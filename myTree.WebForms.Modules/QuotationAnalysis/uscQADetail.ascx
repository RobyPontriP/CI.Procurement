<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="uscQADetail.ascx.cs" Inherits="myTree.WebForms.Modules.QuotationAnalysis.uscQADetail" %>

<%@ Register Src="~/Usc/uscRecentComment.ascx" TagName="recentcomment" TagPrefix="uscComment" %>
<%@ Register Src="~/Usc/uscCancellationForm.ascx" TagName="cancellationform" TagPrefix="uscCancellation" %>

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

    #CancelForm.modal-dialog {
        margin: auto 12%;
        width: 60%;
        height: 320px !important;
    }
</style>

<input type="hidden" id="status" value="<%=VS.status_id %>" />

<!-- for upload file -->
<input type="hidden" name="action" id="action" value="" />
<input type="hidden" id="vs_id" name="doc_id" value="<%=VS.id %>" />
<input type="hidden" name="doc_type" value="QUOTATION ANALYSIS" />
<!-- end of upload file -->

<!-- Cancellation Form -->
<uscCancellation:cancellationform ID="cancellationForm" runat="server" />

<!-- Recent comment -->
<uscComment:recentcomment ID="recentComment" runat="server" />
<input type="hidden" id="vs_no" value="<%=VS.vs_no%>" />
<input type="hidden" id="currency_id" value="<%=VS.currency_id %>" />
<input type="hidden" id="exchange_sign" value="<%=VS.exchange_sign %>" />
<input type="hidden" id="exchange_rate" value="<%=VS.exchange_rate %>" />
<input type="hidden" name="file_name" id="file_name" value="" />
<input type="hidden" name="docidtemp" value="" />
<input type="hidden" id="page_type" value="" />
<input type="hidden" id="page_name" value="<%=page_name %>" />

<div id="JustificationForm" class="modal hide fade modal-dialog" tabindex="-1" role="dialog" aria-labelledby="headerJustificationForm" aria-hidden="true"
    data-backdrop="static" data-keyboard="false">
    <div class="modal-header">
        <%--<button type="button" class="close" data-dismiss="modal" aria-hidden="true"></button>--%>
        <h3 id="headerJustificationForm">Quotation analysis single sourcing</h3>
    </div>
    <div class="modal-body">
        <div class="floatingBox" id="justificationpform-error-box" style="display: none">
            <div class="alert alert-error" id="justificationpform-error-message">
            </div>
        </div>

        <div class="row-fluid">
            <div class="container-fluid">
                <div class="control-group required">
                    <label class="control-label">
                        Single sourcing for
                    </label>
                    <div class="controls">
                        <div>
                            <div id="cboSingleSourcing">
                                <select name="vs.singlesourcing" id="vs.singlesourcing" data-validation="required" data-title="Single sourcing"></select>
                            </div>
                        </div>
                    </div>
                </div>

                <%--<div class="control-group required" id="divJustificationTxt" hidden>
                    <label class="control-label">
                        Single source justification
                    </label>
                    <div class="controls">
                        <div>
                            <div id="txtJustification">
                                <textarea name="vs.justification_singlesourcingp" id="justification_singlesourcingp" data-group="justificationSinglesourcingp" data-title="Reason for justification" rows="5" class="span10 textareavertical" maxlength="2000"></textarea>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="control-group fileinput_justificationp" hidden>
                    <label class="control-label">
                        
                    </label>
                    <div class="controls">
                        <span class="linkDocumentJustificationp" style="display: none;"><a href="Files/<%=VS.id %>/<%=VS.justification_file_singlesourcing %>" id="linkDocumentJustificationpHref" target="_blank"><%=VS.justification_file_singlesourcing %></a>&nbsp;</span>
                        <button type="button" class="btn btn-primary editJustificationpFile" hidden>Edit</button>
                        <input type="file" id="_justificationp_file" name="justificationp_file" />
                        <input type="hidden" name="justificationp.uploaded" value="0" />
                        <button type="button" class="btn btn-success btnFileUploadJustificationp" data-type="file_justificationp">Upload</button>
                        <div class="doc-notes-justificationp"></div>
                        <input style="display: none;" name="vs.justificationp_file_singlesourcing" id="justificationp_file_singlesourcing" data-group="justificationpSinglesourcing" data-validation-primary="no" data-title="Reasons for justification" value="<%=VS.justification_file_singlesourcing%>" autocomplete="off" />
                    </div>
                    
                </div>--%>

            </div>

        </div>
    </div>
    <div class="modal-footer">
        <button type="button" class="btn btn-success" aria-hidden="true" id="btnSaveSingleSourcing" data-action="submitted">Submit</button>
        <button type="button" class="btn" aria-hidden="true" data-dismiss="modal" data-action="saved">Cancel</button>
    </div>
</div>


<div class="row-fluid">
    <div class="floatingBox" style="margin-bottom: 0px;">
        <div class="container-fluid">
            <div class="controls text-right">
                <% if (isInWorkflow)
                   { %>
                        <button id="btnViewWorkflow" class="btn btn-success" type="button">View workflow</button>
                        <a hidden id="btnViewWorkflowA" href="<%= HttpContext.Current.Request.Url.GetLeftPart(UriPartial.Authority) + "/Workspace/ViewWorkflow?Id=" + _id + "&Module=SingleSourcing&blankmode=1" %>"></a>
                <% } %>
                
                <% if (isAdmin || isUser)
                   { %>
                        <button id="btnAuditTrail" class="btn btn-success" type="button">Audit trail</button>
                <% } %>
            </div>
        </div>
    </div>
</div>

