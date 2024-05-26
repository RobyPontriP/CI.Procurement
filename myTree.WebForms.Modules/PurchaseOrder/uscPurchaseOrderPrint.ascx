<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="uscPurchaseOrderPrint.ascx.cs" Inherits="Procurement.PurchaseOrder.uscPurchaseOrderPrint" %>

<style>
    #POdraft .row-fluid {
        margin-bottom: 0px !important;
    }

    #tblPODraft td {
        vertical-align: top;
    }

    @media screen {
        div.divFooter {
            /*display: none;*/
            position: fixed;
            bottom: 0;
            text-align: center;
        }
    }

    @media print {
        div.divFooter {
            position: fixed;
            bottom: 0;
            text-align: center;
        }
    }
</style>
<div id="POdraft">
    <input type="hidden" id="status" value="<%=PO.status_id %>" />
    <input type="hidden" id="po_no" value="<%=PO.po_no %>" />
    <input type="hidden" id="po_number" value="<%=PO.po_no %>" />
    <input type="hidden" id="po_remark" value="<%=PO.remarks %>" />
    <table id="tblPODraft" style="border: 0px; width: 100%;">
        <tr class="noborder">
            <td style="width: 15%;"></td>
            <td style="width: 35%;"></td>
            <td style="width: 10%;"></td>
            <td style="width: 15%;"></td>
            <td style="width: 25%;"></td>
        </tr>

        <tr class="noborder">
            <td>
                <label>To</label></td>
            <td>
                <label><%=PO.vendor_name %></label></td>
            <td>&nbsp;</td>
            <td style="width: 25%;">
                <label>P.O. number</label></td>

            <% if (string.IsNullOrEmpty(PO.po_sun_code))
                { %>
            <td colspan="2">
                <label><b><%=PO.po_no %>/(OCS PO Number - New)</b></label></td>
            <% }
                else
                { %>
            <td colspan="2">
                <label><b><%=PO.po_no %> / <%=PO.po_sun_code %></b></label></td>
            <%}%>
        </tr>
        <tr class="noborder">
            <td rowspan="2">&nbsp;</td>
            <td rowspan="2">
                <label><%=PO.vendor_address %></label></td>
            <td rowspan="2">&nbsp;</td>
            <td>
                <label>P.O. date</label></td>
            <td colspan="2">
                <label><%=PO.document_date %></label></td>
        </tr>

        <tr class="noborder" id="po_delivery_date">
            <td>
                <label>Delivery date</label></td>
            <td colspan="2">
                <label><%=PO.expected_delivery_date %></label></td>
            <td style="width: 10%;">&nbsp;</td>
            <td style="width: 15%;">&nbsp;</td>
            <td style="width: 25%;">&nbsp;</td>
        </tr>
        <tr class="noborder" id="po_payment_term">
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>
                <label>Payment terms</label></td>
            <td colspan="2">
                <label class="multilines"><%=PO.term_of_payment_name %></label></td>
        </tr>
        <% if (PO.is_other_term_of_payment == "1")
            { %>
        <tr class="noborder">
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>
                <label>Other term of payment</label></td>
            <td colspan="2">
                <label class="multilines"><%=PO.other_term_of_payment %></label></td>
        </tr>
        <% }%>

        <tr class="noborder">
            <td>
                <label>Telephone</label></td>
            <td>
                <label><%=PO.vendor_telp_no %></label></td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
        </tr>
        <tr class="noborder">
            <td>
                <label>Fax / Telex</label></td>
            <td>
                <label><%=PO.vendor_fax_no %></label></td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
        </tr>
        <tr class="noborder">
            <td>
                <label>Contact person</label></td>
            <td>
                <label><%=PO.vendor_contact_person %></label></td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
        </tr>
        <tr class="noborder">
            <td>
                <label>Email</label></td>
            <td>
                <label><%=PO.vendor_contact_person_to_email%></label></td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
        </tr>
        <tr class="noborder">
            <td>
                <label>Order reffered to</label></td>
            <td>
                <label><%=PO.order_reference %></label></td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
        </tr>
        <tr class="noborder">
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
        </tr>
        <tr>
            <%--<td colspan="5" style="border-top:2;">--%>
            <td colspan="6">
                <table id="tblPODetail" class="table table-bordered" style="border: 1px solid #ddd; width: 100%;">
                    <thead>
                        <%--  <tr style="border-left: 1px solid transparent; border-right: 1px solid transparent;">
                            <th colspan="8"></th>
                        </tr>--%>
                        <tr>
                            <th>No</th>
                            <%--<th>Product code</th>--%>
                            <th>Description</th>
                            <%--<th>Product status</th>--%>
                            <th style="text-align: right;">Quantity</th>
                            <th>Unit of measure</th>
                            <%--<th>Currency</th>--%>
                            <th style="text-align: right;">Unit price in <%=PO.currency_id %></th>
                            <%--<th style="text-align:right;">Discount</th>
                            <th style="text-align:right;">Additional discount</th>--%>
                            <th style="text-align: right;">Sub total</th>
                            <th style="text-align: right;">Discount in <%=PO.currency_id %></th>
                            <%--<th>VAT code</th>
                            <th>VAT payable?</th>--%>
                            <%--<th style="text-align:right;">VAT amount per unit</th>
                            <th style="text-align:right;">Total VAT amount</th>--%>
                            <th style="text-align: right;">Total in <%=PO.currency_id %></th>
                        </tr>
                    </thead>
                    <tbody>
                    </tbody>
                    <tfoot>
                        <tr>
                            <%--<th style="border-left:1px solid #ddd !important;" rowspan="4" colspan="4">Remarks</th>--%>
                            <th style="border-left: 1px solid #ddd !important; text-align: left !important;" rowspan="5" colspan="4" class="">Remarks:
                                
                                <p style="font-weight:normal"><%=PO.remarks %></p>
                                </th>
                            <th style="font-weight: bold; text-align: right !important; border-left: 1px solid transparent; text-align: right;" colspan="2">Total amount:</th>
                            <th style="font-weight: bold; text-align: right; border-left: 1px solid transparent;" colspan="2"><%=PO.currency_id %> <%=PO.gross_amount %></th>
                        </tr>
                        <tr>
                            <th style="font-weight: bold; border-top: 1px solid transparent; text-align: right;" colspan="2">Total discount:</th>
                            <th style="font-weight: bold; text-align: right; border-left: 1px solid transparent; border-top: 1px solid transparent;" colspan="2"><%=PO.currency_id %> <%=str_discount %></th>
                        </tr>

                        <tr>
                            <th style="font-weight: bold; border-top: 1px solid transparent; text-align: right;" colspan="2">Additional discount:</th>
                            <%--<th style="font-weight:bold; text-align:right; border-left: 1px solid transparent; border-top: 1px solid transparent;"><%=PO.currency_id %> <%=str_vat_amount %>&nbsp /&nbsp USD <%=str_vat_amount_usd %></th>--%>
                            <th style="font-weight: bold; text-align: right; border-left: 1px solid transparent; border-top: 1px solid transparent;" colspan="2"><%=PO.currency_id %> <%=str_additional_discount %></th>
                        </tr>

                        <tr>
                            <th style="font-weight: bold; border-top: 1px solid transparent; text-align: right;" colspan="2">VAT:</th>
                            <% if (PO.currency_id.ToLower() == "usd")
                                { %>
                            <th style="font-weight: bold; text-align: right; border-left: 1px solid transparent; border-top: 1px solid transparent;" colspan="2"><%=PO.currency_id %> <%=str_vat_amount %></th>
                            <% }
                                else
                                { %>
                            <th style="font-weight: bold; text-align: right; border-left: 1px solid transparent; border-top: 1px solid transparent;" colspan="2"><%=PO.currency_id %> <%=str_vat_amount %>&nbsp /&nbsp USD <%=str_vat_amount_usd %></th>
                            <%}%>
                        </tr>

                        <tr>
                            <th style="font-weight: bold; border-top: 1px solid transparent; text-align: right;" colspan="2">Grand total:</th>
                            <% if (PO.currency_id.ToLower() == "usd")
                                { %>
                            <th style="font-weight: bold; text-align: right; border-left: 1px solid transparent; border-top: 1px solid transparent;" colspan="2"><%=PO.currency_id %> <%=str_total_amount %></th>
                            <% }
                                else
                                { %>
                            <th style="font-weight: bold; text-align: right; border-left: 1px solid transparent; border-top: 1px solid transparent;" colspan="2"><%=PO.currency_id %> <%=str_total_amount %>&nbsp /&nbsp USD <%=str_total_amount_usd %></th>
                            <%}%>
                        </tr>
                    </tfoot>
                </table>
            </td>
        </tr>
        <tr class="noborder">
            <td colspan="3">
                <% if (PO.is_other_address == "1")
                    { %>
                <label>
                    Delivery address:<br />
                    <%=PO.other_address%>
                </label>
                <% }
                    else
                    { %>
                <label>
                    Delivery address:<br />
                    <%=PO.cifor_delivery_address %>
                </label>
                <%}%>
                
            </td>
            <%--<td>&nbsp;</td>--%>
            <td colspan="2">
                <label align="justify">
                    <%--Order number must appear on all invoices, advice notes, delivery notes, shipping documents and correspondence to expedite processing of invoices.--%>
                </label>
            </td>
        </tr>
        <tr class="noborder for-print">
            <td colspan="5">&nbsp;</td>
        </tr>
        <tr class="noborder for-print">
            <td colspan="4">&nbsp;</td>
            <td colspan="2" style="text-align: center;">
                <label>
                    <% if (PO.legal_entity.ToLower() == "cifor" || PO.legal_entity.ToLower() == "germany")
                        { %>
                        Authorized for CIFOR
                    <% }
                        else
                        { %>
                        Authorized for ICRAF
                    <%}%>

                    <br />
                    <br />
                    <%=approver_name %><br />
                    <%=approver_title %><br />
                    Approved date: <%=approver_date %><br />
                    <br />
                </label>
            </td>
        </tr>
        <%--     <tr class="noborder for-print">
            <td colspan="5">
                <label>CIFOR is a recognize International non-profit organization and is exempt from Indonesian V.A.T according to article 7 of the headquarters agreement.</label><br />
            </td>
        </tr>
        <tr class="noborder for-print">
            <td colspan="5" style="text-align: center; font-size: 9px;">This is a computer-generated document. No signature is required.</td>
        </tr>--%>
    </table>
