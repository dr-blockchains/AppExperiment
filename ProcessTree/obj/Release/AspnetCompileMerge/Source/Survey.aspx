<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Survey.aspx.cs" Inherits="ProcessTree.Survey" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Survey</title>
    <style type="text/css"> 
          
         
        .auto-style1 {
            height: 30px;
        }
        .auto-style2 {
            width: 60%;
        }          
         
        .auto-style4 {
            font-size: large;
            color: #006600;
             text-align: justify;
        }         
           
        .auto-style6 {
            width: 60%;
            text-align: right;
        }         
         
        .auto-style7 {
            height: 1461px;
            width: 99%;
        }
        .auto-style12 {
            height: 39px;
        }
        .auto-style13 {
            height: 58px;
        }
        .auto-style17 {
            font-size: x-large;
        }
        .auto-style19 {
            height: 28px;
        }
        .auto-style20 {
            height: 34px;
        }
        .auto-style22 {
            text-align: right;
            width: 298px;
        }
        .auto-style23 {
            font-style: italic;
            font-size: 1em;
            color: darkblue;
            font-weight: bold;
            border: solid #ccc 2px;
            border-radius: 5px;
            padding: 3px;
            width: 298px;
        }
        .auto-style24 {
            height: 50px;
        }
          
         
        </style>

    <script src="Timer.js"></script>    
    <link href="StyleSheet.css" rel="stylesheet" type="text/css" />
