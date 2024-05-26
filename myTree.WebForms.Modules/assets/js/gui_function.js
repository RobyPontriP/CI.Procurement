function popupSelect(id, data) {
    eval("window.opener." + data.callback + "(id, data);");
}