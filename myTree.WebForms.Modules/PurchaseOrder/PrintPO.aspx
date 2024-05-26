<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="PrintPO.aspx.cs" Inherits="Procurement.PurchaseOrder.PrintPO" %>

<%--<%@ Register Src="~/PurchaseOrder/uscPurchaseOrderDraft.ascx" TagName="pod" TagPrefix="uscpod" %>--%>
<%--<%@ Register Src="~/PurchaseOrder/uscPurchaseOrderPrint.ascx" TagName="pod" TagPrefix="uscpod" %>--%>
<!DOCTYPE html>
<html>
<head runat="server">
    <title>Purchase Order</title>
    <script type="text/javascript" src="<%=Page.ResolveUrl("~/webformassets/js/vendor/jquery-1.9.1.min.js") %>"></script>
    <script type="text/javascript" src="<%=Page.ResolveUrl("~/webformassets/js/accounting.js") %>?v=<%= DateTime.Now.ToString("yyyyMMddhhmm") %> "></script>
    <link href="<%=Page.ResolveUrl("~/webformassets/css/bootstrap-responsive.min.css")%>" rel="stylesheet" type="text/css" />
    <link href="<%=Page.ResolveUrl("~/webformassets/css/styles.css")%>" rel="stylesheet" type="text/css" />
    <link href="<%=Page.ResolveUrl("~/webformassets/css/thekamarel.css")%>" rel="stylesheet" type="text/css" />
    <link href="<%=Page.ResolveUrl("~/webformassets/js/plugins/datatables/styles/normalize.min.css")%>" rel="stylesheet" type="text/css" />
    <link href="<%=Page.ResolveUrl("~/webformassets/js/plugins/datatables/styles/element.css")%>" rel="stylesheet" type="text/css" />
    <link href="<%=Page.ResolveUrl("~/css/general.css")%>" rel="stylesheet" type="text/css" />
    <%-- <script src="/Workspace/Style_CIFORWorkspace/js/vendor/jquery-1.9.1.min.js?v=<%= DateTime.Now.ToString("yyyyMMddhhmm") %>" ></script>
    <link rel="stylesheet" href="/Workspace/Style_CIFORWorkspace/css/bootstrap-responsive.min.css">
    <link rel="stylesheet" href="/Workspace/Style_CIFORWorkspace/css/styles.css">
    <link rel="stylesheet" href="/Workspace/Style_CIFORWorkspace/css/thekamarel.css">
    <link href="/Workspace/Style_CIFORWorkspace/js/plugins/datatables/styles/normalize.min.css" rel="stylesheet" type="text/css" />
    <link href="/Workspace/Style_CIFORWorkspace/js/plugins/datatables/styles/element.css"
        rel="stylesheet" type="text/css" />--%>
    <%-- <link href="<%=Page.ResolveUrl("~/css/general.css")%>" rel="stylesheet" type="text/css" />
    <link href="<%=Page.ResolveUrl("~/css/select2.min.css")%>" rel="stylesheet" type="text/css" />

    <!-- accounting.js (for money formating) -->
    <script type="text/javascript" src="<%=Page.ResolveUrl("~/js/accounting.js") %>?v=<%= DateTime.Now.ToString("yyyyMMddhhmm") %> "></script>--%>
    <style>
        .table td, .table th, label {
            font-size: 11px !important;
        }

        .table.print-friendly tr td, table.print-friendly tr th {
            page-break-inside: avoid;
        }

        .table td, .table th {
            padding: 5px !important;
        }

        tr.spaceUnder > td {
            padding-top: 1em;
        }

        label {
            margin-bottom: 0 !important;
        }

        #tblPODraft td {
            padding-left: 5px !important;
        }

        #tblPODetail td {
            border: 1px solid #ddd;
        }

            #tblPODetail td.tdleft {
                border-left: 1px solid #ddd;
            }

        #tblPODetail th.thleft {
            border-left: 1px solid #ddd;
        }

        /*  #tblPODetail tr {
    outline: 1px solid #ddd;
}*/

        #tblPODetail td.tdright {
            border-right: 1px solid #ddd;
        }

        * {
            margin: 0;
            padding: 0;
        }

        #page-wrap {
            width: 800px;
            margin: 0 auto;
        }

        .letterhead {
            /*width: 100%;
            height: 124px;*/
        }

            .letterhead img {
                /*width: 100%;
            height: auto;*/
                height: 60px;
                margin-top: 10px;
                margin-left: 20px;
            }

        .left {
            float: left;
        }

        .right {
            float: right;
        }

        a.btnPrint {
            display: inline-block;
            padding: 0.2em 1.45em;
            margin: 0.1em;
            border: 0.15em solid #CCCCCC;
            box-sizing: border-box;
            text-decoration: none;
            font-family: 'Segoe UI','Roboto',sans-serif;
            font-weight: 400;
            color: #000000;
            background-color: #CCCCCC;
            text-align: center;
            position: relative;
            float: right;
        }

            a.btnPrint:hover {
                border-color: #7a7a7a;
            }

            a.btnPrint:active {
                background-color: #999999;
            }

        @media all and (max-width:30em) {
            a.btnPrint {
                display: block;
                margin: 0.2em auto;
            }
        }

        #po_code {
            display: none;
        }

        #po_status {
            display: none;
        }

        footer.printFooter {
            position: fixed;
            bottom: 0;
            width: 100%;
        }

        @media screen {
            footer.printFooter {
                display: none;
            }
        }

        @media print {
            .colortextfooter {
                color: #73b147 !important;
            }

            footer.printFooter:last-child {
                display: none;
            }

            thead {
                display: table-header-group;
            }


        }
    </style>
    <style media="print">
        a.btnPrint {
            display: none;
        }

        .tableheader {
            color: #000 !important;
        }

        a[href]:after {
            display: none;
        }
    </style>

    <style>
        @page {
            /*size: A4;
            margin: 20mm;*/
            size: 8.3in 12.7in;
            margin-bottom: 10mm;
            content: counter(page) ' of ' counter(pages);
        }

        .right-content {
            position: absolute;
            top: 0;
            right: 0;
            width: 30%; /* Adjust the width as needed */
            background-color: #f2f2f2;
            padding: 20px;
        }

        .page::after {
            content: counter(page) ' of ' counter(pages);
            position: absolute;
            bottom: 10mm;
            right: 10mm;
            font-size: 10pt;
        }

        .line {
            width: 100%;
            height: 0;
            border: 1px solid #73b147;
            display: inline-block;
        }
    </style>
