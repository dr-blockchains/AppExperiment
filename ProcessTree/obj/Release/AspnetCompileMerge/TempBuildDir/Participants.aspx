<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Participants.aspx.cs" Inherits="ProcessTree.Participants" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>The Participants</title>
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
            width: 94%;
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

        .auto-style33 {
            text-align: left;
            font-size: large;
        }
                
        .auto-style36 {
            width: 76%;
            min-width: 200px;
        }
        
        </style>    
               
    <link href="StyleSheet.css" rel="stylesheet" type="text/css" />
</head>
<body >
    <form id="Participants" runat="server" class="auto-style36">
                  <table class="auto-style32">
            <tr>
                <td class="auto-style30">
                     <asp:Label ID="LabelLogin" runat="server" Class="login" Text="Error! Please contact the admin: Khaledi@Bus.MSU.edu" Font-Size="Large"></asp:Label>
                    </td>
                <td class="questions">
                                    <asp:Button ID="BtnReturn" runat="server" OnClick="BtnReturn_Click" Text="Return" TabIndex="9" />                       
                </td>     
            </tr>            
            <tr>
               
                <td class="auto-style33" colspan="2">
                    Participants who passed the test:</td>
            </tr>                    
              </table>   
        <table class="auto-style15">
            <tr>
                <td class="auto-style6">
            <asp:CheckBoxList ID="ListVersions" runat="server" DataSourceID="SqlDataSource4" DataTextField="Content" DataValueField="CreationTime" Width="92%" BackColor="#66FFFF" BorderColor="#6600CC" BorderStyle="Solid" AppendDataBoundItems="True" AutoPostBack="True" CellPadding="5" Font-Names="Times New Roman" Font-Size="Medium" RepeatColumns="1" DataMember="DefaultView" Enabled="False" CssClass="remove-checkbox"></asp:CheckBoxList>
                </td>
            </tr>
        </table>
        
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
    
                    <asp:SqlDataSource ID="SqlDataSource4" runat="server" 
                        ConnectionString="<%$ ConnectionStrings:ProcessTreeConnectionString %>" 
                        SelectCommand="SELECT '&lt;hr&gt;&lt;h4&gt;' + ID + ' : ' + Name + '&lt;/h4&gt;' +
'Passed @ ' + FORMAT([QualificationTime], 'HH:mm') + 
' ; Age = ' + CAST([Age] AS VARCHAR) + 
' ; Gender = ' + CASE 
             WHEN Gender = 0 THEN 'Male' 
             WHEN Gender = 1 THEN 'Female' 
             ELSE 'Unknown' END +
'&lt;br&gt;Language = ' + CASE WHEN  [EnglishSpeaker] = 1 THEN 'English' ELSE 'Other' END +
' ; Education = ' + [Education] +
' ; Balance = '  +  CAST([Balance] AS VARCHAR) + '&lt;br&gt;&lt;br&gt;' +
CASE WHEN [Score1] IS NULL THEN 'No Suvey Submission' ELSE 
'Response One : &lt;br&gt;' + REPLACE([Response1] , CHAR(13), '&lt;br&gt;') + '&lt;br&gt;' +
'&lt;br&gt; Response Two : &lt;br&gt;' + REPLACE([Response2] , CHAR(13), '&lt;br&gt;') + '&lt;br&gt;' +
'&lt;br&gt; Response Three : &lt;br&gt;' + REPLACE([Response3] , CHAR(13), '&lt;br&gt;') + '&lt;br&gt;&lt;br&gt;&lt;br&gt;' +
' Score1 = &lt;strong&gt;' + CAST([Score1] AS VARCHAR) + '&lt;/strong&gt;&amp;nbsp&amp;nbsp;&amp;nbsp&amp;nbsp' +' ;  Score2 = &lt;strong&gt;' + CAST([Score2] AS VARCHAR) + '&lt;/strong&gt;&amp;nbsp&amp;nbsp;&amp;nbsp&amp;nbsp' +' ; Score3 = &lt;strong&gt;' + CAST([Score3] AS VARCHAR) + '&lt;/strong&gt;&amp;nbsp&amp;nbsp;&amp;nbsp&amp;nbsp' +' ; Score4 = &lt;strong&gt;' + CAST([Score4] AS VARCHAR) + '&lt;/strong&gt;'
END + 
'&lt;br&gt;&lt;br&gt;Was_Voted_On = &lt;Strong&gt;' + CASE WHEN SUM(VersionVotes.Votes) IS NULL THEN 'None' ELSE CAST(SUM(VersionVotes.Votes) AS VARCHAR) END + '&lt;/strong&gt;&amp;nbsp&amp;nbsp;&amp;nbsp&amp;nbsp' +

-- ' ; Sum_Votes = &lt;Strong&gt;' + CASE WHEN SUM(VersionVotes.Weight) IS NULL THEN 'No Vote Weight' ELSE CAST (SUM(VersionVotes.Weight) AS VARCHAR) END + '&lt;/strong&gt;&amp;nbsp&amp;nbsp;&amp;nbsp&amp;nbsp' + 

' ; Submissions = &lt;Strong&gt;' + CASE WHEN SUM(VersionVotes.New) IS NULL THEN 'None' ELSE CAST(SUM(VersionVotes.New) AS VARCHAR) END + '&lt;/strong&gt;&amp;nbsp&amp;nbsp;&amp;nbsp&amp;nbsp' +
' ; Won Suggestions = &lt;Strong&gt;' + CASE WHEN SUM(VersionVotes.Won) IS NULL THEN 'None' ELSE CAST(SUM(VersionVotes.Won) AS VARCHAR) END + '&lt;/strong&gt;'
AS Content,
	
[CreationTime]
FROM People
LEFT JOIN (
       SELECT
              c.Treatment,
              c.Group#,
              c.Period,
              c.Choice,
              SUM(v.VoteWeight) AS Weight,
              COUNT(v.Choice) AS Votes,
              CASE WHEN c.Choice = 0 THEN 1 ELSE 0 END AS Won,
              CASE WHEN c.Choice = 0 THEN 0 ELSE 1 END AS New,
              c.Proposer
       FROM Versions c
       LEFT JOIN Voting v ON (
              c.Treatment = v.Treatment
              AND c.Group# = v.Group#
              AND c.Period = v.Period
              AND c.Choice = v.Choice
       )
       GROUP BY
              c.Treatment,
              c.Group#,
              c.Period,
              c.Choice,
              c.Proposer
) VersionVotes ON VersionVotes.Proposer = People.ID
WHERE People.Treatment = @Treatment AND People.Group# = @Group AND People.QualificationTime IS NOT NULL  AND CHARINDEX('WATCHER',People.ID) = 0
GROUP BY
       People.ID,
       People.Name,
       [CreationTime],
       [QualificationTime],
       [Education],
       [Age],
       [EnglishSpeaker],
       [Balance],
       [Gender],
       [Score1],
       [Score2],
       [Score3],
       [Score4],
       [Response1],
       [Response2],
       [Response3]
ORDER BY People.[CreationTime]">
                        <SelectParameters>
                            <asp:Parameter DefaultValue="0" Name="Treatment" />
                            <asp:Parameter DefaultValue="1" Name="Group" />
                        </SelectParameters>
                    </asp:SqlDataSource>
    
    </form>
    </body>
</html>
