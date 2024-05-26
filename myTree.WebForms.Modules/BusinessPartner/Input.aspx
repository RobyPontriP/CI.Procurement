<%@ Page MasterPageFile="~/Procurement.Master" Language="C#" AutoEventWireup="true" CodeBehind="Input.aspx.cs" Inherits="myTree.WebForms.Modules.BusinessPartner.Input" %>

<%@ Register Src="uscSupplierAddress.ascx" TagName="supplieraddress" TagPrefix="usc1" %>
<%@ Register Src="uscSupplierAddress.ascx" TagName="paymentaddress" TagPrefix="usc2" %>
<%@ Register Src="uscSupplierAddress.ascx" TagName="orderaddress" TagPrefix="usc3" %>

<asp:Content ID="Content1" ContentPlaceHolderID="AppHead" runat="server">
    <title>Supplier</title>
    <style>
        .select2 {
            min-width: 250px !important;
        }

            .select2.custom {
                min-width: 0px !important;
            }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="AppBody" runat="server">
    <div class="floatingBox" id="error-box" style="display: none">
        <div class="alert alert-error" id="error-message">
        </div>
    </div>
    <div class="row-fluid">
        <div class="floatingBox">
            <div class="container-fluid">
                <%  if (!String.IsNullOrEmpty(vendor.id))
                    { %>
                <div class="control-group">
                    <label class="control-label">
                        Supplier code
                    </label>
                    <div class="controls labelDetail">
                        <b><%=vendor.company_code %></b>
                    </div>
                </div>
                <%  } %>

                <input type="hidden" name="action" id="action" value="" />
                <input type="hidden" name="doc_id" value="<%=vendor.id %>" />
                <input type="hidden" name="doc_type" value="VENDOR" />
                <input type="hidden" name="vendor.id" value="<%=vendor.id %>" />
                <input type="hidden" name="vendor.company_code" value="<%=vendor.company_code %>" />

                <div class="control-group">
                    <label class="control-label">
                        OCS supplier code
                    </label>
                    <div class="controls">
                        <input type="text" name="vendor.ocs.supplier_code" data-title="OCS supplier code" class="span3" value="<%=vendor.ocs_supplier_code  %>" placeholder="OCS supplier code" maxlength="15" readonly />
                    </div>
                </div>
                <div class="control-group">
                    <label class="control-label">
                        Status
                    </label>
                    <div class="controls">
                        <select name="vendor.sun_status" data-title="Status" class="span2">
                        </select>
                    </div>
                </div>
                <div class="control-group">
                    <label class="control-label">
                        Short name
                    </label>
                    <div class="controls">
                        <input type="text" name="vendor.short_desc" maxlength="10" data-title="Short name" class="span3" value="<%=vendor.short_desc %>" placeholder="Short name" />
                    </div>
                </div>
                <div class="control-group required">
                    <label class="control-label">
                        Supplier name
                    </label>
                    <div class="controls">
                        <input type="text" name="vendor.company_name" data-title="Supplier name" data-validation="required" class="span4" value="<%=vendor.company_name%>" placeholder="Supplier name" maxlength="255" />
                    </div>
                </div>

                <!-- Address information -->
                <div class="control-group required">
                    <label class="control-label">
                        Supplier address
                    </label>
                    <div class="controls">
                        <table id="tblAddress" class="table table-bordered table-hover required" data-title="Supplier address" style="border: 1px solid #ddd;">
                            <thead>
                                <tr>
                                    <th style="width: 10%">Address type</th>
                                    <th style="width: 20%;">Street address <span style="color: Red;">*</span></th>
                                    <th style="width: 10%">Country <span style="color: Red;">*</span></th>
                                    <th style="width: 10%">Post code <span style="color: Red;">*</span></th>
                                    <th style="width: 10%">Town/city <span style="color: Red;">*</span></th>
                                    <th style="width: 10%">Country/state/province <span style="color: Red;">*</span></th>
                                    <th style="width: 10%">URL</th>
                                    <th style="width: 10%">Status</th>
                                </tr>
                            </thead>
                            <tbody>
                            </tbody>
                        </table>
                    </div>
                </div>

                <div class="control-group required">
                    <label class="control-label">
                        Telp. no.
                    </label>
                    <div class="controls">
                        <input type="text" name="vendor.telp_no" data-title="Telp. no." data-validation="required" class="span3" value="<%=vendor.telp_no%>" placeholder="Telp. no." maxlength="13" />
                    </div>
                </div>
                <div class="control-group">
                    <label class="control-label">
                        Fax no.
                    </label>
                    <div class="controls">
                        <input type="text" name="vendor.fax_no" data-title="Fax. no." class="span3" value="<%=vendor.fax_no%>" placeholder="Fax no." maxlength="13" />
                    </div>
                </div>
                <div class="control-group">
                    <label class="control-label">
                        Website
                    </label>
                    <div class="controls">
                        <input type="text" name="vendor.website" data-title="Website" class="span3" value="<%=vendor.website%>" placeholder="Website" maxlength="50" />
                    </div>
                </div>

                <div class="control-group">
                    <label class="control-label">
                        Tax system
                    </label>
                    <div class="controls">
                        <select name="vendor.tax_system" data-title="Tax system" class="span2">
                        </select>
                    </div>
                </div>

                <div class="control-group required">
                    <label class="control-label">
                        Contact person(s)
                    </label>
                    <div class="controls">
                        <table id="tblContacts" class="table table-bordered table-hover required" data-title="Contact person(s)" style="border: 1px solid #ddd">
                            <thead>
                                <tr>
                                    <th style="width: 10%;">Name</th>
                                    <th style="width: 10%">Position</th>
                                    <th style="width: 10%;">Mobile phone</th>
                                    <th style="width: 10%;">Home phone</th>
                                    <th style="width: 10%;">Email</th>
                                    <th style="width: 10%;">CC Email</th>
                                    <th style="width: 10%">Status</th>

                                </tr>
                            </thead>
                            <tbody>
                            </tbody>
                        </table>
                        <div style="font-size: 80%; font-style: italic; display: block;">If you have multiple CC email addresses, please separate them with semicolons ( ; ).</div>
                    </div>
                </div>

                <div class="control-group">
                    <label class="control-label">
                        Notes
                    </label>
                    <div class="controls">
                        <textarea name="vendor.remarks" data-title="Notes" rows="5" class="span6 textareavertical" placeholder="Notes" maxlength="255"><%=vendor.remarks%></textarea>
                    </div>
                </div>
                <div class="control-group last">
                    <div class="controls">
                        <button id="btnClose" class="btn" type="button">Close page</button>&nbsp;&nbsp;&nbsp;
                        <% if (isMyTreeSupplier|| _id == "")
                            { %>
                        <button id="btnSave" class="btn btn-success" type="button">Save</button>
                        <%} %>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <script>
        var deletedId = [];

        var vendorCategory = <%=listVendorCategory%>;
        var vendorContact = <%=listVendorContact%>;
        var mainAddress = <%=listVendorMainAddress%>;
        var paymentAddress = <%=listVendorPaymentAddress%>;
        var orderAddress = <%=listVendorOrderAddress%>;

        var dataAddressType = <%= listAddressType%>
        var dataAddressCountry = <%=listCountry%>;
        var dataStatus = [{ id: 'N', description: 'Active' }, { id: 'P', description: 'Parked' }, { id: 'C', description: 'Closed' }];
        var dataTaxSystem = [{ id: 'C0', description: 'CIFOR Default Tax' }, { id: 'I0', description: 'ICRAF Default Tax' }, { id: 'G0', description: 'Germany Default Tax' }];
        var dataPayment = <%=listPayment%>;
        var dataBusinessType = "[]";
        var dataQualification = "[]";
        var dataTaxOpt1 = "[]";
        var dataTaxOpt2 = "[]";
        var dataCategory = <%=listCategory%>;
        var dataAddressCode = <%=listOCSAddress%>;
        dataAddressCode = $.grep(dataAddressCode, function (n, i) {
            return n["text"] != "";
        });

        var _status = "<%=vendor.sun_status%>";
        var _payment = "<%=vendor.payment_method%>";
        var _businessType = "<%=vendor.business_type%>";
        var _qualification = "<%=vendor.qualification%>";
        var _taxOpt1 = "<%=vendor.tax_opt1%>";
        var _taxOpt2 = "<%=vendor.tax_opt2%>";
        var _is_vendor_active = "<%=vendor.is_vendor_active%>"
        var _tax_system = "<%=vendor.tax_system%>";

        var is_payment_address_same = "<%=vendor.is_payment_address_same%>";
        var is_order_address_same = "<%=vendor.is_order_address_same%>";

        var addressess = [];

        var isCanEdit = "<%=valid.isCanEdit%>";
        isCanEdit = isCanEdit.toLowerCase() === "true" ? true : false;

        var isCanDelete = "<%=valid.isCanEdit%>";
        isCanDelete = isCanDelete.toLowerCase() === "true" ? true : false;
        var lookupVendorAddress = [];
        $(document).ready(function () {
            var cboStatus = $("select[name='vendor.sun_status']");
            generateCombo(cboStatus, dataStatus, "id", "description", false);
            $(cboStatus).val(_status);
            Select2Obj(cboStatus, "Status");

            var cboTaxSystem = $("select[name='vendor.tax_system']");
            generateCombo(cboTaxSystem, dataTaxSystem, "id", "description", false);
            $(cboTaxSystem).val(_tax_system);
            Select2Obj(cboTaxSystem, "Tax system");

            var cboPayment = $("select[name='vendor.payment_method']");
            generateCombo(cboPayment, dataPayment, "ID", "NAME", true);
            $(cboPayment).val(_payment);
            Select2Obj(cboPayment, "OCS supplier payment method");

            var cboVendorStatus = $("select[name='vendor.is_vendor_active']");
            $(cboVendorStatus).val(_is_vendor_active);
            Select2Obj(cboVendorStatus, "Procurement supplier status");


            $("select[name='vendor.sun_code']").select2({
                placeholder: "Supplier ID",
                minimumInputLength: 2,
                allowClear: true,
                tags: [],
                ajax: {
                    url: '<%= Page.ResolveUrl("~/" + based_url+service_url + "/GetSUNSupplier") %>',
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
                },
                createTag: function (tag) {
                    if (tag.term.length > 15) {
                        tag.term = tag.term.substring(0, 15);
                    }
                    return {
                        id: tag.term,
                        text: tag.term,
                        tag: true
                    };
                }
            }).on('select2:select', function (e) {
                populateVendorDetail(this.value);
            });

            addressess.push(mainAddress);
            addressess.push(paymentAddress);
            addressess.push(orderAddress);

            populateAddress(addressess);

            ShowVendorAddress();
            ShowVendorCategory();
            ShowVendorContact();

            $("input[name='paymentaddress.is_same']").prop("checked", is_payment_address_same == "1" ? true : false).trigger("change");
            $("input[name='orderaddress.is_same']").prop("checked", is_order_address_same == "1" ? true : false).trigger("change");

            if (!isCanEdit) {
                $("[name='vendor.company_name']").prop("disabled", true);
            }
        });

        function populateVendorDetail(supp_code) {
            var searchObj = new Object();
            searchObj.supp_code = supp_code;

            $.ajax({
                url: '<%= Page.ResolveUrl("~/" + based_url+service_url + "/GetSUNSupplierDetail") %>',
                data: JSON.stringify(searchObj),
                type: "POST",
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (response) {
                    data = JSON.parse(response.d);
                    var maindata = data.Table;
                    var address = data.Table1;

                    if (maindata != null && maindata.length > 0) {
                        $("input[name='paymentaddress.is_same']").prop("checked", (maindata[0].is_payment_address_same == 'true'));
                        $("input[name='orderaddress.is_same']").prop("checked", (maindata[0].is_order_address_same == 'true'));
                        $.each(maindata[0], function (key, val) {
                            if (key != "sun_code")
                                $("[name='vendor." + key + "']").val($.trim(val)).trigger("change");
                        })
                    }

                    populateAddress(address);
                }
            });
        }

        function populateAddress(address) {
            if (address != null && address.length > 0) {
                $.each(address, function (i, items) {
                    if (!$("[name='" + items.address_type + ".is_same']").is(":checked")) {
                        $.each(items, function (key, val) {
                            if (key == "sun_address_code") {
                                $("[name='" + items.address_type + "." + key + "']").val($.trim(val)).change();
                            }
                            $("[name='" + items.address_type + "." + key + "']").val($.trim(val)).trigger("change");
                        });
                        $("." + items.address_type + "info").show();
                    } else {
                        $("[name^='" + items.address_type + ".'][name!='" + items.address_type + ".is_same']").prop("disabled", true);
                        $("." + items.address_type + "info").hide();
                    }
                });
            }
        }

        function populateAddressDetail(addr_type, addr_code) {
            var searchObj = new Object();
            searchObj.addr_code = addr_code;
            $.ajax({
                url: '<%= Page.ResolveUrl("~/" + based_url+service_url + "/GetSUNAddressDetail") %>',
                data: JSON.stringify(searchObj),
                type: "POST",
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (response) {
                    data = JSON.parse(response.d);
                    var maindata = data[0]
                    if (maindata != null) {
                        $.each(maindata, function (key, val) {
                            if (key == "sun_address_code") {
                                $("[name='" + addr_type + "." + key + "']").append("<option value='" + $.trim(val) + "'>" + $.trim(val) + "</option>");
                            }
                            $("[name='" + addr_type + "." + key + "']").val($.trim(val)).trigger("change");
                        });
                    }
                }
            });
        }

        $(document).on("change", "[name$='is_same']", function () {
            var x = $(this).attr("name").split(".");
            var addr_type = x[0];
            if ($(this).is(":checked")) {
                $("[name^='" + addr_type + ".sun_address_code'] option").remove();
                $("[name^='" + addr_type + ".'][name!='" + addr_type + ".is_same'][name!='" + addr_type + ".id']").val("").trigger("change");
                $("[name^='" + addr_type + ".'][name!='" + addr_type + ".is_same'][name!='" + addr_type + ".id']").prop("disabled", true);
                $("." + addr_type + "info").hide();
            } else {
                $("[name^='" + addr_type + ".'][name!='" + addr_type + ".is_same'][name!='" + addr_type + ".id']").prop("disabled", false);
                $("." + addr_type + "info").show();
            }
        });

        function ShowVendorCategory() {
            $.each(vendorCategory, function (i, x) {
                AddCategory(x.id, x.category, x.subcategory, x.can_edit);
            })
        }

        function AddCategory(id, category, subcategory, can_edit) {
            if (typeof can_edit === "undefined" || can_edit == "") {
                can_edit = true;
            } else {
                can_edit = String(can_edit).toLowerCase() === "true" ? true : false;
            }

            var disabledInput = "";

            if (!can_edit) {
                disabledInput = "disabled='disabled'";
            }
            var _uid = guid();
            var html = "<tr id='" + _uid + "'>";
            html += '<td><select class="span12" name="vendorcategory.category" ' + disabledInput + ' data-title="Supplier category" data-validation="required"></select></td>';
            html += '<td><select class="span12" name="vendorcategory.subcategory" ' + disabledInput + ' data-title="Supplier sub category" data-validation="required unique"></select></td>';
            var btnDelete = "";
            if (can_edit) {
                btnDelete = '<span class="label red btnDelete"><i class="icon-trash delete" style="opacity: 1;"></i></span>';
            }
            html += '<td><input type="hidden" name="vendorcategory.id" value="' + id + '"/>' + btnDelete + '</td>';
            html += "</tr>";

            $("#tblCategories tbody").append(html);

            var obj = $("#" + _uid + " select[name='vendorcategory.category']");
            generateCombo(obj, dataCategory, "id", "text", true);
            $(obj).val(category);
            Select2Category(obj);

            var objSub = $("#" + _uid + " select[name='vendorcategory.subcategory']");
            CreateSubCategory(objSub, category, subcategory, "<%=Page.ResolveUrl("~/Service.aspx/GetSubCategory")%>");
        }

        function Select2Category(obj) {
            $(obj).select2({
                placeholder: "Category",
            }).on('select2:select', function (e) {
                var cboSub = $(this).closest("tr").find("select[name='vendorcategory.subcategory']");
                CreateSubCategory(cboSub, $(this).val(), "", "<%=Page.ResolveUrl("~/Service.aspx/GetSubCategory")%>");
            });
        }

        $(document).on("click", "#btnAddCategory", function () {
            AddCategory("", "", "", true);
        });


        function ShowVendorContact() {
            if (vendorContact.length > 0) {
                $.each(vendorContact, function (i, x) {
                    AddContact(x.id, x.name, x.position, x.mobile_phone, x.home_phone, x.email, x.cc_email, x.vendor_cp_active_label);
                })
            } else {
                AddContact("", "", "", "", "", "", "", "Active");
            }

        }

        function ShowVendorAddress() {
            if (mainAddress.length > 0) {
                $.each(mainAddress, function (i, x) {
                    AddAddress(x.id, x.address_type, x.address_name, x.country_id, x.postal_code, x.city, x.state, x.url, x.vendor_address_active_label)
                })
            } else {
                AddAddress("", "", "", "", "", "", "", "", "Active");
            }

        }

        function AddAddress(id, address_type, street_address, country, post_code, city, state, url, status) {
            var html = "<tr>";
            html += '<td>General</td>';
            html += '<td><input type="hidden" name="mainaddress.id" value="' + id + '"/>';
            html += '<textarea name="mainaddress.address_name" data-title="Supplier address street address" rows="5" data-validation="required" class="span12 textareavertical" placeholder="Street address" maxlength="160">' + street_address + '</textarea></td > ';
            html += '<td><select class="span8" name="mainaddress.country_id"  data-title="Supplier address country" data-validation="required"><option></option></select></td>';
            html += '<td><input type="text" name="mainaddress.postal_code" data-title="Supplier address post code" data-validation="required" class="span12" value="' + post_code + '" placeholder="Post code" maxlength="15"/></td>';
            html += '<td><input type="text" name="mainaddress.city" data-title="Supplier address town/city" class="span12" data-validation="required" value="' + city + '" placeholder="City" maxlength="40"/></td>';
            html += '<td><input type="text" name="mainaddress.state" data-title="Supplier address country/state/province" class="span12" data-validation="required" value="' + state + '" placeholder="State" maxlength="40"/></td>';
            html += '<td><input type="text" name="mainaddress.url" data-title="Supplier url" class="span12" value="' + url + '" placeholder="Url" maxlength="255"/></td>';
            html += '<td>' + status + '</td>';
            html += "</tr>";

            $("#tblAddress tbody").append(html);

            var cboAddressCountry = $("[name='mainaddress.country_id']");
            generateCombo(cboAddressCountry, dataAddressCountry, "country_id", "country_name", false);
            $(cboAddressCountry).val(country)
            Select2Obj(cboAddressCountry, "Country");
        }


        function AddContact(id, name, position, mobile_phone, home_phone, email, cc_email, status) {
            var html = "<tr>";
            html += '<td><input type="hidden" name="vendorcontactperson.id" value="' + id + '"/>';
            html += '<input type = "text" name = "vendorcontactperson.name" class="span12" value = "' + name + '" placeholder = "Name" maxlength = "255" /></td > ';
            html += '<td><input type="text" name="vendorcontactperson.position"  class="span12" value="' + position + '" placeholder="Position" maxlength="35"/></td>';
            html += '<td><input type="text" name="vendorcontactperson.mobile_phone" class="span12" value="' + mobile_phone + '" placeholder="Mobile phone" maxlength="35"/></td>';
            html += '<td><input type="text" name="vendorcontactperson.home_phone" class="span12" value="' + home_phone + '" placeholder="Home phone" maxlength="35"/></td>';
            html += '<td><input type="text" name="vendorcontactperson.email" class="span12" value="' + email + '" placeholder="Email" maxlength="255"/></td>';
            html += '<td><input type="text" name="vendorcontactperson.cc_email" class="span12" value="' + cc_email + '" placeholder="CC Email" maxlength="255"/></td>';
            html += '<td>' + status + '</td>'
            html += "</tr>";

            $("#tblContacts tbody").append(html);

        }

        $(document).on("click", "#btnAddAddress", function () {
            AddAddress("", "", "", "", "", "", "", "", "Active");
        });


        $(document).on("click", "#btnAddContact", function () {
            getLooupVendorAddres();
            AddContact("", "", "", "", "", "", "", "", "Active");
        });

        function getLooupVendorAddres() {
            var data = [];
            $("#tblAddress tbody tr").each(function () {
                var _addr = new Object();
                _addr["id"] = $(this).find("input[name='mainaddress.id']").val();
                _addr["address_type"] = $(this).find("select[name='mainaddress.address_type']").val();
                _addr["address_name"] = $(this).find("textarea[name='mainaddress.address_name']").val();
                _addr["country_id"] = $(this).find("select[name='mainaddress.country_id']").val();
                _addr["postal_code"] = $(this).find("input[name='mainaddress.postal_code']").val();
                _addr["city"] = $(this).find("input[name='mainaddress.city']").val();
                _addr["state"] = $(this).find("input[name='mainaddress.state']").val();
                _addr["url"] = $(this).find("input[name='mainaddress.url']").val();
                data.push(_addr);
            });

            lookupVendorAddress = data;
        }

        $(document).on("click", "#btnSave", function () {
            var submission = GetSubmission();
            SubmitValidation(submission);
        });

        function SubmitValidation(data) {
            var errorMsg = "";
            errorMsg += GeneralValidation();
            errorMsg += validationContactPerson();
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

        function GetSubmission() {
            var data = new Object();
            data.id = $("[name='vendor.id']").val();
            data.sun_code = $("[name='vendor.sun_code']").val();
            data.lookup_code = $("[name='vendor.lookup_code']").val();
            data.sun_status = $("[name='vendor.sun_status']").val();
            data.short_desc = $("[name='vendor.short_desc']").val();
            data.company_name = $("[name='vendor.company_name']").val();
            data.company_code = $("[name='vendor.company_code']").val();
            data.description = $("[name='vendor.description']").val();

            data.telp_no = $("[name='vendor.telp_no']").val();
            data.fax_no = $("[name='vendor.fax_no']").val();
            data.email = $("[name='vendor.email']").val();
            data.mobile_no = $("[name='vendor.mobile_no']").val();
            data.website = $("[name='vendor.website']").val();
            data.tax_system = $("select[name='vendor.tax_system']").val();
            data.tax_system_name = $("select[name='vendor.tax_system'] option:selected").text();
            data.payment_method = $("[name='vendor.payment_method']").val();
            data.business_type = $("[name='vendor.business_type']").val();
            data.qualification = $("[name='vendor.qualification']").val();
            data.tax_opt1 = $("[name='vendor.tax_opt1']").val();
            data.tax_opt2 = $("[name='vendor.tax_opt2']").val();
            data.remarks = $("[name='vendor.remarks']").val();
            data.is_vendor_active = $("select[name='vendor.is_vendor_active']").val();

            data.is_payment_address_same = $("input[name='paymentaddress.is_same']").prop("checked") ? 1 : 0;
            data.is_order_address_same = $("input[name='orderaddress.is_same']").prop("checked") ? 1 : 0;

            data.main_address = [];
            $("#tblAddress tbody tr").each(function () {
                var _addr = new Object();
                _addr["id"] = $(this).find("input[name='mainaddress.id']").val();
                _addr["address_type"] = $(this).find("select[name='mainaddress.address_type']").val();
                _addr["address_name"] = $(this).find("textarea[name='mainaddress.address_name']").val();
                _addr["country_id"] = $(this).find("select[name='mainaddress.country_id']").val();
                _addr["postal_code"] = $(this).find("input[name='mainaddress.postal_code']").val();
                _addr["city"] = $(this).find("input[name='mainaddress.city']").val();
                _addr["state"] = $(this).find("input[name='mainaddress.state']").val();
                _addr["url"] = $(this).find("input[name='mainaddress.url']").val();
                data.main_address.push(_addr);
            });


            data.contacts = [];
            $("#tblContacts tbody tr").each(function () {
                var _cont = new Object();
                _cont["id"] = $(this).find("input[name='vendorcontactperson.id']").val();
                _cont["vendor_address_id"] = $(this).find("select[name='vendorcontactperson.vendor_address_id']").val();
                _cont["name"] = $(this).find("input[name='vendorcontactperson.name']").val();
                _cont["position"] = $(this).find("input[name='vendorcontactperson.position']").val();
                _cont["mobile_phone"] = $(this).find("input[name='vendorcontactperson.mobile_phone']").val();
                _cont["home_phone"] = $(this).find("input[name='vendorcontactperson.home_phone']").val();
                _cont["email"] = $(this).find("input[name='vendorcontactperson.email']").val();
                _cont["cc_email"] = $(this).find("input[name='vendorcontactperson.cc_email']").val();
                data.contacts.push(_cont);
            });
            return data;
        }

        function GetSubmissionAddress(obj, type) {
            obj.id = $("input[name='" + type + ".id']").val();
            obj.sun_address_code = $("select[name='" + type + ".sun_address_code']").val();
            obj.address1 = $("input[name='" + type + ".address1']").val();
            obj.address2 = $("input[name='" + type + ".address2']").val();
            obj.address3 = $("input[name='" + type + ".address3']").val();
            obj.address4 = $("input[name='" + type + ".address4']").val();
            obj.address5 = $("input[name='" + type + ".address5']").val();
            obj.city = $("input[name='" + type + ".city']").val();
            obj.state = $("input[name='" + type + ".state']").val();
            obj.postal_code = $("input[name='" + type + ".postal_code']").val();
            obj.country_id = $("select[name='" + type + ".country_id']").val();
            obj.address_type = type;

            return obj
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
                        alert("Supplier " + output.code + " has been saved successfully");
                        blockScreen();
                        location.href = "List.aspx";
                    }
                }
            });
        }

        $(document).on("click", ".btnDelete", function () {
            var _sid = $(this).closest("td").find("input[name$='.id']").val();
            var _sname = $(this).closest("td").find("input").prop("name").split('.');

            if (_sid != "") {
                var _del = new Object();
                _del.id = _sid;
                _del.table = _sname[0];
                deletedId.push(_del);
            }

            $(this).closest("tr").remove();
        });

        $(document).on("click", "#btnClose", function () {
            location.href = "List.aspx";
        });

        var cboAddressCode = $("select[name='mainaddress.sun_address_code']");
        generateCombo(cboAddressCode, dataAddressCode, "id", "text", false);
        Select2Obj(cboAddressCode, "OCS address code");


        // validation contact person


        function validationContactPerson() {

            var regexemail = /^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
            var errMsg = "", errEmailCC = 0;
            var v1 = $("input[name = 'vendorcontactperson.name']").val();
            var v2 = $("input[name = 'vendorcontactperson.position']").val();
            var v3 = $("input[name = 'vendorcontactperson.mobile_phone']").val();
            var v4 = $("input[name = 'vendorcontactperson.home_phone']").val();
            var v5 = $("input[name = 'vendorcontactperson.email']").val();
            var v6 = $("input[name = 'vendorcontactperson.cc_email']").val();
            if (v1.length + v2.length == 0) {
                errMsg += "<br/>- Contact person(s) name or position is required.";
            }

            if (v3.length + v4.length == 0) {
                errMsg += "<br/>- Contact person(s) mobile phone or home phone is required.";
            }

            if (v5.length == 0) {
                errMsg += "<br/>- Contact person(s) email is required.";
            } else if (v5.length != 0 && !regexemail.test($.trim(v5))) {
                errMsg += "<br /> - Invalid format on Contact person(s) email";
            }

            if (v6.length != 0) {
                const arr = v6.split(";");
                for (let i = 0; i < arr.length; i++) {
                    var cc = arr[i];
                    if (!regexemail.test($.trim(cc))) {
                        errEmailCC++;
                    }
                }
            }

            if (errEmailCC > 0) {
                errMsg += "<br /> - Invalid format on Contact person(s) cc email";
            }


            return errMsg;
        }
    </script>
</asp:Content>
