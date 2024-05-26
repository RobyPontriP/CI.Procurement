<%@ Page MasterPageFile="~/Procurement.Master" Language="C#" AutoEventWireup="true" CodeBehind="Input.aspx.cs" Inherits="myTree.WebForms.Modules.Quotation.Input" %>
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

        #CancelForm.modal-dialog {
            margin: auto 12% !important;
            width: 60% !important;
            height: 320px !important;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="AppBody" runat="server">
    <input type="hidden" id="status" value="<%=Q.status_id %>"/>
    <input type="hidden" name="quo.id" value="<%=Q.id %>"/>
    <input type="hidden" id="q_no" value="<%=Q.q_no %>" />
    
    <!-- for upload file -->
    <input type="hidden" name="action" id="action" value=""/>
    <input type="hidden" id="quo.id" name="doc_id" value="<%=Q.id %>"/>
    <input type="hidden" name="doc_type" value="QUOTATION"/>
    <input type="hidden" name="file_name" id="file_name" value="" />
    <input type="hidden" name="docidtemp" value="" />
    <!-- end of upload file -->

    <!-- Bootstrap modal -->
    <div id="RFQForm" class="modal hide fade modal-dialog" tabindex="-1" role="dialog" aria-labelledby="header1" aria-hidden="true"
        data-backdrop="static" data-keyboard="false">
	    <div class="modal-header">
		    <button type="button" class="close" data-dismiss="modal" aria-hidden="true"></button>
			    <h3 id="header1">Select RFQ</h3>
	    </div>
	    <div class="modal-body">
            <div class="floatingBox" id="rfqform-error-box" style="display: none">
                <div class="alert alert-error" id="rfqform-error-message">
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">
                    Created date
                </label>
                <div class="controls">
                    <div class="input-prepend" style="margin-right:-32px;">
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
            <div class="control-group" style="display:none;">
                <label class="control-label">
                    Purchase office
                </label>
                <div class="controls">
                    <select id="cboOffice" data-title="Purchase office" class="span6">
                        <option value="-1">ALL CIFOR OFFICES</option>
                    </select>
                </div>
            </div>
            <div class="control-group">
                <div class="controls">
                    <button type="button" class="btn" id="btnRefresh">Search</button>
                </div>
            </div>
            <div class="control-group">
                <table id="RFQResults" class="table table-bordered" style="border: 1px solid #ddd">
                    <thead>
                        <tr>
                            <th style="width:5%;">&nbsp;</th>
                            <th style="width:20%;">RFQ code</th>
                            <th style="width:20%;">Created date</th>
                            <th style="width:40%;">Supplier</th>
                            <th style="width:15%;">Purchase office</th>
                        </tr>
                    </thead>
                    <tbody>

                    </tbody>
                </table>
            </div>
        </div>
	    <div class="modal-footer">
            <button type="button" class="btn" data-dismiss="modal" aria-hidden="true">Close and cancel</button>
	    </div>
    </div>

    <div id="ItemForm" class="modal hide fade modal-dialog"  role="dialog" aria-labelledby="header2" aria-hidden="true"
        data-backdrop="static" data-keyboard="false">
	    <div class="modal-header">
		    <button type="button" class="close" id="iconCloseItemForm" aria-hidden="true"></button>
			    <h3 id="header2">Edit product quotation</h3>
	    </div>
	    <div class="modal-body">
            <div class="floatingBox" id="itemform-error-box" style="display: none">
                <div class="alert alert-error" id="itemform-error-message">
                </div>
            </div>
            <input type="hidden" name="item.uid"/>
            <input type="hidden" name="item.source_quantity" />
            <input type="hidden" name="item.rfq_quantity"/>
            <input type="hidden" name="item.vs_quantity"/>
            <input type="hidden" name="item.initial_quantity"/>
            <input type="hidden" name="item.initial_quantity_vs"/>
            <input type="hidden" name="item.initial_unit_price"/>
            <input type="hidden" name="item.initial_discount_type"/>
            <input type="hidden" name="item.initial_discount"/>
            <input type="hidden" name="item.initial_additional_discount"/>
            <input type="hidden" name="item.pr_unit_price"/>
            <input type="hidden" name="item.initial_currency"/>
            <input type="hidden" name="item.initial_exchange_rate"/>
            <div class="control-group">
                <table id="tblItemDetail" class="table table-bordered table-hover" style="border: 1px solid #ddd">
                    <thead>
                        <tr>
                            <th style="width:30%;">&nbsp;</th>
                            <th style="width:30%;" id="source_info">PR/RFQ information</th>
                            <th style="width:40%;">Quotation information</th>
                        </tr>
                    </thead>
                    <tbody>
                         <tr>
                            <td>Currency / Exchange rate (to USD)</td>
                            <td ></td>
                            <td>
                                
                                <select  name="item.currency_id" class="span8"></select>
                                <div class="input-prepend">
                                    <span class="add-on">USD</span>
                                    <input type="hidden" name="item.exchange_sign">
                                    <input type="text" name="item.exchange_rate" class="span6 number" data-decimal-places="8" readonly />
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td>Quotation quantity <span style="color:red;">*</span></td>
                            <td id="pr_quantity" style="text-align:right;"></td>
                            <td>
                                <div class="span6">
                                    <div class="input-prepend">
                                        <input type="text" name="item.quotation_quantity" class="span9 number" data-decimal-places="2"/>
                                        <span class="add-on pr_uom"></span>
                                    </div>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td>Quantity to be used in quotation analysis <span style="color:red;">*</span></td>
                            <td></td>
                            <td>
                                <div class="span6">
                                    <div class="input-prepend">
                                        <input type="text" name="item.quantity" class="span9 number" data-decimal-places="2"/>
                                        <span class="add-on pr_uom"></span>
                                    </div>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td>Unit price <span style="color:red;">*</span></td>
                            <td id="pr_unit_price" style="text-align:right;"></td>
                            <td>
                                <div class="span6">
                                    <div class="input-prepend">
                                        <span class="add-on currency"></span>
                                        <input type="text" name="item.unit_price" class="span9 number" data-decimal-places="2"/>
                                    </div>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td>Total</td>
                            <td id="pr_estimated_cost" style="text-align:right;"></td>
                            <td>
                                <div class="span6">
                                    <div class="input-prepend">
                                        <span class="add-on currency"></span>
                                        <input type="text" name="item.total" class="span9 number" data-decimal-places="2" disabled="disabled"/>
                                    </div>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td>Discount per product</td>
                            <td>&nbsp;</td>
                            <td>
                                <select name="item.discount_type" class="span2">
                                </select>                                
                                <div class="input-prepend">
                                    <span  id="txt_TypeAmt_Item" class="add-on currency"></span>
                                    <input type="text" name="item.discount" class="span6 number" maxlength="18" data-decimal-places="2"/>
                                </div>
                                <input type="hidden" name="item.discount_amount" class="span6 number" data-decimal-places="2"/>
                            </td>
                        </tr>
                        <tr>
                            <td>Additional discount</td>
                            <td>&nbsp;</td>
                            <td>
                                <div class="span6">
                                    <div class="input-prepend">
                                        <span class="add-on currency"></span>
                                        <input type="text" name="item.additional_discount" class="span9 number" data-decimal-places="2" disabled="disabled"/>
                                    </div>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td>Total after discount</td>
                            <td>&nbsp;</td>
                            <td>
                                <div class="span6">
                                    <div class="input-prepend">
                                        <span class="add-on currency"></span>
                                        <input type="text" name="item.line_total" class="span9 number" data-decimal-places="2" disabled="disabled"/>
                                    </div>
                                </div>
                             
                                <div class="span5">
                                    <div class="input-prepend">
                                        <span class="add-on">USD</span>
                                        <input type="text" name="item.line_total_usd" class="span9 number" data-decimal-places="2" disabled="disabled"/>
                                    </div>
                                </div>
                            </td>
                        </tr>
                         <tr>
                            <td>Description <span style="color:red;">*</span></td>
                            <td id="pr_item_description"></td>
                            <td>
                                <textarea name="item.quotation_description" maxlength="1000" rows="10" class="span10 textareavertical"  placeholder="Quotation description"></textarea>
                                <div class="mt-1" style="font-size: 80%; font-style: italic; display: block;">Maximum description is 1,000 characters</div>
                            </td>
                        </tr>
                        <tr>
                            <td>Lead time</td>
                            <td>&nbsp;</td>
                            <td>
                                <textarea name="item.indent_time" maxlength="500" rows="3" class="span10 textareavertical" data-title="Lead time" placeholder="Lead time"></textarea>
                                <div class="mt-1" style="font-size: 80%; font-style: italic; display: block;">Maximum description is 500 characters</div>
                            </td>
                        </tr>
                        <tr>
                            <td>Warranty</td>
                            <td>&nbsp;</td>
                            <td>
                                <textarea name="item.warranty" maxlength="500" rows="3" class="span10 textareavertical" data-title="Warranty" placeholder="Warranty"></textarea>
                                <div class="mt-1" style="font-size: 80%; font-style: italic; display: block;">Maximum description is 500 characters</div>
                            </td>
                        </tr>
                        <tr>
                            <td>Remarks</td>
                            <td>&nbsp;</td>
                            <td>
                                <textarea name="item.remarks" maxlength="1000" rows="3" class="span10 textareavertical" data-title="Remarks" placeholder="Remarks"></textarea>
                                 <div class="mt-1" style="font-size: 80%; font-style: italic; display: block;">Maximum description is 1,000 characters</div>
                            </td>
                        </tr>
                        <tr class="item_closing">
                            <td>Closing quantity</td>
                            <td>&nbsp;</td>
                            <td>
                                <span id="closing_quantity"></span>
                            </td>
                        </tr>
                        <tr class="item_closing">
                            <td>Reason for closing</td>
                            <td>&nbsp;</td>
                            <td>
                                <span id="closing_remarks"></span>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
	    </div>
	    <div class="modal-footer">
            <button type="button" class="btn btn-success" aria-hidden="true" id="btnSaveDetail">Save</button>
            <button type="button" class="btn" aria-hidden="true" id="btnCloseItemForm">Close and cancel</button>
	    </div>
    </div>

    <div id="SearchItemForm" class="modal hide fade modal-dialog" tabindex="-1" role="dialog" aria-labelledby="header3" aria-hidden="true"
        data-backdrop="static" data-keyboard="false">
	    <div class="modal-header">
		    <button type="button" class="close" data-dismiss="modal" aria-hidden="true"></button>
			    <h3 id="header3">Add product</h3>
	    </div>
	    <div class="modal-body">
            <div class="floatingBox" id="searchitemform-error-box" style="display: none">
                <div class="alert alert-error" id="searchitemform-error-message">
                </div>
            </div>
            <div class="control-group">
                <button type="button" class="btn" id="btnRefreshItem">Refresh</button>
            </div>
            <div id="SearchResults">
            
            </div>
        </div>
	    <div class="modal-footer">
            <button type="button" class="btn btn-success" aria-hidden="true" id="btnSelectItem">Select product(s)</button>
            <button type="button" class="btn" data-dismiss="modal" id="btnCloseProduct" aria-hidden="true">Close and cancel</button>
	    </div>
    </div>
    <!-- end of bootstrap modal -->
    <div class="floatingBox" id="error-box" style="display: none">
        <div class="alert alert-error" id="error-message">
        </div>
    </div>

    <!-- Cancellation Form -->
    <uscCancellation:cancellationform ID="cancellationForm" runat="server" />

    <!-- Recent comment -->
    <uscComment:recentcomment ID="recentComment" runat="server" />
    <div class="row-fluid">
        <div class="floatingBox">
            <div class="container-fluid">
                <%  if (!String.IsNullOrEmpty(Q.q_no))
                    { %>
                <div class="control-group">
                    <label class="control-label">
                        Quotation code
                    </label>
                    <div class="controls labelDetail">
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
                    <div class="controls labelDetail">
                        <b><%=Q.status_name %></b>
                    </div>
                </div>
                <%  } %>
                <div class="control-group" id="source_selection">
                    <label class="control-label">
                        Source
                    </label>
                    <div class="controls">
                        <div class="span1"><label for="source1" class="radio"><input id="source1" type="radio" name="quo.source" value="1"/> RFQ</label></div>
                        <div class="span4"><label for="source2" class="radio"><input id="source2" type="radio" name="quo.source" value="2"/> Supplier</label></div>
                    </div>
                </div>
                <div class="control-group" id="source_rfq">
                    <label class="control-label">
                        RFQ code
                    </label>
                    <div class="controls labelDetail">
                        <input type="hidden" name="quo.rfq_id" value="<%=Q.rfq_id %>"/>
                        <input type="hidden" name="quo.rfq_no" data-title="RFQ code" placeholder="RFQ code" maxlength="20" disabled="disabled" value="<%=Q.rfq_no %>"/> 
                        <span id="rfq_no">
                            <%  if (Q.rfq_id != "0" && !String.IsNullOrEmpty(Q.rfq_id))
                                { %>

                                 <% var rfqDetailLink = "~/rfq/detail.aspx?id=" + Q.rfq_id + ""; %>
                                <a href="<%=Page.ResolveUrl(rfqDetailLink)%>" target="_blank"><%=Q.rfq_no %></a>
                            <%  }else{ %>
                            &nbsp;&nbsp;&nbsp;
                            <%  } %>
                        </span>
                        <button type="button" class="btn btn-success" id="btnRFQ">Select RFQ</button>
                    </div>
                </div>
                <div class="control-group" id="source_vendor">
                    <label class="control-label">
                        Supplier
                    </label>
                    <div class="controls">
                        <input type="hidden" name="quo.vendor_code" value="<%=Q.vendor_code %>">
                        <input type="hidden" name="quo.vendor_name" value="<%=Q.vendor_name %>">
                        <select name="quo.vendor" data-title="Supplier" data-validation="required" class="span8">
                            <%  if (!String.IsNullOrEmpty(Q.vendor_name))
                                { %>
                            <option value="<%=Q.vendor %>"><%=Q.vendor_name %></option>
                            <%  } %>
                        </select>
                        <%  if (Q.status_id == "5" || String.IsNullOrEmpty(Q.status_id))
                            { %>
                        <%  } %>
                    </div>
                </div>
                  <div class="control-group required">
                    <label class="control-label">
                       Supplier Address
                    </label>
                    <div class="controls">
                        <table  class="table table-bordered table-hover" style="border: 1px solid #ddd">
                            <thead>
                                <tr>
                                    <th style="width: 40%">Address</th>
                                    <th style="width: 30%">Contact person</th>
                                    <th style="width: 30%">Email</th>
                                    <th ></th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td>
                                        <div id="SupplierAddress" style="display:block">
                                             <select name="quo.supplier_address" class="span12"></select>
                                        </div>
                                       
                                        <div id="SundryAddress"></div>
                                    </td>
                                    <td id="SupplierContactPerson"></td>
                                    <td id="SupplierEmail" class="wrapCol"></td>
                                    <td id="SupplierAction" data-id=""> 
                                         
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
                <div class="control-group required">
                    <label class="control-label">
                        Supplier quotation number
                    </label>
                    <div class="controls">
                        <input type="text" name="quo.vendor_document_no" data-title=" Supplier quotation number" data-validation="required" placeholder=" Supplier quotation number" class="span4" maxlength="50" value="<%=Q.vendor_document_no %>"/>
                    </div>
                </div>
                <div class="control-group" id="rfq_reff">
                    <label class="control-label">
                        RFQ reference code
                    </label>
                    <div class="controls">
                        <select name="quo.reff_rfq_no" data-title="RFQ reference" class="span4">
                            <%  if (!String.IsNullOrEmpty(Q.reff_rfq_no))
                                { %>
                            <option value="<%=Q.reff_rfq_no %>"><%=Q.reff_rfq_no %></option>
                            <%  } %>
                        </select>
                    </div>
                </div>
                <div class="control-group required">
                    <label class="control-label">
                        Received date
                    </label>
                    <div class="controls">
                        <div class="input-prepend" style="margin-right:-32px;">
                            <input type="text" name="quo.receive_date" id="_receive_date" data-validation="required date" data-title="Received date" class="span8" readonly="readonly" placeholder="Received date" maxlength="11"/>
                            <span class="add-on icon-calendar" id="receive_date"></span>
                        </div>  
                    </div>
                </div>
                <div class="control-group required">
                    <label class="control-label">
                        Quotation date
                    </label>
                    <div class="controls">
                        <div class="input-prepend" style="margin-right:-32px;">
                            <input type="text" name="quo.document_date" id="_document_date" data-validation="required date" data-title="Quotation date" class="span8" readonly="readonly" placeholder="Quotation date" maxlength="11"/>
                            <span class="add-on icon-calendar" id="document_date"></span>
                        </div>  
                    </div>
                </div>
                <div class="control-group">
                    <label class="control-label">
                       End of validity date
                    </label>
                    <div class="controls">
                        <div class="input-prepend" style="margin-right:-32px;">
                            <input type="text" name="quo.due_date" id="_due_date" data-validation="date" data-title="End of validity date" class="span8" readonly="readonly" placeholder="End of validity date" maxlength="11"/>
                            <span class="add-on icon-calendar" id="due_date"></span>
                        </div>  
                    </div>
                </div>
                <div class="control-group required" id="div_payment_terms">
                    <label class="control-label">
                        Payment terms
                    </label>
                    <div class="controls">
                        <select name="quo.payment_terms"  class="span4" data-validation="required" data-title="Payment terms"></select> 
                    </div>
                </div>

                <div class="control-group" id="div_is_other_payment">
                    <label class="control-label">
                        Other payment terms
                    </label>
                    <div class="controls">
                        <input type="checkbox" name="quo.is_other_payment_terms"/><label for="quo.is_other_payment_terms"></label>
                    </div>
                </div>
                
                <div class="control-group" id="div_other_payment" style="display:none;">
                    <div class="controls">
                        <textarea name="quo.other_payment_terms" maxlength="1000" rows="3" class="span10 textareavertical" data-title="Other payment terms" placeholder="Other payment terms"><%=Q.other_payment_terms%></textarea>
                        <br />
                        <small><i>Maximum other payment terms is 1,000 characters</i></small>
                    </div>
                </div>
             <%--   <div class="control-group required" id="div_other_payment" style="display: none;">
                      <label class="control-label">
                        Other payment terms
                    </label>
                    <div class="controls">
                        <textarea name="quo.other_payment_terms" maxlength="1000" rows="3" class="span10 textareavertical" data-title="Other payment terms" placeholder="Other payment terms"></textarea>
                        <br />
                        <small><i>Maximum other payment terms is 1,000 characters</i></small>
                    </div>
                </div>--%>

                <div class="control-group">
                    <label class="control-label">
                        Remarks
                    </label>
                    <div class="controls">
                        <textarea name="quo.remarks" maxlength="1000" rows="3" class="span10 textareavertical" placeholder="Remarks"><%=Q.remarks %></textarea>
                         <div class="mt-1" style="font-size: 80%; font-style: italic; display: block;">Maximum description is 1,000 characters</div>
                    </div>
                </div>
                <div class="control-group required">
                    <label class="control-label">
                        Product(s)
                    </label>
                    <div class="controls">
                        <table id="tblItems" class="table table-bordered table-hover required" data-title="Product(s)" style="border: 1px solid #ddd">
                            <thead>
                                <tr>
                                    <th style="width:15%;">Product code</th>
                                    <th style="width:20%;">PR description</th>
                                    <th style="width:20%;">Quotation description  <span style="color: Red;">*</span></th>
                                    <th style="width:10%;">PR code</th>
                                    <th style="width:15%;" id="labelTotalQ">Total</th>
                                    <th style="width:15%;">Total (USD)</th>
                                    <th style="width:5%;">&nbsp;</th>
                                 </tr>
                            </thead>
                            <tbody></tbody>
                            <tfoot>
                                <tr>
                                    <th>Discount total</th>
                                    <th colspan="3">

                                        <select name="quo.discount_type" class="span2">
                                            </select>
                                         <div style="display:inline-block" id="discount_currency">
                                                <select  name="quo.discount_currency" class="span8"></select>
                                         </div>  
                                         </div>  
                                        <div class="input-prepend">
                                            <span class="add-on" id="txt_TypeAmt"></span>
                                            <input type="text" data-validation="required" name="quo.discount" data-value="" data-maximum-attr="discount" data-maximum="" class="span10 number" maxlength="18" data-decimal-places="2"/>
                                        </div>
                                    </th>
                                    <th id="discountTotal" style="text-align:right; font-weight:bold;"></th>
                                    <th style="text-align:right; font-weight:bold;">
                                        <div id="discountUSD" style="display:block">0.00</div>
                                        <div id="totalOriginalUSD" style="display:none"></div>
                                    </th>
                                    <th></th>
                                </tr>
                                <tr>
                                    <th colspan="4" style="text-align:right; font-weight:bold;">Grand total
                                        <input type="hidden" id="GrandTotalBeforeDesc"/>
                                        <input type="hidden" id="GrandTotalUSDBeforeDesc"/>
                                    </th>
                                    <th id="GrandTotal" style="text-align: right; font-weight:bold;"></th>
                                    <th id="GrandTotalUSD" style="text-align: right; font-weight:bold;"></th>
                                    <th>&nbsp;</th>
                                </tr>
                            </tfoot>
                        </table>
                        <p><button id="btnAddItem" class="btn btn-success" type="button">Add product</button></p>
                    </div>
                </div>
                <div class="control-group required">
                    <label class="control-label">
                        Quotation file(s)
                    </label>
                    <div class="controls">
                        <table id="tblAttachment" class="table table-bordered table-hover required" data-title="Quotation file(s)" style="border: 1px solid #ddd">
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
                        <p><button id="btnAddAttachment" class="btn btn-success" type="button">Add quotation file</button></p>
                    </div>
                </div>
                <div class="control-group last">
                    <div class="controls">
                        <button id="btnClose" class="btn" type="button">Close page</button>&nbsp;&nbsp;&nbsp;
                        <%  if (Q.status_id == "5" || String.IsNullOrEmpty(Q.status_id))
                            { %>
                            <button id="btnSave" class="btn btn-success" type="button" data-action="saved">Save as draft</button>
                        <%  } %>
                            <button id="btnSubmit" class="btn btn-success" type="button" data-action="<%=(Q.status_id=="5" || String.IsNullOrEmpty(Q.status_id))?"submitted":"updated" %>">
                            <%=(Q.status_id=="5" || String.IsNullOrEmpty(Q.status_id))?"Submit":"Update" %></button>
                        <%  if (max_status != "50")
                            { %>
                        
                        <%  if (max_status == "25" && String.IsNullOrEmpty(copy_id))
                            { %>
                        <button id="btnCancel" class="btn btn-danger" type="button" data-action="cancelled">Cancel this Quotation</button>
                        <%  } %>
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
            <h3 id="header1">Add detail sundry supplier</h3>
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
            <button type="button" class="btn btn-success" aria-hidden="true" id="btnSundrySave">Save</button>
            <button type="button" class="btn" data-dismiss="modal" aria-hidden="true">Close and cancel</button>
        </div>
    </div>
    <!-- end of bootstrap modal -->

    <script>
        var _pr_detail_id = "<%=pr_detail_id%>";
        var listHeaders = <%= listHeaders %>;
        var btnAction = "";
        var workflow = new Object();
        var status_id = "<%=Q.status_id%>";

        var dataRFQ = [];
        var RFQResults = initTable();

        var listOffice = <%=listOffice%>;
        var startDate = new Date("<%=startDate%>");
        var endDate = new Date("<%=endDate%>");
        var cifor_office = "<%=Q.cifor_office_id%>";
        var userOffice = "<%=cifor_office%>";


        var listCurrency = <%=listCurrency%>;
        var _currency = "<%=Q.currency_id%>";
        var receive_date = "<%=Q.receive_date%>";
        var document_date = "<%=Q.document_date%>";
        var due_date = "<%=Q.due_date%>";
        var source = "<%=Q.source%>"; 
        var disc_type = "<%=Q.discount_type%>";
        var is_other_payment_terms = "<%=Q.is_other_payment_terms%>";

        var QuoItems = <%=listDetails%>;
        var Attachments = <%=listAttachments%>;
        var deletedId = [];

        var listDiscType = [{ id: "$" }, { id: "%" }];
        var listDiscCurrency = [{ id: "USD" }];

        var payment_term = "<%= Q.payment_terms%>";
        var other_payment_term = ""
        var listPaymentTerm = <%= listPaymentTerm %>;
        listPaymentTerm = $.grep(listPaymentTerm, function (n, i) {
            return n["Id"] != "OTH";
        });

        var supplierId = "<%=Q.vendor%>";
        var supplierAddressId = "<%=Q.vendor_address_id%>";
        var listSupplierAddress = <%= listSupplierAddress%>

        var dataSundry = <%= listSundry %>;
        var vendor_categories = "";
        var item_categories = "";
        var usedPRItems = [];
        var t_cat = null;
        var t_item = null;
        var filenameupload = "";
        var btnFileUpload = null;
        var listSelVendor = [];
        var selectedItems = [];

        //document ready
        $(document).ready(function () {
            populateHeader();
            /* RFQ form */
            var cboOffice = $("#cboOffice");
            generateComboGroup(cboOffice, listOffice, "office_id", "office_name", "hub_option", true);
            $(cboOffice).val(cifor_office);
            Select2Obj(cboOffice, "Purchase office");

            $("#startDate").datepicker({
                format: "dd M yyyy"
                , autoclose: true
            }).on("changeDate", function () {
                $("#_startDate").val($("#startDate").data("date"));
                $("#startDate").datepicker("hide");
                startDate = new Date($("#startDate").data("date"));
                $('#endDate').datepicker('setStartDate', (startDate.getDate().toString().length < 2 ? '0' + startDate.getDate() : startDate.getDate()) + ' ' + ((startDate.getMonth() + 1).toString().length < 2 ? '0' + (startDate.getMonth() + 1) : (startDate.getMonth() + 1)) + ' ' + startDate.getFullYear());
            });

            $("#endDate").datepicker({
                format: "dd M yyyy"
                , autoclose: true
                , startDate: (startDate.getDate().toString().length < 2 ? '0' + startDate.getDate() : startDate.getDate()) + ' ' + ((startDate.getMonth() + 1).toString().length < 2 ? '0' + (startDate.getMonth() + 1) : (startDate.getMonth() + 1)) + ' ' + startDate.getFullYear()
            }).on("changeDate", function () {
                $("#_endDate").val($("#endDate").data("date"));
                $("#endDate").datepicker("hide");
            });

            $("#startDate").datepicker("setDate", startDate).trigger("changeDate");
            $("#endDate").datepicker("setDate", endDate).trigger("changeDate");
            /* end of RFQ form */

            /* item form */
            var cboItemDiscType = $("select[name='item.discount_type']");
            generateCombo(cboItemDiscType, listDiscType, "id", "id", true);
            $(cboItemDiscType).val(disc_type);
            Select2Obj(cboItemDiscType, "Type");

            $(document).on("change", "[name='item.unit_price'],[name='item.discount']", function () {
                CalculateTotalPerItem();
            });

            $(document).on("change", "[name='item.quotation_quantity']", function () {
                if (delCommas($("[name='item.quotation_quantity']").val()) < delCommas($("[name='item.quantity']").val())) {
                    $("[name='item.quantity']").val($("[name='item.quotation_quantity']").val());
                }
                CalculateTotalPerItem();
            });

            $(document).on('change', "select[name='item.discount_type']", function (e) {
                $("#txt_TypeAmt_Item").hide();
                if ($(this).val() == "$") {
                    $("#txt_TypeAmt_Item").show();
                    //new update discount curreny default USD
                    $("#txt_TypeAmt_Item").text($("[name='item.currency_id']").val());
                    
                }
                CalculateTotalPerItem();
            });
            /* end of item form */

            /* main form */
            if (_pr_detail_id != "" && _pr_detail_id != "0") {
                source = 2;
                loadSearchItem(_pr_detail_id);
            }

            createCboRFQRef();

            $("[name='quo.source'][value='" + source + "']").prop("checked", true);
            changeSource();

            createCboVendor();
           // GetVendorCategories();
            $("[name='quo.vendor']").on("select2:select", function (e) {
                resetSource(2);

                var dVendor = $(this).select2("data");
                if (dVendor) {
                    dVendorName = dVendor[0].text.split(" - ");
                    if (dVendorName.length > 2) {
                        $("[name='quo.vendor_name']").val(dVendorName[1]+" - "+dVendorName[2]);
                        $("[name='quo.vendor_code']").val(dVendorName[0]);
                    } else {
                     $("[name='quo.vendor_name']").val(dVendorName[1]);
                     $("[name='quo.vendor_code']").val(dVendorName[0]);
                    }
                  
               
                }

              //  GetVendorCategories();
                PopulateItemCategories();
            });

            if (delCommas($("#status").val()) > "5") {
                $("#source_selection").hide();
                $("#btnRFQ").hide();
                $("[name='quo.vendor']").prop("disabled", true);
            }

            var cboCurr = $("select[name='quo.currency_id']");
            generateCombo(cboCurr, listCurrency, "CURRENCY_CODE", "CURRENCY_CODE", true);
            $(cboCurr).val(_currency);
            Select2Obj(cboCurr, "Currency");

            populateCurrency();

            $(cboCurr).on('select2:select', function (e) {
                changeExchangeRate($(this).val());
                populateCurrency();
            });

            $("#receive_date").datepicker({
                format: "dd M yyyy"
                , autoclose: true
            }).on("changeDate", function () {
                $("#_receive_date").val($("#receive_date").data("date"));
                $("#receive_date").datepicker("hide");
            });

            $("#document_date").datepicker({
                format: "dd M yyyy"
                , autoclose: true
            }).on("changeDate", function () {
                $("#_document_date").val($("#document_date").data("date"));
                $("#document_date").datepicker("hide");
            });

            $("#due_date").datepicker({
                format: "dd M yyyy"
                , autoclose: true
            }).on("changeDate", function () {
                $("#_due_date").val($("#due_date").data("date"));
                $("#due_date").datepicker("hide");
            });

            if (receive_date != "") {
                $("#receive_date").datepicker("setDate", new Date(receive_date)).trigger("changeDate");
            }
            if (document_date != "") {
                $("#document_date").datepicker("setDate", new Date(document_date)).trigger("changeDate");
            }
            if (due_date != "") {
                $("#due_date").datepicker("setDate", new Date(due_date)).trigger("changeDate");
            }

            var cboDiscType = $("select[name='quo.discount_type']");
            generateCombo(cboDiscType, listDiscType, "id", "id", true);
            $(cboDiscType).val(disc_type);
            Select2Obj(cboDiscType, "Type");

            $(cboDiscType).on('select2:select', function (e) {
                changeDiscountType();
                proRateDiscount();
            });

            $("[name='quo.discount']").on("change", function (e) {
                var discType = $("[name='quo.discount_type']").val();
                if (discType == "$") {
                    calculateDiscount();
                }
                proRateDiscount();
            });


            changeDiscountType();
      
            $.each(QuoItems, function (i, d) {
                addItems(d);
            });
            proRateDiscount();

            $.each(Attachments, function (i, d) {
                addAttachment(d.id, "", d.file_description, d.filename);
            });
            /* end of main form */

            repopulateNumber();
            populateUsedItems();
            PopulateItemCategories();
            normalizeMultilines();

            $("[name='docidtemp']").val(guid());

            if (is_other_payment_terms == 1) {
                $("[name='quo.is_other_payment_terms']").prop("checked", true);
                checkOtherPayment(true);
            } else {
                checkOtherPayment(false);
            }

            if (delCommas($("#status").val()) == 50) {
                $("[name^='quo.']").prop("disabled", true);
                $(".icon-calendar").hide();
            }

            loadCurrentAddressSundry();
        });
        //end document ready

        function changeDiscountType() {
            $("#txt_TypeAmt").hide();
            //$("[name='quo.discount_currency']").hide();

            $("#discount_currency").hide();

            if ($("[name='quo.discount_type']").val() == "$") {
                $("[name='quo.discount']").data("maximum", "");
                $("#txt_TypeAmt").show();
                //new update discount curreny default USD
                $("#txt_TypeAmt").text("USD");
                $("#discount_currency").show();
                $("select[name='quo.discount_currency']").val('USD');
            } else {
                $("[name='quo.discount']").data("maximum", "100");
            }
        }

        /* search form */
        function initTable(){
            return $('#RFQResults').DataTable({
                data: dataRFQ,
                "aoColumns": [
                    {
                        "mDataProp": "id"
                        ,"mRender": function (d, type, row) {
                            var html = '<button type="button" class="btn btnSelectRFQ" data-id="'+row.id+'">Select RFQ</button>';
                            return html;
                        }
                        , "width" : "5%" 
                    },
                    {
                        "mDataProp": "rfq_no"
                        ,"mRender": function (d, type, row) {
                            var html = '<a href="<%=Page.ResolveUrl("~/rfq/detail.aspx?id=' + row.id + '")%>" title="View detail" target="_blank">' + row.rfq_no + '</a>';
                            return html;
                        }
                        , "width" : "20%" 
                    },
                    { "mDataProp": "created_date", "width" : "20%"  },
                    { "mDataProp": "vendor_name", "width" : "40%"  },
                    { "mDataProp": "office_name", "width" : "15%"  },
                ],
                "bFilter": true, "bDestroy": true, "bRetrieve": true, "pagingType": 'full_numbers',
                "iDisplayLength": 5
                ,"bLengthChange": false
                ,"searching": false,
                "info": false
            });
        }

        $(document).on("click", "#btnRFQ", function () {
            $("#RFQForm").modal("show");
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
            data.cifor_office = userOffice //user logon cifor_office;

            dataRFQ = null;
            
            $("#RFQResults tbody tr").html("processing..");
            $.ajax({
                url: "<%=Page.ResolveUrl("~/Service.aspx/GetRFQList")%>",
                data: JSON.stringify(data),
                dataType: 'json',
                type: 'post',
                contentType: "application/json; charset=utf-8",
                success: function (response) {
                    dataRFQ = JSON.parse(response.d);
                    RFQResults.clear().draw();
                    RFQResults.rows.add(dataRFQ).draw();
                }
            });
        }

        $(document).on("click", ".btnSelectRFQ", function () {
            resetSource();
            resetDataSundry();

            var id = $(this).data("id");
            loadRFQData(id);

        });

        function loadRFQData(rfq_id) {
            $.ajax({
                url: "<%=Page.ResolveUrl("~/Service.aspx/GetRFQData")%>",
                data: '{rfq_id:"' + rfq_id + '"}',
                dataType: 'json',
                type: 'post',
                contentType: "application/json; charset=utf-8",
                success: function (response) {
                    rfq = JSON.parse(response.d);

                    if (rfq.Table.length > 0) {

                       

                        $("[name='quo.rfq_id']").val(rfq.Table[0].id);
                        $("[name='quo.rfq_no']").val(rfq.Table[0].rfq_no);
                        $("#rfq_no").html('<a href="<%=Page.ResolveUrl("~/rfq/detail.aspx?id=' +  rfq.Table[0].id + '")%>" title="View detail" target="_blank">' + rfq.Table[0].rfq_no + '</a>&nbsp;&nbsp;&nbsp;');
                        cifor_office = rfq.Table[0].cifor_office_id;
                        listSelVendor = [{
                            vendor_id: rfq.Table[0].vendor
                            , vendor_name: rfq.Table[0].vendor_name + ' (' + rfq.Table[0].vendor_code + ')'
                        }];
                        
                        var cboVendor = $("[name='quo.vendor']");
                        $(cboVendor).empty();
                        generateCombo(cboVendor, listSelVendor, "vendor_id", "vendor_name", true);
                        $(cboVendor).val(rfq.Table[0].vendor);
                        createCboVendor();
                        
                        $("[name='quo.vendor_code']").val(rfq.Table[0].vendor_code);
                        $("[name='quo.vendor_name']").val(rfq.Table[0].vendor_name);
                        supplierId = rfq.Table[0].vendor;
                        supplierAddressId = rfq.Table[0].vendor_contact_person;
                        lookUpSupplierAddress();
                        setPaymentTerms();

                        if (rfq.Table[0].IsSundry == "1") {
                            resetSupplierAddress();
                            hideSelectSupplierAddress();
                            loadBtnEditSundry();
                            $("#SundryAddress").html(rfq.Table[0].vendor_address);
                            $("#sundry_address").val(rfq.Table[0].vendor_address);
                        
                            $("#SupplierAction").attr("data-id", rfq.Table[0].vendor);

                            if (rfq.Table3.length > 0) {
                                loadRFQSundry(rfq.Table3[0]);
                            }
                        }
                        else {
                            //resetSupplierAddress();
                            $("#SupplierAction").empty();
                            $("#SundryAddess").empty();
                            showSelectSupplierAddress();
                        }

                    }
                    QuoItems = [];
                    $.each(rfq.Table1, function (i, d) {
                        var qd = new Object();
                        qd.id = "";
                        qd.uid = guid();
                        qd.item_id = d.item_id;
                        qd.item_code = d.item_code;
                        qd.brand_name = d.brand_name;
                        qd.description = d.description;
                        qd.item_description = d.item_description;
                        qd.uom = d.uom;
                        qd.uom_id = d.uom_id
                        qd.quantity = d.request_quantity;
                        qd.quotation_quantity = d.request_quantity;
                        qd.unit_price = d.pr_unit_price;
                        qd.source_quantity = d.rfq_quantity;
                        qd.pr_quantity = d.pr_qty;
                        qd.rfq_quantity = d.request_quantity;
                        qd.vs_quantity = d.vs_qty;
                        qd.pr_currency = d.pr_currency;
                        qd.pr_unit_price = d.pr_unit_price;
                        qd.pr_estimated_cost = d.pr_estimated_cost;
                        qd.rfq_detail_id = d.id;
                        qd.rfq_id = d.rfq_id;
                        qd.pr_detail_id = d.pr_detail_id;
                        qd.pr_id = d.pr_id;
                        qd.pr_no = d.pr_no;
                        qd.status_id = 25;
                        qd.discount_type = "$";
                        qd.discount = 0;
                        qd.discount_amount = 0;
                        qd.additional_discount = 0;
                        qd.indent_time = "";
                        qd.warranty = "";
                        qd.remarks = "";
                        qd.source_quantity = d.request_quantity;
                        qd.subcategory = d.subcategory;
                        qd.currency_id = d.currency_id;
                        qd.exchange_sign = d.exchange_sign;
                        qd.exchange_rate = d.exchange_rate;

                        QuoItems.push(qd);
                    });

                    $.each(QuoItems, function (i, d) {
                        addItems(d);
                    });

                    proRateDiscount();
                    $("#RFQForm").modal("hide");
                    normalizeMultilines();
                }
            });
        }
        /* end of search form */

        /* main form */
        function createCboRFQRef() {
            $("[name='quo.reff_rfq_no']").select2({
                placeholder: "RFQ reference",
                minimumInputLength: 2,
                allowClear: true,
                ajax: {
                    url: "<%=Page.ResolveUrl("~/Service.aspx/GetRFQSession")%>",
                    type: "POST",
                    dataType: "json",
                    delay: 500,
                    contentType: "application/json; charset=utf-8",
                    data: function (params) {
                        var obj = new Object();
                        obj.search = params.term;
                        return JSON.stringify(obj);
                    },
                    processResults: function (data, params) {
                        return {
                            results: data.d
                        };
                    }
                }
            });
        }
        function createCboVendor() {
            $("[name='quo.vendor']").select2({
                placeholder: "Supplier",
                minimumInputLength: 2,
                allowClear: true,
                ajax: {
                    url: "<%=Page.ResolveUrl("~/Service.aspx/GetVendorByCategory")%>",
                    type: "POST",
                    dataType: "json",
                    delay: 500,
                    contentType: "application/json; charset=utf-8",
                    data: function (params) {
                        var obj = new Object();
                        obj.search = params.term;
                       // obj.subcategory = item_categories.join(';');
                        obj.subcategory = "";  //open all category
                        return JSON.stringify(obj);
                    },
                    processResults: function (data, params) {
                        return {
                            results: data.d
                        };
                    }
                }
            });
        }

        function GetVendorCategories() {
            var currVendor = $("[name='quo.vendor']").val();
            vendor_categories = "";
            if (currVendor != "" && currVendor != null) {
                $.ajax({
                    url: "<%=Page.ResolveUrl("~/Service.aspx/GetVendorCategories")%>",
                    data: '{vendor_id: "' + currVendor + '"}',
                    dataType: 'json',
                    type: 'post',
                    contentType: "application/json; charset=utf-8",
                    success: function (response) {
                        vendor_categories =  response.d;
                    }
                });
            }
        }

        $(document).on("change", "input[name='quo.source']", function () {
            resetSource();
            resetDataSundry();
            $("#SupplierAction").empty();
            $("#SundryAddress").empty();
            resetSupplierAddress();
            changeSource();

            showSelectSupplierAddress();

        });

        function resetSource(source_type) {
            var prev_source = source;
            var current_source = $("input[name='quo.source']:checked").val();

            if (typeof source_type === "undefined") {
                source_type = 1;
            }

            if (source_type == 1) {
                $("[name='quo.vendor']").empty();
                $("[name='quo.vendor_code']").val("");
                $("[name='quo.vendor_name']").val("");
            }

            $("[name='quo.rfq_id']").val("");
            $("[name='quo.rfq_no']").val("");
            $("[name='quo.reff_rfq_no']").find("option").remove();
            $("#rfq_no").html("");
            if (prev_source != current_source || source_type=="1") {
                $.each(QuoItems, function (i, d) {
                    if (d.id != "") {
                        var _del = new Object();
                        _del.id = d.id;
                        _del.table = "item";
                        deletedId.push(_del);
                    }
                });

                usedPRItems = [];
                QuoItems = [];
                $("#tblItems tbody").html("");
                $("[name='quo.discount']").val("0.00");
                $("#GrandTotal").text("0.00");
                $("#GrandTotalUSD").text("0.00");
                PopulateItemCategories();
                listDiscCurrency = [{ id: "USD" }];
                lookUpDiscCurrency();
            }

            source = source_type;
        }

        function changeSource() {
            var sel = $("input[name='quo.source']:checked").val();
            $("#source_vendor").addClass("required");
            /* RFQ */
            if (sel == "1") {
                $("#source_rfq").show();
                $("[name='quo.vendor']").prop("disabled", true);
                $("#source_rfq").addClass("required");
                //$("#source_vendor").removeClass("required");
                $("[name='quo.rfq_no']").data("validation", "required");
                $("#btnAddItem").hide();
                $("#btnNewVendor").hide();
                $("#rfq_reff").hide();
            }
            /* PR */
            else if (sel == "2") {
                $("#source_rfq").hide();
                $("[name='quo.vendor']").prop("disabled", false);
                //$("#source_vendor").addClass("required");
                $("#source_rfq").removeClass("required");
                $("[name='quo.rfq_no']").data("validation", "");
                $("#btnAddItem").show();
                $("#btnNewVendor").show();
                $("#rfq_reff").show();
            }
            source = sel;
        }

        $(document).on("click", "#btnAddItem", function () {
            $("#SearchItemForm").modal("show");
        });

        function addItems(d) {
            if (typeof d.uid === "undefined" || d.uid == "" || d.uid == null) {
                d.uid = guid();
            }

            var html = "<tr id='item_" + d.uid + "'>";
            html += "<td>" + d.item_code + "</td>";
            html += "<td>" + d.item_description;
                if (d.brand_name != "" && d.brand_name != null) {
                    brand_name = NormalizeString(d.brand_name);
                } else {
                    brand_name = "";
                }
            html += "</td>";
            html += "<td id='quotation_description_" + d.uid + "'>";
            if (typeof d.quotation_description !== "undefined") {
                html += d.quotation_description;
            } else {
                d.quotation_description = "";
            }

            html += "</td>";
            html += '<td><a href="<%=Page.ResolveUrl("~/purchaserequisition/detail.aspx?id='+d.pr_id +'")%>" targ="_blank"">' + d.pr_no + '</a></td>';
            html += "<td id='total_" + d.uid + "' style='text-align: right;'></td>";
            html += "<td id='totalUSD_" + d.uid + "' style='text-align: right;'></td>";
            html += "<td><input type='hidden' name='item.id' value='" + d.id + "'/>";
            html += "<input id='quo_description_" + d.uid + "' type='hidden' data-validation='required' data-title='Quotation description'  value='" + d.quotation_description + "'/>";
            html += "<input id='quo_currency_" + d.uid + "' type='hidden' data-validation='required' data-title='Currency " + d.item_code + " - " + d.pr_no + "'   value='" + d.currency_id + "' />";
            if (d.status_id < 50) {
                html += '<span class="label green btnEdit" title="Edit"><i class="icon-pencil edit" style="opacity: 0.7;"></i></span>';
                if (source == 2) {
                    html += '<span class="label red btnDelete" title="Delete"><i class="icon-trash delete" style="opacity: 1;"></i></span>';
                }
            } else if (d.status_id == 50) {
                html += '<span class="label peterRiver btnView" title="View"><i class="icon-zoom-in view" style="opacity: 0.7;"></i></span>';
            }
            html += "&nbsp;</td>";

            $("#tblItems tbody").append(html);
        }

        function proRateDiscount() {
            $.each(QuoItems, function (i, d) {
                d.additional_discount = 0;
            });
            
           calculateItems();

            var grandTotalBeforeDisc = delCommas($("#GrandTotalBeforeDesc").val());
            var grandTotalUSDBeforeDisc = delCommas($("#GrandTotalUSDBeforeDesc").val());
            var discType = $("[name='quo.discount_type']").val();
            var discCurrency = $("#txt_TypeAmt").text();
            var disc = 0;
            var discUSD = 0;
            var totalAddDiscount = 0;
            var totalAddDiscountUSD = 0;
            var totalOriginalUSD = 0;
            $.each(QuoItems, function (i, d) {
                if (discType == "$") {

                    disc = delCommas($("[name='quo.discount']").val());
                    calculateDiscount();

                    if (discCurrency == "USD") {
                        discUSD = delCommas($("#discountUSD").text());
                    } else {
                       
                        if (d.exchange_sign === "/") {
                            discUSD = delCommas(accounting.formatNumber(disc / d.exchange_rate, 8));
                        } else {
                            discUSD = delCommas(accounting.formatNumber(disc * d.exchange_rate, 8))
                        }
                    }
                
                    d.additional_discount = delCommas(accounting.formatNumber(((d.line_total_usd_original / grandTotalUSDBeforeDisc) * discUSD) / d.exchange_rate, 2))
                    totalAddDiscountUSD += delCommas(accounting.formatNumber(((d.line_total_usd_original / grandTotalUSDBeforeDisc) * discUSD), 2));
                } else if (discType == "%") {
                    disc = delCommas($("[name='quo.discount']").val());
                    discUSD = delCommas($("[name='quo.discount']").val()) / 100 * grandTotalUSDBeforeDisc;
                    d.additional_discount = delCommas(accounting.formatNumber(((d.line_total_usd_original / grandTotalUSDBeforeDisc) * discUSD) / d.exchange_rate, 2));
                    totalAddDiscountUSD += delCommas(accounting.formatNumber(((d.line_total_usd_original / grandTotalUSDBeforeDisc) * discUSD), 2));
                }

                if (delCommas(accounting.formatNumber(totalAddDiscountUSD, 2)) > delCommas(accounting.formatNumber(discUSD, 2))) {
                    totalAddDiscountUSD -= d.additional_discount * d.exchange_rate;
                    d.additional_discount = delCommas(delCommas(accounting.formatNumber(discUSD, 2)) - delCommas(accounting.formatNumber(totalAddDiscountUSD, 2)) / d.exchange_rate);
                }
                totalOriginalUSD += d.line_total_usd_original;
            });
            calculateItems();

            $("#discountTotal").text(accounting.formatNumber(disc, 2));
            if (discType == "%") {
                $("#discountUSD").css("display", "none");
                $("#totalOriginalUSD").css("display", "block");

                totalOriginalUSD = (totalOriginalUSD * disc) / 100;
                $("#totalOriginalUSD").text(accounting.formatNumber(totalOriginalUSD, 2));
            } else {
                $("#discountUSD").css("display", "block");
                $("#totalOriginalUSD").css("display", "none");
            } 



        }

        function calculateItems() {

            var grandTotal = 0;
            var grandTotalUSD = 0;
            var grandTotalBeforDisc = 0;
            var grandTotalUSDBeforDisc = 0;
            
       
            const groupGrandTotal = [];
            $.each(QuoItems, function (i, d) {
                var _uid = d.uid;
                var sign = d.exchange_sign;
                var rate = d.exchange_rate;

                d.line_total = delCommas(d.quotation_quantity) * delCommas(d.unit_price);
                d.line_total_usd = d.line_total * rate;

                d.line_total_original = delCommas(d.quotation_quantity) * delCommas(d.unit_price);
                d.line_total_usd_original = d.line_total * rate;

                /* discount */
                if (d.discount_type == "%") {
                    d.discount_amount = delCommas(accounting.formatNumber(d.discount / 100 * d.line_total, 2));
                } else if (d.discount_type == "$") {
                    d.discount_amount = d.discount;
                }

                d.line_total = delCommas(accounting.formatNumber(d.line_total - d.discount_amount, 2));

                grandTotalBeforDisc += d.line_total;
                grandTotalUSDBeforDisc += d.line_total_usd;

                /* pro rated discount */
                d.line_total = delCommas(accounting.formatNumber(d.line_total - d.additional_discount,2));

                if (sign === "/") {
                    d.line_total_usd = delCommas(accounting.formatNumber(d.line_total / rate, 2));
                    d.line_total_usd_original = delCommas(accounting.formatNumber(d.line_total_original / rate, 2));
                } else {
                    d.line_total_usd = delCommas(accounting.formatNumber(d.line_total * rate, 2));
                    d.line_total_usd_original = delCommas(accounting.formatNumber(d.line_total_original * rate, 2));
                }

                grandTotal += d.line_total;
                grandTotalUSD += d.line_total_usd;
                var total = "";
                var total_original = ""
                if (typeof d.currency_id === "undefined" || d.currency_id == null) {
                    total = accounting.formatNumber(d.line_total, 2);
                    total_original = accounting.formatNumber(d.line_total_original, 2);
                } else {
                    total = d.currency_id + " " + accounting.formatNumber(d.line_total, 2);
                    total_original = d.currency_id + " " + accounting.formatNumber(d.line_total_original, 2);
                }
               
                $("#total_" + _uid).text(total_original);
                $("#totalUSD_" + _uid).text(accounting.formatNumber(d.line_total_usd_original, 2));
                $("[name='item.line_total_usd']").val(accounting.formatNumber(d.line_total_usd, 2));

                //set groupGrandTotal groub by currency
                var gid = groupGrandTotal.findIndex(x => x.currency_id === d.currency_id);
                if (gid == -1) {
                    groupGrandTotal.push({ currency_id: d.currency_id, total: d.line_total });

                    var dscCurrency = listDiscCurrency.findIndex(x => x.id === d.currency_id);

                    if (dscCurrency == -1 && d.currency_id != null) {
                        listDiscCurrency.push({ id: d.currency_id });
                    }
                } else {
                    var gd = groupGrandTotal[gid];
                    gd.total += d.line_total;
                }
            });
            var grandTotal = ""
            $.each(groupGrandTotal, function (i, d) {
                if (d.currency_id == null) {
                    grandTotal += accounting.formatNumber(d.total, 2) + "</br>";
                } else {
                    grandTotal += d.currency_id + " " + accounting.formatNumber(d.total, 2) + "</br>";
                }
            });

            $("#GrandTotalBeforeDesc").val(accounting.formatNumber(grandTotalBeforDisc, 2));
            $("#GrandTotalUSDBeforeDesc").val(accounting.formatNumber(grandTotalUSDBeforDisc, 2));
            $("#GrandTotal").html(grandTotal);
            $("#GrandTotalUSD").text(accounting.formatNumber(grandTotalUSD, 2))
            lookUpDiscCurrency();
        }

        $(document).on("change", "[name='quo.exchange_rate']", function () {
            calculateItems();
        });

        function changeExchangeRate(curr) {
            var arr = $.grep(listCurrency, function (n, i) {
                return n["CURRENCY_CODE"] === curr;
            });

            var _sign = "/";
            var _rate = 0;
            if (arr.length > 0) {
                if (arr[0].OPERATOR === "/") {
                    _sign = "&divide;";
                } else {
                    _sign = "x";
                }
                _rate = accounting.formatNumber(arr[0].RATE,8);
            }

            $("#exchange_sign").html(_sign);
            $("[name='quo.exchange_sign']").val(arr[0].OPERATOR);
            $("[name='quo.exchange_rate']").val(_rate);

            calculateItems();
        }

        function populateCurrency() {
            var curr = $("[name='item.currency_id']").val();
            var dscCurr = $("select[name = 'quo.discount_currency'] option:selected").val();
            if (curr != null) {
                $("#txt_TypeAmt").text(dscCurr);
                $(".currency").text(curr);
            }
        }

        /* end of main form */

        /* Item Form */
        function resetItemForm() {
            $("[name^='item.']").prop("disabled", false);
            $("[name='item.total'],[name='item.additional_discount'],[name='item.line_total'],[name='item.line_total_usd']").prop("disabled", true);

            $("[name='item.indent_time']").attr("placeholder", "Lead time");
            $("[name='item.warranty']").attr("placeholder", "Warranty");
            $("[name='item.remarks']").attr("placeholder", "Remarks");

            $("#btnSaveDetail").show();
            $("#ItemForm").find("input:text").val('');
            $("#ItemForm").find("input:hidden").val('');
            $("#ItemForm").find("textarea").val('');
            $("#ItemForm").find("select").val('').trigger("change");
            $("#ItemForm-error-box").hide();

            $(".item_closing").hide();
            
            populateCurrency();

            repopulateNumber();
        }

        $(document).on("click", ".btnEdit", function () {
            resetItemForm();
            var uid = $(this).closest("tr").prop("id");
                uid = uid.replace("item_", "");
            var idx = QuoItems.findIndex(x => x.uid == uid);
            var d = QuoItems[idx];
           EditItem(d);
        });

        $(document).on("click", ".btnView", function () {
            resetItemForm();
            var uid = $(this).closest("tr").prop("id");
                uid = uid.replace("item_", "");
            var idx = QuoItems.findIndex(x => x.uid == uid);
            var d = QuoItems[idx];

            EditItem(d);
            $("[name^='item.']").prop("disabled", true);
            $("[name^='item.']").attr("placeholder", "");
            $("#btnSaveDetail").hide();
            $(".item_closing").show();
        });

        function EditItem(d) {
            $("#itemform-error-box").hide();
            var info_qty = 0;
            if (source == "1") {
                $("#source_info").text("RFQ information");
            } else if (source == "2") {
                $("#source_info").text("PR information");
            }

            info_qty = d.source_quantity;
            $("[name='item.initial_quantity']").val(d.quotation_quantity);
            $("[name='item.initial_quantity_vs']").val(d.quantity);
            $("[name='item.initial_unit_price']").val(d.unit_price);
            $("[name='item.initial_discount_type']").val(d.discount_type);
            $("[name='item.initial_discount']").val(d.discount);
            $("[name='item.initial_additional_discount']").val(d.additional_discount);
            $("[name='item.initial_currency']").val(d.currency_id);
            $("[name='item.initial_exchange_rate']").val(d.exchange_rate);

            $("[name='item.uid']").val(d.uid);
            $("[name='item.source_quantity']").val(d.source_quantity);
            $("[name='item.rfq_quantity']").val(d.rfq_quantity);
            $("[name='item.vs_quantity']").val(d.vs_quantity);


            $("#pr_quantity").text(accounting.formatNumber(delCommas(info_qty), 2) + ' ' + d.uom);

            if (typeof d.pr_currency === "undefined" || d.pr_currency == null) {
                $("#pr_unit_price").text(accounting.formatNumber(delCommas(d.pr_unit_price), 2));
                $("#pr_estimated_cost").text(accounting.formatNumber((delCommas(d.pr_unit_price) * delCommas(info_qty)), 2));
            } else {
                $("#pr_unit_price").text(d.pr_currency + " " + accounting.formatNumber(delCommas(d.pr_unit_price), 2));
                $("#pr_estimated_cost").text(d.pr_currency + " " + accounting.formatNumber((delCommas(d.pr_unit_price) * delCommas(info_qty)), 2));
            }
           

            $("[name='item.pr_unit_price']").val(accounting.formatNumber(delCommas(d.pr_unit_price), 2));
       
            $(".pr_uom").text(d.uom);
            $("[name='item.quantity']").val(d.quantity);
            $("[name='item.quotation_quantity']").val(d.quotation_quantity);
            $("[name='item.unit_price']").val(d.unit_price);
            $("[name='item.total']").val((d.unit_price * d.quantity));

            if (d.discount_type == "") { d.discount_type = "$"; }
            $("[name='item.discount']").val(d.discount);
            $("[name='item.additional_discount']").val(d.additional_discount);
            $("[name='item.discount_type']").val(d.discount_type).trigger("change");
            $("[name='item.indent_time']").val(d.indent_time);
            $("[name='item.warranty']").val(d.warranty);
            $("[name='item.remarks']").val(d.remarks);
            document.getElementById("pr_item_description").innerHTML = d.item_description;
            $("[name='item.quotation_description']").val(d.quotation_description);
            $("[name='item.exchange_sign']").val(d.exchange_sign);
            $("[name='item.exchange_rate']").val(d.exchange_rate);
            $("[name='item.currency_id']").val(d.currency_id).trigger("change");

        

            if (d.status_id == 50 && $.trim(d.close_remarks)!="") {
                $("#closing_quantity").text(accounting.formatNumber(d.close_quantity, 2));
                $("#closing_remarks").text(d.close_remarks);
            }
            repopulateNumber();
            if (typeof d.currency_id === "undefined" || d.currency_id == null) {
                $(".currency").text("");
            } else {
                $(".currency").text(d.currency_id);
            }
           
            $("#ItemForm").modal("show");
            calculateItem();
          
        }

        function CalculateTotalPerItem() {

            var qty = delCommas($("[name='item.quotation_quantity']").val());
            var price = delCommas($("[name='item.unit_price']").val());
            var total = delCommas(accounting.formatNumber(qty * price, 2));

            var qty_for_use = delCommas($("[name='item.quantity']").val());

            var discountType = $("[name='item.discount_type']").val();
            var discount = 0;
            var discountAmount = 0;
            if (discountType == "$") {
                discount = delCommas($("[name='item.discount']").val());
                discountAmount = discount;
            } else if (discountType == "%") {
                discount = delCommas($("[name='item.discount']").val());
                discountAmount = delCommas(accounting.formatNumber(discount / 100 * total, 2));
            }
            
            $("[name='item.total']").val(total);

            var uid = $("[name='item.uid']").val();

            var idx = QuoItems.findIndex(x => x.uid == uid);
            var arr = QuoItems[idx];
            if (typeof arr !== "undefined") {
                var sign = $("[name='item.exchange_sign']").val();
                var rate = delCommas($("[name='item.exchange_rate']").val());

                arr.quantity = qty_for_use;

                arr.quotation_quantity = qty;
                arr.unit_price = price;
                arr.discount_type = discountType;
                arr.discount = discount;
                arr.discount_amount = discountAmount;
                proRateDiscount();
                $("[name='item.discount_amount']").val(discountAmount);
                $("[name='item.additional_discount']").val(arr.additional_discount);
                arr.line_total = total - discountAmount - arr.additional_discount;
                if (sign === "/") {
                    arr.line_total_usd = delCommas(accounting.formatNumber(arr.line_total / rate, 2));
                } else {
                    arr.line_total_usd = delCommas(accounting.formatNumber(arr.line_total * rate, 2));
                }

                $("[name='item.line_total']").val(arr.line_total);
                $("[name='item.line_total_usd']").val(arr.line_total_usd);

                var total = "";
                if (typeof arr.currency_id === "undefined" || arr.currency_id == null) {
                    total = accounting.formatNumber(arr.line_total, 2);
                } else {
                    total = arr.currency_id + " " + accounting.formatNumber(arr.line_total, 2);
                }

                repopulateNumber();
           
               
            }
        }

        $(document).on("click", "#btnCloseItemForm, #iconCloseItemForm", function () {
            closeFormItem();
        });

        function closeFormItem() { 
            $("[name='item.quotation_quantity']").val(delCommas($("[name='item.initial_quantity']").val()));
            $("[name='item.quantity']").val(delCommas($("[name='item.initial_quantity_vs']").val()));
            $("[name='item.unit_price']").val(delCommas($("[name='item.initial_unit_price']").val()));
            $("[name='item.discount']").val(delCommas($("[name='item.initial_discount']").val()));
            $("[name='item.discount_type']").val($("[name='item.initial_discount_type']").val()).trigger("change");
            $("[name='item.additional_discount']").val(delCommas($("[name='item.initial_additional_discount']").val()));
            $("[name='item.currency_id']").val($("[name='item.initial_currency']").val()).trigger("change");

            if ($("[name='quo.discount']").attr('data-value') > 0) {
                $("[name='quo.discount']").val($("[name='quo.discount']").attr('data-value')).trigger("change");
            }
      
            $("#ItemForm").modal("hide");
        }

        $(document).on("click", "#btnSaveDetail", function () {
            validateItem();
            populateDiscCurrency();
        });

        function validateItem() {
            var errorMsg = "";
            var confirmMsg = "";
            var max_qty = 0;
            var vs_quantity = delCommas($("[name='item.vs_quantity']").val());;
            max_qty = delCommas($("[name='item.source_quantity']").val());

            if (delCommas($("[name='item.quotation_quantity']").val()) < 0) {
                errorMsg += "<br/> - Quantity is required.";
            }
            if (delCommas($("[name='item.quotation_quantity']").val()) > max_qty) {
                errorMsg += "<br/> - Quantity is exceed. The maximum quantity you can set is " + accounting.formatNumber(max_qty, 2);
            }
            if (delCommas($("[name='item.quantity']").val()) < 0) {
                errorMsg += "<br/> - Quantity to be used in quotation analysis is required.";
            }
            if (delCommas($("[name='item.quantity']").val()) > delCommas($("[name='item.quotation_quantity']").val())
                || delCommas($("[name='item.quantity']").val()) > max_qty) {
                var max_qty_for_use = 0;
                if (delCommas($("[name='item.quantity']").val()) > max_qty) {
                    max_qty_for_use = max_qty;
                } else {
                    max_qty_for_use = $("[name='item.quotation_quantity']").val() == "";
                }
                errorMsg += "<br/> - Quantity to be used in quotation analysis is exceed. The maximum quantity you can set is " + accounting.formatNumber(max_qty_for_use, 2);
            }
            if ($("[name='item.id']").val()!="" && delCommas($("[name='item.quotation_quantity']").val()) < vs_quantity && delCommas($("[name='item.quotation_quantity']").val()) > 0) {
                errorMsg += "<br/> - Quantity item is already used in quotation analysis. The minimum quantity you can set is " + accounting.formatNumber(vs_quantity, 2);
            }
            if (delCommas($("[name='item.quotation_quantity']").val()) > 0 && delCommas($("[name='item.unit_price']").val()) == 0) {
                errorMsg += "<br/> - Unit price is required.";
            }
            if (delCommas($("[name='item.discount']").val()) > 100 && $("[name='item.discount_type']").val() == "%") {
                errorMsg += "<br/> - Maximum discount is 100%.";
            }
            if (delCommas($("[name='item.quotation_quantity']").val()) == 0 && $.trim($("[name='item.remarks']").val())=="") {
                errorMsg += "<br/> - Remarks is required if you set quotation quantity to zero.";
            }
            if ($("[name='item.quotation_description']").val() == "") {
                errorMsg += "<br/> - Quotation description to be used in quotation analysis is required.";
            }


            /* for confirmation */
            if (delCommas($("[name='item.quotation_quantity']").val()) < max_qty) {
                confirmMsg += "Quotation quantity is less than " + (source == 1 ? "RFQ" : "PR") + " quantity.\n";
            }
            if (delCommas($("[name='item.unit_price']").val()) > delCommas($("[name='item.pr_unit_price']").val())) {
                confirmMsg += "Quotation unit price is greater than PR unit price.\n";
            }


            if (errorMsg !== "") {
                errorMsg = "Please correct the following error(s):" + errorMsg;

                $("#itemform-error-message").html("<b>" + errorMsg + "<b>");
                $("#itemform-error-box").show();
                $('.modal-body').animate({ scrollTop: 0 }, 500);
            }
            else {
                if (confirmMsg != "") {
                    confirmMsg += "Do you want to proceed?";

                    if (!confirm(confirmMsg)) {
                        return;
                    }
                }

                var uid = $("[name='item.uid']").val();
                uid = uid.replace("item_", "");
                var idx = QuoItems.findIndex(x => x.uid == uid);
                var d = QuoItems[idx];

                d.indent_time = $("[name='item.indent_time']").val();
                d.warranty = $("[name='item.warranty']").val();
                d.remarks = $("[name='item.remarks']").val();

                //add quotation description
                d.quotation_description = $("[name='item.quotation_description']").val();
                $("#quotation_description_" + d.uid).text(d.quotation_description);
                $("#quo_description_" + d.uid).val(d.quotation_description);

                d.currency_id = $('select[name="item.currency_id"]').find(":selected").val()
                $("#quo_currency_" + d.uid).val(d.currency_id);
                d.exchange_rate = $("[name='item.exchange_rate']").val()
                $("[name='item.currency_id']").attr("data-value", d.currency_id);
  
                CalculateTotalPerItem();

                $("#ItemForm").modal("hide");
            }
        }
        /* end of Item form */

        /* pr item form */
        $(document).on("click", "#btnRefreshItem", function () {
            loadSearchItem();
        });

        $('#SearchItemForm').on('shown.bs.modal', function () {
            $("#btnRefreshItem").trigger("click");
        });

        function loadSearchItem(pr_detail_id) {
            if (typeof pr_detail_id === "undefined") {
                pr_detail_id = 0;
            }
            $("#SearchResults").html("processing..");
            
            $.ajax({
                url: "<%=Page.ResolveUrl("~/Service.aspx/GetRFQItems")%>",
                data: "{'subcategories':'', 'cifor_office_id':'" + userOffice + "', 'pr_detail_id':''}",
                dataType: 'json',
                type: 'post',
                contentType: "application/json; charset=utf-8",
                success: function (response) {
                    var html = "";
                    var totalRecords = 0;

                    listSearch = JSON.parse(response.d);
                    t_cat = listSearch.Table;
                    t_item = listSearch.Table1;
                    
                    $.each(usedPRItems, function (i, detail_id) {
                        var idx = t_item.findIndex(x => x.pr_detail_id == detail_id);
                        if (idx != -1) {
                            t_item.splice(idx, 1);
                        }
                    });

                    $.each(t_cat, function (i, cat) {
                        var item = $.grep(t_item, function (n, i) {
                            if (cat.category_id != null)
                                cat.category_id = "all";
                                return n["category"] = cat.category_id;
                        });

                        totalRecords += item.length;
                        if (item.length > 0) {
                            //html += '<div class="control-group">' +
                            //    '<div class="row-fluid">' +
                            //    '<div class="span12">' +
                            //    '<table class="table table-bordered" style="border: 1px solid #ddd">' +
                            //    '<thead><tr>' +
                            //    '<th style="width:20%" class="green">Product group</th>' +
                            //    '<th style="width:80%">' + cat.category_name +'</th>' +
                            //    '</tr></thead>' +
                            //    '</table>' +
                            //    '</div>' +
                            //    '</div>';

                            //html += '<div class="row-fluid">' +
                            //    '<table id="item_' + cat.category_id + '" class="table table-bordered table-striped" style="border: 1px solid #ddd">' +
                            //    '<thead><tr>' +
                            //    '<th style="width:3%"><input type="checkbox" id="checkItemAll_' + cat.category_id + '" /></th>' +
                            //    '<th style="width:10%">PR code</th>' +
                            //    '<th style="width:10%">Purchase office</th>' +
                            //    '<th style="width:15%">Requester</th>' +
                            //    '<th style="width:10%">Required date</th>' +
                            //    '<th style="width:12%">Product code</th>' +
                            //    '<th style="width:35%">Description</th>' +
                            //    '<th style="width:15%">Quantity</th>' +
                            //    '</tr></thead>' +
                            //    '</table>' +
                            //    '</div>';

                            //html += '</div>';
                        }
                    });

                    if (totalRecords > 0) {
                        html += '<div class="row-fluid">' +
                            '<table id="item_' + "all" + '" class="table table-bordered table-striped" style="border: 1px solid #ddd">' +
                            '<thead><tr>' +
                            '<th style="width:3%"><input type="checkbox" id="checkItemAll_' + "all" + '" /></th>' +
                            '<th style="width:10%">PR code</th>' +
                            '<th style="width:10%">Purchase office</th>' +
                            '<th style="width:15%">Requester</th>' +
                            '<th style="width:10%">Required date</th>' +
                            '<th style="width:12%">Product code</th>' +
                            '<th style="width:35%">Description</th>' +
                            '<th style="width:15%">Quantity</th>' +
                            '</tr></thead>' +
                            '</table>' +
                            '</div>';

                        html += '</div>';
                    }

                    var vendor = $("[name='quo.vendor_name']").val();
                    if (totalRecords == 0 || vendor == "") {
                        html = "No data available.";
                    }
                    $("#SearchResults").html(html);

                    $("table[id^='item_'").each(function () {
                        var sid = $(this).attr("id").replace("item_", "");
                        var item = $.grep(t_item, function (n, i) {
                            return n["category"] == sid;
                        });
                        GenerateItemTable($(this), item);            
                    });

                    $("[id^='checkItemAll_']").bind("click", function () {
                        var sid = $(this).attr("id").replace("checkItemAll_", "");
                        $(".item_check_" + sid).prop("checked", $(this).is(":checked"));
                    });

                    $("[id^='checkVendorAll_']").bind("click", function () {
                        var sid = $(this).attr("id").replace("checkVendorAll_", "");
                        $(".vendor_check_" + sid).prop("checked", $(this).is(":checked"));
                    });

                    $("input[type='checkbox'].item").bind("click", function () {
                        var iclass = $(this).prop("class");
                        iclass = iclass.replace(" item", "").replace("item_check_","");
                        if (!$(this).prop("checked")) {
                            $("#checkItemAll_" + iclass).prop("checked", false);
                        }
                    });

                    if (pr_detail_id != "" && pr_detail_id != "0") {
                        var selectedItems = [];
                        selectedItems.push(pr_detail_id);
                        selectItemFromPR(selectedItems);
                    }
                }
            });
        }

        function GenerateItemTable(obj, data) {
            $(obj).DataTable({
                "bFilter": false, "bDestroy": true, "bRetrieve": true, "paging": false, "bSort": false,"bLengthChange" : false, "bInfo":false, 
                "aaData": data,
                "aoColumns": [
                    {
                        "mDataProp": "desc"
                        , "mRender": function (d, type, row) {
                            return '<input type="checkbox" class="item_check_all item" data-subcategory="all" value="' + row.pr_detail_id + '"/>';
                           // return '<input type="checkbox" class="item_check_' + row.subcategory + ' item" data-subcategory="' + row.subcategory + '" value="' + row.pr_detail_id + '"/>';
                        }
                    },
                    {
                        "mDataProp": "pr_no"
                        , "mRender": function (d, type, row) {
                            return '<a href="<%=Page.ResolveUrl("~/purchaserequisition/detail.aspx?id=' +  row.pr_id  + '")%>" target="_blank">' + row.pr_no + '</a>';
                        }
                    },
                    {
                        "mDataProp": "cifor_office"
                        , "className": "cifor_office_name"
                        
                    },
                    { "mDataProp": "requester" },
                    { "mDataProp": "required_date" },
                    { "mDataProp": "item_code" },
                    {
                        "mDataProp": "description"
                        , "mRender": function (d, type, row) {
                            return row.item_description;
                        }
                    },
                    {
                        "mDataProp": "request_quantity"
                        , "className": "textRight"
                        , "mRender": function (d, type, row) {
                            return accounting.formatNumber(delCommas(row.request_quantity), 2) + " " + row.uom;
                        }
                    }
                ]
            });
        }

        $(document).on("click", "#btnSelectItem", function () {
            let office_name = "";
            let errorMsg = "";
            let selectedItemsTemp = [];
            let errorMsgTemp = "<br> - You cannot combine products from different Purchase office.";
            let cifor_office_name = "";

            $(".item:checkbox:checked").each(function () {
                cifor_office_name = $(this).closest("tr").find(".cifor_office_name").text();
                $.each(QuoItems, function (i, d) {
                    if (errorMsg == "") {
                        if (d.cifor_office != cifor_office_name) {
                            errorMsg += errorMsgTemp;
                        }
                    }
                });

                if (office_name == "") {
                    office_name = cifor_office_name;
                } else {
                    if (office_name != cifor_office_name) {
                        if (errorMsg == "") {
                            errorMsg += errorMsgTemp;
                        }      
                    }                    
                }

                /*$(this).closest("tr").find(".cifor_office_name").text();*/
                selectedItemsTemp.push($(this).val());
                /*selectedItems.push($(this).val());*/
            });

            if (errorMsg !== "") {
                errorMsg = "Please correct the following error(s):" + errorMsg;
                $("#searchitemform-error-message").html("<b>" + errorMsg + "<b>");
                $("#searchitemform-error-box").show();
                $('.modal-body').animate({ scrollTop: 0 }, 500);
            } else {
                selectedItems = selectedItemsTemp;
                $("#searchitemform-error-message").html("");
                $("#searchitemform-error-box").hide();
                selectItemFromPR(selectedItems);
            }            
        });

        $(document).on("click", "#btnCloseProduct", function () {
            $("#searchitemform-error-message").html("");
            $("#searchitemform-error-box").hide();
        });

        function selectItemFromPR(selectedItems) {
            $(selectedItems).each(function (a, b) {
                var pr_detail_id = b;
                var item = $.grep(t_item, function (n, i) {
                    return n["pr_detail_id"] == pr_detail_id;
                });
                if (item.length > 0) {
                 
                    var d = item[0];
                    cifor_office = d.cifor_office_id;
                    var qd = new Object();
                        qd.id = "";
                        qd.uid = guid();
                        qd.item_id = d.item_id;
                        qd.item_code = d.item_code;
                        qd.brand_name = d.brand_name;
                        qd.description = d.description;
                        qd.item_description = d.item_description;
                        qd.uom_id = d.uom_id;
                        qd.uom = d.uom;
                        qd.quantity = d.request_quantity;
                        qd.quotation_quantity = d.request_quantity;
                        qd.unit_price = d.pr_unit_price;
                        qd.source_quantity = d.request_quantity;
                        qd.pr_quantity = d.request_quantity;
                        qd.rfq_quantity = 0;
                        qd.vs_quantity = d.vs_qty;
                        qd.pr_currency = d.pr_currency;
                        qd.pr_unit_price = d.pr_unit_price;
                        qd.pr_estimated_cost = d.pr_estimated_cost;
                        qd.rfq_detail_id = 0;
                        qd.rfq_id = 0;
                        qd.pr_detail_id = d.pr_detail_id;
                        qd.pr_id = d.pr_id;
                        qd.pr_no = d.pr_no;
                        qd.status_id = 25;
                        qd.discount_type = "$";
                        qd.discount = 0;
                        qd.discount_amount = 0;
                        qd.additional_discount = 0;
                        qd.indent_time = "";
                        qd.warranty = "";
                        qd.remarks = "";
                        qd.subcategory = d.subcategory;
                        qd.quotation_description = d.quotation_description;
                        qd.currency_id = d.currency_id;
                        qd.exchange_sign = d.exchange_sign;
                        qd.exchange_rate = d.exchange_rate;
                        qd.cifor_office = d.cifor_office;

                    QuoItems.push(qd);
                }
            });
            populateUsedItems();

            $("#tblItems tbody").html("");

            $.each(QuoItems, function (i, d) {
                addItems(d);
            });

            proRateDiscount();
            
            $("#SearchItemForm").modal("hide");
            PopulateItemCategories();

            normalizeMultilines();
        }

        function populateUsedItems() {
            usedPRItems = null;
            usedPRItems = [];

            $.each(QuoItems, function (i, d) {
                usedPRItems.push(d.pr_detail_id);
            });

            usedPRItems = unique(usedPRItems);
        }
        /* end of pr item form */

        $(document).on("click", "#btnAddAttachment", function () {
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

        $(document).on("change", "input[name='filename']", function () {
            $(this).closest("tr").find("input[name$='attachment.uploaded']").val("0");
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

        $(document).on("change", "input[name='cancellation_file']", function (e) {
            $("input[name$='cancellation.uploaded']").val("0");
        });

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

            if (mname === "item") {
                var item_uid = $(this).closest("tr").prop("id");
                item_uid = item_uid.replace("item_", "");
                var idx = QuoItems.findIndex(x => x.uid == item_uid);
                if (idx != -1) {
                    QuoItems.splice(idx, 1);
                }

                populateUsedItems();
            }

            $(this).closest("tr").remove();
            proRateDiscount();
            PopulateItemCategories();
        });

        $(document).on("click", "#btnCancel", function () {
            $("#CancelForm").modal("show");
        });

        var uploadValidationResult = {};
        $(document).on("click", "#btnSave,#btnSubmit,#btnSaveCancellation", function () {
            var thisHandler = $(this);
            $("[name=cancellation_file],[name=filename]").uploadValidation(function (result) {
			    uploadValidationResult = result;
			    onBtnClickSave.call(thisHandler);
		    });
	    });

        var onBtnClickSave = function () {
            btnAction = $(this).data("action").toLowerCase();
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
                
                errorMsg += uploadValidationResult.not_found_message||'';
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

            SubmitValidation();
        };

        function SubmitValidation() {
            var errorMsg = "";
            errorMsg += uploadValidationResult.not_found_message||'';
            var data = new Object();
            data.id = $("[name='quo.id']").val();
            data.q_no = $("#q_no").val();
            data.cifor_office_id = cifor_office;
            data.vendor = $("[name='quo.vendor']").val();
            data.vendor_name = $("[name='quo.vendor_name']").val();
            data.vendor_code = $("[name='quo.vendor_code']").val();
            data.vendor_document_no = $("[name='quo.vendor_document_no']").val();
            data.vendor_address_id = $("select[name = 'quo.supplier_address']").attr("selected", "selected").val(); 
            data.receive_date = $("[name='quo.receive_date']").val();
            data.document_date = $("[name='quo.document_date']").val();
            data.due_date = $("[name='quo.due_date']").val();
            data.payment_terms = $("select[name = 'quo.payment_terms']").attr("selected", "selected").val();
            data.other_payment_terms = $("[name='quo.other_payment_terms']").val();
            data.is_other_payment_terms = $("[name='quo.is_other_payment_terms']").prop("checked") == true ? 1 : 0;
            data.remarks = $("[name='quo.remarks']").val();
            data.currency_id = $("[name='quo.currency_id']").val();
            data.exchange_sign = $("[name='quo.exchange_sign']").val();
            data.exchange_rate = delCommas($("[name='quo.exchange_rate']").val());
            data.discount_type = $("[name='quo.discount_type']").val();
            data.discount = delCommas($("[name='quo.discount']").val());
            data.discount_currency = $("select[name = 'quo.discount_currency']").attr("selected", "selected").val();
            data.total_discount = delCommas($("#discountTotal").text());
            data.quotation_amount = delCommas($("#GrandTotal").text());
            data.quotation_amount_usd = delCommas($("#GrandTotalUSD").text());
            data.rfq_id = $("[name='quo.rfq_id']").val();
            data.rfq_no = $("[name='quo.rfq_no']").val();
            data.temporary_id = $("[name='docidtemp']").val();
            data.source = $('input[name="quo.source"]:checked').val();
            if (data.rfq_id == 0) {
                data.reff_rfq_no = $("[name='quo.reff_rfq_no']").val();
            } else {
                data.reff_rfq_no = "";
            }
            data.copy_from_id = $("[name='quo.copy_from_id']").val();
            data.status_id = $("#status").val();

            convertDiscountToUsd()
            data.details = QuoItems;

            data.sundry = [];
            var sundry_detail = $.grep(dataSundry, function (n, k) {
                return n["sundry_supplier_id"] == data.vendor;
            });
            if (sundry_detail.length > 0) {
                data.sundry.push(sundry_detail[0]);
            }


            data.attachments = [];
            $("#tblAttachment tbody tr").each(function () {
                var _att = new Object();
                _att["id"] = $(this).find("input[name='attachment.id']").val();
                _att["filename"] = $(this).find("input[name='attachment.filename']").val();
                _att["file_description"] = $(this).find("input[name='attachment.file_description']").val();
                data.attachments.push(_att);

                if ($(this).find("input[name='attachment.uploaded']").val() == "0") {
                    $(this).css({ 'background-color': 'rgb(245, 183, 177)' });
                    if (!errorMsg) {
                        errorMsg += "<br/> - There are files that have not been uploaded, please upload first.";//    errorMsg += "Please correct the following error(s): <br/> - There are files that have not been uploaded, please upload first.";
                    } 
                }
            });


            if (btnAction == "submitted" || btnAction == "updated") {
                if (data.rfq_id != "0" && btnAction == "submitted") {
                    $.ajax({
                        url: "<%=Page.ResolveUrl("Input.aspx/isRFQValid")%>",
                        data: JSON.stringify({ rfq_id: data.rfq_id }),
                        dataType: 'json',
                        type: 'post',
                        contentType: "application/json; charset=utf-8",
                        success: function (response) {
                            var output = JSON.parse(response.d);
                            if (output.result != "success") {
                                alert(output.message);
                            } else {
                                if (output.valid == "0") {
                                    errorMsg += "<br/> - RFQ is cancelled. You cannot proceed this Quotation.";
                                }
                                errorMsg += GeneralValidation();
                                errorMsg += supplierAddressValidation();
                                //if ($("select[name = 'quo.payment_terms']").attr("selected", "selected").val().toLowerCase() == "oth" && $("[name='quo.other_payment_terms']").val() == "") {
                                //    errorMsg += "<br/> - Other payment terms is required.";
                                //}


                                errorMsg += FileValidation();
                                SubmitProcess(errorMsg, data, deletedId, workflow);
                            }
                        }
                    });
                } else {

                    errorMsg += GeneralValidation();
                    errorMsg += supplierAddressValidation();
                    if ($("select[name = 'quo.payment_terms']").attr("selected", "selected").val().toLowerCase() == "oth" && $("[name='quo.other_payment_terms']").val() == "") {
                        //errorMsg += "<br/> - Other payment terms is required.";
                    }

                    errorMsg += FileValidation();

              
                    SubmitProcess(errorMsg, data, deletedId, workflow);
                }
            } else {
                errorMsg += FileValidation();
                SubmitProcess(errorMsg, data, deletedId, workflow);
            }

        }

        function SubmitProcess(errorMsg, data, deletedId, workflow) {
            if (errorMsg !== "") {
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
            $.ajax({
                url: "<%=Page.ResolveUrl("Input.aspx/Save")%>",
                data: JSON.stringify(_data),
                dataType: 'json',
                type: 'post',
                contentType: "application/json; charset=utf-8",
                success: function (response) {
                    var output = JSON.parse(response.d);
                    if (output.result !== "success") {
                        alert(output.message);
                    } else {
                        if (output.id !== "") {
                            $("#q_no").val(output.q_no);
                            $("[name='quo.id']").val(output.id)
                            $("input[name='doc_id']").val(output.id);
                            $("input[name='action']").val("fileupload");
                            //UploadFile();

                            UploadFileAPI("submit");
                        }
                    }
                }
            });
        }

        $(document).on("click", "#btnClose", function () {
            location.href = "List.aspx";
        });

        function PopulateItemCategories() {
            item_categories = [];
            $(QuoItems).each(function (i, d) {
                item_categories.push(d.subcategory);
            });

            item_categories = unique(item_categories);
        }
    </script>

    <%-- add script new quotation --%>
    <script>
        $(document).ready(function () {
            var itmCurr = $("select[name='item.currency_id']");
            generateCombo(itmCurr, listCurrency, "CURRENCY_CODE", "CURRENCY_CODE", true);
            $(itmCurr).val(_currency);
            Select2Obj(itmCurr, "Currency");

            $(itmCurr).on('select2:select', function (e) {
                changeExchangeRateItem($(this).val());
                populateCurrency();
            });
            lookUpSupplierAddress();
            lookUpDiscCurrency();
            lookUpPaymentTerm();
            $("[name='quo.discount']").val(<%=Q.discount%>);
            calculatetotalDiscount();
            loadCurrentAddressSundry();
        });

        // function
        function changeExchangeRateItem(curr) {
            var arr = $.grep(listCurrency, function (n, i) {
                return n["CURRENCY_CODE"] === curr;
            });

            var _sign = "/";
            var _rate = 0;
            if (arr.length > 0) {
                if (arr[0].OPERATOR === "/") {
                    _sign = "&divide;";
                } else {
                    _sign = "x";
                }
                _rate = accounting.formatNumber(arr[0].RATE, 8);
            }

            $("#exchange_sign").html(_sign);
            $("[name='item.exchange_sign']").val(arr[0].OPERATOR);
            $("[name='item.exchange_rate']").val(_rate);
            calculateItem();
        }

        function calculateItem() {
            var sign = $("[name='item.exchange_sign']").val();
            var rate = delCommas($("[name='item.exchange_rate']").val());
            var _uid = $("[name='item.uid']").val();
            var currency_id = $('select[name="item.currency_id"]').find(":selected").val()

            var grandTotal = 0;
            var grandTotalUSD = 0;
            var grandTotalBeforDisc = 0;
            var grandTotalUSDBeforDisc = 0;


            var total = "";
            var total_original = ""
            var idx = QuoItems.findIndex(x => x.uid == _uid);
            var d = QuoItems[idx];
            d.line_total_original = delCommas(d.quotation_quantity) * delCommas(d.unit_price);
            d.line_total = delCommas(d.quotation_quantity) * delCommas(d.unit_price);

            /* discount */
            if (d.discount_type == "%") {
                d.discount_amount = delCommas(accounting.formatNumber(d.discount / 100 * d.line_total, 2));
            } else if (d.discount_type == "$") {
                d.discount_amount = d.discount;
            }
            d.line_total = delCommas(accounting.formatNumber(d.line_total - d.discount_amount, 2));

            grandTotalBeforDisc += d.line_total;
            grandTotalUSDBeforDisc += d.line_total_usd;

            /* pro rated discount */
            d.line_total = delCommas(accounting.formatNumber(d.line_total - d.additional_discount, 2));

            if (sign === "/") {
                d.line_total_usd = delCommas(accounting.formatNumber(d.line_total / rate, 2));
                d.line_total_usd_original = delCommas(accounting.formatNumber(d.line_total_original / rate, 2));
            } else {
                d.line_total_usd = delCommas(accounting.formatNumber(d.line_total * rate, 2));
                d.line_total_usd_original = delCommas(accounting.formatNumber(d.line_total_original * rate, 2));
            }
            grandTotal += d.line_total;
            grandTotalUSD += d.line_total_usd;
            if (typeof currency_id === "undefined" || currency_id == null) {
                total = accounting.formatNumber(d.line_total, 2)
                total_original = accounting.formatNumber(d.line_total_original, 2)
            } else {
                total = currency_id + " " + accounting.formatNumber(d.line_total, 2)
                total_original = currency_id + " " + accounting.formatNumber(d.line_total_original, 2)
            }
           
            $("#total_" + _uid).text(total_original);
            $("#totalUSD_" + _uid).text(accounting.formatNumber(d.line_total_usd_original, 2));
            $("[name='item.line_total_usd']").val(accounting.formatNumber(d.line_total_usd, 2));

            $("#GrandTotalBeforeDesc").val(accounting.formatNumber(grandTotalBeforDisc, 2));
            $("#GrandTotalBeforeDesc").val(accounting.formatNumber(grandTotalUSDBeforDisc, 2));
            $("#GrandTotal").text(accounting.formatNumber(grandTotal, 2))
            $("#GrandTotalUSD").text(accounting.formatNumber(grandTotalUSD, 2))
        }

        function lookUpDiscCurrency() {
            var curr = $("select[name = 'quo.discount_currency'] option:selected").val();
            $("select[name='quo.discount_currency'] option").remove();
            var cboDiscCurrency = $("select[name='quo.discount_currency']");
            generateCombo(cboDiscCurrency, listDiscCurrency, "id", "id", true);
            if (typeof curr === "undefined") {
                curr = "USD";
                $(cboDiscCurrency).val(curr);
              
            } else {
                $(cboDiscCurrency).val(curr);
            }
            Select2Obj(cboDiscCurrency, "Type");
        }

       function lookUpPaymentTerm() {
 
            var cbo = $("select[name='quo.payment_terms']");
            generateCombo(cbo, listPaymentTerm, "Id", "Name", true);
            Select2Obj(cbo, "Payment terms");
            $(cbo).val(payment_term).change();

           if (payment_term.toLowerCase() == "oth") {
               $("[name='quo.other_payment_terms']").val(other_payment_term)
           }
        }

        function lookUpSupplierAddress() {
            var data = listSupplierAddress;
            if (supplierId != "") {
                data = $.grep(listSupplierAddress, function (n, i) {
                    return n["id"] == supplierId;
                });

                if (data[0].IsSundry == "1") {
                    resetSupplierAddress();
                    hideSelectSupplierAddress()
                    loadBtnEditSundry();
                    loadCurrentAddressSundry();
                    $("#sundry_address").attr("data-validation", "required");
                    $("#SupplierAction").attr("data-id", supplierId);
                } else {
                    showSelectSupplierAddress();
                    $("#sundry_address").removeAttr("data-validation", "");
                    $("#SundryAddress").empty();
                    loadSupplierAddressRequired()
                  
                }
            }

            var cbo = $("select[name='quo.supplier_address']").empty();
            generateCombo(cbo, data, "vendor_address_id", "address", false);

            Select2Obj(cbo, "Supplier address");
            setSupplier();
        }

        function setSupplier() {
            supplierAddressId = $("[name='quo.supplier_address']").find(":selected").val();
            var data = $.grep(listSupplierAddress, function (n, i) {
                return n["id"] == supplierId;
            });
            
            if (data.length > 0) {
                for (let i = 0; i < data.length; i++) {
                    if (data[i].vendor_address_id == supplierAddressId) {
                        
                        $("#SupplierContactPerson").text(data[i].contact_person);
                        $("#SupplierEmail").text(data[i].email);
                        $("select[name='quo.supplier_address']").val(supplierAddressId).trigger("change");

                    }
                }
            } 
        }

        function resetSupplierAddress() {
            $("#SupplierContactPerson").text("");
            $("#SupplierEmail").text("");
            $("select[name='quo.supplier_address']").empty();

        }


        $('[name="quo.vendor"]').on('change', function () {

            resetSupplierAddress();
            supplierId = $(this).find(":selected").val();
            showSelectSupplierAddress();
            lookUpSupplierAddress();
            setPaymentTerms();
            setSupplier();
        });

        $("[name='quo.supplier_address']").on('change', function () {
            var supplierAddressId = $(this).find(":selected").val();
            var data = $.grep(listSupplierAddress, function (n, i) {
                return n["vendor_address_id"] == supplierAddressId;
            });

            if (data.length > 0) {
                if (data[0].vendor_address_id == supplierAddressId) {
                        $("#SupplierContactPerson").text(data[0].contact_person);
                        $("#SupplierEmail").text(data[0].email);

                        $("#supplier_contact_person").val(data[0].contact_person)
                        $("#supplier_email").val(data[0].email);

                        if (data[0].address != '') {
                            $("#supplier_address").val(data[0].vendor_address_id)
                        }
                       
                    }
            }
        });

        $("[name='quo.payment_terms']").on('change', function () {
            //if ($(this).val().toLowerCase() == "oth") {
            //    $("#div_other_payment").css("display", "block");
            //} else {
            //    $("#div_other_payment").css("display", "none");
            //}
        });

        function calculateDiscount() {
            var discCurr = $("select[name='quo.discount_currency']").val();
            var disc = delCommas($("[name='quo.discount']").val());
            var idx = listCurrency.findIndex(x => x.CURRENCY_CODE == discCurr);
            var d = listCurrency[idx];
            var discountUSD = 0;
                if (d.OPERATOR === "/") {
                    discountUSD = delCommas(accounting.formatNumber(disc / d.RATE, 2));
                } else {
                    discountUSD = delCommas(accounting.formatNumber(disc * d.RATE, 2));
            }
                $("#discountUSD").text(accounting.formatNumber(discountUSD, 2));           
        }
        

        $(document).on("change", "[name='item.exchange_rate']", function () {
            var uid = $("[name='item.uid']").val();
            uid = uid.replace("item_", "");
            var idx = QuoItems.findIndex(x => x.uid == uid);
            var d = QuoItems[idx];

            d.indent_time = $("[name='item.indent_time']").val();
            d.warranty = $("[name='item.warranty']").val();
            d.remarks = $("[name='item.remarks']").val();

            //add quotation description
            d.quotation_description = $("[name='item.quotation_description']").val();
            $("#quotation_description_" + d.uid).text(d.quotation_description);
            $("#quo_description_" + d.uid).val(d.quotation_description);

            d.currency_id = $('select[name="item.currency_id"]').find(":selected").val()
            $("#quo_currency_" + d.uid).val(d.currency_id);
            d.exchange_rate = $("[name='item.exchange_rate']").val();

            $("[name='quo.discount']").attr("data-value", delCommas($("[name='quo.discount']").val()))
            $("[name='quo.discount']").val('0').trigger("change");
            $("[name='item.discount']").val('0').trigger("change");

            calculateItem();
            CalculateTotalPerItem();

        });


        $(document).on("change", "[name='item.currency_id']", function () {
            let value = $(this).val();
            if (value.length > 0) {
                var uid = $("[name='item.uid']").val();
                uid = uid.replace("item_", "");
                var idx = QuoItems.findIndex(x => x.uid == uid);
                var d = QuoItems[idx];

                d.indent_time = $("[name='item.indent_time']").val();
                d.warranty = $("[name='item.warranty']").val();
                d.remarks = $("[name='item.remarks']").val();

                //add quotation description
                d.quotation_description = $("[name='item.quotation_description']").val();
                $("#quotation_description_" + d.uid).text(d.quotation_description);
                $("#quo_description_" + d.uid).val(d.quotation_description);

                d.currency_id = $('select[name="item.currency_id"]').find(":selected").val();
                $("#quo_currency_" + d.uid).val(d.currency_id);
                changeExchangeRateItem(d.currency_id); 
                d.exchange_rate = $("[name='item.exchange_rate']").val();
                d.exchange_sign = $("[name='item.exchange_sign']").val();

                if ($("[name='item.initial_exchange_rate']").val() != d.exchange_rate) {
                    $("[name='item.exchange_rate']").val($("[name='item.initial_exchange_rate']").val());
                    d.exchange_rate = $("[name='item.exchange_rate']").val();
                }

                if (value != $("[name='item.initial_currency']").val()) {
                    $("[name='quo.discount']").attr("data-value", delCommas($("[name='quo.discount']").val()))
                    $("[name='quo.discount']").val('0').trigger("change");
                    $("[name='item.discount']").val('0').trigger("change");
                }

                calculateItem();
                CalculateTotalPerItem();
            }
        });

        
        $(document).on("change", "select[name='quo.discount_currency']", function () {
            var curr = $(this).attr("selected", "selected").val();

            $("#txt_TypeAmt").text(curr);
            var discType = $("[name='quo.discount_type']").val();
            if (discType == "$") {
                calculateDiscount();
            } 

            proRateDiscount();
         
        });

        $(document).on("change", "[name='quo.is_other_payment_terms']", function () {
            var isChecked = false;
            isChecked = $(this).prop("checked");

            checkOtherPayment(isChecked);
        });

        function checkOtherPayment(isChecked) {
            if (isChecked) {
                $("#div_is_other_payment").addClass("last");
                $("#div_is_other_payment").addClass("required");
                $("[name='quo.other_payment_terms']").data("validation", "required");
                $("#div_other_payment").show();

                /*$("#div_delivery_address").removeClass("last");*/
                $("#div_payment_terms").removeClass("required");
                $("[name='quo.payment_terms']").data("validation", "");

                $("select[name='quo.payment_terms']").append('<option value="OTH" selected>Other</option>');
            } else {
                $("#div_is_other_payment").removeClass("last");
                $("#div_is_other_payment").removeClass("required");
                $("[name='quo.other_payment_terms']").data("validation", "");
                $("#div_other_payment").hide();
                $("[name='quo.other_payment_terms']").val("");

                $("#div_payment_terms").addClass("required");
                $("[name='quo.payment_terms']").data("validation", "required");

                $("select[name='quo.payment_terms'] option[value='OTH']").remove();
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
                        $('.modal-body').animate({ scrollTop: 0 }, 500);
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

                $("input[name='doc_id']").val($("[name='quo.id']").val());
                UploadFileAPI("");
                $(this).closest("div").find("input[name$='cancellation.uploaded']").val("1");
                $(this).closest("div").find("input[name$='cancellation_file']").css({ 'background-color': '' });
            }
        });

   
        function calculatetotalDiscount() {
            var current = "<%=Q.discount_currency%>";
            if (current == null || current == "") {
                current = "USD";
            }

            var currency = $("select[name = 'quo.discount_currency']").attr("selected", "selected").val(current);
             
            $("#txt_TypeAmt").text(current);
            var discType = $("[name='quo.discount_type']").val();
            if (discType == "$") {
                calculateDiscount();
            }
            proRateDiscount();
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

        function setPaymentTerms() {

            var idx = listSupplierAddress.findIndex(x => x.id == supplierId);
            var d = listSupplierAddress[idx];
            //$("select[name='quo.payment_terms']").val(d.PaymentTerms).trigger("change");
        }

        function populateDiscCurrency() {
            while (listDiscCurrency.length > 0) {
                listDiscCurrency.pop();
            }

            listDiscCurrency = [{ id: "USD" }];
            $.each(QuoItems, function (i, d) {
                var dscCurrency = listDiscCurrency.findIndex(x => x.id === d.currency_id);

                if (dscCurrency == -1 && d.currency_id != null) {
                    listDiscCurrency.push({ id: d.currency_id });
                }

            });

            lookUpDiscCurrency();
        }

        function hideSelectSupplierAddress() {
            $("#SupplierAddress").hide();
            $("[name='quo.supplier_address']").select2({ width: 'element' });

        }
        function showSelectSupplierAddress() {
            $("#SupplierAddress").show();
            $("[name='quo.supplier_address']").select2({ width: 'element' });
        }

        function loadBtnEditSundry() {
            var btnEditSundry = '<span class="label green btnSundryEdit" data-toggle="modal" href="#SundryForm" title="Detail"><i class="icon-pencil edit" style="opacity: 0.7;"></i></span >'
                + '<input id="sundry_address" type="hidden" data-validation="required" data-title="Supplier address">';
            $("#SupplierAction").html(btnEditSundry);
        }

        function loadSupplierAddressRequired() {
            var html = '<input id="supplier_address" type="hidden">'
                    +'<input id="supplier_contact_person" type="hidden" >'
                    +'<input id="supplier_email" type="hidden">';

            $("#SupplierAction").html(html);

        }

        //Sundry supplier
        $(document).on("click", ".btnSundryEdit", function () {
            var id = $("#SupplierAction").attr("data-id")
            var idx = listSupplierAddress.findIndex(x => x.id == id);
            var d = listSupplierAddress[idx];

            EditSundry(d);
        });

        function EditSundry(d) {
            $("#SundryForm tbody").empty();
            $("#SundryForm-error-message").empty();
            $("#SundryForm-error-box").hide();

            var html = AddDetailSundrySupplierHTML(d.company_name, d.id, "","","");
            //html += '<tr>'
            //    + '<td>Sundry </td>'
            //    + '<td>' + d.company_name
            //    + '<input type="hidden" name="sundry.id" value="' + d.id + '" >'
            //    + '</td>'
            //    + '</tr>'
            //    + '<tr>'
            //    + '<td>Name <span style="color: red;">*</span></td>'
            //    + '<td>'
            //    + '<div class="">'
            //    + '<div class="">'
            //    + '<input type="text" name="sundry.name" placeholder="Name" value=""  class="span12" />'
            //    + '</div>'
            //    + '</div>'
            //    + '</td>'
            //    + '</tr>'
            //    + '<tr>'
            //    //
            //    + '<tr>'
            //    + '<td>Contact person <span style="color: red;">*</span></td>'
            //    + '<td>'
            //    + '<div class="">'
            //    + '<div class="">'
            //    + '<input type="text" name="sundry.contact_person" placeholder="Contact person" value="" class="span12"/>'
            //    + '</div>'
            //    + '</div>'
            //    + '</td>'
            //    + '</tr>'
            //    //
            //    + '<tr>'
            //    + '<td>Email <span style="color: red;">*</span></td>'
            //    + '<td>'
            //    + '<div class="">'
            //    + '<div class="">'//
            //    + '<input type="email" name="sundry.email" data-title="email" placeholder="Email" value="" class="span12"/>'
            //    + '</div>'
            //    + '</div>'
            //    + '</td>'
            //    + '</tr>'
            //    //
            //    + '<tr>'
            //    + '<td>Phone number <span style="color: red;">*</span></td>'
            //    + '<td>'
            //    + '<div class="">'
            //    + '<div class="">'//
            //    + '<input type="text" name="sundry.phone_number" placeholder="Phone number" value="" class="span12"/>'
            //    + '</div>'
            //    + '</div>'
            //    + '</td>'
            //    + '</tr>'
            //    //
            //    + '<td>Bank account</td>'
            //    + '<td>'
            //    + '<div class="">'
            //    + '<div class="">'
            //    + '<input type="text" name="sundry.bank_account" placeholder="Bank account" value="" class="span12"/>'
            //    + '</div>'
            //    + '</div>'
            //    + '</td>'
            //    + '</tr>'
            //    + '<tr>'
            //    + '<td>Swift</td>'
            //    + '<td>'
            //    + '<div class="">'
            //    + '<div class="">'
            //    + '<input type="text" name="sundry.swift" placeholder="Swift" value="" class="span12"/>'
            //    + '</div>'
            //    + '</div>'
            //    + '</td>'
            //    + '</tr>'
            //    + '<tr>'
            //    + '<td>Sort code</td>'
            //    + '<td>'
            //    + '<div class="">'
            //    + '<div class="">'
            //    + '<input type="text" name="sundry.sort_code" placeholder="Sort code" value="" class="span12"/>'
            //    + '</div>'
            //    + '</div>'
            //    + '</td>'
            //    + '</tr>'
            //    + '<tr>'
            //    + '<td>Address</td>'
            //    + '<td>'
            //    + '<textarea name="sundry.address" class="textareavertical span12"  maxlength="2000" rows="10" placeholder="address" ></textarea>'
            //    + '<div class="mt-1" style="font-size: 80%; font-style: italic; display: block;">Maximum description is 2,000 characters</div>'
            //    + '</td>'
            //    + '</tr>'
            //    + '<tr>'
            //    + '<td>Place <span style="color: red;">*</span></td>'
            //    + '<td>'
            //    + '<div class="">'
            //    + '<div class="">'
            //    + '<input type="text" name="sundry.place" placeholder="Place" value=""  class="span12"/>'
            //    + '</div>'
            //    + '</div>'
            //    + '</td>'
            //    + '</tr>'
            //    + '<tr>'
            //    + '<td>Province</td>'
            //    + '<td>'
            //    + '<div class="">'
            //    + '<div class="">'
            //    + '<input type="text" name="sundry.province" placeholder="Province" value="" class="span12"/>'
            //    + '</div>'
            //    + '</div>'
            //    + '</td>'
            //    + '</tr>'
            //    + '<tr>'
            //    + '<td>Post code</td>'
            //    + '<td>'
            //    + '<div class="">'
            //    + '<div class="">'
            //    + '<input type="text" name="sundry.post_code" placeholder="Post code" value="" class="span12"/>'
            //    + '</div>'
            //    + '</div>'
            //    + '</td>'
            //    + '</tr>'
            //    + '<tr>'
            //    + '<td>VAT RegNo</td>'
            //    + '<td>'
            //    + '<div class="">'
            //    + '<div class="">'
            //    + '<input type="text" name="sundry.vat_reg_no" placeholder="VAT RegNo"  value="" class="span12"/>'
            //    + '</div>'
            //    + '</div>'
            //    + '</td>'
            //    + '</tr>';

            $("#SundryForm").modal("show");
            $("#SundryForm tbody").append(html);
            populateSundry();
        }

        $(document).on("click", "#btnSundrySave", function () {
            validateSundry();
        });

        function validateSundry() {
            var errorMsg = "";
            var confirmMsg = "";
            errorMsg += EmailValidation();

            if ($("[name='sundry.name']").val() == "") {
                errorMsg += "<br/> - Name is required.";
            }

            if ($("[name='sundry.contact_person']").val() == "") {
                errorMsg += "<br/> - Contact person is required.";
            }
            if ($("[name='sundry.email']").val() == "") {
                errorMsg += "<br/> - email is required.";
            }
            if ($("[name='sundry.phone_number']").val() == "") {
                errorMsg += "<br/> - Phone number is required.";
            }

            if ($("[name='sundry.place']").val() == "") {
                errorMsg += "<br/> - Place is required.";
            }

            if (errorMsg !== "") {
                errorMsg = "Please correct the following error(s):" + errorMsg;

                $("#SundryForm-error-message").html("<b>" + errorMsg + "<b>");
                $("#SundryForm-error-box").show();
                $('.modal-body').animate({ scrollTop: 0 }, 500);
            }
            else {
                if (confirmMsg != "") {
                    confirmMsg += "Do you want to proceed?";

                    if (!confirm(confirmMsg)) {
                        return;
                    }
                }

                var id = $("[name='sundry.id']").val();
                var idx = listSupplierAddress.findIndex(x => x.id == id);
                var d = listSupplierAddress[idx];

                var data = new Object();
                data.id = "";
                data.sundry_supplier_id = d.id;
                data.module_id = "";
                data.module_type = "";
                data.name = $("[name='sundry.name']").val();
                data.address = $("[name='sundry.address']").val();
                data.bank_account = $("[name='sundry.bank_account']").val();
                data.swift = $("[name='sundry.swift']").val();
                data.sort_code = $("[name='sundry.sort_code']").val();
                data.place = $("[name='sundry.place']").val();
                data.province = $("[name='sundry.province']").val();
                data.post_code = $("[name='sundry.post_code']").val();
                data.vat_reg_no = $("[name='sundry.vat_reg_no']").val();
                data.contact_person = $("[name='sundry.contact_person']").val();
                data.email = $("[name='sundry.email']").val();
                data.phone_number = $("[name='sundry.phone_number']").val();

                // check data sundry
                var ids = dataSundry.findIndex(x => x.sundry_supplier_id == d.id);
                if (ids != -1) {
                    data.id = dataSundry[ids].id;
                    dataSundry.splice(ids, 1); // remove sundry
                }

                dataSundry.push(data);
                $("#SupplierContactPerson").html(data.contact_person);
                $("#SupplierEmail").html(data.email);

                $("#SundryAddress").html(setSundryAddress(data));
                $("#sundry_address").val(setSundryAddress(data));

                $("#SundryForm").modal("hide");
            }
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

        function setSundryAddress(data) {
            var address = ""
            if (data.address != "") {
                address += data.address;
            }

            //if (data.place != "") {
            //    if (address != "") {
            //        address += ", " + data.place;
            //    } else {
            //        address += data.place;
            //    }
            //}

            //if (data.province != "") {
            //    if (address != "") {
            //        address += ", " + data.province;
            //    } else {
            //        address += data.province;
            //    }
            //}

            return address;
        }

        function loadRFQSundry(d) {

            var data = new Object();
            data.id = "";
            data.sundry_supplier_id = d.sundry_supplier_id;
            data.module_id = "";
            data.module_type = "";
            data.name = d.name;
            data.address = d.address;
            data.bank_account = d.bank_account;
            data.swift = d.swift;
            data.sort_code = d.sort_code;
            data.place = d.place;
            data.province = d.province;
            data.post_code = d.post_code;
            data.vat_reg_no = d.vat_reg_no;
            data.contact_person = d.contact_person;
            data.email = d.email;
            data.phone_number = d.phone_number;


            // check data sundry
            var ids = dataSundry.findIndex(x => x.sundry_supplier_id == d.sundry_supplier_id);
            if (ids != -1) {
                dataSundry.splice(ids, 1); // remove sundry
            }

            dataSundry.push(data);

            $("#SupplierContactPerson").html(d.contact_person);
            $("#SupplierEmail").html(d.email);
        }

        function loadCurrentAddressSundry() {
            var id = $("[name='quo.vendor']").val();
            var currentSundry = dataSundry;

            var sundry = $.grep(currentSundry, function (n, i) {
                return n["sundry_supplier_id"] == id
            });

            if (sundry.length > 0) {

                $("#SundryAddress").html(setSundryAddress(sundry[0]));
                $("#sundry_address").val(setSundryAddress(sundry[0]));
                $("#SupplierContactPerson").html(sundry[0].contact_person);
                $("#SupplierEmail").html(sundry[0].email);
            } else {
                $("#SundryAddress").empty();
                $("#sundry_address").val("");
                $("#SupplierContactPerson").empty();
                $("#SupplierEmail").empty();
            }
        }

        function resetDataSundry() {
            dataSundry = [];
        }

        // end sundry supplier

        function convertDiscountToUsd() {

            $.each(QuoItems, function (i, d) {
                var total_discount = d.discount_amount + d.additional_discount;
                var total_discount_usd = "0";

                if (d.exchange_sign === "/") {
                    total_discount_usd = accounting.formatNumber(total_discount / d.exchange_rate, 2)
                } else {
                    total_discount_usd = accounting.formatNumber(total_discount * d.exchange_rate, 2)
                }


                d.total_discount = total_discount;
                d.total_discount_usd = delCommas(accounting.formatNumber(total_discount_usd, 2));
            });
        }
    
        function populateHeader(){
              if(listHeaders.length > 0){
                other_payment_term = listHeaders[0].other_payment_terms;
             }
        }

        function supplierAddressValidation(){
            var errorMsg = "";
            var address = $("#supplier_address").val();
            var contact_person = $("#supplier_contact_person").val();
            var email = $("#supplier_email").val();

     
            if ( address == "") {
                errorMsg += "<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- Address is required.";
            }

            if (contact_person == "") {
                errorMsg += "<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- Contact person is required.";
            }

            if (email == "") {
                errorMsg += "<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- Email is required";
            }

            if (errorMsg != "") {
                errorMsg = "<br><b>" + "- Supplier address(s):"+ errorMsg + "<b>";
            }


            return errorMsg;
        }
    </script>
    
</asp:Content>

