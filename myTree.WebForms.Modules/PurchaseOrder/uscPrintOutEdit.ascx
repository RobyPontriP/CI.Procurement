<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="uscPrintOutEdit.ascx.cs" Inherits="Procurement.PurchaseOrder.uscPrintOutEdit" %>

<div id="PrintOutForm" class="modal hide fade modal-dialog" tabindex="-1" role="dialog" aria-labelledby="headerPrintOutForm" aria-hidden="true"
    data-backdrop="static" data-keyboard="false">
    <div class="modal-header">
        <%--<button type="button" class="close" data-dismiss="modal" aria-hidden="true"></button>--%>
        <h3 id="headerPrintOutForm">Purchase order print out</h3>
    </div>
    <div class="modal-body">
        <div class="row-fluid">
            <div class="container-fluid">


                <div class="control-group">
                    <label class="control-label">
                        Procurement address
                    </label>
                    <div class="controls">
                        <div>
                            <div id="cboProcAddressName">
                                <select name="po.procurement_address" id="po.procurement_address" data-validation="required" data-title="Procurement address"></select>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="control-group">
                    <label class="control-label">
                        Legal entity
                    </label>
                    <div class="controls">
                        <div>
                            <div id="cboLegalEntity">
                                <select name="po.legal_entity" id="po.legal_entity" data-validation="required" data-title="Legal entity"></select>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

        </div>
    </div>
    <div class="modal-footer">
        <button type="button" class="btn btn-success" aria-hidden="true" id="btnSavePrintOut" data-action="saved">Update and print PO</button>
        <button type="button" class="btn" aria-hidden="true" data-dismiss="modal" id="btnPrintOut" data-action="saved">Cancel</button>
    </div>
</div>
