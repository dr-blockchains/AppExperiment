<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="ProcessTree.Main"%>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Constitution Experiment</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css"/>    
    <style type="text/css">
        .style1
        {
            width: 99%;
            height: 111px;
        }
        .style2
        {
            text-align: left;
            width: 377px;
        }
        .style3
        {
            width: 459px;
        }
        .style4
        {
            width: 1066px;
        }
        .style5
        {
            text-align: right;
            width: 377px;
            height: 97px;
        }
        .style6
        {
            width: 459px;
            height: 97px;
        }
        .style7
        {
            width: 1066px;
            height: 97px;
        }
        .style8
        {
            text-align: right;
            width: 400px;
        }
        .style9
        {
            width: 377px;
            height: 30px;
        }
        .style10
        {
            width: 459px;
            height: 30px;
        }
        .style11
        {
            width: 1066px;
            height: 30px;
        }
        .auto-style12 {
            text-align: left;
            width: 883px;
            height: 26px;
        }
        .style13
        {
            width: 1093px;
            text-align: left;
            height: 62px;
            color: #FF0066;
            font-family: "Times New Roman", Times, serif;
        }
        .style32
        {
            color: #003300;
            font-size: x-large;
            background-color: #FFFFFF;
            font-family: Roman;
            text-align: center;
        }
        .style25
        {
            width: 438px;
            height: 26px;
            text-align: right;
        }
        .style22
        {
            width: 167px;
            height: 26px;
            text-align: right;
        }
        .style26
        {
            width: 438px;
            height: 23px;
            text-align: right;
        }
        .style21
        {
            width: 167px;
            height: 23px;
            text-align: right;
        }
        .style27
        {
            width: 438px;
            height: 25px;
            text-align: right;
        }
        .style23
        {
            width: 167px;
            height: 25px;
            text-align: right;
        }
        .style28
        {
            width: 438px;
            height: 34px;
            text-align: right;
        }
        .style24
        {
            width: 167px;
            height: 34px;
            text-align: right;
        }
        .auto-style23 {
            text-align: left;
            height: 12px;
            font-size: x-large;
            color: #006600;
        }
        .auto-style39 {
            width: 1121px;
            text-align: center;
        }
        .auto-style53 {
            width: 514px;
            height: 26px;
            text-align: right;
        }
        .auto-style54 {
            height: 14px;
            text-align: left;
            color: #000066;
        }
        .auto-style56 {
            width: 98%;            
            font-size: medium;
        }
        .auto-style57 {
            height: 1px;
            text-align: left;
        }
        .auto-style61 {
            height: 31px;
            text-align: left;
        }
        .auto-style62 {
            height: 32px;
            text-align: left;
        }
        .auto-style65 {
            color: #003300;
            font-size: x-large;
        }
        .auto-style72 {
            width: 1121px;
            height: 1px;
            text-align: right;
        }
        .auto-style74 {
            width: 902px;
            text-align: left;
            height: 123px;
            color: #cde;            
        }
        .auto-style75 {
            width: 1000px;
            height: 979px;
        }
        .auto-style79 {
            height: 5px;
            background-color: #CCCCFF;
            width: 100%;
        }
        .auto-style80 {
            width: 514px;
            height: 40px;
            text-align: right;
        }
        .auto-style81 {
            width: 883px;
            height: 40px;
        }
        .auto-style82 {
            width: 1121px;
            height: 40px;
        }
        .auto-style83 {
            width: 514px;
            height: 12px;
            text-align: right;
        }
        .auto-style84 {
            width: 883px;
            height: 12px;
        }
        .auto-style85 {
            width: 1121px;
            height: 12px;
        }
        .auto-style87 {
            width: 514px;
            height: 33px;
            text-align: right;
        }
        .auto-style88 {
            width: 883px;
            height: 33px;
        }
        .auto-style89 {
            width: 1121px;
            height: 33px;
        }
        .auto-style90 {
            width: 514px;
            height: 28px;
            text-align: right;
        }
        .auto-style91 {
            width: 883px;
            height: 28px;
        }
        .auto-style92 {
            width: 1121px;
            height: 28px;
        }
        .auto-style93 {
            width: 514px;
            height: 27px;
            text-align: right;
        }
        .auto-style94 {
            width: 883px;
            height: 27px;
        }
        .auto-style95 {
            width: 1121px;
            height: 27px;
        }
        .auto-style98 {
            font-size: medium;
        }
        .auto-style99 {
            height: 3%;
        }
        a:link
	{color:blue;
	text-decoration:underline;	
        }
        .auto-style100 {
            color: blue;
            text-decoration: underline;
        }
        .auto-style101 {
            width: 201px;
            height: 31px;
            text-align: right;
        }
        .auto-style102 {
            width: 201px;
            height: 32px;
            text-align: right;
        }
        .auto-style103 {
            width: 100%;
        }
        .auto-style104 {
            width: 100%;
            height: 133px;
            text-align: left;
            background-color: #DDDDFF;            
        }
        </style>
   
    <script src="Timer.js"></script>

    <script>        
        if (window.navigator.userAgent.indexOf("Trident") > 0)
            alert('This website does not support Internet Explorer. Please use another browser.');

    </script>

    <link href="StyleSheet.css" rel="stylesheet" type="text/css" />
