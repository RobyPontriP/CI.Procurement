<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="uscPREdit.ascx.cs" Inherits="myTree.WebForms.Modules.PurchaseRequisition.uscPREdit" %>
<div id="PRForm" class="modal hide fade modal-dialog" tabindex="-1" role="dialog" aria-labelledby="header1" aria-hidden="true"
    data-backdrop="static" data-keyboard="false">
    <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-hidden="true"></button>

        <%  if (page_name == "verification")
            { %>
        <h3 id="header1">Detail product</h3>
        <%  } %>
        <%  else
            { %>
        <h3 id="header1">Add product</h3>
        <%  } %>
    </div>

    <div class="modal-body">
        <div class="floatingBox" id="prform-error-box" style="display: none">
            <div class="alert alert-error" id="prform-error-message">
            </div>
        </div>
        <input type="hidden" id="prfaction" />
        <input type="hidden" name="prf.id" />
        <input type="hidden" name="prf.uid" />
        <div class="control-group" id="searchProduct">
            <label class="control-label">
                Step 1. Search for an product
            </label>
            <div class="controls">
                <a href="#SearchForm" role="button" class="btn" data-toggle="modal" id="btnSearchItem">Search product</a>
            </div>
        </div>
        <div class="control-group">
            <label class="control-label">
                Product group
            </label>
            <div class="controls">
                <input type="hidden" name="prf.category" />
                <input type="text" name="prf.category_name" class="span6" readonly="readonly" />
            </div>
        </div>
        <div class="control-group" hidden>
            <label class="control-label">
                Sub category
            </label>
            <div class="controls">
                <input type="hidden" name="prf.subcategory" />
                <input type="text" name="prf.subcategory_name" class="span6" readonly="readonly" />
            </div>
        </div>
        <div class="control-group">
            <label class="control-label">
                Product name
            </label>
            <div class="controls">
                <input type="hidden" name="prf.brand" />
                <input type="text" name="prf.brand_name" class="span6" readonly="readonly" />
            </div>
        </div>

        <div class="control-group">
            <label class="control-label">
                Product code
            </label>
            <div class="controls">
                <input type="text" name="prf.item_code" class="span3" readonly="readonly" />
                <input type="hidden" name="prf.item_id" />
                <input type="hidden" name="prf.cost_account" />
            </div>
            <br />
        </div>
        <div class="control-group required">
            <label class="control-label">
                Product description
            </label>
            <div class="controls">
                <textarea rows="3" name="prf.description" class="span10 textareavertical" maxlength="1000"></textarea>
                <div class="mt-1" style="font-size: 80%; font-style: italic; display: block;">
                    Do not specify brand or model in the specifications<br/>
                    Maximum 1,000 characters
                </div>
            </div>
        </div>
        <div class="control-group required">
            <label class="control-label">
                Quantity
            </label>
            <div class="controls">
                <input type="text" name="prf.request_qty" class="span3 number" maxlength="18" data-decimal-places="2" />
            </div>
        </div>
        <div class="control-group required">
            <label class="control-label">
                Unit Of Measurement (UOM)
            </label>
            <div class="controls">
                <select style="width: 17%" name="prf.uom" class="span3"></select>
            </div>
        </div>
        <div class="control-group">
            <label class="control-label">
                Last purchased
            </label>
            <div class="controls">
                <table class="table table-bordered">
                    <thead>
                        <tr>
                            <th style="width: 40%;" id="lp_po_product_description_header">Product description
                            </th>
                            <th style="width: 10%; text-align: right;" id="lp_quantity_header">Quantity
                            </th>
                            <th style="width: 30%; text-align: right;" id="lp_price_header">Unit price
                            </th>
                            <th style="width: 20%;" id="lp_date_header">Date
                            </th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td id="lp_po_product_description">N/A</td>
                            <td id="lp_quantity" style="text-align: right;">N/A</td>
                            <td id="lp_price" style="text-align: right">N/A</td>
                            <td id="lp_date">N/A</td>
                        </tr>
                    </tbody>
                </table>
                <input type="hidden" name="prf.last_price_amount" />
                <input type="hidden" name="prf.last_price_currency" />
                <input type="hidden" name="prf.last_price_quantity" />
                <input type="hidden" name="prf.last_price_uom" />
                <input type="hidden" name="prf.last_price_date" />
            </div>
        </div>

        <div class="control-group required">
            <label class="control-label">
                Currency
            </label>
            <div class="controls">
                <div class="span4">
                    <select name="pr.currency_id" style="width: 55%" data-title="Currency" class="span12"></select>
                </div>
                <div class="span3">
                    <label>Exchange rate (to USD)</label>
                </div>
                <div class="span4">
                    <div class="input-prepend">
                        <span class="add-on" id="exchange_sign"><%=pr.exchange_sign_format %></span>
                        <input type="hidden" name="pr.exchange_sign" value="<%=pr.exchange_sign %>">
                        <input type="text" style="width: 235px;" name="pr.exchange_rate" data-title="Exchange rate" data-decimal-places="8" class="number span18" placeholder="Exchange rate" maxlength="18" value="<%=pr.exchange_rate%>">
                    </div>

                </div>
            </div>
        </div>

        <div class="control-group required">
            <label class="control-label">
                Unit price
            </label>
            <div class="controls">
                <div class="span4">
                    <div class="input-prepend">
                        <span class="add-on currency"></span>
                        <input type="text" name="prf.unit_price" class="span9 number" data-decimal-places="2" maxlength="18" />
                    </div>
                </div>
                <div class="span3">
                    <label>USD equivalent</label>
                </div>
                <div class="span4">
                    <input type="text" name="prf.unit_price_usd" class="span9 number" data-decimal-places="2" readonly="readonly" />
                </div>
            </div>
        </div>

        <div class="control-group">
            <label class="control-label">
                Total price
            </label>
            <div class="controls">
                <div class="span4">
                    <div class="input-prepend">
                        <span class="add-on currency"></span>
                        <input type="text" name="prf.estimated_cost" class="span9 number" data-decimal-places="2" readonly="readonly" />
                    </div>
                </div>
                <div class="span3">
                    <label>USD equivalent</label>
                </div>
                <div class="span4">
                    <input type="text" name="prf.estimated_cost_usd" class="span9 number" data-decimal-places="2" readonly="readonly" />
                </div>
            </div>
        </div>
        <div class="control-group required">
            <label class="control-label">
                Purpose
            </label>
            <div class="controls">
                <textarea name="prf.purpose" data-title="Purpose" rows="5" class="span10 textareavertical" placeholder="Purpose" maxlength="2000"></textarea>
                <br />
                <small>Please specify the purpose/function of good(s) or service(s) about to purchase and determine their delivery or address where the service(s) conducted.</small>
            </div>
        </div>

        <div class="control-group required" id="div_delivery_address">
            <label class="control-label">
                Delivery address
            </label>
            <div class="controls">
                <select style="width: 83%" name="prf.delivery_address" class="span3"></select>
            </div>
        </div>

        <div class="control-group" id="div_is_other_address">
            <label class="control-label">
                Other delivery address
            </label>
            <div class="controls">
                <input type="checkbox" name="prf.is_other_address" /><label for="prf.is_other_address"></label>
            </div>
        </div>
        <div class="control-group" id="div_other_address" style="display: none;">
            <div class="controls">
                <textarea name="prf.other_delivery_address" maxlength="255" rows="3" class="span10 textareavertical" data-title="Other delivery address" placeholder="Other delivery address"></textarea>
                <br />
                <small><i>Maximum other delivery address is 255 characters</i></small>
            </div>
        </div>

        <div class="control-group required">
            <label class="control-label">
                Charge code
            </label>
            <div class="controls">
                <%--<table id="tblCostCenters" class="table table-bordered table-striped" style="table-layout: fixed;">--%>
                <table id="tblCostCenters" class="table table-bordered table-hover" style="border: 1px solid #ddd">
                    <thead>
                        <tr>
                            <th style="display: none;">No
                            </th>
                            <th style="text-align: center; word-wrap: break-word;">Cost center<span class="asteriskChargeCode" style="color: Red;">*</span>
                            </th>
                            <th style="text-align: center; word-wrap: break-word;">Work order<span class="asteriskChargeCode" style="color: Red;">*</span>
                            </th>
                            <th style="text-align: center; word-wrap: break-word;">Entity <span class="asteriskChargeCode" style="color: Red;">*</span>
                            </th>
                            <th style="text-align: center; word-wrap: break-word;">Legal entity
                            </th>
                            <th style="text-align: center; word-wrap: break-word;" hidden>Control Account <span class="asteriskChargeCode" style="color: Red;">*</span>
                            </th>
                            <th style="text-align: center; word-wrap: break-word; width: 5%;">% <span class="asteriskChargeCode" style="color: Red;">*</span>
                            </th>
                            <th id="lbItemAmt" style="text-align: center; word-wrap: break-word;"><%=pr.currency_id %>Amount () <span class="asteriskChargeCode" style="color: Red;">*</span>
                            </th>
                            <th style="text-align: center; word-wrap: break-word;">Amount (USD)
                            </th>
                            <th style="text-align: center; word-wrap: break-word;">Remarks
                            </th>
                            <th class="w80" style="width: 5%; word-wrap: break-word;"></th>
                        </tr>
                    </thead>
                    <tfoot>
                        <tr>
                            <td colspan="4" style="text-align: right;"><b>Total</b></td>
                            <td id="ChargeCodePercentage" style="text-align: right;"></td>
                            <td id="ChargeCodeAmount" class="ChargeCodeAmount" style="text-align: right;"></td>
                            <td id="ChargeCodeAmountUSD" class="ChargeCodeAmountUSD" style="text-align: right;"></td>
                            <td colspan="2"></td>
                        </tr>
                    </tfoot>
                    <tbody>
                    </tbody>
                </table>
                <p>
                    <button id="btnAddChargeCode" class="btn btn-success" type="button" data-toggle="modal" onclick="onClickAddCostCenters()" data-doctype="PURCHASE REQUISITION GENERAL">Add</button>
                </p>
                <%--   <a href="<%=hostURL %>" target="_blank">CIFOR-ICRAF charge codes mapping to OCS work orders</a>--%>
            </div>
        </div>

        <div class="control-group">
            <label class="control-label">
                Supporting document(s)
            </label>
            <div class="controls">
                <small><i>Attach any quotations, brochure, catalog , etc, related to the product, which might help Procurement to follow up to your query faster</i></small>
                <table id="tblAttachment" class="table table-bordered table-hover" style="border: 1px solid #ddd">
                    <thead>
                        <tr>
                            <th style="width: 50%;">Description</th>
                            <th style="width: 40%;">File</th>
                            <%  if (page_name == "input")
                                { %>
                            <th style="width: 10%;">&nbsp;</th>
                            <th style="width: 5%; display: none;">Uploaded</th>
                            <%  } %>
                        </tr>
                    </thead>
                    <tbody>
                    </tbody>
                </table>
                <%  if (page_name == "input")
                    { %>
                <div class="doc-notes"></div>
                <p>
                    <button id="btnAddAttachment" class="btn btn-success" type="button" data-toggle="modal" data-doctype="PURCHASE REQUISITION">Add supporting document</button>
                </p>
                <%  } %>
            </div>
        </div>
    </div>
    <div class="modal-footer">
        <button type="button" class="btn btn-success" aria-hidden="true" id="btnSaveDetail">Save</button>
        <%  if (page_name == "verification")
            { %>
        <button type="button" class="btn" data-dismiss="modal" aria-hidden="true" id="btnCloseDetail">Close</button>
        <%  } %>
        <%  else
            { %>
        <button type="button" class="btn" data-dismiss="modal" aria-hidden="true" id="btnCloseDetail">Close and cancel</button>
        <%  } %>
    </div>
</div>

<div id="SearchForm" class="modal hide fade modal-dialog" data-backdrop-limit="1" tabindex="-2" role="dialog" aria-labelledby="header2" aria-hidden="true"
    data-backdrop="static" data-keyboard="false">
    <div class="modal-header">
        <button type="button" onclick="closeAllModal()" class="close" data-dismiss="modal" aria-hidden="true"></button>
        <h3 id="header2">Search product</h3>
    </div>
    <div class="modal-body">
        <div class="floatingBox" id="searchform-error-box" style="display: none">
            <div class="alert alert-error" id="searchform-error-message">
            </div>
        </div>
        <h5 id="searchitemtop"><i>Step 1.  Type in the general search and click "Search"</i></h5>
        <div class="control-group">
            <label class="control-label">
                General search
            </label>
            <div class="controls">
                <input type="text" class="span8" maxlength="100" id="search_general" placeholder="General search" />
            </div>
        </div>
        <%--<div class="control-group">
            <label class="control-label">
                <b>OR</b>
            </label>
        </div>
        <div class="control-group">
            <label class="control-label">
                Brand
            </label>
            <div class="controls">
                <input type="text" class="span8" maxlength="100" id="search_brand" placeholder="Brand" />
            </div>
        </div>
        <div class="control-group">
            <label class="control-label">
                Specifications
            </label>
            <div class="controls">
                <input type="text" class="span8" maxlength="100" id="search_description" placeholder="Specifications" />
            </div>
        </div>--%>
        <div class="control-group">
            <div class="controls">
                <button type="button" id="btnSearch" class="btn btn-success">Search</button>
            </div>
        </div>
        <div id="searchResult">
            <div class="control-group">
                <h5><i>Step 2. Choose one of search results and click "Select product"</i></h5>
                <table id="tblSearchItems" class="table table-bordered table-hover" style="border: 1px solid #ddd">
                </table>
                <br />
            </div>
        </div>
        <div id="addOtherItem" hidden>
            <h5><i>Step 3. Provide new product, only you cannot find the product you were looking for. Type in the Brand and Type and Specification of the product</i></h5>
            <div class="control-group">
                <label class="control-label">
                    Brand
                </label>
                <div class="controls">
                    <input type="text" class="span8" maxlength="100" id="other_brand" placeholder="Brand" />
                    <br />
                    <small><i>If you cannot specify the brand, please type Any brand</i></small>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">
                    Specifications
                </label>
                <div class="controls">
                    <textarea rows="3" maxlength="2000" class="span8 textareavertical" id="other_description" placeholder="Specifications"></textarea>
                    <br />
                    <small><i>Please provide specific detail description of new product.  Ex. Computer table. RAM 8GB, Screen size 10”, Storage 256GB, color black, using USB C type of charging</i></small>
                </div>
            </div>
        </div>
    </div>
    <div class="modal-footer">
        <button type="button" class="btn btn-success" aria-hidden="true" id="btnSaveOtherItem" hidden>Save product</button>
        <button type="button" class="btn" data-dismiss="modal" aria-hidden="true" onclick="closeAllModal()">Close</button>
    </div>
