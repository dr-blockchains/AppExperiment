using System;
using System.Linq;
using System.Data.SqlClient;
using System.Configuration;
using System.Security.Cryptography;
using System.Text;
using System.Text.RegularExpressions;
using System.Data;

namespace ProcessTree
{
    public partial class Main : System.Web.UI.Page
    {
        public static Regex WIDCheck = new Regex("^A[0-9A-Z]{3,30}$");
        // public static Regex EmailCheck = new Regex("\\w+([-+.']\\w+)*@\\w+([-.]\\w+)*\\.edu");

        protected void Page_Load(object sender, EventArgs e)
        {
            if (IsPostBack) return;
            
            if (Session["User"] == null || Session["Treat"] == null || Session["Group"] == null)
            {
                NickName.Focus();

                //Worker ID Verification
                string WorkerID = Request.QueryString["WorkerID"];
                if (WorkerID != null && WIDCheck.IsMatch(WorkerID))
                {
                    TextID.Text = WorkerID;
                    TextID.ReadOnly = true;
                    LabelLogin.Text = "Please choose a nick name for your self.";
                    LabelMessage.Text = "Please check that your Worker ID is correct.";
                    return;
                }
                                               
                // Email Verification
                string Nonce = Request.QueryString["nonce"];
                if (Nonce == null || Nonce.Length != 36) return;
                Regex NonceCheck = new Regex("^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$");
                if (!NonceCheck.IsMatch(Nonce))return;

                SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["ProcessTreeConnectionString"].ConnectionString);
                conn.Open();

                string query = "select * from People where Nonce = '" + Nonce + "'";
                SqlCommand com = new SqlCommand(query, conn);

                SqlDataReader User = com.ExecuteReader();

                if (!User.Read())
                {
                    conn.Close();
                    TextUser.Focus();
                    return;
                }                    

                LabelLogin.Text = User["Name"] + ", your Email successfully verified!";
                LabelMessage.Text = "Please scroll up to login.";
                TextUser.Text = User["ID"].ToString();
                TextPassword.Text = "";
                TextPassword.Focus();
                // BtnLogin.Enabled = true;

                User.Close();

                query = "update People set Verified = GETDATE() where ID = @ID";
                com = new SqlCommand(query, conn);
                com.Parameters.AddWithValue("@ID", TextUser.Text);

                if (com.ExecuteNonQuery() != 1)
                {
                    LabelLogin.Text = "Error (42). Please contact the admin: Law.Economist@Gmail.com";
                    Global.EmailAdmin("Error 42: Default", "UserID =" + TextUser.Text);
                }

                conn.Close();

                return;
            }     
            
            if (Session["User"].Equals("experimenter"))
                Response.Redirect("~/ControlPanel.aspx");
            
            //##################################################################################################
            // A logged in participant with a Treatment Group: -->                           

            int Period = Global.Refresh((int)Session["Treat"], (int)Session["Group"], out DateTime DT);
            
            if (Period < -10) // Experiment Ended
            {
                LabelLogin.Text = "Your experiment has ended.";
                Session["User"] = null;
                return;
            }
            else if (Period == -9) // Null : Experiment Not Started 
            {
                LabelLogin.Text = "You are too late. This experiment has already started.";
                Session["User"] = null;
                return;
            }
            else if (Period == 0 || !Session["Active"].Equals(true)) // Period = 0 or Participant not active yet                            
                Response.Redirect("~/Constitution.aspx");

            else if (Period == -1 || Period == -2) // Final Period and Participant is active                
                Response.Redirect("~/Survey.aspx");

            else if (Period % 2 == 1)  // Suggestion Period and Participant is active
                Response.Redirect("~/Suggestion.aspx");

            else  // if (Period % 2 == 0) // Voting Period and participant is active
                Response.Redirect("~/Voting.aspx");
        }

