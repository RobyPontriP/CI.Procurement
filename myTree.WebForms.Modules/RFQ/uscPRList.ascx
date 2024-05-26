<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="uscPRList.ascx.cs" Inherits="myTree.WebForms.Modules.RFQ.uscPRList" %>
<div class="control-group">
    <label class="control-label">
        Submission date
    </label>
    <div class="controls">
        <div class="input-prepend" style="margin-right:-32px;">
            <input type="text" name="startDate" id="_startDate" data-title="Start date" data-validation="required" class="span8" readonly="readonly" placeholder="Start date" maxlength="11" value="" />
            <span class="add-on icon-calendar" id="startDate"></span>
        </div>
        To&nbsp;&nbsp;&nbsp;
        <div class="input-prepend">
            <input type="text" name="endDate" id="_endDate" data-title="End date" data-validation="required" class="span8" readonly="readonly" placeholder="End date" maxlength="11" value="" />
            <span class="add-on icon-calendar" id="endDate"></span>
        </div>
    </div>
</div>
<div class="control-group">
    <label class="control-label">
        Purchase office
    </label>
    <div class="controls">
        <select id="cboOffice" data-title="Purchase office" data-validation="required" name="cifor_office" class="span6">
            <% if (isMultipleOffice)
                { %>
            <option value="ALL">ALL PURCHASE OFFICES</option>
            <% } %>
        </select>
    </div>
</div>
<div class="control-group">
    <div class="controls">
        <button type="submit" id="btnSearch" class="btn btn-success">Search</button>
    </div>
</div>
<div class="control-group last">
    <div style="width: 97%; overflow-x: auto; display: block;">
        <table id="tblPR" class="table table-bordered" style="border: 1px solid #ddd;">
            <thead>
                <tr>
                    <th style="width:5%">&nbsp;</th>
                    <th style="width:12%;">PR code</th>
                    <th style="width:10%;">Created date</th>
                    <th style="width:10%;">Submission date</th>
                    <th style="width:15%;">Requester</th>
                    <th style="width:10%;">Purchase office</th>
                    <th style="width:10%;">Required date</th>
                    <th style="width:15%;">Remarks</th>
                    <th style="width:8%;">Status</th>
                </tr>
            </thead>
            <tbody>
            </tbody>
        </table>
    </div>
