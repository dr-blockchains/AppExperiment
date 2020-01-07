using System;
using System.Configuration;
using System.Data.SqlClient;

namespace ProcessTree
{
    public partial class Survey : System.Web.UI.Page
    {              
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["User"] == null || Session["Treat"] == null || Session["Group"] == null)
                Response.Redirect("~/Default.aspx");

            if (!IsPostBack)
            {
                LabelMessage.Text = "";

                SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["ProcessTreeConnectionString"].ConnectionString);
                conn.Open();

                string query = "select * from People where ID = @User";
                SqlCommand com = new SqlCommand(query, conn);
                com.Parameters.AddWithValue("@User", Session["User"]);
                SqlDataReader User = com.ExecuteReader();

                if (!User.Read())
                {                    
                    Global.EmailAdmin("Error 47: Survey", "UserID = " + Session["User"] + " & Treatment = " + User["ID"]);
                    conn.Close();
                    Response.Redirect("~/Default.aspx");
                }

                if (!User["Completed"].Equals(DBNull.Value) || User["QualificationTime"].Equals(DBNull.Value) || User["Rater"].Equals(true))
                {
                    conn.Close();
                    Response.Redirect("~/Default.aspx");                    
                }
                
                LabelLogin.Text = "Good job <em>" + User["Name"] + "<em> !";
                float Balance = (float)User["Balance"];
                LabelBalance.Text = "Your Cash Balance = $ " + Balance.ToString("N2");
                //LabelFinalBalance.Text = " --> Your Total Balance = $5 + $" + ((float)User["FinalBalance"]).ToString("N2") + " (Bonus)";

                User.Close();
                                                                                                    
                int LastPeriod = 12;
                float FinalValue = 0.0f, Score = 0;

                query = "SELECT TOP 1 * FROM Versions WHERE Treatment = @Treat AND Group# = @Group AND Choice = 0 ORDER BY Period DESC";
                com = new SqlCommand(query, conn);                
                com.Parameters.AddWithValue("@Treat", Session["Treat"]);
                com.Parameters.AddWithValue("@Group", Session["Group"]);
               
                var FinalArtifact = com.ExecuteReader();
                if (!FinalArtifact.Read())
                {
                    LabelArtifact.Text = "Error in database. Please refresh the page.";                    
                    Global.EmailAdmin("Error 56: Survey", "UserID = " + Session["User"] + " & Treatment = " + Session["Treat"] + " & Group# = " + Session["Group"]);
                }
                else
                {                    
                    LabelArtifact.Text = FinalArtifact["HtmlArtifact"].ToString();
                    LastPeriod = (int)FinalArtifact["Period"];
                    FinalValue = (float)FinalArtifact["PerVal"];
                    Score = (float)FinalArtifact["Score"];
                }

                FinalArtifact.Close();

                query = "SELECT Volume FROM Shares WHERE Owner = @User AND Treatment = @Treat AND Group# = @Group AND Period = @Period AND Choice = 0";
                com = new SqlCommand(query, conn);
                com.Parameters.AddWithValue("@User", Session["User"]);
                com.Parameters.AddWithValue("@Treat", Session["Treat"]);
                com.Parameters.AddWithValue("@Group", Session["Group"]);
                com.Parameters.AddWithValue("@Period", LastPeriod);

                float Shares = (float)(com.ExecuteScalar() ?? 0.0f);
                LabelShare.Text = "Your Number of Shares = " + Shares.ToString();

                Session["FinalBalance"] = Math.Round((Balance + Shares * FinalValue / Score) * 100) / 100;                

                // Initialize the timer: **********************************************************************
                query = @"SELECT Treatment, Group#, Compensation, Starting, Tz, Tf
                          FROM Groups LEFT JOIN Treatments on Treatments.TID = Groups.Treatment
                          WHERE TID = @Treat AND Group# = @Group";
                
