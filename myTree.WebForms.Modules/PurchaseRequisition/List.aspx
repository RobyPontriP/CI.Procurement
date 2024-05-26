<%@ Page MasterPageFile="~/Procurement.Master" Language="C#" AutoEventWireup="true" CodeBehind="List.aspx.cs" Inherits="myTree.WebForms.Modules.PurchaseRequisition.List" %>

<%@ Register Src="~/UserConfirmation/uscSendConfirmation.ascx" TagName="confirmationform" TagPrefix="uscConfirmation" %>

<asp:Content ID="Content1" ContentPlaceHolderID="AppHead" runat="server">
    <title>Purchase Requisitions</title>
    <style>
        .sorting_1 {
            background-color: inherit !important;
        }

        .legend-block {
            min-width: 10px !important;
            min-height: 10px !important;
            padding-left: 25px;
        }

        .legend {
            font-size: 70%;
            clear: both;
            margin-bottom: 10px;
        }

        span.label {
            display: block;
            margin-bottom: 3px;
        }

        span.status.label {
            display: inline-block;
            margin-bottom: 3px;
        }

        /* Show the dropdown menu on hover */
        .icndrop:hover
        .dropdown-menu {
            display: inline-block;
        }

        div.dropdown {
            display: inline-block;
        }

        .select2-selection__choice {
            text-align: left;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="AppBody" runat="server">
    <div id="ConfirmationForm" class="modal hide fade modal-dialog" role="dialog" aria-labelledby="header1" aria-hidden="true"
        data-backdrop="static" data-keyboard="false">
        <div class="modal-header">
            <button type="button" class="close" data-dismiss="modal" aria-hidden="true"></button>
            <h3 id="header1">Request for user confirmation</h3>
        </div>
        <div class="modal-body">
            <div class="floatingBox" id="ucform-error-box" style="display: none">
                <div class="alert alert-error" id="ucform-error-message">
                </div>
            </div>
            <uscConfirmation:confirmationform ID="confirmationForm" runat="server" />
        </div>
        <div class="modal-footer">
            <button type="button" class="btn btn-success" aria-hidden="true" id="btnSendConfirmation" data-action="sent">Send confirmation</button>
            <button type="button" class="btn" data-dismiss="modal" aria-hidden="true">Close and cancel</button>
        </div>
    </div>
    <div class="floatingBox" id="error-box" style="display: none">
        <div class="alert alert-error" id="error-message">
        </div>
    </div>
    <div class="row-fluid">
        <div class="floatingBox">
            <div class="container-fluid">
                <div class="control-group">
                    <label class="control-label">
                        Submission date
                    </label>
                    <div class="controls">
                        <div class="input-prepend" style="margin-right: -32px;">
                            <input type="text" name="startDate" id="_startDate" data-title="Start date" data-validation="required" class="span8" readonly="readonly" placeholder="Start date" maxlength="11" value="<%=startDate %>" />
                            <span class="add-on icon-calendar" id="startDate"></span>
                        </div>
                        To&nbsp;&nbsp;&nbsp;
                        <div class="input-prepend">
                            <input type="text" name="endDate" id="_endDate" data-title="End date" data-validation="required" class="span8" readonly="readonly" placeholder="End date" maxlength="11" value="<%=endDate %>" />
                            <span class="add-on icon-calendar" id="endDate"></span>
                        </div>
                    </div>
                </div>
                <div class="control-group">
                    <label class="control-label">
                        PR type
                    </label>
                    <div class="controls">
                        <select id="cboTypePR" data-title="Type purchase requisition" data-validation="required" name="type_PR" class="span6">
        
                                <option value="-1" selected>ALL PR</option>
                                <option value="0">PR FOR PROCUREMENT</option>
                                <option value="1">PR FOR FINANCE</option>

                        </select>
                    </div>
                </div>
                <div class="control-group">
                    <label class="control-label">
                        View by
                    </label>
                    <div class="controls">
                        <input type="hidden" id="status" name="status" value="<%=status %>" />
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
                            <%  if ((isAdmin && !isOfficer) || isMultipleOffice)
                                { %>
                                <option value="ALL">ALL PURCHASE OFFICES</option>
                            <%  } %>
                        </select>
                    </div>
                </div>
                <div class="control-group">
                    <div class="controls">
                        <button type="submit" id="btnSearch" class="btn btn-success">Search</button>
                    </div>
                </div>
                <div class="control-group">
                    <div class="span3">
                        <div class="legend" id="PRStatus">
                        </div>
                    </div>
                    <div class="span3">
                        <div class="legend" id="ItemStatus">
                        </div>
                    </div>
                </div>
                <div class="control-group last">
                    <%--<%  if (authorized.admin || authorized.procurement_user || authorized.finance)--%>
                    <%--<%  if (isAdmin || isUser || isFinance)--%>
                    <%  if (isEditAble)
                        { %>
                    <button type="button" id="btnCreate" class="btn btn-success">Create new Purchase requisition</button>
                    <%  } %>
                </div>
                <div class="control-group last">
                    <div style="width: 97%; overflow-x: auto; display: block;">
                        <table id="tblPR" class="table table-bordered" style="border: 1px solid #ddd">
                            <thead>
                                <tr>
                                    <th style="width: 2%"><i class="icon-chevron-sign-down dropAllDetail" title="Collapse/Expand detail(s)"></i></th>
                                    <th style="width: 3%;">KPI</th>
                                    <th style="width: 10%;">PR code</th>
                                    <th style="width: 8%;">Created date</th>
                                    <th style="width: 8%;">Submission date</th>
                                    <th style="width: 15%;">Requester</th>
                                    <th style="width: 8%;">Purchase/finance office</th>
                                    <th style="width: 8%;">Required date</th>
                                    <th style="width: 15%;">Remarks</th>
                                    <th style="width: 5%;">Status</th>
                                    <th style="width: 8%;">PR type</th>
                                    <th style="width: 10%;">Purchase type</th>
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
        var isAdmin = "<%=isAdmin?"true":"false"%>";
        isAdmin = (isAdmin === "true");

        <%--var isProcurementUser = "<%=authorized.procurement_user?"true":"false"%>";--%>
        var isProcurementUser = "<%=isUser?"true":"false"%>";
        isProcurementUser = (isProcurementUser === "true");

        var isOfficer = "<%=isOfficer?"true":"false"%>";
        isOfficer = (isOfficer === "true");

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
        var type_PR = "<%=type_PR%>";

        var mainData = <%=listPR%>;

        var PRTable;

        listStatus = $.grep(listStatus, function (n, i) {
            return n["status_id"] != 21;
        });

        var idxSts = listStatus.findIndex(x => x.status_id == 5);
        if (idxSts != -1) {
            listStatus.splice(idxSts, 1);
        }
        idxSts = listStatus.findIndex(x => x.status_id == 10);
        if (idxSts != -1) {
            listStatus.splice(idxSts, 1);
        }
        //idxSts = listStatus.findIndex(x => x.status_id == 15);
        //if (idxSts != -1) {
        //    listStatus.splice(idxSts, 1);
        //}

        $(document).on("click", "#btnSearch", function () {
            var errorMsg = "";
            errorMsg += GeneralValidation();

            if (errorMsg !== "") {
                showErrorMessage(errorMsg);

                return false;
            }
        });

        $(document).on("click", ".btnPurchase", function () {
            location.href = $(this).data("link");
        });

        $(document).on("click", ".btnRFQ", function () {
            location.href = $(this).data("link");
        });

        $(document).on("click", ".btnQuote", function () {
            location.href = $(this).data("link");
        });

        function format(d) {
            var html = "";
            if (typeof d !== "undefined") {
                var _d = JSON.parse(d.details);
                var _dcc = JSON.parse(d.details_charge_code);

                /*var arr = $.grep(detailData, function (n, i) {
                    return n.pr_id == d["id"];
                });*/



                var detailrows = "";
                var strestimated_costCurr = '';
                $.each(_d, function (i, x) {
                    var StrGuid = guid().toString();
                    var id_itemclosure = "";
                    var id_item = "";
                    var reason = "";
                    var status_name = x.status;
                    x.currency_id = x.currency_id == null ? '' : x.currency_id;
                    x.exchange_rate = x.exchange_rate == null ? '0.00' : x.exchange_rate;
                    if (status_name == "CLOSED") {
                        if (x.id_itemclosure != "" && typeof x.id_itemclosure !== "undefined") {
                            id_itemclosure = $.parseXML(x.id_itemclosure);
                            $xml = $(id_itemclosure);

                            status_name += "&nbsp;<div class=\"dropdown\" style=\"inline-block;\">" +
                                "<span data-toggle=\"dropdown\" class=\"status label btn-info icndrop\" style=\"inline-block;\"><i class=\"icon-info-sign \" style=\"opacity: 1;\"></i>" +
                                "<ul class=\"dropdown-menu\" style=\"min-width: 165px; margin-left: 28px; margin-top: -25px;\">";
                            var xi = 1;
                            var xlength = $xml.find('item_closure').length;
                            $xml.find('item_closure').each(function () {
                                var sheet = $(this);
                                reason = $(this).find('reason_for_closing').text();
                                id_item = $(this).find('id').text();
                                status_name += "<li> <a href=\"#\" style=\"white-space: normal\" id=\"btnDetail\" data-detailid=" + id_item + " data-action=\"detail\">#" + id_item + " " + reason + "</a></li >";
                                if (xi < xlength) { status_name += "<li class=\"divider\"></li>"; }
                                xi++;
                            });
                            status_name += "</ul></span></div>";
                        }
                    }
                    if (x.closing_remarks != "" && typeof x.closing_remarks !== "undefined") {
                        status_name += "<br/>Remarks: " + x.closing_remarks;
                    }

                    var strChargeCode = "";
                    if (_dcc != null && _dcc.length > 0) {
                        $.each(_dcc, function (i, d) {
                            if (d.pr_detail_id == x.id) {
                                strChargeCode += '<tr>';
                                strChargeCode += '<td style=" width: 10%;" class="pCostCenters">' + d.CostCenterId + ' - ' + d.CostCenterName + '</td>';
                                strChargeCode += '<td style="width: 20%;" class="pCostCentersWorkOrder">' + d.woId + ' - ' + d.Description + '</td>';
                                strChargeCode += '<td style="width: 10%;" class="pCostCentersEntity">' + d.entitydesc + '</td>';
                                strChargeCode += '<td style="width: 5%;">' + d.legal_entity + '</td>';
                                strChargeCode += '<td style="display: none; width: 5%;">' + d.control_account + '</td>';
                                strChargeCode += '<td style=" width: 5%; text-align:right;" class="pCostCentersValue">' + accounting.formatNumber(parseFloat(d.percentage), 2) + '</td>';
                                strChargeCode += '<td style="width: 11%; text-align:right;" class="pCostCentersAmt">' + accounting.formatNumber(parseFloat(d.amount), 2) + '</td>';
                                strChargeCode += '<td style="width: 11%; text-align:right;" class="pCostCentersUSDAmt">' + accounting.formatNumber(parseFloat(d.amount_usd), 2) + '</td>';
                                strChargeCode += '<td style="width: 20%;">' + d.remarks + '</td>';
                                strChargeCode += '</tr>';
                            }
                        });
                    }

                    if (strChargeCode == "") {
                        strChargeCode += '<tr>';
                        strChargeCode += '<td colspan="8" style="width: 10%; text-align:center;">No data available</td>';
                        strChargeCode += '</tr>';
                    }

                    detailrows += '<tr style="background-color:' + x.color_code + '; color:' + x.font_color + '">' +
                        '<td> <i class="icon-chevron-sign-down dropDetailCC accordion-toggle collapsed" data-target="#dv' + StrGuid + '" data-toggle="collapse" title="View detail(s)"></i></td >' +
                        '<td class="item_code">' + x.item_code + '</td>' +
                        '<td class="description">' + x.item_description + '</td>' +
                        '<td class="status">' + status_name + '</td>' +
                        '<td class="request_qty" style="text-align:right;">' + accounting.formatNumber(delCommas(x.request_qty), 2) + '</td>' +
                        '<td class="request_qty" style="text-align:right;">' + accounting.formatNumber(delCommas(x.po_qty), 2) + '</td>' +
                        '<td class="request_qty" style="text-align:right;">' + accounting.formatNumber(delCommas(x.grm_qty), 2) + '</td>' +
                        '<td class="uom_name">' + x.uom_name + '</td>' +
                        '<td class="currency_id">' + x.currency_id + '</td>' +
                        '<td class="cost_estimated" style="text-align:right;">' + accounting.formatNumber(x.estimated_cost, 2) + '</td>' +
                        '<td class="exchange_rate" style="text-align:right;">' + x.exchange_rate + '</td>' +
                        '<td class="cost_estimated_usd" style="text-align:right;">' + x.estimated_cost_usd + '</td>' +
                        '<td class="supporting document(s)">' + x.attachment + '</td>';
                    if (isProcurement) {
                        detailrows += '<td>' + x.actions + '</td>';
                    }
                    detailrows += '</tr > ';
                    //
                    detailrows += '<tr id="trr' + x.id + '">';
                    detailrows += '<td class="hiddenRow" colspan="14" style="padding:0px;">';
                    detailrows += '<div id="dv' + StrGuid + '" class="accordian-body in collapse" style="height: auto;">';
                    detailrows += '<div id="dv' + x.id + '_ChargeCode" style="margin-left:20px; margin-right:5px; margin-top:3px; margin-bottom:5px;">';
                    detailrows += '<div id="dv' + x.id + '_CostParent">';
                    detailrows += '<table id="tbl' + x.id + '_CostParent" class="table table-bordered table-striped tblCostCenterParent">';
                    detailrows += '<thead>';
                    detailrows += '<tr>';
                    detailrows += '<th style=" width: 15%; text-align:left;">Cost center</th>';
                    detailrows += '<th style=" width: 18%; text-align:left;">Work order</th>';
                    detailrows += '<th style=" width: 10%; text-align:left;">Entity</th>';
                    detailrows += '<th style=" width: 10%; text-align:left;">Legal entity</th>';
                    detailrows += '<th style="display: none;">Account Control</th>';
                    detailrows += '<th style=" width: 5%; text-align:left;">%</th>';
                    detailrows += '<th style=" width: 11%; text-align:left;">Amount (' + x.currency_id + ')</th>';
                    detailrows += '<th style=" width: 11%; text-align:left;">Amount (USD)</th>';
                    detailrows += '<th style=" text-align:left; width: 30%;">Remarks</th>';
                    detailrows += '</tr>';
                    detailrows += '</thead>';
                    detailrows += '<tbody>';
                    detailrows += strChargeCode;
                    detailrows += '</tbody>';
                    detailrows += '</table>';
                    detailrows += '</div>';
                    detailrows += '</div>';
                    detailrows += '</div>';
                    detailrows += '</div>';
                    detailrows += '</td>';
                    detailrows += '</tr>';
                    //
                });

                var groups = {};
                _d.forEach(obj => {
                    if (!groups.hasOwnProperty(obj.currency_id)) {
                        groups[obj.currency_id] = [];
                    }
                    groups[obj.currency_id].push(obj);
                })

                $.each(groups, function (i, dc) {
                    var estimated_costCurr = 0;
                    var currTemp = '';

                    for (var ii = 0; ii < dc.length; ii++) {
                        estimated_costCurr += parseFloat(dc[ii].estimated_cost);
                        currTemp = dc[ii].currency_id == null ? '' : dc[ii].currency_id;
                    }

                    strestimated_costCurr += '<b>(' + currTemp + ') ' + accounting.formatNumber(estimated_costCurr, 2) + '</b> </br>';
                });

                html = '<table class="table table-bordered" cellpadding="5" cellspacing="0" style="border: 1px solid #ddd;">' +
                    '<thead>' +
                    '<tr>' +
                    '<th></th>' +
                    '<th>Product code</th>' +
                    '<th>Description</th>' +
                    '<th style="width:10%;">Product status</th>' +
                    '<th>Request qty.</th>' +
                    '<th>Order qty.</th>' +
                    '<th>Received qty.</th>' +
                    '<th>UOM</th>' +
                    '<th>Currency</th>' +
                    '<th>Cost estimated</th>' +
                    '<th>Exchange rate (to USD)</th>' +
                    '<th>Cost estimated (USD)</th>' +
                    '<th>Supporting document(s)</th>';
                if (isAdmin) {
                    html += '<th>Action</th>';
                }
                html += '</tr>' +

                    '</thead> ' +
                    '<tbody>' + detailrows + '</tbody>' +
                    '<tfoot><tr><td colspan="9" style="font-weight:bold; text-align:right;">Total</td>' +
                    '<td style="font-weight:bold; text-align:right;">' + strestimated_costCurr + '</td>' +
                    '<td></td>' +
                    '<td style="font-weight:bold; text-align:right;">' + d.estimated_cost_usd + '</td>' +
                    '<td colspan="10"></td>' +
                    '</tr></tfoot> ' +
                    '</table>';
            }
            return html;
        }

        $(document).ready(function () {
            $("#PRStatus").append("<b><i>PR status:</i></b><br/>");
            $.each(listStatus, function (i, x) {
                if (x.status_id != "-1") {
                    $("#PRStatus").append("<span style='background-color:" + x.color_code + "' class='legend-block'>&nbsp;</span>&nbsp;<i>" + x.status_name + "</i><br/>");
                }
            });

            $("#ItemStatus").append("<b><i>Product status:</i></b><br/>");
            $.each(itemStatus, function (i, x) {
                if (x.status_id != "-1") {
                    $("#ItemStatus").append("<span style='background-color:" + x.color_code + "' class='legend-block'>&nbsp;</span>&nbsp;<i>" + x.status_name + "</i><br/>");
                }
            })

            var cboTypePR = $("#cboTypePR");
            $(cboTypePR).val(type_PR);
            Select2Obj(cboTypePR, "Type PR");

            var x = status.split(",");
            var cboStatus = $("#cboStatus");
            generateCombo(cboStatus, listStatus, "status_id", "status_name", true);
            $(cboStatus).val(x);
            Select2Obj(cboStatus, "Status");

            $("#cboStatus").on('select2:select select2:unselect', function (e) {
                var sel = $(this).val();

                if (e.params.data.id == -1) {
                    sel = [-1];                    
                } else {
                    sel = jQuery.grep(sel, function (value) {
                        return value != '-1';
                    });
                }
                $("#cboStatus").val(sel).trigger("change");

                $("#status").val(sel.join(','));
            });

            var cboOffice = $("#cboOffice");
            /*generateComboGroup(cboOffice, listOffice, "office_id", "office_name", "hub_option", true);*/
            generateCombo(cboOffice, listOffice, "office_id", "office_name", true);
            $(cboOffice).val(cifor_office);
            Select2Obj(cboOffice, "Purchase office");

            $("#startDate").datepicker({
                format: "dd M yyyy"
                , autoclose: true
            }).on("changeDate", function () {
                $("#_startDate").val($("#startDate").data("date"));
                $("#startDate").datepicker("hide");
                startDate = new Date($("#startDate").data("date"));
                $('#endDate').datepicker('setStartDate', (startDate.getDate().toString().length < 2 ? '0' + startDate.getDate() : startDate.getDate()) + ' ' + ((startDate.getMonth() + 1).toString().length < 2 ? '0' + (startDate.getMonth() + 1) : (startDate.getMonth() + 1)) + ' ' + startDate.getFullYear());
                if (CheckFilterStartEndDate(new Date(startDate), new Date(endDate)) == false) {
                    endDate = new Date($("#startDate").data("date"));
                    $("#_endDate").val($("#startDate").data("date"));
                    $("#endDate").datepicker("setDate", endDate).trigger("changeDate");
                }
            });
            
            $("#endDate").datepicker({
                format: "dd M yyyy"
                , autoclose: true
                , startDate: (startDate.getDate().toString().length < 2 ? '0' + startDate.getDate() : startDate.getDate()) + ' ' + ((startDate.getMonth() + 1).toString().length < 2 ? '0' + (startDate.getMonth() + 1) : (startDate.getMonth() + 1)) + ' ' + startDate.getFullYear()
            }).on("changeDate", function () {
                $("#_endDate").val($("#endDate").data("date"));
                $("#endDate").datepicker("hide");
                endDate = new Date($("#endDate").data("date"));
            });

            $("#startDate").datepicker("setDate", startDate).trigger("changeDate");
            $("#endDate").datepicker("setDate", endDate).trigger("changeDate");

            PRTable = $('#tblPR').DataTable({
                "bFilter": true, "bDestroy": true, "bRetrieve": true, "pagingType": 'full_numbers',
                "lengthMenu": [[50, 100, -1], [50, 100, "All"]],
                "fnRowCallback": function (nRow, aData, iDisplayIndex) {
                    $(nRow).css('background-color', aData.color_code);
                    $(nRow).css('color', aData.font_color);
                },
                "aaData": mainData,
                "aoColumns": [
                    {
                        "mDataProp": "id"
                        , "mRender": function (d, type, row) {
                            return '<i class="icon-chevron-sign-down dropDetail" title="View detail(s)"></i>'
                        }
                    },
                    { "mDataProp": "kpi", "visible": false },//isAdmin
                    {
                        "mDataProp": "pr_no"
                        , "mRender": function (d, type, row) {
                            var pr_no = row.pr_no != '' ? row.pr_no : 'N/A';
                            var html = '<a href="detail.aspx?id=' + row.id + '&submission_page_type=' + row.id_submission_page_type + '" title="View detail">' + pr_no + '</a>';
                            /*  html += '<br /> ' + row.currency_id + ' '+ row.estimated_cost;*/
                            html += '<br />USD ' + row.estimated_cost_usd;
                            return html;
                        }
                    },
                    { "mDataProp": "created_date" },
                    { "mDataProp": "submission_date" },
                    { "mDataProp": "requester" },
                    { "mDataProp": "cifor_office" },
                    { "mDataProp": "required_date" },
                    { "mDataProp": "remarks" },
                    { "mDataProp": "status" },
                    { "mDataProp": "pr_type" },
                    { "mDataProp": "purchase_type_name" },
                    { "mDataProp": "details", "visible": false },
                    { "mDataProp": "details_charge_code", "visible": false },
                ],
                "columnDefs": [{
                    "targets": [0, 1],
                    "orderable": false,
                }],
                "aaSorting": [[4, "asc"]],
                "iDisplayLength": 50
                , "bLengthChange": false
            });

            $('#tblPR_filter input').unbind();
            $('#tblPR_filter input').bind('keyup', function (e) {
                if (e.keyCode == 13) {
                    PRTable.search(this.value).draw();
                }
            });

            $(window).keydown(function (event) {
                if (event.keyCode == 13) {
                    event.preventDefault();
                    return false;
                }
            });

            $('#tblPR tbody').on('click', '.dropDetail', function () {
                if (!$(this).hasClass('no-sort') && !$(this).hasClass('dropAllDetail')) {
                    var tr = $(this).closest('tr');
                    var row = PRTable.row(tr);

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

                }
            });

            $('#tblPR tbody').on("click", ".dropDetailCC", function () {
                var isShown = false;
                if ($(this).hasClass('icon-chevron-sign-right')) {
                    isShown = true;
                } else if ($(this).hasClass('icon-chevron-sign-down')) {
                    isShown = false;
                }

                if (isShown) {
                    $(this).attr('class', 'icon-chevron-sign-down dropDetailCC');
                } else {
                    $(this).attr('class', 'icon-chevron-sign-right dropDetailCC');
                }

            });

            $.each(PRTable.rows().nodes(), function (i) {
                var row = PRTable.row(i)
                if (!row.child.isShown()) {
                    row.child(format(row.data())).show();
                    $(row.node()).addClass('shown');
                }
            });

            // Handle click on "Collapse All" button
            $('#btn-hide-all-children').on('click', function () {
                $.each(PRTable.rows().nodes(), function (i) {
                    var tr = $(this).closest('tr');
                    var row = PRTable.row(i);

                    if (row.child.isShown()) {
                        row.child.hide();
                        tr.removeClass('shown');
                        $(tr).find('i[class^="icon-chevron"]').attr('class', 'icon-chevron-sign-right dropDetail');
                    }
                });
            });
        });

        $(document).on("click", ".dropAllDetail", function () {
            var isShown = false;
            if ($(this).hasClass('icon-chevron-sign-right')) {
                isShown = true;
            } else if ($(this).hasClass('icon-chevron-sign-down')) {
                isShown = false;
            }
            $.each(PRTable.rows().nodes(), function (i) {
                var tr = $(this).closest('tr');
                var row = PRTable.row(i);

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

        $(document).on("click", ".btnConfirm", function () {
            var line_id = $(this).data("base-id");
       /*     console.log(line_id);*/
            sendConfirmation(line_id);
        });

        function sendConfirmation(ids) {
            resetFormConfirmation();
            $("#ConfirmationForm").modal("show");

            loadItems(ids, "PURCHASE REQUISITION");

            setTimeout(ScrollConfirmation, 500);
        }

        function ScrollConfirmation() {
            var ctop = $("#ConfirmationForm").offset().top;
            window.parent.$('html, #ConfirmationForm').animate({ scrollTop: ctop }, 'slow');
        }

        $(document).on("click", ".btnViewConfirm", function () {
            blockScreen();
            parent.location = $(this).data("url");
        });

        $(document).on("click", ".btnCloseItem", function () {
            blockScreen();
            parent.location = $(this).data("url");
        });

        $(document).on("click", "#btnCreate", function () {
            location.href = "Input.aspx";
        });

        $(document).on("click", "#btnDetail", function () {
            link = "../closure/Detail.aspx?id=" + $(this).data("detailid");
            top.window.open(link);
        });

        var uploadValidationResult = {};
        $(document).on("click", "#btnSendConfirmation", function () {
            var thisHandler = $(this);
            $("[name=cancellation_file],[name=confirm_filename]").uploadValidation(function (result) {
                uploadValidationResult = result;
                onBtnClickSendConfirmation.call(thisHandler);
            });
        });

        var onBtnClickSendConfirmation = function () {
            /* confirmation script */
            //$(document).on("click", "#btnSendConfirmation", function () {
            var errorMsg = "";

            errorMsg += uploadValidationResult.not_found_message || '';

            if ($("[name^='delivery_quantity']").length == 0) {
                errorMsg += "<br/>- Product(s) is required";
            }

            errorMsg += GeneralValidation();
            errorMsg += FileValidation();
            if (errorMsg != "") {
                errorMsg = "Please correct the following error(s):" + errorMsg;

                $("#ucform-error-message").html("<b>" + errorMsg + "<b>");
                $("#ucform-error-box").show();
                $('.modal-body').animate({ scrollTop: 0 }, 500);
            } else {
                var workflow = new Object();
                workflow.action = "saved";
                workflow.comment = "";

                var _data = new Object();
                var ConfirmList = [];
                var DocList = [];

                $("[name^='delivery_quantity']").each(function (i, x) {
                    var obj = new Object();
                    obj.base_type = $("[name='base_type']").val();
                    obj.base_id = $(this).data("id");
                    obj.send_quantity = delCommas($(this).val());
                    obj.additional_person = String($("[name^='cboStaff'][data-unique_id='" + $(this).data("unique_id") + "']").val()).toLowerCase();

                    ConfirmList.push(obj);
                });
                _data.details = ConfirmList;

                $("#tblSupportingDocuments tbody tr").each(function () {
                    var _att = new Object();
                    _att["id"] = $(this).find("input[name='confirmationfile.id']").val();
                    _att["filename"] = $(this).find("input[name='confirmationfile.filename']").val();
                    _att["file_description"] = $(this).find("input[name='confirmationfile.file_description']").val();
                    _att["is_provide_file"] = ($(this).find("input[type='checkbox']").is(':checked')) ? "1" : "0";
                    DocList.push(_att);
                });
                _data.documents = DocList;

                var Submission = {
                    submission: JSON.stringify(_data),
                    workflows: JSON.stringify(workflow),
                    deleted: JSON.stringify(deletedSupDocId)
                };

                $.ajax({
                    url: 'UserConfirmation/ItemConfirmation.aspx/Submit',
                    data: JSON.stringify(Submission),
                    dataType: 'json',
                    type: 'post',
                    contentType: "application/json; charset=utf-8",
                    success: function (response) {
                        var output = JSON.parse(response.d);
                        if (output.result !== "success") {
                            alert(output.message);
                        } else {
                            if (output.id !== "") {
                                $("#confirm_no").val(output.confirmation_code);
                                $("input[name='doc_id']").val(output.id);
                                $("input[name='action']").val("upload");
                                $("input[name='doc_type']").val("USER CONFIRMATION");
                                UploadConfirmFile();
                            }
                        }
                    }
                });
            }
        };

        function UploadConfirmFile() {
            var form = $('form')[0];
            var formData = new FormData(form);

            $.ajax({
                type: "POST",
                url: 'Service.aspx',
                data: formData,
                processData: false,
                contentType: false,
                success: function (response) {
                    var output = JSON.parse(response);
                    if (output.result !== "success") {
                        alert(output.message);
                    } else {
                        alert("User confirmation " + $("#confirm_no").val() + " has been sent successfully.");
                        blockScreen();
                        //location.reload();
                        window.location = window.location;
                    }
                }
            });
        }

        function CheckStartEndDate() {
            if (CheckFilterStartEndDate(new Date($("#startDate").data("date")), new Date($("#endDate").data("date"))) == false) {
                $("#_startDate").val($("#endDate").data("date"));
            }
        }
    </script>
</asp:Content>