        protected void BtnLogin_Click(object sender, EventArgs e)
        {
            TextUser.Text = TextUser.Text.Trim(); //.ToLower();

            var conn = new SqlConnection(ConfigurationManager.ConnectionStrings["ProcessTreeConnectionString"].ConnectionString);
            conn.Open();

            string query = "select * from People where ID = @ID";
            var com = new SqlCommand(query, conn);

            com.Parameters.AddWithValue("@ID", TextUser.Text);

            SqlDataReader User = com.ExecuteReader();

            if (!User.Read())
            {
                LabelLogin.Text = "Wrong Username!";
                Session["User"] = null;
                BtnLogin.Text = " Log In ";

                conn.Close();
                return;
            }

            //Reset Password
            if (TextPassword.Text == "Reset")
            {
                LabelLogin.Text = "New password sent to " + TextUser.Text;
                TextPassword.Text = "";

                Random rnd = new Random();
                string RandomPass = rnd.Next(10000).ToString();

                string Content = "Hello " + User["Name"] + " ! <br>" +

 "Your temporary password is : \"" + RandomPass + "\". <br>" +

 "Please log into your account with the [Edit Profile] checked to change your password. <br><br>" +

 "If you did not request password reset, please forward this email to the experimenter: Law.Economist@Gmail.com";

                Global.EmailAdmin("Password Reset", Content);

                string StringToHashX = RandomPass + User["Nonce"];
                byte[] ByteArrayToHashX = Encoding.UTF8.GetBytes(StringToHashX);
                HashAlgorithm algorithmX = new SHA256Managed();
                byte[] HashResultX = algorithmX.ComputeHash(ByteArrayToHashX);
                query = "update People set HashP = @HashP where ID = @ID";
                com = new SqlCommand(query, conn);
                com.Parameters.AddWithValue("@HashP", HashResultX);
                com.Parameters.AddWithValue("@ID", TextUser.Text);

                User.Close();
                if (com.ExecuteNonQuery() != 1)
                {
                    LabelLogin.Text = "Error (127). Please contact the admin: Law.Economist@Gmail.com";
                    Global.EmailAdmin("Error 127: ChangePass", "ID =" + TextUser.Text + " & Pass =" + RandomPass);                    
                }

                conn.Close();
                return;
            }

            // Nonce +  Password -->  HashP
            string StringToHash = TextPassword.Text + User["Nonce"];
            byte[] ByteArrayToHash = Encoding.UTF8.GetBytes(StringToHash);
            HashAlgorithm algorithm = new SHA256Managed();
            byte[] HashResult = algorithm.ComputeHash(ByteArrayToHash);

            if (!HashResult.SequenceEqual((byte[])User["HashP"]))
            {
                LabelLogin.Text = "Wrong Password!";
                ClientScript.RegisterStartupScript(GetType(), "Attention", "alert('If you forgot your password please contact admin: Law.Economist@Gmail.com');", true);
                TextPassword.Text = "";
                conn.Close();
                return;
            }
            
            // Logged In:
            Session["User"] = TextUser.Text;

            // Edit?
            if (ChkEdit.Checked)
            {
                conn.Close();
                Response.Redirect("~/ChangePass.aspx");
            }

            // Experimenter
            if (TextUser.Text.ToLower() == "experimenter")
            {
                conn.Close();                
                Response.Redirect("~/ControlPanel.aspx");
            }
   //         if (User["Verified"].Equals(DBNull.Value))
   //         {
   //             LabelLogin.Text = "Please check your email for Verification";
   //             LabelMessage.Text = "First verify your email address (" + TextUser.Text + ")";                

   //             BtnLogin.Text = " Log In ";

   //             string Content = "Hello again " + User["Name"] + " ! <br>" +

   //"Thank you for registering to participate in our experiment. <br>" +

   //"Please <a href = 'https://Faculty.McCombs.UTexas.edu/Hamed.Khaledi/Default.aspx?nonce=" + User["Nonce"] + "'> Click Here </a>  to verify your email address. <br>" +

   //"If you did not sign up for this experiment, please forward this email to the experimenter: Law.Economist@Gmail.com!";

   //             Global.Email(TextUser.Text, "Verification", Content);

   //             conn.Close();
   //             return;
   //         }
            if (!User["Completed"].Equals(DBNull.Value))
            {
                LabelLogin.Text = "Hi " + User["Name"] + " ! Your final balance is $" + ((float)User["FinalBalance"]).ToString("F");

                conn.Close();
                return;
            }
            //if (User["Rater"].Equals(true))
            //{
            //    LabelLogin.Text = "Thanks for your participation <strong>" + User["Name"] + "<strong> !<br>We already sent you your balance: $" + ((float)User["Balance"]).ToString("N2") ;

            //    conn.Close();
            //    return;

            //    Response.Redirect("~/Rating.aspx");
            //}
            Session["Active"] = !User["QualificationTime"].Equals(DBNull.Value);

            // Assign Treatment Groups:

            if (User["Treatment"].Equals(DBNull.Value) || User["Group#"].Equals(DBNull.Value))                      // ||  User["InitialScore"].Equals(DBNull.Value) )
            {
                User.Close();
                query = @"
                SELECT
                    Groups.Treatment,
                    Groups.Group#,
                    COALESCE(Subjects.SubjectCount, 0) AS SubjectCount,
                    Treatments.PerGroup,
                    Groups.Period
                FROM Groups
                LEFT JOIN (
                    SELECT
                        COUNT(People.ID) AS SubjectCount,
                        People.Treatment,
                        People.Group# 
                    FROM People 
                    WHERE People.Rater <> 1
                    GROUP BY People.Treatment, People.Group# 
                ) AS Subjects
                    ON Subjects.Treatment=Groups.Treatment AND Subjects.Group# = Groups.Group#
                LEFT JOIN Treatments
                    ON Treatments.TID = Groups.Treatment
                WHERE    
                    COALESCE(Subjects.SubjectCount, 0) < Treatments.PerGroup    
                    AND Groups.Period = 0
                    AND COALESCE(Subjects.SubjectCount, 0) = (
                        SELECT
                            MIN(SubjectNumbers.SubjectCount) AS MinCount
                        FROM (
                            SELECT
                                COALESCE(COUNT(People.ID), 0) AS SubjectCount
                            FROM Groups 
                            LEFT JOIN People ON People.Treatment = Groups.Treatment AND People.Group# = Groups.Group# AND People.Rater <> 1
                            LEFT JOIN Treatments ON Treatments.TID = Groups.Treatment
                            GROUP BY Groups.Treatment, Groups.Group#, Groups.Period, Treatments.PerGroup
                            HAVING
                                COALESCE(COUNT(People.ID), 0) < Treatments.PerGroup
                                AND Groups.Period = 0
                        ) AS SubjectNumbers
                    )
                ";

                com = new SqlCommand(query, conn);
                var TreatGroup = com.ExecuteReader();
                var TreatmentGroup = new DataTable();
                TreatmentGroup.Load(TreatGroup);
                TreatGroup.Close();
                int Count = TreatmentGroup.Rows.Count;
                if (Count == 0)
                {
                    query = @"
                SELECT Groups.Treatment, Groups.Group#, SubjectCount, PerGroup, Groups.Period
                FROM Groups LEFT JOIN (
                		SELECT COUNT(People.ID) AS SubjectCount, People.Treatment, People.Group# 
                		FROM People 
                		WHERE People.Rater<>1
                		GROUP BY People.Treatment, People.Group# 
                		) AS Subjects ON Subjects.Treatment=Groups.Treatment AND Subjects.Group# = Groups.Group#
                		LEFT JOIN Treatments on Treatments.TID = Groups.Treatment
                WHERE (SubjectCount < PerGroup OR SubjectCount IS NULL) AND Groups.Period IS NULL";

                    com = new SqlCommand(query, conn);
                    TreatGroup = com.ExecuteReader();
                    TreatmentGroup = new DataTable();
                    TreatmentGroup.Load(TreatGroup);
                    TreatGroup.Close();
                    Count = TreatmentGroup.Rows.Count;
                    if (Count == 0)
                    {
                        LabelLogin.Text = "We already got enough participants.";
                        Session["Treat"] = null; Session["Group"] = null;
                        conn.Close();
                        ClientScript.RegisterStartupScript(GetType(), "Attention", "alert('You are too late.\\nThis experiment has already started.');", true);
                        return;
                    }
                }
                Random rnd = new Random();
                int RandomRow = rnd.Next(Count);

                Session["Treat"] = (int)TreatmentGroup.Rows[RandomRow][0];
                Session["Group"] = (int)TreatmentGroup.Rows[RandomRow][1];

                // Assign the Treatment Group to the User:
                query = "update People set Treatment = " + Session["Treat"] + ", Group# = " + Session["Group"] + " where ID = @User";
                #region Execute
                com = new SqlCommand(query, conn);
                com.Parameters.AddWithValue("@User", Session["User"].ToString());
                if (com.ExecuteNonQuery() != 1)
                {
                    LabelLogin.Text = "Error (162). Please contact the admin: Law.Economist@Gmail.com";
                    Global.EmailAdmin("Error 162: Rating", "UserID = " + Session["User"] + " & Treatment = " + Session["Treat"]);
                    conn.Close();
                    return;
                }                
                #endregion
            }
            else
            {
                Session["Treat"] = (int)User["Treatment"];
                Session["Group"] = (int)User["Group#"];
            }

            conn.Close();

            // A Participant with a Treatment Group: -->                           
            int Period = Global.Refresh((int)Session["Treat"], (int)Session["Group"], out DateTime DT);
            
            if (Period < -10) // Experiment Ended
            {
                LabelLogin.Text = "Your experiment has ended.";
                Session["User"] = null;
                return;
            }
            else if (Period == -9) // Null : Experiment Not Started 
            {
                LabelLogin.Text = "Your experiment has not started yet.";                
                Session["User"] = null;
                return;                                
            }
            else if(Period == 0 || !Session["Active"].Equals(true)) // Period = 0 or Participant not active yet                            
                Response.Redirect("~/Constitution.aspx");   
                     
            else if (Period == -1 || Period == -2) // Final Period and Participant is active                
                Response.Redirect("~/Survey.aspx");        
                
            else if ( Period % 2 == 1)  // Suggestion Period and Participant is active
                Response.Redirect("~/Suggestion.aspx");

            else  // if (Period % 2 == 0) // Voting Period and participant is active
                Response.Redirect("~/Voting.aspx"); 
        }

