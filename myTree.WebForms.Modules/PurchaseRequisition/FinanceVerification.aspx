﻿<%@ Page MasterPageFile="~/Procurement.Master" Language="C#" AutoEventWireup="true" CodeBehind="FinanceVerification.aspx.cs" Inherits="myTree.WebForms.Modules.PurchaseRequisition.FinanceVerification" %>


<%@ Register Src="~/Usc/uscRecentComment.ascx" TagName="recentcomment" TagPrefix="uscComment" %>
<%@ Register Src="uscPREdit.ascx" TagName="predit" TagPrefix="uscPREdit" %>

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
    <%if (approval_notes != null && !string.IsNullOrEmpty(approval_notes.activity_desc))
        {  %>
    <div class="alert alert-info" id="approval-notes">
        <%=approval_notes.activity_desc %>
    </div>
    <% } %>
    <%--<%  if (authorized.admin || authorized.procurement_user)--%>
    <%  if (isAdmin || isUser)
        { %>
    <div class="row-fluid">
        <div class="floatingBox" style="margin-bottom: 0px;">
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
                <uscPREdit:predit ID="predit1" runat="server" />
                <input type="hidden" id="sn" value="<%=sn %>" />
                <input type="hidden" id="activity_id" value="<%=activity_id %>" />
                <input type="hidden" id="accessToken" value="<%=accessToken %>" />
                <%--<input type="hidden" id="roles" value="<%=approval_notes.activity_name %>"/>--%>
                <input type="hidden" id="roles" value="<%=approval_notes.activity_name %>" />
                <input type="hidden" id="_pr_no" />
                <div class="control-group last">
                    <div class="controls">
                        <button id="btnClose" class="btn" type="button">Close page</button>&nbsp;&nbsp;&nbsp;
                        <button id="btnPrint" class="btn btn-success" type="button">Print PR</button>
                        <button id="btnSave" class="btn btn-success" data-action="saved" type="button">Save</button>
                        <button id="btnReject" class="btn btn-success" data-action="rejected" type="button">Reject</button>
                        <button id="btnRevise" class="btn btn-success" data-action="requested for revision" type="button">Request for revision</button>
                        <button id="btnVerify" class="btn btn-success" data-action="verified" type="button">Verify</button>
                        &nbsp;&nbsp;&nbsp;<button id="btnRedirect" class="btn btn-success" data-action="redirect" type="button">Redirect to procurement unit</button>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <script>
        var taskType = "<%=taskType%>";
        var btnAction = "";
        var ActionName = "";
        var workflow = new Object();

        $(document).on("click", "#btnClose", function () {
            if (taskType == "admin") {
                location.href = "Tasklist.aspx";
            } else if (taskType == "adminteam") {
                location.href = "Tasklist.aspx?action=team";
            } else {
                location.href = "/workspace";
            }
        });

        $(document).on("click", "#btnSave,#btnReject,#btnRevise,#btnVerify,#btnRedirect", function () {
            /*blockScreen();*/
            $("#error-box").hide();
            btnAction = $(this).data("action").toLowerCase();
            if (btnAction == "redirect") {
                ActionName = "redirected"
            }
            SubmitValidation();
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
            data.details = PRDetail;

            workflow.sn = $("#sn").val();
            workflow.activity_id = $("#activity_id").val();
            workflow.roles = $("#roles").val();
            workflow.action = btnAction;
            workflow.comment = $("[name='comments']").val();
            workflow.access_token = $("#accessToken").val();

            if (btnAction === "verified") {
                errorMsg += GeneralValidation();
            } else if (btnAction === "rejected" || btnAction === "requested for revision" || btnAction === "redirect") {
                if ($.trim($("[name='comments']").val()) === "") {
                    errorMsg += "<br /> - Comments is required."
                }
            }

            if (errorMsg !== "") {
                showErrorMessage(errorMsg);

                return false;
            } else {
                var _data = {
                    "submission": JSON.stringify(data),
                    "deletedIds": JSON.stringify(deletedId),
                    "workflows": JSON.stringify(workflow)
                };
                blockScreen();
                Submit(_data);
            }
        }

        function Submit(_data) {
            $.ajax({
                url: 'FinanceVerification.aspx/Save',
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
                            $("#_pr_no").val(output.pr_no);
                            $("input[name='doc_id']").val(output.id);
                            $("input[name='action']").val("upload");
                            /* UploadFile();*/
                            if (btnAction == "requested for revision") {
                                alert("Request for revision has been submitted successfully.");
                            } else if (btnAction == "verified") {
                                alert("Request has been " + btnAction + " successfully.");
                            } else if (btnAction == "redirect") {
                                alert("Request has been " + ActionName + " successfully.");
                            } else {
                                alert("Request has been " + btnAction + " successfully.");
                            }
                  /*          blockScreen();*/
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

        function UploadFile() {
            var form = $('form')[0];
            var formData = new FormData(form);

            $.ajax({
                type: "POST",
                <%--url: "<%=service_url%>",--%>
                url: "<%= Page.ResolveUrl("~/" + based_url + service_url) %>",
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
        }

        $(document).on("click", "#btnAuditTrail", function () {
            parent.ShowCustomPopUp("audittrail.aspx?blankmode=1&module=purchaserequisition&id=" + $("[name='pr.id']").val());
        });

        $(document).on("click", "#btnPrint", function () {
            link = "PrintPreview.aspx?id=" + _id;
            top.window.open(link);
        });
    </script>
</asp:Content>

