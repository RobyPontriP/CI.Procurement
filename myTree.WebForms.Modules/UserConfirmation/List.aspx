<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="List.aspx.cs" Inherits="myTree.WebForms.Modules.UserConfirmation.List" %>
<%@ Register Src="~/UserConfirmation/uscReconfirmationForm.ascx" TagName="reconfirmationform" TagPrefix="uscReconfirmation" %>
<asp:Content ID="Content1" ContentPlaceHolderID="AppHead" runat="server">
    <title>User Confirmations</title>
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

        .select2 {
            min-width: 150px !important;
        }

        #ReconfirmationForm.modal-dialog {
            margin: auto 12%;
            width: 60%;
            height: 360px !important;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="AppBody" runat="server">
    <uscReconfirmation:reconfirmationform ID="reconfirmationForm" runat="server" />
    <div class="floatingBox" id="error-box" style="display: none">
        <div class="alert alert-error" id="error-message">
        </div>
    </div>
    <div class="row-fluid">
        <div class="floatingBox">
            <div class="container-fluid">
                <div class="control-group">
                    <label class="control-label">
                        Send date
                    </label>
                    <div class="controls">
                        <div class="input-prepend" style="margin-right:-32px;">
                            <input type="text" name="startDate" id="_startDate" data-title="Start date" data-validation="required" class="span8" readonly="readonly" placeholder="Start date" maxlength="11" <%--value="<%=startDate %>"--%> />
                            <span class="add-on icon-calendar" id="startDate"></span>
                        </div>
                        To&nbsp;&nbsp;&nbsp;
                        <div class="input-prepend">
                            <input type="text" name="endDate" id="_endDate" data-title="End date" data-validation="required" class="span8" readonly="readonly" placeholder="End date" maxlength="11" <%--value="<%=endDate %>"--%> />
                            <span class="add-on icon-calendar" id="endDate"></span>
                        </div>
                    </div>
                </div>
                <div class="control-group">
                    <label class="control-label">
                        View by
                    </label>
                    <div class="controls">
                        <input type="hidden" id="status" name="status" value="<%=status %>"/>
                        <select id="cboStatus" data-title="Status" data-validation="required" multiple="multiple" class="span6">
                        </select>
                    </div>
                </div>
                <div class="control-group">
                    <label class="control-label">
                        Purchase office
                    </label>
                    <div class="controls">
                        <select id="cboOffice" data-title="Purchase office" data-validation="required" name="cifor_office" class="span6">
                            <option value="-1">ALL CIFOR OFFICES</option>
                        </select>
                    </div>
                </div>
                <div class="control-group">
                    <div class="controls">
                        <button type="submit" id="btnSearch" class="btn btn-success">Search</button>
                    </div>
                </div>
                <div class="control-group last">
                    <div style="width: 98%; overflow-x: auto; display: block;">
                    <table id="tblItems" class="table table-bordered" style="border: 1px solid #ddd; overflow: auto;">
                        <thead>
                            <tr>
                                <th style="width:3%;"><i class="icon-chevron-sign-down dropAllDetail" title="Collapse/Expand detail(s)"></i></th>
                                <th>User confirmation code</th>
                                <th>Status</th>
                                <th>PO code</th>
                                <th>Send date</th>
                                <th>Confirm date</th>
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
    <script>
         <%--var isAdmin = "<%=authorized.admin?"true":"false"%>";--%>
        var isAdmin = "<%=userRoleAccess.RoleNameInSystem == "procurement_admin"?"true":"false"%>";
        isAdmin = (isAdmin === "true");

        <%--var isProcurementUser = "<%=authorized.procurement_user?"true":"false"%>";--%>
        var isProcurementUser = "<%=userRoleAccess.RoleNameInSystem == "procurement_user"?"true":"false"%>";
        isProcurementUser = (isProcurementUser === "true");

        <%--var isFinance = "<%=authorized.finance?"true":"false"%>";--%>
        var isProcurementUser = "<%=userRoleAccess.RoleNameInSystem == "finance"?"true":"false"%>";
        isFinance = (isFinance === "true");

        var isProcurement = false;
        if (isAdmin || isProcurementUser) {
            isProcurement = true;
        }

        var itemStatus = <%=itemStatus%>;

        var listStatus = <%=listStatus%>;
        var listOffice = <%=listOffice%>;
        var startDate = new Date("<%=startDate%>");
        var endDate = new Date("<%=endDate%>");
        var status = "<%=status%>";
        var cifor_office = "<%=cifor_office%>";

        var ucdata = <%=listUConfirmation%>;
        var tblItems = initTable();

        var ucDetail = <%=listUDetail%>;

        function initTable() {
            return $("#tblItems").DataTable({
                "bFilter": true, "bDestroy": true, "bRetrieve": true, "pagingType": 'full_numbers',
                "lengthMenu": [[50, 100, -1], [50, 100, "All"]],
                /*"fnRowCallback": function( nRow, aData, iDisplayIndex ) {  
                    $(nRow).css('background-color', aData.color_code);
                    $(nRow).css('color', aData.font_color);
                },*/
                data: ucdata,
                "aoColumns": [
                    {
                        "mDataProp": "uc_id"
                        , "mRender": function (d, type, row) {
                            return '<i class="icon-chevron-sign-down dropDetail" title="View detail(s)"></i>'
                        }
                    },
                    {
                        "mDataProp": "uc_id"
                        ,"mRender": function (d, type, row) {
                            var html = '<a href="/userconfirmation/detail.aspx?id=' + row.uc_id + '" title="View detail User confirmation" target="_blank">' + row.confirmation_code + '</a>';
                            return html;
                        }
                    },
                    { "mDataProp": "status" },
                    { "mDataProp": "po_no" },
                    { "mDataProp": "send_date" },
                    { "mDataProp": "confirm_date" },
                    {
                        "mDataProp": "details"
                        , "visible": false
                    },
                    {
                        "mDataProp": "send_date_order"
                        , "visible": false
                    },
                ],
                "iDisplayLength": 50,
                "bLengthChange": false,
                "drawCallback": function( settings ) {
                    OpenAllItems();
                }
                ,"columnDefs": [ {
                    "targets": [0],
                    "orderable": false,
                }]
                ,"order": [[ 7, "asc" ]]
            });
        }

        $(document).ready(function () {
            var x = status.split(",");
            var cboStatus = $("#cboStatus");
            generateCombo(cboStatus, listStatus, "status_id", "status_name", true);
            $(cboStatus).val(x);
            Select2Obj(cboStatus, "Status");

            $("#cboStatus").on('select2:select select2:unselect', function (e) {
                var sel = $(this).val();
                if (sel.indexOf('-1') !== -1) {
                    sel = [-1];
                    $("#cboStatus").val(sel).trigger("change");
                }
                $("#status").val(sel.join(','));
            });

            var cboOffice = $("#cboOffice");
            generateComboGroup(cboOffice, listOffice, "office_id", "office_name", "hub_option", true);
            $(cboOffice).val(cifor_office);
            Select2Obj(cboOffice, "Purchase office");

            $("#startDate").datepicker({
                format: "dd M yyyy"
                , autoclose: true
            }).on("changeDate", function () {
                $("#_startDate").val($("#startDate").data("date"));
                $("#startDate").datepicker("hide");
            });

            $("#endDate").datepicker({
                format: "dd M yyyy"
                , autoclose: true
            }).on("changeDate", function () {
                $("#_endDate").val($("#endDate").data("date"));
                $("#endDate").datepicker("hide");
            });

            $("#startDate").datepicker("setDate", startDate).trigger("changeDate");
            $("#endDate").datepicker("setDate", endDate).trigger("changeDate");

            OpenAllItems();
            $('#tblItems_filter input').unbind();
            $('#tblItems_filter input').bind('keyup', function (e) {
                if (e.keyCode == 13) {
                    tblItems.search(this.value).draw();	
                }
            });	

            $(window).keydown(function(event){
                if(event.keyCode == 13) {
                    event.preventDefault();
                    return false;
                }
            });

            $('#tblItems tbody').on('click', 'i[class^="icon-chevron"]', function () {
                if (!$(this).hasClass('no-sort') && !$(this).hasClass('dropAllDetail')) {
                    var tr = $(this).closest('tr');
                    var row = tblItems.row(tr);

                    $(this).attr('class', '');
                    if (row.child.isShown()) {
                        row.child.hide();
                        tr.removeClass('shown');
                        $(this).attr('class', 'icon-chevron-sign-right dropDetail');
                    } else {
                        row.child(showItemDetail(row.data())).show();
                        tr.addClass('shown');
                        $(this).attr('class', 'icon-chevron-sign-down dropDetail');
                    }
                    normalizeMultilines();
                }
            });

            $.each(tblItems.rows().nodes(), function (i) {
                var row = tblItems.row(i)
                if(!row.child.isShown()){
                    row.child(showItemDetail(row.data())).show();
                    $(row.node()).addClass('shown');
                    normalizeMultilines();
                }
            });

            // Handle click on "Collapse All" button
            $('#btn-hide-all-children').on('click', function(){
                tblItems.rows().every(function(){
                    if(this.child.isShown()){
                        this.child.hide();
                        $(this.node()).removeClass('shown');
                    }
                });
                normalizeMultilines();
            });
        });

        $(document).on("click", ".dropAllDetail", function () {
            var isShown = false;
            if ($(this).hasClass('icon-chevron-sign-right')) {
                isShown = true;
            } else if ($(this).hasClass('icon-chevron-sign-down')) {
                isShown = false;
            }
            $.each(tblItems.rows().nodes(), function (i) {
                var tr = $(this).closest('tr');
                var row = tblItems.row(i);

                if (!isShown) {
                    row.child.hide();
                    $(row.node()).removeClass('shown');
                    $(tr).find('i[class^="icon-chevron"]').attr('class', 'icon-chevron-sign-right dropDetail');
                }
                else if (isShown) {
                    row.child(showItemDetail(row.data())).show();
                    $(row.node()).addClass('shown');
                    $(tr).find('i[class^="icon-chevron"]').attr('class', 'icon-chevron-sign-down dropDetail');
                }
            });

            if (isShown) {
                $(this).attr('class', 'icon-chevron-sign-down dropAllDetail');
            } else {
                $(this).attr('class', 'icon-chevron-sign-right dropAllDetail');
            }
            normalizeMultilines();
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
                html = '<table class="table table-bordered" style="border: 1px solid #ddd;  margin-left:10px; width:95%; overflow: auto;"><thead>';
                html += '<tr>';
                html += '<th class="wrapCol">PR code</th>';
                html += '<th class="wrapCol">Requester/ Initiator</th>';
                html += '<th class="wrapCol">Item code</th>';
                html += '<th class="wrapCol" style="width:15%;">Item description</th>';
                html += '<th class="wrapCol">Unit</th>';
                html += '<th class="wrapCol" style="text-align:right;">PR quantity</th>';
                html += '<th class="wrapCol" style="text-align:right;">Delivery quantity</th>';
                html += '<th class="wrapCol" style="text-align:right;">Accept quantity</th>';
                html += '<th class="wrapCol" style="text-align:right;">Rejected quantity</th>';
                html += '<th class="wrapCol">Remarks</th>';
                html += '<th class="wrapCol">Status</th>';
                html += '<th class="wrapCol">Confirm by</th>';
                html += '<th class="wrapCol">Confirm date</th>';
                html += '<th class="wrapCol">&nbsp;</th>';
                html += '</tr>';
                html += '</thead><tbody>';

                var item = JSON.parse(d.details);

                $.each(item, function (i, x) {
                    html += '<tr class="confirm_id" data-id="' + x.ucd_id + '">';
                    html += '<td class="wrapCol">' + x.pr_no + '</td>';
                    var requester = x.requester;
                    if (x.requester != x.created_by
                        && x.created_by != null
                        && x.created_by != "") {
                        requester += "/ <br/>" + x.created_by;
                    }
                    html += '<td class="wrapCol">' + requester + '</td>';
                    html += '<td class="wrapCol"><a href="/procurement/item/detail.aspx?id=' + x.item_id + '" target="_blank" title="View detail Item">' + x.item_code + '</a></td>';

                    html += '<td class="wrapCol">' + x.item_description + '</td>';
                    html += '<td class="wrapCol">' + x.uom + '</td>';
                    html += '<td class="wrapCol" style="text-align:right;">' + accounting.formatNumber(x.pr_quantity, 2) + '</td>';
                    html += '<td class="wrapCol" style="text-align:right;">' + accounting.formatNumber(x.send_quantity, 2) + '</td>';
                    html += '<td class="wrapCol" style="text-align:right;">' + accounting.formatNumber(x.quantity, 2) + '</td>';
                    html += '<td class="wrapCol" style="text-align:right;">' + accounting.formatNumber(x.reject_quantity, 2) + '</td>';
                    html += '<td class="wrapCol">' + x.remarks + '</td>';
                    html += '<td class="wrapCol">' + x.status_detail + '</td>';
                    html += '<td class="wrapCol">' + x.confirm_user + '</td>';
                    html += '<td class="wrapCol">' + x.confirm_date + '</td>';
                    html += '<td class="wrapCol">' + x.reconfirm + '</td>';
                    html += '</tr>';
                });

                html += '</tbody></table>';
            }
            return html;
        }
        $(document).on("click", "#btnClose", function () {
            blockScreen();
          /*  parent.location.href = "main.aspx";*/
        });

        function resetReconfirm() {
            $("#additional_person").val("").trigger("change");
            $("#confirmation_code").html("");
            $("#pr_code").html("");
            $("#item_code").html("");
            $("#item_description").html("");
            $("#delivery_quantity").html("");
            $("#requester").html("");
            $("#initiator").html("");
            $("#uc_id").val("");
            $("#ucd_id").val("");
        }

        $(document).on("click", ".btnRevise", function () {
            resetReconfirm();
            var ucd_id = $(this).data("id");
            $("#ucd_id").val(ucd_id);

            var reconfirm = $.grep(ucDetail, function (n, i) {
                return n["ucd_id"] == ucd_id;
            });

            if (reconfirm.length > 0) {
                $("#confirmation_code").html(reconfirm[0].confirmation_code);
                $("#pr_code").html(reconfirm[0].pr_no);
                $("#item_code").html(reconfirm[0].item_code);
                $("#item_description").html(reconfirm[0].item_description);
                $("#delivery_quantity").html(accounting.formatNumber(reconfirm[0].send_quantity, 2)+" "+reconfirm[0].uom);
                $("#requester").html(reconfirm[0].requester);
                $("#initiator").html(reconfirm[0].created_by);
                $("#uc_id").val(reconfirm[0].uc_id);
            }

            $("#ReconfirmationForm").modal('show');

            setTimeout(ScrollConfirmation, 500);
        });

        $(document).on("click", "#btnReconfirm", function () {
            var data = new Object();
            data.id = $("#ucd_id").val();
            data.uc_id = $("#uc_id").val();
            data.additional_person = $("#additional_person").val();
            $.ajax({
                url: 'service.aspx/updateConfirmation',
                data: JSON.stringify(data),
                dataType: 'json',
                type: 'post',
                contentType: "application/json; charset=utf-8",
                success: function (response) {
                    var output = JSON.parse(response.d);
                    if (output.result !== "success") {
                        alert(output.message);
                    } else {
                        alert("Request for re-confirmation "+$.trim($("#confirmation_code").text())+" has been sent successfully.");
                        blockScreen();
                        location.reload();
                    }
                }
            });
        });

        function ScrollConfirmation() {
            var ctop = $("#ReconfirmationForm").offset().top;
            window.parent.$('html, #ReconfirmationForm').animate({ scrollTop: ctop }, 'slow');
        }
    </script>
</asp:Content>