<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="uscConfirmation.ascx.cs" Inherits="myTree.WebForms.Modules.PurchaseRequisition.uscConfirmation" %>
<div class="control-group last">
    <p><label>User confirmation</label></p>
        <table id="tblUserConfirmations" class="table table-bordered table-hover" style="border: 1px solid #ddd; width:100%;">
            <thead>
                <tr>
                    <th>User confirmation code</th>
                    <th>Status</th>
                    <th>Send date</th>
                    <th>Confirm date</th>
                </tr>
            </thead>
            <tbody>
            </tbody>
        </table>
    <p></p>
</div>
<script>
    var listPOConfirm = <%=listPRConfirm%>;
    $(document).ready(function(){
        $('#tblUserConfirmations').dataTable({
            "bDestroy": true, "bRetrieve": true, "pagingType": 'full_numbers',
            bLengthChange: false,
            bFilter: false,
            bSort: false,
            iDisplayLength: 20,
            "aaData": listPOConfirm,
            "aoColumns": [
                {
                    "mDataProp": "id"
                    , "mRender": function (d, type, row) {
                        return '<a href="userconfirmation/detail.aspx?id=' + row.id + '" target="_blank">' + row.confirmation_code + '</a>';
                    }
                },
                { "mDataProp": "status" },
                { "mDataProp": "send_date" },
                { "mDataProp": "confirm_date" },
            ],
        });
    });
</script>