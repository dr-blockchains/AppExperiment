
<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ControlPanel.aspx.cs" Inherits="ProcessTree.ControlPanel" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Control Panel</title>
    <style type="text/css">

        .auto-style1 {
            width: 47%;
        }

        .auto-style3 {
            height: 25px;
            text-align: right;
        }

        .auto-style5 {
            height: 52px;            
        }
        .auto-style6 {
            width: 47%;
            height: 10px;
            text-align: left;
        }
        
        .auto-style8 {
            width: 47%;
            text-align: left;
        }
        .auto-style12 {
            text-align: right;
            height: 27px;
        }
        .auto-style14 {
            text-align: right;
            height: 30px;
        }
        .auto-style15 {
            width: 47%;
            height: 30px;
        }

        .auto-style16 {
            font-weight: bold;
        }

        .auto-style17 {
            width: 47%;
            font-size: large;
        }

        .auto-style18 {
            font-size: small;
        }

        .auto-style19 {
            text-align: right;
            height: 10px;
        }
        .auto-style22 {
            height: 25px;
            text-align: right;
            width: 203px;
        }

        .auto-style23 {
            text-align: left;
        }

        .auto-style24 {
            text-align: right;
            width: 203px;
        }

        </style>
    <link href="StyleSheet.css" rel="stylesheet" type="text/css" />    
</head>
<body>
    <form id="ControlPanel" runat="server">
        <table>
            <tr>
                <td class="auto-style1">

                    <span><strong aria-atomic="False" aria-busy="False" aria-dropeffect="none" aria-expanded="false" aria-grabbed="undefined" aria-multiline="False">
                                <asp:Button ID="BtnSave" runat="server" Font-Bold="True" onclick="BtnSave_Click" Text="Save Changes" Width="109px" AccessKey="s" />
                    &nbsp;
                    &nbsp;<asp:Button ID="BtnActivate" runat="server" OnClick="BtnActivate_Click" Text="Save &amp; Activate" Width="110px" TabIndex="10" CausesValidation="False" />
                    &nbsp;&nbsp;
                    <asp:Button ID="BtnCreate" runat="server" OnClick="BtnCreate_Click" Text="Create Next" Width="85px" TabIndex="20" CausesValidation="False" />
                    </strong>
                </td>
                <td colspan="3" class="auto-style23">

                    <span><strong>Treatment# : </strong><em><strong>
                    <asp:DropDownList ID="Treat" runat="server" DataSourceID="SqlDataSource1" DataTextField="TID" DataValueField="TID" AutoPostBack="True" OnSelectedIndexChanged="DropNumbers_SelectedIndexChanged" BackColor="Aqua" TabIndex="40" Font-Bold="True" Font-Italic="False" Height="20px" Width="50px">
                    </asp:DropDownList>
                    &nbsp;</strong><span class="auto-style18">P </span> <asp:Label ID="Parent" runat="server" BorderStyle="None" BorderWidth="1px" CssClass="auto-style48" Font-Italic="False" style="font-size: small">0</asp:Label>
                
                    </em></td>                
                <td class="questions">

                    <span><strong aria-atomic="False" aria-busy="False" aria-dropeffect="none" aria-expanded="false" aria-grabbed="undefined" aria-multiline="False">
                    <em>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    </em>&nbsp;<asp:Button ID="Back" runat="server" OnClick="Back_Click" Text="Exit" TabIndex="30" CausesValidation="False" />
                    </strong>
                            
                    </td>                
            </tr>
             <tr>
                <td class="auto-style1">

                    <span><strong aria-atomic="False" aria-busy="False" aria-dropeffect="none" aria-expanded="false" aria-grabbed="undefined" aria-multiline="False">
                    <asp:Label ID="Message" runat="server" Font-Italic="True" Font-Size="Medium" ForeColor="Red">Please Contact the Admin: Khaledi@Bus.MSU.edu</asp:Label>
                
                    </strong>
                            
                    </td>
                <td colspan="4" class="questions">

                    <span><strong aria-atomic="False" aria-busy="False" aria-dropeffect="none" aria-expanded="false" aria-grabbed="undefined" aria-multiline="False">

                    &nbsp;</strong>Maximum Subjects per Group <strong aria-atomic="False" aria-busy="False" aria-dropeffect="none" aria-expanded="false" aria-grabbed="undefined" aria-multiline="False">
                    = <asp:TextBox ID="PerGroup" runat="server" TextMode="Number" BackColor="Fuchsia" Width="40px" TabIndex="50">50</asp:TextBox>
                    
                    </strong>
                
                 </td>
            </tr>
             <tr>
                <td class="auto-style15">

                    <span class="auto-style18">

                    <em>

                    <span>
                    <asp:CheckBox ID="PvH" runat="server" Text="People" TabIndex="270" TextAlign="Left" BackColor="White" />
                
                    </span> 
                    </em>

                    </span>

                    </td>
                <td colspan="4" class="auto-style14">

                    <span><asp:Button ID="DownAll" runat="server" BackColor="Fuchsia" BorderWidth="0px" Font-Overline="False" Height="20px" OnClick="DownAll_Click" Text="Delete All" BorderStyle="None" TabIndex="60" Enabled="False" Visible="False" />
                    &nbsp;<asp:Button ID="Down" runat="server" BackColor="Fuchsia" BorderWidth="0px" Font-Overline="False" Height="20px" OnClick="Down_Click" Text="-" BorderStyle="None" Width="20px" TabIndex="70" />