        protected void CheckAgree_CheckedChanged(object sender, EventArgs e)
        {            
            if (CheckAgree.Checked) //&& WIDCheck.IsMatch(TextID.Text))
            {
                BtnSignUp.Enabled = true;
                TextPass.Enabled = true;
                TextRPass.Enabled = true;
            }
            else
            {
                BtnSignUp.Enabled = false;
                TextPass.Enabled = false;
                TextRPass.Enabled = false;
            }
        }

        protected void TextID_TextChanged(object sender, EventArgs e)
        {
            LabelMessage.Text = "";            
        }

        protected void TextUser_TextChanged(object sender, EventArgs e)
        {
            if (TextUser.Text.Trim() == "")
            {
                //BtnLogin.Enabled = false;
                TextUser.Focus();
            }                
            else
            {
                //BtnLogin.Enabled = true;
                TextPassword.Focus();
            }                
        }

        protected void BtnSignUp_Click(object sender, EventArgs e)
        {
            TextID.Text = TextID.Text.Trim();   //.ToLower();
            if (!WIDCheck.IsMatch(TextID.Text))
            {
                LabelMessage.Text = "Invalid WorkerID!";
                return;
            }
            //if (!EmailCheck.IsMatch(TextID.Text))
            //{
            //    LabelMessage.Text = "Invalid Email address!";
            //    return;
            //}
            SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["ProcessTreeConnectionString"].ConnectionString);
            conn.Open();

