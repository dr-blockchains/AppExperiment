using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Globalization;

namespace ProcessTree
{
    public partial class Results : System.Web.UI.Page
    {   
        protected void Page_Load(object sender, EventArgs e)
        {   
            if ((string)Session["User"]!="experimenter" || Session["Treat"] == null || Session["Group"] == null)
                Response.Redirect("~/Default.aspx");

            if (Session["Period"] == null || (int)Session["Period"] < 4)
            {
                Backward.Enabled = false;
                Session["Period"] = 2;
            }                

            LabelP.Text = ((int)Session["Period"]/2).ToString();

            if (IsPostBack)
                return;

            LabelLogin.Text = "Treat = " + Session["Treat"] + "  | |    Group = " + Session["Group"];
            SqlDataSource4.SelectParameters.Clear();
            SqlDataSource4.SelectParameters.Add("Period", Session["Period"].ToString());
            SqlDataSource4.SelectParameters.Add("Treatment", Session["Treat"].ToString());
            SqlDataSource4.SelectParameters.Add("Group", Session["Group"].ToString());            
            SqlDataSource4.DataBind();
        }

        protected void BtnReturn_Click(object sender, EventArgs e)
        {
            if ((string)Session["User"] == "experimenter")
                Response.Redirect("~/ControlPanel.aspx");
            else
                Response.Redirect("~/Default.aspx");
        }

        protected void Forward_Click(object sender, EventArgs e)
        {
            Session["Period"] = (int)Session["Period"] + 2;            
            LabelP.Text = ((int)Session["Period"] / 2).ToString();
            Backward.Enabled = true;

            RadioVersions.Items.Clear();

            SqlDataSource4.SelectParameters.Clear();
            SqlDataSource4.SelectParameters.Add("Period", Session["Period"].ToString());
            SqlDataSource4.SelectParameters.Add("Treatment", Session["Treat"].ToString());
            SqlDataSource4.SelectParameters.Add("Group", Session["Group"].ToString());
            SqlDataSource4.DataBind();
        }

        protected void Backward_Click(object sender, EventArgs e)
        {            
            if (Session["Period"] == null || (int)Session["Period"] < 6)
            {
                Session["Period"] = 2;
                Backward.Enabled = false;
            }
            else
            {
                Session["Period"] = (int)Session["Period"] - 2;
            }
            
            LabelP.Text = ((int)Session["Period"] / 2).ToString();

            RadioVersions.Items.Clear();

            SqlDataSource4.SelectParameters.Clear();
            SqlDataSource4.SelectParameters.Add("Period", Session["Period"].ToString());
            SqlDataSource4.SelectParameters.Add("Treatment", Session["Treat"].ToString());
            SqlDataSource4.SelectParameters.Add("Group", Session["Group"].ToString());
            SqlDataSource4.DataBind();
        }

        protected void DeleteBtn_Click(object sender, EventArgs e)
        {
            if(RadioVersions.SelectedIndex < 0)
            {
                Message.Text = "You must select a version to edit.";
                return;
            }

            SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["ProcessTreeConnectionString"].ConnectionString);
            conn.Open();

            string query = "EXEC Del @Treatment, @Group, @Period, @Choice";

            SqlCommand com = new SqlCommand(query, conn);
            com.Parameters.AddWithValue("@Treatment", Session["Treat"]);
            com.Parameters.AddWithValue("@Group", Session["Group"]);
            com.Parameters.AddWithValue("@Period", Session["Period"]);
            com.Parameters.AddWithValue("@Choice", RadioVersions.SelectedValue);

            if (com.ExecuteNonQuery() < 1)
                Global.EmailAdmin("Error 99: Results", "Choice = " + RadioVersions.SelectedValue + " & Period = " + Session["Period"]);

            conn.Close();
            Response.Redirect("~/Results.aspx");
        }

        protected void AddBtn_Click(object sender, EventArgs e)
        {
            int choice;
            if(RadioVersions.SelectedIndex < 0)            
                choice = 0;            
            else            
                choice = Convert.ToInt16(RadioVersions.SelectedValue);

            SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["ProcessTreeConnectionString"].ConnectionString);
            conn.Open();

            string query = "DELETE FROM Shares WHERE Treatment = @Treatment AND Group# = @Group AND Period = @Period AND Choice = @Choice";

            SqlCommand com = new SqlCommand(query, conn);
            com.Parameters.AddWithValue("@Treatment", Session["Treat"]);
            com.Parameters.AddWithValue("@Group", Session["Group"]);
            com.Parameters.AddWithValue("@Period", Session["Period"]);
            com.Parameters.AddWithValue("@Choice", choice + 1);

            if (com.ExecuteNonQuery() < 0)
                Global.EmailAdmin("Error 519: Suggestion", "UserID = " + Session["User"] + " & Treatment = " + Session["Treat"]);

            query = "UPDATE Versions SET Choice = Choice + 1 WHERE Treatment = @Treatment AND Group# = @Group AND Period = @Period AND Choice > @Choice";

            com = new SqlCommand(query, conn);
            com.Parameters.AddWithValue("@Treatment", Session["Treat"]);
            com.Parameters.AddWithValue("@Group", Session["Group"]);
            com.Parameters.AddWithValue("@Period", Session["Period"]);
            com.Parameters.AddWithValue("@Choice", choice);

            if (com.ExecuteNonQuery() < 0)
                Global.EmailAdmin("Error 519: Suggestion", "UserID = " + Session["User"] + " & Treatment = " + Session["Treat"]);

            query = @"INSERT INTO Versions (Treatment, Group#, Period, Choice, Artifact, HtmlArtifact, Proposer, Time, Score, PerVal)
                Values (@Treatment, @Group, @Period, @Choice, 'Empty', 'EmptyHTML', 'experimenter', GETDATE(), 0, 0)";
            
