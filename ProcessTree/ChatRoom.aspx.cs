using System;
using System.Data.SqlClient;
using System.Configuration;

namespace ProcessTree
{
    public partial class ChatRoom : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["User"] == null || Session["Treat"] == null || Session["Group"] == null)
                Response.Redirect("~/Default.aspx");

            SqlDataSource1.SelectParameters.Clear();
            SqlDataSource1.SelectParameters.Add("Treatment", Session["Treat"].ToString());
            SqlDataSource1.SelectParameters.Add("Group", Session["Group"].ToString());            
            SqlDataSource1.DataBind();
        }

        protected void BtnRefresh_Click(object sender, EventArgs e)
        {
            SqlDataSource1.DataBind();
            Response.Redirect("~/ChatRoom.aspx");
        }

        protected void BtnSend_Click(object sender, EventArgs e)
        {
            string message = TxtMessage.Text.Trim();
            if (message.Length < 1) return;

            // Inser the message into the database.

            if (Session["User"] == null)
                Response.Redirect("~/Default.aspx");

            if (TxtMessage.Text.Trim().Length > 990)
            {
                ClientScript.RegisterStartupScript(GetType(), "Attention", "alert('Your message is too long! Please shorten it!');", true);
                TxtMessage.Focus();
                return;
            }

            SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["ProcessTreeConnectionString"].ConnectionString);
            conn.Open();
            string query;
            SqlCommand com;

            query = "INSERT INTO CHATS Values (@Treatment, @Group, @Writer, GETDATE(), @Message)";

            com = new SqlCommand(query, conn);

            com.Parameters.AddWithValue("@Treatment", Session["Treat"]);
            com.Parameters.AddWithValue("@Group", Session["Group"]);
            com.Parameters.AddWithValue("@Writer", Session["User"]);
            com.Parameters.AddWithValue("@Message", TxtMessage.Text.Trim().Replace("\n", "<br>"));

            try
            {
                if (com.ExecuteNonQuery() != 1)
                {
                    BtnSend.Text = "Error (64). \n Please contact the admin: Law.Economist@Gmail.com";
                    Global.EmailAdmin("Error 64: Chats", "UserID = " + Session["User"] + " & Treatment = " + Session["Treat"]);
                    conn.Close();
                    return;
                }
            }
            catch (Exception Ex)
            {
                BtnSend.Text = "Error (72). \n Please contact the admin: Law.Economist@Gmail.com";
                Global.EmailAdmin("Error 72: Chats", "UserID = " + Session["User"] + " & Treatment = " + Session["Treat"]+ " Exception = " + Ex.ToString());
                conn.Close();
                return;
            }

            TxtMessage.Text = "";
            TxtMessage.Focus();

            conn.Close();
            SqlDataSource1.DataBind();
            Response.Redirect("~/ChatRoom.aspx");
        }

        protected void TxtMessage_TextChanged(object sender, EventArgs e)
        {
            if(TxtMessage.Text.Trim().Length > 0)
                BtnSend.Focus();
        }
    }
}