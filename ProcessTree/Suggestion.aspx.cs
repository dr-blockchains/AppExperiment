using System;
using System.Data.SqlClient;
using System.Configuration;
using System.Collections.Generic;
using DiffPlex;

namespace ProcessTree
{
    public partial class Suggestion : System.Web.UI.Page
    {   
        public string HTMLDiffStrings(string OldString, string NewString)
        {
            var DiffClass = new Differ();
            char[] DiffSeparators = { ' ', '\r', '\n', '\t' };
            DiffPlex.Model.DiffResult AllDiffs = DiffClass.CreateWordDiffs(OldString, NewString, false, DiffSeparators);
            string ReturnString = "";
            string DebugOutput = "\"Old\"\r\n";
            foreach (string piece in AllDiffs.PiecesOld)
            {
                DebugOutput += "\"" + piece.Replace("\r", "\\r").Replace("\n", "\\n").Replace("\"", "\"\"") + "\"\r\n";
            }
            DebugOutput += "\r\n\"New\"\r\n";
            foreach (string piece in AllDiffs.PiecesNew)
            {
                DebugOutput += "\"" + piece.Replace("\r", "\\r").Replace("\n", "\\n").Replace("\"", "\"\"") + "\"\r\n";
            }
            List<int> DeletedStarts = new List<int>();
            List<int> DeletedCounts = new List<int>();
            List<int> InsertedStarts = new List<int>();
            List<int> InsertedCounts = new List<int>();
            DebugOutput += "\r\n\"DeleteStartA\",\"DeleteCountA\",\"InsertStartB\",\"InsertCountB\"\r\n";
            foreach (DiffPlex.Model.DiffBlock block in AllDiffs.DiffBlocks)
            {
                DeletedStarts.Add(block.DeleteStartA);
                DeletedCounts.Add(block.DeleteCountA);
                InsertedStarts.Add(block.InsertStartB);
                InsertedCounts.Add(block.InsertCountB);
                DebugOutput += block.DeleteStartA.ToString() + "," + block.DeleteCountA.ToString() + "," + block.InsertStartB.ToString() + "," + block.InsertCountB.ToString() + "\r\n";
            }
            DebugOutput += "\r\n\"ReturnString\"\r\n";
            for (int i = 0; i < AllDiffs.PiecesOld.Length; i++)
            {
                if (DeletedStarts.Contains(i))
                {
                    int DiffBlockNumber = DeletedStarts.IndexOf(i);
                    int RunStart = i;
                    if (DeletedCounts[DiffBlockNumber] > 0 && InsertedCounts[DiffBlockNumber] <= 0 )
                    {
                        // Words were removed.
                        ReturnString += "<span class=\"diff-del diff-delnohover\">";
                        for (int j = RunStart; j < RunStart + DeletedCounts[DiffBlockNumber]; j++)
                        {
                            //The following line would show deleted words.
                            ReturnString += AllDiffs.PiecesOld[j].Replace("\r","").Replace("\n","<br>").Replace("\t","&nbsp;&nbsp;&nbsp;&nbsp;");
                            i++;
                        }
                        //ReturnString += "__";
                        ReturnString += "</span>";
                    }
                    else if (DeletedCounts[DiffBlockNumber] > 0) {
                        i += DeletedCounts[DiffBlockNumber];
                    }
                    if (InsertedCounts[DiffBlockNumber] > 0)
                    {
                        //Words were added.
                        ReturnString += "<span class=\"diff-add diff-addnohover\">";
                        //ReturnString += "<b>";
                        for (int j = InsertedStarts[DiffBlockNumber]; j < InsertedStarts[DiffBlockNumber] + InsertedCounts[DiffBlockNumber]; j++)
                        {
                            ReturnString += AllDiffs.PiecesNew[j].Replace("\r","").Replace("\n", "<br>").Replace("\t", "&nbsp;&nbsp;&nbsp;&nbsp;");
                        }
                        ReturnString += "</span>";
                        //ReturnString += "</b>";
                    }
                }
                if (i < AllDiffs.PiecesOld.Length)
                {
                    //These words have not changed. Make sure that the most recent block didn't consume all remaining words.
                    ReturnString += AllDiffs.PiecesOld[i].Replace("\r", "").Replace("\n", "<br>").Replace("\t", "&nbsp;&nbsp;&nbsp;&nbsp;");
                }

            }
            if (DeletedStarts.Contains(AllDiffs.PiecesOld.Length))
            {
                //There is one final insert at the end. The number of deletions will be zero.
                int DiffBlockNumber = DeletedStarts.IndexOf(AllDiffs.PiecesOld.Length);
                if (InsertedCounts[DiffBlockNumber] > 0) //Probably not a necessary check.
                {
                    ReturnString += "<span class=\"diff-add diff-addnohover\">";
                    //ReturnString += "<b>";
                    for (int j = InsertedStarts[DiffBlockNumber]; j < InsertedStarts[DiffBlockNumber] + InsertedCounts[DiffBlockNumber]; j++)
                    {
                        ReturnString += AllDiffs.PiecesNew[j].Replace("\r", "").Replace("\n", "<br>").Replace("\t", "&nbsp;&nbsp;&nbsp;&nbsp;");
                    }
                    ReturnString += "</span>";
                    //ReturnString += "</b>";
                }
            }
            DebugOutput += "\"" + ReturnString.Replace("\r","\\r").Replace("\n","\\n").Replace("\"","\"\"") + "\"\r\n";
            return ReturnString;
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["User"] == null)
                Response.Redirect("~/Default.aspx");

