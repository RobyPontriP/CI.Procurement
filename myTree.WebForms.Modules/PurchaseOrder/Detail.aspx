<%@ Page Language="C#" MasterPageFile="~/Procurement.Master" AutoEventWireup="true" CodeBehind="Detail.aspx.cs" Inherits="Procurement.PurchaseOrder.Detail" %>

<%@ Register Src="~/PurchaseRequisition/uscHistoricalInformation.ascx" TagName="historicalInformation" TagPrefix="uscHistoricalInformation" %>
<%@ Register Src="~/PurchaseOrder/uscFinancialReport.ascx" TagName="financialReport" TagPrefix="uscFinancialReport" %>
<%@ Register Src="~/PurchaseOrder/uscConfirmation.ascx" TagName="confirmationList" TagPrefix="uscConfirmation" %>
<%@ Register Src="~/Usc/uscRecentComment.ascx" TagName="recentcomment" TagPrefix="uscComment" %>
<%@ Register Src="~/Usc/uscCancellationForm.ascx" TagName="cancellationform" TagPrefix="uscCancellation" %>
<%@ Register Src="~/UserConfirmation/uscSendConfirmation.ascx" TagName="confirmationform" TagPrefix="uscConfirmation" %>
<%@ Register Src="~/PurchaseOrder/uscPrintOutEdit.ascx" TagName="printOutEditform" TagPrefix="uscPrintOutEdit" %>

