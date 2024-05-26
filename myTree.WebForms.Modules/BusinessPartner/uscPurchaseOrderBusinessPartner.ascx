<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="uscPurchaseOrderBusinessPartner.ascx.cs" Inherits="myTree.WebForms.Modules.BusinessPartner.uscPurchaseOrderBusinessPartner" %>

<div class="row-fluid">
    <div class="floatingBox">
         <div class="container-fluid">   
             <div class="control-group last">
                    <%--<button id="btnExportExcel" class="btn btn-success" type="button">Export to excel</button>  --%> 
                    <input type="submit" name= "btnExport" value="Export to excel" class="btn btn-sm btn-success btnExportExcel"/>
                    <table id="tblPO" class="table table-bordered" style="border: 1px solid #ddd">
                        <thead>
                            <tr>
                                <th style="width:2%"><i class="icon-chevron-sign-down dropAllDetail" title="Collapse/Expand detail(s)"></i></th>
                                <th style="width:8%;">OCS PO number</th>
                                <th style="width:10%;">Document date</th>
                                <%--<th style="width:15%;">Business partner</th>--%>
                                <th style="width:10%;">Delivery date</th>
                                <th style="width:5%;">Currency</th>
                                <th style="width:15%;">Grand total amount (in original currency)</th>
                                <th style="width:10%;">Grand total amount (in USD)</th>
                                <th style="width:25%;">Remarks</th>
                                <th style="width:10%;">Status</th>
                                <th style="width:5%;">&nbsp;</th>
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
        
        var mainData = <%=listPR%>;

        var POTable;

        var _id = "";
        var po_no = "";

        function format(d) {
            var html = "";
            if (typeof d !== "undefined") {
                var _d = JSON.parse(d.details);
                var detailrows = "";

                if (_d.length > 0) {
                    $.each(_d, function (i, x) {
                        var item_desc = "";
                        item_desc = x.item_description;
                        detailrows += '<tr>';
                        var id_itemclosure="";
                        var id_item = "";
                        var reason = "";
                        var line_status_name = x.line_status_name;
                        //if (x.closing_remarks != "") {
                        //    line_status_name += "<br/>Remarks: " + x.closing_remarks;
                        //}

                        detailrows += '<td class="po_no">' + x.po_no + '</td>' +
                            '<td class="item_code">' + x.item_code + '</td>' +
                            '<td class="description">' + item_desc + '</td>' +
                            '<td class="line_status">' + line_status_name + '</td>' +
                            '<td class="quantity" style="text-align:right;">' + accounting.formatNumber(x.quantity, 2) + '</td>' +
                            '<td class="received_quantity" style="text-align:right;">' + accounting.formatNumber(x.received_quantity, 2) + '</td>' +
                            '<td class="balance" style="text-align:right;">' + accounting.formatNumber(x.balance, 2) + '</td>' +
                            '<td class="uom_name">' + x.uom + '<input type="hidden" name="po_detail_id" value="' + x.line_id + '"/></td>' +
                            '<td class="" style="text-align:right;">' + accounting.formatNumber(x.total_amount_product, 2) + '</td>' +
                            '<td class="" style="text-align:right;">' + accounting.formatNumber(x.total_amount_usd_product, 2) + '</td>';
                        detailrows += '</tr > ';
                    });

                    html = '<div class="span1"></div><div class="span11"><table class="table table-bordered" cellpadding="5" cellspacing="0" style="border: 1px solid #ddd">' +
                        '<thead>' +
                        '<tr>';
                    
                    html +=
                        '<th>PO code</th>' +
                        '<th>Product code</th>' +
                        '<th>Description</th>' +
                        '<th style="width:12%;">Product status</th>' +
                        '<th>Order quantity</th>' +
                        '<th>Receiving quantity</th>' +
                        '<th>Balance quantity</th>' +
                        '<th>UOM</th>' +
                        '<th>Total amount (in original currency)' +
                        '<th>Total amount (in USD)';
                    html += '</tr>' +
                        '</thead> ' +
                        '<tbody>' + detailrows + '</tbody>' +
                        '</table></div>';
                }
            }
            return html;
        }

        $(document).ready(function () {
            POTable = $('#tblPO').DataTable({
                "bFilter": true, "bDestroy": true, "bRetrieve": true, "pagingType": 'full_numbers',
                "lengthMenu": [[50, 100, -1], [50, 100, "All"]],
                "fnRowCallback": function( nRow, aData, iDisplayIndex ) {  
                    $(nRow).css('background-color', aData.color_code);
                    $(nRow).css('color', aData.font_color);
                },
                "aaData": mainData,
                "aoColumns": [
                    {
                        "mDataProp": "id"
                        , "mRender": function (d, type, row) {
                            return '<i class="icon-chevron-sign-down dropDetail" title="View detail(s)"></i>'
                        }
                    },
                    {
                        "mDataProp": "po_sun_code"
                        , "mRender": function (d, type, row) {
                            var po_sun_code = row.po_sun_code != '' ? row.po_sun_code : 'N/A';
                            var html = '<a href="<%=Page.ResolveUrl("~/purchaseorder/detail.aspx?id=' + row.id + '")%>" title="View detail PO">' + po_sun_code + '</a>';
                            return html;
                        }
                    },
                    { "mDataProp": "document_date" },
                    //{
                    //    "mDataProp": "vendor"
                    //    , "mRender": function (d, type, row) {
                    //        var html = '<a href="/workspace/procurement/businesspartner/detail.aspx?id=' + row.vendor + '" title="View detail business partner">' + row.vendor_name + '</a>';
                    //        return html;
                    //    }
                    //},
                    { "mDataProp": "delivery_date" },
                    { "mDataProp": "currency_id" },
                    {
                        "mDataProp": "total_amount"
                        , "mRender": function (d, type, row) {
                            return accounting.formatNumber(row.total_amount, 2);
                        }
                    },
                    {
                        "mDataProp": "total_amount_usd"
                        , "mRender": function (d, type, row) {
                            return accounting.formatNumber(row.total_amount_usd, 2);
                        }
                    },
                    { "mDataProp": "remarks" },
                    { "mDataProp": "status" },
                    { "mDataProp": "details", "visible": false }
                ],
                "columnDefs": [ {
                        "targets": [0],
                        "orderable": false,
                    },
                    {
                        "targets": [5,6],
                        "className": 'dt-body-right'
                    },  
                    {
                        "targets": [1],
                        sType : 'sortSunPO'
                    }
                ],
                "aaSorting": [[1, "asc"]],
                "iDisplayLength": 50
                ,"bLengthChange": false
            });

            function getSunPONum(a) {
                var s = !a ?
                            '' :
                            a.replace ?
                                $.trim(a.replace( /<.*?>/g, "" ).toLowerCase() ) :
                        a + '';
                var w = s == "-" ? "0" : s;
                var z = w.substring(w.trim().length - 7).replace("/", "");
                return parseInt(z);
            }

            jQuery.extend( jQuery.fn.dataTableExt.oSort, {
                "sortSunPO-pre": function ( x ) {
                    return getSunPONum(x);
                },

                "sortSunPO-asc": function ( x, y ) {
                    return getSunPONum(x) < getSunPONum(y);
                },

                "sortSunPO-desc": function ( x, y ) {
                    return getSunPONum(x) > getSunPONum(y);
            }});

            $('#tblPO_filter input').unbind();
            $('#tblPO_filter input').bind('keyup', function (e) {
                if (e.keyCode == 13) {
                    POTable.search(this.value).draw();	
                }
            });	

            $(window).keydown(function(event){
                if(event.keyCode == 13) {
                    event.preventDefault();
                    return false;
                }
            });

            $('#tblPO tbody').on('click', 'i[class^="icon-chevron"]', function () {
                if (!$(this).hasClass('no-sort') && !$(this).hasClass('dropAllDetail')) {
                    var tr = $(this).closest('tr');
                    var row = POTable.row(tr);

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
                    normalizeMultilines();
                }
            });

            $.each(POTable.rows().nodes(), function (i) {
                var row = POTable.row(i)
                if(!row.child.isShown()){
                    row.child(format(row.data())).show();
                    $(row.node()).addClass('shown');
                }
            });

            // Handle click on "Collapse All" button
            $('#btn-hide-all-children').on('click', function(){
                POTable.rows().every(function(){
                    if(this.child.isShown()){
                        this.child.hide();
                        $(this.node()).removeClass('shown');
                    }
                });
            });

            normalizeMultilines();
        });

        $(document).on("click", ".dropAllDetail", function () {
            var isShown = false;
            if ($(this).hasClass('icon-chevron-sign-right')) {
                isShown = true;
            } else if ($(this).hasClass('icon-chevron-sign-down')) {
                isShown = false;
            }
            $.each(POTable.rows().nodes(), function (i) {
                var tr = $(this).closest('tr');
                var row = POTable.row(i);

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

</script>