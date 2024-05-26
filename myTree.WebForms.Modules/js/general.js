var APP_FOLDER = "Procurement";
var APP_URL = "https://my.cifor.org/";
var exclCostCenter = ["5903", "5904", "5905", "5906", "5907", "5908", "5934", "5942", "5973", "5980", "5990", "5991", "5992"];
var exclIDFundscheckPR = ["4159"];
var exclIDFundscheckPO = ["1066"];
RefreshURL = getBaseURL() + "Refresh.aspx";

$(document).ready(function () {
    PreventBackBrowser();
    $(".doc-notes").html(GetNotes("attachment", ""));
    $(".doc-notes-justification").html(GetNotes("attachment_justification", ""));
    $(".journal-notes").html(GetNotes("journal",""));
    $(".reference-notes").html(GetNotes("reference", ""));
    AlterLogoutLink();
    /*console.log(RefreshURL);*/
});

function PreventBackBrowser() {
    $(document).on("keydown", function (e) {
        if (e.which === 8 && !$(e.target).is("input, textarea")) {
            e.preventDefault();
        }
    });
}

function getBaseURL() {
    var url = location.href;  // entire url including querystring - also: window.location.href;
    var baseURL = url.substring(0, url.indexOf('/', 14));

    if (baseURL.indexOf('https://localhost') !== -1) {
        // Root Url for domain name
        return baseURL + "/";
    }
    else {
        // Root Url for domain name
        return baseURL + "/" + APP_FOLDER + "/";
    }
}

function siteURL() {
    var url = location.href;  // entire url including querystring - also: window.location.href;
    var baseURL = url.substring(0, url.indexOf('/', 14));

    var pathname = "";
    var index1 = "";
    var index2 = "";
    var moduleName = "";

    if (baseURL.indexOf('http://localhost') !== -1) {
        // Base Url for localhost
        location.href;  // window.location.href;
        pathname = location.pathname;  // window.location.pathname;
        index1 = url.indexOf(pathname);
        index2 = url.indexOf("/", index1 + 1);
        //var baseLocalUrl = url.substr(0, index2);

        return baseLocalUrl + "/";
    }
    else {
        // Root Url for domain name
        return baseURL + "/Workspace";
    }
}

