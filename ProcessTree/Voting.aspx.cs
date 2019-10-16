using System;
using System.Data.SqlClient;
using System.Configuration;

namespace ProcessTree
{
    public partial class Voting : System.Web.UI.Page
    {   
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["User"] == null)
                Response.Redirect("~/Default.aspx");

            if (IsPostBack)
            {
                TimeSpan.Text = ((DateTime)Session["DT"] - DateTime.Now).TotalMilliseconds.ToString();
                return;
            }

            int Period = Global.Refresh((int)Session["Treat"], (int)Session["Group"], out DateTime DT);
            if (Period == 0 || Period == -9)
            {   
                Response.Redirect("~/Default.aspx");
                return;
            }
            if (Period < -10)
            {
                LabelLogin.Text = "Your experiment has ended.";
                ClientScript.RegisterStartupScript(GetType(), "Attention", "alert('Your experiment has ended.');", true);
                RadioVersions.Enabled = false;
                ListVersions.Enabled = false;
                ParallelMarket.Enabled = false;
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
            TimeSpan.Text = (DT - DateTime.Now).TotalMilliseconds.ToString();
            Session["DT"] = DT;
                        
            string RoundDate;            
            switch (Period)
            {
                case 2: RoundDate = "January 1st"; break;
                case 4: RoundDate = "February 1st"; break;
                case 6: RoundDate = "March 1st"; break;                
                case 8: RoundDate = "April 1st"; break;
                case 10: RoundDate = "May 1st"; break;
                default:
                    RoundDate = "June 1st";
                    Global.EmailAdmin("Unusual Period in Voting", "Treatment=" + Session["Treat"] + " & Period=" + Period);
                    break;                
            }

            LabelLogin.Text = "Round " + Period / 2 + " : happening on " + RoundDate;

            if (Session["Period"] == null || (int)Session["Period"] < Period)
                ClientScript.RegisterStartupScript(GetType(), "Attention", "notify('Round " + Period / 2 + " (" + RoundDate + ")');", true);

            Session["Period"] = Period;

            SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["ProcessTreeConnectionString"].ConnectionString);
            conn.Open();
            //string query = "select * from People where ID = @User";
            //SqlCommand com = new SqlCommand(query, conn);
            //com.Parameters.AddWithValue("@User", Session["User"]);
            //SqlDataReader User = com.ExecuteReader();

            //if (!User.Read() || User["Rater"].Equals(true) ||
            //    User["QualificationTime"].Equals(DBNull.Value) ||
            //    User["Treatment"].Equals(DBNull.Value) ||
            //    User["Group#"].Equals(DBNull.Value) ||
            //    !User["Completed"].Equals(DBNull.Value))
            //{   
            //    conn.Close();
            //    Response.Redirect("~/Default.aspx");
            //}

            //float UserBalance = (float) User["Balance"];            
            //LabelBalance.Text = "Your Cash Balance =  $ " + UserBalance.ToString("N2");
            //Session["TotalExtra"] = User["ExtraVote"];
            //User.Close();
            string query = "select * from Treatments where TID = " + Session["Treat"];
            SqlCommand com = new SqlCommand(query, conn);
            SqlDataReader Treatment = com.ExecuteReader();

            if (!Treatment.Read() || Treatment["Constitution"].Equals(DBNull.Value))
            {
                ConstitutionBox.Text = "Error (68). Please contact the admin: Law.Economist@Gmail.com";
                Global.EmailAdmin("Error 68: Voting", "UserID = " + Session["User"] + " & Treatment = " + Session["Treat"]);
                conn.Close();
                return;
            }
                  
            ConstitutionBox.Text = Treatment["Constitution"].ToString();
            Session["Valuation"] = Treatment["Valuation"];

            Session["VoteChange"] = Treatment["VoteChange"];
            //Session["W"] = Treatment["W"];
            //Session["BetFee"] = Treatment["BetFee"];

            Treatment.Close();

            // Parallel Markets ---------------------------------------------
            if ((short)Session["Valuation"] == 10)
            {                
                RadioVersions.Visible = false;
                ListVersions.Visible = false;
                ParallelMarket.Visible = true;

                LabelSelect.Text = "Evaluate the following choices and select one to trade:";
                BtnSubmit.Text = "Trade";
                BtnSubmit.Enabled = true;
                SqlDataSource5.SelectParameters.Clear();
                SqlDataSource5.SelectParameters.Add("Treatment", Session["Treat"].ToString());
                SqlDataSource5.SelectParameters.Add("Group", Session["Group"].ToString());
                SqlDataSource5.SelectParameters.Add("Period", Period.ToString());
                SqlDataSource5.DataBind();
                conn.Close();
                return;
            }

