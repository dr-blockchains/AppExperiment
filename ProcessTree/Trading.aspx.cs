using System;
using System.Data.SqlClient;
using System.Configuration;
using System.Globalization;

namespace ProcessTree
{
    public partial class Trading : System.Web.UI.Page
    {   
        protected void Page_Load(object sender, EventArgs e)
        {
            Page.MaintainScrollPositionOnPostBack = true;

            if (Session["User"] == null || Session["Valuation"] == null)
                Response.Redirect("~/Default.aspx");

            if (Session["Treat"] == null || Session["Group"] == null || Session["Period"] == null || Session["Choice"] == null || (string)Session["Choice"] == "" || Session["DT"] == null || (short)Session["Valuation"] != 10)
                Response.Redirect("~/Voting.aspx");            

            int Period = Global.Refresh((int)Session["Treat"], (int)Session["Group"], out DateTime DT);

            if (Period == 0 || Period == -9)
            {
                Version.Text = "Your experiment has not started yet.";
                Global.EmailAdmin("Error 124: Suggestion", "UserID = " + Session["User"] + " & Treatment = " + Session["Treat"] + " & Group = " + Session["Group"]);
                Response.Redirect("~/Default.aspx");
            }
            if (Period < -10)
            {
                Version.Text = "Your experiment has ended.";
                ClientScript.RegisterStartupScript(GetType(), "Attention", "alert('Your experiment has ended.');", true);
                Session["User"] = null;                
                return;
            }
            if (Period == -1 || Period == -2)
            {                      
                Response.Redirect("~/Survey.aspx");
                // Session["Notification"] = "The process has finished. \\n Please complete the final survey!";                          
            }
            else if (Period % 2 == 1)
            {
                Response.Redirect("~/Suggestion.aspx");
                // Session["Notification"] = "The selection period has finished. \\n Please make a suggestion.";
            }
            else if ((int)Session["Period"] > Period)
            {                
                Global.EmailAdmin("Error 85: Trading", "UserID = " + Session["User"] + " & Treatment = " + Session["Treat"] + " & Group = " + Session["Group"]);             
                Response.Redirect("~/Voting.aspx");
            }
            else if ((int)Session["Period"] < Period)
            {
                Version.Text = "The market for this choice is closed.";                
                Response.Redirect("~/Voting.aspx");
            }

            TimeSpan.Text = ((DateTime)Session["DT"] - DateTime.Now).TotalMilliseconds.ToString();

            if (IsPostBack) return;

            PeriodChoice.Text = "Shares of the mutual fund ASSUMING it " + " <i>" +
    (Session["Choice"].ToString() == "0" ? "holds cash" : "invests on Portfolio " + Session["Choice"].ToString()) +
    "</i> in month " + ((int)Session["Period"] / 2).ToString();

            SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["ProcessTreeConnectionString"].ConnectionString);
            conn.Open();

            string query = "select * from People where ID = @User";
            SqlCommand com = new SqlCommand(query, conn);
            com.Parameters.AddWithValue("@User", Session["User"]);
            SqlDataReader User = com.ExecuteReader();

            if (!User.Read() ||
                User["QualificationTime"].Equals(DBNull.Value) ||
                User["Treatment"].Equals(DBNull.Value) ||
                User["Group#"].Equals(DBNull.Value) ||
                !User["Completed"].Equals(DBNull.Value))
            {
                conn.Close();
                Response.Redirect("~/Default.aspx");
                return;
            }

            float balance = (float)User["Balance"];
            if (Session["V"]==null)
                Message.Text = User["Name"] + ", place an order with a reasonable price!";
            else
                Message.Text = "You placed an order " + User["Name"] + "!";

            User.Close();

            // Version Content
            query = "select * from Versions where Treatment = " + Session["Treat"] + " and Group# = " + Session["Group"] + " and [Period] = " + Period + " and Choice = " + Session["Choice"];
            com = new SqlCommand(query, conn);
            SqlDataReader VersionData = com.ExecuteReader();

