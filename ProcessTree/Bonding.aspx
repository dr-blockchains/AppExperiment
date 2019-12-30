
<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Bonding.aspx.cs" Inherits="ProcessTree.Bonding" MaintainScrollPositionOnPostback="true" %>

<%@ Register Assembly="System.Web.DataVisualization, Version=4.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35" Namespace="System.Web.UI.DataVisualization.Charting" TagPrefix="asp" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Bonding</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css" />

    <script src="Timer.js">  </script>

    <link href="StyleSheet.css" rel="stylesheet" type="text/css" />
    <style type="text/css">
        .auto-style2 {
            width: 50%;
        }

        .auto-style3 {
            width: 46%
        }

        .auto-style5 {
            width: 46%;
            text-align: right;
        }

        .auto-style6 {
            font-style: italic;
            font-size: 1em;
            color: darkblue;
            font-weight: bold;
            border: solid #ccc 2px;
            border-radius: 5px;
            padding: 3px;
            text-align: left;
        }
        .auto-style7 {
            width: 50%;
            font-size: medium;
        }
        .auto-style8 {
            width: 46%;
            font-size: medium;
        }
        .auto-style9 {
            font-size: medium;
        }
        .auto-style11 {
            width: 46%;
            text-align: left;
        }
        .auto-style12 {
            width: 46%;
            font-size: small;
        }
        .newStyle1 {
            font-size: small;
        }
        .auto-style13 {
            height: 50px;
        }
        .auto-style14 {
            text-align: left;
            height: 50px;
        }
        </style>
