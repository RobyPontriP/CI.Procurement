<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="uscHistoricalInformation.ascx.cs" Inherits="myTree.WebForms.Modules.PurchaseRequisition.uscHistoricalInformation" %>

<div class="control-group last">
    <table id="tblHistorical" class="table table-bordered table-hover" style="border: 1px solid #ddd">
        <thead>
            <tr>
                <th>Stage</th>
                <th>Code</th>
                <th>Status</th>
                <th>Updated by</th>
                <th>Updated date</th>
            </tr>
        </thead>
        <tbody>
        </tbody>
    </table>
</div>
<script>
    var data = <%=ListHistorical%>;
    $(document).ready(function(){
        oTable = $('#tblHistorical').dataTable({
            "bDestroy": true, "bRetrieve": true, "pagingType": 'full_numbers',
            bLengthChange: false,
            bFilter: false,
            bSort: false,
            iDisplayLength: 20,
            "aaData": data,
            "aoColumns": [
                { "mDataProp": "module_label" },
                {
                    "mDataProp": "module_code"
                    , "mRender": function (d, type, row) {
                        var link = "";
                        if (String(row.module_name).toLowerCase() === "purchase requisition") {
                            link += "purchaserequisition/"
                        }
                        else if (String(row.module_name).toLowerCase() === "request for quotation") {
                            link += "rfq/"
                        }
                        else if (String(row.module_name).toLowerCase() === "quotation") {
                            link += "quotation/"
                        }
                        else if (String(row.module_name).toLowerCase() === "vendor selection" || String(row.module_name).toLowerCase() === "quotation analysis" || String(row.module_name).toLowerCase() === "single sourcing") {
                            link += "quotationanalysis/"
                        }
                        else if (String(row.module_name).toLowerCase() === "purchase order" || String(row.module_name).toLowerCase() === "purchase order fundscheck") {
                            link += "purchaseorder/"
                        }
                        link += "detail.aspx?id=" + row.module_id;
						var html = "";
						if(String(row.module_name).toLowerCase() === "goods received matching"){
							html = row.module_code;
						}else{
                            /*html = '<a href="' + link + '" title="View detail">' + row.module_code + '</a>';*/
                            html = '<a href="' + '<%= Page.ResolveUrl("~/" + based_url + "/") %>' + link + '" title="View detail">' + row.module_code + '</a>';
                        }
                        if (String(row.module_name).toLowerCase() === "receipt" || String(row.module_name).toLowerCase() === "invoice") {
                            html = row.module_code
                        }
                        return html;
                    }
                },
                { "mDataProp": "status_name" },
                { "mDataProp": "updated_by" },
                { "mDataProp": "updated_date" },
            ]
        });
    });
</script>