            if (IsPostBack)
            {
                TimeSpan.Text = ((DateTime)Session["DT"] - DateTime.Now).TotalMilliseconds.ToString();
                return;
            }
            
            BtnCancel_Click(sender, e);
        }

        protected void BtnCancel_Click(object sender, EventArgs e)
        {
            #region User

            SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["ProcessTreeConnectionString"].ConnectionString);
            conn.Open();

            string query = "select * from People where ID = @User";
            SqlCommand com = new SqlCommand(query, conn);
            com.Parameters.AddWithValue("@User", Session["User"]);

            SqlDataReader User = com.ExecuteReader();
            
            if (!User.Read() || User["Rater"].Equals(true) ||
                User["Qualificationtime"].Equals(DBNull.Value) ||
                User["Treatment"].Equals(DBNull.Value)||
                Session["Treat"] == null ||
                Session["Group"] == null ||
                User["Group#"].Equals(DBNull.Value) ||
                !User["Completed"].Equals(DBNull.Value))
            {
                conn.Close();
                Response.Redirect("~/Default.aspx");
                return;
            }

            float UserBalance = (float)User["Balance"];
            LabelBalance.Text = "Hi " + User["Name"] + ((UserBalance == 0.0)? " !" : " ! Your Balance =  $ " + UserBalance.ToString("N2") );

            LabelLogin.Text = "Please improve this plan in NotePad then paste it back here. Make sure your submission is valid!";
            Session["Suspended"] = User["Suspended"].Equals(DBNull.Value) ? DateTime.MinValue :(DateTime)User["Suspended"];

            #endregion
            User.Close();

            #region Periods

            int Period = Global.Refresh((int)Session["Treat"], (int)Session["Group"], out DateTime DT);

            CurrentPeriod.Text = Period.ToString();

            if (Period == 0 || Period == -9)
            {
                txtArtifact.Text = "Error (86) \n Please contact the admin: Law.Economist@Gmail.com";
                Global.EmailAdmin("Error 86: Suggestion", "UserID = " + Session["User"] + " & Treatment = " + Session["Treat"]);

                // BtnCancel.Enabled = false;
                txtArtifact.Enabled = false;
                Session["User"] = null;
                conn.Close();
                return;
            }
            if (Period < -10)
            {
                txtArtifact.Text = "If you have any question, concern or suggestion, please contact the Admin: Khaledi @bus.msu.edu";
                LabelVersion.Text = "Your experiment has ended!";

                BtnSubmit.Enabled = false;
                BtnCancel.Enabled = false;
                txtArtifact.Enabled = false;                
                Session["User"] = null;
                conn.Close();
                return;
            }
            if (Period == -1 || Period == -2 )
            {
                conn.Close();
                // Session["Notification"] = "The process has finished. \\n Please complete the final survey.";
                Response.Redirect("~/Survey.aspx");                            
            }
            else if (Period % 2 == 0)
            {
                conn.Close();
                // Session["Notification"] = "The suggestion period has finished. \\n Please read the versions and vote.";
                Response.Redirect("~/Voting.aspx");                                             
            }

