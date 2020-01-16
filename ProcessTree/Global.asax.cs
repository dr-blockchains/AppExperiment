using System;
using System.Data.SqlClient;
using System.Configuration;
using System.Xml;
using System.Web;
using System.Data;

namespace ProcessTree
{
    public class Global : System.Web.HttpApplication
    {
        public static string DateFormat = "MMMM d, h:mm tt (CST)";
        public static string TimeFormat = "h:mm tt (CST)";

        public static string LeftTime(DateTime DeadLine)
        {
            int Mins = Convert.ToInt32((DeadLine - DateTime.Now).TotalMinutes);
            return Mins < 60 ? Mins + " minutes."
                : (Mins % 60 == 0 ? Mins / 60 + " hours." : Mins / 60 + " hours and " + Mins % 60 + " minutes.");
        }

        public static void Email(string Address, string Subject, string Content)
        {
            // ClientScript.RegisterStartupScript(this.GetType(), "Attention", "alert('No treatment group is available now. Please come back later! ');", true);
            // HttpContext.Current.Response.Write(Subject);
            return;
#if DEBUG
            HttpContext.Current.Response.Write(Subject);
            return;
#endif
            string Body = Content + "<br><br>" +

                "You can log into your account <a href = 'https://Faculty.McCombs.UTexas.edu/Hamed.Khaledi/'>HERE</a> with your <i>Email Address</i> as your <i>Username</i>. <br><br>" +

                "Best! <br>" +
                "The Experiment Administrators, <br>" +
                "The McCombs Schools of Business, <br>" +
                "The University of Texas at Austin. <br><br>" +

                "P.S. Please do not reply to this message. <br>" + 
                "Please email the Experimenter (Law.Economist@Gmail.com) if you: <br>" +
                "  have any question or concerns or<br>" +
                "  wanted to opt out at any time or<br>" +
                "  forgot your password or<br>" +
                "  encountered any error. (take a screenshot please)";

            XmlDocument AppConfig = new XmlDocument();
            AppConfig.Load(AppDomain.CurrentDomain.SetupInformation.ConfigurationFile);
            string MailServer = System.Configuration.ConfigurationManager.AppSettings["MailServer"];
            string FromAddress = System.Configuration.ConfigurationManager.AppSettings["FromAddress"];
            string FromPrettyName = System.Configuration.ConfigurationManager.AppSettings["FromPrettyName"];

            System.Net.Mail.MailAddress MailFrom = new System.Net.Mail.MailAddress(FromAddress, FromPrettyName);
            System.Net.Mail.MailAddress MailTo = new System.Net.Mail.MailAddress(Address);
            System.Net.Mail.MailMessage MailMessage = new System.Net.Mail.MailMessage(MailFrom, MailTo)
            {
                IsBodyHtml = true,
                Subject = Subject,
                Body = Body
            };
            System.Net.Mail.SmtpClient MailClient = new System.Net.Mail.SmtpClient(MailServer);
            try
            {
                MailClient.Send(MailMessage);
            }                          
            catch (Exception error)
            {
                // HttpContext.Current.Response.Write("<br>Email not queued for delivery!<br><br>Error: " + error);
            }            
        }

        public static void EmailAdmin(string Subject, string Content)
        {
#if DEBUG
            HttpContext.Current.Response.Write("<br>" + Subject + "<br>" + Content);
            return;     
#endif
            XmlDocument AppConfig = new XmlDocument();
            AppConfig.Load(AppDomain.CurrentDomain.SetupInformation.ConfigurationFile);
            string MailServer = System.Configuration.ConfigurationManager.AppSettings["MailServer"];
            string FromAddress = System.Configuration.ConfigurationManager.AppSettings["FromAddress"];
            string FromPrettyName = System.Configuration.ConfigurationManager.AppSettings["FromPrettyName"];

            System.Net.Mail.MailAddress MailFrom = new System.Net.Mail.MailAddress(FromAddress, FromPrettyName);
            System.Net.Mail.MailAddress MailTo = new System.Net.Mail.MailAddress("Law.Economist@Gmail.com");
            System.Net.Mail.MailMessage MailMessage = new System.Net.Mail.MailMessage(MailFrom, MailTo)
            {
                IsBodyHtml = true,
                Subject = Subject,
                Body = Content
            };
            System.Net.Mail.SmtpClient MailClient = new System.Net.Mail.SmtpClient(MailServer);
            try
            {
                MailClient.Send(MailMessage);
            }
            catch (Exception error)
            {
                HttpContext.Current.Response.Write("<br> Please contact the admin: (Law.Economist@Gmail.com) and forward this message: <br> It cannot send email because: " + error);
                // Alert admin: email was not queued for delivery.                
                // HttpContext.Current.Response.Write("\nEmail not queued for delivery. Error: " + error.ToString());
            }
        }

        /* public static void InviteVoting(int Treat, int Group, DateTime DT)
        {
            SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["ProcessTreeConnectionString"].ConnectionString);
            conn.Open();
            
            string Content = " , <br>" +
              "Please log into your account and cast your vote on the Suggestions or the [Current Updated Edition] of the artifact. <br> <br>" +

              "This voting period will close on " + DT.ToString(DateFormat) + ", in about " + LeftTime(DT);            

            string query = "select * from People where (Treatment = @Treat and Group# = @Group and QualificationTime is not null and Completed is null and Rater <> 1 and ID like '%_@__%.__%')";
            SqlCommand com = new SqlCommand(query, conn);
            com.Parameters.AddWithValue("@Treat", Treat);
            com.Parameters.AddWithValue("@Group", Group);
            SqlDataReader User = com.ExecuteReader();

            while (User.Read())
                Email(User["ID"].ToString(), "Voting Period Began", "Hello " + User["Name"] +  Content);

            conn.Close();         
        }
        */