</div>
<script>
    var listOffice = <%=listOffice%>;
    var startDate = new Date("<%=startDate%>");
    var endDate = new Date("<%=endDate%>");
    var cifor_office = "<%=cifor_office%>";
    var isAllTax = "<%=isAllTax%>";

    var __pr_line_id = "<%=pr_line_id%>";

    var mainData = <%=listPR%>;

    var PRTable;
    var PRLineChecked = [];

 
    $(document).on("click", "#btnSearch", function () {
        var errorMsg = "";
        errorMsg += GeneralValidation();

        if (errorMsg !== "") {
            showErrorMessage(errorMsg);

            return false;
        } 
    });

    function setPRChecked() {

        $("[name='checkPR']:checkbox:checked").each(function () {
            PRLineChecked.push($(this).val());
        });
        PRLineChecked = unique(PRLineChecked);
    }
    function removePRChecked(value) {

        let arr = PRLineChecked;
        arr = arr.filter(item => item !== value)
        PRLineChecked = unique(arr);
    }

    function format(d) {
        var html = "";
        if (typeof d !== "undefined") {
            var _d = JSON.parse(d.details);
            var detailrows = "";
            $.each(_d, function (i, x) {
                if (x.id != "") {
                    detailrows += '<tr style="background-color:' + x.color_code + '; color:' + x.font_color + '">' +
                        '<td><input type="checkbox" name="checkPR" data-pr="' + d.id + '" value="' + x.id + '"/></td > ' +
                        '<td class="item_code wrapCol">' + x.item_code + '</td>' +
                        '<td class="description wrapCol">' + x.description + '</td>' +
                        '<td class="status wrapCol">' + x.status + '</td>' +
                        '<td class="request_qty wrapCol" style="text-align:right;">' + accounting.formatNumber(delCommas(x.request_qty), 2) + '</td>' +
                        '<td class="request_qty wrapCol" style="text-align:right;">' + accounting.formatNumber(delCommas(x.po_qty), 2) + '</td>' +
                        '<td class="request_qty wrapCol" style="text-align:right;">' + accounting.formatNumber(delCommas(x.grm_qty), 2) + '</td>' +
                        '<td class="uom_name wrapCol">' + x.uom_name + '</td>' +
                        '<td class="cost_estimated wrapCol" style="text-align:right;">' + x.estimated_cost + '</td>' +
                        '<td class="exchange_rate wrapCol" style="text-align:right;">' + x.exchange_rate + '</td>' +
                        '<td class="cost_estimated_usd wrapCol" style="text-align:right;">' + x.estimated_cost_usd + '</td>' +
                        '<td class="quotations wrapCol">' + x.attachment + '</td>' +
                        '</tr >' +
                        '<tr>' +
                        '<td colspan="12"><i name="cc-collapse" data-item="' + x.id + '" class="icon-chevron-sign-down dropDetail" title="View Charge code(s)"></i >&nbsp&nbsp<b> Charge code(s)</b></td >' +
                        '</tr > ';
                } else {
                    detailrows += '<tr><td colspan="12" style="text-align:center; font-style:italic;">No data available</td></tr>'
                }
                

                    detailrows += '<tr id="tblCostCenters_' + x.id + '"><td colspan="12">' +
                    '<table  class="table table-bordered table-striped" style="table-layout: fixed;">' +
                    '<thead>' +
                    '<tr>' +
                    '<th style="text-align: center; word-wrap: break-word; width: 25%;">Cost center' +
                    '</th>' +
                    '<th style="text-align: center; word-wrap: break-word; width: 30%;">Work order' +
                    '</th>' +
                    '<th style="text-align: center; word-wrap: break-word; width: 25%;">Entity' +
                    '</th>' +
                    '<th style="text-align: center; word-wrap: break-word; width: 10%;">Legal Entity' +
                    '</th>' +
                    '<th style="text-align: center; word-wrap: break-word; width: 25%;" hidden>Control Account' +
                    '</th>' +
                    '<th style="text-align: center; word-wrap: break-word; width: 7%;">%' +
                    '</th>' +
                    '<th id="lbItemAmt" style="text-align: center; word-wrap: break-word; width: 20%;">Amount(' + x.currency_id + ')'+
                    '</th>' +
                    '<th style="text-align: center; word-wrap: break-word; width: 20%;">Amount(USD)' +
                    '</th>' +
                    '<th style="text-align: center; word-wrap: break-word; width: 25%;">Remarks' +
                    '</th>' +
                    '</tr>' +
                    '</thead>' +
                    '<tbody>';

                if (x.detail != "") {
                    var _chargecode = JSON.parse(x.detail);
                    $.each(_chargecode, function (i, c) {
                        detailrows += '<tr>' +
                            '<td>' + c.cost_center + '</td>' +
                            '<td>' + c.work_order_code + ' - ' + c.work_order_description + '</td>' +
                            '<td>' + c.entity_id + '</td>' +
                            '<td>' + c.legal_entity + '</td>' +
                            '<td  style="text-align:center;">' + c.percentage + '</td>' +
                            '<td  style="text-align:right;">' + accounting.formatNumber(delCommas(c.amount), 2) + '</td>' +
                            '<td  style="text-align:right;">' + accounting.formatNumber(delCommas(c.amount_usd), 2) + '</td>' +
                            '<td>' + c.remarks + '</td>' +
                            '</tr>';
                    });
                } else {
                    detailrows += '<tr><td colspan="8" style="text-align:center; font-style:italic;">No data available</td></tr>'
                }

                detailrows +=    '</tbody>' +
                        '</table>' +
                    '</td ></tr > ';
            });

            html = '<table class="table table-bordered" cellpadding="5" cellspacing="0" style="border: 1px solid #ddd;">' +
                '<thead>' +
                '<tr>' +
                '<th><input type="checkbox" name="checkAll" data-pr="' + d.id + '"/></th>' +
                '<th class="wrapCol">Product code</th>' +
                '<th class="wrapCol">Description</th>' +
                '<th class="wrapCol">Product status</th>' +
                '<th class="wrapCol">Request qty.</th>' +
                '<th class="wrapCol">Order qty.</th>' +
                '<th class="wrapCol">Received qty.</th>' +
                '<th class="wrapCol">UOM</th>' +
                '<th class="wrapCol">Cost estimated</th>' +
                '<th class="wrapCol">Exchange rate (to USD)</th>' +
                '<th class="wrapCol">Cost estimated (USD)</th>' +
                '<th class="wrapCol">Quotations</th>';
            html += '</tr>' +
                '</thead> ' +
                '<tbody>' + detailrows + '</tbody>' +
                '</table>';
        }
        return html;
    }

    $(document).ready(function () {
        var cboOffice = $("#cboOffice");
        //generateComboGroup(cboOffice, listOffice, "office_id", "office_name", "hub_option", true);
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
            "bFilter": true, "bDestroy": true, "bRetrieve": true, 
            "lengthMenu": [[50, 100, -1], [50, 100, "All"]],
            "fnRowCallback": function( nRow, aData, iDisplayIndex ) {  
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
                    "mDataProp": "pr_no"
                    ,"mRender": function (d, type, row) {
                        var html = '<a href="<%=Page.ResolveUrl("~/purchaserequisition/detail.aspx?id=' + row.id + '")%>" target="_blank" title="View detail">' + row.pr_no + '</a>';
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
                { "mDataProp": "details", "visible": false },
            ],
            "columnDefs": [ {
                "targets": [0],
                "orderable": false
            },
            {className: "wrapCol", "targets":[1, 2, 3, 4, 5, 7, 8, 9]}],
            "aaSorting": [[3, "asc"]],
            "paging": false
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
  
        $('#tblPR tbody').on('click', 'i[class^="icon-chevron"]', function () {
            if (!$(this).hasClass('no-sort')) {
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

        $.each(PRTable.rows().nodes(), function (i) {
            var row = PRTable.row(i)
            if(!row.child.isShown()){
                row.child(format(row.data())).show();
                $(row.node()).addClass('shown');
            }
        });

        // Handle click on "Collapse All" button
        $('#btn-hide-all-children').on('click', function(){
            PRTable.rows().every(function(){
                if(this.child.isShown()){
                    this.child.hide();
                    $(this.node()).removeClass('shown');
                }
            });
        });

        $("[name='checkPR'][value='" + __pr_line_id + "']").prop("checked", true);

        normalizeMultilines();
        setPRChecked();
    });

    $(document).on("click", "[name='checkAll']", function () {

        if (!$(this).is(":checked")) {
            $("[name='checkPR'][data-pr='" + $(this).data("pr") + "']").each(function () {
                $(this).prop("checked", false);
                removePRChecked($(this).val());
            });
        } else {
            $("[name='checkPR'][data-pr='" + $(this).data("pr") + "']").prop("checked", $(this).is(":checked"));
            setPRChecked();
        }
    });

    $(document).on("click", "[name='checkPR']", function () {
        if (!$(this).is(":checked")) {
            $("[name='checkAll'][data-pr='" + $(this).data("pr") + "']").prop("checked", $(this).is(":checked"));
            removePRChecked($(this).val())
        } else {
            setPRChecked(); 
        }
    });

    $(document).on('click', 'i[name^="cc-collapse"]', function () {
        var tbid = "#tblCostCenters_" + $(this).attr("data-item");
        if (!$(tbid).hasClass('cc-hide')) {
            $(tbid).css("display", "none");
            $(tbid).addClass('cc-hide');
            $(this).removeClass('icon-chevron-sign-down')
            $(this).addClass('icon-chevron-sign-right');
        } else {
            $(tbid).css("display", "");
            $(tbid).removeClass('cc-hide');
            $(this).removeClass('icon-chevron-sign-right');
            $(this).addClass('icon-chevron-sign-down');
        }
    });

    function validatePR() {
        var errorMsgPR = "";
        if (PRLineChecked.length == 0) {
            errorMsgPR += "<br/>- Item(s) is required.";
        }

        return errorMsgPR
    }
</script>