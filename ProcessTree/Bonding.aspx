<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Bonding.aspx.cs" Inherits="ProcessTree.Bonding" MaintainScrollPositionOnPostBack = "true" %>

<%@ Register assembly="System.Web.DataVisualization, Version=4.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35" namespace="System.Web.UI.DataVisualization.Charting" tagprefix="asp" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Bonding</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css"/>
    <style type="text/css">

        .style2
        {
            
            text-align: left;
        }
                   
        .style32
        {
            color: #003300;
            font-size: x-large;            
            font-family: Roman;
            text-align: center;
        }
        .auto-style21 {
            text-align: center;
        }
        .auto-style30 {
            width: 50%;
        }
        .auto-style31 {
            text-align: right;
            width: 50%;
        }
        .auto-style32 {
                        
            height: 174px;
            line-height : 30px;
            margin: 0px auto;
            font-size: medium;
        }

        .auto-style37 {
            text-align: left;
            height: 36px;
            width: 50%;
        }
        .auto-style41 {
            width: 74%;
        }
        
        .auto-style48 {
            height: 36px;
            text-align: left;
        }

        .auto-style51 {
            text-align: right;
            }
        .auto-style53 {
            text-align: center;
            height: 36px;
            width: 50%;
            background-color: #FFFFCC;
        }
        .auto-style56 {
            height: 36px;
            text-align: right;
        }
        .auto-style57 {
            height: 36px;
        }

        .auto-style58 {
            text-align: left;
            font-size: small;
        }
        .auto-style59 {
            font-size: small;
        }
        .auto-style60 {
            text-align: center;
            font-size: small;
        }

        .auto-style61 {
            height: 36px;
            text-align: right;
            width: 1075px;
        }
        .auto-style62 {
            color: #CC3300;
        }

        .auto-style63 {
            text-align: left;
            width: 26%;
        }

        </style>
    
    <script src="Timer.js"> </script>   
    
    <link href="StyleSheet.css" rel="stylesheet" type="text/css" />
</head>
<body >
    <form id="Bonding" runat="server" class="auto-style41">
                  <table class="auto-style32">
            <tr>
                <td class="auto-style30" colspan="2">
                    <strong><em>
                    <asp:Label ID="PeriodChoice" runat="server" Font-Size="Large" Text="Please contact the admin: Law.Economist@Gmail.com" ForeColor="#000099" Width="142%"></asp:Label>
                    </em></strong>
                    </td>
                <td class="questions" colspan="2">
    
                    <span class="auto-style62"><em>Return to switch to another choice: </em></span>
    
                                    <asp:Button ID="BtnReturn" runat="server" OnClick="BtnReturn_Click" Text="Return" TabIndex="90" />
                </td>     
            </tr>            
                          <tr>
                <td colspan="4">
                     <asp:Panel ID="Panel1" runat="server" BackColor="#FFEE88">
                         <asp:Label ID="Version" runat="server" Class="login" Text="Error! Please contact the admin: Law.Economist@Gmail.com" Font-Size="Small" ForeColor="Black" BackColor="#FFEE88" BorderColor="#FFEE88" BorderStyle="Solid" BorderWidth="5px" Width="753px"></asp:Label>
                     </asp:Panel>
                              </td>
                 <asp:Label id="TimeSpan" runat="server" style="display: none"></asp:Label>   
            </tr>
           
            <tr>
                <td class="auto-style31" colspan="2">
                    <asp:Label ID="DeadLineMessage" runat="server" Font-Bold="True" Text="This market closes at "></asp:Label>
                </td>
                <td id="DeadLine" class="time" colspan="2">
                    <script>
                         var TSpan = parseInt(document.getElementById("TimeSpan").textContent);
                         var ClientDeadLine = new Date((new Date()).getTime() + TSpan);
                         document.write(ClientDeadLine.toLocaleTimeString([], options));
                         CountDownTimer(ClientDeadLine, "Timer");
                    </script>
                </td>
            </tr>
            <tr>
               
                <td class="auto-style31" colspan="2">
                    <asp:Label ID="TimerMessage" runat="server" Font-Bold="True" Text="in about"></asp:Label>
                </td>
                <td id="Timer" class="time" colspan="2">

                </td>
            </tr>                    
            <tr>
               
                <td class="auto-style48" colspan="2">    
    
                    &nbsp;</td>
               
                <td class="auto-style61">    
                    <span class="auto-style62"><em>Refresh to see the new price: </em></span>&nbsp;</td>
               
                <td class="auto-style56">    
    
                                    <asp:Button ID="BtnRefresh" runat="server" OnClick="BtnRefresh_Click" Text="Refresh" TabIndex="85" BackColor="#66FFFF" />
    
                </td>
            </tr>                    
            <tr>
               
                <td class="auto-style48" colspan="3">    
    
                    <asp:Label ID="Message" runat="server" Font-Bold="True" ForeColor="#993333" CssClass="auto-style1" Font-Size="Medium" Height="28px" style="font-size: medium" Font-Italic="True" Width="112%"></asp:Label>
                </td>
               
                <td class="auto-style56">    
    
                                    &nbsp;</td>
            </tr>                    
            <tr>
               
                <td class="auto-style37" colspan="2">    
    
                    &nbsp;</td>
               
                <td class="auto-style61">    
                    &nbsp;</td>
               
                <td class="auto-style56">    
    
                                    &nbsp;</td>
            </tr>                    
            <tr>
               
                <td class="auto-style53" colspan="2">    
                    <asp:RadioButtonList ID="RadioOrder" runat="server" RepeatDirection="Horizontal" AutoPostBack="True" BorderStyle="Ridge" BorderWidth="2px" Font-Bold="True" OnSelectedIndexChanged="RadioOrder_SelectedIndexChanged" TabIndex="20">
                        <asp:ListItem>Buy</asp:ListItem>
                        <asp:ListItem Selected="True">Sell</asp:ListItem>
                    </asp:RadioButtonList>
                </td>
               
                <td class="auto-style57" colspan="2">    
    
                    Current (Starting) Price =    
    
                    <asp:Label ID="StartPrice" runat="server" BackColor="Yellow" BorderStyle="Solid" Font-Bold="False" Text="N/A" BorderColor="#FFCC00" BorderWidth="3px"></asp:Label>
                </td>
            </tr>                    
            <tr>   
                <td class="auto-style53" colspan="2">    
 
                    &nbsp; </td>

               
                <td class="auto-style48" colspan="2">    
    
                    Number of Shares Outstanding=    
    
                    <asp:Label ID="StartShares" runat="server" BackColor="Yellow" BorderStyle="Solid" Font-Bold="False" Text="N/A" BorderColor="#FFCC00" BorderWidth="3px"></asp:Label>
                </td>
            </tr>                    
            <tr>   
                <td class="auto-style53" colspan="2">    
 
                    Number of shares&nbsp;you
                    <asp:Label ID="BuySell" runat="server" Text="Sell" Font-Bold="True"></asp:Label>
