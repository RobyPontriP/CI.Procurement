<%@ Page MasterPageFile="~/Procurement.Master" Language="C#" AutoEventWireup="true" CodeBehind="Wizard.aspx.cs" Inherits="myTree.WebForms.Modules.RFQ.Wizard"%>

<%@ Register Src="~/RFQ/uscSearchItem.ascx" TagName="SearchItem" TagPrefix="uscItem" %>
<%@ Register Src="~/RFQ/uscPRList.ascx" TagName="PRList" TagPrefix="uscPR"%>

<asp:Content ID="Content1" ContentPlaceHolderID="AppHead" runat="server">
    <title>Request for Quotation Wizard</title>
    <style>
        .sorting_1 {
            background-color: inherit !important;
        }
        .select2 {
            min-width: 250px !important;
        }
        fieldset {
            border: 0 !important;
            margin: 0 !important;
        }
        #formWizard fieldset, #formWizard fieldset legend {
            background-color: #fff;
        }
        legend {
            margin-bottom: 0;
        }
    </style>

    <script src="<%=Page.ResolveUrl("~/js/RFQWizard.js")%>?v=<%= DateTime.Now.ToString("yyyyMMddhhmm") %> "type="text/javascript"></script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="AppBody" runat="server">
    <div class="floatingBox" id="error-box" style="display: none">
        <div class="alert alert-error" id="error-message">
        </div>
    </div>
    <div class="row-fluid">
        <div class="floatingBox formWizard">
            <div class="container-fluid">
                <div id="formWizard">
                    <fieldset>
                        <legend>Select Product(s)</legend>
                        <uscPR:PRList ID="PRList" runat="server" />
                    </fieldset>
                    <fieldset>
                        <legend>Select supplier(s)</legend>
                        <uscItem:SearchItem ID="SearchItem" runat="server" />
                    </fieldset>
                    <fieldset>
                        <legend>Confirmation</legend>
                        <div class="control-group required">
                            <label class="control-label">Document date</label>
                            <div class="controls">
                                <div class="input-prepend" style="margin-right:-32px;">
                                    <input type="text" name="document_date" id="_document_date" data-title="Document date" data-validation="required" class="span8" readonly="readonly" placeholder="Document date" maxlength="11"/>
                                    <span class="add-on icon-calendar" id="document_date"></span>
                                </div>                                
                            </div>
                        </div>
                        <div class="control-group">
                            <label class="control-label">Due date</label>
                            <div class="controls">
                                <div class="input-prepend" style="margin-right:-32px;">
                                    <input type="text" name="due_date" id="_due_date" data-title="Due date" class="span8" readonly="readonly" placeholder="Due date" maxlength="11"/>
                                    <span class="add-on icon-calendar" id="due_date"></span>
                                </div>                                
                            </div>
                        </div>
                        <div class="control-group">
                            <label class="control-label">Remarks</label>
                            <div class="controls">
                                <textarea name="remarks" data-title="Remarks" rows="5" class="span10 textareavertical" placeholder="Remarks" maxlength="2000"></textarea>
                                <div class="mt-1" style="font-size: 80%; font-style: italic; display: block;">Maximum description is 2,000 characters</div>
                            </div>
                        </div> 
                        <div class="control-group">
                            <table id="tblRFQ" class="table table-bordered table-striped" style="border: 1px solid #ddd">
                                <thead>
                                    <tr>
                                        <th style="width:12%;">RFQ code</th>
                                        <th style="width:20%;">Supplier name</th>
                                        <th style="width:20%;" class="required">Supplier contact person</th>
                                        <th style="width:18%;">Email</th>
                                        <th style="width:30%;">Supplier address</th>
                                        <th></th>
                                    </tr>
                                </thead>
                                <tbody>
                                </tbody>
                            </table>
                        </div>
                        <div class="control-group last">
                            <table id="tblDetail" class="table table-bordered table-striped" style="border: 1px solid #ddd">
                                <thead>
                                    <tr>
                                        <th style="width:12%;">PR code</th>
                                         <th style="width:20%;">Procurement office</th>
                                        <th style="width:20%;">Product code</th>
                                        <th style="width:30%;">Description</th>
                                        <th style="width:18%;">Quantity</th>
                                    </tr>
                                </thead>
                                <tbody>
                                </tbody>
                            </table>
                        </div>
                    </fieldset>
                    <button type="button" class="btn btn-success submit" id="submitForm">Save as draft RFQ</button>
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
        $(function () {
            $("#formWizard").RFQWizard({ submitButton: 'submitForm' });

            $("#_startDate").data("validation", "required");
            $("#_endDate").data("validation", "required");
            $("#_document_date").data("validation", "");
            $("[name='contact']").data("validation", "");
        });

        $("#document_date").datepicker({
            format: "dd M yyyy"
            , autoclose: true
        }).on("changeDate", function () {
            $("[name='document_date']").val($("#document_date").data("date"));
            $("#document_date").datepicker("hide");
            startDate = new Date($("#document_date").data("date"));
            $('#due_date').datepicker('setStartDate', (startDate.getDate().toString().length < 2 ? '0' + startDate.getDate() : startDate.getDate()) + ' ' + ((startDate.getMonth() + 1).toString().length < 2 ? '0' + (startDate.getMonth() + 1) : (startDate.getMonth() + 1)) + ' ' + startDate.getFullYear());

                $.ajax({
                url:"<%=Page.ResolveUrl("~/Service.aspx/GetMinimumDate")%>",
                data: '{date:"' + $("#document_date").data("date") + '", additional: 4}',
                dataType: 'json',
                type: 'post',
                contentType: "application/json; charset=utf-8",
                success: function (response) {
                    $("#due_date").datepicker("setDate", new Date(response.d)).trigger("changeDate");
                }
            });
        });

        $("#due_date").datepicker({
            format: "dd M yyyy"
            , autoclose: true
            , startDate: (startDate.getDate().toString().length < 2 ? '0' + startDate.getDate() : startDate.getDate()) + ' ' + ((startDate.getMonth() + 1).toString().length < 2 ? '0' + (startDate.getMonth() + 1) : (startDate.getMonth() + 1)) + ' ' + startDate.getFullYear()
        }).on("changeDate", function () {
            $("[name='due_date']").val($("#due_date").data("date"));
            $("#due_date").datepicker("hide");
        });

        $(document).on("click", "#submitForm", function() {
            SubmitValidation();
        });

        function SubmitValidation() {
            var errorMsg = "";
            errorMsg += GeneralValidation();
            errorMsg += FileValidation();

            if (errorMsg != "") {
                showErrorMessage(errorMsg);
                return false;
            } else {
                var submit = [];
                $("#tblRFQ tbody tr").each(function (i, v) {
                    var tr = $(this);

                    var rfq = new Object();
                    rfq.document_date = $("[name='document_date']").val();
                    rfq.due_date = $("[name='due_date']").val();
                    rfq.remarks = $("[name='remarks']").val();
                    rfq.vendor = $(this).find("[name='vendor']").val();
                    rfq.vendor_name = $(tr).find("td:eq(1)").text();
                    rfq.vendor_contact_person = $(this).find("[name='contact']").val();
                    rfq.cifor_office_id = cifor_office_id[0];

                    rfq.details = [];
                    $.each(dataRFQ0.item, function (j, _d) {
                        $.each(_d, function (i, d) {
                            var rfqd = new Object();
                            var item = $.grep(listItem, function (n, k) {
                                return n["pr_detail_id"] == d.id;
                            });
                            if (item.length > 0) {
                                rfqd.item_id = item[0].item_id;
                                rfqd.item_code = item[0].item_code;
                                rfqd.brand_name = item[0].brand_name;
                                rfqd.description = item[0].description;
                                rfqd.request_quantity = d.qty;
                                rfqd.uom = item[0].uom_id;
                                rfqd.pr_detail_id = d.id;
                                rfqd.pr_id = item[0].pr_id;
                                rfqd.pr_no = item[0].pr_no;
                            }

                            rfq.details.push(rfqd);
                        });
                    });

                    rfq.sundry = [];
                    var sundry_detail = $.grep(dataSundry, function (n, k) {
                        return n["sundry_supplier_id"] == rfq.vendor;
                    });
                    if (sundry_detail.length > 0) {
                        rfq.sundry.push(sundry_detail[0]);
                    }

                    submit.push(rfq);
                });
               
                var _submit = { "submission": JSON.stringify(submit) };
                Submit(_submit);
            }
        }

        function Submit(_data) {
            $.ajax({
                url: "<%=Page.ResolveUrl("Wizard.aspx/Save")%>",
                data: JSON.stringify(_data),
                dataType: 'json',
                type: 'post',
                contentType: "application/json; charset=utf-8",
                success: function (response) {
                    var output = JSON.parse(response.d);
                    if (output.result != "success") {
                        alert(output.message);
                    } else {
                        alert(output.rfq_no + " has been saved successfully");
                        blockScreen();
                        location.href = "List.aspx";
                    }
                }
            });
        }
    </script>
</asp:Content>
