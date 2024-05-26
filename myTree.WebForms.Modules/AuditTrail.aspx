<%@ Page MasterPageFile="~/Procurement.Master" Language="C#" AutoEventWireup="true" CodeBehind="AuditTrail.aspx.cs" Inherits="myTree.WebForms.Modules.AuditTrail" %>

<asp:Content ID="Content1" ContentPlaceHolderID="AppHead" runat="server">
    <title>Audit Trail</title>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="AppBody" runat="server">
<style>
    .wrapCol {
        word-wrap:break-word;
    }
</style>
<div class="row-fluid">
    <div class="span12 tabContainer">
        <ul class="nav nav-tabs" id="AuditTrailTab">
            <li id="l_comment" class="active"><a href="#tabComment">Recent comments</a></li>
            <li id="l_changes"><a href="#tabChanges">Changes</a></li>
        </ul>
        <div class="container-fluid">
            <div class="tabContent" id="tabComment" style="display: block;">
                <div class="control-group">
                    <table class="table table-bordered table-striped" style="width:100%; table-layout:fixed;" id="tblComments">
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
            <div class="tabContent" id="tabChanges" style="display: none;">
                <div class="control-group">
                    <div class="span12">
                        <table class="table table-bordered table-striped" id="tblChanges" style="width:100%;  table-layout:fixed;">
                            <thead>
                                <tr>
                                    <th style="width:3%;">
                                        &nbsp;
                                    </th>
                                    <th style="width:15%;">
                                        User
                                    </th>
                                    <th style="width:15%;">
                                        Date - time
                                    </th>
                                    <th style="width:10%;">
                                        Type
                                    </th>
                                    <th style="width:17%;">
                                        Field
                                    </th>
                                    <th style="width:20%;">
                                        Previous value
                                    </th>
                                    <th style="width:20%;">
                                        New value
                                    </th>
                                </tr>
                            </thead>
                            <tbody>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<script>
    const module = "<%=module%>";
    const dataComment = <%=listComment%>;
    const dataChanges = <%=listChanges%>;

    let tComments = null;
    let tChanges = null;
    let detailRows = [];

    $(document).ready(function () {
        let isVisible = false;
        switch (module.toLowerCase()) {
            case "brand":
            case "category":
            case "item":
            case "vendor":
            case "directpurchase":
            case "userconfirmation":
                $("#l_comment").hide();
                $("#l_comment").removeClass("active");
                $("#l_changes").addClass("active");
                $("#tabComment").hide();
                $("#tabChanges").show();
                break;
            case "purchaserequisition":
            case "requestforquotation":
            case "vendorselection":
                isVisible = true;
                break;
            default:
                break;
        }

        tComments = $('#tblComments').dataTable({
            "bDestroy": true, "bRetrieve": true, "pagingType": 'full_numbers',
            bLengthChange: false,
            bFilter: false,
            bSort: false,
            iDisplayLength: 5,
            "aaData": dataComment,
            "aoColumns": [
                { "mDataProp": "emp_user_id" },
                {
                    "mDataProp": "roles"
                    ,"visible": isVisible
                },
                { "mDataProp": "created_date" },
                { "mDataProp": "action_taken" },
                {
                    "mDataProp": "comment"
                    , "mRender": function (d, type, row) {
                        let html = row.comment;
                        if(row.comment_file_link!="" && row.comment!="")
                        {
                            html = row.comment + '<br/>' + row.comment_file_link;
                        }else if(row.comment_file_link!="" && row.comment=="")
                        {
                            html = row.comment_file_link;
                        }
                        return html;
                    }
                }
            ],
            "columnDefs": [ 
                {className: "wrapCol", "targets":[0, 1, 2, 3, 4]}
            ],
        });

        tChanges = $("#tblChanges").DataTable({
            "aaData": dataChanges,
            "aoColumns": [
                {
                    "mDataProp": "id"
                    , "mRender": function (d, type, row) {
                        let html = "";
                        if(row.sub_module!="" && row.sub_module.toLowerCase() != "purchaserequisitionjournalno")
                        {
                            html = '<i class="icon-chevron-sign-right dropDetail" title="View detail(s)"></i>';
                        }
                        return html;
                    }
                },
                { "mDataProp": "change_by" },
                { "mDataProp": "change_time_label" },
                { "mDataProp": "change_type_name" },
                { "mDataProp": "field_name" },
                { "mDataProp": "previous_value" },
                { "mDataProp": "new_value" },
                { "mDataProp": "sub_module", "visible": false },
                { "mDataProp": "rec_id", "visible": false },
                { "mDataProp": "module_id", "visible": false },
                { "mDataProp": "change_time", "visible": false },
                { "mDataProp": "module_name", "visible": false },
                { "mDataProp": "change_type", "visible": false },
                { "mDataProp": "approval_no", "visible": false }
            ],
            "bFilter": true, "bDestroy": true, "bRetrieve": true, "pagingType": 'full_numbers',
            "columnDefs": [ {
                "targets": [0],
                "orderable": false,
            },
                {className: "wrapCol", "targets":[0, 1, 2, 3, 4, 5, 6]}
            ],
            "aaSorting": [[10, "desc"]],
            "iDisplayLength": 10,
            "bLengthChange": false
        });
    });

    $('#tblChanges tbody').on('click', 'i', function() {
        let oTable = null;
        oTable = tChanges;

        let tr = $(this).closest('tr');
        let row = oTable.row(tr);
        let dataRow = oTable.row(tr).data();

        let status_detail = dataRow.sub_module || '';
        
        let isHaveDetail = true;
        if (status_detail == "") {
            isHaveDetail = false;
        }

        let data = {
            module_id: dataRow.module_id,
            module_name: dataRow.module_name,
            change_type: dataRow.change_type,
            sub_module: dataRow.sub_module,
            rec_id: dataRow.rec_id,
            change_time: dataRow.change_time,
            approval_no: dataRow.approval_no
        };

        let idx = $.inArray(tr.attr('id'), detailRows);

        oTable.on('draw', function() {
            $.each(detailRows, function(i, id) {
                $('#' + id + ' td.details-control').trigger('click');
            });
        });

        if (isHaveDetail) {
            if (row.child.isShown()) {
                $(this).attr('class', '');
                $(this).attr('class', 'icon-chevron-sign-right dropDetail');
                tr.removeClass('details');
                row.child.hide();
                detailRows.splice(idx, 1);
            }
            else {
                $(this).attr('class', '');
                $(this).attr('class', 'icon-chevron-sign-down dropDetail');
                tr.addClass('details');
                
                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    url: "AuditTrail.aspx/GetDetail",
                    data: JSON.stringify(data),
                    dataType: "json",
                    success: function(response) {
                        let result = response.d;
                        if (result.length > 0) {
                            result = '<div style="width: 97%; overflow-x: auto;">' + result + '</div>';
                            row.child(result).show();
                        } else {
                            let html = '<table class="table-stripped table-bordered" width="100%">';
                            html += '<tr><td>No activity data</td></tr>';
                            html += '</table>';

                            row.child(html).show();
                        }
                    },
                    error: function() {

                    }
                });
                // Add to the 'open' array
                if (idx === -1) {
                    detailRows.push(tr.attr('id'));
                }
            }
        }
    });
</script>
</asp:Content>
