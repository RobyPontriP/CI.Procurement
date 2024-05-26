<%@ Page MasterPageFile="~/Procurement.Master" Language="C#" AutoEventWireup="true" CodeBehind="List.aspx.cs" Inherits="myTree.WebForms.Modules.Quotation.List" %>

<%@ Register Src="~/Usc/uscCancellationForm.ascx" TagName="cancellationform" TagPrefix="uscCancellation" %>

<asp:Content ID="Content1" ContentPlaceHolderID="AppHead" runat="server">
    <title>Quotations</title>
    <style>
        .sorting_1 {
            background-color: inherit !important;
        }
        .legend-block
        {
            min-width: 10px !important;
            min-height: 10px !important;
            padding-left: 25px;
        }
        .legend
        {
            font-size: 70%;
            clear: both;
            margin-bottom: 10px;
        }

        span.label {
            display:block;
            margin-bottom:3px;
        }

        .modal-dialog {
            margin: auto 12%;
            width: 60%;
            height: 320px !important;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="AppBody" runat="server">
    <uscCancellation:cancellationform ID="cancellationForm" runat="server" />
    <div class="floatingBox" id="error-box" style="display: none">
        <div class="alert alert-error" id="error-message">
        </div>
    </div>
    <div class="row-fluid">
        <div class="floatingBox">
            <div class="container-fluid">
                <div class="control-group">
                    <label class="control-label">
                        Created date
                    </label>
                    <div class="controls">
                        <div class="input-prepend" style="margin-right:-32px;">
                            <input type="text" name="startDate" id="_startDate" data-title="Start date" data-validation="required" class="span8" readonly="readonly" placeholder="Start date" maxlength="11" value="<%=startDate %>" />
                            <span class="add-on icon-calendar" id="startDate"></span>
                        </div>
                        To&nbsp;&nbsp;&nbsp;
                        <div class="input-prepend">
                            <input type="text" name="endDate" id="_endDate" data-title="End date" data-validation="required" class="span8" readonly="readonly" placeholder="End date" maxlength="11" value="<%=endDate %>" />
                            <span class="add-on icon-calendar" id="endDate"></span>
                        </div>
                    </div>
                </div>
                <div class="control-group">
                    <label class="control-label">
                        View by
                    </label>
                    <div class="controls">
                        <input type="hidden" id="status" name="status" value="<%=status %>"/>
                        <select id="cboStatus" data-title="Status" data-validation="required" multiple="multiple" class="span6">
                        </select>
                    </div>
                </div>
                <div class="control-group">
                    <label class="control-label">
                        Purchase office
                    </label>
                    <div class="controls">
                        <select id="cboOffice" data-title="Purchase office" data-validation="required" name="cifor_office" class="span6">
                           <% if(isMultipleOffice) { %>
                            <option value="ALL">ALL PURCHASE OFFICES</option>
                            <% } %>
                        </select>
                    </div>
                </div>
                <div class="control-group">
                    <div class="controls">
                        <button type="submit" id="btnSearch" class="btn btn-success">Search</button>
                    </div>
                </div>
                <div class="control-group">
                    <div class="span3">
                        <div class="legend" id="QuotationStatus">
                        </div>
                    </div>
                </div>
                <div class="control-group last">
                    <% if (isEditable)
                        { %>
                    <button type="button" id="btnCreate" class="btn btn-success">Create new Quotation</button>
                    <%} %>
                </div>
                <div class="control-group last">
                    <table id="tblQuotation" class="table table-bordered" style="border: 1px solid #ddd">
                        <thead>
                            <tr>
                                <th style="width:10%;">Quotation code</th>
                                <th style="width:10%;">RFQ code</th>
                                <th style="width:15%;">Created date</th>
                                <th style="width:20%;">PR code</th>
                                <th style="width:22%;">Supplier</th>
                                <th style="width:10%;">Purchase office</th>
                                <th style="width:10%;">Status</th>
                                <th style="width:3%;">Action</th>
                            </tr>
                        </thead>
                        <tbody>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
    <input type="hidden" name="action" id="action"/>
    <input type="hidden" name="doc_id" id="doc_id" value=""/>
    <input type="hidden" name="doc_type" id="doc_type" value="QUOTATION"/>
    <input type="hidden" name="file_name" id="file_name" value="" />
    <script>
        var isAdmin = "<%=isAdmin ?"true":"false"%>";
        isAdmin = (isAdmin === "true");

        var listStatus = <%=listStatus%>;
        var listOffice = <%=listOffice%>;
        var startDate = new Date("<%=startDate%>");
        var endDate = new Date("<%=endDate%>");
        var status = "<%=status%>";
        var cifor_office = "<%=cifor_office%>";

        var mainData = <%=listQuo%>;

        var QuotationTable;
        var _id = "";
        var q_no = "";

        $(document).on("click", "#btnSearch", function () {
            var errorMsg = "";
            errorMsg += GeneralValidation();

            if (errorMsg !== "") {
                showErrorMessage(errorMsg);

                return false;
            }
        });

        $(document).on("click", "#btnCreate", function () {
            location.href = "Input.aspx";
        });
        
        $(document).ready(function () {
            $("#QuotationStatus").append("<b><i>Quotation status:</i></b><br/>");
            $.each(listStatus, function (i, x) {
                if (x.status_id != "-1") {
                    $("#QuotationStatus").append("<span style='background-color:" + x.color_code + "' class='legend-block'>&nbsp;</span>&nbsp;<i>" + x.status_name + "</i><br/>");
                }
            });

            var x = status.split(",");
            var cboStatus = $("#cboStatus");
            generateCombo(cboStatus, listStatus, "status_id", "status_name", true);
            $(cboStatus).val(x);
            Select2Obj(cboStatus, "Status");

            $("#cboStatus").on('select2:select select2:unselect', function (e) {
                var sel = $(this).val();

                if (e.params.data.id == -1) {
                    sel = [-1];
                } else {
                    sel = jQuery.grep(sel, function (value) {
                        return value != '-1';
                    });
                }
                $("#cboStatus").val(sel).trigger("change");

                $("#status").val(sel.join(','));
            });

            var cboOffice = $("#cboOffice");
            //generateComboGroup(cboOffice, listOffice, "office_id", "office_name", "hub_option", true);
            generateCombo(cboOffice, listOffice, "office_id", "office_name", true);
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

            QuotationTable = $('#tblQuotation').DataTable({
                "bFilter": true, "bDestroy": true, "bRetrieve": true, "pagingType": 'full_numbers',
                "lengthMenu": [[50, 100, -1], [50, 100, "All"]],
                "fnRowCallback": function( nRow, aData, iDisplayIndex ) {  
                    $(nRow).css('background-color', aData.color_code);
                    $(nRow).css('color', aData.font_color);
                },
                "aaData": mainData,
                "aoColumns": [
                    {
                        "mDataProp": "q_no"
                        ,"mRender": function (d, type, row) {
                            var html = '<a href="<%=Page.ResolveUrl("detail.aspx?id=' + row.id + '")%>" title="View detail Quotation">' + row.q_no + '</a>';
                            return html;
                        }
                    },
                    {
                        "mDataProp": "rfq_no"
                        , "mRender": function (d, type, row) {
                            var html = '';
                            if (row.rfq_id != "0") {
                                html += '<a href="<%=Page.ResolveUrl("~/RFQ/detail.aspx?id=' + row.rfq_id + '")%>" target="_blank" title="View detail RFQ">' + row.rfq_no + '</a>';
                            }
                            return html;
                        }
                    },
                    { "mDataProp": "created_date" },
                    { "mDataProp": "pr_no" },
                    { "mDataProp": "vendor_name" },
                    { "mDataProp": "cifor_office" },
                    { "mDataProp": "status" },
                    {
                        "mDataProp": "actions"
                        , "sClass": "no-sort"
                        , "visible": isAdmin
                        , "mRender": function (d, type, row) {
                            var html = '<input name="q_no" type="hidden" value="' + row.q_no + '"/><input name="id" type="hidden" value="' + row.id + '"/>';
                            return html += row.actions;
                        }
                    },
                ],
                "columnDefs": [ {
                    "targets": [7],
                    "orderable": false,
                }],
                "aaSorting": [[2, "asc"]],
                "iDisplayLength": 50
                ,"bLengthChange": false
            });

            $('#tblQuotation_filter input').unbind();
            $('#tblQuotation_filter input').bind('keyup', function (e) {
                if (e.keyCode == 13) {
                    QuotationTable.search(this.value).draw();	
                }
            });	

            $(window).keydown(function(event){
                if(event.keyCode == 13) {
                    event.preventDefault();
                    return false;
                }
            });

            $('.isHide').hide();
        });

        $(document).on("click", ".btnEdit", function () {
            _id = $(this).closest("td").find("input[name='id']").val();
            location.href = "input.aspx?id=" + _id;
        });

        $(document).on("click", ".btnCopy", function () {
            _id = $(this).closest("td").find("input[name='id']").val();
            location.href = "input.aspx?copy_id=" + _id;
        });

        $(document).on("click", ".btnCancel", function () {
            _id = $(this).closest("td").find("input[name='id']").val();
            q_no = $(this).closest("td").find("input[name='q_no']").val();
            $("#CancelForm").modal("show");
        });

        $(document).on("click", ".btnFileUploadCancel", function () {
            $("#action").val("fileupload");

            $("#file_name").val($(this).closest("div").find("input:file").val().split('\\').pop());
            var filename = $("#file_name").val();

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

                $("#doc_id").val(_id);
                UploadFileAPI("", this, filename);
                $(this).closest("div").find("input[name$='cancellation.uploaded']").val("1");

            }
        });

        $(document).on("change", "input[name='cancellation_file']", function (e) {
            $("input[name$='cancellation.uploaded']").val("0");
        });

        $(document).on("click", "#btnSaveCancellation", function () {
            var errorMsg = "";
            if ($.trim($("#cancellation_text").val()) == "" && $.trim($("#cancellation_file").val()) == "") {
                errorMsg += "<br/> - Reason for cancellation is required.";
            }
            errorMsg += FileValidation();

            if ($("input[name='cancellation.uploaded']").val() == "0" && $("input[name='cancellation_file']").val()) {
                $("input[name='cancellation_file']").css({ 'background-color': 'rgb(245, 183, 177)' });
                errorMsg += "<br/> - Please upload file first.";
            }

            if (errorMsg == "") {
                $("#doc_id").val(_id);
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
                url: "<%=Page.ResolveUrl("~/Service.aspx")%>",
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
                url: "<%=Page.ResolveUrl("Detail.aspx/QuotationCancellation")%>",
                data: JSON.stringify(data),
                dataType: 'json',
                type: 'post',
                contentType: "application/json; charset=utf-8",
                success: function (response) {
                    var output = JSON.parse(response.d);
                    if (output.result != "success") {
                        alert(output.message);
                    } else {
                        alert("Quotation " + q_no + " has been cancelled successfully");
                        blockScreen();
                        parent.location.href = "List.aspx";
                    }
                }
            });
        }

        function UploadFileAPI(actionType, row, filename) {
            if (actionType == '') {
                blockScreenOL();
            }
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
                    if (actionType == '') {
                        unBlockScreenOL();
                    }
                    var stringJS = '{' + response.substring(
                        response.indexOf("{") + 1,
                        response.lastIndexOf("}")
                    ) + '}';
                    var output = JSON.parse(stringJS);

                    if (actionType != "submit") {
                        if (output.result == '') {
                            GenerateCancelFileLink(row, filename);
                        } else {
                            alert('Upload file failed');
                        }
                    } else {
                        alert("Request has been " + btnAction + " successfully.");
                        if (btnAction === "saved") {
                            if ($("[name='pr.id']").val() == "") {
                                location.href = "input.aspx?id=" + output.id;
                            } else {
                                location.reload();
                            }
                        } else {
                            location.href = "/workspace/mysubmissions";
                        }
                    }
                }
            });

            $("#file_name").val("");
        }

    </script>
</asp:Content>
