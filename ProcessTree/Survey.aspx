<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Survey.aspx.cs" Inherits="ProcessTree.Survey" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Survey</title>    
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css"/>    
        <style type="text/css"> 
          
         
        .auto-style1 {
            height: 30px;
        }
                 
        .auto-style4 {
            font-size: large;
            color: #006600;
             text-align: justify;
        }         
           
        .auto-style6 {
                width: 51%;
                text-align: right;
                height: 20px;
            }         
         
        .auto-style7 {
            height: 1461px;
            width: 99%;
        }
        .auto-style12 {
            height: 39px;
        }
        .auto-style13 {
            height: 58px;
        }
        .auto-style17 {
            font-size: x-large;
        }
        .auto-style19 {
            height: 28px;
        }
        .auto-style20 {
            height: 34px;
        }
        .auto-style23 {
            font-style: italic;
            font-size: 1em;
            color: darkblue;
            font-weight: bold;
            border: solid #ccc 2px;
            border-radius: 5px;
            padding: 3px;
            width: 298px;
                height: 20px;
            }
        .auto-style24 {
            height: 50px;
        }
          
         
        .auto-style26 {
            font-size: large;
        }
        .auto-style27 {
            text-align: justify;
            padding: 10px;
            overflow: auto;
            font-size: large;
        }
        .auto-style28 {
            font-style: italic;
            font-size: medium;
            color: darkblue;
            font-weight: bold;
            border: solid #ccc 2px;
            border-radius: 5px;
            padding: 3px;
            width: 298px;
                height: 21px;
            }
          
         
            .auto-style29 {
                font-size: medium;
            }
          
         
            .auto-style30 {
                width: 29%;
                text-align: left;
                height: 21px;
            }
            .auto-style31 {
                width: 24%;
                text-align: right;
                height: 21px;
            }
          
         
            .auto-style32 {
                height: 32px;
            }
          
         
            .auto-style33 {
                height: 13px;
            }
          
         
        </style>

    <script src="Timer.js"></script>    
    <link href="StyleSheet.css" rel="stylesheet" type="text/css" />