        /* public static int FinalPeriod(int Treat, int Group, DateTime EndingTime)
        {
            SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["ProcessTreeConnectionString"].ConnectionString);
            conn.Open();

            string query = "select top 1 Artifact from Versions where (Treatment = " + Treat + " and Group# = " + Group + " and Choice = 0 and Proposer <> 'experimenter') order by Period desc";
            var com = new SqlCommand(query, conn);
            object FinalArtifact = com.ExecuteScalar();
            string Content;
            int P;

            if (FinalArtifact == null )
            {
                if (EndingTime <= DateTime.Now)                
                    P = -22;                
                else                
                    P = -2;
                
                EmailAdmin("No Final Edition", "There was no successfull modification in treatment " + Treat + " group " + Group);

                Content = " , <br>" +

                    "Please log into your account and complete the final survey. <br><br>" +

                    "There was not enough votes for any modification on the initial edition. <br> <br>" +
                    
                    "The final survey will close on " + EndingTime.ToString(DateFormat) + ", in about " + LeftTime(EndingTime);

                // query = "update Treatments set Period=-2 , DT= '1/1/2100' where TID=" + Treat;
            }
            else
            {
                if (EndingTime <= DateTime.Now)
                    P = -21;
                else
                    P = -1;                

                Content = " , <br>" +

                     "Please log into your account and complete the final survey. <br><br>" +

                     "The final edition is as follows:" +

                     "<p><b>" + FinalArtifact.ToString().Replace("\n", "<br>") + "</b></p> <br> <br>" +

                     "The final survey will close on " + EndingTime.ToString(DateFormat) + ", in about " + LeftTime(EndingTime);

                // query = "update Treatments set Period=-1 , DT=Ending where TID=" + Treat;                  
            }

            //#region Execution
            //com = new SqlCommand(query, conn);
            //if (com.ExecuteNonQuery() != 1)
            //{
            //    EmailAdmin("Error 455: Global.Refresh", "Treatment = " + Treat + " <br> Ending = " + EndingTime + " <br> FinalArtifact = " + FinalArtifact);
            //    conn.Close();
            //    return P;
            //}
            //#endregion            

            #region Send the Final Emails

            //query = "select * from People where ((Treatment = @Treat and Group# = @Group) or Rater = 1) and QualificationTime is not null and Completed is null and ID like '%_@__%.__%'";
            //com = new SqlCommand(query, conn);
            //com.Parameters.AddWithValue("@Treat", Treat);
            //com.Parameters.AddWithValue("@Group", Group);

            //var User = com.ExecuteReader();
            //while (User.Read())
            //    Email(User["ID"].ToString(), "Final Period", "Hello " + User["Name"] + Content);

            #endregion

            conn.Close();                        
            return P;
        }
        
        */

        /* Period =
         
         * -9 :  Null
         * 0 : Before Starting 
         * 1 , 3 , odd : Suggestion
         * 2 , 4 , even : Voting
         * -1 : Final Survey with Final Edition        
         * -2 : Final Survey without Final Edition        
         
         * -11 :  Experiment has Finished After Final Rating
         * -12 :  Experiment has Finished without Final Edition          
         * -50 :  Experiment has Error -50 , Non-Existing TreatGroup     
             
         */

        public static int Refresh(int Treat, int Group, out DateTime DT)           
        {
            SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["ProcessTreeConnectionString"].ConnectionString);
            conn.Open();
           
            string query = "select * from Groups where Treatment =" + Treat + " and Group# = " + Group;
            SqlCommand com = new SqlCommand(query, conn);
            SqlDataReader TreatGroup = com.ExecuteReader();

            if (!TreatGroup.Read())
            {
                com.Dispose();
                conn.Close();
                DT = DateTime.MaxValue;
                return -50;
            }
            com.Dispose();
            DateTime StartingTime = (DateTime)TreatGroup["Starting"];
            if (DateTime.Now < StartingTime)
            {
                int returnvalue = TreatGroup["Period"].Equals(DBNull.Value) ? -9 : 0;
                DT = StartingTime;
                com.Dispose();
                conn.Close();
                return returnvalue;
            }
      
            if (TreatGroup["Period"].Equals(DBNull.Value))
            {
                TreatGroup.Close();
                DT = DateTime.Now.AddHours(1);

                EmailAdmin("Period=NULL --> Postpone", "Postponed Treatment " + Treat + " , Group " + Group + " ! <br> Starting= " + StartingTime);
                query = "UPDATE Groups SET Starting = '" + DT + "', DT = '" + DT + "' WHERE Treatment = " + Treat + " AND Group# = " + Group;
                com = new SqlCommand(query, conn);

                if (com.ExecuteNonQuery() != 1)
                    EmailAdmin("Error 247: Global.Refresh", "Treatment=" + Treat + " & Group = " + Group + " & Period=NULL");
                com.Dispose();
                conn.Close();                
                return -9;
            }

            int Period = (int)TreatGroup["Period"];           

            if (Period < -10)
            {
                DT = DateTime.MaxValue;
                com.Dispose();
                conn.Close();                
                return Period;
            }

            DT = (DateTime)TreatGroup["DT"];

            float A = (float)TreatGroup["A"], B = (float)TreatGroup["B"];

            TreatGroup.Close();

            if (DateTime.Now < DT && Period != 0)
            {
                com.Dispose();
                conn.Close();                
                return Period;
            }

            DT = DateTime.MaxValue;

            query = "select * from Treatments where TID = " + Treat;
            com = new SqlCommand(query, conn);
            SqlDataReader Treatment = com.ExecuteReader();

            if (!Treatment.Read())
            {
                EmailAdmin("Error 249: Global.Refresh", "Treatment = " + Treat);
                com.Dispose();
                conn.Close();                
                return -8;
            }
            
            //Treatment Parameters:            
            DateTime DeadLine = StartingTime.AddMinutes((float)Treatment["Ta"]);
            DateTime Closing = StartingTime.AddMinutes((float)Treatment["Tz"]);
            DateTime EndingTime = Closing.AddMinutes((float)Treatment["Tf"]);

            float Tv = (float)Treatment["Tv"];
            float Tp = (float)Treatment["Tp"];
            int M = (int)Treatment["M"];
            short Valuation = (short) Treatment["Valuation"];

            float Beta = (float)Treatment["Beta"];

            //float Reward = (float)Treatment["Reward"];
            //float Rv = (float)Treatment["Rv"];
            //float Ro = (float)Treatment["Ro"];

            //float Te = (float)Treatment["Te"];

            //int W = (int)Treatment["W"];
            //int V = (int)Treatment["V"];
            //short Meritocracy = (Treatment["Meritocracy"].Equals(DBNull.Value) || (short)Treatment["Meritocracy"] > 3) ? (short)0 : (short)Treatment["Meritocracy"];
            //bool Merit2All = Treatment["Merit2All"].Equals(true);

            com.Dispose();         
            Treatment.Close();

            float Performance = 1;

            //************************************************