&nbsp;<asp:Button ID="Up" runat="server" BackColor="Fuchsia" BorderWidth="0px" Font-Overline="False" Height="20px" OnClick="Up_Click" Text="+" BorderStyle="None" Width="20px" TabIndex="80" />
&nbsp;Groups =
                    <strong>
                    <asp:TextBox ID="Groups" runat="server" TextMode="Number" BackColor="Fuchsia" Width="40px" TabIndex="90" ReadOnly="True" CssClass="auto-style16">1</asp:TextBox>
                
                    </strong>
                
                 </td>
            </tr>
             <tr>
                <td class="auto-style5" colspan="5" style="font-size: medium">

                    <span>
                    <asp:GridView ID="GroupList" runat="server" AllowSorting="True" AutoGenerateColumns="False" BackColor="LightGoldenrodYellow" BorderColor="Tan" BorderWidth="1px" CellPadding="2" DataSourceID="SqlDataSource3" ForeColor="Black" GridLines="None" Font-Size="Small" TabIndex="400" AllowPaging="True" DataKeyNames="Treatment,Group" PageSize="20" OnSelectedIndexChanged="GroupList_SelectedIndexChanged">
                        <AlternatingRowStyle BackColor="PaleGoldenrod" />
                        <Columns>
                            <asp:CommandField ShowEditButton="True" ShowSelectButton="True" >
                            <HeaderStyle Width="30px" />
                            <ItemStyle Width="10px" />
                            </asp:CommandField>
                            <asp:BoundField DataField="Group" HeaderText="Group" SortExpression="Group" ReadOnly="True" >
                            <HeaderStyle HorizontalAlign="Center" Width="30px" />
                            <ItemStyle HorizontalAlign="Center" />
                            </asp:BoundField>
                            <asp:BoundField DataField="Period" HeaderText="Period" SortExpression="Period" ReadOnly="True" NullDisplayText="Null" >
                            <HeaderStyle HorizontalAlign="Center" Width="50px" />
                            <ItemStyle HorizontalAlign="Center" />
                            </asp:BoundField>
                            <asp:BoundField DataField="Treatment" HeaderText="Treatment" ReadOnly="True" SortExpression="Treatment" Visible="False" />
                            <asp:BoundField DataField="DT" HeaderText="DT" SortExpression="DT" DataFormatString="{0:MMM d, h:mm tt}" ReadOnly="True" >
                            <HeaderStyle HorizontalAlign="Center" />
                            <ItemStyle HorizontalAlign="Center" />
                            </asp:BoundField>
                            <asp:BoundField DataField="Starting" HeaderText="Starting" SortExpression="Starting" DataFormatString="{0:MMM d, h:mm tt}" >
                            <HeaderStyle HorizontalAlign="Center" />
                            <ItemStyle HorizontalAlign="Center" />
                            </asp:BoundField>
                            <asp:BoundField DataField="DeadLine" HeaderText="DeadLine" ReadOnly="True" SortExpression="DeadLine" DataFormatString="{0:MMM d, h:mm tt}" >
                            <HeaderStyle HorizontalAlign="Center" />
                            <ItemStyle HorizontalAlign="Center" />
                            </asp:BoundField>
                            <asp:BoundField DataField="Closing" HeaderText="Closing" ReadOnly="True" SortExpression="Closing" DataFormatString="{0:MMM d, h:mm tt}" >
                            <HeaderStyle HorizontalAlign="Center" />
                            <ItemStyle HorizontalAlign="Center" />
                            </asp:BoundField>
                            <asp:BoundField DataField="Ending" HeaderText="Ending" ReadOnly="True" SortExpression="Ending" DataFormatString="{0:MMM d, h:mm tt}" >
                            <HeaderStyle HorizontalAlign="Center" />
                            <ItemStyle HorizontalAlign="Center" />
                            </asp:BoundField>
                            <asp:BoundField DataField="Subjects" HeaderText="Subjects" ReadOnly="True" SortExpression="Subjects" >
                            <HeaderStyle HorizontalAlign="Center" />
                            <ItemStyle HorizontalAlign="Center" />
                            </asp:BoundField>
                        </Columns>
                        <EmptyDataTemplate>
                            &nbsp;
                        </EmptyDataTemplate>
                        <FooterStyle BackColor="Tan" />
                        <HeaderStyle BackColor="Tan" Font-Bold="True" />
                        <PagerStyle BackColor="PaleGoldenrod" ForeColor="DarkSlateBlue" HorizontalAlign="Center" />
                        <SelectedRowStyle BackColor="DarkSlateBlue" ForeColor="GhostWhite" />
                        <SortedAscendingCellStyle BackColor="#FAFAE7" />
                        <SortedAscendingHeaderStyle BackColor="#DAC09E" />
                        <SortedDescendingCellStyle BackColor="#E1DB9C" />
                        <SortedDescendingHeaderStyle BackColor="#C2A47B" />
                    </asp:GridView>
                            
                </td>
            </tr>
             <tr>
                <td class="auto-style6">

                    &nbsp;</td>
                <td colspan="4" class="auto-style19">

                    </td>
            </tr>
             <tr>
                <td class="auto-style8">

                    Tp =
                    <asp:TextBox ID="Tp" runat="server" BackColor="Yellow" Width="50px" OnTextChanged="Tp_TextChanged" TabIndex="110" required pattern ="[0-9]*\.?[0-9]+">12</asp:TextBox>
                            &nbsp;mins</td>
                <td colspan="4" class="questions">

                    Ta =
                    (DeadLine - Starting) =
                    <asp:TextBox ID="Ta" runat="server" BackColor="Yellow" Width="50px" OnTextChanged="Ta_TextChanged" AutoPostBack="True" TabIndex="150" required pattern ="[0-9]*\.?[0-9]+">0</asp:TextBox>
                &nbsp;mins</td>
            </tr>
             <tr>
                <td class="auto-style8">

                   Tv =
                    <asp:TextBox ID="Tv" runat="server" BackColor="Yellow" Width="50px" OnTextChanged="Tv_TextChanged" TabIndex="120" required pattern ="[0-9]*\.?[0-9]+">24</asp:TextBox>
                &nbsp;mins</td>
                <td colspan="4" class="questions">

                    Tz = (Closing - Starting) =
                    <asp:TextBox ID="Tz" runat="server" required pattern ="[0-9]*\.?[0-9]+" Width="50px" TabIndex="160" BackColor="Yellow" OnTextChanged="Tz_TextChanged" AutoPostBack="True">0</asp:TextBox>
                    &nbsp;mins</td>
            </tr>
             <tr>
                <td class="auto-style8">

                    Te =
                    <asp:TextBox ID="Te" runat="server" required pattern ="[0-9]*\.?[0-9]+" Width="50px" TabIndex="130" BackColor="Yellow">0</asp:TextBox>
                            &nbsp;mins</td>
                <td colspan="4" class="questions">

                    Tf = (Ending - Closing) =
                    <asp:TextBox ID="Tf" runat="server" required pattern ="[0-9]*\.?[0-9]+" BackColor="Yellow" OnTextChanged="Tf_TextChanged" AutoPostBack="True" Width="50px" TabIndex="170">0</asp:TextBox>
                    &nbsp;mins</td>
            </tr>
             <tr>
                <td class="auto-style8">

                    E&nbsp;&nbsp; =
                    <asp:TextBox ID="E" runat="server" required pattern ="[0-9]*\.?[0-9]+" Width="50px" TabIndex="140" BackColor="#CCCCCC" Enabled="False">0</asp:TextBox>
                    &nbsp;%&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 
                
                </td>
                <td colspan="4" class="questions">

            Span = (Ending - Starting) =
                    <asp:TextBox ID="Span" runat="server" required pattern ="[0-9]*\.?[0-9]+" BackColor="White" AutoPostBack="True" Width="50px" TabIndex="180" ReadOnly="True" Font-Bold="True" Font-Italic="False">0</asp:TextBox>
                    &nbsp;mins</td>
            </tr>
             <tr>
                <td class="auto-style1">

                </td>
                <td colspan="4" class="questions">

                    &nbsp;</td>
            </tr>
             <tr>
                <td class="auto-style1">

                    <strong>Meritocracy Schemes:</strong></td>
                <td colspan="2" class="questions">

                    

            <span>
                    <asp:CheckBox ID="VoteChange" runat="server" Text="Vote Revisable" TabIndex="240" Font-Bold="False" TextAlign="Left" />
                
                  </td>
                <td colspan="2" class="questions">

                    

                <strong>

                    M =&nbsp;
                    <asp:TextBox ID="M" runat="server" BackColor="Aqua" Width="40px" TabIndex="190" required pattern ="[0-9]+">1</asp:TextBox>
                    &nbsp;<span class="auto-style45">Suggestions</span></strong></td>
            </tr>
             <tr>
                <td class="auto-style15">

                    <span>W =
                    <asp:TextBox ID="W" runat="server" Width="40px" TabIndex="200" BackColor="#FF9900" OnTextChanged="W_TextChanged" AutoPostBack="True">0</asp:TextBox>
                &nbsp;votes</td>
                <td class="auto-style24">

                    <span>
                    <asp:CheckBox ID="MultiChoice" runat="server" Text="Approval Voting" TabIndex="270" TextAlign="Left" />
                
                  </td>
                <td class="auto-style14" colspan="3">

                    MR<strong> =&nbsp;
                    <asp:TextBox ID="MR" runat="server" BackColor="Aqua" Width="40px" TabIndex="190" required pattern ="[0-9]+" Enabled="False">1</asp:TextBox>
                    &nbsp;</strong><span class="auto-style45">Prizes&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span></td>
            </tr>
             <tr>
                <td class="auto-style1">

                    <span>V&nbsp; =
                    <asp:TextBox ID="V" runat="server" Width="40px" TabIndex="210" BackColor="#FF9900">0</asp:TextBox>
                &nbsp;votes</td>
                <td class="auto-style24">

                    <span>
                    <asp:CheckBox ID="MV" runat="server" Text="(m - v) . R" TabIndex="270" TextAlign="Left" BackColor="Lime" />
                
                  </td>
                <td class="questions" colspan="3">

                    Reward =
                    <asp:TextBox ID="Reward" runat="server" required pattern ="[0-9]*\.?[0-9]+" TabIndex="300" BackColor="Lime" Width="40px">0</asp:TextBox>
                    $</td>
            </tr>
             <tr>
                <td class="auto-style1" rowspan="3">                    

                    <asp:RadioButtonList ID="RadioMeritocracy" runat="server" BackColor="#FF9900" Width="163px" AutoPostBack="True" BorderColor="#CC3300" BorderStyle="Solid" RepeatLayout="Flow" TabIndex="220">
                        <asp:ListItem Value="0">Only Constant V</asp:ListItem>
                        <asp:ListItem Value="1">Raw Vote(i)</asp:ListItem>