                com = new SqlCommand(query, conn);
                com.Parameters.AddWithValue("@Treat", Session["Treat"]);
                com.Parameters.AddWithValue("@Group", Session["Group"]);

                var Dates = com.ExecuteReader();

                if (!Dates.Read())
                {
                    LabelArtifact.Text = "Error (192). Please contact the admin: Law.Economist@Gmail.com";
                    Global.EmailAdmin("Error 192: Rating", "UserID = " + Session["User"] + " & Treatment = " + Session["Treat"]);
                    conn.Close();
                    return;
                }

                float Tz = (float)Dates["Tz"];
                float Tf = (float)Dates["Tf"];
                //Session["Compensation"] = (float)Dates["Compensation"];

                Session["Ending"] = ((DateTime)Dates["Starting"]).AddMinutes(Tz+Tf);

                if (DateTime.Now < ((DateTime)Dates["Starting"]).AddMinutes(Tz - 1))
                {
                    Response.Redirect("~/Default.aspx");
                    Global.EmailAdmin("Error 141: Survey", "UserID =" + Session["User"]);                    
                }

                conn.Close();

                if ((DateTime)Session["Ending"] < DateTime.Now)
                {
                    LabelMessage.Text = "Your survey time expired " + 
                        (((DateTime)Session["Ending"]).Date == DateTime.Now.Date ? "at " + ((DateTime)Session["Ending"]).ToString(Global.TimeFormat) : "on " + ((DateTime)Session["Ending"]).ToString(Global.DateFormat));
                    TimeSpan.Text = "0";
                    LabelLogin.Text = "Your survey time has expired!";
                    TimerMessage.Text = "";
                    BtnSubmitScore.Enabled = false;
                    Session["User"] = null;
                    ClientScript.RegisterStartupScript(GetType(), "Attention", "alert('Your survey time expired.');", true);                    
                    return;                    
                }
                //else ClientScript.RegisterStartupScript(GetType(), "Attention", "notify('The game ended. Please complete the Final Survey.');", true);                                                                                
            }

            // Timer when postback:
            int Period = Global.Refresh((int)Session["Treat"], (int)Session["Group"], out DateTime DT);

            if (Period < -10)
            {
                TimeSpan.Text = "0";
                LabelLogin.Text = "Your experiment has ended!";
                TimerMessage.Text = "";
                BtnSubmitScore.Enabled = false;
                Session["User"] = null;
                ClientScript.RegisterStartupScript(GetType(), "Attention", "alert('Your experiment has ended!');", true);                
                return;
            }
            if (Period == -1 || Period == -2)
            {
                Session["DT"] = Session["Ending"];
                TimeSpan.Text = (((DateTime)Session["DT"]) - DateTime.Now).TotalMilliseconds.ToString();                
            }
            else
            {
                Response.Redirect("~/Default.aspx");                
                return;
            }
        }

        protected void BtnSubmitScore_Click(object sender, EventArgs e)
        {
            if (Session["User"] == null)
                Response.Redirect("~/Default.aspx");

            int Score1 = RadioScore1.SelectedIndex + 1;
            Response2.Text = Response2.Text.Trim();            
            int Score3 = RadioScore3.SelectedIndex + 1;
            int Score4 = RadioScore4.SelectedIndex + 1;
            Response5.Text = Response5.Text.Trim();

            if (Score1 <= 0 || Score3 <= 0 || Score4 <= 0)
            {
                LabelMessage.Text = "Please give scores to all rating questions.";
                return;
            }

            if (Response2.Text.Length < 80 || Response5.Text.Length < 80)
            {
                LabelMessage.Text = "Each response should be at least 80 characters.";
                return;
            }

            BtnSubmitScore.Enabled = false;

            // Periods: ********************************
            int Period = Global.Refresh((int)Session["Treat"], (int)Session["Group"], out DateTime DT);

            if (Period < -10 || ((DateTime)Session["Ending"]) < DateTime.Now)
            {                
                LabelMessage.Text = "Your experiment has ended." +
                         (((DateTime)Session["Ending"]).Date == DateTime.Now.Date ? "at " + ((DateTime)Session["Ending"]).ToString(Global.TimeFormat) : "on " + ((DateTime)Session["Ending"]).ToString(Global.DateFormat));

                LabelArtifact.Text = "If you have any question, concern or suggestion, please contact the Admin: Khaledi @bus.msu.edu";
                Session["User"] = null;
                ClientScript.RegisterStartupScript(GetType(), "Attention", "alert('Your Time has Expired.');", true);
                return;
            }
            else if (Period != -1 && Period != -2) // Error
            {
                LabelMessage.Text = "Error (261). Please contact the admin: Law.Economist@Gmail.com";
                Global.EmailAdmin("Error 262: Final Survey", "SessionTreat = " + Session["Treat"] + " & UserID = " + Session["User"] + " & Treatment = " + Session["Treat"]);
         
                Session["User"] = null;
                return;
            }         
            else // if (Period == -1 || Period == -2)
            {
                if (Session["Treat"] == null || Session["Group"] == null)
                {
                    LabelMessage.Text = "Error (414). Please contact the admin: Law.Economist@Gmail.com";
                    Global.EmailAdmin("Error 414: Rating", "UserID = " + Session["User"] + " & Treatment = " + Session["Treat"]);                    
                    return;
                }
                //float NewBalance = (float)Session["FinalBalance"] + (float)Session["Compensation"];
                //LabelBalance.Text = "Your Final Balance = $ " + NewBalance.ToString("N2");                

                SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["ProcessTreeConnectionString"].ConnectionString);                
                SqlCommand com;
                conn.Open();

                string query = "UPDATE People SET Completed = GETDATE(), FinalBalance = @FinalBalance, After1 = @Score1 , After2R = @Response2 , After3 = @Score3 , After4 = @Score4 , After5R = @Response5 WHERE ID = @User";

                com = new SqlCommand(query, conn);
                com.Parameters.AddWithValue("@User", Session["User"]);
                com.Parameters.AddWithValue("@FinalBalance", Session["FinalBalance"]);
                com.Parameters.AddWithValue("@Score1", Score1);
                com.Parameters.AddWithValue("@Response2", Response2.Text);                
                com.Parameters.AddWithValue("@Score3", Score3);
                com.Parameters.AddWithValue("@Score4", Score4);
                com.Parameters.AddWithValue("@Response5", Response5.Text);

                if (com.ExecuteNonQuery() != 1)
                {
                    LabelMessage.Text = "Error (237). Please contact the admin: Law.Economist@Gmail.com";
                    Global.EmailAdmin("Error 238: Rating", "UserID = " + Session["User"] + " & Treatment = " + Session["Treat"] + " & Group = " + Session["Group"]);
                    conn.Close();
                    return;
                }

                conn.Close();

                BtnSubmitScore.Text = "Thanks!";
                //LabelMessage.Text = "Your final balance is: $" + ((double)Session["FinalBalance"]).ToString("N2");
                LabelMessage.Text = "Your completion code is: " + Session["Treat"] + Session["Group"] + "." + Session["User"].ToString().Substring(1,2).ToLower() + "." + DateTime.Now.Minute ;

                Session["User"] = null;
                //if (((float)Session["Compensation"]) > 0)
                //    LabelMessage.Text = "Thank you! Your balance increased by $" + ((float)Session["Compensation"]).ToString("N2");
                //else
                //    LabelMessage.Text = "Thank you!";
            }
        }
        //protected void BtnHistory_Click(object sender, EventArgs e)
        //{
        //    if(Session["User"] == null)            
        //        Response.Redirect("~/Default.aspx");
        //    else            
        //        Response.Redirect("~/History.aspx");                     
        //}
    }
}