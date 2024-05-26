<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="uscDetail.ascx.cs" Inherits="myTree.WebForms.Modules.RFQ.uscDetail" %>
<input type="hidden" id="rfq_no" value="<%=RFQ.rfq_no %>"/>
<div class="row-fluid">
    <div class="floatingBox">
        <div class="container-fluid">
            <%  if (!String.IsNullOrEmpty(RFQ.rfq_no))
                { %>
            <div class="control-group">
                <label class="control-label">
                    RFQ code
                </label>
                <div class="controls">
                    <b><%=RFQ.rfq_no %></b>
                </div>
            </div>
            <%  } %>
            <div class="control-group">
                <label class="control-label">
                    RFQ status
                </label>
                <div class="controls">
                    <b><%=RFQ.status_name %></b>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">
                    Document date
                </label>
                <div class="controls">
                    <%=RFQ.document_date %>
                </div> 
            </div>
            <div class="control-group">
                <label class="control-label">
                    Due date
                </label>
                <div class="controls">
                    <%=RFQ.due_date %>            
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">
                    Remarks
                </label>
                <div class="controls multilines"><%=RFQ.remarks %></div>
            </div>
            <div class="control-group">
                <label class="control-label">
                    Actual date sent to supplier
                </label>
                <div class="controls">
                    <%=RFQ.send_date %>
                </div>
            </div>
            <div class="control-group">
                <table id="tblItems" data-title="Item(s)" class="table table-bordered table-hover" style="border: 1px solid #ddd">
                    <thead>
                        <tr>
                            <th style="width:12%">PR code</th>
                            <th style="width:12%">Procurement office</th>
                            <th style="width:15%">Product code</th>
                            <th style="width:50%">Description</th>
                            <th style="width:13%">Quantity</th>
                            <th style="width:10%">UOM</th>
                        </tr>
                    </thead>
                    <tbody>
                    </tbody>
                </table>
                <p></p>
            </div>
            <div class="control-group">
                <table id="tblVendors" class="table table-bordered table-hover" style="border: 1px solid #ddd">
                    <thead>
                        <tr>
                            <th style="width:20%">Supplier name</th>
                            <th style="width:40%">Address</th>
                            <th style="width:20%">Contact person</th>
                            <th style="width:20%">Email</th>
                            <th></th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                          
                            <td>
                                <%=RFQ.vendor_name %>
                            </td>
                            <td><%=RFQ.vendor_address %><input type="hidden" name="rfq.vendor" value="<%=RFQ.vendor %>"/></td>
                            
                                  <% if(!isSundry) {  %>
                                    <td><%=RFQ.vendor_contact_person_name %></td>
                                      <%  }else{ %>
                                <td id="contact_person"><%=RFQ.vendor_contact_person %></td>
                                    <%  } %>
                            <td id="email" class="wrapCol"><%=RFQ.vendor_contact_person_email %></td>
                            <td>
                                  <% if(isSundry) {  %>
                                    <span class="label btn-primary btnSundryEdit" data-toggle="modal" href="#SundryForm" title="Edit"><i class="icon-info" style="opacity: 0.7;"></i></span >
                                      <%  } %>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
            <div class="control-group">
                <label class="control-label">
                    Product Group(s)
                </label>
                <div class="controls">
                    <div class="span8">
                        <table id="tblCategories" class="table table-bordered table-hover" style="border: 1px solid #ddd">
                            <%--<thead>
                                <tr>
                                    <th style="width:50%">Category</th>
                                </tr>
                            </thead>--%>
                            <tbody>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
               <p class="filled info">Notification template</p>
              <div class="control-group">
                <label class="control-label">
                    Legal entity
                </label>
                <div class="controls">
                   <%= RFQ.legal_entity_name %>
                </div>
            </div>
             <div class="control-group">
                <label class="control-label">
                    Procurement office address
                </label>
                <div class="controls">
                   <%= RFQ.procurement_office_address %>
                </div>
            </div>
            <%  if (isAdmin && RFQ.status_id != "95")
                { %>
            <div class="control-group">
                <label class="control-label">
                    RFQ template
                </label>
                <div class="controls">
                    <select name="rfq.template" class="span4" data-validation="required" data-title="RFQ template">
                        <option></option>
                        <option value="1">Template without procurement team name</option>
                        <option value="2">Template with procurement team name</option>
                        <option value="5">CIFOR-ICRAF Template</option>
                    </select>&nbsp;
                    <button id="btnSendEmail" class="btn btn-success" type="button">Send RFQ through e-mail</button>&nbsp;
                    <button id="btnPrint" class="btn btn-success" type="button">Print RFQ</button>
                </div>
            </div>
            <%  } %>
            <div class="control-group last">
                <div class="controls">
                    <button id="btnClose" class="btn" type="button">Close page</button>&nbsp;&nbsp;&nbsp;
                    <%  if (isAdmin && isEditable)
                        { %>
                    <button id="btnCopy" class="btn btn-success" type="button" data-action="copied">Copy</button>
                    <%  } %>
                    <%  if (max_status != "50")
                        { %>
                    <%  if (max_status == "25" && isEditable)
                        { %>
                    <button id="btnEdit" class="btn btn-success" type="button" data-action="edited">Edit</button>
                    <button id="btnCancel" class="btn btn-danger" type="button" data-action="cancelled">Cancel this RFQ</button>
                    <%  } %>
                    <%  } %>
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
            <h3 id="header1">Detail sundry supplier</h3>
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
            <button type="button" class="btn" data-dismiss="modal" aria-hidden="true">Close and cancel</button>
        </div>
    </div>
    <!-- end of bootstrap modal -->

