<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="uscSendConfirmation.ascx.cs" Inherits="myTree.WebForms.Modules.UserConfirmation.uscSendConfirmation" %>
<div class="control-group">
    <input type="hidden" name="base_type"/>
    <input type="hidden" id="confirm_id" />
    <input type="hidden" id="confirm_no" />
    <table id="tblConfirmations" class="table table-bordered" style="border: 1px solid #ddd; width:100%;">
        <thead>
            <tr>
                <th>PR code</th>
                <th>RFQ code</th>
                <th>Quotation code</th>
                <th>Supplier selection code</th>
                <th>PO code</th>
                <th>Requester</th>
                <th>Initiator</th>
                <th>Additional person to receive the confirmation</th>
            </tr>
        </thead>
        <tbody>
        </tbody>
    </table>
    <p></p>
</div>
<div class="control-group">
    <label class="control-label">
        Supporting document(s)
    </label>
    <div class="controls">
        <table id="tblSupportingDocuments" class="table table-bordered table-hover" style="border: 1px solid #ddd">
            <thead>
                <tr>
                    <th style="width:45%;">Description</th>
                    <th style="width:30%;">File</th>
                    <%  if (page_type == "send")
                        { %>
                    <th style="width:20%;">Is Initiator/Requester need to provide this file?</th>
                    <th style="width:5%;">&nbsp;</th>
                    <%  } %>
                </tr>
            </thead>
            <tbody>
            </tbody>
        </table>
        <%  if ("" == "send")
            { %>
        <div class="doc-notes"></div>
        <p>
            <button id="btnAddSupDoc" class="btn btn-success" type="button">Add supporting document</button>
        </p>
        <%  }
            else
            { %>
        <br />
        <%  } %>
    </div>
