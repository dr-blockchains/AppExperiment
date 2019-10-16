using System;
using System.Data.SqlClient;
using System.Configuration;
using System.Globalization;

namespace ProcessTree
{
    public partial class Bonding : System.Web.UI.Page
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
                Response.Redirect("~/Voting.aspx");
                Version.Text = "The market for this choice is closed.";                
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

            Session["Balance"] = User["Balance"];

            if (Session["V"]==null)
                Message.Text = User["Name"] + ", buy or sell considering the price!";
            else
                Message.Text = "You made a transaction " + User["Name"] + "!";

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
            float shares1 = (float)VersionData["Score"];
            StartShares.Text = shares1.ToString("N3");

            // The bonding curve function:
            float price1 = shares1/100;
            StartPrice.Text = (price1==0 ? "0 (It will rise as you buy shares)": "$" + price1.ToString("C"));

            VersionData.Close();

            // Person's shares for this choice:
            query = "SELECT Volume, BalanceConfirm, BalanceVoid FROM Shares WHERE [Owner] = @User AND Treatment = @Treat AND [Group#] = @Group AND [Period] = @Period AND Choice = @Choice";
            com = new SqlCommand(query, conn);
            com.Parameters.AddWithValue("@User", Session["User"]);
            com.Parameters.AddWithValue("@Treat", Session["Treat"]);
            com.Parameters.AddWithValue("@Group", Session["Group"]);
            com.Parameters.AddWithValue("@Period", Period);
            com.Parameters.AddWithValue("@Choice", Session["Choice"]);
            SqlDataReader SharePerson = com.ExecuteReader();

            if (SharePerson.Read())
            {
                Session["AvShare"] = SharePerson["Volume"];
                Session["AvFund"] = (float)Session["AvFund"] + (float)SharePerson["BalanceConfirm"];
                BalanceVoid.Text = ((float)SharePerson["BalanceVoid"]).ToString("C");
            }
            else
            {
                Session["AvShare"] = 0.0f;
                BalanceVoid.Text = "0";
            }
                        
            SharePerson.Close();

            AvShare.Text = ((float)Session["AvShare"]).ToString("N3");
            AvFund.Text = ((float)Session["AvFund"]).ToString("C");

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
            BalanceWin.Text = ((float)Session["AvFund"] + VoidBalances).ToString("C");
            
            conn.Close();

            if (Session["BuySell"] == null || Session["BuySell"].Equals("Sell"))
            {                                
                RadioOrder.SelectedValue = "Sell";
                Session["BuySell"] = "Sell";
                BuySell.Text = "Sell";

                PlaceOrder.Text = "Place Sell Order";
                PlaceOrder.BackColor = System.Drawing.Color.FromArgb(0xff, 0xaa, 0xaa);
                AutoFill.BackColor = System.Drawing.Color.FromArgb(0xff, 0xaa, 0xaa);

                DeltaShares.BackColor = System.Drawing.Color.FromArgb(0xff, 0xaa, 0xaa);
                DeltaFund.BackColor =System.Drawing.Color.FromArgb(0xff, 0xaa, 0xaa);
                AveragePrice.BackColor =System.Drawing.Color.FromArgb(0xff, 0xaa, 0xaa);
                EndPrice.BackColor=System.Drawing.Color.FromArgb(0xff, 0xaa, 0xaa);
                //PeriodChoice.Focus();
            }
            else //if(Session["BuySell"].Equals("Buy"))
            {      
                RadioOrder.SelectedValue = "Buy";
                Session["BuySell"] = "Buy";
                BuySell.Text = "Buy";
                
                PlaceOrder.Text = "Place Buy Order";
                PlaceOrder.BackColor = System.Drawing.Color.FromArgb(0x66, 0xff, 0x66);
                AutoFill.BackColor = System.Drawing.Color.FromArgb(0x66, 0xff, 0x66);

                DeltaShares.BackColor = System.Drawing.Color.FromArgb(0x66, 0xff, 0x66);
                DeltaFund.BackColor =System.Drawing.Color.FromArgb(0x66, 0xff, 0x66);
                AveragePrice.BackColor =System.Drawing.Color.FromArgb(0x66, 0xff, 0x66);
                EndPrice.BackColor=System.Drawing.Color.FromArgb(0x66, 0xff, 0x66);

                //ClientScript.RegisterStartupScript(GetType(), "ScrollDown", "window.scrollTo(0, document.body.clientHeight);", true);
            }
       