function GeneralValidation() {
    var errorMsg = "";
    var countError = new Object();

    var regexemail = /^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;

    $("input,textarea,select,email,table.required").each(function () {
        if ($(this).is("table")) {
            var _tid = $(this).attr("id");
            if ($("#" + _tid + " tbody tr").length === 0 && $(this).is(":visible")) {
                errorMsg += "<br/>- " + $(this).data("title") + " is required.";
            }
        } else {
            if ($(this).prop("type") === "email") {

                if ($(this).val() !== "" && !regexemail.test($.trim($(this).val()))) {
                    errorMsg += "<br /> - Invalid format on " + $(this).data("title");
                }
            }
            if (typeof $(this).data("validation") !== "undefined") {
                if ($(this).data("validation").indexOf("required") !== -1
                    && (($.trim($(this).val()) === "" || typeof $(this).val() === "undefined" || $(this).val() === null)
                        || ($(this).data("validation").indexOf("number") !== -1 && delCommas($(this).val()) <= 0))
                    && $(this).attr("type") != "radio"
                    && typeof $(this).data("group") === "undefined"
                ) {
                    if (typeof countError[$(this).prop("name")] === "undefined") {
                        countError[$(this).prop("name")] = 1;
                    } else {
                        countError[$(this).prop("name")]++;
                    }
                    if (countError[$(this).prop("name")] === 1) {
                        errorMsg += "<br/>- " + $(this).data("title") + " is required.";
                    }
                }
                if ($(this).data("validation").indexOf("required") !== -1
                    && $(this).prop("type") == "radio" && $("[name='" + $(this).prop("name") + "']:checked").length == 0
                    && typeof $(this).data("group") === "undefined"
                ) {
                    if (typeof countError[$(this).prop("name")] === "undefined") {
                        countError[$(this).prop("name")] = 1;
                    } else {
                        countError[$(this).prop("name")]++;
                    }
                    if (countError[$(this).prop("name")] === 1) {
                        errorMsg += "<br/>- " + $(this).data("title") + " is required.";
                    }
                }
                if ($(this).data("validation").indexOf("unique") !== -1 && $.trim($(this).val()) !== "") {
                    if (typeof countError["arr_" + $(this).prop("name")] === "undefined") {
                        countError["arr_" + $(this).prop("name")] = [];
                        countError["arrCount_" + $(this).prop("name")] = 0;
                    }
                    if (countError["arr_" + $(this).prop("name")].indexOf($(this).val()) !== -1) {
                        countError["arrCount_" + $(this).prop("name")]++;
                    }
                    countError["arr_" + $(this).prop("name")].push($(this).val());
                    if (countError["arrCount_" + $(this).prop("name")] === 1) {
                        errorMsg += "<br/>- Cannot add the same " + $(this).data("title") + ".";
                    }
                }
                if (typeof $(this).data("maximum") !== "undefined" && $(this).data("maximum") !== "" && delCommas($(this).val()) > delCommas($(this).data("maximum"))) {
                    var attr = $(this).data("maximum-attr");
                    var custom = $(this).data("maximum-custom");

                    if (custom != "" && custom != null && typeof (custom) !== "undefined") {
                        errorMsg += "<br/>- Maximum " + custom + " is " + accounting.formatNumber($(this).data("maximum"), 2);
                    } else {
                        if (attr == "quantity") {
                            errorMsg += "<br/>- Maximum quantity for " + $(this).data("description") + " is " + accounting.formatNumber($(this).data("maximum"), 2);
                        } else if (attr == "discount") {
                            errorMsg += "<br/>- Maximum " + attr + " is " + accounting.formatNumber($(this).data("maximum")) + "%";
                        }
                    }
                }
                if ($(this).data("validation").indexOf("required") !== -1 && typeof $(this).data("group") !== "undefined" && $(this).data("validation-primary") == "yes" && $(this).attr("type") != "checkbox") {
                    var groupName = $(this).data("group");
                    var filledIn = 0;
                    $("[data-group='" + groupName + "']").each(function (i, data) {
                        if ($.trim($(this).val()) != "") {
                            filledIn++;
                        }
                    });
                    if (filledIn == 0) {
                        errorMsg += "<br/>- " + $(this).data("title") + " is required."; 
                    }
                }
                
                if ($(this).data("validation").indexOf("required") !== -1 && typeof $(this).data("group") !== "undefined" && $(this).data("validation-primary") == "yes"
                    && $(this).attr("type") == "checkbox" && $("[name='" + $(this).prop("name") + "']:checked").length == 0) {
                    var groupName = $(this).data("group");
                    var filledIn = 0;
                    $("[data-group='" + groupName + "']").each(function (i, data) {
                        console.log($(this).data("title"));
                        if ($(this).attr("type") != "checkbox") {
                            if ($.trim($(this).val()) == "") {
                                if (typeof countError[$(this).prop("name")] === "undefined") {
                                    countError[$(this).prop("name")] = 1;
                                } else {
                                    countError[$(this).prop("name")]++;
                                }
                                if (countError[$(this).prop("name")] === 1) {
                                    errorMsg += "<br/>- " + $(this).data("title") + " is required.";
                                }
                            }
                        }
                    });
                } else if ($(this).data("validation").indexOf("required") !== -1 && typeof $(this).data("group") !== "undefined" && $(this).data("validation-primary") == "yes"
                    && $(this).attr("type") == "checkbox" && $("[name='" + $(this).prop("name") + "']:checked").length == 1) {
                    var groupName = $(this).data("group");
                    var filledIn = 0;
                    $("[data-group='" + groupName + "']").each(function (i, data) {
                        console.log($(this).data("title"));
                        if ($(this).attr("type") == "text") {
                            if ($.trim($(this).val()) == "") {
                                if (typeof countError[$(this).prop("name")] === "undefined") {
                                    countError[$(this).prop("name")] = 1;
                                } else {
                                    countError[$(this).prop("name")]++;
                                }
                                if (countError[$(this).prop("name")] === 1) {
                                    errorMsg += "<br/>- " + $(this).data("title") + " is required.";
                                }
                            }
                        }
                    });
                }
            }
        }
    });

    return errorMsg;
}

function EmailValidation() {
    let errorMsg = "";
    let countError = new Object();

    let regexemail = /^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
    /*console.log($(this).val());*/
    $("input,textarea,select,email,table.required").each(function () {
        if ($(this).prop("type") === "email") {
            if ($(this).val() !== "" && !regexemail.test($.trim($(this).val()))) {
                errorMsg += "<br /> - Invalid format on " + $(this).data("title");
            }
        }
    });

    return errorMsg;
}

