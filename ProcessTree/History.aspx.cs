using System;

namespace ProcessTree
{
    public partial class History : System.Web.UI.Page
    {   
        protected void Page_Load(object sender, EventArgs e)
        {   
            if (Session["User"] == null || Session["Treat"] == null || Session["Group"] == null)
                Response.Redirect("~/Default.aspx");
                        
            // if (IsPostBack) return;

            LabelLogin.Text = "Your ID: " + Session["User"];

            int Period = Global.Refresh((int)Session["Treat"], (int)Session["Group"], out DateTime DT);

            if ((DateTime)Session["DT"] < DT)
                DT = (DateTime)Session["DT"];

            if (DT > DateTime.Now)
                TimeSpan.Text = (DT - DateTime.Now).TotalMilliseconds.ToString();
            else
                TimeSpan.Text = "0";

            CurrentPeriod.Text = Period.ToString();

            if (Period == -9)
            {
                LabelLogin.Text = "Experiment has not started yet!";
                return;                
            }

            if (Period <= 0)
                Period = 9999;                

            SqlDataSource4.SelectParameters.Clear();
            SqlDataSource4.SelectParameters.Add("Treatment", Session["Treat"].ToString());
            SqlDataSource4.SelectParameters.Add("Group", Session["Group"].ToString());
            SqlDataSource4.SelectParameters.Add("Period", Period.ToString());
            SqlDataSource4.DataBind();
        }

        protected void BtnReturn_Click(object sender, EventArgs e)
        {
            int Period = Global.Refresh((int)Session["Treat"], (int)Session["Group"], out DateTime DT);

            if (Period < -10 || Session["User"]==null) // Experiment Ended
                Response.Redirect("~/Default.aspx");                         
            else if (Period == -9) // Null : Experiment Not Started 
            {
                LabelLogin.Text = "Error (65) \n Please contact the admin: Law.Economist@Gmail.com";
                Global.EmailAdmin("Error 65: History", "UserID = " + Session["User"] + " & Treatment = " + Session["Treat"] + " & Group = " + Session["Group"]);
                return;       
            }
            else if (Period == 0) // Period = 0             
                Response.Redirect("~/Constitution.aspx");            
            else if (Period == -1 || Period == -2) // Final Period          
                Response.Redirect("~/Survey.aspx");            
            else if (Period % 2 == 1)  // Suggestion Period 
                Response.Redirect("~/Suggestion.aspx");
            else  // if (Period % 2 == 0) // Voting Period 
                Response.Redirect("~/Voting.aspx");
            
        }
    }
}