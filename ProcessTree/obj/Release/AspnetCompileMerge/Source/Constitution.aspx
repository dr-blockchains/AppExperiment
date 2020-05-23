<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Constitution.aspx.cs" Inherits="ProcessTree.Constitution" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Constitution Test</title>
    <style type="text/css">
      
        .style32
        {
            color: #003300;
            font-size: x-large;
            font-family: Roman;
            text-align: center;
        }
        .auto-style9 {            
            
            font-size: xx-large;
            color: #006600;
            height: 28px;
        }
        .auto-style12 {            
            font-size: xx-large;
            color: #006600;
        }
        .auto-style13 {
            height: 201px;
            text-align: justify;
        }
             
        .auto-style28 {
            
            height: 30px;
            text-align: left;
            width: 96%;
        }
        .auto-style29 {            
            height: 30px;
        }
        .auto-style32 {
            height: 64px;
        }
             
        .auto-style35 {
            text-align: right;
            width: 60%;
        }
        .auto-style37 {
            width: 60%;
        }
        .auto-style38 {
            width: 96%;
            height: 30px;
        }
        .auto-style39 {
            text-align: left;
        }
        .auto-style40 {
            width: 96%;
        }
        .auto-style41 {
            font-size: xx-large;
            color: #006600;
            height: 65px;
            text-align: justify;
        }
        .auto-style42 {
            font-size: large;
            color: #000000;
        }
        .auto-style43 {
            height: 393px;
        }
        </style>
    
    <script src="Timer.js"></script>           
    <link href="StyleSheet.css" rel="stylesheet" type="text/css" />
