<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="uscPurchaseOrderDraft.ascx.cs" Inherits="Procurement.PurchaseOrder.uscPurchaseOrderDetail" %>
<style>
    #POdraft .row-fluid {
        margin-bottom: 0px !important;
    }

    #tblPODraft td {
        vertical-align:top;
    }
</style>
<div id="POdraft">
    <input type="hidden" id="status" value="<%=PO.status_id %>"/>
    <input type="hidden" id="po_number" value="<%=PO.po_no %>"/>
    <table id="tblPODraft" style="border:0px; width:100%;">
        <tr class="noborder">
            <td style="width:15%;"></td>
            <td style="width:35%;"></td>
            <td style="width:10%;"></td>
            <td style="width:15%;"></td>
            <td style="width:25%;"></td>
        </tr>
        <tr class="noborder" id="po_code">
            <td style="width:15%;"><label>PO code</label></td>
            <td style="width:35%;"><label id="po_no"><a href="Detail.aspx?id=<%=PO.id %>" target="_blank"><b><%=PO.po_no %></b></a></label></td>
            <td style="width:10%;">&nbsp;</td>
            <td style="width:15%;">&nbsp;</td>
            <td style="width:25%;">&nbsp;</td>
        </tr>
        <tr class="noborder" id="po_status">
            <td><label>PO status</label></td>
            <td><label><b><%=PO.status_name %></b></label></td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
        </tr>
        <tr class="noborder">
            <td><label>To</label></td>
            <td><label><%=PO.vendor_name %></label></td>
            <td>&nbsp;</td>
            <td><label>P.O. number</label></td>
            <td><label><b><%=PO.po_sun_code %></b></label></td>
        </tr>
        <tr class="noborder">
            <td rowspan="2">&nbsp;</td>
            <td rowspan="2"><label><%=PO.vendor_address %></label></td>
            <td rowspan="2">&nbsp;</td>
            <td><label>P.O. date</label></td>
            <td><label><%=PO.document_date %></label></td>
        </tr>
        <tr class="noborder">
            <td><label>Payment terms</label></td>
            <td><label class="multilines"><%=PO.term_of_payment_name %></label></td>
        </tr>
  <%--      <% if (PO.term_of_payment.ToLower() == "oth")
        { %>
        <tr class="noborder">
            <td><label>Other term of payment</label></td>
            <td><label class="multilines"><%=PO.term_of_payment_name %></label></td>
        </tr>
        <% }%>   --%>     
        <tr class="noborder">
            <td><label>Telephone</label></td>
            <td><label><%=PO.vendor_telp_no %></label></td>
            <td rowspan="2">&nbsp;</td>
            <% if (PO.term_of_payment.ToLower() == "oth")
            { %>
            <td><label>Other term of payment</label></td>
            <td><label class="multilines"><%=PO.other_term_of_payment %></label></td>
            <% }%>        
<%--            <td><label>P.O. date</label></td>
            <td><label><%=PO.document_date %></label></td>--%>
        </tr>
