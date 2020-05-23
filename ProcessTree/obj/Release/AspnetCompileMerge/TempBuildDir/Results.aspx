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
        
        </style>
    <link href="StyleSheet.css" rel="stylesheet" type="text/css" />
</head>
<body >
    <form id="Results" runat="server">
                  <table class="auto-style32">
            <tr>
                <td class="auto-style30" colspan="2">
                     <asp:Label ID="LabelLogin" runat="server" Class="login" Text="Error! Please contact the admin: Khaledi@Bus.MSU.edu" Font-Size="Large" CssClass="auto-style34"></asp:Label>
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
                <td class="auto-style6">
            <asp:CheckBoxList ID="ListVersions" runat="server" DataSourceID="SqlDataSource4" DataTextField="Content" DataValueField="Choice" Width="100%" BackColor="#FFEE88" BorderColor="#6600CC" BorderStyle="Solid" AppendDataBoundItems="True" AutoPostBack="True" CellPadding="5" Font-Names="Times New Roman" Font-Size="Medium" RepeatColumns="1" DataMember="DefaultView" Enabled="False" CssClass="remove-checkbox"></asp:CheckBoxList>
                </td>
            </tr>
        </table>
                <asp:Label ID="CurrentPeriod" runat="server" style="display: none"></asp:Label>   
        
                    <asp:SqlDataSource ID="SqlDataSource4" runat="server" 
                        ConnectionString="<%$ ConnectionStrings:ProcessTreeConnectionString %>" 
                        SelectCommand="SELECT  '&lt;span class=&quot;version-choice&quot;&gt;&lt;h3&gt;' + 
CASE WHEN Versions.Choice = 0 THEN (CASE WHEN Versions.Proposer = 'Experimenter' THEN 'Initial Edition' ELSE 'Updated Edition' END) ELSE '&lt;hr&gt;&amp;nbsp; &amp;gt; &amp;nbsp;Suggestion ' + CAST(Versions.Choice AS VARCHAR(MAX)) END 
+ ' :  [ '+ Versions.Proposer + ' ]  @ [ '+FORMAT(Versions.Time , 'mm:ss') +' ]  :   Vote = '+CAST((CASE WHEN SumVotes IS NULL THEN 0 ELSE SumVotes END) AS VARCHAR(MAX))+
'&lt;/h3&gt;&lt;/span&gt;&lt;br&gt;&lt;div class=&quot;version-artifact&quot;&gt;' + REPLACE(Versions.HtmlArtifact, CHAR(13), '&lt;br&gt;') + '&lt;/div&gt;&lt;br&gt;' 
AS Content, 
Versions.Choice 					

FROM   (SELECT treatment, Group#, period, choice, sum(VoteWeight) AS SumVotes
        FROM Voting
        GROUP BY treatment, Group#, period, choice) AS VotesOnChoices 
RIGHT JOIN Versions ON
		           Versions.Treatment = VotesOnChoices.Treatment AND 
				   Versions.Group# = VotesOnChoices.Group# AND 
				   Versions.Period = VotesOnChoices.Period AND 
				   VotesOnChoices.Choice = Versions.Choice 

WHERE (Versions.Treatment = @Treatment) AND (Versions.[Group#] = @Group) and (Versions.[Period] = @Period)
ORDER BY Versions.Period DESC, CASE WHEN Versions.Choice = 0 THEN 1 ELSE 0 END DESC, SumVotes DESC, Versions.Time DESC">
                        <SelectParameters>
                            <asp:Parameter DefaultValue="0" Name="Treatment" Type="Int32" />
                            <asp:Parameter DefaultValue="1" Name="Group" />
                            <asp:Parameter DefaultValue="2" Name="Period" />
                        </SelectParameters>
                    </asp:SqlDataSource>
    
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
