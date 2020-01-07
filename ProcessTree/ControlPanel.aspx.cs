using System;
using System.Data.SqlClient;
using System.Configuration;
using System.Globalization;

namespace ProcessTree
{
    public partial class ControlPanel : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            //double PerPerson = Convert.ToSingle(InitialBalance.Text) + Convert.ToSingle(MaxPerformance.Text) / 1000000.0 * Convert.ToSingle(InitialVolume.Text);
            //WPerson.Text = PerPerson.ToString();
            //WGroup.Text = (PerPerson * Convert.ToSingle(PerGroup.Text)).ToString();

            if (IsPostBack) return;
            //ClientScript.RegisterStartupScript(GetType(), "Attention", "alert('Not Postback');", true);

            if ((string)Session["User"] == "experimenter")
                Participants.Visible = true;
            else
                Response.Redirect("~/Default.aspx");

            #region API

            // AWSCredential setup

            //var sharedFile = new Amazon.Runtime.CredentialManagement.SharedCredentialsFile();
            //Amazon.Runtime.CredentialManagement.CredentialProfile credential_profile;
            //Amazon.Runtime.AWSCredentials awsCredentials = null;

            //if (sharedFile.TryGetProfile("basic_profile", out credential_profile))
            //{
            //    // Got existing AWS Credential profile
            //    Amazon.Runtime.CredentialManagement.AWSCredentialsFactory.TryGetAWSCredentials(credential_profile, sharedFile, out awsCredentials);
            //}
            //else
            //{
            //    // Need to set up and register AWS Credential profile.
            //    Amazon.Runtime.CredentialManagement.CredentialProfileOptions credential_options = new Amazon.Runtime.CredentialManagement.CredentialProfileOptions();
            //    credential_options.AccessKey = "AKIAJ5MKFZQJCQXBVEAQ";
            //    credential_options.SecretKey = "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";
            //    credential_profile = new Amazon.Runtime.CredentialManagement.CredentialProfile("basic_profile", credential_options);
            //    credential_profile.Region = Amazon.RegionEndpoint.USEast1;
            //    sharedFile.RegisterProfile(credential_profile);
            //    if (sharedFile.TryGetProfile("basic_profile", out credential_profile))
            //    {
            //        Amazon.Runtime.CredentialManagement.AWSCredentialsFactory.TryGetAWSCredentials(credential_profile, sharedFile, out awsCredentials);
            //    }
            //}

            //// mturk_client setup

            //AmazonMTurkClient mturk_client = null;
            //if (awsCredentials != null)
            //{
            //    mturk_client = new AmazonMTurkClient(awsCredentials);
            //}

            // AutoPostBackControl JASON to MTurk:
            // StringBuilder sb = new StringBuilder();
            // byte[] buf = new byte[8192];

            //var httpWebRequest = (HttpWebRequest)WebRequest.Create("https://mturk-requester.us-east-1.amazonaws.com");
            //httpWebRequest.ContentType = "application/x-amz-json-1.1";
            //httpWebRequest.Method = "POST";
            //httpWebRequest.Headers.Add("X-Amz-Date",DateTime.Now.ToShortDateString());

            //using (var streamWriter = new StreamWriter(httpWebRequest.GetRequestStream()))
            //{
            //    string json = "{}";
            //    // string json = "{\"Subject\":\"Experiment Started\"," + 
            //    //"\"MessageText\":\"Please goto Hamed-Constitution.Broad.MSU.edu and login into your account to participante in the experiment\"," + 
            //    //"\"WorkerIds\": [" + WorkerList +"]}";

            //    streamWriter.Write(json);
            //    streamWriter.Flush();
            //    streamWriter.Close();
            //}

            //var httpResponse = (HttpWebResponse)httpWebRequest.GetResponse();
            //using (var streamReader = new StreamReader(httpResponse.GetResponseStream()))
            //{
            //    var result = streamReader.ReadToEnd();
            //}

            #endregion

            if (Session["Treat"] != null)
                Treat.SelectedValue = Session["Treat"].ToString();
            else
            {
                SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["ProcessTreeConnectionString"].ConnectionString);
                conn.Open();

                string query = "select max(TID) from Treatments";
                #region Execute
                SqlCommand com = new SqlCommand(query, conn);
                object TreatObj = com.ExecuteScalar();

                if (TreatObj == null)
                {
                    BtnActivate.Enabled = false;
                    BtnSave.Enabled = false;
                    Message.Text = "No Treatment at " + DateTime.Now.ToString(Global.TimeFormat);
                    conn.Close();
                    return;
                }
                #endregion

                Treat.SelectedValue = TreatObj.ToString();

