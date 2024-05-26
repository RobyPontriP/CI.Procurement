<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="PrintPreview.aspx.cs" Inherits="Procurement.PurchaseOrder.preview" %>

<%--<%@ Register Src="~/PurchaseOrder/uscPurchaseOrderDraft.ascx" TagName="pod" TagPrefix="uscpod" %>--%>
<%@ Register Src="~/PurchaseOrder/uscPurchaseOrderPrint.ascx" TagName="pod" TagPrefix="uscpod" %>
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

        .table td, .table th {
            padding: 5px !important;
        }

        label {
            margin-bottom: 0 !important;
        }

        #tblPODraft td {
            padding-left: 5px !important;
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
            /*size: A4;*/
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
          display:inline-block;
        }
    </style>
</head>
<body>
    <div id="page-wrap">
        <div class="row-fluid">
            <div class="floatingBox">
                <%-- <div class="letterhead">
                <img src="<%=Page.ResolveUrl("~/img/cifor_icon.png")%>" style="margin-left:85px;"> <label style="display:inline-block;">Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.</label>
                <a href="#" onclick="window.print();" class="btnPrint">Print <i class="fa fa-print"></i></a> 
            </div>--%>
                <table>
                    <tr>
                        <td align="center" style="width: 21%;">
                        <td style="font-size: 12px;">
                        <td style="width: 24%; letter-spacing: 2px; text-align: right; font-size: 12px;" id="PrintTitle">PURCHASE ORDER</td>
                    </tr>
                    <tr>
                        <%--<td align="center" style="width:25%;"><img id="logoImg" src="<%=Page.ResolveUrl("~/img/cifor_icon.png")%>"></td>--%>
                        <td align="center" style="width: 21%;">
                            <img id="logoImg" style="width: 50%;" src="<%=Page.ResolveUrl("~/img/cifor_icon.png")%>"></td>
                        <td style="font-size: 12px;" id="deliveryAddress">
                            <br/>
                            <b>cifor.org | forestsnews.cifor.org</b></td>
                        <%--<td style="width: 20%;" id="btnPrintTD"><a href="#" onclick="window.print();" class="btnPrint">Print <i class="fa fa-print"></i></a></td>--%>
                        <td style="width: 20%;" id="btnPrintTD"><a href="#" id="btnPrint" class="btnPrint">Print <i class="fa fa-print"></i></a></td>
                    </tr>
                </table>
                <%--<hr style="border: 0.1px solid black; height: 0;">--%>
                <%--<hr>--%>
                <%--<hr color="#73b147" class="hrcolor" size="4" style="border: 0;">--%>
                <div class="line"></div>
                <div class="container-fluid">
                    <uscpod:pod ID="pod1" runat="server" />
                    <p style='page-break-after: always;'>&nbsp;</p>


                    <% if (pod1.legal_entity.ToLower() == "icraf")
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
    </div>
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
    </script>
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
