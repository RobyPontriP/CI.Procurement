<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="uscPRDetail.ascx.cs" Inherits="myTree.WebForms.Modules.PurchaseRequisition.uscPRDetail" %>
<input type="hidden" name="file_name" id="file_name" value="" />
<input type="hidden" id="max_status" value="<%=max_status %>"/>
<input type="hidden" id="status" value="<%=pr.status_id %>"/>
<input type="hidden" name="pr.id" value="<%=pr.id %>"/>
<input type="hidden" name="action" id="action" value=""/>
<input type="hidden" name="doc_id" value="<%=pr.id %>"/>
<input type="hidden" name="doc_type" value="PURCHASEREQUISITION"/>
<input type="hidden" id="_pr_no" value="<%=pr.pr_no %>" />
<input type="hidden" id="is_direct_to_finance" value="<%=pr.is_direct_to_finance %>" />
<input type="hidden" id="total_estimated_usd" value="<%=pr.total_estimated_usd %>" />
<input type="hidden" id="purchase_type" value="<%=pr.purchase_type %>" />
<input type="hidden" id="journal_no" value="<%=pr.journal_no %>" />
<input type="hidden" id="reference_no" value="<%=pr.reference_no %>" />
<input type="hidden" id="purchasing_process" value="<%=pr.purchasing_process %>" />
<input type="hidden" name="pr.submission_page_name" value="<%=pr.submission_page_name %>"/>

<div id="ModalJournalDetail" class="modal hide fade modal-dialog" tabindex="-1" role="dialog" aria-labelledby="header1" aria-hidden="true"
    data-backdrop="static" data-keyboard="false">
    <div class="modal-header">
        <strong>Journal number detail</strong>
    </div>

    <div class="modal-body">
        <div class="control-group last">
            <%--<table id="tblJournalDetail" class="table table-bordered table-striped table-condensed" style="table-layout: fixed; width: 100%">--%>
            <table id="tblJournalDetail" class="table table-bordered table-striped table-condensed" style="width: 100%">
                <thead>
				                <tr>
					                <th style="width: 20px;">#</th>
					                <th style="width: 35px;">TT
					                </th>
					                <th style="width: 70px;">TransNo
					                </th>
					                <th style="width: 15px;">#
					                </th>
					                <th style="width: 100px;">Trans.date
					                </th>
					                <th style="width: 50px;">Period
					                </th>
					                <th style="width: 60px;">Account
					                </th>
					                <th style="width: 50px;">Cat1
					                </th>
					                <th style="width: 50px;">Cat2
					                </th>
					                <th style="width: 30px;">TC
					                </th>
					                <th>Text
					                </th>
					                <th style="width: 60px; /* text-align: right; */">Currency 
					                </th>
					                <th style="width: 90px; text-align: right;">Currency amount
					                </th>
					                <th style="width: 90px; text-align: right;">Amount in USD
					                </th>
				                </tr>
                </thead>
                <tbody>
                </tbody>
            </table>
        </div>
    </div>
    <div class="modal-footer" style="text-align: left; display: block; overflow-y: auto; overflow-x: auto;">
    <button id="btClose_bottom" class="btn" data-dismiss="modal" aria-hidden="true">
        Close</button>
    </div>
</div>

<%  if (!String.IsNullOrEmpty(pr.pr_no))
    { %>
<div class="control-group">
    <label class="control-label">
        PR code
    </label>
    <div class="controls">
        <b><%=pr.pr_no %></b>
    </div>
</div>
<%  } %>
<div class="control-group">
    <label class="control-label">
        PR status
    </label>
    <div class="controls">
        <%=status_name %>
    </div>
</div>
<div class="control-group">
    <label class="control-label">
        Requester
    </label>
    <div class="controls">
        <%=pr.requester_name %>
    </div>
</div>
<div class="control-group">
    <label class="control-label">
        Required date
    </label>
    <div class="controls">
        <%=pr.required_date %>
    </div>
</div>
<div class="control-group">
    <label class="control-label">
        Purchase/finance office
    </label>
    <div class="controls">
        <%=pr.cifor_office_name %>
    </div>
</div>
<%--<div class="control-group">
    <label class="control-label">
        Charge code
    </label>
    <div class="controls">
        <%=pr.cost_center_id_name %>&nbsp;&nbsp;/&nbsp;&nbsp;
        <%=pr.t4_name %>
    </div>
</div>--%>
<div class="control-group">
    <label class="control-label">
        Remarks
    </label>
    <div class="controls multilines"><%=pr.remarks %></div>
</div>
<%--<div class="control-group">
    <label class="control-label">
        Currency
    </label>
    <div class="controls">
        <div class="span1"><%=pr.currency_id %></div>
        <div class="span3"><label>Exchange rate (to USD)&nbsp;</label></div>
        <div class="span3">
            <%=pr.exchange_sign_format %>&nbsp;<%=pr.exchange_rate %>
            <input type="hidden" name="pr.exchange_sign" value="<%=pr.exchange_sign %>">
            <input type="hidden" name="pr.exchange_rate" value="<%=pr.exchange_rate%>">
        </div>
    </div>
</div>--%>
<div class="control-group <%=page_type=="detail"?"last":"" %>">
	<div style="width: 97%; overflow-x: auto; display: block;">
		<table id="tblItems" class="table table-bordered table-hover" data-title="Product(s)" style="border: 1px solid #ddd">
			<thead>
				<tr>
					<%  if (page_type == "detail")
						{ %>
                    <th style="width:2%;"></th>
					<th style="width:10%;">Product code</th>
					<th style="width:32%;">Description</th>
					<th style="width:8%;">Product status</th>
					<th style="width:5%;">Requested quantity</th>
					<th style="width:5%;">Outstanding quantity</th>
					<th style="width:2%;">UoM</th>
                    <th style="width:2%;">Currency</th>
					<th style="width:10%;" id="lbCostEstimated">Cost estimated</th>
					<th style="width:10%;">Cost estimated (USD)</th>
					<th style="width:15%;">Supporting document(s)</th>
					<th style="width:3%;">&nbsp;</th>
					<%  }
						else { %>
                    <th style="width: 2%"></th>
					<th>Product code</th>
					<th style="width:32%;">Description</th>
					<th>Quantity</th>
					<th>UoM</th>
                    <th style="width:2%;">Currency</th>
					<th>Unit price</th>
                    <th style="width:10%;">Cost estimated</th>
					<th style="width:10%;">Cost estimated (USD)</th>
					<th>Supporting document(s)</th>
                 <%--   <th style="width:2%;"></th>
					<th style="width:10%;">Product code</th>
					<th style="width:32%;">Description</th>
					<th style="width:8%;">Product status</th>
					<th style="width:5%;">Requested quantity</th>
					<th style="width:5%;">Outstanding quantity</th>
					<th style="width:2%;">UoM</th>
                    <th style="width:2%;">Currency</th>
					<th style="width:10%;" id="lbCostEstimated">Cost estimated</th>
					<th style="width:10%;">Cost estimated (USD)</th>
					<th style="width:15%;">Supporting document(s)</th>
					<th style="width:3%;">&nbsp;</th>--%>
					<%  } %>
				</tr>
			</thead>
			<tfoot>
				<tr>
					<td colspan="<%=(page_type == "detail")?"8":"7" %>"><b>Grand total</b></td>
					<td id="GrandTotal" style="text-align:right;"></td>
					<td id="GrandTotalUSD" style="text-align:right;"></td>
					<td>&nbsp;</td>
					<%  if (page_type == "detail")
						{ %>
					<td>&nbsp;</td>
					<%  } %>
				</tr>
			</tfoot>
			<tbody>
			</tbody>
		</table>
	</div>