            if (!VersionData.Read())
            {
                Version.Text = "Please use another browser!";
                Global.EmailAdmin("Error 98: Trading", "UserID = " + Session["User"] + " & Period = " + Session["Period"] + " & Choice = " + Session["Choice"]);
                conn.Close();
                return;
            }
                      
            Version.Text = VersionData["Artifact"].ToString().Trim().Replace("\r", "").Replace("\n", "<br>");
            float price = (float)VersionData["Score"];
            LastPrice.Text = (price==0 ? "No transaction for this choice so far": "The last transaction price = $" + price.ToString("N2"));

            VersionData.Close();

            // Shares for this choice:
            query = "SELECT Volume, BalanceConfirm, BalanceVoid FROM Shares WHERE [Owner] = @User AND Treatment = @Treat AND [Group#] = @Group AND [Period] = @Period AND Choice = @Choice";
            com = new SqlCommand(query, conn);
            com.Parameters.AddWithValue("@User", Session["User"]);
            com.Parameters.AddWithValue("@Treat", Session["Treat"]);
            com.Parameters.AddWithValue("@Group", Session["Group"]);
            com.Parameters.AddWithValue("@Period", Period);
            com.Parameters.AddWithValue("@Choice", Session["Choice"]);
            SqlDataReader Share = com.ExecuteReader();

            if (Share.Read())
            {
                Session["Shares"] = Share["Volume"];
                balance += (float)Share["BalanceConfirm"];
                BalanceVoid.Text = ((float)Share["BalanceVoid"]).ToString("N2");
            }
            else
            {
                Session["Shares"] = 0.0f;
            }

            Share.Close();

            // Balances of other choices if they void:
            float VoidBalances = 0.0f;
            query = "SELECT COALESCE(SUM(BalanceVoid), 0) FROM Shares WHERE [Owner] = @User AND Treatment = @Treat AND [Group#] = @Group AND [Period] = @Period AND Choice != @Choice ";
            com = new SqlCommand(query, conn);
            com.Parameters.AddWithValue("@User", Session["User"]);
            com.Parameters.AddWithValue("@Treat", Session["Treat"]);
            com.Parameters.AddWithValue("@Group", Session["Group"]);
            com.Parameters.AddWithValue("@Period", Period);
            com.Parameters.AddWithValue("@Choice", Session["Choice"]);

            object obj = com.ExecuteScalar();
            if (obj != DBNull.Value) VoidBalances = (float)(double)obj;
            BalanceWin.Text = (balance + VoidBalances).ToString("N2");
            
            // Amount of shares locked due to sell offers on this choice:
            query = "SELECT SUM(UnFullfilled) FROM Offers WHERE (Bidder = @Bidder) AND (Treatment = @Treat) AND ([Group#] = @Group) AND (Period = @Period) AND (Choice = @Choice) AND Buy0Sell1 = 1";
            com = new SqlCommand(query, conn);
            com.Parameters.AddWithValue("@Bidder", Session["User"]);
            com.Parameters.AddWithValue("@Treat", Session["Treat"]);
            com.Parameters.AddWithValue("@Group", Session["Group"]);
            com.Parameters.AddWithValue("@Period", Session["Period"]);
            com.Parameters.AddWithValue("@Choice", Session["Choice"]);

            obj = com.ExecuteScalar();
            if (obj != DBNull.Value)
                Session["Shares"] = (float)Session["Shares"] - (float) (double) obj;

            Shares.Text = ((float)Session["Shares"]).ToString("N3");

            float OffersBalance;

            // Balance locked due to buy offers on this choice:
            query = "SELECT SUM(UnFullfilled * Price) FROM Offers WHERE (Bidder = @Bidder) AND (Treatment = @Treatment) AND ([Group#] = @Group) AND (Period = @Period) AND (Choice = @Choice) AND Buy0Sell1 = 0";
            com = new SqlCommand(query, conn);
            com.Parameters.AddWithValue("@Bidder", Session["User"]);
            com.Parameters.AddWithValue("@Treatment", Session["Treat"]);
            com.Parameters.AddWithValue("@Group", Session["Group"]);
            com.Parameters.AddWithValue("@Period", Session["Period"]);
            com.Parameters.AddWithValue("@Choice", Session["Choice"]);