<%--        <tr class="noborder">
            
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
        </tr>--%>
        <tr class="noborder">
            <td><label>Fax / Telex</label></td>
            <td><label><%=PO.vendor_fax_no %></label></td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
        </tr>
        <tr class="noborder">
            <td><label>Contact person</label></td>
            <td><label><%=PO.vendor_contact_person %></label></td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
        </tr>
        <tr class="noborder">
            <td><label>Order reffered to</label></td>
            <td><label><%=PO.order_reference %></label></td>
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
            <td colspan="5" style="border-top: 0;">
                <table id="tblPODetail" class="table table-bordered" style="border: 1px solid #ddd">
                    <thead>
                        <tr>
                            <th>No</th>
                            <th>Product code</th>
                            <th>Product description</th>
                            <th>Product status</th>
                            <th style="text-align:right;">Quantity</th>
                            <th>UOM</th>
                            <th>Currency</th>
                            <th style="text-align:right;">Unit price</th>
                            <th style="text-align:right;">Discount</th>
                            <th style="text-align:right;">Additional discount</th>
                            <th style="text-align:right;">Sub total</th>
                            <th>VAT code</th>
                            <th>VAT payable?</th>
                            <th style="text-align:right;">VAT amount per unit</th>
                            <th style="text-align:right;">Total VAT amount</th>
                            <th style="text-align:right;">Total</th>
                        </tr>
                    </thead>
                    <tbody>
                    </tbody>
                    <tfoot>
                        <tr>
                            <th style="border-left:1px solid #ddd !important;" rowspan="4" colspan="8">Remarks</th>
                            <th style="border-left:1px solid #ddd !important; text-align: left !important;" rowspan="4" colspan="4" class="multilines"><%=PO.remarks %></th>
                            <th style="border-left:1px solid #ddd !important; font-weight:bold; text-align: left !important;" colspan="3">Total prior to discount</th>
                            <th style="border-left:1px solid #ddd !important; font-weight:bold; text-align:right;"><%=PO.currency_id %> <%=PO.gross_amount %></th>
                        </tr>
                        <tr>
                            <th style="border-left:1px solid #ddd !important; font-weight:bold;" colspan="3">Total discount</th>
                            <th style="border-left:1px solid #ddd !important; font-weight:bold; text-align:right;"><%=PO.currency_id %> <%=PO.discount %></th>
                        </tr>
                        
                        <tr>
                            <th style="border-left:1px solid #ddd !important; font-weight:bold;" colspan="3">Total VAT</th>
                            <th style="border-left:1px solid #ddd !important; font-weight:bold; text-align:right;"><%=PO.currency_id %> <%=str_vat_amount %>&nbsp /&nbsp USD <%=str_vat_amount_usd %></th>
                        </tr>
                        
                        <tr>
                            <th style="border-left:1px solid #ddd !important; font-weight:bold;" colspan="3">Total amount</th>
                            <th style="border-left:1px solid #ddd !important; font-weight:bold; text-align:right;"><%=PO.currency_id %> <%=PO.total_amount %>&nbsp /&nbsp USD <%=PO.total_amount_usd %></th>
                        </tr>
                    </tfoot>
                </table>
                <p></p>
            </td>
        </tr>
        <tr class="noborder">
            <td colspan="2">
                <label>
                    Delivery address:<br />
                    <%=PO.cifor_delivery_address %>
                </label>
            </td>         
            <td>&nbsp;</td>
            <td colspan="2">
                <label>For payment send invoice (Quote PO number reference) and proof of delivery to:<br />
                CIFOR (Center for International Forestry Research)<br />
                Jalan CIFOR, Situ Gede<br />
                Bogor Barat 16115<br />
            </label>
            </td>
        </tr>

        <%  if (PO.is_other_address == "1")
        { %>
        <tr class="noborder">
            <td colspan="2">
                <label>
                    Delivery address:<br />
                    <%=PO.other_address %>
                </label>
            </td>     
            <td>&nbsp;</td>
        </tr>
        <%  } %>     

        <tr class="noborder">
            <td><label>Telephone</label></td>
            <td><label><%=PO.delivery_telp %></label></td>
            <td>&nbsp;</td>
            <td><label>Attention</label></td>
            <td><label><%=PO.accountant %></label></td>
        </tr>
        <tr class="noborder">
            <td><label>Fax number</label></td>
            <td><label><%=PO.delivery_fax %></label></td>
            <td>&nbsp;</td>
            <td><label>Delivery date</label></td>
            <td><label><%=PO.expected_delivery_date %></label></td>
        </tr>
        <tr class="noborder">
            <td><label>Attention</label></td>
            <td><label>Operation Assistant</label></td>
            <td>&nbsp;</td>
            <td><label>Delivery method</label></td>
            <td><label><%=PO.cifor_shipment_account %></label></td>
        </tr>
        <tr class="noborder">
            <td><label>Copies to</label></td>
            <td><label>1. Administration<br />
                2. Accounting</label></td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
        </tr>
        <tr class="noborder for-print">
            <td colspan="5">&nbsp;</td>
        </tr>
        <tr class="noborder for-print">
            <td colspan="3">&nbsp;</td>
            <td colspan="2" style="text-align:center;"><label>Authorized for CIFOR
                <br />
                <br />
                <%=approver_name %><br />
                <%=approver_title %><br />
                Approved date: <%=approver_date %><br />
                <br />
                </label>
            </td>
        </tr>
        <tr class="noborder for-print">
            <td colspan="5"><label>CIFOR is a recognize International non-profit organization and is exempt from Indonesian V.A.T according to article 7 of the headquarters agreement.</label><br /></td>
        </tr>
        <tr class="noborder for-print">
            <td colspan="5" style="text-align:center; font-size:9px;">This is a computer-generated document. No signature is required.</td>
        </tr>
    </table>
