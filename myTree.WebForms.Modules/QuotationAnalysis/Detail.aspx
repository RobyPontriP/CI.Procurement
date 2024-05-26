<%@ Page MasterPageFile="~/Procurement.Master" Language="C#" AutoEventWireup="true" CodeBehind="Detail.aspx.cs" Inherits="myTree.WebForms.Modules.VendorSelection.Detail" %>

<%@ Register Src="~/QuotationAnalysis/uscQADetail.ascx" TagName="qadetail" TagPrefix="uscQADetail" %>



<asp:Content ID="Content1" ContentPlaceHolderID="AppHead" runat="server">
    <title>Quotation Analysis</title>
    
    <style>
    #JustificationForm.modal-dialog {
        margin: auto 5%;
        width: 70%;
        height: 200px !important;
    }
</style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="AppBody" runat="server">
    <div class="floatingBox" id="error-box" style="display: none">
        <div class="alert alert-error" id="error-message">
        </div>
    </div>

    <uscQADetail:qadetail ID="qadetail1" runat="server" />
    
    <script>
        var dataJustification = new Object();
        var listSingleSourcing = [{ id: "1", Text: "PR Requester" }, { id: "2", Text: "Procurement" }];
        var singlesourcing = "";
        let btnActionJust = "";
        let accessButton = false;

        $(document).ready(function () {
            $("#page_type").val("<%=page_type%>");
            $('.btnDetail').show();

            if ($("#status").val() != "25") {
                $("#btnCancel").hide();
            }

            var cboSingleSourcing = $("select[name='vs.singlesourcing']");
            generateCombo(cboSingleSourcing, listSingleSourcing, "id", "Text", true);
            <%--$(cboSingleSourcing).val("<%=VS.singlesourcing%>").change();--%>
            Select2Obj(cboSingleSourcing, "Single sourcing");

            

            if (isSameOffice == "true" && (isProcurementUser == true || isAdmin == true)) {
                accessButton = true;
            }

            if (headerArr.length == 1 && $("#page_type").val() == "DETAIL") 
            {
                if (accessButton == true)
                {
                    $("#btnJustification").show();
                }
                $(".guideline_").prop('readonly', true);
            }

            $('#btnEdit').hide();
            $("#btnCancel").hide();
            if (accessButton == true) {
                $('#btnEdit').show();
                $("#btnCancel").show();

                if ($("#status").val() == "50" || $("#status").val() == "25") {
                    $('#btnAddAttachment').show();
                    $('#btnUpdateAttachment').show();
                } else {
                    $('.editDocument').hide();
                    $('.btnDelete').hide();
                    $("[name='attachment.file_description']").attr("readonly", "true");
                }
            }
        });

        $(document).on("click", "#btnJustification", function () {
            $("#JustificationForm").modal("show");
            $("#cboSingleSourcing").show();
        });

        $(document).on("click", "#btnSaveSingleSourcing", function () {
            btnActionJust = $(this).data("action").toLowerCase();
            singlesourcing = $("select[name='vs.singlesourcing']").val();

            let errorMsg = "";
            /*errorMsg += GeneralValidation();*/
            errorMsg += FileValidation();

            if (singlesourcing.trim() == null || singlesourcing.trim() == "") {
                errorMsg += "<br/> - Single sourcing for is required";
            }

            if (singlesourcing == "2") {
                //if ($("#justification_singlesourcingp").val().trim() == null || $("#justification_singlesourcingp").val().trim() == "") {
                //    errorMsg += "<br/> - Single source justification is required";
                //}
                //if ($("input[name='justificationp_file']").val() == "" || $("input[name='justificationp_file']").val() == null) {
                //    errorMsg += "<br/> - Single source justification file is required.";
                //} else {
                //    if ($("input[name='justificationp.uploaded']").val() == "0") {
                //        errorMsg += "<br/> - There are justification file that have not been uploaded, please upload first.";
                //        $("input[name='justificationp_file']").css({ 'background-color': 'rgb(245, 183, 177)' });
                //    }
                //}
            }

            

            if (errorMsg != "") {
                errorMsg = "Please correct the following error(s):" + errorMsg;

                $("#justificationpform-error-message").html("<b>" + errorMsg + "<b>");
                $("#justificationpform-error-box").show();
                $('.modal-body').animate({ scrollTop: 0 }, 500);
                /*showErrorMessage(errorMsg);*/
            } else {
                sleep(1).then(() => {
                    blockScreenOL();
                });

                sleep(300).then(() => {
                    RequestValidation();
                }).then(() => {
                });
            }            
        });

        function RequestValidation() {
            dataJustification.id = vsItemsMain[0]["vs_id"];
            dataJustification.vs_no = vsItemsMain[0]["vs_no"];
            dataJustification.status_id = vsItemsMain[0]["status_id"];
            dataJustification.singlesourcing = singlesourcing;
            //dataJustification.justification_singlesourcing = $("#justification_singlesourcingp").val();
            //dataJustification.justification_file_singlesourcing = $("#justificationp_file_singlesourcing").val();

            let workflow = new Object();
            workflow.sn = '';
            workflow.activity_id = '';
            workflow.roles = '';
            workflow.action = btnActionJust;
            workflow.comment = '';
            workflow.current_status = $("#status").val();

            var _data = null;

            _data = {
                "submission": JSON.stringify(dataJustification)
            };

            if (singlesourcing == "2") {
                location.href = '<%=Page.ResolveUrl("~/QuotationAnalysis/SingleSourcing.aspx?id=' + dataJustification.id + '&singlesourcing='+singlesourcing+'")%>';
            } else {
                $.ajax({
                    url: "<%=Page.ResolveUrl("Detail.aspx/RequestJustification")%>",
                    data: JSON.stringify(_data),
                    dataType: 'json',
                    type: 'post',
                    contentType: "application/json; charset=utf-8",
                    success: function (response) {
                        var output = JSON.parse(response.d);
                        if (output.result !== "success") {
                            alert(output.message);
                        }

                        if (singlesourcing == "1") {
                            alert("Request has been submitted");

                            unBlockScreenOL();

                            if (isAdmin == "true") {
                                location.href = '<%=Page.ResolveUrl("~/QuotationAnalysis/list.aspx")%>';
                                } else {
                                    location.href = "/workspace/mysubmissions";
                                }
                            } else {
                                location.href = '<%=Page.ResolveUrl("~/QuotationAnalysis/SingleSourcing.aspx?id=' + dataJustification.id + '")%>';
                            }

                    }
                });
            }
            

            <%--if (singlesourcing == "1") {
                _data = {
                    "submission": JSON.stringify(dataJustification)
                };

                $.ajax({
                    url: "<%=Page.ResolveUrl("Detail.aspx/RequestJustification")%>",
                    data: JSON.stringify(_data),
                    dataType: 'json',
                    type: 'post',
                    contentType: "application/json; charset=utf-8",
                    success: function (response) {
                        var output = JSON.parse(response.d);
                        if (output.result !== "success") {
                            alert(output.message);
                        }

                        alert("Request has been submitted");

                        unBlockScreenOL();

                        if (isAdmin == "true") {
                            location.href = '<%=Page.ResolveUrl("~/QuotationAnalysis/list.aspx")%>';
                        } else {
                            location.href = "/workspace/mysubmissions";
                        }
                    }
                });
            } else {
                _data = {
                    "submission": JSON.stringify(dataJustification),
                    "workflows": JSON.stringify(workflow)
                };

                $.ajax({
                    url: "<%=Page.ResolveUrl("Submission.aspx/Submit")%>",
                    data: JSON.stringify(_data),
                    dataType: 'json',
                    type: 'post',
                    contentType: "application/json; charset=utf-8",
                    success: function (response) {
                        var output = JSON.parse(response.d);
                        if (output.result !== "success") {
                            alert(output.message);
                        }

                        alert("Request has been submitted");

                        unBlockScreenOL();

                        if (isAdmin == "true") {
                            location.href = '<%=Page.ResolveUrl("~/QuotationAnalysis/list.aspx")%>';
                        } else {
                            location.href = "/workspace/mysubmissions";
                        }
                    }
                });
            }--%>

            

            <%--if (singlesourcing == "2") {
                parent.location.href = "SubmitJustification.aspx?id=" + _id + "&singlesourcing=" + singlesourcing;
            }
            else {
                var _data = {
                    "submission": JSON.stringify(dataJustification)
                };

                $.ajax({
                    url: "<%=Page.ResolveUrl("Detail.aspx/RequestJustification")%>",
                    data: JSON.stringify(_data),
                    dataType: 'json',
                    type: 'post',
                    contentType: "application/json; charset=utf-8",
                    success: function (response) {
                        var output = JSON.parse(response.d);
                        if (output.result !== "success") {
                            alert(output.message);
                        }

                        alert("Request has been submitted");

                        unBlockScreenOL();

                        location.reload();
                    }
                });
            }--%>
        };

        $(document).on("click", ".btnFileUploadJustificationp", function () {
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

                    $(this).closest("div").find("input[name$='justificationp.uploaded']").val("1");
                    $(this).closest("div").find("input[name$='justificationp_file']").css({ 'background-color': '' });
                }
            } else {
                showErrorMessage(errorMsg);
            }
        });

        function SubmitJustificationValidation() {
            let errorMsg = ""
            if ($("#justificationp_singlesourcing").val() == null || $("#justificationp_singlesourcing").val() == "") {
                errorMsg += "<br/> - Single source justification is required.";
            }

            if ($("input[name='justificationp_file']").val() == "" || $("input[name='justificationp_file']").val() == null) {
                errorMsg += "<br/> - Single source justification file is required.";
            } else {
                if ($("input[name='justificationp.uploaded']").val() == "0") {
                    errorMsg += "<br/> - There are justification file that have not been uploaded, please upload first.";
                    $("input[name='justificationp_file']").css({ 'background-color': 'rgb(245, 183, 177)' });
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

            $(row).closest("div").find("input[name$='justificationp_file']").hide();

            $(row).closest("div").find(".editJustificationpFile").show();
            $(row).closest("div").find("a#linkDocumentJustificationpHref").attr("href", linkdoc);
            $(row).closest("div").find("a#linkDocumentJustificationpHref").text(filename);
            $(row).closest("div").find(".linkDocumentJustificationp").show();
            $(row).closest("div").find(".btnFileUploadJustificationp").hide();

            $(row).closest("div").find("input[name$='vs.justificationp_file_singlesourcing']").val(filename);
        }

        $(document).on("click", ".editJustificationpFile", function () {
            $(this).closest("div").find("input[name='justificationp_file']").val("");
            $(this).closest("div").find("input[name='vs.justificationp_file_singlesourcing']").val("");
            var obj = $(this).closest("div").find("input[name='justificationp_file']");
            var link = $(this).closest("div").find(".linkDocumentJustificationp");

            $(this).closest("div").find("input[name$='justificationp.uploaded']").val("0");
            $(this).closest("div").find(".btnFileUploadJustificationp").show();

            $(obj).show();
            $(link).hide();
            $(this).hide();
        });

        $(document).on("change", "[name='vs.singlesourcing']", function () {
            if ($(this).val() == "1") {
                $("#divJustificationTxt").removeClass("required");
                $("#btnSaveSingleSourcing").text("Submit");
            } else {
                $("#divJustificationTxt").addClass("required");
                $("#btnSaveSingleSourcing").text("Next");
            }
        });

        $(document).on("click", "#btnUpdateAttachment", function () {
            if ($("#tblAttachment >tbody >tr >td").hasClass("dataTables_empty") == true) {
                submitAttachment();
            } else {
                let errorMsg = "";
                errorMsg += FileValidation();

                let errorMsgFileName = "";
                let errorMsgFileDescription = "";

                var atts = [];

                $("#tblAttachment tbody tr").each(function () {
                    var _att = new Object();
                    _att["id"] = $(this).find("input[name='attachment.id']").val();
                    if (errorMsgFileName == "") {
                        if (($(this).find("input[name='attachment.filename']").val() == "" || $(this).find("input[name='attachment.filename']").val() == null) && $(this).find("input[name='attachment.filename']").val() != undefined) {
                            errorMsgFileName = "<br/> - File name is required.";
                        }

                        errorMsg += errorMsgFileName;
                    }

                    if (errorMsgFileDescription == "") {
                        if (($(this).find("input[name='attachment.file_description']").val() == "" || $(this).find("input[name='attachment.file_description']").val() == null) && $(this).find("input[name='attachment.file_description']").val() != undefined) {
                            errorMsgFileDescription = "<br/> - File description is required.";
                        }

                        errorMsg += errorMsgFileDescription;
                    }

                    _att["filename"] = $(this).find("input[name='attachment.filename']").val();
                    _att["file_description"] = $(this).find("input[name='attachment.file_description']").val();
                    atts.push(_att);

                    if ($(this).find("input[name='attachment.uploaded']").val() == "0") {
                        $(this).css({ 'background-color': 'rgb(245, 183, 177)' });
                        if (!errorMsg) {
                            errorMsg += "<br/> - There are files that have not been uploaded, please upload first.";//    errorMsg += "Please correct the following error(s): <br/> - There are files that have not been uploaded, please upload first.";
                        }
                    }
                });

                if (errorMsg != "") {
                    errorMsg = "Please correct the following error(s):" + errorMsg;
                    $("#error-message").html("<b>" + errorMsg + "<b>");
                    $("#error-box").show();
                    $("html, body").animate({ scrollTop: 0 });
                } else {
                    submitAttachment();
                }
            }
        });

    </script>

</asp:Content>


