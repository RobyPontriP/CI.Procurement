<%@ Page MasterPageFile="~/Procurement.Master" Language="C#" AutoEventWireup="true" CodeBehind="Input.aspx.cs" Inherits="myTree.WebForms.Modules.RFQ.Input" %>
<%@ Register Src="~/Usc/uscRecentComment.ascx" TagName="recentcomment" TagPrefix="uscComment" %>
<%@ Register Src="~/Usc/uscCancellationForm.ascx" TagName="cancellationform" TagPrefix="uscCancellation" %>
<asp:Content ID="Content1" ContentPlaceHolderID="AppHead" runat="server">
    <title>Request for Quotation</title>
    <style>
        .select2 {
            min-width: 250px !important;
        }

        #CancelForm.modal-dialog {
            margin: auto 12% !important;
            width: 60% !important;
            height: 320px !important;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="AppBody" runat="server">
    <div class="floatingBox" id="error-box" style="display: none">
        <div class="alert alert-error" id="error-message">
        </div>
    </div>
    <!-- Cancellation Form -->
    <uscCancellation:cancellationform ID="cancellationForm" runat="server" />

    <!-- Recent comment -->
    <uscComment:recentcomment ID="recentComment" runat="server" />

    <!-- for upload file -->
    <input type="hidden" id="action" name="action" value=""/>
    <input type="hidden" id="rfq.id" name="doc_id" value="<%=RFQ.id %>"/>
    <input type="hidden" name="doc_type" value="RFQ"/>
    <input type="hidden" name="file_name" id="file_name" value="" />
    <!-- end of upload file -->

    <div class="row-fluid">
        <div class="floatingBox">
            <div class="container-fluid">
                <input type="hidden" name="rfq.id" value="<%=RFQ.id %>"/>
                <input type="hidden" name="rfq.copy_from_id" value="<%=RFQ.copy_from_id %>"/>
                <input type="hidden" name="rfq.rfq_no" value="<%=RFQ.rfq_no %>"/>
                <input type="hidden" name="rfq.cifor_office_id" value="<%=RFQ.cifor_office_id %>"/>
                <input type="hidden" name="rfq.status_id" value="<%=RFQ.status_id %>"/>

                <input type="hidden" id="status" value="<%=!String.IsNullOrEmpty(copy_id)?"":RFQ.status_id %>"/>
                <%  if (!String.IsNullOrEmpty(RFQ.rfq_no))
                    { %>
                <div class="control-group">
                    <label class="control-label">
                        RFQ code
                    </label>
                    <div class="controls labelDetail">
                        <b><%=RFQ.rfq_no %></b>
                    </div>
                </div>
                <%  } %>
                <%  if (String.IsNullOrEmpty(copy_id))
                    { %>
                <div class="control-group">
                    <label class="control-label">
                        RFQ status
                    </label>
                    <div class="controls labelDetail">
                        <b><%=RFQ.status_name %></b>
                    </div>
                </div>
                <%  } %>
                <div class="control-group required">
                    <label class="control-label">
                        Document date
                    </label>
                    <div class="controls">
                        <div class="input-prepend" style="margin-right:-32px;">
                            <input type="text" name="rfq.document_date" id="_document_date" data-title="Document date" data-validation="required" class="span8" readonly="readonly" placeholder="Document date" maxlength="11"/>
                            <span class="add-on icon-calendar" id="document_date"></span>
                        </div>                                
                    </div> 
                </div>
                <div class="control-group">
                    <label class="control-label">
                        Due date
                    </label>
                    <div class="controls">
                        <div class="input-prepend" style="margin-right:-32px;">
                            <input type="text" name="rfq.due_date" id="_due_date" data-title="Due date" class="span8" readonly="readonly" placeholder="Due date" maxlength="11"/>
                            <span class="add-on icon-calendar" id="due_date"></span>
                        </div>                                
                    </div>
                </div>
                <div class="control-group">
                    <label class="control-label">
                        Remarks
                    </label>
                    <div class="controls">
                        <textarea name="rfq.remarks" data-title="Remarks" rows="5" class="span10 textareavertical" placeholder="Remarks" maxlength="2000"><%=RFQ.remarks %></textarea>
                          <div class="mt-1" style="font-size: 80%; font-style: italic; display: block;">Maximum description is 2,000 characters</div>
                    </div>
                </div>
                <div class="control-group required">
                    <label class="control-label">
                        Actual date sent to supplier
                    </label>
                    <div class="controls">
                        <div class="input-prepend" style="margin-right:-32px;">
                            <input type="text" name="rfq.send_date" id="_send_date" data-validation="required" data-title="Actual date sent to supplier" class="span8" readonly="readonly" placeholder="Actual date sent to supplier" maxlength="11"/>
                            <span class="add-on icon-calendar" id="send_date"></span>
                        </div>                                
                    </div>
                </div>
                <div class="control-group">
                    <table id="tblItems" data-title="Item(s)" class="table table-bordered table-hover required" style="border: 1px solid #ddd">
                        <thead>
                            <tr>
                                <th style="width:12%">PR code</th>
                                <th style="width:15%">Product code</th>
                                <th style="width:50%">Description</th>
                                <th style="width:18%">Quantity</th>
                                <th style="width:5%">&nbsp;</th>
                            </tr>
                        </thead>
                        <tbody>
                        </tbody>
                    </table>
                    <p><button id="btnAddItem" href="#SearchForm" class="btn btn-success" type="button" data-toggle="modal">Add new product</button></p>
                </div>
                <div class="control-group">
                    <table id="tblVendors" class="table table-bordered table-hover" style="border: 1px solid #ddd">
                        <thead>
                            <tr>
                                <th style="width:20%" class="<%=!String.IsNullOrEmpty(copy_id)?"required":"" %>">Supplier name</th>
                                <th style="width:40%" >Address</th>
                                <th style="width:20%" class="<%=!String.IsNullOrEmpty(copy_id)?"required":"" %>">Contact person</th>
                                <th style="width:20%">Email</th>
                                <th style="width:20%"></th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr id="vendor_<%=RFQ.vendor%>">
                                <%  if (!String.IsNullOrEmpty(copy_id))
                                    { %>
                                <td ><select name="rfq.vendor" class="span12" data-validation="required" data-title="Vendor">
                                    <%  if (!String.IsNullOrEmpty(RFQ.vendor_name))
                                        { %>
                                    <option value="<%=RFQ.vendor %>"><%=RFQ.vendor_name %> (<%=RFQ.vendor_code %>)</option>
                                    <%  } %>
                                    </select></td>
                                <%  }else{ %>
                                <td ><input type="hidden" name="rfq.vendor" value="<%=RFQ.vendor %>"/>
                                    <%=RFQ.vendor_name %>
                                </td>
                                <%  } %>
                                <td id="address" ><%=RFQ.vendor_address %></td>
                                
                                    <% if(!isSundry) {  %>
                                <td>
                                    <select name="rfq.vendor_contact_person" class="span6" id="contact" data-title="Contact person" data-validation="required"></select> 
                                    <input  name="rfq.vendor_contact_person_email" type="hidden" data-title="Supplier address" data-validation="conditional" value="<%=RFQ.vendor_contact_person_email %>"/>
                                    </td>
                                      <%  }else{ %>
                                <td id="contact_person"><%=RFQ.vendor_contact_person %></td>
                                    <%  } %>
                                
                                <td id="email" class="wrapCol"><%=RFQ.vendor_contact_person_email %></td>
                                <td>
                                     <% if(isSundry) {  %>
                                    <span class="label green btnSundryEdit" data-toggle="modal" href="#SundryForm" title="Edit"><i class="icon-pencil edit" style="opacity: 0.7;"></i></span >
                                      <%  } %>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                    <input type="hidden" name="rfq.vendor_name" value="<%=RFQ.vendor_name %>"/>
                </div>
                <div class="control-group">
                    <label class="control-label">
                        Product group(s)
                    </label>
                    <div class="controls">
                        <div class="span8">
                            <table id="tblCategories" class="table table-bordered table-hover" style="border: 1px solid #ddd">
                                <thead>
                                    <tr>
                                        <th style="width:50%">Group</th>
                                    </tr>
                                </thead>
                                <tbody>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
                   <p class="filled info">Notification template</p>
                <div class="control-group required" id="">
                    <label class="control-label">
                        Legal entity
                    </label>
                    <div class="controls">
                        <select name="rfq.legal_entity" class="span4" data-validation="required" data-title="Legal entity">
                        </select>
                    </div>
                </div>

                <div class="control-group required" id="">
                    <label class="control-label">
                        Procurement office address
                    </label>
                    <div class="controls">
                        <select name="rfq.procurement_office_address" class="span6" data-validation="required" data-title="Procurement office address">
                        </select>
                    </div>
                </div>

                <div class="control-group required">
                    <label class="control-label">
                        Determine the RFQ method
                    </label>
                    <div class="controls">
                        <select name="rfq.method" class="span4" data-validation="required" data-title="RFQ method">
                            <option></option>
                            <option value="1">Send RFQ through e-mail</option>
                            <option value="2">Print RFQ</option>
                        </select>
                    </div>
                </div>
                <div class="control-group required" id="rfq_method_email">
                    <label class="control-label">
                        RFQ template
                    </label>
                    <div class="controls">
                        <select name="rfq.template" class="span4" data-validation="required"  data-title="RFQ template">
                            <option></option>
                            <option value="1">Template without procurement team name</option>
                            <option value="2">Template with procurement team name</option>
                            <option value="5">CIFOR-ICRAF Template</option>
                        </select>
                    </div>
                </div>
                <div class="control-group last">
                    <div class="controls">
                        <button id="btnClose" class="btn" type="button">Close page</button>&nbsp;&nbsp;&nbsp;
                        <%  if (RFQ.status_id == "5")
                            { %>
                            <button id="btnSave" class="btn btn-success" type="button" data-action="saved">Save</button>
                        <%  } %>
                         <%  if (max_status != "50")
                            { %>
                        <button id="btnSubmit" class="btn btn-success" type="button" data-action="<%=RFQ.status_id=="5"?"submitted":"updated" %>"><%=RFQ.status_id=="5"?"Proceed":"Update" %></button>
                        <%  if (max_status == "25" && String.IsNullOrEmpty(copy_id))
                            { %>
                        <button id="btnCancel" class="btn btn-danger" type="button" data-action="cancelled">Cancel this RFQ</button>
                        <%  } %>
                         <%  } %>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Bootstrap modal -->
    <div id="SearchForm" class="modal hide fade modal-dialog" tabindex="-1" role="dialog" aria-labelledby="header1" aria-hidden="true"
        data-backdrop="static" data-keyboard="false">
	    <div class="modal-header">
		    <button type="button" class="close" data-dismiss="modal" aria-hidden="true"></button>
			    <h3 id="header1">Add product</h3>
	    </div>
	    <div class="modal-body">
            <div class="floatingBox" id="searchform-error-box" style="display: none">
                <div class="alert alert-error" id="searchform-error-message">
                </div>
            </div>
            <div class="control-group">
                <button type="button" class="btn" id="btnRefresh">Refresh</button>
            </div>
            <div id="SearchResults">
            
            </div>
        </div>
	    <div class="modal-footer">
            <button type="button" class="btn btn-success" aria-hidden="true" id="btnSelectItem">Select product(s)</button>
            <button type="button" class="btn" data-dismiss="modal" aria-hidden="true">Close and cancel</button>
	    </div>
    </div>
    <!-- end of bootstrap modal -->

    
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
        var RFQ = <%=listHeader%>;
        var workflow = new Object();

        var copy_id = "<%=copy_id%>";

        var document_date = "<%=RFQ.document_date%>";
        var due_date = "<%=RFQ.due_date%>";
        var send_date = "<%=RFQ.send_date%>";
        var cifor_office_id = "<%=RFQ.cifor_office_id%>";
        var userOffice = "<%=cifor_office%>";

        var vendor = "<%=RFQ.vendor%>";
        var vendor_cp = "<%=RFQ.vendor_contact_person%>";
        var method = "<%=RFQ.method%>";
        var template = "<%=RFQ.template%>";
        var legal_entity = "<%=RFQ.legal_entity%>";
        var procurement_office_address = "<%=RFQ.procurement_office_address_id%>";

        var listItems = <%=listItems%>;
        var listProductCode = [];
        var listCategories = <%=listCategories%>;
        var ItemCategories = [];
        var listContact = [];
        var listSundry = <%= listSundry %>;
        var listLegalEntity = <%= listLegalEntity %>
        var listProcurementOfficeAddress = <%= listProcurementOfficeAddress %>

        var vendor_categories = "<%=vendor_categories%>";
        var tblCategories = null;

        var usedPRItems = [];
        var deletedId = [];

        var t_cat = null;
        var t_item = null;

        var btnAction = "";
        var filenameupload = "";
        var btnFileUpload = null;

        $("#document_date").datepicker({
            format: "dd M yyyy"
            , autoclose: true
        }).on("changeDate", function () {
            $("[name='rfq.document_date']").val($("#document_date").data("date"));
            $("#document_date").datepicker("hide");
            startDate = new Date($("#document_date").data("date"));
            $('#due_date').datepicker('setStartDate', (startDate.getDate().toString().length < 2 ? '0' + startDate.getDate() : startDate.getDate()) + ' ' + ((startDate.getMonth() + 1).toString().length < 2 ? '0' + (startDate.getMonth() + 1) : (startDate.getMonth() + 1)) + ' ' + startDate.getFullYear());
            $.ajax({
                url: "<%=Page.ResolveUrl("~/Service.aspx/GetMinimumDate")%>",
                data: '{date:"' + $("#document_date").data("date") + '", additional: 4}',
                dataType: 'json',
                type: 'post',
                contentType: "application/json; charset=utf-8",
                success: function (response) {
                    $("#due_date").datepicker("setDate", new Date(response.d)).trigger("changeDate");
                }
            });
        });

        $("#due_date").datepicker({
            format: "dd M yyyy"
            , autoclose: true
        }).on("changeDate", function () {
            $("[name='rfq.due_date']").val($("#due_date").data("date"));
            $("#due_date").datepicker("hide");
        });

        $("#send_date").datepicker({
            format: "dd M yyyy"
            , autoclose: true
        }).on("changeDate", function () {
            $("[name='rfq.send_date']").val($("#send_date").data("date"));
            $("#send_date").datepicker("hide");
        });

        $(document).ready(function () {
            $("#document_date").datepicker("setDate", new Date(document_date));
            $("[name='rfq.document_date']").val($("#document_date").data("date"));
            startDate = new Date($("#document_date").data("date"));
            $('#due_date').datepicker('setStartDate', (startDate.getDate().toString().length < 2 ? '0' + startDate.getDate() : startDate.getDate()) + ' ' + ((startDate.getMonth() + 1).toString().length < 2 ? '0' + (startDate.getMonth() + 1) : (startDate.getMonth() + 1)) + ' ' + startDate.getFullYear());
            $("#due_date").datepicker("setDate", new Date(due_date)).trigger("changeDate");
            if (send_date != "") {
                $("#send_date").datepicker("setDate", new Date(send_date)).trigger("changeDate");
            } else {
                $("#send_date").datepicker("setDate", new Date()).trigger("changeDate");
            }

            populateItems();
            populateCategories();
            populateVendorContact();

            var cboTemplate = $("[name='rfq.template']");
            Select2Obj(cboTemplate, "RFQ template");
            $(cboTemplate).val(template).trigger("change");

            var cboMethod = $("[name='rfq.method']");
            Select2Obj(cboMethod, "RFQ method");
            $(cboMethod).on("select2:select", function () {
            });

            $(cboMethod).val(method).trigger("change");
            if (copy_id != "") {
              $("[name='rfq.vendor']").select2({
                    placeholder: "Vendor",
                    minimumInputLength: 2,
                    allowClear: true,
                    ajax: {
                        url: "<%=Page.ResolveUrl("~/Service.aspx/GetVendorByCategory")%>",
                        type: "POST",
                        dataType: "json",
                        delay: 500,
                        contentType: "application/json; charset=utf-8",
                        data: function (params) {
                            var obj = new Object();
                            obj.search = params.term;
                            obj.subcategory = ItemCategories.join(';');
                            return JSON.stringify(obj);


                        },
                        processResults: function (data, params) {
                            return {
                                results: data.d
                            };
                        }
                    }
                });

                $("[name='rfq.vendor']").on("select2:select", function () {
                    var dVendor = $(this).select2("data");
                    if (dVendor) {
                        dVendorName = dVendor[0].text.split(" (BP-");
                        if (dVendorName.length > 0) {
                            $("[name='rfq.vendor_name']").val(dVendorName[0]);
                        }
                        vendor_cp = "";
                    }

                    //GetVendorCategories().then(GetVendorAddress).then(populateVendorContact);

                   GetVendorAddress().then(populateVendorContact);
                    $("#email").html("");                    
                });
            }

            lookupLegalEntity();
            lookupProcurementOfficeAddress();
        });

        function changeMethod() {
            $("[name='rfq.template']").data("validation", "");
            if ($("[name='rfq.method']").val() == "1") {
                $("[name='rfq.template']").data("validation", "required");
                $("#rfq_method_email").show();
            } else {
                $("#rfq_method_email").hide();
            }
        }

        function populateItems() {
            $.each(listItems, function (i, d) {
                d.uid = guid();
                addItem(d);
            });            

            populateUsedItems();
        }

        function addItem(d) {
            if (typeof d.uid === "undefined" || d.uid == "" || d.uid == null) {
                d.uid = guid();
            }

            if (copy_id != "0" && copy_id != "") {
                d.id = "";
            }

            var brand_name = "", desc = "";
            var html = "<tr id='item_" + d.uid + "'>";
            html += '<td><a href="<%=Page.ResolveUrl("~/purchaserequisition/detail.aspx?id=' + d.pr_id + '")%>" target="_blank">' + d.pr_no + '</a></td>';
                html += "<td>" + d.item_code + "</td>";
                html += "<td>" + d.description;
                if (d.brand_name != "" && d.brand_name != null) {
                    brand_name = NormalizeString(d.brand_name);
                } else {
                    brand_name = "";
                }

            desc = NormalizeString(d.description);
            var detail = d.pr_no + ": " + desc;

            var max_qty = "0";
            if (typeof d.procurement_balance !== "undefined") {
                max_qty = d.procurement_balance;
            } else {
                max_qty = d.request_quantity;
            }
            html += "</td>";
            html += '<td>' +
                '<input type="hidden" name="rfqd.sub_category" value="' + d.subcategory + '"/>' +
                '<input type="hidden" name="rfqd.pr_id" value="' + d.pr_id + '"/>' +
                '<input type="hidden" name="rfqd.pr_no" value="' + d.pr_no + '"/>' +
                '<input type="hidden" name="rfqd.pr_detail_id" value="' + d.pr_detail_id + '" />' +
                '<input type="hidden" name="rfqd.item_id" value="' + d.item_id + '"/>' +
                '<input type="hidden" name="rfqd.item_code" value="' + d.item_code + '"/>' +
                '<input type="hidden" name="rfqd.max_qty" value="' + max_qty + '"/>' +
                '<input type="hidden" name="rfqd.uom" value="' + d.uom_id + '"/>' +
                '<input type="hidden" name="rfqd.brand_name" value="' + brand_name + '"/>' +
                '<input type="hidden" name="rfqd.description" value="' + desc + '"/>' +
                '<input type="hidden" name="rfqd.legal_entity" value="' + d.legal_entity + '"/>' +
                '<div class="input-prepend">' +
                '<input type="text" id="qty_' + d.uid + '" name="rfqd.request_quantity" data-title="Requested quantity" data-description="' + detail + '" data-validation="required number" data-decimal-places="2" class="number span8" placeholder="Requested quantity" maxlength="18" value="' + accounting.formatNumber(delCommas(d.request_quantity), 2) + '" data-maximum-attr="quantity" data-maximum="' + delCommas(max_qty) + '">' +
                '<span class="add-on">' + d.uom + '</span></div></td>';
            html += '<td><input type="hidden" name="rfqd.id" value="' + d.id + '"/><span class="label red btnDelete" title="Delete"><i class="icon-trash delete" style="opacity: 1;"></i></span></td></tr>';

            $("#tblItems tbody").append(html);

            PopulateProductCode()
        }

        function populateCategories() {
            $("#tblCategories tbody").html("");
            $.each(listCategories, function (i, d) {
                $("#tblCategories tbody").append("<tr><td>" + d.category_name + "</td></tr>");
            });
        }

        function populateVendorContact() {
            var currVendor = vendor;
            if (copy_id != "") {
                currVendor = $("[name='rfq.vendor']").val();
            }
            return $.ajax({
                url: "<%=Page.ResolveUrl("~/Service.aspx/GetVendorContactPerson")%>",
                data: "{'vendors':'" + currVendor + "'}",
                dataType: 'json',
                type: 'post',
                contentType: "application/json; charset=utf-8",
                success: function (response) {
                    listContact = JSON.parse(response.d);
                    var cboContact = $("#contact");
                    $(cboContact).empty();
                    generateCombo(cboContact, listContact, "id", "name", true);
                    Select2Obj(cboContact, "Contact person");

                    if (vendor_cp == "" && listContact.length == 1) {
                        vendor_cp = listContact[0].id;
                        $("#email").html(listContact[0].email);
                        $("#address").html(listContact[0].address);
                    }

                    $("#contact").val(vendor_cp).trigger("change");


                    $(cboContact).on('select2:select', function (e) {
                        var contact_id = $(this).val();
                        var email_address = "";
                        var address = ""
                        var detailContact = $.grep(listContact, function (n, i) {
                            return n["id"] == contact_id;
                        });
                        if (detailContact.length > 0) {
                            email_address = detailContact[0].email;
                            address = detailContact[0].address;
                        }
                        vendor_cp = $(this).val();
                        $("#email").html(email_address);
                        $("#address").html(address);
                    });

                }
            });
        }

        $(document).on("click", "#btnRefresh", function() {
            loadSearch();
        });

        $('#SearchForm').on('shown.bs.modal', function () {
            $("#btnRefresh").trigger("click");
        });

        function loadSearch() {
            $("#SearchResults").html("processing..");
            $.ajax({
                url: "<%=Page.ResolveUrl("~/Service.aspx/GetRFQItems")%>",
                data: "{'subcategories':'" + vendor_categories + "', 'cifor_office_id':'" + userOffice + "', 'pr_detail_id':'0'}",
                dataType: 'json',
                type: 'post',
                contentType: "application/json; charset=utf-8",
                success: function (response) {

                    var html = "";
                    var totalRecords = 0;

                    listSearch = JSON.parse(response.d);
                 //   t_cat = listSearch.Table;
                    t_cat = [{ category_id: "general", category_name: "" }];
                    t_item = listSearch.Table1;

                    $.each(t_item, function (i, c) {
                        c.category = "general";
                    });
                    
                    $.each(usedPRItems, function (i, detail_id) {
                        var idx = t_item.findIndex(x => x.pr_detail_id == detail_id);
                        if (idx != -1) {
                            t_item.splice(idx, 1);
                        }
                    });            

                    //groub by category
                    //$.each(t_cat, function (i, cat) {
                    //    var item = $.grep(t_item, function (n, i) {
                    //        if (cat.category_id != null)
                    //            return n["category"] == cat.category_id;
                    //    });
                    //    totalRecords += item.length;
                    //    if (item.length > 0) {
                    //        html += '<div class="control-group">' +
                    //            '<div class="row-fluid">' +
                    //            '<div class="span12">' +
                    //            '<table class="table table-bordered" style="border: 1px solid #ddd">' +
                    //            '<thead><tr>' +
                    //            '<th style="width:20%" class="green">Product group</th>' +
                    //            '<th style="width:80%">' + cat.category_name + '</th>' +
                    //            '</tr></thead>' +
                    //            '</table>' +
                    //            '</div>' +
                    //            '</div>';

                    //        html += '<div class="row-fluid">' +
                    //            '<table id="item_' + cat.category_id + '" class="table table-bordered table-striped" style="border: 1px solid #ddd">' +
                    //            '<thead><tr>' +
                    //            '<th style="width:3%"><input type="checkbox" id="checkItemAll_' + cat.category_id + '" /></th>' +
                    //            '<th style="width:10%">PR code</th>' +
                    //            '<th style="width:15%">Requester</th>' +
                    //            '<th style="width:10%">Required date</th>' +
                    //            '<th style="width:12%">Item code</th>' +
                    //            '<th style="width:35%">Description</th>' +
                    //            '<th style="width:15%">Quantity</th>' +
                    //            '</tr></thead>' +
                    //            '</table>' +
                    //            '</div>';

                    //        html += '</div>';
                    //    }
                    //});

                    $.each(t_cat, function (i, cat) {
                        var item = $.grep(t_item, function (n, i) {
                            if (cat.category_id != null)
                                return n["category"] == cat.category_id;
                        });
                        totalRecords += item.length;
                        cat.category_id = "general";
                        if (item.length > 0) {
                            html += '<div class="control-group">';
                             

                            html += '<div class="row-fluid">' +
                                '<table id="item_' + cat.category_id + '" class="table table-bordered table-striped" style="border: 1px solid #ddd">' +
                                '<thead><tr>' +
                                '<th style="width:3%"><input type="checkbox" id="checkItemAll_' + cat.category_id + '" /></th>' +
                                '<th style="width:10%">PR code</th>' +
                                '<th style="width:15%">Requester</th>' +
                                '<th style="width:10%">Required date</th>' +
                                '<th style="width:12%">Item code</th>' +
                                '<th style="width:35%">Description</th>' +
                                '<th style="width:15%">Quantity</th>' +
                                '</tr></thead>' +
                                '</table>' +
                                '</div>';

                            html += '</div>';
                        }
                    });

                    if (totalRecords == 0) {
                        html = "No data available.";
                    }
                    $("#SearchResults").html(html);

                    $("table[id^='item_'").each(function () {
                        var sid = $(this).attr("id").replace("item_", "");
                        var item = $.grep(t_item, function (n, i) {
                            return n["category"] == sid;
                        });
                        GenerateItemTable($(this), item);            
                    });

                    $("[id^='checkItemAll_']").bind("click", function () {
                        var sid = $(this).attr("id").replace("checkItemAll_", "");
                        $(".item_check_" + sid).prop("checked", $(this).is(":checked"));
                    });

                    $("[id^='checkVendorAll_']").bind("click", function () {
                        var sid = $(this).attr("id").replace("checkVendorAll_", "");
                        $(".vendor_check_" + sid).prop("checked", $(this).is(":checked"));
                    });

                    $("input[type='checkbox'].item").bind("click", function () {
                        var iclass = $(this).prop("class");
                        iclass = iclass.replace(" item", "").replace("item_check_","");
                        if (!$(this).prop("checked")) {
                            $("#checkItemAll_" + iclass).prop("checked", false);
                        }
                    });
                }
            });
        }

        function GenerateItemTable(obj, data) {

            $(obj).DataTable({
                "bFilter": false, "bDestroy": true, "bRetrieve": true, "paging": false, "bSort": false,"bLengthChange" : false, "bInfo":false, 
                "aaData": data,
                "aoColumns": [
                    {
                        "mDataProp": "desc"
                        , "mRender": function (d, type, row) {
                            return '<input type="checkbox" class="item_check_' + row.subcategory + ' item" data-subcategory="' + row.subcategory + '" value="' + row.pr_detail_id + '"/>';
                        }
                    },
                    {
                        "mDataProp": "pr_no"
                        , "mRender": function (d, type, row) {
                            return '<a href="<%=Page.ResolveUrl("~/purchaserequisition/detail.aspx?id=' + row.pr_id + '")%>" target="blank">' + row.pr_no + '</a>';
                        }
                    },
                    { "mDataProp": "requester" },
                    { "mDataProp": "required_date" },
                    { "mDataProp": "item_code" },
                    {
                        "mDataProp": "description"
                        , "mRender": function (d, type, row) {
                            var html = "";
                            html += row.description;
                            return html;
                        }
                    },
                    {
                        "mDataProp": "request_quantity"
                        , "mRender": function (d, type, row) {
                            return '<div class="input-prepend">' +
                                '<input type="text" name="request_quantity" data-title="Requested quantity" data-validation="required number" data-decimal-places="2" class="number span8" placeholder="Requested quantity" maxlength="18" value="' + accounting.formatNumber(delCommas(row.request_quantity), 2) + '">' +
                                '<input type="hidden" name="cifor_office_id" value="' + row.cifor_office_id + '"/>' +
                                '<span class="add-on">'+row.uom+'</span></div>'
                        }
                    }
                ]
            });
        }

        $(document).on("click", "#btnSelectItem", function () {
            var errorMsg = "";
            var newItems = [];
            $(".item:checkbox:checked").each(function () {
                var pr_detail_id = $(this).val();
                var item = $.grep(t_item, function (n, i) {
                    return n["pr_detail_id"] == pr_detail_id;
                });
                if(item.length > 0) {
                    item = item[0];

                    var d = new Object();
                    d.item_code = item.item_code;
                    d.brand_name = item.brand_name;
                    d.description = item.description;
                    d.procurement_balance = delCommas(item.request_quantity);
                    d.pr_no = item.pr_no;
                    d.pr_detail_id = pr_detail_id;
                    d.request_quantity = delCommas($(this).closest("tr").find("[name='request_quantity']").val());
                    d.uom_id = item.uom_id;
                    d.uom = item.uom;
                    d.pr_id = item.pr_id;
                    d.item_id = item.item_id;
                    d.subcategory = item.subcategory;
                    d.legal_entity = item.legal_entity;
                    d.id = "";

                    var itemdesc = "";
                    if (d.brand_name != "" && d.brand_name != null) {
                        itemdesc += d.brand_name + ", ";
                    }
                    itemdesc += d.description;

                    if (d.request_quantity <= 0) {
                        errorMsg += "<br/>- Quantity is required for " + d.pr_no + ": " + itemdesc;
                    }
                    if (d.request_quantity > d.procurement_balance) {
                        errorMsg += "<br/>- Max. quantity for " + d.pr_no + ": " + itemdesc + " is " + accounting.formatNumber(delCommas(d.procurement_balance), 2);
                    }

                    newItems.push(d);
                }  
            });

            if (errorMsg != "") {
                errorMsg = "Please correct the following error(s):" + errorMsg;

                $("#searchform-error-message").html("<b>" + errorMsg + "<b>");
                $("#searchform-error-box").show();
                $('.modal-body').animate({ scrollTop: 0 }, 500);
                return false;
            }

            $.each(newItems, function (i, d) {
                addItem(d);
            });

            populateUsedItems();
            $("#SearchForm").modal("hide");

        });

        function populateUsedItems() {
            usedPRItems = null;
            usedPRItems = [];
            usedLegalEntity = null;
            usedLegalEntity = []

            $("#tblItems tbody tr").each(function (i) {
                usedPRItems.push($(this).find("[name='rfqd.pr_detail_id']").val());
                usedLegalEntity.push($(this).find("[name='rfqd.legal_entity']").val())
            });

            usedPRItems = unique(usedPRItems);
            usedLegalEntity = unique(usedLegalEntity);
            checkLegalEntity(usedLegalEntity);
            getProductCategorylist();
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

            PopulateProductCode();
            populateUsedItems();
        });

        $(document).on("click", "#btnCancel", function () {
            $("#CancelForm").modal("show");
        });

        

        var uploadValidationResult = {};
        $(document).on("click", "#btnSave,#btnSubmit,#btnSaveCancellation", function () {
		    var thisHandler = $(this);
		    $("[name=cancellation_file]").uploadValidation(function(result) {
			    uploadValidationResult = result;
			    onBtnClickSave.call(thisHandler);
		    });
        });

        $(document).on("click", ".btnFileUploadCancel", function () {
            $("#action").val("fileupload");
            btnFileUpload = this;

            $("#file_name").val($(this).closest("div").find("input:file").val().split('\\').pop());
            filenameupload = $("#file_name").val();

            if (!$("#file_name").val()) {
                alert("Please choose file first");
                return false;
            } else {
                let errorMsg = FileValidation();
                if (FileValidation() !== '') {
                    $("#cform-error-message").html("<b>" + "- Supporting document(s):" + "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" + errorMsg + "<b>");
                    $("#cform-error-box").show();
                    $('.modal-body').animate({ scrollTop: 0 }, 500);

                    return false;
                }

                $("input[name='doc_id']").val($("#rfq.id").val());
                UploadFileAPI("");
                $(this).closest("div").find("input[name$='cancellation.uploaded']").val("1");
                $(this).closest("div").find("input[name$='cancellation_file']").css({ 'background-color': '' });
            }
        });

       

        var onBtnClickSave = function () {     
            btnAction = $(this).data("action").toLowerCase();
            workflow.action = btnAction;
            workflow.comment = "";

            if (btnAction == "cancelled") {
                var errorMsg = "";
                if ($.trim($("#cancellation_text").val()) == "" && $.trim($("#cancellation_file").val()) == "") {
                    errorMsg += "<br/> - Reason for cancellation is required.";
                }
                errorMsg += uploadValidationResult.not_found_message||'';
                errorMsg += FileValidation();

                if (errorMsg != "") {
                    errorMsg = "Please correct the following error(s):" + errorMsg;

                    $("#cform-error-message").html("<b>" + errorMsg + "<b>");
                    $("#cform-error-box").show();
                    $('.modal-body').animate({ scrollTop: 0 }, 500);
                    return false;
                } else {
                    workflow.comment = $("#cancellation_text").val();
                    workflow.comment_file = $("#cancellation_file").val();
                }
            }

            var RFQ = GetSubmitData();
            var errorMsg = "";
            errorMsg += uploadValidationResult.not_found_message||'';
            
            if (btnAction != "saved" && btnAction != "cancelled") {           
                errorMsg += GeneralValidation();
                if ($("[name='rfq.method']").val() == "1" & $("#email").text() == "") {
                    errorMsg += "<br/> - Email is required.";
                } 
            }

            if (errorMsg != "") {
               
                showErrorMessage(errorMsg);
                return false;
            }

            var _data = {
                "submission": JSON.stringify(RFQ),
                "deletedIds": JSON.stringify(deletedId),
                "workflows": JSON.stringify(workflow),
                "detailSundry": JSON.stringify(listSundry.length > 0 ? listSundry[0] : "")
            };

            if (btnAction == "cancelled") {
                UploadFile(_data);
            } else {
                /*blockScreenOL();*/
                SubmitDataRFQ(_data);
            }
        };

        function UploadFile(_data) {
            $("#action").val("upload");

            var form = $('form')[0];
            var formData = new FormData(form);

            return $.ajax({
                type: "POST",
                url: "<%=Page.ResolveUrl("~/Service.aspx")%>",
                data: formData,
                processData: false,
                contentType: false,
                success: function (response) {
                    var output = JSON.parse(response);

                    if (output.result == "success" || output.result == "") {
                        SubmitDataRFQ(_data);
                    } else {
                        alert(output.message);
                    }
                }
            });
        }

        function SubmitDataRFQ(_data) {
            return $.ajax({
                url: "<%=Page.ResolveUrl("Input.aspx/Save")%>",
                data: JSON.stringify(_data),
                dataType: 'json',
                type: 'post',
                contentType: "application/json; charset=utf-8",
                success: function (response) {
                    var output = JSON.parse(response.d);
                    if (output.result !== "success") {
                        alert(output.message);
                        //unBlockScreenOL();
                    } else {
                        alert(output.rfq_no + " has been " + btnAction + " successfully.");
                        blockScreen();
                        if (btnAction === "saved") {
                            location.href = "input.aspx?id=" + output.id;
                        } else {
                            if (btnAction == "submitted" || btnAction == "updated") {
                                if ($("[name='rfq.method']").val() == "2") {
                                    link = "PrintPreview.aspx?id=" + output.id + "&template=" + $("[name='rfq.template']").val();
                                    top.window.open(link);
                                }
                            }
                            location.href = "List.aspx";
                        }
                    }
                }
            });
        }

        function GetSubmitData() {
            var RFQ = new Object();
            $("[name^='rfq.']").each(function () {
                var idx = String($(this).attr("name")).replace("rfq.","");
                RFQ[idx] = $(this).val();
            })
            RFQ.details = [];

            $("#tblItems tbody tr").each(function () {
                var row = $(this);
                var details = new Object();
                $(row).find("[name^='rfqd.']").each(function () {
                    var idx = String($(this).attr("name")).replace("rfqd.", "");
                    var val = $(this).val();
                    if (idx == "request_quantity") {
                        val = delCommas($(this).val());
                    }
                    details[idx] = val;
                })
                RFQ.details.push(details);
            });

            return RFQ;
        }

        $(document).on("click", "#btnClose", function () {
            location.href = "List.aspx";
        });

        function PopulateItemCategories() {
            ItemCategories = [];
            $("[name='rfqd.sub_category']").each(function () {
                ItemCategories.push($(this).val());
            });

            ItemCategories = unique(ItemCategories);
        }

        function PopulateProductCode() {
            listProductCode = [];
            $("[name='rfqd.item_code']").each(function () {
                listProductCode.push($(this).val());
            });

            listProductCode = unique(listProductCode);
        }

        function GetVendorCategories() {
            var currVendor = $("[name='rfq.vendor']").val();
            vendor_categories = [];
            if (currVendor != "" && currVendor != null) {
                return $.ajax({
                    url: "<%=Page.ResolveUrl("~/Service.aspx/GetVendorCategories")%>",
                    data: '{vendor_id: "' + currVendor + '"}',
                    dataType: 'json',
                    type: 'post',
                    contentType: "application/json; charset=utf-8",
                    success: function (response) {
                        vendor_categories = response.d;
                        GetVendorCategoryList();
                    }
                });
            }
        }

        function getProductCategorylist() {

            var products = listProductCode.join(";");
                return $.ajax({
                    url: "<%=Page.ResolveUrl("~/Service.aspx/GetProductCategoryList")%>",
                    data: '{products: "' + products + '"}',
                    dataType: 'json',
                    type: 'post',
                    contentType: "application/json; charset=utf-8",
                    success: function (response) {
                        listCategories = JSON.parse(response.d);
                        populateCategories();
                    }
                });
               
         }

        function GetVendorCategoryList() {
            if (vendor_categories != "" && vendor_categories != null) {
                console.log(vendor_categories);
                return $.ajax({
                    url: "<%=Page.ResolveUrl("~Service.aspx/GetVendorCategoryList")%>",
                    data: '{categories: "' + vendor_categories + '"}',
                    dataType: 'json',
                    type: 'post',
                    contentType: "application/json; charset=utf-8",
                    success: function (response) {
                        listCategories = JSON.parse(response.d);
                        populateCategories();
                    }
                });
            }
        }

        function GetVendorAddress() {
            var currVendor = $("[name='rfq.vendor']").val();
            if (currVendor != "" && currVendor != null) {
                return $.ajax({
                    url: "<%=Page.ResolveUrl("~/Service.aspx/GetVendorAddressList")%>",
                    data: '{vendor_id: "' + currVendor + '"}',
                    dataType: 'json',
                    type: 'post',
                    contentType: "application/json; charset=utf-8",
                    success: function (response) {
                        var data = JSON.parse(response.d);
                        $("#address").text(data[0].address);
                    }
                });
            }
        }

        function lookupLegalEntity() {

            var cbo = $("[name='rfq.legal_entity']");
            $(cbo).empty();
            generateCombo(cbo, listLegalEntity, "Id", "Name", true);
            Select2Obj(cbo, "Legal entity");
            $("[name='rfq.legal_entity']").val(legal_entity).trigger("change");
        }

        function lookupProcurementOfficeAddress() {
            var cbo = $("[name='rfq.procurement_office_address']");
            $(cbo).empty();
            generateCombo(cbo, listProcurementOfficeAddress, "AddressId", "address", true);
            Select2Obj(cbo, "Procurement office address");
            $("[name='rfq.procurement_office_address']").val(procurement_office_address).trigger("change");
        }

        function checkLegalEntity(data) {

            if (data.length == 1 && legal_entity == "") {
                legal_entity = data[0];
               
            }
            if (data.length > 1) {
                legal_entity = "";
            }

            $("[name='rfq.legal_entity']").val(legal_entity).trigger("change");
        }


        //Sundry supplier
        $(document).on("click", ".btnSundryEdit", function () {
            var id = $(this).closest("tr").prop("id");
            id = id.replace("vendor_", "");
            var idx = listSundry.findIndex(x => x.sundry_supplier_id == id);
            var d = listSundry[idx];
            EditSundry(d);
        });

        function EditSundry(d) {
            var company_name = RecursiveHtmlDecode(RFQ.vendor_name);
            $("#SundryForm tbody").empty();
            $("#SundryForm-error-message").empty();
            $("#SundryForm-error-box").hide();

            var html = AddDetailSundrySupplierHTML(company_name, d.sundry_supplier_id, d.id,"","");
            //html += '<tr>'
            //    + '<td>Sundry </td>'
            //    + '<td>' + company_name
            //    + '<input type="hidden" name="sundry.id" value="' + d.sundry_supplier_id + '" data-index="' + d.id + '">'
            //    + '</td>'
            //    + '</tr>'
            //    + '<tr>'
            //    + '<td>Name <span style="color: red;">*</span></td>'
            //    + '<td>'
            //    + '<div class="">'
            //    + '<div class="">'
            //    + '<input type="text" name="sundry.name" maxlength="255" placeholder="Name" value="" class="span12"/>'
            //    + '</div>'
            //    + '</div>'
            //    + '</td>'
            //    + '</tr>'
            //    //
            //    + '<tr>'
            //    + '<td>Contact person <span style="color: red;">*</span></td>'
            //    + '<td>'
            //    + '<div class="">'
            //    + '<div class="">'//
            //    + '<input type="text" name="sundry.contact_person" placeholder="Contact person" value="" class="span12"/>'
            //    + '</div>'
            //    + '</div>'
            //    + '</td>'
            //    + '</tr>'
            //    //
            //    //
            //    + '<tr>'
            //    + '<td>Email <span style="color: red;">*</span></td>'
            //    + '<td>'
            //    + '<div class="">'
            //    + '<div class="">'//
            //    + '<input type="email" name="sundry.email" placeholder="Email" data-title="email" value="" class="span12"/>'
            //    + '</div>'
            //    + '</div>'
            //    + '</td>'
            //    + '</tr>'
            //    //
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
            //    + '<tr>'
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
            //    + '<textarea name="sundry.address"  maxlength="160" rows="10" placeholder="address" class="span12"></textarea>'
            //    + '<div class="mt-1" style="font-size: 80%; font-style: italic; display: block;">Maximum description is 2,000 characters</div>'
            //    + '</td>'
            //    + '</tr>'
            //    + '<tr>'
            //    + '<td>Place <span style="color: red;">*</span></td>'
            //    + '<td>'
            //    + '<div class="">'
            //    + '<div class="">'
            //    + '<input type="text" name="sundry.place" maxlength="40" placeholder="Place" value="" class="span12"/>'
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
            //    + '<input type="text" name="sundry.post_code" maxlength="15" placeholder="Post code" value=""class="span12"/>'
            //    + '</div>'
            //    + '</div>'
            //    + '</td>'
            //    + '</tr>'
            //    + '<tr>'
            //    + '<td>VAT RegNo</td>'
            //    + '<td>'
            //    + '<div class="">'
            //    + '<div class="">'
            //    + '<input type="text" name="sundry.vat_reg_no" maxlength="25" placeholder="VAT RegNo"  value=""class="span12"/>'
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
                errorMsg += "<br/> - Email is required.";
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
                var idx = listSundry.findIndex(x => x.sundry_supplier_id == id);
                var d = listSundry[idx];
                d.name = $("[name='sundry.name']").val();
                d.address = $("[name='sundry.address']").val();
                d.contact_person = $("[name='sundry.contact_person']").val();
                d.email = $("[name='sundry.email']").val();
                d.phone_number = $("[name='sundry.phone_number']").val();
                d.bank_account = $("[name='sundry.bank_account']").val();
                d.swift = $("[name='sundry.swift']").val();
                d.sort_code = $("[name='sundry.sort_code']").val();
                d.place = $("[name='sundry.place']").val();
                d.province = $("[name='sundry.province']").val();
                d.post_code = $("[name='sundry.post_code']").val();
                d.vat_reg_no = $("[name='sundry.vat_reg_no']").val();

                $("#address").html(setSundryAddress(d));
                $("#contact_person").html(d.contact_person)
                $("#email").html(d.email)
                $("#SundryForm").modal("hide");
            }
        }

        function populateSundry() {
            var id = $("[name='sundry.id']").val();
            var idx = listSundry.findIndex(x => x.sundry_supplier_id == id);
            var d = listSundry[idx];
            if (idx != -1) {
                $("[name='sundry.name']").val(d.name);
                $("[name='sundry.address']").text(d.address);
                $("[name='sundry.contact_person']").val(d.contact_person);
                $("[name='sundry.email']").val(d.email);
                $("[name='sundry.phone_number']").val(d.phone_number);
                $("[name='sundry.bank_account']").val(d.bank_account);
                $("[name='sundry.swift']").val(d.swift);
                $("[name='sundry.sort_code']").val(d.sort_code);
                $("[name='sundry.place']").val(d.place);
                $("[name='sundry.province']").val(d.province);
                $("[name='sundry.post_code']").val(d.post_code);
                $("[name='sundry.vat_reg_no']").val(d.vat_reg_no);
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
                            if ($(btnFileUpload).data("type") == 'filecancel') {
                                GenerateCancelFileLink(btnFileUpload, filenameupload);
                            } else {
                                /*GenerateFileLink(btnFileUpload, filenameupload);*/
                            }
                        } else {
                            alert('Upload file failed');
                        }
                    } else {
                        alert("Quotation " + $("#q_no").val() + " has been " + btnAction + " successfully.");
                        if (btnAction.toLowerCase() == "saved") {
                            parent.location.href = "Input.aspx?id=" + $("[name='rfq.id']").val();
                        } else {
                            parent.location.href = "List.aspx";
                        }
                    }
                },
                error: function (jqXHR, exception) {
                    unBlockScreenOL();
                }
            });

            $("#file_name").val("");
        }
        // end sundry supplier
    </script>
</asp:Content>