                conn.Close();
            }

            Treat.DataBind();            
            DropNumbers_SelectedIndexChanged(sender, e);

            //query = "SELECT Balance FROM People where ID = 'experimenter'";       
            //com = new SqlCommand(query, conn);
            //ExperimenterBalance.Text = ((float)com.ExecuteScalar()).ToString("N2");

            //conn.Close();
        }

        protected void DropNumbers_SelectedIndexChanged(object sender, EventArgs e)
        {
            #region Prepare

            if ((string)Session["User"] == "experimenter")
            {
                Participants.Visible = true;
            }
            else
                Response.Redirect("~/Default.aspx");

            if (Treat.SelectedIndex < 0)
            {
                BtnActivate.Enabled = false;
                BtnSave.Enabled = false;
                Message.Text = "No Treatment at " + DateTime.Now.ToString(Global.TimeFormat);
                return;
            }

            BtnActivate.Enabled = true;
            BtnSave.Enabled = true;
            Message.Text = "";

            SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["ProcessTreeConnectionString"].ConnectionString);
            conn.Open();

            #endregion

            //string query = "select * from Groups where Treatment = " + Treat.SelectedIndex + " and Group# = 1";
            //#region Execute
            //SqlCommand com = new SqlCommand(query, conn);
            //SqlDataReader GroupReader = com.ExecuteReader();

            //if (!GroupReader.Read())
            //{
            //    Constitution.Text = "Error (85). Please contact the admin: Law.Economist@Gmail.com \n Dropnumber = " + Treat.SelectedIndex;
            //    Global.EmailAdmin("Error 85: ControlPanel", "UserID =" + Session["User"] + " & Treatment = " + Treat.SelectedIndex);
            //    conn.Close();
            //    return;
            //}
            //#endregion

            //DateTime DTStart = (DateTime)GroupReader["Starting"];
            //GroupReader.Close();           

            string query = "select * from Treatments where TID = " + Treat.SelectedValue;
            #region Execute
            var com = new SqlCommand(query, conn);
            SqlDataReader Treatment = com.ExecuteReader();

            if (!Treatment.Read())
            {
                Constitution.Text = "Error (87). Please contact the admin: Law.Economist@Gmail.com \n Dropnumber = " + Treat.SelectedValue;
                Global.EmailAdmin("Error 87: ControlPanel", "UserID =" + Session["User"] + " & Treatment = " + Treat.SelectedValue);
                conn.Close();
                return;
            }

            #endregion
            #region Show The Treatment

            // Parent.Text = Treatment["Parent"].ToString();
            Constitution.Text = Treatment["Constitution"].ToString().Replace("<br>", "\n").Replace("<b>", "{").Replace("</b>", "}").Replace("<a href=\"https://", "[[").Replace("/\" target = \"_blank\">", "%%").Replace("</a>", "]]");
            Hypothesis.Text = Treatment["Hypothesis"].ToString();

            Beta.Text = Treatment["Beta"].ToString();

            Tp.Text = Treatment["Tp"].ToString();
            Tv.Text = Treatment["Tv"].ToString();
            Te.Text = Treatment["Te"].ToString();
            
            float TaNum = (float)Treatment["Ta"];
            float TzNum = (float)Treatment["Tz"];
            float TfNum = (float)Treatment["Tf"];
            float SpanNum = TzNum + TfNum;

            Ta.Text = TaNum.ToString();
            Tz.Text = TzNum.ToString();
            Tf.Text = TfNum.ToString();
            Span.Text = SpanNum.ToString();         

            M.Text = Treatment["M"].ToString();

            Rv.Text = ((float) Treatment["Rv"]).ToString("N2");
            Ro.Text = ((float)Treatment["Ro"]).ToString("N2");
            Reward.Text = ((float)Treatment["Reward"]).ToString("N2");
            BetFee.Text = ((float)Treatment["BetFee"]).ToString("N2");
            SuggestionFee.Text = ((float)Treatment["SuggestionFee"]).ToString("N2");
            Compensation.Text = ((float)Treatment["Compensation"]).ToString("N2");

            InitialBalance.Text = ((float)Treatment["InitialBalance"]).ToString("N2");
            InitialVolume.Text = ((float)Treatment["InitialVolume"]).ToString("N2");

            V.Text = Treatment["V"].ToString();
            W.Text = Treatment["W"].ToString();
            E.Text = Treatment["E"].ToString();

            RadioMeritocracy.SelectedIndex = (Treatment["Meritocracy"].Equals(DBNull.Value) || (short)Treatment["Meritocracy"]>3)? (short)-1 : (short)Treatment["Meritocracy"];
            RadioMerit2All.SelectedIndex = Treatment["Merit2All"].Equals(true) ? 1 : 0;

            PerGroup.Text = Treatment["PerGroup"].ToString();            

            VoteChange.Checked = Treatment["VoteChange"].Equals(true);            

            Valuation.SelectedValue = Treatment["Valuation"].ToString();
            AuctionSort.Checked = Treatment["AuctionSort"].Equals(true);

            #endregion                 
            Treatment.Close();

            query = "select count(*) from Groups where Treatment = " + Treat.SelectedValue;
            #region GroupCount
            com = new SqlCommand(query, conn);          
            int GroupsCount = (int) com.ExecuteScalar();
            if (GroupsCount <= 0)
                Message.Text = "Error (166). No Group for this Treament! ";

            if (GroupsCount <= 1)
            {
                Down.Enabled = false;                
            }
            else
            {
                Down.Enabled = true;               
            }

            Groups.Text = GroupsCount.ToString();
            #endregion          

            query = "select Artifact, PerVal from Versions where Treatment = " + Treat.SelectedValue + " and Group# = 1 and Period = 2 and Choice = 0";
            #region Show the Artifact
            com = new SqlCommand(query, conn);
            SqlDataReader DataReader = com.ExecuteReader();      

            if (!DataReader.Read())
            {
                Message.Text = "Error (174). No Initial Solution!";
                Artifact.Text = "No Initial solution! \n Dropnumber = " + Treat.SelectedValue;                
                
                query = "insert into Versions(Treatment, Group#, Period , Choice , Artifact , HtmlArtifact, Proposer , Time, Score, PerVal) values("
                    + Treat.SelectedValue + ", 1 , 2 , 0 , 'Empty', 'Empty', 'experimenter' , GETDATE(), 0, 0)";
                
                #region Execute
                com = new SqlCommand(query, conn);

                DataReader.Close();
                if (com.ExecuteNonQuery() < 1)
                {
                    Message.Text = "Error (266) with inserting an initial solution.";
                    conn.Close();
                    return;
                }
                #endregion
            }
            else
            {
                Artifact.Text = DataReader["Artifact"].ToString();

                float f1 = (float) DataReader["PerVal"];
                float n = float.Parse(PerGroup.Text, CultureInfo.InvariantCulture.NumberFormat);
                float b = float.Parse(Beta.Text, CultureInfo.InvariantCulture.NumberFormat);

                float s = -b + (float)Math.Sqrt(b*b+2*f1); 

                InitialVolume.Text = (s/n).ToString();
            }

            #endregion

            com.Dispose();
            conn.Close();
          
            for (int i = 1; i <= GroupsCount; i++)
                Global.Refresh(Treat.SelectedIndex, i, out DateTime DT);

            if (Convert.ToInt32(W.Text) > 0)
            {
                RadioMerit2All.Enabled = true;
                RadioMeritocracy.Enabled = true;
                V.Enabled = true;
            }
            else
            {
                RadioMerit2All.Enabled = false;
                RadioMeritocracy.Enabled = false;
                V.Enabled = false;
            }

            //--------
            //DeadLine.Text = DTStart.AddHours(TaNum).ToString("s");
            //Closing.Text = DTStart.AddHours(TzNum).ToString("s");
            //Ending.Text = DTStart.AddHours(SpanNum).ToString("s");

            //Starting.Text = DTStart.ToString("s");            
            //Period.Text = GroupReader["Period"].ToString();
            //DT.Text = ((DateTime)GroupReader["DT"]).ToString("s");

            //if (DateTime.Now < Convert.ToDateTime(Starting.Text))            
            //    Starting.BackColor = System.Drawing.Color.FromArgb(0xAAAAFF);
            //else
            //{
            //    Message.Text = DateTime.Now + " : Now > Starting :" + Starting.Text;
            //    BtnActivate.Enabled = false;
            //    Starting.BackColor = System.Drawing.Color.Red;
            //} 
            //---------

            if (Convert.ToSingle(Ta.Text) >= 0.0F)
                Ta.BackColor = System.Drawing.Color.Yellow;
            else
            {
                Message.Text = "Ta = " + Ta.Text + " at Now : " + DateTime.Now;
                BtnActivate.Enabled = false;
                Ta.BackColor = System.Drawing.Color.Red;
            }       
            //--------

            if (Convert.ToSingle(Tz.Text) >= 0.0)
                Tz.BackColor = System.Drawing.Color.Yellow;
            else
            {
                Message.Text = "Tz = " + Tz.Text + " at Now : " + DateTime.Now;
                BtnActivate.Enabled = false;
                Tz.BackColor = System.Drawing.Color.Red;
            }
            //--------

            if (Convert.ToSingle(Tf.Text) >= 0.0)                            
                Tf.BackColor = System.Drawing.Color.Yellow;            
            else
            {
                Message.Text = "Tf = " + Tf.Text + " at Now : " + DateTime.Now;                
                BtnActivate.Enabled = false;                
                Tf.BackColor = System.Drawing.Color.Red;
            }
        }

        protected void BtnCreate_Click(object sender, EventArgs e)
        {
            if ((string)Session["User"] != "experimenter")                         
                Response.Redirect("~/Default.aspx");                      
                        
            if (0.0F <= Convert.ToSingle(Ta.Text) &&
                0.0F <= Convert.ToSingle(Tf.Text) &&
                0.0F <= Convert.ToSingle(Tz.Text))
            {
                Message.Text = "Consistent at " + DateTime.Now.ToString(Global.TimeFormat);
                BtnActivate.Enabled = true;
            }
            else
            {
                BtnActivate.Enabled = false;
                Message.Text = "Inconsistent at " + DateTime.Now.ToString(Global.TimeFormat);
                return;
            }
            //if (Convert.ToDateTime(Starting.Text) < DateTime.Now)
            //{
            //    BtnActivate.Enabled = false;
            //    Message.Text = "Too Late on " + DateTime.Now.ToString(Global.DateFormat);
            //}       
            //Period.Text = "";
            //DT.Text = Starting.Text;   
            int NewIndex = Treat.Items.Count;

            SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["ProcessTreeConnectionString"].ConnectionString);
            conn.Open();

            string query = @"insert into Treatments (TID, Parent, Constitution, Hypothesis, Beta, Ta, Tf, Tp, Tv, Te, Tz, M, Rv, Ro, Reward, BetFee, SuggestionFee, Compensation, V, W, E, PerGroup, VoteChange, Valuation, AuctionSort, Meritocracy, Merit2All, InitialBalance, InitialVolume) 
                                     Values (@Treatment, @Parent, @Constitution, @Hyp, @Beta, @Ta, @Tf, @Tp, @Tv, @Te, @Tz, @M, @Rv, @Ro, @Reward, @BetFee, @SuggestionFee, @Compensation, @V, @W, @E, @PerGroup, @VoteChange, @Valuation, @AuctionSort, @Meritocracy, @Merit2All, @InitialBalance, @InitialVolume)";
            #region Execute

            SqlCommand com = new SqlCommand(query, conn);
            
            com.Parameters.AddWithValue("@Treatment", NewIndex);
            com.Parameters.AddWithValue("@Parent", Math.Max(Treat.SelectedIndex,0));

            com.Parameters.AddWithValue("@Constitution", Constitution.Text.Trim().Replace("\n", "<br>").Replace("{", "<b>").Replace("}", "</b>").Replace("[[", "<a href=\"https://").Replace("%%", "/\" target = \"_blank\">").Replace("]]", "</a>"));
            com.Parameters.AddWithValue("@Hyp", Hypothesis.Text.Trim());

            com.Parameters.AddWithValue("@Beta", Beta.Text);

            com.Parameters.AddWithValue("@Ta", Ta.Text);
            com.Parameters.AddWithValue("@Tf", Tf.Text);
            com.Parameters.AddWithValue("@Tp", Tp.Text);
            com.Parameters.AddWithValue("@Tv", Tv.Text);
            com.Parameters.AddWithValue("@Te", Te.Text);            
            com.Parameters.AddWithValue("@Tz", Tz.Text);

            com.Parameters.AddWithValue("@M", M.Text);

            com.Parameters.AddWithValue("@Rv", Rv.Text);
            com.Parameters.AddWithValue("@Ro", Ro.Text);
            com.Parameters.AddWithValue("@Reward", Reward.Text);
            com.Parameters.AddWithValue("@BetFee", BetFee.Text);
            com.Parameters.AddWithValue("@SuggestionFee", SuggestionFee.Text);
            com.Parameters.AddWithValue("@Compensation", Compensation.Text);

            com.Parameters.AddWithValue("@InitialBalance", InitialBalance.Text);
            com.Parameters.AddWithValue("@InitialVolume", InitialVolume.Text);

            com.Parameters.AddWithValue("@V", V.Text);
            com.Parameters.AddWithValue("@W", W.Text);
            com.Parameters.AddWithValue("@E", E.Text);

            com.Parameters.AddWithValue("@PerGroup", PerGroup.Text);            

            com.Parameters.AddWithValue("@VoteChange", VoteChange.Checked);
            
            com.Parameters.AddWithValue("@Valuation", Valuation.SelectedValue);
            com.Parameters.AddWithValue("@AuctionSort", AuctionSort.Checked);

            com.Parameters.AddWithValue("@Meritocracy", RadioMeritocracy.SelectedIndex);
            com.Parameters.AddWithValue("@Merit2All", RadioMerit2All.SelectedIndex);
            //com.Parameters.AddWithValue("@GroupsCount", Groups.Text);
            //com.Parameters.AddWithValue("@DT", Convert.ToDateTime(DT.Text));
            //com.Parameters.AddWithValue("@Start", Convert.ToDateTime(Starting.Text));   
            if (com.ExecuteNonQuery() != 1)
            {
                Message.Text = "Error (214) with adding new treatment.";
                conn.Close();
                return;
            }

            #endregion

            Groups.Text = "1";
            //int GroupCount = Convert.ToInt32(Groups.Text);

            //if (GroupCount <= 0)
            //{
            //    Message.Text = "Error (337). No Group for this Treament! ";
            //    conn.Close();
            //    return;
            //}

            //DateTime dt = GroupList.Rows[0].Cells[3].Controls[0];
            //string LongDT = dt == "" ? " ," : " , " + dt + "," + dt + "),";

            //string DTString = " , '" + DateTime.Now.Date.AddDays(7) + "' , '" + DateTime.Now.Date.AddDays(7) + "'),";

            //string Values1 = "";
            //string Values2 = "";
            //for (int i = 1; i <= GroupCount; i++)
            //{
            //    Values1 += " (" + Treat.SelectedIndex + " , " + i + DTString;
            //    Values2 += " (" + Treat.SelectedIndex + " , " + i + " , 2 , 0 , @Artifact , @HtmlArtifact , 'experimenter' , GETDATE(), @Score),";
            //}

            //query = "insert into Groups (Treatment , Group#, Starting, DT) values " + Values1.TrimEnd(',');
            query = @"INSERT INTO Groups 
                             SELECT @NewTreat, 1, Period, DT, Starting 
                             FROM Groups
                             WHERE Treatment = @OldTreat AND Group# = 1";

            com = new SqlCommand(query, conn);
            com.Parameters.AddWithValue("@NewTreat", NewIndex);
            com.Parameters.AddWithValue("@OldTreat", Treat.SelectedValue);
            if (com.ExecuteNonQuery() != 1)
            {
                Message.Text = "Error (378) with adding initial version.";
                conn.Close();
                return;
            }

            query = @"INSERT INTO Versions 
                             SELECT @NewTreat, 1, Period, Choice, Artifact, HtmlArtifact, Proposer, GETDATE(), 0, PerVal
                             FROM Versions
                             WHERE Treatment = @OldTreat AND Group# = 1";

            com = new SqlCommand(query, conn);
            com.Parameters.AddWithValue("@NewTreat", NewIndex);
            com.Parameters.AddWithValue("@OldTreat", Treat.SelectedValue);
           
            if (com.ExecuteNonQuery() < 1)
            {
                Message.Text = "Error (392) with adding initial version.";
                conn.Close();
                return;
            }

            Treat.DataBind();
            Treat.SelectedValue = NewIndex.ToString();
            conn.Close();
        }

        protected void Up_Click(object sender, EventArgs e)
        {            
            Down.Enabled = true;

            SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["ProcessTreeConnectionString"].ConnectionString);
            conn.Open();
            
            string query = "select top 1 Group# from Groups where Treatment = " + Treat.SelectedValue + " order by Group# desc";
            var com = new SqlCommand(query, conn);
            object Obj = com.ExecuteScalar();
            int Count = (Obj == null)? 1 : 1 + (int)Obj;
            Groups.Text = Count.ToString();
            //var GroupReader = com.ExecuteReader();
            //if (!GroupReader.Read())
            //{
            //    Constitution.Text = "Error (413). Please contact the admin: Law.Economist@Gmail.com \n Dropnumber = " + Treat.SelectedIndex;
            //    Global.EmailAdmin("Error 413: ControlPanel", "UserID =" + Session["User"] + " & Treatment = " + Treat.SelectedIndex);
            //    conn.Close();
            //    return;
            //}

            //int Count = (int) GroupReader["Group#"] + 1;
            //Groups.Text = Count.ToString();

            //var obj = GroupReader["Starting"];
            //string DTString;

            //if (obj.Equals(DBNull.Value))
            //    DTString = " , '" + DateTime.MaxValue + "' , '" + DateTime.MaxValue + "')";            
            //else            
            //    DTString = " , '" + obj + "' , '" + obj + "')";

            //GroupReader.Close();

            //query = "insert into Groups (Treatment , Group#, DT, Starting) values (" + Treat.SelectedIndex + " , " + Count + ", DATEADD(HOUR, 2, GETDATE()), DATEADD(HOUR, 2, GETDATE()))";
            query = @"INSERT INTO Groups 
                             SELECT Treatment, @NewGroup, Period, DT, Starting, A, B 
                             FROM Groups
                             WHERE Treatment = @Treat AND Group# = 1";

            #region Execute
            com = new SqlCommand(query, conn);
            com.Parameters.AddWithValue("@Treat", Treat.SelectedValue);
            com.Parameters.AddWithValue("@NewGroup", Count);
            try {
                if (com.ExecuteNonQuery() != 1)
                {
                    Message.Text = "Error (523) with adding group.";
                    conn.Close();
                    return;
                }
            }
            catch (Exception Ex)
            {
                Message.Text = "Error (530) with adding group." + " & Exception = " + Ex;
                conn.Close();
                return;
            }
            
            #endregion
             query = @"INSERT INTO Versions 
                             SELECT Treatment, @NewGroup, Period, Choice, Artifact, HtmlArtifact, Proposer, Time, Score, PerVal
                             FROM Versions
                             WHERE Treatment = @Treat AND Group# = 1";
            #region Execute

            com = new SqlCommand(query, conn);
            com.Parameters.AddWithValue("@Treat", Treat.SelectedValue);
            com.Parameters.AddWithValue("@NewGroup", Count);

            try
            {
                if (com.ExecuteNonQuery() < 1)
                {
                    Message.Text = "Error (548) with adding initial version.";
                    conn.Close();
                    return;
                }
            }
            catch (Exception Ex)
            {
                Message.Text = "Error (555) with adding initial version." + " & Exception = " + Ex;
                conn.Close();
                return;
            }            

            #endregion                      

            conn.Close();
            GroupList.DataBind();
        }

        protected void Down_Click(object sender, EventArgs e)
        {
            int Count = Convert.ToInt32(Groups.Text) - 1;
            if (Count < 1)
            {
                Down.Enabled = false;                
                Message.Text = "A treatment must have one group at least.";                
                return;
            }
            if (Count == 1)
            {
                Down.Enabled = false;                
            }
                        
            Groups.Text = Count.ToString();

            SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["ProcessTreeConnectionString"].ConnectionString);
            conn.Open();

            string query = "update People set Group# = NULL where Treatment = " + Treat.SelectedValue + " and Group# > " + Count;
            #region Execute
            var com = new SqlCommand(query, conn);
            if (com.ExecuteNonQuery() < 0)
            {
                Message.Text = "Error (434) with clearing group from people";
                conn.Close();
                return;
            }
            #endregion

            query = "delete from Voting where Treatment = " + Treat.SelectedValue + " and Group# > " + Count;
            #region Execute
            com = new SqlCommand(query, conn);
            if (com.ExecuteNonQuery() <0)
            {
                Message.Text = "Error (445) with deleting votings.";
                conn.Close();
                return;
            }
            #endregion

            query = "delete from Rating where Treatment = " + Treat.SelectedValue + " and Group# > " + Count;
            #region Execute
            com = new SqlCommand(query, conn);
            if (com.ExecuteNonQuery() < 0)
            {
                Message.Text = "Error (478) with deleting ratings.";
                conn.Close();
                return;
            }
            #endregion

            query = "delete from Chats where Treatment = " + Treat.SelectedValue + " and Group# > " + Count;
            #region Execute
            com = new SqlCommand(query, conn);
            if (com.ExecuteNonQuery() < 0)
            {
                Message.Text = "Error (647) with deleting chats.";
                conn.Close();
                return;
            }
            #endregion

            query = "delete from Transactions where Treatment = " + Treat.SelectedValue + " and Group# > " + Count;
            #region Execute
            com = new SqlCommand(query, conn);
            if (com.ExecuteNonQuery() < 0)
            {
                Message.Text = "Error (655) with deleting Transactions.";
                conn.Close();
                return;
            }
            #endregion

            query = "delete from Orders where Treatment = " + Treat.SelectedValue + " and Group# > " + Count;
            #region Execute
            com = new SqlCommand(query, conn);
            if (com.ExecuteNonQuery() < 0)
            {
                Message.Text = "Error (667) with deleting Offer.";
                conn.Close();
                return;
            }
            #endregion

            query = "delete from Shares where Treatment = " + Treat.SelectedValue + " and Group# > " + Count;
            #region Execute
            com = new SqlCommand(query, conn);
            if (com.ExecuteNonQuery() < 0)
            {
                Message.Text = "Error (678) with deleting Shares.";
                conn.Close();
                return;
            }
            #endregion

            query = "delete from Versions where Treatment = " + Treat.SelectedValue + " and Group# > " + Count;
            #region Execute
            com = new SqlCommand(query, conn);
            if (com.ExecuteNonQuery() < 1)
            {
                Message.Text = "Error (456) with deleting versions.";
                conn.Close();
                return;
            }
            #endregion  

            query = "delete from Groups where Treatment = " + Treat.SelectedValue + " and Group# > " + Count;
            #region Execute
            com = new SqlCommand(query, conn);
            if (com.ExecuteNonQuery() != 1)
            {
                Message.Text = "Error (467) with deleting groups.";
                conn.Close();
                return;
            }
            #endregion

            conn.Close();
            GroupList.DataBind();
        }

        protected void BtnSave_Click(object sender, EventArgs e)
        {
            #region Prepare

            if ((string)Session["User"] != "experimenter")
                Response.Redirect("~/Default.aspx");            

            if (Treat.SelectedIndex < 0)
            {
                BtnSave.Enabled = false;
                BtnActivate.Enabled = false;
                Message.Text = "Please create a treatment first.";
                return;
            }

            if (GroupList.EditIndex >= 0)            
                GroupList.UpdateRow(GroupList.EditIndex, false);            

            float TaNum = Convert.ToSingle(Ta.Text);
            float TfNum = Convert.ToSingle(Tf.Text);
            float TzNum = Convert.ToSingle(Tz.Text);

            if (0.0F <= TaNum && 0.0F <= TfNum && 0.0F <= TzNum)
            {
                Message.Text = "Consistent at " + DateTime.Now.ToString(Global.TimeFormat);
                BtnActivate.Enabled = true;
            }                
            else
            {                
                BtnActivate.Enabled = false;
                Message.Text = "Inconsistent at " + DateTime.Now.ToString(Global.TimeFormat);
                return;
            }

            //if (Convert.ToDateTime(Starting.Text) < DateTime.Now)
            //    BtnActivate.Enabled = false;

            //if (Period.Text.Length > 0)
            //{
            //    Message.Text = "Treatment " + Treat.SelectedIndex + " is active!";
            //    BtnActivate.Enabled = false;
            //}

            SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["ProcessTreeConnectionString"].ConnectionString);
            conn.Open();
            string query;
            SqlCommand com;

            #endregion

            query = @"update Treatments set Constitution = @Constitution , Hypothesis = @Hyp , Beta = @Beta, 