            #endregion
            
            query = "select * from Treatments where TID = " + Session["Treat"];
            #region Execute
            com = new SqlCommand(query, conn);
            SqlDataReader Treatment = com.ExecuteReader();
            if (!Treatment.Read() || Treatment["Constitution"].Equals(DBNull.Value))
            {
                txtArtifact.Text = "Error (63). Please contact the admin: Law.Economist@Gmail.com";
                Global.EmailAdmin("Error 63: Suggestion", "UserID = " + Session["User"] + " & Treatment = " + Session["Treat"]);
                conn.Close();
                return;
            }            
            #endregion   

            ConstitutionBox.Text = Treatment["Constitution"].ToString();
            Session["M"] = Treatment["M"];
            Session["Tv"] = Treatment["Tv"];
            float Tz = (float)Treatment["Tz"];
            Session["SuggestionFee"] = Treatment["SuggestionFee"];
            Session["Valuation"] = Treatment["Valuation"];

            Treatment.Close();

            query = "select * from Groups where Treatment = " + Session["Treat"] + " and Group# = " + Session["Group"];
            #region Execute
            com = new SqlCommand(query, conn);
            SqlDataReader Groups = com.ExecuteReader();
            if (!Groups.Read())
            {
                txtArtifact.Text = "Error (63). Please contact the admin: Law.Economist@Gmail.com";
                Global.EmailAdmin("Error 63: Suggestion", "UserID = " + Session["User"] + " & Treatment = " + Session["Treat"]);
                conn.Close();
                return;
            }
            #endregion

            Session["Closing"] = ((DateTime)Groups["Starting"]).AddMinutes(Tz);
            Session["DT"] = ((int)Session["M"] > 1 ? DT : Session["Closing"]);
            Groups.Close();

            if ((float)Session["SuggestionFee"] > 0)            
                LabelLogin.Text = "Submission fee is $" + (float)Session["SuggestionFee"];                              

            // The Current Updated edition:
            query = "select * from Versions where Treatment = " + Session["Treat"] + " and Group# = " + Session["Group"] + " and Period = " + (Period + 1) + " and Choice = 0 ";
            #region Execute
            com = new SqlCommand(query, conn);
            SqlDataReader Version = com.ExecuteReader();

            if (!Version.Read())
            {
                LabelLogin.Text = "Error (119). \n Please contact the admin: Law.Economist@Gmail.com";
                Global.EmailAdmin("Error 119: Suggestion", "UserID = " + Session["User"] + " & Treatment = " + Session["Treat"]);
                txtArtifact.Enabled = false;
                conn.Close();
                return;
            }
            #endregion            
            Session["CurrentEdition"] = Version["Artifact"].ToString().Trim();
            string ProposerofCurrent = Version["Proposer"].ToString();
            Version.Close();
            
            // The Current Updated proposer:
            query = "select Name from People where ID = @ID";
            #region Execute
            com = new SqlCommand(query, conn);
            com.Parameters.AddWithValue("@ID", ProposerofCurrent);
            #endregion                        
              
            string ProposerCurrentEdition = (com.ExecuteScalar() ?? "Anonymous").ToString();

            // Already proposed?
            query = "select * from Versions where Treatment = " + Session["Treat"] + " and Group# = " + Session["Group"] + " and Period = " + (Period + 1) + " and Proposer = @User and choice <> 0 ";
            #region Execute
            com = new SqlCommand(query, conn);
            com.Parameters.AddWithValue("@User", Session["User"]);
            Version = com.ExecuteReader();
            #endregion