&nbsp;= <asp:TextBox ID="DeltaShares" runat="server" BackColor="#FFAAAA" TabIndex="30" Width="99px" Font-Bold="True" Height="25px"></asp:TextBox>
                    &nbsp;shares</td>

               
                <td class="auto-style48" colspan="2">    
    
                    Your available Shares for this choice =
                                              <asp:Label ID="AvShare" runat="server" Class="balance" Font-Bold="True" Font-Size="Medium"></asp:Label>  
                                   
                </td>
            </tr>                    
            <tr>   
                <td class="auto-style53" colspan="2">    
 
                    Amount of Fund =$ <asp:TextBox ID="DeltaFund" runat="server" BackColor="#FFAAAA" TabIndex="40" Width="99px" Font-Bold="True" Height="25px"></asp:TextBox>

                    </td>

               
                <td class="auto-style48" colspan="2">    
    
                    Your available Balance for this choice = $ <asp:Label ID="AvFund" runat="server" Class="balance" Font-Bold="True" Font-Size="Medium"></asp:Label>                                  
                                   
                </td>
            </tr>                    
            <tr>   
                <td class="auto-style53" colspan="2">    
 
                    Average Transaction Price
                    = $&nbsp;<asp:TextBox ID="AveragePrice" runat="server" BackColor="#FFAAAA" TabIndex="40" Width="99px" Font-Bold="True" Height="25px" ReadOnly="True"></asp:TextBox>

                    &nbsp;per share</td>

               
                <td class="auto-style48" colspan="2">    
    
                    &nbsp;</td>
            </tr>                    
            <tr>
               
                <td class="auto-style53" colspan="2">    
                    &nbsp;Ending Transaction Price
                    =&nbsp;$ <asp:TextBox ID="EndPrice" runat="server" BackColor="#FFAAAA" TabIndex="40" Width="99px" Font-Bold="True" Height="25px" ReadOnly="True"></asp:TextBox>

                    &nbsp;per share</td>
               
                <td class="auto-style48" colspan="2">    
    
                    &nbsp;</td>
            </tr>                    
            <tr>               
                <td class="auto-style53" colspan="2">    
                    &nbsp;<asp:Button ID="PlaceOrder" runat="server" Font-Bold="True" onclick="PlaceOrder_Click" TabIndex="60" Text="Place Sell Order" CssClass="auto-style21" Font-Size="Medium" BackColor="#FFAAAA" ForeColor="Black" />                                   
                </td>               
                <td class="auto-style48" colspan="2">        
                    <asp:Button ID="AutoFill" runat="server" Font-Bold="False" onclick="AutoFill_Click" TabIndex="50" Text="Suggest Numbers" CssClass="text-center" Font-Size="Small" BackColor="#66FF66" ForeColor="Black" Height="50px" Width="276px" />                                   
                    </td>
            </tr>                    
            <tr>
               
                <td class="auto-style51" colspan="4">    
                    &nbsp;</td>
               
            </tr>                    

            <tr>
               
                <td class="auto-style63">    
    
                    Transaction price history:</td>
               
                <td class="text-left" colspan="3">    
    
                    &nbsp;</td>
               
            </tr>                    

                <tr>
               
                <td class="auto-style21" colspan="4">
    
                    <asp:Chart ID="Chart1" runat="server" CssClass="text-center" DataSourceID="SqlDataSource1" Height="385px" Width="1000px" Palette="Bright" IsMapEnabled="False" ImageLocation="~/Images/ChartPic_#SEQ(300,3)">
                        <series>
                            <asp:Series ChartType="Line" Name="Series1" YValuesPerPoint="4" XValueMember="TranTime" YValueMembers="Price">
                            </asp:Series>
                        </series>
                        <chartareas>
                            <asp:ChartArea Name="ChartArea1">
                                <AxisY>
                                    <MajorGrid Enabled="False" />
                                    <MinorGrid Enabled="True" LineColor="Gainsboro" />
                                </AxisY>
                                <AxisX>
                                    <MajorGrid Enabled="False" />
                                    <MinorGrid Enabled="True" LineColor="MistyRose" />
                                    <LabelStyle Enabled="False" />
                                </AxisX>
                            </asp:ChartArea>
                        </chartareas>
                        <BorderSkin BackColor="White" />
                    </asp:Chart>
                   </td> 
                <tr>
               
                <td class="auto-style60" colspan="4">
                    </td>
    
                    &nbsp;<tr>
               
                <td class="auto-style58" colspan="2">
    
                    &nbsp;&nbsp; Your cash balance if this choice wins = $ <asp:Label ID="BalanceWin" runat="server" Class="balance" Font-Bold="False" Font-Size="Small" CssClass="auto-style59">0</asp:Label>                                  
                               
                <td class="style2" colspan="2">
    
                    &nbsp;<span class="auto-style59">&nbsp; Refund amount if this choice voids = $ </span> <asp:Label ID="BalanceVoid" runat="server" Class="balance" Font-Bold="False" Font-Size="Small" CssClass="auto-style59">0</asp:Label>                                  
                               
                <tr>
               
                <td class="auto-style58" colspan="2">
    
                    &nbsp;<td class="style2" colspan="2">
    
                        &nbsp;</table>           
    <script>
        function VersionArtifactMouseOver() {
            Array.from(this.getElementsByClassName("diff-delnohover")).map(function (e) { e.classList.remove("diff-delnohover"); });
            Array.from(this.getElementsByClassName("diff-addnohover")).map(function (e) { e.classList.remove("diff-addnohover"); });
        }
        Array.from(document.getElementsByClassName("version-artifact")).map(function (e) { e.addEventListener("mouseover", VersionArtifactMouseOver); });

        function VersionArtifactMouseOut() {
            Array.from(this.getElementsByClassName("diff-add")).map(function (e) { e.classList.add("diff-addnohover"); });
            Array.from(this.getElementsByClassName("diff-del")).map(function (e) { e.classList.add("diff-delnohover"); });
        }
        Array.from(document.getElementsByClassName("version-artifact")).map(function (e) { e.addEventListener("mouseout", VersionArtifactMouseOut); });
    </script>
        
                    <a href="/tips.aspx" targVisual Directions </a>
    
                  <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:ProcessTreeConnectionString %>" SelectCommand="SELECT Price, CASE WHEN Sell_Time &gt; Buy_Time THEN Sell_Time ELSE Buy_Time END AS TranTime
