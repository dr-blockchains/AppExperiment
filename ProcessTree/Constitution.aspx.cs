using System;
using System.Data.SqlClient;
using System.Configuration;

namespace ProcessTree
{
    public partial class Constitution : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["User"] == null)
                Response.Redirect("~/Default.aspx");

            if (!IsPostBack)
            {
                SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["ProcessTreeConnectionString"].ConnectionString);
                conn.Open();

                string query = "select * from People where ID = @User";
                SqlCommand com = new SqlCommand(query, conn);
                com.Parameters.AddWithValue("@User", Session["User"]);

                SqlDataReader User = com.ExecuteReader();

                if (!User.Read() ||                    
                    User["Treatment"].Equals(DBNull.Value) ||
                    User["Group#"].Equals(DBNull.Value) ||
                    User["Completed"].Equals(true))
                {                    
                    LabelLogin.Text = "Error (39) \\n Please contact the admin: Law.Economist@Gmail.com";
                    Global.EmailAdmin("Error 39: Constitution", "SessionUser =" + Session["User"] + " & UserID =" + User["ID"]);                    
                    conn.Close();
                    Response.Redirect("~/Default.aspx");
                }

                Session["Active"] = !User["QualificationTime"].Equals(DBNull.Value);
                Session["Treat"] = (int)User["Treatment"];
                Session["Group"] = (int)User["Group#"];
                
                if (Session["Active"].Equals(true))
                {
                    LabelLogin.Text = "You already answered the questions " + User["Name"] + ". Please review the instructions until the game begins!";                    
                    BtnSubmit.Text = "Thanks!";
                    BtnSubmit.Enabled = false;
                    LabelMessage.Text = "Please keep this page open! <a href=\"./tips.aspx\" target=\"_blank\">Click here for <b>Visual Directions</b>!</a>";
                }                    
                else
                    LabelLogin.Text = "Welcome " + User["Name"] + " ! Please read the instructions then answer the questions honestly before the game begins.";

                User.Close();

                query = "select * from Treatments where TID = " + Session["Treat"];
                com = new SqlCommand(query, conn);
                SqlDataReader Treatment = com.ExecuteReader();

                if (!Treatment.Read())
                {
                    // TxtConstitution.Text = "Error (49). Please contact the admin: Law.Economist@Gmail.com";
                    ConstitutionBox.Text = "Error (71). Please contact the admin: Law.Economist@Gmail.com";
                    Global.EmailAdmin("Error 71: Constitution", "UserID =" + Session["User"]);                    
                    conn.Close();
                    return;
                }                

                if (Treatment["Constitution"].Equals(DBNull.Value))
                {
                    // TxtConstitution.Text = "Error (70) \n Please contact the admin: Law.Economist@Gmail.com";
                    ConstitutionBox.Text = "Error (80). Please contact the admin: Law.Economist@Gmail.com";
                    Global.EmailAdmin("Error 80: Constitution", "UserID =" + Session["User"] + " & Treatment = " + Treatment["TID"]);                    
                    conn.Close();
                    return;
                }

                // TxtConstitution.Text = Treatment["Constitution"].ToString();
                ConstitutionBox.Text = Treatment["Constitution"].ToString(); 
                //.Replace("\n", "<br>").Replace("{","<b>").Replace("}","</b>");
                float Ta = (float)Treatment["Ta"];
                Session["InitialBalance"] = (float) Treatment["InitialBalance"];
                Session["InitialVolume"] = (float)Treatment["InitialVolume"];

                Treatment.Close();

                query = "select * from Groups where Treatment = " + Session["Treat"] + " and Group# = " + Session["Group"];
                com = new SqlCommand(query, conn);
                SqlDataReader GroupReader = com.ExecuteReader();

                if (!GroupReader.Read())
                {
                    // TxtConstitution.Text = "Error (113). Please contact the admin: Law.Economist@Gmail.com";
                    ConstitutionBox.Text = "Error (102). Please contact the admin: Law.Economist@Gmail.com";
                    Global.EmailAdmin("Error 102: Constitution", "UserID =" + Session["User"]);                    
                    conn.Close();
                    return;
                }

                if (GroupReader["Period"].Equals(DBNull.Value))
                {
                    // TxtConstitution.Text = "Error (122) \n Please contact the admin: Law.Economist@Gmail.com";
                    ConstitutionBox.Text = "Error (111). Please contact the admin: Law.Economist@Gmail.com";
                    Global.EmailAdmin("Error 111: Constitution", "UserID =" + Session["User"] + " & Group = " + Session["Group"]);                    
                    conn.Close();
                    return;
                }

                Session["Starting"] = (DateTime)GroupReader["Starting"];
                Session["DeadLine"] = ((DateTime)GroupReader["Starting"]).AddMinutes(Ta);
                conn.Close();
            }

            // Timer:
            if (DateTime.Now < (DateTime)Session["Starting"])
            {
                Session["DT"] = Session["Starting"];
                TimeSpan.Text = ((DateTime)Session["Starting"] - DateTime.Now).TotalMilliseconds.ToString();
            }
            else if (Session["Active"].Equals(true))
            {
                int Period = Global.Refresh((int)Session["Treat"], (int)Session["Group"], out DateTime DT);
                
                #region Period --> Redirect

                if (Period == -9 || Period == 0)
                {                    
                    Global.EmailAdmin("Error 209: Constitution", "UserID =" + Session["User"] + " <br> Period = " + Period);
                    Response.Redirect("~/Default.aspx");
                    return;
                }
                if (Period < -10)
                {
                    TimeSpan.Text = "0";
                    LabelLogin.Text = "Your experiment has ended!";
                    BtnSubmit.Enabled = false;
                    Session["User"] = null;
                    ClientScript.RegisterStartupScript(GetType(), "Attention", "alert('Your experiment has ended.');", true);                                        
                    return;
                }
                if (Period == -1 || Period == -2)                                    
                    Response.Redirect("~/Survey.aspx");                
                else if (Period % 2 == 1)
                    Response.Redirect("~/Suggestion.aspx");
                else // if (Period % 2 == 0)
                    Response.Redirect("~/Voting.aspx");

                #endregion
            }
            else if (DateTime.Now < (DateTime)Session["DeadLine"])
            {
                Session["DT"] = Session["DeadLine"];
                TimeSpan.Text = ((DateTime)Session["DeadLine"] - DateTime.Now).TotalMilliseconds.ToString();
                DeadLineMessage.Text = "You must complete the survey before: ";
                LabelLogin.Text = "The game already started. You have limited time to answer the questions.";
            }
            else
            {
                ConstitutionBox.Text = "Your time to answer the survey has expired!";
                Session["User"] = null;                
                TimeSpan.Text = "0";
                TimerMessage.Visible = false;
                DeadLineMessage.Visible = false;
                BtnSubmit.Enabled = false;
                LabelLogin.Text = "Your time has expired.";                
                return;
            }
        }

        protected void BtnSubmit_Click(object sender, EventArgs e)
        {
            if (Session["User"] == null)                        
                Response.Redirect("~/Default.aspx");

            if (Session["Active"].Equals(true))
            {
                BtnSubmit.Enabled = false;
                ClientScript.RegisterStartupScript(GetType(), "Attention", "alert('You already answered the questions. Please review the instructions until the game begins!.');", true);
                LabelMessage.Text = "Please keep this page open! <a href=\"./tips.aspx\" target=\"_blank\">Click here for <b>Visual Directions</b>!</a>";
                return;
            }

            if ((DateTime)Session["DeadLine"] < DateTime.Now)
            {
                BtnSubmit.Enabled = false;
                ClientScript.RegisterStartupScript(GetType(), "Attention", "alert('Your time has expired.');", true);
                LabelMessage.Text = "Your time has expired.";
                return;                
            }
            //query = "select * from Treatments where TID = " + Session["Treat"];
            //com = new SqlCommand(query, conn);
            //SqlDataReader Treatment = com.ExecuteReader();

            //if (!Treatment.Read())
            //{
            //    LabelMessage.Text = "Error (142). Please contact the admin: Law.Economist@Gmail.com";
            //    Global.EmailAdmin("Error 142: Constitution", "UserID =" + Session["User"]);
            //    BtnSubmit.Enabled = false;
            //    conn.Close();
            //    return;
            //}

            //bool Correct;

            //try
            //{
            //    Correct =
            //        Convert.ToInt32(Text2.Text.Trim()) == 2 &&
            //        Math.Abs(Convert.ToSingle(Text3.Text.Trim()) - (float)Treatment["Tv"]) < .001 &&
            //        Math.Abs(Convert.ToSingle(Text4.Text.Trim()) - (float)Treatment["Tz"]) < .001;
            //}
            //catch
            //{
            //    Correct = false;
            //}
            //Treatment.Close();
            if (RadioScore5.SelectedIndex != 4)
            {
                LabelMessage.Text = "Read the instructions carefully!";
                LabelLogin.Text = "Read the instructions carefully!";
                Session["Error"] = RadioScore5.SelectedIndex + 1;
                return;
            }

            int Score1 = RadioScore1.SelectedIndex + 1;
            int Score2 = RadioScore2.SelectedIndex + 1;
            int Score3 = RadioScore3.SelectedIndex + 1;
            int Score4 = RadioScore4.SelectedIndex + 1;
            int Score5 =(int)(Session["Error"]??99);
            int Score6 = RadioScore6.SelectedIndex + 1;
            Response7.Text = Response7.Text.Trim();
            
            if (Score1 <= 0 || Score2 <= 0 || Score3 <= 0 || Score4 <= 0 || Score6 <= 0)
            {
                LabelMessage.Text = "Read the instructions carefully!";
                LabelLogin.Text = "Read the instructions carefully!";          
                return;
            }

            if (Response7.Text.Length < 80)
            {
                LabelMessage.Text = "Your response should be at least 80 characters.";
                return;
            }

            // ############ Correct answer #######################################################            
            if (!BtnSubmit.Enabled) return;
            BtnSubmit.Enabled = false;

            BtnSubmit.Text = "Thanks!";

            SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["ProcessTreeConnectionString"].ConnectionString);
            conn.Open();

            string query = "UPDATE People SET QualificationTime = GETDATE() , Balance = @Balance , " +
                "Before1 = @Score1 , Before2 = @Score2 , Before3 = @Score3 , Before4 = @Score4 , Before5 = @Score5 , Before6 = @Score6 , Before7R = @Response7 " +
                "WHERE ID = @User";
                        
            SqlCommand com = new SqlCommand(query, conn);
            com.Parameters.AddWithValue("@User", Session["User"]);
            com.Parameters.AddWithValue("@Balance", Session["InitialBalance"]);
            com.Parameters.AddWithValue("@Score1", Score1);
            com.Parameters.AddWithValue("@Score2", Score2);
            com.Parameters.AddWithValue("@Score3", Score3);
            com.Parameters.AddWithValue("@Score4", Score4);
            com.Parameters.AddWithValue("@Score5", Score5);
            com.Parameters.AddWithValue("@Score6", Score6);            
            com.Parameters.AddWithValue("@Response7", Response7.Text);

            if (com.ExecuteNonQuery() != 1)
            {
                LabelLogin.Text = "Error (125) \n Please contact the admin: Law.Economist@Gmail.com";
                Global.EmailAdmin("Error 125: Constitution", "UserID =" + Session["User"]);
                conn.Close();
                return;
            }

            query = "EXEC Orient @Treatment, @Group, @User, @Vol";
            com = new SqlCommand(query, conn);
            com.Parameters.AddWithValue("@User", Session["User"]);
            com.Parameters.AddWithValue("@Treatment", Session["Treat"]);
            com.Parameters.AddWithValue("@Group", Session["Group"]);
            com.Parameters.AddWithValue("@Vol", Session["InitialVolume"]);
            try
            {
                if (com.ExecuteNonQuery() < 1)
                {                    
                    Global.EmailAdmin("Error 258: Constitution", "UserID =" + Session["User"]);
                    LabelMessage.Text = "Your answers are updated.";
                }
            }
            catch (Exception Ex)
            {
                Global.EmailAdmin("Error(281)", "User=" + Session["User"] + " & Treat=" + Session["Treat"] + " &&&&&&&&&&& Exception = " + Ex);
                LabelMessage.Text = "Your answers are updated.";
            }

            conn.Close();

            int Period = Global.Refresh((int)Session["Treat"], (int)Session["Group"], out DateTime DT);
            
            if (Period == -9)
            {                
                Global.EmailAdmin("Error 209: Constitution", "UserID =" + Session["User"]);
                return;
            }
            if (Period < -10)
            {
                LabelMessage.Text = "Too late!";
                LabelLogin.Text = "Your experiment has ended!";
                Session["User"] = null;
                return;
            }
            if (Period == 0)
            {               
                LabelLogin.Text = "Congratulations! Please review the instructions until the game begins!";
                // ClientScript.RegisterStartupScript(GetType(), "Attention", "alert('Congratulations!\\n Please review the instructions until the game begins!');", true);                
                LabelMessage.Text = "Please keep this page open! <a href=\"./tips.aspx\" target=\"_blank\">Click here for Visual Directions!</a>";
                LabelMessage.Focus();
            }
            else if (Period == -1 || Period == -2)             
                Response.Redirect("~/Survey.aspx");            
            else if (Period % 2 == 1)
                Response.Redirect("~/Suggestion.aspx");
            else // if (Period % 2 == 0)
                Response.Redirect("~/Voting.aspx");                   
        }

        protected void BtnHistory_Click(object sender, EventArgs e)
        {
            Response.Redirect("~/History.aspx");
        }

        protected void BtnSignOut_Click(object sender, EventArgs e)
        {
            Session["User"] = null;
            Response.Redirect("~/Default.aspx");
        }
    }
}