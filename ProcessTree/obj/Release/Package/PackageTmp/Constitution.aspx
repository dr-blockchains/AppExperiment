<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Constitution.aspx.cs" Inherits="ProcessTree.Constitution" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Initial Test</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css"/>    
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
            text-align: left;
        }
        .auto-style13 {
            height: 201px;
            text-align: justify;
            min-width: 950px;
        }
             
        .auto-style35 {
            text-align: right;
            width: 52%;
        }
        .auto-style39 {
            text-align: left;
            font-size: large;
        }
        .auto-style41 {
            font-size: xx-large;
            color: #006600;
            height: 65px;
            text-align: justify;
        }
        .auto-style43 {
            height: 393px;
            min-width: 950px;
        }
        .auto-style45 {
            height: 41px;
            text-align: left;
        }
        .auto-style46 {
            font-size: large;
        }
        .auto-style47 {
            text-align: justify;
            padding: 10px;
            overflow: auto;
            font-size: large;
        }
        .auto-style48 {
            width: 52%;
            font-size: large;
            text-align: left;
        }
        .auto-style49 {
            font-style: italic;
            font-size: large;
            color: darkblue;
            font-weight: bold;
            border: solid #ccc 2px;
            border-radius: 5px;
            padding: 3px;
            text-align: left;
        }
        .auto-style50 {
            font-weight: bold;
            font-style: italic;
            color: red;
            font-size: large;
            margin: 0px auto;
        }
        .auto-style51 {
            font-size: medium;
        }
        .auto-style52 {
            height: 66px;
            text-align: right;
            width: 52%;
        }
        .auto-style54 {
            width: 52%;
            text-align: left;
        }
        
        input[type="radio"] {
            margin-right: 5px;
            padding-left: 5px;

        }
        .auto-style55 {
            height: 66px;
            text-align: center;
        }
        </style>
    
    <script src="Timer.js"></script>           
    <link href="StyleSheet.css" rel="stylesheet" type="text/css" />
