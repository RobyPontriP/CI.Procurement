$(document).ready(function () {
    PreventBackBrowser();
    validateChange();
});

function validateChange(obj_selector) {
    obj_selector = typeof obj_selector !== "undefined" ? obj_selector : "textarea, :text";

    $(obj_selector).on("focus", function () {
        _oldVal = this.value;
    });

    $(obj_selector).on("blur", function () {
        var str = this.name;
        var elementClass = $(this).attr("class");
        if (elementClass.toLowerCase().indexOf("typeofchangegroup") >= 0) {
            return;
        }

        if (str.toLowerCase().indexOf("comment") < 0) {
            if (_oldVal != this.value) {
                if (!confirm("Are you sure?")) {
                    this.value = _oldVal;
                }
            }
        }
    });
}

function PreventBackBrowser() {
    $(document).on("keydown", function (e) {
        if (e.which === 8 && !$(e.target).is("input, textarea")) {
            e.preventDefault();
        }
    });
}

function changeChosen(obj, evt, params, _oldVal) {
    if (_oldVal != "") {
        var conf = confirm("Are you sure?");
        if (!conf) {
            $(obj).val(_oldVal).trigger("chosen:updated");
        }
    }
    $(obj).data("previous", params.selected);
}


