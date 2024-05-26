<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="uscFinancialReport.ascx.cs" Inherits="myTree.WebForms.Modules.PurchaseRequisition.uscFinancialReport" %>
<div class="control-group">
    <p><label>Transactions related to this PR</label></p>
        <table id="tblJournal" class="table table-bordered table-hover" style="border: 1px solid #ddd; width:100%;">
            <thead>
                <tr>
                    <th>Journal number</th>
                    <th>Journal type</th>
                    <th>Journal source</th>
                    <th>Period</th>
                    <th>Transaction date</th>
                    <th>Account</th>
                    <th>Charge code</th>
                    <th>Description</th>
                    <th>Currency</th>
                    <th>Other amount (in original currency)</th>
                    <th>Amount in USD</th>
                </tr>
            </thead>
            <tbody>
            </tbody>
            <tfoot>
                <tr>
                    <th colspan="9" style="text-align:right;">Total</th>
                    <th style="text-align:right;" id="JournalTotal"></th>
                    <th style="text-align:right;" id="JournalTotalUSD"></th>
                </tr>
            </tfoot>
        </table>
    
    <p></p>
    <% if ((usrFinance && statusId =="50" && is_show_btneditjournal) || (UserId == "PThayib" || UserId == "cifor-sysdev31") || (UserId == "JManangkil" || UserId == "cifor-sysdev7"))
        { %>
        <br />
        <button type="button" id="btnEditjournalno" class="btn btn-success btn-small">Edit journal number</button>
    <%} %>
</div>
<div class="control-group last">
    <p><label>GRM related to this PR</label></p>
    <table id="tblGRM" class="table table-bordered table-hover" style="border: 1px solid #ddd">
        <thead>
            <tr>
                <th>GRM OCS code</th>
                <th>GRM date</th>
                <th>User who performed GRM</th>
                <th>Confirmed quantity</th>
                <th>Description</th>
                <th>User confirmation</th>
                <th>PO Code</th>
            </tr>
        </thead>
        <tbody>
        </tbody>
    </table>
    <p></p>
</div>
<script>
    var listJournal = <%=listJournal%>;
    var listGRM = <%=listGRM%>;
    var _id = <%=_id%>;
    var workflow = new Object();
    $(document).ready(function(){
        $('#tblJournal').dataTable({
            "bDestroy": true, "bRetrieve": true, "pagingType": 'full_numbers',
            bLengthChange: false,
            bFilter: false,
            bSort: false,
            iDisplayLength: 20,
            "aaData": listJournal,
            "aoColumns": [
                { "mDataProp": "JRNAL_NO" },
                { "mDataProp": "JRNAL_TYPE" },
                { "mDataProp": "JRNAL_SRCE" },
                { "mDataProp": "PERIOD" },
                { "mDataProp": "TRANS_DATE" },
                { "mDataProp": "ACCNT_CODE" },
                { "mDataProp": "COST_CENTER" },
                { "mDataProp": "DESCRIPTN" },
                { "mDataProp": "CONV_CODE" },
                {
                    "mDataProp": "OTHER_AMT"
                    , "mRender": function (d, type, row) {
                        return accounting.formatNumber(row.OTHER_AMT, 2);
                    }
                },
                {
                    "mDataProp": "AMOUNT"
                    , "mRender": function (d, type, row) {
                        return accounting.formatNumber(row.AMOUNT, 2);
                    }
                },
            ],
            columnDefs: [
                {
                    targets: [9,10],
                    className: 'dt-body-right'
                }
            ]
        });

        var total = 0
            ,totalUSD = 0;
        $.each(listJournal, function (i, d) {
            total += delCommas(d.OTHER_AMT);
            totalUSD += delCommas(d.AMOUNT);
        });

        total = accounting.formatNumber(total, 2);
        totalUSD = accounting.formatNumber(totalUSD, 2);

        $("#JournalTotal").html("<b>" + total + "</b>");
        $("#JournalTotalUSD").html("<b>" + totalUSD + "</b>");

        $(document).on("click", "#btnEditjournalno", function () {  
            location.href = "payment.aspx?id=" + _id;
        });

        $('#tblGRM').dataTable({
            "bDestroy": true, "bRetrieve": true, "pagingType": 'full_numbers',
            bLengthChange: false,
            bFilter: false,
            bSort: false,
            iDisplayLength: 20,
            "aaData": listGRM,
            "aoColumns": [
                { "mDataProp": "RCVN_TXN_REF" },
                { "mDataProp": "GRM_DATE" },
                { "mDataProp": "GRM_USER" },
                {
                    "mDataProp": "ACCEPTED_QTY"
                    , "mRender": function (d, type, row) {
                        return accounting.formatNumber(row.ACCEPTED_QTY, 2);
                    }
                },
                { "mDataProp": "GRM_DESCR" },
                { "mDataProp": "CONFIRM_LINK" },
                { "mDataProp": "PO_CODE" },
            ],
            columnDefs: [
                {
                    targets: 3,
                    className: 'dt-body-right'
                }
            ]
        });
    });
</script>