            if (Version.Read())
            {
                DateTime VersionTime = ((DateTime)Version["Time"]);
                if (VersionTime.Date == DateTime.Now.Date)
                    LabelVersion.Text = "You suggested the following at " + VersionTime.ToString(Global.TimeFormat) + " :";                
                else
                    LabelVersion.Text = "You suggested the following on " + VersionTime.ToString(Global.DateFormat) + " :";

                LabelLogin.Text = "Please make sure your submission is valid and feasible and has accurate numbers!";

                if (BtnCancel.Text.Equals("Edit Submission"))
                {
                    LabelArtifact.Visible = false;
                    txtArtifact.Visible = true;
                    txtArtifact.Enabled = true;
                    BtnSubmit.Enabled = true;
                    BtnSubmit.Text = "Submit Suggestion";
                    BtnCancel.Text = "Cancel Changes";
                    txtArtifact.Text = (string)Version["Artifact"];
                }
                else
                {
                    LabelArtifact.Visible = true;
                    txtArtifact.Visible = false;
                    txtArtifact.Enabled = false;
                    BtnSubmit.Enabled = false;
                    BtnSubmit.Text = "Thanks!";
                    BtnCancel.Text = "Edit Submission";
                    LabelArtifact.Text = (string)Version["HtmlArtifact"];
                }

                // TimeSpan.Text = (DT - DateTime.Now).TotalMilliseconds.ToString();
            }
            else
            {
                if (ProposerofCurrent == "experimenter")
                {
                    LabelVersion.Text = "Initial Edition :";
                    ClientScript.RegisterStartupScript(GetType(), "Attention", "notify('Please type your plan in NotePad (or another text editor), then paste it back into the yellow box! The page may refresh at any time.');", true);
                }
                else
                {
                    //LabelVersion.Text = (ProposerofCurrent == "experimenter" ? "Initial Edition :" : "Current Updated Edition (by " + ProposerCurrentEdition + " ) :");
                    LabelVersion.Text = "Current Updated Edition (by " + ProposerCurrentEdition + " ) :";
                    ClientScript.RegisterStartupScript(GetType(), "Attention", "notify('The plan suggested by " + ProposerCurrentEdition + " won and became the Updated Edition.');", true);
                }               

                LabelArtifact.Visible = false;
                txtArtifact.Visible = true;
                txtArtifact.Enabled = true;
                BtnSubmit.Enabled = true;
                BtnSubmit.Text = "Submit Suggestion";
                txtArtifact.Text = (string)Session["CurrentEdition"];
            }
            
            if (DateTime.Now < (DateTime)Session["Suspended"])
            {
                txtArtifact.Enabled = false;
                BtnSubmit.Enabled = false;
                LabelLogin.Text = "Your suggestion was the least voted choice. Hence you cannot submit suggestion now.<br>It doesn't affect your voting rights or rewards.";

                if((DateTime)Session["Suspended"] < (DateTime)Session["Closing"])
                {
                    DeadLineMessage.Text = "You may suggest after ";
                    TimeSpan.Text = ((DateTime)Session["Suspended"] - DateTime.Now).TotalMilliseconds.ToString();
                }
                else
                {
                    DeadLineMessage.Text = "Game ends at ";
                    TimeSpan.Text = ((DateTime)Session["Closing"] - DateTime.Now).TotalMilliseconds.ToString();
                }
            }
            else if (((DateTime)Session["DT"] < (DateTime)Session["Closing"]) && (int)Session["M"] > 1)
            {
                DeadLineMessage.Text = "Waiting for"+ ((int)Session["M"] < 99?(" total of " + Session["M"]) :"") + " suggestions until";
                TimeSpan.Text = ((DateTime)Session["DT"] - DateTime.Now).TotalMilliseconds.ToString();
            }
            else // Closing <= DT
            {
                DeadLineMessage.Text = "Waiting for one suggestion. Game ends at ";
                TimeSpan.Text = ((DateTime)Session["Closing"] - DateTime.Now).TotalMilliseconds.ToString();
            }


            if ((float)Session["SuggestionFee"] > UserBalance)
            {
                LabelLogin.Text = "Not enough balance to submit suggestion!";
                BtnSubmit.Enabled = false;
                txtArtifact.Enabled = false;
            }

            txtArtifact.Focus();

