<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ChatRoom.aspx.cs" Inherits="ProcessTree.ChatRoom" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Chat Room</title>
    <!--
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css" integrity="sha384-ggOyR0iXCbMQv3Xipma34MD+dH/1fQ784/j6cY/iJTQUOhcWr7x9JvoRxT2MZw1T" crossorigin="anonymous"/>
    -->
    <link href="StyleSheet.css" rel="stylesheet" />
    <style type="text/css">
        .chat-log {
	        height: 200px;
	        overflow: auto;
	        background-color: #EDA;
        }

        .chat-log ul {
	        list-style: none;
	        padding: 5px 5px 5px 5px;
        }

        .chat-author {	   
            display: inline-block;   
            vertical-align: top ;
	        font-weight: bold;
	        font-size: 125%;
        }

        .chat-message {
	        display: inline-block;           
	        margin-bottom: 10px;
        }

        .chat-textarea {
	        height: 150px;
	        background-color: #BDF;
        }

        .chat-log, .chat-textarea {
	        display: block;
	        width: 100%;
	        max-width: 800px;
	        margin: 5px auto;
        }
        .auto-style2 {
            display: block;
            max-width: 800px;
            background-color: #BDF;
            padding: 5px;
            margin: 2px auto;
        }
        .auto-style3 {
            height: 677px;
            width: 80%;
        }
        .auto-style4 {
            height: 467px;
            overflow: auto;
            display: block;
            width: 100%;
            max-width: 800px;
            margin: 5px auto;
            background-color: #EDA;
        }
        .auto-style5 {
            text-align: left;
            padding: 5px;
        }
        .auto-style6 {
            color: #CC0000;
        }
    </style>
</head>
<body style="height: 689px">
      <form id="form1" runat="server" style="max-width: 800px" class="auto-style3">
              <div class="questions">
              <div>          
                  <span class="auto-style6"><em><strong>Please refresh the page to see the new messages:&nbsp;</strong>&nbsp;&nbsp;&nbsp;&nbsp; </em></span>&nbsp;<asp:Button ID="BtnRefresh" runat="server" OnClick="BtnRefresh_Click" Text="Refresh" />
         &nbsp; &nbsp;&nbsp;&nbsp;
          <a href="javascript:window.close();">Close Chat Room</a>              
              </div>
          <div class="auto-style4" id="chat_log" style="border-style: double">
          <div class="auto-style5">
          <asp:CheckBoxList ID="List" runat="server" DataSourceID="SqlDataSource1" DataTextField="Content" DataValueField="Time" AppendDataBoundItems="True" AutoPostBack="True" CellPadding="5" Font-Names="Times New Roman" Font-Size="Small" DataMember="DefaultView" Enabled="False" CssClass="remove-checkbox" CausesValidation="True" RepeatLayout="Flow"></asp:CheckBoxList>
          
          </div>
          <div class="auto-style5">
          
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
	      </div>
	    <script type="text/javascript">
	    	var chatlog_div = document.getElementById("chat_log");
	    	chatlog_div.scrollTop = chatlog_div.scrollHeight;
    	</script>
    </div>          
                  <div class="questions">
          <asp:TextBox runat="server" CssClass="auto-style2" name="message" ID="TxtMessage" Height="56px" Width="99%" BorderStyle="Double" BorderWidth="1px" MaxLength="950" Rows="10" TextMode="MultiLine" OnTextChanged="TxtMessage_TextChanged"></asp:TextBox>	
                  </div>
                  <strong>
            <asp:Button ID="BtnSend" runat="server" OnClick="BtnSend_Click" Text="Send" Width="72px" BorderWidth="1px" BorderColor="#999999" BorderStyle="Solid" />
                </strong>
          <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:ProcessTreeConnectionString %>" SelectCommand="SELECT '&lt;span class=&quot;chat-author&quot;&gt;' + People.Name + ' : &lt;/span&gt; 
&lt;span class=&quot;chat-message&quot;&gt;' + Chats.Message + '&lt;/span&gt;&lt;hr&gt;' 
AS Content, Time
FROM Chats LEFT JOIN People ON People.ID = Chats.Writer
WHERE Chats.Treatment = @Treatment AND Chats.Group# =@Group
ORDER BY Time">
                  <SelectParameters>
                      <asp:Parameter DefaultValue="0" Name="Treatment" />
                      <asp:Parameter DefaultValue="1" Name="Group" />
                  </SelectParameters>
              </asp:SqlDataSource>
          
              </div>
      </form>
    <script src="https://code.jquery.com/jquery-3.3.1.slim.min.js" integrity="sha384-q8i/X+965DzO0rT7abK41JStQIAqVgRVzpbzo5smXKp4YfRvH+8abtTE1Pi6jizo" crossorigin="anonymous"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js" integrity="sha384-UO2eT0CpHqdSJQ6hJty5KVphtPhzWj9WO1clHTMGa3JDZwrnQq4sF86dIHNDz0W1" crossorigin="anonymous"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js" integrity="sha384-JjSmVgyd0p3pXB1rRibZUAYoIIy6OrQ6VrjIEaFf/nJGzIxFDsf4x0xIM+B07jRM" crossorigin="anonymous"></script>
</body>
</html>