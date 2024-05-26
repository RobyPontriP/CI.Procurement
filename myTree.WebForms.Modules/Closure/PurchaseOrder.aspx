<%@ Page MasterPageFile="~/Procurement.Master"  Language="C#" AutoEventWireup="true" CodeBehind="PurchaseOrder.aspx.cs" Inherits="Procurement.Closure.PurchaseOrder" %>
<asp:Content ID="Content1" ContentPlaceHolderID="AppHead" runat="server">
    <title>Purchase Order Closure</title>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="AppBody" runat="server">
    <div class="floatingBox" id="error-box" style="display: none">
        <div class="alert alert-error" id="error-message">
        </div>
    </div>
    <div class="row-fluid">
        <div class="floatingBox">
            <div class="container-fluid">
                <div class="control-group">
                    <div class="text-right">
                        <button id="btnRefresh" class="btn btn-success" type="button" data-action="refresh">Refresh</button>
                    </div>
                </div>
                <div class="control-group">
                    <table id="tblItems" class="table table-bordered" style="border: 1px solid #ddd; width:100%;">
                        <thead>
                            <tr>
                                <th style="text-align:center" colspan="6">Purchase Order information</th>
                                <th style="text-align:center" colspan="3">GRM information</th>
                            </tr>
                            <tr>
                                <th style="width:3%;"><input type="checkbox" id="checkAll" checked="checked"/></th>
                                <th style="width:10%; vertical-align:top;">PO code /<br />OCS PO code</th>
                                <th style="width:7%; vertical-align:top;">PR code</th>
                                <th style="width:25%; vertical-align:top;">Item description</th>
                                <th style="width:5%; vertical-align:top;">Unit</th>
                                <th style="width:5%; vertical-align:top;">Outstanding quantity</th>
                                <th style="width:18%; vertical-align:top;">OCS GRM code</th>
                                <th style="width:17%; vertical-align:top;">OCS GRM date</th>
                                <th style="width:10%; vertical-align:top;">OCS GRM quantity</th>
                            </tr>
                        </thead>
                        <tbody>
                        </tbody>
                    </table>
                    <p></p>
                </div>
                <div class="control-group last">
                    <button id="btnClose" class="btn" type="button">Close page</button>&nbsp;&nbsp;&nbsp;
                    <button id="btnSave" class="btn btn-success" type="button" data-action="saved">Save</button>
                </div>
            </div>
        </div>
    </div>
    <script>
        var adata = <%=listClosure%>;
        var tblItems = initTable();

        function initTable() {
            return $("#tblItems").DataTable({
                data: adata,
                "aoColumns": [
                    {
                        "mDataProp": "po_id"
                        ,"mRender": function (d, type, row) {
                            var html = '<input type="checkbox" checked="checked" name="detail_id" class="detail_id" value="' + row.id + '"/>';
                            return html;
                        }
                    },
                    {
                        "mDataProp": "po_id"
                        ,"mRender": function (d, type, row) {
                            var html = '<a href="/workspace/procurement/purchaseorder/detail.aspx?id=' + row.po_id + '" title="View detail Purchase order" target="_blank">' + row.po_no + '</a>';
                            html += '<br/>' + row.po_sun_code;
                            return html;
                        }
                    },
                    {
                        "mDataProp": "pr_id"
                        ,"mRender": function (d, type, row) {
                            var html = '<a href="/workspace/procurement/purchaserequisition/detail.aspx?id=' + row.pr_id + '" title="View detail Purchase requisition" target="_blank">' + row.pr_no + '</a>';
                            return html;
                        }
                    },
                    {
                        "mDataProp": "item_description"
                        ,"mRender": function (d, type, row) {
                            var html = row.item_code + '<br/>';
                            html += row.item_description;
                            return html;
                        }
                    },
                    { "mDataProp": "uom" },
                    {
                        "mDataProp": "quantity"
                        , "mRender": function (d, type, row) {
                            return accounting.formatNumber(row.quantity, 2);
                        }
                    },
                    {
                        "mDataProp": "GRM_NO"
                        ,"mRender": function (d, type, row) {
                            var html = '<input type="hidden" name="pr_detail_id" value="' + row.pr_detail_id + '"/>';
                            html += '<input type="hidden" name="grm_line" value="' + row.GRM_LINE + '"/>';
                            html += '<input type="hidden" name="unit_price" value="' + row.unit_price + '"/>';
                            html += '<input type="hidden" name="exchange_rate" value="' + row.exchange_rate + '"/>';
                            html += '<input type="hidden" name="exchange_sign" value="' + row.exchange_sign + '"/>';
                            html += '<input type="text" maxlength="50" name="grm_no" data-id="' + row.id + '" class="span12" value="' + $.trim(row.GRM_NO) + '"/>';
                            return html;
                        }
                    },
                    {
                        "mDataProp": "GRM_DATE"
                        , "mRender": function (d, type, row) {
                            var html = '<div class="input-prepend"><span class="add-on icon-calendar _grm_date"></span>';
                            html += '<input type="text" maxlength="11" name="grm_date" data-id="' + row.id + '" class="span9 date" readonly="readonly" data-date="' + row.GRM_DATE + '"/></div>';
                            return html;
                        }
                    },
                    {
                        "mDataProp": "GRM_QTY"
                        , "mRender": function (d, type, row) {
                            var html = '<input type="text" maxlength="50" name="grm_quantity" data-title="' + row.po_no + ': ' + row.item_code + '" data-min-quantity="' + row.min_quantity + '" data-id="' + row.id + '" class="span12 number" data-decimal-places="2" value="' + row.GRM_QTY + '"/>';
                            return html;
                        }
                    },
                ],
                "bFilter": false, "bDestroy": true, "bRetrieve": true,
                "searching": false,
                "info": false,
                "ordering": false,
                "paging": false,
                "columnDefs": [ 
                    {
                        targets: [5],
                        className: 'dt-body-right'
                 }],
            });
        }

        $(document).ready(function () {
            $("._grm_date").datepicker({
                format: "dd M yyyy"
                , autoclose: true
            }).on("changeDate", function () {
                $(this).closest('tr').find('[name="grm_date"]').val($(this).data('date'));
                $(this).datepicker('hide');
            });     

            $("._grm_date").each(function () {
                var _date = $(this).closest('tr').find('[name="grm_date"]').data('date');
                if (_date != "" && _date != null) {
                    try {
                        _date = new Date(_date);
                        $(this).datepicker("setDate", _date).trigger("changeDate");
                    } catch (e) {

                    }
                }
            });

            repopulateNumber();
        });

        $(document).on("click", "#checkAll", function () {
            $(".detail_id").prop("checked", $(this).is(":checked"));
        });

        $(document).on("click", ".detail_id", function () {
            if (!$(this).is(":checked")) {
                $("#checkAll").prop("checked", $(this).is(":checked"));
            }
        });

        $(document).on("click", "#btnRefresh", function () {
            blockScreen();
            location.reload();
        });

        $(document).on("click", "#btnSave", function () {
            var data = [];
            $("[name='detail_id']:checkbox:checked").each(function () {
                var obj = new Object();
                obj.base_type = "PURCHASE ORDER";
                obj.base_id = $(this).val();
                obj.pr_detail_id = $(this).closest('tr').find('[name="pr_detail_id"]').val();
                obj.grm_no = $(this).closest('tr').find('[name="grm_no"]').val();
                obj.grm_line = $(this).closest('tr').find('[name="grm_line"]').val();
                if (obj.grm_line == "null" || obj.grm_line == "") {
                    obj.grm_line = 0;
                }
                obj.close_date = $(this).closest('tr').find('[name="grm_date"]').val();
                obj.min_quantity = delCommas($(this).closest('tr').find('[name="grm_quantity"]').data("min-quantity"));
                obj.error_qty = $(this).closest('tr').find('[name="grm_quantity"]').data("title");
                obj.quantity = delCommas($(this).closest('tr').find('[name="grm_quantity"]').val());
                obj.unit_price = delCommas($(this).closest('tr').find('[name="unit_price"]').val());
                obj.actual_amount = delCommas(accounting.formatNumber(obj.quantity * obj.unit_price, 2));
                var exchange_sign = $(this).closest('tr').find('[name="exchange_sign"]').val();
                var exchange_rate = delCommas($(this).closest('tr').find('[name="exchange_rate"]').val());
                if (exchange_sign == "/") {
                    obj.actual_amount_usd = delCommas(accounting.formatNumber(obj.quantity * obj.unit_price / exchange_rate, 2));
                }else if (exchange_sign == "*") {
                    obj.actual_amount_usd = delCommas(accounting.formatNumber(obj.quantity * obj.unit_price * exchange_rate, 2));
                }
                obj.reason_for_closing = "GRM";
                data.push(obj);
            });

            var errMsg = "";
            var errNo = 0;
            var errDate = 0;
            var errQty = 0;
            var errMinQty = [];
            $(data).each(function (i, d) {
                if ($.trim(d.grm_no) == "") {
                    errNo++;
                }
                if ($.trim(d.close_date) == "") {
                    errDate++;
                }
                if (delCommas(d.quantity) == 0) {
                    errQty++;
                }
                if (delCommas(d.quantity) > delCommas(d.min_quantity)) {
                    errMinQty.push("<br/>- Minimun quantity for " + d.error_qty + " is " + accounting.formatNumber(delCommas(d.min_quantity), 2));
                }
            });

            if (data.length == 0) {
                errMsg += "<br/>- Item is required."
            }
            if (errNo > 0) {
                errMsg += "<br/>- OCS GRM code is required."
            }
            if (errDate > 0) {
                errMsg += "<br/>- OCS GRM date is required."
            }
            if (errQty > 0) {
                errMsg += "<br/>- OCS GRM quantity is required."
            }
            if (errMinQty.length > 0) {
                errMinQty = errMinQty.join("");
                errMsg += errMinQty;
            }
        

            if (errMsg !== "") {
                showErrorMessage(errMsg);

                return false;
            } else {
                var _data = { "submission": JSON.stringify(data) };
                $.ajax({
                url: 'PurchaseOrder.aspx/Save',
                data: JSON.stringify(_data),
                dataType: 'json',
                type: 'post',
                contentType: "application/json; charset=utf-8",
                success: function (response) {
                    var output = JSON.parse(response.d);
                    if (output.result !== "success") {
                        alert(output.message);
                    } else {
                        blockScreen();
                        alert("GRM has been saved successfully.")
                        parent.location.href = "/workspace/procurement/purchaseorder/list.aspx";
                    }
                }
            });
            }
        });

        $(document).on("click", "#btnClose", function () {
            parent.location.href = "/workspace/procurement/purchaseorder/list.aspx";
        });
    </script>
</asp:Content>