</head>
<body>
    <div id="page-wrap">
        <div class="row-fluid">
            <table>
                <tr>
                    <td align="center" style="width: 21%;">
                    <%--<td style="font-size: 12px;">--%>
                    <td style="width: 24%; letter-spacing: 2px; text-align: right; font-size: 12px;" id="PrintTitle" colspan="2">PURCHASE ORDER</td>
                </tr>
                <tr>
                    <td align="center" style="width: 21%;">
                        <img id="logoImg" style="width: 50%;" src="<%=Page.ResolveUrl("~/img/cifor_icon.png")%>"></td>
                    <td style="font-size: 12px;" id="deliveryAddress">
                        <br />
                        <b>cifor.org | forestsnews.cifor.org</b></td>
                    <td style="width: 20%;" id="btnPrintTD"><a href="#" id="btnPrint" class="btnPrint">Print <i class="fa fa-print"></i></a></td>
                </tr>
            </table>
            <div class="line"></div>
            <div class="container-fluid">
                <%--<uscpod:pod ID="pod1" runat="server" />--%>
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
                    <%--        <tr class="noborder" id="po_payment_term">
                        <td>&nbsp;</td>
                        <td>&nbsp;</td>
                        <td>&nbsp;</td>
                        <td>
                            <label>Payment terms</label></td>
                        <td colspan="2">
                            <label class="multilines"><%=PO.term_of_payment_name %></label></td>
                    </tr>--%>

                    <tr class="noborder">
                        <td>&nbsp;</td>
                        <td>&nbsp;</td>
                        <td>&nbsp;</td>
                        <td>
                            <label>Payment terms</label></td>
                        <td colspan="2">
                            <% if (PO.is_other_term_of_payment == "1")
                                { %>
                            <label class="multilines"><%=PO.other_term_of_payment %></label>
                        <% }
                        else
                        { %>
                            <label class="multilines"><%=PO.term_of_payment_name %></label>
                        <%}%>
                        </td>
                    </tr>


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
                    </tr>
                </table>
                <table id="tblPODetail" class="table print-friendly" style="border: 1px solid #ddd; width: 100%; border-bottom: transparent; border-left: transparent; border-right: transparent;">
                    <thead>
                        <tr>
                            <th style="border-left: 1px solid #ddd;">No</th>
                            <th class="thleft">Description</th>
                            <th class="thleft" style="text-align: right; width: 10%;">Quantity</th>
                            <th class="thleft" style="width: 13%;">Unit of measure</th>
                            <th class="thleft" style="text-align: right;">Unit price in <%=PO.currency_id %></th>
                            <th class="thleft" style="text-align: right;">Sub total</th>
                            <th class="thleft" style="text-align: right;">Discount in <%=PO.currency_id %></th>
                            <th class="thleft" style="text-align: right; border-right: 1px solid #ddd;">Total in <%=PO.currency_id %></th>
                        </tr>
                    </thead>
                    <tbody>
                    </tbody>
                    <tfoot>
                        <tr style="height: 200px;">
                        </tr>
                    </tfoot>
                </table>
                <p style='page-break-after: always;'>&nbsp;</p>


                <% if (legal_entity.ToLower() == "icraf")
                    { %>
                <%=termcondition.Replace("CIFOR","ICRAF") %>
                <% }
                    else
                    { %>
                <%=termcondition %>
                <%}%>
            </div>
        </div>
    </div>

    <footer class="printFooter" id="printFooter" style="text-align: center; font-size: 9px;">
        <p id="templatePrintP" style="text-align: center;" hidden>This is a computer-generated document. No signature is required.</p>
        <div class="footer content" id="footerCIFOR" align="center" hidden>
            <p style="text-align: center;">This is a computer-generated document. No signature is required.</p>
            <img src="<%=Page.ResolveUrl("~/img/cifor_icon_footer.png")%>" style="width: 5%; margin-right: 14px; vertical-align: middle;">
            <span class="colortextfooter" style="color: #73b147; vertical-align: middle;">CIFOR is a CGIAR Research Center
            </span>
        </div>
        <%--<table id="tblFooterCIFOR" hidden>
            <tr>
                <td>
                    <img style="width: 50%;" src="<%=Page.ResolveUrl("~/img/cifor_icon_footer.png")%>">
                </td>
            </tr>
        </table>--%>
    </footer>

