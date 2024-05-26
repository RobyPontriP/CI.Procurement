<%@ Page MasterPageFile="~/Procurement.Master" Language="C#" AutoEventWireup="true" CodeBehind="SingleSourcing.aspx.cs" Inherits="myTree.WebForms.Modules.VendorSelection.SingleSourcing" %>


<%@ Register Src="~/QuotationAnalysis/uscQADetail.ascx" TagName="qadetail" TagPrefix="uscQADetail" %>
<asp:Content ID="Content1" ContentPlaceHolderID="AppHead" runat="server">
    <title>Single Sourcing Justification</title>

</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="AppBody" runat="server">
    <div class="floatingBox" id="error-box" style="display: none">
        <div class="alert alert-error" id="error-message">
        </div>
    </div>

    <uscQADetail:qadetail ID="qadetail1" runat="server" />

    <input type="hidden" id="sn" value="<%=sn %>" />
    <input type="hidden" id="activity_id" value="<%=activity_id %>" />
    <input type="hidden" id="roles" value="<%=approval_notes.activity_name %>" />
    <input type="hidden" id="cancelSS" value="0" />

    <script>
        var dataJustification = new Object();
        var btnActionSubmit = "";
        let ss_guideline = "";

        $(document).ready(function () {
            <%--$("#page_name").val("<%=page_type%>");--%>
            $("#btnSubmitJustification").show();

            if ($("#status").val() == "10" || $("#status").val() == "35") {
                $("#btnCancelSS").show();
            }

            $(".btnDelete").hide();
            $("#lblSSChecklist").show();
        });

        $(document).on("click", "#btnCancelSS", function () {
            /*SubmitJustification($(this).data("action"));*/
            $("#cancelSS").val('1');
            $("#CancelForm").modal("show");
        });

        $(document).on("click", "#btnSubmitJustification", function () {
            $("#cancelSS").val('0');
            SubmitJustification($(this).data("action"));
        });

        function SubmissionJustification(action) {
            let errorMsg = SubmitJustificationValidation();
            if (errorMsg != "") {
                showErrorMessage(errorMsg);
                unBlockScreenOL();
            } else {
                dataJustification.id = vsItemsMain[0]["vs_id"];
                dataJustification.vs_no = vsItemsMain[0]["vs_no"];
                dataJustification.status_id = vsItemsMain[0]["status_id"];
                dataJustification.singlesourcing = vsItemsMain[0]["singlesourcing"];
                dataJustification.justification_singlesourcing = $("#justification_singlesourcing").val();
                dataJustification.justification_file_singlesourcing = $("#justification_file_singlesourcing").val();
                dataJustification.ss_guideline = ss_guideline;
                
                if (dataJustification.singlesourcing.toString() == "0") {
                    dataJustification.singlesourcing = window.location.search.substr(window.location.search.length - 1);
                }

                let workflow = new Object();
                workflow.sn = $("#sn").val();
                workflow.activity_id = $("#activity_id").val();
                workflow.roles = $("#roles").val();
                workflow.action = action;

                if (action != "cancelled") {
                    if ($("[name='comments']").val().trim() == "" || $("[name='comments']").val().trim() == null) {
                        /*workflow.comment = $("#justification_singlesourcing").val();*/
                    } else {
                        workflow.comment = $("[name='comments']").val();
                    }                    
                    workflow.comment_file = $("#justification_file_singlesourcing").val();
                } else {
                    workflow.comment = $("#cancellation_text").val();
                    workflow.comment_file = $("#cancellation_file").val();
                }
                
                workflow.current_status = $("#status").val();

                var _data = {
                    "submission": JSON.stringify(dataJustification),
                    "workflows": JSON.stringify(workflow)
                };
                console.log(dataJustification.singlesourcing);
                $.ajax({
                    url: "<%=Page.ResolveUrl("SingleSourcing.aspx/Submit")%>",
                    data: JSON.stringify(_data),
                    dataType: 'json',
                    type: 'post',
                    contentType: "application/json; charset=utf-8",
                    success: function (response) {
                        var output = JSON.parse(response.d);
                        if (output.result !== "success") {
                            alert(output.message);
                        }

                        if ($("#cancelSS").val() == 1) {
                            alert("Single sourcing " + $("#vs_no").val() + " has been cancelled successfully.");
                        } else {
                            alert("Request has been " + action);
                        }                        

                        unBlockScreenOL();

                        if (isAdmin == "true") {
                            location.href = '<%=Page.ResolveUrl("~/QuotationAnalysis/list.aspx")%>';
                        } else {
                            location.href = "/workspace/mysubmissions";
                        }
                    }
                });
            }
            
        }

        $(document).on("click", ".btnFileUploadJustification", function () {
            let errorMsg = "";
            btnFileUpload = this;
            /*var errorMsg = GeneralValidation();*/
            errorMsg += uploadValidationResult.not_found_message || '';
            errorMsg += FileValidation();

            if (errorMsg == "") {
                $("#action").val("fileupload");

                $("#file_name").val($(this).closest("div").find("input:file").val().split('\\').pop());

                filenameupload = $("#file_name").val();

                if (!$("#file_name").val()) {
                    alert("Please choose file first");
                    return false;
                } else {
                    let errorMsg = FileValidation();
                    if (FileValidation() !== '') {
                        if ($(this).data("type") == '') {
                            $("#error-message").html("<b>" + "- Justification document(s):" + "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" + errorMsg + "<b>");
                            $("#error-box").show();
                            $('.modal-body').animate({ scrollTop: 0 }, 500);
                        } else {
                            showErrorMessage(errorMsg);
                        }

                        return false;
                    }

                    UploadFileAPI("justification");

                    $(this).closest("div").find("input[name$='justification.uploaded']").val("1");
                    $(this).closest("div").find("input[name$='justification_file']").css({ 'background-color': '' });
                }
            } else {
                showErrorMessage(errorMsg);
            }
        });

        function SubmitJustificationValidation() {
            let errorMsg = "";
            ss_guideline = "";

            $('#tblSingleSourceChecklist').find('input[type=checkbox]:checked').each(function () {
                ss_guideline += ($(this).data("gl") + ";");
            });

            if (ss_guideline.trim() == null || ss_guideline.trim() == "") {
                errorMsg += "<br/> - Single source checklist is required.";
            }

            if ($("#justification_singlesourcing").val().trim() == null || $("#justification_singlesourcing").val().trim() == "") {
                errorMsg += "<br/> - Single source justification is required.";
            }

            if ($("input[name='justification_file']").val() == "" || $("input[name='justification_file']").val() == null) {
                if (vsItemsMain[0]["justification_file_singlesourcing"] == "" || vsItemsMain[0]["justification_file_singlesourcing"] == null || $("input[name='justification.uploaded']").val() == "0") {
                    errorMsg += "<br/> - Single source justification file is required.";
                }
                
            } else {
                if ($("input[name='justification.uploaded']").val() == "0") {
                    errorMsg += "<br/> - There are justification file that have not been uploaded, please upload first.";
                    $("input[name='justification_file']").css({ 'background-color': 'rgb(245, 183, 177)' });
                }
            }

            return errorMsg;
        }

        function GenerateFileJustificationLink(row, filename) {
            let vs_id = '';
            let linkdoc = '';

            if ($("[name='doc_id']").val() == '' || $("[name='doc_id']").val() == null) {
                vs_id = $("[name='docidtemp']").val();
                linkdoc = "FilesTemp/" + vs_id + "/" + filename + "";
            } else {
                vs_id = $("[name='doc_id']").val();
                linkdoc = "Files/" + vs_id + "/" + filename + "";
            }

            $(row).closest("div").find("input[name$='justification_file']").hide();

            $(row).closest("div").find(".editJustificationFile").show();
            $(row).closest("div").find("a#linkDocumentJustificationHref").attr("href", linkdoc);
            $(row).closest("div").find("a#linkDocumentJustificationHref").text(filename);
            $(row).closest("div").find(".linkDocumentJustification").show();
            $(row).closest("div").find(".btnFileUploadJustification").hide();

            $(row).closest("div").find("input[name$='vs.justification_file_singlesourcing']").val(filename);
        }

        $(document).on("click", ".editJustificationFile", function () {
            $(this).closest("div").find("input[name='justification_file']").val("");
            $(this).closest("div").find("input[name='vs.justification_file_singlesourcing']").val("");
            var obj = $(this).closest("div").find("input[name='justification_file']");
            var link = $(this).closest("div").find(".linkDocumentJustification");

            $(this).closest("div").find("input[name$='justification.uploaded']").val("0");
            $(this).closest("div").find(".btnFileUploadJustification").show();

            $(obj).show();
            $(link).hide();
            $(this).hide();
        });
    </script>

</asp:Content>
