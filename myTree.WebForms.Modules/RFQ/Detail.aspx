<%@ Page MasterPageFile="~/Procurement.Master" Language="C#" AutoEventWireup="true" CodeBehind="Detail.aspx.cs" Inherits="myTree.WebForms.Modules.RFQ.Detail" %>
<%@ Register Src="~/Usc/uscRecentComment.ascx" TagName="recentcomment" TagPrefix="uscComment" %>
<%@ Register Src="~/RFQ/uscDetail.ascx" TagName="detail" TagPrefix="uscDetail" %>
<%@ Register Src="~/Usc/uscCancellationForm.ascx" TagName="cancellationform" TagPrefix="uscCancellation" %>
<asp:Content ID="Content1" ContentPlaceHolderID="AppHead" runat="server">
    <title>Request for Quotation</title>
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
    <!-- Cancellation Form -->
    <uscCancellation:cancellationform ID="cancellationForm" runat="server" />
    <!-- Recent comment -->
    <uscComment:recentcomment ID="recentComment" runat="server" />
    <uscDetail:detail id="udetail" runat="server"/>
    <input type="hidden" name="action" id="action"/>
    <input type="hidden" name="doc_id" id="doc_id" value="<%=_id%>"/>
    <input type="hidden" name="doc_type" id="doc_type" value="RFQ"/>
   
    <script>
        var _id = "<%=_id%>";
        var blankmode = "<%=blankmode%>";
        var isAdmin = "<%=isAdmin ?"true":"false"%>";
        isAdmin = (isAdmin === "true");

        $(document).on("click", "#btnEdit", function () {
            parent.location.href = "Input.aspx?id=" + _id;
        });

        $(document).on("click", "#btnCopy", function () {
            parent.location.href = "Input.aspx?copy_id=" + _id;
        });

        $(document).on("click", "#btnCancel", function () {
            $("#CancelForm").modal("show");
        });

        $(document).on("click", "#btnSaveCancellation", function () {
            var errorMsg = "";
            if ($.trim($("#cancellation_text").val()) == "" && $.trim($("#cancellation_file").val()) == "") {
                errorMsg += "<br/> - Reason for cancellation is required.";
            }
            errorMsg += FileValidation();

            if (errorMsg == "") {
                uploadCancellationFile();
            } else {
                errorMsg = "Please correct the following error(s):" + errorMsg;

                $("#cform-error-message").html("<b>" + errorMsg + "<b>");
                $("#cform-error-box").show();
                $('.modal-body').animate({ scrollTop: 0 }, 500);
            }
        });

        function uploadCancellationFile() {
            $("#action").val("upload");
            var form = $('form')[0];
            var formData = new FormData(form);

            $.ajax({
                type: "POST",
                url: "<%=Page.ResolveUrl("~/Service.aspx")%>",
                data: formData,
                processData: false,
                contentType: false,
                success: function (response) {
                    var output = JSON.parse(response);

                    if (output.result == "success" || output.result == "") {
                        submitCancellation();
                    } else {
                        alert(output.message);
                    }
                    $("#action").val("");
                }
            });
        }

        function submitCancellation() {
            var data = new Object();
            data.id = _id;
            data.comment = $("#cancellation_text").val();
            data.comment_file = $("#cancellation_file").val();
            $.ajax({
                url: "<%=Page.ResolveUrl("Detail.aspx/RFQCancellation")%>",
                data: JSON.stringify(data),
                dataType: 'json',
                type: 'post',
                contentType: "application/json; charset=utf-8",
                success: function (response) {
                    var output = JSON.parse(response.d);
                    if (output.result != "success") {
                        alert(output.message);
                    } else {
                        alert($("#rfq_no").val() + " has been cancelled successfully");
                        blockScreen();
                        if (blankmode == "1") {
                            parent.$.colorbox.close();
                        } else {
                            parent.location.href = "List.aspx";
                        }
                    }
                }
            });
        }

        $(document).on("click", "#btnPrint", function () {
            if ($("[name='rfq.template']").val() != "") {
                link = "PrintPreview.aspx?id=" + _id + "&template=" + $("[name='rfq.template']").val();
                top.window.open(link);
            } else {
                alert("Please select a template.");
            }
        });

        $(document).on("click", "#btnSendEmail", function () {
            var template = $("[name='rfq.template']").val();
            var email = $("#email").text();
            
            if (template != "" && email != "") {
                var data = new Object();
                data.id = _id;
                data.template = template;
                $.ajax({
                    url: "<%=Page.ResolveUrl("Detail.aspx/SendEmail")%>",
                    data: JSON.stringify(data),
                    dataType: 'json',
                    type: 'post',
                    contentType: "application/json; charset=utf-8",
                    success: function (response) {
                        var output = JSON.parse(response.d);
                        if (output.result != "success") {
                            alert(output.message);
                        } else {
                            alert("Email has been sent successfully");
                        }
                    }
                });
            } else {
                var errorMsg = ""
                if (template == "") {
                    errorMsg += "<br>- Please select a template.";
                }

                if (email == "") {
                    errorMsg += "<br>- Supplier email is required."
                }

                if (errorMsg != "") {
                    showErrorMessage(errorMsg)
                }
                
            }
        });

        $(document).on("click", "#btnClose", function () {
            if (blankmode == "1") {
                parent.$.colorbox.close();  
            } else {
                parent.location.href = "List.aspx";
            }
        });

        $(document).on("click", "#btnAuditTrail", function () {
            parent.ShowCustomPopUp("<%= ResolveUrl("~"+based_url+"/AuditTrail.aspx?blankmode=1&module=requestforquotation&id=" + _id) %>");
        });
    </script>
</asp:Content>