</head>
<body style="height: 1813px">
    <form id="Survey" runat="server">
          <table id="TheTable" class="auto-style7">
            <tr>
                <td class="auto-style2" > <em> <asp:Label ID="LabelLogin" runat="server" 
                    Text="Error! Please contact the admin: Khaledi@Bus.MSU.edu" Font-Bold="True" ForeColor="Red" Font-Size="Large"></asp:Label>                
                    </em>                
                </td>
                <td class="auto-style22">
                    <asp:Button ID="BtnHistory" runat="server" OnClick="BtnHistory_Click" Text="Versions History" TabIndex="9"/>    
                </td>     
            </tr>
            <tr>
                <td class="auto-style2" >
        <asp:Label ID="LabelBalance" runat="server" CssClass="auto-style4" ></asp:Label>                    
                </td>
                 <asp:Label id="TimeSpan" runat="server" style="display: none"></asp:Label>              
            </tr>
           
            <tr>
                <td class="auto-style6" >
                    <asp:Label ID="DeadLineMessage" runat="server" Font-Bold="True" Text="The time for survey ends at "></asp:Label>
                </td>
                <td id="DeadLine" class="auto-style23">                   
                    <script>
                        var TSpan = parseInt(document.getElementById("TimeSpan").textContent);
                        if (TSpan <=0)
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
                <td class="auto-style6" >
                    <asp:Label ID="TimerMessage" runat="server" Font-Bold="True" Text="in about"></asp:Label>
                </td>
                <td id="Timer" class="auto-style23">

                </td>
            </tr>

            <tr>
                <td  colspan="2" class="auto-style1">
                     
          <em>
                     
        <asp:Label ID="Label" runat="server" Font-Bold="True" Font-Size="X-Large" Text="Final Survey:"></asp:Label>
          &nbsp;<br />
                    <br />
          </em>Please answer these questions honestly.</td>              
            </tr>        

            <tr>
                <td  colspan="2" class="auto-style13">&nbsp;</td>              
            </tr>        

            <tr>
                <td  colspan="2" class="auto-style1">* <span style="mso-fareast-font-family:&quot;Times New Roman&quot;">
                    <o:p>Was ths task description clear and understandable?<br />
                    [1 = Very confusing ..... 10 = Completely clear and easy to understand]</o:p></span></td>              
            </tr>        

            <tr>
                <td  colspan="2" class="auto-style1">
                    <asp:RadioButtonList ID="RadioScore1" runat="server" RepeatDirection="Horizontal" Height="16px" CellPadding="5" CellSpacing="10" TextAlign="Left" TabIndex="2">
                        <asp:ListItem>1</asp:ListItem>
                        <asp:ListItem Value="2"></asp:ListItem>
                        <asp:ListItem>3</asp:ListItem>
                        <asp:ListItem>4</asp:ListItem>
                        <asp:ListItem>5</asp:ListItem>
                        <asp:ListItem>6</asp:ListItem>
                        <asp:ListItem>7</asp:ListItem>
                        <asp:ListItem>8</asp:ListItem>
                        <asp:ListItem>9</asp:ListItem>
                        <asp:ListItem Value="10">10</asp:ListItem>
                    </asp:RadioButtonList>
                </td>              
            </tr>        

              <tr>
                <td  colspan="2" class="auto-style24">
    
                </td>              
              </tr>
              <tr>
                <td  colspan="2" class="auto-style13"><strong>* Please explain how you participated in the game.</strong><asp:TextBox ID="Response1" runat="server" BackColor="#99CCFF" Height="125px" CssClass="justified" style="direction: ltr" TextMode="MultiLine" TabIndex="1" Font-Names="Times New Roman" Font-Size="Large" Width="97%" BorderStyle="Inset">Minimum 80 characters</asp:TextBox>
    
                </td>              
              </tr>

            <tr>
                <td  colspan="2" class="auto-style24"></td>              
            </tr>        

            <tr>
                <td  colspan="2" class="auto-style19">* The final edition is as follows. Please rate it.<br />
                    [1 = Completely nonsense .... 10 = The best plan with maximum profit]</td>              
            </tr>        

            <tr>
                <td  colspan="2" class="auto-style12">
                    <asp:RadioButtonList ID="RadioScore2" runat="server" RepeatDirection="Horizontal" Height="16px" CellPadding="5" CellSpacing="10" TextAlign="Left" TabIndex="2">
                        <asp:ListItem>1</asp:ListItem>
                        <asp:ListItem Value="2"></asp:ListItem>
                        <asp:ListItem>3</asp:ListItem>
                        <asp:ListItem>4</asp:ListItem>
                        <asp:ListItem>5</asp:ListItem>
                        <asp:ListItem>6</asp:ListItem>
                        <asp:ListItem>7</asp:ListItem>
                        <asp:ListItem>8</asp:ListItem>
                        <asp:ListItem>9</asp:ListItem>
                        <asp:ListItem Value="10">10</asp:ListItem>
                    </asp:RadioButtonList>
                </td>              
            </tr>        

            <tr>
                <td  colspan="2" class="auto-style1"><strong><span class="auto-style17"><em>Final edition :</em></span></strong><br />
        <asp:TextBox ID="txtArtifact" runat="server" BackColor="#FFEE88" Height="172px" CssClass="justified" style="direction: ltr" TextMode="MultiLine" TabIndex="1" Font-Names="Times New Roman" Font-Size="Large" Width="97%" ReadOnly="True">Please refresh the page.</asp:TextBox>
    
                    <br />
                </td>              
            </tr>        

            <tr>
                <td  colspan="2" class="auto-style13"></td>              
            </tr>        

            <tr>
                <td  colspan="2" class="auto-style19">* What is your level of expertise in financial investment and stock market?
                    <br />
                    [1 = Never heard of it.... 10 = A professional trader in financial markets]</td>              
            </tr>        

            <tr>
                <td  colspan="2" class="auto-style13">
                    <asp:RadioButtonList ID="RadioScore3" runat="server" RepeatDirection="Horizontal" Height="16px" CellPadding="5" CellSpacing="10" TextAlign="Left" TabIndex="2">
                        <asp:ListItem>1</asp:ListItem>
                        <asp:ListItem Value="2"></asp:ListItem>
                        <asp:ListItem>3</asp:ListItem>
                        <asp:ListItem>4</asp:ListItem>
                        <asp:ListItem>5</asp:ListItem>
                        <asp:ListItem>6</asp:ListItem>
                        <asp:ListItem>7</asp:ListItem>
                        <asp:ListItem>8</asp:ListItem>
                        <asp:ListItem>9</asp:ListItem>
                        <asp:ListItem Value="10">10</asp:ListItem>
                    </asp:RadioButtonList>
                </td>              
            </tr>        

            <tr>
                <td  colspan="2" class="auto-style24">
    
                </td>              
            </tr>        

            <tr>
                <td  colspan="2" class="auto-style13"><strong>* Please explain your reasons and motives behind your activities in the game. </strong><asp:TextBox ID="Response2" runat="server" BackColor="#99CCFF" Height="125px" CssClass="justified" style="direction: ltr" TextMode="MultiLine" TabIndex="1" Font-Names="Times New Roman" Font-Size="Large" Width="97%" BorderStyle="Inset">Minimum 80 characters</asp:TextBox>
    
                </td>              
            </tr>        

            <tr>
                <td  colspan="2" class="auto-style24"></td>              
            </tr>        

            <tr>
                <td  colspan="2" class="auto-style1">* How was the overall quality of the game and website? <br />
                    [1 = Very poor .... 10 = Very effective]</td>              
            </tr>        

            <tr>
                <td  colspan="2" class="auto-style1">
                    <asp:RadioButtonList ID="RadioScore4" runat="server" RepeatDirection="Horizontal" Height="16px" CellPadding="5" CellSpacing="10" TextAlign="Left" TabIndex="2">
                        <asp:ListItem>1</asp:ListItem>
                        <asp:ListItem Value="2"></asp:ListItem>
                        <asp:ListItem>3</asp:ListItem>
                        <asp:ListItem>4</asp:ListItem>
                        <asp:ListItem>5</asp:ListItem>
                        <asp:ListItem>6</asp:ListItem>
                        <asp:ListItem>7</asp:ListItem>
                        <asp:ListItem>8</asp:ListItem>
                        <asp:ListItem>9</asp:ListItem>
                        <asp:ListItem Value="10">10</asp:ListItem>
                    </asp:RadioButtonList>
                </td>              
            </tr>        

            <tr>
                <td  colspan="2" class="auto-style24">
    
                </td>              
            </tr>        

            <tr>
                <td  colspan="2" class="auto-style1"><strong>* Please describe your experience in this experiment. How can we improve it?</strong><br />
        <asp:TextBox ID="Response3" runat="server" BackColor="#99CCFF" Height="125px" CssClass="justified" style="direction: ltr" TextMode="MultiLine" TabIndex="1" Font-Names="Times New Roman" Font-Size="Large" Width="97%" BorderStyle="Inset">Minimum 80 characters</asp:TextBox>
    
                </td>              
            </tr>        

              </table>

<u1:p class=""></u1:p>
          <p class="auto-style20" >
                                &nbsp;<asp:Button ID="BtnSubmitScore" runat="server" Font-Bold="True" onclick="BtnSubmitScore_Click" TabIndex="3" Text="Submit Answers" />
                                <asp:Label ID="LabelMessage" runat="server" Font-Bold="True" ForeColor="Maroon"></asp:Label>
                            </p>
    
    </form>
            
    </body>
</html>
