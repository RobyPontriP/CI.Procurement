<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="CompiledPO.aspx.cs" Inherits="Procurement.PurchaseOrder.CompiledPO" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Compiled PO data</title>
    <link href="/Workspace/Style_CIFORWorkspace/js/plugins/datatables/styles/normalize.min.css"
        rel="stylesheet" type="text/css" />
    <style>
        * {
            margin: 0;
            padding: 0;
            font-size: 9px !important;
            font-family: Verdana, Geneva, sans-serif;
        }

        #page-wrap {
            width: auto;
            margin: 0 auto;
        }

        .letterhead {
            width: 100%;
            height: 124px;
        }

            .letterhead img {
                width: 100%;
                height: auto;
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
            font-size: 12px !important;
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
    </style>
    <style media="print">
        a.btnPrint {
            display: none;
        }

        .tableheader {
            color: #000 !important;
        }
    </style>
    <style type="text/css">
        .basefont {
            font-family: Verdana, Geneva, sans-serif;
            font-size: 10px;
            border-bottom: #C2D69A solid 1px;
            border-right: #C2D69A solid 1px;
            padding: 5px;
        }

        .zebra {
            background-color: #EAF1DD;
            font-family: Verdana, Geneva, sans-serif;
            border-bottom: #C2D69A solid 1px;
            border-right: #C2D69A solid 1px;
            padding: 5px;
        }

        .tblPrint {
            border-top: #C2D69A solid 1px;
            border-left: #C2D69A solid 1px;
            border-bottom: #C2D69A solid 1px;
            border-right: #C2D69A solid 1px;
        }

            .tblPrint td {
                padding: 3px;
            }

            .tblPrint th {
                padding: 3px;
                font-family: Verdana, Geneva, sans-serif;
                font-weight: bold;
                border-bottom: #C2D69A solid 1px;
                border-right: #C2D69A solid 1px;
            }

        .tblBorder td {
            border-bottom: #C2D69A solid 1px;
            border-right: #C2D69A solid 1px;
            font-size: 7px !important;
        }

            .tblBorder td, .tblBorder td span {
                font-size: 7px !important;
            }

        .tblBorder th {
            font-size: 7px !important;
        }

        h2 {
            font-size: 16px !important;
        }

        h3 {
            font-size: 14px !important;
        }
    </style>
</head>
<body>
    <div id="page-wrap">
        <h2 align="center">PURCHASE ORDER DOCUMENT(s)<br />
           <%=po_code %>  <br />
            <a href="#" onclick="window.print();" class="btnPrint">Print <i class="fa fa-print"></i></a>
            <br />
        </h2>
        <br />

        <%=htmlOutput %>
    </div>
    <script type="text/javascript">
        window.print();
    </script>
</body>
</html>
