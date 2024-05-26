<%@ Page MasterPageFile="~/Procurement.Master" Language="C#" AutoEventWireup="true" CodeBehind="Payment.aspx.cs" Inherits="myTree.WebForms.Modules.PurchaseRequisition.Payment" %>


<%@ Register Src="~/Usc/uscRecentComment.ascx" TagName="recentcomment" TagPrefix="uscComment" %>
<%--<%@ Register Src="uscPREdit.ascx" TagName="predit" TagPrefix="uscPREdit" %>--%>
<%@ Register Src="uscPRDetail.ascx" TagName="prdetail" TagPrefix="uscPRDetail" %>

<asp:Content ID="Content1" ContentPlaceHolderID="AppHead" runat="server">
    <title>Purchase Requisition Verification</title>
    <style>
        .select2 {
            min-width: 150px !important;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="AppBody" runat="server">
    <div class="floatingBox" id="error-box" style="display: none">
        <div class="alert alert-error" id="error-message">
        </div>
    </div>
    <%if (approval_notes != null && !string.IsNullOrEmpty(approval_notes.activity_desc)) {  %>
    <div class="alert alert-info" id="approval-notes">
        <%=approval_notes.activity_desc %>
    </div>
    <%  } %>
    <%--<%  if (authorized.admin || authorized.procurement_user)--%>
    <%  if (isAdmin || isUser)
        { %>
    <div class="row-fluid">
        <div class="floatingBox" style="margin-bottom:0px;">
            <div class="container-fluid">
                <div class="controls text-right">
                    <button id="btnAuditTrail" class="btn btn-success" type="button">Audit trail</button>                           
                </div> 
            </div>
        </div>
    </div>
    <%  } %>
    <!-- Recent comment -->
    <uscComment:recentcomment ID="recentComment" runat="server" />
    <div class="containerHeadline">
        <h2>Purchase requisition information(s)</h2>
    </div>
    <div class="row-fluid">
        <div class="floatingBox">
            <div class="container-fluid">
                
                <!-- PR editable -->
                <uscPRDetail:prdetail ID="prdetail1" runat="server"/>
                <input type="hidden" id="sn" value="<%=sn %>"/>
                <input type="hidden" id="activity_id" value="<%=activity_id %>"/>
                <input type="hidden" id="accessToken" value="<%=accessToken %>"/>
                <input type="hidden" id="roles" value="<%=approval_notes.activity_name %>"/>
                <input type="hidden" name="file_name" id="file_name" value="" />
                <input type="hidden" name="docidtemp" value="" />
                <div class="control-group last">
                    <div class="controls">
                        <button id="btnClose" class="btn" type="button">Close page</button>&nbsp;&nbsp;&nbsp;
                        <button id="btnPrint" class="btn btn-success" type="button">Print PR</button>
                        <button id="btnSave" class="btn btn-success" data-action="saved" type="button">Save</button>
                        <button id="btnReject" class="btn btn-success" data-action="rejected" type="button">Reject</button>                           
                        <button id="btnRevise" class="btn btn-success" data-action="requested for revision" type="button">Request for revision</button>
                        <button id="btnVerify" class="btn btn-success" data-action="verified" type="button">Payment completed</button>
                        &nbsp;&nbsp;&nbsp;<button id="btnRedirect" class="btn btn-success" data-action="redirect" type="button">Redirect to procurement unit</button>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <script>
        var taskType = "<%=taskType%>";
        var _id = "<%=_id%>";
        var btnAction = "";
        var ActionName = "";
        var workflow = new Object();
        var isFinance = "<%=isFinance?"true":"false"%>";
        var listPRType = <%=listPRType%>;
        isFinance = (isFinance === "true");

        $(document).ready(function () {
            $("#btnSavejournalno,#btnCanceljournalno,#btnSavereferenceno,#btnCancelreferenceno").hide();

            if ($("#tblJournalNo tbody tr").length < 1) {
                $("#btnEditjournalno").hide();
            }
            //if ($("#status").val() == "50") {
            //    if ($("#purchase_type").val() == "1") {
            //        $("#btnEditreferenceno").show();
            //    } else {
            //        $("#btnEditjournalno").show();
            //    }

            //    $("#btnReject,#btnRevise,#btnSubmit").hide();
            //} else {
            //    $("#btnEditjournalno").hide();
            //    $("#btnEditreferenceno").hide();
            //}
            /*SetJournalAccess();*/
            listPRType = $.grep(listPRType, function (n, i) {
                return n["value"] != "3";
            });
            lookupPRType();
        });

        $(document).on("click", "#btnEditjournalno", function () {
            $(this).hide();
            //$("#btnGetSUNPO").show();
            $("[name='journalno.journal_no']").prop("disabled", false);
            //$("[name='journalno.journal_no']").focus();
            $("#btnSavejournalno").show();
            $("#btnCanceljournalno").show();
            $("#control_journalno").addClass("required");
        });

        $(document).on("click", "#btnAddJournalNo", function () {
            //$(this).hide();
            //$("#btnGetSUNPO").show();
            $("[name='journalno.journal_no']").prop("disabled", false);
            //$("[name='journalno.journal_no']").focus();
            $("#btnEditjournalno").hide();
            $("#btnSavejournalno").show();
            $("#btnCanceljournalno").show();
            $("#control_journalno").addClass("required");

            /*SetJournalAccess();*/
        });

        $(document).on("click", "#btnCanceljournalno", function () {
            $(this).hide();
            $("#tblJournalNo tbody").empty();
            $.each(PRJournalNo, function (i, d) {
                addJournalNo(d.id, "", d.journal_no, d.pr_id, d.journal_attachment_id, d.journal_attachment);
            });
            $("[name='journalno.journal_no']").prop("disabled", true);
            $("#btnCanceljournalno").hide();
            $("#btnSavejournalno").hide();
            $("#btnEditjournalno").show();
            if ($("#status").val() == "50") {
                $("#control_journalno").removeClass("required");
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

        $(document).on("click", "#btnReject,#btnRevise,#btnVerify,#btnRedirect", function () {
            $("#error-box").hide();
            btnAction = $(this).data("action").toLowerCase();
            if (btnAction == "redirect") {
                ActionName = "redirected"
            }

            sleep(1).then(() => {
                blockScreenOL();
            });

            sleep(300).then(() => {
                SubmitValidation();
            }).then(() => {
            });
        });

        function SubmitValidation() {
            var errorMsg = "";
            var data = new Object();
            data.id = $("[name='pr.id']").val();
            data.status_id = $("#status").val();
            data.requester = $("[name='pr.requester']").val();
            data.required_date = $("[name='pr.required_date']").val();
            data.cifor_office_id = $("[name='pr.cifor_office_id']").val();
            data.cost_center_id = $.trim($("[name='pr.cost_center_id']").val());
            data.t4 = $.trim($("[name='pr.t4']").val());
            data.remarks = $("[name='pr.remarks']").val();
            data.currency_id = $("[name='pr.currency_id']").val();
            data.exchange_sign = $("[name='pr.exchange_sign']").val();
            data.exchange_rate = delCommas($("[name='pr.exchange_rate']").val());
            data.total_estimated = delCommas($("#GrandTotal").text());
            data.total_estimated_usd = delCommas($("#GrandTotalUSD").text());
            data.purchase_type = $("[name='pr.purchase_type']").val();
            data.details = PRDetail;

            workflow.sn = $("#sn").val();
            workflow.activity_id = $("#activity_id").val();
            workflow.roles = $("#roles").val();
            workflow.action = btnAction;
            workflow.comment = $("[name='comments']").val();
            workflow.access_token = $("#accessToken").val();
            workflow.amount = data.total_estimated_usd;

            if (btnAction === "verified") {
                errorMsg += GeneralValidation();
            } else if (btnAction === "rejected" || btnAction === "requested for revision" || btnAction === "redirect") {
                if ($.trim($("[name='comments']").val()) === "") {
                    errorMsg += "<br /> - Comments is required."
                }
            }

            let errFile = 0;
            let errJournalNo = 0;
            let errDesc = 0;
            let errUpload = 0;
            let msgFile = "";
            let msgjournal = "";
            data.journalno = [];
            $("#tblJournalNo tbody tr").each(function () {
                let _att = new Object();
                _att["id"] = $(this).find("input[name='journalno.id']").val();
                _att["pr_id"] = $(this).find("input[name='journalno.pr_id']").val();
                _att["journal_no"] = $(this).find("input[name='journalno.journal_no']").val();
                _att["journal_attachment"] = $(this).find("input[name='attachment.filename']").val();
                _att["journal_attachment_id"] = $(this).find("input[name='attachment.id']").val();
                _att["journal_attachment_description"] = "";
                data.journalno.push(_att);

                if ($.trim(_att["journal_no"]) == "" && errJournalNo == 0) {
                    msgFile += "<br/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- Journal number is required.";
                    $(this).find("td:eq(0)").css({ 'background-color': 'rgb(245, 183, 177)' });
                    errJournalNo++;
                } else {
                    let msgJournalTemp = GetJournalDetail($(this).find("input[name='journalno.journal_no']").val(), "validation", "");
                    if (msgJournalTemp != "") {
                        $(this).find("td:eq(0)").css({ 'background-color': 'rgb(245, 183, 177)' });
                    } else {
                        $(this).find("td:eq(0)").css({ 'background-color': '' });
                    }
                    msgjournal += msgJournalTemp;
                }

                if ($.trim(_att["journal_attachment"]) == "" && errFile == 0) {
                    msgFile += "<br/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- File is required.";
                    errFile++;
                }

                if ($(this).find("input[name='attachment.uploaded']").val() == "0") {
                    $(this).find("td:eq(1)").css({ 'background-color': 'rgb(245, 183, 177)' });
                    if ($.trim(_att["journal_attachment"]) != "") {
                        errUpload++;
                    }
                }
            });

            errorMsg += msgjournal;

            if (errUpload > 0) {
                errorMsg += "<br/> - There are files that have not been uploaded, please upload first.";
            }

            if (msgFile !== "") {
                msgFile = "<br/> - Journal attachment:" + msgFile;
            }

            errorMsg = errorMsg + msgFile;

            if (errorMsg !== "") {
                showErrorMessage(errorMsg);
                unBlockScreenOL();
                return false;
            } else {
                var _data = {
                    "id": _id,
                    "submission": JSON.stringify(data),
                    "deletedIds": JSON.stringify(deletedId),
                    "workflows": JSON.stringify(workflow)
                };
                Submit(_data);
            }
        }

        function Submit(_data) {
            $.ajax({
                url: 'Payment.aspx/Submit',
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
                        unBlockScreenOL();
                    } else {
                        if (output.id !== "") {
                            $("#_pr_no").val(output.pr_no);
                            $("input[name='doc_id']").val(output.id);
                            $("input[name='action']").val("upload");
                            /*UploadFile();*/
                            if (btnAction == "requested for revision") {
                                alert("Request for revision has been submitted successfully.");
                            } else if (btnAction == "verified") {
                                alert("Request has been " + btnAction + " successfully.");
                            } else if (btnAction == "redirect") {
                                alert("Request has been " + ActionName + " successfully.");
                            } else {
                                alert("Request has been " + btnAction + " successfully.");
                            }
                            /*blockScreen();*/
                            if (btnAction === "saved") {
                                location.reload();
                            } else {
                                if (taskType == "admin") {
                                    location.href = "Tasklist.aspx";
                                } else if (taskType == "adminteam") {
                                    location.href = "Tasklist.aspx?action=team";
                                } else {
                                    location.href = "/workspace";
                                }
                            }
                        }
                    }
                }
            });
        }

       <%-- function UploadFile() {
            var form = $('form')[0];
            var formData = new FormData(form);

            $.ajax({
                type: "POST",
                <%--url: "<%=service_url%>",
                url: '<%= Page.ResolveUrl("~/"+ based_url+service_url) %>',
                data: formData,
                processData: false,
                contentType: false,
                success: function (response) {
                    var stringJS = '{' + response.substring(
                        response.indexOf("{") + 1,
                        response.lastIndexOf("}")
                    ) + '}';
                    var output = JSON.parse(stringJS);

                    if (output.result !== "success") {
                        alert(output.message);
                    } else {
                        if (btnAction == "requested for revision") {
                            alert("Request for revision has been submitted successfully.");
                        } else if (btnAction == "verified") {
                            alert("Request has been " + btnAction + " successfully.");
                        } else if (btnAction == "redirect") {
                            alert("Request has been " + ActionName + " successfully.");
                        } else {
                            alert("Request has been " + btnAction + " successfully.");
                        }
                        blockScreen();
                        if (btnAction === "saved") {
                            location.reload();
                        } else {
                            if (taskType == "admin") {
                                location.href = "Tasklist.aspx";
                            } else if (taskType == "adminteam") {
                                location.href = "Tasklist.aspx?action=team";
                            } else {
                                location.href = "/workspace";
                            }
                        }
                    }
                }
            });
        }--%>

        $(document).on("click", "#btnAuditTrail", function () {
            parent.ShowCustomPopUp("audittrail.aspx?blankmode=1&module=purchaserequisition&id=" + $("[name='pr.id']").val());
        });

        if ($("#activity_id").val() != '5') {
            $("#div_move_purchase_office").hide();
        }

        if (pageType == 'payment') {
            $("#btnReject").hide();
        }
        

       

        <%--$(document).on("click", ".btnFileUpload", function () {
            $("#action").val("fileupload");

            btnFileUpload = this;

            $("#file_name").val($(this).closest("tr").find("input:file").val().split('\\').pop());

            filenameupload = $("#file_name").val();

            if (!$("#file_name").val()) {
                alert("Please choose file first");
                return false;
            } else {
                let errorMsg = FileValidation();
                if (FileValidation() !== '') {
                    if ($(this).data("type") == '') {
                        $("#error-message").html("<b>" + "- Journal document(s):" + "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" + errorMsg + "<b>");
                        $("#error-box").show();
                        $('.modal-body').animate({ scrollTop: 0 }, 500);
                    } else {
                        showErrorMessage(errorMsg);
                    }

                    return false;
                }

                UploadFileAPI("");
                $(this).closest("tr").find("input[name$='attachment.uploaded']").val("1");
                $(this).closest("tr").css({ 'background-color': '' });
            }
        });

        function UploadFileAPI(actionType) {
            blockScreenOL();
            var form = $('form')[0];
            var formData = new FormData(form);

            $.ajax({
                type: "POST",
                url: '<%= Page.ResolveUrl("~/" +based_url+ service_url + "") %>',
                data: formData,
                processData: false,
                contentType: false,
                success: function (response) {
                    unBlockScreenOL();
                    var stringJS = '{' + response.substring(
                        response.indexOf("{") + 1,
                        response.lastIndexOf("}")
                    ) + '}';
                    var output = JSON.parse(stringJS);

                    if (actionType != "submit") {
                        if (output.result == '') {
                            GenerateFileLink(btnFileUpload, filenameupload);
                        } else {
                            alert('Upload file failed');
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

        function GenerateFileLink(row, filename) {
            let pr_id = '';
            var linkdoc = '';

            if ($("[name='pr.id']").val() == '' || $("[name='pr.id']").val() == null) {
                pr_id = $("[name='docidtemp']").val();
                linkdoc = "FilesTemp/" + quo_id + "/" + filename + "";
            } else {
                quo_id = $("[name='pr.id']").val();
                linkdoc = "Files/" + quo_id + "/" + filename + "";
            }

            $(row).closest("tr").find("input[name$='filename']").hide();

            $(row).closest("tr").find(".editDocument").show();
            $(row).closest("tr").find("a#linkDocument").attr("href", linkdoc);
            $(row).closest("tr").find("a#linkDocument").text(filename);
            $(row).closest("tr").find(".linkDocument").show();
            $(row).closest("tr").find(".btnFileUpload").hide();
            $(row).closest("tr").find("input[name='attachment.filename']").val(filename);

        }

        $(document).on("click", ".editDocument", function () {
            $(this).closest("tr").find("input[name='attachment.filename']").val("");
            var obj = $(this).closest("td").find("input[name='filename']");
            var link = $(this).closest("td").find(".linkDocument");

            $(this).closest("tr").find("input[name$='attachment.uploaded']").val("0");
            $(this).closest("td").find(".btnFileUpload").show();

            $(obj).show();
            $(link).hide();
            $(this).hide();
        });--%>

        /*$(document).on("click", "#btnSavejournalno", function () {*/
        <%--$(document).on("click", "#btnSave", function () {
            var data1 = new Object();
            var errorMsg = "";
            let errFile = 0;
            let errDesc = 0;
            var errUpload = 0;
            var msgFile = "";

            var workflow = new Object();
            workflow.action = "MODIFIED PAYMENT INFORMATION";
            workflow.comment = $("[name='comments']").val();

            data1.journalno = [];
            $("#tblJournalNo tbody tr").each(function () {
                var _att = new Object();
                _att["id"] = $(this).find("input[name='journalno.id']").val();
                _att["pr_id"] = $(this).find("input[name='journalno.pr_id']").val();
                _att["journal_no"] = $(this).find("input[name='journalno.journal_no']").val();

                if ($(this).find("input[name='attachment.uploaded']").val() == '1') {
                    _att["journal_attachment"] = $(this).find("input[name='attachment.filename']").val();
                } else {
                    _att["journal_attachment"] = '';
                }
                
                _att["journal_attachment_id"] = $(this).find("input[name='attachment.id']").val();
                _att["journal_attachment_description"] = "";
                data1.journalno.push(_att);
            });

            errorMsg += GeneralValidation();

            if (errorMsg !== "") {
                showErrorMessage(errorMsg);
            }
            else {
                var data = {
                    "id": _id,
                    "submission": JSON.stringify(data1.journalno),
                    "deletedIds": JSON.stringify(deletedId),
                    "workflows": JSON.stringify(workflow)
                };
                $.ajax({
                    url: '<%= Page.ResolveUrl("~/"+based_url+ service_url + "/savePaymentNo") %>',
                    data: JSON.stringify(data),
                    dataType: 'json',
                    type: 'post',
                    contentType: "application/json; charset=utf-8",
                    success: function (response) {
                        const output = JSON.parse(response.d);
                        if (output.result != "success") {
                            alert(output.message);
                        } else {
                            location.reload();
                            alert("Journal number has been updated.");
                            $("#btnSavejournalno").hide();
                            $("[name='journalno.journal_no']").prop("disabled", true);
                            $("#btnCanceljournalno").hide();
                            $("#btnEditjournalno").show();
                            $("#control_journalno").removeClass("required");
                        }
                    }
                });
            }
        });--%>

        $(document).on("change", "input[name='filename']", function () {
            $(this).closest("tr").find("input[name$='attachment.uploaded']").val("0");
            var obj = $(this).closest("tr").find("input[name='attachment.filename']");
            $(obj).val("");
            var filename = "";
            var fullPath = $(this).val();
            if (fullPath) {
                var startIndex = (fullPath.indexOf('\\') >= 0 ? fullPath.lastIndexOf('\\') : fullPath.lastIndexOf('/'));
                filename = fullPath.substring(startIndex);
                if (filename.indexOf('\\') === 0 || filename.indexOf('/') === 0) {
                    filename = filename.substring(1);
                }
                $(obj).val(filename);
            }
        });

        function SetJournalAccess() {
            //if (isFinance) {
            //    $("[name='filename']").prop("disabled", true);
            //    $(".btnFileUpload, .btnDelete, .editDocument").prop("disabled", true);
            //}
        };

        $(document).on("click", "#btnPrint", function () {
            link = "PrintPreview.aspx?id=" + _id;
            top.window.open(link);
        });

        function lookupPRType() {
            var cbo = $("[name='pr.purchase_type']");
            $(cbo).empty();
            generateCombo(cbo, listPRType, "value", "description", true);
            Select2Obj(cbo, "Purchase type");
            $("[name='pr.purchase_type']").val(purchase_type).trigger("change");
        }
    </script>
</asp:Content>