</div>
<script>
    var listItem = <%=PODetail%>;
    var PODetailsCC = <%=PODetailsCC%>;

    function GenerateTableDetail() {
        let html = "";
        $.each(listItem, function (i, d) {
            //var desc = "";
            //if (d.brand_name != "") {
            //    desc += d.brand_name + "<br/>";
            //}
            //desc += d.description;

            
            html += "<tr>";
            html += "<td>" + (i+1) + "</td>";
            html += "<td>" + d.item_code + "</td>";
            html += "<td>" + d.quotation_description + "</td>";
            html += "<td>" + d.status_name + "</td>";
            html += "<td style='text-align:right;'>" + accounting.formatNumber(d.po_quantity, 2) + "</td>";
            html += "<td>" + d.uom + "</td>";
            html += "<td>" + d.currency_id + "</td>";
            html += "<td style='text-align:right;'>" + accounting.formatNumber(d.po_unit_price, 2) + "</td>";
            html += "<td style='text-align:right;'>" + accounting.formatNumber(d.discount, 2) + "</td>";
            html += "<td style='text-align:right;'>" + accounting.formatNumber(d.additional_discount, 2) + "</td>";
            /*html += "<td style='text-align:right;'>" + accounting.formatNumber(delCommas(d.po_unit_price) * delCommas(d.po_quantity), 2) + "</td>";*/
            html += "<td style='text-align:right;'>" + accounting.formatNumber(d.po_line_total, 2) + "</td>";
            html += '<td>' + (d.tax_name == null ? "" : d.tax_name) + '</td>';
            let vat_type = '';
            if (d.vat_payable == true) {
                vat_type = 'Yes';

                html += '<td>' + vat_type + '</td>';
                html += '<td style="text-align:right;">' + accounting.formatNumber(d.vat_amount / d.quantity, 2) + '</td>';
                html += '<td style="text-align:right;">' + accounting.formatNumber(d.vat_amount, 2) + '</td>';
            } else {
                vat_type = 'No';

                html += '<td>' + vat_type + '</td>';
                html += '<td style="text-align:right;">' + accounting.formatNumber(0, 2) + '</td>';
                html += '<td style="text-align:right;">' + accounting.formatNumber(0, 2) + '</td>';
            }
            if (d.vat_payable == true) {
                html += '<td style="text-align:right;" class="item_total">' + accounting.formatNumber(d.po_line_total + d.vat_amount, 2) + '</td>';
            } else {
                html += '<td style="text-align:right;" class="item_total">' + accounting.formatNumber(d.po_line_total, 2) + '</td>';
            }
            html += "</tr >";

            let strChargeCode = "";
            let PODetailsCCTemp = $.grep(PODetailsCC, function (n, i) {
                return n["vs_detail_id"] == d.vs_detail_id;
            })

            $.each(PODetailsCCTemp, function (i, dc) {
                strChargeCode += '<tr>';
                strChargeCode += '<td style=" width: 10%;" class="pCostCenters">' + dc.cost_center_id + ' - ' + dc.cost_center_name + '</td>';
                strChargeCode += '<td style="width: 20%;" class="pCostCentersWorkOrder">' + dc.work_order + ' - ' + dc.work_order_description + '</td>';
                strChargeCode += '<td style="width: 10%;" class="pCostCentersEntity">' + dc.entity_description + '</td>';
                strChargeCode += '<td style="width: 5%;">' + dc.legal_entity + '</td>';
                strChargeCode += '<td style="display: none; width: 5%;">' + dc.control_account + '</td>';
                strChargeCode += '<td style=" width: 5%; text-align:right;" class="pCostCentersValue">' + accounting.formatNumber(dc.percentage, 2) + '</td>';
                if (d.vat_payable == true) {
                    strChargeCode += '<td style="width: 11%; text-align:right;" class="pCostCentersAmt">' + accounting.formatNumber(parseFloat(dc.amount + dc.amount_vat), 2) + '</td>';
                    strChargeCode += '<td style="width: 11%; text-align:right;" class="pCostCentersUSDAmt">' + accounting.formatNumber(parseFloat(dc.amount_usd + dc.amount_usd_vat), 2) + '</td>';
                } else {
                    strChargeCode += '<td style="width: 11%; text-align:right;" class="pCostCentersAmt">' + accounting.formatNumber(parseFloat(dc.amount), 2) + '</td>';
                    strChargeCode += '<td style="width: 11%; text-align:right;" class="pCostCentersUSDAmt">' + accounting.formatNumber(parseFloat(dc.amount_usd), 2) + '</td>';
                }
                strChargeCode += '<td style="width: 20%;">' + dc.remarks + '</td>';
                strChargeCode += '</tr>';
            });

            html += '<tr id="trr' + d.id + '">';
            html += '<td class="hiddenRow" colspan="16" style="padding:0px;">';
            html += '<div id="dv' + guid().toString(); + '" class="accordian-body in collapse" style="height: auto;">';
            html += '<div id="dv' + d.id + '_ChargeCode" style="margin-left:20px; margin-right:5px; margin-top:3px; margin-bottom:5px;">';
            html += '<div id="dv' + d.id + '_CostParent">';
            html += '<table id="tbl' + d.id + '_CostParent" class="table table-bordered tblCostCenterParent" style="border: 1px solid #ddd">';
            html += '<thead>';
            html += '<tr>';
            html += '<th style=" width: 15%; text-align:left;">Cost center</th>';
            html += '<th style=" width: 18%; text-align:left;">Work order</th>';
            html += '<th style=" width: 10%; text-align:left;">Entity</th>';
            html += '<th style=" width: 10%; text-align:left;">Legal entity</th>';
            html += '<th style="display: none;">Account Control</th>';
            html += '<th style=" width: 5%; text-align:right;">%</th>';
            html += '<th style=" width: 11%; text-align:right;">Amount (' + d.currency_id + ')</th>';
            html += '<th style=" width: 11%; text-align:right;">Amount (USD)</th>';
            html += '<th style=" text-align:left; width: 30%;">Remarks</th>';
            html += '</tr>';
            html += '</thead>';
            html += '<tbody>';
            html += strChargeCode;
            html += '</tbody>';
            html += '</table>';
            html += '</div>';
            html += '</div>';
            html += '</div>';
            html += '</div>';
            html += '</td>';
            html += '</tr>';
            
        });
        $("#tblPODetail tbody").append(html);
    }

    $(document).ready(function () {
        GenerateTableDetail();
        normalizeMultilines();
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