<asp:Content ID="Content1" ContentPlaceHolderID="AppHead" runat="server">
    <title>Purchase Order</title>
    <style>
        .controls {
            padding-top: 5px;
        }

        #CancelForm.modal-dialog {
            margin: auto 12%;
            width: 60%;
            height: 320px !important;
        }

        #PrintOutForm.modal-dialog {
            margin: auto 12%;
            width: 60%;
            height: 270px !important;
        }

        .select2-container {
            width: 100% !important;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="AppBody" runat="server">
    <div class="floatingBox" id="error-box" style="display: none">
        <div class="alert alert-error" id="error-message">
        </div>
    </div>
    <!-- Cancellation Form -->
    <uscCancellation:cancellationform ID="cancellationForm" runat="server" />
    <uscPrintOutEdit:printOutEditform ID="printOutEditform" runat="server" />

    <div id="ConfirmationForm" class="modal hide fade modal-dialog" role="dialog" aria-labelledby="header1" aria-hidden="true"
        data-backdrop="static" data-keyboard="false">
        <div class="modal-header">
            <button type="button" class="close" data-dismiss="modal" aria-hidden="true"></button>
            <h3 id="header1">Request for user confirmation</h3>
        </div>
        <div class="modal-body">
            <div class="floatingBox" id="ucform-error-box" style="display: none">
                <div class="alert alert-error" id="ucform-error-message">
                </div>
            </div>
            <uscConfirmation:confirmationform ID="confirmationForm" runat="server" />
        </div>
        <div class="modal-footer">
            <button type="button" class="btn btn-success" aria-hidden="true" id="btnSendConfirmation" data-action="sent">Send confirmation</button>
            <button type="button" class="btn" data-dismiss="modal" aria-hidden="true">Close and cancel</button>
        </div>
    </div>
    <%--<%  if (authorized.admin || authorized.procurement_user || isInWorkflow)--%>
    <%  if (isAdmin || isUser || isInWorkflow)
        { %>
    <div class="row-fluid">
        <div class="floatingBox" style="margin-bottom: 0px;">
            <div class="container-fluid">
                <div class="controls text-right">
                    <%  if (isInWorkflow)
                        {%>
                    <button id="btnViewWorkflow" class="btn btn-success" type="button">View workflow</button>
                    <a hidden id="btnViewWorkflowA" href="<%= HttpContext.Current.Request.Url.GetLeftPart(UriPartial.Authority) + "/Workspace/ViewWorkflow?Id=" + _id + "&Module=PurchaseOrder&blankmode=1" %>"></a>
                    <%  } %>
                    <%--<%  if (authorized.admin || authorized.procurement_user)--%>
                    <%  if (isAdmin || isUser)
                        {
                    %>
                    <button id="btnAuditTrail" class="btn btn-success" type="button">Audit trail</button>
                    <%  } %>
                </div>
            </div>
        </div>
    </div>
    <%  } %>
    <!-- Recent comment -->
    <uscComment:recentcomment ID="recentComment" runat="server" />

    <input type="hidden" name="action" id="action" />
    <input type="hidden" name="doc_id" id="doc_id" value="<%=_id%>" />
    <input type="hidden" name="doc_type" id="doc_type" value="PURCHASE ORDER" />
    <input type="hidden" name="docidtemp" value="" />

    <input type="hidden" id="po_id" name="po.id" value="<%=PO.id %>" />
    <input type="hidden" name="po.status_id" value="<%=PO.status_id %>" />
    <input type="hidden" id="po_no" name="po.po_no" value="<%=PO.po_no %>" />
    <input type="hidden" name="file_name" id="file_name" value="" />
    <div class="row-fluid" style="margin-bottom: 0px;">
        <div class="span12 tabContainer">
            <!-- ==================== TAB NAVIGATION ==================== -->
            <ul class="nav nav-tabs">
                <li class="active">
                    <a href="#generalInformation" target="_top">Purchase order information</a>
                </li>
                <li class=""><a href="#financialInformation" target="_top">Financial information</a></li>
                <%--<li class=""><a href="#confirmationInformation" target="_top">User confirmation(s)</a></li>--%>
                <li class=""><a href="#otherInformation" target="_top">Historical information</a></li>
            </ul>
            <!-- ==================== END OF TAB NAVIGATIION ==================== -->

            <div class="row-fluid">
                <div class="tabContent" id="generalInformation" style="display: block;">
                    <div class="floatingBox table" style="margin-bottom: 0px;">
                        <div class="container-fluid">


                            <%  if (!String.IsNullOrEmpty(PO.id))
                                { %>
                            <div class="control-group">
                                <label class="control-label">
                                    PO code
                                </label>
                                <div class="controls">
                                    <b><%=PO.po_no %></b>
                                </div>
                            </div>
                            <div class="control-group">
                                <label class="control-label">
                                    PO status
                                </label>
                                <div class="controls">
                                    <b><%=PO.status_name %></b>
                                </div>
                            </div>
                            <%  if (Decimal.Parse(PO.status_id) == 35 || Decimal.Parse(PO.status_id) == 50)
                                { %>
                            <div class="control-group">
                                <label class="control-label">
                                    Invoice status
                                </label>
                                <div class="controls">
                                    <b><%=invoiceStatus %></b>
                                </div>
                            </div>
                            <%  } %>
                            <%--   <%  if (Decimal.Parse(PO.status_id) >=25 && Decimal.Parse(PO.status_id) <=50)
                                    {  %>--%>
                            <div class="control-group">
                                <label class="control-label">
                                    OCS PO
                                </label>
                                <div class="controls">
                                    <div class="span4">
                                        <% if (string.IsNullOrEmpty(PO.po_sun_code) || PO.po_sun_code == "N/A")
                                            { %>
                                        <span id="labelSUNPO" style="font-weight: bold">(OCS PO Number - New)</span>
                                        <% }
                                            else
                                            { %>
                                        <span id="labelSUNPO" style="font-weight: bold"><%=PO.po_sun_code %></span>
                                        <%}%>
                                    </div>
                                    <%  if (isAdmin && (PO.status_id == "25" || PO.status_id == "30"))
                                        {  %>
                                    <%--    <div class="span8">
                                        <button type="button" id="btnGetSUNPO" class="btn btn-success btn-small">Get OCS PO number</button>
                                        <button type="button" id="btnEditSUNPO" class="btn btn-success btn-small">Edit</button>
                                        <button type="button" id="btnSaveSUNPO" class="btn btn-success btn-small">Save</button>
                                        <button type="button" id="btnCancelSaveSUNPO" class="btn btn-small">Cancel</button>
                                    </div>--%>
                                    <%  } %>
                                </div>
                            </div>
                            <%--<%      } %>--%>
                            <%  } %>

                            <%  if (!string.IsNullOrEmpty(ocs_po_status))
                                {  %>
                            <div class="control-group">
                                <label class="control-label">
                                    OCS PO status
                                </label>
                                <div class="controls">
                                    <b><%=ocs_po_status %></b>
                                </div>
                            </div>
                            <%  } %>


                            <div class="control-group">
                                <label class="control-label">
                                    Document date
                                </label>
                                <div class="controls">
                                    <%=PO.document_date %>
                                </div>
                            </div>
                            <div class="control-group">
                                <label class="control-label">
                                    Supplier selection(s)
                                </label>
                                <div class="controls">
                                    <table id="tblVS" class="table table-bordered" data-title="Supplier selection(s)" style="border: 1px solid #ddd">
                                        <thead>
                                            <tr>
                                                <th style="width: 15%;">Supplier selection code</th>
                                                <th style="width: 15%;">Supplier code</th>
                                                <th style="width: 40%;">Supplier name</th>
                                                <%--<th style="width:20%;">Supplier account code</th>--%>
                                                <%--<th style="width:10%;">Currency</th>--%>
                                            </tr>
                                        </thead>
                                        <tbody>
                                        </tbody>
                                    </table>
                                    <p></p>
                                </div>
                            </div>
                            <div class="control-group">
                                <label class="control-label">
                                    Supplier contact person
                                </label>
                                <div class="controls">
                                    <%=PO.vendor_contact_person_name %>
                                </div>
                            </div>
                            <div class="control-group">
                                <label class="control-label">
                                    Email
                                </label>
                                <div class="controls wrapCol">
                                    <%=PO.vendor_contact_person_to_email %>
                                </div>
                            </div>
                            <div class="control-group">
                                <label class="control-label">
                                    Remarks
                                </label>
                                <div class="controls multilines"><%=PO.remarks %></div>
                            </div>

                            <%  if (Decimal.Parse(PO.status_id) == 35)
                                { %>
                            <div class="control-group">
                                <label class="control-label">
                                    Actual date sent to Supplier
                                </label>
                                <div class="controls">
                                    <div class="span2">
                                        <span id="labelSendDate"><%=PO.send_date %></span>
                                        <div class="input-prepend" style="margin-right: -32px;" id="textboxSendDate">
                                            <input type="text" name="po.send_date" id="_send_date" data-validation="required date" data-title="Actual date sent to Supplier" class="span8" readonly="readonly" placeholder="Actual date sent to Supplier" maxlength="11" />
                                            <span class="add-on icon-calendar" id="send_date"></span>
                                        </div>
                                    </div>
                                    <%--         <%  if (isAdmin && (int.Parse(PO.status_id)>= 25 && int.Parse(PO.status_id) <= 35))
                                        {  %>--%>
                                    <div class="span8">
                                        <button type="button" id="btnEditSendDate" class="btn btn-success btn-small">Edit</button>
                                        <button type="button" id="btnSaveSendDate" class="btn btn-success btn-small">Save</button>
                                        <button type="button" id="btnCancelSaveSendDate" class="btn btn-small">Cancel</button>
                                    </div>
                                    <%--<%  } %>--%>
                                </div>
                            </div>
                            <%  } %>

                            <div class="control-group">
                                <label class="control-label">
                                    Expected delivery date
                                </label>
                                <div class="controls">
                                    <div class="span2">
                                        <span id="labelDeliveryDate"><%=PO.expected_delivery_date %></span>
                                        <div class="input-prepend" style="margin-right: -32px;" id="textboxDeliveryDate">
                                            <input type="text" name="po.expected_delivery_date" id="_expected_delivery_date" data-validation="required date" data-title="Expected delivery date" class="span8" readonly="readonly" placeholder="Expected delivery date" maxlength="11" />
                                            <span class="add-on icon-calendar" id="expected_delivery_date"></span>
                                        </div>
                                    </div>
                                    <%--    <%  if (isAdmin && (int.Parse(PO.status_id)>= 25 && int.Parse(PO.status_id) <= 35))
                                        {  %>--%>
                                    <div class="span8">
                                        <button type="button" id="btnEditDeliveryDate" class="btn btn-success btn-small">Edit</button>
                                        <button type="button" id="btnSaveDeliveryDate" class="btn btn-success btn-small">Save</button>
                                        <button type="button" id="btnCancelSaveDeliveryDate" class="btn btn-small">Cancel</button>
                                    </div>
                                    <%--<%  } %>--%>
                                </div>
                            </div>
                            <%--<div class="control-group">
                                <label class="control-label">
                                    PO type
                                </label>
                                <div class="controls">
                                    <%=PO.po_type %>
                                </div>
                            </div>--%>
                            <div class="control-group">
                                <label class="control-label">
                                    Period
                                </label>
                                <div class="controls">
                                    <%=PO.period %>
                                </div>
                            </div>
                            <%--  <div class="control-group">
                                <label class="control-label">
                                    PO prefix
                                </label>
                                <div class="controls">
                                    <%=PO.sun_trans_type %>
                                </div>
                            </div>--%>
                            <div class="control-group">
                                <label class="control-label">
                                    Delivery method
                                </label>
                                <div class="controls">
                                    <%=PO.cifor_shipment_account_name %>
                                </div>
                            </div>
                            <%--  <div class="control-group">
                                <label class="control-label">
                                    Ship via
                                </label>
                                <div class="controls">
                                    <%=PO.cifor_shipment_account %>
                                </div>
                            </div>--%>
                            <div class="control-group">
                                <label class="control-label">
                                    Delivery term
                                </label>
                                <div class="controls">
                                    <%=PO.delivery_term_name %>
                                </div>
                            </div>
                            <div class="control-group">
                                <label class="control-label">
                                    Delivery address
                                </label>
                                <div class="controls">
                                    <%=PO.cifor_delivery_full_address %>
                                </div>
                            </div>
                            <%  if (!String.IsNullOrEmpty(PO.other_address))
                                { %>
                            <div class="control-group">
                                <label class="control-label">
                                    Other delivery address
                                </label>
                                <div class="controls">
                                    <%=PO.other_address %>
                                </div>
                            </div>
                            <%  } %>

                            <div class="control-group">
                                <label class="control-label">
                                    Payment terms
                                </label>
                                <div class="controls multilines"><%=PO.term_of_payment_name %></div>
                            </div>
                            <%--<% if (PO.term_of_payment.ToLower() == "oth")--%>
                            <% if (PO.is_other_term_of_payment.ToLower() == "1")
                                { %>
                            <div class="control-group">
                                <label class="control-label">
                                    Other payment terms
                                </label>
                                <div class="controls multilines"><%=PO.other_term_of_payment%></div>
                            </div>
                            <% }%>
                            <%-- <% if (PO.IsMyTreeSupplier.ToLower() == "true")
                                { %>
                            <div class="control-group">
                                <label class="control-label">
                                    Is sundry supplier?
                                </label>
                                <div class="controls multilines"><%=PO.is_sundry_po == "1" ? "Yes" : "No"%></div>
                            </div>
                            <% }%>--%>
                            <p class="filled info">Purchase order print out</p>
                            <div class="control-group">
                                <label class="control-label">
                                    Procurement address
                                </label>
                                <div class="controls">
                                    <div class="span5">
                                        <span id="labelProcAddressName"><%=PO.procurement_address_name %></span>
                                    </div>
                                    <div class="span7">
                                    </div>
                                </div>
                            </div>
                            <div class="control-group">
                                <label class="control-label">
                                    Legal entity
                                </label>
                                <div class="controls">
                                    <div class="span2">
                                        <span id="labelLegalEntity"><%=PO.legal_entity.ToLower()  == "germany" ? "CIFOR Germany" : PO.legal_entity%></span>
                                    </div>
                                    <div class="span7">
                                    </div>
                                </div>
                            </div>
                            <div class="control-group">
                                <div style="width: 97%; overflow-x: auto; display: block;">
                                    <table id="tbItems" class="table table-bordered" style="border: 1px solid #ddd">
                                        <thead>
                                            <tr>
                                                <th style="width: 20%;">PR code</th>
                                                <th style="width: 20%;">RFQ code</th>
                                                <th style="width: 20%;">Quotation code</th>
                                                <th style="width: 20%;">Supplier selection code</th>
                                                <th style="width: 20%;">Requester</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                        </tbody>
                                    </table>
                                </div>
                                <br />
                            </div>
                            <div class="control-group">
                                <label class="control-label">
                                    Total prior to discount
                                </label>
                                <div class="controls">
                                    <div class="span2" style="text-align: right;">
                                        <%=PO.currency_id %> <%=gross_amount %>
                                    </div>
                                </div>
                            </div>
                            <div class="control-group">
                                <label class="control-label">
                                    Total discount
                                </label>
                                <div class="controls">
                                    <div class="span2" style="text-align: right;">
                                        <%=PO.currency_id %> <%=PO.discount %>
                                    </div>
                                </div>
                            </div>

                            <div class="control-group">
                                <label class="control-label">
                                    Total after discount
                                </label>
                                <div class="controls">
                                    <div class="span2" style="text-align: right;">
                                        <%=PO.currency_id %> <%=total_after_discount %>&nbsp /&nbsp USD <%=gross_amount_usd %>
                                    </div>
                                    <%--<div class="" style="text-align: left;">/&nbsp USD <%=gross_amount_usd %></div>--%>
                                </div>
                            </div>

                            <%-- <% if (vat_payable)
                                { %>--%>
                            <div class="control-group">
                                <label class="control-label">
                                    Total VAT
                                </label>
                                <div class="controls">
                                    <div class="span2" style="text-align: right;">
                                        <%=PO.currency_id %> <%=str_vat_amount %>&nbsp /&nbsp USD <%=str_vat_amount_usd %>
                                    </div>
                                    <%--<div class="" style="text-align: left;">/&nbsp USD <%=str_vat_amount_usd %></div>--%>
                                </div>
                            </div>

                            <%--       <div class="control-group">
                                <label class="control-label">
                                    
                                </label>
                                <div class="controls">
                                    <div class="span1" style="text-align: right; margin-right:4px;">
                                        <%=PO.currency_id %> <%=str_vat_amount %>
                                    </div>
                                    <div class="" style="text-align: left;">
                                        /&nbsp USD <%=str_vat_amount_usd %>
                                    </div>
                                </div>
                            </div>--%>
                            <%--<% }%>--%>
                            <div class="control-group">
                                <label class="control-label">
                                    Total amount
                                </label>
                                <div class="controls">
                                    <div class="span2" style="text-align: right;">
                                        <%=PO.currency_id %> <%=PO.total_amount %>&nbsp /&nbsp USD <%=PO.total_amount_usd %>
                                    </div>
                                    <%--<div class="" style="text-align: left;">/&nbsp USD <%=PO.total_amount_usd %></div>--%>
                                </div>
                            </div>
                            <%--<div class="control-group last">
                                <label class="control-label">
                                    Supporting document(s)
                                </label>
                                <div class="controls">
                                    <table id="tblAttachment" data-title="Supporting document(s)" class="table table-bordered table-hover" style="border: 1px solid #ddd">
                                        <thead>
                                            <tr>
                                                <th style="width:50%;">Description</th>
                                                <th style="width:40%;">File</th>
                                                <th style="width:10%;">&nbsp;</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                        </tbody>
                                    </table>
                                    <div class="doc-notes"></div>
                                    <%--<p><button id="btnAddAttachment" class="btn btn-success" type="button">Add supporting document</button>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                        
                                    </p>
                                </div>
                            </div>--%>
                        </div>
                    </div>
                </div>

                <!-- ==================== SECOND TAB CONTENT ==================== -->
                <div class="tabContent" id="otherInformation" style="display: none;">
                    <div class="floatingBox table" style="margin-bottom: 0px;">
                        <div class="container-fluid">
                            <!-- Historical information -->
                            <uscHistoricalInformation:historicalInformation ID="historicalInformation1" runat="server" />
                        </div>
                    </div>
                </div>
                <!-- ==================== THIRD TAB CONTENT ==================== -->
                <div class="tabContent" id="financialInformation" style="display: none;">
                    <div class="floatingBox table" style="margin-bottom: 0px;">
                        <div class="container-fluid">
                            <!-- Financial information -->
                            <uscFinancialReport:financialReport ID="financialReport1" runat="server" />
                        </div>
                    </div>
                </div>

                <!-- ==================== FOURTH TAB CONTENT ==================== -->
                <div class="tabContent" id="confirmationInformation" style="display: none;">
                    <div class="floatingBox table" style="margin-bottom: 0px;">
                        <div class="container-fluid">
                            <!-- Confirmation information -->
                            <uscConfirmation:confirmationList ID="confirmation1" runat="server" />
                        </div>
                    </div>
                </div>

            </div>
            <div class="row-fluid">
                <div class="floatingBox" style="margin-bottom: 0px;">
                    <div class="container-fluid">
                        <div class="controls">
                            <button id="btnClose" class="btn" type="button">Close page</button>&nbsp;&nbsp;&nbsp;
                            <%  if (!string.IsNullOrEmpty(PO.po_sun_code) && (Decimal.Parse(PO.status_id) == 35 || Decimal.Parse(PO.status_id) == 50))
                                    { %>

                                <button id="btnPrint" class="btn btn-success" type="button" data-action="print">Print PO</button>
                                <button id="btnPrintCompiled" class="btn btn-success" type="button" data-action="print">Print Compiled PO</button>
                                <%  } %>
                            <%  if (!String.IsNullOrEmpty(PO.status_id)
                                    && (isAdmin || isUser || isFinance))
                                { %>
                            <%  } %>
                            <%  if (Decimal.Parse(PO.status_id) >= 25 && !string.IsNullOrEmpty(PO.po_sun_code) && PO.po_sun_code != "N/A")
                                { %>
                            <%--<button id="btnEmailToVendor" class="btn btn-success" type="button" data-action="print">Email to Supplier</button>--%>
                            <%  } %>
                            <%  if (Decimal.Parse(PO.status_id) >= 25 && !string.IsNullOrEmpty(PO.po_sun_code) && PO.po_sun_code != "N/A" && PO.is_notification_sent_to_user == "0")
                                { %>
                            <%--  <button id="btnEmailToUser" class="btn btn-success" type="button" data-action="print">Email to User</button>--%>
                            <%  } %>
                            <%  if (!String.IsNullOrEmpty(PO.status_id)
                                    && Decimal.Parse(PO.status_id) >= 25
                                    && (isAdmin || isUser))
                                { %>
                            <%--  <button id="btnXML" class="btn btn-success" type="button" data-action="exported">Export to XML</button>--%>
                            <%  } %>
                            <%  if (Decimal.Parse(PO.status_id) == 5)
                                { %>
                            <button id="btnEdit" class="btn btn-success" type="button" data-action="edited">Edit</button>
                            <%  } %>
                            <%  if (!String.IsNullOrEmpty(PO.status_id)
                                    && Double.Parse(PO.status_id) >= 25
                                    && Double.Parse(PO.status_id) < 50
                                    && (isAdmin || isUser))
                                { %>
                            <%--<button id="btnRequestForConfirmation" class="btn btn-success" type="button" data-action="confirmation">Request for user confirmation</button>--%>
                            <%  } %>
                        </div>
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
    <script type="text/javascript">
        var _id = "<%=PO.id%>";
        var blankmode = "<%=blankmode%>";
        let procurement_address = "<%=PO.procurement_address%>";
        let legal_entity = "<%=PO.legal_entity%>";
        var listProcurementAddress = <%=listProcurementAddress%>;
        var listLegalEntity = <%=listLegalEntity%>;

        <%--var isAdmin = "<%=authorized.admin?"true":"false"%>";--%>
        <%--var isAdmin = "<%=userRoleAccess.RoleNameInSystem == "procurement_admin"?"true":"false"%>";--%>
        var isAdmin = "<%=isAdmin ? "true":"false"%>";
        isAdmin = (isAdmin === "true");

        <%--var isProcurementUser = "<%=authorized.procurement_user?"true":"false"%>";--%>
        <%--var isProcurementUser = "<%=userRoleAccess.RoleNameInSystem == "procurement_user"?"true":"false"%>";--%>
        var isProcurementUser = "<%=isUser ? "true":"false"%>";
        isProcurementUser = (isProcurementUser === "true");

												  
																 
												   
        <%--var isFinance = "<%=authorized.finance?"true":"false"%>";--%>
        <%--var isFinance = "<%=userRoleAccess.RoleNameInSystem == "finance"?"true":"false"%>";--%>
        var isFinance = "<%=isFinance ? "true":"false"%>";
        isFinance = (isFinance === "true");

        var isCountryLead = "<%=isCountryLead ? "true":"false"%>";
        isCountryLead = (isCountryLead === "true");

        var isProcurement = false;
        if (isAdmin || isProcurementUser) {
            isProcurement = true;
        }

        var deletedId = [];

        var btnAction = "";
        var workflow = new Object();
        var status_id = "<%=PO.status_id%>";

        var PODetails = <%=PODetails%>;
        var PODetailsCC = <%=PODetailsCC%>;
        var PODetailsHeader = [];

        var tblItems = initTableItems();

        var dataVS = <%=dataVS%>;
        var document_date = "<%=PO.document_date%>";
        var listAttachment = <%=supportingDocs%>;

        var expected_delivery_date = "<%=PO.expected_delivery_date%>";
        var send_date = "<%=PO.send_date%>";

        var totalRequestConfirm = 0;
        var dataSundry = <%= listSundry %>;
        var is_sundry = false;
        var filenameupload = "";
        var btnFileUpload = null;

        function initTableItems() {
            return $("#tbItems").DataTable({
                data: PODetailsHeader,
                "aoColumns": [
                    {
                        "mDataProp": "pr_id"
                        , "mRender": function (d, type, row) {
                            var html = '<a href="/procurement/purchaserequisition/detail.aspx?id=' + row.pr_id + '" title="View detail Purchase requisition" target="_blank">' + row.pr_no + '</a>';
                            return html;
                        }
                    },
                    {
                        "mDataProp": "rfq_id"
                        , "mRender": function (d, type, row) {
                            var html = '<a href="/procurement/RFQ/detail.aspx?id=' + row.rfq_id + '" title="View detail RFQ" target="_blank">' + row.rfq_no + '</a>';
                            return html;
                        }
                    },
                    {
                        "mDataProp": "q_id"
                        , "mRender": function (d, type, row) {
                            var html = '<a href="/procurement/quotation/detail.aspx?id=' + row.q_id + '" title="View detail Quotation" target="_blank">' + row.q_no + '</a>';
                            return html;
                        }
                    },
                    {
                        "mDataProp": "vs_no"
                        , "mRender": function (d, type, row) {
                            var html = '<a href="/procurement/QuotationAnalysis/detail.aspx?id=' + row.vs_id + '" title="View detail Supplier selection" target="_blank">' + row.vs_no + '</a>';
                            return html;
                        }
                    },
                    { "mDataProp": "requester" },
                ],
                "bFilter": false, "bDestroy": true, "bRetrieve": true,
                "searching": false,
                "info": false,
                "ordering": false,
                "paging": false,
                "drawCallback": function (settings) {
                    OpenAllItems();
                }
            });
        }


        function populateVSTable(data) {
            data = [...new Map(data.map(item => [item['vs_no'], item])).values()];
            $.each(data, function (i, d) {
                var html = "";
                html += '<tr id="' + d.uid + '">';
                html += '<td><input type="hidden" name="vs_id" value="' + d.id + '"/><a href="/procurement/QuotationAnalysis/detail.aspx?id=' + d.id + '" target="_blank">' + d.vs_no + '</a></td>';
                /*html += '<td><a href="/workspace/procurement/businesspartner/detail.aspx?id=' + d.vendor + '" target="_blank">' + d.vendor_name + '</a></td>';*/
                var supplier_code = '';
                var supplier_name = '';
                if (d.ocs_supplier_code.length > 0) {
                    supplier_code = d.ocs_supplier_code + ' - ' + d.ocs_supplier_name;
                    supplier_name = d.ocs_supplier_name;
                } else {
                    supplier_code = d.vendor_code + ' - ' + d.vendor_name;
                    supplier_name = d.vendor_name;
                }

                html += '<td>' + supplier_code + '</td>';
                if (d.is_sundry == "1") {
                    is_sundry = true;

                    const regexExp = /^[0-9a-fA-F]{8}\b-[0-9a-fA-F]{4}\b-[0-9a-fA-F]{4}\b-[0-9a-fA-F]{4}\b-[0-9a-fA-F]{12}$/gi;
                    var pod_id = "";
                    if (!regexExp.test(d.uid)) {
                        pod_id = d.pod_id;
                    }
                    //set sundry name additional
                    var obj = new Object();
                    obj.id = d.id;
                    obj.pod_id = pod_id;
                    obj.vendor_name = d.vendor_name;
                    getSundryDetail(obj);
                    html += '<td id="supplier_name_' + pod_id + '">';
                } else {
                    is_sundry = false;
                    html += '<td>' + supplier_name;
                }
                html += '</td > ';
                html += '</tr > '
                $("#tblVS tbody").append(html);
            });
        }

        function populateHeaderItem() {
            PODetailsHeader = [];
            var _u = [];
            $.each(PODetails, function (i, d) {
                if (d.uid == null || typeof d.uid === "undefined") {
                    d.uid = guid();
                }
                if (d.unique_id == null || typeof d.unique_id === "undefined") {
                    d.unique_id = d.vs_id + ";" + d.vs_no + ";" + d.q_no + ";" + d.q_id + ";" + d.rfq_no + ";" + d.rfq_id + ";" + d.pr_no + ";" + d.pr_id;
                }
                _u.push(d.unique_id);
            });
            _u = unique(_u);
            $.each(_u, function (i, d) {
                var h = $.grep(PODetails, function (n, i) {
                    return n["unique_id"] == d;
                });

                if (h.length > 0) {
                    var obj = new Object();
                    obj.vs_id = h[0].vs_id;
                    obj.vs_no = h[0].vs_no;
                    obj.q_id = h[0].q_id;
                    obj.q_no = h[0].q_no;
                    obj.rfq_id = h[0].rfq_id;
                    obj.rfq_no = h[0].rfq_no;
                    obj.pr_id = h[0].pr_id;
                    obj.pr_no = h[0].pr_no;
                    obj.requester = h[0].requester;
                    obj.unique_id = h[0].unique_id;
                    obj.status_id = h[0].status_id;

                    PODetailsHeader.push(obj);
                }
            });

            tblItems.clear().draw();
            tblItems.rows.add(PODetailsHeader).draw();
        }

        $(document).ready(function () {
            populateVSTable(dataVS);
            populateHeaderItem();

            $.each(listAttachment, function (i, d) {
                addAttachment(d.id, "", d.file_description, d.filename);
            });

            /* SUN PO button */
            $("#btnGetSUNPO,#btnSaveSUNPO,#btnCancelSaveSUNPO").hide();

            /* Expected delivery date */
            $("#expected_delivery_date").datepicker({
                format: "dd M yyyy"
                , autoclose: true
            }).on("changeDate", function () {
                $("#_expected_delivery_date").val($("#expected_delivery_date").data("date"));
                $("#expected_delivery_date").datepicker("hide");
            });

            if (expected_delivery_date != "") {
                expected_delivery_date = new Date(expected_delivery_date);
                $("#expected_delivery_date").datepicker("setDate", expected_delivery_date).trigger("changeDate");
            }
																																																				 
            $("#btnSaveDeliveryDate,#btnCancelSaveDeliveryDate,#textboxDeliveryDate").hide();
            /* endof Expected delivery date */

            /* Actual sent date */
            $("#send_date").datepicker({
                format: "dd M yyyy"
                , autoclose: true
            }).on("changeDate", function () {
                $("#_send_date").val($("#send_date").data("date"));
                $("#send_date").datepicker("hide");
            });

            if (send_date != "") {
                send_date = new Date(send_date);
                $("#send_date").datepicker("setDate", send_date).trigger("changeDate");
            }
            $("#btnSaveSendDate,#btnCancelSaveSendDate,#textboxSendDate").hide();
            /* endof Actual sent date */

            //if (totalRequestConfirm == 0) {
            //    $("#btnRequestForConfirmation").remove();
            //}

            normalizeMultilines();

            if (!isFinance && !isProcurement) {
                $("#btnAddAttachment").remove();
                $("#btnUploadAttachment").remove();
                $("#tblAttachment td:nth-child(3), #tblAttachment th:nth-child(3)").remove();
                $(".editDocument").remove();
                $(".doc-notes").remove();
            }

            if ($("#tblAttachment tbody tr").length == 0) {
                $("#btnUploadAttachment").hide();
            }

            var cboProcurementAddress = $("select[name='po.procurement_address']");
            generateCombo(cboProcurementAddress, listProcurementAddress, "AddressId", "address", true);
            $(cboProcurementAddress).val(procurement_address).change();
            Select2Obj(cboProcurementAddress, "Procurement address");

            var cboLegalEntity = $("select[name='po.legal_entity']");
            generateCombo(cboLegalEntity, listLegalEntity, "Id", "Name", true);
            $(cboLegalEntity).val(legal_entity).change();
            Select2Obj(cboLegalEntity, "Legal entity");

            if (!isProcurement && !isFinance) {
                $("#btnPrint").hide();
                $("#btnPrintCompiled").hide();
            }            

            if (isCountryLead) {
                $(".btn").hide();
                $("#btnClose").show();
            }

            if (!isProcurement) {
                $("#btnEditSendDate").hide();
                $("#btnEditDeliveryDate").hide();
            }
        });

        function showItemDetail(d) {
            var html = '';
            if (typeof d !== "undefined") {
                html = '<table class="table table-bordered" style="border: 1px solid #ddd; margin-left:10px;"><thead>';
                html += '<tr>';
                if (isProcurement) {
                    //html += '<th>';
                    //if (d.status_id == "25" || d.status_id == "30" || d.status_id == "35") {
                    //html += '<input type="checkbox" class="checkall" data-po="' + d.vs_id + '-' + d.pr_id + '"/>';
                    //}
                    //html += '</th>';
                }
                html += '<th>Product code</th>';
                html += '<th>Product description</th>';
                html += '<th>Product status</th>';
                html += '<th>Quantity</th>';
                html += '<th>UOM</th>';
                html += '<th>Currency</th>';
                html += '<th>Unit price</th>';
                html += '<th>Discount</th>';
                html += '<th>Additional discount</th>';
                html += '<th>Sub total</th>';
                html += '<th>VAT</th>';
                //html += '<th>VAT payable?</th>';
                //html += '<th>VAT printable?</th>';
                html += '<th>VAT amount per unit</th>';
                html += '<th>Total VAT Amount</th>';
                html += '<th>Total</th>';
                if (isProcurement) {
                    //html += '<th>&nbsp;</th>';
                }
                html += '</tr>';
                html += '</thead><tbody>';

                //var item = $.grep(PODetails, function (n, i) {
                //    return n["unique_id"] == d.unique_id;
                //});

                //item = [...new Map(PODetails.map(item => [item['id'], item])).values()];
                var item = $.grep([...new Map(PODetails.map(item =>
                    [item.pr_detail_id, item])).values()], function (n, i) {
                        return n["unique_id"] == d.unique_id;
                    });
                //var item = $.grep(PODetails, function (n, i) {
                //    return n["unique_id"] == d.unique_id;
                //});

                //item = [...new Map(PODetails.map(item => [item['id'], item])).values()];
                //var item = $.grep([...new Map(PODetails.map(item =>
                //    [item.pr_detail_id, item])).values()], function (n, i) {
                //        return n["unique_id"] == d.unique_id;
                //    });

                item = unique(item);

                var groups = [];
                $.each(PODetails, function (index, event) {
                    var events = $.grep(groups, function (e) {
                        return event.vs_cost_centers_detail_id === e.vs_cost_centers_detail_id;
                    });
                    if (events.length === 0) {
                        groups.push(event);
                    }
                });

                //item = [...new Map(PODetails.map(item => [item['id'], item])).values()];

                $.each(item, function (i, x) {
                    html += '<tr>';
                    if (isProcurement) {
                        //var user_conf = "";
                        //if (delCommas(x.balance) > 0 && (d.status_id == "25" || d.status_id == "30" || d.status_id == "35")) {
                        //user_conf = x.user_confirmation;
                        //}
                        //html += '<td>' + user_conf + '</td>';
                    }
                    html += '<td>' + x.item_code + '</td>';
                    /*html += '<td><a href="/workspace/procurement/item/detail.aspx?id=' + x.item_id + '" target="_blank" title="View detail Item">' + x.item_code + '</a></td>';*/

                    var line_status_name = x.line_status_name;
                    if (x.closing_remarks != "") {
                        line_status_name += "<br/>Remarks: " + x.closing_remarks;
                    }


                    /*html += '<td>' + x.item_description + '</td>';*/
                    html += '<td>' + x.quotation_description + '</td>';
                    html += '<td>' + line_status_name + '</td>';
                    html += '<td style="text-align:right;">' + accounting.formatNumber(x.quantity, 2) + '</td>';
                    html += '<td>' + x.uom_name + '</td>';
                    html += '<td>' + x.currency_id + '</td>';
                    html += '<td style="text-align:right;">' + accounting.formatNumber(x.unit_price, 2) + '</td>';
                    html += '<td style="text-align:right;">' + accounting.formatNumber(x.discount, 2) + '</td>';
                    html += '<td style="text-align:right;">' + accounting.formatNumber(x.additional_discount, 2) + '</td>';
                    html += '<td style="text-align:right;">' + accounting.formatNumber(x.line_total, 2) + '</td>';
                    //if (x.vat_type == '%') {
                    //    html += '<td style="text-align:right;">' + accounting.formatNumber(x.vat, 2) + ' %'+'</td>';
                    //} else {
                    //    html += '<td style="text-align:right;">' + accounting.formatNumber(x.vat, 2) +'</td>';
                    //}

                    /*html += '<td>' + (x.tax_name == null ? "" : x.tax_name) + '</td>';*/
                    let vat_type = '';
                    let vat_printable = '';

                    if (x.vat_printable == true) {
                        vat_printable = "VAT Printable ? Yes";
                    } else {
                        vat_printable = "VAT Printable ? No";
                    }

                    if (x.vat_payable == true) {
                        vat_type = 'VAT Payable ? Yes';

                        //html += '<td style="text-align:right;">' + vat_type + '</td>';
                        //html += '<td style="text-align:right;">' + vat_printable + '</td>';
                        html += '<td>' + (x.tax_name == null ? "" : x.tax_name) + '<br/> '+ vat_type + '<br/>' + vat_printable + '</td>';
                        html += '<td style="text-align:right;">' + accounting.formatNumber(x.vat_amount / x.quantity, 2) + '</td>';
                        html += '<td style="text-align:right;">' + accounting.formatNumber(x.vat_amount, 2) + '</td>';
                    } else {
                        vat_type = 'VAT Payable ? No';

                        //html += '<td style="text-align:right;">' + vat_type + '</td>';
                        //html += '<td style="text-align:right;">' + vat_printable + '</td>';
                        html += '<td>' + (x.tax_name == null ? "" : x.tax_name) + '<br/> ' + vat_type + '<br/>' + vat_printable + '</td>';
                        html += '<td style="text-align:right;">' + accounting.formatNumber(0, 2) + '</td>';
                        html += '<td style="text-align:right;">' + accounting.formatNumber(0, 2) + '</td>';
                    }

                    if (x.vat_payable == true) {
                        html += '<td style="text-align:right;" class="item_total">' + accounting.formatNumber(((x.line_total + x.vat_amount) - x.additional_discount), 2) + '</td>';
                    } else {
                        html += '<td style="text-align:right;" class="item_total">' + accounting.formatNumber((x.line_total - x.additional_discount), 2) + '</td>';
                    }
                    /*html += '<td>' + x.cost_center_id + ' / ' + x.t4 + '<input type="hidden" name="po_detail_id" value="' + x.id + '"/></td>';*/
                    if (isProcurement) {
                        //html += '<td>' + x.actions + '</td>';
                    }
                    html += '</tr>';

                    var strChargeCode = "";
                    var PODetailsCCTemp = $.grep(PODetailsCC, function (n, i) {
                        return n["vs_detail_id"] == x.vs_detail_id;
                    })
                    /*  console.log(PODetailsCCTemp);*/
                    $.each(PODetailsCCTemp, function (i, dc) {
                        strChargeCode += '<tr>';
                        strChargeCode += '<td style=" width: 10%;" class="pCostCenters">' + dc.cost_center_id + ' - ' + dc.CostCenterName + '</td>';
                        strChargeCode += '<td style="width: 20%;" class="pCostCentersWorkOrder">' + dc.work_order + ' - ' + dc.Description + '</td>';
                        strChargeCode += '<td style="width: 10%;" class="pCostCentersEntity">' + dc.entitydesc + '</td>';
                        strChargeCode += '<td style="width: 5%;">' + dc.legal_entity + '</td>';
                        strChargeCode += '<td style="display: none; width: 5%;">' + dc.control_account + '</td>';
                        strChargeCode += '<td style=" width: 5%; text-align:right;" class="pCostCentersValue">' + accounting.formatNumber(dc.percentage, 2) + '</td>';
                        if (x.vat_payable == true) {
                            strChargeCode += '<td style="width: 11%; text-align:right;" class="pCostCentersAmt">' + accounting.formatNumber(parseFloat(dc.amount + dc.amount_vat), 2) + '</td>';
                            strChargeCode += '<td style="width: 11%; text-align:right;" class="pCostCentersUSDAmt">' + accounting.formatNumber(parseFloat(dc.amount_usd + dc.amount_usd_vat), 2) + '</td>';
                        } else {
                            strChargeCode += '<td style="width: 11%; text-align:right;" class="pCostCentersAmt">' + accounting.formatNumber(parseFloat(dc.amount), 2) + '</td>';
                            strChargeCode += '<td style="width: 11%; text-align:right;" class="pCostCentersUSDAmt">' + accounting.formatNumber(parseFloat(dc.amount_usd), 2) + '</td>';
                        }
                        strChargeCode += '<td style="width: 20%;">' + dc.remarks + '</td>';
                        strChargeCode += '</tr>';
                    });

                    html += '<tr id="trr' + x.id + '">';
                    html += '<td class="hiddenRow" colspan="16" style="padding:0px;">';
                    html += '<div id="dv' + guid().toString(); + '" class="accordian-body in collapse" style="height: auto;">';
                    html += '<div id="dv' + x.id + '_ChargeCode" style="margin-left:20px; margin-right:5px; margin-top:3px; margin-bottom:5px;">';
                    html += '<div id="dv' + x.id + '_CostParent">';
                    html += '<table id="tbl' + x.id + '_CostParent" class="table table-bordered table-striped tblCostCenterParent">';
                    html += '<thead>';
                    html += '<tr>';
                    html += '<th style=" width: 15%; text-align:left;">Cost center</th>';
                    html += '<th style=" width: 18%; text-align:left;">Work order</th>';
                    html += '<th style=" width: 10%; text-align:left;">Entity</th>';
                    html += '<th style=" width: 10%; text-align:left;">Legal entity</th>';
                    html += '<th style="display: none;">Account Control</th>';
                    html += '<th style=" width: 5%; text-align:left;">%</th>';
                    html += '<th style=" width: 11%; text-align:left;">Amount (' + x.currency_id + ')</th>';
                    html += '<th style=" width: 11%; text-align:left;">Amount (USD)</th>';
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

                html += '</tbody ></table > ';
            }
            return html;
        }

        function OpenAllItems() {
            if (typeof tblItems !== "undefined") {
                $.each(tblItems.rows().nodes(), function (i) {
                    var row = tblItems.row(i)
                    if (typeof row.data() !== "undefined") {
                        if (!row.child.isShown()) {
                            row.child(showItemDetail(row.data())).show();
                            $(row.node()).addClass('shown');
                        }
                    }
                });
                normalizeMultilines();
            }

            totalRequestConfirm += $(".item_confirmation").length;
        }

        $(document).on("click", "#btnCancel", function () {
            $("#CancelForm").modal("show");
        });

															 
											   
			 

        $(document).on("click", "#btnSaveCancellation", function () {
            var errorMsg = "";
            if ($.trim($("#cancellation_text").val()) == "" && $.trim($("#cancellation_file").val()) == "") {
                errorMsg += "<br/> - Reason for cancellation is required.";
            }
            errorMsg += FileValidation();

            if (errorMsg == "") {
                //uploadCancellationFile();
                submitCancellation();
            } else {
                errorMsg = "Please correct the following error(s):" + errorMsg;

                $("#cform-error-message").html("<b>" + errorMsg + "<b>");
                $("#cform-error-box").show();
                $('.modal-body').animate({ scrollTop: 0 }, 500);
            }
        });

        function uploadCancellationFile() {
            $("#action").val("upload");
            var form = $('form')[0];
            var formData = new FormData(form);

            $.ajax({
                type: "POST",
                url: '/Workspace/Procurement/Service.aspx',
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
                url: 'Detail.aspx/POCancellation',
                data: JSON.stringify(data),
                dataType: 'json',
                type: 'post',
                contentType: "application/json; charset=utf-8",
                success: function (response) {
                    var output = JSON.parse(response.d);
                    if (output.result != "success") {
                        alert(output.message);
                    } else {
                        alert("Purchase order " + $("#po_no").val() + " has been cancelled successfully");
                        blockScreen();
                        if (blankmode == "1") {
                            parent.location.reload();
                            parent.$.colorbox.close();
                        } else {
                            parent.location.href = "List.aspx";
                        }
                    }
                }
            });
        }

        $(document).on("click", "#btnPrint", function () {
            //link = "PrintPO.aspx?id=" + _id;
            //top.window.open(link);
            $("#PrintOutForm").modal("show");
            $("#cboProcAddressName").show();
        });

        $(document).on("click", "#btnPrintCompiled", function () {
            link = "CompiledPO.aspx?id=" + _id;
            top.window.open(link);
        });

        $(document).on("click", "#btnEdit", function () {
            parent.location.href = "Input.aspx?id=" + _id;
        });

        $(document).on("click", "#btnClose", function () {
            if (blankmode == "1") {
                /*parent.$.colorbox.close();  */
                //parent.closeshowcustomPopUp();
                parent.$.fancybox.close();
            } else {
                parent.location.href = "List.aspx";
            }
        });

        $(document).on("click", ".checkall", function () {
            var po = $(this).data("po");
            $(".po_" + po).prop("checked", $(this).is(":checked"));
        });

        $(document).on("click", ".item_confirmation", function () {
            var uid = $(this).prop("class").replace("item_confirmation po_", "");
            if (!$(this).is(":checked")) {
                $(".checkall[data-po='" + uid + "']").prop("checked", false);
            }
        });

        $(document).on("click", "#btnRequestForConfirmation", function () {
            var ids = [];
            var errorMsg = "";

            $(".item_confirmation:checkbox:checked").each(function () {
                ids.push($(this).val());
            });
            if (ids.length == 0) {
                errorMsg = "<br/>- Please select item(s).";
                showErrorMessage(errorMsg);
            } else {
                ids = ids.join(";");
                sendConfirmation(ids);
            }
        });

        $(document).on("click", ".btnConfirm", function () {
            var line_id = $(this).closest("tr").find("[name='po_detail_id']").val();
            sendConfirmation(line_id);
        });

        function sendConfirmation(ids) {
            resetFormConfirmation();
            $("#ConfirmationForm").modal("show");

            loadItems(ids, "PURCHASE ORDER");

            setTimeout(ScrollConfirmation, 500);
        }

        function ScrollConfirmation() {
            var ctop = $("#ConfirmationForm").offset().top;
            window.parent.$('html, #ConfirmationForm').animate({ scrollTop: ctop }, 'slow');
        }

        $(document).on("click", ".btnViewConfirm", function () {
            blockScreen();
            parent.location = $(this).data("url");
        });

        $(document).on("click", ".btnCloseItem", function () {
            blockScreen();
            parent.location = $(this).data("url");
        });

        $(document).on("click", "#btnXML", function () {
            link = "ExportXML.aspx?id=" + _id
            top.window.open(link);
        });

        /* Send date - edit feature*/
        $(document).on("click", "#btnEditSendDate", function () {
            $(this).hide();
            $("#labelSendDate").hide();

            $("#btnSaveSendDate").show();
            $("#btnCancelSaveSendDate").show();
            $("#textboxSendDate").show();
        });

        $(document).on("click", "#btnCancelSaveSendDate", function () {
            $(this).hide();
            $("#btnSaveSendDate").hide();
            $("#textboxSendDate").hide();

            if (send_date != "") {
                $("#send_date").datepicker("setDate", new Date(send_date)).trigger("changeDate");
            } else {
                $("#_send_date").val("");
            }

            $("#btnEditSendDate").show();
            $("#labelSendDate").show();
        });

        $(document).on("click", "#btnSaveSendDate", function () {
            send_date = $("#_send_date").val();
            $("#error-box").hide();
            $("#error-message").html("");

            var errorMsg = "";
            if (send_date == "") {
                errorMsg += "<br/>- Actual date sent to Supplier is required.";
            }

            if (errorMsg != "") {
                showErrorMessage(errorMsg);
                return;
            }

            blockScreenOL();

            const data = {
                po_id: _id,
                po_send_date: send_date
            };
            $.ajax({
                url: '<%= Page.ResolveUrl("~/" +based_url+ service_url + "/SavePOSendDate") %>',
                data: JSON.stringify(data),
                dataType: 'json',
                type: 'post',
                contentType: "application/json; charset=utf-8",
                success: function (response) {
                    const output = JSON.parse(response.d);
                    if (output.result != "success") {
                        alert(output.message);
                    } else {
                        alert("Actual date sent to Supplier has been updated.");
                        $("#textboxSendDate").hide();
                        $("#btnSaveSendDate").hide();
                        $("#btnCancelSaveSendDate").hide();

                        $("#labelSendDate").text($.trim(send_date));
                        $("#labelSendDate").show();
                        $("#btnEditSendDate").show();
                    }
                    unBlockScreenOL();
                },
                error: function (jqXHR, exception) {
                    unBlockScreenOL();
                }
            });
        });
        /* end of Send date*/

        /* Expected delivery date - edit feature*/
        $(document).on("click", "#btnEditDeliveryDate", function () {
            $(this).hide();
            $("#labelDeliveryDate").hide();

            $("#btnSaveDeliveryDate").show();
            $("#btnCancelSaveDeliveryDate").show();
            $("#textboxDeliveryDate").show();
        });

        $(document).on("click", "#btnCancelSaveDeliveryDate", function () {
            $(this).hide();
            $("#btnSaveDeliveryDate").hide();
            $("#textboxDeliveryDate").hide();

            $("#expected_delivery_date").datepicker("setDate", new Date(expected_delivery_date)).trigger("changeDate");
            $("#btnEditDeliveryDate").show();
            $("#labelDeliveryDate").show();
        });

        $(document).on("click", "#btnSaveDeliveryDate", function () {
            expected_delivery_date = $("#_expected_delivery_date").val();
            $("#error-box").hide();
            $("#error-message").html("");

            var errorMsg = "";
            if (expected_delivery_date == "") {
                errorMsg += "<br/>- Expected delivery date is required.";
            }

            if (errorMsg != "") {
                showErrorMessage(errorMsg);
                return;
            }

            blockScreenOL();

            const data = {
                po_id: _id,
                po_delivery_date: expected_delivery_date
            };
            $.ajax({
                url: '<%= Page.ResolveUrl("~/" +based_url+ service_url + "/SavePODeliveryDate") %>',
                data: JSON.stringify(data),
                dataType: 'json',
                type: 'post',
                contentType: "application/json; charset=utf-8",
                success: function (response) {
                    const output = JSON.parse(response.d);
                    if (output.result != "success") {
                        alert(output.message);
                    } else {
                        alert("Expected delivery date has been updated.");
                        $("#textboxDeliveryDate").hide();
                        $("#btnSaveDeliveryDate").hide();
                        $("#btnCancelSaveDeliveryDate").hide();

                        $("#labelDeliveryDate").text($.trim(expected_delivery_date));
                        $("#labelDeliveryDate").show();
                        $("#btnEditDeliveryDate").show();
                    }
                    unBlockScreenOL();
                },
                error: function (jqXHR, exception) {
                    unBlockScreenOL();
                }
            });
        });
        /* end of Expected delivery date*/

        /* SUN PO number - edit feature*/
        $(document).on("click", "#btnEditSUNPO", function () {
            $(this).hide();
            $("#btnGetSUNPO").show();
            $("#btnSaveSUNPO").show();
            $("#btnCancelSaveSUNPO").show();
        });

        $(document).on("click", "#btnCancelSaveSUNPO", function () {
            $(this).hide();
            $("#btnGetSUNPO").hide();
            $("#btnCancelSaveSUNPO").hide();
            $("#btnSaveSUNPO").hide();
            $("#btnEditSUNPO").show();
        });

        $(document).on("click", "#btnGetSUNPO", function () {
            $.ajax({
                url: '/Workspace/Procurement/Service.aspx/GetSUNPO',
                data: '{id:"' + _id + '"}',
                dataType: 'json',
                type: 'post',
                contentType: "application/json; charset=utf-8",
                success: function (response) {
                    let sun_po_no = $.trim(response.d);
                    if (sun_po_no == "") {
                        sun_po_no = "N/A";
                    }
                    $("#labelSUNPO").text(sun_po_no);
                }
            });
        });

        $(document).on("click", "#btnSaveSUNPO", function () {
            let sun_code = $.trim($("#labelSUNPO").text());
            if (sun_code == "N/A") {
                sun_code = "";
            }
            const data = {
                po_id: _id,
                po_sun_code: sun_code
            };
            $.ajax({
                url: '/Workspace/Procurement/Service.aspx/saveSUNPO',
                data: JSON.stringify(data),
                dataType: 'json',
                type: 'post',
                contentType: "application/json; charset=utf-8",
                success: function (response) {
                    const output = JSON.parse(response.d);
                    if (output.result != "success") {
                        alert(output.message);
                    } else {
                        alert("OCS PO number has been updated.");
                        $("#btnSaveSUNPO").hide();
                        $("#btnGetSUNPO").hide();
                        $("#btnCancelSaveSUNPO").hide();
                        $("#btnEditSUNPO").show();
                    }
                }
            });
        });
        /* end of SUN PO */

        /* end of Procurement address - edit feature*/
        $(document).on("click", "#btnEditProcAddress", function () {
            //$(this).hide();
            //$("#labelProcAddressName").hide();

            //$("#btnSaveProcAddress").show();
            //$("#btnCancelSaveProcAddress").show();
            //$("#cboProcAddressName").show();
											   
											  
        });

        $(document).on("click", "#btnCancelSaveProcAddress", function () {
            $("select[name='po.procurement_address']").val(procurement_address).change();
            $(this).hide();
            $("#btnSaveProcAddress").hide();
            $("#cboProcAddressName").hide();

            //if (send_date != "") {
            //    $("#send_date").datepicker("setDate", new Date(send_date)).trigger("changeDate");
            //} else {
            //    $("#_send_date").val("");
            //}

            $("#btnEditProcAddress").show();
            $("#labelProcAddressName").show();
        });

        <%--$(document).on("click", "#btnSaveProcAddress", function () {
            let procurement_address_temp = $("select[name='po.procurement_address'] option:selected").val();
            $("#error-box").hide();
            $("#error-message").html("");

            var errorMsg = "";
            if (procurement_address_temp == "") {
                errorMsg += "<br/>- Procurement address is required.";
            }

            if (errorMsg != "") {
                showErrorMessage(errorMsg);
                return;
            }

            blockScreenOL();

            const data = {
                po_id: _id,
                po_procurement_address: procurement_address_temp
            };
            $.ajax({
                url: '<%= Page.ResolveUrl("~/" +based_url+ service_url + "/SavePOProcurementAddress") %>',
                data: JSON.stringify(data),
                dataType: 'json',
                type: 'post',
                contentType: "application/json; charset=utf-8",
                success: function (response) {
                    const output = JSON.parse(response.d);
                    if (output.result != "success") {
                        alert(output.message);
                    } else {
                        alert("Procurement address has been updated.");
                        $("#cboProcAddressName").hide();
                        $("#btnSaveProcAddress").hide();
                        $("#btnCancelSaveProcAddress").hide();

                        $("#labelProcAddressName").text($.trim($("select[name='po.procurement_address'] option:selected").text()));
                        $("#labelProcAddressName").show();
                        $("#btnEditProcAddress").show();
                        procurement_address = procurement_address_temp;
                    }
                    unBlockScreenOL();
                },
                error: function (jqXHR, exception) {
                    unBlockScreenOL();
                }
            });
        });--%>
        $(document).on("click", "#btnSavePrintOut", function () {
            let procurement_address_temp = $("select[name='po.procurement_address'] option:selected").val();
            blockScreenOL();

            const data = {
                po_id: _id,
                po_procurement_address: procurement_address_temp,
                po_legal_entity: $("select[name='po.legal_entity'] option:selected").val(),
            };
            $.ajax({
                url: '<%= Page.ResolveUrl("~/" +based_url+ service_url + "/SavePrintOutPO") %>',
                data: JSON.stringify(data),
                dataType: 'json',
                type: 'post',
                contentType: "application/json; charset=utf-8",
                success: function (response) {
                    const output = JSON.parse(response.d);
                    if (output.result != "success") {
                        alert(output.message);
                    } else {
                        alert("Purchase order print out has been updated.");
                        $('#PrintOutForm').modal('hide');
                        link = "PrintPO.aspx?id=" + _id;
                        top.window.open(link);
                        location.href = "Detail.aspx?id=" + _id;
                    }
                    unBlockScreenOL();
                },
                error: function (jqXHR, exception) {
                    unBlockScreenOL();
                }
            });
        });

        $(document).on("click", "#btnPrintOut", function () {
            //link = "PrintPO.aspx?id=" + _id;
            //top.window.open(link);
        });
        /* end of Procurement address*/

        /* end of Procurement address - edit feature*/
        $(document).on("click", "#btnEditLegalEntity", function () {
            $(this).hide();
            $("#labelLegalEntity").hide();

            $("#btnSaveLegalEntity").show();
            $("#btnCancelSaveLegalEntity").show();
            $("#cboLegalEntity").show();
        });

        $(document).on("click", "#btnCancelSaveLegalEntity", function () {
            $("select[name='po.legal_entity']").val(legal_entity).change();
            $(this).hide();
            $("#btnSaveLegalEntity").hide();
            $("#cboLegalEntity").hide();

            //if (send_date != "") {
            //    $("#send_date").datepicker("setDate", new Date(send_date)).trigger("changeDate");
            //} else {
            //    $("#_send_date").val("");
            //}

            $("#btnEditLegalEntity").show();
            $("#labelLegalEntity").show();
        });

        $(document).on("click", "#btnSaveLegalEntity", function () {
            let legal_entity_temp = $("select[name='po.legal_entity'] option:selected").val();
            $("#error-box").hide();
            $("#error-message").html("");

            var errorMsg = "";
            if (legal_entity_temp == "") {
                errorMsg += "<br/>- Legal entity is required.";
            }

            if (errorMsg != "") {
                showErrorMessage(errorMsg);
                return;
            }

            blockScreenOL();

            const data = {
                po_id: _id,
                po_legal_entity: legal_entity_temp
            };
            $.ajax({
                url: '<%= Page.ResolveUrl("~/" +based_url+ service_url + "/SavePOLegalEntity") %>',
                data: JSON.stringify(data),
                dataType: 'json',
                type: 'post',
                contentType: "application/json; charset=utf-8",
                success: function (response) {
                    const output = JSON.parse(response.d);
                    if (output.result != "success") {
                        alert(output.message);
                    } else {
                        alert("Legal entity has been updated.");
                        $("#cboLegalEntity").hide();
                        $("#btnSaveLegalEntity").hide();
                        $("#btnCancelSaveLegalEntity").hide();

                        $("#labelLegalEntity").text($.trim($("select[name='po.legal_entity'] option:selected").text()));
                        $("#labelLegalEntity").show();
                        $("#btnEditLegalEntity").show();
                        legal_entity = legal_entity_temp;
                    }
                    unBlockScreenOL();
                },
                error: function (jqXHR, exception) {
                    unBlockScreenOL();
                }
            });
        });
        /* end of Legal entity*/

        $(document).on("click", "#btnEmailToUser", function () {
            var data = new Object();
            data.id = _id;

            $.ajax({
                url: 'Detail.aspx/EmailToUser',
                data: JSON.stringify(data),
                dataType: 'json',
                type: 'post',
                contentType: "application/json; charset=utf-8",
                success: function (response) {
                    var output = JSON.parse(response.d);
                    if (output.result != "success") {
                        alert(output.message);
                    } else {
                        alert("Email has been sent to user successfully");
                        blockScreen();
                        location.reload();
                    }
                }
            });
        });

        $(document).on("click", "#btnEmailToVendor", function () {
            var data = new Object();
            data.id = _id;

            $.ajax({
                url: 'Detail.aspx/EmailToBusinessPartner',
                data: JSON.stringify(data),
                dataType: 'json',
                type: 'post',
                contentType: "application/json; charset=utf-8",
                success: function (response) {
                    var output = JSON.parse(response.d);
                    if (output.result != "success") {
                        alert(output.message);
                    } else {
                        alert("Email for supplier has been sent successfully");
                        blockScreen();
                        location.reload();
                    }
                }
            });
        });

        $(document).on("click", "#btnAuditTrail", function () {
            parent.ShowCustomPopUp("<%= ResolveUrl("~"+based_url+"/AuditTrail.aspx?blankmode=1&module=purchaseorder&id=" + _id) %>");
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
                ShowCustomPopUp("<%= HttpContext.Current.Request.Url.GetLeftPart(UriPartial.Authority) + "/Workspace/ViewWorkflow?Id=" + _id + "&Module=PurchaseOrder&blankmode=1" %>");
            }
        });

        /* confirmation script */
        $(document).on("click", "#btnSendConfirmation", function () {
            var errorMsg = "";

            if ($("[name^='delivery_quantity']").length == 0) {
                errorMsg += "<br/>- Item(s) is required";
            }

            errorMsg += GeneralValidation();
            errorMsg += FileValidation();
            if (errorMsg != "") {
                errorMsg = "Please correct the following error(s):" + errorMsg;

                $("#ucform-error-message").html("<b>" + errorMsg + "<b>");
                $("#ucform-error-box").show();
                $('.modal-body').animate({ scrollTop: 0 }, 500);
            } else {
                var workflow = new Object();
                workflow.action = "saved";
                workflow.comment = "";

                var _data = new Object();
                var ConfirmList = [];
                var DocList = [];

                $("[name^='delivery_quantity']").each(function (i, x) {
                    var obj = new Object();
                    obj.base_type = $("[name='base_type']").val();
                    obj.base_id = $(this).data("id");
                    obj.send_quantity = delCommas($(this).val());
                    obj.additional_person = String($("[name^='cboStaff'][data-unique_id='" + $(this).data("unique_id") + "']").val()).toLowerCase();

                    ConfirmList.push(obj);
                });
                _data.details = ConfirmList;

                $("#tblSupportingDocuments tbody tr").each(function () {
                    var _att = new Object();
                    _att["id"] = $(this).find("input[name='confirmationfile.id']").val();
                    _att["filename"] = $(this).find("input[name='confirmationfile.filename']").val();
                    _att["file_description"] = $(this).find("input[name='confirmationfile.file_description']").val();
                    DocList.push(_att);
                });
                _data.documents = DocList;

                var Submission = {
                    submission: JSON.stringify(_data),
                    workflows: JSON.stringify(workflow),
                    deleted: JSON.stringify(deletedSupDocId)
                };

                $.ajax({
                    url: '/workspace/procurement/UserConfirmation/ItemConfirmation.aspx/Submit',
                    data: JSON.stringify(Submission),
                    dataType: 'json',
                    type: 'post',
                    contentType: "application/json; charset=utf-8",
                    success: function (response) {
                        var output = JSON.parse(response.d);
                        if (output.result !== "success") {
                            alert(output.message);
                        } else {
                            if (output.id !== "") {
                                $("#confirm_no").val(output.confirmation_code);
                                $("input[name='doc_id']").val(output.id);
                                $("input[name='action']").val("upload");
                                $("input[name='doc_type']").val("USER CONFIRMATION");
                                UploadConfirmFile();
                            }
                        }
                    }
                });
            }
        });

        function UploadConfirmFile() {
            var form = $('form')[0];
            var formData = new FormData(form);

            $.ajax({
                type: "POST",
                url: '/Workspace/Procurement/Service.aspx',
                data: formData,
                processData: false,
                contentType: false,
                success: function (response) {
                    var output = JSON.parse(response);
                    if (output.result !== "success") {
                        alert(output.message);
                    } else {
                        alert("User confirmation " + $("#confirm_no").val() + " has been sent successfully.");
                        blockScreen();
                        location.reload();
                    }
                }
            });
        }

        $(document).on("click", "#btnAddAttachment", function () {
            addAttachment("", "", "", "");
            $("#btnUploadAttachment").show();
        });

        function addAttachment(id, uid, description, filename) {
            if (uid === "" || typeof uid === "undefined" || uid === null) {
                var uid = guid();
            }
            var html = '<tr>';
            html += '<td><input type="hidden" name="attachment.uid" value="' + uid + '"/>';
            if (isFinance || isProcurement) {
                html += '<input type="text" class="span12" name="attachment.file_description" disabled data-title="Supporting document description" data-validation="required" maxlength="2000" placeholder="Description" value="' + description + '" />';
            } else {
                html += description;
            }
            html += '</td>';
            html += '<td><input type="hidden" name="attachment.filename" data-title="Supporting document file" data-validation="required" value="' + filename + '"/><div class="fileinput_' + uid + '">';
            if (id !== "" && filename !== "") {
                html += '<span class="linkDocument"><a href="Files/' + _id + '/' + filename + '" target="_blank" id="linkDocumentHref">' + filename + '</a>&nbsp;</span>';
                /*html += '<button type="button" class="btn btn-primary editDocument">Edit</button><input type="file" class="span12" name="filename" style="display: none;"/>';*/
                html += '<button type="button" class="btn btn-success btnFileUpload" style="display:none;">Upload</button>';
            } else {
                /*html += '<span class="linkDocument"><a href="" target="_blank" id="linkDocument">' + filename + '</a>&nbsp;</span>';*/
                html += '<span class="linkDocument" style="display:none;"><a class href="" id="linkDocumentHref" target="_blank">' + filename + '</a>&nbsp;</span>';
                /*html += '<input type="file" class="span12" name="filename" />';*/
                /*html += '<button type="button" class="btn btn-primary editDocument" style="display: none;">Edit</button><input type="file" class="span10" name="filename"/>';*/
                html += '<button type="button" class="btn btn-success btnFileUpload">Upload</button>';
            }
            html += '</div></td > ';
            /*html += '<td><input type="hidden" name="attachment.id" value="' + id + '"/><span class="label red btnDelete"><i class="icon-trash delete" style="opacity: 1;"></i></span></td>';*/
            html += '<td><input type="hidden" name="attachment.id" value="' + id + '"/></td>';
            if (filename !== "") {
                html += '<td style="display:none;"><input type="hidden" name="attachment.uploaded" value="1"/></td>';
            } else {
                html += '<td style="display:none;"><input type="hidden" name="attachment.uploaded" value="0"/></td>';
            }
            html += '</tr>';
            /*$("#tblAttachment tbody").append(html);*/
        }

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
                    $("#btnUploadAttachment").hide();
                }
            }

            submitAttachment();
        });

        $(document).on("click", "#btnUploadAttachment", function () {
            var errorMsg = GeneralValidation();
            errorMsg += FileValidation();

            if (errorMsg == "") {
                uploadAttachment();
            } else {
                showErrorMessage(errorMsg);
            }
        });

        function uploadAttachment() {
            $("#action").val("upload");
            var form = $('form')[0];
            var formData = new FormData(form);

            $.ajax({
                type: "POST",
                url: '/Workspace/Procurement/Service.aspx',
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
                /*url: 'Detail.aspx/UploadDocs',*/
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
                        //alert("Supporting document(s) has been uploaded successfully.");
                        //blockScreen();
                        //GenerateCancelFileLink(btnFileUpload, filenameupload);
                        //if (blankmode == "1") {
                        //    parent.$.colorbox.close();
                        //} else {
                        //    parent.location.reload();
                        //}
                    }
                }
            });
        }

        //Sundry supplier
        $(document).on("click", ".btnSundryEdit", function () {
            var header_id = _id;
            var id = $(this).attr("data-id");
            var pod_id = $(this).attr("data-pod-id");
            var vendor_name = $(this).attr("data-vendor-name");

            var obj = new Object();
            obj.id = id;
            obj.pod_id = pod_id;
            obj.vendor_name = vendor_name;
            EditSundry(obj);
        });

        function EditSundry(d) {
            $("#SundryForm tbody").empty();
            $("#SundryForm-error-message").empty();
            $("#SundryForm-error-box").hide();

            var html = "";
            html += '<tr>'
                + '<td>Sundry </td>'
                + '<td>' + d.vendor_name
                + '<input type="hidden" name="sundry.id">'
                + '</td>'
                + '</tr>'
                + '<tr>'
                + '<td>Name <span style="color: red;">*</span></td>'
                + '<td>'
                + '<div class="">'
                + '<div class="">'
                + '<input type="text" name="sundry.name" placeholder="Name" value="" class="span12" readonly/>'
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
                + '<input type="text" name="sundry.bank_account" placeholder="Bank account" value=""class="span12" readonly/>'
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
                + '<input type="text" name="sundry.sort_code" placeholder="Sort code" value="" class="span12" readonly />'
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
                + '<input type="text" name="sundry.place" placeholder="Place" value="" class="span12" readonly/>'
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
                + '<input type="text" name="sundry.vat_reg_no" placeholder="VAT RegNo"  value=""class="span12" readonly/>'
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
            var quotation_id = d.id;
            var pod_id = d.pod_id;
            var po_id = pod_id != "" ? header_id : "";
            $.ajax({
                url: "<%=Page.ResolveUrl("Input.aspx/getSundry")%>",
                data: JSON.stringify({ id1: po_id, id2: quotation_id }),
                dataType: 'json',
                type: 'post',
                contentType: "application/json; charset=utf-8",
                success: function (response) {
                    var output = JSON.parse(response.d);
                    if (output.result == "success") {
                        var d = JSON.parse(output.data);
                        if (d.length > 0) {
                            let index = 0;
                            if (pod_id != "") {
                                index = d.findIndex(x => x.module_detail_id == pod_id);
                                var ids = dataSundry.findIndex(x => x.module_detail_id == pod_id);
                                if (ids != -1) {
                                    $("[name='sundry.name']").val(dataSundry[ids].name);
                                    $("[name='sundry.address']").text(dataSundry[ids].address);
                                    $("[name='sundry.bank_account']").val(dataSundry[ids].bank_account);
                                    $("[name='sundry.swift']").val(dataSundry[ids].swift);
                                    $("[name='sundry.sort_code']").val(dataSundry[ids].sort_code);
                                    $("[name='sundry.place']").val(dataSundry[ids].place);
                                    $("[name='sundry.province']").val(dataSundry[ids].province);
                                    $("[name='sundry.post_code']").val(dataSundry[ids].post_code);
                                    $("[name='sundry.vat_reg_no']").val(dataSundry[ids].vat_reg_no);
                                    $("[name='sundry.contact_person']").val(dataSundry[ids].contact_person);
                                    $("[name='sundry.email']").val(dataSundry[ids].email);
                                    $("[name='sundry.phone_number']").val(dataSundry[ids].phone_number);
                                }
                            } else {
                                $("[name='sundry.name']").val(d[index].name);
                                $("[name='sundry.address']").text(d[index].address);
                                $("[name='sundry.bank_account']").val(d[index].bank_account);
                                $("[name='sundry.swift']").val(d[index].swift);
                                $("[name='sundry.sort_code']").val(d[index].sort_code);
                                $("[name='sundry.place']").val(d[index].place);
                                $("[name='sundry.province']").val(d[index].province);
                                $("[name='sundry.post_code']").val(d[index].post_code);
                                $("[name='sundry.vat_reg_no']").val(d[index].vat_reg_no);
                                $("[name='sundry.contact_person']").val(d[index].contact_person);
                                $("[name='sundry.email']").val(d[index].email);
                                $("[name='sundry.phone_number']").val(d[index].phone_number);
                            }
                        }
                    }
                }
            });
        }

        function getSundryDetail(d) {
            var header_id = _id;
            var quotation_id = d.id;
            var pod_id = d.pod_id;
            var po_id = pod_id != "" ? header_id : "";
            var temp = d;


            $.ajax({
                url: "<%=Page.ResolveUrl("Input.aspx/getSundry")%>",
                data: JSON.stringify({ id1: po_id, id2: quotation_id }),
                dataType: 'json',
                type: 'post',
                contentType: "application/json; charset=utf-8",
                success: function (response) {
                    var output = JSON.parse(response.d);
                    var html = '';
                    if (output.result == "success") {
                        var d = JSON.parse(output.data);
                        if (d.length > 0) {
                            let index = 0;
                            if (pod_id != "") {
                                index = d.findIndex(x => x.module_detail_id == pod_id);
                                var ids = dataSundry.findIndex(x => x.module_detail_id == pod_id);
                                if (ids != -1) {
                                    html += dataSundry[ids].name;
                                    html += ' <span class="label btn-primary btnSundryEdit" data-toggle="modal" href="#SundryForm" title="View detail"'
                                        + 'data-id="' + temp.id + '" data-pod-id ="' + temp.pod_id + '"  data-vendor-name="' + temp.vendor_name + '"> <i class="icon-info" style="opacity: 0.7;"></i></span > '
                                    $("#supplier_name_" + pod_id).html(html)
                                }
                            } else {
                                html += d[index].name;
                                html += ' <span class="label btn-primary btnSundryEdit" data-toggle="modal" href="#SundryForm" title="View detail"'
                                    + 'data-id="' + temp.id + '" data-pod-id ="' + temp.pod_id + '"  data-vendor-name="' + temp.vendor_name + '"> <i class="icon-info" style="opacity: 0.7;"></i></span > '
                                $("#supplier_name_" + pod_id).html(html)
                            }
                        }
                    }
                }
            });
        }


        $(document).on("click", ".btnFileUpload", function () {
            $("#action").val("fileupload");

            btnFileUpload = this;

            $("#file_name").val($(this).closest("tr").find("input:file").val().split('\\').pop());

            /*var filename = $("#file_name").val();*/
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
                        $('.modal-body').animate({ scrollTop: 0 }, 500);
                    } else {
                        showErrorMessage(errorMsg);
                    }

                    return false;
                }

                UploadFileAPI("");
                $(this).closest("tr").find("input[name$='attachment.uploaded']").val("1");
                $(this).closest("tr").css({ 'background-color': '' });
                /*GenerateFileLink(this, filename);*/

            }
        });

        $(document).on("click", ".btnFileUploadCancel", function () {
            $("#action").val("fileupload");

            $("#file_name").val($(this).closest("div").find("input:file").val().split('\\').pop());
            var filename = $("#file_name").val();

            if (!$("#file_name").val()) {
                alert("Please choose file first");
                return false;
            } else {
                $("input[name='doc_id']").val($("[name='po.id']").val());
                UploadFileAPI("");
                $(this).closest("div").find("input[name$='cancellation.uploaded']").val("1");
                $(this).closest("div").find("input[name$='cancellation_file']").css({ 'background-color': '' });
                GenerateCancelFileLink(this, filename);
            }
        });

        function UploadFileAPI(actionType) {
            /*blockScreen();*/
            blockScreenOL();
            var form = $('form')[0];
            var formData = new FormData(form);
            $.ajax({
                type: "POST",
                <%--url: "<%=service_url%>",--%>
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
                        if (output.result !== "success") {
                            /*alert(output.message);*/
                            /*alert("File uploaded successfully.");*/
                            submitAttachment();
                        } else {
                            /*alert("File uploaded successfully.");*/
                        }
                    } else {
                        alert("Request has been " + btnAction + " successfully.");
                        if (btnAction === "saved") {
                            if ($("[name='po.id']").val() == "") {
                                location.href = "input.aspx?id=" + output.id;
                            } else {
                                location.reload();
                            }
                        } else {
                            location.href = "/workspace/mysubmissions";/*"/workspace/My-Submissions.aspx";*/
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
            var po_id = '';
            var linkdoc = '';

            if ($("[name='po.id']").val() == '' || $("[name='po.id']").val() == null) {
                po_id = $("[name='docidtemp']").val();
                linkdoc = "FilesTemp/" + po_id + "/" + filename + "";
            } else {
                po_id = $("[name='po.id']").val();
                linkdoc = "Files/" + po_id + "/" + filename + "";
            }

            $(row).closest("tr").find("input[name$='filename']").hide();

            $(row).closest("tr").find(".editDocument").show();
            $(row).closest("tr").find("a#linkDocumentHref").attr("href", linkdoc);
            $(row).closest("tr").find("a#linkDocumentHref").text(filename);
            $(row).closest("tr").find(".linkDocument").show();
            $(row).closest("tr").find(".btnFileUpload").hide();
        }

    </script>
</asp:Content>