            string query = "select Verified from People where ID = @ID";
            SqlCommand com = new SqlCommand(query, conn);
            com.Parameters.AddWithValue("@ID", TextID.Text);
            object Verified = com.ExecuteScalar();

            if (Verified!=null)
                if (Verified.Equals(DBNull.Value))
                {
                    query = "DELETE FROM People WHERE ID = @ID";

                    com = new SqlCommand(query, conn);
                    com.Parameters.AddWithValue("@ID", TextID.Text);

                    if (com.ExecuteNonQuery() < 0)
                    {
                        LabelMessage.Text = "Error (303). Please contact the admin: Law.Economist@Gmail.com";
                        Global.EmailAdmin("Error 304: Default", "UserID =" + TextID.Text);
                        conn.Close();
                        return;
                    }
                }
                else
                {
                    LabelMessage.Text = "You have already registered.";
                    LabelLogin.Text = "Please use your Worker ID to log in.";
                    TextUser.Text = TextID.Text;
                    BtnLogin.Enabled = true;
                    TextPassword.Focus();
                    conn.Close();
                    return;
                }

            query = "insert into People (ID,Name,CreationTime, Verified, Education,Age,Gender,EnglishSpeaker,Rater) values (@ID, @name, GETDATE(), GETDATE(), @education, @age , @gender , @english ,@rater)";
            #region Execute

