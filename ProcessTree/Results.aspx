<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Results.aspx.cs" Inherits="ProcessTree.Results" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Version Results</title>
  
    <style type="text/css">

        .style2
        {
            
            text-align: left;
        }
        .auto-style6 {
            text-align: left;
        }
                   
        .auto-style15 {
            
            height: 22px;
        }
        .style32
        {
            color: #003300;
            font-size: x-large;            
            font-family: Roman;
            text-align: center;
        }
        .auto-style30 {
            width: 50%;
        }
        .auto-style32 {
                        
            height: 174px;
            line-height : 30px;
            margin: 0px auto;
        }

        .auto-style34 {
            color: #009933;
        }
        
        .auto-style35 {
            width: 349px;
        }
        .auto-style36 {
            width: 66px;
        }
        
        .auto-style37 {
            text-align: left;
            height: 73px;
        }
b,strong{font-weight:bolder}*,::after,::before{text-shadow:none!important;box-shadow:none!important}*,::after,::before{box-sizing:border-box}

        .auto-style3 {
            margin: 0px;
            overflow: auto;
            text-align: justify; 
            display: block;
            padding: 10px;
            border: 2px solid #6600CC;            
        }
   
        textarea{overflow:auto;resize:vertical}
        
        .auto-style38 {
            text-align: left;
            width: 532px;
        }
        
        .auto-style39 {
            text-align: center;
        }
        
        </style>
    <link href="StyleSheet.css" rel="stylesheet" type="text/css" />
</head>
<body >
    <form id="Results" runat="server">
                  <table class="auto-style32">
            <tr>
                <td class="auto-style30" colspan="2">
                     <asp:Label ID="LabelLogin" runat="server" Class="login" Text="Error! Please contact the admin: Law.Economist@Gmail.com" Font-Size="Large" CssClass="auto-style34"></asp:Label>
                    <asp:Label id="TimeSpan" runat="server" style="display: none"></asp:Label>   
                    </td>
                <td class="questions" colspan="2"> 
                                    <asp:Button ID="BtnReturn" runat="server" OnClick="BtnReturn_Click" Text="Return" TabIndex="9" />
                </td>
                </tr>       
            <tr>               
                <td class="auto-style35">
                    <asp:Button ID="Backward" runat="server" Text="&lt;&lt; Back" OnClick="Backward_Click" />
                </td>
                <td class="auto-style36">
                    Round:&nbsp;<asp:Label ID="LabelP" runat="server" Font-Bold="True" Font-Size="X-Large" ForeColor="#660033" Text="0"></asp:Label>
                </td>
                <td class="questions" >
                    <asp:Button ID="Forward" runat="server" Text="Forth &gt;&gt;" OnClick="Forward_Click" />
                </td>
            </tr>                    
              </table>   
        <table class="auto-style15">
            <tr>
                <td class="auto-style6" colspan="2">
            <asp:RadioButtonList ID="RadioVersions" runat="server" DataSourceID="SqlDataSource4" DataTextField="Content" DataValueField="Choice" TabIndex="1" AppendDataBoundItems="True" CellPadding="5" DataMember="DefaultView" EnableTheming="True" RepeatColumns="1" Width="100%" Font-Names="Times New Roman" Font-Size="Medium" BackColor="#FFEE88" BorderColor="#6600CC" BorderStyle="Solid" AutoPostBack="True" OnSelectedIndexChanged="RadioVersions_SelectedIndexChanged"></asp:RadioButtonList>
            &nbsp;&nbsp;
                </td>
            </tr>
            <tr>
                <td class="auto-style37">
                    <strong>
                    <asp:Button ID="AddBtn" runat="server" OnClick="AddBtn_Click" Text="Add" Font-Bold="True" />
                    </strong>&nbsp;
                    <asp:Button ID="DeleteBtn" runat="server" Text="Delete" Font-Bold="True" OnClick="DeleteBtn_Click" />