<asp:ListItem Value="2">Vote(i) - Vote(0)</asp:ListItem>
                        <asp:ListItem Value="3">Vote(i) - MinVote</asp:ListItem>
                    </asp:RadioButtonList>
                
                 </td>
                <td class="auto-style24">

                    &nbsp;</td>
                <td class="questions" colspan="3">

          Rv =
                    <asp:TextBox ID="Rv" runat="server" TabIndex="310" BackColor="Lime" Width="40px" required pattern ="[0-9]*\.?[0-9]+">0</asp:TextBox>
                    $</td>
            </tr>
             <tr>
                <td class="auto-style12" colspan="2">

                    &nbsp;</td>
                <td class="auto-style12" colspan="2">

            Ro =
                    <asp:TextBox ID="Ro" runat="server" required pattern ="[0-9]*\.?[0-9]+" TabIndex="320" BackColor="Lime" Width="40px">0</asp:TextBox>
                    $</td>
            </tr>
              <tr>
                <td class="questions" colspan="2">

                    <span>
                    <asp:CheckBox ID="MultiStage" runat="server" Text="Multiple Stages" TabIndex="250" TextAlign="Left" Enabled="False" />
                
                  </td>
                <td class="questions" colspan="2">

                    Base Pay&nbsp;= 
                    <asp:TextBox ID="Compensation" runat="server" BackColor="Lime" TabIndex="290" Width="40px" required pattern ="[0-9]*\.?[0-9]+">0</asp:TextBox>
                    $</td>
            </tr>
              <tr>
                <td class="auto-style1" rowspan="2">

                    <span>
                    <asp:RadioButtonList ID="RadioMerit2All" runat="server" BackColor="#FF9900" Width="162px" AutoPostBack="True" BorderColor="#CC3300" BorderStyle="Solid" RepeatLayout="Flow" TabIndex="230">
                        <asp:ListItem Value="0">Only to Winner</asp:ListItem>
                        <asp:ListItem Value="1">To all Proposers</asp:ListItem>
                    </asp:RadioButtonList>
                
                 </td>
                <td class="auto-style22">

                    <span>
                    <asp:CheckBox ID="Proxy" runat="server" Text="Proxy Voting" TabIndex="260" TextAlign="Left" Enabled="False" />
                
                  </td>
                <td class="auto-style3" colspan="3">

                    &nbsp;</td>
            </tr>
              <tr>
                <td class="auto-style24">

                    <span>
                    <asp:CheckBox ID="Valuation" runat="server" Text="Valuation Scoring" TabIndex="260" TextAlign="Left" EnableTheming="False" Enabled="False" />
                
                  </td>
                <td class="questions" colspan="3">

                    Suggestion Fee =
                    <asp:TextBox ID="SuggestionFee" runat="server" required pattern ="[0-9]*\.?[0-9]+" TabIndex="300" BackColor="Lime" Width="40px">0</asp:TextBox>
                    $</td>
            </tr>
              <tr>
                <td class="auto-style1">

                    &nbsp;</td>
                <td class="auto-style24">

                    <span>
                    <asp:CheckBox ID="AuctionSort" runat="server" Text="Auction for Sorting" TabIndex="260" TextAlign="Left" BackColor="Lime" Enabled="False" />
                
                  </td>
                <td class="questions" colspan="3">

          Voting Fee =&nbsp;<asp:TextBox ID="BetFee" runat="server" required pattern ="[0-9]*\.?[0-9]+" TabIndex="280" BackColor="Lime" Width="40px">0</asp:TextBox>
                    $</td>
            </tr>
              <tr>
                <td class="auto-style17">

            <strong>Constitution:</strong></td>
                <td colspan="4">

                    &nbsp;</td>
            </tr>
              <tr>
                <td colspan="5">

            
                    <asp:TextBox ID="Constitution"  runat="server" BackColor="#CCFFAA" Height="272px" TextMode="MultiLine" Width="100%" TabIndex="330" Font-Names="Times New Roman" Font-Size="Medium" CssClass="justified">No Constitution!</asp:TextBox>
                
                </td>
            </tr>
              <tr>
                <td class="auto-style1">

                </td>
                <td colspan="4">

                </td>
            </tr>
              <tr>
                <td class="auto-style1">

            <strong>Hypothesis:</strong></td>
                <td colspan="4">

                </td>
            </tr>
              <tr>
                <td colspan="5">
            
                    <asp:TextBox ID="Hypothesis" runat="server" Height="60px" TextMode="MultiLine" Width="100%" BackColor="#FF66FF" TabIndex="340" Font-Names="Times New Roman" Font-Size="Medium" CssClass="justified">No Hypothesis!</asp:TextBox>
                
                </td>
            </tr>
              <tr>
                <td class="auto-style1">

                </td>
                <td colspan="4">

                </td>
            </tr>
              <tr>
                <td class="auto-style1">

                    <strong>Initial Edition:</strong></td>
                <td colspan="4">

                </td>
            </tr>
              <tr>
                <td colspan="5">
                                
        <asp:TextBox ID="Artifact" runat="server" BackColor="#FFEE88" Height="169px"  style="direction: ltr" TextMode="MultiLine" Width="100%" AutoPostBack="True" TabIndex="350" Font-Names="Times New Roman" Font-Size="Medium" CssClass="justified">No Artifact!</asp:TextBox>
                
                </td>
            </tr>
              <tr>
                <td class="auto-style1">

                </td>
                <td colspan="4">

                </td>
            </tr>
              

        </table>    
                    <div dir="ltr" style="position: relative; z-index: auto; width: 100%; left: auto; right: auto; text-align: center; table-layout: auto;">
                    <asp:GridView ID="Participants" runat="server" AllowSorting="True" DataSourceID="SqlDataSource2" AutoGenerateColumns="False" DataKeyNames="ID" Visible="False" TabIndex="360" CellPadding="2" ForeColor="Black" GridLines="None" BackColor="LightGoldenrodYellow" BorderColor="Tan" BorderWidth="1px" CssClass="auto-style18" AllowPaging="True" Font-Size="Small" PageSize="50" >
                        <AlternatingRowStyle BackColor="PaleGoldenrod" />
                        <Columns>
                            <asp:CommandField ShowEditButton="True" />
                            <asp:BoundField DataField="ID" HeaderText="ID" ReadOnly="True" SortExpression="ID" >
                            </asp:BoundField>
                            <asp:BoundField DataField="CreationTime" DataFormatString="{0:MMM d, h:mm tt}" HeaderText="Creation Time" ReadOnly="True" SortExpression="CreationTime" />
                            <asp:BoundField DataField="Group#" HeaderText="Group#" SortExpression="Group#" />
                            <asp:BoundField DataField="QualificationTime" DataFormatString="{0:MMM d, h:mm tt}" HeaderText="QualificationTime" ReadOnly="True" SortExpression="QualificationTime" />
                            <asp:BoundField DataField="Balance" HeaderText="Balance" SortExpression="Balance" >
                            </asp:BoundField>
