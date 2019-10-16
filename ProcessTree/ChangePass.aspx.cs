using System;
using System.Linq;
using System.Data.SqlClient;
using System.Configuration;
using System.Text;
using System.Security.Cryptography;

namespace ProcessTree
{
    public partial class ChangePass : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["User"] == null)
                Response.Redirect("~/Default.aspx");

            if (IsPostBack) return;

            TextUser.Text = (string)Session["User"];

            #region Valid User?

            SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["ProcessTreeConnectionString"].ConnectionString);
            conn.Open();

            string query = "select * from People where ID = @User";
            SqlCommand com = new SqlCommand(query, conn);
            com.Parameters.AddWithValue("@User", Session["User"]);

            SqlDataReader User = com.ExecuteReader();

            if (!User.Read())
            {
                LabelUser.Text = "Error (30). Please contact the admin: Law.Economist@Gmail.com";
                Global.EmailAdmin("Error 30: ChangePass", "Session =" + Session["User"] + " & UserID =" + User["ID"]);
                BtnOk.Enabled = false;
                return;
            }

            //if (!(bool)User["Verified"] || !User["Completed"].Equals(DBNull.Value))
            //{
            //    LabelUser.Text = "You cannot edit your profile. Please contact the admin: Law.Economist@Gmail.com";
            //    BtnOk.Enabled = false;
            //    return;
            //}

            #endregion

            TextName.Text = (string) User["Name"];

            conn.Close();            
        }

        protected void BtnOk_Click(object sender, EventArgs e)
        {
            #region Prepare
            if (TextPassword.Text == "")
            {
                LabelPass.Text = "Please enter your password!";
                return;
            }

            if (TextPass.Text != TextRPass.Text)
            {
                LabelError.Text = "Passwords do not match!";
                return;
            }

            if (TextName.Text.Trim() == "")
            {
                LabelError.Text = "Name cannot be blank!";
                return;
            }            

            SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["ProcessTreeConnectionString"].ConnectionString);
            conn.Open();

            #endregion           

            string query = "select * from People where ID = @ID";
            #region Execute

            SqlCommand com = new SqlCommand(query, conn);
            com.Parameters.AddWithValue("@ID", TextUser.Text);

            SqlDataReader User = com.ExecuteReader();            

            if (!User.Read())
            {
                LabelUser.Text = "Wrong Username!";
                conn.Close();
                return;
            }
            #endregion

            #region Check Password

            string StringToHash = TextPassword.Text + User["Nonce"];
            byte[] ByteArrayToHash = Encoding.UTF8.GetBytes(StringToHash);
            HashAlgorithm algorithm = new SHA256Managed();
            byte[] HashResult = algorithm.ComputeHash(ByteArrayToHash); 

            if (!HashResult.SequenceEqual((byte[])User["HashP"]))
            {
                LabelPass.Text = "Wrong Password!";
                ClientScript.RegisterStartupScript(GetType(), "Attention", "alert('If you forgot your password please contact the admin: Law.Economist@Gmail.com');", true);
                conn.Close();
                return;
            }
            #endregion

            #region Update Password and Name

            StringToHash = ((TextPass.Text=="")? TextPassword.Text : TextPass.Text) + User["Nonce"];              
            ByteArrayToHash = Encoding.UTF8.GetBytes(StringToHash);
            algorithm = new SHA256Managed();
            HashResult = algorithm.ComputeHash(ByteArrayToHash); 
            query = "update People set HashP = @HashP , Name = @Name where ID = @ID";
            com = new SqlCommand(query, conn);
            com.Parameters.AddWithValue("@HashP", HashResult);
            com.Parameters.AddWithValue("@Name", TextName.Text);
            com.Parameters.AddWithValue("@ID", TextUser.Text);

            User.Close();

            if (com.ExecuteNonQuery() != 1)
            {
                LabelPass.Text = "Error (130). Please contact the admin: Law.Economist@Gmail.com";
                Global.EmailAdmin("Error 130: ChangePass", "ID =" + TextUser.Text + " & UserID =" + User["ID"]);
                conn.Close();
                return;
            }

            #endregion

            conn.Close();
            Response.Redirect("~/Default.aspx");
        }

         protected void BtnCancel_Click(object sender, EventArgs e)
        {
            Response.Redirect("~/Default.aspx");
        }
    }
}