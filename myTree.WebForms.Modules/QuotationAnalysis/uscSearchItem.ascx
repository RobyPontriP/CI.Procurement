<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="uscSearchItem.ascx.cs" Inherits="myTree.WebForms.Modules.VendorSelection.uscSearchItem" %>
<div id="ItemForm" class="modal hide fade modal-dialog" tabindex="-1" role="dialog" aria-labelledby="header3" aria-hidden="true"
    data-backdrop="static" data-keyboard="false">
	<div class="modal-header">
		<button type="button" class="close" data-dismiss="modal" aria-hidden="true"></button>
			<h3 id="header3">Add product</h3>
	</div>
	<div class="modal-body">
        <div class="floatingBox" id="itemform-error-box" style="display: none">
            <div class="alert alert-error" id="itemform-error-message">
            </div>
        </div>
       
        <div class="control-group">
            <label class="control-label">View by</label>
            <div class="controls">
                <span class="span2"><input type="radio" name="viewVS" value="1" checked="checked"/> RFQ</span>
                <span class="span6"><input type="radio" name="viewVS" value="2"/> PR &nbsp;
                    <button type="button" class="btn" id="btnRefresh">Refresh</button>
                </span>
            </div>
        </div>
         <div class="control-group">
            <label class="control-label">
                Quotation date
            </label>
            <div class="controls">
                <div class="input-prepend" style="margin-right: -32px;">
                    <input type="text" name="startDate" id="_startDate" data-title="Start date" class="span8" readonly="readonly" placeholder="Start date" maxlength="11" value="" />
                    <span class="add-on icon-calendar" id="startDate"></span>
                </div>
                To&nbsp;&nbsp;&nbsp;
        <div class="input-prepend">
            <input type="text" name="endDate" id="_endDate" data-title="End date" class="span8" readonly="readonly" placeholder="End date" maxlength="11" value="" />
            <span class="add-on icon-calendar" id="endDate"></span>
        </div>
            </div>
        </div>
          <div class="control-group">
            <label class="control-label">
                Search
            </label>
            <div class="controls">
                <div class="input-prepend" style="margin-right: -32px;">
                    <input type="text" name="search" id="_search" data-title="search" class="span9" placeholder="Search" value="" />
                </div>
                  <button type="button" id="btnSearch" class="btn btn-success">Search</button>
                <div class="mt-1" style="font-size: 80%; font-style: italic; display: block;">Search by purchase requisition or request for quotation or quotation code</div>
            </div>
        </div>
        <div>
            <div id="loadingformitem">Loading...</div>
            <table id="SearchItem" class="table table-bordered" style="border: 1px solid #ddd">
                <thead>
                    <tr>
                        <th>&nbsp;</th>
                        <th>&nbsp;</th>
                        <th>Product code</th>
                        <th>PR description</th>
                        <th>PR quantity</th>
                        <th>PR estimated cost</th>
                        <th>PR estimated cost (in USD)</th>
                    </tr>
                </thead>
                <tbody>

                </tbody>
            </table>
            
            <table id="SearchItem2" class="table table-bordered" style="border: 1px solid #ddd">
                <thead>
                    <tr>
                        <th>&nbsp;</th>
                        <th>RFQ code</th>
                        <th>Quotation code</th>
                        <th>Supplier</th>
                        <th>Total</th>
                    </tr>
                </thead>
                <tbody>

                </tbody>
            </table>
        </div>
    </div>
	<div class="modal-footer">
        <button type="button" class="btn btn-success" aria-hidden="true" id="btnSelectItem">Select product(s)</button>
        <button type="button" class="btn" data-dismiss="modal" aria-hidden="true">Close and cancel</button>
	</div>
</div>