<asp:BoundField DataField="ExtraVote" HeaderText="ExtraVote" SortExpression="ExtraVote">
                            </asp:BoundField>
                            <asp:BoundField DataField="Suspended" HeaderText="Suspended" SortExpression="Suspended" DataFormatString="{0:MMM d, h:mm tt}" >
                            </asp:BoundField>
                            <asp:BoundField DataField="Completed" DataFormatString="{0:MMM d, h:mm tt}" HeaderText="Completed" SortExpression="Completed" />
                        </Columns>
                        <FooterStyle BackColor="Tan" />
                        <HeaderStyle BackColor="Tan" Font-Bold="True" />
                        <PagerStyle BackColor="PaleGoldenrod" ForeColor="DarkSlateBlue" HorizontalAlign="Center" />
                        <SelectedRowStyle BackColor="DarkSlateBlue" ForeColor="GhostWhite" />
                        <SortedAscendingCellStyle BackColor="#FAFAE7" />
                        <SortedAscendingHeaderStyle BackColor="#DAC09E" />
                        <SortedDescendingCellStyle BackColor="#E1DB9C" />
                        <SortedDescendingHeaderStyle BackColor="#C2A47B" />
                    </asp:GridView>
                </div>

                <strong>
                                <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:ProcessTreeConnectionString %>" SelectCommand="SELECT [TID], [Parent] FROM [Treatments]">
                    </asp:SqlDataSource>
                                
                    <asp:SqlDataSource ID="SqlDataSource2" runat="server" ConnectionString="<%$ ConnectionStrings:ProcessTreeConnectionString %>" SelectCommand="SELECT ID, CreationTime, QualificationTime, Treatment, [Group#], Balance, ExtraVote, Suspended, Completed FROM People WHERE (ID &lt;&gt; @ID) AND (Treatment = @Treatment) ORDER BY [Group#] ASC, CreationTime DESC" OldValuesParameterFormatString="original_{0}" UpdateCommand="UPDATE People 
