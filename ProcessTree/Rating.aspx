<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Rating.aspx.cs" Inherits="ProcessTree.Rating" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Rating Score</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css"/>
    <style type="text/css"> 
          
         
        .auto-style1 {
            height: 30px;
        }
        .auto-style2 {
            width: 60%;
        }
          
         
        .auto-style4 {
            font-size: large;
            color: #006600;
             text-align: justify;
        }
          
         
           
        .auto-style6 {
            width: 60%;
            text-align: right;
        }
          
         
        .auto-style9 {
            font-family: Times, serif;
            font-size: large;
        }
        .auto-style10 {
            font-size: large;
        }
          
         
        .auto-style11 {
            height: 835px;
        }
          
         
        </style>

    <script src="Timer.js"></script>    
    <link href="StyleSheet.css" rel="stylesheet" type="text/css" />
</head>
<body>
    <form id="Rating" runat="server" class="auto-style11">
          <table id="TheTable">
            <tr>
                <td class="auto-style2" > <em> <asp:Label ID="LabelLogin" runat="server" 
                    Text="Error! Please contact the admin: Law.Economist@Gmail.com" Font-Bold="True" ForeColor="Red" Font-Size="Large"></asp:Label>                
                    </em>                
                </td>
                <td class="questions">
                    <asp:Button ID="BtnSignOut" runat="server" OnClick="BtnSignOut_Click" Text="Sign Out" TabIndex="9"/>    
                </td>     
            </tr>
            <tr>
                <td class="auto-style2" >
        <asp:Label ID="LabelBalance" runat="server" CssClass="auto-style4" >Your Balance = $0.00</asp:Label>                    
                </td>
                 <asp:Label id="TimeSpan" runat="server" style="display: none"></asp:Label>              
            </tr>
           
            <tr>
                <td class="auto-style6" >
                    <asp:Label ID="DeadLineMessage" runat="server" Font-Bold="True" Text="Please submit your scores before:"></asp:Label>
                </td>
                <td id="DeadLine" class="time">                   
                    <script>
                        var TSpan = parseInt(document.getElementById("TimeSpan").textContent);
                        if (TSpan <=0)
                        {
                            document.write("Your Time Expired!");
                            // document.getElementById("Timer").innerHTML = "";
                        }
                        else
                        {
                            var ClientDeadLine = new Date(new Date().getTime() + TSpan);
                            document.write(ClientDeadLine.toLocaleTimeString([], options));
                            CountDownTimer(ClientDeadLine, "Timer");
                        }
                    </script>
                </td>
            </tr>
            <tr>               
                <td class="auto-style6" >
                    <asp:Label ID="TimerMessage" runat="server" Font-Bold="True" Text="in about"></asp:Label>
                </td>
                <td id="Timer" class="time">

                </td>
            </tr>

            <tr>
                <td  colspan="2" class="auto-style1"></td>              
            </tr>        
              </table>
          <p class="MsoNormal">
              <span class="auto-style9">Please</span><span style="font-family: &quot;Times&quot;,serif; mso-fareast-font-family: &quot;Times New Roman&quot;; background: ghostwhite" class="auto-style10"><span style="background-position:initial initial;
background-repeat:initial initial"> assume that we have $100k in cash that we want to invest on some stocks as a stock portfolio<span style="background-position:initial initial;
background-repeat:initial initial"> to sell in one year for the largest return considering the risk.</span></span></span><span class="auto-style10"> </span><span style="font-family: &quot;Times&quot;,serif; mso-fareast-font-family: &quot;Times New Roman&quot;; background: ghostwhite" class="auto-style10"><span style="background-position:initial initial;
background-repeat:initial initial">To this end, all publicly traded companies in the global stock market are acceptable.</span></span></p>

<u1:p class=""></u1:p><u1:p class="">  
        <br />
                     
          <em>
                     
        <asp:Label ID="Label" runat="server" Font-Bold="True" Font-Size="X-Large" Text="Initial Edition:"></asp:Label>
          <br />
          </em>
        <asp:TextBox ID="txtArtifact" runat="server" BackColor="#FFEE88" Height="292px" CssClass="justified" ReadOnly="True" style="direction: ltr" TextMode="MultiLine" TabIndex="1" Font-Names="Times New Roman" Font-Size="Large" Width="97%">Please refresh the page! (Database is not accessable now)</asp:TextBox>
    
        <h2>
            <asp:Label ID="LabelRate" runat="server" Font-Size="Medium" Text="How effective is this edition? Please give your rating score based on the following criteria: &lt;br&gt;&lt;br&gt; 1 =  Not Effective : It does not have any effect on people's behavior at all. &lt;br&gt; 10 = Highly Effective  : It has the maximum possible effect and completely accomplishes its purpose."></asp:Label>
            &nbsp;</h2>
        <div>
                    <asp:RadioButtonList ID="RadioScore" runat="server" RepeatDirection="Horizontal" Height="16px" CellPadding="5" CellSpacing="10" OnSelectedIndexChanged="RadioScore_SelectedIndexChanged" TextAlign="Left" AutoPostBack="True" TabIndex="2">
                        <asp:ListItem>1</asp:ListItem>
                        <asp:ListItem Value="2"></asp:ListItem>
                        <asp:ListItem>3</asp:ListItem>
                        <asp:ListItem>4</asp:ListItem>
                        <asp:ListItem>5</asp:ListItem>
                        <asp:ListItem>6</asp:ListItem>
                        <asp:ListItem>7</asp:ListItem>
                        <asp:ListItem>8</asp:ListItem>
                        <asp:ListItem>9</asp:ListItem>
                        <asp:ListItem Value="10">10</asp:ListItem>
                    </asp:RadioButtonList>
        </div>
        <p >
                                &nbsp;<asp:Button ID="BtnSubmitScore" runat="server" Enabled="False" Font-Bold="True" onclick="BtnSubmitScore_Click" TabIndex="3" Text="Submit Score" />
                                <asp:Label ID="LabelMessage" runat="server" Font-Bold="True" ForeColor="Maroon"></asp:Label>
                            </p>
    
    </form>
    <script src="https://code.jquery.com/jquery-3.3.1.slim.min.js" integrity="sha384-q8i/X+965DzO0rT7abK41JStQIAqVgRVzpbzo5smXKp4YfRvH+8abtTE1Pi6jizo" crossorigin="anonymous"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js" integrity="sha384-UO2eT0CpHqdSJQ6hJty5KVphtPhzWj9WO1clHTMGa3JDZwrnQq4sF86dIHNDz0W1" crossorigin="anonymous"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js" integrity="sha384-JjSmVgyd0p3pXB1rRibZUAYoIIy6OrQ6VrjIEaFf/nJGzIxFDsf4x0xIM+B07jRM" crossorigin="anonymous"></script>            
    </body>
</html>
