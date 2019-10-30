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

