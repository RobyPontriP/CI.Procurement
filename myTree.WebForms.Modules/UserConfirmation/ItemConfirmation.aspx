<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ItemConfirmation.aspx.cs" Inherits="myTree.WebForms.Modules.UserConfirmation.ItemConfirmation" %>
<%@ Register Src="~/UserConfirmation/uscSendConfirmation.ascx" TagName="confirmationform" TagPrefix="uscConfirmation" %>
<asp:Content ID="Content1" ContentPlaceHolderID="AppHead" runat="server">
    <title>User Confirmations</title>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="AppBody" runat="server">
    <!-- for upload file -->
    <input type="hidden" name="action" id="action" value=""/>
    <input type="hidden" id="quo.id" name="doc_id" value=""/>
    <input type="hidden" name="doc_type" value="ITEM CONFIRMATION"/>
    <!-- end of upload file -->

    <div class="floatingBox" id="error-box" style="display: none">
        <div class="alert alert-error" id="error-message">
        </div>
    </div>
    <input type="hidden" name="id" value="<%=id %>" />
    <div class="row-fluid">
        <div class="floatingBox">
            <div class="container-fluid">
                <div class="control-group">
                    <label class="control-label">
                        Confirmation code
                    </label>
                    <div class="controls labelDetail confirmationCode">
                        <b><%=du.confirmation_code %></b>
                    </div>
                </div>
                <div class="control-group">
                    <label class="control-label">
                        Send date
                    </label>
                    <div class="controls labelDetail">
                        <%= du.send_date %>
                    </div>
                </div>
                <div class="control-group">
                    <label class="control-label">
                        Status
                    </label>
                    <div class="controls labelDetail">
                        <%=du.status_id %>
                    </div>
                </div>
                <div class="control-group">
                    <label class="control-label">
                        Confirm date
                    </label>
                    <div class="controls labelDetail confirmDate">
                        <%=du.confirm_date %>
                    </div>
                </div>
                <uscConfirmation:confirmationform ID="confirmationForm" runat="server" />
                <div class="control-group last">
                    <label class="control-label">
                    </label>
                    <div class="controls">
                        <button id="btnClose" class="btn" type="button">Close page</button>&nbsp;&nbsp;&nbsp;
                        <button id="btnSave" class="btn btn-success" type="button" data-action="saved">Save</button>
                        <button id="btnSubmit" class="btn btn-success" type="button" data-action="submitted">Submit</button>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <script>
        var listMain = <%=listMain%>;
        var listGroupHeader = <%=listGroupHeader%>;
        var listGroupDetail = <%=listGroupDetail%>;
        var listDocs = <%=listDocs%>;
        var _id = "<%=id%>";

        var workflow = new Object();
        var btnAction = "";

        $(document).ready(function () {
            ConfirmDetail = listGroupDetail;
            ConfirmMain = listGroupHeader;

            tblConfirm.clear().draw();
            tblConfirm.rows.add(ConfirmMain).draw();

            PopulateDocs();

            CalculateReject();
        });

        function PopulateDocs() {
            $(listDocs).each(function (i, x) {
                //var html = '<tr>';
                //html += '<td>' + x.file_description + '</td>';
                //html += '<td><a href="Files/' + x.document_id + '/' + x.filename + '" target="_blank">' + x.filename + '</a></td>';
                //html += '</tr>';
                //$("#tblSupportingDocuments tbody").append(html);
                var boolisProvide = (x.is_provide_file == 1) ? true : false;
                addAttachment(x.id, "", x.file_description, x.filename, x.is_provide_file)
                $("[name='confirmationfile.suppdoc" + x.id + "']").prop('checked', boolisProvide);
            });
        }

        function addAttachment(id, uid, description, filename, isprovide) {
            description = NormalizeString(description);
            if (uid === "" || typeof uid === "undefined" || uid === null) {
                var uid = guid();
            }
            //var tes = (isprovide == "1") ? 'x' : 'y';
            var html = '<tr>';
            html += '<td><input type="hidden" name="confirmationfile.id" value="' + id + '"/><input type="hidden" name="confirmationfile.uid" value="' + uid + '"/>';
            //if (isprovide) {
            //    html += '<input type="text" class="span12" name="confirmationfile.file_description" data-title="Description" data-validation="required" maxlength="2000" placeholder="Description" value="' + description + '" />';
            //} else {
                html += '<input type="hidden" name="confirmationfile.file_description" value="' + description + '"/>' + description;
            //}
            html += '</td>';
            html += '<td><input type="hidden" name="confirmationfile.filename" data-title="File" data-validation="required" value="' + filename + '"/><div class="fileinput_' + uid + '">';
            if (id !== "" && filename !== "") {
                html += '<span class="linkDocument"><a href="Files/' + _id + '/' + filename + '" target="_blank">' + filename + '</a>&nbsp;</span>';
                if (isprovide) {
                    html += '<button type="button" class="btn btn-primary editDocument">Edit</button><input type="file" class="span12" name="filename" style="display: none;"/>';
                }
            } else {
                html += '<input type="file" class="span12" name="filename" />';
            }
            html += '<input type="checkbox" name="confirmationfile.suppdoc'+ id +'" data-title="Suppdoc" style="display: none;"/>';
            html += '</div></td > ';            
            html += '</tr>';            
            $("#tblSupportingDocuments tbody").append(html);
        }

        $(document).on("change", "input[name='filename']", function () {
            var obj = $(this).closest("tr").find("input[name='confirmationfile.filename']");
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

        $(document).on("click", ".editDocument", function () {
            var obj = $(this).closest("td").find("input[name='filename']");
            var obj3 = $(this).closest("td").find("input[name='confirmationfile.filename']");
            var link = $(this).closest("td").find(".linkDocument");
            $(obj).show();
            $(obj3).val("");
            $(link).hide();
            $(this).hide();
        });

        function CalculateReject() {
            $("[name^='accept_quantity']").each(function (i,x) {
                var send_qty = delCommas($(this).closest("tr").find("[name='send_quantity']").val());
                var accept_qty = delCommas($(this).val());
                var rejected = accounting.formatNumber(send_qty - accept_qty, 2);
        
                $(this).closest("tr").find(".rejected_quantity").html(rejected);
                $(".remarks_" + $(this).data("id")).hide();

                $("[name^='quality'][data-id='" + $(this).data("id") + "']").data("validation","");

                if (send_qty != accept_qty) {
                    $(".remarks_" + $(this).data("id")).show();
                    $("[name^='quality'][data-id='" + $(this).data("id") + "']").data("validation","required");
                }
            });
        }

        var uploadValidationResult = {};
	    $(document).on("click", "#btnSave,#btnSubmit", function () {
		    var thisHandler = $(this);
		    $("[name=cancellation_file],[name=filename]").uploadValidation(function(result) {
			    uploadValidationResult = result;
			    onBtnClickSave.call(thisHandler);
		    });
	    });

        var onBtnClickSave = function () {
        //$(document).on("click", "#btnSave,#btnSubmit", function () {
            btnAction = $(this).data("action").toLowerCase();
            workflow.action = btnAction;
            workflow.comment = "";

            var errorMsg = "";
            errorMsg += FileValidation();
            errorMsg += uploadValidationResult.not_found_message||'';
            if (btnAction == "submitted") {
                errorMsg += GeneralValidation();
            }

            if (errorMsg !== "") {
                showErrorMessage(errorMsg);

                return false;
            } else {
                var _data = new Object();
                _data.id = $("[name='id']").val();
                _data.confirmation_code = $.trim($(".confirmationCode").text());

                var ConfirmList = [];

                $(".confirm_id").each(function (i, x) {
                    var obj = new Object();

                    obj.id = $(this).data("id");
                    obj.quantity = delCommas($(this).find("[name^='accept_quantity']").val());
                    obj.quality = $("[name^='quality'][data-id='" + $(this).data("base_id") + "']").val();
                    obj.additional_person = $(this).find("[name='additional_person']").val();

                    ConfirmList.push(obj);
                });
                _data.details = ConfirmList;

                 var DocList = [];
                $("#tblSupportingDocuments tbody tr").each(function () {
                    var _att = new Object();
                    _att["id"] = $(this).find("input[name='confirmationfile.id']").val();
                    _att["filename"] = $(this).find("input[name='confirmationfile.filename']").val();
                    _att["file_description"] = $(this).find("input[name='confirmationfile.file_description']").val();
                    _att["is_provide_file"] =($(this).find("input[type='checkbox']").is(':checked')) ? "1" : "0";
                    DocList.push(_att);
                });
                _data.documents = DocList;

                var Submission = {
                    submission: JSON.stringify(_data),
                    workflows: JSON.stringify(workflow),
                    deleted: JSON.stringify([])
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
                            if (output.confirmation_code !== "") {
                                $("input[name='doc_id']").val(output.id);
                                $("input[name='action']").val("upload");
                                $("input[name='doc_type']").val("USER CONFIRMATION");
                                UploadConfirmFile();
                                alert("User confirmation " + $.trim(output.confirmation_code) + " has been " + btnAction + " successfully");
                                blockScreen();                                
                                if (btnAction == "saved") {
                                    location.reload();
                                } else {
                                    parent.location.href = "/workspace";
                                }
                            }
                        }
                    }
                });
            }
        };

        function UploadConfirmFile() {
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
                    } 
                }
            });
        }

        $(document).on("click", "#btnClose", function () {
            parent.location.href = "/workspace";
        });
    </script>
</asp:Content>