&nbsp;
                    <strong>
                    <asp:Button ID="EditBtn" runat="server" OnClick="EditBtn_Click" Text="Edit" Font-Bold="True" />
                    </strong>&nbsp;
                    <asp:Label ID="Message" runat="server" Font-Bold="True" ForeColor="Red" CssClass="auto-style1" Font-Size="Medium" Height="28px" style="font-size: medium"></asp:Label>
                    <br />
                </td>
                <td class="auto-style37">
    
                                PerVal = <asp:TextBox ID="Performance" runat="server" required pattern ="[0-9]*\.?[0-9]+" TabIndex="280" BackColor="Lime" Width="154px" Font-Bold="True">0</asp:TextBox>

                </td>
            </tr>
            <tr>
                <td class="auto-style6" colspan="2">
            <asp:TextBox ID="txtArtifact" runat="server" BackColor="#FFEE88" MinLines="5" MaxLines="50" Height="300px" style="direction: ltr" TextMode="MultiLine" TabIndex="1" CssClass="auto-style3" Font-Names="Times New Roman" Font-Size="Large" MaxLength="2000" Width="97%" Enabled="False">Click on Edit to see the version here.</asp:TextBox>
                                                          
                </td>
            </tr>
            <tr>
                <td class="auto-style38">
    
                                <asp:Button ID="BtnSubmit" runat="server" Font-Bold="True" onclick="BtnSubmit_Click" TabIndex="3" Text="Submit New Edition" AccessKey="s" Enabled="False"/>
                </td>
                <td class="auto-style6">
    
                                <a href="ChatRoom.aspx" target="_blank">Open Chat Room</a></td>
            </tr>
            <tr>
                <td class="auto-style39" colspan="2">
    
                                <br />
    
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
                    
                                <br />
                </td>
            </tr>
        </table>
                <asp:Label ID="CurrentPeriod" runat="server" style="display: none"></asp:Label>   
        
                    <asp:SqlDataSource ID="SqlDataSource4" runat="server" 
                        ConnectionString="<%$ ConnectionStrings:ProcessTreeConnectionString %>" 
                        SelectCommand="SELECT '&lt;span class=&quot;version-choice&quot;&gt;' + CASE WHEN Versions.Choice = 0 THEN 'Hold Cash' ELSE 'Portfolio ' + CAST(Versions.Choice AS VARCHAR(MAX)) END + 
' &amp;nbsp&amp;nbsp [ ' + CAST(PerVal AS VARCHAR(MAX)) + ' ] | ( ' +
CASE WHEN Score = 0 THEN 'No Transaction' ELSE 'The Last Transaction Price = ' + CAST(Score AS VARCHAR(MAX)) END +  ' , ' + 
(SELECT COALESCE('Lowest Sell Offer = $ ' + CAST(MIN(Price) AS VARCHAR(MAX)), 'No Sell Offer') FROM Offers 
    WHERE (Treatment = @Treatment) AND ([Group#] = @Group)  AND (Period = @Period) AND Choice = Versions.Choice AND UnFullfilled &gt; 0 AND Buy0Sell1 = 1) + ' , ' +
(SELECT COALESCE('Highest Buy Offer = $ ' + CAST(MAX(Price) AS VARCHAR(MAX)), 'No Buy Offer') FROM Offers 
    WHERE (Treatment = @Treatment) AND ([Group#] = @Group)  AND (Period = @Period) AND Choice = Versions.Choice AND UnFullfilled &gt; 0 AND Buy0Sell1 = 0) +
-- ' )  |  ( Vote = ' + CAST ( COALESCE(SumVotes,0) AS VARCHAR(MAX) ) 
+ ' ) : &lt;/span&gt;&lt;br&gt;&lt;br&gt;&lt;div class=&quot;version-artifact&quot;&gt;' + 
REPLACE(Versions.HtmlArtifact, CHAR(13), '&lt;br&gt;') + 
'&lt;/div&gt;&lt;hr&gt;' 
AS Content, 
Versions.Choice 					
FROM   (SELECT treatment, Group#, period, choice, sum(VoteWeight) AS SumVotes
        FROM Voting
        GROUP BY treatment, Group#, period, choice) AS VotesOnChoices 
RIGHT JOIN Versions ON   Versions.Treatment = VotesOnChoices.Treatment 
                                  AND Versions.Group# = VotesOnChoices.Group# 
                                  AND Versions.Period = VotesOnChoices.Period 
                                  AND VotesOnChoices.Choice = Versions.Choice 
WHERE (Versions.Treatment = @Treatment) AND (Versions.[Group#] = @Group) and (Versions.[Period] = @Period)
ORDER BY 
CASE WHEN Versions.Choice = 0 THEN 1 ELSE 0 END DESC, 
Choice ASC">
                        <SelectParameters>
                            <asp:Parameter DefaultValue="0" Name="Treatment" Type="Int32" />
                            <asp:Parameter DefaultValue="1" Name="Group" />
                            <asp:Parameter DefaultValue="2" Name="Period" />
                        </SelectParameters>
                    </asp:SqlDataSource>
    
                  <br />
    
                   <a href="./tips.aspx" target="_blank"><strong>Visual Directions </strong></a>
    
                  <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:ProcessTreeConnectionString %>" SelectCommand="SELECT Price, CASE WHEN Sell_Time &gt; Buy_Time THEN Sell_Time ELSE Buy_Time END AS TranTime
FROM Transactions 
WHERE (Treatment = @Treatment) AND ([Group#] = @Group) AND (Period = @Period) AND (Choice = @Choice)
 --OR Choice = 0 AND Vol = 0) 
ORDER BY TranID">
                      <SelectParameters>
                          <asp:Parameter DefaultValue="0" Name="Treatment" />
                          <asp:Parameter DefaultValue="1" Name="Group" />
                          <asp:Parameter DefaultValue="2" Name="Period" />
                          <asp:ControlParameter ControlID="RadioVersions" DefaultValue="0" Name="Choice" PropertyName="SelectedValue" />
                      </SelectParameters>
                  </asp:SqlDataSource>
    
                  </a>
    
    </form>
</body>
</html>
