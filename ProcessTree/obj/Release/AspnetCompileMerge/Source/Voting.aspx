<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Voting.aspx.cs" Inherits="ProcessTree.Voting" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Selection</title>
    <style type="text/css">

        .style2
        {
            
            text-align: left;
        }
        .auto-style13 {
            text-align: right;
            font-size: x-large;
        }
           
        .auto-style15 {
            
            height: 92px;
        }
        .style32
        {
            color: #003300;
            font-size: x-large;            
            font-family: Roman;
            text-align: center;
        }
        .auto-style20 {
            
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
        }

        .auto-style33 {
            text-align: left;
            height: 38px;
        }
        .auto-style34 {
            text-align: left;
            width: 480px;
        }

        </style>
    
    <script src="Timer.js"> </script>               
    <link href="StyleSheet.css" rel="stylesheet" type="text/css" />
</head>
<body >
    <form id="Voting" runat="server">
                  <table class="auto-style32">
            <tr>
                <td class="auto-style30">
                     <strong><span class="style32">
                        <asp:Label ID="LabelBalance" runat="server" Class="balance" Font-Bold="True"></asp:Label>
                        </span></strong>
                    </td>
                <td class="questions">
                                    <asp:Button ID="BtnHistory" runat="server" OnClick="BtnHistory_Click" Text="Versions History" TabIndex="9" />                       
                </td>     
            </tr>            
                          <tr>
                <td colspan="2">
                     <asp:Label ID="LabelLogin" runat="server" Class="login" Text="Error! Please contact the admin: Khaledi@Bus.MSU.edu" Font-Size="Large" ForeColor="Red" Width="100%"></asp:Label>
                              </td>
                 <asp:Label id="TimeSpan" runat="server" style="display: none"></asp:Label>   
            </tr>
           
            <tr>
                <td class="auto-style31">
                    <asp:Label ID="DeadLineMessage" runat="server" Font-Bold="True" Text="This voting poll closes at "></asp:Label>
                </td>
                <td id="DeadLine" class="time">
                    <script>
                         var TSpan = parseInt(document.getElementById("TimeSpan").textContent);
                         var ClientDeadLine = new Date((new Date()).getTime() + TSpan);
                         document.write(ClientDeadLine.toLocaleTimeString([], options));
                         CountDownTimer(ClientDeadLine, "Timer");
                    </script>
                </td>
            </tr>
            <tr>
               
                <td class="auto-style31">
                    <asp:Label ID="TimerMessage" runat="server" Font-Bold="True" Text="in about"></asp:Label>
                </td>
                <td id="Timer" class="time">

                </td>
            </tr>                    
            <tr>
               
                <td class="style2">
                    <strong><em>
                    <asp:Label ID="LabelSelect" runat="server" Font-Size="Large" Text="Select the best valid plan:"></asp:Label>
                    </em></strong>
                </td>
               
                <td class="questions">
    
                    <%--<a href="ChatRoom.aspx" target="_blank">Chat Room</a></td>--%>
                                  <asp:Label ID="ExtraVotes" runat="server" Class="balance" Font-Bold="False" Visible="False" Font-Size="Medium"></asp:Label>                                  
            </tr>                    
              </table>   
            <asp:CheckBoxList ID="ListVersions" runat="server" DataSourceID="SqlDataSource4" DataTextField="Expr1" DataValueField="Choice" Width="100%" Visible="False" BackColor="#FFEE88" BorderColor="#6600CC" BorderStyle="Solid" AppendDataBoundItems="True" AutoPostBack="True" CellPadding="5" Font-Names="Times New Roman" Font-Size="Medium" OnSelectedIndexChanged="ListVersions_SelectedIndexChanged" RepeatColumns="1" DataMember="DefaultView"></asp:CheckBoxList>
            <asp:RadioButtonList ID="RadioVersions" runat="server" AutoPostBack="True" DataSourceID="SqlDataSource4" DataTextField="Expr1" DataValueField="Choice" OnSelectedIndexChanged="RadioButtonList1_SelectedIndexChanged" TabIndex="1" AppendDataBoundItems="True" CellPadding="5" DataMember="DefaultView" EnableTheming="True" RepeatColumns="1" Width="100%" Font-Names="Times New Roman" Font-Size="Medium" BackColor="#FFEE88" BorderColor="#6600CC" BorderStyle="Solid"></asp:RadioButtonList>
        <table class="auto-style15">
            <tr>
                <td class="auto-style33" colspan="2">
                    <asp:Button ID="BtnSubmit" runat="server" Enabled="False" Font-Bold="True" onclick="BtnSubmitScore_Click" TabIndex="2" Text="Submit Vote" Width="140px" CssClass="auto-style21" Font-Size="Medium" />
                    &nbsp;
                    <asp:Label ID="Message" runat="server" Font-Bold="True" ForeColor="Red" CssClass="auto-style1" Font-Size="Medium" Height="28px" style="font-size: medium"></asp:Label>
                </td>
            </tr>
            <tr>
                <td class="auto-style34">
                      <strong><span class="auto-style13">
                    <br />
                    Instructions:</span></strong></td>
                <td class="questions">
                    <br />
                    <a href="/tips.aspx" target="_blank">Visual Directions </a></td>
            </tr>
        </table>
        
                  <p class="auto-style20">
                      <asp:Label ID="ConstitutionBox" runat="server" Text="Please refresh the page! (Database is not accessable now)" Width="96%" BackColor="#CCFFAA" BorderColor="#66FF66" BorderStyle="Solid" BorderWidth="10px" CssClass="justified" Font-Names="Georgia" Font-Size="Medium" TabIndex="1"></asp:Label>
                  </p>
                    <asp:SqlDataSource ID="SqlDataSource4" runat="server" 
                        ConnectionString="<%$ ConnectionStrings:ProcessTreeConnectionString %>" 
                        SelectCommand="SELECT '&lt;span class=&quot;version-choice&quot;&gt;' + 
  CASE WHEN Choice = 0 THEN 
                  (CASE WHEN Proposer = 'Experimenter' THEN 'Initial Edition' ELSE 'Current Updated Edition' END) 
  ELSE 'Suggestion ' + CAST(Choice AS VARCHAR(MAX)) 
  END + ':&lt;/span&gt;&lt;div class=&quot;version-artifact&quot;&gt;&lt;br&gt;' + REPLACE(HtmlArtifact, CHAR(13), '&lt;br&gt;') + '&lt;/div&gt;&lt;hr&gt;'   AS Expr1, 
Choice 
FROM Versions 
WHERE (Period = @Period) AND (Treatment = @Treatment) AND ([Group#] = @Group)  
ORDER BY Choice">
                        <SelectParameters>
                            <asp:Parameter DefaultValue="0" Name="Period" />
                            <asp:Parameter DefaultValue="0" Name="Treatment" Type="Int32" />
                            <asp:Parameter DefaultValue="1" Name="Group" />
                        </SelectParameters>
                    </asp:SqlDataSource>
    
                    <asp:Button ID="BtnSignOut" runat="server" OnClick="BtnSignOut_Click" Text="Sign Out" TabIndex="9" Visible="False"/>    
    
                  <br />
    
    </form>
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
</body>
</html>