            conn.Close();           
        }

        protected void BtnSubmit_Click(object sender, EventArgs e)
        {
            if (Session["User"] == null)
                Response.Redirect("~/Default.aspx");

            txtArtifact.Text = txtArtifact.Text.Trim();

            if ((string)Session["CurrentEdition"] == txtArtifact.Text)
            {                
                ClientScript.RegisterStartupScript(GetType(), "Attention", "alert('You cannot submit the same plan without change!');", true);
                txtArtifact.Focus();
                return;
            }

            if(txtArtifact.Text.Length < 50 || txtArtifact.Text.Length > 2000)
            {
                ClientScript.RegisterStartupScript(GetType(), "Attention", "alert('The plan should be between 50 and 2000 characters!');", true);
                txtArtifact.Focus();
                return;
            }

            BtnSubmit.Enabled = false;
            BtnSubmit.Text = "Thanks!";
            BtnCancel.Text = "Edit Submission";
            BtnCancel.Focus();

            #region Periods

            int Period = Global.Refresh((int)Session["Treat"], (int)Session["Group"], out DateTime DT);
            Session["DT"] = ((int)Session["M"] > 1 ? DT : Session["Closing"]);

            if (Period < -10)
            {
                LabelVersion.Text = "Your experiment has ended!";
                BtnCancel.Enabled = false;
                txtArtifact.Enabled = false;
                txtArtifact.Text = "If you have any question, concern or suggestion, please contact the Admin: Khaledi @bus.msu.edu";
                Session["User"] = null;
                ClientScript.RegisterStartupScript(GetType(), "Attention", "alert('Your experiment has concluded!');window.location.href='/Default.aspx';", true);
                return;                
            }
            if (Period == -1 || Period == -2)
            {
                // ClientScript.RegisterStartupScript(GetType(), "Attention", "alert('The suggestion period has finished. \\n We are in Final period now.');window.location.href='/Survey.aspx';", true);
                Response.Redirect("~/Survey.aspx");                          
            }
            else if (Period % 2 == 0)
            {
                //ClientScript.RegisterStartupScript(GetType(), "Attention", "alert('The suggestion period has finished. \\n We are in Voting period now.');window.location.href='/Voting.aspx';", true);
                Response.Redirect("~/Voting.aspx");                
            }

            #endregion         

            SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["ProcessTreeConnectionString"].ConnectionString);
            conn.Open();
            string query;
            SqlCommand com;
            
            if (DateTime.Now < (DateTime)Session["Suspended"])
            {
                LabelLogin.Text = "Your suggestion was the least voted choice. Hence you cannot submit suggestion now.<br>It doesn't affect your voting rights or rewards.";
                ClientScript.RegisterStartupScript(GetType(), "Attention", "alert('Your suggestion was the least voted choice. Hence you cannot submit suggestion now.\\nIt doesn't affect your voting rights or rewards.');window.location.href='/Default.aspx';", true);
                txtArtifact.Enabled = false;
                BtnSubmit.Enabled = false;
                conn.Close();
                return;
            }           

            // Highligght the differences:
            string SuggestionHTML = HTMLDiffStrings((string)Session["CurrentEdition"], txtArtifact.Text.Trim());
            LabelArtifact.Text = SuggestionHTML;
            LabelArtifact.Visible = true;
            txtArtifact.Visible = false;
            txtArtifact.Enabled = false;

            // Already proposed?
            query = "select * from Versions where Treatment = " + Session["Treat"] + " and Group# = " + Session["Group"] + " and Period=" +(Period+1)+ " and Proposer=@User and Choice <> 0";
            #region Execute
            com = new SqlCommand(query, conn);
            com.Parameters.AddWithValue("@User", Session["User"]);
            SqlDataReader Version = com.ExecuteReader();
            #endregion

            if (Version.Read())
            {
                LabelVersion.Text = "You changed your suggestion to:";               

                query = "UPDATE Versions SET Artifact = @Artifact, Time = GETDATE(), HtmlArtifact = @HtmlArtifact " +
                    "WHERE Treatment = @Treatment AND Group# = @Group AND Period = @Period AND Choice = @Choice";

                com = new SqlCommand(query, conn);

                com.Parameters.AddWithValue("@Treatment", Session["Treat"]);
                com.Parameters.AddWithValue("@Group", Session["Group"]);
                com.Parameters.AddWithValue("@Period", Period + 1);
                com.Parameters.AddWithValue("@Choice", Version["Choice"]);
                com.Parameters.AddWithValue("@Artifact", txtArtifact.Text.Trim());
                com.Parameters.AddWithValue("@HtmlArtifact", SuggestionHTML);
                //com.Parameters.AddWithValue("@Time", DateTime.Now);

                Version.Close();

                if (com.ExecuteNonQuery() != 1)
                {
                    LabelLogin.Text = "Error (405). \n Please contact the admin: Law.Economist@Gmail.com";
                    Global.EmailAdmin("Error 405: Suggestion", "UserID = " + Session["User"] + " & Treatment = " + Session["Treat"]);                  
                }

                conn.Close();
                return;
            }
                                   
            Version.Close();

            if ((float)Session["SuggestionFee"] > 0)
            {
                query = "select Balance from People where ID = @Proposer";
                com = com = new SqlCommand(query, conn);
                com.Parameters.AddWithValue("@Proposer", Session["User"]);
                object Balance = com.ExecuteScalar();
                if (Balance == null || (float)Session["SuggestionFee"] > (float)Balance)
                {
                    LabelLogin.Text = "You do not have enough balance to submit suggestion.";
                    BtnSubmit.Enabled = false;
                    conn.Close();
                    return;
                }

                LabelLogin.Text = "You spent $" + (float)Session["SuggestionFee"] + " to Submit Suggestion.";
                LabelBalance.Text = "Your Balance = $" + ((float)Balance - (float)Session["SuggestionFee"]).ToString("N2");

                query = "update People set Balance = Balance - " + (float)Session["SuggestionFee"] + " where ID = @Proposer";
                #region Execute
                com = new SqlCommand(query, conn);
                com.Parameters.AddWithValue("@Proposer", Session["User"]);
                if (com.ExecuteNonQuery() != 1)
                {
                    LabelLogin.Text = "Error (289). Please contact the admin: Law.Economist@Gmail.com";
                    Global.EmailAdmin("Error 289: Voting", "UserID = " + Session["User"] + " & Treatment = " + Session["Treat"] + " & Period = " + Period);
                    conn.Close();
                    return;
                }
                #endregion
            }

            LabelVersion.Text = "You submitted the following plan:";
            LabelLogin.Text = "Make sure your submission is valid and feasible and has accurate numbers!";

            // Number of versions in this period:
            query = "select count(*) from Versions where Treatment = " + Session["Treat"] + " and Group# = " + Session["Group"] + " and Period = " + (Period + 1);
            #region Execute  
            com = new SqlCommand(query, conn);
            int m = (int)com.ExecuteScalar();

            if (m < 1 || m > (int)Session["M"] || ((DateTime)Session["Closing"] <= (DateTime)Session["DT"] && m > 1))
            {
                LabelLogin.Text = "There are " + m + " versions in this period.";
                // LabelVersion.Text = "Error (439). Please contact the admin: Law.Economist@Gmail.com";
                Global.EmailAdmin("Error 439: Suggestion", "UserID = " + Session["User"] + " & Treatment = " + Session["Treat"] + " & m = " + m + " & Closing = " + Session["Closing"]);

                Period++;
                DT = DateTime.Now.AddMinutes((float)Session["Tv"]);

                query = "update Groups set Period=" + Period + " , DT='" + DT + "' where Treatment=" + Session["Treat"] + " and Group#=" + Session["Group"];
                #region Execute
                com = new SqlCommand(query, conn);
                if (com.ExecuteNonQuery() != 1)
                {
                    LabelLogin.Text = "Error (449). \n Please contact the admin: Law.Economist@Gmail.com";
                    Global.EmailAdmin("Error 449: Suggestion", "UserID = " + Session["User"] + " & Treatment = " + Session["Treat"]);
                }
                #endregion

                conn.Close();
                Response.Redirect("~/Voting.aspx");
                // ClientScript.RegisterStartupScript(GetType(), "Attention", "alert('Thanks! A voting period begins now. \\n Your suggestion is the last one in the list.'); window.location.href='/Voting.aspx';", true);
            }
            #endregion

            #region Insert suggestion as a new version:
            query = @"INSERT INTO Versions (Treatment, Group#, Period, Choice, Artifact, HtmlArtifact, Proposer, Time, Score) 
                Values (@Treatment, @Group, @Period, @Choice, @Artifact, @HtmlArtifact, @Proposer, GETDATE(), 0)";

            com = new SqlCommand(query, conn);

            com.Parameters.AddWithValue("@Treatment", Session["Treat"]);
            com.Parameters.AddWithValue("@Group", Session["Group"]);
            com.Parameters.AddWithValue("@Period", Period+1);
            com.Parameters.AddWithValue("@Choice", m);
            com.Parameters.AddWithValue("@Artifact", txtArtifact.Text.Trim());
            com.Parameters.AddWithValue("@HtmlArtifact", SuggestionHTML);
            com.Parameters.AddWithValue("@Proposer", Session["User"]);
            
            try
            {
                if (com.ExecuteNonQuery() != 1)
                {             
                    Global.EmailAdmin("Error 519: Suggestion", "UserID = " + Session["User"] + " & Treatment = " + Session["Treat"]);
                    conn.Close();
                    return;
                }
            }
            catch (Exception Ex)
            {                
                Global.EmailAdmin("Error 527: Suggestion", "UserID = " + Session["User"] + " & Treatment = " + Session["Treat"] + " & Exception = " + Ex);

                if (m >= (int)Session["M"] || ((DateTime)Session["Closing"] <= (DateTime)Session["DT"]))
                {                    
                    conn.Close();
                    Response.Redirect("~/Voting.aspx");
                }

                m++;

                LabelLogin.Text = "Please submit again!";

                conn.Close();                
                return;
            }
                       
            //if((short) Session["Valuation"] == 10)
            //{
            //    query = @"EXEC Fork @Treatment, @Group, @Period, @Choice";

            //    com = new SqlCommand(query, conn);

            //    com.Parameters.AddWithValue("@Treatment", Session["Treat"]);
            //    com.Parameters.AddWithValue("@Group", Session["Group"]);
            //    com.Parameters.AddWithValue("@Period", Period +1 );
            //    com.Parameters.AddWithValue("@Choice", m);
            //    if (com.ExecuteNonQuery() < 2)
            //    {
            //        Global.EmailAdmin("Error 605: Suggestion", "UserID = " + Session["User"] + " & Treatment = " + Session["Treat"]);
            //        conn.Close();
            //        return;
            //    }
            //}

            #endregion

            // Whether it just became enough to close the suggestion period:
            if (m >= (int)Session["M"] || ((DateTime)Session["Closing"] <= (DateTime)Session["DT"]))
            {
                Period++;           
                DT = DateTime.Now.AddMinutes((float)Session["Tv"]);

                query = "update Groups set Period=" + Period + " , DT='" + DT + "' where Treatment=" + Session["Treat"] + " and Group#=" + Session["Group"];
                #region Execute
                com = new SqlCommand(query, conn);
                if (com.ExecuteNonQuery() != 1)
                {
                    LabelLogin.Text = "Error (352). \n Please contact the admin: Law.Economist@Gmail.com";
                    Global.EmailAdmin("Error 352: Suggestion", "UserID = " + Session["User"] + " & Treatment = " + Session["Treat"]);

                    conn.Close();
                    return;
                }
                #endregion

                // Global.InviteVoting((int)Session["Treat"], (int)Session["Group"], DT);
                // Update Offer 0
                // Update Transaction 0
                
                if(Session["Valuation"].Equals(10))
                {
                    query = "EXEC StartTrading @Treatment, @Group, @Period";
                    com = new SqlCommand(query, conn);

                    com.Parameters.AddWithValue("@Treatment", Session["Treat"]);
                    com.Parameters.AddWithValue("@Group", Session["Group"]);
                    com.Parameters.AddWithValue("@Period", Period);
                    if (com.ExecuteNonQuery() < 3)
                    {
                        Global.EmailAdmin("Error 643: Suggestion", "UserID = " + Session["User"] + " & Treatment = " + Session["Treat"]);
                        conn.Close();
                        return;
                    }
                }

                conn.Close();

                Response.Redirect("~/Voting.aspx");
            }            

            conn.Close();
        }

        //protected void txtArtifact_TextChanged(object sender, EventArgs e)
        //{
        //    BtnCancel.Enabled = true;
        //    BtnSubmit.Enabled = true;

        //    BtnSubmit.Text = "Submit Suggestion";

        //    LabelVersion.Text = "Your Version : ";
        //}

        protected void BtnSignOut_Click(object sender, EventArgs e)
        {
            Session["User"] = null;
            Response.Redirect("~/Default.aspx");
        }

        protected void BtnHistory_Click(object sender, EventArgs e)
        {            
            Response.Redirect("~/History.aspx");
        }
    }
}