<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="uscReconfirmationForm.ascx.cs" Inherits="myTree.WebForms.Modules.UserConfirmation.uscReconfirmationForm" %>
<div id="ReconfirmationForm" class="modal hide fade modal-dialog" role="dialog" aria-labelledby="header1" aria-hidden="true"
    data-backdrop="static" data-keyboard="false">
	<div class="modal-header">
		<button type="button" class="close" data-dismiss="modal" aria-hidden="true"></button>
			<h3 id="header1">Send re-confirmation request</h3>
	</div>
	<div class="modal-body">
        <input type="hidden" id="uc_id" />
        <input type="hidden" id="ucd_id" />
        <div class="control-group">
            <label class="control-label">
                Confirmation code
            </label>
            <div class="controls labelDetail" id="confirmation_code"></div>
        </div>
        <div class="control-group">
            <label class="control-label">
                PR code
            </label>
            <div class="controls labelDetail" id="pr_code"></div>
        </div>
        <div class="control-group">
            <label class="control-label">
                Requester
            </label>
            <div class="controls labelDetail" id="requester"></div>
        </div>
        <div class="control-group">
            <label class="control-label">
                Initiator
            </label>
            <div class="controls labelDetail" id="initiator"></div>
        </div>
        <div class="control-group">
            <label class="control-label">
                Item code
            </label>
            <div class="controls labelDetail" id="item_code"></div>
        </div>
        <div class="control-group">
            <label class="control-label">
                Description
            </label>
            <div class="controls labelDetail" id="item_description"></div>
        </div>
        <div class="control-group">
            <label class="control-label">
                Delivery quantity
            </label>
            <div class="controls labelDetail" id="delivery_quantity"></div>
        </div>
        <div class="control-group last">
            <label class="control-label">
                Additional person to receive the request
            </label>
            <div class="controls">
                <select id="additional_person">

                </select>
            </div>
        </div>
    </div>
    <div class="modal-footer">
        <button type="button" class="btn btn-success" aria-hidden="true" id="btnReconfirm" data-action="cancelled">Re-confirm</button>
        <button type="button" class="btn" data-dismiss="modal" aria-hidden="true">Close and cancel</button>
	</div>
</div>
<script>
    var listEmployee = <%= listEmployee%>;

    $(document).ready(function () {
        var cboRequester = $("#additional_person");
        generateCombo(cboRequester, listEmployee, "EMP_USER_ID", "EMP_NAME", true);
        Select2Obj(cboRequester, "Additional person");
    });
</script>