            // Voting -----------------------------------------

            ParallelMarket.Visible = false;
            SqlDataSource4.SelectParameters.Clear();
            SqlDataSource4.SelectParameters.Add("Treatment", Session["Treat"].ToString());
            SqlDataSource4.SelectParameters.Add("Group", Session["Group"].ToString());
            SqlDataSource4.SelectParameters.Add("Period", Period.ToString());
            SqlDataSource4.DataBind();            
            
            if (Session["Valuation"].Equals(4) || Session["Valuation"].Equals(5))
            {
                RadioVersions.Visible = false;
                ListVersions.Visible = true;
                LabelSelect.Text = "Evaluate the following choices and select one or multiple of them:";
            }
            else
            {
                RadioVersions.Visible = true;
                ListVersions.Visible = false;
                LabelSelect.Text = "Evaluate the following choices and select one:";
            }
            //if ((int)Session["W"] > 0)
            //{
            //    Session["VoteW"] = Math.Min((int)Session["TotalExtra"], (int)Session["W"]) + 1;
            //    ExtraVotes.Visible = true;
            //    ExtraVotes.Text = "You have <b>" + (int)Session["TotalExtra"] + "</b> Extra Votes. (Available Now: " + (int)Session["VoteW"] + ")";
            //}
            //else
            //{                
            //}
            Session["VoteW"] = 1;
            ExtraVotes.Visible = false;
            //if ((float)Session["BetFee"] > 0)
            //{
            //    LabelLogin.Text = "Voting (betting) fee is $" + (float)Session["BetFee"];
            //    if ((float)Session["BetFee"] > UserBalance)
            //    {
            //        Message.Text = "You do not have enough balance to vote.";
            //        BtnSubmit.Enabled = false;
            //        RadioVersions.Enabled = false;
            //        ListVersions.Enabled = false;                    
            //        ParallelMarket.Enabled = false;
            //    }
            //}                                      
            // Already Voted?                     
            query = "SELECT * FROM Voting WHERE Treatment = " + Session["Treat"] + " and Group# = " + Session["Group"] + " and Period = " + Period + " and Voter = @User";
            com = new SqlCommand(query, conn);
            com.Parameters.AddWithValue("@User", Session["User"]);            
            var Voting = com.ExecuteReader();

            if (Voting.Read())
            {
                if (Session["Valuation"].Equals(4) || Session["Valuation"].Equals(5))
                {
                    Message.Text = "You already voted for the above selection on " + ((DateTime)Voting["Time"]).ToString(Global.DateFormat) + " .";
                    ListVersions.DataBind();

                    ListVersions.Items[(int)Voting["Choice"]].Selected = true;
                    while (Voting.Read())
                        ListVersions.Items[(int)Voting["Choice"]].Selected = true;
                }
                else
                {
                    Message.Text = "You already voted for " +
                        (Voting["Choice"].Equals(0) ? "Holding Cash" : "<i>Portfolio " + Voting["Choice"]) + "</i>  on "
                        + ((DateTime)Voting["Time"]).ToString(Global.DateFormat) + " .";

                    RadioVersions.SelectedValue = Voting["Choice"].ToString();
                }

                BtnSubmit.Enabled = false;
                BtnSubmit.Text = "Thanks!";
                if (!Session["VoteChange"].Equals(true))
                {
                    RadioVersions.Enabled = false;
                    ListVersions.Enabled = false;
                }

                //if ((int)Session["W"] > 0)
                //{
                //    Session["VoteW"] = Math.Min((int)Session["TotalExtra"], (int)Session["W"]) + 1;
                //    ExtraVotes.Visible = true;
                //    ExtraVotes.Text = "You have <b>" + (int)Session["TotalExtra"] + "</b> Extra Votes left.";
                //}
            }

