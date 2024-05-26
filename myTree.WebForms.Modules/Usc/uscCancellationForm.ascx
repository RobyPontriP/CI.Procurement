<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="uscCancellationForm.ascx.cs" Inherits="myTree.WebForms.Modules.Usc.uscCancellationForm" %>
<div id="CancelForm" class="modal hide fade modal-dialog" tabindex="-1" role="dialog" aria-labelledby="headerCancellationForm" aria-hidden="true"
    data-backdrop="static" data-keyboard="false">
	<div class="modal-header">
		<button type="button" class="close" data-dismiss="modal" aria-hidden="true"></button>
			<h3 id="headerCancellationForm">Reason for cancellation</h3>
	</div>
	<div class="modal-body">
        <div class="floatingBox" id="cform-error-box" style="display: none">
            <div class="alert alert-error" id="cform-error-message">
            </div>
        </div>
        <div class="control-group">
            <small><i id="reasonForCancellationLabel">Please provide a reason for cancellation in text and/or file</i></small><br />
            <textarea id="cancellation_text" rows="3" class="span12 textareavertical" maxlength="1000"></textarea>
            <br />
            <input type="file" id="_cancellation_file" name="cancellation_file" />
            <input type="hidden" name="cancellation.uploaded" value="0"/>
            <input type="hidden" id="cancellation_file" />
            <%--<span class="linkDocumentCancel" style="display: none;"><a href="a" target="_blank" id="linkDocumentCancelHref"></a>&nbsp;</span>--%>
            <span class="linkDocumentCancel" style="display:none;"><a class href="" id="linkDocumentCancelHref" target="_blank"></a>&nbsp;</span>
            <button type="button" class="btn btn-primary editDocumentCancel" style="display: none;">Edit</button>
            <button type="button" class="btn btn-success btnFileUploadCancel" data-type="filecancel">Upload</button>
            <div class="doc-notes"></div>
        </div>
    </div>
    <div class="modal-footer">
        <button type="button" class="btn btn-success" aria-hidden="true" id="btnSaveCancellation" data-action="cancelled">Submit cancellation</button>
        <button type="button" class="btn" data-dismiss="modal" aria-hidden="true">Close and cancel</button>
	</div>
</div>
<script>
    $(document).on("change", "#_cancellation_file", function () {
        var obj = $("#cancellation_file");
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

    $(document).on('hidden.bs.modal', '#CancelForm', function () {
        $("#cancellation_text").val("");
        $("#_cancellation_file").val("");
        $("#cancellation_file").val("");
    });

    $(document).on("click", ".editDocumentCancel", function () {
        $(this).closest("div").find("input[name='cancellation_file']").val("");

        $(this).closest("div").find("input[name$='cancellation.uploaded']").val("0");
        $(this).closest("div").find(".btnFileUploadCancel").show();
        $(this).closest("div").find("input[name$='cancellation_file']").show();

        $(this).closest("div").find(".linkDocumentCancel").hide();
        $(this).closest("div").find(".editDocumentCancel").hide();
    });

    function GenerateCancelFileLink(row, filename) {
        var doc_id = $("input[name='doc_id']").val();
        var linkdoc = '';
        
        linkdoc = "Files/" + doc_id + "/" + filename + "";
        $(row).closest("div").find("input[name$='cancellation_file']").hide();

        $(row).closest("div").find(".editDocumentCancel").show();
        $(row).closest("div").find("a#linkDocumentCancelHref").attr("href", linkdoc);
        $(row).closest("div").find("a#linkDocumentCancelHref").text(filename);
        $(row).closest("div").find(".linkDocumentCancel").show();
        $(row).closest("div").find(".btnFileUploadCancel").hide();
    }
</script>