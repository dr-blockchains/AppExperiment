using System;
using System.Configuration;
using System.Data.SqlClient;

namespace ProcessTree
{
    public partial class ChangePeriod : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["User"] == null || Session["Treat"] == null || Session["Group"] == null)
                return;

            // TimeSpan.Text = ((DateTime)Session["DT"] - DateTime.Now).TotalMilliseconds.ToString();

            SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["ProcessTreeConnectionString"].ConnectionString);
            conn.Open();
            string query = "select Period from Groups where Treatment =" + Session["Treat"] + " and Group# = " + Session["Group"];            
            SqlCommand com = new SqlCommand(query, conn);                      

            Response.Write((com.ExecuteScalar() ?? 0).ToString());

            conn.Close();
        }
    }
}