function generateCombo(obj, data, key, val, isPlaceholder) {
    var cbo = $(obj);

    if (isPlaceholder) {
        cbo.append("<option></option>");
    }

    $.each(data, function (i, d) {
        cbo.append("<option value='" + d[key] + "'>" + d[val] + "</option>");
    });
}

function generateComboGroup(obj, data, key, val, group_key, isPlaceholder) {
    var cbo = $(obj);
    var optGroup = [];

    $.each(data, function (i, d) {
        if (optGroup.indexOf(d[group_key]) === -1) {
            optGroup.push(d[group_key]);
        }
    });

    if (isPlaceholder) {
        cbo.append("<option></option>");
    }

    $.each(optGroup, function (i, group) {
        var html = "";
        html += '<optgroup label="' + group + '">';

        var arr = $.grep(data, function (n, i) {
            return n[group_key] === group;
        });

        $.each(arr, function (i, d) {
            html += "<option value='" + d[key] + "'>" + d[val] + "</option>";
        });
        html += "</optgroup>";
        cbo.append(html);
    });
}

function guid() {
    function s4() {
        return Math.floor((1 + Math.random()) * 0x10000).toString(16).substring(1);
    }
    return s4() + s4() + '-' + s4() + '-' + s4() + '-' + s4() + '-' + s4() + s4() + s4();
}

function showErrorMessage(errorMsg) {
    errorMsg = "Please correct the following error(s):" + errorMsg;

    $("#error-message").html("<b>" + errorMsg + "<b>");
    $("#error-box").show();
    errorMsg = '';

    var blankmode = getParameterByName("blankmode");
    if (blankmode == 1) {
        $('html, body').animate({ scrollTop: 0 }, 500);
    } else {
        window.parent.$('html, body').animate({ scrollTop: 0 }, 500);
    }

    return errorMsg;
}

function showFundsCheckMessage(errorMsg) {
    errorMsg = "Funds check result:" + errorMsg;

    $("#fundcheck-message").html("<b>" + errorMsg + "<b>");
    $("#fundcheck-box").show();
    errorMsg = '';

    var blankmode = getParameterByName("blankmode");
    if (blankmode == 1) {
        $('html, body').animate({ scrollTop: 0 }, 500);
    } else {
        window.parent.$('html, body').animate({ scrollTop: 0 }, 500);
    }

    return errorMsg;
}

function hideFundsCheckMessage() {
    $("#fundcheck-message").html("");
    $("#fundcheck-box").hide();
}

function hideErrorMessage() {
    $("#error-message").html("");
    $("#error-box").hide();
}

function Select2Obj(obj, placeholder) {
    $(obj).select2({
        placeholder: placeholder
    });
}

function CreateSubCategory(obj, category, val, endpoint) {
    $.ajax({
        /*url: 'Service.aspx/GetSubCategory',*/
        url: endpoint,
        data: "{'category':'" + category + "'}",
        dataType: 'json',
        type: 'post',
        contentType: "application/json; charset=utf-8",
        success: function (response) {
            var data = response.d;
            $(obj).empty();
            generateCombo(obj, data, "id", "text", true);
            $(obj).val(val);
            Select2Obj(obj, "Sub category");
        }
    });
}

function FileValidation() {
    var err = 0;
    var errMsg = "";
    var errNoExt = 0;
    var errDP = 0;
    $("input[type='file']").each(function (e) {
        //var tes = e.target.files[0].name;
        if (!IsValidFileName(this)) {
            if (err === 0) {
                errMsg += "<br> - Filename cannot contain any of the following character(s): \\ / : * ? \" < > | # & % '";
            }
            err++;
        }

        var fullPath = $(this).val();
        if (fullPath) {
            var filename = $(this)[0].files[0].name;
            var extension = getFileExtension(filename);
            if (extension == "") {
                if (errNoExt == 0) {
                    errMsg += "<br> - Filename must have an extension";
                }
                errNoExt++;
            }

            if (extension != "") {
                var sublength = extension.length + 2;
                var res = filename.substr(filename.length - (sublength));
                if (extension != "" && res == '..' + extension) {
                    if (errDP == 0) {
                        errMsg += "<br> - Filename cannot have more than one full stop";
                    }
                    errDP++;
                }
            }
        }
    });
    return errMsg;
}