</head>
<body style="width: 95%;">     
    <form id="loginform" runat="server" class="auto-style103">
        <table class="auto-style104" >
        <tr>
            <td class="auto-style74" rowspan="3">
                <asp:Label ID="LabelLogin" runat="server" 
                    Text="Your Username is your Worker ID." Width="100%" Height="52px" CssClass="login"></asp:Label>
                <br />
                <br />
                <span class="auto-style65">Please log in if you already registered.</span></td>
            <td class="auto-style101">
                <strong>Username: </strong></td>
            <td class="auto-style61">
                <asp:TextBox ID="TextUser" runat="server" Width="225px" TabIndex="1" OnTextChanged="TextUser_TextChanged"></asp:TextBox>
            </td>
        </tr>
        <tr>
            <td class="auto-style102">
                <strong>Password:</strong></td>
            <td class="auto-style62">
                <asp:TextBox ID="TextPassword" runat="server" TextMode="Password" 
                    Width="95px" TabIndex="2"></asp:TextBox>
            &nbsp;&nbsp;&nbsp;&nbsp;<asp:Button ID="BtnLogin" runat="server" onclick="BtnLogin_Click" 
                    Text=" Log In " Font-Bold="True" TabIndex="3" CausesValidation="False" EnableTheming="True" Width="94px" />
                </td>
        </tr>
        <tr>
            <td class="text-left">
                &nbsp;</td>
            <td class="text-left">
                <asp:CheckBox ID="ChkEdit" runat="server" Text="Edit my Profile" TabIndex="4" BorderStyle="None" BorderWidth="0px" Width="233px" Height="45px" />
            </td>
        </tr>
        </table>
   

    <div id="SignUp" >   
        <hr class="auto-style79"/>
           <br />
        <p class="auto-style23">
            Registration Form:<span class="auto-style98"> </span>
        </p>
           <p class="auto-style23">
               &nbsp;</p>
                <hr />
             <table class="auto-style75">
            <tr>
                <td class="auto-style80">
                    Nickname:
                </td>
                <td class="auto-style81">
                    <asp:TextBox ID="NickName" runat="server" AutoCompleteType="FirstName" 
                        MaxLength="50" TabIndex="5" Width="68px"></asp:TextBox>
                    *</td>
                <td class="auto-style82">
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" 
                        ControlToValidate="NickName" ErrorMessage="Make a Pseudo-Name!" 
                        Font-Bold="True" ForeColor="Red" SetFocusOnError="True"></asp:RequiredFieldValidator>
                </td>
            </tr>
            <tr>
                <td class="auto-style80">
                    Age: </td>
                <td class="auto-style81">
                    <asp:TextBox ID="Age" runat="server" MaxLength="50" TabIndex="6" TextMode="Number"></asp:TextBox>
                </td>
                <td class="auto-style82">
                    <asp:CompareValidator ID="CompareValidator2" runat="server" ControlToValidate="Age" ErrorMessage="You must be at least 18 years old!" Font-Bold="True" ForeColor="Red" Operator="GreaterThanEqual" Type="Integer" ValueToCompare="18"></asp:CompareValidator>
                </td>
            </tr>
            <tr>
                <td class="auto-style80">
                    Education:</td>
                <td class="auto-style81">
                    <asp:TextBox ID="Education" runat="server" MaxLength="50" TabIndex="7"></asp:TextBox>
                </td>
                <td class="auto-style82">
                    &nbsp;</td>
            </tr>
            <tr>
                <td class="auto-style80">
                    Gender:
                </td>
                <td class="auto-style81">
                    <asp:RadioButtonList ID="Gender" runat="server" RepeatDirection="Horizontal" TabIndex="8">
                        <asp:ListItem Value="0">Male</asp:ListItem>
                        <asp:ListItem Value="1">Female</asp:ListItem>
                    </asp:RadioButtonList>
                </td>
                <td class="auto-style82">
                    </td>
            </tr>
            <tr>
                <td class="auto-style80">
                    &nbsp;</td>
                <td class="auto-style81">
                    <asp:CheckBox ID="EnglishSpeaker" runat="server" Text="Native English speaker" TabIndex="9" />
                </td>
                <td class="auto-style82">
                    </td>
            </tr>
            <tr>
                <td class="auto-style83">
                    </td>
                <td class="auto-style84">
                    </td>
                <td class="auto-style85">
                    </td>
            </tr>
            <tr>
                <td class="auto-style54" colspan="3">
                    <strong>Research disclosure (agreement):</strong></td>
            </tr>
            <tr>
                <td colspan="3" class="auto-style99">
                  <div style="padding: 8px; border: 1px solid #999; text-align: justify; display: block; background-color: #cde;" class="auto-style56" id="Agreement">
                      <p class="MsoNormal">
                          <span>The purpose of this research is to study how people can collaborate and compete to select a solution (portfolio) for a problem (investment). This study can provide useful knowledge to design better decision making processes for organizations. The participants can enjoy a fun learning experience and earn some money.<o:p></o:p></span></p>
                      <p class="MsoNormal">
                          <span>After signing up, you will see a green box containing the instructions and the rules of the game. To participate, you must read all the instructions and answer a few questions correctly. During the game, you should evaluate different choices that you will see in a yellow box. At the end, you must complete a short survey to receive a completion code and get paid at least $5 and at most $50 according to the instructions. Otherwise, you will not be eligible for payment. <o:p></o:p></span>
                      </p>
                      <p class="MsoNormal">
                          <span>Participation in this study takes about one hour. Your participation in this research is voluntary and you may choose not to participate at all or to stop participating at any time or refuse to participate in certain parts or answer certain questions. To participate, you should enter a name (nickname) for yourself. You are not required to reveal your real identity, but you may choose to do so for recognition on your contributions. No sensitive information will be collected, and all your information except your nickname will be kept confidential. There are no risks to you than normal daily life.<o:p></o:p></span></p>
                      <p class="MsoNormal">
                          <span>If you have any questions or concerns, please contact the Principal Investigator: <span class="auto-style100" style="text-underline: single;"><i><a href="https://www.mccombs.utexas.edu/Directory/Profiles/Khaledi-Hamed" target="_blank">Dr. Hamed Khaledi</a></i></span>.<o:p></o:p></span></p>
                      <p class="MsoNormal">
                          <span>If you have questions about your rights as a research participant, or wish to obtain information, ask questions, or discuss any concerns about this study with someone other than the researcher, you can contact <span class="auto-style100" style="text-underline: single;"><a href="https://research.utexas.edu/ors/human-subjects/welcome/">the Human Subjects and Institutional Review Board (IRB)</a></span> for the Office of Research Support and Compliance at The University of Texas at Austin. (Protocol 2019-02-0101)<o:p></o:p></span></p>
                      <p class="MsoNormal">
                          <span>By clicking on the button below, you give your informed consent to voluntarily participate in this study and indicate that you are at least 18 years old.<o:p></o:p></span></p>