</div>
			<%  if (page_type == "payment")
				{ %>
            <div class="control-group required" id="div_is_other_purchase_type">
                <br>
                <p class="filled info">Purchase type determines the type of product(s) you are purchasing, and it will determine the team that will process your purchase requisition.</p>
                <label class="control-label">
                    Purchase type
                </label>
                <div class="controls">
                    <select id="purchase_type_option" name="pr.purchase_type" data-title="Purchase type" data-validation="required" class="span4 select_purchase toSelect2"></select>
                </div>
            </div>
			<%  }
				else { %>
            <div class="control-group">
                <label class="control-label">
                    Purchase type
                </label>
                <div class="controls">
                    <%= pr.purchase_type_description %>
                </div>
            </div>
			<%  } %>

<% // if (pr.purchase_type == "1" || pr.purchase_type == "4" || pr.purchase_type == "5")
   if(pr.purchase_type != "3" && Convert.ToDecimal(pr.total_estimated_usd) > 200)
    { %>
<div class="control-group" id="divDirectToFinance">
    <label class="control-label">
        <%--Reasons for self purchasing by requester--%>
        Justification
    </label>
    <div class="controls" style="word-break: break-all;">
        <div class="multilines"><%=pr.direct_to_finance_justification %></div>
        <div class="fileinput_direct_to_finance">
        <%  if (!string.IsNullOrEmpty(pr.direct_to_finance_file))
          { %>
            <span class="linkDocumentFinance"><a href="Files/<%=pr.id %>/<%=pr.direct_to_finance_file %>" target="_blank"><%=pr.direct_to_finance_file %></a>&nbsp;</span>
        <%  } %>
        </div>        
    </div>
</div>
<%  } %>
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
	</div>
</div>
<%  if (page_type == "payment" || isJournal)
    {%>
        
<%--<div id="control_ispayment" class="control-group required ">
	<label class="control-label">
		Payment has been done
	</label>
	<div class="controls">
		<input type="checkbox" name="pr.is_payment" id="pr.is_payment" data-title="Payment status"/>
	</div>
</div>--%>
       <%     
           //if (!(pr.purchase_type == "1"))
           if (page_type == "payment" || isJournal)
           {%>
<div id="control_journalno" class="control-group required">
	<label class="control-label">
		Journal/Debit note
	</label>
    <div class="controls">        
        <table id="tblJournalNo" class="table table-bordered table-hover required" style="width: 100%;border: 1px solid #ddd" data-title="Journal number"> 
            <thead>
                <tr>
                    <th style="width:30%;">Number</th>
                    <th style="width:65%;">File</th>
                    <% if (page_type == "payment" || isFinance) {%>
                        <th style="width:5%;">&nbsp;</th>
                    <% }%>
                </tr>
            </thead>
            <tbody>
            </tbody>
        </table>
        <div class="span12 journal-notes" style="margin-left:0px;"></div>
        <% if (page_type == "payment" || isFinance) {%>
                        <p><button id="btnAddJournalNo" class="btn btn-success" type="button" data-toggle="modal" data-doctype="PaymentJournal">Add journal</button>   
                    <% }%>
        
       <%-- <button type="button" id="btnEditjournalno" class="btn btn-success " data-toggle="modal">Edit</button>
        <button type="button" id="btnSavejournalno" class="btn btn-success " data-toggle="modal">Save</button>
        <button type="button" id="btnCanceljournalno" class="btn " data-toggle="modal">Cancel</button>  </p>--%>
    </div>
</div>
<%      }
        else {%>
<div id="control_referenceno" class="control-group required">
	<label class="control-label">
		Reference number
	</label>
	<div class="controls">
        <div class="span3">
		    <input type="text" name="pr.reference_no" data-title="Reference number" data-validation="required" class="span12" value="<%=pr.reference_no %>" placeholder="Reference number" />       
        </div>
        <div class="span1" style="margin-left:0px;"></div>
        <div class="span8" style="margin-left:0px;">
            <button type="button" id="btnEditreferenceno" class="btn btn-success btn-small">Edit</button>
            <button type="button" id="btnSavereferenceno" class="btn btn-success btn-small">Save</button>
            <button type="button" id="btnCancelreferenceno" class="btn btn-small">Cancel</button>  
        </div>
        <div class="span12 reference-notes" style="margin-left:0px;"></div>
    </div>
</div>
    <%  }
    } %>
<% if (page_type == "detail" && pr.purchase_type == "1" && pr.reference_no != "")
    {%>
<div id="control_referenceno_detail" class="control-group">
	<label class="control-label">
		Reference number
	</label>
	<div class="controls">
        <div class="span3">
		    <%=pr.reference_no %>       
        </div>
    </div>
</div>
<%} %>