SET Suspended = @Suspended, Balance = @Balance, ExtraVote = @ExtraVote, Completed = @Completed, Group# = @Group#
WHERE ID = @original_ID">
                        <SelectParameters>
                            <asp:Parameter DefaultValue="Experimenter" Name="ID" />
                            <asp:ControlParameter ControlID="Treat" DefaultValue="0" Name="Treatment" PropertyName="SelectedValue" />
                        </SelectParameters>
                        <UpdateParameters>
                            <asp:Parameter Name="Suspended" />                            
                            <asp:Parameter Name="Balance" />
                            <asp:Parameter Name="ExtraVote" />
                            <asp:Parameter Name="Completed" />
                            <asp:Parameter Name="Group#" />
                            <asp:Parameter Name="original_ID" />
                        </UpdateParameters>
                    </asp:SqlDataSource>
        <asp:SqlDataSource ID="SqlDataSource3" runat="server" ConnectionString="<%$ ConnectionStrings:ProcessTreeConnectionString %>" SelectCommand="SELECT
       Groups.Treatment,
       Groups.Group# AS [Group],
       Groups.Period,
       Groups.DT,
       Groups.Starting,
       DATEADD(minute, CAST(@Ta AS real) , Groups.Starting) AS DeadLine,
       DATEADD(minute, CAST(@Tz AS real) , Groups.Starting) AS Closing,
       DATEADD(minute, CAST(@Span AS real) , Groups.Starting) AS Ending,
       PeopleInGroup.[count] AS Subjects