</head>
<body>
    <form id="Constitution" runat="server">
        <div class="text-center">
        <table id="TheTable" class="auto-style43">   
              <tr>
                <td class="auto-style54">
                        &nbsp;</td>
                 <asp:Label id="TimeSpan" runat="server" style="display: none"></asp:Label>              
            </tr>           
            <tr>
                <td class="auto-style35">
                    <asp:Label ID="DeadLineMessage" runat="server" Font-Bold="True" Text="The game will start at " CssClass="auto-style46"></asp:Label>
                &nbsp;&nbsp;
                </td>
                <td id="DeadLine" class="auto-style49">                   
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
                    <asp:Label ID="TimerMessage" runat="server" Font-Bold="True" Text="in about" CssClass="auto-style46"></asp:Label>
                &nbsp;&nbsp;
                </td>
                <td id="Timer" class="auto-style49">

                </td>
            </tr>

            <tr>
                <td class="auto-style41" colspan="2">                    
                        <asp:Label ID="LabelLogin" runat="server" CssClass="auto-style50" Text="Error! Please Contact the admin: Law.Economist@Gmail.com" Font-Size="Large" Width="101%" Height="38px" ForeColor="#CC0000"></asp:Label>                    
                </td>              
            </tr>

            <tr>
                <td class="auto-style9" colspan="2">
                    Instructions:</td>
                    
                    </tr>
            <tr>
                <td class="auto-style13" colspan="2">
                    <asp:Label ID="ConstitutionBox" runat="server" Text="Please refresh the page! (Database is not accessable now)" Width="100%" BackColor="#CCFFAA" BorderColor="#66FF66" BorderStyle="Solid" BorderWidth="10px" CssClass="auto-style47" Font-Names="Georgia" Font-Size="Medium" TabIndex="1"></asp:Label>
                    <br class="auto-style46" />    
                </td>
            </tr>
            <tr>
                <td colspan="2" class="auto-style39">&nbsp;</td>
            </tr>
            <tr>
                <td class="text-left" colspan="2">
                    <strong><span class="auto-style46">1- Are</span></strong><span style="mso-fareast-font-family:&quot;Times New Roman&quot;"><o:p><strong><span class="auto-style46"> the instructions clear and understandable?</span></strong><br class="auto-style46" />
                    <em><span class="auto-style51">[1 = Very confusing ..... 10 = Completely clear and easy to understand]</span></em></o:p></span></td>
            </tr>
            <tr>
                <td class="text-left" colspan="2">
                    <asp:RadioButtonList ID="RadioScore1" runat="server" RepeatDirection="Horizontal" Height="16px" CellPadding="5" CellSpacing="10" TextAlign="Left" TabIndex="10">
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
                <td class="auto-style48">
                    &nbsp;</td>
                <td class="auto-style39">
                    &nbsp;</td>
            </tr>
            <tr>
                <td class="text-left" colspan="2">
                    <strong><span class="auto-style46">2- How well did you comprehend the rules of the game?</span></strong><span style="mso-fareast-font-family:&quot;Times New Roman&quot;"><o:p><br class="auto-style46" />
                    <em><span class="auto-style51">[1 = I could not understand them at all ..... 10 = I understoond them completely]</span></em></o:p></span></td>
            </tr>
            <tr>
                <td class="text-left" colspan="2">
                    <asp:RadioButtonList ID="RadioScore2" runat="server" RepeatDirection="Horizontal" Height="16px" CellPadding="5" CellSpacing="10" TextAlign="Left" TabIndex="20">
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
                <td class="auto-style48">
                    &nbsp;</td>
                <td class="auto-style39">
                    &nbsp;</td>
            </tr>
            <tr>
                <td class="text-left" colspan="2">
                    <strong><span class="auto-style46">3- How much do you think you will earn in this game?</span></strong></td>
            </tr>
            <tr>
                <td class="text-left" colspan="2">
                    <asp:RadioButtonList ID="RadioScore3" runat="server" RepeatDirection="Horizontal" Height="16px" CellPadding="5" CellSpacing="10" TextAlign="Left" TabIndex="30">
                        <asp:ListItem Value="1">$5</asp:ListItem>
                        <asp:ListItem Value="2">$5 - $7</asp:ListItem>
                        <asp:ListItem Value="3">$7- $10</asp:ListItem>
                        <asp:ListItem Value="4">$10 - $13</asp:ListItem>
                        <asp:ListItem Value="5">$13 - $16</asp:ListItem>
                        <asp:ListItem Value="6">$16 - $20</asp:ListItem>
                        <asp:ListItem Value="7">$20 - $25</asp:ListItem>
                        <asp:ListItem Value="8">$25 - $30</asp:ListItem>
                        <asp:ListItem Value="9">$30 - $40</asp:ListItem>
                        <asp:ListItem Value="10">$40 - $50</asp:ListItem>
                    </asp:RadioButtonList>
                </td>
            </tr>
            <tr>
                <td class="auto-style48">
                    &nbsp;</td>
                <td class="auto-style39">
                    &nbsp;</td>
            </tr>
            <tr>
                <td class="text-left" colspan="2">
                    <strong><span class="auto-style46">4- What do you think is your level of expertise in the financial markets?</span></strong><br class="auto-style46" />
                    <span class="auto-style51"><em>[1 = Never heard of it ..... 10 = A professional trader]</em></span></td>
            </tr>
            <tr>
                <td class="text-left" colspan="2">
                    <asp:RadioButtonList ID="RadioScore4" runat="server" RepeatDirection="Horizontal" Height="16px" CellPadding="5" CellSpacing="10" TextAlign="Left" TabIndex="40">
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
                <td class="auto-style48">
                    &nbsp;</td>
                <td class="auto-style39">
                    &nbsp;</td>
            </tr>
            <tr>
                <td class="text-left" colspan="2">
                    <strong><span class="auto-style46">5- How many rounds are there in the game?</span></strong><br class="auto-style46" />
                    <em><span class="auto-style51">[1 = One ..... 10 = Ten]</span></em></td>
            </tr>
            <tr>
                <td class="text-left" colspan="2">
                    <asp:RadioButtonList ID="RadioScore5" runat="server" RepeatDirection="Horizontal" Height="16px" CellPadding="5" CellSpacing="10" TextAlign="Left" TabIndex="50">
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
                <td class="auto-style48">
                    &nbsp;</td>
                <td class="auto-style39">
                    &nbsp;</td>
            </tr>
            <tr>
                <td class="text-left" colspan="2">
                    <strong><span class="auto-style46">6- How do you compare yourself to others in terms of financial literacy?</span></strong>
                    <br class="auto-style46" />
                    <em><span class="auto-style51">[1 = Everybody knows better than me ..... 10 = I know better than 99% of people]</span></em></td>
            </tr>
            <tr>
                <td class="text-left" colspan="2">
                    <asp:RadioButtonList ID="RadioScore6" runat="server" RepeatDirection="Horizontal" Height="16px" CellPadding="5" CellSpacing="10" TextAlign="Left" TabIndex="60">
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
                <td class="auto-style39" colspan="2">
                    &nbsp;</td>
            </tr>
            <tr>
                <td class="text-left" colspan="2">
                    7<strong><span class="auto-style46">- Please briefly explain the rules of the game:</span><br class="auto-style46" />
                    <asp:TextBox ID="Response7" runat="server" BackColor="#99CCFF" Height="125px" CssClass="auto-style47" style="direction: ltr" TextMode="MultiLine" TabIndex="70" Font-Names="Times New Roman" Font-Size="Large" Width="97%" BorderStyle="Inset" MaxLength="900">Minimum 80 characters</asp:TextBox>
    
                    </strong>
                </td>
            </tr>
            <tr>
                <td class="auto-style45" colspan="2">
            <asp:Button ID="BtnSubmit" runat="server" Font-Bold="True" onclick="BtnSubmit_Click" TabIndex="80" Text="Submit Answers" CssClass="auto-style46" />
            <asp:Label ID="LabelMessage" runat="server" Font-Bold="True" ForeColor="Maroon" Font-Size="Larger" CssClass="auto-style46"></asp:Label>
                    <br class="auto-style46" />
                </td>
            </tr>   
            <tr>
                <td class="auto-style52">
                    &nbsp;</td>
                <td class="auto-style55">

                    <%--<a href="ChatRoom.aspx" target="_blank">Open Chat Room</a></td>--%>
            </tr>   
            </table>
        <asp:Image ID="Image10" runat="server" ImageUrl="~/Images/GroupDecision.jpg" Width="90%" />        
        <br />            
        <br />        
        </div>
    </form>
    <script src="https://code.jquery.com/jquery-3.3.1.slim.min.js" integrity="sha384-q8i/X+965DzO0rT7abK41JStQIAqVgRVzpbzo5smXKp4YfRvH+8abtTE1Pi6jizo" crossorigin="anonymous"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js" integrity="sha384-UO2eT0CpHqdSJQ6hJty5KVphtPhzWj9WO1clHTMGa3JDZwrnQq4sF86dIHNDz0W1" crossorigin="anonymous"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js" integrity="sha384-JjSmVgyd0p3pXB1rRibZUAYoIIy6OrQ6VrjIEaFf/nJGzIxFDsf4x0xIM+B07jRM" crossorigin="anonymous"></script>
</body>
</html>