</div>
<div id="hiddenFiles" style="display: none;"></div>
<!-- end of bootstrap modal(s) -->

<input type="hidden" id="status" value="<%=pr.status_id %>" />
<input type="hidden" name="pr.id" value="<%=pr.id %>" />
<input type="hidden" name="action" id="action" value="" />
<input type="hidden" name="file_name" id="file_name" value="" />
<input type="hidden" name="doc_id" value="<%=pr.id %>" />
<input type="hidden" name="doc_type" value="PURCHASEREQUISITION" />
<input type="hidden" name="is_cancel" value="" />
<input type="hidden" name="pr.is_procurement" value="<%=pr.is_procurement %>" />
<input type="hidden" name="docidtemp" value="" />
<input type="hidden" name="submission_page_name" value="<%=pr.submission_page_name%>" />
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
<div class="control-group required">
    <label class="control-label">
        Requester
    </label>
    <div class="controls">
        <select name="pr.requester" data-title="Requester" data-validation="required" class="span4"></select>
    </div>
</div>
<div class="control-group required">
    <label class="control-label">
        Required date
    </label>
    <div class="controls">
        <div class="input-prepend">
            <input type="text" name="pr.required_date" data-title="Required date" data-validation="required date" class="span8" readonly="readonly" placeholder="Required date" maxlength="11" value="<%=pr.required_date%>" />
            <span class="add-on icon-calendar" id="requiredDate"></span>
        </div>
        <br />
        <small><i>Disclaimer: The default estimated required date is 22 working days from your submission date, in condition the Purchase Requisition approval completed within 6 working days and all product(s) are ready stock locally and postpaid.</i></small>
    </div>
</div>
<div class="control-group required">
    <label class="control-label">
        Purchase/finance office
    </label>
    <div class="controls">
        <small><i>This is a default value, and you can change it as needed</i></small>
        <br />
        <select name="pr.cifor_office_id" data-title="Purchase/finance office" data-validation="required" class="span4" onchange="onChangeDDLPurchaseOffice()">
        </select>
    </div>
</div>
<%--<div class="control-group required">
    <label class="control-label">
        Charge code
    </label>
    <div class="controls">
        <select name="pr.cost_center_id" data-title="Charge code" data-validation="required" class="span4" ></select>&nbsp;
        <select name="pr.t4" data-title="Work order" data-validation="required" class="span6" ></select>
    </div>
    <div class="controls">
        <a href="<%=hostURL %>" target="_blank">CIFOR charge codes mapping to OCS work orders</a>        
    </div>
</div>--%>
<div class="control-group">
    <label class="control-label">
        Remarks
    </label>
    <div class="controls">
        <textarea name="pr.remarks" data-title="Remarks" rows="5" class="span10 textareavertical" placeholder="Remarks" maxlength="2000"><%=pr.remarks%></textarea>
        <br />
        <small><i>Maximum description is 2,000 characters</i></small>
    </div>
</div>

<div class="control-group required">
    <br>
    <%--<p class="filled info">For those request of computer software and/or hardware, in the meantime, should include the email recommendation from ICT manager</p>--%>
    <table id="tblItems" class="table table-bordered table-hover required" data-title="Product(s)" style="border: 1px solid #ddd">
        <thead>
            <tr>
                <%--<th style="width:2%"><i class="icon-chevron-sign-down dropAllDetail" title="Collapse/Expand detail(s)"></i></th>--%>
                <th style="width: 2%"></th>
                <th>Product code</th>
                <th>Description</th>
                <th>Quantity</th>
                <th>UoM</th>
                <th>Currency</th>
                <th id="lbUnitPrice">Unit price</th>
                <th id="lbCostEstimated">Cost estimated</th>
                <th>Cost estimated (USD)</th>
                <th>Supporting document(s)</th>
                <th>&nbsp;</th>
            </tr>
        </thead>
        <tfoot>
            <tr>
                <td colspan="7" style="text-align:right;"><b>Grand total</b></td>
                <td id="GrandTotal" style="text-align: right;"></td>
                <td id="GrandTotalUSD" style="text-align: right;"></td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
            </tr>
        </tfoot>
        <tbody>
        </tbody>
    </table>
    <%  if (page_name == "input")
        { %>
    <p>
        <button id="btnAdd" href="#PRForm" class="btn btn-success" type="button" data-toggle="modal">Add product</button>
    </p>
    <%  } %>
</div>
<div class="control-group required" id="div_is_other_purchase_type">
    <br>
    <p class="filled info">Purchase type determines the type of product(s) you are purchasing, and it will determine the team that will process your purchase requisition.</p>
    <label class="control-label">
        Purchase type
    </label>
    <div class="controls">
        <select id="purchase_type_option" name="pr.purchase_type" data-title="Purchase type" data-validation="required" class="span4 select_purchase toSelect2"></select>
        &nbsp;&nbsp;&nbsp;<button id="btnChangePurchaseType" class="btn btn-success" type="button" data-toggle="modal" data-page="0" hidden>Change purchasing type to</button>
    </div>
</div>
<div id="supporting_doc_notes2"></div>
<div class="control-group" id="divDirectToFinance">
    <br>
    <%--<div id="supporting_doc_notes2"></div>--%>
    <label class="control-label">
        <%--Reasons for self purchasing by requester--%>
        Justification
    </label>
    <div class="controls">
        <div id="cash_advance_notes"></div>
        <textarea name="pr.direct_to_finance_justification" id="direct_to_finance_justification" data-group="directFinance" data-validation-primary="yes" data-title="Reasons for self purchasing by requester" rows="5" class="span10 textareavertical" maxlength="2000"><%=pr.direct_to_finance_justification %></textarea>
        <br />
        <div class="fileinput_direct_to_finance" style="margin-top: 5px;">

            <%  if (!string.IsNullOrEmpty(pr.direct_to_finance_file))
                { %>
            <span class="linkDocumentFinance"><a href="Files/<%=pr.id %>/<%=pr.direct_to_finance_file %>" id="linkDocumentFinance" target="_blank"><%=pr.direct_to_finance_file %></a>&nbsp;</span>
            <%  if (page_name == "input")
                { %>
            <button type="button" class="btn btn-primary editDirectToFinanceFile">Edit</button>
            <%  } %>
            <input type="file" id="_direct_to_finance_file" name="direct_to_finance_file" style="display: none;" />
            <input type="hidden" name="justification.uploaded" value="1" />
            <button type="button" class="btn btn-success btnFileUploadJustification" data-type="file_justification" style="display: none;">Upload</button>
            <%  }
                else
                { %>
            <%  if (page_name == "input")
                { %>
            <span class="linkDocumentFinance" style="display: none;"><a href="Files/<%=pr.id %>/<%=pr.direct_to_finance_file %>" id="linkDocumentFinance" target="_blank"><%=pr.direct_to_finance_file %></a>&nbsp;</span>
            <button type="button" class="btn btn-primary editDirectToFinanceFile" hidden>Edit</button>
            <input type="file" id="_direct_to_finance_file" name="direct_to_finance_file" />
            <input type="hidden" name="justification.uploaded" value="0" />
            <button type="button" class="btn btn-success btnFileUploadJustification" data-type="file_justification">Upload</button>
            <%  } %>
            <%  } %>
            <%  if (page_name == "input")
                { %>
            <div class="doc-notes-justification"></div>
            <%  } %>
            <input style="display: none;" name="pr.direct_to_finance_file" id="direct_to_finance_file" data-group="directFinance" data-validation-primary="no" data-title="Reasons for self purchasing by requester" value="<%=pr.direct_to_finance_file%>" autocomplete="off" />
        </div>
    </div>
</div>
<div class="control-group required" id="ControlAttachmentGeneral">
    <br>
    <div id="supporting_doc_notes"></div>
    <label class="control-label">
        Supporting document(s)
    </label>
    <div class="controls">
        <table id="tblAttachmentGeneral" data-title="Supporting document(s)" class="table table-bordered table-hover required" style="border: 1px solid #ddd">
            <thead>
                <tr>
                    <th style="width: 50%;">Description</th>
                    <th style="width: 40%;">File</th>
                    <%  if (page_name == "input")
                        { %>
                    <th style="width: 10%;">&nbsp;</th>
                    <th style="width: 5%; display: none;">Uploaded</th>
                    <%} %>
                </tr>
            </thead>
            <tbody>
            </tbody>
        </table>
        <%  if (page_name == "input")
            { %>
        <div class="doc-notes"></div>
        <p>
            <button id="btnAddAttachment" class="btn btn-success" type="button" data-toggle="modal" data-doctype="PURCHASE REQUISITION GENERAL">Add supporting document</button>
        </p>
        <%} %>
    </div>
