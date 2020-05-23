<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ChangePass.aspx.cs" Inherits="ProcessTree.ChangePass" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Edit Profile</title>
    <style type="text/css">
        .style1
        {
            
        }
        .style2
        {
            
        }
        .style3
        {
            
            text-align: right;
        }
        .auto-style1 {
            
            text-align: right;
            height: 23px;
        }
        .auto-style2 {
            
            height: 23px;
        }
        .auto-style3 {
            height: 23px;
        }
        .style32
        {
            color: #003300;
            font-size: x-large;
            background-color: #FFFFFF;
            font-family: Roman;
            text-align: center;
        }
        </style>    
        <link href="StyleSheet.css" rel="stylesheet" type="text/css" />
</head>
<body>
    <form id="ChangePass" runat="server">
    <div>
    
        <table class="style1">
            <tr>
                <td class="auto-style1">
                    Username :&nbsp;&nbsp;&nbsp;
                </td>
                <td class="auto-style2">
                <asp:TextBox ID="TextUser" runat="server" Width="100%" TabIndex="1" ReadOnly="True"></asp:TextBox>
                </td>
                <td class="auto-style3">
                    <asp:Label ID="LabelUser" runat="server" Font-Bold="True" ForeColor="Red"></asp:Label>
                    </td>
            </tr>
            <tr>
                <td class="style3">
                    Current Password:&nbsp; </td>
                <td class="style2">
                    <asp:TextBox ID="TextPassword" runat="server" TextMode="Password" 
                        MaxLength="50" TabIndex="2" Width="120px"></asp:TextBox>
                    </td>
                <td>
                    <asp:Label ID="LabelPass" runat="server" Font-Bold="True" ForeColor="Red"></asp:Label>
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" 
                        ControlToValidate="TextPassword" ErrorMessage="Password is required." 
                        Font-Bold="True" ForeColor="Red" SetFocusOnError="True"></asp:RequiredFieldValidator>
                </td>
            </tr>
            <tr>
                <td class="style3">
                    &nbsp;</td>
                <td class="style2">
                    &nbsp;</td>
                <td>
                    &nbsp;</td>
            </tr>
            <tr>
                <td class="style3">
                    New Password: 
                </td>
                <td class="style2">
                    <asp:TextBox ID="TextPass" runat="server" TextMode="Password" 
                        MaxLength="50" TabIndex="3" Width="120px"></asp:TextBox>
                    </td>
                <td>
                    <asp:RegularExpressionValidator ID="RegularExpressionValidator2" runat="server" 
                        ControlToValidate="TextPass" ErrorMessage="Password must be 8-18 characters." 
                        Font-Bold="True" ForeColor="Red" 
                        ValidationExpression="[\S\s]{8,18}" SetFocusOnError="True"></asp:RegularExpressionValidator>
                    <br />
                    <asp:CompareValidator ID="CompareValidator1" runat="server" 
                        ControlToCompare="TextPass" ControlToValidate="TextRPass" 
                        ErrorMessage="Passwords must be the same." Font-Bold="True" ForeColor="Red"></asp:CompareValidator>
                </td>
            </tr>
            <tr>
                <td class="style3">
                    Confirm New Password: 
                </td>
                <td class="style2">
                    <asp:TextBox ID="TextRPass" runat="server" MaxLength="50" 
                        TextMode="Password" TabIndex="4" Width="120px"></asp:TextBox>
                    </td>
                <td>
                    <asp:CompareValidator ID="CompareValidator2" runat="server" 
                        ControlToCompare="TextRPass" ControlToValidate="TextPass" 
                        ErrorMessage="Passwords must be the same." Font-Bold="True" ForeColor="Red"></asp:CompareValidator>
                    <br />
                </td>
            </tr>
            <tr>
                <td class="style2">
                    &nbsp;</td>
                <td class="style2">
                    &nbsp;</td>
                <td>
                    <asp:Label ID="LabelError" runat="server" Font-Bold="True" ForeColor="Red"></asp:Label>
                    </td>
            </tr>
            <tr>
                <td class="style3">
                    Chosen NickName:</td>
                <td class="style2">
                    <asp:TextBox ID="TextName" runat="server" 
                        MaxLength="50" TabIndex="5" Width="120px"></asp:TextBox>
                    </td>
                <td>
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator5" runat="server" 
                        ControlToValidate="TextName" ErrorMessage="A name is required." 
                        Font-Bold="True" ForeColor="Red" SetFocusOnError="True"></asp:RequiredFieldValidator>
                    </td>
            </tr>
            <tr>
                <td class="style2">
                    &nbsp;</td>
                <td class="style2">
                    &nbsp;</td>
                <td>
                    &nbsp;</td>
            </tr>
            <tr>
                <td class="style2">
                    <asp:Button ID="BtnOk" runat="server" onclick="BtnOk_Click" Text="Update" 
                        TabIndex="6" style="height: 26px" />
                </td>
                <td class="style2">
                    <asp:Button ID="BtnCancel" runat="server" onclick="BtnCancel_Click" 
                        Text="Cancel" CausesValidation="False" PostBackUrl="~/Default.aspx" 
                        TabIndex="7" />
                </td>
                <td>
                    &nbsp;</td>
            </tr>
        </table>
    
    </div>
    </form>
</body>
</html>