</div>
                </td>
            </tr>
            <tr>
                <td class="auto-style57" colspan="2">
                    <asp:CheckBox ID="CheckAgree" runat="server" AutoPostBack="True" 
                        oncheckedchanged="CheckAgree_CheckedChanged" 
                        Text="  I accept the above agreement." TabIndex="14" Font-Italic="True" />
                </td>
                <td class="auto-style72">
                    <asp:Button ID="BtnSignUp" runat="server" onclick="BtnSignUp_Click" Text="Sign Up" 
                        Enabled="False" TabIndex="15" Font-Bold="True" Font-Size="Large" Height="46px" Width="118px" />
                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                </td>
            </tr>
            <tr>
                <td class="auto-style57" colspan="2">
                    &nbsp;</td>
                <td class="auto-style72">
                    &nbsp;</td>
            </tr>
            <tr>
                <td class="auto-style87">
                    Username : <td class="auto-style88">
                    <asp:TextBox ID="TextID" runat="server" MaxLength="50" 
                        ontextchanged="TextID_TextChanged" TabIndex="10" CausesValidation="True" BackColor="#FFCCFF" Font-Bold="True" Width="281px" AutoPostBack="True"></asp:TextBox>
                    *</td>
                <td class="auto-style89">
                    <asp:Label ID="LabelMessage" runat="server" Font-Bold="True" ForeColor="Red"></asp:Label>
                    <br />
                    <asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server" 
                        ControlToValidate="TextID" ErrorMessage="Please type a valid Username!" 
                        Font-Bold="True" ForeColor="Red" 
                        ValidationExpression="\\w+([-+.']\\w+)*@\\w+([-.]\\w+)*\\.edu" SetFocusOnError="True" Enabled="False"></asp:RegularExpressionValidator>
                    <br />
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator5" runat="server" 
                        ControlToValidate="TextID" ErrorMessage="Username is required." Font-Bold="True" 
                        ForeColor="Red" SetFocusOnError="True"></asp:RequiredFieldValidator>
                </td>
            </tr>
            <tr>
                <td class="auto-style90">
                    Password: 
                </td>
                <td class="auto-style91">
                    <asp:TextBox ID="TextPass" runat="server" TextMode="Password" Enabled="False" 
                        MaxLength="50" TabIndex="11" CausesValidation="True" Width="60px"></asp:TextBox>
                    *</td>
                <td class="auto-style92">
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" 
                        ControlToValidate="TextPass" ErrorMessage="Password is required." 
                        Font-Bold="True" ForeColor="Red" SetFocusOnError="True"></asp:RequiredFieldValidator>
                    <br />
                    <asp:RegularExpressionValidator ID="RegularExpressionValidator2" runat="server" 
                        ControlToValidate="TextPass" ErrorMessage="Password must be 4-18 characters." 
                        Font-Bold="True" ForeColor="Red" 
                        ValidationExpression="[\S\s]{4,18}" SetFocusOnError="True"></asp:RegularExpressionValidator>
                </td>
            </tr>
            <tr>
                <td class="auto-style93">
                    Confirm password:</td>
                <td class="auto-style94">
                    <asp:TextBox ID="TextRPass" runat="server" Enabled="False" MaxLength="50" 
                        TextMode="Password" TabIndex="12" CausesValidation="True" Width="60px"></asp:TextBox>
                    *</td>
                <td class="auto-style95">
                    <asp:CompareValidator ID="CompareValidator1" runat="server" 
                        ControlToCompare="TextPass" ControlToValidate="TextRPass" 
                        ErrorMessage="Passwords must be the same." Font-Bold="True" ForeColor="Red" SetFocusOnError="True"></asp:CompareValidator>
                    <br />
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator4" runat="server" 
                        ControlToValidate="TextRPass" ErrorMessage="Repeating Password is required." 
                        Font-Bold="True" ForeColor="Red" SetFocusOnError="True"></asp:RequiredFieldValidator>
                </td>
            </tr>
            <tr>
                <td class="auto-style53">
                    &nbsp;</td>
                <td class="auto-style12">
                    <asp:TextBox ID="TextExpert" runat="server" AutoCompleteType="HomePhone" 
                        MaxLength="50" TextMode="Phone" TabIndex="16" Visible="False"></asp:TextBox>
                    </td>
                <td class="auto-style39">
                    <asp:Label ID="Rater" runat="server" Text="  (Leave blank unless you are a Rater)" Visible="False"></asp:Label>
                </td>
            </tr>
            </table>
    
    </div>         
       
    </form>  
       <footer>
           <p> Designed and Developed by <em>Dr. Hamed Khaledi</em> © 2019 </p>
       </footer> 
    <script src="https://code.jquery.com/jquery-3.3.1.slim.min.js" integrity="sha384-q8i/X+965DzO0rT7abK41JStQIAqVgRVzpbzo5smXKp4YfRvH+8abtTE1Pi6jizo" crossorigin="anonymous"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js" integrity="sha384-UO2eT0CpHqdSJQ6hJty5KVphtPhzWj9WO1clHTMGa3JDZwrnQq4sF86dIHNDz0W1" crossorigin="anonymous"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js" integrity="sha384-JjSmVgyd0p3pXB1rRibZUAYoIIy6OrQ6VrjIEaFf/nJGzIxFDsf4x0xIM+B07jRM" crossorigin="anonymous"></script>
</body>   
     
</html>