<%  if (page_type != "detail")
    { %>
<div class="control-group">
    <label class="control-label">
        Comments
    </label>
    <div class="controls">
        <textarea name="comments" data-title="Comments" rows="5" class="span10 textareavertical" placeholder="comments" maxlength="2000"></textarea>
    </div>
</div>
<%  } %>
<script>
    var deletedId = [];

    var PRDetail = <%=PRDetail%>;
    var PRAttachmentGeneral = <%=PRAttachmentGeneral%>;
    var PRJournalNo = <%=PRJournalNo%>;

    var pageType = "<%=page_type%>";
    var isFinance = "<%=isFinance%>";
    var lastActivity = "<%=LastActivity%>"
    var oTableItems;
    var purchase_type = "<%=pr.purchase_type%>";
    var isJournal = "<%=isJournal%>";
    var submission_page_name = "<%=pr.submission_page_name%>";
    var usc_id_submission_page_type = "<%=usc_id_submission_page_type%>";
    var usc_submission_page_name = "<%=usc_submission_page_name%>";
    let filenameupload = "";

    $('#pageTitle').html(submission_page_name + " Detail");

    function showDirectPurchase(x) {
        var html = "";
        var detailrows = "";

        var d = x.directPurchase;
        detailrows += '<tr>' +
            '<td>' + d.status_id + '</td>' +
            '<td>' + d.vendor_name + '</td>' +
            '<td style="text-align:right;">' + accounting.formatNumber(delCommas(d.purchase_qty), 2) + '</td>' +
            '<td>' + d.purchase_currency + '</td>' +
            '<td style="text-align:right;">' + accounting.formatNumber(delCommas(d.unit_price), 2) + '</td>' +
            '<td style="text-align:right;">' + accounting.formatNumber(delCommas(d.total_cost), 2) + '</td>' +
            '<td>' + d.purchase_date + '</td>' +
            '<td>' + d.actions + '</td>' +
            '</tr > ';

        html = '<div class="span1"></div><div class="span11"><table class="table table-bordered" cellpadding="5" cellspacing="0" style="border: 1px solid #ddd">' +
            '<thead>' +
            '<tr>' +
            '<th>Direct purchase status</th>' +
            '<th>Supplier</th>' +
            '<th>Actual quantity</th>' +
            '<th>Currency</th>' +
            '<th>Actual unit price</th>' +
            '<th>Total</th>' +
            '<th>Actual date of purchase</th>' +
            '<th>&nbsp;</th>' +
            '</tr>' +
            '</thead> ' +
            '<tbody>' + detailrows + '</tbody>' +
            '</table></div>';

        return html;
    }

    $(document).ready(function () {
        //if (id_submission_page_type == "") {
        //    id_submission_page_type = usc_id_submission_page_type;
        //}
        $('#btnPrint').html("Print " + submission_page_name);
        if (pageType == "approval") {
            $("#control_journalno").removeClass("required");
        }

        if (isFinance == true) {
            $('#btnSave').show();
        }

        if (pageType == 'detail' && isFinance == false) {
            $(".journal-notes").remove();
        }

        if (pageType === "detail") {
            oTableItems = $('#tblItems').DataTable({
                "bFilter": false, "bDestroy": true, "bRetrieve": true, "paging": false, "bSort": false, "bLengthChange": false, "bInfo": false,
                "aaData": PRDetail,
                "aoColumns": [
                    {
                        "mDataProp": "id"
                        , "mRender": function (d, type, row) {
                            return '<i class="icon-chevron-sign-down dropDetail" title="View detail(s)"></i>'
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
                        "mDataProp": "status_name"
                        , "mRender": function (d, type, row) {
                            var html = row.status_name;
                            if (row.closing_remarks != "") {
                                html += "<br/>Remarks: " + row.closing_remarks;
                            }
                            return html;
                        }
                    },
                    {
                        "mDataProp": "request_qty"
                        , "mRender": function (d, type, row) {
                            return accounting.formatNumber(delCommas(row.request_qty), 2)
                        }
                    },
                    {
                        "mDataProp": "open_qty"
                        , "mRender": function (d, type, row) {
                            return accounting.formatNumber(delCommas(row.open_qty), 2)
                        }
                    },
                    { "mDataProp": "uom_name" },
                    { "mDataProp": "currency_id" },
                    {
                        "mDataProp": "estimated_cost"
                        , "mRender": function (d, type, row) {
                            /*return accounting.formatNumber(delCommas(row.estimated_cost),2)*/
                            return accounting.formatNumber(parseFloat(row.estimated_cost), 2)
                        }
                    },
                    {
                        "mDataProp": "estimated_cost_usd"
                        , "mRender": function (d, type, row) {
                            /*return accounting.formatNumber(delCommas(row.estimated_cost_usd), 2)*/
                            return accounting.formatNumber(parseFloat(row.estimated_cost_usd), 2)
                        }
                    },
                    {
                        "mDataProp": "attachment"
                        , "mRender": function (d, type, row) {
                            var strAttachment = "";
                            $.each(row.attachments, function (idx, d) {
                                if (idx > 0) {
                                    strAttachment += '<br />';
                                }
                                var is_cloned = $(".clone_" + d.uid).length;
                                if (row.id !== "" && row.id !== "0" && is_cloned == 0) {
                                    strAttachment += '<a href="Files/' + row.pr_id + '/' + d.filename + '" target="_blank">' + d.filename + '</a>';
                                } else {
                                    strAttachment += d.filename;
                                }
                            });
                            return strAttachment;
                        }
                    },
                    {
                        "mDataProp": "actions"
                        , "sClass": "no-sort"
                        , "visible": isAdmin
                    },
                    { "mDataProp": "costCenters", "visible": false }
                ],
                columnDefs: [
                    {
                        targets: [4, 5, 8, 9],
                        className: 'dt-body-right'
                    }
                ]
            });

            $("#control_journalno").removeClass("required");
        } else {
            //$.each(PRDetail, function (i, d) {
            //    populateItemTable(d, "add");
            //});
            oTableItems = $('#tblItems').DataTable({
                "bFilter": false, "bDestroy": true, "bRetrieve": true, "paging": false, "bSort": false, "bLengthChange": false, "bInfo": false,
                "aaData": PRDetail,
                "aoColumns": [
                    {
                        "mDataProp": "id"
                        , "mRender": function (d, type, row) {
                            return '<i class="icon-chevron-sign-down dropDetail" title="View detail(s)"></i>'
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
                        "mDataProp": "request_qty"
                        , "mRender": function (d, type, row) {
                            return accounting.formatNumber(delCommas(row.request_qty), 2)
                        }
                    },
                    { "mDataProp": "uom_name" },
                    { "mDataProp": "currency_id" },
                    {
                        "mDataProp": "unit_price"
                        , "mRender": function (d, type, row) {
                            /*return accounting.formatNumber(delCommas(row.estimated_cost),2)*/
                            return accounting.formatNumber(parseFloat(row.unit_price), 2)
                        }
                    },
                    {
                        "mDataProp": "estimated_cost"
                        , "mRender": function (d, type, row) {
                            /*return accounting.formatNumber(delCommas(row.estimated_cost),2)*/
                            return accounting.formatNumber(parseFloat(row.estimated_cost), 2)
                        }
                    },
                    {
                        "mDataProp": "estimated_cost_usd"
                        , "mRender": function (d, type, row) {
                            /*return accounting.formatNumber(delCommas(row.estimated_cost_usd), 2)*/
                            return accounting.formatNumber(parseFloat(row.estimated_cost_usd), 2)
                        }
                    },
                    {
                        "mDataProp": "attachment"
                        , "mRender": function (d, type, row) {
                            var strAttachment = "";
                            $.each(row.attachments, function (idx, d) {
                                if (idx > 0) {
                                    strAttachment += '<br />';
                                }
                                var is_cloned = $(".clone_" + d.uid).length;
                                if (row.id !== "" && row.id !== "0" && is_cloned == 0) {
                                    strAttachment += '<a href="Files/' + row.pr_id + '/' + d.filename + '" target="_blank">' + d.filename + '</a>';
                                } else {
                                    strAttachment += d.filename;
                                }
                            });
                            return strAttachment;
                        }
                    }
                ],
                columnDefs: [
                    {
                        targets: [3, 6, 7, 8],
                        className: 'dt-body-right'
                    }
                ]
            });
        }

        $.each(oTableItems.rows().nodes(), function (i) {
            var row = oTableItems.row(i)
            if (!row.child.isShown()) {
                row.child(format(row.data())).show();
                $(row.node()).addClass('shown');
            }
        });

        //$('#tblItems tbody').on('click', 'td', function () {
        //    if (!$(this).hasClass('no-sort')) {
        //        var tr = $(this).closest('tr');
        //        var row = oTableItems.row(tr);
        //        if (typeof row.data() !== "undefined" && row.data().is_direct_purchase == "1") {
        //            if (row.child.isShown()) {
        //                row.child.hide();
        //                tr.removeClass('shown');
        //            } else {
        //                row.child(showDirectPurchase(row.data())).show();
        //                tr.addClass('shown');
        //            }
        //        }
        //    }
        //});

        $('#tblItems tbody').on('click', 'i[class^="icon-chevron"]', function () {
            /*if (!$(this).hasClass('no-sort') && !$(this).hasClass('dropAllDetail')) {*/
            if (!$(this).hasClass('no-sort')) {
                var tr = $(this).closest('tr');
                var row = oTableItems.row(tr);

                $(this).attr('class', '');
                if (row.child.isShown()) {
                    row.child.hide();
                    tr.removeClass('shown');
                    $(this).attr('class', 'icon-chevron-sign-right dropDetail');
                } else {
                    if (pageType === "detail") {
                        row.child(format(row.data())).show();

                    } else {
                        row.child(formatD(row.data())).show();

                    }

                    tr.addClass('shown');
                    $(this).attr('class', 'icon-chevron-sign-down dropDetail');
                }
            }
        });

        $.each(PRAttachmentGeneral, function (i, d) {
            addAttachment(d.id, "", d.file_description, d.filename);
        });

        if (PRAttachmentGeneral.length == 0) {
            let html = '<tr>';
            html += '<td colspan="14" class="dataTables_empty" style="text-align:center">No data available</td>';
            html += '</tr>';

            $("#tblAttachment tbody").append(html);
            
        }

        $.each(PRJournalNo, function (i, d) {
            addJournalNo(d.id, "", d.journal_no, d.pr_id, d.journal_attachment_id, d.journal_attachment);
        });

        CalculateItems();
        financepage();
        normalizeMultilines();
    });

    function format(d) {
        var html = "";
        if (typeof d !== "undefined") {
            var _d = d;
            var detailrows = "";
            $.each(_d.costCenters, function (i, x) {

                //var status_name = x.status;
                //if (status_name == "CLOSED") {
                //    if (x.id_itemclosure != "" && typeof x.id_itemclosure !== "undefined") {
                //        id_itemclosure = $.parseXML(x.id_itemclosure);
                //        $xml = $(id_itemclosure);

                //        status_name += "&nbsp;<div class=\"dropdown\" style=\"inline-block;\">" +
                //            "<span data-toggle=\"dropdown\" class=\"status label btn-info icndrop\" style=\"inline-block;\"><i class=\"icon-info-sign \" style=\"opacity: 1;\"></i>" +
                //            "<ul class=\"dropdown-menu\" style=\"min-width: 165px; margin-left: 28px; margin-top: -25px;\">";
                //        var xi = 1;
                //        var xlength = $xml.find('item_closure').length;
                //        $xml.find('item_closure').each(function () {
                //            var sheet = $(this);
                //            reason = $(this).find('reason_for_closing').text();
                //            id_item = $(this).find('id').text();
                //            status_name += "<li> <a href=\"#\" style=\"white-space: normal\" id=\"btnDetail\" data-detailid=" + id_item + " data-action=\"detail\">#" + id_item + " " + reason + "</a></li >";
                //            if (xi < xlength) { status_name += "<li class=\"divider\"></li>"; }
                //            xi++;
                //        });
                //        status_name += "</ul></span></div>";
                //    }
                //}
                //if (x.closing_remarks != "" && typeof x.closing_remarks !== "undefined") {
                //    status_name += "<br/>Remarks: " + x.closing_remarks;
                //}
                detailrows += '<tr>' +
                    '<td class="cost_center" style="width: 15%;">' + x.cost_center_id + ' - ' + x.cost_center_name + '</td>' +
                    '<td class="work_order" style="width: 18%;">' + x.work_order + ' - ' + x.work_order_name + '</td>' +
                    '<td class="entity_id" style="width: 17%;">' + x.entity_id + ' - ' + x.entity_name + '</td>' +
                    '<td class="legal_entity" style="width: 2%;">' + x.legal_entity + '</td>' +
                    '<td class="control_account" style="display: none;">' + x.control_account + '</td>' +
                    '<td class="percentage" style="text-align:right; width: 5%;">' + accounting.formatNumber(parseFloat(x.percentage), 2) + '</td>' +
                    '<td class="amount" style="text-align:right; width: 11%;">' + accounting.formatNumber(parseFloat(x.amount), 2) + '</td>' +
                    '<td class="amount_usd" style="text-align:right; width: 11%;">' + accounting.formatNumber(parseFloat(x.amount_usd), 2) + '</td>' +
                    '<td class="remarks" style="text-align:right; width: 11%;">' + x.remarks + '</td>';
                //if (isProcurement) {
                //    detailrows += '<td>' + x.actions + '</td>';
                //}
                detailrows += '</tr > ';
            });

            html = /*'<div class="floatingBox">' +*/
                //'<div class="control-group">' +
                //'<div class="controls" style="margin-top: 5px;">' +
                //'</div>' +
                //'</div>' +
                /*'<label style="padding-top:2px; float:left; width:180px; text-align:right;">Charge code </label>' +*/
                //'<div id="dv_ChargeCode" class="controls">' +
                //'<div id="dv_CostParent">' +
                '<div style="margin-left:21px; margin-right:5px; margin-top:22px; margin-bottom:5px;">' +
                '<table class="table table-bordered">' +
                '<thead>' +
                '<tr>' +
                '<th>Cost center</th>' +
                '<th>Work order</th>' +
                '<th>Entity</th>' +
                '<th style="width:10%;">Legal entity</th>' +
                '<th style="display: none;">Account Control</th>' +
                '<th style=" width: 5%; text-align:left;">%</th>' +
                '<th>Amount (' + d.currency_id + ')</th>' +
                '<th>Amount (USD)</th>' +
                '<th>Remarks</th>';
            //if (isAdmin) {
            //    html += '<th>&nbsp;</th>';
            //}
            html += '</tr>' +
                '</thead> ' +
                '<tbody>' + detailrows + '</tbody>' +
                //'<tfoot><tr><td colspan="8" style="font-weight:bold; text-align:right;">Total</td>' +
                //'<td style="font-weight:bold; text-align:right;">' + d.currency_id + ' ' + d.estimated_cost + '</td>' +
                //'<td></td>' +
                //'<td style="font-weight:bold; text-align:right;">' + d.estimated_cost_usd + '</td>' +
                //'</tr></tfoot> ' +
                '</table>' +
                '</div>';
            /*  '</div>' +*/
            /*'</div>';*/
        }

        if (typeof d !== "undefined" && d.is_direct_purchase == "1") {

            html += showDirectPurchase(d);
        }

        return html;
    }

    function formatD(d) {
        var html = "";
        if (typeof d !== "undefined") {
            var _d = d;
            var detailrows = "";
            $.each(_d.costCenters, function (i, x) {
                detailrows += '<tr>' +
                    '<td class="cost_center" style="width: 15%;">' + x.cost_center_id + ' - ' + x.cost_center_name + '</td>' +
                    '<td class="work_order" style="width: 18%;">' + x.work_order + ' - ' + x.work_order_name + '</td>' +
                    '<td class="entity_id" style="width: 15%;">' + x.entity_name + '</td>' +
                    '<td class="legal_entity" style="width: 2%;">' + x.legal_entity + '</td>' +
                    '<td class="control_account" style="display: none;">' + x.control_account + '</td>' +
                    '<td class="percentage" style="text-align:right; width: 5%;">' + accounting.formatNumber(parseFloat(x.percentage), 2) + '</td>' +
                    '<td class="amount" style="text-align:right; width: 11%;">' + accounting.formatNumber(parseFloat(x.amount), 2) + '</td>' +
                    '<td class="amount_usd" style="text-align:right; width: 11%;">' + accounting.formatNumber(parseFloat(x.amount_usd), 2) + '</td>' +
                    '<td class="remarks">' + x.remarks + '</td>';
                detailrows += '</tr > ';
            });

            html =
                '<div style="margin-left:21px; margin-right:5px; margin-top:22px; margin-bottom:5px;">' +
                '<table class="table table-bordered">' +
                '<thead>' +
                '<tr>' +
                '<th>Cost center</th>' +
                '<th>Work order</th>' +
                '<th>Entity</th>' +
                '<th style="width:10%;">Legal entity</th>' +
                '<th style="display: none;">Account Control</th>' +
                '<th style=" width: 5%; text-align:left;">%</th>' +
                '<th>Amount (' + d.currency_id + ')</th>' +
                '<th>Amount (USD)</th>' +
                '<th>Remarks</th>';
            //if (isAdmin) {
            //    html += '<th>&nbsp;</th>';
            //}
            html += '</tr>' +
                '</thead> ' +
                '<tbody>' + detailrows + '</tbody>' +
                //'<tfoot><tr><td colspan="8" style="font-weight:bold; text-align:right;">Total</td>' +
                //'<td style="font-weight:bold; text-align:right;">' + d.currency_id + ' ' + d.estimated_cost + '</td>' +
                //'<td></td>' +
                //'<td style="font-weight:bold; text-align:right;">' + d.estimated_cost_usd + '</td>' +
                //'</tr></tfoot> ' +
                '</table>' +
                '</div>';
            /*  '</div>' +*/
            /*'</div>';*/
        }
        return html;
    }

    function CalculateItems() {
        //var sign = $("[name='pr.exchange_sign']").val();
        //var rate = $("[name='pr.exchange_rate']").val();
        var estimated_cost = 0;
        var estimated_cost_usd = 0;
        if (PRDetail.length > 0) {
            $.each(PRDetail, function (i, d) {
                var a = PRDetail[i];
                var rate = parseFloat(a.exchange_rate.replace(/,/g, '.'));
                /*if (sign === "/") {*/
                if (a.exchange_sign_format === "/") {
                    a.unit_price_usd = delCommas(accounting.formatNumber(a.unit_price / rate, 2));
                    /*a.estimated_cost_usd = delCommas(accounting.formatNumber(a.estimated_cost / rate, 2));*/
                    a.estimated_cost_usd = delCommas(accounting.formatNumber(parseFloat(a.estimated_cost) / rate, 2));
                } else {
                    a.unit_price_usd = delCommas(accounting.formatNumber(a.unit_price * rate, 2));
                    /*a.estimated_cost_usd = delCommas(accounting.formatNumber(a.estimated_cost * rate, 2));*/
                    a.estimated_cost_usd = delCommas(accounting.formatNumber(parseFloat(a.estimated_cost) * rate, 2));
                }
                estimated_cost += parseFloat(a.estimated_cost);
                estimated_cost_usd += parseFloat(a.estimated_cost_usd);
                //populateItemTable(PRDetail[i], "edit");
            });
        }

        var groups = {};
        PRDetail.forEach(obj => {
            if (!groups.hasOwnProperty(obj.currency_id)) {
                groups[obj.currency_id] = [];
            }
            groups[obj.currency_id].push(obj);
        })

        var strestimated_costCurr = '';
        $.each(groups, function (i, d) {
            var estimated_costCurr = 0;
            var currTemp = '';

            for (var ii = 0; ii < d.length; ii++) {
                estimated_costCurr += parseFloat(d[ii].estimated_cost);
                currTemp = d[ii].currency_id;
            }

            strestimated_costCurr += '<b>(' + currTemp + ') ' + accounting.formatNumber(estimated_costCurr, 2) + '</b> </br>';
        });

        /*$("#GrandTotal").html('<b>' + accounting.formatNumber(estimated_cost, 2) + '</b>');*/
        $("#GrandTotal").html(strestimated_costCurr);
        $("#GrandTotalUSD").html('<b>' + accounting.formatNumber(estimated_cost_usd, 2) + '</b>');

        if (estimated_cost_usd > 200) {
            if (pageType == "payment") {
                $("#btnReject").hide();
            }
        }
    }

    function populateItemTable(item, mode) {
        if (item.uid === "" || typeof item.uid === "undefined" || item.uid === null) {
            item.uid = guid();
        }

        var strAttachment = "";
        $.each(item.attachments, function (idx, d) {
            if (idx > 0) {
                strAttachment += '<br />';
            }
            var is_cloned = $(".clone_" + d.uid).length;
            if (item.id !== "" && item.id !== "0" && is_cloned == 0) {
                strAttachment += '<a href="Files/' + item.pr_id + '/' + d.filename + '" target="_blank">' + d.filename + '</a>';
            } else {
                strAttachment += d.filename;
            }
        });

        var strChargeCode = "";
        var idx = PRDetail.findIndex(x => x.uid == item.uid);
        var a = PRDetail[idx];
        $.each(a.costCenters, function (i, d) {
            strChargeCode += '<tr>';
            strChargeCode += '<td style=" width: 10%;" class="pCostCenters">' + d.cost_center_name + '</td>';
            strChargeCode += '<td style="width: 20%;" class="pCostCentersWorkOrder">' + d.work_order_name + '</td>';
            strChargeCode += '<td style="width: 10%;" class="pCostCentersEntity">' + d.entity_name + '</td>';
            strChargeCode += '<td style="width: 5%;">' + d.legal_entity + '</td>';
            strChargeCode += '<td style="display: none; width: 5%;">' + item.uid + '</td>';
            strChargeCode += '<td style=" width: 5%; text-align:right;" class="pCostCentersValue">' + accounting.formatNumber(parseFloat(d.percentage), 2) + '</td>';
            strChargeCode += '<td style="width: 11%; text-align:right;" class="pCostCentersAmt">' + accounting.formatNumber(parseFloat(d.amount), 2) + '</td>';
            strChargeCode += '<td style="width: 11%; text-align:right;" class="pCostCentersUSDAmt">' + accounting.formatNumber(parseFloat(d.amount_usd), 2) + '</td>';
            strChargeCode += '<td style="width: 20%;">' + d.remarks + '</td>';
            strChargeCode += '</tr>';
        });

        var html = "";
        html += '<tr id="' + item.uid + '">';
        html += '<td> <i class="icon-chevron-sign-down dropDetail accordion-toggle collapsed" data-target="#dv' + item.uid + '" data-toggle="collapse" title="View detail(s)"></i></td > <td>' + item.item_code + '</td>';
        html += '<td>' + item.item_description + '</td>';
        html += '<td style="text-align:right;">' + accounting.formatNumber(item.request_qty, 2) + '</td>';
        html += '<td>' + item.uom_name + '</td>';
        html += '<td>' + item.currency_id + '</td>';
        html += '<td style="text-align:right;">' + accounting.formatNumber(parseFloat(item.unit_price), 2) + '</td>';
        html += '<td style="text-align:right;">' + accounting.formatNumber(parseFloat(item.estimated_cost), 2) + '</td>';
        html += '<td style="text-align:right;">' + accounting.formatNumber(parseFloat(item.estimated_cost_usd), 2) + '</td>';
        html += '<td>' + strAttachment + '</td>';
        html += '</tr >';

        var htmlDetail = '';
        htmlDetail += '<tr id="trr' + item.uid + '">';
        htmlDetail += '<td class="hiddenRow" colspan="11" style="padding:0px;">';
        htmlDetail += '<div id="dv' + item.uid + '" class="accordian-body in collapse" style="height: auto;">';
        htmlDetail += '<div id="dv' + item.uid + '_ChargeCode" style="margin-left:28px; margin-right:5px; margin-top:25px; margin-bottom:10px;">';
        htmlDetail += '<div id="dv' + item.uid + '_CostParent">';
        htmlDetail += '<table id="tbl' + item.uid + '_CostParent" class="table table-bordered table-striped tblCostCenterParent">';
        htmlDetail += '<thead>';
        htmlDetail += '<tr>';
        htmlDetail += '<th style=" width: 15%; text-align:left;">Cost center</th>';
        htmlDetail += '<th style=" width: 18%; text-align:left;">Work order</th>';
        htmlDetail += '<th style=" width: 10%; text-align:left;">Entity</th>';
        htmlDetail += '<th style=" width: 10%; text-align:left;">Legal entity</th>';
        htmlDetail += '<th style="display: none;">Account Control</th>';
        htmlDetail += '<th style=" width: 5%; text-align:left;">%</th>';
        htmlDetail += '<th style=" width: 11%; text-align:left;">' + item.currency_id + '</th>';
        htmlDetail += '<th style=" width: 11%; text-align:left;">USD</th>';
        htmlDetail += '<th style=" text-align:left; width: 30%;">Remarks</th>';
        htmlDetail += '</tr>';
        htmlDetail += '</thead>';
        htmlDetail += '<tbody>';
        htmlDetail += strChargeCode;
        htmlDetail += '</tbody>';
        htmlDetail += '</table>';
        htmlDetail += '</div>';
        htmlDetail += '</div>';
        htmlDetail += '</div>';
        htmlDetail += '</div>';
        htmlDetail += '</td>';
        htmlDetail += '</tr>';

        if (mode === "add") {
            $("#tblItems tbody").append(html + htmlDetail);
        } else if (mode === "edit") {
            $("#" + item.uid).replaceWith(html);
        }

        //$('#tbl' + item.uid + '_CostParent >tbody').append(strChargeCode);

        normalizeMultilines();
    }

    $(document).on("click", "#btnAddJournalNo", function () {
        //if ($("#status").val() == "50") {
        //    $("#btnEditjournalno").click();
        //}
        var pr_id = $("[name='pr.id']").val();
        addJournalNo("", "", "", pr_id, "", "");
    });

    function addAttachment(id, uid, description, filename) {
        var file_link = "";
        description = NormalizeString(description);
        var pr_id = $("[name='pr.id']").val();
        if (uid === "" || typeof uid === "undefined" || uid === null) {
            var uid = guid();
        }

        if (description == "") {
            description = "-";
        }

        if (filename == "") {
            file_link = '-';
        } else {
            file_link = '<a href="Files/' + pr_id + '/' + filename + '" target="_blank">' + filename + '</a>';
        }

        var html = '<tr>';
        html += '<td>' + description + '</td>';
        html += '<td>' + file_link + '</td >';
        html += '</tr>';

        $("#tblAttachment tbody").append(html);
    }

    function financepage() {
        if ($("#status").val() == "50") {
            if (purchase_type == "1") {
                $("[name='pr.reference_no']").prop("disabled", true);
                $("[name='pr.is_payment']").prop("disabled", true).prop("checked", true);
                $("#control_referenceno").removeClass("required");
                $("#control_ispayment").removeClass("required");
            } else {
                $("[name='journalno.journal_no']").prop("disabled", true);
                $("[name='pr.is_payment']").prop("disabled", true).prop("checked", true);
                $("[name='comments']").prop("disabled", true);
                $("#control_ispayment").removeClass("required");
                $("#control_journalno").removeClass("required");
            }
        }

        if ($("#status").val() == "22" || isFinance == true) {
            $("[name='journalno.journal_no']").prop("disabled", false);
        }
    }

    function addJournalNo(id, uid, journalno, prid, attId, filename) {
        let html = '';

        if (pageType == 'payment' || isFinance == true) {
            var btnremove = "";
            var inputjournal = ''
            if (uid === "" || typeof uid === "undefined" || uid === null) {
                var uid = guid();
            }

            if (id == "") {
                /*inputjournal = '<input type="text" name="journalno.journal_no" data-title="Journal number" data-validation="required" class="span12" placeholder="Journal number" maxlength="9" onkeypress="return isNumberKey(event)" />';*/
                inputjournal = '<input type="text" name="journalno.journal_no" style="margin-right:10px;" data-title="Journal number" class="span9" placeholder="Journal number" maxlength="9" onkeypress="return isNumberKey(event)" />';
                /*btnremove = '<button type="button" id="btnRemovejournalno" class="btn btn-danger btn-small btnRemovejournalno">Remove</button>';*/
                btnremove = '<span class="label red btnDelete" title="Delete"><i class="icon-trash delete" style="opacity: 1;"></i></span>';
            } else {
                /*inputjournal = '<input type="text" name="journalno.journal_no" data-title="Journal number" data-validation="required" class="span12" value="'+ journalno +'" placeholder="Journal number" maxlength="9" onkeypress="return isNumberKey(event)" disabled/>'*/
                inputjournal = '<input type="text" name="journalno.journal_no" style="margin-right:10px;" data-title="Journal number" class="span9" value="' + journalno + '" placeholder="Journal number" maxlength="9" onkeypress="return isNumberKey(event)"/>'
                /*btnremove = '&nbsp;&nbsp;<button type="button" id="btnRemovejournalno" class="btn btn-danger btn-small btnRemovejournalno">Remove</button>';*/
                btnremove = '&nbsp;&nbsp;<span class="label red btnDelete" title="Delete"><i class="icon-trash delete" style="opacity: 1;"></i></span>';
            }

            html = '<tr id =' + uid + '>';
            html += '<td><input type="hidden" name="journalno.uid" value=' + uid + '>';
            html += '<input type="hidden" name="journalno.pr_id" value=' + prid + '>';
            html += '' + inputjournal + '<button type="button" class="btn btn-primary checkJournalNumber">Check</button></td > ';
            html += '</td > ';
            html += '<td><input type="hidden" name="attachment.filename" data-title="Journal file" value="' + filename + '"/><div class="fileinput_' + uid + '">';
            /*html += '<input type="hidden" name="attachment.filename.validation" data-title="Journal file" data-validation="required" value="' + filename + '" />';*/
            /*html += '<input type="hidden" name="attachment.filename.validation" data-title="Journal file" value="' + filename + '" />';*/
            if (id !== "" && filename !== "") {
                html += '<span class="linkDocument"><a href="Files/' + prid + '/' + filename + '" target="_blank" id="linkDocument">' + filename + '</a>&nbsp;</span>';
                html += '<button type="button" class="btn btn-primary editDocument">Edit</button><input type="file" class="span10" name="filename" style="display: none;"/>';
                html += '<button type="button" class="btn btn-success btnFileUpload" style="display:none;">Upload</button>';
            } else {
                html += '<span class="linkDocument"><a href="" target="_blank" id="linkDocument">' + filename + '</a>&nbsp;</span>';
                html += '<button type="button" class="btn btn-primary editDocument" style="display: none;">Edit</button><input type="file" class="span10" name="filename"/>';
                html += '<button type="button" class="btn btn-success btnFileUpload">Upload</button>';
            }
            html += '</div></td > ';
            html += '<td>'
            html += '<input type="hidden" name="journalno.id" value=' + id + '>';
            html += '' + btnremove + '';
            if (filename !== "") {
                html += '<td style="display:none;"><input type="hidden" name="attachment.uploaded" value="1"/></td>';
            } else {
                html += '<td style="display:none;"><input type="hidden" name="attachment.uploaded" value="0"/></td>';
            }
            html += '<td style="display:none;"><input type="hidden" name="attachment.id" value="' + attId + '"/></td>';
            html += '</tr>';
        } else {
            let file_link = "";
            journalno = NormalizeString(journalno);
            let pr_id = $("[name='pr.id']").val();
            if (uid === "" || typeof uid === "undefined" || uid === null) {
                var uid = guid();
            }

            if (journalno == "") {
                journalno = "-";
            }

            if (filename == "") {
                file_link = '-';
            } else {
                file_link = '<a href="Files/' + pr_id + '/' + filename + '" target="_blank">' + filename + '</a>';
            }

            html = '<tr>';
            html += '<td>' + journalno + '</td>';
            html += '<td>' + file_link + '</td >';
            html += '</tr>';
        }

        $("#tblJournalNo tbody").append(html);

    }

    /*$(document).on("click", ".btnRemovejournalno", function () {*/
    $(document).on("click", ".btnDelete", function () {
        //if ($("#status").val() == "50") {
        //    $("#btnEditjournalno").click();
        //}
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

        if (mname == "journalno") {
            var uid = $(this).closest("tr").find("input[name$='.uid']").val();
            $(".clone_" + uid).remove();
        }

        $(this).closest("tr").remove();
    });

    $(document).on("click", ".checkJournalNumber", function () {
        let journalNo = $(this).closest("tr").find("input[name$='journalno.journal_no']").val();
        let errMsg = validationJournalCheck(journalNo);

        if (errMsg == "") {
            $('#ModalJournalDetail').modal('show');
            GetJournalDetail(journalNo, "modal", "");
        }
    });

    function GetJournalDetail(journalno, type, errorMsg) {
        var journal_number = journalno;
        if (journal_number != "") {
            var journalCount;
            $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                url: '<%= Page.ResolveUrl("~/" + based_url+service_url + "/GetJournalDetail") %>',
                async: false,
                data: '{"journal_number":"' + journal_number + '"}',
                dataType: "json",
                success: function (Response) {
                    var DataSet = JSON.parse(Response.d);
                    var JournalDetail = DataSet;
                    journalCount = DataSet.length;

                    if (type == "modal") {
                        $('#tblJournalDetail >tbody').find('tr').each(function () {
                            $(this).remove();
                        });
                        if (journalCount > 0) {
                            for (i = 0; i < journalCount; i++) {
                                var rowjournal = "<tr>";
                                rowjournal += '<td>' + (i + 1) + '</td>'
                                rowjournal += '<td>' + JournalDetail[i]["TT"] + '</td>'
                                rowjournal += '<td>' + JournalDetail[i]["TransNo"] + '</td>'
                                rowjournal += '<td>' + JournalDetail[i]["SeqNo"] + '</td>'
                                rowjournal += '<td>' + JournalDetail[i]["TransDate"] + '</td>'
                                rowjournal += '<td>' + JournalDetail[i]["Period"] + '</td>'
                                rowjournal += '<td>' + JournalDetail[i]["Account"] + '</td>'
                                rowjournal += '<td>' + JournalDetail[i]["Cat1"] + '</td>'
                                rowjournal += '<td>' + JournalDetail[i]["Cat2"] + '</td>'
                                rowjournal += '<td>' + JournalDetail[i]["TC"] + '</td>'
                                rowjournal += '<td>' + JournalDetail[i]["Text"] + '</td>'
                                rowjournal += '<td>' + JournalDetail[i]["Currency"] + '</td>'
                                rowjournal += '<td style="text-align:right">' + accounting.formatNumber(JournalDetail[i]["CurrencyAmount"], 2) + '</td>'
                                rowjournal += '<td style="text-align:right">' + accounting.formatNumber(JournalDetail[i]["Amount"], 2) + '</td>'
                                rowjournal += "</tr>";
                                $('#tblJournalDetail tbody').append(rowjournal);
                            }
                        }
                        else {
                            var rowjournal = "<tr>";
                            rowjournal += '<td colspan="14" class="dataTables_empty" style="text-align:center">No data available in table</td>'
                            rowjournal += "</tr>";
                            $('#tblJournalDetail tbody').append(rowjournal);
                        }
                    }
                    else {
                        errorMsg += validationSaveJournal(journalCount, journalno);
                        return errorMsg;
                    }
                },
                error: function (event) {

                }
            });
            return errorMsg;
        }
    }

    function validationJournalCheck(journalNo) {
        let msg = "";
        if ((journalNo.trim() == "" || journalNo == null)) {
            alert("Journal number is required");
            msg = "err";
        }
        return msg;
    }

    function validationSaveJournal(data, journalno) {
        let errorMsgJournal = "";
        if (data == 0) {
            errorMsgJournal += "<br> - Journal number " + journalno + " does not exist";
        }
        return errorMsgJournal;
    }

    $(document).on("click", "#btnSave", function () {
        var data1 = new Object();
        var errorMsg = "";
        let errFile = 0;
        let errDesc = 0;
        var errUpload = 0;
        var msgFile = "";

        var workflow = new Object();
        workflow.action = "MODIFIED PAYMENT INFORMATION";
        workflow.comment = $("[name='comments']").val();
        workflow.roles = $("#roles").val();

        data1.journalno = [];
        $("#tblJournalNo tbody tr").each(function () {
            var _att = new Object();
            _att["id"] = $(this).find("input[name='journalno.id']").val();
            _att["pr_id"] = $(this).find("input[name='journalno.pr_id']").val();
            _att["journal_no"] = $(this).find("input[name='journalno.journal_no']").val();

            if ($(this).find("input[name='attachment.uploaded']").val() == '1') {
                _att["journal_attachment"] = $(this).find("input[name='attachment.filename']").val();
            } else {
                _att["journal_attachment"] = '';
            }

            _att["journal_attachment_id"] = $(this).find("input[name='attachment.id']").val();
            _att["journal_attachment_description"] = "";
            data1.journalno.push(_att);
        });

        errorMsg += GeneralValidation();

        let datapr = new Object();
        datapr.id = $("[name='doc_id']").val();
        datapr.purchase_type = $("[name='pr.purchase_type']").val();

        if (errorMsg !== "") {
            showErrorMessage(errorMsg);
        }
        else {
            var data = {
                "id": _id,
                "submission": JSON.stringify(data1.journalno),
                "deletedIds": JSON.stringify(deletedId),
                "workflows": JSON.stringify(workflow),
                "purchaseRequisition": JSON.stringify(datapr)
            };
            $.ajax({
                url: '<%= Page.ResolveUrl("~/"+based_url+ service_url + "/savePaymentNo") %>',
            data: JSON.stringify(data),
            dataType: 'json',
            type: 'post',
            contentType: "application/json; charset=utf-8",
            success: function (response) {
                const output = JSON.parse(response.d);
                if (output.result != "success") {
                    alert(output.message);
                } else {
                    location.reload();
                    //alert("Journal number has been updated.");
                    alert("Request has been saved successfully.");
                    $("#btnSavejournalno").hide();
                    $("[name='journalno.journal_no']").prop("disabled", true);
                    $("#btnCanceljournalno").hide();
                    $("#btnEditjournalno").show();
                    $("#control_journalno").removeClass("required");
                }
            }
        });
        }
    });

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
                    $("#error-message").html("<b>" + "- Journal document(s):" + "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" + errorMsg + "<b>");
                    $("#error-box").show();
                    $('.modal-body').animate({ scrollTop: 0 }, 500);
                } else {
                    showErrorMessage(errorMsg);
                }

                return false;
            }

            UploadFileJournalAPI("");
            $(this).closest("tr").find("input[name$='attachment.uploaded']").val("1");
            $(this).closest("tr").css({ 'background-color': '' });
        }
    });

    function UploadFileJournalAPI(actionType) {
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
                    GenerateFileLink(btnFileUpload, filenameupload);
                } else {
                    alert('Upload file failed');
                }
            }
        },
        error: function (jqXHR, exception) {
            alert('Upload file failed');
            unBlockScreenOL();
        }
    });

        $("#file_name").val("");
    }

    function GenerateFileLink(row, filename) {
        let pr_id = '';
        var linkdoc = '';

        if ($("[name='pr.id']").val() == '' || $("[name='pr.id']").val() == null) {
            pr_id = $("[name='docidtemp']").val();
            linkdoc = "FilesTemp/" + quo_id + "/" + filename + "";
        } else {
            quo_id = $("[name='pr.id']").val();
            linkdoc = "Files/" + quo_id + "/" + filename + "";
        }

        $(row).closest("tr").find("input[name$='filename']").hide();

        $(row).closest("tr").find(".editDocument").show();
        $(row).closest("tr").find("a#linkDocument").attr("href", linkdoc);
        $(row).closest("tr").find("a#linkDocument").text(filename);
        $(row).closest("tr").find(".linkDocument").show();
        $(row).closest("tr").find(".btnFileUpload").hide();
        $(row).closest("tr").find("input[name='attachment.filename']").val(filename);

    }

    $(document).on("click", ".editDocument", function () {
        $(this).closest("tr").find("input[name='attachment.filename']").val("");
        var obj = $(this).closest("td").find("input[name='filename']");
        var link = $(this).closest("td").find(".linkDocument");

        $(this).closest("tr").find("input[name$='attachment.uploaded']").val("0");
        $(this).closest("td").find(".btnFileUpload").show();

        $(obj).show();
        $(link).hide();
        $(this).hide();
    });
</script>