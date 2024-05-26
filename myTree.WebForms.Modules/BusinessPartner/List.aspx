<%@ Page MasterPageFile="~/Procurement.Master" Language="C#" AutoEventWireup="true" CodeBehind="List.aspx.cs" Inherits="myTree.WebForms.Modules.BusinessPartner.List" %>

<asp:Content ID="Content1" ContentPlaceHolderID="AppHead" runat="server">
    <title>Supplier</title>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="AppBody" runat="server">
    <div class="row-fluid">
        <div class="floatingBox">
            <div class="container-fluid">
                <div class="control-group">
                    <label class="control-label">
                        Show Suppliers by status
                    </label>
                    <div class="controls">
                        <select id="vendorStatus" name="_vendorStatus">
                            <option value="">All</option>
                            <option value="1">Active</option>
                            <option value="0">In-active</option>
                        </select>
                    </div>
                </div>

                <div class="control-group">
                    <div class="controls">
                        <button type="submit" id="btnSearch" class="btn btn-success">Search</button>
                    </div>
                </div>

                <div class="control-group last">
                    <p>
                        <button type="button" id="btnAdd" class="btn btn-success">Add new Supplier</button>
                     <%--   <asp:Button ID="BtnExportToExcelBP" runat="server" CssClass="btn btn-success" OnClick="BtnExportToExcelBP_Click" Text="Export to excel" />--%>
                    </p>

                    <table id="tblVendors" class="table table-bordered table-hover" style="border: 1px solid #ddd">
                        <thead>
                            <tr>
                                <th style="width: 2%"><i class="icon-chevron-sign-down dropAllDetail" title="Collapse/Expand detail(s)"></i></th>
                                <th style="width: 7%">Supplier code</th>
                                <th style="width: 8%">OCS Supplier code</th>
                                <th style="width: 20%">Name</th>
                                <th style="width: 38%">Address</th>
                                <th style="width: 5%">Status</th>
                                <th style="width: 5%">&nbsp;</th>
                            </tr>
                        </thead>
                        <tbody>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
    <script>
        var isAdmin = "<%=isAdmin?"true":"false"%>";
        isAdmin = (isAdmin === "true");

        var vendorStatus = "<%=vendorStatus%>";
        var isShown = true;
        var mainData = <%=listVendor%>;
        var listVendorDetail = <%=listVendorDetail%>;

        function format(d) {
            var html = "";

            html = '<div class="span1"></div><div class="span11"><table class="table table-bordered" cellpadding="5" cellspacing="0" style="border: 1px solid #ddd">' +
                '<thead>' +
                '<tr>' +
                '<th>Contact person name</th>' +
                '<th>Position</th>' +
                '<th>Mobile phone</th>' +
                '<th>Home phone</th>' +
                '<th>Email</th>' +
                '<th>CC Email</th>' +
                '<th>Status</th>' +
                '</tr>' +
                '</thead> ' +
                '<tbody> ';

            var tbody = '';

            if (typeof d !== "undefined") {
                let arr = $.grep(listVendorDetail, function (n, i) {
                    return  n["Id"] == d.address_id;
                });

                if (arr.length > 0) {
                    $.each(arr, function (i, _contact) {
                        tbody += '<tr>' +
                            '<td  class="wrapCol">' + _contact.ContactPerson + '</td>' +
                            '<td  class="wrapCol">' + _contact.Position + '</td>' +
                            '<td  class="wrapCol">' + _contact.Telephone4 + '</td>' +
                            '<td  class="wrapCol">' + _contact.Telephone6 + '</td>' +
                            '<td class="wrapCol">' + _contact.ToEmail + '</td>' +
                            '<td class="wrapCol">' + _contact.CCEmail + '</td>' +
                            '<td class="wrapCol">' + _contact.vendor_cp_active_label + '</td>' +
                            '</tr > ';
                    });
                } else {
                    tbody += '<tr>' +
                        '<td colspan="7" style="text-align:center;">No data available</td>' +
                        '</tr > ';   
  
                }
                
            } 
            html += tbody
            '</tbody>' +
                '</table></div>';

            return html;
        }
        var oTable;
        $(document).ready(function () {
            $("form[name='aspnetForm']").bind("keypress", function (e) {
                if (e.keyCode == 13) {
              <%--      $("#<%=BtnExportToExcelBP.ClientID %>").attr('value');--%>
                    //add more buttons here
                    return false;
                }
            });

            <%--oTable = $('#tblVendors').DataTable({
                "processing": true,
                "serverSide": true,
                "searchDelay": 5000,
                "info": true,
                //"bFilter": true,
                //"bDestroy": true,
                //"bRetrieve": true,
                "pagingType": 'full_numbers',
                //"lengthMenu": [[100, 200, -1], [100, 200, "All"]],
                "ajax": {
                    "url": "<%= Page.ResolveUrl("~/BusinessPartner/Render.aspx") %>",
                    "type": "POST",
                    "data": function (d) {
                        d.vendor_status = $("#vendorStatus").val();
                    }
                },
                //"aaData": data,
                "aoColumns": [
                    {
                        "mDataProp": "id"
                        , "mRender": function (d, type, row) {
                            return '<i class="icon-chevron-sign-down dropDetail" title="View detail(s)"></i>'
                        }
                    },
                    { "mDataProp": "company_code" },
                    { "mDataProp": "sun_code" },
                    {
                        "mDataProp": "company_name"
                        , "mRender": function (d, type, row) {
                            var html = '<a href="detail.aspx?id=' + row.id + '" title="View detail">' + row.company_name + '</a>';
                            return html;
                        }
                    },

                    { "mDataProp": "address" },
                    { "mDataProp": "categories" },
                    { "mDataProp": "vendor_active_label" },
                    {
                        "mDataProp": "action"
                        , "sClass": "no-sort"
                        , "visible": isAdmin
                        , "mRender": function (d, type, row) {
                            var html = '<input name="id" type="hidden" value="' + row.id + '"/>';

                            html += '<span class="label green btnEdit" title="Edit vendor"><i class="icon-pencil edit" style="opacity: 0.7;"></i></span>';
                            html += '<span class="label red btnDelete" title="Delete vendor"><i class="icon-trash delete" style="opacity: 1;"></i></span>';
                            return html;
                        }
                    },
                    {
                        "mDataProp": "contacts"
                        , "visible": false
                    }
                ],
                "columnDefs": [{
                    "targets": [0, 6],
                    "orderable": false,
                }, {
                    "targets": [1],
                    "sType": "companycode"
                }]
                , "order": [[1, "asc"]]
                , "bLengthChange": false
                , "iDisplayLength": 50
                , "drawCallback": function (settings) {
                    OpenAllChilds();
                }
            });--%>

            oTable = $('#tblVendors').DataTable({
                "bFilter": true, "bDestroy": true, "bRetrieve": true, "pagingType": 'full_numbers',
                "lengthMenu": [[50, 100, -1], [50, 100, "All"]],
                "aaData": mainData,
                "aoColumns": [
                    {
                        "mDataProp": "id"
                        , "mRender": function (d, type, row) {
                            return '<i class="icon-chevron-sign-down dropDetail" title="View detail(s)"></i>'
                        }
                    },
                    { "mDataProp": "Code" },
                    { "mDataProp": "ocs_supplier_code" },
                    {
                        "mDataProp": "company_name"
                        , "mRender": function (d, type, row) {
                            var html = '';
                            //if (row.IsMyTreeSupplier == 1) {
                            //    html = '<a href="detail.aspx?id=' + row.Id + '" title="View detail">' + row.company_name + '</a>';
                            //} else {
                            //    html = row.company_name;
                            //}
                            html = '<a href="detail.aspx?id=' + row.Id + '" title="View detail">' + row.company_name + '</a>';
                            return html;
                        }
                    },
                    { "mDataProp": "address" },
                    //{
                    //    "mDataProp": "categories"
                    //    , "mRender": function (d, type, row) {
                    //        var html = '';
                    //        if (row.categories !== null && row.categories != '' && row.categories != 'undefined') {
                    //            /*html = row.categories.replace(/|/g, "<br/>");*/
                    //            html = row.categories.split("|").join("<br/>");
                    //        }

                    //        return html;
                    //    }
                    //},
                    /*{ "mDataProp": "categories" },*/
                    { "mDataProp": "vendor_active_label" },
                    {
                        "mDataProp": "action"
                        , "sClass": "no-sort"
                        , "visible": isAdmin
                        , "mRender": function (d, type, row) {
                            var html = '<input name="id" type="hidden" value="' + row.id + '"/>';

                            html += '<span class="label green btnEdit" title="Edit vendor"><i class="icon-pencil edit" style="opacity: 0.7;"></i></span>';
                            html += '<span class="label red btnDelete" title="Delete vendor"><i class="icon-trash delete" style="opacity: 1;"></i></span>';
                            return html;
                        }
                    }
                ],
                "columnDefs": [{
                    "targets": [0],
                    "orderable": false,
                    //"sortable": false,
                },
                { className: "wrapCol", "targets": [1,2,3,4] }],
               "aaSorting": [[1, "asc"],[1,"desc"]],
                "iDisplayLength": 50
                , "bLengthChange": false

            });

            $('#tblVendors_filter input').unbind();
            $('#tblVendors_filter input').bind('keyup', function (e) {
                if (e.keyCode == 13) {
                    oTable.search(this.value).draw();
                }
            });

            $(window).keydown(function (event) {
                if (event.keyCode == 13) {
                    event.preventDefault();
                    return false;
                }
            });

            $('#tblVendors tbody').on('click', '.dropDetail', function () {
                if (!$(this).hasClass('no-sort') && !$(this).hasClass('dropAllDetail')) {
                    var tr = $(this).closest('tr');
                    var row = oTable.row(tr);

                    $(this).attr('class', '');
                    if (row.child.isShown()) {
                        row.child.hide();
                        tr.removeClass('shown');
                        $(this).attr('class', 'icon-chevron-sign-right dropDetail');
                    } else {
                        row.child(format(row.data())).show();
                        tr.addClass('shown');
                        $(this).attr('class', 'icon-chevron-sign-down dropDetail');
                    }

                }
            });


            $.each(oTable.rows().nodes(), function (i) {
                var row = oTable.row(i)
                if (!row.child.isShown()) {
                    row.child(format(row.data())).show();
                    $(row.node()).addClass('shown');
                }
            });


            // Handle click on "Collapse All" button
            $('#btn-hide-all-children').on('click', function () {
                // Enumerate all rows
                oTable.rows().every(function () {
                    // If row has details expanded
                    if (this.child.isShown()) {
                        // Collapse row details
                        this.child.hide();
                        $(this.node()).removeClass('shown');
                    }
                });
            });

            $("#vendorStatus")
                .select2()
                .on("change", function () {
                    var searchVal = $("[type='search']").val();
                    oTable.search(searchVal).draw();
                });


            var cboVendorStatus = $("#vendorStatus");
            $(cboVendorStatus).val(vendorStatus).change();
        });

        $(document).on("click", ".dropAllDetail", function () {
            if ($(this).hasClass('icon-chevron-sign-right')) {
                isShown = true;
            } else if ($(this).hasClass('icon-chevron-sign-down')) {
                isShown = false;
            }
            $.each(oTable.rows().nodes(), function (i) {
                var tr = $(this).closest('tr');
                var row = oTable.row(i);

                if (!isShown) {
                    row.child.hide();
                    $(row.node()).removeClass('shown');
                    $(tr).find('i[class^="icon-chevron"]').attr('class', 'icon-chevron-sign-right dropDetail');
                }
                else if (isShown) {
                    row.child(format(row.data())).show();
                    $(row.node()).addClass('shown');
                    $(tr).find('i[class^="icon-chevron"]').attr('class', 'icon-chevron-sign-down dropDetail');
                }
            });

            if (isShown) {
                $(this).attr('class', 'icon-chevron-sign-down dropAllDetail');
            } else {
                $(this).attr('class', 'icon-chevron-sign-right dropAllDetail');
            }
        });

        function OpenAllChilds() {
            $.each(oTable.rows().nodes(), function (i) {
                var tr = $(this).closest('tr');
                var row = oTable.row(i)
                    if (!isShown) {
                        row.child.hide();
                        $(row.node()).removeClass('shown');
                        $(tr).find('i[class^="icon-chevron"]').attr('class', 'icon-chevron-sign-right dropDetail');
                    }
                    else if (isShown) {
                        row.child(format(row.data())).show();
                        $(row.node()).addClass('shown');
                        $(tr).find('i[class^="icon-chevron"]').attr('class', 'icon-chevron-sign-down dropDetail');
                    }
            });
        }

        $(document).on("click", ".btnEdit", function () {
            var _id = $(this).closest("td").find("input[name='id']").val();
            location.href = "input.aspx?id=" + _id;
        });

        $(document).on("click", ".btnDelete", function () {
            var _id = $(this).closest("td").find("input[name='id']").val();
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
            })
        }

        $(document).on("click", "#btnAdd", function () {
            location.href = "input.aspx";
        });

        $(document).on("click", "#btnSearch", function () {
            var errorMsg = "";
            //errorMsg += GeneralValidation();

            //if (errorMsg !== "") {
            //    showErrorMessage(errorMsg);

            //    return false;
            //}
        });

        //$(document).on("click","#btnExportExcel", function () {
        //    ExportExcel();
        //});

        jQuery.fn.dataTableExt.oSort["companycode-desc"] = function (x, y) {
            function getNumber(str) {
                str = str.replace('BP-', '');
                str = str.replace(new RegExp(',', 'g'), '');
                return parseFloat(str);
            };
            return getNumber(x) - getNumber(y);
        };

        jQuery.fn.dataTableExt.oSort["companycode-asc"] = function (x, y) {
            return jQuery.fn.dataTableExt.oSort["companycode-desc"](y, x);
        }

    </script>
</asp:Content>
