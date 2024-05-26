$(document).ajaxComplete(function myErrorHandler(event, xhr, ajaxOptions, thrownError) {
    if (xhr.status === 401) {
        alert("Your session has expired and myTree is going to refresh it. Please do not close your browser.");

        var redirectWindow = window.open('/Refresh.aspx', 'about:blank');
        redirectWindow.location;
        window.location;
        setTimeout(function () {
            redirectWindow.close();
        }, 90000);
        window.parent.focus();
        return;
    }
});