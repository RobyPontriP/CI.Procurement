<%@ Page MasterPageFile="~/Procurement.Master" Language="C#" AutoEventWireup="true" CodeBehind="Tasklist.aspx.cs" Inherits="Procurement.PurchaseOrder.Tasklist" %>

<asp:Content ID="Content1" ContentPlaceHolderID="AppHead" runat="server">
    <title>Purchase Order(s) pending for action</title>
    <style>
        .sorting_1 {
            background-color: inherit !important;
        }
        .legend-block
        {
            min-width: 10px !important;
            min-height: 10px !important;
            padding-left: 25px;
        }
        .legend
        {
            font-size: 70%;
            clear: both;
            margin-bottom: 10px;
        }

        span.label {
            display:block;
            margin-bottom:3px;
        }

        #CancelForm.modal-dialog {
            margin: auto 12%;
            width: 60%;
            height: 320px !important;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="AppBody" runat="server">
    <div class="row-fluid">
        <div class="floatingBox">
            <div class="container-fluid">
                <div class="control-group last">
                    <table id="tblPO" class="table table-bordered" style="border: 1px solid #ddd">
                        <thead>
                            <tr>
                                <th style="width:2%"><i class="icon-chevron-sign-down dropAllDetail" title="Collapse/Expand detail(s)"></i></th>
                                <th style="width:8%;">PO code</th>
                                <th style="width:10%;">Document date</th>
                                <th style="width:15%;">Business partner</th>
                                <th style="width:15%;">Total amount (in original currency)</th>
                                <th style="width:15%;">Exchange rate</th>
                                <th style="width:15%;">Total amount (in USD)</th>
                                <th style="width:15%;">Remarks</th>
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
        var mainData = <%=listPO%>;

        var POTable;

        function format(d) {
            var html = "";
            if (typeof d !== "undefined") {
                var _d = JSON.parse(d.details);
                var detailrows = "";

                if (_d.length > 0) {
                    $.each(_d, function (i, x) {
                        var item_desc = "";
                        item_desc = x.item_description;
                        detailrows += '<tr>' +
                            '<td class="item_code">' + x.item_code + '</td>' +
                            '<td class="description">' + item_desc + '</td>' +
                            '<td class="line_status">' + x.line_status_name + '</td>' +
                            '<td class="quantity" style="text-align:right;">' + accounting.formatNumber(x.quantity, 2) + ' ' + x.uom + '</td>' +
                            '<td class="pr_detail"><a href="/workspace/procurement/purchaserequisition/detail.aspx?id=' + x.pr_id + '" target="_blank">' + x.pr_no + '</a></td>' +
                            '</tr > ';
                    });
                    console.log('<tbody>' + detailrows + '</tbody>');
                    html = '<div class="span1"></div><div class="span11"><table class="table table-bordered" cellpadding="5" cellspacing="0" style="border: 1px solid #ddd">' +
                        '<thead>' +
                        '<tr>' +
                        '<th>Item code</th>' +
                        '<th>Description</th>' +
                        '<th>Item status</th>' +
                        '<th>Order quantity & UOM</th>' +
                        '<th>PR code</th>' +
                        '</tr>' +
                        '</thead>' +
                        '<tbody>' + detailrows + '</tbody>' +
                        '</table></div>';
                }
            }
            console.log(html);
            return html;
        }

        $(document).ready(function () {
            POTable = $('#tblPO').DataTable({
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
                    { "mDataProp": "po_no" },
                    { "mDataProp": "document_date" },
                    {
                        "mDataProp": "vendor"
                        , "mRender": function (d, type, row) {
                            var html = '<a href="/workspace/procurement/businesspartner/detail.aspx?id=' + row.vendor + '" target="_blank" title="View detail business partner">' + row.vendor_name + '</a>';
                            return html;
                        }
                    },
                    {
                        "mDataProp": "total_amount"
                        , "mRender": function (d, type, row) {
                            return row.currency_id + ' ' + accounting.formatNumber(row.total_amount, 2);
                        }
                    },
                    {
                        "mDataProp": "exchange_rate"
                        , "mRender": function (d, type, row) {
                            return accounting.formatNumber(row.exchange_rate, 2);
                        }
                    },
                    {
                        "mDataProp": "total_amount_usd"
                        , "mRender": function (d, type, row) {
                            return accounting.formatNumber(row.total_amount_usd, 2);
                        }
                    },
                    { "mDataProp": "remarks" },
                    {
                        "mDataProp": "url"
                        , "mRender": function (d, type, row) {
                            return '<a href="'+row.url+'">Take action</a>'
                        }
                    },
                    { "mDataProp": "details", "visible": false },
                ],
                "columnDefs": [ {
                    "targets": [0,8],
                    "orderable": false,
                    },
                    {
                        targets: [4,5,6],
                        className: 'dt-body-right'
                 }],
                "aaSorting": [[2, "asc"]],
                "iDisplayLength": 50
                ,"bLengthChange": false
            });

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
</asp:Content>