<div class="row-fluid">
    <div class="floatingBox">
        <div class="container-fluid">
            <%  if (!String.IsNullOrEmpty(VS.vs_no))
                {  %>
            <div class="control-group">
                <label class="control-label">Quotation Analysis code</label>
                <div class="controls">
                    <b><%=VS.vs_no %></b>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">Quotation Analysis status</label>
                <div class="controls">
                    <b><%=VS.status_name %></b>
                </div>
            </div>
            <%  } %>
            <div class="control-group">
                <label class="control-label">Quotation Analysis date</label>
                <div class="controls">
                    <%=VS.document_date %>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">Target currency</label>
                <div class="controls">
                    <%=VS.currency_id %>  &nbsp;&nbsp;Exchange rate (to USD) <%= VS.exchange_rate %>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">Item(s)</label>
            </div>
            <div class="control-group">
                <div style="width: 97%; overflow-x: auto; display: block;">
                    <table id="tblVSItem" data-title="Product(s)" class="table table-bordered table-hovered" style="border: 1px solid #ddd;">
                        <thead></thead>
                        <tbody></tbody>
                        <tfoot></tfoot>
                    </table>
                    <br />
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
                                <th style="width: 50%;">Description</th>
                                <th style="width: 40%;">File</th>
                                <th style="width: 10%;" class="btnDelete">&nbsp;</th>
                            </tr>
                        </thead>
                        <tbody>
                        </tbody>
                    </table>
                    <div class="doc-notes"></div>
                    <p><button id="btnAddAttachment" class="btn btn-success" type="button" hidden>Add supporting document</button>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                        <button id="btnUpdateAttachment" class="btn btn-success" type="button" hidden>Update</button>
                      </p>
                </div>
            </div>

            <%  if (VS.singlesourcing == "2" || _single_sourcing == "2" || VS.singlesourcing == "1" || _single_sourcing == "1")
                //<%  if (!string.IsNullOrEmpty(VS.singlesourcing))
                { %>
                <div class="control-group required" id="divJustificationGuideline">
                    <label class="control-label">
                        Single source checklist
                    </label>
                    <div class="controls">
                        <label id="lblSSChecklist" hidden>
                            Single-source selection lacks the benefit of competition in regard to quality and cost, is not transparent in selection, and may encourage unacceptable practices. Therefore, single-source selection should only be used in exceptional circumstances. The justification for single-source selection must be examined carefully to ensure economy and efficiency. The conditions for the use of direct procurement should be noted before using this selection approach
                        </label>
                        <table id="tblSingleSourceChecklist" data-title="Single source checklist" class="table table-bordered table-hover" style="border: 1px solid #ddd">
                            <thead>
                                <tr>
                                    <th style="width: 10%;">No</th>
                                    <th style="width: 40%;">CIFOR-ICRAF PROCUREMENT GUIDELINES</th>
                                    <th style="width: 2%;"><input type="checkbox" name="checkAll" data-pr="' + d.id + '"/></th>
                                </tr>
                            </thead>
                            <tbody>
                            </tbody>
                        </table>
                    </div>
                </div>
                <div class="control-group required" id="divJustification">
                    <br>
                    <%--<div id="supporting_doc_notes2"></div>--%>
                    <label class="control-label">
                        <%--Reasons for self purchasing by requester--%>
                        Single source justification
                    </label>
                    <div class="controls">
                        <%--<div id="cash_advance_notes"></div>--%>
                        <textarea name="vs.justification_singlesourcing" id="justification_singlesourcing" data-group="justificationSinglesourcing" data-validation-primary="yes" data-title="Reasons for justification" rows="5" class="span12 textareavertical" maxlength="2000"><%=VS.justification_singlesourcing %></textarea>
                        <br />
                        <div class="fileinput_justification" style="margin-top: 5px;">

                            <%  if (!string.IsNullOrEmpty(VS.justification_file_singlesourcing))
                                { %>
                            <span class="linkDocumentJustification"><a href="Files/<%=VS.id %>/<%=VS.justification_file_singlesourcing %>" id="linkDocumentJustificationHref" target="_blank"><%=VS.justification_file_singlesourcing %></a>&nbsp;</span>
                            <%  if (page_name == "inputjustification")
                                { %>
                            <button type="button" class="btn btn-primary editJustificationFile">Edit</button>
                            <%  } %>
                            <input type="file" id="_justification_file" name="justification_file" value="<%=VS.justification_file_singlesourcing %>" style="display: none;" />
                            <input type="hidden" name="justification.uploaded" value="1" />
                            <button type="button" class="btn btn-success btnFileUploadJustification" data-type="file_justification" style="display: none;">Upload</button>
                            <%  }
                                else
                                { %>
                            <%  if (page_name == "inputjustification")
                                { %>
                            <span class="linkDocumentJustification" style="display: none;"><a href="Files/<%=VS.id %>/<%=VS.justification_file_singlesourcing %>" id="linkDocumentJustificationHref" target="_blank"><%=VS.justification_file_singlesourcing %></a>&nbsp;</span>
                            <button type="button" class="btn btn-primary editJustificationFile" hidden>Edit</button>
                            <input type="file" id="_justification_file" name="justification_file" />
                            <input type="hidden" name="justification.uploaded" value="0" />
                            <button type="button" class="btn btn-success btnFileUploadJustification" data-type="file_justification">Upload</button>
                            <%  } %>
                            <%  } %>
                            <%  if (page_name == "inputjustification")
                                { %>
                            <div class="doc-notes-justification"></div>
                            <%  } %>
                            <input style="display: none;" name="vs.justification_file_singlesourcing" id="justification_file_singlesourcing" data-group="justificationSinglesourcing" data-validation-primary="no" data-title="Reasons for justification" value="<%=VS.justification_file_singlesourcing%>" autocomplete="off" />
                        </div>
                    </div>
                </div>
            <%  } %>

            <div class="control-group divComment" hidden>
                <label class="control-label">
                    Comments
                </label>
                <div class="controls">
                    <textarea name="comments" data-title="Comments" rows="5" class="span10 textareavertical" placeholder="comments" maxlength="2000"></textarea>
                </div>
            </div>

            <div class="control-group last">
                <div class="controls">
                    <button id="btnClose" class="btn" type="button">Close page</button>&nbsp;&nbsp;&nbsp;
                    <%  if (page_name == "inputjustification")
                        { %>
                    <button id="btnSubmitJustification" class="btn btn-success" data-action="submitted" type="button" hidden>Submit</button>
                    <%  } %>

                    <button id="btnReject" class="btn btn-success btnApproval" data-action="rejected" type="button" hidden>Reject</button>
                    <button id="btnRevise" class="btn btn-success btnApproval" data-action="requested for revision" type="button" hidden>Request for revision</button>
                    <%--<button id="btnApprove" class="btn btn-success" data-action="<%=approval_type %>" type="button"><%=approval_type_label %></button>--%>
                    <button id="btnApprove" class="btn btn-success btnApproval" data-action="approve" type="button" hidden>Approve</button>
                    <%  if ((isEditable && VS.status_id == "5") || ((isUser || isAdmin) && (VS.status_id == "25" || VS.status_id == "50")))
                        { %>
                        <button id="btnEdit" class="btn btn-success btnDetail" type="button" data-action="edited" hidden>Edit</button>
                    <%  } %>
                    <%  if (max_status != "50")
                        { %>
                    <%  if (((max_status == "25" && isEditable) || VS.status_id == "10") && isAdmin)
                        { %>
                    <button id="btnCancel" class="btn btn-danger btnDetail" type="button" data-action="cancelled" hidden>Cancel this Quotation Analysis</button>
                    
                    <%  } %>
                    <button id="btnCancelSS" class="btn btn-danger" type="button" data-action="cancelled" hidden>Cancel this Single Sourcing</button>
                    <%  } %>
                    <%  if (VS.status_id == "25")
                        { %>
                        &nbsp;&nbsp;&nbsp;
                    <button id="btnJustification" class="btn btn-success" type="button" data-action="saved" hidden>Request for single sourcing</button>
                    <%  } %>
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

