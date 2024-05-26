<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="PrintPreview.aspx.cs" Inherits="myTree.WebForms.Modules.RFQ.PrintPreview" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>RFQ print preview</title>
    <link href="/Workspace/Style_CIFORWorkspace/js/plugins/datatables/styles/normalize.min.css"
        rel="stylesheet" type="text/css" />
    <style>
        * { margin: 0; padding: 0; }
        #page-wrap { width: 800px; margin: 0 auto; }
        .letterhead {
            width: 100%;
            height: 50px;
        }
        .letterhead img {
            width: 100%;
            height: auto;
        }
        .left { float: left;}
        .right { float: right; }

        a.btnPrint{
	        display:inline-block;
	        padding:0.2em 1.45em;
	        margin:0.1em;
	        border:0.15em solid #CCCCCC;
	        box-sizing: border-box;
	        text-decoration:none;
	        font-family:'Segoe UI','Roboto',sans-serif;
	        font-weight:400;
	        color:#000000;
	        background-color:#CCCCCC;
	        text-align:center;
	        position:relative;
	        float:right;
        }
        a.btnPrint:hover{
	        border-color:#7a7a7a;
        }
        a.btnPrint:active{
	        background-color:#999999;
        }
        @media all and (max-width:30em){
	        a.btnPrint{
		        display:block;
		        margin:0.2em auto;
	        }
        }
    </style>
    <style media="print">
        a.btnPrint{
	        display:none;
        }

        .tableheader {
            color: #000 !important;
        }
    </style>
</head>
<body>
    <div id="page-wrap">
        <div class="letterhead">
            <%--<img src="<%=Page.ResolveUrl("~/img/cifor_letterhead.png")%>">--%>
		    <a href="#" onclick="window.print();" class="btnPrint">Print <i class="fa fa-print"></i></a> 
		</div>
        <%=htmlOutput %>
    </div>
    <script type="text/javascript">
        window.print();
    </script>
</body>
</html>

