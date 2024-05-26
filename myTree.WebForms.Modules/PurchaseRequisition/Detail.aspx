<%@ Page MasterPageFile="~/Procurement.Master" Language="C#" AutoEventWireup="true" CodeBehind="Detail.aspx.cs" Inherits="myTree.WebForms.Modules.PurchaseRequisition.Detail" %>


<%@ Register Src="~/Usc/uscRecentComment.ascx" TagName="recentcommentDetail" TagPrefix="uscCommentDetail" %>
<%@ Register Src="~/PurchaseRequisition/uscPRDetail.ascx" TagName="prdetail" TagPrefix="uscPRDetail" %>
<%@ Register Src="~/PurchaseRequisition/uscHistoricalInformation.ascx" TagName="historicalInformation" TagPrefix="uscHistoricalInformation" %>
<%@ Register Src="~/UserConfirmation/uscSendConfirmation.ascx" TagName="confirmationform" TagPrefix="uscConfirmation" %>
<%@ Register Src="~/PurchaseRequisition/uscConfirmation.ascx" TagName="confirmationList" TagPrefix="confirmationList" %>
<%@ Register Src="~/PurchaseRequisition/uscFinancialReport.ascx" TagName="financialReport" TagPrefix="uscFinancialReport" %>
<%@ Register Src="~/Usc/uscCancellationForm.ascx" TagName="cancellationform" TagPrefix="uscCancellation" %>

