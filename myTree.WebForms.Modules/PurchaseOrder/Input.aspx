<%@ Page MasterPageFile="~/Procurement.Master" Language="C#" AutoEventWireup="true" CodeBehind="Input.aspx.cs" Inherits="Procurement.PurchaseOrder.Input" %>

<%@ Register Src="~/Usc/uscRecentComment.ascx" TagName="recentcomment" TagPrefix="uscComment" %>
<%@ Register Src="~/Usc/uscCancellationForm.ascx" TagName="cancellationform" TagPrefix="uscCancellation" %>

<asp:Content ID="Content1" ContentPlaceHolderID="AppHead" runat="server">
    <title>Purchase Order</title>
    <style>
        .select2 {
            min-width: 50px !important;
        }

        #CancelForm.modal-dialog {
            margin: auto 12% !important;
            width: 60% !important;
            height: 320px !important;
        }

        .control-label {
            width: 200px !important;
        }

        .controls {
            margin-left: 220px !important;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="AppBody" runat="server">
    <!-- Bootstrap modal -->
    <div id="VSForm" class="modal hide fade modal-dialog" tabindex="-1" role="dialog" aria-labelledby="header1" aria-hidden="true"
        data-backdrop="static" data-keyboard="false">
        <div class="modal-header">
            <button type="button" class="close" data-dismiss="modal" aria-hidden="true"></button>
            <h3 id="header1">Select quotation analysis(s)</h3>
        </div>
        <div class="modal-body">
            <div class="floatingBox" id="vsform-error-box" style="display: none">
                <div class="alert alert-error" id="vsform-error-message">
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">
                    Created date
                </label>
                <div class="controls">
                    <div class="input-prepend" style="margin-right: -32px;">
                        <input type="text" id="_startDate" data-title="Start date" data-validation="required" class="span8" readonly="readonly" placeholder="Start date" maxlength="11" value="<%=startDate %>" />
                        <span class="add-on icon-calendar" id="startDate"></span>
                    </div>
                    To&nbsp;&nbsp;&nbsp;
                    <div class="input-prepend">
                        <input type="text" id="_endDate" data-title="End date" data-validation="required" class="span8" readonly="readonly" placeholder="End date" maxlength="11" value="<%=endDate %>" />
                        <span class="add-on icon-calendar" id="endDate"></span>
                    </div>
                </div>
            </div>
            <div class="control-group">
                <div class="controls">
                    <button type="button" class="btn" id="btnRefresh">Search</button>
                </div>
            </div>
            <div class="control-group">
                <table id="VSResults" class="table table-bordered" style="border: 1px solid #ddd">
                    <thead>
                        <tr>
                            <th style="width: 5%;">
                                <input id="checkAllVS" type="checkbox" /></th>
                            <th style="width: 20%;">Quotation analysis code</th>
                            <th style="width: 20%;">Created date</th>
                            <th style="width: 40%;">Supplier</th>
                            <th style="width: 15%;">Purchase/finance office</th>
                        </tr>
                    </thead>
                    <tbody>
                    </tbody>
                </table>
            </div>
        </div>
        <div class="modal-footer">
            <button type="button" class="btn btn-success" id="btnSelectVS" aria-hidden="true">Select quotation analysis</button>
            <button type="button" class="btn" data-dismiss="modal" aria-hidden="true">Close and cancel</button>
        </div>
    </div>
    <!-- end of bootstrap model -->
    <div class="floatingBox" id="error-box" style="display: none">
        <div class="alert alert-error" id="error-message">
        </div>
    </div>
    <!-- Recent comment -->
    <uscComment:recentcomment ID="recentComment" runat="server" />

    <!-- Cancellation Form -->
    <uscCancellation:cancellationform ID="cancellationForm" runat="server" />

    <!-- for upload file -->
    <input type="hidden" name="action" id="action" value="" />
    <input type="hidden" name="doc_id" value="<%=PO.id %>" />
    <input type="hidden" name="doc_type" value="PURCHASE ORDER" />
    <!-- end of upload file -->

    <input type="hidden" id="sn" value="<%=sn %>" />
    <input type="hidden" id="activity_id" value="<%=activity_id %>" />
    <input type="hidden" id="status" value="<%=PO.status_id %>" />

    <input type="hidden" id="po_id" name="po.id" value="<%=PO.id %>" />
    <input type="hidden" name="po.status_id" value="<%=PO.status_id %>" />
    <input type="hidden" id="po_no" name="po.po_no" value="<%=PO.po_no %>" />
    <input type="hidden" name="po.currency_id" value="<%=PO.currency_id %>" />
    <input type="hidden" name="po.exchange_sign" value="<%=PO.exchange_sign %>" />
    <input type="hidden" name="po.exchange_rate" value="<%=PO.exchange_rate %>" class="number" data-decimal-places="8" />
    <input type="hidden" name="po.cifor_office_id" value="<%=PO.cifor_office_id %>" />
    <input type="hidden" name="po.vendor" />
    <input type="hidden" name="po.vendor_code" />
    <input type="hidden" name="po.vendor_name" />
    <input type="hidden" name="po.is_goods" />
    <input type="hidden" name="file_name" id="file_name" value="" />
    <input type="hidden" name="temp.sundry_name" value="" />
    <div class="row-fluid">
        <div class="floatingBox">
            <div class="container-fluid">
                <%  if (!String.IsNullOrEmpty(PO.id))
                    { %>
                <div class="control-group">
                    <label class="control-label">
                        PO code
                    </label>
                    <div class="controls labelDetail">
                        <b><%=PO.po_no %></b>
                    </div>
                </div>
                <div class="control-group">
                    <label class="control-label">
                        PO status
                    </label>
                    <div class="controls labelDetail">
                        <b><%=PO.status_name %></b>
                    </div>
                </div>
                <div class="control-group" id="divSUNPO">
                    <label class="control-label">
                        OCS PO
                    </label>
                    <div class="controls labelDetail">
                        <input type="text" name="po.po_sun_code" class="span3" readonly="readonly" placeholder="OCS PO" maxlength="20" value="<%=PO.po_sun_code %>" />
                        <%--<button type="button" id="btnGetSUNPO" class="btn btn-success">Get SUN PO number</button>--%>
                    </div>
                </div>
                <%  } %>
                <div class="control-group required">
                    <label class="control-label">
                        Document date
                    </label>
                    <div class="controls">
                        <div class="input-prepend" style="margin-right: -32px;">
                            <input type="text" name="po.document_date" id="_document_date" data-validation="required date" data-title="Document date" class="span8" readonly="readonly" placeholder="Document date" maxlength="11" />
                            <span class="add-on icon-calendar" id="document_date"></span>
                        </div>
                    </div>
                </div>
                <div class="control-group required">
                    <label class="control-label">
                        Quotation analysis
                    </label>
                    <div class="controls">
                        <table id="tblVS" class="table table-bordered required" data-title="Quotation analysis" style="border: 1px solid #ddd">
                            <thead>
                                <tr>
                                    <th style="width: 15%;">Quotation analysis code</th>
                                    <th style="width: 15%;">Supplier code</th>
                                    <th style="width: 40%;">Supplier name</th>
                                    <%--<th style="width:15%;">Supplier account code</th>--%>
                                    <%--                     <th style="width:10%;">Currency</th>--%>
                                    <%  if (string.IsNullOrEmpty(sn))
                                        { %>
                                    <th style="width: 5%;">&nbsp;</th>
                                    <%  } %>
                                </tr>
                            </thead>
                            <tbody>
                            </tbody>
                        </table>
                        <p>
                            <button id="btnVS" class="btn btn-success" type="button">Add quotation analysis</button></p>
                    </div>
                </div>
                <div class="control-group required">
                    <label class="control-label">
                        Supplier contact person
                    </label>
                    <div class="controls">
                        <select name="po.vendor_contact_person" class="span4" data-validation="required" data-title="Contact person"></select>
                    </div>
                </div>
                <div class="control-group">
                    <label class="control-label">
                        Email
                    </label>
                    <div class="controls">
                        <select name="po.email" class="span4" data-title="Email"></select>
                    </div>
                </div>
                <div class="control-group">
                    <label class="control-label">
                        Remarks
                    </label>
                    <div class="controls">
                        <textarea name="po.remarks" maxlength="2000" rows="3" class="span10 textareavertical" placeholder="Remarks"><%=PO.remarks %></textarea>
                        <br />
                        <small><i>Maximum description is 2,000 characters</i></small>
                    </div>
                </div>
                <div class="control-group required">
                    <label class="control-label">
                        Expected delivery date
                    </label>
                    <div class="controls">
                        <div class="input-prepend" style="margin-right: -32px;">
                            <input type="text" name="po.expected_delivery_date" id="_expected_delivery_date" data-validation="required date" data-title="Expected delivery date" class="span8" readonly="readonly" placeholder="Expected delivery date" maxlength="11" />
                            <span class="add-on icon-calendar" id="expected_delivery_date"></span>
                        </div>
                    </div>
                </div>
                <%--      <div class="control-group">
                    <label class="control-label">
                        Actual date sent to supplier
                    </label>
                    <div class="controls">
                        <div class="input-prepend" style="margin-right:-32px;">
                            <input type="text" name="po.send_date" id="_actual_sent_date" data-title="Actual date sent to Supplier" class="span8" readonly="readonly" placeholder="Actual date sent to Supplier" maxlength="11"/>
                            <span class="add-on icon-calendar" id="actual_sent_date"></span>
                        </div> 
                    </div>
                </div>--%>

                <%--<div class="control-group required">--%>
                <%--               <div class="control-group hidden">
                    <label class="control-label">
                        PO type
                    </label>
                    <div class="controls">
                        <select name="po.po_type" class="span4" data-validation="required" data-title="PO type"></select>
                    </div>
                </div>--%>
                <%--<div class="control-group required">--%>
                <%--                <div class="control-group hidden">
                    <label class="control-label">
                        PO prefix
                    </label>
                    <div class="controls">
                        <input type="hidden" name="po.po_prefix" value="<%=PO.po_prefix %>"/>
                        <select name="po.sun_trans_type" class="span4" data-validation="required" data-title="PO prefix"></select>
                    </div>
                </div>--%>
                <div class="control-group required">
                    <label class="control-label">
                        Period
                    </label>
                    <div class="controls">
                        <select name="po.period" class="span4" data-validation="required" data-title="Period"></select>
                    </div>
                </div>
                <div class="control-group required">
                    <label class="control-label">
                        Delivery method
                    </label>
                    <div class="controls">
                        <%--<select name="po.cifor_shipment_account" class="span4" data-validation="required" data-title="Shipment method"></select>--%>
                        <select name="po.cifor_shipment_account" class="span4" data-validation="required" data-title="Delivery method"></select>
                    </div>
                </div>
                <div class="control-group required">
                    <label class="control-label">
                        Delivery term
                    </label>
                    <div class="controls">
                        <select name="po.delivery_term" class="span4" data-validation="required" data-title="Delivery term"></select>
                    </div>
                </div>
                <div class="control-group required" id="div_delivery_address">
                    <label class="control-label">
                        Delivery address
                    </label>
                    <div class="controls">
                        <select name="po.cifor_delivery_address" class="span4" data-validation="required" data-title="Delivery address"></select>
                    </div>
                </div>
                <div class="control-group" id="div_is_other_address">
                    <label class="control-label">
                        Other delivery address
                    </label>
                    <div class="controls">
                        <input type="checkbox" name="po.is_other_address" /><label for="po.is_other_address"></label>
                    </div>
                </div>

                <div class="control-group" id="div_other_address" style="display: none;">
                    <div class="controls">
                        <textarea name="po.other_address" maxlength="255" rows="3" class="span10 textareavertical" data-title="Other delivery address" placeholder="Other delivery address"><%=PO.other_address %></textarea>
                        <br />
                        <small><i>Maximum other delivery address is 255 characters</i></small>
                    </div>
                </div>

                <div class="control-group required" id="div_payment_terms">
                    <label class="control-label">
                        Payment terms
                    </label>
                    <div class="controls">
                        <select name="po.term_of_payment"  class="span4" data-validation="required" data-title="Payment terms"></select> 
                    </div>
                </div>

                <div class="control-group" id="div_is_other_payment">
                    <label class="control-label">
                        Other payment terms
                    </label>
                    <div class="controls">
                        <input type="checkbox" name="po.is_other_term_of_payment"/><label for="po.is_other_term_of_payment"></label>
                    </div>
                </div>
                
                <div class="control-group" id="div_other_payment" style="display:none;">
                    <div class="controls">
                        <textarea name="po.other_term_of_payment" maxlength="1000" rows="3" class="span10 textareavertical" data-title="Other payment terms" placeholder="Other payment terms"><%=PO.other_term_of_payment%></textarea>
                        <br />
                        <small><i>Maximum other payment terms is 1,000 characters</i></small>
                    </div>
                </div>
           <%--     <div class="control-group required">
                    <label class="control-label">
                        Term of payment
                    </label>
                    <div class="controls">
                        <select name="po.term_of_payment" class="span4" data-validation="required" data-title="Term of payment"></select>
                    </div>
                </div>
                <div class="control-group required" id="div_other_payment" style="display: none;">
                    <label class="control-label">
                        Other term of payment
                    </label>
                    <div class="controls">
                        <textarea name="po.other_term_of_payment" maxlength="1000" rows="3" class="span10 textareavertical" data-title="Other term of payment" placeholder="Other term of payment"></textarea>
                        <br />
                        <small><i>Maximum other term of payment is 1,000 characters</i></small>
                    </div>
                </div>--%>
        <%--        <div class="control-group" id="div_is_sundry_po" style="display:none;">
                    <label class="control-label">
                        Is sundry supplier?
                    </label>
                    <div class="controls">
                        <input type="checkbox" name="po.is_sundry_po"/><label for="po.is_sundry_po"></label>
                    </div>
                </div>--%>
                <p class="filled info">Purchase order print out</p>
                <div class="control-group required">
                    <label class="control-label">
                        Procurement address
                    </label>
                    <div class="controls">
                        <select name="po.procurement_address" class="span4" data-validation="required" data-title="Procurement address"></select>
                    </div>
                </div>
                <div class="control-group required">
                    <label class="control-label">
                        Legal entity
                    </label>
                    <div class="controls">
                        <select name="po.legal_entity" class="span4" data-validation="required" data-title="Legal entity"></select>
                    </div>
                </div>
                <div class="control-group">
                    <div style="width: 100%; overflow-x: auto; display: block;">
                        <table id="tbItems" class="table table-bordered" style="border: 1px solid #ddd">
                            <thead>
                                <tr>
                                    <th style="width: 20%;">PR code</th>
                                    <th style="width: 20%;">RFQ code</th>
                                    <th style="width: 20%;">Quotation code</th>
                                    <th style="width: 20%;">Quotation analysis code</th>
                                    <th style="width: 20%;">Requester</th>
                                </tr>
                            </thead>
                            <tbody>
                            </tbody>
                        </table>
                        <br />
                    </div>
                </div>
                <div class="control-group">
                    <label class="control-label">
                        Total prior to discount
                    </label>
                    <div class="controls">
                        <div class="input-prepend">
                            <span class="add-on currency"></span>
                            <input type="text" name="po.gross_amount" class="span9 number" data-decimal-places="2" readonly="readonly" />
                        </div>
                    </div>
                </div>
                <div class="control-group">
                    <label class="control-label">
                        Total discount
                    </label>
                    <div class="controls">
                        <div class="input-prepend">
                            <span class="add-on currency"></span>
                            <input type="text" name="po.discount" class="span9 number" data-decimal-places="2" readonly="readonly" />
                        </div>
                    </div>
                </div>
                <div class="control-group">
                    <label class="control-label">
                        Total after discount
                    </label>
                    <div class="controls">
                        <div class="input-prepend">
                            <span class="add-on currency"></span>
                            <input type="text" name="po.total_after_discount" class="span9 number" data-decimal-places="2" readonly="readonly" />
                        </div>
                        <%=PO.exchange_sign %>&nbsp;&nbsp;&nbsp;
                        <div class="input-prepend">
                            <span class="add-on">USD</span>
                            <input type="text" name="po.gross_amount_usd" class="span9 number" data-decimal-places="2" readonly="readonly" />
                        </div>
                    </div>
                </div>

                <div class="control-group" id="totalVAT">
                    <label class="control-label">
                        Total VAT
                    </label>
                    <div class="controls">
                        <div class="input-prepend">
                            <span class="add-on currency"></span>
                            <input type="text" name="po.vat_amount" class="span9 number" data-decimal-places="2" readonly="readonly" />
                        </div>
                        <%=PO.exchange_sign %>&nbsp;&nbsp;&nbsp;
                        <div class="input-prepend">
                            <span class="add-on">USD</span>
                            <input type="text" name="po.vat_amount_usd" class="span9 number" data-decimal-places="2" readonly="readonly" />
                        </div>
                    </div>
                </div>

                <div class="control-group">
                    <label class="control-label">
                        Total amount
                    </label>
                    <div class="controls">
                        <div class="input-prepend">
                            <span class="add-on currency"></span>
                            <input type="text" name="po.total_amount" class="span9 number" data-decimal-places="2" readonly="readonly" />
                        </div>
                        <%=PO.exchange_sign %>&nbsp;&nbsp;&nbsp;
                        <div class="input-prepend">
                            <span class="add-on">USD</span>
                            <input type="text" name="po.total_amount_usd" class="span9 number" data-decimal-places="2" readonly="readonly" />
                        </div>
                    </div>
                </div>
                <div class="control-group last">
                    <div class="controls">
                        <button id="btnClose" class="btn" type="button">Close page</button>&nbsp;&nbsp;&nbsp;
                        <%  if (PO.status_id != "95")
                            { %>
                        <button id="btnSave" class="btn btn-success" type="button" data-action="saved">Save as draft</button>
                        <%  } %>
                        <%  if (!String.IsNullOrEmpty(PO.status_id) && PO.status_id != "95")
                            { %>
                        <%--<button id="btnPrint" class="btn btn-success" type="button" data-action="print">View draft PO</button>--%>
                        <%  } %>
                        <%  if (PO.status_id != "95")
                            { %>
                        <button id="btnSubmit" class="btn btn-success" type="button" data-action="submitted">Submit</button>
                        <button id="btnFundsCheck" class="btn btn-success" type="button" data-action="fundscheck">Funds check</button>
                        <%  } %>
                        <%  if (!string.IsNullOrEmpty(sn))
                            { %>
                        <%--<button id="btnSubmitApp" class="btn btn-success" type="button" data-action="resubmitted for re-approval">Submit for re-approval</button>--%>
                        <%  } %>
                        <%  if (PO.status_id == "5" || !string.IsNullOrEmpty(sn))
                            { %>
                        <button id="btnCancel" class="btn btn-danger" type="button" data-action="cancelled">Cancel this PO</button>
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
    <script type="text/javascript">
        var _id = "<%= _id %>";
        var isfundscheck = "<%= isfundscheck %>";
        var taskType = "<%=taskType%>";

        var deletedId = [];

        var btnAction = "";
        var workflow = new Object();
        var status_id = "<%=PO.status_id%>";

        var listContact = [];
        var listEmail = [];
        var listCurrency = <%=listCurrency%>;
        var listPOType = <%=listPOType%>;
        var listTransType = <%=listTransType%>;
        var listShipment = <%=listShipment%>;
        var listDeliveryTerm = <%=listDeliveryTerm%>;
        var listPeriod = <%=listPeriod%>;
        /*listShipment[0].CODE listPaymentTerm = "0";*/
        var listDeliveryAddress = <%=listDelivery%>;

        listDeliveryAddress = $.grep(listDeliveryAddress, function (n, i) {
            return n["AddressType"] == "2";
        });

        listDeliveryAddress = $.grep(listDeliveryAddress, function (n, i) {
            return n["Id"] != "23821";
        });

        var listPaymentTerm = <%=listPaymentTerm%>;
        listPaymentTerm = $.grep(listPaymentTerm, function (n, i) {
            return n["Id"] != "OTH";
        });
        var listLegalEntity = <%=listLegalEntity%>;
        var listProcurementAddress = <%=listProcurementAddress%>;
        var listTaxType = [{ id: "$" }, { id: "%" }];
        var listPayableTax = [{ id: "0", Text: "No" }, { id: "1", Text: "Yes" }];
        var listPrintableTax = [{ id: "0", Text: "No" }, { id: "1", Text: "Yes" }];
        var listTax = <%=listTax%>;
        var listProduct = <%=listProduct%>;
        var listProductGroup = <%=listProductGroup%>;

        var po_type = "<%=PO.po_type%>";
        var trans_type = "<%=PO.sun_trans_type%>";
        var shipment = "<%=PO.cifor_shipment_account%>";
        var account_period = "<%=PO.period%>";
        var delivery_term = "<%=PO.delivery_term%>";
        var delivery_address = "<%=PO.cifor_delivery_address%>";
        var vendor_cp = "<%=PO.vendor_contact_person%>";
        <%--var disc_type = "<%=Q.discount_type%>";--%>
        var tax_type = "<%=PO.tax_type%>";
        var vat = "<%=PO.tax%>";
        vat = delCommas(vat);

        var usedVS = [];
        var POHeaders = <%= POHeaders%>;
        var PODetails = <%=PODetails%>;
        var PODetailsCC = <%=PODetailsCC%>;
        var PODetailsHeader = [];
        var currency_id = "<%=PO.currency_id%>";
        var vendor = "<%=PO.vendor%>";
        var vendor_code = "<%=PO.vendor_code%>";
        var vendor_name = "";
        var ocs_supplier_id = "<%=PO.ocs_supplier_id%>";
        var PODetailSundry = "<%=PO.detail_sundry%>";
        var contact_person_sundry = "";
        var email_sundry = "";

        var tblItems = initTableItems();

        var dataVS = <%=dataVS%>;
        var VSResults = initTable();

        /*var cifor_office = -1;*/
        var cifor_office = "<%=user_office%>";

        var startDate = new Date("<%=startDate%>");
        var endDate = new Date("<%=endDate%>");
        var document_date = "<%=PO.document_date%>";

        var is_other_address = "<%=PO.is_other_address%>";
        var is_other_payment_terms = "<%=PO.is_other_term_of_payment%>";
    <%--    let is_sundry_po = "<%=PO.is_sundry_po%>";--%>

        /* taken from quotation(s) */
        var expected_delivery_date = "<%=PO.expected_delivery_date%>";
        var actual_sent_date = "<%=PO.send_date%>";
        var term_of_payment = "<%=PO.term_of_payment%>";
        var other_term_of_payment = "";
        let legal_entity = "<%=PO.legal_entity%>";
        let procurement_address = "<%=PO.procurement_address%>";
        var is_my_tree_supplier = "<%=PO.IsMyTreeSupplier%>";
        <%--let payable_vat = "<%=PO.payable_vat%>";--%>

        var isFromQA = false;
        var dataSundry = <%= listSundry %>;
        var is_sundry = false;
        var is_goods = true;
        var arrobjProduct = null;
        let objProduct = listProduct;
        let vsd = [];
        let vs_id = '';
        var fListProduct = [];
        var fListProductGroup = [];

        function initTableItems() {
            return $("#tbItems").DataTable({
                data: PODetailsHeader,
                "aoColumns": [
                    {
                        "mDataProp": "pr_id"
                        , "mRender": function (d, type, row) {
                       <%--     '<%= Page.ResolveUrl("~/" + based_url+service_url + "/GetVSItems") %>'--%>
                            /*var html = '<a href="/workspace/procurement/purchaserequisition/detail.aspx?id=' + row.pr_id + '" title="View detail Purchase requisition" target="_blank">' + row.pr_no + '</a>';*/
                            var html = '<a href="' + '<%= Page.ResolveUrl("~/" + based_url + "/PurchaseRequisition/detail.aspx?id=") %>' + row.pr_id + '" title="View detail Purchase requisition" target="_blank">' + row.pr_no + '</a>';
                            return html;
                        }
                    },
                    {
                        "mDataProp": "rfq_id"
                        , "mRender": function (d, type, row) {
                            /*var html = '<a href="/workspace/procurement/RFQ/detail.aspx?id=' + row.rfq_id + '" title="View detail RFQ" target="_blank">' + row.rfq_no + '</a>';*/
                            var html = '<a href="' + '<%= Page.ResolveUrl("~/" + based_url + "/RFQ/detail.aspx?id=") %>' + row.rfq_id + '" title="View detail RFQ" target="_blank">' + row.rfq_no + '</a>';
                            return html;
                        }
                    },
                    {
                        "mDataProp": "q_id"
                        , "mRender": function (d, type, row) {
                            /*var html = '<a href="/workspace/procurement/quotation/detail.aspx?id=' + row.q_id + '" title="View detail Quotation" target="_blank">' + row.q_no + '</a>';*/
                            var html = '<a href="' + '<%= Page.ResolveUrl("~/" + based_url + "/Quotation/Detail.aspx?id=") %>' + row.q_id + '" title="View detail Quotation" target="_blank">' + row.q_no + '</a>';
                            return html;
                        }
                    },
                    {
                        "mDataProp": "vs_no"
                        , "mRender": function (d, type, row) {
                            /*var html = '<a href="/workspace/procurement/vendorselection/detail.aspx?id=' + row.vs_id + '" title="View detail supplier selection" target="_blank">' + row.vs_no + '</a>';*/
                            var html = '<a href="' + '<%= Page.ResolveUrl("~/" + based_url + "/QuotationAnalysis/Detail.aspx?id=") %>' + row.vs_id + '" title="View detail quotation analysis" target="_blank">' + row.vs_no + '</a>';
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

        /* search form */
        function initTable() {
            return $('#VSResults').DataTable({
                data: dataVS,
                "aoColumns": [
                    {
                        "mDataProp": "id"
                        , "mRender": function (d, type, row) {
                            var html = '<input class="vs" type="checkbox" name="vs" value="' + row.id + '" data-vendor="' + row.vendor + '"  data-currency="' + row.currency_id + '" data-sundry="' + row.is_sundry + '" data-detailsundry="' + row.detail_sundry + '"/>';
                            return html;
                        }
                        , "width": "2%"
                    },
                    {
                        "mDataProp": "rfq_no"
                        , "mRender": function (d, type, row) {
                            /*var html = '<a href="/workspace/procurement/vendorselection/detail.aspx?id=' + row.id + '" title="View detail" target="_blank">' + row.vs_no + '</a>';*/
                            var html = '<a href="' + '<%= Page.ResolveUrl("~/" + based_url + "/QuotationAnalysis/Detail.aspx?id=") %>' + row.id + '" title="View detail" target="_blank">' + row.vs_no + '</a>';
                            return html;
                        }
                        , "width": "20%"
                    },
                    { "mDataProp": "created_date", "width": "20%" },
                    { "mDataProp": "vendor_name", "width": "40%" },
                    { "mDataProp": "office_name", "width": "18%" },
                ],
                "bFilter": true, "bDestroy": true, "bRetrieve": true, "pagingType": 'full_numbers',
                "iDisplayLength": 5
                , "bLengthChange": false
                , "searching": true,
                "info": false,
                "columnDefs": [{
                    "targets": [0],
                    "orderable": false,
                }],
                "aaSorting": [[2, "asc"]],
            });
        }

        $(document).on("click", "#btnVS", function () {
            $("#checkAllVS").prop("checked", false);
            $("#VSForm").modal("show");
            $("#vsform-error-box").hide();
            loadSearch();
        });

        $(document).on("click", "#btnRefresh", function () {
            loadSearch();
        });

        function loadSearch() {
            var startDate = $("#startDate").data("date");
            var endDate = $("#endDate").data("date");
            var status = "25,30";

            var data = new Object();
            data.startDate = startDate;
            data.endDate = endDate;
            data.status = status;
            data.cifor_office = cifor_office;
            data.usedVS = usedVS.join(";");

            dataVS = null;

            $("#VSResults tbody tr").html("processing..");
            $.ajax({
                /*url: '/Workspace/Procurement/Service.aspx/GetVSList',*/
                url: '<%= Page.ResolveUrl("~/" + based_url+service_url + "/GetVSList") %>',
                data: JSON.stringify(data),
                dataType: 'json',
                type: 'post',
                contentType: "application/json; charset=utf-8",
                success: function (response) {
                    /*dataVS = JSON.parse(response.d);*/
                    dataVS = [...new Map(JSON.parse(response.d).map(item => [item['id'], item])).values()];
                    //dataVS = $.grep(dataVS, function (n, i) {
                    //    return n["is_singlesourcing"] == 0;
                    //});
                    VSResults.clear().draw();
                    VSResults.rows.add(dataVS).draw();
                }
            });
        }

        $(document).on("click", "#btnSelectVS", function () {
            var selectedVS = [];
            $(".vs:checkbox:checked").each(function () {
                var _v = new Object();
                _v.val = $(this).val();
                _v.currency_id = $(this).data("currency");
                _v.vendor = $(this).data("vendor");
                _v.sundry = $(this).data("sundry");
                _v.detail_sundry = $(this).data("detailsundry");
                /*_v.IsMyTreeSupplier = $(this).data("IsMyTreeSupplier");*/
                selectedVS.push(_v);
            });
            selectVS(selectedVS);
        });

        function selectVS(selectedVS) {
            $("#vsform-error-box").hide();

            var _currency_id = currency_id;
            var _vendor_id = vendor;
            let isMyTreeSupplier = '';
            var _PODetailSundry = PODetailSundry;
            var errCurr = 0, errVendor = 0, errSundry = 0;
            var vs_ids = [];

            $.each(selectedVS, function (i, d) {
                if (_currency_id === "") {
                    _currency_id = d.currency_id;
                }

                if (_currency_id != d.currency_id) {
                    errCurr++;
                }

                if (_vendor_id === "" || _vendor_id == "0") {
                    _vendor_id = d.vendor;
                }

                if (_vendor_id != d.vendor) {
                    errVendor++;
                }

                if (d.sundry) {
                    if (_PODetailSundry === "" || _PODetailSundry.length == 0) {
                        _PODetailSundry = d.detail_sundry;
                    }

                    if (_PODetailSundry != d.detail_sundry) {
                        errSundry++;
                    }
                }
                vs_ids.push(d.val);
            });

            var errorMsg = "";

            if (selectedVS.length == 0) {
                errorMsg += "<br/>- Quotation analysis is required.";
            }
            if (errCurr > 0) {
                errorMsg += "<br/>- Cannot combine quotation analysis with different currency.";
            }
            if (errVendor > 0) {
                errorMsg += "<br/>- Cannot combine quotation analysis with different selected supplier.";
            }

            if (errSundry > 0) {
                errorMsg += "<br/>- Cannot combine quotation analysis with different detail sundry."
            }

            if (_vendor_id == "0") {
                errorMsg += "<br/>- Quotation analysis doesn't have a selected supplier."
            }

            if (errorMsg !== "") {
                errorMsg = "Please correct the following error(s):" + errorMsg;

                $("#vsform-error-message").html("<b>" + errorMsg + "<b>");
                $("#vsform-error-box").show();
                $('.modal-body').animate({ scrollTop: 0 }, 500);
            }
            else {
                currency_id = _currency_id;
                vendor = _vendor_id;
                PODetailSundry = _PODetailSundry;
                vs_ids = unique(vs_ids);

                $("[name='po.currency_id']").val(currency_id);
                var arr = $.grep(listCurrency, function (n, i) {
                    return n["CURRENCY_CODE"] == currency_id;
                });
                if (arr.length > 0) {
                    $("[name='po.exchange_sign']").val(arr[0].OPERATOR);
                    $("[name='po.exchange_rate']").val(arr[0].RATE);
                }

                var _o = [];

                $.each(vs_ids, function (i, vs_id) {
                    var _data = $.grep(dataVS, function (n, i) {
                        return n["id"] == vs_id;
                    })

                    if (_data.length > 0) {
                        var o = new Object();
                        o.id = _data[0].id;
                        o.uid = guid();
                        o.vs_no = _data[0].vs_no;
                        o.vendor = _data[0].vendor;
                        o.vendor_code = _data[0].vendor_code;
                        o.vendor_name = _data[0].vendor_name;
                        o.vendor_account_code = _data[0].vendor_account_code;
                        o.currency_id = _data[0].currency_id;
                        o.is_sundry = _data[0].is_sundry;
                        o.ocs_supplier_id = _data[0].ocs_supplier_id;
                        o.ocs_supplier_code = _data[0].ocs_supplier_code;
                        o.ocs_supplier_name = _data[0].ocs_supplier_name;
                        _o.push(o);

                        vendor_code = _data[0].vendor_code;
                        vendor_name = _data[0].vendor_name;
                        isMyTreeSupplier = _data[0].IsMyTreeSupplier;
                        is_my_tree_supplier = isMyTreeSupplier;
                        ocs_supplier_id = _data[0].ocs_supplier_id;
                        if (_data[0].is_sundry) {
                            listContact = [{ id: _data[0].contact_person_sundry, name: _data[0].contact_person_sundry, email: _data[0].email_sundry }];
                        }
                    }
                });

                _o = unique(_o);

                $("[name='po.vendor']").val(vendor);
                $("[name='po.vendor_code']").val(vendor_code);
                $("[name='po.vendor_name']").val(vendor_name);



                SetTaxType();
                populateVSTable(_o);
                populateUsedVS();
                populateCurrency();

                vs_ids = vs_ids.join(";");
                GetVSItems(vs_ids)
                    .then(populateVendorContact)
                    .then(populateVendorTax)
                    .then(populateTotal);

                //if (isMyTreeSupplier == true) {
                //    let errorMsgCheckSupplier = CheckSupplier(vendor);
                //    if (errorMsgCheckSupplier != '' && errorMsgCheckSupplier != null) {
                //        $("#div_is_sundry_po").css("display", "block");
                //    }
                //}


                $("#VSForm").modal("hide");
            }
        }

        function GetVSItems(vs_ids) {
            var d = new Object();
            d.vs_ids = vs_ids;

            return $.ajax({
                /*url: '/Workspace/Procurement/Service.aspx/GetVSItems',*/
                url: '<%= Page.ResolveUrl("~/" + based_url+service_url + "/GetVSItems") %>',
                data: JSON.stringify(d),
                dataType: 'json',
                type: 'post',
                contentType: "application/json; charset=utf-8",
                success: function (response) {
                    isFromQA = true;
                    var data = JSON.parse(response.d);
                    var exD = [], pTerms = [], pOtherTerms = [];
                    var difPR = false;

                    $.each(data, function (i, d) {
                        d.unique_id = d.vs_id + ";" + d.vs_no + ";" + d.q_no + ";" + d.q_id + ";" + d.rfq_no + ";" + d.rfq_id + ";" + d.pr_no + ";" + d.pr_id;
                        d.uid = guid();
                        d.status_id = 25;
                        d.vat_amount = 0;
                        d.vat_amount_unit = 0;
                        /*d.vat_payable = false;*/
                        d.vat_percentage = 0;

                        exD.push(d.expected_delivery_date);
                        pTerms.push(d.term_of_payment);
                        pOtherTerms.push(d.other_term_of_payment);
                        $("[name='po.cifor_office_id']").val(d.cifor_office_id);
                        $("[name='po.exchange_sign']").val(d.exchange_sign);
                        $("[name='po.exchange_rate']").val(d.exchange_rate);
                        PODetails.push(d);

                        if (d.pr_id !== data[0]['pr_id']) {
                            difPR = true;
                        }
                    });

                    exD.sort(function (a, b) { return new Date(a) - new Date(b) });
                    if (expected_delivery_date == "") {
                        expected_delivery_date = new Date(exD[0]);
                        $("#expected_delivery_date").datepicker("setDate", expected_delivery_date).trigger("changeDate");
                    }
                    var _term = "";                     
                         _term = unique(pTerms);
                      
                        //hanya bisa populate jika, vs memiliki 1 quotation.
                        if (_term.length == 1 ) {
                            term_of_payment = _term.join("; ");
                            //$("[name='po.term_of_payment']").val(term_of_payment);

                        if (term_of_payment.toLowerCase() == "oth") {
                            var _otherterm = unique(pOtherTerms);
                            other_term_of_payment = _otherterm.join("; ");
                            $("[name='po.other_term_of_payment']").val(other_term_of_payment);
                        }
                    }


                    PODetailsCC = [];

                    $.each(data, function (i, d) {
                        var _itemDetailTemp = new Object();
                        _itemDetailTemp["CostCenterName"] = d.CostCenterName;
                        _itemDetailTemp["Description"] = d.prccDescription;
                        _itemDetailTemp["exchange_rate"] = $("[name='po.exchange_rate']").val();
                        _itemDetailTemp["amount"] = d.amount;
                        _itemDetailTemp["amount_usd"] = d.amount_usd;
                        _itemDetailTemp["amount_usd_vat"] = 0;
                        _itemDetailTemp["amount_vat"] = 0;
                        _itemDetailTemp["control_account"] = d.control_account;
                        _itemDetailTemp["cost_center_id"] = d.cost_center_id;
                        _itemDetailTemp["entity_id"] = d.entity_id;
                        _itemDetailTemp["entitydesc"] = d.entitydesc;
                        _itemDetailTemp["id"] = '';
                        _itemDetailTemp["is_active"] = '';
                        _itemDetailTemp["legal_entity"] = d.legal_entity;
                        _itemDetailTemp["percentage"] = d.percentage;
                        _itemDetailTemp["pr_detail_id"] = d.pr_detail_id;
                        _itemDetailTemp["pr_detail_cost_center_id"] = d.pr_detail_cost_center_id;
                        _itemDetailTemp["purchase_order"] = '';
                        _itemDetailTemp["purchase_order_detail_id"] = '';
                        _itemDetailTemp["remarks"] = d.remarks;
                        _itemDetailTemp["sequence_no"] = '';
                        _itemDetailTemp["vs_detail_id"] = d.vs_detail_id;
                        _itemDetailTemp["vendor_selection_detail_cost_center_id"] = d.vs_cost_centers_detail_id;
                        _itemDetailTemp["work_order"] = d.work_order;
                        PODetailsCC.push(_itemDetailTemp);
                    });

                    //PODetailsCC = [...new Map(PODetailsCC.map(item => [item['vs_detail_id'], item])).values()];

                    populateHeaderItem();

                    //var cboEmail = $("select[name='po.email']");
                    //cboEmail.empty();
                    //generateCombo(cboEmail, listEmail, "Id", "Id", true);
                    //$(cboEmail).val(data[0]['email']).change();
                    //Select2Obj(cboEmail, "Email");

                    var cboPeriod = $("select[name='po.period']");
                    cboPeriod.empty();
                    generateCombo(cboPeriod, listPeriod, "Id", "Id", true);
                    $(cboPeriod).val(listPeriod[0].Id).change();
                    Select2Obj(cboPeriod, "Period");

                    var cboShipment = $("select[name='po.cifor_shipment_account']");
                    cboShipment.empty();
                    generateCombo(cboShipment, listShipment, "CODE", "NAME", true);
                    Select2Obj(cboShipment, "Delivery method");

                    var cboDeliveryTerm = $("select[name='po.delivery_term']");
                    cboDeliveryTerm.empty();
                    generateCombo(cboDeliveryTerm, listDeliveryTerm, "CODE", "NAME", true);
                    Select2Obj(cboDeliveryTerm, "Delivery term");

                    var cboDelivery = $("select[name='po.cifor_delivery_address']");
                    cboDelivery.empty();
                    generateCombo(cboDelivery, listDeliveryAddress, "Id", "Address", true);
                    if (!difPR) {
                        //$(cboDelivery).val(data[0]['delivery_address']).change();
                    }
                    Select2Obj(cboDelivery, "Delivery address");

                    var cboPaymentTerm = $("select[name='po.term_of_payment']");
                    cboPaymentTerm.empty();
                    generateCombo(cboPaymentTerm, listPaymentTerm, "Id", "Name", true);
                    if (_term.length == 1) {
                        term_of_payment = _term.join("; ");
                        //$(cboPaymentTerm).val(term_of_payment).change();
                    }

                    Select2Obj(cboPaymentTerm, "Payment terms");

                    let cboTaxType = $("select[name='po.tax_type']");
                    generateCombo(cboTaxType, listTax, "Id", "Name", true);
                    Select2Obj(cboTaxType, "Type");
                    populateTaxType($("[name='po.tax_type']").val());

                    let cboPayableTax = $("select[name='po.payable_tax']");
                    generateCombo(cboPayableTax, listPayableTax, "id", "Text", true);
                    Select2Obj(cboPayableTax, "Select");

                    let cboPrintableTax = $("select[name='po.printable_tax']");
                    generateCombo(cboPrintableTax, listPrintableTax, "id", "Text", true);
                    Select2Obj(cboPrintableTax, "Select");
                }
            });
        }

        function populateVSTable(data) {
            var sn = $("#sn").val();
            data = [...new Map(data.map(item => [item['vs_no'], item])).values()];
            $.each(data, function (i, d) {
                var html = "";
                html += '<tr id="' + d.uid + '">';
                /*html += '<td><input type="hidden" name="vs_id" value="' + d.id + '"/><a href="/workspace/procurement/vendorselection/detail.aspx?id=' + d.id + '" target="_blank">' + d.vs_no + '</a></td>';*/
                html += '<td><input type="hidden" name="vs_id" value="' + d.id + '"/><a href="' + '<%= Page.ResolveUrl("~/" + based_url + "/QuotationAnalysis/Detail.aspx?id=") %>' + d.id + '" target="_blank">' + d.vs_no + '</a></td>';

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
                /*html += '<td><a href="/workspace/procurement/businesspartner/detail.aspx?id=' + d.vendor + '" target="_blank">' + d.vendor_name + '</a></td>';*/
                <%--html += '<td><a href="' + '<%= Page.ResolveUrl("~/" + based_url + "/BusinessPartner/Detail.aspx?id=") %>' + d.vendor + '" target="_blank">' + d.vendor_name + '</a></td>';--%>

                if (d.is_sundry == "1") {
                    is_sundry = true;
                    const regexExp = /^[0-9a-fA-F]{8}\b-[0-9a-fA-F]{4}\b-[0-9a-fA-F]{4}\b-[0-9a-fA-F]{4}\b-[0-9a-fA-F]{12}$/gi;
                    var pod_id = '';
                    if (!regexExp.test(d.uid)) {
                        pod_id = d.pod_id;
                    } else {
                        pod_id = d.uid;
                    }
                    //set sundry name additional
                    var obj = new Object();
                    obj.id = d.id;
                    obj.pod_id = pod_id;
                    obj.vendor_name = vendor_name;
                    getSundryDetail(obj);
                    html += '<td id="supplier_name_' + pod_id + '">';
                } else {
                    is_sundry = false;
                    html += '<td>' + supplier_name;
                }
                html += '</td > ';
                /*html += '<td>' + d.vendor_account_code + '</td>';*/
                /*   html += '<td>' + d.currency_id + '</td>';*/
                if (sn == "") {
                    html += '<td><span class="label red btnDelete"><i class="icon-trash delete" style="opacity: 1;"></i></span></td>';
                }
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
                //d.vat_amount = 0;
                //d.vat_amount_unit = 0;
                //d.vat_payable = false;
                //d.vat_percentage = 0;
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

                    PODetailsHeader.push(obj);
                }
            });
            tblItems.clear().draw();
            tblItems.rows.add(PODetailsHeader).draw();
        }

        $(document).ready(function () {
            populateHeader();
            if ($("#sn").val() != "") {
                $("#btnVS").hide();
                $("[name='po.po_type']").prop("disabled", true);
            }

            //if (is_sundry_po == 1) {
            //    $("[name='po.is_sundry_po']").prop("checked", true);
            //}

            //if (is_my_tree_supplier == "True") {
            //    let errorMsgCheckSupplier = CheckSupplier(vendor_code);
            //    if (errorMsgCheckSupplier != '' && errorMsgCheckSupplier != null) {
            //        $("#div_is_sundry_po").css("display", "block");
            //    }
            //}
            if (status_id == 25) {
                $("#divSUNPO").show();
            } else {
                $("#divSUNPO").hide();
            }

            $("[name='po.vendor']").val(vendor);
            $("[name='po.tax']").val(vat);
            $("[name='po.vendor_code']").val(vendor_code);
            $("[name='po.vendor_name']").val(vendor_name);
            /* VS form */
            $("#startDate").datepicker({
                format: "dd M yyyy"
                , autoclose: true
            }).on("changeDate", function () {
                $("#_startDate").val($("#startDate").data("date"));
                $("#startDate").datepicker("hide");
                startDate = new Date($("#startDate").data("date"));
                $('#endDate').datepicker('setStartDate', (startDate.getDate().toString().length < 2 ? '0' + startDate.getDate() : startDate.getDate()) + ' ' + ((startDate.getMonth() + 1).toString().length < 2 ? '0' + (startDate.getMonth() + 1) : (startDate.getMonth() + 1)) + ' ' + startDate.getFullYear());
                if (CheckFilterStartEndDate(new Date(startDate), new Date(endDate)) == false) {
                    endDate = new Date($("#startDate").data("date"));
                    $("#_endDate").val($("#startDate").data("date"));
                    $("#endDate").datepicker("setDate", endDate).trigger("changeDate");
                }
            });

            $("#endDate").datepicker({
                format: "dd M yyyy"
                , autoclose: true
                , startDate: (startDate.getDate().toString().length < 2 ? '0' + startDate.getDate() : startDate.getDate()) + ' ' + ((startDate.getMonth() + 1).toString().length < 2 ? '0' + (startDate.getMonth() + 1) : (startDate.getMonth() + 1)) + ' ' + startDate.getFullYear()
            }).on("changeDate", function () {
                $("#_endDate").val($("#endDate").data("date"));
                $("#endDate").datepicker("hide");
                endDate = new Date($("#endDate").data("date"));
            });

            $("#startDate").datepicker("setDate", startDate).trigger("changeDate");
            $("#endDate").datepicker("setDate", endDate).trigger("changeDate");
            /* end of VS form */
            $("#document_date").datepicker({
                format: "dd M yyyy"
                , autoclose: true
            }).on("changeDate", function () {
                $("#_document_date").val($("#document_date").data("date"));
                $("#document_date").datepicker("hide");
            });

            if (document_date != "") {
                document_date = new Date(document_date);
                $("#document_date").datepicker("setDate", document_date).trigger("changeDate");
            }

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

            $("#actual_sent_date").datepicker({
                format: "dd M yyyy"
                , autoclose: true
            }).on("changeDate", function () {
                $("#_actual_sent_date").val($("#actual_sent_date").data("date"));
                $("#actual_sent_date").datepicker("hide");
            });

            if (actual_sent_date != "") {
                actual_sent_date = new Date(actual_sent_date);
                $("#actual_sent_date").datepicker("setDate", actual_sent_date).trigger("changeDate");
            }

            var cboContactPerson = $("select[name='po.vendor_contact_person']");
            Select2Obj(cboContactPerson, "Contact person");

            var cboPayableVat = $("select[name='po.payable_vat']");
            /*   $(cboPayableVat).val(payable_vat);*/
            Select2Obj($("select[name='po.payable_vat']"), "VAT Payable");

            var cboPOType = $("select[name='po.po_type']");
            generateCombo(cboPOType, listPOType, "ID", "NAME", true);
            $(cboPOType).val(po_type);
            Select2Obj(cboPOType, "PO type");

            var cboPrefix = $("select[name='po.sun_trans_type']");
            generateCombo(cboPrefix, listTransType, "ID", "NAME", true);
            $(cboPrefix).val(trans_type);
            Select2Obj(cboPrefix, "PO prefix");
            $(cboPrefix).on("select2:select", function (e) {
                var id = $(this).val();
                var arr = $.grep(listTransType, function (n, i) {
                    return n["ID"] == id;
                });
                if (arr.length > 0) {
                    $("[name='po.po_prefix']").val(arr[0].PREFIX);
                }
            });

            var cboShipment = $("select[name='po.cifor_shipment_account']");
            generateCombo(cboShipment, listShipment, "CODE", "NAME", true);
            $(cboShipment).val(shipment);
            Select2Obj(cboShipment, "Delivery method");

            var cboDeliveryTerm = $("select[name='po.delivery_term']");
            generateCombo(cboDeliveryTerm, listDeliveryTerm, "CODE", "NAME", true);
            $(cboDeliveryTerm).val(delivery_term);
            Select2Obj(cboDeliveryTerm, "Delivery term");

            var cboEmail = $("select[name='po.email']");
            cboEmail.empty();
            generateCombo(cboEmail, listEmail, "Id", "Id", true);
            /*$(cboEmail).val(listEmail[0].Id).change();*/
            Select2Obj(cboEmail, "Email");

            var cboPeriod = $("select[name='po.period']");
            generateCombo(cboPeriod, listPeriod, "Id", "Id", true);
            if (account_period != '' && account_period != null) {
                $(cboPeriod).val(account_period);
            } else {
                $(cboPeriod).val(listPeriod[0].Id).change();
            }
            /*$(cboPeriod).val((account_period != null ? account_period : listPeriod[0].Id));*/
            Select2Obj(cboPeriod, "Period");

            var cboDelivery = $("select[name='po.cifor_delivery_address']");
            generateCombo(cboDelivery, listDeliveryAddress, "Id", "Address", true);
            $(cboDelivery).val(delivery_address).change();
            Select2Obj(cboDelivery, "Delivery address");


            //payment term
            var cboPaymentTerm = $("select[name='po.term_of_payment']");
            generateCombo(cboPaymentTerm, listPaymentTerm, "Id", "Name", true);
            $(cboPaymentTerm).val(term_of_payment).change();
            Select2Obj(cboPaymentTerm, "Payment terms");

            var cboLegalEntity = $("select[name='po.legal_entity']");
            generateCombo(cboLegalEntity, listLegalEntity, "Id", "Name", true);
            $(cboLegalEntity).val(legal_entity).change();
            Select2Obj(cboLegalEntity, "Legal entity");

            var cboProcurementAddress = $("select[name='po.procurement_address']");
            generateCombo(cboProcurementAddress, listProcurementAddress, "AddressId", "address", true);
            $(cboProcurementAddress).val(procurement_address).change();
            Select2Obj(cboProcurementAddress, "Procurement address");

            if (term_of_payment.toLowerCase() == "oth") {
                $("[name='po.other_term_of_payment']").val(other_term_of_payment);
            }
            //end payment term

            //var cboTaxType = $("select[name='po.tax_type']");
            //generateCombo(cboTaxType, listTaxType, "id", "id", false);
            //$(cboTaxType).val(tax_type);
            //Select2Obj(cboTaxType, "Type");

            if (is_other_address == 1) {
                $("[name='po.is_other_address']").prop("checked", true);
                checkOtherAddress(true);
            } else {
                checkOtherAddress(false);
            }

            var cboVAT = $("select[name='po.tax']");
            $(cboVAT).val(vat);
            Select2Obj(cboVAT, "VAT");
            $(cboVAT).on("select2:select", function (e) {
                calculateTax();
            });

            $(cboTaxType).on('select2:select', function (e) {
                populateTaxType($(this).val());
            });


            populateVSTable(dataVS);
            populateUsedVS();

            if (_id != "" && is_sundry == true) {
                var _data = dataVS;

                if (_data.length > 0) {
                    if (_data[0].is_sundry) {
                        listContact = [{ id: _data[0].contact_person_sundry, name: _data[0].contact_person_sundry, email: _data[0].email_sundry }];
                    }
                }
            }

            populateVendorContact()

            populateCurrency();
            populateHeaderItem();

            populateAmtVATChargeCode();

            populateTotal();
            repopulateNumber();
            var cboTaxType = $("select[name='po.tax_type']");
            generateCombo(cboTaxType, listTax, "Id", "Name", true);
            Select2Obj(cboTaxType, "Type");
            populateTaxType($("[name='po.tax_type']").val());


            let cboPayableTax = $("select[name='po.payable_tax']");
            generateCombo(cboPayableTax, listPayableTax, "id", "Text", true);
            Select2Obj(cboPayableTax, "Select");

            let cboPrintableTax = $("select[name='po.printable_tax']");
            generateCombo(cboPrintableTax, listPrintableTax, "id", "Text", true);
            Select2Obj(cboPrintableTax, "Select");


            SetTaxType();
            //$(cboTaxType).val(tax_type).change();

            if (isfundscheck == "1") {
                btnAction = 'fundscheck';
                let errorMsgFC = '';

                sleep(1).then(() => {
                    //GetDataProduct();
                    GetVSPRData();
                });

                sleep(300).then(() => {
                    errorMsgFC += FundsCheck(PODetailsCC, errorMsgFC);
                    if (errorMsgFC !== "") {
                        unBlockScreenOL();
                        showErrorMessage(errorMsgFC);
                    } else {
                        alert('Budget is sufficient');
                    }
                    isfundscheck = '0';
                }).then(() => {
                });

            }

            if (is_other_payment_terms == 1) {
                $("[name='po.is_other_term_of_payment']").prop("checked", true);
                checkOtherPayment(true);
            } else {
                checkOtherPayment(false);
            }

            if (is_other_payment_terms == 1) {
                $("[name='po.is_other_term_of_payment']").prop("checked", true);
                checkOtherPayment(true);
            } else {
                checkOtherPayment(false);
            }
        });

        $(document).on("click", "#checkAllVS", function () {
            $(".vs").prop("checked", $(this).is(":checked"));
        });

        $(document).on("click", ".vs", function () {
            if (!$(this).is(":checked")) {
                $("#checkAllVS").prop("checked", $(this).is(":checked"));
            }
        });

        function showItemDetail(d) {
            var html = '';
            if (typeof d !== "undefined") {
                html = '<table class="table table-bordered" style="border: 1px solid #ddd"><thead>';
                html += '<tr>';
                html += '<th style="width:7%;">Product code</th>';
                /*      html += '<th style="width:20%;">Product description</th>';*/
                html += '<th style="width:20%;">Product description</th>';
                html += '<th>Quantity</th>';
                html += '<th>UOM</th>';
                html += '<th>Currency</th>';
                html += '<th style="text-align:right;">Unit price</th>';
                html += '<th style="text-align:right;">Discount</th>';
                html += '<th style="text-align:right;">Additional discount</th>';
                html += '<th style="text-align:right;">Sub total</th>';
                html += '<th class="required">VAT</th>';
                /*html += '<th style="text-align:right;" class="required">VAT payable?</th>';*/
                /*html += '<th style="text-align:right;" class="required">VAT printable?</th>';*/
                html += '<th style="text-align:right;">VAT amount per unit</th>';
                html += '<th style="text-align:right;">Total VAT Amount</th>';
                html += '<th>Total</th>';
                /*  html += '<th>Cost center & T4</th>';*/
                html += '</tr>';
                html += '</thead><tbody>';

                if ($("input[name='doc_id']").val() == "") {
                    var item = $.grep([...new Map(PODetails.map(item =>
                        [item.pr_detail_id, item])).values()], function (n, i) {
                            return n["unique_id"] == d.unique_id;
                        });
                } else {
                    //var item = $.grep(PODetails, function (n, i) {
                    //    return n["unique_id"] == d.unique_id;
                    //});
                    var item = $.grep([...new Map(PODetails.map(item =>
                        [item.pr_detail_id, item])).values()], function (n, i) {
                            return n["unique_id"] == d.unique_id;
                        });
                }

                //var item = $.grep([...new Map(PODetails.map(item =>
                //    [item.pr_detail_id, item])).values()], function (n, i) {
                //    return n["unique_id"] == d.unique_id;
                //});



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

                $.each(item, function (i, x) {
                    fListProduct = listProduct.filter(i => i.Id == x.item_code);
                    fListProductGroup = listProductGroup.filter(i => i.Id == fListProduct[0].ProductGroupId);

                    if (is_goods == true) {
                        if (fListProductGroup[0].IsGoods == 0) {
                            is_goods = false;
                        }
                    }                    

                    $("[name='po.is_goods']").val(is_goods == true ? "1" : "0");

                    html += '<tr>';
                    <%--html += '<td><a href="' + '<%= Page.ResolveUrl("~/" + based_url + "/item/Detail.aspx?id=") %>' + x.item_id + '" target="_blank" title="View detail Item">' + x.item_code + '</a></td>';--%>
                    html += '<td>' + x.item_code + '</td>';
                    /* html += '<td>' + x.item_description + '</td>';*/
                    /*html += '<td>' + x.quotation_description + '</td>';*/
                    html += '<td><textarea name="item.description" maxlength="900" rows="4" class="span12 textareavertical" data-title="Product description" data-type=' + x.vs_detail_id + ' placeholder="Quotation description">' + x.quotation_description + '</textarea></td>';
                    html += '<td style="text-align:right;" class="item_quantity">' + accounting.formatNumber(x.quantity, 2) + '</td>';
                    html += '<td>' + x.uom_name + '</td>';
                    html += '<td>' + x.currency_id + '</td>';
                    html += '<td style="text-align:right;" class="item_unit_price">' + accounting.formatNumber(x.unit_price, 2) + '</td>';
                    html += '<td style="text-align:right;">' + accounting.formatNumber(x.discount, 2) + '</td>';
                    html += '<td style="text-align:right;" class="item_additional_discount">' + accounting.formatNumber(x.additional_discount, 2) + '</td>';
                    html += '<td style="text-align:right;" class="item_line_total">' + accounting.formatNumber(x.line_total, 2) + '</td>';
                    
                    /*html += '<td><select name="po.tax_type" style="width:2px !important;" onchange="calculateVATpercentage(this,' + x.vs_detail_id + ')" id=vat_type_' + x.vs_detail_id + '></select><input type="text" data-validation="required" name="item.vat_percentage" value="' + accounting.formatNumber(x.vat, 2) + '" data-maximum-attr="vat_percentage" data-maximum="" class="span7 number" maxlength="18" data-decimal-places="2" style="margin-left:10px;" onchange="calculateVATpercentage(this,' + x.vs_detail_id + ')"/></td >';*/
                    html += '<td style="line-height:10px;"><select name="po.tax_type" data-validation="required" data-title="VAT code" onchange="calculateVATpercentage(this,' + x.vs_detail_id + ')" id=vat_type_' + x.vs_detail_id + '></select><br/><br/><div class="span8"><div style="margin-top:7px;"><label>VAT Payable ?</label></div></div><div class="span3" style="margin-bottom:10px;"><div><select style="width:30px !important;" data-validation="required" data-title="VAT Payable" style="margin-top:20px;" name="po.payable_tax" onchange="PayableChange(this,' + x.vs_detail_id + ')" id=chkVATpercentage_' + x.vs_detail_id + '></select></div></div><br/><br/><div class="span8"><div style="margin-top:5px;"><label>VAT Printable ?</label></div></div><div class="span3"><div><select style="width:30px !important;" data-validation="required" data-title="VAT Printable" name="po.printable_tax" onchange="PrintableChange(this,' + x.vs_detail_id + ')" id=chkVATprintable_' + x.vs_detail_id + '></select></div></div></td >';
                    /*html += '<td style="text-align:center;"><select data-validation="required" data-title="VAT Payable" style="width:90px !important;" name="po.payable_tax" onchange="PayableChange(this,' + x.vs_detail_id + ')" id=chkVATpercentage_' + x.vs_detail_id + '></select></td>';*/
                    /*html += '<td style="text-align:center;"><select data-validation="required" data-title="VAT Printable" style="width:90px !important;" name="po.printable_tax" onchange="PrintableChange(this,' + x.vs_detail_id + ')" id=chkVATprintable_' + x.vs_detail_id + '></select></td>';*/
                    html += '<td style="text-align:right;" class="item_vat_amt_unit" id=item.VATamtUnit_' + x.vs_detail_id + '>' + accounting.formatNumber(x.vat_amount / x.quantity, 2) + '</td>';
                    html += '<td style="text-align:right;" class="item_vat_amt">' + accounting.formatNumber(x.vat_amount, 2) + '</td>';
                    //if (x.vat_payable == true) {
                    //    /*html += '<td style="text-align:center;"><input type="checkbox" name="checkPO" id=chkVATpercentage_' + x.vs_detail_id + ' data-pr="' + x.vs_detail_id + '" onchange="PayableChange(this,' + x.vs_detail_id + ')" checked/></td>';*/
                    //    html += '<td style="text-align:center;"><select name="po.payable_tax" style="width:2px !important;" onchange="PayableChange(this,' + x.vs_detail_id + ')" id=chkVATpercentage_' + x.vs_detail_id + '></select></td>';
                    //} else {
                    //    html += '<td style="text-align:center;"><input type="checkbox" name="checkPO" id=chkVATpercentage_' + x.vs_detail_id + ' data-pr="' + x.vs_detail_id + '" onchange="PayableChange(this,' + x.vs_detail_id + ')"/></td>';
                    //}
                    if (x.vat_payable == true) {
                        html += '<td style="text-align:right;" class="item_total">' + accounting.formatNumber((x.line_total + x.vat_amount) - x.additional_discount, 2) + '</td>';
                    } else {
                        html += '<td style="text-align:right;" class="item_total">' + accounting.formatNumber(x.line_total - x.additional_discount, 2) + '</td>';
                    }

                    /*  html += '<td>' + x.cost_center_id + ' / ' + x.t4 + '</td>';*/
                    html += '</tr>';
                    //[...new Map(PODetailsCC.map(item => [item['vs_detail_id'], item])).values()];
                    var strChargeCode = "";
                    //var PODetailsCCTemp = [...new Map(PODetailsCC.map(item => [item['vs_detail_id'], item])).values()];
                    var PODetailsCCTemp = $.grep(PODetailsCC, function (n, i) {
                        return n["vs_detail_id"] == x.vs_detail_id;
                    })

                    $.each(PODetailsCCTemp, function (i, dc) {
                        strChargeCode += '<tr>';
                        strChargeCode += '<td style=" width: 10%;" class="pCostCenters">' + dc.cost_center_id + ' - ' + dc.CostCenterName + '</td>';
                        strChargeCode += '<td style="width: 20%;" class="pCostCentersWorkOrder">' + dc.work_order + ' - ' + dc.Description + '</td>';
                        strChargeCode += '<td style="width: 10%;" class="pCostCentersEntity">' + dc.entitydesc + '</td>';
                        strChargeCode += '<td style="width: 5%;">' + dc.legal_entity + '</td>';
                        strChargeCode += '<td style="display: none; width: 5%;">' + dc.control_account + '</td>';
                        strChargeCode += '<td style=" width: 5%; text-align:right;" class="pCostCentersValue">' + accounting.formatNumber(dc.percentage, 2) + '</td>';
                        strChargeCode += '<td style="width: 11%; text-align:right;" class="pCostCentersAmt" id="pCostCentersAmt_' + (dc.id == '' ? i.toString() : dc.id) + '">' + accounting.formatNumber(parseFloat(dc.amount), 2) + '</td>';
                        strChargeCode += '<td style="width: 11%; text-align:right; display:none;" class="pCostCentersVat" id="pCostCentersAmtVat_' + (dc.id == '' ? i.toString() : dc.id) + '">' + accounting.formatNumber(parseFloat(dc.amount_vat), 2) + '</td>';
                        strChargeCode += '<td style="width: 11%; text-align:right; display:none;" class="pCostCentersVatUSD" id="pCostCentersAmtVatUSD_' + (dc.id == '' ? i.toString() : dc.id) + '">' + accounting.formatNumber(parseFloat(dc.amount_vat_usd), 2) + '</td>';
                        strChargeCode += '<td style="width: 11%; text-align:right;" class="pCostCentersUSDAmt" id="pCostCentersUSDAmt_' + (dc.id == '' ? i.toString() : dc.id) + '">' + accounting.formatNumber(parseFloat(dc.amount_usd), 2) + '</td>';
                        strChargeCode += '<td style="width: 20%;">' + dc.remarks + '</td>';
                        strChargeCode += '</tr>';
                    });

                    html += '<tr id="trr' + x.id + '">';
                    html += '<td class="hiddenRow" colspan="15" style="padding:0px;">';
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
                    html += '<th style=" width: 11%; text-align:left; display:none;">VAT</th>';
                    html += '<th style=" width: 11%; text-align:left;">Amount (USD)</th>';
                    html += '<th style=" width: 11%; text-align:left; display:none;">VAT USD</th>';
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

                html += '</tbody></table>';
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
        }

        $(document).on("click", ".btnDelete", function () {
            var _sid = $(this).closest("tr").find("[name='vs_id']").val();

            if (_sid != "") {
                var dels = $.grep(PODetails, function (n, i) {
                    return n["vs_id"] == _sid;
                });

                $.each(dels, function (i, d) {
                    if (d.id != "" && d.id != null && typeof d.id !== "undefined") {
                        var _del = new Object();
                        _del.id = d.id;
                        _del.table = "item";
                        deletedId.push(_del);
                    }

                    var idx = PODetails.findIndex(x => x.uid == d.uid);
                    var idxc = PODetailsCC.findIndex(x => x.vs_detail_id == d.vs_detail_id);

                    if (idx != -1) {
                        PODetails.splice(idx, 1);
                    }

                    if (idxc != -1) {
                        PODetailsCC.splice(idxc, 1);
                    }
                });
            }

            if (PODetails.length == 0) {
                usedVS = [];
                PODetails = [];
                PODetailsHeader = [];
                currency_id = "";
                vendor = "";
                expected_delivery_date = "";
                actual_sent_date = "";
                term_of_payment = "";
                PODetailSundry = [];

                $("#tblVS tbody").html("");
                $("[name='po.vendor_contact_person']").empty();
                $("[name='po.period']").empty();
                $("[name='po.cifor_shipment_account']").empty();
                $("[name='po.delivery_term']").empty();
                $("[name='po.cifor_delivery_address']").empty();
                $("[name='po.term_of_payment']").empty();
                $("[name='po.email']").empty();
                $("[name='po.expected_delivery_date']").val("");
                $("[name='po.send_date']").val("");
                $("[name='po.term_of_payment']").val("");
                $("[name='po.other_term_of_payment']").val("");
                $("#div_other_payment").css("display", "none");


                $("[name='po.exchange_sign']").val("");
                $("[name='po.exchange_rate']").val("");



            }
            $(this).closest("tr").remove();
            populateHeaderItem();
            populateTotal();

            repopulateNumber();
            /*$("[name='po.is_sundry_po']").prop("checked", false);*/
            /*$("#div_is_sundry_po").css("display", "none");*/
        });

        function populateUsedVS() {
            $("[name='vs_id']").each(function (i, d) {
                usedVS.push($(this).val());
            });

            usedVS = unique(usedVS);
        }

        function populateVendorContact() {

            /*var id =  ocs_supplier_id.length > 0  ? ocs_supplier_id : vendor;*/
            var id = vendor;
            if (!is_sundry) {
                return $.ajax({
                    /*url: '/Workspace/Procurement/Service.aspx/GetVendorContactPerson',*/
                    url: '<%= Page.ResolveUrl("~/" + based_url+service_url + "/GetVendorContactPerson") %>',
                    data: "{'vendors':'" + id + "'}",
                    dataType: 'json',
                    type: 'post',
                    contentType: "application/json; charset=utf-8",
                    success: function (response) {
                        listContact = JSON.parse(response.d);
                        let email = '';
                        var cboContact = $("[name='po.vendor_contact_person']");
                        $(cboContact).empty();
                        generateCombo(cboContact, listContact, "id", "name", true);
                        Select2Obj(cboContact, "Supplier contact person");
                        if (listContact.length == 1) {
                            vendor_cp = listContact[0].id;
                            email = listContact[0].email;
                        }

                        var cboEmail = $("select[name='po.email']");
                        cboEmail.empty();
                        generateCombo(cboEmail, listContact, "email", "email", true);
                        Select2Obj(cboEmail, "Email");

                        $(cboContact).val(vendor_cp).trigger("change");
                        $(cboEmail).val(email).trigger("change");
                        //$(cboPeriod).val(listPeriod[0].Id).change();
                    }
                });
            } else {

                var cboContact = $("[name='po.vendor_contact_person']");
                $(cboContact).empty();
                generateCombo(cboContact, listContact, "id", "name", true);
                Select2Obj(cboContact, "Supplier contact person");

                var cboEmail = $("select[name='po.email']");
                cboEmail.empty();
                generateCombo(cboEmail, listContact, "email", "email", true);
                Select2Obj(cboEmail, "Email");

                $(cboContact).val(listContact[0].name).trigger("change");
                $(cboEmail).val(listContact[0].email).trigger("change");
            }

        }

        function populateVendorTax() {
            return $.ajax({
                url: '<%= Page.ResolveUrl("~/" + based_url+service_url + "/GetVendorTax") %>',
                data: "{'vendor_id':'" + vendor + "'}",
                dataType: 'json',
                type: 'post',
                contentType: "application/json; charset=utf-8",
                success: function (response) {
                    var tax = 0;
                    var d = JSON.parse(response.d);
                    if (d.length > 0) {
                        if (String(d.tax_10).toLowerCase() == "y") {
                            tax = 10;
                        } else if (String(d.tax_20).toLowerCase() == "y") {
                            tax = 20;
                        }

                        $("[name='po.tax']").val(tax).trigger("change");
                        $("[name='po.tax']").prop("disable", true);
                    } else {
                        $("[name='po.tax']").prop("disable", false);
                    }
                }
            });
        }

        function calculateTax() {
            var tax = delCommas($("[name='po.vat_amount']").val());
            var tad = delCommas($("[name='po.total_after_discount']").val());

            //if ($("select[name='po.tax_type']").val() == '%') {
            //    tax = delCommas(accounting.formatNumber(tax / 100 * tad, 2));
            //} else {
            //    tax = delCommas(accounting.formatNumber(tax, 2));
            //}
            //tax = delCommas(accounting.formatNumber(tax / 100 * tad, 2));

            $("[name='po.tax_amount']").val(accounting.formatNumber(tax, 2))

            /*var net_amount = tad + tax;*/
            var net_amount = tad + tax;

            /*$("[name='po.total_amount']").val(accounting.formatNumber(net_amount, 2));*/
            $("[name='po.total_amount']").val(accounting.formatNumber(net_amount, 2));

            var sign = $("[name='po.exchange_sign']").val();
            var rate = $("[name='po.exchange_rate']").val();
            var net_amount_usd = 0;
            if (sign === "/") {
                net_amount_usd = delCommas(accounting.formatNumber(net_amount / rate, 2));
            } else {
                net_amount_usd = delCommas(accounting.formatNumber(net_amount * rate, 2));
            }

            $("[name='po.total_amount_usd']").val(accounting.formatNumber(net_amount_usd, 2));
        }

        function populateCurrency() {
            $(".currency").text(currency_id);
        }

        function populateTotal() {
            var gross_amt = 0;
            var gross_amt_usd = 0;
            var vat_amt = 0;
            var vat_amt_usd = 0;
            var disc = 0;
            var after_disc = 0;
            var rate_temp = 0;
            let vat_payable = false;
            let total_discount = 0;
            let total_amt_usd = 0;
            let total_additional_discount = 0;
            let total_additional_discount_usd = 0;

            /*$.each(PODetails, function (i, d) {*/
            $.each([...new Map(PODetails.map(item =>
                [item.pr_detail_id, item])).values()], function (i, d) {
                    if (d.vat_payable == true) {
                        /*gross_amt += delCommas(accounting.formatNumber((delCommas(d.quantity) * delCommas(d.unit_price)) + d.vat_amount, 2));*/
                        /*gross_amt += delCommas(accounting.formatNumber((delCommas(d.quantity) * delCommas(d.unit_price)), 2));*/
                        
                        vat_amt += delCommas(accounting.formatNumber(d.vat_amount, 2));
                        vat_payable = true;
                    } else {
                        /*gross_amt += delCommas(accounting.formatNumber((delCommas(d.quantity) * delCommas(d.unit_price)), 2));*/
                    }
                    gross_amt += d.line_total;
                    total_amt_usd += d.line_total_usd;
                    total_discount += delCommas(d.discount);
                    total_additional_discount += delCommas(d.additional_discount);
                });
            after_disc = delCommas(accounting.formatNumber(gross_amt - total_additional_discount, 2));

            var sign = $("[name='po.exchange_sign']").val();
            var rate = delCommas($("[name='po.exchange_rate']").val());
            let gross_amount_usd = 0;

            if (sign === "/") {
                gross_amt_usd = delCommas(accounting.formatNumber(after_disc / rate, 2));
                vat_amt_usd = delCommas(accounting.formatNumber(vat_amt / rate, 2));
                total_additional_discount_usd = (total_additional_discount / rate);
                gross_amount_usd = (after_disc / rate);
            } else {
                gross_amt_usd = delCommas(accounting.formatNumber(after_disc * rate, 2));
                vat_amt_usd = delCommas(accounting.formatNumber(vat_amt * rate, 2));
                total_additional_discount_usd = (total_additional_discount * rate);
                gross_amount_usd = (after_disc * rate);
            }

            $("[name='po.gross_amount']").val(gross_amt + total_discount);
            /*$("[name='po.gross_amount_usd']").val(gross_amt_usd);*/
            /*$("[name='po.gross_amount_usd']").val(accounting.formatNumber(total_amt_usd - total_additional_discount_usd, 2));*/
            $("[name='po.gross_amount_usd']").val(accounting.formatNumber(gross_amount_usd, 2));
            $("[name='po.discount']").val(total_discount + total_additional_discount);
            $("[name='po.total_after_discount']").val(after_disc);//po.vat_amount
            $("[name='po.vat_amount']").val(vat_amt);
            $("[name='po.vat_amount_usd']").val(vat_amt_usd);

            calculateTax();
            if (vat_amt == 0) {
                $("[name='po.total_amount_usd']").val(accounting.formatNumber(gross_amount_usd, 2));
            }
            
            repopulateNumber();

            //if (vat_payable == false) {
            //    $("#totalVAT").hide();
            //} else {
            //    $("#totalVAT").show();
            //}
        }

        $(document).on("click", "#btnCancel", function () {
            $("#CancelForm").modal("show");
        });

        $(document).on("click", "#btnSave,#btnSubmit,#btnSaveCancellation,#btnFundsCheck", function () {
            sleep(1).then(() => {
                blockScreenOL();
                //GetDataProduct();
                GetVSPRData();
            });

            sleep(300).then(() => {
                btnAction = $(this).data("action").toLowerCase();

                if (btnAction == 'fundscheck' && _id != '') {
                    /*   let fundsCheckChargeCodes = [];*/
                    let errorMsgFundsCheck = '';

                    if (PODetails.length > 0) {
                        calculateVAT();
                        AdjustVAT();
                        errorMsgFundsCheck += FundsCheck(PODetailsCC, errorMsgFundsCheck);

                        if (errorMsgFundsCheck !== "") {
                            showErrorMessage(errorMsgFundsCheck);
                        } else {
                            unBlockScreenOL();
                            alert('Budget is sufficient');
                        }


                    } else {
                        unBlockScreenOL();
                        alert('please choose quotation analysis first');
                    }
                    //unBlockScreenOL();
                } else {
                    workflow.sn = $("#sn").val();
                    workflow.activity_id = $("#activity_id").val();
                    workflow.action = btnAction;
                    workflow.comment = "";
                    if (btnAction == "cancelled") {
                        var errorMsg = "";
                        if ($.trim($("#cancellation_text").val()) == "" && $.trim($("#cancellation_file").val()) == "") {
                            errorMsg += "<br/> - Reason for cancellation is required.";
                        }

                        if ($("input[name='cancellation.uploaded']").val() == "0" && $("input[name='cancellation_file']").val()) {
                            $("input[name='cancellation_file']").css({ 'background-color': 'rgb(245, 183, 177)' });
                            errorMsg += "<br/> - Please upload file first.";
                        }
                        errorMsg += FileValidation();

                        if (errorMsg != "") {
                            errorMsg = "Please correct the following error(s):" + errorMsg;

                            $("#cform-error-message").html("<b>" + errorMsg + "<b>");
                            $("#cform-error-box").show();
                            $('.modal-body').animate({ scrollTop: 0 }, 500);
                            return false;
                        } else {
                            workflow.comment = $("#cancellation_text").val();
                            workflow.comment_file = $("#cancellation_file").val();
                        }
                    }

                    if (PODetails.length > 0) {
                        SubmitValidation();
                    } else {
                        alert('please choose quotation analysis first');
                        unBlockScreenOL();
                    }
                }


            }).then(() => {
            });

        });

        function SubmitValidation() {
            var errorMsg = "";

            var data = new Object();
            $("[name^='po.']").each(function (i, d) {
                var idx = String($(this).attr("name")).replace("po.", "");
                if (idx == "is_other_address") {
                    var isCheck = 0;
                    if ($(this).prop("checked")) {
                        isCheck = 1;
                    }
                    data[idx] = isCheck;
                }
                //else if (idx == "is_sundry_po") {
                //    let isCheckSundry = 0;
                //    if ($(this).prop("checked")) {
                //        isCheckSundry = 1;
                //    }
                //    data[idx] = isCheckSundry;
                //}
                else {
                    if ($(this).hasClass("number")) {
                        data[idx] = delCommas($(this).val());
                    } else {
                        data[idx] = $(this).val();
                    }
                }

                if (idx == "is_other_term_of_payment") {
                    var isCheckk = 0;
                    if ($(this).prop("checked")) {
                        isCheckk = 1;
                    }
                    data[idx] = isCheckk;
                }
            });

            calculateVAT();
            AdjustVAT();
            data.details = PODetails;
            data.detailsCC = PODetailsCC;
            data.is_sundry = is_sundry;
            if (btnAction == "submitted" || btnAction == "updated" || btnAction == "resubmitted for re-approval") {
                var errorMsgFundsCheck = ""
                //debugger;
                //data.details.forEach(function (item) {
                //    item.costCenters.forEach(function (chargeCode) {
                //        fundsCheckChargeCodes.push(chargeCode);
                //    });
                //});
                let pr_id = '';

                if (data.details.length > 0) {
                    pr_id = data.details[0]['pr_id'];
                }

                errorMsg += GeneralValidation();
                sleep(1).then(() => {
                    //GetDataProduct();
                    GetVSPRData();
                });

                sleep(300).then(() => {
                    
                }).then(() => {
                });
                
                errorMsg += FundsCheck(data.detailsCC, errorMsg);
                
                if (is_my_tree_supplier == "True" || is_my_tree_supplier == true) {
                    //if ($("[name='po.is_sundry_po']").is(":checked") != true) {
                    //    errorMsg = CheckSupplier(data.vendor);
                    //}
                    errorMsg += CheckSupplier(data.vendor);

                }

                if ($("select[name = 'po.term_of_payment']").attr("selected", "selected").val().toLowerCase() == "oth" && $("[name='po.other_term_of_payment']").val() == "") {
                    errorMsg += "<br/> - Other payment terms is required.";
                }
                errorMsg += FileValidation();
                /*errorMsg += CheckSupplier(data.vendor);*/
                SubmitProcess(errorMsg, data, deletedId, workflow);
            } else {
                errorMsg += FileValidation();
                SubmitProcess(errorMsg, data, deletedId, workflow);
            }
        }

        function SubmitProcess(errorMsg, data, deletedId, workflow) {
            if (errorMsg !== "") {
                unBlockScreenOL();
                showErrorMessage(errorMsg);

                return false;
            } else {
                var _data = {
                    "submission": JSON.stringify(data),
                    "deletedIds": JSON.stringify(deletedId),
                    "workflows": JSON.stringify(workflow)
                };
                Submit(_data);
            }
        }

        function Submit(_data) {
            /*blockScreen();*/
            $.ajax({
                url: 'Input.aspx/Save',
                data: JSON.stringify(_data),
                dataType: 'json',
                type: 'post',
                contentType: "application/json; charset=utf-8",
                success: function (response) {
                    var output = JSON.parse(response.d);
                    if (output.result == "invalidQA") {
                        unBlockScreenOL();
                        showErrorMessage(output.message);
                    } else {
                        if (output.result !== "success") {
                            alert(output.message);
                        } else {
                            if (output.id !== "") {
                                $("#po_no").val(output.po_no);
                                $("#po_id").val(output.id);
                                $("input[name='doc_id']").val(output.id);
                                $("input[name='action']").val("upload");

                                if (btnAction !== 'fundscheck') {
                                    alert("Purchase order " + $("#po_no").val() + " has been " + btnAction + " successfully.");
                                    if (btnAction == "submitted" || btnAction == "cancelled") {
                                        location.href = "list.aspx";
                                    } else {
                                        if (workflow.sn != "") {
                                            location.href = "input.aspx?id=" + output.id + '&sn=' + workflow.sn + '&activity_id=' + workflow.activity_id;
                                        } else {
                                            location.href = "input.aspx?id=" + output.id;
                                        }
                                    }
                                } else {
                                    if (_id == '') {
                                        blockScreen();
                                        location.href = "Input.aspx?id=" + output.id + "&isfundscheck=" + '1';
                                    }
                                }
                            }
                        }
                    }
                    
                }
            });
        }

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

        function UploadFile() {
            var form = $('form')[0];
            var formData = new FormData(form);

            $.ajax({
                type: "POST",
                /*url: '/Workspace/Procurement/Service.aspx',*/
                url: '<%= Page.ResolveUrl("~/" +based_url+ service_url + "") %>',
                data: formData,
                processData: false,
                contentType: false,
                success: function (response) {
                    var output = JSON.parse(response);
                    if (output.result !== "success") {
                        alert(output.message);
                    } else {
                        alert("Purchase order " + $("#po_no").val() + " has been " + btnAction + " successfully.");
                        blockScreen();
                        if (btnAction.toLowerCase() == "saved") {
                            if ($("[name='po.id']").val() == "") {
                                /*location.href = "input.aspx?id=" + output.id;*/
                                location.href = "list.aspx";
                            } else {
                                location.reload();
                            }
                            /*if (workflow.sn != "") {
                                parent.location.href = "Input.aspx?id=" + $("#po_id").val() + '&sn=' + workflow.sn + '&activity_id=' + workflow.activity_id;
                            } else {
                                parent.location.href = "Input.aspx?id=" + $("#po_id").val();
                            }*/
                        } else {
                            parent.location.href = "/workspace/My-Submissions.aspx";
                        }
                    }
                }
            });
        }

        $(document).on("click", "#btnGetSUNPO", function () {
            var po_id = $("#po_id").val();
            $.ajax({
                /* url: '/Workspace/Procurement/Service.aspx/GetSUNPO',*/
                url: '<%= Page.ResolveUrl("~/" +based_url+ service_url + "/GetSUNPO") %>',
                data: '{id:"' + po_id + '"}',
                dataType: 'json',
                type: 'post',
                contentType: "application/json; charset=utf-8",
                success: function (response) {
                    $("[name='po.po_sun_code']").val($.trim(response.d));
                }
            });
        });

        $(document).on("click", "#btnClose", function () {
            if (taskType == "admin") {
                parent.location.href = "Tasklist.aspx";
            } else if (taskType == "adminteam") {
                location.href = "Tasklist.aspx?action=team";
            } else {
                parent.location.href = "List.aspx";
            }
        });

        $(document).on("click", "#btnPrint", function () {
            link = "PrintPO.aspx?id=" + $("#po_id").val();
            top.window.open(link);
        });

        $(document).on("change", "[name='po.is_other_address']", function () {
            var isChecked = false;
            isChecked = $(this).prop("checked");

            checkOtherAddress(isChecked);
        });

        $(document).on("change", "[name='po.is_other_term_of_payment']", function () {
            checkOtherPayment($(this).prop("checked"));
        });

        $(document).on("change", "[name='po.tax']", function () {
            //if ($("select[name='po.tax_type']").val() == '%') {
            //    if (parseFloat($(this).val()) > 100) {
            //        $(this).val(100.00);
            //    }
            //}

            calculateTax();
        });

        $("[name='po.term_of_payment']").on('change', function () {
            if ($(this).val().toLowerCase() == "oth") {
            } else {
                $("select[name='po.term_of_payment'] option[value='OTH']").remove();
            }
        });

        function checkOtherAddress(isChecked) {
            if (isChecked) {
                $("#div_is_other_address").addClass("last");
                $("#div_is_other_address").addClass("required");
                $("[name='po.other_address']").data("validation", "required");
                $("#div_other_address").show();

                /*$("#div_delivery_address").removeClass("last");*/
                $("#div_delivery_address").removeClass("required");
                $("[name='po.cifor_delivery_address']").data("validation", "");

                $("select[name='po.cifor_delivery_address']").append('<option value="23821" selected>Other</option>');
            } else {
                $("#div_is_other_address").removeClass("last");
                $("#div_is_other_address").removeClass("required");
                $("[name='po.other_address']").data("validation", "");
                $("#div_other_address").hide();
                $("[name='po.other_address']").val("");

                $("#div_delivery_address").addClass("required");
                $("[name='po.cifor_delivery_address']").data("validation", "required");

                $("select[name='po.cifor_delivery_address'] option[value='23821']").remove();
            }
        }

        function checkOtherPayment(isChecked) {
            if (isChecked) {
                $("#div_is_other_payment").addClass("last");
                $("#div_is_other_payment").addClass("required");
                $("[name='po.other_term_of_payment']").data("validation", "required");
                $("#div_other_payment").show();

                /*$("#div_delivery_address").removeClass("last");*/
                $("#div_payment_terms").removeClass("required");
                $("[name='po.term_of_payment']").data("validation", "");

                $("select[name='po.term_of_payment']").append('<option value="OTH" selected>Other</option>');
            } else {
                $("#div_is_other_payment").removeClass("last");
                $("#div_is_other_payment").removeClass("required");
                $("[name='po.other_term_of_payment']").data("validation", "");
                $("#div_other_payment").hide();
                $("[name='po.other_term_of_payment']").val("");

                $("#div_payment_terms").addClass("required");
                $("[name='po.term_of_payment']").data("validation", "required");

                $("select[name='po.term_of_payment'] option[value='OTH']").remove();
            }
        }

        $(document).on("change", "[name='item.description']", function () {
            var vsDetailID = $(this).data("type");
            var quoDesc = $(this).val();

            $.each(PODetails, function (i, d) {
                if (vsDetailID == d.vs_detail_id) {
                    d.quotation_description = quoDesc;
                }
            });
        });

        function populateTaxType(tax_type_p) {
            if (tax_type_p == '$') {
                $("#div_tax_amount").hide();
            } else {
                $("#div_tax_amount").show();
                if (parseFloat(delCommas($("[name='po.tax']").val())) > 100) {
                    $("[name='po.tax']").val(0.00);
                }
            }

            calculateTax();
        }

        function UploadFileAPI(actionType) {
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
                    //unBlockScreenOL();
                    var stringJS = '{' + response.substring(
                        response.indexOf("{") + 1,
                        response.lastIndexOf("}")
                    ) + '}';
                    var output = JSON.parse(stringJS);

                    if (actionType != "submit") {
                        if (output.result == '') {
                            //if ($(btnFileUpload).data("type") == 'filecancel') {
                            //    //GenerateCancelFileLink(btnFileUpload, filenameupload);
                            //} else {
                            //    //GenerateFileLink(btnFileUpload, filenameupload);
                            //}
                        } else {
                            alert('Upload file failed');
                        }
                        unBlockScreenOL();
                    } else {
                        alert("Quotation " + $("#q_no").val() + " has been " + btnAction + " successfully.");
                        if (btnAction.toLowerCase() == "saved") {
                            parent.location.href = "Input.aspx?id=" + $("[name='po.id']").val();
                        } else {
                            parent.location.href = "List.aspx";
                        }
                    }
                    /*unBlockScreenOL();*/
                },
                error: function (jqXHR, exception) {
                    unBlockScreenOL();
                }
            });

            $("#file_name").val("");
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
                + '<input type="email" name="sundry.email" placeholder="Email" value="" data-title="email" class="span12" readonly/>'
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
            const regexExp = /^[0-9a-fA-F]{8}\b-[0-9a-fA-F]{4}\b-[0-9a-fA-F]{4}\b-[0-9a-fA-F]{4}\b-[0-9a-fA-F]{12}$/gi;
            var param1 = '';
            if (!regexExp.test(pod_id)) {
                param1 = header_id;
            }
            var param2 = quotation_id;

            $.ajax({
                url: "<%=Page.ResolveUrl("Input.aspx/getSundry")%>",
                data: JSON.stringify({ id1: param1, id2: param2 }),
                dataType: 'json',
                type: 'post',
                contentType: "application/json; charset=utf-8",
                success: function (response) {

                    regexExp.test(pod_id); // jangan dihapus
                    var output = JSON.parse(response.d);
                    if (output.result == "success") {
                        var d = JSON.parse(output.data);
                        if (d.length > 0) {
                            let index = 0;
                            if (!regexExp.test(pod_id)) {
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

            const regexExp = /^[0-9a-fA-F]{8}\b-[0-9a-fA-F]{4}\b-[0-9a-fA-F]{4}\b-[0-9a-fA-F]{4}\b-[0-9a-fA-F]{12}$/gi;
            var param1 = '';
            if (!regexExp.test(pod_id)) {
                param1 = header_id;
            }
            var param2 = quotation_id;
            var temp = d;

            $.ajax({
                url: "<%=Page.ResolveUrl("Input.aspx/getSundry")%>",
             data: JSON.stringify({ id1: param1, id2: param2 }),
             dataType: 'json',
             type: 'post',
             contentType: "application/json; charset=utf-8",
             success: function (response) {
                 regexExp.test(pod_id); // jangan dihapus
                 var output = JSON.parse(response.d);
                 var html = '';
                 if (output.result == "success") {
                     var d = JSON.parse(output.data);
                     if (d.length > 0) {
                         let index = 0;
                         if (!regexExp.test(pod_id)) {
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

        //$(document).on("click", "#btnFundsCheck", function () {

        //    var fundsCheckChargeCodes = [];
        //    errorMsgFundsCheck = '';

        //    btnAction = $(this).data("action").toLowerCase();

        //    sleep(1).then(() => {
        //        blockScreenOL();

        //    });

        //    sleep(300).then(() => {
        //        if (PODetails.length > 0) {
        //            calculateVAT();
        //            AdjustVAT();
        //            /*errorMsgFundsCheck += FundsCheck(PODetailsCC, errorMsgFundsCheck, PODetails[0]['pr_id']);*/
        //            errorMsgFundsCheck += FundsCheck(PODetailsCC, errorMsgFundsCheck);

        //            if (errorMsgFundsCheck !== "") {
        //                showErrorMessage(errorMsgFundsCheck);
        //            } else {
        //                alert('Budget is sufficient');
        //            }


        //        } else {
        //            alert('please choose quotation analysis first');
        //        }
        //        unBlockScreenOL();
        //    }).then(() => {
        //    });
        //});

        function FundsCheck(chargeCodes, errMessage) {
            if (btnAction == 'fundscheck') {
                blockScreenOL();
            }

            var params = [];
            let appSource = [];
            var prIdStr = "";
            var msgFundscheck = "";
            /*let productTemp = [];*/

            let isExcludeCC = false;
            let isExcludeID = false;
            /*let productTemp = [];*/

            //if (!prId)
            //    prIdStr = "";
            //else
            //    prIdStr = prId;
            chargeCodes.forEach(function (item) {
                let pod = $.grep(PODetails, function (n, i) {
                    return n["vs_detail_id"] == item.vs_detail_id;
                });

                arrobjProduct = $.grep(objProduct, function (n, i) {
                    return n["Id"] == pod[0].item_code;
                });

                var chargeCode = {
                    Costc: item.cost_center_id,
                    Workorder: item.work_order,
                    Entity: item.entity_id,
                    Account: arrobjProduct[0].BudgetAccount,
                    Amount: pod[0]['vat_payable'] == true ? parseFloat(item.amount_usd) + parseFloat(item.amount_usd_vat) : parseFloat(item.amount_usd),
                    ControlAccount: item.control_account
                };

                isExcludeCC = exclCostCenter.includes(item.cost_center_id);
                isExcludeID = exclIDFundscheckPO.includes($("[name='po.id']").val());

                if (isExcludeCC == false && isExcludeID == false) {
                    params.push(chargeCode);

                    let appSourceTemp = {
                        SourceId: item.purchase_order + '.' + item.pr_detail_id,
                        SourceName: 'Procurement'
                    };

                    appSource.push(appSourceTemp);
                }
            });

            appSource = [...new Map(appSource.map(item => [item['SourceId'], item])).values()];

            vsd.forEach(function (item) {
                let appSourceTemp = {
                    SourceId: item.pr_id + '.' + item.pr_detail_id,
                    SourceName: 'Procurement'
                };
                appSource.push(appSourceTemp);
            });

            $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                url: '<%= Page.ResolveUrl("~/" + based_url+service_url + "/FundsCheck") %>',
                async: false,
                /*data: JSON.stringify({ data: [{ Data: params, ApplicationId: prIdStr.toString(), ApplicationSource: "Procurement" }] }),*/
                data: JSON.stringify({ data: [{ Data: params, ApplicationSource: appSource }] }),
                dataType: "json",
                success: function (response) {
                    var result = JSON.parse(response.d);
                    if (result.success == true && result.status == "200") {
                        result.data.forEach(function (item) {
                            if (item.Result == false) {
                                let accountProd = '';

                                params.forEach(function (itemP) {
                                    if (itemP.Costc == item.Costc && itemP.Workorder == item.WorkOrder && itemP.Entity == item.Entity) {
                                        accountProd += itemP.ControlAccount + ",";
                                    }
                                });
                                msgFundscheck += "<br> - The budget for Cost center : " + item.Costc + ", Work order: " + item.WorkOrder + ", Entity : " + item.Entity + ", Account : " + accountProd.slice(0, -1) + ", Budget account : " + item.Account + " has exceeded by USD " + accounting.formatNumber(item.Amount * -1, 2);
                                errMessage += msgFundscheck;
                            }
                        });
                    } else {
                        errMessage += "<br> - " + result.additionalInfo;
                    }
                    if (btnAction == 'fundscheck' || btnAction == 'submitted') {
                        $.ajax({
                            type: "POST",
                            contentType: "application/json; charset=utf-8",
                            url: '<%= Page.ResolveUrl("~/" + based_url+service_url + "/SaveLifeCycle") %>',
                            async: false,
                            data: "{'module_id':'" + $("[name='po.id']").val() + "', 'module_name':'PURCHASE ORDER FUNDSCHECK', 'status_id':'" + status_id + "', 'fundscheck_result':'" + msgFundscheck + "'}",
                            dataType: "json",
                            success: function (response) {
                                //var result = response.d;
                                
                            },
                            error: function (jqXHR, exception) {
                                /*unBlockScreenOL();*/
                            }
                        });
                    }
                },
                error: function (jqXHR, exception) {
                    /*unBlockScreenOL();*/
                }
            });
            return errMessage;
        }

        function CheckSupplier(vendor) {
            let errMessage = "";
            $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                url: '<%= Page.ResolveUrl("~/" + based_url+service_url + "/CheckSupplier") %>',
                async: false,
                data: "{'vendor_id':'" + vendor + "'}",
                dataType: "json",
                success: function (response) {
                    var result = JSON.parse(response.d);
                    if (result.length > 0) {
                        if (result[0].ocs_supplier_code == '' || result[0].ocs_supplier_code == null || result[0].ocs_supplier_code == 'undefined') {
                            errMessage += "<br> - Quotation analysis cannot be used because it does not have a supplier code ocs";
                        }
                    }
                },
                error: function (jqXHR, exception) {
                    /*unBlockScreenOL();*/
                }
            });
            return errMessage;
        }

        //function calculateVAT() {
        //    var podtemp = [...new Map(PODetailsCC.map(item => [item['vs_detail_id'], item])).values()];
        //    let po_tax = 0;

        //    if ($("select[name='po.tax_type']").val() == '%') {
        //        if ($("[name='po.exchange_sign']").val() === "/") {
        //            po_tax = parseFloat(delCommas($("[name='po.tax_amount']").val()));
        //        } else {
        //            po_tax = parseFloat(delCommas($("[name='po.tax_amount']").val()));
        //        }
        //    } else {
        //        po_tax = parseFloat(delCommas($("[name='po.tax']").val()));
        //    }

        //    var totalproduct = 0;
        //    $.each(podtemp, function (i, d) {
        //        let amttemp = 0;
        //        $.each(PODetailsCC, function (i, pod) {
        //            if (d.vs_detail_id == pod.vs_detail_id) {
        //                amttemp += pod.amount_usd;
        //                d.amount_usd_temp = parseFloat(amttemp.toFixed(2));
        //            }
        //        });

        //        totalproduct += d.amount_usd_temp;
        //    });

        //    $.each(podtemp, function (i, d) {
        //        d.vat_product = parseFloat(((d.amount_usd_temp / totalproduct) * po_tax).toFixed(2));
        //    });

        //    $.each(podtemp, function (i, d) {
        //        $.each(PODetailsCC, function (i, pod) {
        //            if (d.vs_detail_id == pod.vs_detail_id) {
        //                pod.amount_vat = 0;
        //                pod.amount_vat = parseFloat(((d.vat_product * pod.percentage) / 100).toFixed(2));

        //                let vat_product_temp = d.vat_product;

        //                pod.amount_vat_product = parseFloat(vat_product_temp.toFixed(2));
        //            }
        //        });
        //    });
        //}

        //function AdjustVAT() {
        //    let totalVAT = 0;
        //    let po_tax = 0;

        //    if ($("select[name='po.tax_type']").val() == '%') {
        //        if ($("[name='po.exchange_sign']").val() === "/") {
        //            po_tax = parseFloat(delCommas($("[name='po.tax_amount']").val()));
        //        } else {
        //            po_tax = parseFloat(delCommas($("[name='po.tax_amount']").val()));
        //        }
        //    } else {
        //        po_tax = parseFloat(delCommas($("[name='po.tax']").val()));
        //    }

        //    $.each(PODetailsCC, function (i, pod) {
        //        totalVAT += pod.amount_vat;
        //    });

        //    while (totalVAT != po_tax) {
        //        let vat_temp = 0;
        //        if (totalVAT > po_tax) {
        //            vat_temp = PODetailsCC[PODetailsCC.length - 1]['amount_vat'] - 0.01;
        //        } else {
        //            vat_temp = PODetailsCC[PODetailsCC.length - 1]['amount_vat'] + 0.01;
        //        }

        //        PODetailsCC[PODetailsCC.length - 1]['amount_vat'] = parseFloat(vat_temp.toFixed(2));
        //        PODetailsCC[PODetailsCC.length - 1]['amount_vat_product'] = parseFloat(vat_temp.toFixed(2));

        //        totalVAT = 0;
        //        $.each(PODetailsCC, function (i, pod) {
        //            totalVAT += pod.amount_vat;
        //        });

        //        let podtemp = [...new Map(PODetailsCC.map(item => [item['vs_detail_id'], item])).values()];

        //        $.each(podtemp, function (i, d) {
        //            let amount_vat_temp = 0;
        //            $.each(PODetailsCC, function (i, pod) {
        //                if (d.vs_detail_id == pod.vs_detail_id) {
        //                    amount_vat_temp += pod.amount_vat;
        //                    if ((amount_vat_temp - pod.amount_vat_product) < 1 && (amount_vat_temp - pod.amount_vat_product) > 0) {
        //                        $.each(PODetailsCC, function (i, podd) {
        //                            if (pod.vs_detail_id == podd.vs_detail_id) {
        //                                podd.amount_vat_product = parseFloat(amount_vat_temp.toFixed(2));
        //                            }
        //                        });
        //                    }
        //                }                        
        //            });
        //        });
        //    }

        //    $.each(PODetailsCC, function (i, pod) {
        //        if ($("[name='po.exchange_sign']").val() === "/") {
        //            pod.amount_usd_vat = parseFloat((pod.amount_vat / $("[name='po.exchange_rate']").val()).toFixed(2));
        //        } else {
        //            pod.amount_usd_vat = parseFloat((pod.amount_vat * $("[name='po.exchange_rate']").val()).toFixed(2));
        //        }
        //    });
        //}

        function calculateVATpercentage(e, vs_detail) {
            let line_total = parseFloat(delCommas($(e).closest("tr").find("td.item_line_total").text()));
            let qty = parseFloat(delCommas($(e).closest("tr").find("td.item_quantity").text()));
            let additional_discount = parseFloat(delCommas($(e).closest("tr").find("td.item_additional_discount").text()));

            let tax_type = $(e).closest("tr").find("select[name$='po.tax_type']").val();

            let listTaxTemp = $.grep(listTax, function (n, i) {
                return n["Id"] == tax_type;
            });

            if (tax_type != '' && tax_type != null) {
                tax_type = parseFloat(listTaxTemp[0]['Tax']) / 100;
            }

            let item_vat = 0;
            //if (tax_type == '%') {
            //    if (parseFloat($(e).closest("tr").find("input[name$='item.vat_percentage']").val()) > 100) {
            //        $(e).closest("tr").find("input[name$='item.vat_percentage']").val(100.00);
            //    }

            //    item_vat = (line_total * $(e).closest("tr").find("input[name$='item.vat_percentage']").val()) / 100;
            //} else {
            //    item_vat = parseFloat(delCommas($(e).closest("tr").find("input[name$='item.vat_percentage']").val()));
            //}
            item_vat = (line_total * tax_type);
            item_vat = parseFloat(item_vat);

            //$(e).closest("tr").find("td.item_vat_amt_unit").text(accounting.formatNumber(item_vat / qty, 2));
            //$(e).closest("tr").find("td.item_vat_amt").text(accounting.formatNumber(item_vat, 2));

            if ($(e).closest("tr").find("select[name$='po.payable_tax']").val() == '1') {
                $(e).closest("tr").find("td.item_total").text(accounting.formatNumber((line_total + item_vat) - additional_discount, 2));

                $(e).closest("tr").find("td.item_vat_amt_unit").text(accounting.formatNumber(item_vat / qty, 2));
                $(e).closest("tr").find("td.item_vat_amt").text(accounting.formatNumber(item_vat, 2));
            } else {
                $(e).closest("tr").find("td.item_total").text(accounting.formatNumber(line_total - additional_discount, 2));

                $(e).closest("tr").find("td.item_vat_amt_unit").text(accounting.formatNumber(0, 2));
                $(e).closest("tr").find("td.item_vat_amt").text(accounting.formatNumber(0, 2));
            }

            $.each(PODetails, function (i, d) {
                if (d.vs_detail_id == vs_detail) {
                    /*d.vat_percentage = parseFloat($(e).closest("tr").find("input[name$='item.vat_percentage']").val());*/
                    d.vat_percentage = tax_type * 100;
                    d.vat_amount_unit = item_vat / qty;
                    /*d.vat_amount = item_vat;*/

                    if ($("#chkVATpercentage_" + vs_detail + "").val() !== '') {
                        d.vat_payable = $("#chkVATpercentage_" + vs_detail + "").val() == '1' ? true : false;
                    }

                    d.vat_type = $("#vat_type_" + vs_detail + "").val();
                    /*d.vat = parseFloat($(e).closest("tr").find("input[name$='item.vat_percentage']").val());*/
                    d.vat = 0;

                    if (d.vat_payable == false) {
                        d.vat_amount = 0;
                    } else {
                        d.vat_amount = item_vat;
                    }
                }
            });

            //populateTotal();
            calculateVAT();
            AdjustVAT();
        }

        function calculateVAT() {
            $.each(PODetails, function (i, d) {
                $.each(PODetailsCC, function (i, dc) {
                    if (d.vs_detail_id == dc.vs_detail_id) {
                        d.vat_amount = d.vat_amount == null ? 0 : d.vat_amount;
                        if (d.vat_amount > -1) {
                            dc.amount_vat_product = parseFloat((d.vat_amount).toFixed(2));
                            dc.amount_vat = parseFloat(((d.vat_amount * dc.percentage) / 100).toFixed(2));
                            if ($("[name='po.exchange_sign']").val() === "/") {
                                dc.amount_usd_vat = parseFloat((dc.amount_vat / d.exchange_rate).toFixed(2));
                            } else {
                                dc.amount_usd_vat = parseFloat((dc.amount_vat * d.exchange_rate).toFixed(2));
                            }
                        }

                    }
                });
            });
        }

        function AdjustVAT() {
            let item_vat_amt = 0;
            $.each(PODetails, function (i, d) {
                let total_amt_vat_cc = 0;
                let idcc = 0;
                item_vat_amt = d.vat_amount;

                $.each(PODetailsCC, function (i, dc) {
                    if (d.vs_detail_id == dc.vs_detail_id) {
                        total_amt_vat_cc += parseFloat(dc.amount_vat.toFixed(2));
                        idcc = dc.id;
                    }
                });

                if (item_vat_amt > -1) {
                    //while (parseFloat(item_vat_amt.toFixed(2)) != parseFloat(total_amt_vat_cc.toFixed(2))) {
                    //    let temp_total_vat_product = item_vat_amt;
                    //    let temp_total_vat_product_cc = total_amt_vat_cc;
                    //    total_amt_vat_cc = 0;
                    //    $.each(PODetailsCC, function (i, dcc) {
                    //        if (dcc.id == idcc) {
                    //            if (temp_total_vat_product_cc > temp_total_vat_product) {
                    //                dcc.amount_vat = parseFloat((dcc.amount_vat - 0.01).toFixed(2));
                    //            } else {
                    //                dcc.amount_vat = parseFloat((dcc.amount_vat + 0.01).toFixed(2));
                    //            }
                    //        }
                    //        dcc.amount_vat = parseFloat(dcc.amount_vat.toFixed(2));
                    //        if (d.vs_detail_id == dcc.vs_detail_id) {
                    //            total_amt_vat_cc += dcc.amount_vat;
                    //        }
                    //    });
                    //}
                }
            });

            //$.each(PODetailsCC, function (i, pod) {
            //    if ($("[name='po.exchange_sign']").val() === "/") {
            //        pod.amount_usd_vat = parseFloat((pod.amount_vat / $("[name='po.exchange_rate']").val()).toFixed(2));
            //    } else {
            //        pod.amount_usd_vat = parseFloat((pod.amount_vat * $("[name='po.exchange_rate']").val()).toFixed(2));
            //    }

            //    $("#pCostCentersAmt_" + pod.id).text(accounting.formatNumber(pod.amount + pod.amount_vat, 2));
            //    $("#pCostCentersUSDAmt_" + pod.id).text(accounting.formatNumber(pod.amount_usd + pod.amount_usd_vat, 2));
            //});
            populateAmtVATChargeCode();
            populateTotal();
        }

        function PayableChange(e, vsd) {
            $.each(PODetails, function (i, d) {
                if (d.vs_detail_id == vsd) {
                    /*d.vat_payable = $("#chkVATpercentage_" + d.vs_detail_id + "").is(":checked");*/
                    d.vat_payable = $("#chkVATpercentage_" + d.vs_detail_id + "").val() == "1" ? true : false;
                }
            });

            let line_total = parseFloat(delCommas($(e).closest("tr").find("td.item_line_total").text()));
            let vat_total = parseFloat(delCommas($(e).closest("tr").find("td.item_vat_amt").text()));

            if ($(e).closest("tr").find("select[name$='po.payable_tax']").val() == '1') {
                $(e).closest("tr").find("td.item_total").text(accounting.formatNumber(line_total + vat_total, 2));
            } else {
                $(e).closest("tr").find("td.item_total").text(accounting.formatNumber(line_total, 2));
            }

            populateAmtVATChargeCode();
            populateTotal();

            calculateVATpercentage(e, vsd);
        }

        function PrintableChange(e, vsd) {
            $.each(PODetails, function (i, d) {
                if (d.vs_detail_id == vsd) {
                    d.vat_printable = $("#chkVATprintable_" + d.vs_detail_id + "").val() == "1" ? true : false;
                }
            });
        }

        function populateAmtVATChargeCode() {
            $.each(PODetailsCC, function (i, pod) {
                if ($("[name='po.exchange_sign']").val() === "/") {
                    pod.amount_usd_vat = parseFloat((pod.amount_vat / $("[name='po.exchange_rate']").val()).toFixed(2));
                } else {
                    pod.amount_usd_vat = parseFloat((pod.amount_vat * $("[name='po.exchange_rate']").val()).toFixed(2));
                }

                let podt = $.grep(PODetails, function (n, i) {
                    return n["vs_detail_id"] == pod.vs_detail_id;
                });
                if (podt[0]['vat_payable'] == true && podt[0]['vat_amount'] > 0) {
                    $("#pCostCentersAmt_" + (pod.id == '' ? i.toString() : pod.id)).text(accounting.formatNumber(pod.amount + pod.amount_vat, 2));
                    $("#pCostCentersUSDAmt_" + (pod.id == '' ? i.toString() : pod.id)).text(accounting.formatNumber(pod.amount_usd + pod.amount_usd_vat, 2));
                    /*} else if (podt[0]['vat_percentage'] > 0) {*/
                } else {
                    $("#pCostCentersAmt_" + (pod.id == '' ? i.toString() : pod.id)).text(accounting.formatNumber(pod.amount, 2));
                    $("#pCostCentersUSDAmt_" + (pod.id == '' ? i.toString() : pod.id)).text(accounting.formatNumber(pod.amount_usd, 2));
                }
            });
        }

        function SetTaxType() {
            $.each(PODetails, function (i, pod) {
                $("#vat_type_" + pod.vs_detail_id + "").val(pod.vat_type).change();

                $("#chkVATpercentage_" + pod.vs_detail_id + "").val(pod.vat_payable == true ? '1' : '0').change();
                $("#chkVATprintable_" + pod.vs_detail_id + "").val(pod.vat_printable == true ? '1' : '0').change();
            });
        }

        function GetDataProduct() {
            $.ajax({
                url: '<%= Page.ResolveUrl("~/" + based_url+service_url + "/GetProductList") %>',
                dataType: 'json',
                type: 'post',
                contentType: "application/json; charset=utf-8",
                success: function (response) {
                    //objProduct = JSON.parse(response.d);
                }
            });
        }

        function populateHeader() {
            if (POHeaders.length > 0) {
                other_term_of_payment = POHeaders[0].other_term_of_payment;
            }
        }

        function GetVSPRData() {
            for (let i = 0; i < usedVS.length; i++) {
                vs_id += usedVS[i] + ',';
            }
            $.ajax({
                /* url: '/Workspace/Procurement/Service.aspx/GetSUNPO',*/
                url: '<%= Page.ResolveUrl("~/" +based_url+ service_url + "/GetVSDetailData") %>',
                    data: '{vs_id:"' + vs_id.slice(0, -1) + '"}',
                    dataType: 'json',
                    type: 'post',
                    contentType: "application/json; charset=utf-8",
                    success: function (response) {
                        vsd = JSON.parse(response.d);
                    }
                });
        }
    </script>
</asp:Content>
