<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="uscFinancialReport.ascx.cs" Inherits="Procurement.PurchaseOrder.uscFinancialReport" %>
<div class="control-group">
    <p><label>Receipt information</label></p>
        <table id="tblReceipt" class="table table-bordered table-hover" style="border: 1px solid #ddd; width:100%;">
            <thead>
                <tr>
                    <th width="5%">Order line</th>
                    <th width="5%">Receipt no</th>
                    <th width="10%">Received by</th>
                    <th width="10%">External ref</th>
                    <th width="10%">Receipt date</th>
                    <th width="10%">Product</th>
                    <th width="10%">Product description</th>
                    <th width="5%">Quantity</th>
                    <th width="25%">Amount (USD)</th>
                </tr>
            </thead>
            <tbody>
            </tbody>
            <tfoot>
                <tr>
                    <th colspan="8" style="text-align:left!important;">Total</th>
                    <th style="text-align:right;" id="ReceiptTotal"></th>
                    <%--<th style="text-align:right;" id="JournalTotalUSD"></th>--%>
                </tr>
            </tfoot>
        </table>
    
    <p></p>
</div>
<div class="control-group last">
    <p><label>Invoice information</label></p>
    <table id="tblInvoice" class="table table-bordered table-hover" style="border: 1px solid #ddd">
        <thead>
            <tr>
                <%--<th>Invoice history</th>--%>
                <th>TT</th>
                <th>Transaction date</th>
                <th>Transaction number</th>
                <th>Invoice no</th>
                <th>Period</th>
                <th>Account</th>
                <th>Cat 1</th>
                <th>Cat 2</th>
                <th>Curr. amount (<span id="currencyInvoice"></span>)</th>
            </tr>
        </thead>
        <tbody>
        </tbody>
         <tfoot>
                <tr>
                    <th colspan="8" style="text-align:left!important;">Total</th>
                    <th style="text-align:right;" id="InvoiceTotal"></th>
                    <%--<th style="text-align:right;" id="JournalTotalUSD"></th>--%>
                </tr>
            </tfoot>
    </table>
    <p></p>
</div>
<script>
    var listInvoice = <%=listInvoice%>;
    var listReceipt = <%=listReceipt%>;
    $(document).ready(function(){
        $('#tblInvoice').dataTable({
            "bDestroy": true, "bRetrieve": true, "pagingType": 'full_numbers',
            bLengthChange: false,
            bFilter: false,
            bSort: false,
            iDisplayLength: 20,
            "aaData": listInvoice,
            "aoColumns": [
                //{ "mDataProp": "InvoiceHistory" },
                { "mDataProp": "TT" },
                { "mDataProp": "TransactionDate" },
                { "mDataProp": "TransactionNumber" },
                { "mDataProp": "InvoiceNo" },
                { "mDataProp": "Period" },
                { "mDataProp": "Account" },
                { "mDataProp": "Category1" },
                { "mDataProp": "Category2" },
                {
                    "mDataProp": "AmountCurrency"
                    , "mRender": function (d, type, row) {
                        return accounting.formatNumber(row.AmountCurrency, 2);
                    }
                },

            ],
            columnDefs: [
                {
                    targets: [8],
                    className: 'dt-body-right'
                }
            ]
        });

        $('#tblReceipt').dataTable({
            "bDestroy": true, "bRetrieve": true, "pagingType": 'full_numbers',
            bLengthChange: false,
            bFilter: false,
            bSort: false,
            iDisplayLength: 20,
            "aaData": listReceipt,
            "aoColumns": [
                { "mDataProp": "OrderLine" },
                { "mDataProp": "ReceiptNo" },
                { "mDataProp": "ReceivedBy" },
                { "mDataProp": "ExternalRef" },
                { "mDataProp": "ReceiptDate" },
                { "mDataProp": "Product" },
                { "mDataProp": "ProductDescription" },
                {
                    "mDataProp": "Quantity"
                    , "mRender": function (d, type, row) {
                        return  accounting.formatNumber(row.Quantity, 2);
                    }
                },
                {
                    "mDataProp": "Amount"
                    , "mRender": function (d, type, row) {
                        return accounting.formatNumber(row.Amount, 2);
                    }
                },
      
            ],
            columnDefs: [
                {
                    targets: [7,8],
                    className: 'dt-body-right'
                }
            ]
        });

        var totalReceipt = 0
            ,totalInvoice = 0, currencyTotalInvoice = '';

        $.each(listReceipt, function (i, d) {
            totalReceipt += delCommas(d.Amount);
        });

        $.each(listInvoice, function (i, d) {
            totalInvoice += delCommas(d.AmountCurrency);
            currencyTotalInvoice = d.CurrencyID;
        });

        totalReceipt = accounting.formatNumber(totalReceipt, 2);
        totalInvoice = accounting.formatNumber(totalInvoice, 2);

        $("#ReceiptTotal").html("<b>" + totalReceipt + "</b>");
        $("#InvoiceTotal").html("<b>" + totalInvoice + "</b>");
        $("#currencyInvoice").html(currencyTotalInvoice);
    });
</script>