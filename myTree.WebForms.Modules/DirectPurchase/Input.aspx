<%@ Page MasterPageFile="~/Procurement.Master" Language="C#" AutoEventWireup="true" CodeBehind="Input.aspx.cs" Inherits="myTree.WebForms.Modules.DirectPurchase.Input" %>
<asp:Content ID="Content1" ContentPlaceHolderID="AppHead" runat="server">
    <title>Direct purchase</title>
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
    <%  if ((isAdmin || isUser) && !string.IsNullOrEmpty(_id))
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
    <div class="containerHeadline">
        <h2>Direct purchase information(s)</h2>
    </div>
    <div class="row-fluid">
        <div class="floatingBox">
            <div class="container-fluid">
                <div class="control-group">
                    <label class="control-label">
                        PR code
                    </label>
                    <div class="controls labelDetail">
                        <b><%=dp.pr_no %></b>
                        <input type="hidden" name="action" value="" id="action"/>
                        <input type="hidden" name="doc_id" value="<%=dp.id %>"/>
                        <input type="hidden" name="doc_type" value="DIRECT PURCHASE"/>
                        <input type="hidden" id="status" value="<%=dp.id %>"/>

                        <input type="hidden" name="id" value="<%=dp.id %>"/>
                        <input type="hidden" name="pr_id" value="<%=dp.pr_id %>"/>
                        <input type="hidden" name="pr_line_id" value="<%=dp.pr_line_id %>"/>
                        <input type="hidden" name="item_id" value="<%=dp.item_id %>"/>
                        <input type="hidden" name="docidtemp" value="" />
                        <input type="hidden" name="file_name" id="file_name" value="" />
                    </div>
                </div>
                <div class="control-group">
                    <label class="control-label">
                        Product code
                    </label>
                    <div class="controls labelDetail">
                        <%=dp.item_code %>
                    </div>
                </div>
               <%-- <div class="control-group">
                    <label class="control-label">
                        Brand
                    </label>
                    <div class="controls labelDetail">
                        <%=dp.brand_name %>
                    </div>
                </div>--%>
                <div class="control-group">
                    <label class="control-label">
                        Specifications
                    </label>
                    <div class="controls labelDetail">
                        <%=dp.description %>
                    </div>
                </div>
                <div class="control-group">
                    <label class="control-label">
                        Actual purchase date
                    </label>
                    <div class="controls">
                        <div class="input-prepend">
                            <input type="text" name="purchase_date" data-title="Purchase date" data-validation="required date" class="span8" readonly="readonly" placeholder="Purchase date" maxlength="11"/>
                            <span class="add-on icon-calendar" id="purchaseDate"></span>
                        </div>
                    </div>
                </div>
                <div class="control-group required">
                    <label class="control-label">
                        Actual supplier
                    </label>
                    <div class="controls">
                        <select class="span6" name="vendor_id" data-title="Actual supplier" data-validation="required" >
                            <%  if (!String.IsNullOrEmpty(dp.vendor_name))
                                { %>
                            <option value="<%=dp.vendor_id %>"><%=dp.vendor_name %></option>
                            <%  } %>
                        </select>
                    </div>
                </div>
                  <div class="control-group required">
                    <label class="control-label">
                       Supplier Address
                    </label>
                    <div class="controls">
                       <div class="span10">
                           
                        <table  class="table table-bordered table-hover" style="border: 1px solid #ddd">
                            <thead>
                                <tr>
                                    <th style="width: 40%">Address</th>
                                    <th style="width: 30%">Contact person</th>
                                    <th style="width: 30%">Email</th>
                                    <th ></th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td>
                                        <div id="SupplierAddress" style="display:block">
                                             <select name="dp.supplier_address" class="span12"></select>
                                        </div>
                                       
                                        <div id="SundryAddress"></div>
                                    </td>
                                    <td id="SupplierContactPerson"></td>
                                    <td id="SupplierEmail"></td>
                                    <td id="SupplierAction" data-id=""> 
                                         
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                        </div>
                    </div>
                </div>
                <div class="control-group">
                    <label class="control-label">
                        Detail(s)
                    </label>
                    <div class="controls">
                        <div class="span10">
                            <table class="table table-bordered table-hover" style="border: 1px solid #ddd">
                                <thead>
                                    <tr>
                                        <th style="width:40%;">&nbsp;</th>
                                        <th style="width:30%; text-align:center;">Requested</th>
                                        <th style="width:30%; text-align:center;">Actual</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td>Currency</td>
                                        <td ><%=dp.pr_currency %></td>
                                        <td><select name="purchase_currency" data-title="Currency" data-validation="required" class="span12" ></select></td>
                                    </tr>
                                    <tr>
                                        <td>Exchange rate (to USD)</td>
                                        <td style="text-align:right;"><%=dp.pr_exchange_rate %></td>
                                        <td><div class="input-prepend">
                                            <span class="add-on" id="exchange_sign"><%=dp.exchange_sign_format %></span>
                                            <input type="hidden" name="exchange_sign" value="<%=dp.exchange_sign %>"/>
                                            <input type="text" name="exchange_rate" data-title="Exchange rate" data-validation="required number" data-decimal-places="8" class="span10 number" placeholder="Exchange rate" maxlength="18" value="<%=dp.exchange_rate%>"/>
                                        </div></td>
                                    </tr>
                                    <tr>
                                        <td>Quantity</td>
                                        <td style="text-align:right;" id="pr_purchase_qty"><%=dp.purchase_qty %></td>
                                        <td style="text-align:right;"><%=dp.direct_purchase_qty %>
                                            <input type="hidden" name="purchase_qty" value="<%=dp.direct_purchase_qty %>"/>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>Unit price</td>
                                        <td style="text-align:right;" id="pr_unit_price"><%=dp.pr_unit_price %></td>
                                        <td><input type="text" name="unit_price" data-title="Unit price" data-validation="required number" data-decimal-places="2" class="span12 number" placeholder="Unit price" maxlength="18" value="<%=dp.unit_price%>"/></td>
                                    </tr>
                                    <tr>
                                        <td><b>Total</b></td>
                                        <td style="text-align:right;"><span id="pr_total_cost" style="font-weight:bold;"><%=dp.pr_total_cost %></span></td>
                                        <td style="text-align:right;"><span id="Total" style="font-weight:bold;"></span>
                                            <input type="hidden" name="total" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td><b>Total (USD)</b></td>
                                        <td style="text-align:right;"><span id="pr_total_usd" style="font-weight:bold;"><%=dp.pr_total_cost_usd %></span></td>
                                        <td style="text-align:right;"><span id="TotalUSD" style="font-weight:bold;"></span>
                                            <input type="hidden" name="totalUSD" />
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
                <div class="control-group">
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
                <div class="control-group last">
                    <div class="controls">
                        <button id="btnClose" class="btn" type="button">Close page</button>&nbsp;&nbsp;&nbsp;
                        <button id="btnSave" class="btn btn-success" type="button">Save</button>                           
                    </div>
                </div>
            </div>
        </div>
    </div>

            <!-- Bootstrap modal sundry supplier-->
    <div id="SundryForm" class="modal hide fade modal-dialog" tabindex="-1" role="dialog" aria-labelledby="header1" aria-hidden="true"
        data-backdrop="static" data-keyboard="false">
        <div class="modal-header">
            <button type="button" class="close" data-dismiss="modal" aria-hidden="true"></button>
            <h3 id="header1">Add detail sundry supplier</h3>
        </div>
        <div class="modal-body">
            <div class="floatingBox" id="SundryForm-error-box" style="display: none">
                <div class="alert alert-error" id="SundryForm-error-message">
                </div>
            </div>

            <table id="" class="table table-bordered table-hover" style="border: 1px solid #ddd">
                <thead>
                    <tr>
                        <th style="width: 30%;">&nbsp;</th>
                        <th style="width: 70%;" id="source_info">Supplier information</th>
                    </tr>
                </thead>
                <tbody>
                </tbody>
            </table>
        </div>
        <div class="modal-footer">
            <button type="button" class="btn btn-success" aria-hidden="true" id="btnSundrySave">Save</button>
            <button type="button" class="btn" data-dismiss="modal" aria-hidden="true">Close and cancel</button>
        </div>
    </div>
    <!-- end of bootstrap modal -->

    <script>
        var _id = "<%=_id%>";
        var deletedId = [];

        var listCurrency = <%=listCurrency%>;
        var listAttachment = <%=listAttachment%>;
        var _currency = "<%=dp.purchase_currency%>";
        var purchase_date = new Date("<%=dp.purchase_date%>");

        var source = "<%=source%>";
        var filenameupload = "";
        var btnFileUpload = null;
        var listSupplierAddress = <%= listSupplierAddress%>;
        var supplierId = "<%=supplier_id %>";
        var supplierAddressId = "<%=supplier_address_id %>";
        var dataSundry = <%= listSundry %>;

        $(document).ready(function () {
            var cboCurr = $("select[name='purchase_currency']");
            generateCombo(cboCurr, listCurrency, "CURRENCY_CODE", "CURRENCY_CODE", true);
            $(cboCurr).val(_currency);
            Select2Obj(cboCurr, "Currency");

            $(cboCurr).on('select2:select', function (e) {
                changeExchangeRate($(this).val());
            });

            $("#purchaseDate").datepicker({
                format: "dd M yyyy"
                , autoclose: true
            }).on("changeDate", function () {
                $("[name='purchase_date']").val($("#purchaseDate").data("date"));
                $("#purchaseDate").datepicker("hide");
            });

            $("#purchaseDate").datepicker("setDate", purchase_date).trigger("changeDate");

            repopulateNumber();
            CalculateTotal();

            $.each(listAttachment, function (i, d) {
                addAttachment(d.id, "", d.file_description, d.filename);
            });

            $("[name='vendor_id']").select2({
                placeholder: "Actual Supplier",
                minimumInputLength: 2,
                allowClear: true                
            });

            $.ajax({
                url: "<%=Page.ResolveUrl("~/Service.aspx/GetVendorList")%>",
                dataType: 'json',
                type: 'post',
                delay: 500,
                contentType: "application/json; charset=utf-8",
                success: function (response) {

                    listVendor = JSON.parse(response.d);                
                    var cboVendor = $("select[name='vendor_id']");
                    cboVendor.empty();
                    generateCombo(cboVendor, listVendor, "id", "company_name", true);
                    Select2Obj(cboVendor, "Supplier");
                }
            });

            populatePR();

            $("[name='docidtemp']").val(guid());
            lookUpSupplierAddress();
        });

        function populatePR() {
            $("#pr_purchase_qty").text(accounting.formatNumber($("#pr_purchase_qty").text(), 2));
            $("#pr_unit_price").text(accounting.formatNumber($("#pr_unit_price").text(), 2));
            $("#pr_total_cost").text(accounting.formatNumber($("#pr_total_cost").text(), 2));
            $("#pr_total_usd").text(accounting.formatNumber($("#pr_total_usd").text(), 2));

        }


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

            data.id = $("[name='id']").val();
            data.pr_line_id = $("[name='pr_line_id']").val();
            data.item_id = $("[name='item_id']").val();
            data.vendor_id = $("[name='vendor_id']").val();
            data.purchase_currency = $("[name='purchase_currency']").val();
            data.purchase_qty = delCommas($("[name='purchase_qty']").val());
            data.exchange_sign = $("[name='exchange_sign']").val();
            data.exchange_rate = delCommas($("[name='exchange_rate']").val());
            data.unit_price = delCommas($("[name='unit_price']").val());
            data.total_cost = delCommas($("[name='total']").val());
            data.total_cost_usd = delCommas(accounting.format($("[name='totalUSD']").val()));
            data.purchase_date = $("[name='purchase_date']").val();
            data.temporary_id = $("[name='docidtemp']").val();
            data.vendor_address_id = $("select[name = 'dp.supplier_address']").attr("selected", "selected").val(); 

            data.attachments = [];
            $("#tblAttachment tbody tr").each(function () {
                var _att = new Object();
                _att["id"] = $(this).find("input[name='attachment.id']").val();
                _att["filename"] = $(this).find("input[name='attachment.filename']").val();
                _att["file_description"] = $(this).find("input[name='attachment.file_description']").val();
                data.attachments.push(_att);
            });

            data.sundry = [];
            var sundry_detail = $.grep(dataSundry, function (n, k) {
                return n["sundry_supplier_id"] == data.vendor_id;
            });
            if (sundry_detail.length > 0) {
                data.sundry.push(sundry_detail[0]);
            }

            return data;
        }

        function SubmitValidation(data) {
            var errorMsg = "";
            errorMsg += GeneralValidation();
            errorMsg += FileValidation();
            errorMsg += uploadValidationResult.not_found_message||'';

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

        function Submit(_data) {
            $.ajax({
                url: "<%=Page.ResolveUrl("Input.aspx/Save")%>",
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
                            /*UploadFile();*/
                            UploadFileAPI("submit");
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
                url: "<%=Page.ResolveUrl("~/Service.aspx")%>",
                data: formData,
                processData: false,
                contentType: false,
                success: function (response) {
                    var output = JSON.parse(response);
                    if (output.result != "success") {
                        alert(output.message);
                    } else {
                        alert("Direct purchase has been saved successfully");
                        blockScreen();
                        if (source === "detail") {
                            var _pr_id = $("[name='pr_id']").val();
                            location.href = '<%=Page.ResolveUrl("~/PurchaseRequisition/Detail.aspx?id=' + _pr_id + '")%>';
                        } else {
                            location.href = '<%=Page.ResolveUrl("~/PurchaseRequisition/list.aspx")%>';

                        }
                    }
                }
            });
        }

        $(document).on("change", "[name='unit_price'],[name='exchange_rate']", function () {
            CalculateTotal();
        });

        function changeExchangeRate(curr) {
            var arr = $.grep(listCurrency, function (n, i) {
                return n["CURRENCY_CODE"] === curr;
            });

            var _sign = "/";
            var _rate = 0;
            if (arr.length > 0) {
                if (arr[0].OPERATOR === "/") {
                    _sign = "&divide;";
                } else {
                    _sign = "x";
                }
                _rate = accounting.formatNumber(arr[0].RATE,6);
            }

            $("#exchange_sign").html(_sign);
            $("[name='exchange_sign']").val(arr[0].OPERATOR);
            $("[name='exchange_rate']").val(_rate);
            CalculateTotal();
        }

        function CalculateTotal() {
            var curr = $("[name='purchase_currency']").val();
            var sign = $("[name='exchange_sign']").val();
            var rate = delCommas($("[name='exchange_rate']").val());
            var total_cost = 0;
            var total_cost_usd = 0;

            total_cost = delCommas($("[name='purchase_qty']").val()) * delCommas($("[name='unit_price']").val());
            total_cost = delCommas(accounting.formatNumber(total_cost, 2));

            if (sign === "/") {
                total_cost_usd = delCommas(accounting.formatNumber(total_cost / rate, 2));
            } else {
                total_cost_usd = delCommas(accounting.formatNumber(total_cost * rate, 2));
            }
            
            $("#Total").html(curr + ' ' + accounting.formatNumber(total_cost, 2));
            $("#TotalUSD").html(accounting.formatNumber(total_cost_usd, 2));

            $("[name='total']").val(total_cost);
            $("[name='totalUSD']").val(total_cost_usd);
        }

        $(document).on("click", ".editDocument", function () {
            $(this).closest("tr").find("input[name='attachment.filename']").val("");
            var obj = $(this).closest("td").find("input[name='filename']");
            var link = $(this).closest("td").find(".linkDocument");

            $(this).closest("tr").find("input[name$='attachment.uploaded']").val("0");
            $(this).closest("td").find(".btnFileUpload").show();

            $(obj).show();
            $(link).hide();
            $(this).hide();
        });

        $(document).on("click", ".btnFileUpload", function () {
            $("#action").val("fileupload");
            btnFileUpload = this;
            $("#file_name").val($(this).closest("tr").find("input:file").val().split('\\').pop());

           /* var filename = $("#file_name").val();*/
            filenameupload = $("#file_name").val();

            if (!$("#file_name").val()) {
                alert("Please choose file first");
                return false;
            } else {
                let errorMsg = FileValidation();
                if (FileValidation() !== '') {
                    if ($(this).data("type") == '') {
                        $("#error-message").html("<b>" + "- Supporting document(s):" + "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" + errorMsg + "<b>");
                        $("#error-box").show();
                        $('.modal-body').animate({ scrollTop: 0 }, 500);
                    } else {
                        showErrorMessage(errorMsg);
                    }

                    return false;
                }

                UploadFileAPI("");
                $(this).closest("tr").find("input[name$='attachment.uploaded']").val("1");
                $(this).closest("tr").css({ 'background-color': '' });
               /* GenerateFileLink(this, filename);*/

            }
        });

        function GenerateFileLink(row, filename) {
            var pr_id = '';
            var linkdoc = '';

            if ($("[name='pr.id']").val() == '' || $("[name='pr.id']").val() == null) {
                pr_id = $("[name='docidtemp']").val();
                linkdoc = "FilesTemp/" + pr_id + "/" + filename + "";
            } else {
                pr_id = $("[name='pr.id']").val();
                linkdoc = "Files/" + pr_id + "/" + filename + "";
            }

            $(row).closest("tr").find("input[name$='filename']").hide();

            $(row).closest("tr").find(".editDocument").show();
            $(row).closest("tr").find("a#linkDocument").attr("href", linkdoc);
            $(row).closest("tr").find("a#linkDocument").text(filename);
            $(row).closest("tr").find(".linkDocument").show();
            $(row).closest("tr").find(".btnFileUpload").hide();
            $(row).closest("tr").find("input[name='attachment.filename.validation']").val(filename);

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

            $(this).closest("tr").remove();
        });

        $(document).on("click", "#btnClose", function () {
            if (source === "detail") {
                var _pr_id = $("[name='pr_id']").val();
                location.href = '<%=Page.ResolveUrl("~/PurchaseRequisition/Detail.aspx?id=' + _pr_id + '")%>';
            } else {
                 location.href = '<%=Page.ResolveUrl("~/PurchaseRequisition/List.aspx")%>';
             }
        });

        $(document).on("click", "#btnAddAttachment", function () {
            addAttachment("", "", "", "");
        });

        function addAttachment(id, uid, description, filename) {
            var _pr_id = $("[name='pr.id']").val();
            if (uid === "" || typeof uid === "undefined" || uid === null) {
                var uid = guid();
            }
            var html = '<tr>';
            html += '<td><input type="hidden" name="attachment.uid" value="' + uid + '"/><input type="text" class="span12" name="attachment.file_description" data-title="Supporting document description" data-validation="required" maxlength="2000" placeholder="Description" value="' + description + '"/></td>';
            html += '<td><input type="hidden" name="attachment.filename" data-title="Supporting document file" data-validation="required" value="' + filename + '"/><div class="fileinput_' + uid + '">';
            /*html += '<input type="hidden" name="attachment.filename.validation" data-title="Quotation file" data-validation="required" value="' + filename + '" />';*/
            if (id !== "" && filename !== "") {
                html += '<span class="linkDocument"><a href="Files/' + _id + '/' + filename + '" target="_blank" id="linkDocument">' + filename + '</a>&nbsp;</span>';
                html += '<button type="button" class="btn btn-primary editDocument">Edit</button><input type="file" class="span10" name="filename" style="display: none;"/>';
                html += '<button type="button" class="btn btn-success btnFileUpload" style="display:none;">Upload</button>';
            } else {
                html += '<span class="linkDocument"><a href="" target="_blank" id="linkDocument">' + filename + '</a>&nbsp;</span>';
                html += '<button type="button" class="btn btn-primary editDocument" style="display: none;">Edit</button><input type="file" class="span10" name="filename"/>';
                html += '<button type="button" class="btn btn-success btnFileUpload">Upload</button>';
            }
            html += '</div></td > ';
            html += '<td><input type="hidden" name="attachment.id" value="' + id + '"/><span class="label red btnDelete"><i class="icon-trash delete" style="opacity: 1;"></i></span></td>';
            if (filename !== "") {
                html += '<td style="display:none;"><input type="hidden" name="attachment.uploaded" value="1"/></td>';
            } else {
                html += '<td style="display:none;"><input type="hidden" name="attachment.uploaded" value="0"/></td>';
            }
            html += '</tr>';
            $("#tblAttachment tbody").append(html);
        }

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

        $(document).on("click", ".editDocument", function () {
            var obj = $(this).closest("td").find("input[name='filename']");
            var link = $(this).closest("td").find(".linkDocument");
            $(obj).show();
            $(link).hide();
            $(this).hide();
        });

        $(document).on("click", "#btnAuditTrail", function () {
            parent.ShowCustomPopUp("/workspace/procurement/audittrail.aspx?blankmode=1&module=directpurchase&id=" + _id);
        });

        function UploadFileAPI(actionType) {
            blockScreenOL();
            var form = $('form')[0];
            var formData = new FormData(form);
            $.ajax({
                type: "POST",
                <%--url: "<%=service_url%>",--%>
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
                        if (output.result == '') {
                            //if ($(btnFileUpload).data("type") == 'filecancel') {
                            //    GenerateCancelFileLink(btnFileUpload, filenameupload);
                            //} else {
                            //    GenerateFileLink(btnFileUpload, filenameupload);
                            //}
                            GenerateFileLink(btnFileUpload, filenameupload);
                        } else {
                            alert('Upload file failed');
                        }
                    } else {
                        alert("Direct purchase has been saved successfully");
                        if (actionType.toLowerCase() == "submit") {
                            /*parent.location.href = "Input.aspx?id=" + $("[name='quo.id']").val();*/
                            var _pr_id = $("[name='pr_id']").val();
                            location.href = '<%=Page.ResolveUrl("~/PurchaseRequisition/Detail.aspx?id=' + _pr_id + '")%>';
                        } else {
                            location.href = '<%=Page.ResolveUrl("~/PurchaseRequisition/list.aspx")%>';
                        }
               

                       <%-- alert("Direct purchase has been saved successfully");
                        blockScreen();
                        if (source === "detail") {
                            var _pr_id = $("[name='pr_id']").val();
                            location.href = '<%=Page.ResolveUrl("~/PurchaseRequisition/Detail.aspx?id=' + _pr_id + '")%>';
                        } else {
                            location.href = '<%=Page.ResolveUrl("~/PurchaseRequisition/list.aspx")%>';

                        }--%>
                    }
                },
                error: function (jqXHR, exception) {
                    unBlockScreenOL();
                }
            });

            $("#file_name").val("");
        }

        function lookUpSupplierAddress() {
            var data = listSupplierAddress;
            if (supplierId != "") {

                $("#SupplierAddress").show();
                data = $.grep(listSupplierAddress, function (n, i) {
                    return n["id"] == supplierId;
                });

                if (data[0].IsSundry == "1") {
                    resetSupplierAddress();
                    hideSelectSupplierAddress()
                    loadBtnEditSundry();
                    loadCurrentAddressSundry();
                    $("#sundry_address").attr("data-validation", "required");
                    $("#SupplierAction").attr("data-id", supplierId);
                } else {
                    showSelectSupplierAddress();
                    $("#sundry_address").removeAttr("data-validation", "");
                    $("#SundryAddress").empty();
                    loadSupplierAddressRequired()

                }
            }


            if (supplierId == "") {
                resetSupplierAddress();
            } else {
                var cbo = $("select[name='dp.supplier_address']").empty();;
                generateCombo(cbo, data, "vendor_address_id", "address", true);

                Select2Obj(cbo, "Supplier address");
                //setSupplier();
            }
          
        }


        $('[name="vendor_id"]').on('change', function () {
            resetSupplierAddress();
            supplierId = $(this).find(":selected").val();
            showSelectSupplierAddress();
            lookUpSupplierAddress();
            setSupplier();
           
        });

        $('[name="dp.supplier_address"]').on('change', function () {
            supplierAddressId = $(this).find(":selected").val();
            var data = $.grep(listSupplierAddress, function (n, i) {
                return n["vendor_address_id"] == supplierAddressId;
            });
            if (data.length > 0) {
                if (data[0].vendor_address_id == supplierAddressId) {
                    $("#SupplierContactPerson").text(data[0].contact_person);
                    $("#SupplierEmail").text(data[0].email);
                    $("#supplier_address").val(data[0].vendor_address_id)
                }
            }
        });

        function showSelectSupplierAddress() {
            $("#SupplierAddress").show();
            $("[name='dp.supplier_address']").select2({ width: 'element' });
        }

        function hideSelectSupplierAddress() {
            $("#SupplierAddress").hide();
            $("[name='dp.supplier_address']").select2({ width: 'element' });

        }

        function loadSupplierAddressRequired() {
            var html = '<input id="supplier_address" type="hidden" data-validation="required" data-title="Supplier address">';
            $("#SupplierAction").html(html);

        }

        function setSupplier() {

            var data = $.grep(listSupplierAddress, function (n, i) {
                return n["id"] == supplierId;
            });

            if (data.length > 0) {
         

                for (let i = 0; i < data.length; i++) {
                    if (data[i].vendor_address_id == supplierAddressId) {

                        $("#SupplierContactPerson").text(data[i].contact_person);
                        $("#SupplierEmail").text(data[i].email);
                        $("select[name='dp.supplier_address']").val(supplierAddressId).trigger("change");

                    }
                }
            }

            if (data.length == 1) {
                $("select[name='dp.supplier_address']").val(data[0].vendor_address_id).trigger("change");
            }


           
        }

        function resetSupplierAddress() {
            $("#SupplierContactPerson").text("");
            $("#SupplierEmail").text("");
            $("select[name='dp.supplier_address']").empty();

        }

        function loadBtnEditSundry() {
            var btnEditSundry = '<span class="label green btnSundryEdit" data-toggle="modal" href="#SundryForm" title="Detail"><i class="icon-pencil edit" style="opacity: 0.7;"></i></span >'
                + '<input id="sundry_address" type="hidden" data-validation="required" data-title="Supplier address">';
            $("#SupplierAction").html(btnEditSundry);
        }



        //Sundry supplier
        $(document).on("click", ".btnSundryEdit", function () {
            var id = $("#SupplierAction").attr("data-id")
            var idx = listSupplierAddress.findIndex(x => x.id == id);
            var d = listSupplierAddress[idx];

            EditSundry(d);
        });

        function EditSundry(d) {
            $("#SundryForm tbody").empty();
            $("#SundryForm-error-message").empty();
            $("#SundryForm-error-box").hide();

            var html = AddDetailSundrySupplierHTML(d.company_name, d.id, "","","");
            //html += '<tr>'
            //    + '<td>Sundry </td>'
            //    + '<td>' + d.company_name
            //    + '<input type="hidden" name="sundry.id" value="' + d.id + '" >'
            //    + '</td>'
            //    + '</tr>'
            //    + '<tr>'
            //    + '<td>Name <span style="color: red;">*</span></td>'
            //    + '<td>'
            //    + '<div class="">'
            //    + '<div class="">'
            //    + '<input type="text" name="sundry.name" maxlength="255" placeholder="Name" value=""  class="span12" />'
            //    + '</div>'
            //    + '</div>'
            //    + '</td>'
            //    + '</tr>'
            //    + '<tr>'
            //    //
            //    + '<tr>'
            //    + '<td>Contact person <span style="color: red;">*</span></td>'
            //    + '<td>'
            //    + '<div class="">'
            //    + '<div class="">'
            //    + '<input type="text" name="sundry.contact_person" placeholder="Contact person" value="" class="span12"/>'
            //    + '</div>'
            //    + '</div>'
            //    + '</td>'
            //    + '</tr>'
            //    //
            //    + '<tr>'
            //    + '<td>Email <span style="color: red;">*</span></td>'
            //    + '<td>'
            //    + '<div class="">'
            //    + '<div class="">'//
            //    + '<input type="email" name="sundry.email" data-title="email" placeholder="Email" value="" class="span12"/>'
            //    + '</div>'
            //    + '</div>'
            //    + '</td>'
            //    + '</tr>'
            //    //
            //    + '<tr>'
            //    + '<td>Phone number <span style="color: red;">*</span></td>'
            //    + '<td>'
            //    + '<div class="">'
            //    + '<div class="">'//
            //    + '<input type="text" name="sundry.phone_number" placeholder="Phone number" value="" class="span12"/>'
            //    + '</div>'
            //    + '</div>'
            //    + '</td>'
            //    + '</tr>'
            //    //
            //    + '<td>Bank account</td>'
            //    + '<td>'
            //    + '<div class="">'
            //    + '<div class="">'
            //    + '<input type="text" name="sundry.bank_account" maxlength="35" placeholder="Bank account" value="" class="span12"/>'
            //    + '</div>'
            //    + '</div>'
            //    + '</td>'
            //    + '</tr>'
            //    + '<tr>'
            //    + '<td>Swift</td>'
            //    + '<td>'
            //    + '<div class="">'
            //    + '<div class="">'
            //    + '<input type="text" name="sundry.swift" maxlength="11" placeholder="Swift" value="" class="span12"/>'
            //    + '</div>'
            //    + '</div>'
            //    + '</td>'
            //    + '</tr>'
            //    + '<tr>'
            //    + '<td>Sort code</td>'
            //    + '<td>'
            //    + '<div class="">'
            //    + '<div class="">'
            //    + '<input type="text" name="sundry.sort_code" maxlength="13" placeholder="Sort code" value="" class="span12"/>'
            //    + '</div>'
            //    + '</div>'
            //    + '</td>'
            //    + '</tr>'
            //    + '<tr>'
            //    + '<td>Address</td>'
            //    + '<td>'
            //    + '<textarea name="sundry.address" maxlength="160" class="textareavertical span12"  maxlength="2000" rows="10" placeholder="address" ></textarea>'
            //    + '<div class="mt-1" style="font-size: 80%; font-style: italic; display: block;">Maximum description is 2,000 characters</div>'
            //    + '</td>'
            //    + '</tr>'
            //    + '<tr>'
            //    + '<td>Place <span style="color: red;">*</span></td>'
            //    + '<td>'
            //    + '<div class="">'
            //    + '<div class="">'
            //    + '<input type="text" name="sundry.place" maxlength="40" placeholder="Place" value=""  class="span12"/>'
            //    + '</div>'
            //    + '</div>'
            //    + '</td>'
            //    + '</tr>'
            //    + '<tr>'
            //    + '<td>Province</td>'
            //    + '<td>'
            //    + '<div class="">'
            //    + '<div class="">'
            //    + '<input type="text" name="sundry.province" maxlength="40" placeholder="Province" value="" class="span12"/>'
            //    + '</div>'
            //    + '</div>'
            //    + '</td>'
            //    + '</tr>'
            //    + '<tr>'
            //    + '<td>Post code</td>'
            //    + '<td>'
            //    + '<div class="">'
            //    + '<div class="">'
            //    + '<input type="text" name="sundry.post_code" maxlength="15" placeholder="Post code" value="" class="span12"/>'
            //    + '</div>'
            //    + '</div>'
            //    + '</td>'
            //    + '</tr>'
            //    + '<tr>'
            //    + '<td>VAT RegNo</td>'
            //    + '<td>'
            //    + '<div class="">'
            //    + '<div class="">'
            //    + '<input type="text" name="sundry.vat_reg_no" maxlength="25" placeholder="VAT RegNo"  value="" class="span12"/>'
            //    + '</div>'
            //    + '</div>'
            //    + '</td>'
            //    + '</tr>';

            $("#SundryForm").modal("show");
            $("#SundryForm tbody").append(html);
            populateSundry();
        }

        $(document).on("click", "#btnSundrySave", function () {
            validateSundry();
        });

        function validateSundry() {
            var errorMsg = "";
            var confirmMsg = "";
            errorMsg += EmailValidation();

            if ($("[name='sundry.name']").val() == "") {
                errorMsg += "<br/> - Name is required.";
            }

            if ($("[name='sundry.contact_person']").val() == "") {
                errorMsg += "<br/> - Contact person is required.";
            }
            if ($("[name='sundry.email']").val() == "") {
                errorMsg += "<br/> - email is required.";
            }
            if ($("[name='sundry.phone_number']").val() == "") {
                errorMsg += "<br/> - Phone number is required.";
            }

            if ($("[name='sundry.place']").val() == "") {
                errorMsg += "<br/> - Place is required.";
            }

            if (errorMsg !== "") {
                errorMsg = "Please correct the following error(s):" + errorMsg;

                $("#SundryForm-error-message").html("<b>" + errorMsg + "<b>");
                $("#SundryForm-error-box").show();
                $('.modal-body').animate({ scrollTop: 0 }, 500);
            }
            else {
                if (confirmMsg != "") {
                    confirmMsg += "Do you want to proceed?";

                    if (!confirm(confirmMsg)) {
                        return;
                    }
                }

                var id = $("[name='sundry.id']").val();
                var idx = listSupplierAddress.findIndex(x => x.id == id);
                var d = listSupplierAddress[idx];

                var data = new Object();
                data.id = "";
                data.sundry_supplier_id = d.id;
                data.module_id = "";
                data.module_type = "";
                data.name = $("[name='sundry.name']").val();
                data.address = $("[name='sundry.address']").val();
                data.bank_account = $("[name='sundry.bank_account']").val();
                data.swift = $("[name='sundry.swift']").val();
                data.sort_code = $("[name='sundry.sort_code']").val();
                data.place = $("[name='sundry.place']").val();
                data.province = $("[name='sundry.province']").val();
                data.post_code = $("[name='sundry.post_code']").val();
                data.vat_reg_no = $("[name='sundry.vat_reg_no']").val();
                data.contact_person = $("[name='sundry.contact_person']").val();
                data.email = $("[name='sundry.email']").val();
                data.phone_number = $("[name='sundry.phone_number']").val();

                // check data sundry
                var ids = dataSundry.findIndex(x => x.sundry_supplier_id == d.id);
                if (ids != -1) {
                    data.id = dataSundry[ids].id;
                    dataSundry.splice(ids, 1); // remove sundry
                }

                dataSundry.push(data);
                $("#SupplierContactPerson").html(data.contact_person);
                $("#SupplierEmail").html(data.email);

                $("#SundryAddress").html(setSundryAddress(data));
                $("#sundry_address").val(setSundryAddress(data));

                $("#SundryForm").modal("hide");
            }
        }

        function populateSundry() {
            var id = $("[name='sundry.id']").val();
            var idx = dataSundry.findIndex(x => x.sundry_supplier_id == id);
            var d = dataSundry[idx];
            if (idx != -1) {
                $("[name='sundry.name']").val(d.name);
                $("[name='sundry.address']").text(d.address);
                $("[name='sundry.bank_account']").val(d.bank_account);
                $("[name='sundry.swift']").val(d.swift);
                $("[name='sundry.sort_code']").val(d.sort_code);
                $("[name='sundry.place']").val(d.place);
                $("[name='sundry.province']").val(d.province);
                $("[name='sundry.post_code']").val(d.post_code);
                $("[name='sundry.vat_reg_no']").val(d.vat_reg_no);
                $("[name='sundry.contact_person']").val(d.contact_person);
                $("[name='sundry.email']").val(d.email);
                $("[name='sundry.phone_number']").val(d.phone_number);
            }

        }

        function setSundryAddress(data) {
            var address = ""
            if (data.address != "") {
                address += data.address;
            }

            if (data.place != "") {
                if (address != "") {
                    address += ", " + data.place;
                } else {
                    address += data.place;
                }
            }

            if (data.province != "") {
                if (address != "") {
                    address += ", " + data.province;
                } else {
                    address += data.province;
                }
            }

            return address;
        }

        function loadCurrentAddressSundry() {
            var id = $("[name='vendor_id']").val();
            var currentSundry = dataSundry;


            var sundry = $.grep(currentSundry, function (n, i) {
                return n["sundry_supplier_id"] == id
            });
            if (sundry.length > 0) {
                $("#SundryAddress").html(setSundryAddress(sundry[0]));
                $("#sundry_address").val(setSundryAddress(sundry[0]));
                $("#SupplierContactPerson").html(sundry[0].contact_person);
                $("#SupplierEmail").html(sundry[0].email);
            } else {
                $("#SundryAddress").empty();
                $("#sundry_address").val("");
                $("#SupplierContactPerson").empty();
                $("#SupplierEmail").empty();
            }
        }

        function resetDataSundry() {
            dataSundry = [];
        }

        // end sundry supplier


    </script>
</asp:Content>