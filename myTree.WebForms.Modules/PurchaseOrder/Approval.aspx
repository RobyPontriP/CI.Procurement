<%@ Page MasterPageFile="~/Procurement.Master"  Language="C#" AutoEventWireup="true" CodeBehind="Approval.aspx.cs" Inherits="Procurement.PurchaseOrder.Approval" %>

<%@ Register Src="~/Usc/uscRecentComment.ascx" TagName="recentcommentDetail" TagPrefix="uscCommentDetail" %>
<%--<%@ Register Src="~/PurchaseOrder/uscPurchaseOrderDraft.ascx" TagName="pod" TagPrefix="uscpod" %>--%>
<%@ Register Src="~/PurchaseOrder/uscPurchaseOrderPrint.ascx" TagName="pod" TagPrefix="uscpodprint" %>
<%@ Register Src="~/PurchaseOrder/uscVendorSelection.ascx" TagName="povs" TagPrefix="uscpovs" %>
<%@ Register Src="~/PurchaseRequisition/uscHistoricalInformation.ascx" TagName="historicalInformation" TagPrefix="uscHistoricalInformation" %>

<asp:Content ID="Content1" ContentPlaceHolderID="AppHead" runat="server">
    <title>Purchase Order</title>
    <style>
        .controls {
            padding-top: 5px;
        }

        #tblPODraft tr.noborder td {
            border-top: 0 !important;
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
    <div class="row-fluid">
        <div class="floatingBox" style="margin-bottom:0px;">
            <div class="container-fluid">
                <div class="controls text-right">
                    <button id="btnViewWorkflow" class="btn btn-success" type="button">View workflow</button>
                    <a hidden id="btnViewWorkflowA" href="<%= HttpContext.Current.Request.Url.GetLeftPart(UriPartial.Authority) + "/Workspace/ViewWorkflow?Id=" + _id + "&Module=PurchaseOrder&blankmode=1" %>"></a>
                    <%  if (isAdmin)
                        {
                        %>
                    <button id="btnAuditTrail" class="btn btn-success" type="button">Audit trail</button>
                        <%  } %>                       
                </div> 
            </div>
        </div>
    </div>
    <!-- Recent comment -->
    <uscCommentDetail:recentcommentDetail ID="recentCommentDetail" runat="server" />
    <div class="row-fluid" style="margin-bottom:0px;">
        <div class="span12 tabContainer">
            <!-- ==================== TAB NAVIGATION ==================== -->
            <ul class="nav nav-tabs">
                <li class="active">
                    <a href="#generalInformation" target="_top">Purchase order information</a>
                </li>
                <li class=""><a href="#vsInformation" target="_top">PO background information</a></li>
                <li class=""><a href="#otherInformation" target="_top">Historical information</a></li>
            </ul>
            <!-- ==================== END OF TAB NAVIGATIION ==================== -->
                
            <div class="row-fluid">
                <div class="tabContent" id="generalInformation" style="display: block;">
                    <div class="floatingBox table" style="margin-bottom:0px;">
                        <div class="container-fluid">
                            <input type="hidden" id="sn" value="<%=sn %>" />
                            <input type="hidden" id="activity_id" value="<%=activity_id %>" />
                            <input type="hidden" id="roles" value="<%=approval_notes.activity_name %>"/>
                            <!-- PO detail -->
                            <uscpodprint:pod ID="pod1" runat="server" />
                            <%--<div class="control-group last">
                                <label class="control-label">
                                    Comments
                                </label>
                                <div class="controls">
                                    <textarea name="comments" maxlength="2000" rows="3" class="span10 textareavertical" placeholder="Comments"></textarea>   
                                </div>
                            </div>--%>
                        </div>
                    </div>
                </div>
                <!-- ==================== SECOND TAB CONTENT ==================== -->
                <div class="tabContent" id="vsInformation" style="display: none;">
                    <div class="floatingBox table" style="margin-bottom:0px;">
                        <div class="container-fluid">
                            <!-- Business partner selection information -->
                            <uscpovs:povs ID="povs1" runat="server" />
                        </div>
                    </div>
                </div>
                <!-- ==================== THIRD TAB CONTENT ==================== -->
                <div class="tabContent" id="otherInformation" style="display: none;">
                    <div class="floatingBox table" style="margin-bottom:0px;">
                        <div class="container-fluid">
                            <!-- Historical information -->
                            <uscHistoricalInformation:historicalInformation ID="historicalInformation1" runat="server" />
                        </div>
                    </div>
                </div>
            </div>
            <div class="row-fluid">
                <div class="floatingBox" style="margin-bottom:0px;">
                    <div class="container-fluid">
                        <div class="control-group last">
                                <label class="control-label">
                                    Comments
                                </label>
                                <div class="controls">
                                    <textarea name="comments" maxlength="2000" rows="3" class="span10 textareavertical" placeholder="Comments"></textarea>   
                                </div>
                            </div>
                        <div class="controls">
                            <button id="btnClose" class="btn" type="button">Close page</button>&nbsp;&nbsp;&nbsp;
                            <button id="btnReject" class="btn btn-success" data-action="rejected" type="button">Reject</button>
                            <button id="btnRevise" class="btn btn-success" data-action="requested for revision" type="button">Request for revision</button>
                            <button id="btnApprove" class="btn btn-success" data-action="<%=approval_type %>" type="button"><%=approval_type_label %></button>
                        </div> 
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
        var purchase_order = new Object();

        $(document).ready(function () {
            $(".for-print").hide();
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

        $(document).on("click", "#btnReject,#btnApprove,#btnRevise", function () {
            btnAction = $(this).data("action").toLowerCase();

            purchase_order.id = _id;
            purchase_order.po_no = $("#po_no").val();
            purchase_order.remarks = $("#po_remark").val();

            workflow.sn = $("#sn").val();
            workflow.activity_id = $("#activity_id").val();
            workflow.roles = $("#roles").val();
            workflow.action = btnAction;
            workflow.comment = $("[name='comments']").val();
            workflow.current_status = $("#status").val();

            $("#error-box").hide();
            if ((btnAction === "rejected" || btnAction === "requested for revision") && workflow.comment === "") {
                showErrorMessage("<br /> - Comments is required");
            } else {
                var _data = {
                    /*"id": _id,*/
                    "purchaseorders": JSON.stringify(purchase_order),
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
                        } else {
                            alert("Purchase order " + $("#po_number").val() + " has been " + btnAction + " successfully.");
                            blockScreen();
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
        });

        $(document).on("click", "#btnAuditTrail", function () {
            /*parent.ShowCustomPopUp("/procurement/audittrail.aspx?blankmode=1&module=purchaseorder&id=" + _id);*/
            parent.ShowCustomPopUp("<%= ResolveUrl("~"+based_url+"/AuditTrail.aspx?blankmode=1&module=purchaseorder&id=" + _id) %>");
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
                ShowCustomPopUp("<%= HttpContext.Current.Request.Url.GetLeftPart(UriPartial.Authority) + "/Workspace/ViewWorkflow?Id=" + _id + "&Module=PurchaseOrder&blankmode=1" %>");
            }
        });
    </script>
</asp:Content>