<asp:Content ID="Content1" ContentPlaceHolderID="AppHead" runat="server">
    <title><%=submission_page_name%> Detail</title>
    <style>
        .controls {
            padding-top: 5px;
        }

        #CancelForm.modal-dialog {
            margin: auto 12% !important;
            width: 60% !important;
            height: 320px !important;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="AppBody" runat="server">
    <%--<%  if (authorized.admin || authorized.procurement_user || isInWorkflow)--%>
    <%  if (isAdmin || isUser || isInWorkflow)
        { %>
    <div class="row-fluid">
        <div class="floatingBox" style="margin-bottom: 0px;">
            <div class="container-fluid">
                <div class="controls text-right">
                    <%  if (isInWorkflow)
                        {%>
                    <button id="btnViewWorkflow" class="btn btn-success" type="button">View workflow</button>
                    <a hidden id="btnViewWorkflowA" href="<%= HttpContext.Current.Request.Url.GetLeftPart(UriPartial.Authority) + "/Workspace/ViewWorkflow?Id=" + _id + "&Module=PurchaseRequisition&blankmode=1" %>"></a>
                    <%  } %>
                    <%--<%  if (authorized.admin || authorized.procurement_user)--%>
                    <%  if (isAdmin || isUser)
                        {
                    %>
                    <button id="btnAuditTrail" class="btn btn-success" type="button">Audit trail</button>
                    <a hidden id="btnAuditTrailA" href="<%= ResolveUrl("~"+based_url+"/AuditTrail.aspx?blankmode=1&module=purchaserequisition&id=" + _id) %>"></a>
                    <%  } %>
                </div>
            </div>
        </div>
    </div>
    <%  } %>
    <!-- Recent comment -->
    <uscCommentDetail:recentcommentDetail ID="recentCommentDetail" runat="server" />

    <!-- Cancellation Form -->
    <uscCancellation:cancellationform ID="cancellationForm" runat="server" />

    <!-- Confirmation Form -->
    <div id="ConfirmationForm" class="modal hide fade modal-dialog" role="dialog" aria-labelledby="header1" aria-hidden="true"
        data-backdrop="static" data-keyboard="false">
        <div class="modal-header">
            <button type="button" class="close" data-dismiss="modal" aria-hidden="true"></button>
            <h3 id="header1">Request for user confirmation</h3>
        </div>
        <div class="modal-body">
            <div class="floatingBox" id="ucform-error-box" style="display: none">
                <div class="alert alert-error" id="ucform-error-message">
                </div>
            </div>
            <uscConfirmation:confirmationform ID="confirmationForm" runat="server" />
        </div>
        <div class="modal-footer">
            <button type="button" class="btn btn-success" aria-hidden="true" id="btnSendConfirmation" data-action="sent">Send confirmation</button>
            <button type="button" class="btn" data-dismiss="modal" aria-hidden="true">Close and cancel</button>
        </div>
    </div>
    <div class="floatingBox" id="error-box" style="display: none">
        <div class="alert alert-error" id="error-message">
        </div>
    </div>
    <div class="row-fluid" style="margin-bottom: 0px;">
        <div class="span12 tabContainer">

            <!-- ==================== TAB NAVIGATION ==================== -->
            <ul class="nav nav-tabs">
                <li class="active">
                    <a href="#generalInformation" target="_top">General Information</a>
                </li>
                <%--<li class=""><a href="#financialInformation" target="_top">Financial information</a></li>--%>
                <%--<li class=""><a href="#confirmationInformation" target="_top">User confirmation(s)</a></li>--%>
                <li class=""><a href="#otherInformation" target="_top">Other information</a></li>
            </ul>
            <!-- ==================== END OF TAB NAVIGATIION ==================== -->

            <div class="row-fluid">
                <div class="tabContent" id="generalInformation" style="display: block;">
                    <div class="floatingBox table" style="margin-bottom: 0px;">
                        <div class="container-fluid">
                            <!-- PR editable -->
                            <uscPRDetail:prdetail ID="prdetail1" runat="server" />
                            <input type="hidden" id="sn" />
                        </div>
                    </div>
                </div>
                <!-- ==================== SECOND TAB CONTENT ==================== -->
                <div class="tabContent" id="financialInformation" style="display: none;">
                    <div class="floatingBox table" style="margin-bottom: 0px;">
                        <div class="container-fluid">
                            <!-- Financial information -->
                            <uscFinancialReport:financialReport ID="financialReport1" runat="server" />
                        </div>
                    </div>
                </div>
                <!-- ==================== THIRD TAB CONTENT ==================== -->
                <div class="tabContent" id="confirmationInformation" style="display: none;">
                    <div class="floatingBox table" style="margin-bottom: 0px;">
                        <div class="container-fluid">
                            <!-- Confirmation information -->
                            <confirmationList:confirmationList ID="confirmationList" runat="server" />
                        </div>
                    </div>
                </div>
                <!-- ==================== FORTH TAB CONTENT ==================== -->
                <div class="tabContent" id="otherInformation" style="display: none;">
                    <div class="floatingBox table" style="margin-bottom: 0px;">
                        <div class="container-fluid">
                            <!-- Historical information -->
                            <uscHistoricalInformation:historicalInformation ID="historicalInformation1" runat="server" />
                        </div>
                    </div>
                </div>
            </div>
            <div class="row-fluid">
                <div class="floatingBox" style="margin-bottom: 0px;">
                    <div class="container-fluid">
                        <div class="controls">
                            <button id="btnClose" class="btn" type="button">Close page</button>
                            <button id="btnSave" class="btn btn-success" data-action="saved" hidden type="button">Save</button>&nbsp;&nbsp;&nbsp;
                            <button id="btnPrint" class="btn btn-success" type="button">Print PR</button>
                            
                            <%  if (isEditable)
                                { %>
                            <button id="btnEdit" class="btn btn-success" data-action="saved" type="button">Edit</button>
                            <%  } %>
                            <button id="btnReturn" class="btn btn-success" data-action="returned to initiator" type="button">Return to initiator</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <script>
        var _id = "<%=_id%>";
        var id_submission_page_type = "<%=id_submission_page_type%>";
        var blankmode = "<%=blankmode%>";
        <%--var isAdmin = "<%=authorized.admin?"true":"false"%>";--%>
        var isAdmin = "<%=isAdmin ? "true":"false"%>";
        isAdmin = (isAdmin === "true");

        <%--var isFinance = "<%=authorized.finance?"true":"false"%>";--%>
        var isFinance = "<%=isFinance ? "true":"false"%>";
        isFinance = (isFinance === "true");

        var UserId = "<%= UserId%>";
        var isEditable = "<%= isEditable%>";
        var btnAction = "";
        var workflow = new Object();

        $(document).on("click", ".btnPurchase", function () {
            parent.location.href = $(this).data("link");
        });

        $(document).on("click", ".btnEditPurchase", function () {
            parent.location.href = $(this).data("link");
        });

        $(document).on("click", "#btnEdit", function () {
            parent.location.href = "Input.aspx?id=" + _id + "&submission_page_type=" + id_submission_page_type;
        });

        $(document).on("click", "#btnClose", function () {
            if (blankmode == "1") {
                //parent.$.colorbox.close();
                parent.$.fancybox.close();
            } else {
                parent.location.href = "List.aspx";
            }
        });

        $(document).on("click", ".btnConfirm", function () {
            var line_id = $(this).data("base-id");
            sendConfirmation(line_id);
        });

        function sendConfirmation(ids) {
            resetFormConfirmation();
            $("#ConfirmationForm").modal("show");

            loadItems(ids, "PURCHASE REQUISITION");

            setTimeout(ScrollConfirmation, 500);
        }

        function ScrollConfirmation() {
            var ctop = $("#ConfirmationForm").offset().top;
            window.parent.$('html, #ConfirmationForm').animate({ scrollTop: ctop }, 'slow');
        }

        $(document).on("click", ".btnViewConfirm", function () {
            blockScreen();
            parent.location = $(this).data("url");
        });

        $(document).on("click", ".btnCloseItem", function () {
            blockScreen();
            parent.location = $(this).data("url");
        });

        $(document).on("click", "#btnAuditTrail", function () {
            if (window.self != window.top) {
                parent.$("#btnAuditTrailA").fancybox({
                    iframe: {
                        css: {
                            height: '600px'
                        }
                    }
                });
                $("#btnAuditTrailA").get(0).click();
            } else {
                ShowCustomPopUp("<%= ResolveUrl("~"+based_url+"/AuditTrail.aspx?blankmode=1&module=purchaserequisition&id=" + _id) %>");
            }
        });

        $(document).on("click", "#btnViewWorkflow", function () {
            if (window.self != window.top) {
                parent.$("#btnViewWorkflowA").fancybox({
                    iframe: {
                        css: {
                            height: '600px'
                        }
                    }
                });
                $("#btnViewWorkflowA").get(0).click();
            } else {
                ShowCustomPopUp("<%= HttpContext.Current.Request.Url.GetLeftPart(UriPartial.Authority) + "/Workspace/ViewWorkflow?Id=" + _id + "&Module=PurchaseRequisition&blankmode=1" %>");
            }
        });

        /* confirmation script */
        var uploadValidationResult = {};
        $(document).on("click", "#btnSendConfirmation", function () {
            var thisHandler = $(this);
            $("[name=cancellation_file],[name=confirm_filename]").uploadValidation(function (result) {
                uploadValidationResult = result;
                onBtnClickSendConfirmation.call(thisHandler);
            });
        });

        var onBtnClickSendConfirmation = function () {
            //$(document).on("click", "#btnSendConfirmation", function () {
            var errorMsg = "";
            errorMsg += uploadValidationResult.not_found_message || '';
            if ($("[name^='delivery_quantity']").length == 0) {
                errorMsg += "<br/>- Item(s) is required";
            }

            errorMsg += GeneralValidation();
            errorMsg += FileValidation();
            if (errorMsg != "") {
                errorMsg = "Please correct the following error(s):" + errorMsg;

                $("#ucform-error-message").html("<b>" + errorMsg + "<b>");
                $("#ucform-error-box").show();
                $('.modal-body').animate({ scrollTop: 0 }, 500);
            } else {
                var workflow = new Object();
                workflow.action = "saved";
                workflow.comment = "";

                var _data = new Object();
                var ConfirmList = [];
                var DocList = [];

                $("[name^='delivery_quantity']").each(function (i, x) {
                    var obj = new Object();
                    obj.base_type = $("[name='base_type']").val();
                    obj.base_id = $(this).data("id");
                    obj.send_quantity = delCommas($(this).val());
                    obj.additional_person = String($("[name^='cboStaff'][data-unique_id='" + $(this).data("unique_id") + "']").val()).toLowerCase();

                    ConfirmList.push(obj);
                });
                _data.details = ConfirmList;

                $("#tblSupportingDocuments tbody tr").each(function () {
                    var _att = new Object();
                    _att["id"] = $(this).find("input[name='confirmationfile.id']").val();
                    _att["filename"] = $(this).find("input[name='confirmationfile.filename']").val();
                    _att["file_description"] = $(this).find("input[name='confirmationfile.file_description']").val();
                    _att["is_provide_file"] = ($(this).find("input[type='checkbox']").is(':checked')) ? "1" : "0";
                    DocList.push(_att);
                });
                _data.documents = DocList;

                var Submission = {
                    submission: JSON.stringify(_data),
                    workflows: JSON.stringify(workflow),
                    deleted: JSON.stringify(deletedSupDocId)
                };

                $.ajax({
                    url: 'UserConfirmation/ItemConfirmation.aspx/Submit',
                    data: JSON.stringify(Submission),
                    dataType: 'json',
                    type: 'post',
                    contentType: "application/json; charset=utf-8",
                    success: function (response) {
                        var output = JSON.parse(response.d);
                        if (output.result !== "success") {
                            alert(output.message);
                        } else {
                            if (output.id !== "") {
                                $("#confirm_no").val(output.confirmation_code);
                                $("input[name='doc_id']").val(output.id);
                                $("input[name='action']").val("upload");
                                $("input[name='doc_type']").val("USER CONFIRMATION");
                                UploadConfirmFile("confirm");
                            }
                        }
                    }
                });
            }
        };

        $(document).on("click", ".btnFileUploadCancel", function () {
            $("#action").val("fileupload");

            $("#file_name").val($(this).closest("div").find("input:file").val().split('\\').pop());
            var filename = $("#file_name").val();

            if (!$("#file_name").val()) {
                alert("Please choose file first");
                return false;
            } else {
                $("input[name='doc_id']").val($("[name='pr.id']").val());
                UploadFileAPI("");
                $(this).closest("div").find("input[name$='cancellation.uploaded']").val("1");
                $(this).closest("div").find("input[name$='cancellation_file']").css({ 'background-color': '' });
                GenerateCancelFileLink(this, filename);
            }
        });

        function UploadConfirmFile(source) {
            var form = $('form')[0];
            var formData = new FormData(form);

            $.ajax({
                type: "POST",
                url: 'Service.aspx',
                data: formData,
                processData: false,
                contentType: false,
                success: function (response) {
                    var output = JSON.parse(response);
                    if (output.result !== "success") {
                        alert(output.message);
                    } else {
                        blockScreen();
                        if (source == "confirm") {
                            alert("User confirmation " + $("#confirm_no").val() + " has been sent successfully.");
                            location.reload();
                        } else if (source == "return") {
                            alert($("#_pr_no").val() + " has been returned to initiator successfully.")
                            if (blankmode == "1") {
                                parent.$.colorbox.close();
                                parent.location.href = "List.aspx";
                            } else {
                                parent.location.href = "List.aspx";
                            }
                        }
                    }
                }
            });
        }

        $(document).on("click", "#btnReturn", function () {
            $("#CancelForm").modal("show");

            $("#headerCancellationForm").text("Reason for return this PR to initiator");
            $("#reasonForCancellationLabel").text("Please provide a reason for return this PR to initiator in text and/or file");
            $("#btnSaveCancellation").text("Return to initiator");
        });

        $(document).on("click", "#btnSaveCancellation", function () {
            btnAction = $(this).data("action").toLowerCase();
            workflow.action = "RETURNED TO INITIATOR";

            var errorMsg = "";
            if ($.trim($("#cancellation_text").val()) == "" && $.trim($("#cancellation_file").val()) == "") {
                errorMsg += "<br/> - Reason for cancellation is required.";
            }
            errorMsg += FileValidation();

            if (errorMsg != "") {
                errorMsg = "Please correct the following error(s):" + errorMsg;

                $("#cform-error-message").html("<b>" + errorMsg + "<b>");
                $("#cform-error-box").show();
                $('.modal-body').animate({ scrollTop: 0 }, 500);
                return false;
            } else {
                workflow.comment = $("#cancellation_text").val();
                workflow.comment_file = $("#cancellation_file").val();
            }

            submitReturn();
        });

        function submitReturn() {
            var _data = {
                "id": _id,
                "workflows": JSON.stringify(workflow)
            };

            $.ajax({
                url: 'Detail.aspx/Return',
                data: JSON.stringify(_data),
                dataType: 'json',
                type: 'post',
                contentType: "application/json; charset=utf-8",
                success: function (response) {
                    var output = JSON.parse(response.d);
                    if (output.result !== "success") {
                        alert(output.message);
                    } else {
                        $("input[name='doc_id']").val(output.id);
                        $("input[name='action']").val("upload");
                        $("input[name='doc_type']").val("PURCHASE REQUISITION");
                        alert($("#_pr_no").val() + " has been returned to initiator successfully.")
                        if (blankmode == "1") {
                            parent.$.colorbox.close();
                            parent.location.href = "List.aspx";
                        } else {
                            parent.location.href = "List.aspx";
                        }
                        /*      UploadConfirmFile("return");*/
                    }
                }
            });
        }

        $(document).ready(function () {
            var is_direct_to_finance = $("#is_direct_to_finance").val();
            if (is_direct_to_finance == "" || typeof is_direct_to_finance === "undefined") {
                is_direct_to_finance = 0;
            }

            //if (!($("#max_status").val() == "25" && $("#status").val() == "25" && $("#purchase_type").val() == "3" && ((isAdmin && is_direct_to_finance == 0) || (isFinance && is_direct_to_finance == 1)))) {
            //    if (!(($("#status").val() == "50" || $("#status").val() == "25") && $("#purchase_type").val() != "3" && ((UserId == "pthayib" || UserId == "cifor-sysdev31") || (UserId == "isalokang" || UserId == "cifor-sysdev48") || (UserId == "hlinawati" || UserId == "cifor-sysdev45") || (UserId == "jmanangkil" || UserId == "cifor-sysdev7")))) {
            //        $("#btnReturn").remove();
            //    }
            //}

            //if (!($("#max_status").val() == "25"
            //    && $("#status").val() == "25"
            //    && ($("#purchase_type").val() == "3" || $("#purchase_type").val() == "5")
            //    && isAdmin
            //)) {
            //    if (!(($("#status").val() == "50" || $("#status").val() == "25")
            //        && ($("#purchase_type").val() != "3" && $("#purchase_type").val() != "5")
            //        && isFinance
            //    )) {
            //        $("#btnReturn").remove();
            //    }
            //}

            if (!($("#max_status").val() == "25"
                && $("#status").val() == "25"
                && (lastActivity == "5")
                && isAdmin
            )) {
                if (!($("#max_status").val() == "25"
                    && ($("#status").val() == "50" || $("#status").val() == "25")
                    && (lastActivity == "7")
                    && isFinance
                )) {
                    $("#btnReturn").remove();
                }
            }

            if ($("#status").val() == "50") {
                $("#btnReturn").remove();
            }
        });

        $(document).on("click", "#btnPrint", function () {
            link = "PrintPreview.aspx?id=" + _id;
            top.window.open(link);
        });

        $(document).on("click", "#btnSavePrintOut", function () {
            let procurement_address_temp = $("select[name='po.procurement_address'] option:selected").val();
            blockScreenOL();

            const data = {
                po_id: _id,
                po_procurement_address: procurement_address_temp,
                po_legal_entity: $("select[name='po.legal_entity'] option:selected").val(),
            };
            $.ajax({
                url: '<%= Page.ResolveUrl("~/" +based_url+ service_url + "/SavePrintOutPO") %>',
                data: JSON.stringify(data),
                dataType: 'json',
                type: 'post',
                contentType: "application/json; charset=utf-8",
                success: function (response) {
                    const output = JSON.parse(response.d);
                    if (output.result != "success") {
                        alert(output.message);
                    } else {
                        alert("Purchase order print out has been updated.");
                        $('#PrintOutForm').modal('hide');
                        link = "PrintPO.aspx?id=" + _id;
                        top.window.open(link);
                        location.href = "Detail.aspx?id=" + _id;
                    }
                    unBlockScreenOL();
                },
                error: function (jqXHR, exception) {
                    unBlockScreenOL();
                }
            });
        });

        function UploadFileAPI(actionType) {
            /*blockScreen();*/
            blockScreenOL();
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
                    unBlockScreenOL();
                    var stringJS = '{' + response.substring(
                        response.indexOf("{") + 1,
                        response.lastIndexOf("}")
                    ) + '}';
                    var output = JSON.parse(stringJS);

                    if (actionType != "submit") {
                        if (output.result !== "success") {
                            alert(output.message);
                        } else {
                            alert("File uploaded successfully.");
                        }
                    } else {
                        alert("Request has been " + btnAction + " successfully.");
                        if (btnAction === "saved") {
                            if ($("[name='pr.id']").val() == "") {
                                location.href = "input.aspx?id=" + output.id;
                            } else {
                                location.reload();
                            }
                        } else {
                            location.href = "/workspace/mysubmissions";/*"/workspace/My-Submissions.aspx";*/
                        }
                    }
                },
                error: function (jqXHR, exception) {
                    unBlockScreenOL();
                }


            });
            $("#file_name").val("");
        }
    </script>
</asp:Content>
