<%@ Page MasterPageFile="~/Procurement.Master" Language="C#" AutoEventWireup="true" CodeBehind="Main.aspx.cs" Inherits="myTree.WebForms.Modules.Main" %>

<%@ Import Namespace="myTree.WebForms.Procurement.General" %>
<asp:Content ID="Content1" ContentPlaceHolderID="AppHead" runat="server">
    <title>Home</title>
    <link rel="stylesheet" type="text/css" href="css/leftMenu.css" />
    <script type="text/jscript">
        $(document).ready(function () {
            $("#left ul.nav li.parent > a > span.sign").trigger('click');
        });
        !function ($) {
            // Le left-menu sign
            /* for older jquery version
            $('#left ul.nav li.parent > a > span.sign').click(function () {
            $(this).find('i:first').toggleClass("icon-minus");
            }); */

            $(document).on("click", "#left ul.nav li.parent > a > span.sign", function () {
                $(this).find('i:first').toggleClass("icon-minus");
            });

            // Open Le current menu
            $("#left ul.nav li.parent.active > a > span.sign").find('i:first').addClass("icon-minus");
            $("#left ul.nav li.current").parents('ul.children').addClass("in");

        }(window.jQuery);
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="AppBody" runat="server">

    <div class="floatingBox" id="general_information_tab_content">
        <div class="container-fluid">
            <div id="left" class="span6" style="width: 100%;">
                <ul id="menu-group-1" class="nav menu" style="background-color: #ffffff">
                    <%  if (roleAccess(AccessControlObjectEnum.ProcurementSupplierList).isCanRead)
                        { %>
                    <li class="item-25 deeper parent">
                        <a class="parent" href="javascript:void(0);">
                            <span data-toggle="collapse" data-parent="#menu-group-1" href="#sub-item-1" class="sign">
                                <i class="icon-plus icon-white"></i>
                            </span>
                            <span class="lbl lblParent"><b>Master</b></span>
                        </a>
                        <ul class="children nav-child unstyled small collapse" id="sub-item-1">
                            <%--<li>
                                <a class="" href="Brand/List.aspx">
                                    <span class="sign"><i class="icon-play"></i></span>
                                    <span class="lbl">Brands</span> 
                                </a>
                            </li>
                            <li>
                                <a class="" href="Category/List.aspx">
                                    <span class="sign"><i class="icon-play"></i></span>
                                    <span class="lbl">Categories and Sub Categories</span> 
                                </a>
                            </li>
                            <li>
                                <a class="" href="Item/List.aspx">
                                    <span class="sign"><i class="icon-play"></i></span>
                                    <span class="lbl">Items</span> 
                                </a>
                            </li>--%>

                            <li>
                                <a class="" href="<%=ResolveUrl("~"+based_url+"/BusinessPartner/List.aspx")%>">
                                    <span class="sign"><i class="icon-play"></i></span>
                                    <span class="lbl">Suppliers</span>
                                </a>
                            </li>

                            <%--<%  if (userRoleAccess.RoleNameInSystem == "admin")
                                { %>
                            <li>
                                <a class="" href="TaskRegistration.aspx">
                                    <span class="sign"><i class="icon-play"></i></span>
                                    <span class="lbl">Summary Task Registration</span>
                                </a>
                            </li>
                            <%  } %>--%>
                        </ul>
                    </li>
                    <%  } %>
                    <li class="item-25 deeper parent">
                        <a class="parent" href="javascript:void(0);">
                            <span data-toggle="collapse" data-parent="#menu-group-1" href="#sub-item-8" class="sign">
                                <i class="icon-plus icon-white"></i>
                            </span>
                            <span class="lbl lblParent"><b>Purchase</b></span>
                        </a>
                        <ul class="children nav-child unstyled small collapse" id="sub-item-8">
                            <li>
                                <a class="" href="<%=roleAccess(AccessControlObjectEnum.ProcurementPurchaseRequisitionList).isCanRead?ResolveUrl("~"+based_url+"/PurchaseRequisition/List.aspx"):ResolveUrl("~"+based_url+"/PurchaseRequisition/Input.aspx?submission_page_type=1") %>">
                                    <span class="sign"><i class="icon-play"></i></span>
                                    <span class="lbl">Purchase Requisitions</span>
                                </a>
                            </li>
                            <%  if (!roleAccess(AccessControlObjectEnum.ProcurementPurchaseRequisitionList).isCanRead)
                                { %>
                            <li>
                                <a class="" href="<%=ResolveUrl("~"+based_url+"/PurchaseRequisition/Input.aspx?submission_page_type=2") %>">
                                    <span class="sign"><i class="icon-play"></i></span>
                                    <span class="lbl">Request for Payment</span>
                                </a>
                            </li>
                            <%  } %>
                            <%  if (roleAccess(AccessControlObjectEnum.ProcurementRFQList).isCanRead)
                                { %>
                            <li>
                                <a class="" href="<%=ResolveUrl("~"+based_url+"/RFQ/List.aspx")%>">
                                    <span class="sign"><i class="icon-play"></i></span>
                                    <span class="lbl">Request For Quotations</span>
                                </a>
                            </li>
                            <%  } %>
                            <%  if (roleAccess(AccessControlObjectEnum.ProcurementQuotationList).isCanRead)
                                { %>
                            <li>
                                <a class="" href="<%=ResolveUrl("~"+based_url+"/Quotation/List.aspx")%>">
                                    <span class="sign"><i class="icon-play"></i></span>
                                    <span class="lbl">Quotations</span>
                                </a>
                            </li>
                            <%  } %>
                            <%  if (roleAccess(AccessControlObjectEnum.ProcurementQuotationAnalysisList).isCanRead)
                                { %>
                            <li>
                                <a class="" href="<%=ResolveUrl("~"+based_url+"/QuotationAnalysis/List.aspx")%>">
                                    <span class="sign"><i class="icon-play"></i></span>
                                    <span class="lbl">Quotation Analysis</span>
                                </a>
                            </li>
                            <%  } %>
                            <%  if (roleAccess(AccessControlObjectEnum.ProcurementPurchaseOrderList).isCanRead)
                                { %>
                            <li>
                                <a class="" href="<%=ResolveUrl("~"+based_url+"/PurchaseOrder/List.aspx")%>">
                                    <span class="sign"><i class="icon-play"></i></span>
                                    <span class="lbl">Purchase Orders</span>
                                </a>
                            </li>
                            <%  } %>
                        </ul>
                    </li>
                </ul>
            </div>
        </div>
    </div>
</asp:Content>