            conn.Close();
            //TimeSpan.Text = ((DateTime)Session["DT"] - DateTime.Now).TotalMilliseconds.ToString();
        }

        protected void BtnSubmitScore_Click(object sender, EventArgs e)
        {
            if (Session["User"] == null)
                Response.Redirect("~/Default.aspx");

            BtnSubmit.Enabled = false;
            //int Period = Global.Refresh((int)Session["Treat"], (int)Session["Group"], out DateTime DT);
            //Session["DT"] = DT;            
            //if (Period < -10)
            //{
            //    LabelLogin.Text = "Your experiment has ended!";
            //    ClientScript.RegisterStartupScript(GetType(), "Attention", "alert('Your experiment has finished.\\nYou are too late!');", true);
            //    RadioVersions.Enabled = false;
            //    ListVersions.Enabled = false;
            //    ParallelMarket.Enabled = false;            
            //    return;
            //}
            //if (Period == -1 || Period == -2)
            //{                
            //    // Session["Notification"] = "The process has finished. \\n Please complete the final survey!";
            //    Response.Redirect("~/Survey.aspx");                
            //}
            //else if (Period % 2 == 1)
            //{                
            //    // Session["Notification"] = "The selectino period has finished. \\n Please edit the Current Updated editino or write a new one!";
            //    Response.Redirect("~/Suggestion.aspx");                
            //}
            // Parallel Markets --------------------------------------

            if ((short)Session["Valuation"] == 10)
            {
                if (ParallelMarket.SelectedIndex < 0)
                {
                    Message.Text = "Please select one choice!";
                    return;
                }
                Session["Choice"] = ParallelMarket.SelectedValue;                
                Session["BuySell"] = null;
                Session["V"] = null;
                Response.Redirect("~/Trading.aspx");
                // Response.Write("<script>window.open('/Trading.aspx','_blank');</script>");
                // "<a href=\"/Trading.aspx\" target=\"_blank\">Goto Exchange</a>";
            }

            if (Session["Valuation"].Equals(4) || Session["Valuation"].Equals(5))
            {
                int CountChoices = 0;

                for (int i = 0; i < ListVersions.Items.Count; i++)
                    if (ListVersions.Items[i].Selected) CountChoices++;

                if (CountChoices >= ListVersions.Items.Count)
                {
                    Message.Text = "You cannot select all choices!";
                    return;
                }
                else if (ListVersions.SelectedIndex < 0)
                {
                    Message.Text = "Please make a selection!";
                    return;
                }
            }
            else if (RadioVersions.SelectedIndex < 0)
            {
                Message.Text = "Please select one version!";
                return;
            }            

            SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["ProcessTreeConnectionString"].ConnectionString);
            conn.Open();
            string query; 
            SqlCommand com;            

            // Voting for oneself suggestion?            
            query = "select Choice from Versions where Treatment = " + Session["Treat"] + " and Group# = " + Session["Group"] + " and Period = " + Session["Period"] + " and Proposer = @User";
            com = new SqlCommand(query, conn);
            com.Parameters.AddWithValue("@User", Session["User"]);
            SqlDataReader Proposed = com.ExecuteReader();

            while(Proposed.Read())
                if ((Session["Valuation"].Equals(4) || Session["Valuation"].Equals(5)) ? ListVersions.Items[(int)Proposed["Choice"]].Selected : RadioVersions.Items[(int)Proposed["Choice"]].Selected)
                {
                    Message.Text = "You cannot vote for your own plan!";
                    ClientScript.RegisterStartupScript(GetType(), "Attention", "alert('You cannot vote for your own plan!');", true);
                    conn.Close();
                    return;
                }

            Proposed.Close();

            // Already voted?
            query = "select VoteWeight from Voting where Treatment = " + Session["Treat"] + " and Group# = " + Session["Group"] + " and Period = " + Session["Period"] + " and Voter = @User";
            com = new SqlCommand(query, conn);
            com.Parameters.AddWithValue("@User", Session["User"]);
            object Voted = com.ExecuteScalar();
            
            if (Voted != null)
            {
                return;
                if (!Session["VoteChange"].Equals(true)) return;
                Session["VoteW"] = (int)Voted;
                if (Session["Valuation"].Equals(4) || Session["Valuation"].Equals(5))
                {
                    query = "delete from Voting where Treatment = " + Session["Treat"] + " and Group# = " + Session["Group"] + " and Period = " + Session["Period"] + " and Voter = @Voter";
                    com = new SqlCommand(query, conn);
                    com.Parameters.AddWithValue("@Voter", Session["User"]);
                    if (com.ExecuteNonQuery() < 0)
                    {
                        Global.EmailAdmin("Error 290: Voting", "UserID = " + Session["User"] + " & Treatment = " + Session["Treat"] + " & Period = " + Session["Period"]);
                        Message.Text = "Error (290) with unpdating approval votes.";
                        conn.Close();
                        return;
                    }

                    query = "insert into Voting (Treatment, Group#, Period, Choice, Stage, Voter, Time, VoteWeight, Value) Values";
                    for (int i = 0; i < ListVersions.Items.Count; i++)
                        if (ListVersions.Items[i].Selected)
                            query += " (@Treatment, @Group, @Period, " + i + " , @Stage, @Voter, GETDATE() , @VoteWeight, @Value) ,";

                    query = query.TrimEnd(',');
                }
                else
                    query = "update Voting set Choice = @Choice, Time = GETDATE() where (Treatment = @Treatment and Group# = @Group and Period = @Period and Voter = @Voter)";
            }
            else
            {                             
                //// Meritocracy:
                //if ((int)Session["TotalExtra"] > 0 && (int)Session["W"] > 0)
                //{
                //    int NewExtra = (int)Session["TotalExtra"] - (int)Session["VoteW"] + 1;
                //    ExtraVotes.Text = "You have <b>" + NewExtra + "</b> Extra Votes left.";

                //    query = "update People set ExtraVote = " + NewExtra + " where ID = @Voter";
                //    com = new SqlCommand(query, conn);
                //    com.Parameters.AddWithValue("@Voter", Session["User"]);
                //    if (com.ExecuteNonQuery() != 1)
                //    {
                //        LabelLogin.Text = "Error (291). Please contact the admin: Law.Economist@Gmail.com";
                //        Global.EmailAdmin("Error 291: Voting", "UserID = " + Session["User"] + " & Treatment = " + Session["Treat"] + " & Period = " + Period);
                //        conn.Close();
                //        return;
                //    }
                //}

                //if ((float)Session["BetFee"] > 0)
                //{
                //    query = "select Balance from People where ID = @Voter";
                //    com = com = new SqlCommand(query, conn);
                //    com.Parameters.AddWithValue("@Voter", Session["User"]);
                //    object Balance = com.ExecuteScalar();
                //    if (Balance == null || (float)Session["BetFee"] > (float)Balance)
                //    {
                //        Message.Text = "You do not have enough balance to vote.";
                //        conn.Close();
                //        return;
                //    }
                                        
                //    LabelLogin.Text = "You spent $" + (float)Session["BetFee"] + " to vote.";
                //    LabelBalance.Text = "Your Balance = $" + ((float)Balance- (float)Session["BetFee"]).ToString("N2");

                //    query = "update People set Balance = Balance -" + (float)Session["BetFee"] + " where ID = @Voter";
                //    com = new SqlCommand(query, conn);
                //    com.Parameters.AddWithValue("@Voter", Session["User"]);
                //    if (com.ExecuteNonQuery() != 1)
                //    {
                //        LabelLogin.Text = "Error (289). Please contact the admin: Law.Economist@Gmail.com";
                //        Global.EmailAdmin("Error 289: Voting", "UserID = " + Session["User"] + " & Treatment = " + Session["Treat"] + " & Period = " + Period);
                //        conn.Close();
                //        return;
                //    }
                //}
                if (Session["Valuation"].Equals(4) || Session["Valuation"].Equals(5))
                {
                    query = "insert into Voting (Treatment, Group#, Period, Choice, Stage, Voter, Time, VoteWeight, Value) Values";
                    for (int i = 0; i < ListVersions.Items.Count; i++)
                        if (ListVersions.Items[i].Selected)                        
                            query += " (@Treatment, @Group, @Period, "+ i +" , @Stage, @Voter, GETDATE(), @VoteWeight, @Value) ,";                        

                    query = query.TrimEnd(',');
                }
                else                
                    query = "insert into Voting (Treatment, Group#, Period, Choice, Stage, Voter, Time, VoteWeight, Value) Values (@Treatment, @Group, @Period, @Choice, @Stage, @Voter, GETDATE(), @VoteWeight, @Value)";                
            }
            com = new SqlCommand(query, conn);

            com.Parameters.AddWithValue("@VoteWeight", 1); // Session["VoteW"]);
            com.Parameters.AddWithValue("@Treatment", Session["Treat"]);
            com.Parameters.AddWithValue("@Group", Session["Group"]);
            com.Parameters.AddWithValue("@Period", Session["Period"]);
            com.Parameters.AddWithValue("@Choice", RadioVersions.SelectedValue);
            com.Parameters.AddWithValue("@Stage", 0);
            com.Parameters.AddWithValue("@Voter", Session["User"]);
            // com.Parameters.AddWithValue("@Time", DateTime.Now);          
            com.Parameters.AddWithValue("@Value", 1);

            try
            {
                if (com.ExecuteNonQuery() < 1)
                {
                    LabelLogin.Text = "Error (279). Please contact the admin: Law.Economist@Gmail.com";
                    Global.EmailAdmin("Error 279: Voting", "UserID = " + Session["User"] + " & Treatment = " + Session["Treat"]);
                    conn.Close();
                    return;
                }
            }
            catch (Exception Ex)
            {
                LabelLogin.Text = "Error (450). Please contact the admin: Law.Economist@Gmail.com";
                Global.EmailAdmin("Error 450: Voting", "UserID = " + Session["User"] + " & Treatment = " + Session["Treat"] + " & Execption = " + Ex);
                conn.Close();
                return;
            }

            Message.Text = "You voted for the above selection.";

            //if (Session["Valuation"].Equals(4) || Session["Valuation"].Equals(5))
            //    Message.Text = "You casted " + ((int)Session["VoteW"] == 1 ? "one vote" : ((int)Session["VoteW"] + " units of vote")) + " for the above selection.";
            //else
            //    Message.Text = "You casted " + ((int)Session["VoteW"] == 1 ? "one vote" : ((int)Session["VoteW"] + " units of vote")) + " for: <i>" + (RadioVersions.SelectedValue == "0" ? "No Change" : "Suggestion " + RadioVersions.SelectedValue) + "</i>";            
            
            if (!Session["VoteChange"].Equals(true))
            {
                RadioVersions.Enabled = false;
                ListVersions.Enabled = false;
            }

            BtnSubmit.Text = "Thanks!";

            conn.Close();
        }

        protected void RadioButtonList1_SelectedIndexChanged(object sender, EventArgs e)
        {
            BtnSubmit.Enabled = true;

            if ((short)Session["Valuation"] == 10)
            {
                LabelLogin.Text = "Error (496) \n Please contact the admin: Law.Economist@Gmail.com";
                Global.EmailAdmin("Error 496: Trading", "UserID = " + Session["User"] + " & Treatment = " + Session["Treat"] + " & Group = " + Session["Group"]);
                return;
            }
            else
            {
                BtnSubmit.Text = "Submit";
                Message.Text = " Voting for: <i>" + (RadioVersions.SelectedValue == "0" ? "Hold Cash" : "Portfolio " + RadioVersions.SelectedValue) + "</i>";
                // + ((int)Session["VoteW"] > 1 ? " Your vote is weighted as " + (int)Session["VoteW"] + " unit vote(s). (=1+" + ((int)Session["VoteW"] - 1) + ")" : "");
            }
        }

        protected void ListVersions_SelectedIndexChanged(object sender, EventArgs e)
        {
            if ((short)Session["Valuation"] == 10)
            {                
                LabelLogin.Text = "Error (488) \n Please contact the admin: Law.Economist@Gmail.com";
                Global.EmailAdmin("Error 488: Trading", "UserID = " + Session["User"] + " & Treatment = " + Session["Treat"] + " & Group = " + Session["Group"]);
                return;
            }

            BtnSubmit.Text = "Submit";

            int CountChoices = 0;

            for (int i = 0; i < ListVersions.Items.Count; i++)            
                if (ListVersions.Items[i].Selected) CountChoices++;

            if (CountChoices >= ListVersions.Items.Count)
            {
                Message.Text = "You cannot select all choices!";
                BtnSubmit.Enabled = false;
                return;
            }
            else if (ListVersions.SelectedIndex < 0)
            {
                Message.Text = "Please make a selection!";
                BtnSubmit.Enabled = false;
                return;
            }

            BtnSubmit.Enabled = true;

            Message.Text = " Voting for <i>" + CountChoices + " choices</i>.";
            // + ((int)Session["VoteW"] > 1 ? " Your vote is weighted as " + (int)Session["VoteW"] + " unit vote(s). (=1+" + ((int)Session["VoteW"] - 1) + ")" : "");
        }

        //protected void BtnHistory_Click(object sender, EventArgs e)
        //{
        //    Response.Redirect("~/History.aspx");
        //}

        protected void BtnSignOut_Click(object sender, EventArgs e)
        {
            Session["User"] = null;
            Response.Redirect("~/Default.aspx");
        }

        protected void ParallelMarket_Changed(object sender, EventArgs e)
        {
            BtnSubmit.Enabled = true;

            if ((short)Session["Valuation"] == 10)
            {
                BtnSubmit.Text = "Trade";
                Message.Text = " Trading: <i>" + (ParallelMarket.SelectedValue == "0" ? "Holding Cash" : "Portfolio " + ParallelMarket.SelectedValue) + "</i>";
            }
            else
            {
                Message.Text = "Error(554) \n Please contact the admin: Law.Economist @Gmail.com";
                Global.EmailAdmin("Error 554: Voting", "UserID = " + Session["User"] + " & Treatment = " + Session["Treat"] + " & Group = " + Session["Group"]);
            }
        }

        protected void BtnRefresh_Click(object sender, EventArgs e)
        {
            Response.Redirect("~/Voting.aspx");
        }
    }
}