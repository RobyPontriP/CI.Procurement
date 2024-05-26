<%@ Page MasterPageFile="~/Procurement.Master" Language="C#" AutoEventWireup="true" CodeBehind="Approval.aspx.cs" Inherits="myTree.WebForms.Modules.VendorSelection.Approval" %>

<%@ Register Src="~/Usc/uscRecentComment.ascx" TagName="recentcommentDetail" TagPrefix="uscCommentDetail" %>
<%@ Register Src="~/QuotationAnalysis/uscQADetail.ascx" TagName="qadetail" TagPrefix="uscQADetail" %>
<%@ Register Src="~/PurchaseRequisition/uscHistoricalInformation.ascx" TagName="historicalInformation" TagPrefix="uscHistoricalInformation" %>
<asp:Content ID="Content1" ContentPlaceHolderID="AppHead" runat="server">
    <title>Single Sourcing Approval</title>

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

    <uscQADetail:qadetail ID="qadetail1" runat="server" />


    <input type="hidden" id="sn" value="<%=sn %>" />
    <input type="hidden" id="activity_id" value="<%=activity_id %>" />
    <input type="hidden" id="roles" value="<%=approval_notes.activity_name %>"/>

    <script>
        var dataApproval = new Object();
        var btnActionSubmit = "";
        var approval_type = "<%=approval_type%>";

        $(document).ready(function () {
            $('.btnApproval').show();
            document.getElementById('btnApprove').dataset.action = "<%=approval_type%>";
            $("#btnApprove").html("<%=approval_type_label%>");

            $('.divComment').show();
            $(".btnDelete").hide();

            if (approval_type == "recommended") {
                $("#pageTitle").html("Single Sourcing Recommendation");
            }

            $(".guideline_").prop('readonly', true);
        });

        $(document).on("click", "#btnReject,#btnApprove,#btnRevise", function () {
            btnActionSubmit = $(this).data("action").toLowerCase();
            sleep(1).then(() => {
                blockScreenOL();
            });

            sleep(300).then(() => {
                SubmitWF();
            }).then(() => {
            });
        });

        function SubmitWF() {
            let errorMsg = "";

            errorMsg += ApprovalValidation();

            if (errorMsg != "") {
                errorMsg = "Please correct the following error(s):" + errorMsg;
                showErrorMessage(errorMsg);
                unBlockScreenOL();
            } else {
                dataApproval.id = vsItemsMain[0]["vs_id"];
                dataApproval.vs_no = vsItemsMain[0]["vs_no"];
                dataApproval.status_id = vsItemsMain[0]["status_id"];

                let workflow = new Object();
                workflow.sn = $("#sn").val();
                workflow.activity_id = $("#activity_id").val();
                workflow.roles = $("#roles").val();
                workflow.action = btnActionSubmit;
                workflow.comment = $("[name='comments']").val();
                workflow.current_status = $("#status").val();

                let approvalObj = new Object();
                approvalObj.approval_type = "<%=approval_type%>";

                var _data = {
                    "submission": JSON.stringify(dataApproval),
                    "workflows": JSON.stringify(workflow),
                    "strApprovalObj": JSON.stringify(approvalObj)
                };

                $.ajax({
                    url: "<%=Page.ResolveUrl("Approval.aspx/SubmitWF")%>",
                    data: JSON.stringify(_data),
                    dataType: 'json',
                    type: 'post',
                    contentType: "application/json; charset=utf-8",
                    success: function (response) {
                        var output = JSON.parse(response.d);
                        if (output.result !== "success") {
                            alert(output.message);
                        } else {
                            alert("Single sourcing " + $("#vs_no").val() + " has been " + btnActionSubmit + " successfully.");
                        }

                        if (isAdmin == "true") {
                            location.href = '<%=Page.ResolveUrl("~/QuotationAnalysis/list.aspx")%>';
                        } else {
                            location.href = "/workspace";
                        }

                        unBlockScreenOL();
                    }
                });
            }
        }

        function ApprovalValidation() {
            let msg = "";
            if (btnActionSubmit != "approved" && btnActionSubmit != "recommended") {
                if ($("[name='comments']").val().trim() == null || $("[name='comments']").val().trim() == "") {
                    msg += "<br/> - Comments is required";
                }
            }

            return msg;
        }
    </script>

</asp:Content>