Ta = @Ta , Tf = @Tf , Tp = @Tp , Tv = @Tv , Te = @Te , Tz = @Tz , M = @M , Rv = @Rv , Ro = @Ro , Reward = @Reward , BetFee = @BetFee , SuggestionFee = @SuggestionFee, Compensation = @Compensation , V = @V , W = @W , E = @E , 
PerGroup = @PerGroup, VoteChange = @VoteChange, Valuation = @Valuation, AuctionSort = @AuctionSort, Meritocracy = @Meritocracy, Merit2All = @Merit2All , InitialBalance = @InitialBalance , InitialVolume = @InitialVolume where TID = "
+ Treat.SelectedValue;

            #region Execute

            com = new SqlCommand(query, conn);

            com.Parameters.AddWithValue("@Constitution", Constitution.Text.Trim().Replace("\n", "<br>").Replace("{", "<b>").Replace("}", "</b>").Replace("[[", "<a href=\"https://").Replace("%%", "/\" target = \"_blank\">").Replace("]]", "</a>"));
            com.Parameters.AddWithValue("@Hyp", Hypothesis.Text.Trim());

            //com.Parameters.AddWithValue("@Start", Convert.ToDateTime(Starting.Text));
            //if (Period.Text.Equals("") || Convert.ToInt32(Period.Text) == 0)
            //{
            //    com.Parameters.AddWithValue("@DT", Convert.ToDateTime(Starting.Text));
            //    DT.Text = Starting.Text;
            //}
            //else
            //{
            //    com.Parameters.AddWithValue("@DT", Convert.ToDateTime(DT.Text));
            //}                            

            com.Parameters.AddWithValue("@Beta", Beta.Text);

            com.Parameters.AddWithValue("@Tp", Tp.Text);
            com.Parameters.AddWithValue("@Tv", Tv.Text);
            com.Parameters.AddWithValue("@Te", Te.Text);
            com.Parameters.AddWithValue("@Ta", Ta.Text);            
            com.Parameters.AddWithValue("@Tf", Tf.Text);
            com.Parameters.AddWithValue("@Tz", Tz.Text);

            com.Parameters.AddWithValue("@M", M.Text);
            com.Parameters.AddWithValue("@Rv", Rv.Text);
            com.Parameters.AddWithValue("@Ro", Ro.Text);
            com.Parameters.AddWithValue("@Reward", Reward.Text);
            com.Parameters.AddWithValue("@BetFee", BetFee.Text);
            com.Parameters.AddWithValue("@SuggestionFee", SuggestionFee.Text);
            com.Parameters.AddWithValue("@Compensation", Compensation.Text);

            com.Parameters.AddWithValue("@InitialBalance", InitialBalance.Text);
            com.Parameters.AddWithValue("@InitialVolume", InitialVolume.Text);

            com.Parameters.AddWithValue("@V", V.Text);
            com.Parameters.AddWithValue("@W", W.Text);
            com.Parameters.AddWithValue("@E", E.Text);

            com.Parameters.AddWithValue("@PerGroup", PerGroup.Text);            

            com.Parameters.AddWithValue("@VoteChange", VoteChange.Checked);

            com.Parameters.AddWithValue("@Valuation", Valuation.SelectedValue);
            com.Parameters.AddWithValue("@AuctionSort", AuctionSort.Checked);

            com.Parameters.AddWithValue("@Meritocracy", RadioMeritocracy.SelectedIndex);
            com.Parameters.AddWithValue("@Merit2All", RadioMerit2All.SelectedIndex);

            if (com.ExecuteNonQuery() != 1)
            {
                Message.Text = "Error (303) with saving.";
                conn.Close();
                return;
            }

            #endregion

            query = "UPDATE Groups SET DT = DATEADD(minute," + Span.Text + ", Starting) WHERE Treatment = " + Treat.SelectedValue + "AND Period = -1";
            #region Execute
            com = new SqlCommand(query, conn);           

            if (com.ExecuteNonQuery() < 0)
            {
                Message.Text = "Error (714) with updating the initial artifact.";
                conn.Close();
                return;
            }
            #endregion

            query = "UPDATE Groups SET DT = DATEADD(minute," + Tz.Text + ", Starting) WHERE Treatment = " + Treat.SelectedValue + "AND Period > 0 AND DT > DATEADD(minute," + Tz.Text + ", Starting)";
            #region Execute
            com = new SqlCommand(query, conn);
            
            if (com.ExecuteNonQuery() < 0)
            {
                Message.Text = "Error (726) with updating the initial artifact.";
                conn.Close();
                return;
            }
            #endregion

            query = "UPDATE Groups SET DT = Starting WHERE Treatment = " + Treat.SelectedValue + "AND Period = 0 OR Period IS NULL";
            #region Execute
            com = new SqlCommand(query, conn);
            
            if (com.ExecuteNonQuery() < 0)
            {
                Message.Text = "Error (738) with updating the initial artifact.";
                conn.Close();
                return;
            }
            #endregion

            float ds = float.Parse(InitialVolume.Text, CultureInfo.InvariantCulture.NumberFormat);
            float n = float.Parse(PerGroup.Text, CultureInfo.InvariantCulture.NumberFormat);
            float b = float.Parse(Beta.Text, CultureInfo.InvariantCulture.NumberFormat); 

            float s = n * ds;
            float f1 = .5f * s * s + b * s;

            query = "update Versions set Artifact = @Artifact, HtmlArtifact = @HtmlArtifact, PerVal = @PerVal, Time = '" + DateTime.Now + "' where (Treatment= " + Treat.SelectedValue + " and Period = 2 and Choice = 0)";
            #region Execute
            com = new SqlCommand(query, conn);

            com.Parameters.AddWithValue("@PerVal", f1);
            com.Parameters.AddWithValue("@Artifact", Artifact.Text.Trim());            
            com.Parameters.AddWithValue("@HtmlArtifact", Artifact.Text.Replace("\r", "").Replace("\n", "<br>").Replace("\t", "&nbsp;&nbsp;&nbsp;&nbsp;"));

            if (com.ExecuteNonQuery() < 1)
            {
                Message.Text = "Error (320) with updating the initial artifact.";
                conn.Close();
                return;                              
            }
            #endregion

            Message.Text = "Saved at " + DateTime.Now.ToString(Global.TimeFormat);
            com.Dispose();
            conn.Close();

            GroupList.DataBind();
        }

        protected void BtnActivate_Click(object sender, EventArgs e)
        {                 
            if ((string)Session["User"] != "experimenter")
                Response.Redirect("~/Default.aspx");
    
            if (Treat.SelectedIndex < 0)
            {
                Message.Text = "No Treatment at " + DateTime.Now.ToString(Global.TimeFormat);
                BtnSave.Enabled = false;
                BtnActivate.Enabled = false;
                return;
            }

            if (0.0F <= Convert.ToSingle(Ta.Text) &&
                0.0F <= Convert.ToSingle(Tf.Text) &&
                0.0F <= Convert.ToSingle(Tz.Text))
            {
                Message.Text = "Consistent at " + DateTime.Now.ToString(Global.TimeFormat);
            }
            else
            {
                BtnActivate.Enabled = false;
                Message.Text = "Inconsistent at " + DateTime.Now.ToString(Global.TimeFormat);
                return;
            }

            SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["ProcessTreeConnectionString"].ConnectionString);
            conn.Open();

            BtnSave_Click(sender, e);
            //Period.Text = "0";
            //DT.Text = Starting.Text;

            string query = "update Groups set Period = 0 , DT = Starting where Treatment = " + Treat.SelectedValue + " and Period IS NULL";
            #region Execute

            SqlCommand com = new SqlCommand(query, conn);

            if (com.ExecuteNonQuery() < 0)
            {
                Message.Text = "Error (359) with activating the treatment: " + Treat.SelectedValue;
                conn.Close();
                return;
            }

            #endregion

            Message.Text = "Activated at " + DateTime.Now.ToString(Global.TimeFormat);
            BtnActivate.Enabled = false;

            com.Dispose();
            conn.Close();
            GroupList.DataBind();
        }

        protected void Back_Click(object sender, EventArgs e)
        {
            Session["User"] = null;
            Response.Redirect("~/Default.aspx");
        }

        protected void Ta_TextChanged(object sender, EventArgs e)
        {         
            if (Convert.ToSingle(Ta.Text) >= 0.0F )
            {
                Ta.BackColor = System.Drawing.Color.Yellow;                
            }
            else
            {
                Ta.BackColor = System.Drawing.Color.Red;                
            }            
            //DeadLine.Text = Convert.ToDateTime(Starting.Text).AddHours(Convert.ToSingle(Ta.Text)).ToString("s");    
        }

        protected void Tf_TextChanged(object sender, EventArgs e)
        {
            float SpanNum = Convert.ToSingle(Tz.Text) + Convert.ToSingle(Tf.Text);
            Span.Text = SpanNum.ToString("F1");
          
            if (Convert.ToSingle(Tf.Text) >= 0.0)
            {
                Tf.BackColor = System.Drawing.Color.Yellow;
            }
            else
            {
                Tf.BackColor = System.Drawing.Color.Red;
            }
            //Ending.Text = Convert.ToDateTime(Starting.Text).AddHours(SpanNum).ToString("s");
        }

        protected void Tp_TextChanged(object sender, EventArgs e)
        {
            if (Convert.ToSingle(Tp.Text) >= 0)
                Tp.BackColor = System.Drawing.Color.Yellow;
            else
                Tp.BackColor = System.Drawing.Color.Red;
        }

        protected void Tv_TextChanged(object sender, EventArgs e)
        {
            if (Convert.ToSingle(Tv.Text) >= 0)
                Tv.BackColor = System.Drawing.Color.Yellow;
            else
                Tv.BackColor = System.Drawing.Color.Red;
        }

        protected void Tz_TextChanged(object sender, EventArgs e)
        {
            float SpanNum = Convert.ToSingle(Tz.Text) + Convert.ToSingle(Tf.Text);
            Span.Text = SpanNum.ToString("F1");
         
            if (Convert.ToSingle(Tz.Text) >= 0.0)
            {
                Tz.BackColor = System.Drawing.Color.Yellow;
            }
            else
            {
                Tz.BackColor = System.Drawing.Color.Red;
            }          
            
            //Closing.Text = Convert.ToDateTime(Starting.Text).AddHours(Convert.ToSingle(Tz.Text)).ToString("s");
            //Ending.Text = Convert.ToDateTime(Starting.Text).AddHours(SpanNum).ToString("s");     
        }
   
        protected void W_TextChanged(object sender, EventArgs e)
        {
            if (Convert.ToInt32(W.Text) > 0)
            {
                RadioMerit2All.Enabled = true;
                RadioMeritocracy.Enabled =true;
                V.Enabled = true;
            }
            else
            {
                RadioMerit2All.Enabled = false;
                RadioMeritocracy.Enabled = false;
                V.Enabled = false;
            }
        }

        protected void GroupList_SelectedIndexChanged(object sender, EventArgs e)
        {
            Session["Treat"] = Treat.SelectedIndex;
            Session["Group"] = GroupList.SelectedIndex + 1;
            Session["DT"] = DateTime.Now.AddMinutes(10);

            if (PvH.Checked)            
                Response.Redirect("~/Participants.aspx");            
            else            
                Response.Redirect("~/Results.aspx");                     
        }

        protected void BtnEmail_Click(object sender, EventArgs e)
        {
            BtnEmail.Enabled = false;
            SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["ProcessTreeConnectionString"].ConnectionString);
            conn.Open();
            string Content = " ";
            string query = "SELECT * FROM People WHERE Treatment = " + Treat.SelectedIndex + " AND Completed IS NULL";
            SqlCommand com = new SqlCommand(query, conn);
            SqlDataReader Subjects = com.ExecuteReader();
            while (Subjects.Read())
            {
                Content = "Hello " + Subjects["Name"] + " ! <br>" +
                    "Please note that the experiment is conducted in the behavioral lab (CBA 6.402 and 6.499) in the McCombs School of Business.<br>" +
                    "See you before noon! <br>";
                try
                {
                    Global.Email(Subjects["ID"].ToString(), "Location of Experiment", Content);
                }
                catch
                {
                    Global.EmailAdmin("Error in Email", "ID = " + Subjects["ID"]);
                }
            }

            conn.Close();
        }

        protected void BtnReset_Click(object sender, EventArgs e)
        {
            SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["ProcessTreeConnectionString"].ConnectionString);
            conn.Open();

            string query = "EXEC ResetGroup @Treatment";
            SqlCommand com = new SqlCommand(query, conn);
            com.Parameters.AddWithValue("@Treatment", Treat.SelectedIndex);
            if (com.ExecuteNonQuery() < 1)
            {
                Global.EmailAdmin("Error 1080: Global.Refresh", "Treatment = " + Treat.SelectedIndex);
                Message.Text = "Error (1080) with ResetGroup.";
                conn.Close();
                return;
            }
           
            com.Dispose();

            conn.Close();
            
            Response.Redirect("~/ControlPanel.aspx");
        }
    }
}