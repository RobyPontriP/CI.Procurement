<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="uscItemData.ascx.cs" Inherits="myTree.WebForms.Modules.UserConfirmation.uscItemData" %>
<div class="control-group">
    <table id="tblItem" class="table table-bordered" style="border: 1px solid #ddd; width:100%;">
        <thead>
            <tr>
                <th>PR code</th>
                <th>RFQ code</th>
                <th>Quotation code</th>
                <th>Business partner selection code</th>
                <th>Requester</th>
            </tr>
        </thead>
        <tbody>
        </tbody>
    </table>
    <p></p>
</div>
<script>
    var listHeader = <%= listHeader%>;
    var listItem = <%=listItem%>;
    var tblItems = initTable();

    var page_type = "<%=page_type%>";

    function initTable() {
        return $("#tblItem").DataTable({
            data: listHeader,
            "aoColumns": [
                {
                    "mDataProp": "pr_id"
                    ,"mRender": function (d, type, row) {
                        var html = '<a href="purchaserequisition/detail.aspx?id=' + row.pr_id + '" title="View detail Purchase requisition" target="_blank">' + row.pr_no + '</a>';
                        return html;
                    }
                },
                {
                    "mDataProp": "rfq_id"
                    ,"mRender": function (d, type, row) {
                        var html = '<a href="RFQ/detail.aspx?id=' + row.rfq_id + '" title="View detail RFQ" target="_blank">' + row.rfq_no + '</a>';
                        return html;
                    }
                },
                {
                    "mDataProp": "q_id"
                    ,"mRender": function (d, type, row) {
                        var html = '<a href="quotation/detail.aspx?id=' + row.q_id + '" title="View detail Quotation" target="_blank">' + row.q_no + '</a>';
                        return html;
                    }
                },
                {
                    "mDataProp": "vs_no"
                    ,"mRender": function (d, type, row) {
                        var html = '<a href="vendorselection/detail.aspx?id=' + row.vs_id + '" title="View detail Business partner selection" target="_blank">' + row.vs_no + '</a>';
                        return html;
                    }
                },
                { "mDataProp": "requester"},
            ],
            "bFilter": false, "bDestroy": true, "bRetrieve": true,
            "searching": false,
            "info": false,
            "ordering": false,
            "paging": false,
            "drawCallback": function( settings ) {
                OpenAllItems();
            }
        });
    }

    $(document).ready(function () {
        OpenAllItems();
        repopulateNumber();
    });

    function OpenAllItems() {
        if (typeof tblItems !== "undefined") {
            $.each(tblItems.rows().nodes(), function (i) {
                var row = tblItems.row(i)
                if (typeof row.data() !== "undefined") {
                    if (!row.child.isShown()) {
                        row.child(showItemDetail(row.data())).show();
                        $(row.node()).addClass('shown');
                    }
                }
            });
            normalizeMultilines();
        }
    }

    function showItemDetail(d) {
        var html = '';
        if (typeof d !== "undefined") {
            html = '<table class="table table-bordered" style="border: 1px solid #ddd;  margin-left:10px;"><thead>';
            html += '<tr>';
            html += '<th>Item code</th>';
            html += '<th>Item description</th>';
            html += '<th style="text-align:right;">Quantity based on PR</th>';
            html += '<th style="text-align:right;">Quantity send by business partner</th>';
            html += '<th>UOM</th>';
            html += '</tr>';
            html += '</thead><tbody>';

            var item = $.grep(listItem, function (n, i) {
                return n["unique_id"] == d.unique_id;
            });

            $.each(item, function (i, x) {
                html += '<tr class="confirm_id" data-id="' + x.id + '">';
                html += '<td><a href="item/detail.aspx?id=' + x.item_id + '" target="_blank" title="View detail Item">' + x.item_code + '</a></td>';
                html += '<td>' + x.item_description + '</td>';
                html += '<td style="text-align:right;">' + accounting.formatNumber(x.pr_quantity, 2) + '</td>';
                html += '<td style="text-align:right;">' + accounting.formatNumber(x.send_quantity, 2) + '</td>';
                html += '<td>' + x.uom + '</td>';
                html += '</tr>';
                
                var qty = "";
                var qly = "";
                if (page_type.toLowerCase() != "submission") {
                    qty = accounting.formatNumber(delCommas(x.quantity), 2);
                    qly = x.quality;
                } else {
                    if (x.quantity == 0) {
                        x.quantity = x.send_quantity;
                    }
                    qty = '<input type="text" data-validation="required number" data-decimal-places="2" data-title="Confirmed quantity for ' + x.item_code + '" class="number span2" data-maximum="' + delCommas(x.send_quantity) + '" data-maximum-attr="quantity" data-description="' + x.item_code + '"  max-length="10" name="confirmed_quantity_' + x.id + '" data-id="' + x.id + '" placeholder="Confirmed quantity" value="' + delCommas(x.quantity) + '"/>'
                    qly = '<textarea data-validation="required" data-title="Quality of ' + x.item_code + '" name="quality_' + x.id + '" max-length="2000" data-id="' + x.id + '" rows="3" class="span10 textareavertical" placeholder="Quality">' + x.quality + '</textarea>';
                }
                html += '<tr><td>Confirmed quantity<span style="color:red;">*</span></td>';
                html += '<td colspan="4">' + qty + ' ' + x.uom + '</td>';
                html += '</tr><tr>';
                html += '<td>Quality<span style="color:red;">*</span></td>';
                html += '<td colspan="4">' + qly + '</td>';
                html += '</tr><tr>';
                html += '<td>Status</td>';
                var confirm_by = "";
                if (x.status_id == 50) {
                    confirm_by = " by " + x.user_name + " at " + x.confirm_date;
                }
                html += '<td colspan="4"><b>' + x.status_name + '</b> ' + confirm_by + '</td>';
                html += '</tr><tr><td colspan="5"></td></tr>';
            });

            html += '</tbody></table>';
        }
        return html;
    }
</script>
