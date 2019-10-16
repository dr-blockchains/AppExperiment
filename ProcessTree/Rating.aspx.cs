using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace ProcessTree
{
    public partial class Rating : System.Web.UI.Page
    {
        private bool NextFinal() // It shows the Final Edition of the next reatment for the rater.
        {
            BtnSubmitScore.Enabled = false;

            SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["ProcessTreeConnectionString"].ConnectionString);
            conn.Open();

            string query = @"

SELECT Groups.Treatment, Groups.Group# 
FROM Groups 
WHERE Groups.Period IN (-1 ,-11) 
  AND NOT EXISTS ( select Rating.Treatment, Rating.Group# 
                         from Rating
                         where Rating.RatingUser = @RUser
                           and Rating.Treatment = Groups.Treatment
                           and Rating.Group# = Groups.Group# ) ";

            // and FinalScore is not null

            //AND EXISTS (select *
            //                  from Versions
            //                  where (Versions.Treatment = Groups.Treatment)
            //                    and(Versions.Group# =  Groups.Group#) 
            //          and(Choice = 0)
            //                    and(Proposer <> 'experimenter'))

            #region Execute
            var com = new SqlCommand(query, conn);
            com.Parameters.AddWithValue("@RUser", Session["User"]);
            var TreatGroup = com.ExecuteReader();                           
            var TreatmentGroup = new DataTable();
            TreatmentGroup.Load(TreatGroup);
            TreatGroup.Close();
            int Count = TreatmentGroup.Rows.Count;
            #endregion

            if (Count == 0)
            {
                LabelLogin.Text += " Please come back later!";
                LabelMessage.Text = "Thank you!";
                txtArtifact.Text = "You have rated all final editions so far.";
                Label.Text = "No more final edition!";
                RadioScore.Enabled = false;
                conn.Close();
                return false;
            }

            Random rnd = new Random();
            int RandomRow = rnd.Next(Count);

            int TreatFinal = (int)TreatmentGroup.Rows[RandomRow][0];
            int GroupFinal = (int)TreatmentGroup.Rows[RandomRow][1];            
            
            query = "select top 1 Artifact from Versions where (Treatment = " + TreatFinal + ") and (Group# = "+ GroupFinal +" ) and (Choice = 0) and (Proposer <> 'experimenter') order by Period desc";
            #region Execute
            com = new SqlCommand(query, conn);
            object Artifact = com.ExecuteScalar();
            #endregion

            if (Artifact == null)
            {
                #region Error
                txtArtifact.Text = "No winner for treatment " + TreatFinal + " , Group " + GroupFinal;
                LabelMessage.Text = "Error (42) Please contact the admin: Law.Economist@Gmail.com";
                Global.EmailAdmin("Error 42: Rating", "UserID = " + Session["User"] + " & Treatment = " + TreatFinal + " & Group = " + GroupFinal);
                return false;
                #endregion
            }
            else
            {
                txtArtifact.Text = Artifact.ToString();
                Label.Text = "Final Edition of Treatment " + TreatFinal + " Group " + GroupFinal;
                Session["Treat"] = TreatFinal;
                Session["Group"] = GroupFinal;                
            }      

            conn.Close();
            return true;            
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["User"] == null)
                Response.Redirect("~/Default.aspx");

            if (!IsPostBack)
            {
                #region User Data


                BtnSubmitScore.Enabled = false;
                RadioScore.Enabled = true;

                LabelMessage.Text = "";

                SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["ProcessTreeConnectionString"].ConnectionString);
                conn.Open();

                string query = "select * from People where ID = @User";
                SqlCommand com = new SqlCommand(query, conn);
                com.Parameters.AddWithValue("@User", Session["User"]);
                SqlDataReader User = com.ExecuteReader();
                if (!User.Read())
                    Response.Redirect("~/Default.aspx");

                if (!User["Completed"].Equals(DBNull.Value) || !User["Rater"].Equals(true))
                {
                    LabelLogin.Text = "Error (47). Please contact the admin: Law.Economist@Gmail.com";
                    Global.EmailAdmin("Error 47: Rating", "UserID = " + Session["User"] + " & Treatment = " + User["ID"]);
                    LabelBalance.Text = Session["User"].ToString();
                    RadioScore.Enabled = false;
                    conn.Close();
                    return;
                }

                LabelLogin.Text = "Hi <em>" + User["Name"] + "<em> !";
                LabelBalance.Text = "Your Balance = $ " + ((float)User["Balance"]).ToString("N2");                              

                object InitialScore = User["InitialScore"];
                RadioScore.SelectedValue = InitialScore.ToString();

                #endregion

                User.Close();

                query = "SELECT TOP 1 Treatment, Group#, DATEADD(minute, (Tz+Tf), Starting) AS Ending FROM Groups LEFT JOIN Treatments on Treatments.TID = Groups.Treatment ORDER BY Ending DESC";
                com = new SqlCommand(query, conn);
                var TreatGroup = com.ExecuteReader();
                if (!TreatGroup.Read())
                {
                    LabelLogin.Text += " Please come back later!";
                    txtArtifact.Text = "The experiment has not started yet. Please wait until a treatment group becomes available.";
                    Label.Text = " ";
                    RadioScore.Enabled = false;
                    conn.Close();
                    return;
                }

                object LastTreat = TreatGroup["Treatment"];
                object LastGroup = TreatGroup["Group#"];
                Session["Ending"] = TreatGroup["Ending"];

                TreatGroup.Close();

                if (InitialScore.Equals(DBNull.Value))
                {
                    Label.Text = "Initial Edition: ";

                    Session["Treat"] = null;
                    Session["Group"] = null;

                    query = "select Artifact from Versions where (Treatment = " + LastTreat + " and Group# = " + LastGroup + " and Period = 2 and Choice = 0 )";
                    #region Execute and Show Initial Edition

                    com = new SqlCommand(query, conn);

                    object InitialArtifact = com.ExecuteScalar();

                    if (InitialArtifact == null)
                    {
                        LabelLogin.Text = "Error (175). Please contact the admin: Law.Economist@Gmail.com";
                        Global.EmailAdmin("Error 175: Rating", "UserID = " + Session["User"] + " <br> Treatment = " + LastTreat + " <br> Group = " + LastGroup);
                    }
                    else
                        txtArtifact.Text = InitialArtifact.ToString();

                    #endregion
                }
                else
                    NextFinal();

                // Initialize the timer: **********************************************************************
                                                             
                if ((DateTime)Session["Ending"] < DateTime.Now)
                {
                    LabelMessage.Text = "All experiments have ended.";
                    Session["User"] = null;
                    BtnSubmitScore.Enabled = false;
                    conn.Close();
                    return;
                }
                
                conn.Close();
            }

            // Timer when postback:
            TimeSpan.Text = ((DateTime)Session["Ending"] - DateTime.Now).TotalMilliseconds.ToString();                            
        }

        protected void BtnSubmitScore_Click(object sender, EventArgs e)
        {
            #region Preparation

            if (Session["User"] == null)            
                Response.Redirect("~/Default.aspx");

            BtnSubmitScore.Enabled = false;

            int Score = RadioScore.SelectedIndex + 1;            
            if (Score <= 0)
            {
                LabelMessage.Text = "Please Select a Rating Score.";                                           
                return;
            }

            SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["ProcessTreeConnectionString"].ConnectionString);
            string query;
            SqlCommand com;

            conn.Open();

            #endregion        
            
            if (Session["Treat"] == null || Session["Group"] == null) // Initial: *****************************************            
                query = "update People set InitialScore = " + Score + " where ID = @RUser";
            else                                                      // Final: *******************************************
            { 
                query = "select FinalScore from Rating where Treatment = " + Session["Treat"] + " and Group# = " + Session["Group"] + " and RatingUser = @RUser";
                com = new SqlCommand(query, conn);
                com.Parameters.AddWithValue("@RUser", Session["User"]);

                object SavedScore = com.ExecuteScalar();

                if (SavedScore == null)
                    query = "insert into Rating (Treatment , Group# , RatingUser , FinalScore) Values (" + Session["Treat"] + " ," + Session["Group"] + " , @RUser , " + Score + ")";
                else
                    query = "update Rating set FinalScore = " + Score + " where Treatment = " + Session["Treat"] + " and Group# = " + Session["Group"] + " and RatingUser = @RUser";
            }

            #region Execution

            com = new SqlCommand(query, conn);
            com.Parameters.AddWithValue("@RUser", Session["User"]);
            try
            {
                if (com.ExecuteNonQuery() != 1)
                {
                    LabelMessage.Text = "Error (248). Please contact the admin: Law.Economist@Gmail.com";
                    Global.EmailAdmin("Error 248: Rating", "UserID = " + Session["User"] + " & Treatment = " + Session["Treat"] + " & Group = " + Session["Group"]);
                    conn.Close();
                    return;
                }
            }
            catch(Exception Ex)
            {
                LabelMessage.Text = "Error (256). Please contact the admin: Law.Economist@Gmail.com";
                Global.EmailAdmin("Error 256: Rating", "UserID = " + Session["User"] + " & Treatment = " + Session["Treat"] + " & Group = " + Session["Group"] + " & Execption = " + Ex);
                conn.Close();
                return;
            }            
            #endregion
            
            BtnSubmitScore.Enabled = NextFinal();
            
            conn.Close();
            return;           
        }

        protected void RadioScore_SelectedIndexChanged(object sender, EventArgs e)
        {
            BtnSubmitScore.Enabled = true;
        }

        protected void BtnSignOut_Click(object sender, EventArgs e)
        {
            Session["User"] = null;
            Response.Redirect("~/Default.aspx");
        }
    }
}