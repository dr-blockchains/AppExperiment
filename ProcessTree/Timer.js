if (("Notification" in window) && (Notification.permission === 'default')) {
    Notification.requestPermission().then(function (result) { });
}

function notify(message) {
    if (!("Notification" in window)) {
        alert(message);
    } else {
        switch (Notification.permission) {
            case 'denied':
                alert(message);
                break;

            case 'granted':
                var notification = new Notification(message);
                break;

            case 'default':
            default:
                Notification.requestPermission().then(function (result) {
                    if (result === 'granted') {
                        var notification = new Notification(message);
                    } else {
                        alert(message);
                    }
                });
                break;
        }
    }
}

function CountDownTimer(dline, id) {

    var end = new Date(dline);

    var _second = 1000;
    var _minute = _second * 60;
    var _hour = _minute * 60;
    var _day = _hour * 24;
    var timer = 0; 

    function showRemaining() {
        var now = new Date();
        var distance = end - now;
        if (distance < 0) {

            clearInterval(timer);
            var currentPage = window.location.href;
            window.location.href = currentPage;
            // document.location.reload();

            return;
        }
        var days = Math.floor(distance / _day);
        var hours = Math.floor((distance % _day) / _hour);
        var minutes = Math.floor((distance % _hour) / _minute);
        var seconds = Math.floor((distance % _minute) / _second);

        document.getElementById(id).innerHTML = (days == 0)? " " : days == 1 ? "1 day " : (days + " days ");
        document.getElementById(id).innerHTML += (hours == 0)? " " : ((days > 0) ? ", " : "") + (hours==1? "1 hour ":(hours + " hours "));
        document.getElementById(id).innerHTML += (days > 0 || minutes == 0)? " " : ((hours > 0) ? ", " : "") + (minutes==1? "1 minute ":(minutes + " minutes "));
        document.getElementById(id).innerHTML += (days > 0 || hours > 0 )? "" : (((minutes > 0)?", ":"") + seconds + " seconds");
    }

    timer = setInterval(showRemaining, 1000);
}

//var options = { month: "long", day: "numeric", hour: "2-digit", minute: "2-digit", hour12: true, timeZoneName: "long" };
var options = { hour: "2-digit", minute: "2-digit", hour12: true, timeZoneName: "long" };

function DShare2All() {
    Message.innerHTML = " ";
    shares1 = Number(StartShares.innerHTML);
    StartPrice.innerHTML = (shares1 == 0 ? "0 (It will rise as you buy shares)" : (shares1 / 100).toFixed(2) );

    dshare = Number(DeltaShares.value);
    if (dshare <= 0 || dshare > 10000) {
        Message.innerHTML = "Number of shares is out of range!";
        dshare = NaN;
    }

    const SelectedRadio = document.querySelector("input[name='Position']:checked").value;

    if (SelectedRadio == "Buy") {

        shares2 = shares1 + dshare;
        dfund = Math.round(dshare * (shares1 + shares2)) / 200;

        const avfund = Number(AvFund.innerHTML);
        if (dfund > avfund) {
            Message.innerHTML = ("You only have $" + avfund + " !");
        }

    } else { // Sell
        if (dshare > shares1) {
            dshare = shares1;
            DeltaShares.value = dshare;
            Message.innerHTML = ("There are only " + shares1 + " shares!  ");
        }
        shares2 = shares1 - dshare;
        dfund = dshare * (shares1 + shares2) / 200.0;

        const avshare = Number(AvShare.innerHTML);
        if (dshare > avshare) {
            Message.innerHTML += ("<br>You only have " + avshare + " shares!");
        }
    }

    DeltaFund.value = dfund.toFixed(2);

    AveragePrice.innerHTML = ((shares1 + shares2) / 200.0).toFixed(2);
    EndPrice.innerHTML = (shares2 / 100.0).toFixed(2);
    EndShares.innerHTML = shares2.toFixed(2);
}

