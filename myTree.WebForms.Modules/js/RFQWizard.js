/* Created by jankoatwarpspeed.com */
/* Edited lines 55-76 by Tattek for THEKAMAREL PROJECT */

var RootUrl = "";
if (!(location.hostname === "localhost" || location.hostname === "127.0.0.1" || location.hostname === "")) {

    RootUrl = "/Procurement";

}

(function ($) {
    function blockScreen() {
        jQuery.blockUI({ message: 'Loading', baseZ: 2000 });
        $("button").prop("disabled", true);
    }

    function unBlockScreen() {
        jQuery.unblockUI();
        $("button").prop("disabled", false);
    }

    $.fn.RFQWizard = function (options) {
        options = $.extend({
            submitButton: ""
        }, options);

        var element = this;

        var steps = $(element).find("fieldset");
        var count = steps.size();
        var submmitButtonName = "#" + options.submitButton;
        $(submmitButtonName).hide();

        // 2
        $(element).before("<ul id='steps'></ul>");

        steps.each(function (i) {
            $(this).wrap("<div id='step" + i + "'></div>");
            $(this).append("<p id='step" + i + "commands'></p>");

            // 2
            var name = $(this).find("legend").html();
            $("#steps").append("<li id='stepDesc" + i + "'>Step " + (i + 1) + "<span>" + name + "</span></li>");

            if (i == 0) {
                createCloseButton(i);
                createNextButton(i);
                selectStep(i);
            }
            else if (i == count - 1) {
                $("#step" + i).hide();
                createCloseButton(i);
                createPrevButton(i);
            }
            else {
                $("#step" + i).hide();
                createCloseButton(i);
                createPrevButton(i);
                createNextButton(i);
            }
        });

        function createCloseButton(i) {
            var stepName = "step" + i;
            $("#" + stepName + "commands").append("<a href='List.aspx' id='" + stepName + "Close' class='prev'>Close</a>");
        }

        function createPrevButton(i) {
            var stepName = "step" + i;
            $("#" + stepName + "commands").append("<a href='#' id='" + stepName + "Prev' class='prev'>< Back</a>");

            $("#" + stepName + "Prev").bind("click", function (e) {
                $("#" + stepName).hide();
                $("#step" + (i - 1)).show();
                $(submmitButtonName).hide();
                selectStep(i - 1);
                hideErrorMessage();
            });
        }

        function createNextButton(i) {
            var stepName = "step" + i;
            $("#" + stepName + "commands").append("<a href='#' id='" + stepName + "Next' class='next'>Next ></a>");

            $("#" + stepName + "Next").bind("click", function (e) {
                var errorMsg = "";
                hideErrorMessage();

                if (stepName === "step0") {
                    errorMsg = validatePR();
                }else if (stepName === "step1") {
                    dataRFQ0 = validateRFQ0();
                    errorMsg = dataRFQ0["errorMsg"];
                }

                if (errorMsg !== "") {
                    showErrorMessage(errorMsg);
                    return false;
                } else {
                    if (stepName === "step0") {
                        blockScreen();
                        //var prlines = [];
                        //$("[name='checkPR']:checkbox:checked").each(function () {
                        //    prlines.push($(this).val());
                        //});

                        var prlines = PRLineChecked;

                        $("#step2Data").html("");
                        $.ajax({
                            //url: '/Workspace/Procurement/RFQ/Wizard.aspx/GetItems',
                            /*url: "RFQ/Wizard.aspx/GetItems",*/
                            url: RootUrl+"/RFQ/Wizard.aspx/GetItems",
                            data: JSON.stringify({
                                subcategory: "",
                                cifor_office_id: $("#cboOffice").val(),
                                pr_line_id: prlines.join(";")
                            }),
                            dataType: 'json',
                            type: 'post',
                            contentType: "application/json; charset=utf-8",
                            success: function (response) {
                                _Items = JSON.parse(response.d);
                                GenerateBaseTable(_Items);
                                /*unBlockScreen();*/
                            }
                        });
                    }
                    else if (stepName === "step1") {
                        if (dataRFQ0["lessThanPR"] > 0) {
                            if (!confirm("RFQ quantity is less than PR quantity.\nDo you want to proceed?")) {
                                return;
                            }
                        }
                        var vendors = dataRFQ0["vendor"].join(",");
                        $.ajax({
                            url: RootUrl +"/Service.aspx/GetVendorContactPerson",
                            data: "{'vendors':'" + vendors + "'}",
                            dataType: 'json',
                            type: 'post',
                            contentType: "application/json; charset=utf-8",
                            success: function (response) {
                                listContact = JSON.parse(response.d);
                                ConfirmVendor(dataRFQ0["vendor"], listContact);
                                ConfirmItem(dataRFQ0["item"]);
                            }
                        });
                    }
                }
                /*$('#' + stepName + ' ' + 'fieldset :input').each(function () {
                    $(this).parsley('validate', function () {
                        if ($('#' + stepName + ' ' + ':input').hasClass('parsley-error')) {
                            return false;
                        }
                        else if ($('#' + stepName + ' ' + ':input').hasClass('parsley-success')) {
                            $("#" + stepName).hide();
                            $("#step" + (i + 1)).show();
                            if (i + 2 == count)
                                $(submmitButtonName).show();
                            selectStep(i + 1);
                        }
                    });
                });*/
                $("#" + stepName).hide();
                $("#step" + (i + 1)).show();
                if (i + 2 == count)
                    $(submmitButtonName).show();
                selectStep(i + 1);
            });
        }

        function selectStep(i) {
            $("#steps li").removeClass("current");
            $("#stepDesc" + i).addClass("current").prev().addClass('complete');

            $("#_startDate").data("validation", "");
            $("#_endDate").data("validation", "");
            $("#_document_date").data("validation", "");

            if (i == 0) {
                $("#_startDate").data("validation", "required");
                $("#_endDate").data("validation", "required");
                $("#_document_date").data("validation", "");
                $("[name='contact']").data("validation", "");
            }
            else if (i == 2) {
                $("#_startDate").data("validation", "");
                $("#_endDate").data("validation", "");
                $("#_document_date").data("validation", "required");
            }
        }

    }
})(jQuery); 