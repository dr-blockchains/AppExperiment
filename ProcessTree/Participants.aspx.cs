using System;

namespace ProcessTree
{
    public partial class Participants : System.Web.UI.Page
    {   
        protected void Page_Load(object sender, EventArgs e)
        {   
            if ((string)Session["User"] != "experimenter" || Session["Treat"] == null || Session["Group"] == null)
                Response.Redirect("~/Default.aspx");
                        
            if (IsPostBack)               
                return;

            LabelLogin.Text = "Treat = " + Session["Treat"] + "  | |    Group = " + Session["Group"];

            SqlDataSource4.SelectParameters.Clear();
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
    }
}