            obj = com.ExecuteScalar();
            if (obj != DBNull.Value)
            {
                OffersBalance = (float)(double)obj;
                Offers.Text = OffersBalance.ToString("N2");
                balance -= OffersBalance;
            }

            // Balance locked due to buy offers on other choices:
            query = @"SELECT COALESCE(SUM(CASE WHEN NETB> 0 THEN NETB ELSE 0 END), 0)
                      FROM (SELECT Choice, SUM(Price * UnFullfilled) - COALESCE((
                                           SELECT BalanceConfirm FROM Shares
                                           WHERE (Owner = @Bidder) AND(Treatment = @Treatment) AND([Group#] = @Group) AND (Period = @Period) AND (Choice = Offers.Choice)) , 0)
                                           AS NETB
                            FROM Offers
                            WHERE (Bidder = @Bidder) AND(Treatment = @Treatment) AND([Group#] = @Group) AND (Period = @Period) AND (Buy0Sell1 = 0) AND (Choice != @Choice)
                            GROUP BY Choice) AS Table1";

            com = new SqlCommand(query, conn);
            com.Parameters.AddWithValue("@Bidder", Session["User"]);
            com.Parameters.AddWithValue("@Treatment", Session["Treat"]);
            com.Parameters.AddWithValue("@Group", Session["Group"]);
            com.Parameters.AddWithValue("@Period", Session["Period"]);
            com.Parameters.AddWithValue("@Choice", Session["Choice"]);

            obj = com.ExecuteScalar();
            if (obj != DBNull.Value)
            {
                OffersBalance = (float)(double)obj;
                OtherOffers.Text = OffersBalance.ToString("N2");
                balance -= OffersBalance;
            }
            
            Balance.Text = balance.ToString("N2");
            Session["Balance"] = balance;

            conn.Close();
            //query = "SELECT Price FROM Transactions WHERE (Treatment = @Treatment) AND ([Group#] = @Group) AND (Period = @Period) AND (Choice = @Choice OR Choice = 0 AND Vol = 0) ORDER BY TranID DESC";
            //com = new SqlCommand(query, conn);
            //com.Parameters.AddWithValue("@Bidder", Session["User"]);
            //com.Parameters.AddWithValue("@Treatment", Session["Treat"]);
            //com.Parameters.AddWithValue("@Group", Session["Group"]);
            //com.Parameters.AddWithValue("@Period", Session["Period"]);
            //com.Parameters.AddWithValue("@Choice", Session["Choice"]);

            //LastPrice.Text = "$" + ((float)(com.ExecuteScalar() ?? "No Transaction on this choice so far.)).ToString("N2");

            if (Session["BuySell"] == null || Session["BuySell"].Equals("Sell"))
            {
                Session["BuySell"] = "Sell";
                Than.Text = ">";
                RadioOrder.SelectedValue = "Sell";
                PlaceOrder.Text = "Place Sell Order";
                PlaceOrder.BackColor = System.Drawing.Color.FromArgb(0xff, 0xaa, 0xaa);
                Price.BackColor = System.Drawing.Color.FromArgb(0xff, 0xaa, 0xaa);
                TotalVol.BackColor = System.Drawing.Color.FromArgb(0xff, 0xaa, 0xaa);
                AutoFill.BackColor = System.Drawing.Color.FromArgb(0xff, 0xaa, 0xaa);
                //PeriodChoice.Focus();
            }
            else //if(Session["BuySell"].Equals("Buy"))
            {                
                Than.Text = "<";
                RadioOrder.SelectedValue = "Buy";
                PlaceOrder.Text = "Place Buy Order";
                PlaceOrder.BackColor = System.Drawing.Color.FromArgb(0x66, 0xff, 0x66);
                Price.BackColor = System.Drawing.Color.FromArgb(0x66, 0xff, 0x66);
                TotalVol.BackColor = System.Drawing.Color.FromArgb(0x66, 0xff, 0x66);
                AutoFill.BackColor = System.Drawing.Color.FromArgb(0x66, 0xff, 0x66);
                //ClientScript.RegisterStartupScript(GetType(), "ScrollDown", "window.scrollTo(0, document.body.clientHeight);", true);
            }
            //else
            //{
            //    Than.Text = ">";
            //    RadioOrder.SelectedValue = "Sell";
            //    PlaceOrder.Text = "Place Sell Order";
            //    PlaceOrder.BackColor = System.Drawing.Color.FromArgb(0xff, 0xaa, 0xaa);
            //    Price.BackColor = System.Drawing.Color.FromArgb(0xff, 0xaa, 0xaa);
            //    TotalVol.BackColor = System.Drawing.Color.FromArgb(0xff, 0xaa, 0xaa);
            //    AutoFill.BackColor = System.Drawing.Color.FromArgb(0xff, 0xaa, 0xaa);
            //    //ClientScript.RegisterStartupScript(GetType(), "ScrollDown", "window.scrollTo(0, document.body.clientHeight);", true);
            //}
            SqlDataSource1.SelectParameters.Clear();
            SqlDataSource1.SelectParameters.Add("Treatment", Session["Treat"].ToString());
            SqlDataSource1.SelectParameters.Add("Group", Session["Group"].ToString());
            SqlDataSource1.SelectParameters.Add("Period", Period.ToString());
            SqlDataSource1.SelectParameters.Add("Choice", Session["Choice"].ToString());

            SqlDataSource4.SelectParameters.Clear();
            SqlDataSource4.SelectParameters.Add("Treatment", Session["Treat"].ToString());
            SqlDataSource4.SelectParameters.Add("Group", Session["Group"].ToString());
            SqlDataSource4.SelectParameters.Add("Period", Period.ToString());
            SqlDataSource4.SelectParameters.Add("Choice", Session["Choice"].ToString());
            SqlDataSource4.SelectParameters.Add("Bidder", Session["User"].ToString());

            SqlDataSource5.SelectParameters.Clear();
            SqlDataSource5.SelectParameters.Add("Treatment", Session["Treat"].ToString());
            SqlDataSource5.SelectParameters.Add("Group", Session["Group"].ToString());
            SqlDataSource5.SelectParameters.Add("Period", Period.ToString());
            SqlDataSource5.SelectParameters.Add("Choice", Session["Choice"].ToString());

            SqlDataSource6.SelectParameters.Clear();
            SqlDataSource6.SelectParameters.Add("Treatment", Session["Treat"].ToString());
            SqlDataSource6.SelectParameters.Add("Group", Session["Group"].ToString());
            SqlDataSource6.SelectParameters.Add("Period", Period.ToString());
            SqlDataSource6.SelectParameters.Add("Choice", Session["Choice"].ToString());

            SqlDataSource1.DataBind();
            SqlDataSource4.DataBind();
            SqlDataSource5.DataBind();
            SqlDataSource6.DataBind();
        }

        protected void Delete_Click(object sender, EventArgs e)
        {
            if (Session["User"] == null)
                Response.Redirect("~/Default.aspx");

            Session["V"] = null;

            if (SelfOrders.SelectedValue == "")
            {
                Message.Text = "Please select one order to delete!";
                return;
            }

            SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["ProcessTreeConnectionString"].ConnectionString);
            conn.Open();            
            string query = "UPDATE Offers SET TotalVol = TotalVol - UnFullfilled , UnFullfilled = 0 WHERE (Treatment = @Treatment) AND ([Group#] = @Group) AND (Period = @Period) AND (Choice = @Choice) AND (Bidder = @Bidder) AND DATEDIFF(second,Time, @Time)=0";
            SqlCommand com = new SqlCommand(query, conn);

            com.Parameters.AddWithValue("@Treatment", Session["Treat"]);
            com.Parameters.AddWithValue("@Group", Session["Group"]);
            com.Parameters.AddWithValue("@Period", Session["Period"]);
            com.Parameters.AddWithValue("@Choice", Session["Choice"]);         
            com.Parameters.AddWithValue("@Bidder", Session["User"]);
            com.Parameters.AddWithValue("@Time", SelfOrders.SelectedValue);

            if (com.ExecuteNonQuery() < 0)
            {
                Message.Text = "This order is fullfilled or does not exist anymore!";
                Global.EmailAdmin("Error 313: Trading","UserID =" + Session["User"]);
                conn.Close();
                return;
            }
            
            conn.Close();
            Session["BuySell"] = RadioOrder.SelectedValue;
            Response.Redirect("~/Trading.aspx");
        } 

        protected void BtnReturn_Click(object sender, EventArgs e)
        {
            //Session["BuySell"] = null;
            Response.Redirect("~/Voting.aspx");
        }

        protected void BtnRefresh_Click(object sender, EventArgs e)
        {
            //Session["BuySell"] = RadioOrder.SelectedValue;
            Response.Redirect("~/Trading.aspx");
            Session["V"] = null;
        }

        protected void RadioOrder_SelectedIndexChanged(object sender, EventArgs e)
        {
            if(RadioOrder.SelectedValue == "Buy")
            {
                PlaceOrder.Text = "Place Buy Order";
                Than.Text = "<";
                PlaceOrder.BackColor = System.Drawing.Color.FromArgb(0x66,0xff,0x66);
                Price.BackColor = System.Drawing.Color.FromArgb(0x66, 0xff, 0x66);
                TotalVol.BackColor = System.Drawing.Color.FromArgb(0x66, 0xff, 0x66);
                AutoFill.BackColor = System.Drawing.Color.FromArgb(0x66, 0xff, 0x66);
            }
            else
            {
                PlaceOrder.Text = "Place Sell Order";
                Than.Text = ">";
                PlaceOrder.BackColor = System.Drawing.Color.FromArgb(0xff, 0xaa, 0xaa);
                Price.BackColor = System.Drawing.Color.FromArgb(0xff, 0xaa, 0xaa);
                TotalVol.BackColor = System.Drawing.Color.FromArgb(0xff, 0xaa, 0xaa);
                AutoFill.BackColor = System.Drawing.Color.FromArgb(0xff, 0xaa, 0xaa);
            }

            Price.Focus();
            Session["BuySell"] = RadioOrder.SelectedValue;
            Session["V"] = null;
        }

        protected void PlaceOrder_Click(object sender, EventArgs e)
        {
            float P, V; // Price , Unfullfilled

            try
            {
                P = float.Parse(Price.Text, CultureInfo.InvariantCulture.NumberFormat);                
            }
            catch
            {
                Price.Focus();
                Message.Text = "Your price is not in proper format!";
                return;
            }

            try
            {
                V = float.Parse(this.TotalVol.Text, CultureInfo.InvariantCulture.NumberFormat);                
            }
            catch
            {
                this.TotalVol.Focus();
                Message.Text = "Number of shares is not in proper format!";
                return;
            }

            Price.Text += "*";
            this.TotalVol.Text += "*";

            if (P <= 0 || P > 100)
            {
                Price.Focus();
                Message.Text = "Your offered price is out of range!";
                return;
            }

            if (V <= 0 || V > 10000)
            {
                this.TotalVol.Focus();
                Message.Text = "Number of shares is out of range!";
                return;
            }

            if (RadioOrder.SelectedValue == "Buy")
            {
                if (P * V > (float)Session["Balance"])
                {
                    ClientScript.RegisterStartupScript(GetType(), "Insufficient Balance", "alert('You need $" + (P * V).ToString("N2") + " of available balance for this order.');", true);               
                    this.TotalVol.Text = (Math.Floor((float)base.Session["Balance"] * 1000 / P) / 1000).ToString();
                    Message.Text = "Try to buy " + this.TotalVol.Text + " shares!";
                    this.TotalVol.Focus();
                    return;
                }
                Session["Balance"] = (float)Session["Balance"] - P * V;
            }
            else
            {
                if (V > (float)Session["Shares"])
                {
                    ClientScript.RegisterStartupScript(GetType(), "Insufficient Shares", "alert('You do not have " + V + " shares for this choice.');", true);
                    this.TotalVol.Text = (Math.Floor((float)base.Session["Shares"]*1000)/1000).ToString();
                    Message.Text = "Try to sell " + this.TotalVol.Text + " shares!";
                    this.TotalVol.Focus();
                    return;
                }

                Session["Shares"] = (float)Session["Shares"] - V;
            }


            Session["Time"] = DateTime.Now;

            SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["ProcessTreeConnectionString"].ConnectionString);            
            conn.Open();

            string query = "INSERT INTO Offers VALUES (@Treatment, @Group, @Period, @Choice, @Bidder, @Time, @Price, @TotalVol, @TotalVol, @Buy0Sell1)";
            SqlCommand com = new SqlCommand(query, conn);

            com.Parameters.AddWithValue("@Treatment", Session["Treat"]);
            com.Parameters.AddWithValue("@Group", Session["Group"]);
            com.Parameters.AddWithValue("@Period", Session["Period"]);
            com.Parameters.AddWithValue("@Choice", Session["Choice"]);
            com.Parameters.AddWithValue("@Bidder", Session["User"]);
            com.Parameters.AddWithValue("@Time", Session["Time"]);
            com.Parameters.AddWithValue("@Price", P);
            com.Parameters.AddWithValue("@TotalVol", V);
            com.Parameters.AddWithValue("@Buy0Sell1", RadioOrder.SelectedIndex);

            if (com.ExecuteNonQuery() != 1)
            {
                Message.Text = "Could not place the order. Try again!";
                Global.EmailAdmin("Error 250: Trading", "UserID =" + Session["User"] + " & Choice = " + Session["Choice"]);
                conn.Close();
                return;
            }

            //  Match offer to the unfullfilled counteroffers 
            query = "SELECT * FROM Offers WHERE (Treatment = @Treatment) AND ([Group#] = @Group) AND (Period = @Period) AND (Choice = @Choice) AND (UnFullfilled > 0) AND " +
            (RadioOrder.SelectedValue == "Buy" ?
                " Buy0Sell1 = 1 AND Price <= " + P + " ORDER BY Price" :
                " Buy0Sell1 = 0 AND Price >= " + P + " ORDER BY Price DESC") + " , Time";

            com = new SqlCommand(query, conn);
            com.Parameters.AddWithValue("@Treatment", Session["Treat"]);
            com.Parameters.AddWithValue("@Group", Session["Group"]);
            com.Parameters.AddWithValue("@Period", Session["Period"]);
            com.Parameters.AddWithValue("@Choice", Session["Choice"]);

            SqlDataReader Offers = com.ExecuteReader();
            
            SqlConnection conn2 = new SqlConnection(ConfigurationManager.ConnectionStrings["ProcessTreeConnectionString"].ConnectionString);
            conn2.Open();
            SqlCommand com2;
            query = "EXEC Transact @Treatment, @Group, @Period, @Choice, @Seller, @Sell_Time, @Buyer, @Buy_Time, @Price, @Vol";

            float Pi = 0.0f, Vi, Vol;

            while (Offers.Read() && V > 0)
            {
                Vi = (float)Offers["Unfullfilled"];
                Pi = (float)Offers["Price"];

                Vol = Math.Min(V, Vi);
                V -= Vol;

                com2 = new SqlCommand(query, conn2);
                com2.Parameters.AddWithValue("@Treatment", Session["Treat"]);
                com2.Parameters.AddWithValue("@Group", Session["Group"]);
                com2.Parameters.AddWithValue("@Period", Session["Period"]);
                com2.Parameters.AddWithValue("@Choice", Session["Choice"]);
                com2.Parameters.AddWithValue("@Price", Pi);
                com2.Parameters.AddWithValue("@Vol", Vol);

                if (RadioOrder.SelectedValue == "Buy")
                {
                    com2.Parameters.AddWithValue("@Seller", Offers["Bidder"]);
                    com2.Parameters.AddWithValue("@Sell_Time", Offers["Time"]);
                    com2.Parameters.AddWithValue("@Buyer", Session["User"]);
                    com2.Parameters.AddWithValue("@Buy_Time", Session["Time"]);
                }
                else
                {
                    com2.Parameters.AddWithValue("@Seller", Session["User"]);
                    com2.Parameters.AddWithValue("@Sell_Time", Session["Time"]);
                    com2.Parameters.AddWithValue("@Buyer", Offers["Bidder"]);
                    com2.Parameters.AddWithValue("@Buy_Time", Offers["Time"]);
                }

                if (com2.ExecuteNonQuery() < 4)
                {                    
                    Global.EmailAdmin("Error 332: Trading", "Number of rows = " + com2.ExecuteNonQuery()  + " & UserID =" + Session["User"] + " & Period =" + Session["Period"] + "  & Choice =" + Session["Choice"] + " & RadioOrder.SelectedValue =" + RadioOrder.SelectedValue + " & Time = " + DateTime.Now
                        + " & Offers.Bidder = " + Offers["Bidder"] + " & Offers.Time = " + Offers["Time"] + " & Offers.Price = " + Pi + " & Offers.TotalVol = " + Offers["TotalVol"]+ " & Offers.Unfullfilled = " + Vi + " & V = " + V + " & Vol = " + Vol);

                    V += Vol;
                }
            }

            Offers.Close();
            conn2.Close();

            if (Pi > 0)
            {                
                query = "UPDATE Versions SET Score = @Score WHERE (Treatment = @Treatment) AND ([Group#] = @Group) AND (Period = @Period) AND (Choice = @Choice)";
                com = new SqlCommand(query, conn);

                com.Parameters.AddWithValue("@Treatment", Session["Treat"]);
                com.Parameters.AddWithValue("@Group", Session["Group"]);
                com.Parameters.AddWithValue("@Period", Session["Period"]);
                com.Parameters.AddWithValue("@Choice", Session["Choice"]);
                com.Parameters.AddWithValue("@Score", Pi);

                if (com.ExecuteNonQuery() != 1)
                {             
                    Global.EmailAdmin("Error 538: Trading", "UserID =" + Session["User"]);
                    conn.Close();
                    return;
                }
            }

            conn.Close();
            Session["V"] = V;            
            Response.Redirect("~/Trading.aspx");
        }

        protected void AutoFill_Click(object sender, EventArgs e)
        {
            if (Session["User"] == null)
                Response.Redirect("~/Default.aspx");

            Session["V"] = null;

            float P, V; // Price , Unfullfilled

            try
            {
                P = float.Parse(Price.Text, CultureInfo.InvariantCulture.NumberFormat);
            }
            catch
            {
                P = 0;                
            }

            try
            {
                V = float.Parse(TotalVol.Text, CultureInfo.InvariantCulture.NumberFormat);
            }
            catch
            {
                V = 0;                
            }

            if (P <= 0 || P > 100)
            {
                SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["ProcessTreeConnectionString"].ConnectionString);
                conn.Open();

                string query = "SELECT Price FROM Offers WHERE (Treatment = @Treatment) AND ([Group#] = @Group) AND (Period = @Period) AND (Choice = @Choice) AND (UnFullfilled > 0) AND " +
                (RadioOrder.SelectedValue == "Buy" ? " Buy0Sell1 = 1 ORDER BY Price" : " Buy0Sell1 = 0 ORDER BY Price DESC");

                SqlCommand com = new SqlCommand(query, conn);

                com.Parameters.AddWithValue("@Treatment", Session["Treat"]);
                com.Parameters.AddWithValue("@Group", Session["Group"]);
                com.Parameters.AddWithValue("@Period", Session["Period"]);
                com.Parameters.AddWithValue("@Choice", Session["Choice"]);

                P = (float)(com.ExecuteScalar() ?? 0.15f);
                Price.Text = P.ToString();

                conn.Close();
            }

            if (V <= 0 || V > 10000)
            {
                TotalVol.Text = (RadioOrder.SelectedValue == "Buy" ?
                    Math.Floor((float)Session["Balance"] * 1000 / P ) / 1000:
                    Math.Floor((float)Session["Shares"] * 1000) / 1000
                    ).ToString();
            }
        }
    }
}