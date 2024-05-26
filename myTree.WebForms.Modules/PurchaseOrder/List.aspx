<%@ Page MasterPageFile="~/Procurement.Master" Language="C#" AutoEventWireup="true" CodeBehind="List.aspx.cs" Inherits="Procurement.PurchaseOrder.List" %>
<%@ Register Src="~/Usc/uscCancellationForm.ascx" TagName="cancellationform" TagPrefix="uscCancellation" %>
<%@ Register Src="~/UserConfirmation/uscSendConfirmation.ascx" TagName="confirmationform" TagPrefix="uscConfirmation" %>

<asp:Content ID="Content1" ContentPlaceHolderID="AppHead" runat="server">
    <title>Purchase Orders</title>
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

    #CancelForm.modal-dialog {
        margin: auto 12%;
        width: 60%;
        height: 320px !important;
    }
</style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="AppBody" runat="server">
    <uscCancellation:cancellationform ID="cancellationForm" runat="server" />

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
                        Document date
                    </label>
                    <div class="controls">
                        <div class="input-prepend" style="margin-right:-32px;">
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
                        <div class="legend" id="POStatus">
                        </div>
                    </div>
                </div>
                <div class="control-group last">
                    <%  if (isEditAble)
                        { %>
                    <button type="button" id="btnCreate" class="btn btn-success">Create new PO</button>&nbsp;&nbsp;&nbsp;
                    <%  } %>
                </div>
                <div class="control-group last">
                    <div style="width: 97%; overflow-x: auto; display: block;">
                        <table id="tblPO" class="table table-bordered" style="border: 1px solid #ddd">
                            <thead>
                                <tr>
                                    <th style="width:2%"><i class="icon-chevron-sign-down dropAllDetail" title="Collapse/Expand detail(s)"></i></th>
                                    <th style="width:10%;">PO code</th>
                                    <th style="width:10%;">OCS PO number</th>
                                    <th style="width:10%;">Document date</th>
                                    <th style="width:12%;">Expected delivery date</th>
                                    <th style="width:15%;">Supplier</th>
        <%--                            <th style="width:5%;">Currency</th>--%>
                                    <th style="width:15%;">Total amount (in original currency)</th>
                                    <th style="width:10%;">Total amount (in USD)</th>
                                    <th style="width:15%;">Remarks</th>
                                    <th style="width:5%;">Status</th>
                                    <th style="width:5%;">Action</th>
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
    <input type="hidden" name="action" id="action"/>
    <input type="hidden" name="doc_id" id="doc_id" value=""/>
    <input type="hidden" name="doc_type" id="doc_type" value="PURCHASE ORDER"/>
    <input type="hidden" name="file_name" id="file_name" value="" />
    <script>
        <%--var isAdmin = "<%=authorized.admin?"true":"false"%>";--%>
        var isAdmin = "<%=isAdmin?"true":"false"%>";
        isAdmin = (isAdmin === "true");

        <%--var isProcurementUser = "<%=authorized.procurement_user?"true":"false"%>";--%>
        var isProcurementUser = "<%=isUser?"true":"false"%>";
        isProcurementUser = (isProcurementUser === "true");

        <%--var isFinance = "<%=authorized.finance?"true":"false"%>";--%>
        var isFinance = "<%=isFinance?"true":"false"%>";
        isFinance = (isFinance === "true");

        var isProcurement = false;
        if (isAdmin || isProcurementUser) {
            isProcurement = true;
        }

        var itemStatus = <%=itemStatus%>;

        var listStatus = <%=listStatus%>;
        //listStatus = $.grep(listStatus, function (n, i) {
        //    return n["status_id"] != 25;
        //});
        var listOffice = <%=listOffice%>;
        var startDate = new Date("<%=startDate%>");
        var endDate = new Date("<%=endDate%>");
        var status = "<%=status%>";
        var cifor_office = "<%=cifor_office%>";

        var mainData = <%=listPR%>;

        var POTable;

        var _id = "";
        var po_no = "";

        $(document).on("click", "#btnSearch", function () {
            var errorMsg = "";
            errorMsg += GeneralValidation();

            if (errorMsg !== "") {
                showErrorMessage(errorMsg);

                return false;
            }
        });

        function format(d) {
            var html = "";
            if (typeof d !== "undefined") {
                var _d = JSON.parse(d.details);
                var _dcc = JSON.parse(d.details_charge_code);
                var detailrows = "";

                $.each(_d, function (i, x) {
                    var StrGuid = guid().toString();
                    let item_desc = "";
                    item_desc = x.quotation_description;

                    var strChargeCode = "";
                    if (_dcc != null && _dcc.length > 0) {
                        $.each(_dcc, function (i, d) {
                            if (d.purchase_order_detail_id == x.line_id) {
                                let amount = d.amount;
                                let amount_usd = d.amount_usd;

                                if (x.payable_vat == true) {
                                    amount += d.amount_vat;
                                    amount_usd += d.amount_usd_vat;
                                }

                                strChargeCode += '<tr>';
                                strChargeCode += '<td style=" width: 10%;" class="pCostCenters">' + d.CostCenterId + ' - ' + d.CostCenterName + '</td>';
                                strChargeCode += '<td style="width: 20%;" class="pCostCentersWorkOrder">' + d.woId + ' - ' + d.Description + '</td>';
                                strChargeCode += '<td style="width: 10%;" class="pCostCentersEntity">' + d.entitydesc + '</td>';
                                strChargeCode += '<td style="width: 5%;">' + d.legal_entity + '</td>';
                                strChargeCode += '<td style="display: none; width: 5%;">' + d.control_account + '</td>';
                                strChargeCode += '<td style=" width: 5%; text-align:right;" class="pCostCentersValue">' + accounting.formatNumber(parseFloat(d.percentage), 2) + '</td>';
                                strChargeCode += '<td style="width: 11%; text-align:right;" class="pCostCentersAmt">' + accounting.formatNumber(parseFloat(amount), 2) + '</td>';
                                strChargeCode += '<td style="width: 11%; text-align:right;" class="pCostCentersUSDAmt">' + accounting.formatNumber(parseFloat(amount_usd), 2) + '</td>';
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

                    let line_status_name = x.line_status_name;
                    if (x.closing_remarks != "") {
                        line_status_name += "<br/>Remarks: " + x.closing_remarks;
                    }

                    detailrows += '<tr>' +
                        '<td> <i class="icon-chevron-sign-down dropDetailCC accordion-toggle collapsed" data-target="#dv' + StrGuid + '" data-toggle="collapse" title="View detail(s)"></i></td >' +
                        '<td class="item_code">' + x.item_code + '</td>' +
                        '<td class="description" colspan="5">' + item_desc + '</td>' +
                        '<td class="line_status">' + line_status_name + '</td>' +
                        '<td class="quantity" style="text-align:right;">' + accounting.formatNumber(delCommas(x.quantity), 2) + '</td>' +
                        '<td class="received_quantity" style="text-align:right;">' + accounting.formatNumber(delCommas(x.received_quantity), 2) + '</td>' +
                        '<td class="balance" style="text-align:right;">' + accounting.formatNumber(delCommas(x.balance), 2) + '</td>' +
                        '<td class="uom_name">' + x.uom_name + '<input type="hidden" name="po_detail_id" value="' + x.line_id + '"/></td>' +
                        '<td class="requester">' + x.requester + '<input type="hidden" name="pr_requester" value="' + x.requester + '"/></td>';
                    //if (isProcurement) {
                    //    detailrows += '<td>' + x.actions + '</td>';
                    //}
                    detailrows += '</tr > ';
                    //
                    detailrows += '<tr id="trr' + x.id + '">';
                    detailrows += '<td class="hiddenRow" colspan="13" style="padding:0px;">';
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
                html = '<table class="table table-bordered" cellpadding="5" cellspacing="0" style="border: 1px solid #ddd;">' +
                    '<thead>' +
                    '<tr>' +
                    '<th></th>' +
                    '<th>Product code</th>' +
                    '<th colspan="5">Description</th>' +
                    '<th>Product status</th>' +
                    '<th>Order quantity</th>' +
                    '<th>Receiving quantity</th>' +
                    '<th>Balance quantity</th>' +
                    '<th>UOM</th>' +
                    '<th>Requester</th>';
                //if (isAdmin) {
                //    html += '<th>Action</th>';
                //}
                html += '</tr>' +

                    '</thead> ' +
                    '<tbody>' + detailrows + '</tbody>' +
                    '</table>';
            }
            return html;
        }

        $(document).ready(function () {
            $("#POStatus").append("<b><i>PO status:</i></b><br/>");
            $.each(listStatus, function (i, x) {
                if (x.status_id != "-1") {
                    $("#POStatus").append("<span style='background-color:" + x.color_code + "' class='legend-block'>&nbsp;</span>&nbsp;<i>" + x.status_name + "</i><br/>");
                }
            });

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

            POTable = $('#tblPO').DataTable({
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
                    {
                        "mDataProp": "po_no"
                        ,"mRender": function (d, type, row) {
                            var html = '<a href="detail.aspx?id=' + row.id + '" title="View detail PO">' + row.po_no + '</a>';
                            return html;
                        }
                    },
                    { "mDataProp": "po_sun_code" },
                    { "mDataProp": "document_date" },
                    { "mDataProp": "expected_delivery_date" },
                    {
                        "mDataProp": "vendor"
                        , "mRender": function (d, type, row) {
                            /*var html = '<a href="/workspace/procurement/businesspartner/detail.aspx?id=' + row.vendor + '" title="View detail business partner">' + row.vendor_name + '</a>';*/
                            var html = row.vendor_code + ' - ' + row.vendor_name + '<br>' + row.sundry_name;
                            return html;
                        }
                    },
                    {
                        "mDataProp": "total_amount"
                        , "mRender": function (d, type, row) {
                            return accounting.formatNumber(row.total_amount, 2);
                        }
                    },
                    {
                        "mDataProp": "total_amount_usd"
                        , "mRender": function (d, type, row) {
                            return accounting.formatNumber(row.total_amount_usd, 2);
                        }
                    },
                    { "mDataProp": "remarks" },
                    { "mDataProp": "status" },
                    { "mDataProp": "actions", "visible": isProcurement },
                    { "mDataProp": "details", "visible": false },
                    { "mDataProp": "details_charge_code", "visible": false },
                ],
                "columnDefs": [{
                    "targets": [0],
                    "orderable": false,
                    },
                    {
                        targets: [6,7],
                        className: 'dt-body-right'
                    }
                ],
                "aaSorting": [[3, "asc"]],
                "iDisplayLength": 50
                , "bLengthChange": false
                , "oSearch": { "bSmart": false }
            });

            $('#tblPO_filter input').unbind();
            $('#tblPO_filter input').bind('keyup', function (e) {
                if (e.keyCode == 13) {
                    POTable.search(this.value).draw();
                }
            });

            $(window).keydown(function(event){
                if(event.keyCode == 13) {
                    event.preventDefault();
                    return false;
                }
            });

            $('#tblPO tbody').on('click', '.dropDetail', function () {
                if (!$(this).hasClass('no-sort') && !$(this).hasClass('dropAllDetail')) {
                    var tr = $(this).closest('tr');
                    var row = POTable.row(tr);

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

            $('#tblPO tbody').on("click", ".dropDetailCC", function () {
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

            $.each(POTable.rows().nodes(), function (i) {
                var row = POTable.row(i)
                if(!row.child.isShown()){
                    row.child(format(row.data())).show();
                    $(row.node()).addClass('shown');
                }
            });

            // Handle click on "Collapse All" button
            $('#btn-hide-all-children').on('click', function () {
                $.each(POTable.rows().nodes(), function (i) {
                    var tr = $(this).closest('tr');
                    var row = POTable.row(i);

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
            $.each(POTable.rows().nodes(), function (i) {
                var tr = $(this).closest('tr');
                var row = POTable.row(i);

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

        $(document).on("click", ".checkall", function () {
            var po = $(this).data("po");
            $(".po_" + po).prop("checked", $(this).is(":checked"));
        });

        $(document).on("click", ".item_confirmation", function () {
            var uid = $(this).prop("class").replace("item_confirmation po_", "");
            if (!$(this).is(":checked")) {
                $(".checkall[data-po='" + uid + "']").prop("checked", false);
            }
        });

        $(document).on("click", ".btnCancel", function () {
            _id = $(this).data("po");
            po_no = $(this).data("pono");
            $("#CancelForm").modal("show");
        });

        $(document).on("click", ".btnFileUploadCancel", function () {
            $("#action").val("fileupload");

            $("#file_name").val($(this).closest("div").find("input:file").val().split('\\').pop());
            var filename = $("#file_name").val();
            //filenameupload = $("#file_name").val();

            if (!$("#file_name").val()) {
                alert("Please choose file first");
                return false;
            } else {
                let errorMsg = FileValidation();
                if (FileValidation() !== '') {
                    $("#cform-error-message").html("<b>" + "- Supporting document(s):" + "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" + errorMsg + "<b>");
                    $("#cform-error-box").show();
                    $('.modal-body').animate({ scrollTop: 0 }, 500);

                    return false;
                }

                $("#doc_id").val(_id);
                UploadFileAPI("", this, filename);
                $(this).closest("div").find("input[name$='cancellation.uploaded']").val("1");

            }
        });

        $(document).on("change", "input[name='cancellation_file']", function (e) {
            $("input[name$='cancellation.uploaded']").val("0");
        });

        $(document).on("click", "#btnSaveCancellation", function () {
            var errorMsg = "";
            if ($.trim($("#cancellation_text").val()) == "" && $.trim($("#cancellation_file").val()) == "") {
                errorMsg += "<br/> - Reason for cancellation is required.";
            }
            errorMsg += FileValidation();

            if ($("input[name='cancellation.uploaded']").val() == "0" && $("input[name='cancellation_file']").val()) {
                $("input[name='cancellation_file']").css({ 'background-color': 'rgb(245, 183, 177)' });
                errorMsg += "<br/> - Please upload file first.";
            }

            if (errorMsg == "") {
                $("#doc_id").val(_id);
                /*  uploadCancellationFile();*/
                submitCancellation();
            } else {
                errorMsg = "Please correct the following error(s):" + errorMsg;

                $("#cform-error-message").html("<b>" + errorMsg + "<b>");
                $("#cform-error-box").show();
                $('.modal-body').animate({ scrollTop: 0 }, 500);
            }
        });

        function uploadCancellationFile() {
            $("#action").val("upload");
            var form = $('form')[0];
            var formData = new FormData(form);

            $.ajax({
                type: "POST",
                url: '/Workspace/Procurement/Service.aspx',
                data: formData,
                processData: false,
                contentType: false,
                success: function (response) {
                    var output = JSON.parse(response);
                    if (output.result !== "success") {
                        alert(output.message);
                    } else {
                        submitCancellation();
                    }
                    $("#action").val("");
                }
            });
        }

        function submitCancellation() {
            var data = new Object();
            data.id = _id;
            data.comment = $("#cancellation_text").val();
            data.comment_file = $("#cancellation_file").val();
            $.ajax({
                url: 'Detail.aspx/POCancellation',
                data: JSON.stringify(data),
                dataType: 'json',
                type: 'post',
                contentType: "application/json; charset=utf-8",
                success: function (response) {
                    var output = JSON.parse(response.d);
                    if (output.result != "success") {
                        alert(output.message);
                    } else {
                        alert("Purchase order " + po_no + " has been cancelled successfully");
                        blockScreen();
                        parent.location.href = "List.aspx";
                    }
                }
            });
        }

        $(document).on("click", "#btnRequestForConfirmation", function () {
            var ids = [];
            var pos = [];
            var errorMsg = "";

            $(".item_confirmation:checkbox:checked").each(function () {
                ids.push($(this).val());
                pos.push($(this).data("po"));
            });

            pos = unique(pos);

            if (ids.length == 0) {
                errorMsg += "<br/>- Please select product(s).";
            }
            if (pos.length > 1) {
                errorMsg += "<br/>- Cannot combine multiple PO(s).";
            }

            if (errorMsg != "") {
                showErrorMessage(errorMsg);
            }
            else {
                ids = ids.join(";");
                sendConfirmation(ids);
            }
        });

        $(document).on("click", ".btnConfirm", function () {
            var line_id = $(this).closest("tr").find("[name='po_detail_id']").val();
            sendConfirmation(line_id);
        });

        function sendConfirmation(ids) {
            resetFormConfirmation();
            $("#ConfirmationForm").modal("show");

            loadItems(ids, "PURCHASE ORDER");

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

        $(document).on("click", "#btnCreate", function () {
            location.href = "Input.aspx";
        });

        $(document).on("click", ".btnCloseItem", function () {
            blockScreen();
            parent.location = $(this).data("url");
        });

        $(document).on("click", ".btnClosePO", function () {
            blockScreen();
            parent.location = $(this).data("url");
        });

        $(document).on("click", "#btnClosePOs", function () {
            blockScreen();
            parent.location = "/workspace/procurement/closure/purchaseorder.aspx";
        });

        $(document).on("click", ".btnEdit", function () {
            blockScreen();
            parent.location = $(this).data("url");
        });

        $(document).on("click", "#btnSendConfirmation", function () {
            var errorMsg = "";

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
                    DocList.push(_att);
                });
                _data.documents = DocList;

                var Submission = {
                    submission: JSON.stringify(_data),
                    workflows: JSON.stringify(workflow),
                    deleted: JSON.stringify(deletedSupDocId)
                };

                $.ajax({
                    url: '/workspace/procurement/UserConfirmation/ItemConfirmation.aspx/Submit',
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
        });

        function UploadConfirmFile() {
            var form = $('form')[0];
            var formData = new FormData(form);

            $.ajax({
                type: "POST",
                url: '/Workspace/Procurement/Service.aspx',
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
                        location.reload();
                    }
                }
            });
        }

        function UploadFileAPI(actionType, row, filename) {
            if (actionType == '') {
                blockScreenOL();
            }
            var form = $('form')[0];
            var formData = new FormData(form);
            $.ajax({
                type: "POST",
                <%--url: "<%=service_url%>",--%>
                url: '<%= Page.ResolveUrl("~/" +based_url+ service_url + "") %>',
                data: formData,
                processData: false,
                contentType: false,
                success: function (response) {
                    if (actionType == '') {
                        unBlockScreenOL();
                    }
                    var stringJS = '{' + response.substring(
                        response.indexOf("{") + 1,
                        response.lastIndexOf("}")
                    ) + '}';
                    var output = JSON.parse(stringJS);

                    if (actionType != "submit") {
                        if (output.result == '') {
                            GenerateCancelFileLink(row, filename);
                        } else {
                            alert('Upload file failed');
                        }
                    } else {
                        alert("Request has been " + btnAction + " successfully.");
                        if (btnAction === "saved") {
                            if ($("[name='pr.id']").val() == "") {
                                location.href = "input.aspx?id=" + output.id;
                            } else {
                                location.reload();
                            }
                        } else {
                            location.href = "/workspace/mysubmissions";/*"/workspace/My-Submissions.aspx";*/
                        }
                    }
                }
            });

            $("#file_name").val("");
        }
    </script>
</asp:Content>