<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Suggestion.aspx.cs" Inherits="ProcessTree.Suggestion" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Suggest a Modification</title>
    <style type="text/css">

        .auto-style3 {
            margin: 0px;
            overflow: auto;
            text-align: justify; 
            display: block;
            padding: 10px;
            border: 2px solid #6600CC;            
        }
   
        .auto-style12 {
            height: 150px;
            text-align: right;
            font-size: x-large;
        }
        .style32
        {
            color: #003300;
            font-size: x-large;            
            font-family: Roman;
            text-align: center;
        }
        .auto-style19 {
            text-align: right;
            width: 50%;
        }
        .auto-style21 {
            text-align: left;
            height: 27px;
        }
        .auto-style23 {
            
            height: 44px;
            width: 50%;
        }
        .auto-style24 {
            text-align: right;
            height: 50%;
        }
     
        .auto-style25 {
            height: 98px;
        }
        .auto-style26 {
            height: 38px;
        }
        .auto-style27 {
            text-align: right;
            height: 38px;
        }
     
        .auto-style28 {
            height: 56px;
        }
        .auto-style29 {
            text-align: right;
            height: 56px;
        }
     
        </style>
    

<script src="Timer.js">    </script> 
        <link href="StyleSheet.css" rel="stylesheet" type="text/css" />
    </head>

