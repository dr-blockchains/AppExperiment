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
            width: 51%;
        }
        .auto-style31 {
            text-align: right;
            width: 51%;
        }
        .auto-style32 {
                        
            height: 174px;
            line-height : 30px;
            margin: 0px auto;
            font-size: medium;
        }

        .auto-style41 {
            width: 74%;
        }
        
        .auto-style51 {
            text-align: right;
            }
        .auto-style56 {
            height: 36px;
            text-align: right;
        }
        
        .auto-style58 {
            text-align: left;
            font-size: small;
            width: 51%;
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

        .auto-style64 {
            height: 36px;
            text-align: left;
            width: 51%;
        }

        .auto-style65 {
            height: 36px;
            text-align: center;
            width: 1075px;
        }
        .auto-style66 {
            height: 36px;
            text-align: right;
            width: 51%;
        }
        
        .auto-style68 {
            font-size: medium;
        }
        .auto-style69 {
            height: 36px;
            text-align: left;
            width: 51%;
            font-size: medium;
        }
        .auto-style70 {
            height: 36px;
            text-align: right;
            font-size: medium;
        }
        .auto-style71 {
            height: 57px;
            text-align: right;
            width: 1075px;
        }
        .auto-style73 {
            height: 36px;
            text-align: right;
            width: 1075px;
            text-decoration: underline;
            color: #99CCFF;
        }
        .auto-style74 {
            height: 36px;
            text-align: right;
            text-decoration: underline;
        }

        .auto-style75 {
            height: 36px;
            text-align: left;
        }

        .auto-style78 {
            height: 36px;
            text-align: center;
            width: 895px;
        }

        .auto-style79 {
            width: 315px;
        }

        .auto-style80 {
            margin-bottom: 9px;
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
                <td class="questions" colspan="3">
    
                    <span class="auto-style62"><em>Return to switch to another choice: </em></span>
    
                                    <asp:Button ID="BtnReturn" runat="server" OnClick="BtnReturn_Click" Text="Return" TabIndex="90" />
                </td>     
            </tr>            
                          <tr>
                <td colspan="5">
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
                <td id="DeadLine" class="time" colspan="3">
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
                <td id="Timer" class="time" colspan="3">

                </td>
            </tr>                    
            <tr>               
                <td class="text-left" colspan="2" rowspan="3">      
    
                    <p class="text-left">
    
                    &nbsp;                                    
                &nbsp;&nbsp;&nbsp;
                        
                    <asp:Label ID="Message" runat="server" Font-Bold="True" ForeColor="#993333" CssClass="auto-style1" Font-Size="Medium" Height="60px" style="font-size: medium; margin-bottom: 0px;" Font-Italic="True" Width="98%"></asp:Label>
                    </p>
                                   
                </td>
               
                <td class="auto-style75" colspan="3">      
                    &nbsp;</td>
               
            </tr>                    
            <tr>
               
                <td class="auto-style78">    
                    <asp:RadioButtonList ID="RadioOrder" runat="server" RepeatDirection="Horizontal" BorderStyle="Ridge" BorderWidth="3px" Font-Bold="True" OnSelectedIndexChanged="javascript: RadioClick()" TabIndex="20" BackColor="pink" Height="66px" BorderColor="Red" CellPadding="3" CellSpacing="3" CssClass="auto-style80" Width="100%">
                        <asp:ListItem>Buy</asp:ListItem>
                        <asp:ListItem Selected="True">Sell</asp:ListItem>
                    </asp:RadioButtonList>

<%--                      <div id="RadioButton" onclick="RadioClick()" style="text-align: center; padding: 10px; border-style:groove; border-width:3px; font-weight:bold; background-color:pink; width:100%;" >
                            <input type="radio" name="Position" value="Buy"/> Buy &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                            <input type="radio" name="Position" value="Sell" checked /> Sell
                      </div>--%>
                </td>
                             
            </tr>                    
            <tr>
               
                <td class="auto-style71" colspan="4">    
                    &nbsp;</td>
               
            </tr>                    
            <tr>
               
               
                <td class="auto-style56" colspan="2">    
    
                    <p>
    
                        Your available Shares for this choice = <asp:Label ID="AvShare" runat="server" Class="balance" Font-Bold="True" Font-Size="Medium"></asp:Label>  
                                   
                    </p>
                                   
                </td>
               
                <td class="auto-style61" colspan="2">    
 
                    Number of Shares&nbsp;you <asp:Label ID="BuySell" runat="server" Text="Sell" Font-Bold="True"></asp:Label>
&nbsp;= 
                    <asp:TextBox ID="DeltaShares" runat="server" type="text" name="txt" value="0" onchange="javascript: DShare2All();LastChange.innerHTML='S';" BackColor="pink" TabIndex="30" Width="99px" Font-Bold="True" Height="40px"></asp:TextBox>

                          <%--<input type="text" name="DeltaShares" id="DeltaShares" value="0" style="width: 100px; background-color:pink;" onchange="DShare2All();LastChange.innerHTML='S';" />--%>

                </td>
               
                <td class="auto-style56">    
                    <div id="LastChange" hidden="hidden">S</div>  
    
                                    &nbsp;</td>
            </tr>                    
            <tr>
               
               
                <td class="auto-style56" colspan="2">    
    
                    <p>
                        Your available Balance for this choice = $ <asp:Label ID="AvFund" runat="server" Class="balance" Font-Bold="True" Font-Size="Medium"></asp:Label>                                  
                                   
                    </p>
                </td>
               
                <td class="auto-style61" colspan="2">    
 
                    <p>
 
                    Amount of Fund Transfer = $ 
                       
                        <asp:TextBox ID="DeltaFund" runat="server" BackColor="pink" TabIndex="40" Width="99px" Font-Bold="True" Height="40px" onchange="javascript: DFund2All();LastChange.innerHTML='F';">0</asp:TextBox>
         
                        <%--<input type="text" name="DeltaFund" id="DeltaFund" value="0" style="width: 100px; background-color:pink;" onchange="DFund2All();LastChange.innerHTML='F';" />--%>
            
                    </p>

                </td>
               
                <td class="auto-style56">    
    
                                    &nbsp;</td>
            </tr>                    
            <tr>
               
                <td class="auto-style74" colspan="2">    
    
                    </td>
               
                <td class="auto-style73" colspan="2">    
                    &nbsp;</td>
               
                <td class="auto-style56">    
    
                                    &nbsp;</td>
            </tr>                    
            <tr>
               
                <td class="auto-style70" colspan="2">    
    
                    Current Shares outstanding =    
    
                    <asp:Label ID="StartShares" runat="server" BackColor="Yellow" BorderStyle="Solid" Font-Bold="False" Text="N/A" BorderColor="#FFCC00" BorderWidth="3px"></asp:Label>
                </td>
               
                <td class="auto-style61" colspan="2">    
                    <h4>
                        <span class="auto-style68">&nbsp;Target shares outstanding =&nbsp; </span> <asp:TextBox ID="EndShares" runat="server" BackColor="pink" TabIndex="40" Width="99px" Font-Bold="True" Height="40px" ReadOnly="True" CssClass="auto-style68"></asp:TextBox>

                    </h4>

                </td>
               
                <td class="auto-style56">    
    
                                    &nbsp;</td>
            </tr>                    
            <tr>
               
                <td class="auto-style70" colspan="2">    
    
                    Current Price per share =    
    
                    $    
    
                    <asp:Label ID="StartPrice" runat="server" BackColor="Yellow" BorderStyle="Solid" Font-Bold="False" Text="N/A" BorderColor="#FFCC00" BorderWidth="3px"></asp:Label>
                </td>
               
                <td class="auto-style61" colspan="2">    
                    <h4>
                        <span class="auto-style68">Target Price (per share) = $ </span> <asp:TextBox ID="EndPrice" runat="server" BackColor="pink" TabIndex="40" Width="99px" Font-Bold="True" Height="40px" ReadOnly="True" CssClass="auto-style68"></asp:TextBox>

                        </h4>
                </td>
               
                <td class="auto-style56">    
    
                                    &nbsp;</td>
            </tr>                    
            <tr>
               
                <td class="auto-style69" colspan="2">    
    
                    <h4></h4>
                </td>
               
                <td class="auto-style61" colspan="2">    
 
                    <h4>
 
                        <span class="auto-style68">Average transaction Price = $&nbsp;</span><asp:TextBox ID="AveragePrice" runat="server" BackColor="pink" TabIndex="40" Width="99px" Font-Bold="True" Height="40px" ReadOnly="True" CssClass="auto-style68"></asp:TextBox>

                        </h4>
                </td>
               
                <td class="auto-style56">    
    
                                    &nbsp;</td>
            </tr>                    
            <tr>
               
                <td class="auto-style64" colspan="2">    
    
                    &nbsp;</td>
               
                <td class="auto-style61" colspan="2">    
                    &nbsp;</td>
               
                <td class="auto-style56">    
    
                                    &nbsp;</td>
            </tr>                    
            <tr>
               
                <td class="auto-style66" colspan="2">    
                    <input type="button" id="AutoFill" onclick="AutoFill_Click()" value="Suggest Numbers" style="background-color: pink" class="auto-style79"/>                                   
                </td>
               
                <td class="auto-style65" colspan="2">    
                <asp:Button ID="PlaceOrder" runat="server" Font-Bold="True" onclick="PlaceOrder_Click" TabIndex="60" Text="Sell Shares" CssClass="auto-style21" Font-Size="Medium" BackColor="pink" ForeColor="Black" />                                   
                </td>
               
                <td class="auto-style56">    
    
                                    &nbsp;</td>
            </tr>                    
            <tr>
               
                <td class="auto-style64" colspan="2">    
    
                    &nbsp;</td>
               
                <td class="auto-style61" colspan="2">    
                    &nbsp;</td>
               
                <td class="auto-style56">    
    
                                    &nbsp;</td>
            </tr>                    
                      
<script>
                          function DShare2All() {

                              shares1 = Number(StartShares.Text);

                              dshare = Number(DeltaShares.Text);
                              if (dshare <= 0 || dshare > 10000) dshare = NaN;

                              dfund = Number(DeltaFund.Text);
                              if (dfund <= 0 || dfund > 1000) dfund = NaN;

                              if (RadioOrder.SelectedValue == "Buy") {

                                  shares2 = Math.sqrt(200.0 * dfund + shares1 * shares1);
                                  dshare = shares2 - shares1;
                                  DeltaShares.Text = dshare.ToString();
                              }
                              else {

                                  shares2 = shares1 - dshare;
                                  dfund = dshare * (shares1 + shares2) / 200.0f;
                                  DeltaFund.Text = dfund.ToString("C");
                              }

                              AveragePrice.Text = ((shares1 + shares2) / 200.0).toString();
                              EndPrice.Text = (shares2 / 100.0).toString();
                              EndShares.Text = shares2.toString();
                          }
</script>

            <tr>
               
                <td class="auto-style51" colspan="5">    
                    &nbsp;</td>
               
            </tr>                    

            <tr>
               
                <td class="auto-style63">    
    
                    Transaction price history:</td>
               
                <td class="text-left" colspan="4">    
    
                    &nbsp;</td>
               
            </tr>                    

                <tr>
               
                <td class="auto-style21" colspan="5">
    
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
                    </tr>

                <tr>
               
                <td class="auto-style60" colspan="5">
                    </td>
    
                    &nbsp;<tr>
               
                <td class="auto-style58" colspan="2">
    
                    &nbsp;&nbsp; Your cash balance if this choice wins = $ <asp:Label ID="BalanceWin" runat="server" Class="balance" Font-Bold="False" Font-Size="Small" CssClass="auto-style59">0</asp:Label>                                  
                               
                <td class="style2" colspan="3">
    
                    &nbsp;<span class="auto-style59">&nbsp; Refund amount if this choice voids = $ </span> <asp:Label ID="BalanceVoid" runat="server" Class="balance" Font-Bold="False" Font-Size="Small" CssClass="auto-style59">0</asp:Label>                                  
                               
                <tr>
               
                <td class="auto-style58" colspan="2">
    
                    &nbsp;<td class="style2" colspan="3">
    
                        &nbsp;</table>           
                  <div class="text-right">
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
        
                   <a href="./tips.aspx" target="_blank"><strong>Visual Directdions </strong></a>
    
                  </div>
    
                  <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:ProcessTreeConnectionString %>" SelectCommand="SELECT Price, Time AS TranTime FROM Offers WHERE (Treatment = @Treatment) AND (Group# = @Group ) AND (Period = @Period) AND (Choice = @Choice) ORDER BY TranTime">
                      <SelectParameters>
                          <asp:Parameter DefaultValue="0" Name="Treatment" />
                          <asp:Parameter DefaultValue="1" Name="Group" />
                          <asp:Parameter DefaultValue="2" Name="Period" />
                          <asp:Parameter DefaultValue="0" Name="Choice" />
                      </SelectParameters>
                  </asp:SqlDataSource>
    
                  </a>
    
    </form>
    <script>
        DShare2All();
    </script>
    <script src="https://code.jquery.com/jquery-3.3.1.slim.min.js" integrity="sha384-q8i/X+965DzO0rT7abK41JStQIAqVgRVzpbzo5smXKp4YfRvH+8abtTE1Pi6jizo" crossorigin="anonymous"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js" integrity="sha384-UO2eT0CpHqdSJQ6hJty5KVphtPhzWj9WO1clHTMGa3JDZwrnQq4sF86dIHNDz0W1" crossorigin="anonymous"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js" integrity="sha384-JjSmVgyd0p3pXB1rRibZUAYoIIy6OrQ6VrjIEaFf/nJGzIxFDsf4x0xIM+B07jRM" crossorigin="anonymous"></script>
    </body>
</html>
