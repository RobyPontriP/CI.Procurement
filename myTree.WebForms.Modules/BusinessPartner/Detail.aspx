<%@ Page MasterPageFile="~/Procurement.Master" Language="C#" AutoEventWireup="true" CodeBehind="Detail.aspx.cs" Inherits="myTree.WebForms.Modules.BusinessPartner.Detail" %>

<%@ Register Src="uscSupplierAddressDetail.ascx" TagName="supplieraddress" TagPrefix="usc1" %>
<%@ Register Src="uscSupplierAddressDetail.ascx" TagName="paymentaddress" TagPrefix="usc2" %>
<%@ Register Src="uscSupplierAddressDetail.ascx" TagName="orderaddress" TagPrefix="usc3" %>
<%@ Register Src="uscPurchaseOrderBusinessPartner.ascx" TagName="purchaseorder" TagPrefix="usc4" %>

<asp:Content ID="Content1" ContentPlaceHolderID="AppHead" runat="server">
    <title>Supplier</title>
    <style>
        .controls {
            padding-top: 5px;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="AppBody" runat="server">
    <input type="hidden" name="id" value="<%=_id%>"/>
    <input type="hidden" name="sun_code" value="<%=vendor.sun_code%>"/>
  <% if (isMyTreeSupplier){ %>
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
    <div class="floatingBox" id="error-box" style="display: none">
        <div class="alert alert-error" id="error-message">
        </div>
    </div>
    <div class="control-group">
        <div class="span12 tabContainer">
            <!-- ==================== TAB NAVIGATION ==================== -->
            <ul class="nav nav-tabs">
                <li class="active">
                    <a href="#general" target="_top">General</a>
                </li>
                <li class=""><a href="#purchaseorder" target="_top">PO related</a></li>
            </ul>
            <!-- ==================== END OF TAB NAVIGATIION ==================== -->
            <div class="container-fluid">
                <!-- ==================== FIRST TAB CONTENT ==================== -->
                <div class="chartContainers tabContent" id="general" style="display: block;">
                    <div class="row-fluid">
                        <div class="floatingBox">
                             <div class="container-fluid">
                                  <%  if (!String.IsNullOrEmpty(vendor.id))
                                 { %>
                             <div class="control-group">
                                <label class="control-label">
                                    Supplier code
                                </label>
                                <div class="controls">
                                    <b><%=vendor.company_code %></b>
                                </div>
                            </div>
                            <%  } %>
                                 <div class="control-group">
                                     <label class="control-label">
                                         OCS supplier code
                                     </label>
                                     <div class="controls">
                                            <%=vendor.ocs_supplier_code %>
                                     </div>
                                 </div>
                            <div class="control-group">
                                <label class="control-label">
                                    Status
                                </label>
                                <div class="controls">
                                    <%=vendor.sun_status_name %>
                                </div>
                            </div>
                            <div class="control-group">
                                <label class="control-label">
                                    Short name
                                </label>
                                <div class="controls">
                                    <%=vendor.short_desc %>
                                </div>
                            </div>
                            <div class="control-group">
                                <label class="control-label">
                                    Supplier name
                                </label>
                                <div class="controls">
                                    <%=vendor.company_name%>
                                </div>
                            </div>
                            <!-- Address information -->
                           <div class="control-group">
                                <label class="control-label">
                                   Supplier address
                                </label>
                                <div class="controls">
                                    <table id="tblAddress" class="table table-bordered table-hover" data-title="Supplier address" style="border: 1px solid #ddd">
                                        <thead>
                                            <tr>
                                                 <th style="width:10%">Address type</th>
                                                 <th style="width:20%;">Street address</th>
                                                 <th style="width:10%">Country</th>
                                                 <th style="width:10%">Post code</th>
                                                 <th style="width:10%">Town/city</th>
                                                 <th style="width:10%">Country/state/province</th>
                                                 <th style="width:10%">URL</th>
                                                <th style="width:10%">Status</th>
   
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <%  foreach (myTree.WebForms.Procurement.General.DataModel.VendorAddress address in vendor.main_address) { %>
                                            <tr>
                                                <td class="wrapCol"><%= address.address_type %></td>
                                                <td class="wrapCol"><%= address.address_name %></td>
                                                <td class="wrapCol"><%= address.country_name %></td>
                                                <td class="wrapCol"><%= address.postal_code %></td>
                                                <td class="wrapCol"><%= address.city %></td>
                                                <td class="wrapCol"><%= address.state %></td>
                                                <td class="wrapCol"><%= address.url %></td>
                                                <td class="wrapCol"><%= address.vendor_address_active_label %></td>
                                            </tr>
                                            <%  } %>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                            <div class="control-group">
                                <label class="control-label">
                                    Telp. no.
                                </label>
                                <div class="controls">
                                    <%=vendor.telp_no%>
                                </div>
                            </div>
                            <div class="control-group">
                                <label class="control-label">
                                    Fax no.
                                </label>
                                <div class="controls">
                                    <%=vendor.fax_no%>
                                </div>
                            </div>
                            <div class="control-group">
                                <label class="control-label">
                                    Website
                                </label>
                                <div class="controls">
                                    <%=vendor.website%>
                                </div>
                            </div>
                            <div class="control-group">
                                <label class="control-label">
                                    Tax system
                                </label>
                                <div class="controls">
                                    <%=vendor.tax_system_name%>
                                </div>
                            </div>
                            <div class="control-group">
                                <label class="control-label">
                                    Contact person(s)
                                </label>
                                <div class="controls">
                                    <table id="tblContacts" class="table table-bordered table-hover" data-title="Contact person(s)" style="border: 1px solid #ddd">
                                        <thead>
                                            <tr>
                                                  <th style="width:10%;">Name</th>
                                                  <th style="width:10%">Position</th>
                                                  <th style="width:10%;">Mobile phone</th>
                                                  <th style="width:10%;">Home phone</th>
                                                  <th style="width:10%;">Email</th>
                                                  <th style="width:10%;">CC Email</th>
                                                  <th style="width:10%;">Status</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <%  foreach (myTree.WebForms.Procurement.General.DataModel.VendorContactPerson contact in vendor.contacts) { %>
                                            <tr>
                                                <td class="wrapCol"><%=contact.name %></td>
                                                <td class="wrapCol"><%=contact.position %></td>
                                                <td class="wrapCol"><%=contact.mobile_phone %></td>
                                                <td class="wrapCol"><%=contact.home_phone %></td>
                                                <td class="wrapCol"><%=contact.email %></td>
                                                <td class="wrapCol"><%=contact.cc_email %></td>
                                                <td class="wrapCol"><%=contact.vendor_cp_active_label %></td>
                                            </tr>
                                            <%  } %>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                            <div class="control-group">
                                <label class="control-label">
                                    Notes
                                </label>
                                <div class="controls multilines wrapCol"><%=vendor.remarks%></div>
                            </div>
                            <div class="control-group last">
                                <div class="controls">
                                   <button id="btnClose" class="btn" type="button">Close page</button>&nbsp;&nbsp;&nbsp;
                               <% if (isMyTreeSupplier){ %>
                                    <button id="btnEdit" class="btn btn-success" type="button">Edit</button>                           
                                   <%-- <button id="btnDelete" class="btn btn-danger" type="button">Delete</button>--%>
                               <%} %>
                                            <%  if (!string.IsNullOrEmpty(vendor.sun_code))
                                                { %>
                                    &nbsp;&nbsp;&nbsp;
                                   <%-- <button id="btnExportXML" class="btn btn-success" type="button">Export supplier information to XML</button>
                                    <button id="btnExportAddressXML" class="btn btn-success" type="button">Export address information to XML</button>
                                    <asp:Button ID="btnExportExcel" runat="server" Text="Export to excel" class="btn btn-success" onclick="btnExportExcel_Click" Visible="false"/>--%>
                                            <%  } %>
                                    <%--<%   } %>         --%>               
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                </div>
                <!-- ==================== END OF FIRST TAB CONTENT ==================== -->
                <!-- ==================== SECOND TAB CONTENT ==================== -->
                <div class="chartContainers tabContent" id="purchaseorder" style="display: none;">
                    <usc4:purchaseorder ID="purchaseorder1" runat="server" address_type="po" vendor_id=""/>
                </div>
                <!-- ==================== END OF SECOND TAB CONTENT ==================== -->
            </div>
        </div>
    </div>
    <script>
        var company_code = "<%=vendor.company_code %>";

        var mainAddress = <%=listVendorMainAddress%>;
        var paymentAddress = <%=listVendorPaymentAddress%>;
        var orderAddress = <%=listVendorOrderAddress%>;

        var is_payment_address_same = "<%=vendor.is_payment_address_same%>";
        var is_order_address_same = "<%=vendor.is_order_address_same%>";

        var addressess = [];

        $(document).ready(function () {
            addressess.push(mainAddress);
            addressess.push(paymentAddress);
            addressess.push(orderAddress);

            populateAddress(addressess);

            $("input[name='paymentaddress.is_same']").prop("checked", is_payment_address_same == "1" ? true : false).trigger("change");
            $("input[name='orderaddress.is_same']").prop("checked", is_order_address_same == "1" ? true : false).trigger("change");
            normalizeMultilines();

        });

        function populateAddress(address) {
            if (address != null && address.length > 0) {
                $.each(address, function (i, items) {
                    if (!$("[id='" + items.address_type + ".is_same']").is(":checked")) {
                        $.each(items, function (key, val) {
                            $("[id='" + items.address_type + "." + key + "']").html($.trim(val));
                        });
                    }
                });
            }
        }

        $(document).on("change", "[name$='is_same']", function () {
            var x = $(this).attr("name").split(".");
            var addr_type = x[0];
            if ($(this).is(":checked")) {
                $("." + addr_type + "info").hide();
                $("." + addr_type + "check").show();
            } else {
                $("." + addr_type + "info").show();
                $("." + addr_type + "check").hide();
            }
        });

        var _id = "<%=_id%>";
        $(document).on("click", "#btnEdit", function () {
            location.href = "Input.aspx?id=" + _id;
        });

        $(document).on("click", "#btnClose", function () {
            location.href = "List.aspx";
        });

        $(document).on("click","#btnDelete", function () {
            if (confirm("Are you sure?")) {
                Delete(_id);
            }
        });

        function Delete(id) {
            $.ajax({
                url: 'List.aspx/Delete',
                data: '{"id":"' + id + '"}',
                dataType: 'json',
                type: 'post',
                contentType: "application/json; charset=utf-8",
                success: function (response) {
                    var output = JSON.parse(response.d);
                    if (output.result != "success") {
                        alert(output.message);
                    } else {
                        alert("Data has been deleted successfully");
                        blockScreen();
                        location.href = "List.aspx";
                    }
                }
            });
        }

        $(document).on("click", "#btnAuditTrail", function () {
            parent.ShowCustomPopUp("<%= ResolveUrl("~"+based_url+"/AuditTrail.aspx?blankmode=1&module=vendor&id=" + _id) %>");
        });

        $(document).on("click", "#btnExportXML", function () {
            var link1 = "ExportToXML.aspx?id=" + _id + "&type=supplier&code=" + company_code;
            top.window.open(link1);
        });

        $(document).on("click", "#btnExportAddressXML", function () {
            var link2 = "ExportToXML.aspx?id=" + _id + "&type=address&code=" + company_code;
            top.window.open(link2);
        });

    </script>
</asp:Content>