<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="History.aspx.cs" Inherits="ProcessTree.History" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Version History</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css"/>
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

        .auto-style33 {
            text-align: left;
            font-size: large;
        }
        .auto-style31 {
            text-align: right;
            width: 50%;
        }
        
        .auto-style34 {
            color: #009933;
        }
        
        </style>
    
    <script src="Timer.js"> </script>               
    <link href="StyleSheet.css" rel="stylesheet" type="text/css" />
</head>
<body >
    <form id="History" runat="server">
                  <table class="auto-style32">
            <tr>
                <td class="auto-style30">
                     <asp:Label ID="LabelLogin" runat="server" Class="login" Text="Error! Please contact the admin: Law.Economist@Gmail.com" Font-Size="Large" CssClass="auto-style34"></asp:Label>
                    <asp:Label id="TimeSpan" runat="server" style="display: none"></asp:Label>   
                    </td>
                <td class="questions"> 
                                    <asp:Button ID="BtnReturn" runat="server" OnClick="BtnReturn_Click" Text="Return" TabIndex="9" />
                </td>
                </tr>       
                      <tr>
                <td class="auto-style31">
                    <asp:Label ID="DeadLineMessage" runat="server" Font-Bold="True" Text="This page refreshes at "></asp:Label>
                </td>
                <td id="DeadLine" class="time">                   
                </td>
                      </tr>
                      <tr>
               
                <td class="auto-style31">
                    <asp:Label ID="TimerMessage" runat="server" Font-Bold="True" Text="in about"></asp:Label>
                </td>
                <td id="Timer" class="time">
                   <script type="text/javascript">
                        function period_check() {
                        var xmlhttp = new XMLHttpRequest();
                        xmlhttp.onreadystatechange = function () {
                            if (xmlhttp.readyState == XMLHttpRequest.DONE) {   // XMLHttpRequest.DONE == 4
                                if (xmlhttp.status == 200 || xmlhttp.status == 0 ) {
                                    if (xmlhttp.responseText.length == 0) {
                                        alert('1: xmlhttp.status = ' + xmlhttp.status);
                                        // Leave immediately. Something went wrong, probably with the session. Don't set the timer to fire again.
                                        return;
                                    }
                                    if (xmlhttp.responseText != document.getElementById("CurrentPeriod").innerHTML) {                                         
                                        document.getElementById("TimeSpan").innerHTML = "0";
                                        document.getElementById("DeadLine").innerHTML = "New Period Began. Please return!";
                                        document.getElementById("DeadLine").style.color = "#D00";
                                        document.getElementById("DeadLineMessage").innerHTML = "";
                                        document.getElementById("TimerMessage").innerHTML = "";
                                        document.getElementById("Timer").style.display = "none";
                                        notify("New Period Began!");
                                    }
                                    // Set the timer after it has done its work so that it can check again.
                                    global_period_check_timer = window.setTimeout(period_check, 12000);
                                }
                                else {
                                    //alert('2: xmlhttp.status = ' + xmlhttp.status + ' ; xmlhttp.responseText = ' + xmlhttp.responseText);
                                }
                            }
                        }
                        xmlhttp.open("GET", "/ChangePeriod.aspx", true);
                        xmlhttp.send();
                        }
                        // Start timer. You can put a condition around this if you want, like the current URL for example.
                        global_period_check_timer = window.setTimeout(period_check, 12000);

                        var TSpan = parseInt(document.getElementById("TimeSpan").textContent);
                        if (TSpan <= 0) {                            
                            document.getElementById("DeadLine").innerHTML = "New Period Began. Please return!";
                            document.getElementById("DeadLine").style.color = "#D00";
                            document.getElementById("DeadLineMessage").innerHTML = "";
                            document.getElementById("TimerMessage").innerHTML = "";
                            document.getElementById("Timer").style.display = "none";
                            notify("New Period Began!");
                        }
                        else {
                            var ClientDeadLine = new Date((new Date()).getTime() + TSpan);
                            document.getElementById("DeadLine").innerHTML = ClientDeadLine.toLocaleTimeString([], options);
                            CountDownTimer(ClientDeadLine, "Timer");
                        }
                  </script>

                </td>
                      </tr>
            <tr>               
                <td class="auto-style33" colspan="2">
                    Previous
                    Versions:</td>
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
                        SelectCommand="SELECT '&lt;span class=&quot;version-choice&quot;&gt;' + 
CASE WHEN Choice = 0 THEN '&lt;hr&gt;&lt;h3&gt;Versions in Round ' + CAST(Period/2 AS VARCHAR(MAX)) + ':&lt;/h3&gt;'+ (CASE WHEN Proposer = 'experimenter' THEN 'Initial Edition' ELSE 'Updated Edition' END) 
ELSE '&amp;nbsp; &amp;gt; &amp;nbsp;Suggestion ' + CAST(Choice AS VARCHAR(MAX)) END + ':&lt;/span&gt;&lt;div class=&quot;version-artifact&quot;&gt;&lt;br&gt;' + REPLACE(HtmlArtifact, CHAR(13), '&lt;br&gt;') + '&lt;/div&gt;&lt;br&gt;' AS Content, Choice FROM Versions WHERE (Period &lt;= @Period) AND (Treatment = @Treatment) AND ([Group#] = @Group)  ORDER BY Period DESC, Choice ASC">
                        <SelectParameters>
                            <asp:Parameter DefaultValue="1" Name="Period" />
                            <asp:Parameter DefaultValue="0" Name="Treatment" Type="Int32" />
                            <asp:Parameter DefaultValue="1" Name="Group" />
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
    <script src="https://code.jquery.com/jquery-3.3.1.slim.min.js" integrity="sha384-q8i/X+965DzO0rT7abK41JStQIAqVgRVzpbzo5smXKp4YfRvH+8abtTE1Pi6jizo" crossorigin="anonymous"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js" integrity="sha384-UO2eT0CpHqdSJQ6hJty5KVphtPhzWj9WO1clHTMGa3JDZwrnQq4sF86dIHNDz0W1" crossorigin="anonymous"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js" integrity="sha384-JjSmVgyd0p3pXB1rRibZUAYoIIy6OrQ6VrjIEaFf/nJGzIxFDsf4x0xIM+B07jRM" crossorigin="anonymous"></script>
</body>
</html>
