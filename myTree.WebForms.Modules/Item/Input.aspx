<%@ Page MasterPageFile="~/Procurement.Master" Language="C#" AutoEventWireup="true" CodeBehind="Input.aspx.cs" Inherits="myTree.WebForms.Modules.Item.Input" %>

<asp:Content ID="Content1" ContentPlaceHolderID="AppHead" runat="server">
    <title>Item</title>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="AppBody" runat="server">
    <div class="floatingBox" id="error-box" style="display: none">
        <div class="alert alert-error" id="error-message">
        </div>
    </div>
    <div class="row-fluid">
        <div class="floatingBox">
            <div class="container-fluid">
                <div class="control-group required">
                    <label class="control-label">
                        OCS item code
                    </label>
                    <div class="controls">
                        <input type="hidden" name="action" id="action" value=""/>
                        <input type="hidden" name="doc_id" value="<%=item.id %>"/>
                        <input type="hidden" name="doc_type" value="ITEM"/>

                        <input type="hidden" name="item.id" value="<%=item.id %>"/>
                        <input type="hidden" name="item.sun_description" value="<%=item.sun_long_desc %>"/>
                        <input type="hidden" name="item.item_code" value="<%=item.item_code%>" />
                        <select name="item.sun_code" data-title="OCS Item code" data-validation="required" class="span4" >
                            <%  if (!String.IsNullOrEmpty(item.id))
                                { %>
                            <option value="<%=item.sun_code %>"><%=item.sun_code %> - <%=item.sun_long_desc %></option>
                            <%  } %>
                        </select>
                    </div>
                </div>
                <div class="control-group">
                    <label class="control-label">
                        OCS lookup code
                    </label>
                    <div class="controls">
                        <input type="text" name="item.sun_lookup_code" data-title="OCS lookup code" class="span4" placeholder="OCS lookup code" maxlength="50" disabled="disabled" value="<%=item.sun_lookup_code%>" />
                    </div>
                </div>
                <div class="control-group">
                    <label class="control-label">
                        OCS item description
                    </label>
                    <div class="controls">
                        <input type="text" name="item.sun_long_desc" data-title="OCS item description" class="span4" placeholder="OCS item description" maxlength="500" disabled="disabled" value="<%=item.sun_long_desc%>" />
                    </div>
                </div>
                <div class="control-group">
                    <label class="control-label">
                        OCS item short heading
                    </label>
                    <div class="controls">
                        <input type="text" name="item.sun_short_desc" data-title="OCS item short heading" class="span4" placeholder="OCS item short heading" maxlength="50" disabled="disabled" value="<%=item.sun_short_desc%>" />
                    </div>
                </div>
                <div class="control-group">
                    <label class="control-label">
                        OCS item status
                    </label>
                    <div class="controls">
                        <input type="text" name="item.sun_status" data-title="OCS item status" class="span4" placeholder="OCS item status" maxlength="50" disabled="disabled" value="<%=item.sun_status%>" />
                    </div>
                </div>
                <div class="control-group">
                    <label class="control-label">
                        OCS item grouping
                    </label>
                    <div class="controls">
                        <input type="text" name="item.sun_item_group" data-title="OCS item grouping" class="span4" placeholder="OCS item grouping" maxlength="50" disabled="disabled" value="<%=item.sun_item_group%>" />
                    </div>
                </div>
                <div class="control-group">
                    <label class="control-label">
                        OCS item account code
                    </label>
                    <div class="controls">
                        <input type="text" name="item.sun_account_code" data-title="OCS item account code" class="span4" placeholder="OCS item account code" maxlength="50" disabled="disabled" value="<%=item.sun_account_code%>" />
                    </div>
                </div>
                <%  if (!String.IsNullOrEmpty(item.id))
                    { %>
                <div class="control-group">
                    <label class="control-label">
                        Procurement item code
                    </label>
                    <div class="controls labelDetail">
                        <b><%=item.item_code%></b>
                    </div>
                </div>
                <%  } %>
                <div class="control-group required">
                    <label class="control-label">
                        Detail description
                    </label>
                    <div class="controls">
                        <textarea name="item.description" data-title="Detail description" data-validation="required" rows="5" class="span6 textareavertical" placeholder="Detail description" maxlength="2000"><%=item.description%></textarea>
                    </div>
                </div>
                <div class="control-group required">
                    <label class="control-label">
                        Unit of measurement
                    </label>
                    <div class="controls">
                        <select name="item.uom" data-title="Unit of measurement" data-validation="required" class="span2" >

                        </select>
                    </div>
                </div>
                <div class="control-group required">
                    <label class="control-label">
                        Category
                    </label>
                    <div class="controls">
                        <select name="item.category" data-title="Category" data-validation="required" class="span4" >

                        </select>
                    </div>
                </div>
                <div class="control-group required">
                    <label class="control-label">
                        Sub category
                    </label>
                    <div class="controls">
                        <select name="item.subcategory" data-title="Sub category" data-validation="required" class="span4" >

                        </select>
                    </div>
                </div>
                <div class="control-group">
                    <label class="control-label">
                        Brand
                    </label>
                    <div class="controls">
                        <select name="item.brand" data-title="Brand" class="span4" >

                        </select>
                    </div>
                </div>
                <div class="control-group">
                    <label class="control-label">
                        Attachment(s)
                    </label>
                    <div class="controls">
                        <table id="tblAttachment" class="table table-bordered table-hover" data-title="Attachment(s)" style="border: 1px solid #ddd">
                            <thead>
                                <tr>
                                    <th style="width:50%;">Description</th>
                                    <th style="width:40%;">File</th>
                                    <th style="width:10%;">&nbsp;</th>
                                </tr>
                            </thead>
                            <tbody>
                                <%  foreach (myTree.WebForms.Procurement.General.DataModel.Attachment att in item.attachments)
                                    { %>
                                <tr>
                                    <td><input type="text" class="span12" name="attachment.file_description" data-title="Attachment description" data-validation="required" maxlength="2000" placeholder="Description" value="<%=att.file_description %>"/></td>
                                    <td><input type="hidden" name="attachment.filename" data-title="Attachment file" data-validation="required" value="<%=att.filename %>"/>
                                        <%  if (!String.IsNullOrEmpty(att.filename)){ %>
                                        <span class="linkDocument"><a href="<%=myTree.WebForms.Procurement.General.statics.GetFileUrl("ITEM",item.id,att.filename) %>" target='_blank'><%=att.filename%></a>&nbsp;</span>
                                        <button type="button" class="btn btn-primary editDocument">Edit</button>
                                        <input type="file" class="span12" name="filename" style="display: none;"/>
                                        <%  } else { %>
                                        <input type="file" class="span12" name="filename"/>
                                        <%  } %>
                                    </td>                                        
                                    <td><input type="hidden" name="attachment.id" value="<%=att.id %>"/>
                                        <span class="label red btnDelete"><i class="icon-trash delete" style="opacity: 1;"></i></span></td>
                                </tr>
                                <%  } %>
                            </tbody>
                        </table>
                        <div class="doc-notes"></div>
                        <p><button id="btnAdd" class="btn btn-success" type="button">Add attachment</button></p>
                    </div>
                </div>
                <div class="control-group">
                    <label class="control-label">
                        Procurement item status
                    </label>
                    <div class="controls">
                        <select name="item.is_item_active" data-title="Procurement item status" class="span3" >
                            <option value="1">Active</option>
                            <option value="0">In-active</option>
                        </select>
                    </div>
                </div>
                <div class="control-group">
                    <label class="control-label">
                        Remarks
                    </label>
                    <div class="controls">
                        <textarea name="item.remarks" data-title="Remarks" rows="5" class="span6 textareavertical" placeholder="Remarks" maxlength="2000"><%=item.remarks%></textarea>
                    </div>
                </div>
                <div class="control-group last">
                    <div class="controls">
                        <button id="btnClose" class="btn" type="button">Close page</button>&nbsp;&nbsp;&nbsp;
                        <button id="btnSave" class="btn btn-success" type="button">Save</button>                           
                    </div>
                </div>
            </div>
        </div>
    </div>
    <script>
        var deletedId = [];
        var dataCategory = <%=listCategory%>;
        var dataBrand = <%=listBrand%>;
        var dataUoM = <%=listUoM%>;

        var _category = "<%=item.category%>";
        var _subcategory = "<%=item.subcategory%>";
        var _brand = "<%=item.brand%>";
        var _uom = "<%=item.uom%>";
        var _is_item_active = "<%=item.is_item_active%>"

        var isCanEdit = "<%=valid.isCanEdit%>";
        isCanEdit = isCanEdit.toLowerCase() === "true" ? true : false;

        var isCanDelete = "<%=valid.isCanEdit%>";
        isCanDelete = isCanDelete.toLowerCase() === "true" ? true : false;

        $(document).ready(function () {
            var cboCat = $("select[name='item.category']");
            var cboSub = $("select[name='item.subcategory']");
            generateCombo(cboCat, dataCategory, "id", "text", true);

            $(cboCat).val(_category).select2({
                placeholder: "Category"
            }).on('select2:select', function (e) {
                CreateSubCategory(cboSub, $(this).val(), "");
            });

            CreateSubCategory(cboSub, _category, _subcategory);

            var cboBrand = $("select[name='item.brand']");
            generateCombo(cboBrand, dataBrand, "id", "text", true);
            $(cboBrand).val(_brand);
            Select2Obj(cboBrand, "Brand");

            var cboUoM = $("select[name='item.uom']");
            generateCombo(cboUoM, dataUoM, "id", "text", true);
            $(cboUoM).val(_uom);
            Select2Obj(cboUoM, "Unit of measurement");

            var cboItemStatus = $("select[name='item.is_item_active']");
            $(cboItemStatus).val(_is_item_active);
            Select2Obj(cboItemStatus, "Procurement item status");

            $("select[name='item.sun_code']").select2({
                placeholder: "OCS item code",
                minimumInputLength: 2,
                allowClear: true,
                ajax: {
                    url: "Service.aspx/GetSUNItem",
                    type: "POST",
                    dataType: "json",
                    delay: 500,
                    contentType: "application/json; charset=utf-8",
                    data: function (params) {
                        return '{search: "' + params.term + '"}';
                    },
                    processResults: function (data, params) {
                        return {
                            results: data.d
                        };
                    }
                }
            }).on('select2:select', function (e) {
                populateSUNDetail(this.value);
                /*
                var _val = "";
                var x = "-1";
                var data = $("select[name='item.sun_code']").select2('data');
                if (data) {
                    _val = data[0].text;
                    x = _val.indexOf(" - ");
                    x = _val.substring((x + 3), _val.length);
                    $("input[name='item.sun_description']").val(x);
                }*/
            });

            if (!isCanEdit) {
                $("[name='item.brand']").prop("disabled", true);
                $("[name='item.category']").prop("disabled", true);
                $("[name='item.subcategory']").prop("disabled", true);
                $("[name='item.description']").prop("disabled", true);
            }
        });

        function populateSUNDetail(item_code) {
            $.ajax({
                url: "Service.aspx/GetSUNItemDetail",
                data: "{item_code:'" + item_code + "'}",
                type: "POST",
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (response) {
                    data = JSON.parse(response.d);
                    data = data[0];
                    $("input[name='item.sun_lookup_code']").val(data.sun_lookup_code);
                    $("input[name='item.sun_long_desc']").val(data.sun_long_desc);
                    $("input[name='item.sun_short_desc']").val(data.sun_short_desc);
                    $("input[name='item.sun_status']").val(data.sun_status);
                    $("input[name='item.sun_item_group']").val(data.sun_item_group);
                    $("input[name='item.sun_account_code']").val(data.sun_account_code);
                }
            });
        }

        function SubmitValidation(data) {
            var errorMsg = "";
            errorMsg += uploadValidationResult.not_found_message||'';
            errorMsg += GeneralValidation();
            errorMsg += FileValidation();

            if (errorMsg != "") {
                showErrorMessage(errorMsg);
                return false;
            }

            var _data = {
                "submission": JSON.stringify(data),
                "deleted": JSON.stringify(deletedId)
            }
            Submit(_data);
        }

        $(document).on("click", ".btnDelete", function () {
            var _sid = $(this).closest("td").find("input[name='attachment.id']").val();
            if (_sid != "") {
                deletedId.push(_sid);
            }

            $(this).closest("tr").remove();
        });

        $(document).on("click", "#btnClose", function () {
            location.href = "List.aspx";
        })

        $(document).on("click", "#btnAdd", function () {
            var html = '<tr>';
            html += '<td><input type="text" class="span12" name="attachment.file_description" data-title="Attachment description" data-validation="required" maxlength="2000" placeholder="Description"/></td>';
            html += '<td><input type="hidden" name="attachment.filename" data-title="Attachment file" data-validation="required"/><input type="file" class="span12" name="filename"/></td>';
            html += '<td><input type="hidden" name="attachment.id"/><span class="label red btnDelete"><i class="icon-trash delete" style="opacity: 1;"></i></span></td>';
            html += '</tr>';
            $("#tblAttachment tbody").append(html);
        });

        var uploadValidationResult = {};
	    $(document).on("click", "#btnSave", function () {
		    var thisHandler = $(this);
		    $("[name=filename]").uploadValidation(function(result) {
			    uploadValidationResult = result;
			    onBtnClickSave.call(thisHandler);
		    });
	    });

        var onBtnClickSave = function () {
        //$(document).on("click", "#btnSave", function () {
            var submission = GetSubmission();
            SubmitValidation(submission); 
        };

        function GetSubmission() {
            var data = new Object();
            data.id = $("input[name='item.id']").val();
            data.sun_code = $("select[name='item.sun_code']").val();
            data.sun_long_desc = $("input[name='item.sun_long_desc']").val();
            data.category = $("select[name='item.category']").val();
            data.subcategory = $("select[name='item.subcategory']").val();
            data.brand = $("select[name='item.brand']").val();
            data.item_code = $("input[name='item.item_code']").val();
            data.description = $("textarea[name='item.description']").val();
            data.uom = $("select[name='item.uom']").val();
            data.remarks = $("textarea[name='item.remarks']").val();
            data.is_item_active = $("select[name='item.is_item_active']").val();

            data.attachments = [];
            $("#tblAttachment tbody tr").each(function () {
                var _att = new Object();
                _att["id"] = $(this).find("input[name='attachment.id']").val();
                _att["filename"] = $(this).find("input[name='attachment.filename']").val();
                _att["file_description"] = $(this).find("input[name='attachment.file_description']").val();
                data.attachments.push(_att);
            });

            return data;
        }

        function Submit(_data) {
            $.ajax({
                url: 'Input.aspx/Save',
                data: JSON.stringify(_data),
                dataType: 'json',
                type: 'post',
                contentType: "application/json; charset=utf-8",
                success: function (response) {
                    var output = JSON.parse(response.d);
                    if (output.result != "success") {
                        alert(output.message);
                    } else {
                        if (output.id != "") {
                            $("input[name='doc_id']").val(output.id);
                            $("input[name='action']").val("upload");
                            $("input[name='item.item_code']").val(output.code);
                            UploadFile();
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
                url: 'Service.aspx',
                data: formData,
                processData: false,
                contentType: false,
                success: function (response) {
                    var output = JSON.parse(response);
                    if (output.result != "success") {
                        alert(output.message);
                    } else {
                        alert("Item " + $("input[name='item.item_code']").val() + " has been saved successfully");
                        blockScreen();
                        location.href = "List.aspx";
                    }
                }
            });
        }

        $(document).on("change", "input[name='filename']", function () {
            var obj = $(this).closest("tr").find("input[name='attachment.filename']");
            $(obj).val("");
            var fullPath = $(this).val();
            if (fullPath) {
                var startIndex = (fullPath.indexOf('\\') >= 0 ? fullPath.lastIndexOf('\\') : fullPath.lastIndexOf('/'));
                var filename = fullPath.substring(startIndex);
                if (filename.indexOf('\\') === 0 || filename.indexOf('/') === 0) {
                    filename = filename.substring(1);
                }
                $(obj).val(filename);
            }
        });

        $(document).on("click", ".editDocument", function () {
            var obj = $(this).closest("td").find("input[name='filename']");
            var link = $(this).closest("td").find(".linkDocument");
            $(obj).show();
            $(link).hide();
            $(this).hide();
        });
    </script>
</asp:Content>