</div>
<%  if (page_name != "input")
    { %>

<div class="control-group" id="div_move_purchase_office">
    <br>
    <label class="control-label">
        Redirect to other purchase office
    </label>
    <div class="controls">
        <select name="cifor_office_id_move" data-title="Redirect to other purchase office" class="span4">
        </select>
        <button id="btnMovePurchaseOffice" class="btn btn-success" data-action="movepurchaseoffice" type="button">Redirect to other purchase office</button>
    </div>
</div>

<div class="control-group" id="div_move_po_comment">
    <label class="control-label">
        Comments
    </label>
    <div class="controls">
        <textarea name="comments" data-title="Comments" rows="5" class="span10 textareavertical" placeholder="comments" maxlength="2000"></textarea>
    </div>
</div>
<%  } %>
<script>
    var page_name = "<%=page_name%>";
    var deletedId = [];
    var popupDeleteId = [];
    var PRHeader = <%=PRHeader%>;
    var PRDetail = <%=PRDetail%>;
    /*  var PRCCDetail = [];*/
    var PRAttachmentGeneral = <%=PRAttachmentGeneral%>;

    var listOffice = <%=listOffice%>;
    var listEmployee = <%=listEmployee%>;
    var listCurrency = <%=listCurrency%>;
    var listCostCenter = <%=listCostCenter%>;
    var listUoM = <%=listUoM%>;
    var listDelivery = <%=listDelivery%>;
    var listPRType = <%=listPRType%>;
    var listPRTypeFull = <%=listPRType%>;

    //if (id_submission_page_type == "1") {
    //    listPRType = $.grep(listPRType, function (n, i) {
    //        return n["value"] == "3";
    //    });
    //} else {
    //    listPRType = $.grep(listPRType, function (n, i) {
    //        return n["value"] != "3";
    //    });
    //}

    listDelivery = $.grep(listDelivery, function (n, i) {
        return n["AddressType"] == "2";
    });

    listDelivery = $.grep(listDelivery, function (n, i) {
        return n["Id"] != "23821";
    });

    var listEntity = <%=listEntity%>;
    var listEntityTemp = [];

    var listSearchItems = [];

    var _cifor_office_id = "<%=pr.cifor_office_id%>";
    var _requester = "<%=pr.requester%>";
    var _currency = "<%=pr.currency_id%>";
    var _cost_center = "<%=pr.cost_center_id%>";
    <%--var _t4 = "<%=pr.t4%>";--%>
    var _is_direct_to_finance = "<%=pr.is_direct_to_finance%>";
    var _purchase_type = "<%=pr.purchase_type%>";
    var _id = "<%= page_id %>";
    var _justification_file_link_200 = "<%=justification_file_link_200 %>";
    var _justification_file_link_1000 = "<%=justification_file_link_1000 %>";
    var _justification_file_link_25000 = "<%=justification_file_link_2500 %>";

    var _justification_file_link_below_25000 = "<%=justification_file_link_below_25000 %>";
    var _justification_file_link_above_25000 = "<%=justification_file_link_above_25000 %>";

    var file_uploaded = [];
    var folder_id_temp = "";
    var procOfficeFromDB = "<%=procOfficeFromDB%>";
    var isPOFFChangedDuringResubmission = false;
    <%--var is_other_address = "<%=prd.is_other_address%>";--%>
    var direct_to_finance_justification = "";
    var direct_to_finance_file = "<%=pr.direct_to_finance_file%>";
    var is_edit_product = false;

    $('.modal').on('shown.bs.modal', function () {
        $(document).off('focusin.modal');
    });

    $('.modal').on('hidden.bs.modal', function () {
        if ($(".modal:visible").length > 0) {
            setTimeout(function () {
                $('body').addClass('modal-open');
            }, 200)
        }
    });

    var SearchTable = initTable();

    function initTable() {
        return $('#tblSearchItems').DataTable({
            data: listSearchItems,
            columns: [
                { visible: false, title: "ID", data: "id" },
                {
                    title: "", data: "id", "width": "20%",
                    render: function (data, type, row) {
                        return '<button type="button" class="btn btn-small ItemSelect" data-id="' + data + '">Select product</button>';
                    }
                },
                { title: "Product code", data: "item_code", "width": "15%" },
                { title: "Product name", data: "brand_name", "width": "25%" },
                { title: "Account", data: "CostAccount", "width": "5%" },
                { title: "Account Description", data: "CostAccountName", "width": "25%" },
                /*{ title: "Specifications", data: "description", "width": "40%" },*/
                { visible: false, title: "Category", data: "category_name" },
                { visible: false, title: "Sub category", data: "subcategory_name" },
            ],
            "bFilter": true, "bDestroy": true, "bRetrieve": true, "pagingType": 'full_numbers',
            "searching": false,
            "info": false
        });
    }

    $(document).ready(function () {
        populateHeader();
        var cboOffice = $("select[name='pr.cifor_office_id']");
        /*  generateComboGroup(cboOffice, listOffice, "office_id", "office_name", "hub_option", true);*/
        generateCombo(cboOffice, listOffice, "office_id", "office_name", true);
        $(cboOffice).val(_cifor_office_id);
        Select2Obj(cboOffice, "Purchase/finance office");

        var cboRequester = $("select[name='pr.requester']");
        generateCombo(cboRequester, listEmployee, "EMP_USER_ID", "EMP_NAME", true);
        $(cboRequester).val(_requester).trigger("change");
        Select2Obj(cboRequester, "Requester");
        $(cboRequester).on('select2:select', function (e) {
            $.ajax({
                url: '<%= Page.ResolveUrl("~/" + based_url+service_url + "/GetRequesterProcurementOffice") %>',
                data: "{'user_id':'" + $(this).val() + "'}",
                dataType: 'json',
                type: 'post',
                contentType: "application/json; charset=utf-8",
                success: function (response) {
                    var data = response.d;
                    $("select[name='pr.cifor_office_id']").val(data).trigger("change");
                }
            })
        });

        _purchase_type = _id != "" ? _purchase_type : 3;

        var cboDirectFinance = $("select[name='pr.purchase_type']");
        //$(cboDirectFinance).val(_purchase_type);
        //Select2Obj(cboDirectFinance, "Purchase type");
        lookupPRType();
        checkOtherPurchase($(cboDirectFinance).val());

        if (_purchase_type != "3") {
            $("[name='pr.direct_to_finance_justification']").val(direct_to_finance_justification);
            $("[name='pr.direct_to_finance_file']").val(direct_to_finance_file);
            var urlLinkDocumentFinance = "Files/" + _id + "/" + direct_to_finance_file;
            $("#linkDocumentFinance").attr("href", urlLinkDocumentFinance)
            $("#linkDocumentFinance").text()
            var link = $(".editDirectToFinanceFile").closest("div").find(".linkDocumentFinance");

            if (direct_to_finance_file != "") {
                $(link).show();
                $(".editDirectToFinanceFile").show()
                $("#_direct_to_finance_file").hide();
                $(".btnFileUploadJustification").hide();
                $("input[name='justification.uploaded']").val('1');

            } else {
                $(link).hide();
                $(".editDirectToFinanceFile").hide()
                $("#_direct_to_finance_file").show();
                $(".btnFileUploadJustification").show();
                $("input[name='justification.uploaded']").val('0');

            }

        }


        var cboCC = $("select[name='pr.cost_center_id']");
        generateCombo(cboCC, listCostCenter, "CODES", "DESCRIPTION", true);
        $(cboCC).val(_cost_center);
        Select2Obj(cboCC, "Cost center");

        var cboCurr = $("select[name='pr.currency_id']");
        generateCombo(cboCurr, listCurrency, "CURRENCY_CODE", "CURRENCY_CODE", true);
        $(cboCurr).val(_currency);
        Select2Obj(cboCurr, "Currency");

        $(cboCurr).on('select2:select', function (e) {
            changeExchangeRate($(this).val());
            calculatePricePerItem();
            CalcAmtChargeCode();

            CalcAmtAndUSDAmtChargeCode();
            CalculateChargeCodePercentage(-1);
            AdjustAmountUSDChargeCode();
        });

        $("#requiredDate").datepicker({
            format: "dd M yyyy"
            , autoclose: true
            , startDate: "<%=minDate%>"
        }).on("changeDate", function () {
            $("[name='pr.required_date']").val($("#requiredDate").data("date"));
            $("#requiredDate").datepicker("hide");
        });

        $("#requiredDate").datepicker("setDate", new Date($("[name='pr.required_date']").val()));

        var cboUoM = $("select[name='prf.uom']");
        generateCombo(cboUoM, listUoM, "id", "text", true);
        Select2Obj(cboUoM, "Unit of measurement");

        var cboDelivery = $("select[name='prf.delivery_address']");
        generateCombo(cboDelivery, listDelivery, "Id", "Address", true);
        Select2Obj(cboDelivery, "Delivery address");

        //$.each(PRDetail, function (i, d) {
        //    populateItemTable(d, "add");
        //});
        populateItemTable(PRDetail, "add");
        if (PRAttachmentGeneral !== null && PRAttachmentGeneral.length !== 0) {
            $.each(PRAttachmentGeneral, function (i, d) {
                addAttachment(d.id, "", d.file_description, d.filename, d.document_type)
            });
        }

        CalculateItems();
        repopulateNumber();

        if (page_name == "verification" || page_name == "finance_verification") {
            $("[name^='pr.']").prop("disabled", true);
            $("[name^='pr.']").attr("placeholder", "");
            $("#requiredDate").hide();

            var cboOfficeMove = $("select[name='cifor_office_id_move']");
            var listOfficeMove = $.grep(listOffice, function (n, i) {
                return n["office_id"] != _cifor_office_id;
            });
            generateCombo(cboOfficeMove, listOfficeMove, "office_id", "office_name", true);
            Select2Obj(cboOfficeMove, "Purchase office");
        }

        $("[name='docidtemp']").val(guid());
    });

    <%--function CreateT4(obj, code, val) {
        var x = code.split('-');
        var _code = typeof x[0] === "undefined" ? "" : x[0];
        $.ajax({
            url: "<%=service_url %>" + '/GetSUNT4',
            data: "{'code':'" + _code + "'}",
            dataType: 'json',
            type: 'post',
            contentType: "application/json; charset=utf-8",
            success: function (response) {
                var data = response.d;
                if (x.length < 1) {
                    var data = [];
                }
                $(obj).empty();
                generateCombo(obj, data, "id", "text", true);
                $(obj).val(val);
                Select2Obj(obj, "Work order");
            }
        });
    }--%>

    function changeExchangeRate(curr) {
        var arr = $.grep(listCurrency, function (n, i) {
            return n["CURRENCY_CODE"] == curr;
        });

        var _sign = "/";
        var _rate = 0;
        if (arr.length > 0) {
            if (arr[0].OPERATOR == "/") {
                _sign = "&divide;";
            } else {
                _sign = "x";
            }
            _rate = accounting.formatNumber(arr[0].RATE, 8);
        }

        $("#exchange_sign").html(_sign);
        $("[name='pr.exchange_sign']").val(arr[0].OPERATOR);
        $("[name='pr.exchange_rate']").val(_rate);

        populateCurrency(curr);
        CalculateItems();
    }

    function populateCurrency(curr) {
        $("#lbUnitPrice").text("Unit price");
        $("#lbCostEstimated").text("Cost estimated");
        if (curr != '') {
            $("#lbItemAmt").text('');
            $("#lbItemAmt").append('Amount (' + curr + ')<span class="asteriskChargeCode" style="color: Red;"> *</span>');
        }

        $(".currency").text(curr);
    }

    $(document).on("change", "[name='pr.exchange_rate']", function () {
        CalculateItems();
    });

    function CalculateItems() {
        var sign = $("[name='pr.exchange_sign']").val();
        /*var rate = delCommas($("[name='pr.exchange_rate']").val());*/
        var estimated_cost = 0;
        var estimated_cost_usd = 0;
        /*if (PRDetail.length > 0 && $("#tblItems tbody tr").length == PRDetail.length) {*/
        if (PRDetail.length > 0) {
            $.each(PRDetail, function (i, d) {
                var a = PRDetail[i];
                var rate = parseFloat(a.exchange_rate);
                if (a.exchange_sign_format == "/") {
                    a.unit_price_usd = delCommas(accounting.formatNumber(parseFloat(a.unit_price) / rate, 2));
                    a.estimated_cost_usd = delCommas(accounting.formatNumber(parseFloat(a.estimated_cost) / rate, 2));
                } else {
                    a.unit_price_usd = delCommas(accounting.formatNumber(parseFloat(a.unit_price) * rate, 2));
                    a.estimated_cost_usd = delCommas(accounting.formatNumber(parseFloat(a.estimated_cost) * rate, 2));
                }

                estimated_cost += parseFloat(a.estimated_cost);
                estimated_cost_usd += parseFloat(a.estimated_cost_usd);
                let PRDetailTemp = [];
                PRDetailTemp.push(PRDetail[i]);
                populateItemTable(PRDetailTemp, "edit");
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

        /*$("#GrandTotal").html(strestimated_costCurr + '<b>' + accounting.formatNumber(estimated_cost, 2) + '</b>');*/
        $("#GrandTotal").html(strestimated_costCurr);
        $("#GrandTotalUSD").html('<b>' + accounting.formatNumber(estimated_cost_usd, 2) + '</b>');

        /* if ($("[name='pr.purchase_type']").val() == "1" || $("[name='pr.purchase_type']").val() == "4" || $("[name='pr.purchase_type']").val() == "5") {*/
        if ($("[name='pr.purchase_type']").val() != "3" && estimated_cost_usd > 200) {
            ShowReasonPurchase();
        } else {
            HideReasonPurchase();
        }
        supportingDocNotes($("[name='pr.purchase_type']").val());
    }

    $(document).on("change", "[name='pr.purchase_type']", function () {
        resetJustification();
        var isOther = $(this).val();
        checkOtherPurchase(isOther);


    });

    function resetJustification() {
        $("[name='pr.direct_to_finance_justification']").val("");
        var obj = $("input[name='pr.direct_to_finance_file']");
        $(obj).val("");
        var obj2 = $("input[name='direct_to_finance_file']");
        $(obj2).val("");

        var obj = $("input[name='pr.direct_to_finance_file']");
        $(obj).val("");
        var obj = $(".editDirectToFinanceFile").closest("div").find("input[name='direct_to_finance_file']");
        var link = $(".editDirectToFinanceFile").closest("div").find(".linkDocumentFinance");

        $(".editDirectToFinanceFile").closest("div").find(".btnFileUploadJustification").show();
        $(".editDirectToFinanceFile").closest("div").find("input[name$='justification.uploaded']").val("0");
        $(obj).val('');
        $(obj).show();
        $(link).hide();
        $(".editDirectToFinanceFile").hide();
    }
    function checkOtherPurchase(isOther) {
        var grandtotalusd = delCommas($("#GrandTotalUSD").text());
        if (isOther == "3") {
            $("#div_is_other_purchase_type").addClass("last");
            $("#div_is_other_purchase_type").addClass("required");
            if (grandtotalusd <= 200) {
                supportingDocNotes(isOther);
            } else {
                supportingDocNotes(isOther);
            }
            HideReasonPurchase();
            /*  } else if (isOther == "1" || isOther == "4" || isOther == "5") {*/
        } else if (isOther != "3" && grandtotalusd > 200) {
            ShowReasonPurchase();
        } else {
            $("#div_is_other_purchase_type").removeClass("last");
            HideReasonPurchase();
        }



        supportingDocNotes($("[name='pr.purchase_type']").val());
    }

    function HideReasonPurchase() {
        $("#divDirectToFinance").removeClass("required");
        $("[name='pr.direct_to_finance_justification']").data("validation", "");
        $("#divDirectToFinance").hide();
        $("[name='pr.direct_to_finance_justification']").val("");
        var obj = $("input[name='pr.direct_to_finance_file']");
        $(obj).val("");
        var obj2 = $("input[name='direct_to_finance_file']");
        $(obj2).val("");

    }

    function ShowReasonPurchase() {
        $("#divDirectToFinance").addClass("required");
        $("[name='pr.direct_to_finance_justification']").data("validation", "required");
        $("#divDirectToFinance").show();
    }

    $('#PRForm').on('shown.bs.modal', function () {
        if ($("#prfaction").val() === "add") {
            $("[name='prf.uid']").val(guid());
            $("#btnSearchItem").trigger("click");
        }

        var aTag = $("#btnSearchItem");
        $('#PRForm .modal-body').animate({ scrollTop: aTag.position().top }, 'slow');

    });

    $('#SearchForm').on('shown.bs.modal', function () {
        resetSearchForm();

        var aTag = $("#searchitemtop");
        $('#SearchForm .modal-body').animate({ scrollTop: aTag.position().top }, 'slow');
        $("#btnSearch").trigger("click");
    });

    function resetPRForm() {
        popupDeleteId = [];

        $("#PRForm").find("input:text").val('');
        $("#PRForm").find("input:hidden").val('');
        $("#PRForm").find("textarea").val('');
        $("#PRForm").find("select").val('').trigger("change");
        $("#tblAttachment tbody").html('');
        $("#tblCostCenters tbody").html('');
        $("#ChargeCodePercentage").html('0.00');
        $("#ChargeCodeAmount").html('0.00');
        $("#ChargeCodeAmountUSD").html('0.00');
        $("#prform-error-box").hide();

        $("#lp_po_product_description_header").text('Product description');
        $("#lp_price_header").text('Price');
        $("#lp_quantity_header").text('Quantity');
        $("#lp_date_header").text('Date');

        $("#lp_po_product_description").text('N/A');
        $("#lp_price").text('N/A');
        $("#lp_quantity").text('N/A');
        $("#lp_date").text('N/A');

        populateCurrency($("[name='pr.currency_id']").val());

        repopulateNumber();
    }

    function resetPRFormNewProduct(resetAll) {
        popupDeleteId = [];

        if (resetAll == true) {
            $("#PRForm").find("input:text").val('');
            $("#PRForm").find("textarea").val('');
            $("#PRForm").find("select").val('').trigger("change");
            $("#tblAttachment tbody").html('');
            $("#tblCostCenters tbody").html('');
            $("#prform-error-box").hide();

            populateCurrency($("[name='pr.currency_id']").val());

            repopulateNumber();
        } else {
            $("[name='prf.item_code']").val('');
            $("[name='prf.category_name']").val('');
            $("[name='prf.brand_name']").val('');
        }

        $("#lp_po_product_description_header").text('Product description');
        $("#lp_price_header").text('Price');
        $("#lp_quantity_header").text('Quantity');
        $("#lp_date_header").text('Date');

        $("#lp_po_product_description").text('N/A');
        $("#lp_price").text('N/A');
        $("#lp_quantity").text('N/A');
        $("#lp_date").text('N/A');
    }

    function resetSearchForm() {
        $("#search_general").val("");
        $("#search_brand").val("");
        $("#search_description").val("");

        $("#other_brand").val("");
        $("#other_description").val("");

        listSearchItems = [];
        SearchTable.clear().draw();
        SearchTable.rows.add(listSearchItems).draw();

        $("#searchResult").hide();
        $("#addOtherItem").hide();
        $("#btnSaveOtherItem").hide();
        $("#searchform-error-box").hide();
        $("#prform-error-box").hide();
    }

    $(document).on("click", "#btnSearch", function () {
        var search_general = $("#search_general").val();
        /* var search_brand = $("#search_brand").val();*/
        var search_description = $("#search_description").val();

        /*if (search_general === "" && search_brand === "" && search_description === "") {*/
        //if (search_general === "") {
        //    $("#searchform-error-message").html("<b>Please type in your search criteria.</b>");
        //    $("#searchform-error-box").show();
        //} else {
        $("#addOtherItem").hide();
        $("#btnSaveOtherItem").hide();

        var searchObj = new Object();
        searchObj.general = search_general;
        searchObj.brand = "";
        searchObj.description = "";

        $.ajax({
                <%--url: "<%=service_url %>" + '/SearchItem',--%>
                url: '<%= Page.ResolveUrl("~/"+based_url+ service_url + "/SearchItem") %>',
                data: JSON.stringify(searchObj),
                dataType: 'json',
                type: 'post',
                contentType: "application/json; charset=utf-8",
                success: function (response) {
                    var output = JSON.parse(response.d);
                    output = output.filter(p => String(p.id).startsWith('NS'));
                    output = output.filter(p => !String(p.category).startsWith('CAPEX'));
                    listSearchItems = output;
                    SearchTable.clear().draw();
                    SearchTable.rows.add(listSearchItems).draw();
                    $("#searchResult").show();
                    /*  $("#addOtherItem").show();*/
                    /*$("#btnSaveOtherItem").show();*/

                    var aTag = $("#searchResult");
                    $('#SearchForm .modal-body').animate({ scrollTop: aTag.position().top }, 'slow');
                }
            });
        /* }*/
    });

    $(document).on("click", ".ItemSelect", function () {
        var _id = $(this).data("id");
        let resetProduct = false;

        if ($("[name='prf.item_code']").val() != _id && $("[name='prf.item_code']").val()) {
            if (is_edit_product == true) {
                $("#prfaction").val("edit");

                if (confirm('Product has been changed. Do you want to reset the information that you inputted previously ?', 'Title', function () {
                })) {
                    $("#tblAttachment .btnDelete").trigger("click");
                    $("#tblCostCenters .btnDelete").trigger("click");
                    resetProduct = true;
                } else {

                }
                resetPRFormNewProduct(resetProduct);
            }
        }

        var arr = $.grep(listSearchItems, function (n, i) {
            return n["id"] === _id;
        });
        if (arr.length > 0) {
            fillItemDetail(arr[0].category, arr[0].category_name
                , arr[0].subcategory, arr[0].subcategory_name
                , arr[0].brand, arr[0].brand_name
                , arr[0].description, arr[0].CostAccount, arr[0].item_code, arr[0].id, arr[0].uom, arr[0].delivery_address, arr[0].is_other_address, arr[0].other_delivery_address
                , arr[0].last_price_currency, arr[0].last_price_amount
                , arr[0].last_price_quantity, arr[0].last_price_uom, arr[0].last_price_date, arr[0].last_po_product_description
            );
            $("#SearchForm").modal("hide");
        }
    });

    $(document).on("click", "#btnSaveOtherItem", function () {
        var brand = $.trim($("#other_brand").val());
        var description = $.trim($("#other_description").val());

        var errorMsg = "";
        if (brand === "") {
            errorMsg += "<br/>- Brand is required.";
        }
        if (description === "") {
            errorMsg += "<br/>- Description is required.";
        }

        if (errorMsg !== "") {
            errorMsg = "Please correct the following error(s):" + errorMsg;

            $("#searchform-error-message").html("<b>" + errorMsg + "<b>");
            $("#searchform-error-box").show();
            $('.modal-body').animate({ scrollTop: 0 }, 500);
        } else {
            fillItemDetail('0', '-', '0', '-', '0', brand, description, '', 'OTHER', '0', '', '', '0', '', $("[name='pr.currency_id']").val(), 0, '', '', '', '');
            $("#SearchForm").modal("hide");
        }
    });

    function fillItemDetail(category, category_name, subcategory, subcategory_name, brand, brand_name, description, cost_account, item_code, item_id, uom, delivery_address, is_other_address, other_delivery_address, last_curr, last_amount, last_quantity, last_uom, last_date, last_po_product_description) {
        $("[name='prf.category']").val(category);
        $("[name='prf.category_name']").val(category_name);
        $("[name='prf.subcategory']").val(subcategory);
        $("[name='prf.subcategory_name']").val(subcategory_name);
        $("[name='prf.brand']").val(brand);
        $("[name='prf.brand_name']").val(brand_name);
        $("[name='prf.description']").val(description);
        $("[name='prf.cost_account']").val(cost_account);
        $("[name='prf.item_code']").val(item_code);
        $("[name='prf.item_id']").val(item_id);
        $("[name='prf.uom']").val(uom).trigger("change");
        $("[name='prf.delivery_address']").val(delivery_address).trigger("change");
        $("[name='prf.other_delivery_address']").val(other_delivery_address);

        $("[name='prf.last_price_currency']").val(last_curr);
        $("[name='prf.last_price_amount']").val(last_amount);
        $("[name='prf.last_price_quantity']").val(last_quantity);
        $("[name='prf.last_price_uom']").val(last_uom);
        $("[name='prf.last_price_date']").val(last_date);

        if (last_amount != "" && delCommas(last_amount) != 0) {
            $("#lp_po_product_description").text(last_po_product_description);
            $("#lp_price").text(accounting.formatNumber(delCommas(last_amount), 2));
            $("#lp_quantity").text(accounting.formatNumber(delCommas(last_quantity), 2));
            $("#lp_date").text(last_date);

            $("#lp_po_product_description_header").text('Product description');
            $("#lp_price_header").text('Price (' + last_curr + ')');
            $("#lp_quantity_header").text('Quantity (' + last_uom + ')');
            $("#lp_date_header").text('Date');
        } else {
            $("#lp_po_product_description_header").text('Product description');
            $("#lp_price_header").text('Price');
            $("#lp_quantity_header").text('Quantity');
            $("#lp_date_header").text('Date');

            $("#lp_po_product_description").text('N/A');
            $("#lp_price").text('N/A');
            $("#lp_quantity").text('N/A');
            $("#lp_date").text('N/A');
        }

        if (page_name === "verification" || page_name == "finance_verification") {
            $("[name='prf.uom']").prop("disabled", true);
            $("[name='prf.delivery_address']").prop("disabled", true);
        }

        if (item_code === "OTHER") {
            $("[name='prf.brand_name']").prop("readonly", false);
            /* $("[name='prf.description']").prop("readonly", false);*/
            $("[name='prf.uom']").prop("disabled", false);
            $("[name='prf.delivery_address']").prop("disabled", false);
        } else {
            $("[name='prf.brand_name']").prop("readonly", true);
            /*  $("[name='prf.description']").prop("readonly", true);*/
        }

        if (is_other_address == '1') {
            $("[name='prf.is_other_address']").prop("checked", true);
            checkOtherAddress(true);
        } else {
            $("[name='prf.is_other_address']").prop("checked", false);
            checkOtherAddress(false);
        }

        repopulateNumber();
    }

    function calculatePricePerItem() {
        var qty = parseFloat(delCommas($("[name='prf.request_qty']").val()));
        var price = parseFloat(delCommas($("[name='prf.unit_price']").val()));
        var rate = parseFloat(delCommas($("[name='pr.exchange_rate']").val()));
        var sign = $("[name='pr.exchange_sign']").val();
        var price_usd = 0;
        var total_estimated_usd = 0;

        qty = qty == "" ? 0 : qty;
        price = price == "" ? 0 : price;
        rate = rate == "" ? 0 : rate;

        var total_estimated = parseFloat(qty * price);

        if (sign == "/") {
            price_usd = price / rate;
            total_estimated_usd = parseFloat(total_estimated) / rate;
        } else {
            price_usd = price * rate;
            total_estimated_usd = total_estimated * rate;
        }

        $("[name='prf.unit_price_usd']").val(accounting.formatNumber(price_usd, 2))
        $("[name='prf.estimated_cost']").val(total_estimated);
        $("[name='prf.estimated_cost_usd']").val(accounting.formatNumber(total_estimated_usd, 2))

        repopulateNumber();
    }

    $(document).on("change", "[name='prf.unit_price'],[name='prf.request_qty'],[name='pr.exchange_rate']", function () {
        calculatePricePerItem();
        CalcAmtAndUSDAmtChargeCode();
        CalculateChargeCodePercentage(-1);
        AdjustAmountUSDChargeCode();
    });

    var uploadValidationResult = {};
    $(document).on("click", "#btnSaveDetail", function () {
        var thisHandler = $(this);
        $("[name=filename]").uploadValidation(function (result) {
            uploadValidationResult = result;
            onBtnClickSaveDetail.call(thisHandler);
        });
    });

    var onBtnClickSaveDetail = function () {
        var _uid = $("[name='prf.uid']").val();
        var _d = new Object();
        _d.id = $("[name='prf.id']").val();
        _d.pr_id = $("[name='pr.id']").val();
        _d.uid = _uid;
        _d.category = $("[name='prf.category']").val();
        _d.category_name = $("[name='prf.category_name']").val();
        _d.subcategory = $("[name='prf.subcategory']").val();
        _d.subcategory_name = $("[name='prf.subcategory_name']").val();
        _d.brand = $("[name='prf.brand']").val();
        _d.brand_name = $("[name='prf.brand_name']").val();
        _d.description = $("[name='prf.description']").val();
        _d.item_code = $("[name='prf.item_code']").val();
        _d.item_id = $("[name='prf.item_id']").val();
        _d.request_qty = delCommas($("[name='prf.request_qty']").val());
        _d.uom = $("[name='prf.uom']").val();
        _d.purpose = $("[name='prf.purpose']").val();
        _d.delivery_address = $("[name='prf.delivery_address']").val();
        _d.is_other_address = $("[name='prf.is_other_address']").prop("checked");
        _d.other_delivery_address = $("[name='prf.other_delivery_address']").val();

        _d.item_description = "";
        if (_d.brand_name != "") {
            _d.item_description = _d.brand_name + "<br/>";
        }
        /*_d.item_description += '<span class="multilines">' + _d.description + '</span><br/>'*/
        _d.item_description += 'Product group: ' + _d.category_name + '<br/>';
        _d.item_description += 'Product description: ' + _d.description + '<br/>';
        /*_d.item_description += 'Sub category: ' + _d.subcategory_name + '<br/>';*/
        _d.item_description += '<span class="multilines">Purpose: ' + _d.purpose + '</span>';

        uom_name = $("[name='prf.uom']").select2('data');
        if (uom_name) {
            _d.uom_name = uom_name[0].text;
        }
        _d.last_price_currency = $("[name='prf.last_price_currency']").val();
        _d.last_price_amount = delCommas($("[name='prf.last_price_amount']").val());
        if (_d.last_price_amount == "") {
            _d.last_price_amount = 0;
        }
        _d.last_price_quantity = delCommas($("[name='prf.last_price_quantity']").val());
        if (_d.last_price_quantity == "") {
            _d.last_price_quantity = 0;
        }
        _d.last_price_uom = $("[name='prf.last_price_uom']").val();
        _d.last_price_date = $("[name='prf.last_price_date']").val();

        _d.unit_price = delCommas($("[name='prf.unit_price']").val());
        _d.unit_price_usd = delCommas($("[name='prf.unit_price_usd']").val());
        _d.estimated_cost = delCommas($("[name='prf.estimated_cost']").val());
        _d.estimated_cost_usd = delCommas($("[name='prf.estimated_cost_usd']").val());
        _d.currency_id = $("[name='pr.currency_id']").val();
        _d.exchange_sign = $("[name='pr.exchange_sign']").val();
        _d.exchange_rate = $("[name='pr.exchange_rate']").val();
        _d.attachments = [];
        /*_d.itemDetail = [];*/
        _d.costCenters = [];

        var errFile = 0;
        var errDesc = 0;
        var errUpload = 0;
        var msgFile = "";
        var errorMsg = "";
        errorMsg += uploadValidationResult.not_found_message || '';

        $("#tblAttachment tbody tr").each(function () {
            var _att = new Object();
            _att["id"] = $(this).find("input[name='attachment.id']").val();
            _att["att_id"] = $(this).find("input[name='attachment.att_id']").val();
            _att["uid"] = $(this).find("input[name='attachment.uid']").val();
            _att["filename"] = $(this).find("input[name='attachment.filename']").val();
            _att["file_description"] = $(this).find("input[name='attachment.file_description']").val();
            _att["new_file"] = $(this).data('new_file');

            _d.attachments.push(_att);
            if ($.trim(_att["filename"]) == "" && errFile == 0) {
                msgFile += "<br/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- File is required.";
                errFile++;
            }
            if ($.trim(_att["file_description"]) == "" && errDesc == 0) {
                msgFile += "<br/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- Description is required.";
                errDesc++;
            }
            if ($(this).find("input[name='attachment.uploaded']").val() == "0") {
                $(this).css({ 'background-color': 'rgb(245, 183, 177)' });
                if ($.trim(_att["filename"]) != "") {
                    errUpload++;
                }
            }
        });

        if (errUpload > 0) {
            msgFile += "<br/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- There are files that have not been uploaded, please upload first.";
        }

        if (_d.item_id == "0" || _d.item_id == "") {
            if (_d.brand == "") {
                errorMsg += "<br/>- Product name is required.";
            }
        }
        if (_d.uom == 0 || _d.uom == "") {
            errorMsg += "<br/>- Unit of measurement is required.";
        }
        if (_d.request_qty == 0 || _d.request_qty == "") {
            errorMsg += "<br/>- Quantity is required.";
        }

        if ($.trim(_d.description) == "") {
            errorMsg += "<br/>- Product description is required.";
        }

        if (_d.currency_id == "") {
            errorMsg += "<br/>- Currency is required.";
        }
        if (_d.exchange_rate == 0) {
            errorMsg += "<br/>- Exchange rate is required.";
        }
        if (_d.unit_price == 0 || _d.unit_price == "") {
            errorMsg += "<br/>- Unit price is required.";
        }
        if ($.trim(_d.purpose) == "") {
            errorMsg += "<br/>- Purpose are required.";
        }

        if (_d.is_other_address) {
            if ($.trim(_d.other_delivery_address) == "") {
                errorMsg += "<br/>- Other delivery address are required.";
            }
        } else {
            if ($.trim(_d.delivery_address) == "") {
                errorMsg += "<br/>- Delivery address are required.";
            }
        }


        //tblCostCenters chargeCode validasi
        var countErCC = 0;
        var countErWorkOrder = 0;
        var countErEntity = 0;
        var countErVal = 0;
        var countErDuplicate = 0;
        /*    var duplicate = 0;*/
        if ($('#tblCostCenters >tbody >tr').length <= 0) {
            errorMsg += "<br> - Charge code is required.";
        } else {
            $("#tblCostCenters tbody tr").css({ 'background-color': '' });
            $("#tblCostCenters tbody tr").each(function (index1) {
                var row = $(this);
                var row_val = row.find('.CostCenters').val() + row.find('.CostCentersWorkOrder').val() + row.find('.EntityCostC').val();

                if (($(this).find('.CostCenters').val() == "" || $(this).find('.CostCenters').val() == "0") && countErCC == 0) {
                    errorMsg += "<br> - Cost center is required.";
                    countErCC = 1;
                }

                if (($(this).find('.CostCentersWorkOrder').val() == "" || $(this).find('.CostCentersWorkOrder').val() == "0" || $(this).find('.CostCentersWorkOrder').val() == null) && countErWorkOrder == 0) {
                    errorMsg += "<br> - Work order T4 is required.";
                    countErWorkOrder = 1;
                }

                if (($(this).find('.EntityCostC').val() == "" || $(this).find('.EntityCostC').val() == "0" || $(this).find('.EntityCostC').val() == null) && countErEntity == 0) {
                    errorMsg += "<br> - Entity is required.";
                    countErEntity = 1;
                }

                if (($(this).find('.CostCentersValue').val() == "" || $(this).find('.CostCentersValue').val() == "0" || $(this).find('.CostCentersValue').val() == null) && countErVal == 0) {
                    errorMsg += "<br> - Charge Code value is required.";
                    countErVal = 1;
                }

                $("#tblCostCenters tbody tr").each(function (index2) {
                    var compare_row = $(this);
                    var compare_row_val = compare_row.find('.CostCenters').val() + compare_row.find('.CostCentersWorkOrder').val() + compare_row.find('.EntityCostC').val();


                    if (index1 != index2 && row_val == compare_row_val) {
                        if (countErDuplicate == 0) {
                            errorMsg += "<br> - Cannot add the same combination (work order, cost center, and entity).";
                        }
                        compare_row.css({ 'background-color': 'rgb(245, 183, 177)' });
                        countErDuplicate++;
                    }
                });

                if (errorMsg == "") {
                    $(this).find('.AccControl').text($("[name='prf.cost_account']").val());
                    var _itemDetailTemp = new Object();
                    _itemDetailTemp["id"] = $(this).find('.ChargeCodeID').text();
                    _itemDetailTemp["cost_center_id"] = $(this).find('.CostCenters').val();
                    _itemDetailTemp["cost_center_name"] = $(this).find('.CostCenters :selected').text();
                    _itemDetailTemp["work_order"] = $(this).find('.CostCentersWorkOrder').val();
                    _itemDetailTemp["work_order_name"] = $(this).find('.CostCentersWorkOrder :selected').text();
                    _itemDetailTemp["entity_id"] = $(this).find('.EntityCostC').val();
                    _itemDetailTemp["entity_name"] = $(this).find('.EntityCostC :selected').text();
                    _itemDetailTemp["legal_entity"] = $(this).find('.LegalEntityC').text();
                    _itemDetailTemp["percentage"] = $(this).find('.CostCentersValue').val();
                    _itemDetailTemp["amount"] = delCommas($(this).find('.CostCentersAmt').val());
                    _itemDetailTemp["amount_usd"] = delCommas($(this).find('.CostCentersUSDAmt').val());
                    _itemDetailTemp["control_account"] = $(this).find('.AccControl').text();
                    _itemDetailTemp["remarks"] = $(this).find('.CostCentersRemark').val();
                    _d.costCenters.push(_itemDetailTemp);
                }


            });
            var errTotal = 0;

            var total = 0;
            var totalAmt = 0;
            var totalAmtUSD = 0;
            $("#tblCostCenters tbody tr").each(function () {
                if (errTotal == 0) {
                    if (parseFloat($(this).val()) == 0 || parseFloat($(this).val()) <= 0) {
                        errTotal = 1;
                        errorMsg += "<br> - Charge Code value must be greater than 0";
                    }
                }
                total += parseFloat($(this).find('.CostCentersValue').val());
                totalAmt += parseFloat(delCommas($(this).find('.CostCentersAmt').val()));
                totalAmtUSD += parseFloat(delCommas($(this).find('.CostCentersUSDAmt').val()));
            })

            if (delCommas($("#ChargeCodeAmount").html()) != delCommas($("[name='prf.estimated_cost']").val()) || delCommas($("#ChargeCodeAmountUSD").html()) != delCommas($("[name='prf.estimated_cost_usd']").val())) { errorMsg += "<br> - Total amount charge code must be equal to total price amount" }
        }
        if (msgFile !== "") {
            msgFile = "<br> - Supporting document(s):" + msgFile;
        }
        errorMsg += msgFile;
        errorMsg += FileValidation();

        if (errorMsg !== "") {
            errorMsg = "Please correct the following error(s):" + errorMsg;

            $("#prform-error-message").html("<b>" + errorMsg + "<b>");
            $("#prform-error-box").show();
            $('.modal-body').animate({ scrollTop: 0 }, 500);
        } else {
            var mode = $("#prfaction").val();
            if (mode == "add") {
                PRDetail.push(_d);
            } else if ($("#prfaction").val() == "edit") {
                var idx = PRDetail.findIndex(x => x.uid == _uid);
                PRDetail[idx] = _d;
            }

            let PRDetailTemp = [];
            PRDetailTemp.push(_d);
            populateItemTable(PRDetailTemp, mode);
            CalculateItems();

            MoveFile();
            $("#PRForm").modal("hide");

            is_edit_product = false;
        }
    };

    function MoveFile() {
        $('#tblAttachment').find('[name="filename"]').each(function () {
            $(this).prop('class', 'suppdoc_hidden');
            $(this).prop('name', 'suppdoc_filename');
            $(this).prop('id', '');
            $(this).detach().appendTo('#inputhide');
        });
    }

    function populateItemTable(PRDetail, mode) {
        let html = "";
        let htmlDetail = '';
        $.each(PRDetail, function (i, item) {
            if (item.uid == "" || typeof item.uid === "undefined" || item.uid == null) {
                item.uid = guid();
            }
            var desc = item.item_description;

            var strAttachment = "";
            $.each(item.attachments, function (idx, d) {
                if (idx > 0) {
                    strAttachment += '<br />';
                }
                var is_cloned = $(".clone_" + d.uid).length;
                if (item.id !== "" && item.id !== "0" && is_cloned == 0 && d.id !== "" && d.id !== "0" && !d.new_file) {
                    strAttachment += '<a href="Files/' + item.pr_id + '/' + d.filename + '" target="_blank">' + d.filename + '</a>';
                } else {
                    //strAttachment += d.filename;
                    let idtemp = '';
                    let _pr_id = $("[name='pr.id']").val();
                    if (_pr_id == "" || typeof _pr_id === "undefined" || _pr_id == null) {
                        strAttachment += '<a href="FilesTemp/' + $("[name='docidtemp']").val() + '/' + d.filename + '" target="_blank">' + d.filename + '</a>';
                        //idtemp = "FilesTemp/" + $("[name='docidtemp']").val();
                    } else {
                        strAttachment += '<a href="Files/' + item.pr_id + '/' + d.filename + '" target="_blank">' + d.filename + '</a>';
                    }

                }
            });

            var strChargeCode = "";
            var idx = PRDetail.findIndex(x => x.uid == item.uid);
            var a = PRDetail[idx];
            $.each(a.costCenters, function (i, d) {
                strChargeCode += '<tr>';
                strChargeCode += '<td style=" width: 10%;" class="pCostCenters">' + d.cost_center_name + '</td>';
                strChargeCode += '<td style="width: 20%;" class="pCostCentersWorkOrder">' + d.work_order + ' - ' + d.work_order_name + '</td>';
                strChargeCode += '<td style="width: 10%;" class="pCostCentersEntity">' + d.entity_name + '</td>';
                strChargeCode += '<td style="width: 5%;">' + d.legal_entity + '</td>';
                strChargeCode += '<td style="display: none; width: 5%;">' + item.uid + '</td>';
                strChargeCode += '<td style=" width: 5%; text-align:right;" class="pCostCentersValue">' + d.percentage + '</td>';
                strChargeCode += '<td style="width: 11%; text-align:right;" class="pCostCentersAmt">' + accounting.formatNumber(parseFloat(d.amount), 2) + '</td>';
                strChargeCode += '<td style="width: 11%; text-align:right;" class="pCostCentersUSDAmt">' + accounting.formatNumber(parseFloat(d.amount_usd), 2) + '</td>';
                strChargeCode += '<td style="width: 20%;">' + d.remarks + '</td>';
                strChargeCode += '</tr>';
            });

            
            html += '<tr id="' + item.uid + '">';
            /*   html += '<tr id="' + item.uid + '"class="accordion-toggle collapsed" data-target="#dv' + item.uid + '" data-toggle="collapse">';*/
            html += '<td> <i class="icon-chevron-sign-down dropDetail accordion-toggle collapsed" data-target="#dv' + item.uid + '" data-toggle="collapse" title="View detail(s)"></i></td > <td>' + item.item_code + '</td>';
            html += '<td>' + desc + '</td>';
            html += '<td style="text-align:right;">' + accounting.formatNumber(parseFloat(item.request_qty), 2) + '</td>';
            html += '<td>' + item.uom_name + '</td>';
            html += '<td>' + a.currency_id + '</td>';
            /*html += '<td style="text-align:right;">' + accounting.formatNumber(item.unit_price, 2) + '</td>';*/
            html += '<td style="text-align:right;">' + accounting.formatNumber(parseFloat(item.unit_price), 2) + '</td>';
            /*html += '<td style="text-align:right;">' + accounting.formatNumber(item.estimated_cost, 2) + '</td>';*/
            html += '<td style="text-align:right;">' + accounting.formatNumber(parseFloat(item.estimated_cost), 2) + '</td>';
            html += '<td style="text-align:right;">' + accounting.formatNumber(parseFloat(item.estimated_cost_usd), 2) + '</td>';
            /*    html += '<td style="text-align:right;">' + accounting.formatNumber(parseFloat(item.estimated_cost_usd), 2) + '</td>';*/
            html += '<td>' + strAttachment + '</td>';
            html += '<td><input type="hidden" name="item.id" value="' + item.id + '"/>';

            if (page_name == "input") {
                html += '<span class="label green btnEdit" title="Edit"><i class="icon-pencil edit" style="opacity: 0.7;"></i></span>';
                html += '<span class="label red btnDelete" title="Delete"><i class="icon-trash delete" style="opacity: 1;"></i></span>';
            } else if (page_name == "verification") {
                html += '<span class="label btn-primary btnEdit" title="Detail"><i class="icon-info edit" style="opacity: 0.7;"></i></span>';
            }
            html += '</td ></tr >';

            
            //if (mode == "add") {
            //    $("#tblItems tbody").append(html + htmlDetail);
            //} else if (mode == "edit") {
            //    $("#" + item.uid).replaceWith(html);
            //    $("#trr" + item.uid).replaceWith(htmlDetail);
            //}
            if (mode == "add") {
                html += '<tr id="trr' + item.uid + '">';
                html += '<td class="hiddenRow" colspan="11" style="padding:0px;">';
                html += '<div id="dv' + item.uid + '" class="accordian-body in collapse" style="height: auto;">';
                html += '<div id="dv' + item.uid + '_ChargeCode" style="margin-left:28px; margin-right:5px; margin-top:25px; margin-bottom:10px;">';
                html += '<div id="dv' + item.uid + '_CostParent">';
                html += '<table id="tbl' + item.uid + '_CostParent" class="table table-bordered table-striped tblCostCenterParent">';
                html += '<thead>';
                html += '<tr>';
                html += '<th style=" width: 15%; text-align:left;">Cost center</th>';
                html += '<th style=" width: 18%; text-align:left;">Work order</th>';
                html += '<th style=" width: 10%; text-align:left;">Entity</th>';
                html += '<th style=" width: 10%; text-align:left;">Legal entity</th>';
                html += '<th style="display: none;">Account Control</th>';
                html += '<th style=" width: 5%; text-align:left;">%</th>';
                html += '<th style=" width: 11%; text-align:left;">Amount (' + item.currency_id + ')</th>';
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
            }else if (mode == "edit") {
                $("#" + item.uid).replaceWith(html);

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
                htmlDetail += '<th style=" width: 11%; text-align:left;">Amount (' + item.currency_id + ')</th>';
                htmlDetail += '<th style=" width: 11%; text-align:left;">Amount (USD)</th>';
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
                $("#trr" + item.uid).replaceWith(htmlDetail);
            }
            
        });
        if (mode == "add") {
            $("#tblItems tbody").append(html);
        }
        //$('#tbl' + item.uid + '_CostParent >tbody').append(strChargeCode);
        //normalizeMultilines();
        
    }

    $(document).on("click", "#btnAddAttachment", function () {
        var DocType = $(this).data("doctype");
        addAttachment("", "", "", "", DocType);

    });

    function addAttachment(id, uid, description, filename, doctype, new_file) {
        var _pr_id = $("[name='pr.id']").val();
        var _purchase_type = $("[name='pr.purchase_type']").val();
        if (uid == "" || typeof uid === "undefined" || uid == null) {
            var uid = guid();
        }

        var filedoctype = doctype == "PURCHASE REQUISITION GENERAL" ? "_general" : "";

        var html = '<tr>';

        if (page_name == "verification" || page_name == "finance_verification") {
            html += '<td>' + description + '</td>';
            html += '<td><a href="Files/' + _pr_id + '/' + filename + '" target="_blank">' + filename + '</a></td >';
            html += '</tr>';
        } else {
            html += '<td><input type="hidden" name="attachment.uid" value="' + uid + '"/><input type="text" class="span12" name="attachment.file_description" maxlength="1000" placeholder="Description" value="' + description + '"/></td>';
            html += '<td><input type="hidden" name="attachment.filename' + filedoctype + '" value="' + filename + '"/><div class="fileinput_' + uid + '">';
            if (id !== "" && filename !== "" && !new_file) {
                html += '<span class="linkDocument"><a href="Files/' + _pr_id + '/' + filename + '" target="_blank" id="linkDocumentHref">' + filename + '</a>&nbsp;</span>';
                html += '<input type="hidden" name="attachment.att_id" value="' + (id || '') + '"/>';
                if (page_name == "input") {
                    html += '<button type="button" class="btn btn-primary editDocument" data-type="' + filedoctype + '">Edit</button><input type="file" class="span10" name="filename' + filedoctype + '" style="display: none;"/>';
                    html += '<button type="button" class="btn btn-success btnFileUpload" data-type="' + filedoctype + '" style="display:none;">Upload</button>';
                }
            } else if (filename !== "") {
                var idtemp = '';
                if (_pr_id == "" || typeof _pr_id === "undefined" || _pr_id == null) {
                    idtemp = "FilesTemp/" + $("[name='docidtemp']").val();
                } else {
                    idtemp = "Files/" + _pr_id;
                }

                /*html += '<input type="button" class="custom-file-button" value="Choose File"/><label id="labelfile" name="labelfile" class="custom-file-label" for="button">' + filename + '</label>';*/
                /*html += '<span class="linkDocument"><a class href="Files/' + idtemp + '/' + filename + '" id="linkDocumentHref" target="_blank">' + filename + '</a>&nbsp;</span>';*/
                html += '<span class="linkDocument"><a class href="' + idtemp + '/' + filename + '" id="linkDocumentHref" target="_blank">' + filename + '</a>&nbsp;</span>';
                html += '<button type="button" class="btn btn-primary editDocument" data-type="' + filedoctype + '">Edit</button><input type="file" class="span10" name="filename' + filedoctype + '" style="display: none;"/>';
                html += '<button type="button" class="btn btn-success btnFileUpload" data-type="' + filedoctype + '" style="display:none;">Upload</button>';
                /*                html += '<input type="file" class="custom-file" name="filename' + filedoctype + '" style="display:none;"/>';*/
            }
            else {
                html += '<span class="linkDocument" style="display:none;"><a class href="" id="linkDocumentHref" target="_blank"></a>&nbsp;</span>';
                html += '<button type="button" class="btn btn-primary editDocument" data-type="' + filedoctype + '" style="display:none;">Edit</button>';
                html += '<input type="file" class="span10" name="filename' + filedoctype + '" id="filename' + filedoctype + '"/>';
                html += '<button type="button" class="btn btn-success btnFileUpload" data-type="' + filedoctype + '">Upload</button>';
            }
            html += '</div></td > ';
            if (page_name == "input") {
                /*html += '<td><input type="hidden" name="attachment.id" value="' + id + '"/><span class="label green btnFileUpload"><i class="icon-upload upload" style="opacity: 1;"></i></span> <span class="label red btnDelete"><i class="icon-trash delete" style="opacity: 1;"></i></span></td>';*/
                html += '<td><input type="hidden" name="attachment.id" value="' + id + '"/><span class="label red btnDelete" title="Delete"><i class="icon-trash delete" style="opacity: 1;"></i></span></td>';
                if (doctype == "PURCHASE REQUISITION") {
                    if (filename !== "") {
                        html += '<td style="display:none;"><input type="hidden" name="attachment.uploaded" value="1"/></td>';
                    } else {
                        html += '<td style="display:none;"><input type="hidden" name="attachment.uploaded" value="0"/></td>';
                    }
                } else {
                    if (filename !== "") {
                        html += '<td style="display:none;"><input type="hidden" name="attachment.uploaded" value="1"/></td>';
                    } else {
                        html += '<td style="display:none;"><input type="hidden" name="attachment.uploaded" value="0"/></td>';
                    }
                }

                /*html += '<td><input type="hidden" name="attachment.id" value="' + id + '"/><span class="label red btnDelete"><i class="icon-trash delete" style="opacity: 1;"></i></span></td>';*/
            } else {
                html += '<td style="display:none;"><input type="hidden" name="attachment.id" value="' + id + '"/></td>';
            }
            html += '</tr>';
        }
        if (doctype == "PURCHASE REQUISITION GENERAL") {
            $("#tblAttachmentGeneral tbody").append(html);
        }
        else {
            $("#tblAttachment tbody").append(html);
        }
    }

    function addCostCenter(row, ID, ccID, ccWorkOrder, ccEntity, ccLegalEntity, ccVal, ccAmt, ccUSDAmt, ccAccControl, ccRemark) {
        $("#tblCostCenters tbody").append(
            GetHtmlCostCenters(row, ID)
        )
        /*for (i = 0; i < listCostCenter.length; i++) { addOption('txt' + row + '_CostCenters', listCostCenter[i]["CODES"], listCostCenter[i]["DESCRIPTION"]); }*/
        /*$('.cboCostCenter').chosen({ placeholder_text_single: "Select cost center...", search_contains: true, width: "98%" });*/
        generateCombo($('#cbo' + row + '_CostCenters'), listCostCenter, "CODES", "DESCRIPTION", true);
        $('#lb' + row + '_ChargeCodeID').text(ID);
        $('#cbo' + row + '_CostCenters').val(ccID).trigger("change");
        $('#cbo' + row + '_WorkOrder').val(ccWorkOrder);
        $('#cbo' + row + '_EntityCostC').val(ccEntity);
        $('#lb' + row + '_LegalEntity').text(ccLegalEntity);
        $('#txt' + row + '_CostCentersValue').val(parseFloat(ccVal));
        $('#txt' + row + '_CostCentersAmt').val(parseFloat(ccAmt));
        $('#txt' + row + '_CostCentersUSDAmt').val(accounting.formatNumber(parseFloat(ccUSDAmt), 2));
        $('#lb' + row + '_AccControl').text(ccAccControl);
        $('#txt' + row + '_CostCentersRemarks').val(ccRemark);
        Select2Obj($('#cbo' + row + '_CostCenters'), "Cost center");
        Select2Obj($('#cbo' + row + '_WorkOrder'), "Work order / T4");
        Select2Obj($('#cbo' + row + '_EntityCostC'), "Entity");
    }

    function supportingDocNotes(purchaseType) {
        var grandtotalusd = delCommas($("#GrandTotalUSD").text());
        if (grandtotalusd <= 200) {
            //if (!$('#purchase_type_option').find("option[value='6']").length) {
            //    // Create a DOM Option and pre-select by default
            //    /*var newOption = new Option("Direct payment to supplier", 6, true, true);*/
            //    // Append it to the select
            //    /*$('.select_purchase option[value="5"]').after(newOption);*/
            //    $('#purchase_type_option').val(purchaseType).trigger("change");
            //}
        } else {
            //if ($('.toSelect2').select2('val') == '6')
            //    $('.toSelect2').select2('val', '');
            //$('.select_purchase option[value="6"]').detach();
        }

        var className = $("#supporting_doc_notes").attr('class')
        if ($.trim(className) !== "" && typeof className !== "undefined" && className !== null) {
            $("." + className + "").html("");
            $("#supporting_doc_notes").removeClass(className);
        }
        var className2 = $("#supporting_doc_notes2").attr('class')
        if ($.trim(className2) !== "" && typeof className2 !== "undefined" && className2 !== null) {
            $("." + className2 + "").html("");
            $("#supporting_doc_notes2").removeClass(className2);
        }

        var className3 = $("#cash_advance_notes").attr('class')
        if ($.trim(className3) !== "" && typeof className3 !== "undefined" && className3 !== null) {
            $("." + className3 + "").html("");
            $("#cash_advance_notes").removeClass(className3);
        }

        let isFileGeneralMandatory = true;

        if (grandtotalusd <= 200) {
            if (purchaseType == "5" || purchaseType == "3") {//5 3
                isFileGeneralMandatory = false;
            }
        } else if (grandtotalusd > 200) {
            if (purchaseType == "3") {
                isFileGeneralMandatory = false;
            }
        }

        if ((purchaseType == "3" || purchaseType == "5") && grandtotalusd <= 200) {
            $("#ControlAttachmentGeneral").removeClass("required");
            $("#tblAttachmentGeneral").removeClass("required");
        } else if (grandtotalusd > 200 && purchaseType == "3") {
            $("#ControlAttachmentGeneral").removeClass("required");
            $("#tblAttachmentGeneral").removeClass("required");
        } else if (isFileGeneralMandatory == true){
            $("#ControlAttachmentGeneral").addClass("required");
            $("#tblAttachmentGeneral").addClass("required");         
        }

        //if (grandtotalusd < 200) {
        //    /*HideReasonPurchase();*/
        //    $("#divDirectToFinance").removeClass("required");
        //    $("[name='pr.direct_to_finance_justification']").data("validation", "");
        //}

        switch (purchaseType) {
            case "0":
                $("#supporting_doc_notes").addClass("invoice_notes");
                /*             $("#supporting_doc_notes2").addClass("invoice_notes");*/
                $(".invoice_notes").html(GetNotes("invoice_notes", ""));
                break;
        }

        /*
        if (grandtotalusd <= 200) {
            switch (purchaseType) {
                case "1":
                    $("#supporting_doc_notes").addClass("payment_less_200_notes");
                    $(".payment_less_200_notes").html(GetNotes("payment_less_200_notes", ""));
                    break;
                case "2":
                    $("#supporting_doc_notes").addClass("subs_less_200_notes");
                    $(".subs_less_200_notes").html(GetNotes("subs_less_200_notes", ""));
                    break;
                case "4":
                    $("#supporting_doc_notes2").addClass("reimburse_less_200_notes");
                    $(".reimburse_less_200_notes").html(GetNotes("reimburse_less_200_notes",""));
                    break;                
                case "5":
                    $("#cash_advance_notes").addClass("cash_advance_notes");
                    $(".cash_advance_notes").html(GetNotes("cash_advance_notes", ""));
                    break;
                case "6":
                    $("#supporting_doc_notes").addClass("direct_business_partner_notes");
                    $(".direct_business_partner_notes").html(GetNotes("direct_business_partner_notes", ""));
                    break;
            }
        }else if (grandtotalusd > 200 && grandtotalusd <= 1000) {
            switch (purchaseType) {
                case "1":
                    $("#supporting_doc_notes").addClass("payment_200_notes");
                    $(".payment_200_notes").html(GetNotes("payment_200_notes", _justification_file_link_200));
                    break;
                case "2":
                    $("#supporting_doc_notes").addClass("subs_200_notes");
                    $(".subs_200_notes").html(GetNotes("subs_200_notes", _justification_file_link_200));
                    break;
                case "4":
                    $("#supporting_doc_notes2").addClass("reimburse_200_notes");
                    $(".reimburse_200_notes").html(GetNotes("reimburse_200_notes",_justification_file_link_200));
                    break;                
                case "5":
                    $("#supporting_doc_notes2").addClass("cash_advance_200_notes");
                    $(".cash_advance_200_notes").html(GetNotes("cash_advance_200_notes", _justification_file_link_200));
                    $("#cash_advance_notes").addClass("cash_advance_notes");
                    $(".cash_advance_notes").html(GetNotes("cash_advance_notes", ""));
                    break;
            }
        }else if (grandtotalusd > 1000 && grandtotalusd <= 25000) {
            switch (purchaseType) {
                case "1":
                    $("#supporting_doc_notes").addClass("payment_1000_notes");
                    $(".payment_1000_notes").html(GetNotes("payment_1000_notes", _justification_file_link_1000));
                    break;
                case "2":
                    $("#supporting_doc_notes").addClass("subs_1000_notes");
                    $(".subs_1000_notes").html(GetNotes("subs_1000_notes", _justification_file_link_1000));
                    break;

                case "4":
                    $("#supporting_doc_notes2").addClass("reimburse_1000_notes");
                    $(".reimburse_1000_notes").html(GetNotes("reimburse_1000_notes",_justification_file_link_1000));
                    break;
                case "5":
                    $("#supporting_doc_notes2").addClass("cash_advance_1000_notes");
                    $(".cash_advance_1000_notes").html(GetNotes("cash_advance_1000_notes", _justification_file_link_1000));
                    $("#cash_advance_notes").addClass("cash_advance_notes");
                    $(".cash_advance_notes").html(GetNotes("cash_advance_notes", ""));
                    break;
            }
        }else if (grandtotalusd > 25000){
            switch (purchaseType) {
                case "1":
                    $("#supporting_doc_notes").addClass("payment_25000_notes");
                    $(".payment_25000_notes").html(GetNotes("payment_25000_notes", _justification_file_link_25000));
                    break;
                case "2":
                    $("#supporting_doc_notes").addClass("subs_25000_notes");
                    $(".subs_25000_notes").html(GetNotes("subs_25000_notes", _justification_file_link_25000));
                    break;
                case "4":
                    $("#supporting_doc_notes2").addClass("reimburse_25000_notes");
                    $(".reimburse_25000_notes").html(GetNotes("reimburse_25000_notes",_justification_file_link_25000));
                    break;
                case "5":
                    $("#supporting_doc_notes2").addClass("cash_advance_2500_notes");
                    $(".cash_advance_2500_notes").html(GetNotes("cash_advance_2500_notes", _justification_file_link_25000));
                    $("#cash_advance_notes").addClass("cash_advance_notes");
                    $(".cash_advance_notes").html(GetNotes("cash_advance_notes", ""));
                    break;
            }           
        } */

        /* edit by : Cahyadi 9/9/2020, only for <= 25000 and > 25000 */
        if (grandtotalusd <= 25000) {
            switch (purchaseType) {
                case "1":
                    $("#supporting_doc_notes").addClass("payment_below_25000_notes");
                    /*          $("#supporting_doc_notes2").addClass("payment_below_25000_notes");*/
                    $(".payment_below_25000_notes").html(GetNotes("payment_below_25000_notes", _justification_file_link_below_25000));
                    break;
                case "2":
                    $("#supporting_doc_notes").addClass("subs_below_25000_notes");
                    /*               $("#supporting_doc_notes2").addClass("subs_below_25000_notes");*/
                    $(".subs_below_25000_notes").html(GetNotes("subs_below_25000_notes", _justification_file_link_below_25000));
                    break;
                case "4":
                    $("#supporting_doc_notes2").addClass("reimburse_below_25000_notes");
                    $(".reimburse_below_25000_notes").html(GetNotes("reimburse_below_25000_notes", _justification_file_link_below_25000));
                    break;
                case "5":
                    $("#supporting_doc_notes2").addClass("cash_advance_below_25000_notes");
                    $(".cash_advance_below_25000_notes").html(GetNotes("cash_advance_below_25000_notes", _justification_file_link_below_25000));
                    $("#cash_advance_notes").addClass("cash_advance_notes");
                    $(".cash_advance_notes").html(GetNotes("cash_advance_notes", ""));
                    break;
                case "6":
                    $("#supporting_doc_notes").addClass("direct_payment_below_25000_notes");
                    /*           $("#supporting_doc_notes2").addClass("direct_payment_below_25000_notes");*/
                    $(".direct_payment_below_25000_notes").html(GetNotes("direct_payment_below_25000_notes", _justification_file_link_below_25000));
                    break;
            }
        } else if (grandtotalusd > 25000) {
            switch (purchaseType) {
                case "1":
                    $("#supporting_doc_notes").addClass("payment_above_25000_notes");
                    /*    $("#supporting_doc_notes2").addClass("payment_above_25000_notes");*/
                    $(".payment_above_25000_notes").html(GetNotes("payment_above_25000_notes", _justification_file_link_above_25000));
                    break;
                case "2":
                    $("#supporting_doc_notes").addClass("subs_above_25000_notes");
                    /* $("#supporting_doc_notes2").addClass("subs_above_25000_notes");*/
                    $(".subs_above_25000_notes").html(GetNotes("subs_above_25000_notes", _justification_file_link_above_25000));
                    break;
                case "4":
                    $("#supporting_doc_notes2").addClass("reimburse_above_25000_notes");
                    $(".reimburse_above_25000_notes").html(GetNotes("reimburse_above_25000_notes", _justification_file_link_above_25000));
                    break;
                case "5":
                    $("#supporting_doc_notes2").addClass("cash_advance_above_25000_notes");
                    $(".cash_advance_above_25000_notes").html(GetNotes("cash_advance_above_25000_notes", _justification_file_link_above_25000));
                    $("#cash_advance_notes").addClass("cash_advance_notes");
                    $(".cash_advance_notes").html(GetNotes("cash_advance_notes", ""));
                    break;
            }
        }
    }

    $(document).on("click", "#btnAdd", function () {
        resetPRForm();
        $("#prfaction").val("add");

    });

    $(document).on("click", ".btnEdit", function () {
        resetPRForm();
        var uid = $(this).closest("tr").prop("id");
        var idx = PRDetail.findIndex(x => x.uid == uid);
        var a = PRDetail[idx];

        $("#prfaction").val("edit");
        $("[name='prf.uid']").val(uid);
        $("[name='prf.id']").val(a.id);
        $("[name='prf.request_qty']").val(parseFloat(a.request_qty));
        $("[name='prf.unit_price']").val(parseFloat(a.unit_price));
        $("[name='prf.unit_price_usd']").val(parseFloat(a.unit_price_usd));
        $("[name='prf.estimated_cost']").val(parseFloat(a.estimated_cost));
        $("[name='prf.estimated_cost_usd']").val(a.estimated_cost_usd);
        $("[name='prf.purpose']").val(a.purpose);
        $("select[name='pr.currency_id']").val(a.currency_id).change();
        $("[name='pr.exchange_rate']").val(accounting.formatNumber(parseFloat(a.exchange_rate.replace(/,/g, '.')), 8));
        populateCurrency(a.currency_id);

        fillItemDetail(a.category, a.category_name, a.subcategory, a.subcategory_name, a.brand, a.brand_name, a.description, a.costCenters[0].control_account, a.item_code, a.item_id, a.uom, a.delivery_address, a.is_other_address, a.other_delivery_address, a.last_price_currency, a.last_price_amount, a.last_price_quantity, a.last_price_uom, a.last_price_date);
        $.each(a.attachments, function (i, d) {
            addAttachment(d.id, d.uid, d.file_description, d.filename, d.document_type);
        });

        $.each(a.costCenters, function (i, d) {
            addCostCenter(i, d.id, d.cost_center_id, d.work_order, d.entity_id, d.legal_entity, d.percentage, d.amount, d.amount_usd, d.control_account, d.remarks);
        });

        repopulateNumber();
        if (page_name == "verification" || page_name == "finance_verification") {
            $("[name^='prf.'][name!='prf.brand_name']").prop("disabled", true);
            $("#tblCostCenters").find("input,button,textarea,select").attr("disabled", "disabled");
            $("#tblAttachment").find("input,button,textarea,select").attr("disabled", "disabled");
            $("#btnSaveDetail,#btnAddChargeCode").hide();
            $("#searchProduct").hide();
            $("#PRForm").find(".required").removeClass("required");
            $("#tblCostCenters").find(".required").removeClass("required");
            $("#tblCostCenters").find(".asteriskChargeCode").hide();
            $("#lbItemAmt").find(".asteriskChargeCode").hide();
        }
        $("#PRForm").modal('show');

        CalculateChargeCodePercentage(-1);

        is_edit_product = true;
    });

    $(document).on("click", ".btnFileUpload,.btnFileUploadJustification", function () {
        $("#action").val("fileupload");

        btnFileUpload = this;

        if ($(this).data("type") == "file_justification") {
            $("#file_name").val($(this).closest("div").find("input:file").val().split('\\').pop());
        } else {
            $("#file_name").val($(this).closest("tr").find("input:file").val().split('\\').pop());
        }

        filenameupload = $("#file_name").val();

        if (!$("#file_name").val()) {
            alert("Please choose file first");
            return false;
        } else {
            let errorMsg = FileValidation();
            if (FileValidation() !== '') {
                if ($(this).data("type") == '') {
                    $("#prform-error-message").html("<b>" + "- Supporting document(s):" + "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" + errorMsg + "<b>");
                    $("#prform-error-box").show();
                    $('.modal-body').animate({ scrollTop: 0 }, 500);
                } else {
                    showErrorMessage(errorMsg);
                }

                return false;
            }
            UploadFileAPI("");
            //direct_to_finance_file
            if ($(this).data("type") == "file_justification") {
                $(this).closest("div").find("input[name$='justification.uploaded']").val("1");
                $(this).closest("div").find("input[name$='direct_to_finance_file']").css({ 'background-color': '' });
            } else {
                $(this).closest("tr").find("input[name$='attachment.uploaded']").val("1");
                $(this).closest("tr").css({ 'background-color': '' });
            }

        }
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
            popupDeleteId.push(_del);

        }

        if (mname == "attachment") {
            var uid = $(this).closest("tr").find("input[name$='.uid']").val();
            $(".clone_" + uid).remove();
        } else if (mname == "item") {
            var item_uid = $(this).closest("tr").prop("id");
            var idx = PRDetail.findIndex(x => x.uid == item_uid);
            $.each(PRDetail[idx].attachments, function (i, d) {
                var att_uid = d.uid
                $(".clone_" + att_uid).remove();
            });
            if (idx != -1) {
                PRDetail.splice(idx, 1);
            }
        }

        $('table#tblItems tr#trr' + $(this).closest("tr").attr('id') + '').remove();
        $(this).closest("tr").remove();
        CalculateItems();

        CalculateChargeCodePercentage(-1);
    });

    $(document).on("change", "input[name='filename']", function (e) {
        $(this).closest("tr").find("input[name$='attachment.uploaded']").val("0");
        var obj = $(this).closest("tr").find("input[name='attachment.filename']");
        $(obj).val("");
        var obj2 = $(this).closest("tr").find("label[for='button']");
        $(obj2).text("");
        var filename = "";
        var fullPath = $(this).val();
        if (fullPath) {
            var startIndex = (fullPath.indexOf('\\') >= 0 ? fullPath.lastIndexOf('\\') : fullPath.lastIndexOf('/'));
            filename = fullPath.substring(startIndex);
            if (filename.indexOf('\\') == 0 || filename.indexOf('/') == 0) {
                filename = filename.substring(1);
            }
            $(obj).val(filename);
            $(obj2).text(e.target.files[0].name);
            $(this).closest("tr").data('new_file', true);
        }

        $(this).closest("tr").css({ 'background-color': '' });
        /* fungsi ini tidak jalan di safari 
        var clone = $(this).clone();
        //clone.attr('id', 'filename2');
        clone.attr('class', 'filename2');
        $('#inputhide').append(clone);
        */
    });

    $(document).on("change", "input[name='cancellation_file']", function (e) {
        $("input[name$='cancellation.uploaded']").val("0");
    });

    $(document).on("change", "input[name='filename_general']", function (e) {
        $(this).closest("tr").find("input[name$='attachment.uploaded']").val("0");
        var obj = $(this).closest("tr").find("input[name='attachment.filename_general']");
        $(obj).val("");
        var filename = "";
        var fullPath = $(this).val();

        if (fullPath) {
            var startIndex = (fullPath.indexOf('\\') >= 0 ? fullPath.lastIndexOf('\\') : fullPath.lastIndexOf('/'));
            filename = fullPath.substring(startIndex);
            if (filename.indexOf('\\') == 0 || filename.indexOf('/') == 0) {
                filename = filename.substring(1);
            }
            $(obj).val(filename);
        }

        $(this).closest("tr").css({ 'background-color': '' });
    });

    $(document).on("click", ".editDocument", function () {
        var filedoctype = $(this).data("type") == "_general" ? "_general" : "";
        var obj = $(this).closest("td").find("input[name='filename" + filedoctype + "']");
        var obj2 = $(this).closest("td").find("input[name='attachment.filename" + filedoctype + "']");
        var att_id = $(this).closest("td").find("input[name='attachment.att_id']");
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

    $(document).on("change", "input[name='direct_to_finance_file']", function () {
        var obj = $("input[name='pr.direct_to_finance_file']");
        $(obj).val("");
        var filename = "";
        var fullPath = $(this).val();
        if (fullPath) {
            var startIndex = (fullPath.indexOf('\\') >= 0 ? fullPath.lastIndexOf('\\') : fullPath.lastIndexOf('/'));
            filename = fullPath.substring(startIndex);
            if (filename.indexOf('\\') == 0 || filename.indexOf('/') == 0) {
                filename = filename.substring(1);
            }
            $(obj).val(filename);
        }
    });

    $(document).on("change", "[name='prf.is_other_address']", function () {
        var isChecked = false;
        isChecked = $(this).prop("checked");

        checkOtherAddress(isChecked);
    });

    function checkOtherAddress(isChecked) {
        if (isChecked) {
            $("#div_is_other_address").addClass("last");
            $("#div_is_other_address").addClass("required");
            $("#div_other_address").show();

            $("#div_delivery_address").removeClass("required");
            $("select[name='prf.delivery_address']").append('<option value="23821" selected>Other</option>');
        } else {
            $("#div_is_other_address").removeClass("last");
            $("#div_is_other_address").removeClass("required");
            $("#div_other_address").hide();
            $("[name='prf.other_delivery_address']").val("");

            $("#div_delivery_address").addClass("required");
            $("select[name='prf.delivery_address'] option[value='23821']").remove();
        }
    }

    $(document).on("click", ".custom-file-button", function () {
        $(this).closest('td').find(".custom-file").trigger("click");
    });

    $(document).on("click", ".editDirectToFinanceFile", function () {
        var obj = $("input[name='pr.direct_to_finance_file']");
        $(obj).val("");
        var obj = $(this).closest("div").find("input[name='direct_to_finance_file']");
        var link = $(this).closest("div").find(".linkDocumentFinance");

        $(this).closest("div").find(".btnFileUploadJustification").show();
        $(this).closest("div").find("input[name$='justification.uploaded']").val("0");
        $(obj).val('');
        $(obj).show();
        $(link).hide();
        $(this).hide();
    });

    $(document).on("click", "#btnCloseDetail", function () {
        $("#tblAttachment tbody tr").each(function () {

            $(this).closest('td').find("input[name='filename']").val("");

        });
        var currentPopupDeleteId = popupDeleteId.map(x => x.id);
        $.each(currentPopupDeleteId, function (x, y) {
            var idx = deletedId.map(x => x.id).indexOf(y);
            if (idx >= 0) {
                deletedId.splice(idx, 1);
            }
        });
    });

    function onClickAddCostCenters() {
        var tblLength = $('#tblCostCenters >tbody >tr').length;
        var rowid_ = [];
        $('.tdRowNumCC').each(function (i, obj) {
            var x = $(this).attr('id');
            x = x.replace('tdRowNumCC', '');
            rowid_.push(x);
        });
        var row = rowid_.length === 0 ? 0 : Math.max.apply(Math, rowid_);
        row = row + 1;

        $("#tblCostCenters tbody").append(
            GetHtmlCostCenters(row, 0)
        )
        generateCombo($('#cbo' + row + '_CostCenters'), listCostCenter, "CODES", "DESCRIPTION", true);
        Select2Obj($('#cbo' + row + '_CostCenters'), "Cost center");
        Select2Obj($('#cbo' + row + '_WorkOrder'), "Work order / T4");
        Select2Obj($('#cbo' + row + '_EntityCostC'), "Entity");

        if (tblLength == 0) {
            $(".CostCentersValue").val(accounting.formatNumber(100, 2)).trigger("change");
        }
    }

    function populateWorkOrder(sel) {
        var row = $(sel).prop("id").replace('cbo', '').replace('_CostCenters', '');
        var selectedCODES = sel.value;
        parts = selectedCODES.split('-');
        t2 = parts[0];
        var selectedT2 = t2;

        $('#cbo' + row + '_CostCenters').val(selectedCODES);
        $('#lb' + row + '_T2val').text(selectedT2);
        /*  alert(selectedT2);*/
        $.ajax({
            type: "POST",
            contentType: "application/json; charset=utf-8",
            <%--url: "<%=service_url %>" + "/GetSUNT4",--%>
            url: '<%= Page.ResolveUrl("~/" + based_url+service_url + "/GetSUNT4") %>',
            async: false,
            data: '{"code":"' + selectedT2 + '"}',
            dataType: "json",
            success: function (response) {
                var data = response.d;
                $('#cbo' + row + '_WorkOrder').empty();
                $('#cbo' + row + '_EntityCostC').empty();
                generateCombo($('#cbo' + row + '_WorkOrder'), data, "id", "text", true);
            },
            error: function (event) {

            }
        });

        listEntityTemp = [];
        $.each(listEntity, function (i, d) {
            if (selectedCODES == d.CostCenterId) {
                listEntityTemp.push(d);
            }
        });
        $('#cbo' + row + '_EntityCostC').empty();
        $('#lb' + row + '_LegalEntity').text('');
        generateCombo($('#cbo' + row + '_EntityCostC'), listEntityTemp, "EntityId", "Description", true);
    }

    function onChangeCostCenter(noRow) {
    }

    function onChangeEntityCostCenter(noRow) {
        $.each(listEntityTemp, function (i, d) {
            if ($('#cbo' + noRow + '_EntityCostC').val() == d.EntityId) {
                $('#lb' + noRow + '_LegalEntity').text(d.LegalEntityId);
            }
        });

    }

    function onChangeCostCenterAmt(noRow, typeOf) {
        var amt = parseFloat($('#txt' + noRow + '_CostCentersAmt').val());
        var amtVal = parseFloat($('#txt' + noRow + '_CostCentersValue').val());
        var excRate = parseFloat($("[name='pr.exchange_rate']").val());
        var totalPrice = parseFloat(delCommas($("[name='prf.estimated_cost']").val()));

        if (typeOf == 1) {
            amt = (amtVal / 100.000000) * totalPrice;
            $('#txt' + noRow + '_CostCentersAmt').val(accounting.formatNumber((amtVal / 100.000000) * totalPrice, 2));
        } else {
            if (totalPrice > 0) {
                $('#txt' + noRow + '_CostCentersValue').val(accounting.formatNumber((amt / totalPrice) * 100.000000, 2));
            }
        }

        $('#txt' + noRow + '_CostCentersUSDAmt').val(accounting.formatNumber(amt * excRate, 2));

        CalculateChargeCodePercentage(noRow);
        AdjustAmountUSDChargeCode();
    }

    function AdjustAmountUSDChargeCode() {
        /*while (delCommas($("#ChargeCodeAmount").html()) == delCommas($("[name='prf.estimated_cost']").val()) && delCommas($("#ChargeCodeAmountUSD").html()) != delCommas($("[name='prf.estimated_cost_usd']").val())) {*/
        if ($("#ChargeCodePercentage").html() == '100.00') {
            while (delCommas($("#ChargeCodeAmountUSD").html()) != delCommas($("[name='prf.estimated_cost_usd']").val())) {
                var ccAmtUSD = parseFloat(delCommas($('#tblCostCenters tbody tr:last').find('.CostCentersUSDAmt').val()));
                if (parseFloat(delCommas($("#ChargeCodeAmountUSD").html())) - parseFloat(delCommas($("[name='prf.estimated_cost_usd']").val())) > 0) {
                    ccAmtUSD = ccAmtUSD - 0.01;
                } else {
                    ccAmtUSD = ccAmtUSD + 0.01;
                }
                $('#tblCostCenters tbody tr:last').find('.CostCentersUSDAmt').val(accounting.formatNumber(ccAmtUSD, 2));
                CalculateChargeCodePercentage(-1);
            }

            while (delCommas($("#ChargeCodeAmount").html()) != delCommas($("[name='prf.estimated_cost']").val())) {
                var ccAmt = parseFloat(delCommas($('#tblCostCenters tbody tr:last').find('.CostCentersAmt').val()));
                if (parseFloat(delCommas($("#ChargeCodeAmount").html())) - parseFloat(delCommas($("[name='prf.estimated_cost']").val())) > 0) {
                    ccAmt = ccAmt - 0.01;
                } else {
                    ccAmt = ccAmt + 0.01;
                }
                $('#tblCostCenters tbody tr:last').find('.CostCentersAmt').val(accounting.formatNumber(ccAmt, 2));
                CalculateChargeCodePercentage(-1);
            }
        }

    }

    function AdjustPercentageChargeCode(noRow) {
        while (parseFloat($('#ChargeCodePercentage').html()) != 100.00) {
            var percentage = parseFloat(delCommas($('#tblCostCenters tbody tr:last').find('.CostCentersValue').val()));
            if (parseFloat($('#ChargeCodePercentage').html()) > 100.00) {
                percentage = percentage - 0.01;
            } else {
                percentage = percentage + 0.01;
            }
            $('#txt' + noRow + '_CostCentersValue').val(accounting.formatNumber(percentage, 2));
            CalculateChargeCodePercentage(-1);
        }
    }

    function CalculateChargeCodePercentage(noRow) {
        var total = 0;
        var totalAmt = 0;
        var totalAmtUSD = 0;
        $("#tblCostCenters tbody tr").each(function () {
            total += parseFloat($(this).find('.CostCentersValue').val());
            totalAmt += parseFloat(delCommas($(this).find('.CostCentersAmt').val()));
            totalAmtUSD += parseFloat(delCommas($(this).find('.CostCentersUSDAmt').val()));
        })

        $('#ChargeCodePercentage').html(accounting.formatNumber(total, 2));
        $('#ChargeCodeAmount').html(accounting.formatNumber(totalAmt, 2));
        $('#ChargeCodeAmountUSD').html(accounting.formatNumber(totalAmtUSD, 2));

        if (parseFloat(delCommas($("[name='prf.estimated_cost']").val())) > 0) {
            if ($('#ChargeCodeAmount').html() == $("[name='prf.estimated_cost']").val() || $('#ChargeCodeAmountUSD').html() == $("[name='prf.estimated_cost_usd']").val()) {
                AdjustPercentageChargeCode(noRow);
            }
        }
    }

    function onChangeCostCenterVal(noRow) {
        var amt = $('#txt' + noRow + '_CostCentersAmt').val();
        var excRate = $("[name='pr.exchange_rate']").val();
        var totalPrice = delCommas($("[name='prf.estimated_cost']").val());

        $('#txt' + noRow + '_CostCentersUSDAmt').val(accounting.formatNumber(parseFloat(amt * excRate), 2));
        $('#txt' + noRow + '_CostCentersValue').val(accounting.formatNumber((amt / totalPrice) * 100, 2));
    }

    function onChangeDDLPurchaseOffice() {
        if (activityId != null && activityId != "" && activityId == 1 && isAllowed) {
            var procOfficeFromEventChanged = $("select[name='pr.cifor_office_id']").val();

            if (procOfficeFromDB != procOfficeFromEventChanged) {
                isPOFFChangedDuringResubmission = true;
            }
            else {
                isPOFFChangedDuringResubmission = false;
            }
        }
    }

    function CalcAmtChargeCode() {
        var excRate = $("[name='pr.exchange_rate']").val();

        if ($('#tblCostCenters >tbody >tr').length > 0) {
            $("#tblCostCenters tbody tr").each(function () {
                var amt = delCommas($(this).find('.CostCentersAmt').val());
                $(this).find('.CostCentersUSDAmt').val(accounting.formatNumber(parseFloat(amt * excRate), 2));
            });
        }
    }

    function CalcAmtAndUSDAmtChargeCode() {
        var excRate = $("[name='pr.exchange_rate']").val();
        var totalPrice = delCommas($("[name='prf.estimated_cost']").val());


        if ($('#tblCostCenters >tbody >tr').length > 0) {
            $("#tblCostCenters tbody tr").each(function () {
                var amtVal = $(this).find('.CostCentersValue').val();
                var amt = (amtVal / 100) * totalPrice;
                $(this).find('.CostCentersAmt').val(accounting.formatNumber(amt, 2));
                $(this).find('.CostCentersUSDAmt').val(accounting.formatNumber(parseFloat(amt * excRate), 2));
            });
        }
    }

    function delCostCenterID(id, obj) {
        $(obj).closest("tr").remove();
    }

    function GetHtmlCostCenters(row, id) {
        var html = '<tr>' +
            '<td style="display: none;" class="tdRowNumCC" id="tdRowNumCC' + row + '">' + row + '</td>' +
            '<td style="display: none;"><label id="lb' + row + '_ChargeCodeID" class="ChargeCodeID"></label></td>' +
            '<td style="word-wrap: break-word"><select id="cbo' + row + '_CostCenters" type="text" class="cboCostCenter CostCenters" onchange="populateWorkOrder(this)"></select></td>' +
            '<td style="word-wrap: break-word"><select class="CostCentersWorkOrder" id="cbo' + row + '_WorkOrder" onchange="onChangeCostCenter(' + row + ')"></select></td>' +
            '<td style="word-wrap: break-word"><select class="EntityCostC" id="cbo' + row + '_EntityCostC" onchange="onChangeEntityCostCenter(' + row + ')"></select></td>' +
            '<td><label id="lb' + row + '_LegalEntity" class="LegalEntityC" style="padding-top:5px; text-align:center;"></label></td>' +
            '<td style="display: none;"><label id="lb' + row + '_AccControl" class="AccControl"></label></td>' +
            /*'<td><label id="lb' + row + '_AccControl" class="AccControl"></label></td>' +*/
            '<td style="text-align: center;word-wrap: break-word"><input id="txt' + row + '_CostCentersValue" style="width:40px;" type="text" class="input-sm number CostCentersValue" data-decimal-places="2" placeholder="Cost value..." autocomplete="off" onchange="onChangeCostCenterAmt(' + row + ',1)"></input></td>' +
            '<td style="text-align: center;word-wrap: break-word"><input id="txt' + row + '_CostCentersAmt" style="width:120px;" type="text" class="input-sm number CostCentersAmt" data-decimal-places="2" placeholder="Amount value..." autocomplete="off" onchange="onChangeCostCenterAmt(' + row + ',2)"></input></td>' +
            '<td style="text-align: center;word-wrap: break-word"><input readonly id="txt' + row + '_CostCentersUSDAmt" style="width:120px;" type="text" class="input-sm number CostCentersUSDAmt" placeholder="USD Amount value..." data-decimal-places="2"></input></td>' +
            '<td style="word-wrap: break-word"><input id="txt' + row + '_CostCentersRemarks" type="text" class="input-sm CostCentersRemark" placeholder="Remarks..." autocomplete="off"></input></td>';
        /*   '<td style="word-wrap: break-word" class="actions"><span id= "del' + row + '_CostCenters"class="label red" data-original-title="" title="" ><i id= "img' + row + '"class="icon-trash delete" onclick="delCostCenterID(\'\',this)"></i></span></td>';*/
        if (page_name == "input") {
            html += '<td><input type="hidden" name="chargecode.id" value="' + id + '"/><span class="label red btnDelete" title="Delete"><i class="icon-trash delete" style="opacity: 1;"></i></span></td>';
        } else {
            html += '<td style="display:none;"><input type="hidden" name="chargecode.id" value="' + id + '"/></td>';
        }
        '</tr>'

        return html;
    }

    $(document).on("click", ".dropDetail", function () {
        var isShown = false;
        if ($(this).hasClass('icon-chevron-sign-right')) {
            isShown = true;
        } else if ($(this).hasClass('icon-chevron-sign-down')) {
            isShown = false;
        }

        if (isShown) {
            $(this).attr('class', 'icon-chevron-sign-down dropDetail');
        } else {
            $(this).attr('class', 'icon-chevron-sign-right dropDetail');
        }

    });

    function FundsCheck(chargeCodes) {
        blockScreenOL();
        var params = [];
        var failedFundsCheck = "";
        chargeCodes.forEach(function (item) {
            var chargeCode = {
                Costc: item.cost_center_id,
                Workorder: item.work_order,
                Entity: item.entity_id,
                Account: item.control_account,
                Amount: item.amount_usd
            };
            params.push(chargeCode);
        });

        $.ajax({
            type: "POST",
            contentType: "application/json; charset=utf-8",
            url: '<%= Page.ResolveUrl("~/" + based_url+service_url + "/FundsCheck") %>',
            async: false,
            data: JSON.stringify({ data: params }),
            dataType: "json",
            success: function (response) {
                var result = JSON.parse(response.d);

                if (result.success == true && result.status == "200") {
                    result.data.forEach(function (item) {
                        if (item.Result == false) {
                            failedFundsCheck += "<br> - Failed funds check for " + item.WorkOrder + "." + item.Entity;
                        }
                    });
                }
            },
            error: function (jqXHR, exception) {
                unBlockScreenOL();
            }
        });
        return failedFundsCheck;
    }

    $('#tblSearchItems').on('page.dt', function () {
        $('.modal-body').animate({ scrollTop: 0 }, 500);
    });

    function lookupPRType() {

        var cbo = $("[name='pr.purchase_type']");
        $(cbo).empty();
        generateCombo(cbo, listPRType, "value", "description", true);
        Select2Obj(cbo, "Purchase type");
        $("[name='pr.purchase_type']").val(_purchase_type).trigger("change");
        // $("[name='pr.purchase_type']").val(_purchase_type)
    }

    function populateHeader() {
        direct_to_finance_justification = new DOMParser().parseFromString(PRHeader.direct_to_finance_justification, "text/html").documentElement.textContent;
    }

</script>
