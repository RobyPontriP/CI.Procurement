<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="uscRecentComment.ascx.cs" Inherits="myTree.WebForms.Modules.Usc.uscRecentComment" %>
<div id="headerRecentComment" class="containerHeadline accordion-toggle" data-toggle="collapse" data-target="#detailRecentComment">
    <h2>Recent comment(s)</h2>
</div>
<div class="accordion-body collapse" id="detailRecentComment" style="margin-bottom:30px;">
    <div class="floatingBox table" style="margin-bottom:0px;">
        <div class="container-fluid">
            <div style="font-style:italic;padding-bottom:0;">Starting Jan 2023, all CIFOR-ICRAF business system servers are using UTC standard time</div>
            <table id="tblComments" class="table table-bordered table-striped" style="border: 1px solid #ddd;">
                <thead>
                    <tr>
                        <th style="width:15%;">
                            Name
                        </th>
                        <th style="width:25%;">
                            Role
                        </th>
                        <th style="width:15%;">
                            Date
                        </th>
                        <th style="width:15%;">
                            Action taken
                        </th>
                        <th style="width:30%;">
                            Comments
                        </th>
                    </tr>
                </thead>
                <tbody>
                </tbody>
            </table>
        </div>
    </div>
</div>
<script type="text/javascript">
    var recentComments = <%=listComments%>;
    var isVisible = "<%=(moduleName.ToLower()=="purchase requisition" || moduleName.ToLower()=="purchase order" || moduleName.ToLower()=="vendor selection")?"true":"false"%>";
    isVisible = (isVisible === "true");

    $(document).ready(function () {
        oTable = $('#tblComments').dataTable({
            "bDestroy": true, "bRetrieve": true, "pagingType": 'full_numbers',
            bLengthChange: false,
            bFilter: false,
            bSort: false,
            iDisplayLength: 5,
            "aaData": recentComments,
            "aoColumns": [
                { "mDataProp": "emp_user_id" },
                {
                    "mDataProp": "roles"
                    ,"visible": isVisible
                },
                { "mDataProp": "created_date" },
                { "mDataProp": "action_taken" },
                { "mDataProp": "comment" }
            ]
        });

        /*$.each(recentComments, function (i, d) {
            $("#tblComments tbody").append('<tr><td>'+d.emp_user_id+'</td><td>'+d.roles+'</td><td>'+d.created_date+'</td><td>'+d.action_taken+'</td><td>'+d.comment+'</td></tr>');
        });*/

        var status_id = $("#status").val();
        if (status_id === "") {
            $("#headerRecentComment").hide();
            $("#detailRecentComment").hide;
            $("#detailRecentComment").css("margin-bottom", "0px");
        } else {
            $("#detailRecentComment").addClass("in");
        }
    });
</script>