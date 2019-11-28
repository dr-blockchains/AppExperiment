using System;
using System.Data.SqlClient;
using System.Configuration;
using System.Globalization;
//using WebSocketSharp;

namespace ProcessTree
{
    public partial class Bonding : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            Page.MaintainScrollPositionOnPostBack = true;

            if (Session["User"] == null || Session["Valuation"] == null || Session["Treat"] == null || Session["Group"] == null || Session["Period"] == null || Session["Choice"] == null || (string)Session["Choice"] == "" || Session["DT"] == null || (short)Session["Valuation"] != 12)
                Response.Redirect("~/Default.aspx");

            int Period = Global.Refresh((int)Session["Treat"], (int)Session["Group"], out DateTime DT);

            if (Period == 0 || Period == -9)
            {
                Version.Text = "Your experiment has not started yet.";
                Global.EmailAdmin("Error 23: Bonding", "UserID = " + Session["User"] + " & Treatment = " + Session["Treat"] + " & Group = " + Session["Group"]);
                Response.Redirect("~/Default.aspx");
            }
            if (Period < -10)
            {
                Version.Text = "Your experiment has ended.";
                ClientScript.RegisterStartupScript(GetType(), "Attention", "alert('Your experiment has ended.');", true);
                Session["User"] = null;
                Response.Redirect("~/Default.aspx");
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
                Global.EmailAdmin("Error 46: Bonding", "UserID = " + Session["User"] + " & Treatment = " + Session["Treat"] + " & Group = " + Session["Group"]);             
                Response.Redirect("~/Voting.aspx");
            }
            else if ((int)Session["Period"] < Period)
            {
                Version.Text = "The market for this choice is closed.";
                Response.Redirect("~/Voting.aspx");             
            }

            TimeSpan.Text = ((DateTime)Session["DT"] - DateTime.Now).TotalMilliseconds.ToString();

            if (IsPostBack) return;
            ClientScript.RegisterStartupScript(GetType(), "Attention", "alert('Not Postback');", true);

            PeriodChoice.Text = "Shares of the firm ASSUMING it " + " <i>" +
    (Session["Choice"].ToString() == "0" ? "holds cash" : "invests on Portfolio " + Session["Choice"].ToString()) +
    "</i> in month " + ((int)Session["Period"] / 2).ToString();

            SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["ProcessTreeConnectionString"].ConnectionString);
            conn.Open();

            string query = "select * from People where ID = @User";
            SqlCommand com = new SqlCommand(query, conn);
            com.Parameters.AddWithValue("@User", Session["User"]);
            SqlDataReader User = com.ExecuteReader();

            if (!User.Read()){
                com.Dispose();
                conn.Close();
                Response.Redirect("~/Default.aspx");
                return;
            }

            float avfund = (float) User["Balance"];

            if (Session["MEssage"] == null)
                Message.Text = User["Name"] + ", buy or sell considering the current price!";
            else
                Message.Text = Session["Message"].ToString();

            User.Close();


            // Version Content
            query = "select * from Versions where Treatment = " + Session["Treat"] + " and Group# = " + Session["Group"] + " and [Period] = " + Period + " and Choice = " + Session["Choice"];
            com = new SqlCommand(query, conn);
            SqlDataReader VersionData = com.ExecuteReader();

            if (!VersionData.Read())
            {
                Version.Text = "Error: Please take a screenshot and contact the admin: Law.Economist@Gmail.com!";
                Global.EmailAdmin("Error 98: Bonding", "UserID = " + Session["User"] + " & Period = " + Session["Period"] + " & Choice = " + Session["Choice"]);
                conn.Close();
                return;
            }
                      
            Version.Text = VersionData["Artifact"].ToString().Trim().Replace("\r", "").Replace("\n", "<br>");

            float shares1 = (float)VersionData["Score"];
            StartShares.Text = shares1.ToString("N3");

            com.Dispose();
            VersionData.Close();

            // The bonding curve function:
            //float price1 = shares1/100;
            //StartPrice.Text = (price1==0 ? "0 (It will rise as you buy shares)": price1.ToString("N2"));

            // The function(A and B):
            query = "select * from Groups where Treatment = " + Session["Treat"] + " and Group# = " + Session["Group"];
            com = new SqlCommand(query, conn);
            SqlDataReader GroupData = com.ExecuteReader();
            if (!GroupData.Read())
            {
                Version.Text = "Error: Please take a screenshot and contact the admin: Law.Economist@Gmail.com!";
                Global.EmailAdmin("Error 121: Bonding", "UserID = " + Session["User"] + " & Period = " + Session["Period"] + " & Choice = " + Session["Choice"]);
                conn.Close();
                return;
            }

            Atxt.Text = GroupData["A"].ToString();
            Btxt.Text = GroupData["B"].ToString();

            com.Dispose();
            GroupData.Close();


            // Person's shares for this choice:
            query = "SELECT Volume, BalanceConfirm, BalanceVoid FROM Shares WHERE [Owner] = @User AND Treatment = @Treat AND [Group#] = @Group AND [Period] = @Period AND Choice = @Choice";
            com = new SqlCommand(query, conn);
            com.Parameters.AddWithValue("@User", Session["User"]);
            com.Parameters.AddWithValue("@Treat", Session["Treat"]);
            com.Parameters.AddWithValue("@Group", Session["Group"]);
            com.Parameters.AddWithValue("@Period", Period);
            com.Parameters.AddWithValue("@Choice", Session["Choice"]);
            SqlDataReader SharePerson = com.ExecuteReader();

            float avshare;
            if (SharePerson.Read())
            {
                avshare = (float) SharePerson["Volume"];
                avfund += (float)SharePerson["BalanceConfirm"];
                BalanceVoid.Text = ((float)SharePerson["BalanceVoid"]).ToString("N2");
            }
            else
            {
                avshare = 0.0f;
                BalanceVoid.Text = "0";
            }
                        
            SharePerson.Close();

            AvShare.Text = avshare.ToString("N3");
            AvFund.Text = avfund.ToString("N2");

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
            BalanceWin.Text = (avfund + VoidBalances).ToString("N2");
            
            conn.Close();

            //if (Session["BuySell"] == null || Session["BuySell"].Equals("Sell"))
            //{                                
            //    RadioOrder.SelectedValue = "Sell";
            //    Session["BuySell"] = "Sell";
            //    BuySell.Text = "Sell";
            //    PlaceOrder.Text = "Sell Shares";

            //    //PlaceOrder.BackColor = System.Drawing.Color.FromArgb(0xff, 0xaa, 0xaa);
            //    //AutoFill.BackColor = System.Drawing.Color.FromArgb(0xff, 0xaa, 0xaa);

            //    //DeltaShares.BackColor = System.Drawing.Color.FromArgb(0xff, 0xaa, 0xaa);
            //    //DeltaFund.BackColor =System.Drawing.Color.FromArgb(0xff, 0xaa, 0xaa);
            //    //AveragePrice.BackColor =System.Drawing.Color.FromArgb(0xff, 0xaa, 0xaa);
            //    //EndPrice.BackColor=System.Drawing.Color.FromArgb(0xff, 0xaa, 0xaa);
            //    //PeriodChoice.Focus();
            //}
            //else //if(Session["BuySell"].Equals("Buy"))
            //{      
            //    RadioOrder.SelectedValue = "Buy";
            //    Session["BuySell"] = "Buy";
            //    BuySell.Text = "Buy";                
            //    PlaceOrder.Text = "Buy Shares";

            //    //PlaceOrder.BackColor = System.Drawing.Color.FromArgb(0x66, 0xff, 0x66);
            //    //AutoFill.BackColor = System.Drawing.Color.FromArgb(0x66, 0xff, 0x66);

            //    //DeltaShares.BackColor = System.Drawing.Color.FromArgb(0x66, 0xff, 0x66);
            //    //DeltaFund.BackColor =System.Drawing.Color.FromArgb(0x66, 0xff, 0x66);
            //    //AveragePrice.BackColor =System.Drawing.Color.FromArgb(0x66, 0xff, 0x66);
            //    //EndPrice.BackColor=System.Drawing.Color.FromArgb(0x66, 0xff, 0x66);

            //    //ClientScript.RegisterStartupScript(GetType(), "ScrollDown", "window.scrollTo(0, document.body.clientHeight);", true);
            //}
            SqlDataSource1.SelectParameters.Clear();
            SqlDataSource1.SelectParameters.Add("Treatment", Session["Treat"].ToString());
            SqlDataSource1.SelectParameters.Add("Group", Session["Group"].ToString());
            SqlDataSource1.SelectParameters.Add("Period", Period.ToString());
            SqlDataSource1.SelectParameters.Add("Choice", Session["Choice"].ToString());
            SqlDataSource1.DataBind();
        }

        protected void BtnReturn_Click(object sender, EventArgs e)
        {
            Response.Redirect("~/Voting.aspx");
        }

        //protected void RadioOrder_SelectedIndexChanged(object sender, EventArgs e)
        //{
        //    if (RadioOrder.SelectedValue == "Sell")
        //    {
        //        PlaceOrder.Text = "Place Sell Order";
        //        PlaceOrder.BackColor = System.Drawing.Color.FromArgb(0xff, 0xaa, 0xaa);
        //        //AutoFill.BackColor = System.Drawing.Color.FromArgb(0xff, 0xaa, 0xaa);

        //        DeltaShares.BackColor = System.Drawing.Color.FromArgb(0xff, 0xaa, 0xaa);
        //        DeltaFund.BackColor = System.Drawing.Color.FromArgb(0xff, 0xaa, 0xaa);
        //        AveragePrice.BackColor = System.Drawing.Color.FromArgb(0xff, 0xaa, 0xaa);
        //        EndPrice.BackColor = System.Drawing.Color.FromArgb(0xff, 0xaa, 0xaa);
        //        DeltaShares.Focus();
        //    }
        //    else
        //    {
        //        RadioOrder.SelectedValue = "Buy";

        //        PlaceOrder.Text = "Place Buy Order";
        //        PlaceOrder.BackColor = System.Drawing.Color.FromArgb(0x66, 0xff, 0x66);
        //        //AutoFill.BackColor = System.Drawing.Color.FromArgb(0x66, 0xff, 0x66);

        //        DeltaShares.BackColor = System.Drawing.Color.FromArgb(0x66, 0xff, 0x66);
        //        DeltaFund.BackColor = System.Drawing.Color.FromArgb(0x66, 0xff, 0x66);
        //        AveragePrice.BackColor = System.Drawing.Color.FromArgb(0x66, 0xff, 0x66);
        //        EndPrice.BackColor = System.Drawing.Color.FromArgb(0x66, 0xff, 0x66);
        //        DeltaFund.Focus();
        //    }

        //    Session["BuySell"] = RadioOrder.SelectedValue;
        //    BuySell.Text = RadioOrder.SelectedValue;
        //    Session["Message"] = null;
        //}

        protected void PlaceOrder_Click(object sender, EventArgs e)
        {
            if (Session["User"] == null)
                Response.Redirect("~/Default.aspx");

            Session["Message"] = "Your order did not go through!";

            float A, B, shares1, shares2, dshare, dfund, avfund, avshare;

            try
            {
                shares1 = float.Parse(StartShares.Text, CultureInfo.InvariantCulture.NumberFormat);
                A = float.Parse(Atxt.Text, CultureInfo.InvariantCulture.NumberFormat);
                B = float.Parse(Btxt.Text, CultureInfo.InvariantCulture.NumberFormat);
            }
            catch
            {
                Message.Text = "Please refresh the page!";
                Global.EmailAdmin("Error 255: Bonding", "UserID =" + Session["User"] + " & Choice = " + Session["Choice"] + " & StartShares = " + StartShares.Text);
                return;
            }

            try
            {
                dshare = float.Parse(DeltaShares.Text, CultureInfo.InvariantCulture.NumberFormat);
                if (!(dshare > 0 && dshare < 10000)) throw new Exception();
            }
            catch
            {
                DeltaShares.Focus();
                Message.Text = "Number of shares is out of range!";
                return;
            }

            try
            {
                dfund = float.Parse(DeltaFund.Text, CultureInfo.InvariantCulture.NumberFormat);
                if (!(dfund > 0 && dfund < 1000)) throw new Exception();
            }
            catch
            {
                DeltaFund.Focus();
                Message.Text = "Amount of fund is out of range!";
                return;
            }        

            if (RadioOrder.SelectedValue == "Buy")
            {
                try
                {
                    avfund = float.Parse(AvFund.Text, CultureInfo.InvariantCulture.NumberFormat);
                    if (!(avfund > 0 && avfund < 1000)) throw new Exception();
                }
                catch
                {
                    DeltaFund.Focus();
                    Message.Text = "No available fund!";
                    return;
                }

                if (dfund > avfund)
                {
                    ClientScript.RegisterStartupScript(GetType(), "Insufficient Balance", "alert('You do not have $" + dfund.ToString("N2") + " of available fund. \n The order is fulfilled partially.');", true);
                    dfund = (float) Math.Floor(avfund * 10000) / 10000;
                    DeltaFund.Text = dfund.ToString("N3");
                    Message.Text = "You invested $" + DeltaFund.Text + " !";
                    DeltaFund.Focus();
                }
                
                float p1 = (A * shares1 + B);
                shares2 = (-B + (float)Math.Sqrt(B * B + p1 * p1 + 2 * A * dfund)) / A ;

                dshare = shares2 - shares1;

                //DeltaShares.Text = dshare.ToString("N2");
            }
            else
            {
                try
                {
                    avshare = float.Parse(AvShare.Text, CultureInfo.InvariantCulture.NumberFormat);
                    if (!(avshare > 0 && avshare < 10000)) throw new Exception();
                }
                catch
                {
                    DeltaShares.Focus();
                    Message.Text = "No available share!";
                    return;
                }

                if (dshare > avshare)
                {
                    ClientScript.RegisterStartupScript(GetType(), "Insufficient Shares", "alert('You do not have " + dshare.ToString("N3") + " shares for this choice. \n The order is fulfilled partially.');", true);
                    dshare = (float) Math.Floor(avshare * 10000) / 10000;
                    DeltaShares.Text = dshare.ToString("N2");
                    Message.Text = "You sold " + DeltaShares.Text + " shares!";
                    DeltaShares.Focus();
                }

                //shares2 = shares1 - dshare;
                //dfund = dshare * (shares1 + shares2) / 200.0f;
                //DeltaFund.Text = dfund.ToString("N2");
            }

            SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["ProcessTreeConnectionString"].ConnectionString);
            conn.Open();

            string query = "EXEC Bonding @Treatment, @Group, @Period, @Choice, @Bidder, @Buy0Sell1, @Score, @Dshare";
            SqlCommand com = new SqlCommand(query, conn);

            com.Parameters.AddWithValue("@Treatment", Session["Treat"]);
            com.Parameters.AddWithValue("@Group", Session["Group"]);
            com.Parameters.AddWithValue("@Period", Session["Period"]);
            com.Parameters.AddWithValue("@Choice", Session["Choice"]);
            com.Parameters.AddWithValue("@Bidder", Session["User"]);
            //com.Parameters.AddWithValue("@Time", DateTime.Now);
            com.Parameters.AddWithValue("@Buy0Sell1", RadioOrder.SelectedIndex);
            com.Parameters.AddWithValue("@Score", shares1);
            com.Parameters.AddWithValue("@DShare", dshare);

            if (com.ExecuteNonQuery() < 3)
            {
                Message.Text = "Could not place the order. Try again!";
                Global.EmailAdmin("Error 250: Trading", "UserID =" + Session["User"] + " & Choice = " + Session["Choice"]);
                conn.Close();
                return;
            }

            com.Dispose();
            conn.Close();
            //DeltaFund.Text = "";
            //DeltaShares.Text = "";

            //if (RadioOrder.SelectedValue == "Buy")
            //{
            //    Session["AvFund"] = (float)Session["AvFund"] - dfund;
            //    Session["AvShare"] = (float)Session["AvShare"] + dshare;

            //    AvFund.Text = ((float)Session["AvFund"]).ToString("N2");
            //    AvShare.Text = ((float)Session["AvShare"]).ToString("N3");

            //    Session["Message"] = "You bought " + shares2 + " shares.";
            //}
            //else
            //{
            //    Session["AvFund"] = (float)Session["AvFund"] + dfund;
            //    Session["AvShare"] = (float)Session["AvShare"] - dshare;

            //    AvFund.Text = ((float)Session["AvFund"]).ToString("N2");
            //    AvShare.Text = ((float)Session["AvShare"]).ToString("N3");

            //    Session["Message"] = "You sold " + shares2 + " shares.";
            //}

            //AveragePrice.Text = ((shares1 + shares2) / 200.0).ToString("N2");
            //EndPrice.Text = (shares2 / 100.0).ToString("N2");
            //EndShares.Text = shares2.ToString("N2");
            Session["Message"] = (RadioOrder.SelectedIndex == 0? "You bought " : "You sold ") + dshare + " shares.";

            //push new shares1 +- dshare to the front end of every client.

            Response.Redirect("~/Bonding.aspx");
        }

        protected void BtnRefresh_Click(object sender, EventArgs e)
        {
            Session["Message"] = null;
            Response.Redirect("~/Bonding.aspx");
        }

        //protected void AutoFill_Click(object sender, EventArgs e)
        //{
        //    if (Session["User"] == null)
        //        Response.Redirect("~/Default.aspx");

        //    Session["Message"] = null;

        //    float shares1, shares2, dshare, dfund;

        //    try
        //    {
        //        shares1 = float.Parse(StartShares.Text, CultureInfo.InvariantCulture.NumberFormat);
        //    }
        //    catch
        //    {
        //        Message.Text = "Please refresh the page!";
        //        Global.EmailAdmin("Error 257: Bonding", "UserID =" + Session["User"] + " & Choice = " + Session["Choice"] + " & StartShares = " + StartShares.Text);
        //        return;
        //    }

        //    if (RadioOrder.SelectedValue == "Buy")
        //    {
        //        dfund = (float)Math.Floor((float)Session["AvFund"] * 10000) / 10000;
        //        DeltaFund.Text = dfund.ToString("N2");
        //        Message.Text = "Investing " + DeltaFund.Text + " !";

        //        shares2 = (float)Math.Sqrt(200.0f * dfund + shares1 * shares1);

        //        dshare = shares2 - shares1;
        //        DeltaShares.Text = dshare.ToString("F");
        //    }
        //    else
        //    {
        //        dshare = (float)Math.Floor((float)Session["AvShare"] * 10000) / 10000;
        //        DeltaShares.Text = dshare.ToString("F");
        //        Message.Text = "Selling " + DeltaShares.Text + " shares!";

        //        shares2 = shares1 - dshare;

        //        dfund = dshare * (shares1 + shares2) / 200.0f;
        //        DeltaFund.Text = dfund.ToString("N2");
        //    }

        //    AveragePrice.Text = ((shares1 + shares2) / 200.0).ToString("N2");
        //    EndPrice.Text = (shares2 / 100.0).ToString("N2");
        //    EndShares.Text = shares2.ToString("N2");

        //    PlaceOrder.Focus();
        //}
    }
}