            com = new SqlCommand(query, conn);
            com.Parameters.AddWithValue("@ID", TextID.Text);
            com.Parameters.AddWithValue("@name", NickName.Text);
            com.Parameters.AddWithValue("@education", Education.Text);
            com.Parameters.AddWithValue("@age", Age.Text);
            com.Parameters.AddWithValue("@gender", Gender.SelectedIndex);
            com.Parameters.AddWithValue("@english", EnglishSpeaker.Checked);
            com.Parameters.AddWithValue("@rater", false);
            //if (TextExpert.Text == "Grader")
            //{
            //    com.Parameters.AddWithValue("@rater", true);
            //}
            //else
            //    com.Parameters.AddWithValue("@rater", false);
            try
            {
                if (com.ExecuteNonQuery() != 1)
                {
                    LabelMessage.Text = "Error (449). Please contact the admin: Law.Economist@Gmail.com";
                    Global.EmailAdmin("Error 449: Default", "UserID =" + TextID.Text);
                    conn.Close();
                    return;
                }
            }
            catch (Exception Ex)
            {
                LabelMessage.Text = "Error (457). Please contact the admin: Law.Economist@Gmail.com";
                Global.EmailAdmin("Error 457: Default", "UserID =" + TextID.Text + " & Execption = " + Ex);
                conn.Close();
                return;
            }

            #endregion

            Session["Treat"] = 1;
            Session["Group"] = 1;

            #region Nonce +  Password -->  HashP

            query = "select Nonce from People where ID = @ID";            
            com = new SqlCommand(query, conn);
            com.Parameters.AddWithValue("@ID", TextID.Text);

            string Nonce = com.ExecuteScalar().ToString();
            string StringToHash = TextPass.Text + Nonce;
            byte[] ByteArrayToHash = Encoding.UTF8.GetBytes(StringToHash);
            HashAlgorithm algorithm = new SHA256Managed();
            byte[] HashResult = algorithm.ComputeHash(ByteArrayToHash);

            #endregion

            Session["User"] = TextID.Text;
            Session["Active"] = false;

            //LabelMessage.Text = "We sent you an email with subject: Verification";
            //LabelLogin.Text = "Please check your email (" + TextID.Text + ")";
            BtnSignUp.Enabled = false;
            CheckAgree.Checked = false;
            TextPass.Enabled = false;
            TextRPass.Enabled = false;
            // Send Verificatin Email         

            //            string Content = "Hello " + NickName.Text + " ! <br>" +

            //"Thank you for registering to participate in our experiment. <br>" +
            //"Please <a href = 'https://Faculty.McCombs.Utexas.edu/Hamed.Khaledi/Default.aspx?nonce=" + Nonce + "'> Click Here </a>  to verify your email address. <br>" +
            //"If you did not sign up for this experiment, please forward this email to the experimenter: Law.Economist@Gmail.com !";

            //            Global.Email(TextID.Text, "Verification", Content);

            // Assign Treatment Groups:
            query = @"
            SELECT
                Groups.Treatment,
                Groups.Group#,
                COALESCE(Subjects.SubjectCount, 0) AS SubjectCount,
                Treatments.PerGroup,
                Groups.Period
            FROM Groups
            LEFT JOIN (
                SELECT
                    COUNT(People.ID) AS SubjectCount,
                    People.Treatment,
                    People.Group# 
                FROM People 
                WHERE People.Rater <> 1
                GROUP BY People.Treatment, People.Group# 
            ) AS Subjects
                ON Subjects.Treatment=Groups.Treatment AND Subjects.Group# = Groups.Group#
            LEFT JOIN Treatments
                ON Treatments.TID = Groups.Treatment
            WHERE    
                COALESCE(Subjects.SubjectCount, 0) < Treatments.PerGroup    
                AND Groups.Period = 0
                AND COALESCE(Subjects.SubjectCount, 0) = (
                    SELECT
                        MIN(SubjectNumbers.SubjectCount) AS MinCount
                    FROM (
                        SELECT
                            COALESCE(COUNT(People.ID), 0) AS SubjectCount
                        FROM Groups 
                        LEFT JOIN People ON People.Treatment = Groups.Treatment AND People.Group# = Groups.Group# AND People.Rater <> 1
                        LEFT JOIN Treatments ON Treatments.TID = Groups.Treatment
                        GROUP BY Groups.Treatment, Groups.Group#, Groups.Period, Treatments.PerGroup
                        HAVING
                            COALESCE(COUNT(People.ID), 0) < Treatments.PerGroup
                            AND Groups.Period = 0
                    ) AS SubjectNumbers
                )
            ";