<script>
    var _id = "<%=VS.id%>";
    var blankmode = "<%=blankmode%>";

    var isAdmin = "<%=isAdmin?"true":"false"%>";
    isAdmin = (isAdmin === "true");

    var isProcurementUser = "<%=isUser?"true":"false"%>";
    isProcurementUser = (isProcurementUser === "true");

    var isFinance = "<%=isFinance?"true":"false"%>";
    isFinance = (isFinance === "true");

    var isProcurement = false;
    if (isAdmin || isProcurementUser) {
        isProcurement = true;
    }

    var btnAction = "";
    var workflow = new Object();

    var listCurrency = <%=listCurrency%>;
    var listAttachment = <%=supportingDocs%>;
    var cifor_office = "1";
    var user_office = "<%=user_office%>";

    var dataQuotation = [];
    var usedPRItems = [];
    var vsItems = <%=vsItems%>;
    var vsItemsMain = <%=vsItemsMain%>;
    var listChargeCode = <%=listChargeCode%>;

    /* Business partner selection variables */
    var headerArr = [];
    var detailSupport = [];
    /* end of Business partner selection variables */
    var listCurrencyItems = [];

    var vendor_ids = [];
    var currency_ids = [];
    var deletedId = [];
    var dataSundry = <%= listSundry %>;
    var filenameupload = "";
    var btnFileUpload = null;

    var isSameOffice = "<%=isSameOffice?"true":"false"%>";
    var listSSCheck = <%=SSChecklist%>;

    $(document).ready(function () {
        //set charge code
        setdetailcc()
        PopulateVSItem();
        normalizeMultilines();

        $.each(listAttachment, function (i, d) {
            addAttachment(d.id, "", d.file_description, d.filename);
        });

        if (listAttachment.length == 0) {
            let rowatt = "<tr>";
            rowatt += '<td colspan="14" class="dataTables_empty" style="text-align:center">No data available</td>'
            rowatt += "</tr>";

            if ($("#page_type").val() == 'DETAIL' || $("#page_name").val() == 'inputjustification' || $("#page_name").val() == 'DETAIL') {
                $("#tblAttachment tbody").append(rowatt);
                $(".doc-notes").remove();

                //if ($("#page_name").val() != 'inputjustification') {
                //    $("#divJustification").removeClass("required");
                //    $('#justification_singlesourcing').prop('readonly', true);
                //}                
            }
        }

        if ($("#page_name").val() != 'inputjustification') {
            $("#divJustification").removeClass("required");
            $("#divJustificationGuideline").removeClass("required");
            $('#justification_singlesourcing').prop('readonly', true);
            $(".guideline_").prop('readonly', true);
        }      

        if (!isProcurement) {
            //$("#btnAddAttachment").remove();
            $("#btnUploadAttachment").remove();
            $("#tblAttachment td:nth-child(3), #tblAttachment th:nth-child(3)").remove();
            $(".editDocument").remove();
            $(".doc-notes").remove();
        }

        if ($("#tblAttachment tbody tr").length == 0) {
            $("#btnUploadAttachment").hide();
        }

        //if ((isProcurementUser == "false" && isAdmin == "false") || isSameOffice == "false") {
        //    $("#btnJustification").hide();
        //}
        tblSSCheck = $('#tblSingleSourceChecklist').DataTable({
            "bFilter": false, "bDestroy": true, "bRetrieve": true, //"pagingType": 'full_numbers',
            /*"lengthMenu": [[50, 100, -1], [50, 100, "All"]],*/
            //"fnRowCallback": function (nRow, aData, iDisplayIndex) {
            //    $(nRow).css('background-color', aData.color_code);
            //    $(nRow).css('color', aData.font_color);
            //},
            "aaData": listSSCheck,
            "aoColumns": [
                /*{ "mDataProp": "Id" },*/
                { "mDataProp": "Id", "visible": false },
                { "mDataProp": "guideline" },
                {
                    "mDataProp": "actions"
                    , "sClass": "no-sort"
                    //, "visible": isAdmin
                    , "mRender": function (d, type, row) {
                        var html = '<input type="checkbox" name="guideline_'+row.Id+'" id="check" data-gl="' + row.Id + '" class="guideline_"/>';
                        return html;
                    }
                },
            ],
            "bPaginate": false,
            "bInfo": false,
            "ordering": false
            //"columnDefs": [{
            //    /*"targets": [7],*/
            //    "orderable": false,
            //}],
            //"iDisplayLength": 50
            //, "bLengthChange": false
        });

        let arrGuideLine = [];

        if (vsItemsMain[0]["ss_guideline"] != null && vsItemsMain[0]["ss_guideline"].toString() != "") {
            arrGuideLine = vsItemsMain[0]["ss_guideline"].split(';');
        }        

        for (var i = 0; i < arrGuideLine.length; i++) {
            $("[name='guideline_" + arrGuideLine[i] +"']").prop('checked', true);
        }
    });

    function PopulateVSItem() {
        if ($("#tblVSItem thead").html() == "") {
            var header = '<tr>';
            header += '<th rowspan="2" style="width:5%; vertical-align:top;">Product code</th>';
            header += '<th rowspan="2" style="vertical-align:top;">PR description</th>';
            header += '<th rowspan="2" style="width:10%; vertical-align:top;">PR code</th>';
            header += '<th colspan="2" style="width:20%; text-align:center; vertical-align:top;">Purchase requisition</th>';

            headerArr = $.grep(vsItems, function (n, i) {
                return n["pr_detail_id"] === vsItems[0].pr_detail_id;
            });

            //handle multiple vendor
            $.each(headerArr, function (i, d) {
                if (vsItemsMain.length == 1) {
                    d.vendor = d.vendor + "_" + d.quotation_detail_id;
                }
            });

            $.each(headerArr, function (i, d) {
                header += '<th colspan="5" style="text-align:center;">' + d.vendor_name + '</th>';
            });

            addcol = 10 + (headerArr.length * 4);

            header += '<th rowspan="2">&nbsp;</th></tr><tr>';
            header += '<th style="border-left:1px solid #ddd !important; text-align:right;">Unit price</th>';
            header += '<th style="text-align:right;">Quantity</th>';


            $.each(headerArr, function (i, d) {
                header += '<th style="text-align:left;">Quotation</th>';
                header += '<th style="text-align:right;">Currency</th>';
                header += '<th style="text-align:right;">Unit price</th>';
                header += '<th style="text-align:right;">Quantity</th>';
                header += '<th style="text-align:right;">Total</th>';
            });
            header += '</tr>';

            $("#tblVSItem thead").append(header);
        }

        if ($("#tblVSItem tbody").html() == "") {
            var html = "";
            $.each(vsItemsMain, function (i, d) {
                html += '<tr>';
                html += '<td style="width:5%;"><input type="hidden" name="pr_detail_id" value="' + d.pr_detail_id + '"/>' + d.item_code + '</td>';
                html += '<td style="width:30%;">' + d.item_description + '</td>';
                html += '<td style="width:5%;"><a href="<%=Page.ResolveUrl("~/purchaserequisition/detail.aspx?id=' + d.pr_id + '")%>" target="_blank">' + d.pr_no + '</a></td>';
                html += '<td style="width:5%; text-align:right;">' + d.pr_currency_original + ' ' + accounting.formatNumber(delCommas(d.pr_unit_price_original), 2) + '</td>';
                html += '<td style="width:5%; text-align:right;">' + accounting.formatNumber(delCommas(d.pr_quantity), 2) + ' ' + d.uom + '</td>';

                var details = $.grep(vsItems, function (n, k) {
                    return n["pr_detail_id"] === d.pr_detail_id;
                });
                $.each(details, function (l, dt) {
                    var quotation = '';
                    quotation += '<a href="<%=Page.ResolveUrl("~/quotation/detail.aspx?id=' + dt.q_id + '")%>" target="_blank">' + dt.q_no + '</a><br>';
                    quotation += dt.qd_description;

                    html += '<td style="text-align:left;">' + quotation + '</td>';
                    html += '<td style="text-align:right;">' + dt.currency_id_original + '</td>';
                    html += '<td style="text-align:right;"><input type="hidden" name="uom" data-vendor="' + dt.vendor + '" value="' + dt.uom + '"/><input type="hidden" name="unit_price" data-vendor="' + dt.vendor + '" value="' + delCommas(dt.unit_price) + '">' + accounting.formatNumber(delCommas(dt.unit_price_original), 2) + '</td>';
                    html += '<td style="text-align:right;"><input type="hidden" name="vs_quantity" class="number span10" data-initial="' + dt.quantity + '" data-maximum-attr="quantity" data-maximum="' + dt.max_quantity + '" data-validation="required maximum" data-description="Product: ' + d.item_code + ' in Quotation from ' + dt.vendor_name + '" data-decimal-places="2" data-vendor="' + dt.vendor + '" value="' + dt.quantity + '"/>' +
                        '' + accounting.formatNumber(delCommas(dt.quantity), 2) + '</td > ';
                    html += '<td style="text-align:right;" id="total_' + d.pr_detail_id + '_' + dt.vendor + '">' + accounting.formatNumber(dt.cost_original, 2) + '</td>';
                });
                if (($("#status").val() == "50") || ($("#status").val() == "25")) {
                    html += '<td></td></tr>';
                } else {
                    html += '<td><span class="label red btnDelete" title="Delete"><i class="icon-trash delete" style="opacity: 1;"></i></span></td></tr>';
                }

                /*
                //detail charge code
                html += '<tr id="chargecode_' + d.pr_detail_id + '">';
                html += '<td colspan="' + addcol + '"><i name="cc-collapse"  data-item="' + d.pr_detail_id + '" class="icon-chevron-sign-right dropDetail" title="View Charge code(s)"></i >&nbsp&nbsp<b> Charge code(s)</b></td >';
                html += '</tr>';
                html += '<tr id="tblCostCenters_' + d.pr_detail_id + '" class="cc-hide" style="display:none;"><td colspan="' + addcol + '">' +
                    '<table  class="table table-bordered table-striped" style="table-layout: fixed;">' +
                    '<thead>' +
                    '<tr>' +
                    '<th style="text-align: center; word-wrap: break-word; width: 25%;">Cost center / Project code' +
                    '</th>' +
                    '<th style="text-align: center; word-wrap: break-word; width: 30%;">Work order / T4' +
                    '</th>' +
                    '<th style="text-align: center; word-wrap: break-word; width: 25%;">Entity' +
                    '</th>' +
                    '<th style="text-align: center; word-wrap: break-word; width: 10%;">Legal Entity' +
                    '</th>' +
                    '<th style="text-align: center; word-wrap: break-word; width: 25%;" hidden>Control Account' +
                    '</th>' +
                    '<th style="text-align: center; word-wrap: break-word; width: 7%;">%' +
                    '</th>' +
                    '<th id="lbItemAmt" style="text-align: center; word-wrap: break-word; width: 20%;">Amount(' + d.pr_currency + ')' +
                    '</th>' +
                    '<th style="text-align: center; word-wrap: break-word; width: 20%;">Amount(USD)' +
                    '</th>' +
                    '<th style="text-align: center; word-wrap: break-word; width: 25%;">Remarks' +
                    '</th>' +
                    '</tr>' +
                    '</thead>' +
                    '<tbody>';


                if (d.detail_chargecode.length > 0) {
                    $.each(d.detail_chargecode, function (l, dcc) {
                        html += '<tr>' +
                            '<td>' + dcc.cost_center_id + ' - ' + dcc.cost_center_name + '</td>' +
                            '<td>' + dcc.work_order + ' - ' + dcc.work_order_description + '</td>' +
                            '<td>' + dcc.entity_id + ' - ' + dcc.entity_description + '</td>' +
                            '<td>' + dcc.legal_entity + '</td>' +
                            '<td  style="text-align:center;">' + dcc.percentage + '</td>' +
                            '<td  style="text-align:right;">' + accounting.formatNumber(delCommas(dcc.amount), 2) + '</td>' +
                            '<td  style="text-align:right;">' + accounting.formatNumber(delCommas(dcc.amount_usd), 2) + '</td>' +
                            '<td>' + dcc.remarks + '</td>' +
                            '</tr>';
                    });

                } else {
                    html += '<tr><td colspan="8" style="text-align:center; font-style:italic;">No data available</td></tr>';
                }


                html += '</tbody>' +
                    '</table>' +
                    '</td ></tr > ';
                    */
            });


            $("#tblVSItem tbody").append(html);
        }

        populateDetailSupport();
        populateListCurrencyItems();

        if ($("#tblVSItem tfoot").html() == "") {
            var htmlFooter = "";

            htmlFooter += '<tr><td colspan="5" style="text-align:right; font-weight:bold;">Supplier Address</td>';
            $.each(headerArr, function (i, d) {
                htmlFooter += '<td colspan="5" style="text-align:left; font-weight:bold;" id="vendorAddress_' + d.vendor + '"></td>';
            });

            htmlFooter += '<td rowspan="15">&nbsp;</td></tr>';

            htmlFooter += '<tr><td colspan="5" style="text-align:right;">Discount</td>';
            $.each(headerArr, function (i, d) {
                var x = $.grep(detailSupport, function (n, j) {
                    return n["vendor"] === d.vendor;
                });

                htmlFooter += '<td colspan="5" style="text-align:right;" id="discount_' + d.vendor + '"><input type="hidden" name="discount" class="number span12" data-decimal-places="2" data-vendor="' + d.vendor + '" value="' + x[0].discount + '"/>'
                    + accounting.formatNumber(x[0].discount, 2)
                    + '</td>';
            });
            htmlFooter += '</tr>';


            htmlFooter += '<tr><td colspan="5" style="text-align:right; font-weight:bold;">Total after discount</td>';
            $.each(headerArr, function (i, d) {
                htmlFooter += '<td colspan="5" style="text-align:right; font-weight:bold;" id="TotalAfterDisc_' + d.vendor + '"></td>';
            });
            htmlFooter += '</tr>';

            htmlFooter += '<tr><td colspan="5" style="text-align:right; font-weight:bold;">Total (in USD)</td>';
            $.each(headerArr, function (i, d) {
                htmlFooter += '<td colspan="5" style="text-align:right; font-weight:bold;" id="TotalUSD_' + d.vendor + '"></td>';
            });
            htmlFooter += '</tr>';

            htmlFooter += '<tr><td colspan="5" style="text-align:right;">Additional discount (in target currency)</td>';
            $.each(headerArr, function (i, d) {
                var x = $.grep(detailSupport, function (n, j) {
                    return n["vendor"] === d.vendor;
                });
                htmlFooter += '<td colspan="5" style="text-align:right;">' + accounting.formatNumber(delCommas(x[0].additional_discount), 2) +
                    '<input type="hidden" name="additional_discount" data-vendor="' + d.vendor + '" value="' + x[0].additional_discount + '"/>' +
                    '  / USD <span id="additional_discount_usd_' + d.vendor + '"></span></td>';
            });
            htmlFooter += '</tr>';

            htmlFooter += '<tr><td colspan="5" style="text-align:right; font-weight:bold;">Total after additional discount (in target currency)</td>';
            $.each(headerArr, function (i, d) {
                htmlFooter += '<td colspan="5" style="text-align:right; font-weight:bold;" id="TotalAfterAddDisc_' + d.vendor + '"></td>';
            });
            htmlFooter += '</tr>';


            htmlFooter += '<tr><td colspan="5" style="text-align:right; font-weight:bold;">Total after additional discount (in USD)</td>';
            $.each(headerArr, function (i, d) {
                htmlFooter += '<td colspan="5" style="text-align:right; font-weight:bold;" id="TotalAfterAddDiscUSD_' + d.vendor + '"></td>';
            });
            htmlFooter += '</tr>';


            htmlFooter += '<tr><td colspan="5" style="text-align:right;">Lead time</td>';
            $.each(headerArr, function (i, d) {
                var x = $.grep(detailSupport, function (n, j) {
                    return n["vendor"] === d.vendor;
                });
                htmlFooter += '<td colspan="5" class="multilines">' + x[0].indent_time + '</td>';
            });
            htmlFooter += '</tr>';

            htmlFooter += '<tr><td colspan="5" style="text-align:right;">Warranty</td>';
            $.each(headerArr, function (i, d) {
                var x = $.grep(detailSupport, function (n, j) {
                    return n["vendor"] === d.vendor;
                });
                htmlFooter += '<td colspan="5" class="multilines">' + x[0].warranty_time + '</td>';
            });
            htmlFooter += '</tr>';

            htmlFooter += '<tr><td colspan="5" style="text-align:right;">Delivery time</td>';
            $.each(headerArr, function (i, d) {
                var x = $.grep(detailSupport, function (n, j) {
                    return n["vendor"] === d.vendor;
                });
                var exp_del = x[0].expected_delivery_date;

                if (exp_del === null) {
                    exp_del = "";
                }
                htmlFooter += '<td colspan="5">' + exp_del + '</td>';

            });
            htmlFooter += '</tr>';

            htmlFooter += '<tr><td colspan="5" style="text-align:right;">SELECTED SUPPLIER</td>';
            $.each(headerArr, function (i, d) {
                var x = $.grep(detailSupport, function (n, j) {
                    return n["vendor"] === d.vendor;
                });

                var selected = "";
                if (x[0].is_selected == "1") {
                    selected = "checked";
                }

                htmlFooter += '<td colspan="5" style="text-align:center;"><input type="radio" name="is_selected" data-vendor="' + d.vendor + '" value="1" ' + selected + ' disabled="disabled"/></td>';
            });
            htmlFooter += '</tr>';

            htmlFooter += '<tr><td colspan="5" style="text-align:right;">Reason for selection</td>';
            $.each(headerArr, function (i, d) {
                var x = $.grep(detailSupport, function (n, j) {
                    return n["vendor"] === d.vendor;
                });
                htmlFooter += '<td colspan="5" class="multilines">' + x[0].reason_for_selection + '</td>';
            });
            htmlFooter += '</tr>';

            htmlFooter += '<tr><td colspan="5" style="text-align:right;">Remarks</td>';
            $.each(headerArr, function (i, d) {
                var x = $.grep(detailSupport, function (n, j) {
                    return n["vendor"] == d.vendor;
                });
                htmlFooter += '<td colspan="5" class="multilines">' + x[0].remarks + '</td>';
            });
            htmlFooter += '</tr>';

            htmlFooter += '<tr><td colspan="5" style="text-align:right;">Upload justification (if any)</td>';
            $.each(headerArr, function (i, d) {
                var x = $.grep(detailSupport, function (n, j) {
                    return n["vendor"] == d.vendor;
                });

                htmlFooter += '<td colspan="5">';
                if (x[0].justification_file !== "") {
                    htmlFooter += '<span class="linkDocument"><a href="Files/' + $("#vs_id").val() + '/' + x[0].justification_file + '" target="_blank">' + x[0].justification_file + '</a>&nbsp;</span>';
                } else {
                    htmlFooter += '&nbsp;';
                }
                htmlFooter += '</td>';
            });
            htmlFooter += '</tr>';

            $("#tblVSItem tfoot").append(htmlFooter);

            $("span[id^='expected_delivery_date']").each(function () {
                var id = $(this).attr("id");
                $(this).datepicker({
                    format: "dd M yyyy"
                    , autoclose: true
                    , orientation: "auto"
                }).on("changeDate", function () {
                    $("#_" + id).val($("#" + id).data("date"));
                    $("#" + id).datepicker("hide");
                });
            });
            $.each(headerArr, function (i, d) {
                var x = $.grep(detailSupport, function (n, j) {
                    return n["vendor"] == d.vendor;
                });
                if (x[0].expected_delivery_date != "" && x[0].expected_delivery_date != null) {
                    var delivDate = new Date(x[0].expected_delivery_date);
                    $("#expected_delivery_date" + d.vendor).datepicker("setDate", delivDate).trigger("changeDate");
                }
            });
        } else {
            repopulateTotalDiscount();
        }

        calculateTotal();
        repopulateNumber();

        normalizeMultilines();
    }

    function populateDetailSupport() {
        /* detail support variables */
        detailSupport = [];
        $.each(headerArr, function (i, dha) {
            var arrVendors = $.grep(vsItems, function (n, i) {
                return n["vendor"] === dha.vendor;
            });

            var vendorDetail = [];
            $.each(arrVendors, function (m, sd) {
                vendorDetail.push(sd.q_id);
            });
            vendorDetail = unique(vendorDetail);

            var indent_time = ""
                , warranty_time = ""
                , expected_delivery_date = ""
                , is_selected = ""
                , reason_for_selection = ""
                , remarks = ""
                , justification_file = ""
                , discount = 0
                , additional_discount = 0;

            // populate supporting data
            $.each(arrVendors, function (m, sd) {
                // if vendor have one quotation;
                if (vendorDetail.length == 1 && _id == "") {
                    indent_time += sd.indent_time.length > 0 ? sd.indent_time + ", " : "";
                    warranty_time += sd.warranty_time.length > 0 ? sd.warranty_time + ", " : "";
                } else {
                    indent_time = sd.indent_time.length > 0 ? sd.indent_time + ", " : "";
                    warranty_time = sd.warranty_time.length > 0 ? sd.warranty_time + ", " : "";
                }

                expected_delivery_date = sd.expected_delivery_date;
                is_selected = sd.is_selected;
                reason_for_selection = sd.reason_for_selection;
                remarks = sd.remarks;
                justification_file = sd.justification_file;
                discount += delCommas(sd.discount);

                additional_discount += sd.additional_discount;
            });

            var sp = new Object();
            sp.vendor = dha.vendor;
            sp.indent_time = indent_time.length > 0 ? indent_time.substring(0, indent_time.length - 2) : indent_time;
            sp.warranty_time = warranty_time.length > 0 ? warranty_time.substring(0, warranty_time.length - 2) : warranty_time;
            sp.expected_delivery_date = expected_delivery_date;
            sp.is_selected = is_selected;
            sp.reason_for_selection = reason_for_selection;
            sp.remarks = remarks;
            sp.justification_file = justification_file;
            sp.discount = delCommas(accounting.formatNumber(discount, 2));
            sp.additional_discount = delCommas(accounting.formatNumber(additional_discount, 6));
            detailSupport.push(sp);
        });
    }

    function repopulateTotalDiscount() {
        $.each(headerArr, function (i, d) {
            var x = $.grep(detailSupport, function (n, j) {
                return n["vendor"] === d.vendor;
            });
            $("[name='discount'][data-vendor='" + d.vendor + "']").val(x[0].discount);
        });
    }

    function calculateTotal() {
        $("[name='vs_quantity']").each(function () {
            var vendor = $(this).data("vendor");
            var pr_detail_id = $(this).closest("tr").find("[name='pr_detail_id']").val();

            var EditVSItem = $.grep(vsItems, function (n, i) {
                return n["vendor"] == vendor && n["pr_detail_id"] == pr_detail_id;
            });
            EditVSItem[0].quantity = delCommas($(this).val());
            EditVSItem[0].cost = EditVSItem[0].quantity * EditVSItem[0].unit_price;
            EditVSItem[0].cost_original = EditVSItem[0].quantity * EditVSItem[0].unit_price_original;

            $("#total_" + pr_detail_id + '_' + vendor).text(accounting.formatNumber(delCommas(EditVSItem[0].cost_original), 2));
        });


        //populateCurrentData();
        //populateAfterDiscount(); 
        populateDataPerVendor();
    }

    function populateDataPerVendor() {
        let vendorAddress = "";
        let listVendorAddress = [];
        let is_sundry = "";

        $.each(detailSupport, function (i, d) {
            var pervendor = $.grep(vsItems, function (n, j) {
                return n["vendor"] == d.vendor;
            });

            let line_total_sum_pervendor = 0;
            let discount_sum_pervendor = 0;
            let add_discount_sum_pervendor = 0;
            let add_discount_usd = 0;
            let line_total_usd_sum_pervendor = 0;
            let currency_id = "";
            let exchange_sign = "";
            let exchange_rate = "";

            $.each(pervendor, function (k, di) {
                //populate group vendor address
                var adid = listVendorAddress.findIndex(x => x.supplier_address === di.supplier_address);
                if (adid == -1) {
                    listVendorAddress.push({ supplier_address: di.supplier_address });
                } else {
                    var temp = listVendorAddress[adid];
                    temp.supplier_address = di.supplier_address;
                }
                //END populate group vendor address

                currency_id = di.currency_id;
                exchange_sign = di.exchange_sign;
                exchange_rate = di.exchange_rate;

                //CALCULATE AMOUNT
                line_total_sum_pervendor += delCommas(accounting.formatNumber(di.line_total, 2));
                line_total_usd_sum_pervendor += di.line_total_usd;
                discount_sum_pervendor += di.discount;
                add_discount_sum_pervendor += di.additional_discount;
                //END CALCULATE AMOUNT
            });

            //group vendor address
            $.each(listVendorAddress, function (k, di) {
                if (di.supplier_address != null || di.supplier_address != "") {

                    if (is_sundry == "1") {
                        var btnEditSundry = '<span class="label green btnSundryEdit" data-toggle="modal" href="#SundryForm" title="Detail" data-id = ' + id + '><i class="icon-pencil edit" style="opacity: 0.7;"></i></span >'
                        vendorAddress = di.supplier_address + " " + btnEditSundry + "<br>";
                    } else {
                        vendorAddress = di.supplier_address + "<br>";
                    }

                }
            });
            //END group vendor address

            if (exchange_sign == "*") {
                //line_total_sum_pervendor = (line_total_usd_sum_pervendor / exchange_rate);
                add_discount_usd = (add_discount_sum_pervendor * exchange_rate);
            } else {
                //line_total_sum_pervendor = (line_total_usd_sum_pervendor * exchange_rate);
                add_discount_usd = (add_discount_sum_pervendor / exchange_rate);
            }

            if (isNaN(add_discount_sum_pervendor)) {
                add_discount_sum_pervendor = 0;
            }

            if (isNaN(add_discount_usd)) {
                add_discount_usd = 0;
            }

            $("#vendorAddress_" + d.vendor).html(vendorAddress);
            $("#discount_" + d.vendor).html(currency_id + " " + accounting.formatNumber(discount_sum_pervendor, 2));
            $("#TotalAfterDisc_" + d.vendor).html(currency_id + " " + accounting.formatNumber(line_total_sum_pervendor, 2));
            $("#TotalAfterDisc_" + d.vendor).attr("data-value", line_total_sum_pervendor);
            $("#TotalUSD_" + d.vendor).text(accounting.formatNumber(line_total_usd_sum_pervendor, 2));
            $("#TotalAfterAddDisc_" + d.vendor).html(currency_id + " " + accounting.formatNumber(line_total_sum_pervendor - add_discount_sum_pervendor, 2));
            $("#TotalAfterAddDiscUSD_" + d.vendor).html(accounting.formatNumber(line_total_usd_sum_pervendor - add_discount_usd, 2));
            $("#additional_discount_usd_" + d.vendor).html(accounting.formatNumber(add_discount_usd, 2));
        });
    }

    function CalculateAdditionalDiscount(vendor_code) {
        let add_discount_usd = 0;
        let add_discount = delCommas($("[name='additional_discount'][data-vendor='" + vendor_code + "']").val());

        if ($("[name='target.exchange_sign']").val() == "*") {
            add_discount_usd = (add_discount * $("[name='target.exchange_rate']").val());
        } else {
            add_discount_usd = (add_discount / $("[name='target.exchange_rate']").val());
        }

        $("#additional_discount_usd_" + vendor_code).html(accounting.formatNumber(add_discount_usd, 2));

        total_after_discount = delCommas(accounting.formatNumber($("#TotalAfterDisc_" + vendor_code).attr("data-value"), 2));
        total_after_discount_usd = delCommas($("#TotalUSD_" + vendor_code).html());
        additional_discount = delCommas($("[name='additional_discount'][data-vendor='" + vendor_code + "']").val());
        additional_discount_usd = delCommas($("#additional_discount_usd_" + vendor_code).html());

        $("#TotalAfterAddDisc_" + vendor_code).html($("select[name='target.currency']").attr("selected", "selected").val() + " " + accounting.formatNumber(total_after_discount - add_discount, 2));
        $("#TotalAfterAddDiscUSD_" + vendor_code).html(accounting.formatNumber(total_after_discount_usd - add_discount_usd, 2));

        var pervendor = $.grep(vsItems, function (n, j) {
            return n["vendor"] == vendor_code;
        });

        let additional_discount_sum = 0;
        $.each(pervendor, function (k, di) {
            di.additional_discount = delCommas(accounting.formatNumber((di.line_total_usd / total_after_discount_usd) * additional_discount, 6));
            additional_discount_sum += di.additional_discount;
        });

        let gep_add_disc = 0;

        if (delCommas(accounting.formatNumber(additional_discount_sum, 6)) > delCommas(accounting.formatNumber(add_discount, 6))) {
            gep_add_disc = delCommas(accounting.formatNumber(additional_discount_sum, 6)) - delCommas(accounting.formatNumber(add_discount, 6));
            pervendor[0]["additional_discount"] = delCommas(accounting.formatNumber(pervendor[0]["additional_discount"] - gep_add_disc, 6));
        } else if (delCommas(accounting.formatNumber(additional_discount_sum, 6)) < delCommas(accounting.formatNumber(add_discount, 6))) {
            gep_add_disc = delCommas(accounting.formatNumber(add_discount, 6)) - delCommas(accounting.formatNumber(additional_discount_sum, 6));
            pervendor[0]["additional_discount"] = delCommas(accounting.formatNumber(pervendor[0]["additional_discount"] + gep_add_disc, 6));
        }
    }

    //function populateCurrentData() {
    //    $.each(detailSupport, function (i, d) {
    //        var pervendor = $.grep(vsItems, function (n, j) {
    //            return n["vendor"] == d.vendor;
    //        });

    //        var currency_id = "";
    //        var _sign = "";
    //        var _rate = "";
    //        var is_sundry = "";
    //        var groupDiscount = "";
    //        var groupTotalAfterDisc = "";
    //        var groupExchangeRate = "";
    //        var vendorAddress = "";
    //        var totalAfterDisc = 0;
    //        var totalAfterDiscUSD = 0;
    //        var listDiscount = [];
    //        var listAfterDiscount = [];
    //        var listVendorAddress = [];
    //        var listExchngeRate = [];
    //        var id = "";

    //        $.each(pervendor, function (k, di) {

    //            currency_id = di.currency_id;
    //            is_sundry = di.is_sundry;
    //            id = di.id != "" ? di.id : di.uid;
    //            di.exchange_rate = $("#exchange_rate").val();


    //            _sign = di.exchange_sign;
    //            _rate = di.exchange_rate;


    //            //populate before additional discount
    //            console.log(di.line_total);
    //            //di.line_total = delCommas(accounting.formatNumber(di.cost - di.discount, 2));

    //            if (_sign == "/") {
    //                di.line_total_usd = delCommas(accounting.formatNumber(di.line_total / delCommas(_rate), 2));
    //            } else {
    //                di.line_total_usd = delCommas(accounting.formatNumber(di.line_total * delCommas(_rate), 2));
    //            }
    //            totalAfterDisc += di.line_total;
    //            totalAfterDiscUSD += di.line_total_usd;


    //            //populate group discount
    //            var did = listDiscount.findIndex(x => x.currency_id === di.currency_id);
    //            if (did == -1) {
    //                listDiscount.push({ currency_id: di.currency_id, discount: di.discount });
    //            } else {
    //                var temp = listDiscount[did];
    //                temp.discount += di.discount;
    //            }

    //            //populate group after discount
    //            var adid = listAfterDiscount.findIndex(x => x.currency_id === di.currency_id);
    //            if (adid == -1) {
    //                listAfterDiscount.push({ currency_id: di.currency_id, line_total: di.line_total, line_total_usd: di.line_total_usd });
    //            } else {
    //                var temp = listAfterDiscount[adid];
    //                temp.line_total += di.line_total;
    //                temp.line_total_usd += di.line_total_usd;
    //            }


    //            //populate group vendor address
    //            var adid = listVendorAddress.findIndex(x => x.supplier_address === di.supplier_address);
    //            if (adid == -1) {
    //                listVendorAddress.push({ supplier_address: di.supplier_address });
    //            } else {
    //                var temp = listVendorAddress[adid];
    //                temp.supplier_address = di.supplier_address;
    //            }

    //        })


    //        //group vendor address
    //        $.each(listVendorAddress, function (k, di) {
    //            if (di.supplier_address != null || di.supplier_address != "") {
    //                if (is_sundry == "1") {
    //                    var btnEditSundry = '<span class="label btn-primary btnSundryEdit" data-toggle="modal" href="#SundryForm" title="Detail" data-id = ' + id + '><i class="icon-info edit" style="opacity: 0.7;"></i></span >'
    //                    vendorAddress += di.supplier_address + " " + btnEditSundry + "<br>";
    //                } else {
    //                    vendorAddress += di.supplier_address + "<br>";
    //                }
    //            }
    //        });

    //        //group discount
    //        $.each(listDiscount, function (k, di) {
    //            if (di.currency_id == null) {
    //                groupDiscount += accounting.formatNumber(di.discount, 2) + "<br>";
    //            } else {
    //                groupDiscount += di.currency_id + " " + accounting.formatNumber(di.discount, 2) + "<br>";
    //            }
    //        });

    //        //group after discount
    //        $.each(listAfterDiscount, function (k, di) {
    //            if (di.currency_id == null) {
    //                groupTotalAfterDisc += accounting.formatNumber(di.line_total, 2) + " <br>";
    //            } else {
    //                groupTotalAfterDisc += di.currency_id + " " + accounting.formatNumber(di.line_total, 2) + " <br>";
    //            }
    //        });


    //        $("#vendorAddress_" + d.vendor).html(vendorAddress);
    //        $("#discount_" + d.vendor).html(groupDiscount);
    //        $("#TotalAfterDisc_" + d.vendor).html(groupTotalAfterDisc);
    //        $("#TotalUSD_" + d.vendor).text(accounting.formatNumber(totalAfterDiscUSD, 2));


    //    });

    //}

    //function populateAfterDiscount() {
    //    $.each(detailSupport, function (i, d) {
    //        var pervendor = $.grep(vsItems, function (n, j) {
    //            return n["vendor"] == d.vendor;
    //        });


    //        var totalGross = 0;
    //        var grandTotalUSDBeforeAddDisc = 0;
    //        $.each(pervendor, function (k, di) {
    //            totalGross += di.cost;
    //            grandTotalUSDBeforeAddDisc += di.line_total_usd;
    //        })


    //        var disc = delCommas($("[name='discount'][data-vendor='" + d.vendor + "']").val());
    //        var addDisc = delCommas($("[name='additional_discount'][data-vendor='" + d.vendor + "']").val());
    //        //convert to usd
    //        if ($("#exchange_sign").val() == "/") {
    //            addDisc = delCommas(addDisc / delCommas($("#exchange_rate").val()));
    //        } else {
    //            addDisc = delCommas(addDisc * delCommas($("#exchange_rate").val()));
    //        }
    //        $("#additional_discount_usd_" + d.vendor).html(accounting.formatNumber(addDisc, 2));

    //        var totalUsedDisc = 0;
    //        var totalUsedAddDisc = 0;
    //        var totalAfterAddDisc = 0;
    //        var totalAfterAddDiscUSD = 0;
    //        var currency_id = "";
    //        var _sign = "";
    //        var _rate = "";

    //        var groupTotalAfterAddDisc = "";


    //        var listAfterAddDiscount = [];

    //        $.each(pervendor, function (k, di) {

    //            currency_id = di.currency_id;
    //            di.exchange_rate = $("#exchange_rate").val();

    //            _sign = di.exchange_sign;
    //            _rate = di.exchange_rate

    //            //populate additional discount
    //            var addDiscPerItem = delCommas(accounting.formatNumber(((di.line_total_usd / grandTotalUSDBeforeAddDisc) * addDisc) / di.exchange_rate, 6));
    //            totalUsedAddDisc += delCommas(accounting.formatNumber(((di.line_total_usd / grandTotalUSDBeforeAddDisc) * addDisc), 6));

    //            if (delCommas(accounting.formatNumber(totalUsedAddDisc, 6)) > delCommas(accounting.formatNumber(addDisc, 6))) {
    //                totalUsedAddDisc -= addDiscPerItem * di.exchange_rate;
    //                addDiscPerItem = delCommas(delCommas(accounting.formatNumber(addDisc, 6)) - delCommas(accounting.formatNumber(totalUsedAddDisc, 6)) / di.exchange_rate);
    //            }

    //            di.additional_discount = delCommas(accounting.formatNumber(addDiscPerItem, 6));
                
    //            /*di.line_total = delCommas(accounting.formatNumber(di.cost - di.discount - di.additional_discount, 6));*/
    //            di.line_total = delCommas(accounting.formatNumber(di.line_total - di.additional_discount, 6));

    //            if (_sign == "/") {
    //                di.line_total_usd = delCommas(accounting.formatNumber(di.line_total / delCommas(_rate), 2));
    //            } else {
    //                di.line_total_usd = delCommas(accounting.formatNumber(di.line_total * delCommas(_rate), 2));
    //            }
    //            totalAfterAddDisc += di.line_total;
    //            totalAfterAddDiscUSD += di.line_total_usd;

    //            //populate group after additional discount
    //            var adid = listAfterAddDiscount.findIndex(x => x.currency_id === di.currency_id);
    //            if (adid == -1) {
    //                listAfterAddDiscount.push({ currency_id: di.currency_id, line_total: di.line_total, line_total_usd: di.line_total_usd });
    //            } else {
    //                var temp = listAfterAddDiscount[adid];
    //                temp.line_total += di.line_total;
    //                temp.line_total_usd += di.line_total_usd;
    //            }



    //        });

    //        //group after Additional discount
    //        $.each(listAfterAddDiscount, function (k, di) {
    //            if (di.currency_id == null) {
    //                groupTotalAfterAddDisc += accounting.formatNumber(di.line_total, 2) + " <br>";
    //            } else {
    //                groupTotalAfterAddDisc += di.currency_id + " " + accounting.formatNumber(di.line_total, 2) + " <br>";
    //            }
    //        });

    //        $("#TotalAfterAddDisc_" + d.vendor).html(groupTotalAfterAddDisc);

    //        $("#TotalAfterAddDiscUSD_" + d.vendor).text(accounting.formatNumber(totalAfterAddDiscUSD, 2));


    //    });
    //}

    function populateListCurrencyItems() {
        $.each(vsItems, function (i, di) {
            var id = listCurrencyItems.findIndex(x => x.currency_id === di.currency_id);
            if (id == -1) {
                listCurrencyItems.push({ currency_id: di.currency_id, exchange_rate: di.exchange_rate });
            }
        });
    }


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
        var errorMsg = "";
        if ($.trim($("#cancellation_text").val()) == "" && $.trim($("#cancellation_file").val()) == "") {
            errorMsg += "<br/> - Reason for cancellation is required.";
        }
        errorMsg += FileValidation();
        if ($("input[name='cancellation.uploaded']").val() == "0" && $("input[name='cancellation_file']").val()) {
            $("input[name='cancellation_file']").css({ 'background-color': 'rgb(245, 183, 177)' });
            errorMsg += "<br/> - Please upload file first.";
        }

        if (errorMsg == "") {
            $("#doc_id").val(_id);
            /*    UploadFileAPI("");*/
            if ($("#page_name").val() != "inputjustification") {
                submitCancellation();
            } else {
                SubmitJustification($(this).data("action")); 
            }
            
            /*uploadCancellationFile();*/
        } else {
            errorMsg = "Please correct the following error(s):" + errorMsg;

            $("#cform-error-message").html("<b>" + errorMsg + "<b>");
            $("#cform-error-box").show();
            $('.modal-body').animate({ scrollTop: 0 }, 500);
        }
    });

    var onBtnClickSaveCancellation = function () {
        var errorMsg = "";
        if ($.trim($("#cancellation_text").val()) == "" && $.trim($("#cancellation_file").val()) == "") {
            errorMsg += "<br/> - Reason for cancellation is required.";
        }
        errorMsg += uploadValidationResult.not_found_message || '';
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
        $("#action").val("upload");
        var form = $('form')[0];
        var formData = new FormData(form);

        $.ajax({
            type: "POST",
            url: '<%=Page.ResolveUrl("~/Service.aspx")%>',
            data: formData,
            processData: false,
            contentType: false,
            success: function (response) {
                var output = JSON.parse(response);
                if (output.result !== "success") {
                    alert(output.message);
                } else {
                    submitCancellation();
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
            url: "<%=Page.ResolveUrl("Detail.aspx/VendorSelectionCancellation")%>",
            data: JSON.stringify(data),
            dataType: 'json',
            type: 'post',
            contentType: "application/json; charset=utf-8",
            success: function (response) {
                var output = JSON.parse(response.d);
                if (output.result != "success") {
                    alert(output.message);
                } else {
                    alert("Quotation analysis " + $("#vs_no").val() + " has been cancelled successfully");
                    blockScreen();
                    parent.location.href = "List.aspx";
                }
            }
        });
    }

    $(document).on("click", "#btnAuditTrail", function () {
        parent.ShowCustomPopUp("<%= ResolveUrl("~"+based_url+"/AuditTrail.aspx?blankmode=1&module=vendorselection&id=" + _id) %>");
    });

    /* supporting docs */
    $(document).on("click", "#btnAddAttachment", function () {
        if ($("#tblAttachment >tbody >tr >td").hasClass("dataTables_empty") == true) {
            $(".dataTables_empty").remove();
        }
        addAttachment("", "", "", "");
    });

    function addAttachment(id, uid, description, filename) {
        description = NormalizeString(description);
        var vs_id = $("[name='doc_id']").val();
        if (uid === "" || typeof uid === "undefined" || uid === null) {
            var uid = guid();
        }
        var html = '<tr>';

        html += '<td><input type="hidden" name="attachment.uid" value="' + uid + '"/><input type="text" class="span12" name="attachment.file_description" data-title="Quotation file description" data-validation="required" maxlength="1000" placeholder="Description" value="' + description + '"/></td>';
        html += '<td><input type="hidden" name="attachment.filename" data-title="Quotation file" value="' + filename + '"/><div class="fileinput_' + uid + '">';
        html += '<input type="hidden" name="attachment.filename.validation" data-title="Quotation file" data-validation="required" value="' + filename + '" />';
        if (id !== "" && filename !== "") {
            html += '<span class="linkDocument"><a href="Files/' + vs_id + '/' + filename + '" target="_blank" id="linkDocument">' + filename + '</a>&nbsp;</span>';
            html += '<button type="button" class="btn btn-primary editDocument">Edit</button><input type="file" class="span10" name="filename" style="display: none;"/>';
            html += '<button type="button" class="btn btn-success btnFileUpload" data-type="file_qa" style="display:none;">Upload</button>';

        } else {
            html += '<span class="linkDocument"><a href="" target="_blank" id="linkDocument">' + filename + '</a>&nbsp;</span>';
            html += '<button type="button" class="btn btn-primary editDocument" style="display: none;">Edit</button><input type="file" class="span10" name="filename"/>';
            html += '<button type="button" class="btn btn-success btnFileUpload" data-type="file_qa">Upload</button>';

        }
        html += '</div></td > ';
        html += '<td>';
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
    //    if (uid === "" || typeof uid === "undefined" || uid === null) {
    //        var uid = guid();
    //    }
    //    var html = '<tr>';
    //    html += '<td><input type="hidden" name="attachment.uid" value="' + uid + '"/>';
    //    if (isFinance || isProcurement) {
    //        html += '<input type="text" class="span10" name="attachment.file_description" data-title="Supporting document description" data-validation="required" maxlength="2000" placeholder="Description" value="' + description + '" disabled/>';
    //    } else {

    //        html += description;
    //    }
    //    html += '</td>';
    //    html += '<td><input type="hidden" name="attachment.filename" data-title="Supporting document file" data-validation="required" value="' + filename + '"/><div class="fileinput_' + uid + '">';
    //    if (id !== "" && filename !== "") {
    //        html += '<span class="linkDocument"><a href="Files/' + _id + '/' + filename + '" target="_blank" id="linkDocumentHref">' + filename + '</a>&nbsp;</span>';
    //        html += '<button type="button" class="btn btn-success btnFileUpload" style="display:none;">Upload</button>';
    //        html += '<td style="display:none;"><input type="hidden" name="attachment.uploaded" value="1"/></td>';
    //    } else {
    //        html += '<span class="linkDocument" style="display:none;"><a class href="" id="linkDocumentHref" target="_blank"></a>&nbsp;</span>';
    //        html += '<input type="file" class="span10" name="filename" />';
    //        html += '<button type="button" class="btn btn-success btnFileUpload">Upload</button>';
    //        html += '<td style="display:none;"><input type="hidden" name="attachment.uploaded" value="0"/></td>';
    //    }
    //    html += '</div></td > ';
    //    html += '<td><input type="hidden" name="attachment.id" value="' + id + '"/></td>';
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

    $(document).on("click", ".editDocument", function () {
        var obj = $(this).closest("td").find("input[name='filename']");
        var link = $(this).closest("td").find(".linkDocument");

        $(this).closest("tr").find("input[name$='attachment.uploaded']").val("0");
        $(this).closest("td").find(".btnFileUpload").show();

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
        $("[name=filename]").uploadValidation(function (result) {
            uploadValidationResult = result;
            onBtnClickUpload.call(thisHandler);
        });
    });

    var onBtnClickUpload = function () {
        //$(document).on("click", "#btnUploadAttachment", function () {
        var errorMsg = GeneralValidation();
        errorMsg += uploadValidationResult.not_found_message || '';
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
            url: '<%=Page.ResolveUrl("~/Service.aspx")%>',
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
                    alert("Quotation analysis " + $("#vs_no").val() + " has been updated successfully.");
                    if (blankmode == "1") {
                        parent.$.colorbox.close();
                    } else {
                        parent.location.reload();
                    }
                }
            }
        });
    }


    $(document).on('click', 'i[name^="cc-collapse"]', function () {
        var tbid = "#tblCostCenters_" + $(this).attr("data-item");
        if (!$(tbid).hasClass('cc-hide')) {
            $(tbid).css("display", "none");
            $(tbid).addClass('cc-hide');
            $(this).removeClass('icon-chevron-sign-down')
            $(this).addClass('icon-chevron-sign-right');
        } else {
            $(tbid).css("display", "");
            $(tbid).removeClass('cc-hide');
            $(this).removeClass('icon-chevron-sign-right');
            $(this).addClass('icon-chevron-sign-down');
        }
    });


    function setdetailcc() {

        $.each(vsItemsMain, function (i, d) {

            var cc = $.grep(listChargeCode, function (n, i) {
                return n["pr_detail_id"] == d.pr_detail_id;
            });

            d.detail_chargecode = cc;

        });
    }

    //Sundry supplier
    $(document).on("click", ".btnSundryEdit", function () {

        // Regular expression to check if string is a valid UUID
        const regexExp = /^[0-9a-fA-F]{8}\b-[0-9a-fA-F]{4}\b-[0-9a-fA-F]{4}\b-[0-9a-fA-F]{4}\b-[0-9a-fA-F]{12}$/gi;

        var id = $(this).attr("data-id");
        var idx = "";
        if (regexExp.test(id)) {
            idx = vsItems.findIndex(x => x.uid == id);
        } else {
            idx = vsItems.findIndex(x => x.id == id);
        }

        var d = vsItems[idx];
        EditSundry(d);
    });

    function EditSundry(d) {
        $("#SundryForm tbody").empty();
        $("#SundryForm-error-message").empty();
        $("#SundryForm-error-box").hide();

        var html = "";
        var qa_id = d.id != "" ? d.id : d.uid;
        html += '<tr>'
            + '<td>Sundry </td>'
            + '<td>' + d.vendor_name
            + '<input type="hidden" name="sundry.id" value="' + d.vendor_code + '" data-vendor="' + d.vendor + '" data-qa-id = "' + qa_id + '" >'
            + '</td>'
            + '</tr>'
            + '<tr>'
            + '<td>Name <span style="color: red;">*</span></td>'
            + '<td>'
            + '<div class="">'
            + '<div class="">'
            + '<input type="text" name="sundry.name" placeholder="Name" value="" readonly class="span12"/>'
            + '</div>'
            + '</div>'
            + '</td>'
            + '</tr>'
            //
            + '<tr>'
            + '<td>Contact person <span style="color: red;">*</span></td>'
            + '<td>'
            + '<div class="">'
            + '<div class="">'//
            + '<input type="text" name="sundry.contact_person" placeholder="Contact person" value="" readonly class="span12"/>'
            + '</div>'
            + '</div>'
            + '</td>'
            + '</tr>'
            //
            //
            + '<tr>'
            + '<td>Email <span style="color: red;">*</span></td>'
            + '<td>'
            + '<div class="">'
            + '<div class="">'//
            + '<input type="text" name="sundry.email" placeholder="Email" value="" readonly class="span12"/>'
            + '</div>'
            + '</div>'
            + '</td>'
            + '</tr>'
            //
            //
            + '<tr>'
            + '<td>Phone number <span style="color: red;">*</span></td>'
            + '<td>'
            + '<div class="">'
            + '<div class="">'//
            + '<input type="text" name="sundry.phone_number" placeholder="Phone number" value="" readonly class="span12"/>'
            + '</div>'
            + '</div>'
            + '</td>'
            + '</tr>'
            //
            + '<tr>'
            + '<td>Bank account</td>'
            + '<td>'
            + '<div class="">'
            + '<div class="">'
            + '<input type="text" name="sundry.bank_account" placeholder="Bank account" value="" readonly class="span12"/>'
            + '</div>'
            + '</div>'
            + '</td>'
            + '</tr>'
            + '<tr>'
            + '<td>Swift</td>'
            + '<td>'
            + '<div class="">'
            + '<div class="">'
            + '<input type="text" name="sundry.swift" placeholder="Swift" value="" readonly class="span12"/>'
            + '</div>'
            + '</div>'
            + '</td>'
            + '</tr>'
            + '<tr>'
            + '<td>Sort code</td>'
            + '<td>'
            + '<div class="">'
            + '<div class="">'
            + '<input type="text" name="sundry.sort_code" placeholder="Sort code" value="" readonly class="span12"/>'
            + '</div>'
            + '</div>'
            + '</td>'
            + '</tr>'
            + '<tr>'
            + '<td>Address</td>'
            + '<td>'
            + '<textarea name="sundry.address"  maxlength="2000" rows="10" placeholder="address" readonly class="span12"></textarea>'
            + '</td>'
            + '</tr>'
            + '<tr>'
            + '<td>Place <span style="color: red;">*</span></td>'
            + '<td>'
            + '<div class="">'
            + '<div class="">'
            + '<input type="text" name="sundry.place" placeholder="Place" value="" readonly class="span12"/>'
            + '</div>'
            + '</div>'
            + '</td>'
            + '</tr>'
            + '<tr>'
            + '<td>Province</td>'
            + '<td>'
            + '<div class="">'
            + '<div class="">'
            + '<input type="text" name="sundry.province" placeholder="Province" value="" readonly class="span12"/>'
            + '</div>'
            + '</div>'
            + '</td>'
            + '</tr>'
            + '<tr>'
            + '<td>Post code</td>'
            + '<td>'
            + '<div class="">'
            + '<div class="">'
            + '<input type="text" name="sundry.post_code" placeholder="Post code" value="" readonly class="span12"/>'
            + '</div>'
            + '</div>'
            + '</td>'
            + '</tr>'
            + '<tr>'
            + '<td>VAT RegNo</td>'
            + '<td>'
            + '<div class="">'
            + '<div class="">'
            + '<input type="text" name="sundry.vat_reg_no" placeholder="VAT RegNo"  value="" readonly class="span12"/>'
            + '</div>'
            + '</div>'
            + '</td>'
            + '</tr>';

        $("#SundryForm").modal("show");
        $("#SundryForm tbody").append(html);
        populateSundry(d);
    }

    function populateSundry(d) {
        var header_id = _id;
        var quotation_id = d.q_id;
        var qa_id = d.id != "" && d.is_selected == "1" ? header_id : "";

        $.ajax({
            url: "<%=Page.ResolveUrl("Input.aspx/getSundry")%>",
            data: JSON.stringify({ id1: qa_id, id2: quotation_id }),
            dataType: 'json',
            type: 'post',
            contentType: "application/json; charset=utf-8",
            success: function (response) {
                var output = JSON.parse(response.d);
                if (output.result == "success") {
                    var d = JSON.parse(output.data);
                    if (d.length > 0) {
                        var ids = dataSundry.findIndex(x => x.sundry_supplier_id == d[0].sundry_supplier_id);
                        if (ids != -1) {
                            $("[name='sundry.name']").val(dataSundry[ids].name);
                            $("[name='sundry.contact_person']").val(dataSundry[ids].contact_person);
                            $("[name='sundry.email']").val(dataSundry[ids].email);
                            $("[name='sundry.phone_number']").val(dataSundry[ids].phone_number);
                            $("[name='sundry.address']").text(dataSundry[ids].address);
                            $("[name='sundry.bank_account']").val(dataSundry[ids].bank_account);
                            $("[name='sundry.swift']").val(dataSundry[ids].swift);
                            $("[name='sundry.sort_code']").val(dataSundry[ids].sort_code);
                            $("[name='sundry.place']").val(dataSundry[ids].place);
                            $("[name='sundry.province']").val(dataSundry[ids].province);
                            $("[name='sundry.post_code']").val(dataSundry[ids].post_code);
                            $("[name='sundry.vat_reg_no']").val(dataSundry[ids].vat_reg_no);
                        } else {
                            $("[name='sundry.name']").val(d[0].name);
                            $("[name='sundry.contact_person']").val(d[0].contact_person);
                            $("[name='sundry.email']").val(d[0].email);
                            $("[name='sundry.phone_number']").val(d[0].phone_number);
                            $("[name='sundry.address']").text(d[0].address);
                            $("[name='sundry.bank_account']").val(d[0].bank_account);
                            $("[name='sundry.swift']").val(d[0].swift);
                            $("[name='sundry.sort_code']").val(d[0].sort_code);
                            $("[name='sundry.place']").val(d[0].place);
                            $("[name='sundry.province']").val(d[0].province);
                            $("[name='sundry.post_code']").val(d[0].post_code);
                            $("[name='sundry.vat_reg_no']").val(d[0].vat_reg_no);
                        }
                    }
                }
            }
        });
    }

    $(document).on("click", ".btnFileUploadCancel", function () {
        $("#action").val("fileupload");
        btnFileUpload = this;

        $("#file_name").val($(this).closest("div").find("input:file").val().split('\\').pop());
        filenameupload = $("#file_name").val();

        if (!$("#file_name").val()) {
            alert("Please choose file first");
            return false;
        } else {
            let errorMsg = FileValidation();
            if (FileValidation() !== '') {
                $("#cform-error-message").html("<b>" + "- Supporting document(s):" + "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" + errorMsg + "<b>");
                $("#cform-error-box").show();
                $('.modal-body').animate({ scrollTop: 0 }, 500);

                return false;
            }

            $("input[name='doc_id']").val(_id);
            UploadFileAPI("");
            $(this).closest("div").find("input[name$='cancellation.uploaded']").val("1");
            $(this).closest("div").find("input[name$='cancellation_file']").css({ 'background-color': '' });
        }
    });

    $(document).on("click", "#btnViewWorkflow", function () {
        /* parent.ShowCustomPopUp("/workspace/viewworkflow.aspx?id="+_id+"&module=PurchaseOrder&blankmode=1");*/
        if (window.self != window.top) {
            parent.$("#btnViewWorkflowA").fancybox({
                iframe: {
                    css: {
                        height: '600px'
                    }
                }
            });
            $("#btnViewWorkflowA").get(0).click();
        } else {
            ShowCustomPopUp("<%= HttpContext.Current.Request.Url.GetLeftPart(UriPartial.Authority) + "/Workspace/ViewWorkflow?Id=" + _id + "&Module=SingleSourcing&blankmode=1" %>");
        }
    });

    function UploadFileAPI(actionType) {
        blockScreenOL();

        //if (actionType == "justification") {
        //    $("[name='doc_type']").val("QUOTATION ANALYSIS JUSTIFICATION");
        //} else {
        //    $("[name='doc_type']").val("QUOTATION ANALYSIS");
        //}

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
                        if ($(btnFileUpload).data("type") == 'file_qa') {
                            GenerateFileLink(btnFileUpload, filenameupload);
                        }
                        else if($(btnFileUpload).data("type") == 'filecancel') {
                            GenerateCancelFileLink(btnFileUpload, filenameupload);
                        } else {
                            GenerateFileJustificationLink(btnFileUpload, filenameupload);
                        }
                    } else {
                        alert('Upload file failed');
                    }
                } else {
                    alert("Quotation analysis " + $("#vs_no").val() + " has been " + btnAction + " successfully.");
                    if (btnAction.toLowerCase() == "saved") {
                        parent.location.href = "Input.aspx?id=" + $("#vs_id").val();
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

    function GenerateFileLink(row, filename) {
        var vs_id = '';
        var linkdoc = '';

        if ($("[name='doc_id']").val() == '' || $("[name='doc_id']").val() == null) {
            vs_id = $("[name='docidtemp']").val();
            linkdoc = "FilesTemp/" + vs_id + "/" + filename + "";
        } else {
            vs_id = $("[name='doc_id']").val();
            linkdoc = "Files/" + vs_id + "/" + filename + "";
        }

        $(row).closest("tr").find("input[name$='filename']").hide();

        $(row).closest("tr").find(".editDocument").show();
        $(row).closest("tr").find("a#linkDocument").attr("href", linkdoc);
        $(row).closest("tr").find("a#linkDocument").text(filename);
        $(row).closest("tr").find(".linkDocument").show();
        $(row).closest("tr").find(".btnFileUpload").hide();
        $(row).closest("tr").find("input[name='attachment.filename.validation']").val(filename);

    }

    $(document).on("click", "#btnJustification", function () {
        //$("#JustificationForm").modal("show");
        //$("#cboSingleSourcing").show();
    });

    function SubmitJustification(action) {
        sleep(1).then(() => {
            blockScreenOL();
        });

        sleep(300).then(() => {
            SubmissionJustification(action);
        }).then(() => {
        });
    }

    $(document).on("click", "[name='checkAll']", function () {

        if (!$(this).is(":checked")) {
            //$("[name='checkPR'][data-pr='" + $(this).data("pr") + "']").each(function () {
            //    $(this).prop("checked", false);
            //    removePRChecked($(this).val());
            //});
            $(".guideline_").prop('checked', false);
        } else {
            $(".guideline_").prop('checked', true);
            //$("[name='checkPR'][data-pr='" + $(this).data("pr") + "']").prop("checked", $(this).is(":checked"));
            //setPRChecked();
        }
    });

    $(document).on("click", ".guideline_", function () {
        if (!$(this).is(":checked")) {
            $("[name='checkAll']").prop('checked', false);
        } else {
            //$("[name='checkAll']").prop('checked', true);
        }
    });

    function setPRChecked() {

        $("[name='checkPR']:checkbox:checked").each(function () {
            PRLineChecked.push($(this).val());
        });
        PRLineChecked = unique(PRLineChecked);
    }
    function removePRChecked(value) {

        let arr = PRLineChecked;
        arr = arr.filter(item => item !== value)
        PRLineChecked = unique(arr);
    }
</script>