</body>

</html>
<script type="text/javascript">
    let po_id = "<%=_id%>";
    let module = "<%=moduleName%>";
    $(document).on("click", "#btnPrint", function () {
        $.ajax({
            /* url: '/Workspace/Procurement/Service.aspx/GetSUNPO',*/
            url: '<%= Page.ResolveUrl("~/" +based_url+ service_url + "/UpdatePrint") %>',
            data: '{id:"' + po_id + '",module:"' + module + '"}',
            dataType: 'json',
            type: 'post',
            contentType: "application/json; charset=utf-8",
            success: function (response) {
                window.print();
            }
        });
    });

    var listItem = <%=PODetail%>;
    var PODetailsCC = <%=PODetailsCC%>;
    var PODeliveryAddress = "<%=PO.procurement_address_name%>";
    let contactDescription = "<%=PO.contact_description%>";
    let legalEntity = "<%=PO.legal_entity%>";
    let is_print = "<%=PO.is_print%>";
    /*let legalEntity = "ICRAF";*/
    let logoCIFOR = "<%=Page.ResolveUrl("~/img/cifor_icon.png")%>";//icraf_icon
    let logoICRAF = "<%=Page.ResolveUrl("~/img/icraf_icon.png")%>";
    let is_other_address = "<%=PO.is_other_address%>";
    let other_address = "<%=PO.other_address.Replace("\n", "<br />")%>";
    let cifor_delivery_address = "<%=PO.cifor_delivery_address%>";
    let po_remarks = "<%=myTree.WebForms.Procurement.General.statics.NormalizeString(PO.remarks.Replace("\n", "<br />"))%>";
    let currency_id = "<%=PO.currency_id%>";
    let gross_amount = "<%=PO.gross_amount%>";
    let str_discount = "<%=str_discount%>";
    let str_additional_discount = "<%=str_additional_discount%>";
    let str_vat_amount = "<%=str_vat_amount%>";
    let str_vat_amount_usd = "<%=str_vat_amount_usd%>";
    let total_amount = "<%=PO.total_amount%>";
    let total_amount_usd = "<%=PO.total_amount_usd%>";
    let str_total_amount = "<%=str_total_amount%>";
    let str_total_amount_usd = "<%=str_total_amount_usd%>";
    let approver_name = "<%=approver_name%>";
    let approver_title = "<%=approver_title%>";
    let approver_date = "<%=approver_date%>";

    function GenerateTableDetail() {
        let html = "";
        let vat_printable = false;
        $.each(listItem, function (i, d) {
            html += "<tr>";
            html += "<td class=tdleft>" + (i + 1) + "</td>";
            html += '<td>' + d.quotation_description.replace("\"", "&quot;") + '</td>';
            html += "<td style='text-align:right;'>" + accounting.formatNumber(d.po_quantity, 2) + "</td>";
            html += "<td>" + d.uom_name + "</td>";
            html += "<td style='text-align:right;'>" + accounting.formatNumber(d.po_unit_price, 2) + "</td>";
            /*html += "<td style='text-align:right;'>" + accounting.formatNumber(delCommas(d.po_unit_price) * delCommas(d.po_quantity), 2) + "</td>";*/
            html += "<td style='text-align:right;'>" + accounting.formatNumber(d.po_line_total + d.po_discount + d.po_additional_discount, 2) + "</td>";
            html += "<td style='text-align:right;'>" + accounting.formatNumber(d.po_discount, 2) + "</td>";
            html += "<td style='text-align:right;' class=tdright>" + accounting.formatNumber(d.po_line_total + d.po_additional_discount, 2) + "</td>";
            html += "</tr >";

            if (d.vat_printable == true && vat_printable == false) {
                vat_printable = true;
            }            
        });

        html += "<tr>";
        html += "<th style='border-left:1px solid #ddd !important; text-align: left !important;' rowspan='5' colspan='4' class=''>";
        html += "Remarks:</br><p style='font-weight:normal'>" + po_remarks +"</p></th>";
        html += "<th style='font-weight: bold; text-align: right!important; border-left: 1px solid transparent; text-align: right;' colspan='2'>Total amount:</th>";
        html += "<th style='font-weight: bold; text-align: right; border-left: 1px solid transparent; border-right:1px solid #ddd;' colspan='2'>" + currency_id + " " + gross_amount + "</th>";
        html += "</tr>";

        html += "<tr>";
        html += "<th style='font-weight:bold; border-top:1px solid transparent; text-align:right;' colspan='2'>Total discount:</th>";
        html += "<th style='font-weight:bold; text-align: right; border-left:1px solid transparent; border-top: 1px solid transparent; border-right:1px solid #ddd;' colspan='2'>" + currency_id + " " + str_discount + "</th>";
        html += "</tr>";

        html += "<tr>";
        html += "<th style='font-weight:bold; border-top: 1px solid transparent; text-align: right;' colspan='2'>Additional discount:</th>";
        html += "<th style='font-weight:bold; text-align: right; border-left: 1px solid transparent; border-top:1px solid transparent; border-right:1px solid #ddd;' colspan='2'>" + currency_id + " " + str_additional_discount + "</th>";
        html += "</tr>";

        if (vat_printable == true) {
            html += "<tr>";
            html += "<th style='font-weight:bold; border-top:1px solid transparent; text-align: right;' colspan='2'>VAT:</th>";
            if (currency_id.toLowerCase() == "usd") {
                html += "<th style='font-weight:bold; text-align: right; border-left: 1px solid transparent; border-top: 1px solid transparent; border-right:1px solid #ddd;' colspan='2'>" + currency_id + " " + str_vat_amount + "</th>";
            } else {
                html += "<th style='font-weight:bold; text-align: right; border-left: 1px solid transparent; border-top: 1px solid transparent; border-right:1px solid #ddd;' colspan='2'>" + currency_id + " " + str_vat_amount + " / USD " + str_vat_amount_usd + "</th>";
            }
            html += "</tr>";
        }        

        html += "<tr>";
        html += "<th style='font-weight:bold; border-top: 1px solid transparent; text-align: right;' colspan='2'>Grand total:</th>";
        if (currency_id.toLowerCase() == "usd") {
            html += "<th style='font-weight:bold; text-align:right; border-left: 1px solid transparent; border-top: 1px solid transparent; border-right:1px solid #ddd;' colspan='2'>" + currency_id + " " + str_total_amount + "</th>";
        } else {
            html += "<th style='font-weight:bold; text-align:right; border-left: 1px solid transparent; border-top: 1px solid transparent; border-right:1px solid #ddd;' colspan='2'>" + currency_id + " " + str_total_amount + " / USD " + str_total_amount_usd + "</th>";
        }
        html += "</tr>";

        html += "<tr>";
        html += "</tr>";
        html += "<tr class='noborder spaceUnder'>";
        html += "<td colspan='4' style='border-left: 1px solid transparent; border-right: 1px solid transparent; border-bottom: 1px solid transparent;'>";
        html += "</br>";
        if (is_other_address == "1") {
            html += "<label>Delivery address:<br />" + other_address + "</label >";
        } else {
            html += "<label>Delivery address:<br />" + cifor_delivery_address + "</label >";
        }
        html += "</td>";
        html += "<td colspan='4' style='border-right: 1px solid transparent; border-bottom: 1px solid transparent;'>";
        html += "</br>";
        html += "<label align='justify'> Order number must appear on all invoices, advice notes, delivery notes, shipping documents and correspondence to expedite processing of invoices.</label>";
        html += "</td>";
        html += "</tr>";
        html += "<tr class='noborder for-print'>";
        html += "<td colspan='5' style='border: 1px solid transparent;'>&nbsp;</td>";
        html += "</tr>";
        html += "<tr class='noborder for-print'>";
        html += "<td colspan='6' style='border: 1px solid transparent;'>&nbsp;</td>";
        html += "<td colspan='2' style='text-align:center; border: 1px solid transparent;'>";
        html += "<label>";
        if (legalEntity.toLowerCase() == "cifor" || legalEntity.toLowerCase() == "germany") {
            if (legalEntity.toLowerCase() == "germany") {
                html += "Authorized for CIFOR Germany";
            } else {
                html += "Authorized for CIFOR";
            }           
        } else {
            html += "Authorized for ICRAF";
        }
        html += "<br/> <br/>";
        html += approver_name + "<br/>";
        html += approver_title + "<br/>";
        html += "Approved date: " + approver_date;
        html += "<br/> <br/>";
        html += "</label>";
        html += "</td>";
        html += "</tr>";

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
            $("#deliveryAddress").css({ "width": "70%" });
        } else if (legalEntity == "ICRAF") {
            $("#templatePrintP").show();
            $("#logoImg").attr("src", logoICRAF);
            $("#logoImg").css({ "width": "60%" });
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