            if (Period == -1 || Period == -2) // Was final rating period: *********************************************
            {
                Period -= 10;
                DT = EndingTime; 
            }         
            else if (Period == 0) // Was registration Period: ***********************************************
            {
                query = "UPDATE Versions SET Time = GETDATE() , Score = 0 , Fund = 0 WHERE Treatment = @Treat AND Group# = @Group";
                com = new SqlCommand(query, conn);
                com.Parameters.AddWithValue("@Treat", Treat);
                com.Parameters.AddWithValue("@Group", Group);
                if (com.ExecuteNonQuery() < 1)
                    EmailAdmin("Error 340: Global.Refresh", "Treatment=" + Treat + " & Period=" + Period + " & DeadLine=" + DeadLine);

                query = "DELETE FROM Versions WHERE Treatment = @Treat AND Group# = @Group AND Period > 2 AND Choice = 0";
                #region Execute
                com = new SqlCommand(query, conn);
                com.Parameters.AddWithValue("@Treat", Treat);
                com.Parameters.AddWithValue("@Group", Group);
                if (com.ExecuteNonQuery() < 0)
                    Global.EmailAdmin("Error 547: Global.Refresh", "Treatment=" + Treat);
                #endregion
                //query = "SELECT HtmlArtifact FROM Versions WHERE Treatment = @Treat AND Group# = @Group AND Period = 2 AND Choice = 0";                
                //com = new SqlCommand(query, conn);
                //com.Parameters.AddWithValue("@Treat", Treat);
                //com.Parameters.AddWithValue("@Group", Group);
                //object HtmlObj = com.ExecuteScalar();
                //if (HtmlObj == null)
                //{
                //    EmailAdmin("Error 326: Global.Refresh", "Period = " + Period + " <br> Treatment = " + Treat);
                //    // string HtmlArtifact = Artifact.ToString().Replace("\r", "").Replace("\n", "<br>").Replace("\t", "&nbsp;&nbsp;&nbsp;&nbsp;");
                //    query = "UPDATE Versions SET Artifact = @Artifact, HtmlArtifact = @HtmlArtifact WHERE Treatment = " + Treat + " AND Group# = " + Group + " AND Period = 2 AND Choice = 0";

                //    com = new SqlCommand(query, conn);
                //    com.Parameters.AddWithValue("@Artifact", "There is an error in the database. Please contact Admin: Law.Economist@Gmail.com.");
                //    com.Parameters.AddWithValue("@HtmlArtifact", "There is an error in the <strong>database</strong>. <br> Please contact Admin: Law.Economist@Gmail.com.");

                //    if (com.ExecuteNonQuery() != 1)
                //        EmailAdmin("Error 335: Global.Refresh", "Treatment=" + Treat + " & Period=" + Period );
                //}
                //com.Dispose();

                // Invitation Emails
                /*
                Content = " , <br>" +
                       "Please log into your account and begin participating in the design process. <br><br>" +
                       "If you have already passed the test, you can edit the artifact now. <br>" +
                       "Otherwise, you need to pass the test before: " + DeadLine.ToString(DateFormat) + ". <br>" +
                       "You have about " + LeftTime(DeadLine);

                query = "select * from People where (Treatment = @Treat and Group# = @Group and Verified = 1 and Rater <> 1 and ID like '%_@__%.__%')";               

                com = new SqlCommand(query, conn);
                com.Parameters.AddWithValue("@Treat", Treat);
                com.Parameters.AddWithValue("@Group", Group);

                User = com.ExecuteReader();

                while (User.Read())
                    Email(User["ID"].ToString(), "First Period Began", "Hello " + User["Name"] + Content);

                User.Close();
                */



                // Parallel Bonding

                query = "UPDATE Groups SET A = 1 , B = (SELECT Beta FROM Treatments WHERE TID = @Treat) WHERE Treatment = @Treat AND Group# = @Group";
                com = new SqlCommand(query, conn);
                com.Parameters.AddWithValue("@Treat", Treat);
                com.Parameters.AddWithValue("@Group", Group);
                if (com.ExecuteNonQuery() < 1)
                    EmailAdmin("Error 399: Global.Refresh", "Treatment=" + Treat + " & Period=" + Period + " & DeadLine=" + DeadLine);

                Period = 1;   // Switch to Suggestion Period

                if (M == 0)
                {
                    Period = 2;                                         // Skip Suggestion Period
                    DT = DateTime.Now.AddMinutes(Tv);
                    //// Copy the suggestion from group 1
                    //query = @"INSERT INTO Versions    
                    //                 SELECT Treatment, @Group, Period, Choice, Artifact, HtmlArtifact, Proposer, Time, Score 
                    //                 FROM Versions 
                    //                 WHERE Treatment= 23 and Group# = 1 and Period = 2 AND Choice != 0";

                    //com = new SqlCommand(query, conn);
                    //com.Parameters.AddWithValue("@Group", Group);
                    //if (com.ExecuteNonQuery() < 1)                     // No suggestion!
                    //    EmailAdmin("Error 406: Global.Refresh", "Treatment = " + Treat + " ,   Period = 2 <br> DT = " + DT);                    
                }
                else if (M == 1 || Closing < DateTime.Now.AddMinutes(Tv))
                    DT = Closing;
                else
                    DT = DateTime.Now.AddMinutes(Tp) < Closing ? DateTime.Now.AddMinutes(Tp) : Closing.AddSeconds(-1);
            }
            else if (Period % 2 == 0)  // Was Selection Period: **********************************************
            {
                int Winner;
                string Proposer, Artifact, NewCash, HtmlNewCash;
                float OldValue, NewValue, Score = 0;
                DataTable VersionVotes;
                //int MinVote = 0;
                //string ProposerName;
                //float Balance, MaxVote;
                if (Valuation == 12) // Parallel Primary
                {
                    query = @"SELECT * FROM Versions
                            WHERE Treatment = @Treatment AND [Group#] = @Group AND Period = @Period
                            ORDER BY Score DESC, Versions.Choice";

                    com = new SqlCommand(query, conn);
                    com.Parameters.AddWithValue("@Treatment", Treat);
                    com.Parameters.AddWithValue("@Group", Group);
                    com.Parameters.AddWithValue("@Period", Period);

                    var DataReader = com.ExecuteReader();
                    if (!DataReader.Read())
                    {
                        EmailAdmin("Error 469: Global.Refresh", "No Version! &&  Treatment=" + Treat + " & Period=" + Period);
                        conn.Close();
                        return Period;
                    }

                    Winner = (int)DataReader["Choice"];
                    Score= (float) DataReader["Score"];                   
                    Proposer = (string)DataReader["Proposer"];
                    Artifact = (string)DataReader["Artifact"];
                    Performance = (Winner==0?1:(float)DataReader["PerVal"]);
                                                         
                    com.Dispose();
                    DataReader.Close();
                }
                else if (Valuation == 10) // Parallel Market
                {
                    // query = @"SELECT *, COALESCE ((SELECT TOP 1 Price FROM Transactions 
                    //            						WHERE Treatment = @Treatment AND [Group#] = @Group AND Period = @Period AND Choice = Versions.Choice
                    //                                  ORDER BY TranID DESC), Score) AS ScorePrice
                    //        FROM Versions
                    //        WHERE Treatment = @Treatment AND [Group#] = @Group AND Period = @Period
                    //        ORDER BY ScorePrice DESC, Choice";

                    // query = @"SELECT * FROM Versions
                    //        WHERE Treatment = @Treatment AND [Group#] = @Group AND Period = @Period
                    //        ORDER BY Score DESC, Choice";
                    query = @"SELECT *
                            FROM Versions LEFT JOIN (SELECT * FROM Orders WHERE DShare > 0 AND UnFullfilled > 0) AS Offers1
                            ON Versions.Treatment = Offers1.Treatment AND Versions.Group# = Offers1.Group# AND Versions.Period= Offers1.Period AND Versions.Choice=Offers1.Choice
                            WHERE Versions.Treatment = @Treatment AND Versions.[Group#] = @Group AND Versions.Period = @Period
                            ORDER BY Price1 DESC, Versions.Score DESC, Versions.Choice";

                    com = new SqlCommand(query, conn);
                    com.Parameters.AddWithValue("@Treatment", Treat);
                    com.Parameters.AddWithValue("@Group", Group);
                    com.Parameters.AddWithValue("@Period", Period);
                   
                    var DataReader = com.ExecuteReader();
                    if (!DataReader.Read())
                    {
                        EmailAdmin("Error 469: Global.Refresh", "No Version! &&  Treatment=" + Treat + " & Period=" + Period);
                        com.Dispose();
                        conn.Close();
                        return Period;
                    }

                    Winner = (int)DataReader["Choice"];

                    //MaxVote = (float) DataReader["Score"];                   
                    Proposer = (string) DataReader["Proposer"];
                    Artifact = (string) DataReader["Artifact"];
                    Performance = (float)DataReader["PerVal"];
                    com.Dispose();
                    DataReader.Close();
                }
                else // Voting
                {
                    query = @"SELECT 
                        CASE WHEN SumVotes IS NULL THEN 0 ELSE SumVotes END AS SumVoteZ,
	                    Versions.Choice, 
	                    Versions.Proposer,
	                    Versions.Artifact,
                        Versions.PerVal
                        FROM (SELECT treatment, Group#, period, choice, sum(VoteWeight) AS SumVotes
                                  FROM Voting
                                  GROUP BY treatment, Group#, period, choice) AS VotesOnChoices RIGHT JOIN Versions ON 
                                                    Versions.Treatment = VotesOnChoices.Treatment AND 
                                                    Versions.Group# = VotesOnChoices.Group# AND 
                                                    Versions.Period = VotesOnChoices.Period AND 
                                                    VotesOnChoices.Choice = Versions.Choice 
                         WHERE Versions.Treatment=" + Treat + " AND Versions.Group#=" + Group + " AND Versions.Period=" + Period +
                        "ORDER BY SumVoteZ DESC, Versions.Time DESC";

                    #region Execute
                    com = new SqlCommand(query, conn);
                    var DataReader = com.ExecuteReader();
                    VersionVotes = new DataTable();
                    VersionVotes.Load(DataReader);
                    DataReader.Close();
                    if (VersionVotes.Rows.Count == 0)
                    {
                        EmailAdmin("Error 230: Global.Refresh", "Treatment=" + Treat + " <br> Period=" + Period + " <br> query=" + query);
                        com.Dispose();
                        conn.Close();
                        return Period;
                    }
                    #endregion
                    Winner = (int)VersionVotes.Rows[0][1]; // (int)Winning["Choice"];

                    // MinVote = (int)VersionVotes.Rows[VersionVotes.Rows.Count - 1][0];
                    //MaxVote = (int)VersionVotes.Rows[0][0];                    
                    Proposer = (string)VersionVotes.Rows[0][2]; // Version["Proposer"].ToString();
                    Artifact = (string)VersionVotes.Rows[0][3]; // Version["Artifact"].ToString(); // In Plain Text \n                    
                    Performance = (float)VersionVotes.Rows[0][4]; // Version["PerVal"];
                }

                OldValue = .5f * A * Score * Score + B * Score;
                NewValue = OldValue * Performance;
                A *= Performance;
                B *= Performance;
                // Only for voting or parallel (secondary) markets (Valutation < 12) 
                //if (Winner == 0)
                //{
                //    OldValue = Performance;
                //    NewValue = OldValue;
                //    Performance = 1;                    
                //}
                //else
                //{                
                //    query = "SELECT PerVal FROM Versions WHERE Versions.Treatment = @Treatment AND Versions.[Group#] = @Group AND Versions.Period = @Period AND Choice = 0";

                //    com = new SqlCommand(query, conn);
                //    com.Parameters.AddWithValue("@Treatment", Treat);
                //    com.Parameters.AddWithValue("@Group", Group);
                //    com.Parameters.AddWithValue("@Period", Period);

                //    OldValue = (float)(com.ExecuteScalar()??1.0f); // get the value in the previous round choice 0
                //    NewValue = OldValue * Performance;
                //    com.Dispose();
                //}
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
                        EmailAdmin("Unusual Period", "Treatment=" + Treat + " & Period=" + Period + " & Winner=" + Winner);
                        break;
                }

                NewCash = "$" + NewValue.ToString("N2");
                HtmlNewCash = "Fund from previous round = " + NewCash + "<br><hr>" +
                    "<strong>Calculation:</strong><br><br><i>" +
                    "The winnig choice on " + RoundDate + ": <br><br>" +
                    Artifact.Replace("\r", "").Replace("\n", "<br>") + "<br><br>" +
                    "Its performance was " +  Performance.ToString("N6") + "<br>" + //(Winner == 0 ? "1" : Performance.ToString("N6")) + "<br>" +
                    "Prior fund invested by the firm (on " + RoundDate + ") was $" + OldValue.ToString("N2") + "<br>" +
                    "New fund = Prior fund * Performance = $" + NewValue.ToString("N2") + "<i><br>" +
                    "New price function is: Price = " + A.ToString("N3") + " * S + " + B.ToString("N3");
                
                // Insert the winner to the next round (Period +2)
                query = @"INSERT INTO Versions(Treatment, Group#, Period , Choice , Artifact , HtmlArtifact, Proposer, Time, Score, PerVal) values(
                     @Treatment, @Group, @Period, 0, @Artifact, @HtmlArtifact, @Proposer, GETDATE(), @Score, @PerVal, @Fund)";
                com = new SqlCommand(query, conn);
                com.Parameters.AddWithValue("@Treatment", Treat);
                com.Parameters.AddWithValue("@Group", Group);
                com.Parameters.AddWithValue("@Period", Period + 2);
                com.Parameters.AddWithValue("@Artifact", NewCash);
                com.Parameters.AddWithValue("@HtmlArtifact", HtmlNewCash);
                com.Parameters.AddWithValue("@Proposer", Proposer);
                com.Parameters.AddWithValue("@Score", Score);
                com.Parameters.AddWithValue("@PerVal", NewValue);
                com.Parameters.AddWithValue("@Fund", NewValue);

                try
                {
                    if (com.ExecuteNonQuery() != 1)
                    {
                        EmailAdmin("Error 434: Global.Refresh", "Treatment=" + Treat + " & Period=" + Period + " & Winner=" + Winner);
                        com.Dispose();
                        conn.Close();
                        return Period;
                    }                    
                }
                catch (Exception Ex)
                {
                    EmailAdmin("Simultaneous Insert", "Treatment=" + Treat + " & Period=" + Period + " & Winner=" + Winner + " &&&&&&&&&&& Exception = " + Ex);

                    if (Closing < DateTime.Now.AddMinutes(1))
                    {
                        Period = -1;  // Switch to Survey Period
                        DT = EndingTime;
                    }
                    else
                    {
                        Period++;   // Switch to Suggestion Period

                        if (M == 0)
                        {
                            Period++;                       // Skip Suggestion Period
                            DT = DateTime.Now.AddMinutes(Tv);                           
                        }
                        else if (M <= 1 || Closing < DateTime.Now.AddMinutes(Tv))
                            DT = Closing;
                        else
                            DT = DateTime.Now.AddMinutes(Tp) < Closing ? DateTime.Now.AddMinutes(Tp) : Closing.AddMilliseconds(-1);
                    }

                    com.Dispose();
                    conn.Close();
                    return Period;
                    //NoDoubleInsert = false;
                }
                //if (NoDoubleInsert) // Parallel Markets

                query = "EXEC Winning @Treatment, @Group, @Period, @Winner";
                com = new SqlCommand(query, conn);
                com.Parameters.AddWithValue("@Treatment", Treat);
                com.Parameters.AddWithValue("@Group", Group);
                com.Parameters.AddWithValue("@Period", Period);
                com.Parameters.AddWithValue("@Winner", Winner);
                if (com.ExecuteNonQuery() < 1)
                    EmailAdmin("Error 549: Global.Refresh", "Treatment = " + Treat + " <br> Period = " + Period + " <br> DT = " + DT + " <br> Winner = " + Winner);
                com.Dispose();
                //    // Proposer of the winning choice
                //    query = "select * from People where ID = @Proposer";
                //    com = new SqlCommand(query, conn);
                //    com.Parameters.AddWithValue("@Proposer", Proposer);
                //    User = com.ExecuteReader();
                //    if (!User.Read())
                //    {
                //        EmailAdmin("Error 305: Global.Refresh", "Treatment=" + Treat + " & Period=" + Period + " & Winner=" + Winner + " & Propoer = " + Proposer);
                //        conn.Close();
                //        return Period;
                //    }
                //    ProposerName = (string)User["Name"];
                //    Balance = (float)User["Balance"];
                //    int TotalExtra = (int)User["ExtraVote"];
                //    User.Close();

                //    // Suspension
                //    if (Te > 0 && MinVote < MaxVote)
                //    {
                //        DateTime Until = DateTime.Now.AddMinutes(Te);
                //        query = "update People set Suspended = '" + Until + "' where ID in (' '";

                //        //  Content = "Hello proposer, <br> " +
                //        //"Unfortunately, your suggestion received the least number of votes (" + MinVote + " votes), and hence you cannnot submit suggestions for " + LeftTime(Until) + " <br>" +
                //        //"This means that you cannot suggest an edition until : " + Until.ToString(DateFormat) + " . <br> " +
                //        //"However, you can still see the others' suggestions and vote for them as before. <br>" + 
                //        //"As a reminder, you made the following suggestion : <br> <p><b>";  

                //        string Loser;
                //        for (int i = VersionVotes.Rows.Count - 1;
                //            (int)VersionVotes.Rows[i][0] == MinVote &&
                //            (int)VersionVotes.Rows[i][1] != 0;
                //            i--)
                //        {
                //            Loser = (string)VersionVotes.Rows[i][2];
                //            query += ", '" + Loser + "'";
                //            //Email(Loser, "Temporary Suspension!", 
                //            //    Content + 
                //            //    ((string)VersionVotes.Rows[i][3]).Replace("\r", "").Replace("\n", "<br>").Replace("\t", "&nbsp;&nbsp;&nbsp;&nbsp;") + "</b></p>");
                //        }

                //        query += ")";
                //        com = new SqlCommand(query, conn);
                //        // com.Parameters.AddWithValue("@Losers", Losers);
                //        if (com.ExecuteNonQuery() < 0)
                //            EmailAdmin("Error 411: Global.Refresh", "Treatment = " + Treat + " & Period = " + Period + " & MinVote = " + MinVote);
                //    }

                //    // Meritocracy to Winner
                //    if (W > 0 && Winner > 0 && !Merit2All)
                //    {
                //        switch (Meritocracy)
                //        {
                //            case 1:
                //                V += (int)MaxVote;
                //                break;
                //            case 2:
                //                V += (int)MaxVote - (int)VersionVotes.Select("Choice=0")[0][0];
                //                break;
                //            case 3:
                //                V += (int)MaxVote - MinVote;
                //                break;
                //            default:
                //                if (V == 0)
                //                    goto BreakFromIf1;
                //                break;
                //        }

                //        TotalExtra += V;
                //        query = "update People set ExtraVote = " + TotalExtra + " where ID = @Proposer";
                //        com = new SqlCommand(query, conn);
                //        com.Parameters.AddWithValue("@Proposer", Proposer);
                //        if (com.ExecuteNonQuery() != 1)
                //            EmailAdmin("Error 323: Global.Refresh", "Treatment = " + Treat + " & Period = " + Period + " & Proposer = " + Proposer);

                //        //  Content = "Hello " + ProposerName + " , <br> " +
                //        //"Congratulations! Your suggestion won " + MaxVote + " votes and became the updated edition.<br>" +
                //        //"Accordingly you receive " + V + " extra votes and your total extra votes become " + TotalExtra + " votes for the upcoming voting periods.<br>" +
                //        //"When you vote, " + Math.Min(W,TotalExtra) + " votes will be used out of your extra votes and your vote will be weighted as " + (Math.Min(W,TotalExtra)+1) + " unit votes.";

                //        //  Email(Proposer, "Extra votes for your contribution!", Content);
                //    }
                //BreakFromIf1:

                //    // Meritocracy to All
                //    if (W > 0 && Merit2All)
                //    {
                //        string Proposeri;
                //        int Votei;
                //        int SumVotei;
                //        switch (Meritocracy)
                //        {
                //            // V + Votes(i) --> Every Proposer
                //            case 1:
                //                for (int i = 0; i < VersionVotes.Rows.Count; i++)
                //                {
                //                    if ((int)VersionVotes.Rows[i][1] == 0)
                //                        continue;

                //                    Votei = (int)VersionVotes.Rows[i][0];
                //                    SumVotei = V + Votei;
                //                    if (SumVotei <= 0)
                //                        break;

                //                    Proposeri = (string)VersionVotes.Rows[i][2];

                //                    query = "update People set ExtraVote = ExtraVote + " + SumVotei + " where ID = '" + Proposeri + "'";
                //                    com = new SqlCommand(query, conn);
                //                    if (com.ExecuteNonQuery() < 0)
                //                        EmailAdmin("Error 411: Global.Refresh", "Treatment = " + Treat + " & Period = " + Period + " & W = " + W);

                //                    //Content = "Hello proposer, <br> " +
                //                    //    "Your suggestion received " + Votei + " votes.<br>" +
                //                    //    "Accordingly you receive " + SumVotei + " extra votes to be applied in the upcoming voting periods.<br>" +
                //                    //    (W < 99 ? ("Meanwhile, the maximum voting weight is " + (W + 1) + " and thus you cannot use more than " + W + " votes in each voting period.<br>") : "<br>") +
                //                    //    "As a reminder, you made the following suggestion : <br> <p><b>";

                //                    //Email(Proposeri, "Extra Votes for You!",
                //                    //    Content +
                //                    //    ((string)VersionVotes.Rows[i][3]).Replace("\r", "").Replace("\n", "<br>").Replace("\t", "&nbsp;&nbsp;&nbsp;&nbsp;") + "</b></p>");
                //                }
                //                break;


                //            // V + Votes(i) - Votes(0) --> Every Proposer
                //            case 2:
                //                int Vote0 = (int)VersionVotes.Select("Choice=0")[0][0];
                //                V -= Vote0;

                //                for (int i = 0; i < VersionVotes.Rows.Count; i++)
                //                {
                //                    if ((int)VersionVotes.Rows[i][1] == 0)
                //                        continue;

                //                    Votei = (int)VersionVotes.Rows[i][0];
                //                    SumVotei = V + Votei;
                //                    if (SumVotei <= 0)
                //                        break;

                //                    Proposeri = (string)VersionVotes.Rows[i][2];

                //                    query = "update People set ExtraVote = ExtraVote + " + SumVotei + " where ID = '" + Proposeri + "'";
                //                    com = new SqlCommand(query, conn);
                //                    if (com.ExecuteNonQuery() < 0)
                //                        EmailAdmin("Error 411: Global.Refresh", "Treatment = " + Treat + " & Period = " + Period + " & W = " + W);

                //                    //Content = "Hello proposer, <br> " +
                //                    //    "Your suggestion won " + Votei + " votes and the updated edition got " + Vote0 + " votes.<br>" +
                //                    //    "Accordingly you receive " + SumVotei + " extra votes to be applied in the upcoming voting periods.<br>" +
                //                    //    (W < 99 ? ("Meanwhile, the maximum voting weight is " + (W + 1) + " and thus you cannot use more than " + W + " votes in each voting period.<br>") : "<br>") +
                //                    //    "As a reminder, you made the following suggestion : <br> <p><b>";

                //                    //Email(Proposeri, "Extra Votes for You!",
                //                    //    Content +
                //                    //    ((string)VersionVotes.Rows[i][3]).Replace("\r", "").Replace("\n", "<br>").Replace("\t", "&nbsp;&nbsp;&nbsp;&nbsp;") + "</b></p>");
                //                }
                //                break;


                //            // V + Votes(i) - MinVotes --> Every Proposer
                //            case 3:
                //                V -= MinVote;

                //                for (int i = 0; i < VersionVotes.Rows.Count; i++)
                //                {
                //                    if ((int)VersionVotes.Rows[i][1] == 0)
                //                        continue;

                //                    Votei = (int)VersionVotes.Rows[i][0];
                //                    SumVotei = V + Votei;
                //                    if (SumVotei <= 0)
                //                        break;

                //                    Proposeri = (string)VersionVotes.Rows[i][2];

                //                    query = "update People set ExtraVote = ExtraVote + " + SumVotei + " where ID = '" + Proposeri + "'";
                //                    com = new SqlCommand(query, conn);
                //                    if (com.ExecuteNonQuery() < 0)
                //                        EmailAdmin("Error 411: Global.Refresh", "Treatment = " + Treat + " & Period = " + Period + " & W = " + W);

                //                    //Content = "Hello proposer, <br> " +
                //                    //    "Your suggestion received " + Votei + " votes.<br> and the least voted choice got " + MinVote + " votes.<br>" +
                //                    //    "Accordingly you receive " + SumVotei + " extra votes to be applied in the upcoming voting periods.<br>" +
                //                    //    (W < 99 ? ("Meanwhile, the maximum voting weight is " + (W + 1) + " and thus you cannot use more than " + W + " votes in each voting period.<br>") : "<br>") +
                //                    //    "As a reminder, you made the following suggestion : <br> <p><b>";

                //                    //Email(Proposeri, "Extra Votes for You!",
                //                    //    Content +
                //                    //    ((string)VersionVotes.Rows[i][3]).Replace("\r", "").Replace("\n", "<br>").Replace("\t", "&nbsp;&nbsp;&nbsp;&nbsp;") + "</b></p>");
                //                }
                //                break;


                //            // Fixed Votes V --> Every Proposer
                //            default:
                //                if (V == 0)
                //                    break;

                //                //Content = "Hello proposer, <br> " +
                //                //    "Every proposer receives " + V + " extra votes to cast during the upcoming voting periods. <br>" +
                //                //    (W < 99 ? ("Meanwhile, the maximum voting weight is " + (W + 1) + " and thus you cannot use more than " + W + " votes in each voting period.<br>") : "<br>") +
                //                //    "As a reminder, you made the following suggestion : <br> <p><b>";

                //                query = "update People set ExtraVote = ExtraVote + " + V + " where ID in (' '";

                //                for (int i = 0; i < VersionVotes.Rows.Count; i++)
                //                {
                //                    if ((int)VersionVotes.Rows[i][1] == 0)
                //                        continue;

                //                    Proposeri = (string)VersionVotes.Rows[i][2];
                //                    query += ", '" + Proposeri + "'";
                //                    //Email(Proposeri, "Extra Votes for You!",
                //                    //    Content +
                //                    //    ((string)VersionVotes.Rows[i][3]).Replace("\r", "").Replace("\n", "<br>").Replace("\t", "&nbsp;&nbsp;&nbsp;&nbsp;") + "</b></p>");
                //                }

                //                query += ")";
                //                com = new SqlCommand(query, conn);
                //                if (com.ExecuteNonQuery() < 0)
                //                    EmailAdmin("Error 411: Global.Refresh", "Treatment = " + Treat + " & Period = " + Period + " & W = " + W);
                //                break;
                //        }

                //        //    query = "update People set ExtraVote = ExtraVote + " + V + Votes + " where ID = @Proposer";                    
                //    }

                //    // Reward the right votes on the winning suggestion
                //    if (Rv > 0 && Winner > 0)
                //    {
                //        if (Valuation == 5)
                //        {
                //            query = "select count(*) from Versions where Treatment=" + Treat + " and Group#=" + Group + " and Period=" + Period;
                //            com = new SqlCommand(query, conn);
                //            int m = (int)com.ExecuteScalar();

                //            query = @"
                //    UPDATE P SET
                //        P.Balance = P.Balance + @Rv * (@m - NumVotes.Votes) 
                //    FROM People P
                //    LEFT JOIN (
                //        SELECT
                //            VoterVotes.Voter,
                //            COUNT(VoterVotes.Voter) AS Votes
                //        FROM (
                //            SELECT
                //                Voter
                //            FROM Voting
                //            WHERE
                //                Treatment = @Treat
                //                AND Group# = @Group
                //                AND[Period] = @Period
                //        ) VoterVotes
                //        GROUP BY VoterVotes.Voter
                //    ) NumVotes ON NumVotes.Voter = P.ID
                //    WHERE
                //        @Winner IN (
                //            SELECT
                //                Choice
                //            FROM Voting
                //            WHERE
                //                P.ID = Voter
                //                AND Treatment = @Treat
                //                AND Group# = @Group
                //                AND[Period] = @Period
                //        )";

                //            com = new SqlCommand(query, conn);
                //            com.Parameters.AddWithValue("@Rv", Rv);
                //            com.Parameters.AddWithValue("@m", m);
                //            com.Parameters.AddWithValue("@Treat", Treat);
                //            com.Parameters.AddWithValue("@Group", Group);
                //            com.Parameters.AddWithValue("@Period", Period);
                //            com.Parameters.AddWithValue("@Winner", Winner);

                //            if (com.ExecuteNonQuery() < 1)
                //                EmailAdmin("Error 767: Global.Refresh", "Treatment = " + Treat + " & Period = " + Period + " & Winner = " + Winner);
                //        }
                //        else
                //        {
                //            query = "update People set Balance = Balance + " + Rv +
                //            " where ID in (select Voter from Voting where Choice = " + Winner + " and Treatment = " + Treat + " and Group# = " + Group + " and [Period] = " + Period + ")";

                //            com = new SqlCommand(query, conn);

                //            if (com.ExecuteNonQuery() < 0)
                //                EmailAdmin("Error 777: Global.Refresh", "Treatment = " + Treat + " & Period = " + Period + " & Winner = " + Winner);
                //        }
                //    }

                //    // Reward the right votes on the Current Updated edition
                //    if (Ro > 0 && MaxVote > 0 && Winner == 0)
                //    {
                //        if (Valuation == 5)
                //        {
                //            query = "select count(*) from Versions where Treatment=" + Treat + " and Group#=" + Group + " and Period=" + Period;
                //            com = new SqlCommand(query, conn);
                //            int m = (int)com.ExecuteScalar();

                //            query = @"
                //    UPDATE P SET
                //        P.Balance = P.Balance + @Ro * (@m - NumVotes.Votes)
                //    FROM People P
                //    LEFT JOIN(
                //        SELECT
                //            VoterVotes.Voter,
                //            COUNT(VoterVotes.Voter) AS Votes
                //        FROM(
                //            SELECT
                //                Voter
                //            FROM Voting
                //            WHERE
                //                Treatment = @Treat
                //                AND Group# = @Group
                //                AND[Period] = @Period
                //        ) VoterVotes
                //        GROUP BY VoterVotes.Voter
                //    ) NumVotes ON NumVotes.Voter = P.ID
                //    WHERE
                //        0 IN(
                //            SELECT
                //                Choice
                //            FROM Voting
                //            WHERE
                //                P.ID = Voter
                //                AND Treatment = @Treat
                //                AND Group# = @Group
                //                AND[Period] = @Period
                //        )";

                //            com = new SqlCommand(query, conn);
                //            com.Parameters.AddWithValue("@Ro", Ro);
                //            com.Parameters.AddWithValue("@m", m);
                //            com.Parameters.AddWithValue("@Treat", Treat);
                //            com.Parameters.AddWithValue("@Group", Group);
                //            com.Parameters.AddWithValue("@Period", Period);

                //            if (com.ExecuteNonQuery() < 1)
                //                EmailAdmin("Error 829: Global.Refresh", "Treatment = " + Treat + " & Period = " + Period + " & Winner = " + Winner);
                //        }
                //        else
                //        {
                //            query = "update People set Balance = Balance + " + Ro +
                //            " where ID in (select Voter from Voting where Choice = 0 and Treatment= " + Treat + " and Group#= " + Group + " and [Period] = " + Period + ")";
                //            com = new SqlCommand(query, conn);

                //            if (com.ExecuteNonQuery() < 0)
                //                EmailAdmin("Error 838: Global.Refresh", "Treatment = " + Treat + " & Period = " + Period + " & Winner = " + Winner);
                //        }
                //    }

                //    // Reward the winner proposer
                //    if (Reward > 0 && Winner > 0)
                //    {
                //        Balance += Reward;
                //        query = "update People set Balance = " + Balance + " where ID = @Proposer";
                //        com = new SqlCommand(query, conn);
                //        com.Parameters.AddWithValue("@Proposer", Proposer);
                //        if (com.ExecuteNonQuery() != 1)
                //            EmailAdmin("Error 323: Global.Refresh", "Treatment = " + Treat + " & Period = " + Period + " & Proposer = " + Proposer);

                //        //  Content = "Hello " + ProposerName + " , <br> " +
                //        //"Congratulations! Your suggestion won and became the updated edition.<br>" +
                //        //"Accordingly you receive $" + Reward + " in reward and your balance becomes $" + Balance + ".";

                //        //  Email(Proposer, "Reward for your contribution!", Content);
                //    }
                // Period Change ###################################################################
                if (Closing < DateTime.Now.AddMinutes(1))
                {
                    // Send Invitation Emails

                    //                    Content = " , <br> " + (Winner == 0 ? "The Current Updated Edition won and became the Final Edition" :
                    //("By getting more votes (" + MaxVote + " votes) than other choices, Suggestion #" + Winner + " (by " + ProposerName + ") won and became the Final Edition"))
                    //+ " : <br> <br>" +

                    //"<p><b>" + HtmlArtifact + "</b></p> <br> <br> ";

                    //query = "select * from People where (Treatment = @Treat and Group# = @Group and QualificationTime is not null and Rater <> 1 and ID like '%_@__%.__%')";



                    //com = new SqlCommand(query, conn);
                    //com.Parameters.AddWithValue("@Treat", Treat);
                    //com.Parameters.AddWithValue("@Group", Group);

                    //User = com.ExecuteReader();

                    //while (User.Read())
                    //    Email(User["ID"].ToString(), "The design is finalized", "Hello " + User["Name"] + Content);

                    //User.Close();                  
                    query = @"UPDATE People SET 
ShareBalance = (@Dividend) * COALESCE((SELECT Volume FROM Shares WHERE Owner = People.ID AND Period = @Period + 2 AND Choice = 0),0)
WHERE Treatment = @Treat AND Group# = @Group";

                    com = new SqlCommand(query, conn);
                    com.Parameters.AddWithValue("@Treat", Treat);
                    com.Parameters.AddWithValue("@Group", Group);
                    com.Parameters.AddWithValue("@Period", Period);
                    com.Parameters.AddWithValue("@Dividend", Score>0 ? NewValue/Score : 0);
                    if (com.ExecuteNonQuery() < 1)
                        EmailAdmin("Error 1004: Global.Refresh", "Treatment = " + Treat + " <br> Period = " + Period + " <br> DT = " + DT + " <br> Winner = " + Winner);
                    
                    com.Dispose();
                    
                    Period = -1;     // FinalPeriod(Treat, Group, EndingTime);  // Switch to Final Period
                    DT = EndingTime;
                    //if (Period == -1 || Period == -2)
                    //    DT = EndingTime;
                    //else
                    //    DT = DateTime.MaxValue;
                }
                else
                {
                    // Send Invitation Emails
                    //   Content = " , <br> " + (Winner == 0 ? "The Current Updated Edition won and carried on to the next period" :
                    //("By getting more votes (" + MaxVote + " votes) than other choices, Suggestion #" + Winner + " (suggested by " + ProposerName + ") won and became the new Updated Edition"))
                    //+ " : <br> <br>" +

                    //"<p><b>" + HtmlArtifact + "</b></p> <br> <br> " +

                    //"Please log into your account to suggest a modification on the above edition.";

                    //   query = "select * from People where (Treatment = @Treat and Group# = @Group and QualificationTime is not null and Rater <> 1 and ID like '%_@__%.__%')";

                    //   com = new SqlCommand(query, conn);
                    //   com.Parameters.AddWithValue("@Treat", Treat);
                    //   com.Parameters.AddWithValue("@Group", Group);

                    //   User = com.ExecuteReader();

                    //   while (User.Read())
                    //       Email(User["ID"].ToString(), "Suggestion Period Began", "Hello " + User["Name"] + Content);

                    //   User.Close();                    
                    Period++;   // Switch to Suggestion Period

                    if (M == 0)
                    {
                        Period++;                       // Skip the Suggestion Period
                        DT = DateTime.Now.AddMinutes(Tv);
                        //if (Valuation == 10)
                        //{
                        //    query = "EXEC StartTrading @Treatment, @Group, @Period";
                        //    com = new SqlCommand(query, conn);

                        //    com.Parameters.AddWithValue("@Treatment", Treat);
                        //    com.Parameters.AddWithValue("@Group", Group);
                        //    com.Parameters.AddWithValue("@Period", Period);
                        //    if (com.ExecuteNonQuery() < 2)
                        //    {
                        //        EmailAdmin("Error 643: Global", " Treatment = " + Treat + " & Period = " + Period);
                        //        conn.Close();
                        //        return Period;
                        //    }
                        //}
                    }
                    else if (M == 1 || Closing < DateTime.Now.AddMinutes(Tv))                    
                        DT = Closing;                    
                    else                    
                        DT = DateTime.Now.AddMinutes(Tp) < Closing ? DateTime.Now.AddMinutes(Tp) : Closing.AddSeconds(-1);                    
                }
            }
            else if (Period % 2 == 1) // Was Suggestion Period: ********************************************
            {
                query = "select count(*) from Versions where Treatment=" + Treat + " and Group#=" + Group + " and Period=" + (Period + 1);
                com = new SqlCommand(query, conn);
                int m = (int)com.ExecuteScalar();

                if (m > 1) // Enough suggestions for selection
                {
                    Period++; // Switch to Voting Period
                    DT = DateTime.Now.AddMinutes(Tv);
                    // InviteVoting(Treat, Group, DT);
                    // Update Offer 0
                    // Update Transaction 0
                    if (Valuation > 9 )
                    {
                        query = "EXEC SetSuggestions @Treatment, @Group, @Period";
                        com = new SqlCommand(query, conn);

                        com.Parameters.AddWithValue("@Treatment", Treat);
                        com.Parameters.AddWithValue("@Group", Group);
                        com.Parameters.AddWithValue("@Period", Period);
                        try
                        {
                            if (com.ExecuteNonQuery() < 3)
                            {
                                EmailAdmin("Error 1058: Global", " Treatment = " + Treat + " & Period = " + Period);
                                com.Dispose();
                                conn.Close();
                                return Period;
                            }
                        }
                        catch (Exception Ex)
                        {
                            EmailAdmin("Simultaneous StartTrading", "Treatment=" + Treat + " & Period=" + Period + " &&&&&&&&&&& Exception = " + Ex);
                            com.Dispose();
                            conn.Close();
                            return Period;
                        }
                        com.Dispose();
                    }
                }
                else if (m<=1) // Not enough suggestions for Voting
                {
                    if (Closing <= DateTime.Now) // Switching to the Final Period:
                    {
                        // Period = FinalPeriod(Treat, Group, EndingTime);  // Switch to Final Period
                        //if (Period == -1 || Period == -2)
                        //    DT = EndingTime;
                        //else
                        //    DT = DateTime.MaxValue;
                        Period = -1;
                        DT = EndingTime;
                    }
                    else
                    {
                        // Period == Period : Stay in the suggestion period
                        DT = Closing; // Wait for a suggestion until the Closing Time
                    }                    
                }
                else // m == 0   : Not even the Current Updated Edition!!!                {
                    EmailAdmin("Error 903: Global.Refresh", "Treatment = " + Treat + " </> Period = " + Period + " <br> DT = " + DT);                
            }

            // *************************************************           

            // Update to the next Period

            query = "update Groups set [Period]=" + Period + " , DT= '" + DT + "' , A *= @Performance , B *= @Performance where Treatment=" + Treat + " and Group#=" + Group;

            com = new SqlCommand(query, conn);
            com.Parameters.AddWithValue("@Performance", Performance);

            if (com.ExecuteNonQuery() != 1)
            {
                EmailAdmin("Error 459: Global.Refresh", "Treatment = " + Treat + " <br> Period = " + Period + " <br> DT = " + DT);
                com.Dispose();
                conn.Close();                
                return Period;
            }
            com.Dispose();
            conn.Close();            
            return Period;
        }

        protected void Application_Start(object sender, EventArgs e)
        {       
           
        }

        protected void Session_Start(object sender, EventArgs e)
        {

        }

        protected void Application_BeginRequest(object sender, EventArgs e)
        {

        }

        protected void Application_AuthenticateRequest(object sender, EventArgs e)
        {

        }

        protected void Application_Error(object sender, EventArgs e)
        {            
            Response.Write("Error in application. \n Please contact the admin: Law.Economist@Gmail.com");
            EmailAdmin("Aplpication_Error",                 
                " <br><br> Url = " + HttpContext.Current.Request.Url +              
                " <br><br> UserHostAddress = " + HttpContext.Current.Request.UserHostAddress +
                " <br><br> Error = " + HttpContext.Current.Error +
                " <br><br> Form = " + HttpContext.Current.Request.Form +
                " <br><br> Headers = " + HttpContext.Current.Request.Headers);
        }

        protected void Session_End(object sender, EventArgs e)
        {

        }

        protected void Application_End(object sender, EventArgs e)
        {

        }
    }
}