            SqlDataSource1.SelectParameters.Clear();
            SqlDataSource1.SelectParameters.Add("Treatment", Session["Treat"].ToString());
            SqlDataSource1.SelectParameters.Add("Group", Session["Group"].ToString());
            SqlDataSource1.SelectParameters.Add("Period", Period.ToString());
            SqlDataSource1.SelectParameters.Add("Choice", Session["Choice"].ToString());
            SqlDataSource1.DataBind();
        }

        protected void BtnReturn_Click(object sender, EventArgs e)
        {
            //Session["BuySell"] = null;
            Response.Redirect("~/Voting.aspx");
        }

        protected void BtnRefresh_Click(object sender, EventArgs e)
        {
            //Session["BuySell"] = RadioOrder.SelectedValue;
            Response.Redirect("~/Bonding.aspx");
            Session["V"] = null;
        }

        protected void RadioOrder_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (RadioOrder.SelectedValue == "Sell")
            {
                PlaceOrder.Text = "Place Sell Order";
                PlaceOrder.BackColor = System.Drawing.Color.FromArgb(0xff, 0xaa, 0xaa);
                AutoFill.BackColor = System.Drawing.Color.FromArgb(0xff, 0xaa, 0xaa);

                DeltaShares.BackColor = System.Drawing.Color.FromArgb(0xff, 0xaa, 0xaa);
                DeltaFund.BackColor = System.Drawing.Color.FromArgb(0xff, 0xaa, 0xaa);
                AveragePrice.BackColor = System.Drawing.Color.FromArgb(0xff, 0xaa, 0xaa);
                EndPrice.BackColor = System.Drawing.Color.FromArgb(0xff, 0xaa, 0xaa);
            }
            else
            {
                RadioOrder.SelectedValue = "Buy";

                PlaceOrder.Text = "Place Buy Order";
                PlaceOrder.BackColor = System.Drawing.Color.FromArgb(0x66, 0xff, 0x66);
                AutoFill.BackColor = System.Drawing.Color.FromArgb(0x66, 0xff, 0x66);

                DeltaShares.BackColor = System.Drawing.Color.FromArgb(0x66, 0xff, 0x66);
                DeltaFund.BackColor = System.Drawing.Color.FromArgb(0x66, 0xff, 0x66);
                AveragePrice.BackColor = System.Drawing.Color.FromArgb(0x66, 0xff, 0x66);
                EndPrice.BackColor = System.Drawing.Color.FromArgb(0x66, 0xff, 0x66);
            }

            DeltaFund.Focus();
            Session["BuySell"] = RadioOrder.SelectedValue;
            BuySell.Text = RadioOrder.SelectedValue;
            Session["V"] = null;
        }

        protected void PlaceOrder_Click(object sender, EventArgs e)
        {
            float P, V; // Price , Unfullfilled

            try
            {
                V = float.Parse(DeltaShares.Text, CultureInfo.InvariantCulture.NumberFormat);
            }
            catch
            {
                DeltaShares.Focus();
                Message.Text = "Number of shares is not in proper format!";
                return;
            }

            try
            {
                P = float.Parse(DeltaFund.Text, CultureInfo.InvariantCulture.NumberFormat);                
            }
            catch
            {
                DeltaFund.Focus();
                Message.Text = "Your price is not in proper format!";
                return;
            }

            Price.Text += "*";
            TotalVol.Text += "*";

            if (P <= 0 || P > 100)
            {
                Price.Focus();
                Message.Text = "Your offered price is out of range!";
                return;
            }

            if (V <= 0 || V > 10000)
            {
                TotalVol.Focus();
                Message.Text = "Number of shares is out of range!";
                return;
            }

            if (RadioOrder.SelectedValue == "Buy")
            {
                if (P * V > (float)Session["Balance"])
                {
                    ClientScript.RegisterStartupScript(GetType(), "Insufficient Balance", "alert('You need $" + (P * V).ToString("C") + " of available balance for this order.');", true);               
                    TotalVol.Text = (Math.Floor((float)Session["Balance"] * 1000 / P) / 1000).ToString();
                    Message.Text = "Try to buy " + TotalVol.Text + " shares!";
                    TotalVol.Focus();
                    return;
                }
                Session["Balance"] = (float)Session["Balance"] - P * V;
            }
            else
            {
                if (V > (float)Session["Shares"])
                {
                    ClientScript.RegisterStartupScript(GetType(), "Insufficient Shares", "alert('You do not have " + V + " shares for this choice.');", true);
                    TotalVol.Text = (Math.Floor((float)Session["Shares"]*1000)/1000).ToString();
                    Message.Text = "Try to sell " + TotalVol.Text + " shares!";
                    TotalVol.Focus();
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
            
            query = "EXEC Transact @Treatment, @Group, @Period, @Choice, @Seller, @Sell_Time, @Buyer, @Buy_Time, @Price, @Vol";

            float Pi = 0.0f, Vi, Vol;







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