function IsValidFileName(selector) {
    result = true;
    var fullPath = $(selector).val();
    if (fullPath) {
        var filename = $(selector)[0].files[0].name;
        //var startIndex = fullPath.indexOf('\\') >= 0 ? fullPath.lastIndexOf('\\') : fullPath.lastIndexOf('/');
        //var filename = fullPath.substring(startIndex);
        //if (filename.indexOf('\\') === 0 || filename.indexOf('/') === 0) {
        //    filename = filename.substring(1);
        //}
        var patternStr = /(#|&|'|<|>|\/|\*|\?|\\|\:|\"|\%|\|)/g;
        var result = filename.match(patternStr);

        result = result === null ? true : false;
    }
    return result;
}

function getFileExtension(name) {
    var found = name.lastIndexOf('.') + 1;
    return (found > 0 ? name.substr(found) : "");
}

function delCommas(str) {
    str = String(str);
    str = str.replace(/\,/g, "");
    return str === "" ? "" : parseFloat(str);
}

$(document).on("focus", ".number", function () {
    $(this).val(delCommas($(this).val()));
    var x = $(this).val();
    if (x === "0") { $(this).val(""); }
});

$(document).on("blur", ".number", function () {
    var decimalPlaces = $(this).data("decimal-places");
    $(this).val(accounting.formatNumber($(this).val(), decimalPlaces));
});

function repopulateNumber() {
    $(".number").each(function () {
        var decimalPlaces = $(this).data("decimal-places");
        $(this).val(accounting.formatNumber(delCommas($(this).val()), decimalPlaces));
    });
}

function GetNotes(notesType, link) {
    var msg = "";
    var mandatory = "<div class=\"filled info\">Mandatory supporting document(s) or other requirement(s).";
    var invoice_other_cgiar = "<ol style=\"margin-top:0px;margin-bottom:0px\"><li>Scanned copy of invoice(s).</li>";
    var others = "<ol style=\"margin-top:0px;margin-bottom:0px\"><li>Quotations or brochures (if any).</li>";
    var payment_one = "<ol style=\"margin-top:0px;margin-bottom:0px\"><li>Scanned copy of invoice(s) and/or screen capture of billing payment and hyperlinks.</li>";
    var subscription_one = "<ol style=\"margin-top:0px;margin-bottom:0px\"><li>Scanned copy of invoice(s) including bank account information.</li>";
    var direct_business_partner = "<ol style=\"margin-top:0px;margin-bottom:0px\"><li>Scanned copy of invoice(s) include bank account information.</li>";
    var reimbursement_one = "<ol style=\"margin-top:0px;margin-bottom:0px\"><li>Scanned copy of receipt(s).</li>";
    var cash_advance = "<ol style=\"margin-top:0px;margin-bottom:0px\"><li>Email approval of justification from Director of Corporate Service on the reason(s) of ";
    var cash_advance2 = "<ol style=\"margin-top:0px;margin-bottom:0px\"><li>Email approval of justification from Director General on the reason(s) of ";
    var justification_note = "<li>Please download the template for the justification from ";
    var email_approval_note = "<li>Email approval of justification from Director of Corporate Service on the reason(s) of ";
    var email_approval_note2 = "<li>Email approval of justification from Director General on the reason(s) of ";
    var email_approval_note_a = "<ol style=\"margin-top:0px;margin-bottom:0px\"><li type=\"a\">Purchasing without Purchase Order. </li>";    
    var email_approval_note_b = "<li type=\"a\">Purchasing from a single source. </li>";
    /*var note = "<li>Note: Purchase of goods valued less than USD 200 can be procured without purchase order. Justification (No. 2) is therefore not required.";*/
    var note = "";
    var reason = "<li>Emails clarifying reasons for self-purchasing.";
    var email_approval_note_new = "<li>Approval emails by Director of Corporate Services justifying the reasons for not using purchase orders and for selecting the vendor (Please download the template for the justification form ";
    var email_approval_note2_new = "<li>Approval emails by Director General justifying the reasons for not using purchase orders and for selecting the vendor (Please download the template for the justification form ";
    /*var cash_advance_note = "<li>Note: Purchase of goods valued less than USD 200 can be procured without purchase order. Justification (No. 1) is therefore not required. ";*/
    var cash_advance_note = "<li>Note: Purchase of goods valued less than USD 200 can be procured without purchase order. ";
    var cash_advance_new = "<ol style=\"margin-top:0px;margin-bottom:0px\"><li>Approval emails by Director of Corporate Services justifying the reasons for not using purchase orders and for selecting the vendor (Please download the template for the justification form ";
    var cash_advance2_new = "<ol style=\"margin-top:0px;margin-bottom:0px\"><li>Approval emails by Director General justifying the reasons for not using purchase orders and for selecting the vendor (Please download the template for the justification form ";

    var link_justification_200 = "<a href=\"" + link + "\" target=\"_blank\"><u>here</u></a>.";
    var link_justification_1000 = "<a href=\"" + link + "\" target=\"_blank\"><u>here</u></a>.";
    var link_justification_25000 = "<a href=\"" + link + "\" target=\"_blank\"><u>here</u></a>.";
    var link_justification_below_25000 = "<a href=\"" + link + "\" target=\"_blank\"><u>here</u></a>).";
    var link_justification_above_25000 = "<a href=\"" + link + "\" target=\"_blank\"><u>here</u></a>).";
    
    switch (notesType) {
        case "attachment":
            msg = "Filename cannot contain any of the following character(s): \\ / : * ? \" <> | # & % ' <br/> Maximum size of the file can be upload into the system is 30 MB <br/> Maximum description is 1,000 characters";
            break;
        case "attachment_justification":
            msg = "Filename cannot contain any of the following character(s): \\ / : * ? \" <> | # & % ' <br/> Maximum size of the file can be upload into the system is 30 MB <br/> Maximum description is 2,000 characters";
            break;
        case "journal":
            msg = "Journal number cannot contain any character and alphabet.";
            break;
        case "reference":
            msg = "Reference number cannot contain any character.";
            break;
        case "invoice_notes":
            msg = mandatory + invoice_other_cgiar + "</ol></div><br/>" ;
            break;
        case "direct_business_partner_notes":
            msg = mandatory + direct_business_partner + "</ol></div><br/>";
            break;
        case "others_notes":
            msg = $.trim(mandatory.replace("Mandatory supporting", "Supporting"));
            msg = msg.charAt(0).toUpperCase() + msg.substring(1);
            msg += others + "</ol></div><br/>" ;
            break;
        case "cash_advance":
            msg = mandatory.concat(cash_advance, email_approval_note_a, email_approval_note_b,"</ol></div><br/>");
            break;
        case "cash_advance_200_notes":
            msg = mandatory.concat(cash_advance, email_approval_note_a,  "</ol></li>", justification_note, link_justification_200, "</ol></div><br/>");
            break;
        case "cash_advance_1000_notes":
            msg = mandatory.concat(cash_advance, email_approval_note_a, email_approval_note_b, "</ol></li>", justification_note, link_justification_1000, "</ol></div><br/>");
            break;
        case "cash_advance_2500_notes":
            msg = mandatory.concat(cash_advance2, email_approval_note_a, email_approval_note_b, "</ol></li>", justification_note, link_justification_25000, "</ol></div><br/>");
            break;
        case "cash_advance_notes":
            msg = "Please also include the advance amount that you required.";
            break;
        case "payment_less_200_notes":
            msg += mandatory.concat(payment_one, "</ol></div><br/>");
            break;
        case "payment_200_notes":
            msg = mandatory.concat(payment_one, email_approval_note, email_approval_note_a, "</ol></li>", justification_note, link_justification_200, "</ol></div><br/>");
            break;
        case "payment_1000_notes":
            msg = mandatory.concat(payment_one, email_approval_note, email_approval_note_a, email_approval_note_b, "</ol></li>", justification_note, link_justification_1000, "</ol></div><br/>");
            break;
        case "payment_25000_notes":
            msg = mandatory.concat(payment_one, email_approval_note2, email_approval_note_a, email_approval_note_b, "</ol></li>", justification_note, link_justification_25000, "</ol></div><br/>");
            break;
        case "subs_less_200_notes":
            msg += mandatory.concat(subscription_one, "</ol></div><br/>");
            break;
        case "subs_200_notes":
            msg = mandatory.concat(subscription_one, email_approval_note, email_approval_note_a, "</ol></li>", justification_note, link_justification_200, "</ol></div><br/>");
            break;
        case "subs_1000_notes":
            msg = mandatory.concat(subscription_one, email_approval_note, email_approval_note_a, email_approval_note_b, "</ol></li>", justification_note, link_justification_1000, "</ol></div><br/>");
            break;
        case "subs_25000_notes":
            msg = mandatory.concat(subscription_one, email_approval_note2, email_approval_note_a, email_approval_note_b, "</ol></li>", justification_note, link_justification_25000, "</ol></div><br/>");
            break;
        case "reimburse_less_200_notes":
            msg += mandatory.concat(reimbursement_one, "</ol></div><br/>");
            break;
        case "reimburse_200_notes":
            msg = mandatory.concat(reimbursement_one, email_approval_note, email_approval_note_a, "</ol></li>", justification_note, link_justification_200, "</ol></div><br/>");
            break;
        case "reimburse_1000_notes":
            msg = mandatory.concat(reimbursement_one, email_approval_note, email_approval_note_a, email_approval_note_b, "</ol></li>", justification_note, link_justification_1000, "</ol></div><br/>");
            break;
        case "reimburse_25000_notes":
            msg = mandatory.concat(reimbursement_one, email_approval_note2, email_approval_note_a, email_approval_note_b, "</ol></li>", justification_note, link_justification_25000, "</ol></div><br/>");
            break;    
        /* edit by : Cahyadi 9/9/2020, only for <= 25000 and > 25000 */
        case "payment_below_25000_notes":
            /*msg = mandatory.concat(payment_one, email_approval_note_new, link_justification_below_25000, note, "</ol></div><br/>");*/
            /*msg = mandatory.concat(payment_one, link_justification_below_25000, note, "</ol></div><br/>");*/
            msg = mandatory.concat(payment_one, note, "</ol></div><br/>");
            break;
        case "subs_below_25000_notes":
            msg = mandatory.concat(subscription_one, "</ol></div><br/>");
            break;
        case "reimburse_below_25000_notes":
            /*msg = mandatory.concat(reimbursement_one, email_approval_note_new, link_justification_below_25000, reason, note, "</ol></div><br/>");*/
            /*msg = mandatory.concat(reimbursement_one, link_justification_below_25000, "</ol></div><br/>");*/
            msg = mandatory.concat(reimbursement_one, "</ol></div><br/>");
            break;
        case "cash_advance_below_25000_notes":
            /*msg = mandatory.concat(cash_advance_new, link_justification_below_25000, reason, cash_advance_note, "</ol></div><br/>");*/
            /*msg = mandatory.concat(cash_advance_note, link_justification_below_25000, "</ol></div><br/>");*/
            msg = mandatory.concat(cash_advance_note, "</ol></div><br/>");
            break;
        case "direct_payment_below_25000_notes":
            /*msg = mandatory.concat(invoice_other_cgiar, link_justification_below_25000, note, "</ol></div><br/>");*/
            msg = mandatory.concat(invoice_other_cgiar, note, "</ol></div><br/>");
            break;
        case "payment_above_25000_notes":
            msg = mandatory.concat(payment_one, email_approval_note2_new, link_justification_above_25000, "</ol></div><br/>");
            break;
        case "subs_above_25000_notes":
            msg = mandatory.concat(subscription_one, "</ol></div><br/>");
            break;
        case "reimburse_above_25000_notes":
            msg = mandatory.concat(reimbursement_one, email_approval_note2_new, link_justification_above_25000, reason, "</ol></div><br/>");
            break;
        case "cash_advance_above_25000_notes":
            msg = mandatory.concat(cash_advance2_new, link_justification_above_25000, reason, "</ol></div><br/>");
            break;
        default:
            break;
    }
    return msg;
}

function NormalizeString(str) {
    return str.replace(new RegExp('\'', 'g'), '&apos;').replace(new RegExp('"', 'g'), '&quot;');
}

function blockScreen() {
    jQuery.blockUI({ message: 'Loading', baseZ: 2000 });
    $("button").prop("disabled", true);
}

function unBlockScreen() {
    jQuery.unblockUI();
    $("button").prop("disabled", false);
}

function blockScreenOL() {
    jQuery.blockUI({ message: 'Loading', baseZ: 2000 });
}

function unBlockScreenOL() {
    jQuery.unblockUI();
}

function unique(array) {
    return $.grep(array, function (el, index) {
        return index == $.inArray(el, array);
    });
}

function normalizeMultilines() {
    $(".multilines").each(function () {
        $(this).html($(this).text().replace(/\r?\n/g, '<br />'));
    });
}

function getParameterByName(name, url) {
    if (!url) url = window.location.href;
    name = name.replace(/[\[\]]/g, '\\$&');
    var regex = new RegExp('[?&]' + name + '(=([^&#]*)|&|#|$)'),
        results = regex.exec(url);
    if (!results) return null;
    if (!results[2]) return '';
    return decodeURIComponent(results[2].replace(/\+/g, ' '));
}

function isNumberKey(evt) {
    var charCode = (evt.which) ? evt.which : event.keyCode
    if (charCode > 31 && (charCode < 48 || charCode > 57))
        return false;
    return true;
} 

$.fn.uploadValidation = function (callback) {
    var result = {
        notfound: [],
        found: [],
        status: "",
        status_code: 0,
        not_found_message: ""
    };

    var jqueryObj = $(this);
    if (jqueryObj.length > 0) {
        var p1 = new Promise(function (resolve, reject) {
            var filesReady = jqueryObj.filter(function () {
                return (this.files !== null && this.files.length > 0);
            });

            // all files empty
            if (filesReady.length == 0) {
                resolve();
            } else {
                filesReady.each(function (i, o) {
                    var f = this.files[0];
                    var r = new FileReader();
                    r.onload = function (e) {
                        result.found.push(f.name);
                    }
                    r.onerror = function (e) {
                        result.notfound.push(f.name);
                    }
                    r.onloadend = function () {
                        if (i === (filesReady.length - 1)) {
                            resolve();
                        }
                    }
                    r.readAsArrayBuffer(f);
                });
            }
        });
        p1.then(function () {
            if (result.notfound.length > 0) {
                result.not_found_message = "<br> - File not found:";
                $.each(result.notfound, function (i, o) {
                    result.not_found_message += "<br>\xa0\xa0 \u2022 " + o;
                });
            }
            callback(result);
        });
    } else {
        result.status = "JQuery selector not found";
        result.status_code = 1;
        callback(result);
    }
}

function CheckAlphabhetNumeric(alphanumber){
    result = true;
    if (alphanumber) {
        var patternStr = /^[a-zA-Z0-9]+$/;
        var result = alphanumber.match(patternStr);

        result = result === null ? true : false;
    }
    return result;
}

function sleep(ms) {
    return new Promise(resolve => setTimeout(resolve, ms));
}

function AlterLogoutLink() {
    // Get HTML last index profile menu
    var x = $('#ProfileMenu li a').last();
    var logoutUrl = window.location.origin + "/Procurement/Logout.aspx"
    $(x).attr("href", logoutUrl);
}

function CheckFilterStartEndDate(startDate, endDate) {
    result = true;

    if (startDate > endDate) {
        result = false;
    }

    return result;
}

function closeAllModal() {
    $('.modal').modal('hide');
}

function GetProduct(endpoint) {
    let objProduct = null;
    $.ajax({
        /*url: 'Service.aspx/GetSubCategory',*/
        url: endpoint,
        /*data: "{'category':'" + category + "'}",*/
        dataType: 'json',
        type: 'post',
        contentType: "application/json; charset=utf-8",
        success: function (response) {
            var data = response.d;
            //console.log(response);
            //console.log(data);
            objProduct = response;
            console.log(objProduct);
        }
    });
    console.log(objProduct);
    return objProduct;
}

function RecursiveHtmlDecode(str) {
    if (!str) { str = ""; }
   return new DOMParser().parseFromString(str, "text/html").documentElement.textContent;
}

function AddDetailSundrySupplierHTML(company_name, sundry_supplier_id, index,qa_id,module) {
    var html = "";
    html += '<tr>'
        + '<td>Sundry </td>'
        + '<td>' + company_name
        if (module == "quotationanalysis") {
            html += '<input type="hidden" name="sundry.id" value="' + sundry_supplier_id + '" data-vendor="' + index + '" data-qa-id = "' + qa_id + '" >'
        } else {
            html += '<input type="hidden" name="sundry.id" value="' + sundry_supplier_id + '" data-index="' + index + '">';
        }
        html += '</td>'
        + '</tr>'
        + '<tr>'
        + '<td>Name <span style="color: red;">*</span></td>'
        + '<td>'
        + '<div class="">'
        + '<div class="">'
        + '<input type="text" name="sundry.name" maxlength="255" placeholder="Name" value="" class="span12"/>'
        + '</div>'
        + '</div>'
        + '</td>'
        + '</tr>'
        //
        + '<tr>'
        + '<td>Contact person <span style="color: red;">*</span></td>'
        + '<td>'
        + '<div class="">'
        + '<div class="">'//
        + '<input type="text" name="sundry.contact_person" maxlength="250" placeholder="Contact person" value="" class="span12"/>'
        + '</div>'
        + '</div>'
        + '</td>'
        + '</tr>'
        //
        //
        + '<tr>'
        + '<td>Email <span style="color: red;">*</span></td>'
        + '<td>'
        + '<div class="">'
        + '<div class="">'//
        + '<input type="email" name="sundry.email" maxlength="250" placeholder="Email" data-title="email" value="" class="span12"/>'
        + '</div>'
        + '</div>'
        + '</td>'
        + '</tr>'
        //
        //
        + '<tr>'
        + '<td>Phone number <span style="color: red;">*</span></td>'
        + '<td>'
        + '<div class="">'
        + '<div class="">'//
        + '<input type="text" name="sundry.phone_number" maxlength="250" placeholder="Phone number" value="" class="span12"/>'
        + '</div>'
        + '</div>'
        + '</td>'
        + '</tr>'
        //
        + '<tr>'
        + '<td>Bank account</td>'
        + '<td>'
        + '<div class="">'
        + '<div class="">'
        + '<input type="text" name="sundry.bank_account" maxlength="35" placeholder="Bank account" value="" class="span12"/>'
        + '</div>'
        + '</div>'
        + '</td>'
        + '</tr>'
        + '<tr>'
        + '<td>Swift</td>'
        + '<td>'
        + '<div class="">'
        + '<div class="">'
        + '<input type="text" name="sundry.swift" maxlength="11" placeholder="Swift" value="" class="span12"/>'
        + '</div>'
        + '</div>'
        + '</td>'
        + '</tr>'
        + '<tr>'
        + '<td>Sort code</td>'
        + '<td>'
        + '<div class="">'
        + '<div class="">'
        + '<input type="text" name="sundry.sort_code" maxlength="13" placeholder="Sort code" value="" class="span12"/>'
        + '</div>'
        + '</div>'
        + '</td>'
        + '</tr>'
        + '<tr>'
        + '<td>Address</td>'
        + '<td>'
        + '<textarea name="sundry.address"  maxlength="160" rows="10" placeholder="address" class="span12"></textarea>'
        + '<div class="mt-1" style="font-size: 80%; font-style: italic; display: block;">Maximum description is 160 characters</div>'
        + '</td>'
        + '</tr>'
        + '<tr>'
        + '<td>Place <span style="color: red;">*</span></td>'
        + '<td>'
        + '<div class="">'
        + '<div class="">'
        + '<input type="text" name="sundry.place" maxlength="40" placeholder="Place" value="" class="span12"/>'
        + '</div>'
        + '</div>'
        + '</td>'
        + '</tr>'
        + '<tr>'
        + '<td>Province</td>'
        + '<td>'
        + '<div class="">'
        + '<div class="">'
        + '<input type="text" name="sundry.province" maxlength="40" placeholder="Province" value="" class="span12"/>'
        + '</div>'
        + '</div>'
        + '</td>'
        + '</tr>'
        + '<tr>'
        + '<td>Post code</td>'
        + '<td>'
        + '<div class="">'
        + '<div class="">'
        + '<input type="text" name="sundry.post_code" maxlength="15" placeholder="Post code" value=""class="span12"/>'
        + '</div>'
        + '</div>'
        + '</td>'
        + '</tr>'
        + '<tr>'
        + '<td>VAT RegNo</td>'
        + '<td>'
        + '<div class="">'
        + '<div class="">'
        + '<input type="text" name="sundry.vat_reg_no" maxlength="25" placeholder="VAT RegNo"  value=""class="span12"/>'
        + '</div>'
        + '</div>'
        + '</td>'
        + '</tr>';

    return html;
}