FROM Groups
LEFT JOIN (
       SELECT
              COUNT(people.ID) AS [count],
              people.Treatment,
              people.Group#
       FROM people
       WHERE People.QualificationTime IS NOT NULL
       GROUP BY people.Treatment, people.Group#
) AS PeopleInGroup
       ON PeopleInGroup.Treatment = Groups.Treatment AND PeopleInGroup.Group# = Groups.Group#
 WHERE (Groups.[Treatment] = @Treatment) ORDER BY Groups.[Group#]" UpdateCommand="UPDATE Groups SET [Starting] = @Starting, [DT] = CASE WHEN [Period] IS NULL OR [Period] = 0 THEN @Starting ELSE [DT] END WHERE ([Treatment] = @Treatment AND [Group#] = @Group)">
            <SelectParameters>
                <asp:ControlParameter ControlID="Ta" DefaultValue="0" Name="Ta" PropertyName="Text" />
                <asp:ControlParameter ControlID="Tz" DefaultValue="0" Name="Tz" PropertyName="Text" />
                <asp:ControlParameter ControlID="Span" DefaultValue="0" Name="Span" PropertyName="Text" />
                <asp:ControlParameter ControlID="Treat" DefaultValue="0" Name="Treatment" PropertyName="SelectedValue" Type="Int32" />
            </SelectParameters>
            <UpdateParameters>
                <asp:Parameter Name="Starting" />
                <asp:Parameter Name="Treatment" />
                <asp:Parameter Name="Group" />
            </UpdateParameters>
        </asp:SqlDataSource>
                                
                    </strong>
    </form>
</body>
</html>