</head>
<body>
    <form id="Bonding" runat="server" class="auto-style41">
        <table class="auto-style32">
            <tr>
                <td class="auto-style3" colspan="2">
                    <strong><em>
                        <asp:Label ID="PeriodChoice" runat="server" Font-Size="Large" Text="Please contact the admin: Law.Economist@Gmail.com" ForeColor="#000099" Width="147%"></asp:Label>
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
                <asp:Label ID="TimeSpan" runat="server" Style="display: none"></asp:Label>
            </tr>

            <tr>
                <td class="auto-style5" colspan="2">
                    <asp:Label ID="DeadLineMessage" runat="server" Font-Bold="True" Text="This market closes at "></asp:Label>
                </td>
                <td id="DeadLine" class="auto-style6" colspan="3">
                    <script>
                        var TSpan = parseInt(document.getElementById("TimeSpan").textContent);
                        var ClientDeadLine = new Date((new Date()).getTime() + TSpan);
                        document.write(ClientDeadLine.toLocaleTimeString([], options));
                        CountDownTimer(ClientDeadLine, "Timer");
                    </script>
                </td>
            </tr>
            <tr>

                <td class="auto-style5" colspan="2">
                    <asp:Label ID="TimerMessage" runat="server" Font-Bold="True" Text="in about"></asp:Label>
                </td>
                <td id="Timer" class="time" colspan="3"></td>
            </tr>
            <tr>

                <td class="newStyle1" colspan="2">
                    <div class="text-center">

                    <asp:RadioButtonList ID="RadioOrder" ClientIDMode="Static" runat="server" RepeatDirection="Horizontal" onclick="javascript: RadioClick();"
                        BorderStyle="Ridge" BorderWidth="3px" Font-Bold="True" TabIndex="20" BackColor="pink" Height="48px" CellPadding="5" CellSpacing="5" Font-Size="Large" Width="60%">
                        <asp:ListItem>Buy</asp:ListItem>
                        <asp:ListItem Selected="True">Sell</asp:ListItem>
                    </asp:RadioButtonList>
                    </div>

                </td>

                <td class="newStyle1" colspan="2">
                    <p class="text-center">

                    <input type="button" id="AutoFill" onclick="AutoFill_Click()" value="Suggest Numbers" style="background-color: pink" /></p>
                    </td>

                <td class="auto-style56">&nbsp;</td>
            </tr>
            <tr>

                <td class="auto-style3" colspan="2">&nbsp;</td>

                <td class="text-center" colspan="2">&nbsp;</td>

                <td class="auto-style56">&nbsp;</td>
            </tr>


            <tr>

                <td class="auto-style3" colspan="2">

                    <span class="auto-style2">Your available Shares for this choice = </span>
                    <asp:Label ID="AvShare" runat="server" Class="balance" Font-Bold="True" Font-Size="Medium" CssClass="auto-style2" ForeColor="#336600" Width="100px"></asp:Label>

                </td>

                <td>Number of Shares&nbsp;you
                    <asp:Label ID="BuySell" ClientIDMode="Static" runat="server" Text="Sell" Font-Bold="True"></asp:Label>
                    &nbsp;= 
                    <asp:TextBox ID="DeltaShares" ClientIDMode="Static" runat="server" type="text" name="txt" value="0" onchange="javascript: Message.innerHTML = ' '; DShare2All();LastChange.innerHTML='S';" BackColor="pink" TabIndex="30" Width="99px" Font-Bold="True" Height="40px">NaN</asp:TextBox>
                </td> 
                <td class="auto-style61" rowspan="2">

                    &nbsp;</td>

                <td class="auto-style56">&nbsp;</td>
            </tr>

            <tr>

                <td class="auto-style3" colspan="2">

                    <span class="auto-style2">Your available Balance for this choice = $ </span>
                    <asp:Label ID="AvFund" runat="server" Class="balance" Font-Bold="True" Font-Size="Medium" CssClass="auto-style2" ForeColor="#336600" Width="100px"></asp:Label>

                </td>

                <td>Amount of Fund Transfer = 
                       
                        <strong>$</strong> 
                       
                        <asp:TextBox ID="DeltaFund" ClientIDMode="Static" runat="server" BackColor="pink" TabIndex="40" Width="99px" Font-Bold="True" Height="40px" onchange="javascript: Message.innerHTML = ' '; DFund2All();LastChange.innerHTML='F';">NaN</asp:TextBox>

                 </td>

                <td class="auto-style56">

                      <div id="LastChange" hidden>S</div>
                </td>
            </tr>

            <tr>

                <td class="auto-style3" colspan="2">    
                    &nbsp;</td>

                <td class="text-right" colspan="2">&nbsp;</td>

                <td class="auto-style56">&nbsp;</td>
            </tr>

            <tr>

                <td class="auto-style8" colspan="2">

                    <span class="auto-style7">Current shares outstanding =    
    
                    </span>

                    <asp:Label ID="StartShares" ClientIDMode="Static" runat="server" BackColor="Yellow" BorderStyle="Solid" Font-Bold="False" Text="0" BorderColor="#FFCC00" BorderWidth="3px" CssClass="auto-style9"></asp:Label>
                    <span class="auto-style9">
          
                    </span>
                
                </td>

                <td class="auto-style61" colspan="2">
                    <span class="auto-style7">Target shares outstanding =&nbsp; </span>
                    <asp:Label ID="EndShares" runat="server" BackColor="Yellow" TabIndex="40" Font-Bold="False" ReadOnly="True" CssClass="auto-style68" Style="font-size: medium" BorderColor="#FFCC00" BorderStyle="Solid" BorderWidth="3px" ClientIDMode="Static" Font-Size="Small">NaN</asp:Label>

                </td>

                <td class="auto-style56">&nbsp;</td>
            </tr>

            <tr>

                <td class="auto-style8" colspan="2">

                    <span class="auto-style7">Current share price = $    
    
                    </span>

                    <asp:Label ID="StartPrice" ClientIDMode="Static" runat="server" BackColor="Yellow" BorderStyle="Solid" Font-Bold="False" Text="0" BorderColor="#FFCC00" BorderWidth="3px" CssClass="auto-style9"></asp:Label>
                </td>

                <td class="auto-style61" colspan="2">
                    <span class="auto-style7">Target share price = $ </span>
                    <asp:Label ID="EndPrice" ClientIDMode="Static" runat="server" BackColor="Yellow" TabIndex="40" Font-Bold="False" ReadOnly="True" CssClass="auto-style68" Style="font-size: medium" BorderColor="#FFCC00" BorderStyle="Solid" BorderWidth="3px" Font-Size="Small">NaN</asp:Label>
                </td>

                <td class="auto-style56"></td>
            </tr>

            <tr>

                <td class="auto-style12" colspan="2"><em>Share Price = (<asp:Label ID="Atxt" ClientIDMode="Static" runat="server" BorderStyle="Solid" Font-Bold="False" Text="0" BorderColor="#FFCC00" BorderWidth="1px" CssClass="auto-style9"></asp:Label>
                    )*(Shares Outstanding) + (<asp:Label ID="Btxt" ClientIDMode="Static" runat="server" BorderStyle="Solid" Font-Bold="False" Text="0" BorderColor="#FFCC00" BorderWidth="1px" CssClass="auto-style9"></asp:Label>
                    )</em></td>

                <td class="auto-style61" colspan="2">

                    <span class="auto-style7">Average transaction price = $&nbsp;</span>
                    <asp:Label ID="AveragePrice" ClientIDMode="Static" runat="server" BackColor="Yellow" TabIndex="40" Font-Bold="False" ReadOnly="True" CssClass="auto-style68" Style="font-size: medium" BorderColor="#FFCC00" BorderStyle="Solid" BorderWidth="3px" Font-Size="Small">NaN</asp:Label>

                </td>

                <td class="auto-style56">&nbsp;</td>
            </tr>

            <tr>

                <td class="auto-style3" colspan="2">

                    <p>

                        &nbsp;</p>
                </td>

                <td class="auto-style61" colspan="2">    

                    &nbsp;</td>

                <td class="auto-style56">&nbsp;</td>
            </tr>

            <tr>

                <td class="auto-style11" colspan="2">    

                    <span class="newStyle1"><em>Refresh to update numbers:&nbsp;</em></span><asp:Button ID="BtnRefresh" runat="server" OnClick="BtnRefresh_Click" Text="Refresh" TabIndex="85" BackColor="#66FFFF" Height="43px" Width="110px" Font-Size="Small"/>
    
                        </td>

                <td class="text-center" colspan="2"> 

                    &nbsp;&nbsp;
                    <asp:Button ID="PlaceOrder" ClientIDMode="Static" runat="server" Font-Bold="True" OnClick="PlaceOrder_Click" TabIndex="60" Text="Sell Shares" CssClass="auto-style21" Font-Size="Large" BackColor="pink" ForeColor="Black" />

                </td>

                <td class="auto-style56">&nbsp;</td>
            </tr>

            <tr>

                <td class="auto-style13">Transaction price history:</td>

                <td class="auto-style14" colspan="4">

                    <asp:Label ID="Message" ClientIDMode="Static" runat="server" Font-Bold="True" ForeColor="#993333" Font-Size="Medium" Height="63px" Style="font-size: medium; margin-bottom: 0px;" Font-Italic="True"></asp:Label>
    
                </td>

            </tr>

            <tr>
                <td class="text-center" colspan="4">

                    <asp:Chart ID="Chart1" runat="server" CssClass="text-center" DataSourceID="SqlDataSource1" Height="522px" Width="916px" Palette="Bright" IsMapEnabled="False" ImageLocation="~/Images/ChartPic_#SEQ(300,3)">
                        <Series>
                            <asp:Series ChartType="Line" Name="Series1" YValuesPerPoint="4" XValueMember="TranTime" YValueMembers="Price">
                            </asp:Series>
                        </Series>
                        <ChartAreas>
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
                        </ChartAreas>
                        <BorderSkin BackColor="White" />
                    </asp:Chart>
                </td>
            </tr>
            <tr>
                <td class="auto-style3" colspan="2">&nbsp;&nbsp; Your cash balance if this choice wins = $
                    <asp:Label ID="BalanceWin" runat="server" Class="balance" Font-Bold="False" Font-Size="Small" CssClass="auto-style59">0</asp:Label>

                </td>
                <td class="style2" colspan="3">&nbsp;<span class="auto-style59">&nbsp; Refund amount if this choice voids = $ </span>
                    <asp:Label ID="BalanceVoid" runat="server" Class="balance" Font-Bold="False" Font-Size="Small" CssClass="auto-style59">0</asp:Label>
                </td>
            </tr>
            </table>
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

            <%--<a href="./tips.aspx" target="_blank"><strong>Visual Directdions </strong></a>--%>

        </div>

        <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:ProcessTreeConnectionString %>" SelectCommand="SELECT Price, Time AS TranTime FROM Offers WHERE (Treatment = @Treatment) AND (Group# = @Group ) AND (Period = @Period) AND (Choice = @Choice) ORDER BY TranTime">
            <SelectParameters>
                <asp:Parameter DefaultValue="0" Name="Treatment" />
                <asp:Parameter DefaultValue="1" Name="Group" />
                <asp:Parameter DefaultValue="2" Name="Period" />
                <asp:Parameter DefaultValue="0" Name="Choice" />
            </SelectParameters>
        </asp:SqlDataSource>

    <script>

        //window.setInterval(PullPrice, 500);

        //function PullPrice() {

        //    get score from Versions.Score

        //    StartShares.innerHTML = Versions.Score ;
        //    Share2All();
        //}

        //let socket;

        //export default function Store(props) {

        //    if (!socket) {
        //        socket = io(':3001');
        //        socket.on('chat message', function (msg) {
        //            dispatch({ type: 'RECEIVE_MESSAGE', payload: msg })
        //        });
        //    }

        // fetch (url )

        //socket = socket.io(':3001');
        //socket.on("New shares", function (msg) {
        //    StartShares.innerHTML = msg.StartShares;
        //    DShare2All();
        //})

        RadioClick();
        DShare2All();

        function DShare2All() {

            const shares1 = Number(StartShares.innerHTML);
            const a = Number(Atxt.innerHTML);
            const b = Number(Btxt.innerHTML);
            
            const p1 = (a * shares1 + b);
            StartPrice.innerHTML = p1.toFixed(2);

            dshare = Number(DeltaShares.value);
            if (dshare <= 0 || dshare > 10000) {
                Message.innerHTML = "Enter a valid number for shares!";
                dshare = 0;
                DeltaShares.value = '0';
            }

            const SelectedRadio = document.querySelector("input[name='RadioOrder']:checked").value;
            document.getElementById("PlaceOrder").disabled = false;

            if (SelectedRadio == "Buy") { // Buy
                const avfund = Number(AvFund.innerHTML);
                if (avfund <= 0) {
                    Message.innerHTML = ("You have no fund!");
                    document.getElementById("PlaceOrder").disabled = true;
                    dfund = 0;
                    shares2 = shares1;
                    dshare = 0;
                    DeltaShares.value = dshare.toFixed(3);
                }
                else {
                    shares2 = shares1 + dshare;
                    dfund = dshare * (a * (shares1 + shares2) / 2 + b);
                    if (dfund >= avfund) {
                        Message.innerHTML = ("Using all available fund!");
                        dfund = avfund;
                        shares2 = Math.ceil((-b + Math.sqrt(p1 * p1 + 2 * a * dfund)) * 1000 / a) / 1000;
                        dshare = shares2 - shares1;
                        DeltaShares.value = dshare.toFixed(3);
                    }
                }

            } else { // Sell 
                avshare = Number(AvShare.innerHTML);
                if (avshare > shares1) {
                    alert("Error449: Your Share (" + avshare + ") > Total Share ("+shares1+")");
                    avshare = shares1;
                    AvShare.innerHTML = avshare.toFixed(3);
                }

                if (avshare <= 0) {
                    Message.innerHTML = ("You have no share!");
                    document.getElementById("PlaceOrder").disabled = true;
                    dshare = 0;
                    DeltaShares.value = dshare.toFixed(3);
                }
                else if (dshare >= avshare) {
                    Message.innerHTML = ("Selling all your shares!");
                    dshare = avshare;
                    DeltaShares.value = dshare.toFixed(3);
                }

                shares2 = shares1 - dshare;
                dfund = dshare * (a * (shares1 + shares2) / 2 + b);                
            }

            DeltaFund.value = dfund.toFixed(2);

            EndShares.innerHTML = shares2.toFixed(3);
            EndPrice.innerHTML = (a * shares2 + b).toFixed(2);
            AveragePrice.innerHTML = (.5 * a * (shares1 + shares2) + b).toFixed(2);            
        }

        function DFund2All() {

            const shares1 = Number(StartShares.innerHTML);
            const a = Number(Atxt.innerHTML);
            const b = Number(Btxt.innerHTML);

            const p1 = (a * shares1 + b);
            StartPrice.innerHTML = p1.toFixed(2);

            dfund = Number(DeltaFund.value);
            if (dfund < 0 || dfund > 1000) {
                Message.innerHTML = "Enter a valid number for fund!";
                dfund = 0;
                DeltaFund.value = '0';
            }

            const SelectedRadio = document.querySelector("input[name='RadioOrder']:checked").value;
            document.getElementById("PlaceOrder").disabled = false;

            if (SelectedRadio == "Buy") {
                const avfund = Number(AvFund.innerHTML);
                if (avfund <= 0) {
                    Message.innerHTML = ("You have no fund!");
                    document.getElementById("PlaceOrder").disabled = true;
                    dfund = 0;
                    DeltaFund.value = dfund;
                }
                else if (dfund >= avfund) {
                    Message.innerHTML = ("Using all available fund!");
                    dfund = avfund;
                    DeltaFund.value = dfund;
                }
                shares2 = Math.ceil((-b + Math.sqrt(p1 * p1 + 2 * a * dfund)) * 1000 / a) / 1000;
                dshare = shares2 - shares1;

            } else { // Sell
                avshare = Number(AvShare.innerHTML);
                if (avshare > shares1) {
                    alert("Error513: Your Share (" + avshare + ") > Total Share (" + shares1 + ")");
                    avshare = shares1;
                    AvShare.innerHTML = avshare.toFixed(3);
                }

                if (avshare <= 0) {
                    Message.innerHTML = ("You have no share!");
                    document.getElementById("PlaceOrder").disabled = true;
                    dshare = 0;
                    shares2 = shares1;
                    dfund = 0;
                    DeltaFund.value = dfund.toFixed(2);
                }
                else {

                    shares2 = shares1 - avshare;
                    avfundS = avshare * (a * (shares1 + shares2) / 2 + b); 

                    //const F1 = (.5 * a * shares1 + b) * shares1;
                    //const F2 = (.5 * a * shares2 + b) * shares2;
                    //avfundS = F1 - F2;

                    if (dfund > avfundS) {
                        Message.innerHTML = ("Selling all your shares!");
                        dfund = avfundS;
                        DeltaFund.value = dfund.toFixed(2);
                    }

                    shares2 = (-b + Math.sqrt(p1 * p1 - 2 * a * dfund)) / a;
                    dshare = shares1 - shares2;

                    if (dshare >= avshare) {
                        Message.innerHTML = ("Selling all your shares!");
                        dshare = avshare;
                        shares2 = shares1 - dshare;
                        dfund = dshare * (a * (shares1 + shares2) / 2 + b);
                        DeltaFund.value = dfund.toFixed(2);
                    }
                }
            }

            DeltaShares.value = dshare.toFixed(3);

            EndShares.innerHTML = shares2.toFixed(3);
            EndPrice.innerHTML = (a * shares2 + b).toFixed(2);
            AveragePrice.innerHTML = (.5 * a * (shares1 + shares2) + b).toFixed(2); 
        }

        function RadioClick() {

            Message.innerHTML = " ";
            const SelectedRadio = document.querySelector("input[name='RadioOrder']:checked").value;

            if (SelectedRadio == "Buy") {
                DeltaFund.focus();
                const avfund = Number(AvFund.innerHTML);
                if(avfund <= 0){
                    Message.innerHTML = ("You have no fund!");
                    document.getElementById("PlaceOrder").disabled = true;
                }
                else {
                    Message.innerHTML = ('');
                    document.getElementById("PlaceOrder").disabled = false;
                }

                PlaceOrder.value = "Buy Shares";
                BuySell.innerHTML = "Buy";

                RadioOrder.style.backgroundColor = "lightgreen";
                PlaceOrder.style.backgroundColor = "lightgreen";
                AutoFill.style.backgroundColor = "lightgreen";
                DeltaShares.style.backgroundColor = "lightgreen";
                DeltaFund.style.backgroundColor = "lightgreen";

                //AveragePrice.style.backgroundColor = "lightgreen";
                //EndPrice.style.backgroundColor = "lightgreen";
                //EndShares.style.backgroundColor = "lightgreen";

                //Order.style.backgroundColor = "lightgreen";
                // document.getElementById("PlaceOrder").innerHTML = "Buy Shares";
                // document.getElementById("PlaceOrder").style.backgroundColor = "lightgreen";
                // document.getElementById("AutoFill").style.backgroundColor = "lightgreen";
                // document.getElementById("DeltaShares").style.backgroundColor = "lightgreen";
                // document.getElementById("DeltaFund").style.backgroundColor = "lightgreen";
                // document.getElementById("AveragePrice").style.backgroundColor = "lightgreen";
                // document.getElementById("EndPrice").style.backgroundColor = "lightgreen";
                // document.getElementById("EndShares").style.backgroundColor = "lightgreen";
                // document.getElementById("RadioButton").style.backgroundColor = "lightgreen";

            } else {
                DeltaShares.focus();
                const avshare = Number(AvShare.innerHTML);
                if (avshare <= 0) {
                    Message.innerHTML = ("You have no share!");
                    document.getElementById("PlaceOrder").disabled = true;
                }
                else {
                    Message.innerHTML = ('');
                    document.getElementById("PlaceOrder").disabled = false;
                }

                PlaceOrder.value = "Sell Shares";
                BuySell.innerHTML = "Sell";

                RadioOrder.style.backgroundColor = "pink";
                PlaceOrder.style.backgroundColor = "pink";
                AutoFill.style.backgroundColor = "pink";
                DeltaShares.style.backgroundColor = "pink";
                DeltaFund.style.backgroundColor = "pink";

            }

            if (LastChange.innerHTML == 'F') {
                DFund2All();
            } else {
                DShare2All();
            }
        }

        function AutoFill_Click() {

            Message.innerHTML = " ";
            const SelectedRadio = document.querySelector("input[name='RadioOrder']:checked").value;

            if (SelectedRadio == "Buy") {
                DeltaFund.value = (Number(AvFund.innerHTML)).toFixed(2);
                DFund2All();
            } else {
                DeltaShares.value = (Number(AvShare.innerHTML)).toFixed(3);
                DShare2All();
            }
        }

    </script>
    <script src="https://code.jquery.com/jquery-3.3.1.slim.min.js" integrity="sha384-q8i/X+965DzO0rT7abK41JStQIAqVgRVzpbzo5smXKp4YfRvH+8abtTE1Pi6jizo" crossorigin="anonymous"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js" integrity="sha384-UO2eT0CpHqdSJQ6hJty5KVphtPhzWj9WO1clHTMGa3JDZwrnQq4sF86dIHNDz0W1" crossorigin="anonymous"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js" integrity="sha384-JjSmVgyd0p3pXB1rRibZUAYoIIy6OrQ6VrjIEaFf/nJGzIxFDsf4x0xIM+B07jRM" crossorigin="anonymous"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/socket.io/2.3.0/socket.io.js" integrity="sha256-bQmrZe4yPnQrLTY+1gYylfNMBuGfnT/HKsCGX+9Xuqo=" crossorigin="anonymous"></script>
        <p>
            &nbsp;</p>

    </form>

    </body>
</html>