</div>
<script>
    var listEmployee = <%=listEmployee%>;

    var confirmationType = "<%=page_type%>";

    var tblConfirm = initConfirmTable();
    var ConfirmMain = [];
    var ConfirmDetail = [];

    var deletedSupDocId = [];

    $(document).on("click", "#btnAddSupDoc", function () {
        var _uid = guid();
        var html = '<tr>';
        html += '<td><input type="text" class="span12" name="confirmationfile.file_description" data-title="Description" data-validation="required" data-group="confirmationattach_'+ _uid +'" data-validation-primary="no" maxlength="2000" placeholder="Description"/></td>';
        html += '<td><input type="hidden" name="confirmationfile.filename" data-title="File" data-validation="required" data-group="confirmationattach_'+ _uid +'" data-validation-primary="no"/><input type="file" class="span12" name="confirm_filename"/></td>';
        html += '<td><input type="checkbox" name="confirmationfile.suppdoc_'+ _uid +'" data-title="Suppdoc" data-validation="required" data-group="confirmationattach_'+ _uid +'" data-validation-primary="yes"/></td>';
        html += '<td><input type="hidden" name="confirmationfile.id"/><span class="label red btnDeleteDoc"><i class="icon-trash delete" style="opacity: 1;"></i></span></td>';
        html += '</tr>';
        $("#tblSupportingDocuments tbody").append(html);
    });

    $(document).on("click", ".btnDeleteDoc", function () {
        var _sid = $(this).closest("td").find("input[name='confirmationfile.id']").val();
        if (_sid != "") {
            deletedSupDocId.push(_sid);
        }

        $(this).closest("tr").remove();
    });

    $(document).on("change", "input[name='confirm_filename']", function () {
        var obj = $(this).closest("tr").find("input[name='confirmationfile.filename']");
        $(obj).val("");
        var fullPath = $(this).val();
        if (fullPath) {
            var startIndex = (fullPath.indexOf('\\') >= 0 ? fullPath.lastIndexOf('\\') : fullPath.lastIndexOf('/'));
            var filename = fullPath.substring(startIndex);
            if (filename.indexOf('\\') === 0 || filename.indexOf('/') === 0) {
                filename = filename.substring(1);
            }
            $(obj).val(filename);
        }
    });

    function resetFormConfirmation() {
        $("#ucform-error-box").hide();
        $("#ucform-error-message").val("");
        $("#tblConfirmations tbody").html("");
        $("#tblSupportingDocuments tbody").html("");
        $("[name='base_type']").val("");

        ConfirmMain = [];
        ConfirmDetail = [];
    }

    function initConfirmTable() {
        var isVisible = true;
        if (confirmationType != "send") {
            isVisible = false;
        }

        return $("#tblConfirmations").DataTable({
            data: ConfirmMain,
            "aoColumns": [
                {
                    "mDataProp": "pr_id"
                    , "mRender": function (d, type, row) {
                        var html = '<input type="hidden" name="base_id" value="' + row.base_id + '"/>' +
                            '<a href="purchaserequisition/detail.aspx?id=' + row.pr_id + '" title="View detail Purchase requisition" target="_blank">' + row.pr_no + '</a>';
                        return html;
                    }
                },
                {
                    "mDataProp": "rfq_id"
                    ,"mRender": function (d, type, row) {
                        var html = '<a href="RFQ/detail.aspx?id=' + row.rfq_id + '" title="View detail RFQ" target="_blank">' + row.rfq_no + '</a>';
                        return html;
                    }
                },
                {
                    "mDataProp": "q_id"
                    ,"mRender": function (d, type, row) {
                        var html = '<a href="quotation/detail.aspx?id=' + row.q_id + '" title="View detail Quotation" target="_blank">' + row.q_no + '</a>';
                        return html;
                    }
                },
                {
                    "mDataProp": "vs_no"
                    ,"mRender": function (d, type, row) {
                        var html = '<a href="vendorselection/detail.aspx?id=' + row.vs_id + '" title="View detail Supplier selection" target="_blank">' + row.vs_no + '</a>';
                        return html;
                    }
                },
                {
                    "mDataProp": "po_no"
                    ,"mRender": function (d, type, row) {
                        var html = '<a href="purchaseorder/detail.aspx?id=' + row.po_id + '" title="View detail Purchase order" target="_blank">' + row.po_no + '<br/>' + row.po_sun_code + '</a>';
                        return html;
                    }
                },
                { "mDataProp": "requester_name" },
                { "mDataProp": "initiator_name" },
                {
                    "mDataProp": "po_sun_code"
                    , "mRender": function (d, type, row) {
                        var html = '<select name="cboStaff_' + row.unique_id + '" class="cboStaff" data-unique_id="' + row.unique_id + '"></select>';
                        return html;
                    }
                    , "visible": isVisible
                },
            ],
            "bFilter": false, "bDestroy": true, "bRetrieve": true,
            "searching": false,
            "info": false,
            "ordering": false,
            "paging": false,
            "drawCallback": function( settings ) {
                OpenAllConfirmItems();
            }
        });
    }

    function loadItems(ids, baseType) {
        $("[name='base_type']").val(baseType);
        var data = { ids: ids, base_type: baseType };
        $.ajax({
          /*  url: 'Service.aspx/GetUserConfirmationItems',*/
            url: '<%= Page.ResolveUrl("~/" + based_url+service_url + "/GetUserConfirmationItems") %>',
            data: JSON.stringify(data),
            dataType: 'json',
            type: 'post',
            contentType: "application/json; charset=utf-8",
            success: function (response) {
                dataConfirmation = JSON.parse(response.d);
                ConfirmMain = dataConfirmation.groupheader
                ConfirmDetail = dataConfirmation.groupdetail

                tblConfirm.clear().draw();
                tblConfirm.rows.add(ConfirmMain).draw();

                $("[name^='cboStaff']").each(function () {
                    var cboRequester = $("[name='" + $(this).attr("name") + "']");
                    generateCombo(cboRequester, listEmployee, "EMP_USER_ID", "EMP_NAME", true);
                    Select2Obj(cboRequester, "Additional person");
                });
            }
        });
    }

    function OpenAllConfirmItems() {
        if (typeof tblConfirm !== "undefined") {
            $.each(tblConfirm.rows().nodes(), function (i) {
                var row = tblConfirm.row(i)
                if (typeof row.data() !== "undefined") {
                    if (!row.child.isShown()) {
                        row.child(showConfirmationDetail(row.data())).show();
                        $(row.node()).addClass('shown');
                    }
                }
                normalizeMultilines();
            });
        }
        repopulateNumber();
    }

    function showConfirmationDetail(d) {
        var html = '';
        if (typeof d !== "undefined") {
            html = '<table class="table table-bordered" style="border: 1px solid #ddd;  margin-left:10px; width:98%; overflow: auto;""><thead>';
            html += '<tr>';
            html += '<th class="wrapCol">No</th>';
            html += '<th class="wrapCol">Product code</th>';
            html += '<th class="wrapCol">Product description</th>';
            html += '<th class="wrapCol">UOM</th>';
            html += '<th class="wrapCol" style="text-align:right;">PR quantity</th>';
            if (confirmationType == "send") {
                html += '<th class="wrapCol" style="text-align:right;">Outstanding quantity</th>';
                html += '<th class="wrapCol" style="text-align:right;">Delivery quantity <span style="color:red">*</span></th>';
            } else {
                html += '<th class="wrapCol" style="text-align:right;">Delivery quantity</th>';
                html += '<th class="wrapCol" style="text-align:right;">Accept quantity</th>';
                html += '<th class="wrapCol" style="text-align:right;">Rejected quantity</th>';
                if (confirmationType == "detail") {
                    html += '<th class="wrapCol">Status</th>';
                    html += '<th class="wrapCol">Confirm by</th>';
                    html += '<th class="wrapCol">Confirm date</th>';
                }
            }
            html += '</tr>';
            html += '</thead><tbody>';

            var item = $.grep(ConfirmDetail, function (n, i) {
                return n["unique_id"] == d.unique_id;
            });

            $.each(item, function (i, x) {
                html += '<tr class="confirm_id" data-id="' + x.id + '" data-base_id="' + x.base_id + '">';
                html += '<td class="wrapCol">' + (i + 1) + '<input type="hidden" name="additional_person" value="' + x.additional_person + '"/></td>';
                /* html += '<td class="wrapCol"><a href="item/detail.aspx?id=' + x.item_id + '" target="_blank" title="View detail Item">' + x.item_code + '</a></td>';*/
                html += '<td class="wrapCol">' + x.item_code + '</td>';
                html += '<td class="wrapCol">' + x.item_description + '</td>';
                html += '<td class="wrapCol">' + x.uom + '</td>';
                html += '<td class="wrapCol" style="text-align:right;">' + accounting.formatNumber(x.pr_quantity, 2) + '</td>';
                var deliv_qty = "";
                if (confirmationType == "send") {
                    html += '<td class="wrapCol" style="text-align:right;">' + accounting.formatNumber(x.outstanding_quantity, 2) + '</td>';
                    deliv_qty = '<input type="text" data-validation="required number" data-decimal-places="2" data-title="Delivery quantity for ' + x.item_code + '" class="number span12" data-maximum="' + delCommas(x.outstanding_quantity) + '" data-maximum-attr="quantity" data-description="' + x.item_code + '"  max-length="10" name="delivery_quantity_' + x.base_id + '" data-id="' + x.base_id + '" data-unique_id="' + x.unique_id + '" placeholder="Delivery quantity" value="' + delCommas(x.outstanding_quantity) + '"/>';
                } else {
                    deliv_qty = '<input type="hidden" name="send_quantity" value="' + delCommas(x.send_quantity) + '"/>' + accounting.formatNumber(x.send_quantity, 2);
                }
                html += '<td class="wrapCol" style="text-align:right;">' + deliv_qty + '</td>';
                if (confirmationType != "send") {
                    var accept_qty = "";
                    if (confirmationType == "submission") {
                        accept_qty = '<input type="text" data-validation="number" data-decimal-places="2" data-title="Accept quantity for ' + x.item_code + '" class="number span12" data-maximum="' + delCommas(x.send_quantity) + '" data-maximum-attr="quantity" data-description="' + x.item_code + '"  max-length="10" name="accept_quantity_' + x.base_id + '" data-id="' + x.base_id + '" data-unique_id="' + x.unique_id + '" placeholder="Accept quantity" value="' + delCommas(x.quantity) + '"/>';
                    } else {
                        accept_qty = accounting.formatNumber(x.quantity, 2);
                    }
                    html += '<td class="wrapCol" style="text-align:right;">' + accept_qty + '</td>';
                    html += '<td class="wrapCol rejected_quantity" style="text-align:right;">' + accounting.formatNumber(x.rejected_quantity, 2) + '</td>';
                    if (confirmationType == "detail") {
                        html += '<td class="wrapCol">' + x.status_name + '</td>';
                        html += '<td class="wrapCol">' + x.confirm_user + '</td>';
                        html += '<td class="wrapCol">' + x.confirm_date + '</td>';
                    }
                }
                html += '</tr>';
                if (confirmationType == "submission") {
                    html += '<tr class="remarks_' + x.base_id + '" style="display:none;">';
                    html += '<td colspan="2">Remarks <span style="color:red">*</span></td>';
                    html += '<td colspan="6"><textarea maxlength="2000" class="span11 textareavertical" data-title="Remarks for ' + x.item_code + '" name="quality_' + x.base_id + '" data-id="' + x.base_id + '">' + x.quality + '</textarea></td></tr>';
                }else if (confirmationType == "detail" && delCommas(x.rejected_quantity)>0) {
                    html += '<tr><td colspan="2">Remarks</td><td colspan="9">' + x.quality + '</td></tr>';
                }
            });

            html += '</tbody></table>';
        }
        return html;
    }

    $(document).on("change", "[name^='accept_quantity']", function () {
        var send_qty = delCommas($(this).closest("tr").find("[name='send_quantity']").val());
        var accept_qty = delCommas($(this).val());
        var rejected = accounting.formatNumber(send_qty - accept_qty, 2);
        
        $(this).closest("tr").find(".rejected_quantity").html(rejected);
        $(".remarks_" + $(this).data("id")).hide();
        $("[name^='quality'][data-id='" + $(this).data("id") + "']").val("");

        $("[name^='quality'][data-id='" + $(this).data("id") + "']").data("validation", "");
        if (send_qty != accept_qty) {
            $(".remarks_" + $(this).data("id")).show();
            $("[name^='quality'][data-id='" + $(this).data("id") + "']").data("validation", "required");
        }
    });
</script>