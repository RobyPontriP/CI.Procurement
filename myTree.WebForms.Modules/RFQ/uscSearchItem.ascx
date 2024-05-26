<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="uscSearchItem.ascx.cs" Inherits="myTree.WebForms.Modules.RFQ.uscSearchItem" %>
<div id="step2Data"></div>
<script>
    var listCategory = [];
    var listItem = [];
    var listVendor = [];
    var listContact = [];
    var dataRFQ0 = null;
    var cifor_office_id = $("#cboOffice").val();
    var listVendorLookup = [];
    var indexVendorLookup = []
    var dataSundry = [];
    var listSundry = [];
    var listVendorAddress = [];
    var listEntity = [];
    var _Items = null;

    function GenerateBaseTable(data) {
        listCategory = [{ category_id: "general", category_name: "" }];
        listItem = JSON.parse(data.listItem);
        $.each(listItem, function (i, c) {
            c.category = "general";
        });

        var html = "";
        html += '<div class="row-fluid">' +
            '<div class="span12">' +

            '<div class="control-group">' +
            '<label class="control-label">' +
            'Supplier' +
            '</label>' +
            '<div class="controls">' +
            '<select  id="srcSupplier" data-title="Supplier search" multiple="multiple" name="supplier_search" class="span8">' +
            '</select>' +
            '</div>' +
            '</div>' +
            '<div class="control-group">' +
            '<div class="controls">' +
            '<button type="button" id="addSupplier" class="btn btn-success">Add</button>' +
            '</div>' +
            '</div>' +

            '</div>' +
            '</div>';

        $.each(listCategory, function (i, c) { 
            var template = '<div class="control-group ">' +
                //'<div class="row-fluid">' +
                //    '<div class="span12">' +
                //        '<table class="table table-bordered" style="border: 1px solid #ddd">' +
                //            '<thead>' +
                //                '<tr>' +
                //                    //'<th style="width:20%" class="green">Category & Sub category</th>' +
                //                    //'<th style="width:80%">{{category}} / {{sub_category}}</th>' +
                //                     '<th style="width:20%" class="green">Product group</th>' +
                //                    '<th style="width:80%">{{category}}</th>' +
                //                '</tr>' +
                //            '</thead>' +
                //        '</table>' +
                //    '</div>' +
                //'</div>' +
                '<div class="row-fluid">' +
                    '<table id="item_{{category_id}}" class="table table-bordered table-striped" style="border: 1px solid #ddd">' +
                        '<thead>' +
                            '<tr>' +
                                //'<th style="width:3%"><input type="checkbox" id="checkItemAll_{{subcategory_id}}" /></th>' +
                                '<th style="width:10%">PR code</th>' +
                                '<th style="width:10%">Procurement office</th>' +
                                '<th style="width:15%">Requester</th>' +
                                '<th style="width:10%">Required date</th>' +
                                '<th style="width:10%">Product code</th>' +
                                '<th style="width:20%">Description</th>' +
                                '<th style="width:10%">PR quantity</th>' +
                                '<th style="width:10%">RFQ quantity</th>' +
                            '</tr>' +
                        '</thead>' +
                    '</table>' +
                '</div>' +

              

                '<div class="row-fluid">' +
                    '<div class="span1">' +
                    '</div>' +
                '<div class="span11">' +
                        '<table id="vendor_{{category_id}}" class="table table-bordered table-striped" style="border: 1px solid #ddd">' +
                            '<thead>' +
                                '<tr>' +
                                    '<th style="width:5%"><input type="checkbox" id="checkVendorAll_{{category_id}}" /></th>' +
                                    '<th style="width:30%">Supplier name</th>' +
                                    '<th style="width:65%">Supplier address</th>' +
                                '</tr>' +
                            '</thead>' +
                        '</table>' +
                    '</div>' +
                '</div>' +
            '</div>';

            template = template.replace(/{{category}}/g, c.category_name);
            template = template.replace(/{{sub_category}}/g, c.subcategory_name);
            template = template.replace(/{{category_id}}/g, c.category_id);

            html += template;

        });

        $("#step2Data").html(html);

        $("table[id^='item_'").each(function () {
            var sid = $(this).attr("id").replace("item_", "");
            var item = $.grep(listItem, function (n, i) {
                return n["category"] == sid;
            });
            GenerateItemTable($(this), item);            
        });

        $("table[id^='vendor_'").each(function () {
            var sid = $(this).attr("id").replace("vendor_", "");
            var vendor = $.grep(listVendor, function (n, i) {
                return n["category"] == sid;
            });
        
            GenerateVendorTable($(this), vendor);
        });

        normalizeMultilines();
        loadLookupsupplier();
        /*SetLookupSuppliers();*/
    }

    $(document).ready(function () {
        loadLookupsupplier();
    });

    function GenerateItemTable(obj, data) {
        $(obj).DataTable({
            "bFilter": false, "bDestroy": true, "bRetrieve": true, "paging": false, "bSort": false,"bLengthChange" : false, "bInfo":false, 
            "aaData": data,
            "aoColumns": [
                /*{
                    "mDataProp": "desc"
                    , "mRender": function (d, type, row) {
                        return '<input type="checkbox" class="item_check_' + row.subcategory + ' item" data-subcategory="' + row.subcategory + '" value="' + row.pr_detail_id + '"/>';
                    }
                },*/
                {
                    "mDataProp": "pr_no"
                    , "mRender": function (d, type, row) {
                        return '<input style="display:none;" type="checkbox" checked class="item_check_' + row.category + ' item" data-category="' + row.category + '" value="' + row.pr_detail_id + '"/>'+
                            '<a href="<%=Page.ResolveUrl("~/purchaserequisition/detail.aspx?id=' + row.pr_id + '")%>" target="_blank">' + row.pr_no + '</a>';
                    }
                },
                { "mDataProp": "cifor_office" },
                { "mDataProp": "requester" },
                { "mDataProp": "required_date" },
                { "mDataProp": "item_code" },
                {
                    "mDataProp": "description"
                    , "mRender": function (d, type, row) {
                        return row.item_description;
                    }
                },
                {
                    "mDataProp": "request_quantity"
                    , "mRender": function (d, type, row) {
                        return accounting.formatNumber(delCommas(row.request_quantity), 2);
                    }
                },
                {
                    "mDataProp": "rfq_quantity"
                    , "mRender": function (d, type, row) {
                        return '<div class="input-prepend">' +
                            '<input type="text" name="request_quantity" data-title="Requested quantity" data-validation="required number" data-decimal-places="2" class="number span8" placeholder="Requested quantity" maxlength="18" value="' + accounting.formatNumber(delCommas(row.request_quantity), 2) + '">' +
                            '<input type="hidden" name="cifor_office_id" value="' + row.cifor_office_id + '"/>' +
                            '<span class="add-on">'+row.uom+'</span></div>'
                    }
                }
            ],
            "columnDefs": [ 
                {
                    targets: [6],
                    className: 'dt-body-right'
                }
            ],
        }); 
    }

    function GenerateVendorTable(obj, data) {
        $(obj).DataTable({
            "bFilter": false, "bDestroy": true, "bRetrieve": true, "paging": false, "bSort": false,"bLengthChange" : false, "bInfo":false, 
            "aaData": data,
            "aoColumns": [
                {
                    "mDataProp": "desc"
                    , "mRender": function (d, type, row) {
                        return '<input type="checkbox" class="vendor_check_' + row.category + ' vendor" data-category="' + row.category + '" value="' + row.id + '"/>';

                    }
                },
                {
                    "mDataProp": "company_name"
                    , "mRender": function (d, type, row) {
                        return '<a href="<%=Page.ResolveUrl("~/businesspartner/detail.aspx?id=' + row.id + '")%>" target="_blank">' + row.company_name + '</a>';
                         
                    }
                },
                { "mDataProp": "address" },
            ]
        });
    }

    function validateRFQ0() {
        var data = [];
        var lessThanPR = 0
        cifor_office_id = [];

        $(".vendor:checkbox:checked").each(function () {
            var sid = $(this).data("category");
            var vendor = $.grep(data, function (n, i) {
                return n["category"] == sid;
            });

            if (vendor.length == 0) {
                var d = new Object();
                d.category = sid;
                d.vendor_id = [$(this).val()];
                d.item_id = [];
                d.qty = [];
                data.push(d);
            } else {
                vendor[0].vendor_id.push($(this).val());
            }
        });

        $(".item:checkbox:checked").each(function () {
            var sid = $(this).data("category");
            var item = $.grep(data, function (n, i) {
                return n["category"] == sid;
            });

            var qty = delCommas($(this).closest("tr").find("[name='request_quantity']").val());
            cifor_office_id.push($(this).closest("tr").find("[name='cifor_office_id']").val());
            var pr_line = new Object();
            pr_line.id = $(this).val();
            pr_line.qty = qty;

            if (item.length == 0) {
                var d = new Object();
                d.category = sid;
                d.vendor_id = [];
                d.item_id = [$(this).val()];
                d.qty = [pr_line];
                data.push(d);
            } else {
                item[0].item_id.push($(this).val());
                item[0].qty.push(pr_line);
            }
        });

        var vendors = ""
            , errorSameVendor = 0;
        var errorMsg = "";
        var dataVendor = [];
        var dataItem = [];
        cifor_office_id = jQuery.unique(cifor_office_id);

        if (data.length === 0) {
            errorMsg += "<br/>- Product(s) is required."
        }
        if (cifor_office_id.length > 1) {
            errorMsg += "<br/>- You cannot combine products from different Procurement office."
        }
        
        $(data).each(function (i, d) {
            var errorItem = 0
                , errorVendor = 0;

            dataVendor = d.vendor_id;
            dataItem.push(d.qty);


            if (i == 0) {
                vendors = d.vendor_id.join(",");
            }
            if (vendors != d.vendor_id.join(",")) {
                errorSameVendor++;
            }

            if (d.item_id.length == 0 && d.vendor_id.length > 0) {
                errorItem++; 
            }
            if (d.item_id.length > 0 && d.vendor_id.length == 0) {
                errorVendor++; 
            }

            if (errorItem > 0) {
                var cat = $.grep(listCategory, function (n, i) {
                    return n["category_id"] == d.category;
                });
              
                errorMsg += "<br/>- Please select product(s) ";
            }
            if (errorVendor > 0) {
                var cat = $.grep(listCategory, function (n, i) {
                    return n["category_id"] == d.category;
                });
               
                errorMsg += "<br/>- Please select supplier(s)";
            }

            //validation supplier address
            if (d.vendor_id.length > 0) {
                for (let v = 0; v < d.vendor_id.length; v++) {
                    var vndr = $.grep(listVendorAddress, function (n, i) {
                        return n["id"] == d.vendor_id[v];
                    });

                    //validate  addres
                    if (vndr[0].address == "" && vndr[0].IsSundry != "1") {
                        errorMsg += "<br/>- Supplier address " + vndr[0].name+" is required.";
                    }
                   
                }
            }

            var no_qty = $.grep(d.qty, function (n, i) {
                return n["qty"] <= 0;
            });
            if (no_qty.length > 0) {
                $.each(no_qty, function (i, x) {
                    var prline = $.grep(listItem, function (n, i) {
                        return n["pr_detail_id"] == x.id;
                    });
                    var itemdesc = "";
                    if (prline[0].brand_name != "" && prline[0].brand_name != null) {
                        itemdesc += prline[0].brand_name + ", ";
                    }
                    itemdesc += prline[0].description;
                    errorMsg += "<br/>- Quantity is required for " + prline[0].pr_no + ": " + itemdesc;
                });
            }

            $.each(d.qty, function (i, x) {
                var prline = $.grep(listItem, function (n, i) {
                    return n["pr_detail_id"] == x.id && n["request_quantity"] < x.qty;
                });
                var itemdesc = "";
                if (prline.length > 0) {
                    if (prline[0].brand_name != "" && prline[0].brand_name != null) {
                        itemdesc += prline[0].brand_name + ", ";
                    }
                    itemdesc += prline[0].description;
                    errorMsg += "<br/>- Max. quantity for " + prline[0].pr_no + ": " + itemdesc + " is " + accounting.formatNumber(delCommas(prline[0].request_quantity), 2);
                }
            });

            $.each(d.qty, function (i, x) {
                var prline = $.grep(listItem, function (n, i) {
                    return n["pr_detail_id"] == x.id && n["request_quantity"] > x.qty;
                });
                var itemdesc = "";
                if (prline.length > 0) {
                    if (prline[0].brand_name != "" && prline[0].brand_name != null) {
                        itemdesc += prline[0].brand_name + ", ";
                    }
                    lessThanPR++;
                }
            });
        });

        if (errorSameVendor > 0) {
            errorMsg += "<br/>- Invalid supplier. You have to select the same supplier(s) for each procduct category."
        }

        var out = { errorMsg: errorMsg, data: data, vendor: dataVendor, item: dataItem, lessThanPR: lessThanPR };
        
        return out;
    }

    function ConfirmVendor(data, contacts) {

        $("#tblRFQ tbody").html("");
        var len = data.length;
        $.each(data, function (i, d) {
            var vendor = $.grep(listVendor, function (n, j) {
                return n["id"] == d;
            });

            var rfq_no = "000" + String(i + 1);
            rfq_no = rfq_no.substr(rfq_no.length - 3);

            if (len == 1) {
                rfq_no = "(New)";
            } else {
                rfq_no = "(New)-" + rfq_no;
            }

            var vendor_address = "";
            if (vendor[0].address != null) {
                vendor_address = vendor[0].address
            }

            var row = "";
            row += '<tr id="vendor_' + d + '" data-index = "' + i + '"><td>' + rfq_no + '<input type="hidden" name="vendor" value="' + vendor[0].id + '"/></td>'
                + '<td>' + vendor[0].company_name + '</td>';


            if (vendor[0].IsSundry != "1") {
                row += '<td>' +'<select name="contact" class="span6" id="contact_' + i + '" data-title="Contact person" data-validation="required"></select>';
            } else {
                row += '<td id="contact_person_' + i + '">&nbsp;</td>';
            }

            row += '<td id="email_' + i + '" class="wrapCol">&nbsp;</td>'
                + '<td  id="address_' + i + '" class="wrapCol">' + vendor_address
                + '</td>'

                + '<td>';

            if (vendor[0].IsSundry == "1") {
                row += '<span class="label green btnSundryEdit" data-toggle="modal" href="#SundryForm" title="Detail"><i class="icon-pencil edit" style="opacity: 0.7;"></i></span >'
                    + '<input type="hidden" name="address_' + i + '"  data-title="Sundry address" data-validation="required">'
            }


            row += '</td>'


                + '</tr > ';

            $("#tblRFQ tbody").append(row);

            var listContacts = $.grep(contacts, function (n, i) {
                return n["vendor_id"] == d;
            });
            var cboContact = $("#contact_" + i);
            generateCombo(cboContact, listContacts, "id", "name", true);
            Select2Obj(cboContact, "Contact person");
            if (listContacts.length == 1) {
                $(cboContact).val(listContacts[0].id).change();
                populateDetailVendor(listContacts[0].id, i);
            }

            $(cboContact).on('select2:select', function (e) {
                var contact_id = $(this).val();
                populateDetailVendor(contact_id, i);
            });
        });
    }

    function populateDetailVendor(id, i) {
        var contact_id = id;
        var email_address = "";
        var address = "";
        var detailContact = $.grep(listContact, function (n, i) {
            return n["id"] == contact_id;
        });
        if (detailContact.length > 0) {
            email_address = detailContact[0].email;
            address = detailContact[0].address;
        }
        $("#validate_email_" + i).val(email_address);
        $("#email_" + i).html(email_address);
        $("#address_" + i).html(address);
    }

    function ConfirmItem(data) {
        $("#tblDetail tbody").html("");
        $.each(data, function (i, _d) {
            $.each(_d, function (i, d) {
                var item = $.grep(listItem, function (n, j) {
                    return n["pr_detail_id"] == d.id;
                });

                var itemdesc = item[0].item_description;

                var uom = item[0].uom;
                if (uom == null || typeof uom === "undefined") {
                    uom = "";
                } else {
                    uom = " " + uom;
                }
                var row = "";
                row += '<tr><td><a href="<%=Page.ResolveUrl("~/purchaserequisition/detail.aspx?id=' + item[0].pr_id + '")%>" target="_blank">' + item[0].pr_no + '</a></td>'
                    + '<td>' + item[0].cifor_office + '</td>'
                    + '<td>' + item[0].item_code + '</td>'
                    + '<td>' + itemdesc + '</td>'
                    + '<td style="text-align:right;">' + accounting.formatNumber(delCommas(d.qty), 2) + ' ' + uom + '</td>'
                    + '</tr > ';

                $("#tblDetail tbody").append(row);
            });
        });
        normalizeMultilines();
    }

    function SetLookupSuppliers() {

        var srcSupplier = $("#srcSupplier");
        var isPlaceholder = true;
        var cbo = $(srcSupplier);
        var data = listVendor;

        if (isPlaceholder) {
            cbo.append("<option></option>");
        }

        $.each(data, function (i, d) {
            cbo.append("<option value='" + d["id"] + "'>" + d["company_name"] + "</option>");           
        });

        Select2Obj(srcSupplier, "Supplier");
    }

    $(document).on("click", "[id^='checkItemAll_']", function () {
        var sid = $(this).attr("id").replace("checkItemAll_", "");
        $(".item_check_" + sid).prop("checked", $(this).is(":checked"));
    });

    $(document).on("click", "[id^='checkVendorAll_']", function () {
        var sid = $(this).attr("id").replace("checkVendorAll_", "");
        $(".vendor_check_" + sid).prop("checked", $(this).is(":checked"));
    });

    $(document).on("click", "input[type='checkbox'].item", function () {
        var iclass = $(this).prop("class");
        iclass = iclass.replace(" item", "").replace("item_check_","");
        if (!$(this).prop("checked")) {
            $("#checkItemAll_" + iclass).prop("checked", false);
        }
    });

    $(document).on("click", "[id^='checkItemAll_']", function () {
        var sid = $(this).attr("id").replace("checkItemAll_", "");
        $(".item_check_" + sid).prop("checked", $(this).is(":checked"));
    });

    $(document).on("click", "[id^='addSupplier']", function () {
        var selectText = $('#srcSupplier option:selected')
            .toArray().map(item => item.text);
        var selectValue = $('#srcSupplier option:selected')
            .toArray().map(item => item.value);

        var currVendor = $("input[class^='vendor_check'").toArray().map(item => item.value);
        if (currVendor.length == 0) {
            $("table[id ^= 'vendor_'").find("td").remove();
            indexVendorLookup = [];
        }

        for (let i = 0; i < currVendor.length; i++) {
            indexVendorLookup.push(currVendor[i]);
        }
        indexVendorLookup = unique(indexVendorLookup)


        //get address supplier
        var param = selectValue.join(";");

        $.ajax({
            url: "<%=Page.ResolveUrl("~/Service.aspx/GetVendorAddressList")%>",
              dataType: 'json',
            data: '{vendor_id: "' + param + '"}',
              type: 'post',
              contentType: "application/json; charset=utf-8",
              success: function (response) {
                  listVendorAddress = JSON.parse(response.d);
                  for (let i = 0; i < selectText.length; i++) {

                      var supplierName = selectText[i];
                      var supplierAddress = "";
                      var idx = listVendorAddress.findIndex(x => x.id == selectValue[i])
                      var dVendor = listVendorAddress[idx];
                      if (dVendor != null) {
                          if (dVendor.address !== "" && dVendor.address !== null) {
                              supplierAddress = dVendor.address;
                          }
                      }

                      if (indexVendorLookup.indexOf(selectValue[i]) == -1) {
                          indexVendorLookup.push(selectValue[i]);

                          $("table[id^='vendor_'").each(function (index, e) {
                              var row = "";
                              var vendorCategory = e.id;
                              var temp = vendorCategory.split("_");

                              //format category id
                              var category = "";
                              if (temp.length > 2) {
                                  for (let j = 0; j < temp.length; j++) {
                                      if (j > 0) { category += temp[j] + '_'; }
                                  }
                                  category = category.substring(0, category.length - 1);
                              } else {
                                  category = temp[1];
                              }
                              //end

                              row += '<tr>'
                                  + '<td><input type="checkbox" class="vendor_check_' + category + ' vendor" data-category="' + category + '" value="' + selectValue[i] + '"/></td>'
                        + '<td>' + supplierName + '</td>'
                        + '<td>' + supplierAddress + '</td>';

                    $("#" + vendorCategory).find('tbody').append(row);

                    listVendor.push(
                        {
                            id: selectValue[i],
                            address: supplierAddress,
                            category: null,
                            company_name: supplierName,
                            category: category

                        }
                    );
                });

                    }
                  }

              }
        });


       
    });

    $(document).on("click", ".btnSundryEdit", function () {
        var id = $(this).closest("tr").prop("id");
        var index = $("#"+id).attr("data-index");
        id = id.replace("vendor_", "");
        var idx = listVendor.findIndex(x => x.id == id);
        var d = listVendor[idx];       
        EditSundry(d, index);
    });

    function EditSundry(d, index) {
        $("#SundryForm tbody").empty();
        $("#SundryForm-error-message").empty();
        $("#SundryForm-error-box").hide();

        var html = AddDetailSundrySupplierHTML(d.company_name, d.id, index,"","");
        //html += '<tr>'
        //    + '<td>Sundry </td>'
        //    + '<td>' + d.company_name
        //    + '<input type="hidden" name="sundry.id" value="'+d.id+'" data-index="'+index+'">'
        //    + '</td>'
        //    + '</tr>'
        //    + '<tr>'
        //    + '<td>Name <span style="color: red;">*</span></td>'
        //    + '<td>'
        //    + '<div class="">'
        //    + '<div class="">'//
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
        //    + '<input type="email" name="sundry.email" data-title="email" placeholder="Email" value="" class="span12"/>'
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
        //        //
        //    + '<tr>'
        //    + '<td>Bank account</td>'
        //    + '<td>'
        //    + '<div class="">'
        //    + '<div class="">'//
        //    + '<input type="text" name="sundry.bank_account" maxlength="35" placeholder="Bank account" value="" class="span12"/>'
        //    + '</div>'
        //    + '</div>'
        //    + '</td>'
        //    + '</tr>'
        //    + '<tr>'
        //    + '<td>Swift</td>'
        //    + '<td>'
        //    + '<div class="">'
        //    + '<div class="">'//
        //    + '<input type="text" name="sundry.swift" maxlength="11" placeholder="Swift" value="" class="span12"/>'
        //    + '</div>'
        //    + '</div>'
        //    + '</td>'
        //    + '</tr>'
        //    + '<tr>'
        //    + '<td>Sort code</td>'
        //    + '<td>'
        //    + '<div class="">'
        //    + '<div class="">'//
        //    + '<input type="text" name="sundry.sort_code" maxlength="13" placeholder="Sort code" value="" class="span12"/>'
        //    + '</div>'
        //    + '</div>'
        //    + '</td>'
        //    + '</tr>'
        //    + '<tr>'
        //    + '<td>Address</td>'
        //    + '<td>'
        //    + '<textarea name="sundry.address" maxlength="160" maxlength="2000" rows="10" placeholder="address" class="span12"></textarea>'
        //    + '<div class="mt-1" style="font-size: 80%; font-style: italic; display: block;">Maximum description is 2,000 characters</div>'
        //    + '</td>'
        //    + '</tr>'
        //    + '<tr>'
        //    + '<td>Place <span style="color: red;">*</span></td>'
        //    + '<td>'
        //    + '<div class="">'
        //    + '<div class="">'//
        //    + '<input type="text" name="sundry.place" maxlength="40" placeholder="Place" value="" class="span12"/>'
        //    + '</div>'
        //    + '</div>'
        //    + '</td>'
        //    + '</tr>'
        //    + '<tr>'
        //    + '<td>Province</td>'
        //    + '<td>'
        //    + '<div class="">'
        //    + '<div class="">'//
        //    + '<input type="text" name="sundry.province" maxlength="40" placeholder="Province" value="" class="span12"/>'
        //    + '</div>'
        //    + '</div>'
        //    + '</td>'
        //    + '</tr>'
        //    + '<tr>'
        //    + '<td>Post code</td>'
        //    + '<td>'
        //    + '<div class="">'
        //    + '<div class="">'//
        //    + '<input type="text" name="sundry.post_code" maxlength="15" placeholder="Post code" value="" class="span12"/>'
        //    + '</div>'
        //    + '</div>'
        //    + '</td>'
        //    + '</tr>'
        //    + '<tr>'
        //    + '<td>VAT RegNo</td>'
        //    + '<td>'
        //    + '<div class="">'
        //    + '<div class="">'//
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
            var index = $("[name='sundry.id']").attr("data-index");
            var idx = listVendor.findIndex(x => x.id == id);
            var d = listVendor[idx];       

            var data = new Object();
            data.sundry_supplier_id = d.id;
            data.module_id = "";
            data.module_type = "";
            data.name = $("[name='sundry.name']").val();
            data.address = $("[name='sundry.address']").val();
            data.contact_person = $("[name='sundry.contact_person']").val();
            data.email = $("[name='sundry.email']").val();
            data.phone_number = $("[name='sundry.phone_number']").val();
            data.bank_account = $("[name='sundry.bank_account']").val();
            data.swift = $("[name='sundry.swift']").val();
            data.sort_code = $("[name='sundry.sort_code']").val();
            data.place = $("[name='sundry.place']").val();
            data.province = $("[name='sundry.province']").val();
            data.post_code = $("[name='sundry.post_code']").val();
            data.vat_reg_no = $("[name='sundry.vat_reg_no']").val();

            // check data sundry
            var ids = dataSundry.findIndex(x => x.sundry_supplier_id == d.id);
            if (ids != -1) {
                dataSundry.splice(ids,1); // remove sundry
            }

            dataSundry.push(data);

            $("#address_" + index).html(setSundryAddress(data))
            $("#contact_person_" + index).html(data.contact_person)
            $("#email_" + index).html(data.email)
            $("[name='address_" + index+"'").val(setSundryAddress(data))
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

    function loadLookupsupplier() {
        blockScreenOL();
        let listItemTemp = null;
        let office_id = '';
        if (_Items != null) {
            listItemTemp = JSON.parse(_Items.listItem);
        }

        if (listItemTemp != null) {
            if (listItemTemp.length > 0) {
                office_id = listItemTemp[0]['cifor_office_id'];
            }
        }        

        $.ajax({
            url: "<%=Page.ResolveUrl("~/Service.aspx/GetVendorList")%>",
             dataType: 'json',
             type: 'post',
            delay: 500,
            contentType: "application/json; charset=utf-8",
            success: function (response) {

                listVendor = JSON.parse(response.d);
                listSundry = listVendor.filter(i => i.IsSundry == "1");
                listVendor = listVendor.filter(i => i.IsSundry == "0");
                $.ajax({
                    url: "<%=Page.ResolveUrl("~/Service.aspx/GetTaxSystem")%>",
                    data: '{office_id:"' + office_id + '"}',
                    dataType: 'json',
                    type: 'post',
                    delay: 500,
                    contentType: "application/json; charset=utf-8",
                    success: function (response) {

                        listEntity = JSON.parse(response.d);
                        if (isAllTax.toLowerCase() == 'false') {
                            $.each(listEntity, function (i, en) {
                                listVendor = listVendor.filter(i => i.Entity == en.Entity);
                            });
                        }

                        $.each(listSundry, function (i, en) {
                            listVendor.push(
                                {
                                    id: en.id,
                                    IsSundry: en.IsSundry,
                                    address: en.address,
                                    code: en.code,
                                    company_name: en.company_name,
                                    vendor_name: en.vendor_name,
                                    subcategory: en.subcategory,
                                    ocs_supplier_code: en.ocs_supplier_code,
                                    category: en.category

                                }
                            );
                        });

                        var cboPeriod = $("select[name='supplier_search']");
                        cboPeriod.empty();
                        generateCombo(cboPeriod, listVendor, "id", "company_name", true);
                        /*$(cboPeriod).val(listPeriod[0].Id).change();*/
                        Select2Obj(cboPeriod, "Supplier");
                        //SetLookupSuppliers();
                        unBlockScreen();
                        unBlockScreenOL();
                    }
                });
             }
         });
    }

</script>