<body style="height: 100%">
        <form id="Suggestion" runat="server">
                      <table class="table">
                                      <tr>
                                                          <td class="auto-style23">
                                                                                   <strong><span class="style32">
                        <asp:Label ID="LabelBalance" runat="server" CssClass="balance"></asp:Label>
                        </span></strong>                        

                                                                                                                        </td>
                                                          <td class="auto-style24">
                                                                                                  <asp:Button ID="BtnHistory" runat="server" OnClick="BtnHistory_Click" Text="Versions History" TabIndex="9" />                       

                                                          </td>     

                                      </tr>            
                                                    <tr>
                                                                        <td colspan="2">
                                                                                   <asp:Label ID="LabelLogin" runat="server" Text="Please refresh the page!" Font-Size="Large" Height="28px" Font-Bold="True" Font-Italic="True" ForeColor="Red" Width="100%"></asp:Label>                        

                                                                                                                        </td>
                             
            </tr>
            <asp:Label id="TimeSpan" runat="server" style="display: none"></asp:Label> 
            <tr>
                <td class="auto-style19">
                    <asp:Label ID="DeadLineMessage" runat="server" Font-Bold="True" Text="Please submit your edition before "></asp:Label>
                </td>
                <td id="DeadLine" class="time">                   
                  
                </td>
            </tr>
            <tr>               
                <td class="auto-style19">
                    <asp:Label ID="TimerMessage" runat="server" Font-Bold="True" Text="in about"></asp:Label>
                </td>
                <td id="Timer" class="time">
                      <script type="text/javascript">
                        function period_check() {
                            var xmlhttp = new XMLHttpRequest();
                            xmlhttp.onreadystatechange = function () {
                                if (xmlhttp.readyState == XMLHttpRequest.DONE) {   // XMLHttpRequest.DONE == 4
                                    if (xmlhttp.status == 200 || xmlhttp.status == 0) {
                                        if (xmlhttp.responseText.length == 0) {
                                            // alert('1: xmlhttp.status = ' + xmlhttp.status);
                                            // Leave immediately. Something went wrong, probably with the session. Don't set the timer to fire again.
                                            return;
                                        }
                                        if (xmlhttp.responseText != document.getElementById("CurrentPeriod").innerHTML) {
                                            document.getElementById("TimeSpan").innerHTML = "0";
                                            document.getElementById("DeadLine").innerHTML = "Please refresh the page!";
                                            document.getElementById("DeadLine").style.color = "#000";
                                            document.getElementById("DeadLineMessage").innerHTML = "";
                                            document.getElementById("TimerMessage").innerHTML = "";
                                            document.getElementById("Timer").style.display = "none";                                            
                                            document.getElementById("LabelVersion").innerHTML = "Period changed. Copy and paste your work in NotePad, then refresh the page!";
                                            document.getElementById("LabelVersion").style.color = "#D00";
                                            document.getElementById("LabelLogin").innerHTML = "Suggestion period ended!";
                                            document.getElementById("BtnSubmit").style.display = "none";
                                            notify("New Period Began!");
                                            //alert('The period has changed. You cannot submit your suggestion now. Copy and paste it in NotePad, then Refresh the page!');
                                        }
                                        // Set the timer after it has done its work so that it can check again.
                                        global_period_check_timer = window.setTimeout(period_check, 12000);
                                    }
                                    else {
                                        alert('2: xmlhttp.status = ' + xmlhttp.status + ' ; xmlhttp.responseText = ' + xmlhttp.responseText);
                                    }
                                }
                            }
                            xmlhttp.open("GET", "/ChangePeriod.aspx", true);
                            xmlhttp.send();
                        }

                        // Start timer. You can put a condition around this if you want, like the current URL for example.
                        global_period_check_timer = window.setTimeout(period_check, 12000);

                        var TSpan = parseInt(document.getElementById("TimeSpan").textContent);
                        var ClientDeadLine = new Date((new Date()).getTime() + TSpan);                        
                        document.getElementById("DeadLine").innerHTML = ClientDeadLine.toLocaleTimeString([], options);
                        CountDownTimer(ClientDeadLine, "Timer");
                    </script>
                </td>
            </tr>
            <tr>
               
                <td class="auto-style21" colspan="2">
                            <strong><em>             
                            <br />
                            <asp:Label ID="LabelVersion" runat="server" Text="Current Updated Edition:" Font-Size="Large" ></asp:Label>    
                            </em></strong>    
                           <%-- <a href='/ChatRoom.aspx' target="_blank">Chat Room</a></td>--%>
               
                </td>
               </tr>
                </table>
            <asp:TextBox ID="txtArtifact" runat="server" BackColor="#FFEE88" MinLines="5" MaxLines="50" Height="300px" style="direction: ltr" TextMode="MultiLine" TabIndex="1" CssClass="auto-style3" Font-Names="Times New Roman" Font-Size="Large" MaxLength="2000" Width="97%">Please refresh the page! (Database is not accessable now)</asp:TextBox>
                                                          
          <asp:Label ID="LabelArtifact" runat="server" BackColor="#FFEE88" CssClass="auto-style3" Font-Names="Times New Roman" Font-Size="Large" Height="300px" Text="Please refresh the page! (Database is not accessable now)" Visible="False" Width="97%" TabIndex="2"  ></asp:Label>
                                
        <table class="auto-style25" >
            <tr>
                <td class="auto-style26">
    
                                <asp:Button ID="BtnSubmit" runat="server" Font-Bold="True" onclick="BtnSubmitScore_Click" TabIndex="3" Text="Submit Suggestion" AccessKey="s"/>
                            <br />
                </td>
                <td class="auto-style27">
    
                                <asp:Button ID="BtnCancel" runat="server" Font-Bold="True" onclick="BtnCancel_Click" TabIndex="4" Text="Cancel Changes"/>
    
                            <br />
                </td>
            </tr>
            <tr>
                <td class="auto-style28">
    
                    <strong><span class="auto-style12">
                                <br />
                                Instructions:</span></strong></td>
                <td class="auto-style29">    
                                <br />
                                <a href="/tips.aspx">Visual Directions</a>
                </td>
            </tr>
        </table>             
              <asp:Label ID="ConstitutionBox" runat="server" Text="Please refresh the page! (Database is not accessable now)" Width="96%" BackColor="#CCFFAA" BorderColor="#66FF66" BorderStyle="Solid" BorderWidth="10px" CssClass="justified" Font-Names="Georgia" Font-Size="Medium" TabIndex="1"></asp:Label>            
          <p class="questions">
                    <asp:Button ID="BtnSignOut" runat="server" OnClick="BtnSignOut_Click" Text="Sign Out" TabIndex="9" Visible="False"/>    
                      </p>
                    <asp:Label ID="CurrentPeriod" runat="server" style="display: none"></asp:Label>   
    </form>
    <script>
        var LabelArtifact = document.getElementById("LabelArtifact");
        function LabelArtifactMouseOver() {
            Array.from(this.getElementsByClassName("diff-delnohover")).map(function (e) { e.classList.remove("diff-delnohover"); });
            Array.from(this.getElementsByClassName("diff-addnohover")).map(function (e) { e.classList.remove("diff-addnohover"); });
        }
        if (LabelArtifact) { LabelArtifact.addEventListener("mouseover", LabelArtifactMouseOver); }

        function LabelArtifactMouseOut() {
            Array.from(this.getElementsByClassName("diff-add")).map(function (e) { e.classList.add("diff-addnohover"); })
            Array.from(this.getElementsByClassName("diff-del")).map(function (e) { e.classList.add("diff-delnohover"); })
        }
        if (LabelArtifact) { LabelArtifact.addEventListener("mouseout", LabelArtifactMouseOut); }
    </script>
</body>
</html>
