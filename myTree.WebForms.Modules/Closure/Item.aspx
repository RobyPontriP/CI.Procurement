<%@ Page MasterPageFile="~/Procurement.Master"  Language="C#" AutoEventWireup="true" CodeBehind="Item.aspx.cs" Inherits="Procurement.Closure.ItemClosure" %>
<asp:Content ID="Content1" ContentPlaceHolderID="AppHead" runat="server">
    <title>Item Closure</title>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="AppBody" runat="server">
    <div class="floatingBox" id="error-box" style="display: none">
        <div class="alert alert-error" id="error-message">
        </div>
    </div>
    <div class="row-fluid">
        <div class="floatingBox">
            <div class="container-fluid">
                <div class="control-group po_source">
                    <label class="control-label">
                        PO code
                    </label>
                    <div class="controls labelDetail">
                        <%=ic.po_code %>
                        <input type="hidden" name="ic.id" value="<%=ic.id %>"/>
                        <input type="hidden" name="ic.base_id" value="<%=base_id %>"/>
                        <input type="hidden" name="ic.base_type" value="<%=base_type %>"/>
                        <input type="hidden" name="ic.pr_detail_id" value="<%=ic.pr_detail_id %>"/>
                    </div>
                </div>
                <div class="control-group">
                    <label class="control-label">
                        PR code
                    </label>
                    <div class="controls labelDetail">
                        <%=ic.pr_code %>
                    </div>
                </div>
                <div class="control-group">
                    <label class="control-label">
                        Product code
                    </label>
                    <div class="controls labelDetail">
                        <%=ic.item_code %>
                    </div>
                </div>
                <div class="control-group">
                    <label class="control-label">
                        Product description
                    </label>
                    <div class="controls labelDetail">
                        <%=ic.item_description %>
                    </div>
                </div>
                <div class="control-group">
                    <label class="control-label" id="label-quantity">
                        PO quantity
                    </label>
                    <div class="controls labelDetail">
                        <%=ic.po_quantity %> <%=ic.uom %>
                    </div>
                </div>
              <%--  <div class="control-group">
                    <label class="control-label">
                        Requester / Initiator confirmation date
                    </label>
                    <div class="controls labelDetail">
                        <%=ic.confirm_date %>
                    </div>
                </div>--%>
                <div class="control-group required">
                    <label class="control-label">
                        Reason for closing
                    </label>
                    <div class="controls">
                        <select name="ic.reason_for_closing" class="span4" data-title="Reason for closing" data-validation="required">
                            <option></option>
                            <option value="MANUAL">Close manually</option>
                            <option value="DIRECT PURCHASE">Direct purchase</option>
                            <option value="GRM">GRM</option>
                        </select>
                    </div>
                </div>
                <div class="control-group po_source grm required">
                    <label class="control-label">
                        GRM code
                    </label>
                    <div class="controls">
                        <input type="text" name="ic.grm_no" maxlength="50" data-validation="required" data-title="GRM code" placeholder="GRM code" class="span4"/>
                        <input type="hidden" name="ic.grm_line" value="0"/>
                    </div>
                </div>
                <div class="control-group required">
                    <label class="control-label" id="label-date">
                        Close date
                    </label>
                    <div class="controls">
                        <div class="input-prepend">
                            <input type="text" maxlength="11" name="ic.close_date" class="span9 date" readonly="readonly" data-validation="required date" data-title=""/>
                            <span class="add-on icon-calendar close_date"></span>
                        </div>
                    </div>
                </div>
                <div class="control-group required">
                    <label class="control-label" id="label-actual-quantity">
                        Actual quantity
                    </label>
                    <div class="controls">
                        <input type="text" name="ic.quantity" maxlength="18" data-maximum-custom="actual quantity" data-maximum-attr="quantity" data-maximum="<%=ic.remaining_quantity %>" data-validation="required number" data-title="Actual quantity" placeholder="Actual quantity" class="span2 number" data-decimal-places="2"/>
                    </div>
                </div>
                <div class="control-group pr_source">
                    <label class="control-label">
                        Direct purchase actual supplier
                    </label>
                    <div class="controls labelDetail">
                        <%=ic.actual_vendor %>
                    </div>
                </div>
                <div class="control-group">
                    <label class="control-label">
                        Estimated value
                    </label>
                    <div class="controls labelDetail">
                        <%=ic.pr_currency_id %> <%=ic.estimated_cost %> / USD <%=ic.estimated_cost_usd %>
                    </div>
                </div>
                <div class="control-group po_source">
                    <label class="control-label">
                        PO value
                    </label>
                    <div class="controls labelDetail">
                        <%=ic.po_currency_id %> <%=ic.po_cost %> / USD <%=ic.po_cost_usd %>
                    </div>
                </div>
                <div class="control-group">
                    <label class="control-label">
                        Actual value
                    </label>
                    <div class="controls labelDetail">
                        <%=ic.po_currency_id %> <span id="actual_value"></span> / USD <span id="actual_value_usd"></span>
                    </div>
                </div>
                <div id="supporting_docs" class="control-group">
                    <label class="control-label">
                        Supporting document(s)
                    </label>
                    <div class="controls">
                        <table id="tblAttachment" data-title="Supporting document(s)" class="table table-bordered table-hover" style="border: 1px solid #ddd">
                            <thead>
                                <tr>
                                    <th style="width:50%;">Description</th>
                                    <th style="width:40%;">File</th>
                                    <th style="width:10%;">&nbsp;</th>
                                </tr>
                            </thead>
                            <tbody>
                            </tbody>
                        </table>
                        <div class="doc-notes"></div>
                        <p><button id="btnAddAttachment" class="btn btn-success" type="button" data-toggle="modal">Add supporting document</button></p>                
                    </div>
                </div>
                <div id="section_remarks" class="control-group required last">
                    <label class="control-label">
                        Remarks
                    </label>
                    <div class="controls">
                        <textarea name="ic.remarks" data-validation="required" data-title="Remarks" placeholder="Remarks" maxlength="2000" rows="3" class="span10 textareavertical"></textarea>
                    </div>
                </div>
                <div class="control-group required last">
                    <div class="controls">
                        <button id="btnClose" class="btn" type="button">Close page</button>&nbsp;&nbsp;&nbsp;
                        <button id="btnSave" class="btn btn-success" type="button" data-action="saved">Save</button>
                    </div>
                </div>
                <input type="hidden" name="doc_id" value=""/>
                <input type="hidden" name="doc_type" value="CLOSURE"/>
                <input type="hidden" name="action" value=""/>
                <input type="hidden" name="file_name" id="file_name" value="" />
                <input type="hidden" name="docidtemp" value="" />
            </div>
        </div>
    </div>
    <script>
        const base_type = $("[name='ic.base_type']").val();
        const currency = "<%=ic.po_currency_id%>";
        const unit_price = "<%=ic.unit_price%>";
        const listCurrency = <%=listCurrency%>;
        const is_direct_purchase = "<%=is_direct_purchase%>";

        const source = "<%=source%>";
        const source_id = "<%=source_id%>";
        
        let arr = $.grep(listCurrency, function (n, i) {
            return n["CURRENCY_CODE"] == currency;
        });
        const exchange_rate = arr[0].RATE;
        const exchange_sign = arr[0].OPERATOR;

        $(document).ready(function () {
            controlValidation();

            const cboReason = $("[name='ic.reason_for_closing']");
            Select2Obj(cboReason, "Reason for closing");
            $(cboReason).on("change", function () {
                changeMethod();
            });

            $(".close_date").datepicker({
                format: "dd M yyyy"
                , autoclose: true
            }).on("changeDate", function () {
                $('[name="ic.close_date"]').val($(this).data('date'));
                $(this).datepicker('hide');
            });     

            $(".close_date").datepicker("setDate", new Date()).trigger("changeDate");
            repopulateNumber();

            changeMethod();

            $("[name='docidtemp']").val(guid());
        });

        function controlValidation() {
            if (String(base_type).toLowerCase() == "purchase requisition") {
                $("[name='ic.reason_for_closing'] option[value='GRM']").remove();
                $(".po_source").hide();
                $("[name='ic.grm_no']").data("validation", "");
                $("#label-quantity").text("PR quantity");
                if (is_direct_purchase == "1") {
                    $("[name='ic.reason_for_closing']").val("DIRECT PURCHASE").trigger("change");
                }
            } else if (String(base_type).toLowerCase() == "purchase order") {
                $("[name='ic.reason_for_closing'] option[value='DIRECT PURCHASE']").remove();
                $("[name='ic.grm_no']").data("validation", "required");
                $(".pr_source").hide();
                $("#label-quantity").text("PO quantity");
            }
        }

        function changeMethod() {
            const method = $("[name='ic.reason_for_closing']").val();

            $(".grm").hide();
            $("[name='ic.grm_no']").data("validation", "");
            $("[name='ic.quantity']").prop("disabled", false);

            $("#section_remarks").removeClass("required");
            $("[name='ic.remarks']").data("validation", "");

            $("#supporting_docs").removeClass("required");
            $("#tblAttachment").removeClass("required");

            if (method == "GRM") {
                $("#label-date").text("GRM date");
                $("[name='ic.close_date']").data("title", "GRM date");
                $("[name='ic.grm_no']").data("validation", "required");
                $(".grm").show();
            } else if (method == "MANUAL") {
                $("#label-date").text("Close date");
                $("[name='ic.close_date']").data("title", "Close date");
                $("[name='ic.quantity']")
                    .prop("disabled", true)
                    .val("<%=ic.remaining_quantity%>")
                    .trigger("change");

                $("#section_remarks").addClass("required");
                $("[name='ic.remarks']").data("validation", "required");
                if (String(base_type).toLowerCase() == "purchase order") {
                    $("#supporting_docs").addClass("required");
                    $("#tblAttachment").addClass("required");
                }
            } else if (method == "DIRECT PURCHASE") {
                let dp_qty = 0;
                let _po_qty = "<%=ic.po_quantity%>";
                let _remaining_qty = "<%=ic.remaining_quantity%>";

                dp_qty = _po_qty;
                if (delCommas(_po_qty) > delCommas(_remaining_qty)) {
                    dp_qty = _remaining_qty;
                }

                $("#label-date").text("Direct purchase actual date");
                $("[name='ic.close_date']").data("title", "Direct purchase actual date");
                $("[name='ic.quantity']")
                    .val(dp_qty)
                    .trigger("change");
            }
        }

        $(document).on("change", "[name='ic.quantity']", function () {
            const cost = unit_price * delCommas($(this).val());
            console.log(cost);
            console.log(exchange_rate);
            let cost_usd = 0;
            if (exchange_sign == "/") {
                cost_usd = cost / exchange_rate;
            } else {
                cost_usd = cost * exchange_rate;
            }

            let _remaining_qty = "<%=ic.remaining_quantity%>";


            if ($(this).val() < 0) {
                $(this).val(0);
            }

            

            $("#actual_value").text(accounting.formatNumber(delCommas(cost), 2));
            $("#actual_value_usd").text(accounting.formatNumber(delCommas(cost_usd), 2));
        });

        $(document).on("click", "#btnAddAttachment", function () {
            addAttachment("", "", "", "");
        });

        function addAttachment(id, uid, description, filename) {
            description = NormalizeString(description);
            var base_id = $("[name='ic.base_id']").val();
            if (uid === "" || typeof uid === "undefined" || uid === null) {
                var uid = guid();
            }
            var html = '<tr>';
            html += '<td><input type="hidden" name="attachment.uid" value="' + uid + '"/><input type="text" class="span12" name="attachment.file_description" data-title="Supporting document description" data-validation="required" maxlength="2000" placeholder="Description" value="' + description + '"/></td>';
            html += '<td><input type="hidden" name="attachment.filename" data-title="Supporting document file" data-validation="required" value="' + filename + '"/><div class="fileinput_' + uid + '">';
            if (id !== "" && filename !== "") {
                html += '<span class="linkDocument"><a href="Files/' + base_id + '/' + filename + '" target="_blank" id="linkDocument">' + filename + '</a>&nbsp;</span>';
                html += '<button type="button" class="btn btn-primary editDocument">Edit</button><input type="file" class="span10" name="filename" style="display: none;"/>';
                html += '<button type="button" class="btn btn-success btnFileUpload" style="display:none;">Upload</button>';
            } else {
                html += '<span class="linkDocument"><a href="" target="_blank" id="linkDocument">' + filename + '</a>&nbsp;</span>';
                html += '<button type="button" class="btn btn-primary editDocument" style="display: none;">Edit</button><input type="file" class="span10" name="filename"/>';
                html += '<button type="button" class="btn btn-success btnFileUpload">Upload</button>';
            }
            html += '</div></td > ';
            html += '<td><input type="hidden" name="attachment.id" value="' + id + '"/><span class="label red btnDelete"><i class="icon-trash delete" style="opacity: 1;"></i></span>';
            html += '</td > ';
            if (filename !== "") {
                html += '<td style="display:none;"><input type="hidden" name="attachment.uploaded" value="1"/></td>';
            } else {
                html += '<td style="display:none;"><input type="hidden" name="attachment.uploaded" value="0"/></td>';
            }
            html += '</tr>';
            $("#tblAttachment tbody").append(html);
        }

        $(document).on("click", ".btnDelete", function () {
            var _sid = $(this).closest("td").find("input[name$='.id']").val();
            var _sname = $(this).closest("td").find("input").prop("name").split('.');

            var mname = "";
            if (typeof _sname !== "undefined" && _sname.length > 1) {
                mname = _sname[0];
            }

            if (_sid != "") {
                var _del = new Object();
                _del.id = _sid;
                _del.table = mname;
                deletedId.push(_del);
            }

            if (mname == "attachment") {
                var uid = $(this).closest("tr").find("input[name$='.uid']").val();
                $(".clone_" + uid).remove();
            } else if (mname == "item") {
                var item_uid = $(this).closest("tr").prop("id");
                var idx = PRDetail.findIndex(x => x.uid == item_uid);
                $.each(PRDetail[idx].attachments, function (i, d) {
                    var att_uid = d.uid
                    $(".clone_" + att_uid).remove();
                });      
                if (idx != -1) {
                    PRDetail.splice(idx, 1);
                }
            }

            $(this).closest("tr").remove();
        });

            $(document).on("change", "input[name='filename']", function () {
                var obj = $(this).closest("tr").find("input[name='attachment.filename']");
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

            var uploadValidationResult = {};
	        $(document).on("click", "#btnSave", function () {
		        var thisHandler = $(this);
		        $("[name=filename]").uploadValidation(function(result) {
			        uploadValidationResult = result;
			        onBtnClickSave.call(thisHandler);
		    });
	    });

        var onBtnClickSave = function () {
            var errorMsg = GeneralValidation();
            errorMsg += FileValidation();
            errorMsg += uploadValidationResult.not_found_message || '';

            if (errorMsg != "") {
                showErrorMessage(errorMsg);
            } else {
                var data = new Object();
                $("[name^='ic.']").each(function (i, d) {
                    const key = $(this).prop("name").replace("ic.", "");
                    let val = $(this).val();
                    if (key == "quantity") {
                        val = delCommas($(this).val());
                    }
                    data[key] = val;
                });
                data["actual_amount"] = delCommas($("#actual_value").text());
                data["actual_amount_usd"] = delCommas($("#actual_value_usd").text());
                data["temporary_id"] = $("[name='docidtemp']").val();

                data.attachments = [];
                $("#tblAttachment tbody tr").each(function () {
                    var _att = new Object();
                    _att["id"] = $(this).find("input[name='attachment.id']").val();
                    _att["filename"] = $(this).find("input[name='attachment.filename']").val();
                    _att["file_description"] = $(this).find("input[name='attachment.file_description']").val();
                    data.attachments.push(_att);

                    if ($(this).find("input[name='attachment.uploaded']").val() == "0") {
                        $(this).css({ 'background-color': 'rgb(245, 183, 177)' });
                        if (!errorMsg) {
                            errorMsg += "<br/> - There are files that have not been uploaded, please upload first.";
                        }
                    }
                });

                if (errorMsg != "") {
                    showErrorMessage(errorMsg);
                    return false;
                }

                var _data = { "submission": JSON.stringify(data) };
                $.ajax({
                    url: 'Item.aspx/Save',
                    data: JSON.stringify(_data),
                    dataType: 'json',
                    type: 'post',
                    contentType: "application/json; charset=utf-8",
                    success: function (response) {
                        var output = JSON.parse(response.d);
                        if (output.result !== "success") {
                            alert(output.message);
                        } else {
                            blockScreen();
                            $("input[name='doc_id']").val(output.id);
                            $("input[name='action']").val("fileupload");
                            UploadFileAPI("submit");
                        }
                    }
                });
            }
        };

        $(document).on("click", ".editDocument", function () {
            $(this).closest("tr").find("input[name='attachment.filename']").val("");
            var obj = $(this).closest("td").find("input[name='filename']");
            var link = $(this).closest("td").find(".linkDocument");

            $(this).closest("tr").find("input[name$='attachment.uploaded']").val("0");
            $(this).closest("td").find(".btnFileUpload").show();

            $(obj).val('');
            $(obj).show();
            $(link).hide();
            $(this).hide();
        });

        $(document).on("click", ".btnFileUpload", function () {
            $("#action").val("fileupload");

            $("#file_name").val($(this).closest("tr").find("input:file").val().split('\\').pop());

            var filename = $("#file_name").val();

            if (!$("#file_name").val()) {
                alert("Please choose file first");
                return false;
            } else {
                UploadFileAPI("");
                $(this).closest("tr").find("input[name$='attachment.uploaded']").val("1");
                $(this).closest("tr").css({ 'background-color': '' });

                GenerateFileLink(this, filename);
            }
        });

        function GenerateFileLink(row, filename) {
            var ic_id = '';
            var linkdoc = '';

            if ($("[name='ic.id']").val() == '' || $("[name='ic.id']").val() == null) {
                ic_id = $("[name='docidtemp']").val();
                linkdoc = "FilesTemp/" + ic_id + "/" + filename + "";
            } else {
                ic_id = $("[name='ic.id']").val();
                linkdoc = "Files/" + ic_id + "/" + filename + "";
            }

            $(row).closest("tr").find("input[name$='filename']").hide();

            $(row).closest("tr").find(".editDocument").show();
            $(row).closest("tr").find("a#linkDocument").attr("href", linkdoc);
            $(row).closest("tr").find("a#linkDocument").text(filename);
            $(row).closest("tr").find(".linkDocument").show();
            $(row).closest("tr").find(".btnFileUpload").hide();
        }

        function UploadFileAPI(actionType) {
            blockScreenOL();
            var form = $('form')[0];
            var formData = new FormData(form);
            $.ajax({
                type: "POST",
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
                        alert("Item closure has been saved successfully.");
                        switch (source.toLowerCase()) {
                            case "polist":
                                parent.location.href = "/procurement/purchaseorder/List.aspx";
                                break;
                            case "podetail":
                                parent.location.href = "/procurement/purchaseorder/detail.aspx?id=" + source_id;
                                break;
                            case "prlist":
                                parent.location.href = "/procurement/purchaserequisition/list.aspx";
                                break;
                            case "prdetail":
                                parent.location.href = "/procurement/purchaserequisition/detail.aspx?id=" + source_id;
                                break;
                            default:
                                break;
                        }
                    }
                },
                error: function (jqXHR, exception) {
                    unBlockScreenOL();
                }
            });

            $("#file_name").val("");
        }

        function UploadFile() {
            var form = $('form')[0];
            var formData = new FormData(form);

            $.ajax({
                type: "POST",
                url: '/Workspace/Procurement/Service.aspx',
                data: formData,
                processData: false,
                contentType: false,
                success: function (response) {
                    var output = JSON.parse(response);
                    if (output.result !== "success") {
                        alert(output.message);
                    } else {
                        alert("Item closure has been saved successfully.");
                        switch (source.toLowerCase()) {
                            case "polist":
                                parent.location.href = "/workspace/procurement/purchaseorder/List.aspx";
                                break;
                            case "podetail":
                                parent.location.href = "/workspace/procurement/purchaseorder/detail.aspx?id=" + source_id;
                                break;
                            case "prlist":
                                parent.location.href = "/workspace/procurement/purchaserequisition/list.aspx";
                                break;
                            case "prdetail":
                                parent.location.href = "/workspace/procurement/purchaserequisition/detail.aspx?id=" + source_id;
                                break;
                            default:
                                break;
                        }
                    }
                }
            });
        }

        $(document).on("click", "#btnClose", function () {
            blockScreen();
            switch (source.toLowerCase()) {
                case "polist":
                    parent.location.href = "/procurement/purchaseorder/List.aspx";
                    break;
                case "podetail":
                    parent.location.href = "/procurement/purchaseorder/detail.aspx?id=" + source_id;
                    break;
                case "prlist":
                    parent.location.href = "/procurement/purchaserequisition/list.aspx";
                    break;
                case "prdetail":
                    parent.location.href = "/procurement/purchaserequisition/detail.aspx?id=" + source_id;
                    break;
                default:
                    break;
            }
        });
    </script>
</asp:Content>