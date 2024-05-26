<%@ Page MasterPageFile="~/Procurement.Master" Language="C#" AutoEventWireup="true" CodeBehind="detail.aspx.cs" Inherits="Procurement.Closure.detail" %>
<asp:Content ID="Content1" ContentPlaceHolderID="AppHead" runat="server">
    <title>Item Closure</title>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="AppBody" runat="server">
    <div class="floatingBox" id="error-box" style="display: none">
        <div class="alert alert-error" id="error-message">
        </div>
    </div>
    <div class="row-fluid">
        <div class="floatingBox">
            <div class="container-fluid">
                <div class="control-group po_source">
                    <label class="control-label">
                        PO code
                    </label>
                    <div class="controls labelDetail">
                        <%=ic.po_code %>
                        <input type="hidden" name="ic.base_id" value="<%=base_id %>"/>
                        <input type="hidden" name="ic.base_type" value="<%=base_type %>"/>
                        <input type="hidden" name="ic.pr_detail_id" value="<%=ic.pr_detail_id %>"/>
                    </div>
                </div>
                <div class="control-group">
                    <label class="control-label">
                        PR code
                    </label>
                    <div class="controls labelDetail">
                        <%=ic.pr_code %>
                    </div>
                </div>
                <div class="control-group">
                    <label class="control-label">
                        Product code
                    </label>
                    <div class="controls labelDetail">
                        <%=ic.item_code %>
                    </div>
                </div>
                <div class="control-group">
                    <label class="control-label">
                        Product description
                    </label>
                    <div class="controls labelDetail">
                        <%=ic.item_description %>
                    </div>
                </div>
                <div class="control-group">
                    <label class="control-label" id="label-quantity">
                        PO quantity
                    </label>
                    <div class="controls labelDetail">
                        <%=ic.po_quantity %> <%=ic.uom %>
                    </div>
                </div>