            com = new SqlCommand(query, conn);
            var TreatGroup = com.ExecuteReader();
            var TreatmentGroup = new DataTable();
            TreatmentGroup.Load(TreatGroup);
            TreatGroup.Close();
            int Count = TreatmentGroup.Rows.Count;
            if (Count == 0)
            {
                query = @"
            SELECT Groups.Treatment, Groups.Group#, SubjectCount, PerGroup, Groups.Period
            FROM Groups LEFT JOIN (
            		SELECT COUNT(People.ID) AS SubjectCount, People.Treatment, People.Group# 
            		FROM People 
            		WHERE People.Rater<>1
            		GROUP BY People.Treatment, People.Group# 
            		) AS Subjects ON Subjects.Treatment=Groups.Treatment AND Subjects.Group# = Groups.Group#
            		LEFT JOIN Treatments on Treatments.TID = Groups.Treatment
            WHERE (SubjectCount < PerGroup OR SubjectCount IS NULL) AND Groups.Period IS NULL";

                com = new SqlCommand(query, conn);
                TreatGroup = com.ExecuteReader();
                TreatmentGroup = new DataTable();
                TreatmentGroup.Load(TreatGroup);
                TreatGroup.Close();
                Count = TreatmentGroup.Rows.Count;
                if (Count == 0)
                {
                    LabelLogin.Text = "You are too late!";
                    Session["Treat"] = null; Session["Group"] = null;
                    conn.Close();
                    ClientScript.RegisterStartupScript(GetType(), "Attention", "alert('You are too late.\\nThis experiment has already started.');", true);
                    return;
                }
            }
            Random rnd = new Random();
            int RandomRow = rnd.Next(Count);

            Session["Treat"] = (int)TreatmentGroup.Rows[RandomRow][0];
            Session["Group"] = (int)TreatmentGroup.Rows[RandomRow][1];

            // Assign the Treatment Group to the User:
            query = "update People set Treatment = " + Session["Treat"] + ", Group# = " + Session["Group"] + " where ID = @User";
            #region Execute
            com = new SqlCommand(query, conn);
            com.Parameters.AddWithValue("@User", Session["User"].ToString());
            if (com.ExecuteNonQuery() != 1)
            {
                LabelLogin.Text = "Error (162). Please contact the admin: Law.Economist@Gmail.com";
                Global.EmailAdmin("Error 162: Rating", "UserID = " + Session["User"] + " & Treatment = " + Session["Treat"]);
                conn.Close();
                return;
            }
            #endregion

            conn.Close();
            // A Participant with a Treatment Group: -->                           
            int Period = Global.Refresh((int)Session["Treat"], (int)Session["Group"], out DateTime DT);

            if (Period < -10) // Experiment Ended
            {
                LabelLogin.Text = "Your experiment has ended.";
                Session["User"] = null;
                return;
            }
            else if (Period == -9) // Null : Experiment Not Started 
            {
                LabelLogin.Text = "Your experiment has not started yet.";
                Session["User"] = null;
                return;
            }
            else if (Period == 0 || !Session["Active"].Equals(true)) // Period = 0 or Participant not active yet                            
                Response.Redirect("~/Constitution.aspx");

            else if (Period == -1 || Period == -2) // Final Period and Participant is active                
                Response.Redirect("~/Survey.aspx");

            else if (Period % 2 == 1)  // Suggestion Period and Participant is active
                Response.Redirect("~/Suggestion.aspx");

            else  // if (Period % 2 == 0) // Voting Period and participant is active
                Response.Redirect("~/Voting.aspx");
        }
    }
}