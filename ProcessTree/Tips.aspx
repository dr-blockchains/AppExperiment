<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Tips.aspx.cs" Inherits="ProcessTree.Tips" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Visual Directions</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css"/>    
    <style type="text/css">
    
        .auto-style8 {
            text-align: center;
            min-width: 700px;
            max-width: 1500px;
            width: 70%;
            margin:auto;
        }
        .auto-style9 {
            font-size: xx-large;
            font-weight: bold;
        }
        .auto-style10 {
            font-size: x-large;
        }
        .auto-style12 {
            font-size: x-large;
            font-weight: bold;
            color: #660066;
        }
        .auto-style13 {
            font-size: x-large;
            color: #660066;
        }
        </style>
</head>
<body>
    <form id="form1" runat="server" style="text-align:center">   
        <div class="auto-style8">
            <br />
                <asp:Image ID="Image1" runat="server" ImageUrl="~/Images/GroupDecision.jpg" Width="80%" />
            <br />
            <br />
            <hr />
            <br />
            <p style="text-align: left" class="auto-style12">TimeLine:</p>            
                <asp:Image ID="Image4" runat="server" ImageUrl="~/Images/Process.jpeg" Width="100%" />
            <br />
            <br />
            <hr />
            <br />
            <p style="text-align: left" class="auto-style12">Perfromance of one Portfolio (One Choice):</p>                            
            <br class="auto-style10" />
            <p style="text-align: left">
                <span class="auto-style10"><em>Example: If on Jan 1</em></span><sup><span class="auto-style10"><em>st</em></span></sup><span class="auto-style10"><em>  the mutual fund invests 30% of its cash on coin A and 70% on coin B, then on Feb 1</em></span><sup><span class="auto-style10"><em>st</em></span></sup><span class="auto-style10"><em> this is the amount it will have:
            </em>
            </span>
            </p>
            <br />
            <br />
                <asp:Image ID="Image3" runat="server" ImageUrl="~/Images/Formula.PNG" Width="90%" />                     
            <br />
            <br />
            <br />
            <hr />
             <br />
            <p style="text-align: left" class="auto-style12">Share Value (for Each Choice):</p>                                        
            <br />
                <asp:Image ID="Image6" runat="server" ImageUrl="~/Images/ShareValue.JPG" Width="90%" />                     
            <br />
            <br />
            <br />
            <hr />
            <br />
                <p style="text-align: left" class="auto-style12">The Prices:</p>
            <br />            
            <asp:Image ID="Image5" runat="server" ImageUrl="~/Images/Prices.jpg" Width="100%" />            
            <br />
            <hr />
            <br />
                <p style="text-align: left" class="auto-style9">&nbsp;</p>
            <p style="text-align: left" class="auto-style9"><span class="auto-style13">How to Navigate </span> <a href="https://coinmarketcap.com/" target = "_blank"><span class="auto-style10">CoinMarketCap.com</span></a>:</p>  
            <br />
            <br />
            <asp:Image ID="Image2" runat="server" ImageUrl="~/Images/CoinMarketCap.png" Width="100%" />     
        </div>     
    </form>
    <script src="https://code.jquery.com/jquery-3.3.1.slim.min.js" integrity="sha384-q8i/X+965DzO0rT7abK41JStQIAqVgRVzpbzo5smXKp4YfRvH+8abtTE1Pi6jizo" crossorigin="anonymous"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js" integrity="sha384-UO2eT0CpHqdSJQ6hJty5KVphtPhzWj9WO1clHTMGa3JDZwrnQq4sF86dIHNDz0W1" crossorigin="anonymous"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js" integrity="sha384-JjSmVgyd0p3pXB1rRibZUAYoIIy6OrQ6VrjIEaFf/nJGzIxFDsf4x0xIM+B07jRM" crossorigin="anonymous"></script>
</body>
</html>