<script>
    var RFQ = <%=listHeader%>; //data header
    var listItems = <%=listItems%>;
    var listCategories = <%=listCategories%>;
    var max_status = "<%=max_status%>";

    var template = "<%=RFQ.template%>";
    var cifor_office = "<%=RFQ.cifor_office%>";
    var tblCategories = null;
    var listSundry = <%= listSundry %>;

    $(document).ready(function () {
        populateItems();
        populateCategories();

        var cboTemplate = $("[name='rfq.template']");
        Select2Obj(cboTemplate, "RFQ template");
        $(cboTemplate).val(template).trigger("change");
    });

    function populateItems() {
        $.each(listItems, function (i, d) {
            d.uid = guid();
            addItem(d);
        });

        normalizeMultilines();
    }

    function addItem(d) {
        if (typeof d.uid === "undefined" || d.uid == "" || d.uid == null) {
            d.uid = guid();
        }

        var html = "<tr id='item_" + d.uid + "'>";
        html += '<td><a href="<%=Page.ResolveUrl("~/purchaserequisition/detail.aspx?id=' + d.pr_id + '")%>" target="_blank">' + d.pr_no + '</a></td>';
        html += "<td>" + d.office_name + "</td>";
            html += "<td>" + d.item_code + "</td>";
            html += "<td>";
            html += d.item_description;
        html += "</td>";
        html += '<td style="text-align:right;">' + accounting.formatNumber(delCommas(d.request_quantity), 2) + '</td><td>' + d.uom + '</td>';
        html += '</tr>';

        $("#tblItems tbody").append(html);
    }

    function populateCategories() {
        $("#tblCategories tbody").html("");
        $.each(listCategories, function (i, d) {
            $("#tblCategories tbody").append("<tr><td>" + d.category_name + "</td></tr>");
        });
    }

    $(document).on("click", ".btnSundryEdit", function () {
        EditSundry();
    });

    function EditSundry(d) {
            var company_name = RecursiveHtmlDecode(RFQ.vendor_name);
            var id = RFQ.vendor;
            $("#SundryForm tbody").empty();
            $("#SundryForm-error-message").empty();
            $("#SundryForm-error-box").hide();

            var html = "";
            html += '<tr>'
                + '<td>Sundry </td>'
                + '<td>' + company_name
                + '<input type="hidden" name="sundry.id" value="' + id + '" >'
                + '</td>'
                + '</tr>'
                + '<tr>'
                + '<td>Name <span style="color: red;">*</span></td>'
                + '<td>'
                + '<div class="">'
                + '<div class="">'
                + '<input type="text" name="sundry.name" placeholder="Name" value="" class="span12" readonly/>'
                + '</div>'
                + '</div>'
                + '</td>'
                + '</tr>'
                //
                + '<tr>'
                + '<td>Contact person <span style="color: red;">*</span></td>'
                + '<td>'
                + '<div class="">'
                + '<div class="">'//
                + '<input type="text" name="sundry.contact_person" placeholder="Contact person" value="" class="span12"/>'
                + '</div>'
                + '</div>'
                + '</td>'
                + '</tr>'
                //
                //
                + '<tr>'
                + '<td>Email <span style="color: red;">*</span></td>'
                + '<td>'
                + '<div class="">'
                + '<div class="">'//
                + '<input type="text" name="sundry.email" placeholder="Email" value="" class="span12"/>'
                + '</div>'
                + '</div>'
                + '</td>'
                + '</tr>'
                //
                //
                + '<tr>'
                + '<td>Phone number <span style="color: red;">*</span></td>'
                + '<td>'
                + '<div class="">'
                + '<div class="">'//
                + '<input type="text" name="sundry.phone_number" placeholder="Phone number" value="" class="span12"/>'
                + '</div>'
                + '</div>'
                + '</td>'
                + '</tr>'
                //
                + '<tr>'
                + '<td>Bank account</td>'
                + '<td>'
                + '<div class="">'
                + '<div class="">'
                + '<input type="text" name="sundry.bank_account" placeholder="Bank account" value="" class="span12" readonly/>'
                + '</div>'
                + '</div>'
                + '</td>'
                + '</tr>'
                + '<tr>'
                + '<td>Swift</td>'
                + '<td>'
                + '<div class="">'
                + '<div class="">'
                + '<input type="text" name="sundry.swift" placeholder="Swift" value="" class="span12" readonly />'
                + '</div>'
                + '</div>'
                + '</td>'
                + '</tr>'
                + '<tr>'
                + '<td>Sort code</td>'
                + '<td>'
                + '<div class="">'
                + '<div class="">'
                + '<input type="text" name="sundry.sort_code" placeholder="Sort code" value="" class="span12" readonly/>'
                + '</div>'
                + '</div>'
                + '</td>'
                + '</tr>'
                + '<tr>'
                + '<td>Address</td>'
                + '<td>'
                + '<textarea name="sundry.address" class="textareavertical span12" maxlength="2000" rows="10" placeholder="address" readonly></textarea>'
                + '</td>'
                + '</tr>'
                + '<tr>'
                + '<td>Place <span style="color: red;">*</span></td>'
                + '<td>'
                + '<div class="">'
                + '<div class="">'
                + '<input type="text" name="sundry.place" placeholder="Place" value="" class="span12" readonly />'
                + '</div>'
                + '</div>'
                + '</td>'
                + '</tr>'
                + '<tr>'
                + '<td>Province</td>'
                + '<td>'
                + '<div class="">'
                + '<div class="">'
                + '<input type="text" name="sundry.province" placeholder="Province" value="" class="span12" readonly/>'
                + '</div>'
                + '</div>'
                + '</td>'
                + '</tr>'
                + '<tr>'
                + '<td>Post code</td>'
                + '<td>'
                + '<div class="">'
                + '<div class="">'
                + '<input type="text" name="sundry.post_code" placeholder="Post code" value="" class="span12" readonly/>'
                + '</div>'
                + '</div>'
                + '</td>'
                + '</tr>'
                + '<tr>'
                + '<td>VAT RegNo</td>'
                + '<td>'
                + '<div class="">'
                + '<div class="">'
                + '<input type="text" name="sundry.vat_reg_no" placeholder="VAT RegNo"  value="" class="span12" readonly/>'
                + '</div>'
                + '</div>'
                + '</td>'
                + '</tr>';
            $("#SundryForm").modal("show");
            $("#SundryForm tbody").append(html);
            populateSundry();
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
</script>