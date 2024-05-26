<%@ Page Async="true" MasterPageFile="~/Procurement.Master" Language="C#" AutoEventWireup="true" CodeBehind="Input.aspx.cs" Inherits="myTree.WebForms.Modules.PurchaseRequisition.Input" %>

<%@ Register Src="~/Usc/uscRecentComment.ascx" TagName="recentcomment" TagPrefix="uscComment" %>
<%@ Register Src="uscPREdit.ascx" TagName="predit" TagPrefix="uscPREdit" %>
<%@ Register Src="~/Usc/uscCancellationForm.ascx" TagName="cancellationform" TagPrefix="uscCancellation" %>

<asp:Content ID="Content1" ContentPlaceHolderID="AppHead" runat="server">
    <title><%=submission_page_name%> Submission</title>
    <style>
        .select2 {
            min-width: 150px !important;
        }

        #CancelForm.modal-dialog {
            margin: auto 12% !important;
            width: 60% !important;
            height: 320px !important;
        }

        .custom-file-label {
            display: inline-block;
            margin-bottom: 5px;
            margin-left: 5px;
            font-size: 12px;
        }

        .hiddenRow {
            padding: 0 !important;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="AppBody" runat="server">
    <div class="floatingBox" id="error-box" style="display: none">
        <div class="alert alert-error" id="error-message">
        </div>
    </div>

    <div class="floatingBox" id="fundcheck-box" style="display: none">
        <div class="filled info" id="fundcheck-message">
        </div>
    </div>
    <%--<%if(approval_notes != null && !string.IsNullOrEmpty(approval_notes.activity_desc)) {  %>
    <div class="alert alert-info" id="approval-notes">
        <%=approval_notes.activity_desc %>
    </div>
    <%}%>--%>
    <!-- Recent comment -->
    <uscComment:recentcomment ID="recentComment" runat="server" />

    <!-- Cancellation Form -->
    <uscCancellation:cancellationform ID="cancellationForm" runat="server" />

    <div class="containerHeadline">
        <h2>Purchase requisition information(s)</h2>
    </div>
    <div class="row-fluid">
        <div class="floatingBox">
            <div class="container-fluid">
                <!-- PR editable -->
                <uscPREdit:predit ID="predit1" runat="server" />
                <input type="hidden" id="sn" value="<%=sn %>" />
                <input type="hidden" id="activity_id" value="<%=activity_id %>" />
                <input type="hidden" id="accessToken" value="<%=strAccessToken %>" />
                <div class="control-group last">
                    <div class="controls">
                        <button id="btnClose" class="btn" type="button">Close page</button>&nbsp;&nbsp;&nbsp;
                        <button id="btnSave" class="btn btn-success" data-action="saved" data-type="_general" type="button">Save as draft</button>
                        <button id="btnSubmit" class="btn btn-success" data-action="submitted" data-type="_general" type="button">Submit</button>
                        <button id="btnFundsCheck" class="btn btn-success" data-action="fundscheck" type="button">Funds check</button>
                        <button id="btnCancel" class="btn btn-danger" type="button" data-action="cancelled">Cancel this PR</button>
                    </div>
                </div>
                <div id="inputhide" style="display: none;">
                </div>
            </div>
        </div>
    </div>
    <script>
        var taskType = "<%=taskType%>";
        let listProduct = <%=listProduct%>;
        var is_revision = "<%=is_revision%>";
        var isAllowed = "<%=isAllowed%>";
        var sn = "<%=sn%>";
        var id_submission_page_type = "<%=id_submission_page_type%>";
        var activityId = "<%=activity_id%>";
        var btnAction = "";
        var workflow = new Object();
        var errorMsgFundsCheck = "";
        var filenameupload = "";
        var btnFileUpload = null;
        var arrobjProduct = null;
        var objProduct = listProduct;
        var isChangeType = "";

        if ($("#status").val() == "10" || $("#status").val() == "90" || $("#status").val() == "5") {
            isChangeType = "1";
        }

        if (id_submission_page_type == "1") {
            listPRType = $.grep(listPRType, function (n, i) {
                return n["value"] == "3";
            });
        } else {
            listPRType = $.grep(listPRType, function (n, i) {
                return n["value"] != "3";
            });
        }

        $(document).ready(function () {
            $('#btnChangePurchaseType').attr("data-page", id_submission_page_type);

            if ($("#status").val() == "") {
                $("#btnCancel").remove();
            }

            if (id_submission_page_type == "1") {
                $('#btnChangePurchaseType').html($('#btnChangePurchaseType').html() + ' Finance');
            } else {
                $('#btnChangePurchaseType').html($('#btnChangePurchaseType').html() + ' Procurement');
            }

            if (isChangeType == "1") {
                $('#btnChangePurchaseType').show();
            }
        });

        $(document).on("click", "#btnClose", function () {
            if (taskType == "admin") {
                location.href = "Tasklist.aspx";
            } else if (taskType == "adminteam") {
                location.href = "Tasklist.aspx?action=team";
            } else {
                location.href = "/workspace";
            }
        });

        $(document).on("click", "#btnCancel", function () {
            $("#CancelForm").modal("show");
        });

        $(document).on("click", ".btnFileUploadCancel", function () {
            $("#action").val("fileupload");
            btnFileUpload = this;

            $("#file_name").val($(this).closest("div").find("input:file").val().split('\\').pop());
            /*var filename = $("#file_name").val();*/

            filenameupload = $("#file_name").val();

            if (!$("#file_name").val()) {
                alert("Please choose file first");
                return false;
            } else {
                let errorMsg = FileValidation();
                if (FileValidation() !== '') {
                    $("#cform-error-message").html("<b>" + "- Supporting document(s):" + "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" + errorMsg + "<b>");
                    $("#cform-error-box").show();
                    $('.modal-body').animate({ scrollTop: 0 }, 500);

                    return false;
                }

                $("input[name='doc_id']").val($("[name='pr.id']").val());
                UploadFileAPI("");
                $(this).closest("div").find("input[name$='cancellation.uploaded']").val("1");
                $(this).closest("div").find("input[name$='cancellation_file']").css({ 'background-color': '' });
                /*GenerateCancelFileLink(this, filenameupload);*/
            }
        });

        $(document).on("click", "#btnFundsCheck", function () {

            var fundsCheckChargeCodes = [];
            errorMsgFundsCheck = '';

            btnAction = $(this).data("action").toLowerCase();

            sleep(1).then(() => {
                blockScreenOL();
                /*GetDataProductFC();*/
            });

            sleep(300).then(() => {
                GetDataProductFC();
                <%--if (PRDetail.length > 0) {
                    PRDetail.forEach(function (item) {
                        item.costCenters.forEach(function (chargeCode) {
                            arrobjProduct = $.grep(objProduct, function (n, i) {
                                return n["Id"] == item.item_code;
                            });
                            var chargeCodeFC = new Object();
                            chargeCodeFC.id = chargeCode.id;
                            chargeCodeFC.pr_id = chargeCode.pr_id;
                            chargeCodeFC.pr_detail_id = chargeCode.pr_detail_id;
                            chargeCodeFC.sequence_no = chargeCode.sequence_no;
                            chargeCodeFC.cost_center_id = chargeCode.cost_center_id;
                            chargeCodeFC.work_order = chargeCode.work_order;
                            chargeCodeFC.entity_id = chargeCode.entity_id;
                            chargeCodeFC.legal_entity = chargeCode.legal_entity;
                            chargeCodeFC.control_account = arrobjProduct[0].BudgetAccount;
                            chargeCodeFC.percentage = chargeCode.percentage;
                            chargeCodeFC.amount = chargeCode.amount;
                            chargeCodeFC.amount_usd = chargeCode.amount_usd;
                            chargeCodeFC.remarks = chargeCode.remarks;
                            chargeCodeFC.is_active = chargeCode.is_active;
                            chargeCodeFC.cost_center_name = chargeCode.cost_center_name;
                            chargeCodeFC.work_order_name = chargeCode.work_order_name;
                            chargeCodeFC.entity_name = chargeCode.entity_name;
                            chargeCodeFC.is_trigger_audit = chargeCode.is_trigger_audit;

                            fundsCheckChargeCodes.push(chargeCodeFC);
                            console.log(chargeCodeFC);
                        });
                    });
                    
                    errorMsgFundsCheck += FundsCheck(fundsCheckChargeCodes, errorMsgFundsCheck, $("[name='pr.id']").val());

                    if (errorMsgFundsCheck !== "") {
                        showErrorMessage(errorMsgFundsCheck);
                    } else {
                        alert('Budget is sufficient');
                    }

                    
                } else {
                    alert('please fill product first');
                }
                unBlockScreenOL();--%>
                }).then(() => {
                });


            });

        var uploadValidationResult = {};
        $(document).on("click", "#btnSave,#btnSubmit,#btnSaveCancellation", function () {
            sleep(1).then(() => {
                blockScreenOL();
                GetDataProduct();
            });

            sleep(300).then(() => {
                var thisHandler = $(this);
                var filedoctype = thisHandler.data("type");
                hideFundsCheckMessage();

                if (!$.trim($("[name='pr.direct_to_finance_justification']").val())) {
                    $("[name=cancellation_file],[name=direct_to_finance_file],[name=filename" + filedoctype + "]").uploadValidation(function (result) {

                        uploadValidationResult = result;
                        //onBtnClickSave.call(thisHandler);
                    });
                } else {
                    $("[name=cancellation_file],[name=filename" + filedoctype + "]").uploadValidation(function (result) {

                        uploadValidationResult = result;
                        //onBtnClickSave.call(thisHandler);
                    });

                }
                onBtnClickSave.call(thisHandler);

            }).then(() => {
                /*   unBlockScreenOL();*/
            });
        });

        var onBtnClickSave = function () {
            btnAction = $(this).data("action").toLowerCase();

            workflow.sn = $("#sn").val();
            workflow.activity_id = $("#activity_id").val();
            workflow.access_token = $("#accessToken").val();
            workflow.action = btnAction;
            workflow.comment = $("[name='comments']").val();
            workflow.IsProcOffChangedDuringResubmit = isPOFFChangedDuringResubmission;

            $("[name='is_cancel']").val("");

            if (btnAction == "cancelled") {
                errorMsg = "";
                if ($.trim($("#cancellation_text").val()) == "" && $.trim($("#cancellation_file").val()) == "") {
                    errorMsg += "<br/> - Reason for cancellation is required.";
                }

                if ($("input[name='cancellation.uploaded']").val() == "0" && $("input[name='cancellation_file']").val()) {
                    $("input[name='cancellation_file']").css({ 'background-color': 'rgb(245, 183, 177)' });
                    errorMsg += "<br/> - Please upload file first.";
                }

                errorMsg += FileValidation();

                if (errorMsg != "") {
                    unBlockScreenOL();
                    errorMsg = "Please correct the following error(s):" + errorMsg;

                    $("#cform-error-message").html("<b>" + errorMsg + "<b>");
                    $("#cform-error-box").show();
                    $('.modal-body').animate({ scrollTop: 0 }, 500);
                    return false;
                } else {
                    workflow.comment = $("#cancellation_text").val();
                    workflow.comment_file = $("#cancellation_file").val();
                }
                if ($("#status").val() != "5") {
                    $("[name='is_cancel']").val("1");
                }
            }
            SubmitValidation();
        };

        function SubmitValidation() {
            var errorMsg = "";
            errorMsg += uploadValidationResult.not_found_message || '';
            var data = new Object();
            data.id = $("[name='pr.id']").val();
            data.status_id = $("#status").val();
            data.requester = $("[name='pr.requester']").val();
            data.required_date = $("[name='pr.required_date']").val();
            data.cifor_office_id = $("[name='pr.cifor_office_id']").val();
            data.cost_center_id = $.trim($("[name='pr.cost_center_id']").val());
            data.t4 = $.trim($("[name='pr.t4']").val());
            var t4_name = $("[name='pr.t4']").select2('data');
            if (t4_name) {
                data.t4_name = t4_name[0].text;
            }
            data.remarks = $("[name='pr.remarks']").val();
            data.currency_id = $("[name='pr.currency_id']").val();
            data.exchange_sign = $("[name='pr.exchange_sign']").val();
            data.exchange_rate = delCommas($("[name='pr.exchange_rate']").val());
            data.total_estimated = delCommas($("#GrandTotal").text());
            data.total_estimated_usd = delCommas($("#GrandTotalUSD").text());
            data.details = PRDetail;
            data.is_revision = is_revision;
            data.is_procurement = $("[name='pr.is_procurement']").val();
            data.purchase_type = $("[name='pr.purchase_type']").val();
            data.temporary_id = $("[name='docidtemp']").val();
            data.id_submission_page_type = id_submission_page_type;
            /*if (data.purchase_type == "1" || data.purchase_type == "4" || data.purchase_type == "5") {*/

            //if (data.purchase_type != "3" && data.total_estimated_usd > 200) {
            //    data.direct_to_finance_justification = $("[name='pr.direct_to_finance_justification']").val();
            //    data.direct_to_finance_file = $("[name='pr.direct_to_finance_file']").val();
            //}
            if (data.purchase_type != "3" && data.total_estimated_usd > 200) {
                data.direct_to_finance_justification = $("[name='pr.direct_to_finance_justification']").val();
                if ($("input[name='justification.uploaded']").val() == "1") {
                    data.direct_to_finance_file = $("[name='pr.direct_to_finance_file']").val();
                }
            }
            if (data.purchase_type != "3" && data.purchase_type != "5") {
                data.purchasing_process = "1";
            }

            if (data.total_estimated_usd > 200) {
                if (_purchase_type != data.purchase_type) {
                    data.is_procurement = data.purchase_type != "3" && data.purchase_type != "5" ? "1" : "0";
                }
            }

            data.attachments_general = [];
            var errFile = 0;
            var errDesc = 0;
            var errUpload = 0;
            var msgFile = "";
            let isFileGeneralMandatory = true;

            if (delCommas($("#GrandTotalUSD").text()) <= 200) {
                if ($("[name='pr.purchase_type']").val() == "5" || $("[name='pr.purchase_type']").val() == "3") {//5 3
                    isFileGeneralMandatory = false;
                }
            } else if (delCommas($("#GrandTotalUSD").text()) > 200) {
                if ($("[name='pr.purchase_type']").val() == "3") {
                    isFileGeneralMandatory = false;
                }
            }

            $("#tblAttachmentGeneral tbody tr").each(function () {
                var _att = new Object();
                _att["id"] = $(this).find("input[name='attachment.id']").val();
                _att["filename"] = $(this).find("input[name='attachment.filename_general']").val();
                _att["file_description"] = $(this).find("input[name='attachment.file_description']").val();

                if ($.trim(_att["filename"]) == "" && errFile == 0 && isFileGeneralMandatory == true) {
                    msgFile += "<br/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- File is required.";
                    errFile++;
                }
                if ($.trim(_att["file_description"]) == "" && errDesc == 0 && isFileGeneralMandatory == true) {
                    msgFile += "<br/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- Description is required.";
                    errDesc++;
                }
                if ($(this).find("input[name='attachment.uploaded']").val() == "0" && isFileGeneralMandatory == true) {
                    $(this).css({ 'background-color': 'rgb(245, 183, 177)' });
                    if ($.trim(_att["filename"]) != "") {
                        errUpload++;
                    }
                    _att["filename"] = "";
                } else {
                    _att["filename"] = $(this).find("input[name='attachment.filename_general']").val();
                }
                data.attachments_general.push(_att);
                //attachment.uploaded
                //if ($(this).find("input[name='attachment.uploaded']").val() == "0") {
                //    $(this).css({ 'background-color': 'rgb(245, 183, 177)' });
                //    if (!errorMsg) {
                //        errorMsg += "<br/> - There are files that have not been uploaded, please upload first.";
                //    } 
                //}
            });

            if (errUpload > 0) {
                msgFile += "<br/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- There are files that have not been uploaded, please upload first.";
            }

            //justification.uploaded
            if (($("input[name='justification.uploaded']").val() == "0" && ($("[name='pr.purchase_type']").val() != "3")) && !$.trim($("[name='pr.direct_to_finance_justification']").val())) {
                if ($.trim($("[name='direct_to_finance_file']").val())) {
                    errorMsg += "<br/> - There are justification files that have not been uploaded, please upload first.";
                    $("input[name='direct_to_finance_file']").css({ 'background-color': 'rgb(245, 183, 177)' });
                }
            }

            errorMsg += FileValidation();

            if (btnAction == "submitted") {
                // FundsChecking 

                var fundsCheckChargeCodes = [];
                var errorMsgFundsCheck = ""
                //debugger;
                data.details.forEach(function (item) {
                    item.costCenters.forEach(function (chargeCode) {
                        arrobjProduct = $.grep(objProduct, function (n, i) {
                            return n["Id"] == item.item_code;
                        });
                        var chargeCodeFC = new Object();
                        chargeCodeFC.id = chargeCode.id;
                        chargeCodeFC.pr_id = chargeCode.pr_id;
                        chargeCodeFC.pr_detail_id = chargeCode.pr_detail_id;
                        chargeCodeFC.sequence_no = chargeCode.sequence_no;
                        chargeCodeFC.cost_center_id = chargeCode.cost_center_id;
                        chargeCodeFC.work_order = chargeCode.work_order;
                        chargeCodeFC.entity_id = chargeCode.entity_id;
                        chargeCodeFC.legal_entity = chargeCode.legal_entity;
                        chargeCodeFC.control_account = arrobjProduct[0].BudgetAccount;
                        chargeCodeFC.product_account = chargeCode.control_account;
                        chargeCodeFC.percentage = chargeCode.percentage;
                        chargeCodeFC.amount = chargeCode.amount;
                        chargeCodeFC.amount_usd = chargeCode.amount_usd;
                        chargeCodeFC.remarks = chargeCode.remarks;
                        chargeCodeFC.is_active = chargeCode.is_active;
                        chargeCodeFC.cost_center_name = chargeCode.cost_center_name;
                        chargeCodeFC.work_order_name = chargeCode.work_order_name;
                        chargeCodeFC.entity_name = chargeCode.entity_name;
                        chargeCodeFC.is_trigger_audit = chargeCode.is_trigger_audit;

                        fundsCheckChargeCodes.push(chargeCodeFC);
                        //console.log(chargeCodeFC);
                    });
                });
                errorMsg += FundsCheck(fundsCheckChargeCodes, errorMsg, data.id);
                errorMsg += GeneralValidation();
                if (msgFile !== "") {
                    errorMsg += "<br> - Supporting document(s):" + msgFile;
                }
            }

            if (errorMsg !== "") {
                unBlockScreenOL();
                showErrorMessage(errorMsg);
                return false;
            } else {
                var _data = {
                    "submission": JSON.stringify(data),
                    "deletedIds": JSON.stringify(deletedId),
                    "workflows": JSON.stringify(workflow)
                };
                Submit(_data);
            }
        }

        function Submit(_data) {
            /*blockScreen();*/
            $.ajax({
                url: 'Input.aspx/Save',
               <%-- url: '<%= Page.ResolveUrl("~/Input.aspx/Save") %>',--%>
                    data: JSON.stringify(_data),
                    dataType: 'json',
                    type: 'post',
                    contentType: "application/json; charset=utf-8",
                    success: function (response) {
                        var output = JSON.parse(response.d);
                        if (output.result !== "success") {
                            alert(output.message);
                            if (output.result == "errorwf") {
                                location.href = "/workspace";
                            }
                        } else {
                            if (output.id !== "") {
                                $("input[name='doc_id']").val(output.id);
                                //$("input[name='action']").val("upload");
                                //UploadFile();

                                $("#action").val("fileupload");
                                UploadFileAPI("submit");
                            }
                        }
                    },
                    error: function (jqXHR, exception) {
                        if (jqXHR.status == 401) {
                            //alert('Session is ended. Please relogin.');
                        }
                        else {
                            alert('Error on submit/save Purchase Requisiton data. Please call administrator.');
                        }

                        //location.href = "/AccessDenied";
                    }
                });
        }

        function UploadFile() {
            var form = $('form')[0];
            var formData = new FormData(form);

            $.each($(form).find('input[type="file"]'), function () {
                var name = $(this).attr('name');
                var files = $(this).prop('files');

                if (files.length == 0) {
                    formData.set(name, null);
                }
            });

            $.ajax({
                type: "POST",
                processData: false,
                contentType: false,
                <%--url: "<%=service_url%>",--%>
                    url: '<%= Page.ResolveUrl("~/" + based_url+service_url + "") %>',
                    data: formData,
                    success: function (response) {
                        var stringJS = '{' + response.substring(
                            response.indexOf("{") + 1,
                            response.lastIndexOf("}")
                        ) + '}';
                        var output = JSON.parse(stringJS);

                        if (output.result !== "success") {
                            alert(output.message);
                        } else {
                            alert("Request has been " + btnAction + " successfully.");
                            blockScreen();
                            if (btnAction === "saved") {
                                if ($("[name='pr.id']").val() == "") {
                                    location.href = "input.aspx?id=" + output.id + "&submission_page_type=" + id_submission_page_type;
                                } else {
                                    location.reload();
                                }
                                /*if (workflow.sn != "") {
                                    location.href = "input.aspx?id=" + output.id + "&sn=" + workflow.sn;
                                } else {
                                    location.href = "input.aspx?id=" + output.id;
                                }*/
                            } else {//
                                location.href = "/workspace/mysubmissions";/*"/workspace/My-Submissions.aspx";*/
                            }
                        }
                    }
                });
        }

        function UploadFileAPI(actionType) {
            /*blockScreen();*/
            if (actionType == '') {
                blockScreenOL();
            }

            var form = $('form')[0];
            var formData = new FormData(form);

            $.ajax({
                type: "POST",
                <%--url: "<%=service_url%>",--%>
                    url: '<%= Page.ResolveUrl("~/" +based_url+ service_url + "") %>',
                    data: formData,
                    processData: false,
                    contentType: false,
                    success: function (response) {
                        if (actionType == '') {
                            unBlockScreenOL();
                        }
                        var stringJS = '{' + response.substring(
                            response.indexOf("{") + 1,
                            response.lastIndexOf("}")
                        ) + '}';
                        var output = JSON.parse(stringJS);

                        if (actionType != "submit") {
                            if (output.result == '') {
                                if ($(btnFileUpload).data("type") == 'filecancel') {
                                    GenerateCancelFileLink(btnFileUpload, filenameupload);
                                } else {
                                    GenerateFileLink(btnFileUpload, filenameupload);
                                }
                            } else {
                                alert('Upload file failed');
                            }

                        } else {
                            alert("Request has been " + btnAction + " successfully.");
                            if (btnAction === "saved") {
                                if ($("[name='pr.id']").val() == "") {
                                    location.href = "input.aspx?id=" + output.id + "&submission_page_type=" + id_submission_page_type;
                                } else {
                                    location.reload();
                                }
                            } else {
                                location.href = "/workspace/mysubmissions";/*"/workspace/My-Submissions.aspx";*/
                            }
                        }
                    },
                    error: function (jqXHR, exception) {
                        alert('Upload file failed');
                        unBlockScreenOL();
                    }


                });
            $("#file_name").val("");
        }

        function FundsCheck(chargeCodes, errMessage, prId) {
            if (btnAction == 'fundscheck') {
                blockScreenOL();
            }
            var params = [];
            let appSource = [];
            var prIdStr = "";

            let isExcludeCC = false;
            let isExcludeID = false;

            if (!prId)
                prIdStr = "";
            else
                prIdStr = prId;


            chargeCodes.forEach(function (item) {
                var chargeCode = {
                    Costc: item.cost_center_id,
                    Workorder: item.work_order,
                    Entity: item.entity_id,
                    Account: item.control_account,
                    Amount: parseFloat(item.amount_usd),
                    ProductAccount: item.product_account
                };

                //exclCostCenter
                isExcludeCC = exclCostCenter.includes(item.cost_center_id);
                isExcludeID = exclIDFundscheckPR.includes($("[name='pr.id']").val());

                if (isExcludeCC == false && isExcludeID == false) {
                    params.push(chargeCode);

                    let sourceid_temp = "";

                    if (id_submission_page_type == "2") {
                        sourceid_temp = item.pr_id;
                    } else {
                        sourceid_temp = item.pr_id + '.' + item.pr_detail_id;
                    }

                    let appSourceTemp = {
                        SourceId: item.pr_id + '.' + item.pr_detail_id,
                        SourceName: 'Procurement'
                    };

                    appSource.push(appSourceTemp);
                }
            });
            appSource = [...new Map(appSource.map(item => [item['SourceId'], item])).values()];

            $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                url: '<%= Page.ResolveUrl("~/" + based_url+service_url + "/FundsCheck") %>',
                    async: false,
                    /*data: JSON.stringify({ data: [{ Data: params, ApplicationId: prIdStr, ApplicationSource: "Procurement" }] }),*/
                    data: JSON.stringify({ data: [{ Data: params, ApplicationSource: appSource }] }),
                    dataType: "json",
                    success: function (response) {
                        var result = JSON.parse(response.d);
                        if (result.success == true && result.status == "200") {
                            result.data.forEach(function (item) {
                                if (item.Result == false) {
                                    let accountProd = '';

                                    params.forEach(function (itemP) {
                                        if (itemP.Costc == item.Costc && itemP.Workorder == item.WorkOrder && itemP.Entity == item.Entity) {
                                            accountProd += itemP.ProductAccount + ",";
                                        }
                                    });

                                    if (params.length > 0) {
                                        errMessage += "<br> - The budget for Cost center : " + item.Costc + ", Work order: " + item.WorkOrder + ", Entity : " + item.Entity + ", Account : " + accountProd.slice(0, -1) + ", Budget account : " + item.Account + " has exceeded by USD " + accounting.formatNumber(item.Amount * -1, 2);
                                    }                            
                                }
                                //else {
                                //    if (btnAction == 'fundscheck') {
                                //        alert('Budget is sufficient');
                                //    }
                                //}

                                /*fundscheckresult = item.Result;*/
                            });
                        } else {
                            errMessage += "<br> - " + result.additionalInfo;
                        }
                        if (btnAction == 'fundscheck') {
                            unBlockScreenOL();
                        }
                    },
                    error: function (jqXHR, exception) {
                        /*unBlockScreenOL();*/
                    }
                });
            return errMessage;
        }

        function sleep(ms) {
            return new Promise(resolve => setTimeout(resolve, ms));
        }

        function GenerateFileLink(row, filename) {//nyari datatype cancel
            var pr_id = '';
            var linkdoc = '';

            if ($("[name='pr.id']").val() == '' || $("[name='pr.id']").val() == null) {
                pr_id = $("[name='docidtemp']").val();
                linkdoc = "FilesTemp/" + pr_id + "/" + filename + "";
            } else {
                pr_id = $("[name='pr.id']").val();
                linkdoc = "Files/" + pr_id + "/" + filename + "";
            }

            if ($(row).data("type") == "_general") {
                $(row).closest("tr").find("input[name$='filename_general']").hide();
            } else if ($(row).data("type") == "file_justification") {
                $(row).closest("div").find("input[name$='direct_to_finance_file']").hide();
                $(row).closest("div").find(".editDirectToFinanceFile").show();
                $(row).closest("div").find("a#linkDocumentFinance").attr("href", linkdoc);
                $(row).closest("div").find("a#linkDocumentFinance").text(filename);
                $(row).closest("div").find(".linkDocumentFinance").show();
                $(row).closest("div").find(".btnFileUploadJustification").hide();
            } else {
                $(row).closest("tr").find("input[name$='filename']").hide();
            }

            $(row).closest("tr").find(".editDocument").show();
            $(row).closest("tr").find("a#linkDocumentHref").attr("href", linkdoc);
            $(row).closest("tr").find("a#linkDocumentHref").text(filename);
            $(row).closest("tr").find(".linkDocument").show();
            $(row).closest("tr").find(".btnFileUpload").hide();
        }

        function GetDataProduct() {
            $.ajax({
                url: '<%= Page.ResolveUrl("~/" + based_url+service_url + "/GetProductList") %>',
                    dataType: 'json',
                    type: 'post',
                    contentType: "application/json; charset=utf-8",
                    success: function (response) {
                        //objProduct = JSON.parse(response.d);
                    }
                });
        }

        function GetDataProductFC() {
            $.ajax({
                url: '<%= Page.ResolveUrl("~/" + based_url+service_url + "/GetProductList") %>',
                    dataType: 'json',
                    type: 'post',
                    contentType: "application/json; charset=utf-8",
                    success: function (response) {
                        objProduct = JSON.parse(response.d);
                        let fundsCheckChargeCodes = [];

                        if (PRDetail.length > 0) {
                            PRDetail.forEach(function (item) {
                                item.costCenters.forEach(function (chargeCode) {
                                    arrobjProduct = $.grep(objProduct, function (n, i) {
                                        return n["Id"] == item.item_code;
                                    });
                                    var chargeCodeFC = new Object();
                                    chargeCodeFC.id = chargeCode.id;
                                    chargeCodeFC.pr_id = chargeCode.pr_id;
                                    chargeCodeFC.pr_detail_id = chargeCode.pr_detail_id;
                                    chargeCodeFC.sequence_no = chargeCode.sequence_no;
                                    chargeCodeFC.cost_center_id = chargeCode.cost_center_id;
                                    chargeCodeFC.work_order = chargeCode.work_order;
                                    chargeCodeFC.entity_id = chargeCode.entity_id;
                                    chargeCodeFC.legal_entity = chargeCode.legal_entity;
                                    chargeCodeFC.control_account = arrobjProduct[0].BudgetAccount;
                                    chargeCodeFC.product_account = chargeCode.control_account;
                                    chargeCodeFC.percentage = chargeCode.percentage;
                                    chargeCodeFC.amount = chargeCode.amount;
                                    chargeCodeFC.amount_usd = chargeCode.amount_usd;
                                    chargeCodeFC.remarks = chargeCode.remarks;
                                    chargeCodeFC.is_active = chargeCode.is_active;
                                    chargeCodeFC.cost_center_name = chargeCode.cost_center_name;
                                    chargeCodeFC.work_order_name = chargeCode.work_order_name;
                                    chargeCodeFC.entity_name = chargeCode.entity_name;
                                    chargeCodeFC.is_trigger_audit = chargeCode.is_trigger_audit;

                                    fundsCheckChargeCodes.push(chargeCodeFC);
                                    //console.log(chargeCodeFC);
                                });
                            });

                    <%--url: '<%= Page.ResolveUrl("~/" + based_url+service_url + "/FundsCheck") %>',--%>
                            errorMsgFundsCheck += FundsCheck(fundsCheckChargeCodes, errorMsgFundsCheck, $("[name='pr.id']").val());

                            if (errorMsgFundsCheck !== "") {
                                showErrorMessage(errorMsgFundsCheck);
                            } else {
                                alert('Budget is sufficient');
                            }


                        } else {
                            alert('please fill product first');
                        }
                        unBlockScreenOL();
                    },
                    error: function (jqXHR, exception) {
                        unBlockScreenOL();
                    }
                });
        }

        $(document).on("click", "#btnChangePurchaseType", function () {
            blockScreenOL();
            let btnChangePT = "Change purchasing type to";

            if ($('#btnChangePurchaseType ').attr("data-page") == "1") {
                listPRType = $.grep(listPRTypeFull, function (n, i) {
                    return n["value"] != "3";
                });
                id_submission_page_type = 2;
            } else {
                listPRType = $.grep(listPRTypeFull, function (n, i) {
                    return n["value"] == "3";
                });
                id_submission_page_type = 1;
            }

            lookupPRType();
            $('#btnChangePurchaseType').attr("data-page", id_submission_page_type);

            if (id_submission_page_type == "1") {
                $('#btnChangePurchaseType').html(btnChangePT + ' Finance');
                $("[name='pr.purchase_type']").val('3').change();
            } else {
                $('#btnChangePurchaseType').html(btnChangePT + ' Procurement');
            }

            unBlockScreenOL();
        });

    </script>
</asp:Content>