function DFund2All() {
    Message.innerHTML = " ";
    const shares1 = Number(StartShares.innerHTML);
    StartPrice.innerHTML = (shares1 == 0 ? "0 (It will rise as you buy shares)" : (shares1 / 100).toFixed(2));

    let dfund = Number(DeltaFund.value);
    if (dfund <= 0 || dfund > 1000) {
        Message.innerHTML = "Amount of fund is out of range!"
        dfund = NaN;
    }

    let SelectedRadio = document.querySelector("input[name='Position']:checked").value;

    if (SelectedRadio == "Buy") {
        shares2 = Math.sqrt(shares1 * shares1 + 200.0 * dfund);
        dshare = shares2 - shares1;

        const avfund = Number(AvFund.innerHTML);
        if (dfund > avfund) {
            Message.innerHTML = ("You only have $" + avfund + " !");
        }

    } else { // Sell

        if (200 * dfund > shares1 * shares1) {
            dfund = shares1 * shares1 / 200;
            DeltaFund.value = dfund;
            Message.innerHTML = ("There is only $" + dfund + " of total funds!  ");
        }

        shares2 = Math.round(Math.sqrt(shares1 * shares1 - 200.0 * dfund) * 100) / 100;
        dshare = shares1 - shares2;

        const avshare = Number(AvShare.innerHTML);
        if (dshare > avshare) {
            Message.innerHTML += ("You only have " + avshare + " shares!");
        }
    }

    DeltaShares.value = dshare.toFixed(2);

    AveragePrice.innerHTML = ((shares1 + shares2) / 200.0).toFixed(2);
    EndPrice.innerHTML = (shares2 / 100.0).toFixed(2);
    EndShares.innerHTML = shares2.toFixed(2);
}

function RadioClick() {
    //const SelectedRadio = document.querySelector("input[name='Position']:checked").value;
    const SelectedRadio = $('#<%= RadioOrder.ClientID %> input[type=radio]:checked').val();

    if (SelectedRadio == "Buy") {
        DeltaFund.focus();
       
        PlaceOrder.value = "Buy Shares";
        BuySell.innerHTML = "Buy";

        //Order.style.backgroundColor = "lightgreen";
        // document.getElementById("PlaceOrder").innerHTML = "Buy Shares";
        // document.getElementById("PlaceOrder").style.backgroundColor = "lightgreen";
        // document.getElementById("AutoFill").style.backgroundColor = "lightgreen";
        // document.getElementById("DeltaShares").style.backgroundColor = "lightgreen";
        // document.getElementById("DeltaFund").style.backgroundColor = "lightgreen";
        // document.getElementById("AveragePrice").style.backgroundColor = "lightgreen";
        // document.getElementById("EndPrice").style.backgroundColor = "lightgreen";
        // document.getElementById("EndShares").style.backgroundColor = "lightgreen";
        // document.getElementById("RadioButton").style.backgroundColor = "lightgreen";

    } else {
        DeltaShares.focus();

        PlaceOrder.value = "Sell Shares";
        BuySell.innerHTML = "Sell";

        //Order.style.backgroundColor = "pink";
        // document.getElementById("PlaceOrder").innerHTML = "Sell Shares";
        // document.getElementById("PlaceOrder").style.backgroundColor = "pink";
        // document.getElementById("AutoFill").style.backgroundColor = "pink";
        // document.getElementById("DeltaShares").style.backgroundColor = "pink";
        // document.getElementById("DeltaFund").style.backgroundColor = "pink";
        // document.getElementById("AveragePrice").style.backgroundColor = "pink";
        // document.getElementById("EndPrice").style.backgroundColor = "pink";
        // document.getElementById("EndShares").style.backgroundColor = "pink";
        // document.getElementById("RadioButton").style.backgroundColor = "pink";
    }
    if (LastChange.innerHTML == 'F') {
        DFund2All();
    } else {
        DShare2All();
    }
}

function AutoFill_Click() {

    const SelectedRadio = document.querySelector("input[name='Position']:checked").value;
    if (SelectedRadio == "Buy") {
        DeltaFund.value = AvFund.innerHTML;
        DFund2All();
    } else {
        DeltaShares.value = AvShare.innerHTML;
        DShare2All();
    }
}