</div>
<%--<div class="divFooter"><label style="text-align:center; font-size:9px;">This is a computer-generated document. No signature is required.</label></div>--%>
<script>
    var listItem = <%=PODetail%>;
    var PODetailsCC = <%=PODetailsCC%>;
    var PODeliveryAddress = "<%=PO.procurement_address_name%>";
    let contactDescription = "<%=PO.contact_description%>";
    let legalEntity = "<%=PO.legal_entity%>";
    let is_print = "<%=PO.is_print%>";
    /*let legalEntity = "ICRAF";*/
    let logoCIFOR = "<%=Page.ResolveUrl("~/img/cifor_icon.png")%>";//icraf_icon
    let logoICRAF = "<%=Page.ResolveUrl("~/img/icraf_icon.png")%>";

    function GenerateTableDetail() {
        let html = "";
        $.each(listItem, function (i, d) {
            //var desc = "";
            //if (d.brand_name != "") {
            //    desc += d.brand_name + "<br/>";
            //}
            //desc += d.description;

            /*var html = "";*/
            html += "<tr>";
            html += "<td>" + (i + 1) + "</td>";
            /*html += "<td>" + d.item_code + "</td>";*/
            html += "<td>" + d.quotation_description + "</td>";
            /*html += "<td>" + d.status_name + "</td>";*/
            html += "<td style='text-align:right;'>" + accounting.formatNumber(d.po_quantity, 2) + "</td>";
            html += "<td>" + d.uom_name + "</td>";
            /*html += "<td>" + d.currency_id + "</td>";*/
            html += "<td style='text-align:right;'>" + accounting.formatNumber(d.po_unit_price, 2) + "</td>";
            //html += "<td style='text-align:right;'>" + accounting.formatNumber(d.discount, 2) + "</td>";
            //html += "<td style='text-align:right;'>" + accounting.formatNumber(d.additional_discount, 2) + "</td>";
            html += "<td style='text-align:right;'>" + accounting.formatNumber(delCommas(d.po_unit_price) * delCommas(d.po_quantity), 2) + "</td>";
            html += "<td style='text-align:right;'>" + accounting.formatNumber(d.po_discount, 2) + "</td>";
            html += "<td style='text-align:right;'>" + accounting.formatNumber(d.po_line_total + d.po_additional_discount, 2) + "</td>";
            //html += '<td>' + (d.tax_name == null ? "" : d.tax_name) + '</td>';
            //let vat_type = '';
            //if (d.vat_payable == true) {
            //    vat_type = 'Yes';

            //    html += '<td>' + vat_type + '</td>';
            //    html += '<td style="text-align:right;">' + accounting.formatNumber(d.vat_amount / d.quantity, 2) + '</td>';
            //    html += '<td style="text-align:right;">' + accounting.formatNumber(d.vat_amount, 2) + '</td>';
            //} else {
            //    vat_type = 'No';

            //    html += '<td>' + vat_type + '</td>';
            //    html += '<td style="text-align:right;">' + accounting.formatNumber(0, 2) + '</td>';
            //    html += '<td style="text-align:right;">' + accounting.formatNumber(0, 2) + '</td>';
            //}
            //if (d.vat_payable == true) {
            //    html += '<td style="text-align:right;" class="item_total">' + accounting.formatNumber(d.po_line_total + d.vat_amount, 2) + '</td>';
            //} else {
            //    html += '<td style="text-align:right;" class="item_total">' + accounting.formatNumber(d.po_line_total, 2) + '</td>';
            //}
            html += "</tr >";

            //let strChargeCode = "";
            //let PODetailsCCTemp = $.grep(PODetailsCC, function (n, i) {
            //    return n["vs_detail_id"] == d.vs_detail_id;
            //})

            //$.each(PODetailsCCTemp, function (i, dc) {
            //    strChargeCode += '<tr>';
            //    strChargeCode += '<td style=" width: 10%;" class="pCostCenters">' + dc.cost_center_id + ' - ' + dc.cost_center_name + '</td>';
            //    strChargeCode += '<td style="width: 20%;" class="pCostCentersWorkOrder">' + dc.work_order + ' - ' + dc.work_order_description + '</td>';
            //    strChargeCode += '<td style="width: 10%;" class="pCostCentersEntity">' + dc.entity_description + '</td>';
            //    strChargeCode += '<td style="width: 5%;">' + dc.legal_entity + '</td>';
            //    strChargeCode += '<td style="display: none; width: 5%;">' + dc.control_account + '</td>';
            //    strChargeCode += '<td style=" width: 5%; text-align:right;" class="pCostCentersValue">' + accounting.formatNumber(dc.percentage, 2) + '</td>';
            //    if (d.vat_payable == true) {
            //        strChargeCode += '<td style="width: 11%; text-align:right;" class="pCostCentersAmt">' + accounting.formatNumber(parseFloat(dc.amount + dc.amount_vat), 2) + '</td>';
            //        strChargeCode += '<td style="width: 11%; text-align:right;" class="pCostCentersUSDAmt">' + accounting.formatNumber(parseFloat(dc.amount_usd + dc.amount_usd_vat), 2) + '</td>';
            //    } else {
            //        strChargeCode += '<td style="width: 11%; text-align:right;" class="pCostCentersAmt">' + accounting.formatNumber(parseFloat(dc.amount), 2) + '</td>';
            //        strChargeCode += '<td style="width: 11%; text-align:right;" class="pCostCentersUSDAmt">' + accounting.formatNumber(parseFloat(dc.amount_usd), 2) + '</td>';
            //    }
            //    strChargeCode += '<td style="width: 20%;">' + dc.remarks + '</td>';
            //    strChargeCode += '</tr>';
            //});

            //html += '<tr id="trr' + d.id + '">';
            //html += '<td class="hiddenRow" colspan="16" style="padding:0px;">';
            //html += '<div id="dv' + guid().toString(); + '" class="accordian-body in collapse" style="height: auto;">';
            //html += '<div id="dv' + d.id + '_ChargeCode" style="margin-left:20px; margin-right:5px; margin-top:3px; margin-bottom:5px;">';
            //html += '<div id="dv' + d.id + '_CostParent">';
            //html += '<table id="tbl' + d.id + '_CostParent" class="table table-bordered tblCostCenterParent" style="border: 1px solid #ddd">';
            //html += '<thead>';
            //html += '<tr>';
            //html += '<th style=" width: 15%; text-align:left;">Cost center / Project code </th>';
            //html += '<th style=" width: 18%; text-align:left;">Work order / T4 </th>';
            //html += '<th style=" width: 10%; text-align:left;">Entity</th>';
            //html += '<th style=" width: 10%; text-align:left;">Legal entity</th>';
            //html += '<th style="display: none;">Account Control</th>';
            //html += '<th style=" width: 5%; text-align:right;">%</th>';
            //html += '<th style=" width: 11%; text-align:right;">Amount (' + d.currency_id + ')</th>';
            //html += '<th style=" width: 11%; text-align:right;">Amount (USD)</th>';
            //html += '<th style=" text-align:left; width: 30%;">Remarks</th>';
            //html += '</tr>';
            //html += '</thead>';
            //html += '<tbody>';
            //html += strChargeCode;
            //html += '</tbody>';
            //html += '</table>';
            //html += '</div>';
            //html += '</div>';
            //html += '</div>';
            //html += '</div>';
            //html += '</td>';
            //html += '</tr>';

        });

        //html += "<tr>";
        //html += "<td style='height:15px;' colspan='8'></td>";
        //html += "</tr >";
        $("#tblPODetail tbody").append(html);
    }

    $(document).ready(function () {
        GenerateTableDetail();
        normalizeMultilines();
        if (legalEntity == "CIFOR" || legalEntity == "GERMANY") {
            $("#logoImg").attr("src", logoCIFOR);
            $("#deliveryAddress").html('<p class="colortextfooter" style="font-size: 14px;margin: 0px 0 0 0; color:#73b147; font-weight:bold;">' + contactDescription + '</p>' + PODeliveryAddress + $("#deliveryAddress").html());
            /*$("#tblFooterCIFOR").show();*/
            $("#footerCIFOR").show();
        } else if (legalEntity == "ICRAF") {
            $("#templatePrintP").show();
            $("#logoImg").attr("src", logoICRAF);
            $("#logoImg").css({ "width": "70%" });
            $("#deliveryAddress").html("");
            $("#deliveryAddress").css({ "verticalAlign": "top" });
            $("#btnPrintTD").html("Transforming lives and landscapes with trees" + "<br />" + $("#btnPrintTD").html());
            $("#btnPrintTD").css({ "verticalAlign": "top", fontSize: "12px", width: "31%" });
            $("#printFooter").html(PODeliveryAddress + "<br />" + $("#printFooter").html());
            $("#printFooter").css({ "textAlign": "left" });
        }

        if (is_print == "1") {
            $("#PrintTitle").html($("#PrintTitle").html() + " COPY");
        }
    });

    function normalizeMultilines() {
        $(".multilines").each(function () {
            $(this).html($(this).text().replace(/\r?\n/g, '<br />'));
        });
    }

    function delCommas(str) {
        str = String(str);
        str = str.replace(/\,/g, "");
        return str === "" ? "" : parseFloat(str);
    }
</script>
