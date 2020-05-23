<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ChatRoom.aspx.cs" Inherits="ProcessTree.ChatRoom" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Chat Room</title>
    <link href="StyleSheet.css" rel="stylesheet" />
    <style type="text/css">
        .auto-style1 {
            display: block;
            margin: 5px auto;
            background-color: #BDF;
        }
        .auto-style2 {
            height: 600px;
            overflow: auto;
            display: block;
            width: 100%;
            text-align: right;
            margin: 5px auto;
            background-color: #EDA;
        }
        .auto-style3 {
            text-align: left;
        }
        .auto-style4 {
            font-weight: bold;
        }
    </style>
</head>
<body>
      <form id="form1" runat="server" style="max-width: 800px">
          <div class="questions">
              <div class="auto-style3">
          
         
          
          <asp:Button ID="BtnRefresh" runat="server" OnClick="BtnRefresh_Click" Text="Refresh" />
         
          
          &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
          <a href="javascript:window.close();">Close Chat Room</a>              
              </div>
      <div class="auto-style2" id="chat_log">
          <asp:CheckBoxList ID="List" runat="server" DataSourceID="SqlDataSource1" DataTextField="Column1" DataValueField="Column1" AppendDataBoundItems="True" AutoPostBack="True" CellPadding="5" Font-Names="Times New Roman" Font-Size="Small" RepeatColumns="1" DataMember="DefaultView" Enabled="False" CssClass="remove-checkbox"></asp:CheckBoxList>
          <%--<asp:BulletedList ID="BulletedList1" runat="server" DataSourceID="SqlDataSource1" DataTextField="Column1" DataValueField="Column1"></asp:BulletedList>--%>
    	      <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:ProcessTreeConnectionString %>" SelectCommand="SELECT '&lt;span class=&quot;chat-author&quot;&gt;&lt;br&gt;&lt;hr&gt;' +  People.Name + '&lt;/span&gt;: &amp;nbsp;&lt;span class=&quot;chat-message&quot;&gt; ' + HtmlArtifact + '&lt;/span&gt;' 
FROM Versions LEFT JOIN People ON People.ID = Versions.Proposer
WHERE Versions.Treatment = @Treatment AND Versions.Group# =@Group
ORDER BY Time">
                  <SelectParameters>
                      <asp:Parameter DefaultValue="0" Name="Treatment" />
                      <asp:Parameter DefaultValue="1" Name="Group" />
                  </SelectParameters>
              </asp:SqlDataSource>
          
         
          
             <%-- <ul name="LList" runat="server" datasourceid="SqlDataSource1">
		    <li><span class="chat-author">Person 1</span>: &nbsp;<span class="chat-message">This is loads of example text for your face to read slowy in some kind of chair...</span></li>
		    <li><span class="chat-author">Not a Person</span>: &nbsp;<span class="chat-message">Whatever else can go here is more things and stuff and words and whatever...</span></li>
		    <li><span class="chat-author">Person 1</span>: &nbsp;<span class="chat-message">This is loads of example text for your face to read slowy in some kind of chair...</span></li>
		    <li><span class="chat-author">Not a Person</span>: &nbsp;<span class="chat-message">Whatever else can go here is more things and stuff and words and whatever...</span></li>
		    <li><span class="chat-author">Person 1</span>: &nbsp;<span class="chat-message">This is loads of example text for your face to read slowy in some kind of chair...</span></li>
		    <li><span class="chat-author">Not a Person</span>: &nbsp;<span class="chat-message">Whatever else can go here is more things and stuff and words and whatever...</span></li>
		    <li><span class="chat-author">Person 1</span>: &nbsp;<span class="chat-message">This is loads of example text for your face to read slowy in some kind of chair...</span></li>
		    <li><span class="chat-author">Not a Person</span>: &nbsp;<span class="chat-message">Whatever else can go here is more things and stuff and words and whatever...</span></li>		
    	</ul>--%>
	    <script type="text/javascript">
	    	var chatlog_div = document.getElementById("chat_log");
	    	chatlog_div.scrollTop = chatlog_div.scrollHeight;
    	</script>
    </div>    
          
         
          
          <asp:TextBox runat="server" CssClass="auto-style1" name="message" ID="TxtMessage" Height="50px" Width="100%"></asp:TextBox>	
            <div class="questions">
                <strong>
            <asp:Button ID="BtnSend" runat="server" OnClick="BtnSend_Click" Text="Send" CssClass="auto-style4" Width="72px" />
                </strong>
                        
          
          </div>
          </div>
      </form>


</body>
</html>