            com = new SqlCommand(query, conn);
            com.Parameters.AddWithValue("@Treatment", Session["Treat"]);
            com.Parameters.AddWithValue("@Group", Session["Group"]);
            com.Parameters.AddWithValue("@Period", Session["Period"]);
            com.Parameters.AddWithValue("@Choice", choice + 1 );
            
            if (com.ExecuteNonQuery() != 1)
                Global.EmailAdmin("Error 519: Suggestion", "UserID = " + Session["User"] + " & Treatment = " + Session["Treat"]);

            conn.Close();
            EditBtn.Focus();
            Response.Redirect("~/Results.aspx");
        }

        protected void EditBtn_Click(object sender, EventArgs e)
        {
            if(RadioVersions.SelectedIndex<0)
            {
                Message.Text = "You must select a version to edit.";
                return;
            }

            SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["ProcessTreeConnectionString"].ConnectionString);
            conn.Open();

            string query = "select Artifact, PerVal from Versions where Treatment = " + Session["Treat"] + " and Group# = " + Session["Group"] + 
                " and Period = " + ((int)Session["Period"]) + " and choice = " + RadioVersions.SelectedValue;

            SqlCommand com = new SqlCommand(query, conn);
            SqlDataReader DataReader = com.ExecuteReader();

            if (!DataReader.Read())
            {
                txtArtifact.Text = "No such version exists!";
                return;
            }
                
            txtArtifact.Text = DataReader["Artifact"].ToString();
            Performance.Text = DataReader["PerVal"].ToString();

            txtArtifact.Focus();

            BtnSubmit.Enabled = true;
            txtArtifact.Enabled = true;

            conn.Close();
        }

        protected void BtnSubmit_Click(object sender, EventArgs e)
        {
            if (!Session["User"].Equals("experimenter"))
                Response.Redirect("~/Default.aspx");

            if(RadioVersions.SelectedIndex < 0)
            {
                Message.Text = "No choice is specified!";
                RadioVersions.Focus();
                return;
            }
                
            txtArtifact.Text = txtArtifact.Text.Trim();

            if (txtArtifact.Text.Length < 10 || txtArtifact.Text.Length > 2000)
            {
                ClientScript.RegisterStartupScript(GetType(), "Attention", "alert('The plan should be between 10 and 2000 characters!');", true);
                txtArtifact.Focus();
                return;
            }

            float P;
            try
            {
                P = float.Parse(Performance.Text, CultureInfo.InvariantCulture.NumberFormat);
            }
            catch
            {
                Performance.Focus();
                Message.Text = "Performance / Value is not in proper format!";
                return;
            }

            SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["ProcessTreeConnectionString"].ConnectionString);
            conn.Open();
                        
            string query = "UPDATE Versions SET Artifact = @Artifact, Time = GETDATE(), HtmlArtifact = @HtmlArtifact, PerVal = @P " +
                    "WHERE Treatment = @Treatment AND Group# = @Group AND Period = @Period AND Choice = @Choice";

            SqlCommand com = new SqlCommand(query, conn);
            com.Parameters.AddWithValue("@Treatment", Session["Treat"]);
            com.Parameters.AddWithValue("@Group", Session["Group"]);
            com.Parameters.AddWithValue("@Period", Session["Period"]);
            com.Parameters.AddWithValue("@Choice", RadioVersions.SelectedValue);
            com.Parameters.AddWithValue("@Artifact", txtArtifact.Text);
            com.Parameters.AddWithValue("@HtmlArtifact", txtArtifact.Text.Replace("\n","<br/>").Replace("\r", ""));
            com.Parameters.AddWithValue("@P", Performance.Text);

            if (com.ExecuteNonQuery() != 1)
            {
                Message.Text = "Error (405). \n Please contact the admin: Law.Economist@Gmail.com";
                Global.EmailAdmin("Error 405: Suggestion", "UserID = " + Session["User"] + " & Treatment = " + Session["Treat"]);
            }

            BtnSubmit.Enabled = false;
            txtArtifact.Enabled = false;

            conn.Close();
            Response.Redirect("~/Results.aspx");            
        }

        protected void RadioVersions_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (RadioVersions.SelectedIndex < 0)
            {
                Message.Text = "You must select a version.";
                return;
            }

            Message.Text = "<i> Version: " + RadioVersions.SelectedValue + " from Round: " + (int)Session["Period"] / 2 + "</i>";

            SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["ProcessTreeConnectionString"].ConnectionString);
            conn.Open();

            string query = "select Artifact, PerVal from Versions where Treatment = " + Session["Treat"] + " and Group# = " + Session["Group"] +
                " and Period = " + ((int)Session["Period"]) + " and choice = " + RadioVersions.SelectedValue;

            SqlCommand com = new SqlCommand(query, conn);
            SqlDataReader DataReader = com.ExecuteReader();

            if (!DataReader.Read())
            {
                txtArtifact.Text = "No such version exists!";
                return;
            }

            txtArtifact.Text = DataReader["Artifact"].ToString();
            Performance.Text = DataReader["PerVal"].ToString();

            txtArtifact.Focus();

            BtnSubmit.Enabled = true;
            txtArtifact.Enabled = true;

            SqlDataSource1.SelectParameters.Clear();
            SqlDataSource1.SelectParameters.Add("Treatment", Session["Treat"].ToString());
            SqlDataSource1.SelectParameters.Add("Group", Session["Group"].ToString());
            SqlDataSource1.SelectParameters.Add("Period", Session["Period"].ToString());
            SqlDataSource1.SelectParameters.Add("Choice", RadioVersions.SelectedValue);

            conn.Close();
        }
    }
}