</head>
<body style="height: 807px">
    <form id="Constitution" runat="server">
        <table id="TheTable">
         
              <tr>
                <td class="auto-style37">
                        <asp:Label ID="LabelLogin" runat="server" CssClass="login" Text="Error! Please Contact the admin: Khaledi@Bus.MSU.edu" Font-Size="Large" Width="167%"></asp:Label>
                    </td>
                 <asp:Label id="TimeSpan" runat="server" style="display: none"></asp:Label>              
            </tr>
           
            <tr>
                <td class="auto-style35">
                    <asp:Label ID="DeadLineMessage" runat="server" Font-Bold="True" Text="The game will start at "></asp:Label>
                </td>
                <td id="DeadLine" class="time">                   
                    <script>
                        var TSpan = parseInt(document.getElementById("TimeSpan").textContent);
                        if (TSpan <= 0)
                        {
                            document.write("Your Time Expired!");
                            // document.getElementById("Timer").innerHTML = "";
                        }
                        else
                        {
                            var ClientDeadLine = new Date((new Date()).getTime() + TSpan);
                            document.write(ClientDeadLine.toLocaleTimeString([], options));
                            CountDownTimer(ClientDeadLine, "Timer");
                        }
                    </script>
                </td>
            </tr>
            <tr>
               
                <td class="auto-style35">
                    <asp:Label ID="TimerMessage" runat="server" Font-Bold="True" Text="in about"></asp:Label>
                </td>
                <td id="Timer" class="time">

                </td>
            </tr>

            <tr>
                <td class="auto-style41" colspan="2"><span class="auto-style42">
                    <p>
                        Please read the instructions and answer the questions. Keep this page open until the end of the experiment.</span></p>
                </td>              
            </tr>

            <tr>
                <td class="auto-style9" colspan="2">
                    <strong><span class="auto-style12">
                    <em>Instructions:</em></tr>
            <tr>
                <td class="auto-style13" colspan="2">
                    <asp:Label ID="ConstitutionBox" runat="server" Text="Please refresh the page! (Database is not accessable now)" Width="96%" BackColor="#CCFFAA" BorderColor="#66FF66" BorderStyle="Solid" BorderWidth="10px" CssClass="justified" Font-Names="Georgia" Font-Size="Medium" TabIndex="1"></asp:Label>
                    <br />
        <table class="auto-style43">
            <tr>
                <td class="auto-style40">&nbsp;</td>
                <td class="auto-style15">&nbsp;</td>
            </tr>
            <tr>
                <td class="auto-style28">
                    <asp:TextBox ID="TextBox1" runat="server" Height="20px" ReadOnly="True" Width="95%" BorderStyle="None" CssClass="questions" >How many suggestions (at most) can you submit per period?</asp:TextBox>
                </td>
                <td class="auto-style29">
                    <asp:TextBox ID="Text1" runat="server" BackColor="Yellow" TabIndex="2" Width="50px" TextMode="Number"></asp:TextBox>
                    &nbsp;Suggestions</td>
            </tr>
            <tr>
                <td colspan="2">&nbsp;</td>
            </tr>
            <tr>
                <td class="auto-style40">
                    <asp:TextBox ID="TextBox2" runat="server" Height="20px" ReadOnly="True" Width="95%" BorderStyle="None" CssClass="questions">What is the minimum number of choices in each voting period?</asp:TextBox>
                </td>
                <td class="auto-style15">
                    <asp:TextBox ID="Text2" runat="server" BackColor="Yellow" Width="50px" TabIndex="3" TextMode="Number"></asp:TextBox>
                    &nbsp;Versions</td>
            </tr>
            <tr>
                <td colspan="2">&nbsp;</td>
            </tr>
            <tr>
                <td class="auto-style38">
                    <asp:TextBox ID="TextBox3" runat="server" Height="20px" ReadOnly="True" Width="95%" BorderStyle="None" CssClass="questions">How long is each voting period?</asp:TextBox>
                </td>
                <td class="auto-style29">
                    <asp:TextBox ID="Text3" runat="server" pattern ="[0-9]*\.?[0-9]+" BackColor="Yellow" TabIndex="4" Width="50px"></asp:TextBox>
                    &nbsp;Minutes</td>
            </tr>
            <tr>
                <td colspan="2">&nbsp;</td>
            </tr>
            <tr>
                <td class="auto-style40">
                    <asp:TextBox ID="TextBox4" runat="server" Height="20px" ReadOnly="True" Width="95%" BorderStyle="None" CssClass="questions">How long is the game?</asp:TextBox>
                </td>
                <td class="auto-style15">
                    <asp:TextBox ID="Text4" runat="server" BackColor="Yellow" TabIndex="5" Width="50px" pattern ="[0-9]*\.?[0-9]+"></asp:TextBox>
                    &nbsp;Minutes</td>
            </tr>
            <tr>
                <td colspan="2" >&nbsp;</td>
            </tr>
            <tr>
                <td class="auto-style40">
                    <asp:TextBox ID="TextBox5" runat="server" Height="20px" ReadOnly="True" Width="95%" BorderStyle="None" CssClass="questions" >The game begins with:</asp:TextBox>
                </td>
                <td class="auto-style39">
                    <asp:RadioButtonList ID="Radio5" runat="server" BackColor="Yellow" CellPadding="0" CellSpacing="0" Height="16px" RepeatDirection="Horizontal" Width="323px" TabIndex="6" TextAlign="Left">
                        <asp:ListItem Value="0">Voting</asp:ListItem>
                        <asp:ListItem Value="1">Suggestion</asp:ListItem>
                        <asp:ListItem Value="2">Survey</asp:ListItem>
                    </asp:RadioButtonList>
                </td>
            </tr>
            <tr>
                <td class="auto-style32" colspan="2">
            <asp:Button ID="BtnSubmit" runat="server" Font-Bold="True" onclick="BtnSubmit_Click" TabIndex="8" Text="Submit Answers" />
            <asp:Label ID="LabelMessage" runat="server" Font-Bold="True" ForeColor="Maroon" Font-Size="Larger"></asp:Label>
                    <br />
                </td>
            </tr>
            <tr>
                <td class="auto-style32" colspan="2">
                    <br />
                    <br />
                    <br />
                    <br />
                    <br />
                    <br />
                    <br />
                    <br />
                    <br />
                    <br />
                </td>
            </tr>
        </table>
                </td>
            </tr>
            </table>
     </form>
</body>
</html>
