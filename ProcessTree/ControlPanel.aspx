
<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ControlPanel.aspx.cs" Inherits="ProcessTree.ControlPanel" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Control Panel</title>
    <!--
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css" integrity="sha384-ggOyR0iXCbMQv3Xipma34MD+dH/1fQ784/j6cY/iJTQUOhcWr7x9JvoRxT2MZw1T" crossorigin="anonymous"/>
    -->
    <style type="text/css">

        .auto-style1 {
            width: 47%;
        }

        .auto-style6 {
            width: 47%;
            text-align: left;
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
                
        .auto-style31 {
            text-align: right;            
        }
        .auto-style33 {
            text-align: right;            
        }
        .auto-style35 {
            text-align: right;            
        }
        .auto-style37 {
            width: 47%;            
        }
        .auto-style60 {
            width: 30%;
            text-align: right;
        }
        .auto-style65 {
            width: 32%;
            background-color: #FFCCCC;
        }

        .auto-style66 {
            width: 32%;
        }
        .auto-style67 {
            width: 32%;
            text-align: left;
        }
        
        .auto-style69 {
            width: 32%;
            text-align: right;
        }
        .auto-style70 {
            width: 35%;
        }
        .auto-style71 {
            width: 35%;
            text-align: left;
        }

        .auto-style73 {
            width: 32%;
            background-color: #FFFFFF;
        }

        .auto-style74 {
            text-align: right;
            background-color: #CCFFFF;
        }
        .auto-style75 {
            width: 35%;
            background-color: #FFCCFF;
        }
        .auto-style76 {
            background-color: #CCFFFF;
        }
        .auto-style77 {
            width: 32%;
            background-color: #CCFFCC;
        }

        </style>
    <link href="StyleSheet.css" rel="stylesheet" type="text/css" />    
</head>
<body>
    <form id="ControlPanel" runat="server">
        <table class="auto-style29">
            <tr>
                <td class="auto-style70">

                    <span><strong aria-atomic="False" aria-busy="False" aria-dropeffect="none" aria-expanded="false" aria-grabbed="undefined" aria-multiline="False">
                                <asp:Button ID="BtnSave" runat="server" Font-Bold="True" onclick="BtnSave_Click" Text="Save Changes" AccessKey="s" />
                    &nbsp;
                    &nbsp;<asp:Button ID="BtnActivate" runat="server" OnClick="BtnActivate_Click" Text="Save &amp; Activate" TabIndex="10" CausesValidation="False" />
                    &nbsp;&nbsp;
                    <asp:Button ID="BtnCreate" runat="server" OnClick="BtnCreate_Click" Text="Create Next" TabIndex="20" CausesValidation="False" />
                    </strong>
                </td>
                <td class="auto-style66">

                    <span><strong aria-atomic="False" aria-busy="False" aria-dropeffect="none" aria-expanded="false" aria-grabbed="undefined" aria-multiline="False">
                    <em><strong>Treatment# : 
                    <asp:DropDownList ID="Treat" runat="server" DataSourceID="SqlDataSource1" DataTextField="TID" DataValueField="TID" AutoPostBack="True" OnSelectedIndexChanged="DropNumbers_SelectedIndexChanged" BackColor="Aqua" TabIndex="40" Font-Bold="True" Font-Italic="False">
                    </asp:DropDownList>
                    </strong>
                    </em>
                    </strong>
                </td>
                <td class="auto-style31">

                    <span><strong aria-atomic="False" aria-busy="False" aria-dropeffect="none" aria-expanded="false" aria-grabbed="undefined" aria-multiline="False">
                    <em>&nbsp;&nbsp;
                    </em>&nbsp;<asp:Button ID="Back" runat="server" OnClick="Back_Click" Text="Exit" TabIndex="30" CausesValidation="False" />
                    </strong>
                            
                    </td>                
            </tr>
             <tr>
                <td class="auto-style70">

                    <span class="auto-style18">

                    <em>

                    <span>
                    <asp:CheckBox ID="PvH" runat="server" Text="People" TabIndex="270" TextAlign="Left" BackColor="White" />
                
                    <strong aria-atomic="False" aria-busy="False" aria-dropeffect="none" aria-expanded="false" aria-grabbed="undefined" aria-multiline="False">
                    <asp:Label ID="Message" runat="server" Font-Italic="True" Font-Size="Medium" ForeColor="Red">Please Contact the Admin: Law.Economist@Gmail.com</asp:Label>
                
                    </strong>
                            
                    </span> 
                    </em>

                    </span>

                    </td>
                <td class="auto-style69">

                    <span>&nbsp;<asp:Button ID="Down" runat="server" BackColor="Fuchsia" BorderWidth="0px" Font-Overline="False" OnClick="Down_Click" Text="-" BorderStyle="None" TabIndex="70" Enabled="False" />
&nbsp;<asp:Button ID="Up" runat="server" BackColor="Fuchsia" BorderWidth="0px" Font-Overline="False" OnClick="Up_Click" Text="+" BorderStyle="None" TabIndex="80" />
&nbsp;Groups =
                    <strong>
                    <asp:TextBox ID="Groups" runat="server" TextMode="Number" BackColor="Fuchsia" TabIndex="90" ReadOnly="True" CssClass="auto-style16" Width="30px">1</asp:TextBox>
                
                    </strong>
                
                 </td>
                <td class="auto-style35">

                    <span><strong aria-atomic="False" aria-busy="False" aria-dropeffect="none" aria-expanded="false" aria-grabbed="undefined" aria-multiline="False">

                    &nbsp;</strong>Maximum Subjects per Group <strong aria-atomic="False" aria-busy="False" aria-dropeffect="none" aria-expanded="false" aria-grabbed="undefined" aria-multiline="False">
                    = <asp:TextBox ID="PerGroup" runat="server" TextMode="Number" BackColor="Fuchsia" TabIndex="50" Width="36px" AutoPostBack="True">50</asp:TextBox>
                    
                    </strong>
                
                 </td>
            </tr>
             <tr>
                <td class="auto-style58" colspan="3" style="font-size: medium">

                    <span>
                    <asp:GridView ID="GroupList" runat="server" AllowSorting="True" AutoGenerateColumns="False" BackColor="LightGoldenrodYellow" BorderColor="Tan" BorderWidth="1px" CellPadding="2" DataSourceID="SqlDataSource3" ForeColor="Black" GridLines="None" Font-Size="Small" TabIndex="400" AllowPaging="True" DataKeyNames="Treatment,Group" PageSize="20" OnSelectedIndexChanged="GroupList_SelectedIndexChanged" Height="16px">
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
                            <asp:BoundField DataField="Period" HeaderText="Period" SortExpression="Period" NullDisplayText="Null" >
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
                <td class="auto-style6" colspan="2">

                    &nbsp;</td>
                <td class="questions">

                    &nbsp;</td>
            </tr>
             <tr>
                <td class="auto-style71" rowspan="3">

                    <asp:RadioButtonList ID="Valuation" runat="server" BackColor="Yellow" BorderColor="#CC3300" BorderStyle="Solid" RepeatLayout="Flow" TabIndex="220" CellPadding="5" CellSpacing="5"><asp:ListItem Value="2">Plurality</asp:ListItem><asp:ListItem Value="4">Approval</asp:ListItem><asp:ListItem Value="5">Approval: (M-V).Rv</asp:ListItem><asp:ListItem Value="10">Parallel Markets</asp:ListItem>
                        <asp:ListItem Value="12">Parallel Primary Markets</asp:ListItem>
                    </asp:RadioButtonList></td>
                <td class="auto-style67">

                    Tp =
                    <asp:TextBox ID="Tp" runat="server" BackColor="Yellow" Width="50px" OnTextChanged="Tp_TextChanged" TabIndex="110" required pattern ="[0-9]*\.?[0-9]+">12</asp:TextBox>
                            &nbsp;mins</td>
                <td class="auto-style33">

                    Ta =
                    (DeadLine - Starting) =
                    <asp:TextBox ID="Ta" runat="server" BackColor="Yellow" Width="50px" OnTextChanged="Ta_TextChanged" AutoPostBack="True" TabIndex="150" required pattern ="[0-9]*\.?[0-9]+">0</asp:TextBox>
                &nbsp;mins</td>
            </tr>
             <tr>
                <td class="auto-style67">

                   Tv =
                    <asp:TextBox ID="Tv" runat="server" BackColor="Yellow" Width="50px" OnTextChanged="Tv_TextChanged" TabIndex="120" required pattern ="[0-9]*\.?[0-9]+">24</asp:TextBox>
                &nbsp;mins</td>
                <td class="auto-style33">

                    Tz = (Closing - Starting) =
                    <asp:TextBox ID="Tz" runat="server" required pattern ="[0-9]*\.?[0-9]+" Width="50px" TabIndex="160" BackColor="Yellow" OnTextChanged="Tz_TextChanged" AutoPostBack="True">0</asp:TextBox>
                    &nbsp;mins</td>
            </tr>
             <tr>
                <td class="auto-style67">

                    Te =
                    <asp:TextBox ID="Te" runat="server" required pattern ="[0-9]*\.?[0-9]+" Width="50px" TabIndex="130" BackColor="Yellow">0</asp:TextBox>
                            &nbsp;mins</td>
                <td class="auto-style33">

                    Tf = (Ending - Closing) =
                    <asp:TextBox ID="Tf" runat="server" required pattern ="[0-9]*\.?[0-9]+" BackColor="Yellow" OnTextChanged="Tf_TextChanged" AutoPostBack="True" Width="50px" TabIndex="170">0</asp:TextBox>
                    &nbsp;mins</td>
            </tr>
             <tr>
                <td class="auto-style71">

                    

                    Beta =
                    <asp:TextBox ID="Beta" runat="server" BackColor="Yellow" Width="50px" OnTextChanged="Tp_TextChanged" TabIndex="110" required pattern ="[0-9]*\.?[0-9]+">1</asp:TextBox>
                            &nbsp;shares</td>
                <td class="auto-style67">

                    E&nbsp;&nbsp; =
                    <asp:TextBox ID="E" runat="server" required pattern ="[0-9]*\.?[0-9]+" Width="50px" TabIndex="140" BackColor="#CCCCCC" Enabled="False">0</asp:TextBox>
                    &nbsp;%</td>
                <td class="auto-style35">

            Span = (Ending - Starting) =
                    <asp:TextBox ID="Span" runat="server" required pattern ="[0-9]*\.?[0-9]+" BackColor="White" AutoPostBack="True" Width="50px" TabIndex="180" ReadOnly="True" Font-Bold="True" Font-Italic="False">0</asp:TextBox>
                    &nbsp;mins</td>
            </tr>
             <tr>
                <td class="auto-style70">

                    &nbsp;</td>
                <td class="auto-style66">

                    &nbsp;</td>
                <td class="auto-style60">

                    &nbsp;</td>
            </tr>
             <tr>
                <td class="auto-style75">

                    <strong>Meritocracy Schemes:</strong></td>
                <td class="auto-style77">

                    

                <strong>

                    M&nbsp;&nbsp; =&nbsp;
                    <asp:TextBox ID="M" runat="server" BackColor="Aqua" Width="40px" TabIndex="190" required pattern ="[0-9]+">1</asp:TextBox>
                    &nbsp;<span class="auto-style45">Suggestions</span></strong></td>
                <td class="auto-style76">

                    

                    &nbsp;</td>
            </tr>
             <tr>
                <td class="auto-style75">

                    <span>W =
                    <asp:TextBox ID="W" runat="server" Width="40px" TabIndex="200" BackColor="#FF9900" OnTextChanged="W_TextChanged" AutoPostBack="True">0</asp:TextBox>
                &nbsp;votes</td>
                <td class="auto-style77">

                    

                    MR<strong> =&nbsp;
                    <asp:TextBox ID="MR" runat="server" BackColor="Aqua" Width="40px" TabIndex="190" required pattern ="[0-9]+" Enabled="False">1</asp:TextBox>
                    &nbsp;</strong><span class="auto-style45">Prizes</span></td>
                <td class="auto-style74">

                    

                    Base Pay&nbsp;= 
                    <asp:TextBox ID="Compensation" runat="server" BackColor="Lime" TabIndex="290" Width="40px" required pattern ="[0-9]*\.?[0-9]+">0</asp:TextBox>
                    $</td>
            </tr>
             <tr>
                <td class="auto-style75">

                    <span>V&nbsp; =
                    <asp:TextBox ID="V" runat="server" Width="40px" TabIndex="210" BackColor="#FF9900">0</asp:TextBox>
                &nbsp;votes</td>
                <td class="auto-style77">

                    

            <span>
                    <asp:CheckBox ID="VoteChange" runat="server" Text="Vote Revisable" TabIndex="240" Font-Bold="False" TextAlign="Left" />
                
                  </td><td class="auto-style74">Reward = <asp:TextBox ID="Reward" runat="server" required pattern ="[0-9]*\.?[0-9]+" TabIndex="300" BackColor="Lime" Width="40px">0</asp:TextBox>$</td></tr><tr>
                <td class="auto-style75" rowspan="3"><asp:RadioButtonList ID="RadioMeritocracy" runat="server" BackColor="#FF9900" Width="300px" AutoPostBack="True" BorderColor="#CC3300" BorderStyle="Solid" RepeatLayout="Flow" TabIndex="220">
                        <asp:ListItem Value="0">Only Constant V</asp:ListItem><asp:ListItem Value="1">Raw Vote(i)</asp:ListItem><asp:ListItem Value="2">Vote(i) - Vote(0)</asp:ListItem><asp:ListItem Value="3">Vote(i) - MinVote</asp:ListItem></asp:RadioButtonList></td>
                <td class="auto-style73">
                    &nbsp;</td><td class="auto-style74">Rv = <asp:TextBox ID="Rv" runat="server" TabIndex="310" BackColor="Lime" Width="40px" required pattern ="[0-9]*\.?[0-9]+">0</asp:TextBox>
                    $</td>
            </tr>
             <tr>
                <td class="auto-style65">Initial Balance = <asp:TextBox ID="InitialBalance" runat="server" required pattern ="[0-9]*\.?[0-9]+" TabIndex="280" BackColor="Lime" Width="85px">0</asp:TextBox>
                    $ / Person</td>
                <td class="auto-style74">

            Ro =
                    <asp:TextBox ID="Ro" runat="server" required pattern ="[0-9]*\.?[0-9]+" TabIndex="320" BackColor="Lime" Width="40px">0</asp:TextBox>
                    $</td>
            </tr>
              <tr>
                <td class="auto-style65">Initial Fund = <asp:TextBox ID="InitialVolume" runat="server" required pattern ="[0-9]*\.?[0-9]+" TabIndex="280" BackColor="Lime" Width="123px" AutoPostBack="True">0</asp:TextBox>

                    $ / Group</td>
                <td class="auto-style74">

                    &nbsp;</td>
            </tr>
              <tr>
                <td class="auto-style75" rowspan="2">

                    <asp:RadioButtonList ID="RadioMerit2All" runat="server" BackColor="#FF9900" Width="300px" AutoPostBack="True" BorderColor="#CC3300" BorderStyle="Solid" RepeatLayout="Flow" TabIndex="230">
                        <asp:ListItem Value="0">Only to Winner</asp:ListItem>
                        <asp:ListItem Value="1">To all Proposers</asp:ListItem>
                    </asp:RadioButtonList>
                
                 </td>
                <td class="auto-style65">

                    

                    Maximum Performance = <asp:TextBox ID="MaxPerformance" runat="server" required pattern ="[0-9]*\.?[0-9]+" TabIndex="280" BackColor="Lime" Width="123px" AutoPostBack="True">2.5</asp:TextBox>

                    </td>
                <td class="auto-style74">

                    <span>
                    <asp:CheckBox ID="AuctionSort" runat="server" Text="Auction for Sorting" TabIndex="260" TextAlign="Left" BackColor="Lime" BorderColor="#009933" BorderStyle="Solid" BorderWidth="1px" EnableTheming="True" />
                
                  </td>
            </tr>
              <tr>
                <td class="auto-style65">

                    

                    Max Cost per Person =
                    <asp:Label ID="WPerson" runat="server" Text="0"></asp:Label>
&nbsp;$</td>
                <td class="auto-style74">

                    Suggestion Fee = <asp:TextBox ID="SuggestionFee" runat="server" required pattern ="[0-9]*\.?[0-9]+" TabIndex="280" BackColor="Lime" Width="40px">0</asp:TextBox>
                    $ </td>
            </tr>
              <tr>
                <td class="auto-style75">

                    &nbsp;</td>
                <td class="auto-style65">

                    Max Cost per Group =
                    <asp:Label ID="WGroup" runat="server" Text="0"></asp:Label>
&nbsp;$</td>
                <td class="auto-style74">

                    Voting Fee = <asp:TextBox ID="BetFee" runat="server" required pattern ="[0-9]*\.?[0-9]+" TabIndex="280" BackColor="Lime" Width="40px">0</asp:TextBox>
                    $</td>
            </tr>
              <tr>
                <td class="auto-style17" colspan="2">
            <script>
                a = Number(InitialBalance.value);
                b = Number(InitialVolume.value);
                p = Number(MaxPerformance.value);

                WPerson.innerHTML = (a * p).toFixed(2);
                WGroup.innerHTML = (b * p).toFixed(2);

            </script>
            <strong>Instructions:</strong></td>
                <td>

                    &nbsp;</td>
            </tr>
              <tr>
                <td colspan="3" class="auto-style47">

            
                    <asp:TextBox ID="Constitution"  runat="server" BackColor="#CCFFAA" Height="272px" TextMode="MultiLine" Width="100%" TabIndex="330" Font-Names="Times New Roman" Font-Size="Medium" CssClass="justified">No Constitution!</asp:TextBox>
                
                </td>
            </tr>
              <tr>
                <td class="auto-style1" colspan="2">

                </td>
                <td>

                </td>
            </tr>
              <tr>
                <td class="auto-style1" colspan="2">

            <strong>Hypothesis:</strong></td>
                <td>

                </td>
            </tr>
              <tr>
                <td colspan="3" class="auto-style49">
            
                    <asp:TextBox ID="Hypothesis" runat="server" Height="60px" TextMode="MultiLine" Width="100%" BackColor="#FF66FF" TabIndex="340" Font-Names="Times New Roman" Font-Size="Medium" CssClass="justified">No Hypothesis!</asp:TextBox>
                
                </td>
            </tr>
              <tr>
                <td class="auto-style1" colspan="2">

                </td>
                <td>

                </td>
            </tr>
              <tr>
                <td class="auto-style1" colspan="2">

                    <strong>Initial Edition:</strong></td>
                <td>

                    &nbsp;</td>
            </tr>
              <tr>
                <td colspan="3" class="auto-style50">
                                
        <asp:TextBox ID="Artifact" runat="server" BackColor="#FFEE88" Height="169px"  style="direction: ltr" TextMode="MultiLine" Width="100%" AutoPostBack="True" TabIndex="350" Font-Names="Times New Roman" Font-Size="Medium" CssClass="justified">No Artifact!</asp:TextBox>
                
                </td>
            </tr>
              <tr>
                <td class="auto-style37" colspan="2">

                    <span><strong aria-atomic="False" aria-busy="False" aria-dropeffect="none" aria-expanded="false" aria-grabbed="undefined" aria-multiline="False">
                    <asp:Button ID="BtnEmail" runat="server" OnClick="BtnEmail_Click" Text="Email to Everybody" TabIndex="20" CausesValidation="False" BackColor="#FF5050" Width="194px" />
                    </strong>
                
                </td>
                <td class="auto-style48">

                    <span><strong aria-atomic="False" aria-busy="False" aria-dropeffect="none" aria-expanded="false" aria-grabbed="undefined" aria-multiline="False">
                    <asp:Button ID="BtnReset" runat="server" OnClick="BtnReset_Click" Text="Reset Group" TabIndex="20" CausesValidation="False" BackColor="#FF5050" Width="194px" />
                    </strong>
                
                </td>
            </tr>
              

        </table>    
                    <div dir="ltr" style="position: relative; z-index: auto; width: 100%; left: auto; right: auto; text-align: center; table-layout: auto;">
                    <asp:GridView ID="Participants" runat="server" AllowSorting="True" DataSourceID="SqlDataSource2" AutoGenerateColumns="False" DataKeyNames="ID" Visible="False" TabIndex="360" CellPadding="2" ForeColor="Black" GridLines="None" BackColor="LightGoldenrodYellow" BorderColor="Tan" BorderWidth="1px" CssClass="auto-style18" AllowPaging="True" Font-Size="Small" PageSize="50" >
                        <AlternatingRowStyle BackColor="PaleGoldenrod" />
                        <Columns>
                            <asp:BoundField DataField="ID" HeaderText="ID" ReadOnly="True" SortExpression="ID" >
                            </asp:BoundField>
                            <asp:BoundField DataField="Name" HeaderText="Name" SortExpression="Name" />
                            <asp:BoundField DataField="FinalBalance" HeaderText="FinalBalance" SortExpression="FinalBalance" />
                            <asp:BoundField DataField="Balance" HeaderText="Balance" SortExpression="Balance" />
                            <asp:BoundField DataField="ShareBalance" HeaderText="ShareBalance" SortExpression="ShareBalance" />
                            <asp:BoundField DataField="CreationTime" HeaderText="CreationTime" SortExpression="CreationTime" />
                            <asp:BoundField DataField="QualificationTime" HeaderText="QualificationTime" SortExpression="QualificationTime" >
                            </asp:BoundField>
                            <asp:BoundField DataField="Completed" HeaderText="Completed" SortExpression="Completed" />
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
                                
                    <asp:SqlDataSource ID="SqlDataSource2" runat="server" ConnectionString="<%$ ConnectionStrings:ProcessTreeConnectionString %>" SelectCommand="SELECT ID, Name, CreationTime, QualificationTime, Group#, Balance, FinalBalance, ShareBalance, Completed FROM People WHERE (ID &lt;&gt; @ID) AND (Treatment = @Treatment) ORDER BY Group#, CreationTime DESC" OldValuesParameterFormatString="original_{0}" UpdateCommand="UPDATE People 
SET Suspended = @Suspended, Balance = @Balance, ExtraVote = @ExtraVote, Completed = @Completed, Group# = @Group#
WHERE ID = @original_ID">
                        <SelectParameters>
                            <asp:Parameter DefaultValue="experimenter" Name="ID" />
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
 WHERE (Groups.[Treatment] = @Treatment) ORDER BY Groups.[Group#]" UpdateCommand="UPDATE Groups SET [Period] = @Period, [Starting] = @Starting, [DT] = CASE WHEN [Period] IS NULL OR [Period] = 0 THEN @Starting ELSE [DT] END WHERE ([Treatment] = @Treatment AND [Group#] = @Group)">
            <SelectParameters>
                <asp:ControlParameter ControlID="Ta" DefaultValue="0" Name="Ta" PropertyName="Text" />
                <asp:ControlParameter ControlID="Tz" DefaultValue="0" Name="Tz" PropertyName="Text" />
                <asp:ControlParameter ControlID="Span" DefaultValue="0" Name="Span" PropertyName="Text" />
                <asp:ControlParameter ControlID="Treat" DefaultValue="0" Name="Treatment" PropertyName="SelectedValue" Type="Int32" />
            </SelectParameters>
            <UpdateParameters>
                <asp:Parameter Name="Period" />
                <asp:Parameter Name="Starting" />
                <asp:Parameter Name="Treatment" />
                <asp:Parameter Name="Group" />
            </UpdateParameters>
        </asp:SqlDataSource>
                                
                    </strong>
    </form>
    <script src="https://code.jquery.com/jquery-3.3.1.slim.min.js" integrity="sha384-q8i/X+965DzO0rT7abK41JStQIAqVgRVzpbzo5smXKp4YfRvH+8abtTE1Pi6jizo" crossorigin="anonymous"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js" integrity="sha384-UO2eT0CpHqdSJQ6hJty5KVphtPhzWj9WO1clHTMGa3JDZwrnQq4sF86dIHNDz0W1" crossorigin="anonymous"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js" integrity="sha384-JjSmVgyd0p3pXB1rRibZUAYoIIy6OrQ6VrjIEaFf/nJGzIxFDsf4x0xIM+B07jRM" crossorigin="anonymous"></script>
</body>
</html>