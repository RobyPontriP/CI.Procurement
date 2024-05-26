<%@ Page MasterPageFile="~/Procurement.Master" Language="C#" AutoEventWireup="true" CodeBehind="Detail.aspx.cs" Inherits="myTree.WebForms.Modules.Quotation.Detail" %>
<%@ Register Src="~/Usc/uscRecentComment.ascx" TagName="recentcomment" TagPrefix="uscComment" %>
<%@ Register Src="~/Usc/uscCancellationForm.ascx" TagName="cancellationform" TagPrefix="uscCancellation" %>
<asp:Content ID="Content1" ContentPlaceHolderID="AppHead" runat="server">
    <title>Quotation</title>
    <style>
        .select2 {
            min-width: 50px !important;
        }

        .textRight {
            text-align: right !important;
        }
        
        .controls {
            padding-top: 5px;
        }

        .modal-dialog-close {
            margin: auto 12%;
            width: 60%;
            height: 320px !important;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="AppBody" runat="server">
    <input type="hidden" id="status" value="<%=Q.status_id %>"/>
    <input type="hidden" name="quo.id" value="<%=Q.id %>"/>
    
    <!-- for upload file -->
    <input type="hidden" name="action" id="action" value=""/>
    <input type="hidden" id="quo.id" name="doc_id" value="<%=Q.id %>"/>
    <input type="hidden" name="doc_type" value="QUOTATION"/>
    <input type="hidden" name="file_name" id="file_name" value="" />
    <input type="hidden" name="docidtemp" value="" />
    <!-- end of upload file -->

    <div class="floatingBox" id="error-box" style="display: none">
        <div class="alert alert-error" id="error-message">
        </div>
    </div>

    <%  if (isAdmin || isUser)
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

    <!-- Cancellation Form -->
    <uscCancellation:cancellationform ID="cancellationForm" runat="server" />

    <!-- Recent comment -->
    <uscComment:recentcomment ID="recentComment" runat="server" />
    <input type="hidden" id="q_no" value="<%=Q.q_no %>"/>
    <div class="row-fluid">
        <div class="floatingBox">
            <div class="container-fluid">
                <%  if (!String.IsNullOrEmpty(Q.q_no))
                    { %>
                <div class="control-group">
                    <label class="control-label">
                        Quotation code
                    </label>
                    <div class="controls">
                        <b><%=Q.q_no %></b>
                    </div>
                </div>
                <%  } %>
                <%  if (!String.IsNullOrEmpty(Q.q_no))
                    { %>
                <div class="control-group">
                    <label class="control-label">
                        Quotation status
                    </label>
                    <div class="controls">
                        <b><%=Q.status_name %></b>
                    </div>
                </div>
                <%  } %>
                <div class="control-group" id="source_rfq">
                    <label class="control-label">
                        RFQ code
                    </label>
                    <div class="controls">
                        <% var rfqDetailLink = "~/rfq/detail.aspx?id=" + Q.rfq_id + ""; %>
                        <a href="<%=Page.ResolveUrl(rfqDetailLink)%>" target="_blank"><%=Q.rfq_no %></a>
                    </div>
                </div>
                <div class="control-group" id="source_vendor">
                    <label class="control-label">
                        Supplier
                    </label>
                    <div class="controls">
                        <% var supplierDetailLink = "~/businesspartner/detail.aspx?id=" + Q.vendor + "";  %>
                        <%=Q.vendor_name %> (<%=Q.vendor_code %>)

                        <% if (listSundry != "[]")
                            { %>
                        <span class="label btn-primary btnSundryEdit" data-toggle="modal" href="#SundryForm" title="View detail"><i class="icon-info" style="opacity: 0.7;"></i></span >
                        <% } %>
                    </div>
                </div>
                <div class="control-group">
                    <label class="control-label">
                      Supplier quotation number
                    </label>
                    <div class="controls">
                        <%=Q.vendor_document_no %>
                    </div>
                </div>
                <%  if (Q.rfq_id == "0" || string.IsNullOrEmpty(Q.rfq_id))
                    { %>
                <div class="control-group">
                    <label class="control-label">
                        RFQ reference code
                    </label>
                    <div class="controls">
                        <%=Q.reff_rfq_no %>
                    </div>
                </div>
                <%  } %>
                <div class="control-group">
                    <label class="control-label">
                        Received date
                    </label>
                    <div class="controls">
                        <%=Q.receive_date %>
                    </div>
                </div>
                <div class="control-group">
                    <label class="control-label">
                        Quotation date
                    </label>
                    <div class="controls">
                        <%=Q.document_date %>
                    </div>
                </div>
                <div class="control-group">
                    <label class="control-label">
                        End of validity date
                    </label>
                    <div class="controls">
                        <%=Q.due_date %>
                    </div>
                </div>
                <div class="control-group">
                    <label class="control-label">
                        Payment terms
                    </label>
                    <div class="controls multilines"><%=Q.payment_terms_name %></div>
                </div>
                <%--<%  if (Q.payment_terms.ToLower() == "oth") { %>--%>
                <%  if (Q.is_other_payment_terms.ToLower() == "1") { %>
                 <div class="control-group">
                    <label class="control-label">
                        Other payment terms
                    </label>
                    <div class="controls multilines"><%=Q.other_payment_terms %></div>
                </div>
                <%} %>
                <div class="control-group">
                    <label class="control-label">
                        Remarks
                    </label>
                    <div class="controls multilines"><%=Q.remarks %></div>
                </div>
                <div class="control-group">
                    <label class="control-label">
                        Product(s)
                    </label>
                    <div class="controls">
                        <table id="tblItems" class="table table-bordered table-hover" data-title="Product(s)" style="border: 1px solid #ddd">
                            <thead>
                                <tr>
                                    <th style="width:3%;">&nbsp;</th>
                                    <th style="width:15%;">Product code</th>
                                    <th style="width:15%;">Description</th>
                                       <th style="width:15%;">Quotation description</th>
                                    <th style="width:10%;">PR code</th>
                                    <th style="width:15%;" id="labelTotalQ">Total</th>
                                    <th style="width:15%;">Total (USD)</th>
                                    <th style="width:5%;">Status</th>
                                    <th style="width:7%;">&nbsp;</th>
                                 </tr>
                            </thead>
                            <tbody></tbody>
                            <tfoot>
                                <tr>
                                    <th colspan="5" style="text-align:right; font-weight:bold;" >Discount total</th>
                                    <th style="text-align:right;">
                                        <%  if (Q.discount_type == "$")
                                            { %>
                                            <%=Q.discount_currency %> <%=Q.discount %>
                                        <%  }else{%>
                                            <%=Q.discount %>%
                                        <%  } %>
                                    </th>
                                    <th style="text-align:right; font-weight:bold;">
                                        <div id="discountUSD" style="display:block"></div>
                                        <div id="totalOriginalUSD" style="display:none"></div>
                                    </th>
                                    <th>&nbsp;</th>
                                    <th>&nbsp;</th>
                                </tr>
                                <tr>
                                    <th colspan="5" style="text-align:right; font-weight:bold;">Grand total</th>
                                    <th id="GrandTotal" style="text-align: right; font-weight:bold;"><%=Q.quotation_amount %></th>
                                    <th id="GrandTotalUSD" style="text-align: right; font-weight:bold;"><%=Q.quotation_amount_usd %></th>
                                    <th>&nbsp;</th>
                                    <th>&nbsp;</th>
                                </tr>
                            </tfoot>
                        </table>
                        <br />
                    </div>
                </div>
                <div class="control-group">
                    <label class="control-label">
                        Quotation file(s)
                    </label>
                    <div class="controls">
                        <table id="tblAttachment" class="table table-bordered table-hover" data-title="Quotation file(s)" style="border: 1px solid #ddd">
                            <thead>
                                <tr>
                                    <th style="width:50%;">Description</th>
                                    <th style="width:40%;">File</th>
                                    <th style="width:10%;" class="btnDelete">&nbsp;</th>
                                </tr>
                            </thead>
                            <tbody>
                            </tbody>
                        </table>
                        <div class="doc-notes"></div>
                          <p><button id="btnAddAttachment" class="btn btn-success" type="button" hidden>Add quotation file</button>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                              <button id="btnUpdateAttachment" class="btn btn-success" type="button" hidden>Update</button>
                            </p>
                        <%  if (isAdmin)
                            { %>
                      <%--  <p><button id="btnAddAttachment" class="btn btn-success" type="button">Add quotation file</button>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                        </p>--%>
                        <br />
                        <%  } %>
                    </div>
                </div>
                <div class="control-group last">
                    <div class="controls">
                        <button id="btnClose" class="btn" type="button">Close page</button>&nbsp;&nbsp;&nbsp;
                        <%  if (isEditable && Q.status_id != "95")
                            { %>
                        <button id="btnEdit" class="btn btn-success" type="button" data-action="edited">Edit</button>
                        <%  } %>
                         <%  if (max_status != "50")
                            { %>
                        
                        <%  if (max_status == "25" && isEditable)
                            { %>
                        <button id="btnCancel" class="btn btn-danger" type="button" data-action="cancelled">Cancel this Quotation</button>
                        <%  } %>
                        <%  } %>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <!-- modal form -->
    <div id="CloseForm" class="modal hide fade modal-dialog modal-dialog-close" tabindex="-1" role="dialog" aria-labelledby="header1" aria-hidden="true"
        data-backdrop="static" data-keyboard="false">
	    <div class="modal-header">
		    <button type="button" class="close" data-dismiss="modal" aria-hidden="true"></button>
			    <h3 id="header1">Reason for closing</h3>
	    </div>
	    <div class="modal-body">
            <div class="floatingBox" id="closeform-error-box" style="display: none">
                <div class="alert alert-error" id="closeform-error-message">
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">
                    Remaining quantity
                    <input type="hidden" id="close_quantity" />
                    <input type="hidden" id="quotation_detail_id" />
                </label>
                <div class="controls" id="close_quantity_text">
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">
                    Reason for closing
                </label>
                <div class="controls">
                    <textarea id="close_remarks" rows="3" class="span12 textareavertical"></textarea>
                </div>
            </div>
        </div>
        <div class="modal-footer">
            <button type="button" class="btn btn-success" aria-hidden="true" id="btnSaveClosing">Submit closing item</button>
            <button type="button" class="btn" data-dismiss="modal" aria-hidden="true" id="btnCanceClosing">Close and cancel</button>
	    </div>
    </div>
    <!-- end of modal form -->

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
        var blankmode = "<%=blankmode%>";
        
        var isAdmin = "<%=isAdmin?"true":"false"%>";
        isAdmin = (isAdmin === "true");

        var isProcurementUser = "<%=isUser?"true":"false"%>";
        isProcurementUser = (isProcurementUser === "true");

        var QuoItems = <%=listDetails%>;
        var Attachments = <%=listAttachments%>;
        var source = "<%=Q.source%>"; 
        var curr = "<%=Q.currency_id%>";
        var listCurrency = <%=listCurrency%>;
        var discountCurrency = "<%=Q.discount_currency %>";
        var dataSundry = <%= listSundry %>;
        var Q = <%= listHeader %> // list Header

        var deletedId = [];

        var ItemTable;
        var filenameupload = "";
        var btnFileUpload = null;

        var isSameOffice = "<%=isSameOffice?"true":"false"%>";
        var isEditable = "<%=isEditable?"true":"false"%>";

        $(document).ready(function () {
            changeSource();
            populateCurrency();
            $(".doc-notes").hide();
            if (Attachments.length == 0) {
                let rowatt = "<tr>";
                rowatt += '<td colspan="14" class="dataTables_empty" style="text-align:center">No data available</td>'
                rowatt += "</tr>";
                $("#tblAttachment tbody").append(rowatt);
            } else {
                $.each(Attachments, function (i, d) {
                    addAttachment(d.id, "", d.file_description, d.filename);
                });
            }            

            ItemTable = $('#tblItems').DataTable({
                "bFilter": false, "bDestroy": true, "bRetrieve": true, "paging": false, "bSort": false,"bLengthChange" : false, "bInfo":false, 
                "aaData": QuoItems,
                "aoColumns": [
                    {
                        "mDataProp": "id"
                        , "mRender": function (d, type, row) {
                            return '<i class="icon-chevron-sign-down" title="View detail(s)"></i>'
                        }
                    },
                    { "mDataProp": "item_code" },
                    {
                        "mDataProp": "desc"
                        , "mRender": function (d, type, row) {
                            return row.item_description;
                        }
                    },
                    {
                        "mDataProp": "quo_desc"
                        , "mRender": function (d, type, row) {
                            return row.quotation_description;
                        }
                    },
                    {
                        "mDataProp": "pr_no"
                        , "mRender": function (d, type, row) {
                            return '<a href="<%=Page.ResolveUrl("~/purchaserequisition/detail.aspx?id='+row.pr_id +'")%>" targer="_blank"">' + row.pr_no + '</a>';
                        }
                    },
                    {
                        "mDataProp": "line_total"
                        , "mRender": function (d, type, row) {
                            return row.currency_id+" "+accounting.formatNumber(delCommas(row.quantity_original), 2)
                        }
                    },
                    {
                        "mDataProp": "line_total_usd"
                        , "mRender": function (d, type, row) {
                            return accounting.formatNumber(delCommas(row.quantity_usd_original),2)
                        }
                    },
                    {
                        "mDataProp": "status_name"
                        ,"visible": false
                    },
                    {
                        "mDataProp": "actions"
                        , "sClass": "no-sort"
                        , "visible": isAdmin
                        , "mRender": function (d, type, row) {
                            var html = '<input name="id" type="hidden" value="' + row.id + '"/>';
                            if (typeof row.actions !== "undefined" && (row.status_id==25 || row.status_id==30)) {
                                html += row.actions;
                            }
                            return html;
                        }
                    },
                ]
                ,"bLengthChange": false
            });

            $('#tblItems_filter input').unbind();
            $('#tblItems_filter input').bind('keyup', function(e) {
                if (e.keyCode == 13) {
                    ItemTable.search(this.value).draw();	
                }
            });	

            $("form[name='aspnetForm']").submit(function () {
                return false;
            });
        
            $('#tblItems tbody').on('click', 'i[class^="icon-chevron"]', function () {
                if (!$(this).hasClass('no-sort')) {
                    var tr = $(this).closest('tr');
                    var row = ItemTable.row(tr);

                    $(this).attr('class', '');
                    
                    if (row.child.isShown()) {
                        // This row is already open - close it
                        row.child.hide();
                        tr.removeClass('shown');
                        $(this).attr('class', 'icon-chevron-sign-right');
                    } else {
                        // Open this row
                        row.child(format(row.data())).show();
                        tr.addClass('shown');
                        $(this).attr('class', 'icon-chevron-sign-down');
                    }
                }
            });

            $.each(ItemTable.rows().nodes(), function (i) {
                var row = ItemTable.row(i)
                if(!row.child.isShown()){
                    row.child(format(row.data())).show();
                    $(row.node()).addClass('shown');
                }
            });

            if ($("#tblAttachment tbody tr").length == 0) {
            }

            normalizeMultilines();
            calculateDiscountTotal();
            calculateGrandTotal();

            let accessButton = false;

            if (isSameOffice == "true" && (isProcurementUser == true || isAdmin == true)) {
                accessButton = true;
            }

            if ($('#status').val() == "50" || $('#status').val() == "25") {
                if ($('#status').val() == "50") {
                    $('#btnEdit').hide();
                    if (accessButton == true) {
                        $('#btnEdit').show();
                    }
                }

                if (accessButton == true) {
                    $('#btnAddAttachment').show();
                    $('#btnUpdateAttachment').show();
                } else {
                    $('.editDocument').hide();
                    $('.btnDelete').hide();
                    $("[name='attachment.file_description']").attr("readonly", "true");
                }
            }
        });

        function format(d) {
            var html = "";
            if (typeof d !== "undefined") {
                var discPerItem = "";

                if (d.discount_type == "%") {
                    discPerItem = accounting.formatNumber(delCommas(d.discount), 2) + "%";
                } else {
                    discPerItem = curr + ' ' + accounting.formatNumber(delCommas(d.discount), 2);
                }

                var source_type = "";
                if (d.rfq_id != "0") {
                    source_type = "RFQ";
                } else {
                    source_type = "PR";
                }

                var pr_currency;
                if (typeof d.pr_currency === "undefined" || d.pr_currency == null) {
                    pr_currency = "";
                } else {
                    pr_currency = d.pr_currency;
                }
     
                var exchange_sign_format = "";
                if (d.exchange_sign == "*") {
                    exchange_sign_format = "x"
                } else {
                    exchange_sign_format = "&divide;";
                }

                html += '<table class="table table-bordered table-hover" style="border: 1px solid #ddd">' +
                    '<thead><tr>' +
                    '<th style="width:25%;">&nbsp;</th>' +
                    '<th style="width:25%;" id="source_info">' + source_type + ' information</th>' +
                    '<th style="width:50%;" colspan="2">Quotation information</th>' +
                    '</tr></thead>' +
                    '<tbody>' +

                    '<tr><td>Currency</td>' +
                    '<td style="text-align:right;"></td>' +
                    '<td style="text-align:right;">' + d.currency_id + ' Exchange rate (to USD) '+exchange_sign_format+' '+d.exchange_rate+'</td><td style="width:25%; border-left:0px;">&nbsp;</td></tr>' +

                    '<tr><td>Quotation quantity</td>' +
                    '<td style="text-align:right;">' + accounting.formatNumber(delCommas(d.source_quantity), 2) + ' ' + d.uom + '</td>' +
                    '<td style="text-align:right;">' + accounting.formatNumber(delCommas(d.quotation_quantity), 2) + ' ' + d.uom + '</td><td style="width:25%; border-left:0px;">&nbsp;</td></tr>' +

                    '<tr><td>Quantity to be used in quotation analysis</td>' +
                    '<td style="text-align:right;"></td>' +
                    '<td style="text-align:right;">' + accounting.formatNumber(delCommas(d.quantity), 2) + ' ' + d.uom + '</td><td style="width:25%; border-left:0px;">&nbsp;</td></tr>' +

                    '<tr><td>Unit price</td>' +
                    '<td style="text-align:right;">' + pr_currency + ' ' + accounting.formatNumber(delCommas(d.pr_unit_price), 2) + '</td>' +
                    '<td style="text-align:right;">' + d.currency_id + ' ' + accounting.formatNumber(delCommas(d.unit_price), 2) + '</td><td style="border-left:0px;">&nbsp;</td></tr>' +

                    '<tr><td>Total</td>' +
                    '<td id="pr_estimated_cost" style="text-align:right;">' + pr_currency + ' ' + accounting.formatNumber(delCommas(d.pr_estimated_cost), 2) + '</td>' +
                    '<td style="text-align:right;">' + d.currency_id + ' ' + accounting.formatNumber(delCommas(d.quotation_quantity) * delCommas(d.unit_price), 2) + '</td><td style="border-left:0px;">&nbsp;</td></tr>' +

                    '<tr><td>Discount per item</td>' +
                    '<td>&nbsp;</td>' +
                    '<td style="text-align:right;">' + discPerItem + '</td><td style="border-left:0px;">&nbsp;</td></tr>' +

                    '<tr><td>Additional discount</td>' +
                    '<td>&nbsp;</td>' +
                    '<td style="text-align:right;">' + d.currency_id + ' ' + accounting.formatNumber(delCommas(d.additional_discount), 2) + '</td><td style="border-left:0px;">&nbsp;</td></tr>' +

                    '<tr><td>Total after discount</td>' +
                    '<td>&nbsp;</td>' +
                    '<td style="text-align:right;">' + d.currency_id + ' ' + accounting.formatNumber(delCommas(d.line_total), 2) + '&nbsp;&nbsp;&nbsp;/</td>' +
                    '<td style="border-left:0px;">USD ' + accounting.formatNumber(delCommas(d.line_total_usd), 2) + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td></tr > ' +

                    '<tr><td>Lead time</td>' +
                    '<td>&nbsp;</td>' +
                    '<td colspan="2">' + d.indent_time + '</td>' +
                    '</tr>' +

                    '<tr><td>Warranty</td>' +
                    '<td>&nbsp;</td>' +
                    '<td colspan="2">' + d.warranty + '</td></tr>' +

                    '<tr><td>Remarks</td>' +
                    '<td>&nbsp;</td>' +
                    '<td colspan="2">' + d.remarks + '</td></tr>';
                if (d.status_id == 50 && $.trim(d.close_remarks) != "") {
                    html += '<tr><td>Closing quantity</td>' +
                        '<td>&nbsp;</td>' +
                        '<td style="text-align:right;">' + accounting.formatNumber(d.close_quantity, 2) + ' ' + d.uom + '</td><td style="border-left:0px;">&nbsp;</td></tr>' +
                        '<tr><td>Reason for closing</td>' +
                        '<td>&nbsp;</td>' +
                        '<td colspan="2">' + d.close_remarks + '</td></tr>';
                }
                html += '</tbody></table>';
            }
            return html;
        }

        $(document).on("click", ".btnCloseRemaining", function () {
            var qd_id = $(this).closest("td").find("input").val();
            $("#quotation_detail_id").val(qd_id);
            var item = $.grep(QuoItems, function (n, i) {
                return n["id"] == qd_id;
            });
            $("#close_quantity").val("");
            $("#close_quantity_text").html("");
            $("#close_remarks").val("");
            if (item.length > 0) {
                var remaining_qty = item[0].quotation_quantity - item[0].vs_qty;
                $("#close_quantity").val(remaining_qty);
                $("#close_quantity_text").html(accounting.formatNumber(delCommas(remaining_qty), 2) + " " + item[0].uom);
            }
            $("#CloseForm").modal("show");
        });

        $(document).on("click", "#btnSaveClosing", function () {
            var data = new Object();
            data.id = $("#quotation_detail_id").val();
            data.close_quantity = delCommas($("#close_quantity").val());
            data.close_remarks = $("#close_remarks").val();
            data.quotation = _id;


            var errorMsg = "";
            if ($.trim($("#close_remarks").val()) == "" ) {
                errorMsg += "<br/> - Reason for closing is required.";
            }

            if (errorMsg == "") {
                submitClosing(data);
            } else {
                errorMsg = "Please correct the following error(s):" + errorMsg;

                $("#closeform-error-message").html("<b>" + errorMsg + "<b>");
                $("#closeform-error-box").show();
                $('.modal-body').animate({ scrollTop: 0 }, 500);
            }
        });

        $(document).on("click", "#btnCanceClosing", function () {
            $("#closeform-error-message").empty();
            $("#closeform-error-box").hide();           
        });


        function submitClosing(data) {
            var data = { quo_detail: JSON.stringify(data) };
            $.ajax({
                url: "<%=Page.ResolveUrl("Detail.aspx/ItemClosing")%>",
                data: JSON.stringify(data),
                dataType: 'json',
                type: 'post',
                contentType: "application/json; charset=utf-8",
                success: function (response) {
                    var output = JSON.parse(response.d);
                    if (output.result != "success") {
                        alert(output.message);
                    } else {
                        alert("Remaining item quantity has been closed successfully");
                        blockScreen();
                        location.href = "Detail.aspx?id=" + _id;
                    }
                }
            });
        }

        function changeSource() {
            var sel = source;
            /* RFQ */
            if (sel == "1") {
                $("#source_rfq").show();
            }
            /* PR */
            else if (sel == "2") {
                $("#source_rfq").hide();
            }
        }

        function populateCurrency() {
            $("#txt_TypeAmt").text(curr);
            //$("#labelTotalQ").text("Total (" + curr + ")");
            $(".currency").text(curr);
        }

        $(document).on("click", "#btnAddAttachment", function () {
            if ($("#tblAttachment >tbody >tr >td").hasClass("dataTables_empty") == true) {
                $(".dataTables_empty").remove();
            }
            addAttachment("", "", "", "");

        });

        function addAttachment(id, uid, description, filename) {
            description = NormalizeString(description);
            var quo_id = $("[name='quo.id']").val();
            if (uid === "" || typeof uid === "undefined" || uid === null) {
                var uid = guid();
            }
            var html = '<tr>';
            html += '<td><input type="hidden" name="attachment.uid" value="' + uid + '"/><input type="text" class="span12" name="attachment.file_description" data-title="Quotation file description" data-validation="required" maxlength="1000" placeholder="Description" value="' + description + '"/></td>';
            html += '<td><input type="hidden" name="attachment.filename" data-title="Quotation file" value="' + filename + '"/><div class="fileinput_' + uid + '">';
            html += '<input type="hidden" name="attachment.filename.validation" data-title="Quotation file" data-validation="required" value="' + filename + '" />';
            if (id !== "" && filename !== "") {
                html += '<span class="linkDocument"><a href="Files/' + quo_id + '/' + filename + '" target="_blank" id="linkDocument">' + filename + '</a>&nbsp;</span>';
                html += '<button type="button" class="btn btn-primary editDocument">Edit</button><input type="file" class="span10" name="filename" style="display: none;"/>';
                html += '<button type="button" class="btn btn-success btnFileUpload" style="display:none;">Upload</button>';
            } else {
                html += '<span class="linkDocument"><a href="" target="_blank" id="linkDocument">' + filename + '</a>&nbsp;</span>';
                html += '<button type="button" class="btn btn-primary editDocument" style="display: none;">Edit</button><input type="file" class="span10" name="filename"/>';
                html += '<button type="button" class="btn btn-success btnFileUpload">Upload</button>';
            }
            html += '</div></td > ';
            html += '<td class="btnDelete">';
            html += '<input type = "hidden" name = "attachment.id" value = "' + id + '" /> <span class="label red btnDelete" title="Delete"><i class="icon-trash delete" style="opacity: 1;"></i></span>';
            html += '</td > ';
            if (filename !== "") {
                html += '<td style="display:none;"><input type="hidden" name="attachment.uploaded" value="1"/></td>';
            } else {
                html += '<td style="display:none;"><input type="hidden" name="attachment.uploaded" value="0"/></td>';
            }
            html += '</tr>';
            $("#tblAttachment tbody").append(html);
        }

        //function addAttachment(id, uid, description, filename) {
        //    description = NormalizeString(description);
        //    var quo_id = $("[name='quo.id']").val();
        //    if (uid === "" || typeof uid === "undefined" || uid === null) {
        //        var uid = guid();
        //    }

        //    var html = '<tr>';
        //    html += '<td><input type="hidden" name="attachment.uid" value="' + uid + '"/>';
        //    if (isAdmin) {
        //        html += '<input type="text" class="span12" name="attachment.file_description" data-title="Quotation file description" data-validation="required" maxlength="2000" placeholder="Description" value="' + description + '" disabled/>';
        //    } else {
        //        html += description;
        //    }
        //    html += '</td>';
        //    html += '<td><input type="hidden" name="attachment.filename" data-title="Quotation file" data-validation="required" value="' + filename + '"/><div class="fileinput_' + uid + '">';
        //    if (id !== "" && filename !== "") {
        //        html += '<span class="linkDocument"><a href="Files/' + _id + '/' + filename + '" target="_blank" id="linkDocumentHref">' + filename + '</a>&nbsp;</span>';
        //        if (isAdmin) {
        //            html += '<button type="button" class="btn btn-success btnFileUpload" style="display:none;">Upload</button>';
        //        }
        //        html += '<td style="display:none;"><input type="hidden" name="attachment.uploaded" value="1"/></td>';
        //    } else {
        //        html += '<span class="linkDocument" style="display:none;"><a class href="" id="linkDocumentHref" target="_blank"></a>&nbsp;</span>';
        //        html += '<button type="button" class="btn btn-primary editDocument" style="display:none;">Edit</button>';
        //        html += '<input type="file" class="span10" name="filename" />';
        //        html += '<button type="button" class="btn btn-success btnFileUpload">Upload</button>';
        //        html += '<td style="display:none;"><input type="hidden" name="attachment.uploaded" value="0"/></td>';
        //    }
        //    html += '</div></td > ';
        //    if (isAdmin) {
        //        html += '<td><input type="hidden" name="attachment.id" value="' + id + '"/></td>';
        //    }
        //    html += '</tr>';

        //    $("#tblAttachment tbody").append(html);
        //}

        $(document).on("change", "input[name='filename']", function () {
            var obj = $(this).closest("tr").find("input[name='attachment.filename']");
            $(obj).val("");
            var filename = "";
            var fullPath = $(this).val();
            if (fullPath) {
                var startIndex = (fullPath.indexOf('\\') >= 0 ? fullPath.lastIndexOf('\\') : fullPath.lastIndexOf('/'));
                filename = fullPath.substring(startIndex);
                if (filename.indexOf('\\') === 0 || filename.indexOf('/') === 0) {
                    filename = filename.substring(1);
                }
                $(obj).val(filename);
            }
        });

        $(document).on("click", ".editDocument", function () {
            $(this).closest('td').find("input[name='attachment.filename']").val("");
            var obj = $(this).closest("td").find("input[name='filename']");
            var link = $(this).closest("td").find(".linkDocument");
            $(obj).show();
            $(link).hide();
            $(this).hide();
        });

        $(document).on("click", ".btnDelete", function () {
            var _sid = $(this).closest("td").find("input[name$='.id']").val();
            var _sname = $(this).closest("td").find("input").prop("name").split('.');

            var mname = "";
            if (typeof _sname !== "undefined" && _sname.length > 1) {
                mname = _sname[0];
            }

            if (_sid != "") {
                var _del = new Object();
                _del.id = _sid;
                _del.table = mname;
                deletedId.push(_del);
            }
            
            $(this).closest("tr").remove();

            if (mname == "attachment") {
                if ($("#tblAttachment tbody tr").length == 0) {
                }
            }

            //submitAttachment();
        });

        var uploadValidationResult = {};
	    $(document).on("click", "#btnUploadAttachment", function () {
		    var thisHandler = $(this);
		    $("[name=filename]").uploadValidation(function(result) {
			    uploadValidationResult = result;
			    onBtnClickUpload.call(thisHandler);
		    });
	    });

        var onBtnClickUpload = function () {
            var errorMsg = GeneralValidation();
            errorMsg += uploadValidationResult.not_found_message||'';
            errorMsg += FileValidation();

            if (errorMsg == "") {
                uploadAttachment();
            } else {
                showErrorMessage(errorMsg);
            }
        };

        function uploadAttachment() {
            $("#action").val("upload");
            var form = $('form')[0];
            var formData = new FormData(form);

            $.ajax({
                type: "POST",
                url: "<%=Page.ResolveUrl("~/Service.aspx")%>",
                data: formData,
                processData: false,
                contentType: false,
                success: function (response) {
                    var output = JSON.parse(response);
                    if (output.result !== "success") {
                        alert(output.message);
                    } else {
                        submitAttachment();
                    }
                    $("#action").val("");
                }
            });
        }

        function submitAttachment() {
            var atts = []
            $("#tblAttachment tbody tr").each(function () {
                var _att = new Object();
                _att["id"] = $(this).find("input[name='attachment.id']").val();
                _att["filename"] = $(this).find("input[name='attachment.filename']").val();
                _att["file_description"] = $(this).find("input[name='attachment.file_description']").val();
                atts.push(_att);
            });

            var data = new Object();
            data.id = _id;
            data.attachment = JSON.stringify(atts);
            data.deleted = JSON.stringify(deletedId);

            $.ajax({
                url: "<%=Page.ResolveUrl("Detail.aspx/UploadDocs")%>",
                data: JSON.stringify(data),
                dataType: 'json',
                type: 'post',
                contentType: "application/json; charset=utf-8",
                success: function (response) {
                    var output = JSON.parse(response.d);
                    if (output.result != "success") {
                        alert(output.message);
                    } else {
                        GenerateFileLink(btnFileUpload, filenameupload);
                        alert("Quotation " + $("#q_no").val() + " has been updated successfully.");
                        if (blankmode == "1") {
                            parent.$.colorbox.close();
                        } else {
                            parent.location.reload();
                        }                        
                    }
                }
            });
        }

        $(document).on("click", "#btnUpdateAttachment", function () {
            if ($("#tblAttachment >tbody >tr >td").hasClass("dataTables_empty") == true) {
                submitAttachment();
            } else {
                let errorMsg = "";
                errorMsg += FileValidation();

                let errorMsgFileName = "";
                let errorMsgFileDescription = "";

                var atts = [];

                $("#tblAttachment tbody tr").each(function () {
                    var _att = new Object();
                    _att["id"] = $(this).find("input[name='attachment.id']").val();
                    if (errorMsgFileName == "") {
                        if (($(this).find("input[name='attachment.filename']").val() == "" || $(this).find("input[name='attachment.filename']").val() == null) && $(this).find("input[name='attachment.filename']").val() != undefined) {
                            errorMsgFileName = "<br/> - File name is required.";
                        }

                        errorMsg += errorMsgFileName;
                    }

                    if (errorMsgFileDescription == "") {
                        if (($(this).find("input[name='attachment.file_description']").val() == "" || $(this).find("input[name='attachment.file_description']").val() == null) && $(this).find("input[name='attachment.file_description']").val() != undefined) {
                            errorMsgFileDescription = "<br/> - File description is required.";
                        }

                        errorMsg += errorMsgFileDescription;
                    }

                    _att["filename"] = $(this).find("input[name='attachment.filename']").val();
                    _att["file_description"] = $(this).find("input[name='attachment.file_description']").val();
                    atts.push(_att);

                    if ($(this).find("input[name='attachment.uploaded']").val() == "0") {
                        $(this).css({ 'background-color': 'rgb(245, 183, 177)' });
                        if (!errorMsg) {
                            errorMsg += "<br/> - There are files that have not been uploaded, please upload first.";//    errorMsg += "Please correct the following error(s): <br/> - There are files that have not been uploaded, please upload first.";
                        }
                    }
                });

                if (errorMsg != "") {
                    errorMsg = "Please correct the following error(s):" + errorMsg;
                    $("#error-message").html("<b>" + errorMsg + "<b>");
                    $("#error-box").show();
                    $("html, body").animate({ scrollTop: 0 });
                } else {
                    submitAttachment();
                }
            }
        });

        $(document).on("click", "#btnClose", function () {
            if (blankmode == "1") {
                parent.$.colorbox.close();  
            } else {
                parent.location.href = "List.aspx";
            }
        });

        $(document).on("click", "#btnEdit", function () {
            parent.location.href = "Input.aspx?id=" + _id;
        });

        $(document).on("click", "#btnCancel", function () {
            $("#CancelForm").modal("show");
        });

        var uploadValidationResult = {};
	    $(document).on("click", "#btnSaveCancellation", function () {
		    var thisHandler = $(this);
		    $("[name=cancellation_file],[name=filename]").uploadValidation(function(result) {
                uploadValidationResult = result;
			    onBtnClickSaveCancellation.call(thisHandler);
		    });
	    });

        var onBtnClickSaveCancellation = function () {
            var errorMsg = "";
            if ($.trim($("#cancellation_text").val()) == "" && $.trim($("#cancellation_file").val()) == "") {
                errorMsg += "<br/> - Reason for cancellation is required.";
            }
            errorMsg += uploadValidationResult.not_found_message||'';
            errorMsg += FileValidation();

            if (errorMsg == "") {
                uploadCancellationFile();
            } else {
                errorMsg = "Please correct the following error(s):" + errorMsg;

                $("#cform-error-message").html("<b>" + errorMsg + "<b>");
                $("#cform-error-box").show();
                $('.modal-body').animate({ scrollTop: 0 }, 500);
            }
        };

        function uploadCancellationFile() {
            $("input[name='action']").val("upload");
            var form = $('form')[0];
            var formData = new FormData(form);

            $.ajax({
                type: "POST",
                url: "<%=Page.ResolveUrl("~/Service.aspx")%>",
                data: formData,
                processData: false,
                contentType: false,
                success: function (response) {
                    var output = JSON.parse(response);

                    if (output.result == "success" || output.result == "") {
                        submitCancellation();
                    } else {
                        alert(output.message);
                    }
                    $("#action").val("");
                }
            });
        }

        function submitCancellation() {
            var data = new Object();
            data.id = _id;
            data.comment = $("#cancellation_text").val();
            data.comment_file = $("#cancellation_file").val();
            $.ajax({
                url: "<%=Page.ResolveUrl("Detail.aspx/QuotationCancellation")%>",
                data: JSON.stringify(data),
                dataType: 'json',
                type: 'post',
                contentType: "application/json; charset=utf-8",
                success: function (response) {
                    var output = JSON.parse(response.d);
                    if (output.result != "success") {
                        alert(output.message);
                    } else {
                        alert("Quotation " + $("#q_no").val() + " has been cancelled successfully");
                        blockScreen();
                        if (blankmode == "1") {
                            parent.$.colorbox.close();
                        } else {
                            parent.location.href = "List.aspx";
                        }
                    }
                }
            });
        }

        $(document).on("click", "#btnAuditTrail", function () {
            parent.ShowCustomPopUp("<%= ResolveUrl("~"+based_url+"/AuditTrail.aspx?blankmode=1&module=quotation&id=" + _id) %>");
        });

        function setTotalUsdOrigianl() {
            var totalUsdOriginal = 0;
            $.each(QuoItems, function (i, d) {
                totalUsdOriginal += d.quantity_usd_original;
            });

            var disc = delCommas(accounting.formatNumber(<%= discountTotal %>, 2));

            totalUsdOriginal = (totalUsdOriginal * disc) / 100;
            $("#totalOriginalUSD").text(accounting.formatNumber(totalUsdOriginal, 2));
        }

        function calculateDiscountTotal() {
            var disc = delCommas(accounting.formatNumber(<%= discountTotal %>, 2));
            var discCurr = discountCurrency;
            var idx = listCurrency.findIndex(x => x.CURRENCY_CODE == discCurr);
            var d = listCurrency[idx];
            var discType = Q.discount_type;
            var discountUSD = 0;
            if (d.OPERATOR === "/") {
                discountUSD = delCommas(accounting.formatNumber(disc / d.RATE, 2));
            } else {
                discountUSD = delCommas(accounting.formatNumber(disc * d.RATE, 2));
            }

            $("#discountUSD").text(accounting.formatNumber(discountUSD, 2));

            if (discType == "%") {
                setTotalUsdOrigianl(); 
                $("#discountUSD").css("display", "none");
                $("#totalOriginalUSD").css("display", "block");
            } else {
                $("#discountUSD").css("display", "block");
                $("#totalOriginalUSD").css("display", "none");
            } 

        }

        function calculateGrandTotal() {
            var grandTotal = "";
            $.each(QuoItems, function (i, d) {
                if (d.currency_id != null || d.currency_id != "") {
                    grandTotal +=  d.currency_id + " " + accounting.formatNumber(d.line_total, 2) + "</br>";
                } else {
                    grandTotal += accounting.formatNumber(d.line_total, 2) + "</br>";
                }
            });
            
            $("#GrandTotal").html(grandTotal);
        }


        //Sundry supplier
        $(document).on("click", ".btnSundryEdit", function () {
            
            EditSundry();
        });

        function EditSundry() {
            $("#SundryForm tbody").empty();
            $("#SundryForm-error-message").empty();
            $("#SundryForm-error-box").hide();
            var id = Q.vendor;
            var company_name = RecursiveHtmlDecode(Q.vendor_name);

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

        $(document).on("click", ".btnFileUpload", function () {
            $("#action").val("fileupload");

            btnFileUpload = this;

            $("#file_name").val($(this).closest("tr").find("input:file").val().split('\\').pop());

            filenameupload = $("#file_name").val();

            if (!$("#file_name").val()) {
                alert("Please choose file first");
                return false;
            } else {
                let errorMsg = FileValidation();
                if (FileValidation() !== '') {
                    if ($(this).data("type") == '') {
                        $("#error-message").html("<b>" + "- Supporting document(s):" + "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" + errorMsg + "<b>");
                        $("#error-box").show();
                        $("html, body").animate({ scrollTop: 0 });
                    } else {
                        showErrorMessage(errorMsg);
                    }

                    return false;
                }

                UploadFileAPI("");
                $(this).closest("tr").find("input[name$='attachment.uploaded']").val("1");
                $(this).closest("tr").css({ 'background-color': '' });

            }
        });

        function GenerateFileLink(row, filename) {
            var quo_id = '';
            var linkdoc = '';

            if ($("[name='quo.id']").val() == '' || $("[name='quo.id']").val() == null) {
                quo_id = $("[name='docidtemp']").val();
                linkdoc = "FilesTemp/" + quo_id + "/" + filename + "";
            } else {
                quo_id = $("[name='quo.id']").val();
                linkdoc = "Files/" + quo_id + "/" + filename + "";
            }

            $(row).closest("tr").find("input[name$='filename']").hide();

            $(row).closest("tr").find(".editDocument").show();
            $(row).closest("tr").find("a#linkDocument").attr("href", linkdoc);
            $(row).closest("tr").find("a#linkDocument").text(filename);
            $(row).closest("tr").find(".linkDocument").show();
            $(row).closest("tr").find(".btnFileUpload").hide();
            $(row).closest("tr").find("input[name='attachment.filename.validation']").val(filename);

        }

        $(document).on("click", ".editDocument", function () {
            var filedoctype = $(this).data("type") == "_general" ? "_general" : "";
            var obj = $(this).closest("td").find("input[name='filename']");
            var obj2 = $(this).closest("td").find("input[name='attachment.filename']");
            var att_id = $(this).closest("td").find("input[name='attachment.id']");
            var link = $(this).closest("td").find(".linkDocument");
            //btnFileUpload
            $(this).closest("tr").find("input[name$='attachment.uploaded']").val("0");

            $(this).closest("td").find(".btnFileUpload").show();
            $(obj).show();
            $(obj).val("");
            $(obj2).val("");
            $(att_id).val("");
            $(link).hide();
            $(this).hide();
        });

        function UploadFileAPI(actionType) {
            blockScreenOL();
            var form = $('form')[0];
            var formData = new FormData(form);
            $.ajax({
                type: "POST",
                url: '<%= Page.ResolveUrl("~/" +based_url+ service_url + "") %>',
                data: formData,
                processData: false,
                contentType: false,
                success: function (response) {
                    unBlockScreenOL();
                    var stringJS = '{' + response.substring(
                        response.indexOf("{") + 1,
                        response.lastIndexOf("}")
                    ) + '}';
                    var output = JSON.parse(stringJS);

                    if (actionType != "submit") {
                        if (output.result == '') {
                            if ($(btnFileUpload).data("type") == 'filecancel') {
                                GenerateCancelFileLink(btnFileUpload, filenameupload);
                            } else {
                                GenerateFileLink(btnFileUpload, filenameupload);
                            }
                        } else {
                            alert('Upload file failed');
                        }
                    } else {
                        alert("Quotation " + $("#q_no").val() + " has been " + btnAction + " successfully.");
                        if (btnAction.toLowerCase() == "saved") {
                            parent.location.href = "Input.aspx?id=" + $("[name='quo.id']").val();
                        } else {
                            parent.location.href = "List.aspx";
                        }

                    }
                },
                error: function (jqXHR, exception) {
                    unBlockScreenOL();
                }
            });

            $("#file_name").val("");
        }
    </script>
</asp:Content>