<%--                <div class="control-group">
                    <label class="control-label">
                        Requester / Initiator confirmation date
                    </label>
                    <div class="controls labelDetail">
                        <%=ic.confirm_date %>
                    </div>
                </div>--%>
                <div class="control-group">
                    <label class="control-label">
                        Reason for closing
                    </label>
                    <div class="controls labelDetail">
                        <%=ic.reason_for_closing_name %>
                    </div>
                </div>
                <div class="control-group po_source grm">
                    <label class="control-label">
                        GRM code
                    </label>
                    <div class="controls labelDetail">
                        <%=ic.grm_no %>
                    </div>
                </div>
                <div class="control-group">
                    <label class="control-label" id="label-date">
                        Close date
                    </label>
                    <div class="controls labelDetail">
                        <%=ic.close_date %>
                    </div>
                </div>
                <div class="control-group">
                    <label class="control-label" id="label-actual-quantity">
                        Actual quantity
                    </label>
                    <div class="controls labelDetail">
                        <%=ic.quantity %>
                    </div>
                </div>
                <div class="control-group pr_source">
                    <label class="control-label">
                        Direct purchase actual supplier
                    </label>
                    <div class="controls labelDetail">
                        <%=ic.actual_vendor %>
                    </div>
                </div>
                <div class="control-group">
                    <label class="control-label">
                        Estimated value
                    </label>
                    <div class="controls labelDetail">
                        <%=ic.pr_currency_id %> <%=ic.estimated_cost %> / USD <%=ic.estimated_cost_usd %>
                    </div>
                </div>
                <div class="control-group po_source">
                    <label class="control-label">
                        PO value
                    </label>
                    <div class="controls labelDetail">
                        <%=ic.po_currency_id %> <%=ic.po_cost %> / USD <%=ic.po_cost_usd %>
                    </div>
                </div>
                <div class="control-group">
                    <label class="control-label">
                        Actual value
                    </label>
                    <div class="controls labelDetail">
                        <%=ic.po_currency_id %> <span id="actual_value"></span> / USD <span id="actual_value_usd"></span>
                    </div>
                </div>
                <div id="supporting_docs" class="control-group">
                    <label class="control-label">
                        Supporting document(s)
                    </label>
                    <div class="controls">
                        <table id="tblAttachment" data-title="Supporting document(s)" class="table table-bordered table-hover" style="border: 1px solid #ddd">
                            <thead>
                                <tr>
                                    <th style="width:50%;">Description</th>
                                    <th style="width:50%;">File</th>
                                </tr>
                            </thead>
                            <tbody>
                            </tbody>
                        </table>
                    </div>
                </div>
                <div id="section_remarks" class="control-group last">
                    <label class="control-label">
                        Remarks
                    </label>
                    <div class="controls labelDetail">
                        <%=ic.remarks %>
                    </div>
                </div>
                <div class="control-group required last">
                    <div class="controls">
                        <button id="btnClose" class="btn" type="button">Close page</button>&nbsp;&nbsp;&nbsp;
                    </div>
                </div>
                <input type="hidden" name="doc_id" value=""/>
                <input type="hidden" name="doc_type" value="CLOSURE"/>
                <input type="hidden" name="action" value=""/>
            </div>
        </div>
    </div>
    <script>
        const base_type = $("[name='ic.base_type']").val();
        const currency = "<%=ic.po_currency_id%>";
        const unit_price = "<%=ic.unit_price%>";
        const listCurrency = <%=listCurrency%>;
        const is_direct_purchase = "<%=is_direct_purchase%>";
        var listAttachment = <%=listAttachment%>;
        
        let arr = $.grep(listCurrency, function (n, i) {
            return n["CURRENCY_CODE"] == currency;
        });
        const exchange_rate = arr[0].RATE;
        const exchange_sign = arr[0].OPERATOR;

        $(document).ready(function () {
            controlValidation();

            $("#actual_value").text("<%=ic.actual_amount%>");
            $("#actual_value_usd").text("<%=ic.actual_amount_usd%>");

            $.each(listAttachment, function (i, d) {
                addAttachment(d.id, "", d.file_description, d.filename);
            });

            repopulateNumber();

            changeMethod();
        });

        function controlValidation() {
            if (String(base_type).toLowerCase() == "purchase requisition") {
                $("[name='ic.reason_for_closing'] option[value='GRM']").remove();
                $(".po_source").hide();
                $("[name='ic.grm_no']").data("validation", "");
                $("#label-quantity").text("PR quantity");
                if (is_direct_purchase == "1") {
                    $("[name='ic.reason_for_closing']").val("DIRECT PURCHASE").trigger("change");
                }
            } else if (String(base_type).toLowerCase() == "purchase order") {
                $("[name='ic.reason_for_closing'] option[value='DIRECT PURCHASE']").remove();
                $("[name='ic.grm_no']").data("validation", "required");
                $(".pr_source").hide();
                $("#label-quantity").text("PO quantity");
            }
        }

        function changeMethod() {
            const method = "<%=ic.reason_for_closing %>";

            $(".grm").hide();


            if (method == "GRM") {
                $("#label-date").text("GRM date");
                $("[name='ic.close_date']").data("title", "GRM date");
                $(".grm").show();
            } else if (method == "MANUAL") {
                $("#label-date").text("Close date");
                $("[name='ic.close_date']").data("title", "Close date");
            } else if (method == "DIRECT PURCHASE") {
                let dp_qty = 0;
                let _po_qty = "<%=ic.po_quantity%>";
                let _remaining_qty = "<%=ic.remaining_quantity%>";

                dp_qty = _po_qty;
                if (delCommas(_po_qty) > delCommas(_remaining_qty)) {
                    dp_qty = _remaining_qty;
                }

                $("#label-date").text("Direct purchase actual date");
                $("[name='ic.close_date']").data("title", "Direct purchase actual date");
            }
        }

        function addAttachment(id, uid, description, filename) {
            description = NormalizeString(description);
            var base_id = $("[name='ic.base_id']").val();
            if (uid === "" || typeof uid === "undefined" || uid === null) {
                var uid = guid();
            }

            var html = '<tr>';
            html += '<td>' + description + '</td>';
            html += '<td><span class="linkDocument"><a href="Files/' + <%=_id%> + '/' + filename + '" target="_blank">' + filename + '</a>&nbsp;</span></td >';
            html += '</tr>';
            $("#tblAttachment tbody").append(html);
        }

        $(document).on("click", "#btnClose", function () {
            blockScreen();
            switch (base_type.toLowerCase()) {
                case "purchase order":
                    parent.location.href = "/procurement/purchaseorder/List.aspx";
                    break;
                case "purchase requisition":
                    parent.location.href = "/procurement/purchaserequisition/list.aspx";
                    break;
                default:
                    break;
            }
        });
    </script>
</asp:Content>
