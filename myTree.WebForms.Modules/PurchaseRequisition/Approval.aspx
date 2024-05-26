<%@ Page MasterPageFile="~/Procurement.Master" Language="C#" AutoEventWireup="true" CodeBehind="Approval.aspx.cs" Inherits="myTree.WebForms.Modules.PurchaseRequisition.Approval" %>

<%@ Register Src="~/Usc/uscRecentComment.ascx" TagName="recentcommentDetail" TagPrefix="uscCommentDetail" %>
<%@ Register Src="~/PurchaseRequisition/uscPRDetail.ascx" TagName="prdetail" TagPrefix="uscPRDetail" %>

<asp:Content ID="Content1" ContentPlaceHolderID="AppHead" runat="server">
    <title>Purchase Requisition Approval</title>
    <style>
        .controls {
            padding-top: 5px;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="AppBody" runat="server">
    <div class="floatingBox" id="error-box" style="display: none">
        <div class="alert alert-error" id="error-message">
        </div>
    </div>
    <%if(approval_notes != null && !string.IsNullOrEmpty(approval_notes.activity_desc)) {  %>
    <div class="alert alert-info" id="approval-notes">
        <%=approval_notes.activity_desc %>
    </div>
    <%}%>
    <!-- Recent comment -->
    <uscCommentDetail:recentcommentDetail ID="recentCommentDetail" runat="server" />
    <div class="containerHeadline">
        <h2>Purchase requisition information(s)</h2>
    </div>
    <div class="row-fluid">
        <div class="floatingBox">
            <div class="container-fluid">
                <!-- PR profile -->
                <uscPRDetail:prdetail ID="prdetail1" runat="server" />
                <input type="hidden" id="sn" value="<%=sn %>"/>
                <input type="hidden" id="activity_id" value="<%=activity_id %>"/>
                <%--<input type="hidden" id="roles" value="<%=approval_notes.activity_name %>"/>--%>
                <input type="hidden" id="roles" value="<%=approval_notes.activity_name %>"/>
                <input type="hidden" id="accessToken" value="<%=accessToken %>"/>
                <div class="control-group last">
                    <div class="controls">
                        <button id="btnClose" class="btn" type="button">Close page</button>&nbsp;&nbsp;&nbsp;
                        <button id="btnPrint" class="btn btn-success" type="button">Print PR</button>
                        <button id="btnReject" class="btn btn-success" data-action="rejected" type="button">Reject</button>
                        <button id="btnApprove" class="btn btn-success" data-action="approved" type="button">Approve</button>                        
                    </div>
                </div>
            </div>
        </div>
    </div>
    <script>
        var taskType = "<%=taskType%>";

        var _id = "<%=_id%>";
        var btnAction = "", btnAlert = "";
        var workflow = new Object();

        $(document).ready(function () {
            if($("#activity_id").val()=="5"){
                $("#btnReject").text("Insufficient budget");
                $("#btnApprove").text("Budget is sufficient");

                $("#btnReject").data("action", "insufficient budget");
                $("#btnApprove").data("action", "budget is sufficient");
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

        $(document).on("click", "#btnPrint", function () {
            link = "PrintPreview.aspx?id=" + _id;
            top.window.open(link);
        });

        $(document).on("click", "#btnReject,#btnApprove", function () {
            sleep(1).then(() => {
                blockScreenOL();
            });

            sleep(300).then(() => {
                btnAction = $(this).data("action").toLowerCase();

                workflow.sn = $("#sn").val();
                workflow.activity_id = $("#activity_id").val();
                workflow.access_token = $("#accessToken").val();
                workflow.roles = $("#roles").val();
                workflow.action = btnAction;
                workflow.comment = $("[name='comments']").val();
                workflow.current_status = $("#status").val();
                workflow.is_direct_to_finance = $("#is_direct_to_finance").val();
                workflow.purchasing_process = $("#purchasing_process").val();
                workflow.purchase_type = $("#purchase_type").val();
                workflow.amount = $("#total_estimated_usd").val();

                $("#error-box").hide();
                if ((btnAction === "rejected" || btnAction === "insufficient budget") && workflow.comment === "") {
                    unBlockScreenOL();
                    showErrorMessage("<br /> - Comments is required");
                } else {
                    var _data = {
                        "id": _id,
                        "workflows": JSON.stringify(workflow)
                    };

                    $.ajax({
                        url: 'Approval.aspx/Submit',
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
                                if (workflow.activity_id == "5") {
                                    if (btnAction == "insufficient budget") {
                                        alert("Budget is insufficient. Request has been rejected successfully.");
                                    } else {
                                        alert("Budget is sufficient. Request has been approved successfully.");
                                    }
                                } else {
                                    alert("Request has been " + btnAction + " successfully.");
                                }
                                //blockScreen();
                                if (taskType == "admin") {
                                    location.href = "Tasklist.aspx";
                                } else if (taskType == "adminteam") {
                                    location.href = "Tasklist.aspx?action=team";
                                } else {
                                    location.href = "/workspace";
                                }
                            }
                        }
                    });
                }
                
                return;
            }).then(() => {
            });

            
        });
    </script>
</asp:Content>