FROM Transactions 
WHERE (Treatment = @Treatment) AND ([Group#] = @Group) AND (Period = @Period) AND (Choice = @Choice)
 --OR Choice = 0 AND Vol = 0) 
ORDER BY TranID">
                      <SelectParameters>
                          <asp:Parameter DefaultValue="0" Name="Treatment" />
                          <asp:Parameter DefaultValue="1" Name="Group" />
                          <asp:Parameter DefaultValue="2" Name="Period" />
                          <asp:Parameter DefaultValue="0" Name="Choice" />
                      </SelectParameters>
                  </asp:SqlDataSource>
    
                  </a>
    
    </form>
    <script src="https://code.jquery.com/jquery-3.3.1.slim.min.js" integrity="sha384-q8i/X+965DzO0rT7abK41JStQIAqVgRVzpbzo5smXKp4YfRvH+8abtTE1Pi6jizo" crossorigin="anonymous"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js" integrity="sha384-UO2eT0CpHqdSJQ6hJty5KVphtPhzWj9WO1clHTMGa3JDZwrnQq4sF86dIHNDz0W1" crossorigin="anonymous"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js" integrity="sha384-JjSmVgyd0p3pXB1rRibZUAYoIIy6OrQ6VrjIEaFf/nJGzIxFDsf4x0xIM+B07jRM" crossorigin="anonymous"></script>
    </body>
</html>