</head>
<body style="height: 1813px">
    <form id="Survey" runat="server">
          <table id="TheTable" class="auto-style7">
                      
           
            <tr>
                <td class="auto-style30" ><asp:Label id="TimeSpan" runat="server" style="display: none"></asp:Label>
                    <em> <asp:Label ID="LabelLogin" runat="server" 
                    Text="Error! Please contact the admin: Law.Economist@Gmail.com" Font-Bold="True" ForeColor="Red" Font-Size="Large" CssClass="auto-style26"></asp:Label>                
                    </em>                
                </td>
                <td class="auto-style31" >
                    <asp:Label ID="DeadLineMessage" runat="server" Font-Bold="True" Text="The survey ends at " CssClass="auto-style29"></asp:Label>
                </td>
                <td id="DeadLine" class="auto-style28">                   
                    <script>
                        var TSpan = parseInt(document.getElementById("TimeSpan").textContent);
                        if (TSpan <=0)
                        {
                            document.write("Your Time Expired!");
                            // document.getElementById("Timer").innerHTML = "";
                        }
                        else
                        {
                            var ClientDeadLine = new Date((new Date()).getTime() + TSpan);
                            document.write(ClientDeadLine.toLocaleTimeString([], options));
                            CountDownTimer(ClientDeadLine, "Timer");
                        }
                    </script>
                </td>
            </tr>
            <tr>               
                <td class="auto-style6" colspan="2" >
                    <asp:Label ID="TimerMessage" runat="server" Font-Bold="True" Text="in about" CssClass="auto-style26"></asp:Label>
                </td>
                <td id="Timer" class="auto-style23">

                </td>
            </tr>

            <tr>
                <td  colspan="3" class="auto-style1">
                     
                    <em> &nbsp;</em><asp:Label ID="LabelBalance" runat="server" CssClass="auto-style4" ></asp:Label>                    
                    &nbsp;&amp; <asp:Label ID="LabelShare" runat="server" CssClass="auto-style4" ></asp:Label>                
                    &nbsp;                
        <asp:Label ID="LabelFinalBalance" runat="server" CssClass="auto-style4" Visible="False" ></asp:Label>                    
                </td>              
            </tr>        

              <tr>
                <td  colspan="3" class="auto-style33">           
                    </td>              
              </tr>

            <tr>
                <td  colspan="3" class="auto-style19"><strong><span class="auto-style26">1- The final outcome is as follows. Please rate it.</span></strong><br class="auto-style26" />
                    <em><span class="auto-style29">[1 = The worst possible outcome .... 10 = The best outcome with maximum profit]</span></em></td>              
            </tr>        

            <tr>
                <td  colspan="3" class="auto-style12">
                    <asp:RadioButtonList ID="RadioScore1" runat="server" RepeatDirection="Horizontal" Height="16px" CellPadding="5" CellSpacing="10" TextAlign="Left" TabIndex="20">
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
                </td>              
            </tr>        

            <tr>
                <td  colspan="3" class="auto-style1"><strong><em><span class="auto-style17">Final outcome :</span><span class="auto-style26"><br />
                                                          
                    </span>
                    </em></strong>
                    <span class="auto-style17">
                                                          
          <asp:Label ID="LabelArtifact" runat="server" BackColor="#FFFF99" CssClass="auto-style3" Font-Names="Times New Roman" Font-Size="Medium" Text="Please refresh the page! (Database is not accessable now)" Width="97%" TabIndex="2" style="font-size: medium" BorderColor="#FFFFCC" BorderStyle="Solid" BorderWidth="10px"  ></asp:Label>
                                
                    </span>
                </td>              
            </tr>        

            <tr>
                <td  colspan="3" class="auto-style32">&nbsp;</td>              
            </tr>        

            <tr>
                <td  colspan="3" class="auto-style32"><strong><span class="auto-style26">2- Please explain how you participated in the game and calculate your final payoff:</span></strong></td>              
            </tr>        

            <tr>
                <td  colspan="3" class="auto-style32"><asp:TextBox ID="Response2" runat="server" BackColor="#99CCFF" Height="125px" CssClass="auto-style27" style="direction: ltr" TextMode="MultiLine" TabIndex="10" Font-Names="Times New Roman" Font-Size="Large" Width="97%" BorderStyle="Inset" MaxLength="900">Minimum 80 characters</asp:TextBox>
    
                </td>              
            </tr>        

            <tr>
                <td  colspan="3" class="auto-style32">&nbsp;</td>              
            </tr>        

            <tr>
                <td  colspan="3" class="auto-style13">
                    <strong><span class="auto-style26">3- Was the game easy to follow?</span></strong><span style="mso-fareast-font-family:&quot;Times New Roman&quot;"><o:p><br class="auto-style26" />
                    <em><span class="auto-style29">[1 = No it was very confusing ..... 10 = Yes it was completely clear and easy to understand]</span></em></o:p></span></td>              
            </tr>        

            <tr>
                <td  colspan="3" class="auto-style24">
    
                    <asp:RadioButtonList ID="RadioScore3" runat="server" RepeatDirection="Horizontal" Height="16px" CellPadding="5" CellSpacing="10" TextAlign="Left" TabIndex="30">
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
    
                </td>              
            </tr>        

            <tr>
                <td  colspan="3" class="auto-style24"></td>              
            </tr>        

            <tr>
                <td  colspan="3" class="auto-style1"><strong><span class="auto-style26">4- How was the overall quality of the game and the website? </span> </strong> <br class="auto-style26" />
                    <em><span class="auto-style29">[1 = Very poor .... 10 = Very effective]</span></em></td>              
            </tr>        

            <tr>
                <td  colspan="3" class="auto-style1">
                    <asp:RadioButtonList ID="RadioScore4" runat="server" RepeatDirection="Horizontal" Height="16px" CellPadding="5" CellSpacing="10" TextAlign="Left" TabIndex="40">
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
                </td>              
            </tr>        

            <tr>
                <td  colspan="3" class="auto-style24">
    
                </td>              
            </tr>        

            <tr>
                <td  colspan="3" class="auto-style1"><strong><span class="auto-style26">5- Please describe your experience in this experiment. How can we improve it?</span></strong><br class="auto-style26" />
        <asp:TextBox ID="Response5" runat="server" BackColor="#99CCFF" Height="125px" CssClass="auto-style27" style="direction: ltr" TextMode="MultiLine" TabIndex="50" Font-Names="Times New Roman" Font-Size="Large" Width="97%" BorderStyle="Inset" MaxLength="900">Minimum 80 characters</asp:TextBox>
    
                </td>              
            </tr>        

              </table>

<u1:p class=""></u1:p>
          <p class="auto-style20" >
                                &nbsp;<asp:Button ID="BtnSubmitScore" runat="server" Font-Bold="True" onclick="BtnSubmitScore_Click" TabIndex="60" Text="Submit Answers" CssClass="auto-style29" />
                                <asp:Label ID="LabelMessage" runat="server" Font-Bold="True" ForeColor="Maroon" CssClass="auto-style26"></asp:Label>
                            </p>
    
    </form>
    <script src="https://code.jquery.com/jquery-3.3.1.slim.min.js" integrity="sha384-q8i/X+965DzO0rT7abK41JStQIAqVgRVzpbzo5smXKp4YfRvH+8abtTE1Pi6jizo" crossorigin="anonymous"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js" integrity="sha384-UO2eT0CpHqdSJQ6hJty5KVphtPhzWj9WO1clHTMGa3JDZwrnQq4sF86dIHNDz0W1" crossorigin="anonymous"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js" integrity="sha384-JjSmVgyd0p3pXB1rRibZUAYoIIy6OrQ6VrjIEaFf/nJGzIxFDsf4x0xIM+B07jRM" crossorigin="anonymous"></script>            
    </body>
</html>
