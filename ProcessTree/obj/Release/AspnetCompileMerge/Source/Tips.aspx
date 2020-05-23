<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Tips.aspx.cs" Inherits="ProcessTree.Tips" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <style type="text/css">
        .auto-style7 {
            text-align: center;
        }
        .auto-style8 {
            text-align: left;
        }
        .auto-style9 {
            font-size: xx-large;
            font-weight: bold;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
     
        <div class="auto-style8">
            <br />
            <p style="text-align: center" class="auto-style9">Helpful Directions</p>            
            * This is the flow diagram of the game:<br />
            <br />
            <div class ="auto-style7">
                <asp:Image ID="Image5" runat="server" ImageUrl="~/Images/Process.png" Width="90%" />
            </div>            
            <br />
            <br />
            * Please have a calculator or Excel sheet ready. You may use your smartphone if you like!<br />
            <br />
            * Please use this formula to calculate the increase in wealth&nbsp; from one trade:&nbsp;&nbsp; NewWealth =&nbsp; OldWealth * (SellPrice)/(BuyPrice)<br />
            <br />
            * Please use this formula to cacluate the increase in wealth from multiple trades:
            &nbsp;&nbsp;&nbsp;<br />
&nbsp;&nbsp;&nbsp;&nbsp; NewWealth =&nbsp; OldWealth * (SellPriceX)/(BuyPriceX)* (SellPriceY)/(BuyPriceY)* (SellPriceZ)/(BuyPriceZ)<br />
            <br />
            *Please suggest your plan in this format:
            <br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; On&nbsp; [<em>Date1</em>]&nbsp; Buy&nbsp; [<em>XXX</em>]&nbsp; @&nbsp; [<em>Price1</em>]&nbsp;
            <br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; On&nbsp; [<em>Date2</em>]&nbsp; Sell&nbsp; [<em>XXX</em>]&nbsp; @&nbsp; [<em>Price2</em>]&nbsp; <br />
            <strong>
            <br />
            * Please see the following tips to use <a href="https://finance.yahoo.com/most-active/" target = "_blank">Yahoo.Finance</a> better:</strong><br />
            <br />
        </div>
        <div class="auto-style7">
            <asp:Image ID="Image2" runat="server" ImageUrl="~/Images/Start.JPG" Width="90%" />
            <br />
            <br />
            <hr />
            <br />
            <br />
            <asp:Image ID="Image1" runat="server" ImageUrl="~/Images/Basics.png" Width="90%" />
            <br />
            <br />
            <hr />            
            <br />
            <br />
            <asp:Image ID="Image3" runat="server" ImageUrl="~/Images/Scale.png" Width="90%" />
            <br />
            <br />
            <hr />
            <br />
            <br />
            <asp:Image ID="Image4" runat="server" ImageUrl="~/Images/Compare.png" Width="90%" />
            <br />
            <br />
        </div>
     
    </form>
</body>
</html>
