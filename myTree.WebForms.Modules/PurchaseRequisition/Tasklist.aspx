<%@ Page  MasterPageFile="~/Procurement.Master" Language="C#" AutoEventWireup="true" CodeBehind="Tasklist.aspx.cs" Inherits="myTree.WebForms.Modules.PurchaseRequisition.Tasklist" %>

<asp:Content ID="Content1" ContentPlaceHolderID="AppHead" runat="server">
    <title>Purchase Requisition(s) pending for action</title>
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
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="AppBody" runat="server">
    <div class="containerHeadline">
        <%  if (action.ToLower() == "team"){ %>
        <h2>Purchase requisition team tasklist</h2>
        <%} else { %>
            <h2>Purchase requisition tasklist</h2>
          <%  }%>
    </div>
    <div class="row-fluid">
        <div class="floatingBox">
            <div class="container-fluid">

                <div class="control-group">
                    <label class="control-label">
                        Purchase/finance office
                    </label>
                    <div class="controls">
                        <select id="cboOffice" data-title="Purchase office" data-validation="required" name="cifor_office" class="span4">
                            <%--<% if(!isLead) { %>
                            <option value="All">All purchase/finance offices</option>
                            <% } %>--%>
                        </select>
                    </div>
                </div>
                <div class="control-group">
                    <div class="controls">
                        <button type="button" id="btnSearch" class="btn btn-success">Search</button>
                    </div>
                </div>

                <div class="control-group last">
                    <div style="width: 97%; overflow-x: auto; display: block;">
                        <table id="tblPR" class="table table-bordered table-striped" style="border: 1px solid #ddd">
                            <thead>
                                <tr>
                                    <th style="width:2%"><i class="icon-chevron-sign-down dropAllDetail" title="Collapse/Expand detail(s)"></i></th>
                                    <th style="width: 8%;">PR code</th>
                                    <th style="width:8%;">Created date</th>
                                    <th style="width:8%;">Submission date</th>
                                    <th style="width:8%;">Requester</th>
                                    <th style="width:10%;">Purchase/finance office</th>
                                    <th style="width:10%;">Required date</th>
                                    <th style="width:17%;">Remarks</th>
                                    <th style="width:0%;">Charge code</th>
                                    <th style="width: 10%;">Status</th>
                                    <th style="width: 10%;">PR type</th>
                                    <th style="width:5%;">&nbsp;</th>
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
        var isAdmin = "<%=userRoleAccess.RoleNameInSystem == "admin"?"true":"false"%>";
        isAdmin = (isAdmin === "true");
		
		<%--var isProcurementUser = "<%=authorized.procurement_user?"true":"false"%>";--%>
        var isProcurementUser = "<%=userRoleAccess.RoleNameInSystem == "procurement_user"?"true":"false"%>";
        isProcurementUser = (isProcurementUser === "true");
		
		var isProcurement = false;
        if (isAdmin || isProcurementUser) {
            isProcurement = true;
        }

        var mainData = <%=listPR%>;

        var PRTable;
        var listOffice = <%=listOffice%>;
        var cifor_office = "<%=cifor_office%>";
        var isLead = "<%=isLead%>";
        var action = "<%=action%>";


        function format(d) {
            var html = "";
            if (typeof d !== "undefined") {
                var _d = JSON.parse(d.details);
                var _dcc = JSON.parse(d.details_charge_code);

                var detailrows = "";
                var strestimated_costCurr = '';
                $.each(_d, function (i, x) {
                    var StrGuid = guid().toString(); var id_itemclosure = "";
                    var id_item = "";
                    var reason = "";
                    x.currency_id = x.currency_id == null ? '' : x.currency_id;
                    x.exchange_rate = x.exchange_rate == null ? '0.00' : x.exchange_rate;

                    var status_name = x.status;
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
                                strChargeCode += '<td style=" width: 5%; text-align:right;" class="pCostCentersValue">' + accounting.formatNumber(parseFloat(d.percentage.toString().replaceAll(',', '')), 2) + '</td>';
                                strChargeCode += '<td style="width: 11%; text-align:right;" class="pCostCentersAmt">' + accounting.formatNumber(parseFloat(d.amount.toString().replaceAll(',', '')), 2) + '</td>';
                                strChargeCode += '<td style="width: 11%; text-align:right;" class="pCostCentersUSDAmt">' + accounting.formatNumber(parseFloat(d.amount_usd.toString().replaceAll(',', '')), 2) + '</td>';
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

                    detailrows += '<tr>' + //'<tr style="background-color:' + x.color_code + '; color:' + x.font_color + '">' +
                        '<td> <i class="icon-chevron-sign-down dropDetailCC accordion-toggle collapsed" data-target="#dv' + StrGuid + '" data-toggle="collapse" title="View detail(s)" style="cursor: pointer;"></i></td >' +
                        '<td class="item_code">' + x.item_code + '</td>' +
                        '<td class="description">' + x.item_description + '</td>' +
                        '<td class="status">' + status_name + '</td>' +
                        '<td class="request_qty" style="text-align:right;">' + accounting.formatNumber(delCommas(x.request_qty), 2) + '</td>' +
                        '<td class="request_qty" style="text-align:right;">' + accounting.formatNumber(delCommas(x.po_qty), 2) + '</td>' +
                        '<td class="request_qty" style="text-align:right;">' + accounting.formatNumber(delCommas(x.grm_qty), 2) + '</td>' +
                        '<td class="uom_name">' + x.uom_name + '</td>' +
                        '<td class="currency_id">' + x.currency_id + '</td>' +
                        //'<td class="cost_estimated" style="text-align:right;">' + x.unit_price + '</td>' +
                        //'<td class="cost_estimated" style="text-align:right;">' + x.estimated_cost + '</td>' +
                        //'<td class="exchange_rate" style="text-align:right;">' + x.exchange_rate + '</td>' +
                        //'<td class="cost_estimated_usd" style="text-align:right;">' + x.estimated_cost_usd + '</td>' +
                        '<td class="cost_estimated" style="text-align:right;">' + accounting.formatNumber(x.estimated_cost, 2) + '</td>' +
                        '<td class="exchange_rate" style="text-align:right;">' + x.exchange_rate + '</td>' +
                        '<td class="cost_estimated_usd" style="text-align:right;">' + x.estimated_cost_usd + '</td>' +
                        '<td class="quotations">' + x.attachment + '</td>';
                    detailrows += '</tr > ';

                    detailrows += '<tr id="trr' + x.id + '">';
                    detailrows += '<td class="hiddenRow" colspan="13" style="padding:0px;">';
                    detailrows += '<div id="dv' + StrGuid + '" class="accordian-body in collapse" style="height: auto;">';
                    detailrows += '<div id="dv' + x.id + '_ChargeCode" style="margin-left:30px; margin-right:0px; margin-top:5px; margin-bottom:5px; width:77.5%;">';
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
                        estimated_costCurr += parseFloat(dc[ii].estimated_cost.toString().replaceAll (',', ''));
                        currTemp = dc[ii].currency_id == null ? '' : dc[ii].currency_id;
                    }

                    strestimated_costCurr += '<b>(' + currTemp + ') ' + accounting.formatNumber(estimated_costCurr, 2) + '</b> </br>';
                });
                
                html = '<table class="table table-bordered table-striped" cellpadding="5" cellspacing="0" style="border: 1px solid #ddd;">' +
                    //'<thead>' +
                    //'<tr>' +
                    //'<th>Product code</th>' +
                    //'<th>Description</th>' +
                    //'<th>Product status</th>' +
                    //'<th>Request qty.</th>' +
                    //'<th>UOM</th>' +
                    //'<th>Cost estimated</th>' +
                    //'<th>Total estimation</th>' +
                    //'<th>Exchange rate (to USD)</th>' +
                    //'<th>Total estimation (USD)</th>' +
                    //'<th>Quotations</th>';
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
                if (detailrows == "") {
                    detailrows += '<tr>';
                    detailrows += '<td colspan="13" style="width: 10%; text-align:center;">No data available</td>';
                    detailrows += '</tr>';

                    html += '</tr>' +
                        '</thead> ' +
                        '<tbody>' + detailrows + '</tbody>' +
                        '</table>';
                }
                else {

                    html += '</tr>' +
                        '</thead> ' +
                        '<tbody>' + detailrows + '</tbody>' +
                        '<tfoot><tr><td colspan="9" style="font-weight:bold; text-align:right;">Total</td>' +
                        //'<td style="font-weight:bold; text-align:right;">' + d.currency_id + ' ' + d.estimated_cost + '</td>' +
                        //'<td></td>' +
                        '<td style="font-weight:bold; text-align:right;">' + strestimated_costCurr + '</td>' +
                        '<td></td>' +
                        '<td style="font-weight:bold; text-align:right;">' + d.estimated_cost_usd + '</td>' +
                        '<td></td>' +
                        '</tr></tfoot> ' +
                        '</table>';
                }
                
            }
            return html;
        }

        $(document).ready(function () {
            PRTable = $('#tblPR').DataTable({
                "bFilter": true, "bDestroy": true, "bRetrieve": true, "pagingType": 'full_numbers',
                "lengthMenu": [[50, 100, -1], [50, 100, "All"]],
                "aaData": mainData,
                "aoColumns": [
                    {
                        "mDataProp": "id"
                        , "mRender": function (d, type, row) {
                            return '<i class="icon-chevron-sign-down dropDetail" title="View detail(s)"></i>'
                        }
                    },
                    {
                        "mDataProp": "pr_no"
                        , "mRender": function (d, type, row) {
                            var pr_no = row.pr_no != '' ? row.pr_no : 'N/A';
                            var html = '<a href="detail.aspx?id=' + row.id + '" title="View detail">' + pr_no + '</a>';
                            /*  html += '<br /> ' + row.currency_id + ' '+ row.estimated_cost;*/
                            html += '<br />USD ' + row.estimated_cost_usd; //row.estimated_cost_usd;
                            return html;
                        }
                    },
                    { "mDataProp": "created_date" },
                    { "mDataProp": "submission_date" },
                    { "mDataProp": "requester" },
                    { "mDataProp": "cifor_office" },
                    { "mDataProp": "required_date" },
                    { "mDataProp": "remarks" },
                    { "mDataProp": "cost_center", "visible": false },
                    { "mDataProp": "status" },
                    { "mDataProp": "pr_type", "visible": false },
                    {
                        "mDataProp": "url"
                       ,"mRender": function (d, type, row) {
                            let ret = "";
                            if (row.id != null && row.id != "") {
                                ret = '<a href="' + row.url +'">Take action</a>'
                            }
                            return ret
                        }
                    },
                    { "mDataProp": "details", "visible": false },
                ],
                "columnDefs": [ {
                    "targets": [0,11,12],
                    "orderable": false,
                }],
                "aaSorting": [[2, "asc"]],
                "iDisplayLength": 50,
                "bLengthChange": false,
                //"fnRowCallback": function (nRow, aData, iDisplayIndex, iDisplayIndexFull) {
                //    $('td', nRow).css('background-color', aData.color_code);
                //}
            });

            $('#tblPR_filter input').unbind();
            $('#tblPR_filter input').bind('keyup', function (e) {
                if (e.keyCode == 13) {
                    PRTable.search(this.value).draw();	
                }
            });	

            $(window).keydown(function(event){
                if(event.keyCode == 13) {
                    event.preventDefault();
                    return false;
                }
            });

            //$('#tblPR tbody').on('click', 'i[class^="icon-chevron"]', function () {
            //    if (!$(this).hasClass('no-sort') && !$(this).hasClass('dropAllDetail')) {
            //        var tr = $(this).closest('tr');
            //        var row = PRTable.row(tr);

            //        $(this).attr('class', '');
            //        if (row.child.isShown()) {
            //            row.child.hide();
            //            tr.removeClass('shown');
            //            $(this).attr('class', 'icon-chevron-sign-right dropDetail');
            //        } else {
            //            row.child(format(row.data())).show();
            //            tr.addClass('shown');
            //            $(this).attr('class', 'icon-chevron-sign-down dropDetail');
            //        }
            //    }
            //});

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
                    $(this).css("cursor", "pointer");
                } else {
                    $(this).attr('class', 'icon-chevron-sign-right dropDetailCC');
                    $(this).css("cursor", "pointer");
                }

            });


            $.each(PRTable.rows().nodes(), function (i) {
                var row = PRTable.row(i)
                if(!row.child.isShown()){
                    row.child(format(row.data())).show();
                    $(row.node()).addClass('shown');
                }
            });

            $('#PRTable > tbody  > tr').each(function (index, tr) {
                console.log(index);
                console.log(tr);
            });

            var cboOffice = $("#cboOffice");
            generateCombo(cboOffice, listOffice, "office_id", "office_name", true);
            $(cboOffice).val(cifor_office);
            Select2Obj(cboOffice, "Purchase office");
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

        $(document).on("click", "#btnSearch", function () {
            var procurementOffice = $("#cboOffice").val();

            $.get("/Procurement/PurchaseRequisition/Tasklist.aspx?procurementOffice=" + procurementOffice + "&action=" + action, function () {
                window.location.href = "/Procurement/PurchaseRequisition/Tasklist.aspx?procurementOffice=" + procurementOffice + "&action=" + action;
            })
        });
    </script>
</asp:Content>
