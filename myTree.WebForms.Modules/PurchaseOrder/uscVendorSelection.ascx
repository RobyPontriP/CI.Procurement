<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="uscVendorSelection.ascx.cs" Inherits="Procurement.PurchaseOrder.uscVendorSelection" %>
<div class="control-group">
    <p>Supplier Selection(s) and Quotation(s) information</p>
    <table id="tblVS" class="table table-bordered table-hover" style="border: 1px solid #ddd">
        <thead>
            <tr>
                <th></th>
                <th>Quotation analysis code</th>
                <th>Supplier code</th>
                <th>Supplier name</th>
                <th>Supporting material(s)</th>
            </tr>
        </thead>
        <tbody>
        </tbody>
    </table>
</div>
<div class="control-group last">
    <p>Purchase Requisition(s) information</p>
    <table id="tblPR" class="table table-bordered table-hover" style="border: 1px solid #ddd">
        <thead>
            <tr>
                <th>PR code</th>
                <th>Created date</th>
                <th>Submission date</th>
                <th>Requester name</th>
                <th>Purchase office</th>
                <th>Required date</th>
                <th>Remarks</th>
                <th>Supporting document(s)</th>
            </tr>
        </thead>
        <tbody>
        </tbody>
    </table>
</div>
<script>
    var listPR = <%=listPR%>;
    var listVS = <%=listVS%>;

    var VSTable;

    $(document).ready(function(){
        PRTable = $('#tblPR').dataTable({
            "bDestroy": true, "bRetrieve": true, "pagingType": 'full_numbers',
            bLengthChange: false,
            bFilter: false,
            bSort: false,
            iDisplayLength: 20,
            "aaData": listPR,
            "aoColumns": [
                {
                    "mDataProp": "pr_no"
                    , "mRender": function (d, type, row) {
                        return '<a href="/procurement/purchaserequisition/detail.aspx?id=' + row.id + '" target="_blank" title="View Purchase requisition">' + row.pr_no + '</a>';
                    }
                },
                {
                    "mDataProp": "created_date"
                },
                {
                    "mDataProp": "submission_date"
                },
                {
                    "mDataProp": "requester_name"
                },
                {
                    "mDataProp": "cifor_office_name"
                },
                {
                    "mDataProp": "required_date"
                },
                {
                    "mDataProp": "remarks"
                },
                {
                    "mDataProp": "supporting_documents"
                },
            ]
        });

       VSTable = $('#tblVS').DataTable({
            "bDestroy": true, "bRetrieve": true, "pagingType": 'full_numbers',
            bLengthChange: false,
            bFilter: false,
            bSort: false,
            iDisplayLength: 20,
            "aaData": listVS,
            "aoColumns": [
                {
                    "mDataProp": "vs_id"
                    , "mRender": function (d, type, row) {
                        return '<i class="icon-chevron-sign-down dropDetail" title="View detail(s)"></i>'
                    }
                },
                {
                    "mDataProp": "vs_no"
                    ,"mRender": function (d, type, row) {
                        var html = '<a href="/procurement/QuotationAnalysis/detail.aspx?id=' + row.vs_id + '" target="_blank" title="View Supplier">' + row.vs_no + '</a>';
                        return html;
                    }
                },
                { "mDataProp": "vendor_code" },
                {
                    "mDataProp": "vendor_name"
                    ,"mRender": function (d, type, row) {
                        var html = '<a href="/procurement/businesspartner/detail.aspx?id=' + row.vendor + '" target="_blank" title="View Supplier">' + row.vendor_name + '</a>';
                        return html;
                    }
                },
                {
                    "mDataProp": "supporting_documents"
                },
                { "mDataProp": "details", "visible": false },
            ],
            "aaSorting": [[2, "asc"]]
        });
        
        $('#tblVS tbody').on('click', 'i[class^="icon-chevron"]', function () {
            if (!$(this).hasClass('no-sort')) {
                var tr = $(this).closest('tr');
                var row = VSTable.row(tr);

                $(this).attr('class', '');
                if (row.child.isShown()) {
                    row.child.hide();
                    tr.removeClass('shown');
                    $(this).attr('class', 'icon-chevron-sign-right dropDetail');
                } else {
                    row.child(formatVSD(row.data())).show();
                    tr.addClass('shown');
                    $(this).attr('class', 'icon-chevron-sign-down dropDetail');
                }
            }
        });
        $.each(VSTable.rows().nodes(), function (i) {
            var row = VSTable.row(i)
            if(!row.child.isShown()){
                row.child(formatVSD(row.data())).show();
                $(row.node()).addClass('shown');
            }
        });

        // Handle click on "Collapse All" button
        $('#btn-hide-all-children').on('click', function () {
            $.each(VSTable.rows().nodes(), function (i) {
                var tr = $(this).closest('tr');
                var row = VSTable.row(i);

                if (row.child.isShown()) {
                    row.child.hide();
                    tr.removeClass('shown');
                    $(tr).find('i[class^="icon-chevron"]').attr('class', 'icon-chevron-sign-right dropDetail');
                }
            });
        });
    });

    function formatVSD(d) {
        var html = "";
        if (typeof d !== "undefined") {
            var _d = JSON.parse(d.details);

            var detailrows = "";
            $.each(_d, function (i, x) {
                var rfq = "";
                if (x.rfq_id != 0 && x.rfq_id != null && x.rfq_id != "") {
                    rfq = '<a href="/procurement/rfq/detail.aspx?id=' + x.rfq_id + '" target="_blank" title="View Request For Quotation">' + x.rfq_no + '</a>';
                }
                detailrows += '<tr>' +
                    '<td class="quotation"><a href="/procurement/quotation/detail.aspx?id=' + x.q_id + '" target="_blank" title="View Quotation">' + x.q_no + '</a></td>' +
                    '<td class="rfq">' + rfq + '</td>' +
                    '<td class="business_partner"><a href="/procurement/businesspartner/detail.aspx?id=' + x.vendor + '" target="_blank" title="View Supplier">' + x.vendor_name + '</a></td>' +
                    '<td class="documents">' + x.quotations + '</td>';
                detailrows += '</tr > ';
            });
                
            html = '<table class="table table-bordered" cellpadding="5" cellspacing="0" style="border: 1px solid #ddd;">' +
                '<thead>' +
                '<tr>' +
                '<th>Quotation code</th>' +
                '<th>RFQ code</th>' +
                '<th>Supplier</th>' +
                '<th>Quotation file(s)</th>' +
                '</tr>' +
                '</thead> ' +
                '<tbody>' + detailrows + '</tbody>' +
                '</table>';
        }
        return html;
    }
</script>