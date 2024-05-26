<%@ Page MasterPageFile="~/Procurement.Master" Language="C#" AutoEventWireup="true" CodeBehind="Detail.aspx.cs" Inherits="myTree.WebForms.Modules.DirectPurchase.Detail" %>

<asp:Content ID="Content1" ContentPlaceHolderID="AppHead" runat="server">
    <title>Direct purchase</title>
    <style>
        .select2 {
            min-width: 150px !important;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="AppBody" runat="server">
    <div class="floatingBox" id="error-box" style="display: none">
        <div class="alert alert-error" id="error-message">
        </div>
    </div>
    <%  if ((isAdmin || isUser) && !string.IsNullOrEmpty(_id))
        { %>
    <div class="row-fluid">
        <div class="floatingBox" style="margin-bottom:0px;">
            <div class="container-fluid">
                <div class="controls text-right">
                    <button id="btnAuditTrail" class="btn btn-success" type="button">Audit trail</button>                           
                </div> 
            </div>
        </div>
    </div>
    <%  } %>
    <div class="containerHeadline">
        <h2>Direct purchase information(s)</h2>
    </div>
    <div class="row-fluid">
        <div class="floatingBox">
            <div class="container-fluid">
                <div class="control-group">
                    <label class="control-label">
                        PR code
                    </label>
                    <div class="controls labelDetail">
                        <b><%=dp.pr_no %></b>
                        <input type="hidden" name="action" value="" id="action"/>
                        <input type="hidden" name="doc_id" value="<%=dp.id %>"/>
                        <input type="hidden" name="doc_type" value="DIRECT PURCHASE"/>
                        <input type="hidden" id="status" value="<%=dp.id %>"/>

                        <input type="hidden" name="id" value="<%=dp.id %>"/>
                        <input type="hidden" name="pr_id" value="<%=dp.pr_id %>"/>
                        <input type="hidden" name="pr_line_id" value="<%=dp.pr_line_id %>"/>
                        <input type="hidden" name="item_id" value="<%=dp.item_id %>"/>
                    </div>
                </div>
                <div class="control-group">
                    <label class="control-label">
                        Item code
                    </label>
                    <div class="controls labelDetail">
                        <%=dp.item_code %>
                    </div>
                </div>
               <%-- <div class="control-group">
                    <label class="control-label">
                        Brand
                    </label>
                    <div class="controls labelDetail">
                        <%=dp.brand_name %>
                    </div>
                </div>--%>
                <div class="control-group">
                    <label class="control-label">
                        Specifications
                    </label>
                    <div class="controls labelDetail">
                        <%=dp.description %>
                    </div>
                </div>
                <div class="control-group">
                    <label class="control-label">
                        Actual purchase date
                    </label>
                    <div class="controls labelDetail">
                        <%=dp.purchase_date %>
                    </div>
                </div>
                <div class="control-group">
                    <label class="control-label">
                        Actual supplier
                    </label>
                    <div class="controls labelDetail">
                        <%=dp.vendor_name %>

                          <% if (listSundry != "[]")
                            { %>
                        <span class="label btn-primary btnSundryEdit" data-toggle="modal" href="#SundryForm" title="View detail"><i class="icon-info" style="opacity: 0.7;"></i></span >
                        <% } %>
                    </div>
                </div>
                <div class="control-group">
                    <label class="control-label">
                        Detail(s)
                    </label>
                    <div class="controls">
                        <div class="span10">
                            <table class="table table-bordered table-hover" style="border: 1px solid #ddd">
                                <thead>
                                    <tr>
                                        <th style="width:40%;">&nbsp;</th>
                                        <th style="width:30%; text-align:center;">Requested</th>
                                        <th style="width:30%; text-align:center;">Actual</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td>Currency</td>
                                        <td><%=dp.pr_currency %></td>
                                        <td><%=dp.purchase_currency %></td>
                                    </tr>
                                    <tr>
                                        <td>Exchange rate (to USD)</td>
                                        <td style="text-align:right;"><%=dp.pr_exchange_rate %></td>
                                        <td style="text-align:right;"><%=dp.exchange_rate%></td>
                                    </tr>
                                    <tr>
                                        <td>Quantity</td>
                                        <td style="text-align:right;" id="pr_purchase_qty"><%=dp.purchase_qty %></td>
                                        <td style="text-align:right;" id="act_direct_purchase_qty"><%=dp.direct_purchase_qty %></td>
                                    </tr>
                                    <tr>
                                        <td>Unit price</td>
                                        <td style="text-align:right;" id="pr_unit_price"><%=dp.pr_unit_price %></td>
                                        <td style="text-align:right;" id="act_unit_price"><%=dp.unit_price%></td>
                                    </tr>
                                    <tr>
                                        <td><b>Total</b></td>
                                        <td style="text-align:right;"><span id="pr_total_cost" style="font-weight:bold;"><%=dp.pr_total_cost %></span></td>
                                        <td style="text-align:right;"><span id="Total" style="font-weight:bold;"><%=dp.total_cost %></span></td>
                                    </tr>
                                    <tr>
                                        <td><b>Total (USD)</b></td>
                                        <td style="text-align:right;"><span id="pr_total_cost_usd" style="font-weight:bold;"><%=dp.pr_total_cost_usd %></span></td>
                                        <td style="text-align:right;"><span id="TotalUSD" style="font-weight:bold;"><%=dp.total_cost_usd %></span></td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
                <div class="control-group">
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
                        <br />
                    </div>
                </div>
                <div class="control-group last">
                    <div class="controls">
                        <button id="btnClose" class="btn" type="button">Close page</button>
                    </div>
                </div>
            </div>
        </div>
    </div>

    
      <!-- Bootstrap modal sundry supplier-->
    <div id="SundryForm" class="modal hide fade modal-dialog" tabindex="-1" role="dialog" aria-labelledby="header1" aria-hidden="true"
        data-backdrop="static" data-keyboard="false">
        <div class="modal-header">
            <button type="button" class="close" data-dismiss="modal" aria-hidden="true"></button>
            <h3 id="header1">Detail sundry supplier</h3>
        </div>
        <div class="modal-body">
            <div class="floatingBox" id="SundryForm-error-box" style="display: none">
                <div class="alert alert-error" id="SundryForm-error-message">
                </div>
            </div>

            <table id="" class="table table-bordered table-hover" style="border: 1px solid #ddd">
                <thead>
                    <tr>
                        <th style="width: 30%;">&nbsp;</th>
                        <th style="width: 70%;" id="source_info">Supplier information</th>
                    </tr>
                </thead>
                <tbody>
                </tbody>
            </table>
        </div>
        <div class="modal-footer">
            <button type="button" class="btn" data-dismiss="modal" aria-hidden="true">Close and cancel</button>
        </div>
    </div>
    <!-- end of bootstrap modal -->

    <script>
        var _id = "<%=_id%>";
        
        var listAttachment = <%=listAttachment%>;
        var source = "<%=source%>";
        var dataSundry = <%= listSundry %>;

        $(document).ready(function () {
            $.each(listAttachment, function (i, d) {
                addAttachment(d.id, "", d.file_description, d.filename);
            });
            populateData();
        });

        function populateData() {
            $("#pr_purchase_qty").text(accounting.formatNumber($("#pr_purchase_qty").text(), 2));
            $("#pr_unit_price").text(accounting.formatNumber($("#pr_unit_price").text(), 2));
            $("#pr_total_cost").text(accounting.formatNumber($("#pr_total_cost").text(), 2));
            $("#pr_total_usd").text(accounting.formatNumber($("#pr_total_usd").text(), 2));

            $("#act_direct_purchase_qty").text(accounting.formatNumber($("#act_direct_purchase_qty").text(), 2));
            $("#act_unit_price").text(accounting.formatNumber($("#act_unit_price").text(), 2));
            $("#Total").text(accounting.formatNumber($("#Total").text(), 2));
            $("#TotalUSD").text(accounting.formatNumber($("#TotalUSD").text(), 2));

        }

        
        $(document).on("click", "#btnClose", function () {
            if (source === "detail") {
                var _pr_id = $("[name='pr_id']").val();
                location.href = '<%=Page.ResolveUrl("~/PurchaseRequisition/Detail.aspx?id=' + _pr_id + '")%>';
            } else {
                location.href = '<%=Page.ResolveUrl("~/PurchaseRequisition/List.aspx")%>';
            }
        });

        $(document).on("click", "#btnAddAttachment", function () {
            addAttachment("", "", "", "");
        });

        function addAttachment(id, uid, description, filename) {
            if (uid === "" || typeof uid === "undefined" || uid === null) {
                var uid = guid();
            }
            var html = '<tr>';
            html += '<td>' + description + '</td>';
            html += '<td><span class="linkDocument"><a href="Files/' + _id + '/' + filename + '" target="_blank">' + filename + '</a>&nbsp;</span></td >';
            html += '</tr>';
            $("#tblAttachment tbody").append(html);
        }

        $(document).on("click", "#btnAuditTrail", function () {
            ShowCustomPopUp("<%= ResolveUrl("~"+based_url+"/AuditTrail.aspx?blankmode=1&module=directpurchase&id=" + _id) %>");
        });

        //Sundry supplier
        $(document).on("click", ".btnSundryEdit", function () {

            EditSundry();
        });

        function EditSundry() {
            $("#SundryForm tbody").empty();
            $("#SundryForm-error-message").empty();
            $("#SundryForm-error-box").hide();
            var id = "<%= dp.vendor_id %>";
            var company_name = "<%=dp.vendor_name%>";

            var html = "";
            html += '<tr>'
                + '<td>Sundry </td>'
                + '<td>' + company_name
                + '<input type="hidden" name="sundry.id" value="' + id + '" >'
                + '</td>'
                + '</tr>'
                + '<tr>'
                + '<td>Name <span style="color: red;">*</span></td>'
                + '<td>'
                + '<div class="">'
                + '<div class="">'
                + '<input type="text" name="sundry.name" placeholder="Name" value=""  class="span12" readonly/>'
                + '</div>'
                + '</div>'
                + '</td>'
                + '</tr>'
                + '<tr>'
                //
                + '<tr>'
                + '<td>Contact person <span style="color: red;">*</span></td>'
                + '<td>'
                + '<div class="">'
                + '<div class="">'
                + '<input type="text" name="sundry.contact_person" placeholder="Contact person" value="" class="span12" readonly/>'
                + '</div>'
                + '</div>'
                + '</td>'
                + '</tr>'
                //
                + '<tr>'
                + '<td>Email <span style="color: red;">*</span></td>'
                + '<td>'
                + '<div class="">'
                + '<div class="">'//
                + '<input type="email" name="sundry.email" placeholder="Email" value="" class="span12" readonly/>'
                + '</div>'
                + '</div>'
                + '</td>'
                + '</tr>'
                //
                + '<tr>'
                + '<td>Phone number <span style="color: red;">*</span></td>'
                + '<td>'
                + '<div class="">'
                + '<div class="">'//
                + '<input type="text" name="sundry.phone_number" placeholder="Phone number" value="" class="span12" readonly/>'
                + '</div>'
                + '</div>'
                + '</td>'
                + '</tr>'
                //
                + '<td>Bank account</td>'
                + '<td>'
                + '<div class="">'
                + '<div class="">'
                + '<input type="text" name="sundry.bank_account" placeholder="Bank account" value="" class="span12" readonly/>'
                + '</div>'
                + '</div>'
                + '</td>'
                + '</tr>'
                + '<tr>'
                + '<td>Swift</td>'
                + '<td>'
                + '<div class="">'
                + '<div class="">'
                + '<input type="text" name="sundry.swift" placeholder="Swift" value="" class="span12" readonly/>'
                + '</div>'
                + '</div>'
                + '</td>'
                + '</tr>'
                + '<tr>'
                + '<td>Sort code</td>'
                + '<td>'
                + '<div class="">'
                + '<div class="">'
                + '<input type="text" name="sundry.sort_code" placeholder="Sort code" value="" class="span12" readonly/>'
                + '</div>'
                + '</div>'
                + '</td>'
                + '</tr>'
                + '<tr>'
                + '<td>Address</td>'
                + '<td>'
                + '<textarea name="sundry.address" class="textareavertical span12"  maxlength="2000" rows="10" placeholder="address" readonly ></textarea>'
                + '<div class="mt-1" style="font-size: 80%; font-style: italic; display: block;">Maximum description is 160 characters</div>'
                + '</td>'
                + '</tr>'
                + '<tr>'
                + '<td>Place <span style="color: red;">*</span></td>'
                + '<td>'
                + '<div class="">'
                + '<div class="">'
                + '<input type="text" name="sundry.place" placeholder="Place" value=""  class="span12" readonly/>'
                + '</div>'
                + '</div>'
                + '</td>'
                + '</tr>'
                + '<tr>'
                + '<td>Province</td>'
                + '<td>'
                + '<div class="">'
                + '<div class="">'
                + '<input type="text" name="sundry.province" placeholder="Province" value="" class="span12" readonly/>'
                + '</div>'
                + '</div>'
                + '</td>'
                + '</tr>'
                + '<tr>'
                + '<td>Post code</td>'
                + '<td>'
                + '<div class="">'
                + '<div class="">'
                + '<input type="text" name="sundry.post_code" placeholder="Post code" value="" class="span12" readonly/>'
                + '</div>'
                + '</div>'
                + '</td>'
                + '</tr>'
                + '<tr>'
                + '<td>VAT RegNo</td>'
                + '<td>'
                + '<div class="">'
                + '<div class="">'
                + '<input type="text" name="sundry.vat_reg_no" placeholder="VAT RegNo"  value="" class="span12" readonly/>'
                + '</div>'
                + '</div>'
                + '</td>'
                + '</tr>';

            $("#SundryForm").modal("show");
            $("#SundryForm tbody").append(html);
            populateSundry();
        }
        function populateSundry() {
            var id = $("[name='sundry.id']").val();
            var idx = dataSundry.findIndex(x => x.sundry_supplier_id == id);
            var d = dataSundry[idx];
            if (idx != -1) {
                $("[name='sundry.name']").val(d.name);
                $("[name='sundry.address']").text(d.address);
                $("[name='sundry.bank_account']").val(d.bank_account);
                $("[name='sundry.swift']").val(d.swift);
                $("[name='sundry.sort_code']").val(d.sort_code);
                $("[name='sundry.place']").val(d.place);
                $("[name='sundry.province']").val(d.province);
                $("[name='sundry.post_code']").val(d.post_code);
                $("[name='sundry.vat_reg_no']").val(d.vat_reg_no);
                $("[name='sundry.contact_person']").val(d.contact_person);
                $("[name='sundry.email']").val(d.email);
                $("[name='sundry.phone_number']").val(d.phone_number);
            }

        }
    </script>
</asp:Content>