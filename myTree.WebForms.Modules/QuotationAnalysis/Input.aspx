<%@ Page MasterPageFile="~/Procurement.Master" Language="C#" AutoEventWireup="true" CodeBehind="Input.aspx.cs" Inherits="myTree.WebForms.Modules.VendorSelection.Input" %>
<%@ Register Src="~/Usc/uscRecentComment.ascx" TagName="recentcomment" TagPrefix="uscComment" %>
<%@ Register Src="~/QuotationAnalysis/uscSearchItem.ascx" TagName="searchitem" TagPrefix="uscSearchItem" %>
<%@ Register Src="~/Usc/uscCancellationForm.ascx" TagName="cancellationform" TagPrefix="uscCancellation" %>
<asp:Content ID="Content1" ContentPlaceHolderID="AppHead" runat="server">
    <title>Quotation Analysis</title>
    <style>
        .select2 {
            min-width: 50px !important;
        }

        .textRight {
            text-align: right !important;
        }

        .modal-dialog {
            height: 520px !important;
        }

        #CancelForm.modal-dialog {
            margin: auto 12% !important;
            width: 60% !important;
            height: 320px !important;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="AppBody" runat="server">
    <input type="hidden" id="status" value="<%=VS.status_id %>"/>
    
    <!-- for upload file -->
    <input type="hidden" name="action" id="action" value=""/>
    <input type="hidden" id="vs_id" name="doc_id" value="<%=VS.id %>"/>
    <input type="hidden" name="doc_type" value="QUOTATION ANALYSIS"/>
    <input type="hidden" name="docidtemp" value="" />
    <!-- end of upload file -->

    <div class="floatingBox" id="error-box" style="display: none">
        <div class="alert alert-error" id="error-message">
        </div>
    </div>

    <!-- Cancellation Form -->
    <uscCancellation:cancellationform ID="cancellationForm" runat="server" />

    <!-- Recent comment -->
    <uscComment:recentcomment ID="recentComment" runat="server" />

    <uscSearchItem:searchitem ID="searchItem1" runat="server" />

    <input type="hidden" id="vs_no" value="<%=VS.vs_no%>"/>
    <input type="hidden" id="currency_id" value="<%=VS.currency_id %>"/>
    <input type="hidden" id="exchange_sign" value="<%=VS.exchange_sign %>"/>
    <input type="hidden" id="exchange_rate" value="<%=VS.exchange_rate %>"/>
    <input type="hidden" name="file_name" id="file_name" value="" />
    
    <div class="row-fluid">
        <div class="floatingBox">
            <div class="container-fluid">
                <%  if (!String.IsNullOrEmpty(VS.vs_no))
                    {  %>
                <div class="control-group">
                    <label class="control-label">Quotation analysis code</label>
                    <div class="controls labelDetail">
                        <b><%=VS.vs_no %></b>
                    </div>
                </div>
                <div class="control-group">
                    <label class="control-label">Quotation analysis status</label>
                    <div class="controls labelDetail">
                        <b><%=VS.status_name %></b>
                    </div>
                </div>
                <%  } %>
                <div class="control-group required">
                    <label class="control-label">Quotation analysis date</label>
                    <div class="controls">
                        <div class="input-prepend" style="margin-right:-32px;">
                            <input type="text" name="vs.document_date" id="_document_date" data-validation="date required" data-title="Quotation Analysis date" class="span8" readonly="readonly" placeholder="Quotation analysis date" maxlength="11" value="<%=VS.document_date%>"/>
                            <% if (VS.status_name == "DRAFT" || VS.status_name == "REVISED" || String.IsNullOrEmpty(VS.status_name))
                            {  %>
                            <span class="add-on icon-calendar" id="document_date"</span>
                            <% } %>
                        </div>  
                    </div>
                </div>
                <div class="control-group required">
                    <label class="control-label">Target currency</label>
                    <div class="controls">
                       <select name="target.currency"  id="target.currency" class="span2" data-validation="required" data-title="Target currency"></select>
                        &nbsp;&nbsp;Exchange rate (to USD)
                         <div class="input-prepend">
                                    <input type="hidden" name="target.exchange_sign" value="">
                                    <input type="text" name="target.exchange_rate" class="span6 number" data-decimal-places="8" value="" readonly/>
                                </div>
                    </div>
                </div>           
                <div class="control-group required" id="item">
                    <label class="control-label">Product(s)</label>
                    <div class="controls">
                        <button class="btn btn-success" type="button" id="btnAdd">Add product</button>
                    </div>
                </div>
                <div class="control-group">
                    <div style="width: 100%; overflow-x: auto; display: block;">
                        <table id="tblVSItem" data-title="Product(s)" class="table table-bordered table-hovered required" style="border: 1px solid #ddd;">
                            <thead></thead>
                            <tbody></tbody>
                            <tfoot></tfoot>
                        </table>
                        <br />
                    </div>
                </div>
                <div class="control-group">
                    <label class="control-label">
                        Supporting document(s)
                    </label>
                    <div class="controls">
                        <table id="tblAttachment" data-title="Supporting document(s)" class="table table-bordered table-hover" style="border: 1px solid #ddd">
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
                        <p><button id="btnAddAttachment" class="btn btn-success" type="button" data-toggle="modal">Add supporting document</button></p>
                    </div>
                </div>
                <div class="control-group last">
                    <div class="controls">
                        <button id="btnClose" class="btn" type="button">Close page</button>&nbsp;&nbsp;&nbsp;
                        <%  if (VS.status_id == "5" || String.IsNullOrEmpty(VS.status_id))
                            { %>
                            <button id="btnSave" class="btn btn-success" type="button" data-action="saved">Save as draft</button>
                        
                        <%  } %>
                            <button id="btnSubmit" class="btn btn-success" type="button" data-action="<%=(VS.status_id=="5" || String.IsNullOrEmpty(VS.status_id))?"submitted":"updated" %>">
                            <%=(VS.status_id=="5" || String.IsNullOrEmpty(VS.status_id))?"Submit":"Update" %></button>
                        <%  if (max_status != "50")
                            { %>					
						  
                        <%  if (max_status == "25")
                            { %>
                        <button id="btnCancel" class="btn btn-danger" type="button" data-action="cancelled">Cancel this Quotation analysis</button>
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
        var _id = "<%= _id %>";
        var btnAction = "";
        var workflow = new Object();

        var listCurrency = <%=listCurrency%>;
        var listAttachment = <%=listAttachment%>;
        var cifor_office = "<%=cifor_office%>";
        var userOffice = "<%=user_office%>";

        var dataQuotation = [];
        var usedPRItems = [];
        var vsItems = <%=vsItems%>;
        var vsItemsOriginal = <%=vsItems%>
        var vsItemsMain = <%=vsItemsMain%>;
        var vsItemsMainOriginal = <%=vsItemsMain%>;
        var listChargeCode = <%=listChargeCode%>;

        /* Business partner selection variables */
        var headerArr = [];
        var detailSupport = [];
        /* end of Business partner selection variables */
        var listCurrencyItems = [];
        var additionalDiscountVendor = "";

        var vendor_ids = [];
        var deletedId = [];

        var QuoResults = initTable();
        var QuoResultsRFQ = initTableRFQ();

        var _document_date = "<%=VS.document_date%>"

        var tblExchangeRate = <%=tblExchangeRate%>;

        var currstatus_id = "<%=VS.status_id %>";

        var dataSundry = <%= listSundry %>;

        var filenameupload = "";
        var btnFileUpload = null;
        var _currency = "";

        var target_currency = "<%= VS.currency_id%>";
        var target_exchange_sign = "<%= VS.exchange_sign%>";
        var target_exchange_rate = "<%= VS.exchange_rate%>";

        var isExistingData_ = "<%=isExistingData?"true":"false"%>";
        isExistingData_ = (isExistingData_ === "true");

        function initTable() {
            var __tableSearch = null;
            var groupColumn = 1;
            __tableSearch = $('#SearchItem').DataTable({
                data: dataQuotation,
                "order": [[groupColumn, 'asc']],
                "aoColumns": [
                    {
                        "mDataProp": "pr_detail_id"
                        , "mRender": function (d, type, row) {
                            var html = '<input type="checkbox" name="item" value="' + row.pr_detail_id + '" data-vendors="' + row.vendor_ids + '" data-currencies="' + row.currency_ids + '"/>';
                            return html;
                        }
                        , "width": "4%"
                    },
                    {
                        "mDataProp": "pr_id"
                        , "width": "1%"
                        , "visible": false
                    },
                    {
                        "mDataProp": "item_code"
                        , "width": "20%"
                    },
                    {
                        "mDataProp": "item_description"
                        , "mRender": function (d, type, row) {
                            return row.item_description;
                        }
                        , "width": "40%"
                    },
                    {
                        "mDataProp": "pr_quantity"
                        , "mRender": function (d, type, row) {
                            return accounting.formatNumber(row.pr_quantity, 2);
                        }
                        , "width": "10%"
                        , "className": "textRight"
                    },
                    {
                        "mDataProp": "pr_estimated_cost"
                        , "mRender": function (d, type, row) {
                            return accounting.formatNumber(row.pr_estimated_cost, 2);
                        }
                        , "width": "15%"
                        , "className": "textRight"
                    },
                    {
                        "mDataProp": "pr_estimated_cost_usd"
                        , "mRender": function (d, type, row) {
                            return accounting.formatNumber(row.pr_estimated_cost_usd, 2);
                        }
                        , "width": "10%"
                        , "className": "textRight"
                    }
                ]
                , "bFilter": false, "bSort": false, "bDestroy": true, "bRetrieve": true, "paging": false
                , "iDisplayLength": 100
                , "bLengthChange": false
                , "searching": false
                , "info": false
                , "drawCallback": function (settings) {
                    var api = this.api();
                    var rows = api.rows({ page: 'current' }).nodes();
                    var last = null;
                    api.column(groupColumn, { page: 'current' }).data().each(function (group, i) {
                        if (last !== group) {
                            var rowData = api.row(i).data();
                            var pr_id = rowData["pr_id"];
                            $(rows).eq(i).before(
                                '<tr class="group"><td colspan="6">' +
                                '<table class="table table-bordered" style="border: 1px solid #ddd;"><tr>' +
                                '<th class="green" style="width:7%;">PR code</th>' +
                                '<th style="width:10%;"><a href="<%=Page.ResolveUrl("~/purchaserequisition/detail.aspx?id=' + pr_id + '")%>" target = "_blank" > ' + rowData["pr_no"] + '</a ></th>' +
                                '<th style="width:13%;" class="green">Submitted date</th>' +
                                '<th style="width:10%;">' + rowData["pr_submission_date"] + '</th>' +
                                '<th style="width:10%;"class="green">Initiator</th>' +
                                '<th style="width:20%;">' + rowData["initiator"] + '</th>' +
                                '<th style="width:10%;" class="green">Requester</th>' +
                                '<th style="width:20%;">' + rowData["requester"] + '</th ></tr ></table></td></tr>'
                            );
                            last = group;
                        }
                    });
                }
            });
            
            return __tableSearch; 
        }

        function initTableRFQ() {
            var __tableSearch = null;
            var groupColumn = 0;
            __tableSearch = $('#SearchItem2').DataTable({
                data: dataQuotation,
                "order": [[groupColumn, 'asc']],
                "aoColumns": [
                    {
                        "mDataProp": "rfq_reff"
                        ,"visible":false
                    },
                    {
                        "mDataProp": "rfq_no"
                        , "mRender": function (d, type, row) {
                            var html = "";
                            if (row.rfq_id == "0") {
                                html = row.rfq_reff;
                            } else {
                                html = '<a href="<%=Page.ResolveUrl("~/rfq/detail.aspx?id=' + row.rfq_id + '")%>" target="_blank">' + row.rfq_no + '</a>';
                            }
                            return html;
                        }
                        , "width": "15%"
                    },
                    {
                        "mDataProp": "q_no"
                        , "mRender": function (d, type, row) {
                            var html = '<a href="<%=Page.ResolveUrl("~/quotation/detail.aspx?id=' + row.q_id + '")%>" target="_blank">'+row.q_no+'</a>';
                            return html;
                        }
                        , "width": "15%"
                    },
                    {
                        "mDataProp": "q_no"
                        , "mRender": function (d, type, row) {
                            var html = row.vendor_name
                            return html;
                        }
                        , "width": "50%"
                    },
                    {
                        "mDataProp": "total_quotation"
                        , "mRender": function (d, type, row) {                            
                            var grandTotal = "";
                            var quotes = $.grep(dataQuotation.Table1, function (n, i) {
                                return n["q_id"] == row.q_id;
                            });
                            $.each(quotes, function (i, d) {
                                var total_cost = delCommas(d.q_cost) - delCommas(d.q_total_discount);
                                if (d.q_currency_id != null && d.q_currency_id != "") {
                                    grandTotal +=  d.q_currency_id + " " + accounting.formatNumber(delCommas(total_cost), 2) + "</br>";
                                } else {
                                    grandTotal += accounting.formatNumber(delCommas(total_cost), 2) + "</br>";
                                }
                            });

                            return grandTotal;
                        }
                        , "width": "20%"
                    }
                ]
                , "bFilter": false, "bSort": false, "bDestroy": true, "bRetrieve": true, "paging": false
                , "iDisplayLength": 100
                , "bLengthChange": false
                , "searching":false
                , "info": false
                , "drawCallback": function (settings) {
                    var api = this.api();
                    var rows = api.rows({ page: 'current' }).nodes();
                    var last = null;
                    api.column(groupColumn, { page: 'current' }).data().each(function (group, i) {
                        if (last !== group) {
                            var rowData = api.row(i).data();
                            var rfq_reff = "No RFQ";
                            if (rowData.rfq_reff != null
                                && rowData.rfq_reff != "null"
                                && rowData.rfq_reff != ""
                                && typeof rowData.rfq_reff !== "undefined") {
                                rfq_reff = rowData.rfq_reff;
                            } 
                            $(rows).eq(i).before(
                                '<tr class="group"><td colspan="6" class="green"><b>' + rfq_reff + '<b></tr>'
                            );
                            last = group;
                        }
                    });
                }
                , "columnDefs": [
                    {
                        targets: [4],
                        className: 'dt-body-right'
                    }
                ]
            });
            
            return __tableSearch; 
        }

        $(document).ready(function () {
            //populate terget currency
            if (target_currency == "" || typeof target_currency == "undefined") {
                populateCurrency();
            } else {
                //current target currency
                var data = $.grep(listCurrency, function (n, i) {
                    return n["CURRENCY_CODE"] == target_currency;
                });

                $("[name='target.exchange_rate']").val(target_exchange_rate.replaceAll(",","."))
                $("[name='target.exchange_sign']").val(target_exchange_sign)

                var cboCurr = $("select[name='target.currency");
                generateCombo(cboCurr, listCurrency, "CURRENCY_CODE", "CURRENCY_CODE", true);
                $(cboCurr).val(target_currency);
                Select2Obj(cboCurr, "Currency");

            }


            //create detail charge code;
            setdetailcc();
            $("#document_date").datepicker({
                format: "dd M yyyy"
                , autoclose: true
            }).on("changeDate", function () {
                $("#_document_date").val($("#document_date").data("date"));
                $("#document_date").datepicker("hide");

                getExchangeRate($("#currency_id").val(), $("#_document_date").val())
                    .then(calculateTotal);
            });

            if (_document_date != "") {
                $("#document_date").datepicker("setDate", new Date(_document_date)).trigger("changeDate");
            }



            PopulateVSItem();
            populateUsedItems();
            populateVendorIds();
            //populateCurrencyIds();

            $.each(listAttachment, function (i, d) {
                addAttachment(d.id, "", d.file_description, d.filename);
            });

            if (($("#status").val() == "50") || ($("#status").val() == "25")) {
                document.getElementById("item").style.display = 'none';
            }

            $("[name='docidtemp']").val(guid());

            if ((currstatus_id == "25" && (vsItemsMain[0]['singlesourcing'] != "0" && vsItemsMain[0]['singlesourcing'] != null)) || currstatus_id == "50") {
                $("[name='target.currency']").attr("disabled", true);
            }

            if (currstatus_id == "50") {
                $(".icon-calendar").hide();
            }

            populateDataPerVendor();
        });

        function loadItem() {
            var data = {
                "used_items": usedPRItems.join(";")
                , "vendor_ids": vendor_ids.join(";")
                , "currency_ids": ''//currency_ids.join(";")
                , "date": $("#_document_date").val()
                , "startdate": $("#_startDate").val()
                , "enddate": $("#_endDate").val()
                , "search": $("#_search").val()
                , "cifor_office": userOffice
            }
            $("#loadingformitem").show();
            $("#SearchItem").hide();
            $("#SearchItem2").hide();

            $.ajax({
                url: "<%=Page.ResolveUrl("~/Service.aspx/GetVendorSelectionItem")%>",
                data: JSON.stringify(data),
                dataType: 'json',
                type: 'post',
                contentType: "application/json; charset=utf-8",
                success: function (response) {
                    $("#loadingformitem").hide();
                    var viewVS = $("[name='viewVS']:checked").val();
                    dataQuotation = JSON.parse(response.d);

                    $.each(usedPRItems, function (i, detail_id) {
                        var idx = dataQuotation.Table.findIndex(x => x.pr_detail_id == detail_id);
                        if (idx != -1) {
                            dataQuotation.Table.splice(idx, 1);
                        }
                    }); 

                    if (viewVS == "2") {
                        $("#SearchItem").show();
                        QuoResults.clear().draw();
                        QuoResults.rows.add(dataQuotation.Table).draw();
                        OpenAllChilds();
                    } else if (viewVS == "1") {
                        $("#SearchItem2").show();
                        QuoResultsRFQ.clear().draw();
                        QuoResultsRFQ.rows.add(dataQuotation.Table2).draw();
                        OpenAllChildsRFQ();
                    }
                }
            });
        }

        function OpenAllChilds() {
            $.each(QuoResults.rows().nodes(), function (i) {
                var row = QuoResults.row(i)
                if (typeof row.data() !== "undefined" && typeof row.data()["pr_detail_id"] !== "undefined"){
                    if (!row.child.isShown()) {
                        row.child(format(row.data())).show();
                        $(row.node()).addClass('shown');
                    }
                }
            });
        }

        function format(d) {
            var quotes = $.grep(dataQuotation.Table1, function (n, i) {
                return n["pr_detail_id"] == d.pr_detail_id;
            });
            var html = '<table class="table table-bordered table-hover" style="border: 1px solid #ddd">';
            html += '<thead><tr><th>RFQ reff.</th>';
            html += '<th>Quotation code</th>';
            html += '<th>Supplier name</th>';
            html += '<th style="text-align:right;">Quantity</th>';
            html += '<th>Currency</th>';
            html += '<th style="text-align:right;">Unit price</th>';
            html += '<th style="text-align:right;">Discount</th>';
            html += '<th style="text-align:right;">Total</th>';
            html += '<th style="text-align:right;">Total (in USD)</th>';
            html += '</thead><tbody>';

            $.each(quotes, function (i, d) {
                var total_cost = delCommas(d.q_cost) - delCommas(d.q_total_discount);
                var ref = "";
                if (d.rfq_reff != null && d.rfq_reff != "" && typeof d.rfq_reff !== "undefined") {
                    ref = d.rfq_reff;
                }

                var rfq_link = "";
                if (d.rfq_id != "" && d.rfq_id != "0") {
                    rfq_link = '<a href="<%=Page.ResolveUrl("~/rfq/detail.aspx?id=' + d.rfq_id + '")%>" target="_blank">' + ref + '</a>';
                } else {
                    rfq_link = ref;
                }

                html += '<tr><td>' + rfq_link + '</td>';
                html += '<td><a href="<%=Page.ResolveUrl("~/quotation/detail.aspx?id=' + d.q_id + '")%>" target="_blank">' + d.q_no + '</a></td>';
                html += '<td>'+d.vendor_name+'</td>';
                html += '<td style="text-align:right;">' + accounting.formatNumber(delCommas(d.q_quantity), 2) + '</td>';
                html += '<td>' + d.q_currency_id + '</td>';
                html += '<td style="text-align:right;">' + accounting.formatNumber(delCommas(d.q_unit_price), 2) + '</td>';
                html += '<td style="text-align:right;">' + accounting.formatNumber(delCommas(d.q_total_discount), 2) + '</td>';
                html += '<td style="text-align:right;">' + accounting.formatNumber(delCommas(total_cost), 2) + '</td>';
                html += '<td style="text-align:right;">' + accounting.formatNumber(delCommas(d.q_cost_usd), 2) + '</td>';
                html += '</tr >';
            });
            html += '</tbody></table>';
            return '<div class="span1"></div><div class="span11">' + html + '</div>';
        }

        function OpenAllChildsRFQ() {
            $.each(QuoResultsRFQ.rows().nodes(), function (i) {
                var row = QuoResultsRFQ.row(i)
                if (typeof row.data() !== "undefined" && typeof row.data()["q_id"] !== "undefined"){
                    if (!row.child.isShown()) {
                        row.child(formatRFQ(row.data())).show();
                        $(row.node()).addClass('shown');
                    }
                }
            });
        }

        function formatRFQ(d) {
            var quotes = $.grep(dataQuotation.Table1, function (n, i) {
                return n["q_id"] == d.q_id;
            });

            var html = '<table class="table table-bordered table-hover" style="border: 1px solid #ddd">';
            html += '<thead><tr><th>&nbsp;</th><th>Product code</th>';
            html += '<th>PR description</th>';
            html += '<th style="text-align:right;">Quantity</th>';
            html += '<th style="text-align:right;">Unit price</th>';
            html += '<th style="text-align:right;">Discount</th>';
            html += '<th style="text-align:right;">Total</th>';
            html += '<th style="text-align:right;">Total (in USD)</th>';
            html += '</thead><tbody>';

            $.each(quotes, function (i, d) {
                var items = $.grep(dataQuotation.Table, function (n, i) {
                    return n["pr_detail_id"] == d.pr_detail_id;
                });

                var _item_code = "";
                var _description = "";

                $.each(items, function (j, l) {
                    _item_code = l.item_code;
                    _description = l.item_description;
                });

                var total_cost = delCommas(d.q_cost) - delCommas(d.q_total_discount);
                if (d.q_currency_id == null) {
                    d.q_currency_id = "";
                }
           
                html += '<tr>';
                html += '<td><input type="checkbox" name="itemRFQ" value="' + d.qd_id + '" data-vendor="' + d.vendor + '" data-currency="' + d.q_currency_id + '" data-pr_detail_id="' + d.pr_detail_id + '"/></td>';
                html += '<td>' + _item_code + '</td>';
                html += '<td>' + _description + '</td>';
                html += '<td style="text-align:right;">' + accounting.formatNumber(delCommas(d.q_quantity), 2) + '</td>';
                html += '<td style="text-align:right;">' + d.q_currency_id + ' ' + accounting.formatNumber(delCommas(d.q_unit_price), 2) + '</td>';
                html += '<td style="text-align:right;">' + d.q_currency_id + ' ' + accounting.formatNumber(delCommas(d.q_total_discount), 2) + '</td>';
                html += '<td style="text-align:right;">' + d.q_currency_id + ' ' + accounting.formatNumber(delCommas(total_cost), 2) + '</td>';
                html += '<td style="text-align:right;">' + accounting.formatNumber(delCommas(d.q_cost_usd), 2) + '</td>';
                html += '</tr >';
            });
            html += '</tbody></table>';
            return '<div class="span1"></div><div class="span11">' + html + '</div>';
        }

        $(document).on("click", "#btnAdd", function () {
            if ($.trim($("#_document_date").val()) == "") {
                alert("Please set quotation analysis date.");
            } else {
                ResetItemForm();
                loadItem();
                $("#ItemForm").modal("show");
            }
        });

        $(document).on("click", "#btnRefresh", function () {
            loadItem();
        });

        function ResetItemForm() {
            $("#SearchItem tbody").html("");
            $("#SearchItem2 tbody").html("");
            $("#itemform-error-box").hide();
        }

        $(document).on("click", "#btnSelectItem", function () {
            var errorMsg = "";
            var currExchange = [];
            var _vendor_ids = [];

            var totalCheck = 0;

            if (vendor_ids.length > 0) {
                _vendor_ids.push(vendor_ids.join(";"));
            }

            var viewVs = $("[name='viewVS']:checked").val();
            if (viewVs == "2") {
                $("[name='item']:checkbox:checked").each(function (i, d) {
                    _vendor_ids.push($(this).data("vendors"));
                    totalCheck++;
                });
            } else if (viewVs == "1") {
                var validateItemRFQ = [];
                var pr_ids = [];
                $("[name='itemRFQ']:checkbox:checked").each(function (i, d) {
                    pr_ids.push($(this).data("pr_detail_id"));

                    var _valid = new Object({
                        pr_detail_id: $(this).data("pr_detail_id")
                        , qd_id: $(this).val()
                        , currency: $(this).data("currency")
                        , vendor: $(this).data("vendor")
                        , unique: $(this).data("vendor") + '|' + $(this).data("currency")
                    });
                    validateItemRFQ.push(_valid);
                    totalCheck++;
                });

                pr_ids = unique(pr_ids);
                pr_valid = [];

                $.each(pr_ids, function (i_pr, d_pr) {
                    var vendorPR = [];

                    var totalVRFQ = $.grep(validateItemRFQ, function (n, i) {
                        return n["pr_detail_id"] == d_pr;
                    });

                    $.each(totalVRFQ, function (i_tpr, d_tpr) {
                        vendorPR.push(d_tpr.vendor);
                    });

                    vendorPR = unique(vendorPR);

                    pr_valid.push({
                        pr_detail_id: d_pr
                        , total_items: totalVRFQ.length
                        , total_vendors: vendorPR.length
                        , vendors: vendorPR.join(";")
                    });
                });

                var countErrorItems = 0;
                var countErrorVendors = 0;

                var totalItems = 0;
                var totalVendors = 0;

                var vendors = "";

                $.each(pr_valid, function (i_prv, d_prv) {
                    if (totalItems == 0) {
                        totalItems = d_prv.total_items;
                    }
                    if (totalVendors == 0) {
                        totalVendors = d_prv.total_vendors;
                    }
                    if (vendors == "") {
                        vendors = d_prv.vendors;
                    }

                    _vendor_ids.push(d_prv.vendors);

                    if (totalItems != d_prv.total_items) {
                        countErrorItems++;
                    }
                    if (vendors != d_prv.vendors) {
                        countErrorVendors++;
                    }
                });

                if (countErrorItems) {
                    errorMsg += "<br/> - Cannot select different product combination(s).";
                }
            }

            if (totalCheck == 0) {
                errorMsg += "<br/> - Item(s) required."
            }

            _vendor_ids = unique(_vendor_ids);
            if (_vendor_ids.length > 1) {
                errorMsg += "<br/> - Cannot combine product(s) with different quotation's supplier.";
            }

            if (errorMsg !== "") {
                errorMsg = "Please correct the following error(s):" + errorMsg;

                $("#itemform-error-message").html("<b>" + errorMsg + "<b>");
                $("#itemform-error-box").show();
                $('.modal-body').animate({ scrollTop: 0 }, 500);
            }
            else {
                if (vsItems.length == 0) {
                    $("#tblVSItem thead").html("");
                    $("#tblVSItem tbody").html("");
                    $("#tblVSItem tfoot").html("");
                }
                var selectionItems = [];
                if (viewVs == "2") {
                    $("[name='item']:checkbox:checked").each(function (i, d) {
                        var pr_detail_id = $(this).val();

                        var mn = $.grep(dataQuotation.Table, function (n, i) {
                            return n["pr_detail_id"] == pr_detail_id;
                        });

                        var dt = $.grep(dataQuotation.Table1, function (n, i) {
                            return n["pr_detail_id"] == pr_detail_id;
                        });

                        var vm = new Object();
                        vm.item_code = mn[0].item_code;
                        vm.item_description = mn[0].item_description;
                        vm.pr_no = mn[0].pr_no;
                        vm.pr_id = mn[0].pr_id;
                        vm.cost_center_id = mn[0].pr_cost_center_id + ' / ' + mn[0].pr_t4;
                        vm.pr_quantity = mn[0].pr_quantity;
                        vm.pr_currency = mn[0].pr_currency;
                        vm.pr_unit_price = mn[0].pr_unit_price;
                        vm.uom = mn[0].qd_uom;
                        vm.pr_detail_id = pr_detail_id;
                        vm.qd_description = mn[0].qd_description;
                        vm.pr_currency_original = mn[0].pr_currency_original;
                        vm.pr_unit_price_original = mn[0].pr_unit_price_original;

                        var cc = $.grep(dataQuotation.Table4, function (n, i) {
                            return n["pr_detail_id"] == pr_detail_id;
                        });

                        vm.detail_chargecode = cc;

                        vsItemsMain.push(vm);

                        $.each(dt, function (i, d) {
                            cifor_office = d.cifor_office_id;
                            var vd = new Object();
                            vd.id = "";
                            vd.uid = guid();
                            vd.vendor = d.vendor;
                            vd.vendor_code = d.vendor_code;
                            vd.vendor_name = d.vendor_name;
                            vd.quotation_detail_id = d.qd_id;
                            vd.q_no = d.q_no;
                            vd.q_id = d.q_id;
                            vd.currency_id = d.q_currency_id;
                            vd.currency_id_original = d.q_currency_id_original;
                            vd.exchange_rate = d.q_exchange_rate;
                            vd.exchange_sign = d.q_exchange_sign;
                            currExchange.push(vd.currency_id);
                            vd.unit_price = d.q_unit_price;
                            vd.unit_price_original = d.q_unit_price_original;
                            vd.unit_price_usd = d.q_unit_price_usd
                            vd.pr_detail_id = pr_detail_id;
                            vd.source_quantity = d.q_quantity;
                            vd.uom_id = d.qd_uom_id;
                            vd.uom = d.qd_uom;
                            vd.quantity = d.q_quantity;
                            vd.discount = d.q_total_discount;
                            vd.qd_discount_original = d.q_total_discount;
                            vd.discount_usd = d.q_total_discount_usd;
                            vd.cost = delCommas(accounting.formatNumber(d.q_cost, 2));
                            vd.cost_usd = delCommas(d.q_cost_usd);
                            vd.cost_original = delCommas(d.q_cost_original);
                            vd.line_total = d.q_line_total;//delCommas(accounting.formatNumber(vd.cost - vd.discount, 2));//delCommas(d.q_cost) - delCommas(d.q_total_discount);
                            vd.line_total_usd = delCommas(accounting.formatNumber(d.q_cost_usd, 2));
                            vd.indent_time = d.q_indent_time;
                            vd.warranty_time = d.q_warranty;
                            vd.expected_delivery_date = "";
                            vd.is_selected = 0;
                            vd.reason_for_selection = "";
                            vd.remarks = "";
                            vd.justification_file = "";
                            vd.procurement_balance = d.procurement_balance;
                            if (vd.source_quantity > vd.procurement_balance) {
                                vd.max_quantity = vd.procurement_balance;
                            } else {
                                vd.max_quantity = vd.source_quantity;
                            }
                            vd.pr_id = d.pr_id;
                            vd.pr_no = d.pr_no;
                            vd.supplier_address = d.supplier_address;
                            vd.qd_description = d.qd_description;
                            vd.is_sundry = d.is_sundry;

                            var cc = $.grep(dataQuotation.Table4, function (n, i) {
                                return n["pr_detail_id"] == pr_detail_id;
                            });

                            vd.detail_chargecode = cc;

                            vsItems.push(vd)
                        });
                    });
                } else if (viewVs == "1") {
                    var pr_ids = [];
                    $("[name='itemRFQ']:checkbox:checked").each(function (i, d) {
                        var pr_detail_id = $(this).data("pr_detail_id");
                        pr_ids.push(pr_detail_id);

                        var qd_id = $(this).val();

                        var dt = $.grep(dataQuotation.Table1, function (n, i) {
                            return n["qd_id"] == qd_id;
                        });

                        $.each(dt, function (i, d) {
                            cifor_office = d.cifor_office_id;
                            var vd = new Object();
                            vd.id = "";
                            vd.uid = guid();
                            vd.vendor = d.vendor;
                            vd.vendor_code = d.vendor_code;
                            vd.vendor_name = d.vendor_name;
                            vd.quotation_detail_id = d.qd_id;
                            vd.q_no = d.q_no;
                            vd.q_id = d.q_id;
                            vd.currency_id = d.q_currency_id;
                            vd.currency_id_original = d.q_currency_id_original;
                            vd.exchange_rate = d.q_exchange_rate;
                            vd.exchange_sign = d.q_exchange_sign;
                            currExchange.push(vd.currency_id);
                            vd.unit_price = d.q_unit_price;
                            vd.unit_price_original = d.q_unit_price_original;
                            vd.unit_price_usd = d.q_unit_price_usd
                            vd.pr_detail_id = pr_detail_id;
                            vd.source_quantity = d.q_quantity;
                            vd.uom_id = d.qd_uom_id;
                            vd.uom = d.qd_uom;
                            vd.quantity = d.q_quantity;
                            vd.discount = d.q_total_discount;
                            vd.qd_discount_original = d.q_total_discount;
                            vd.discount_usd = d.q_total_discount_usd;
                            vd.cost = delCommas(accounting.formatNumber(d.q_cost, 2));
                            vd.cost_usd = delCommas(d.q_cost_usd);
                            vd.cost_original = delCommas(d.q_cost_original);
                            vd.line_total = d.q_line_total;//d.q_cost - d.q_total_discount;//delCommas(d.q_cost) - delCommas(d.q_total_discount);
                            vd.line_total_usd = delCommas(accounting.formatNumber(d.q_cost_usd, 2));
                            vd.indent_time = d.q_indent_time;
                            vd.warranty_time = d.q_warranty;
                            vd.expected_delivery_date = "";
                            vd.is_selected = 0;
                            vd.reason_for_selection = "";
                            vd.remarks = "";
                            vd.justification_file = "";
                            vd.procurement_balance = d.procurement_balance;
                            if (vd.source_quantity > vd.procurement_balance) {
                                vd.max_quantity = vd.procurement_balance;
                            } else {
                                vd.max_quantity = vd.source_quantity;
                            }
                            vd.pr_id = d.pr_id;
                            vd.pr_no = d.pr_no;
                            vd.supplier_address = d.supplier_address;
                            vd.qd_description = d.qd_description;
                            vd.is_sundry = d.is_sundry;
                            var cc = $.grep(dataQuotation.Table4, function (n, i) {
                                return n["pr_detail_id"] == pr_detail_id;
                            });

                            vd.detail_chargecode = cc;

                            vsItems.push(vd);
                        });
                    });

                    pr_ids = unique(pr_ids);
                    $.each(pr_ids, function (ipr, dr) {
                        var mn = $.grep(dataQuotation.Table, function (n, i) {
                            return n["pr_detail_id"] == dr;
                        });

                        var vm = new Object();
                        vm.item_code = mn[0].item_code;
                        vm.item_description = mn[0].item_description;
                        vm.pr_no = mn[0].pr_no;
                        vm.pr_id = mn[0].pr_id;
                        vm.cost_center_id = mn[0].pr_cost_center_id + ' / ' + mn[0].pr_t4;
                        vm.pr_quantity = mn[0].pr_quantity;
                        vm.pr_currency = mn[0].pr_currency;
                        vm.pr_unit_price = mn[0].pr_unit_price;
                        vm.uom = mn[0].qd_uom;
                        vm.pr_detail_id = dr;
                        vm.qd_description = mn[0].qd_description;
                        vm.pr_currency_original = mn[0].pr_currency_original;
                        vm.pr_unit_price_original = mn[0].pr_unit_price_original;

                        var cc = $.grep(dataQuotation.Table4, function (n, i) {
                            return n["pr_detail_id"] == dr;
                        });
                        vm.detail_chargecode = cc;

                        vsItemsMain.push(vm);
                    });

                }


                vendor_ids = _vendor_ids;
                $("#ItemForm").modal("hide");

                $("#tblVSItem tbody").html("");

                currExchange = unique(currExchange);
                currExchange = currExchange.join(";");

                $("#currExchange").val(currExchange);


                //getExchangeRate(currExchange, $("[name='vs.document_date']").val())
                //    .then(PopulateVSItem)
                //    .then(populateUsedItems)
                //    .then(populateVendorIds);
                getExchangeRate(currExchange, $("[name='vs.document_date']").val())
                    .then(PopulateVSItem)
                    .then(populateUsedItems)
                    .then(populateVendorIds)
                    .then(populateDetailSupport)
                    .then(populateDataPerVendor);
                    //.then(populateCurrencyIds);
                //PopulateVSItem();
                //populateUsedItems();
                //populateVendorIds();
                //populateCurrencyIds();

                //populateDataPerVendor();
            }

       
        });

        function getExchangeRate(curr, date) {
            var curr_list = [];
            $.each(vsItems, function (i, z) {
                curr_list.push(z.currency_id);
            });
            curr = unique(curr_list);
            curr = curr.join(";");

            return $.ajax({
                url: "<%=Page.ResolveUrl("~/Service.aspx/GetSpecificExchangeRate")%>",
                data: JSON.stringify({
                    destination: "",
                    source: curr,
                    date: date
                }),
                dataType: 'json',
                type: 'post',
                contentType: "application/json; charset=utf-8",
                success: function (response) {
                    tblExchangeRate = JSON.parse(response.d);

                    $.each(vsItems, function (i, z) {
                        var x = $.grep(tblExchangeRate, function (n, j) {
                            return n["CURRENCY_ID"] === z.currency_id;
                        });

                        $.each(x, function (k, l) {
                            
                            if (l.CURRENCY_ID != z.currency_id) {
                                z.exchange_rate = delCommas(accounting.formatNumber(l.RATE, 8));
                                z.exchange_sign = l.OPERATOR;
                            } else {
                                //if ($("[name='target.currency']").val() == l.CURRENCY_ID) {
                                //    $("[name='target.exchange_rate']").val(z.exchange_rate);
                                //}
                                $.each(listCurrency, function (k, cc) {
                                    if (cc.CURRENCY_CODE == z.currency_id) {
                                        cc.RATE = z.exchange_rate;
                                    }
                                });
                                $("[name='target.currency']").val(z.currency_id).change();
                                //$("[name='target.exchange_rate']").val(z.exchange_rate);
                                //PopulateVSItem();
                            }
                            
                        });
                    });
                }
            });
        }

        function PopulateVSItem() {    
            populateWithTargetCurrency();

            if ($("#tblVSItem thead").html() == "") {
                var header = '<tr>';
                header += '<th rowspan="2" style="width:5%; vertical-align:top;">Product code</th>';
                header += '<th rowspan="2" style="vertical-align:top;">PR description</th>';
                header += '<th rowspan="2" style="width:10%; vertical-align:top;">PR code</th>';
                header += '<th colspan="2" style="width:20%; text-align:center; vertical-align:top;">Purchase requisition</th>';

                headerArr = $.grep(vsItems, function (n, i) {
                    return n["pr_detail_id"] === vsItems[0].pr_detail_id;
                });

                ////handle multiple vendor
                //$.each(headerArr, function (i, d) {
                //    if (vsItemsMain.length == 1) {
                //        d.vendor = d.vendor + "_" + d.quotation_detail_id;
                //    }
                //});

                $.each(headerArr, function (i, d) {
                    header += '<th colspan="5" style="text-align:center;">' + d.vendor_name + '</th>';
                });

                addcol = 10 + (headerArr.length * 4);

                header += '<th rowspan="2">&nbsp;</th></tr><tr>';
                header += '<th style="border-left:1px solid #ddd !important; text-align:right;">Unit price</th>';
                header += '<th style="text-align:right;">Quantity</th>';


                $.each(headerArr, function (i, d) {
                    header += '<th style="text-align:left;">Quotation</th>';
                    header += '<th style="text-align:right;">Currency</th>';
                    header += '<th style="text-align:right;">Unit price</th>';
                    header += '<th style="text-align:right;">Quantity</th>';
                    header += '<th style="text-align:right;">Total</th>';
                });
                header += '</tr>';

                $("#tblVSItem thead").append(header);
            } else {

            }
    
            if ($("#tblVSItem tbody").html() == "") {
                var html = "";
                $.each(vsItemsMain, function (i, d) {
                    html += '<tr>';
                    html += '<td style="width:5%;"><input type="hidden" name="pr_detail_id" value="' + d.pr_detail_id + '"/>' + d.item_code + '</td>';
                    html += '<td style="width:30%;">' + d.item_description + '</td>';
                    html += '<td style="width:5%;"><a href="<%=Page.ResolveUrl("~/purchaserequisition/detail.aspx?id=' + d.pr_id + '")%>" target="_blank">' + d.pr_no + '</a></td>';
                    html += '<td style="width:5%; text-align:right;">' + d.pr_currency_original + ' ' + accounting.formatNumber(delCommas(d.pr_unit_price_original), 2) + '</td>';
                    html += '<td style="width:5%; text-align:right;">' + accounting.formatNumber(delCommas(d.pr_quantity), 2) + ' ' + d.uom + '</td>';
                    
                    var details = $.grep(vsItems, function (n, k) {
                        return n["pr_detail_id"] === d.pr_detail_id;
                    });

                    var currency = ""
                    $.each(details, function (l, dt) {
                        var quotation = '';
                        currency = dt.currency_id_original
                        quotation += '<a href="<%=Page.ResolveUrl("~/quotation/detail.aspx?id=' + dt.q_id + '")%>" target="_blank">' + dt.q_no + '</a><br>';
                        quotation += dt.qd_description;
                        
                        html += '<td style="text-align:left;">' + quotation + '</td>';
                        html += '<td style="text-align:right;">' + dt.currency_id_original + '</td>';
                        html += '<td style="text-align:right;"><input type="hidden" name="uom" data-vendor="' + dt.vendor + '" value="' + dt.uom + '"/><input type="hidden" name="unit_price" data-vendor="' + dt.vendor + '" value="' + delCommas(dt.unit_price) + '">' + accounting.formatNumber(delCommas(dt.unit_price_original), 2) + '</td>';
                        html += '<td style="text-align:right;"><input type="hidden" name="vs_quantity" class="number span10" data-initial="' + dt.quantity + '" data-maximum-attr="quantity" data-maximum="' + dt.max_quantity + '" data-validation="required maximum" data-description="Product: ' + d.item_code + ' in Quotation from ' + dt.vendor_name + '" data-decimal-places="2" data-vendor="' + dt.vendor + '" value="' + dt.quantity + '"/>' +
                            '' + accounting.formatNumber(delCommas(dt.quantity), 2) + '</td > ';
                        html += '<td style="text-align:right;" id="total_' + d.pr_detail_id + '_' + dt.vendor + '">' + accounting.formatNumber(dt.cost_original, 2) + '</td>';
                    });
                    if (($("#status").val() == "50") || ($("#status").val() == "25")) {
                        html += '<td></td></tr>';
                    } else {
                        html += '<td><span class="label red btnDelete" title="Delete"><i class="icon-trash delete" style="opacity: 1;"></i></span></td></tr>';
                    }
                    /*
                    //detail charge code
                    html += '<tr id="chargecode_' + d.pr_detail_id + '">';
                    html += '<td colspan="' + addcol + '"><i name="cc-collapse"  data-item="' + d.pr_detail_id + '" class="icon-chevron-sign-right dropDetail" title="View Charge code(s)"></i >&nbsp&nbsp<b> Charge code(s)</b></td >';
                    html += '</tr>';
                    html += '<tr id="tblCostCenters_' + d.pr_detail_id + '" class="cc-hide" style="display:none;"><td colspan="' + addcol + '">' +
                        '<table  class="table table-bordered table-striped" style="table-layout: fixed;">' +
                        '<thead>' +
                        '<tr>' +
                        '<th style="text-align: center; word-wrap: break-word; width: 25%;">Cost center / Project code' +
                        '</th>' +
                        '<th style="text-align: center; word-wrap: break-word; width: 30%;">Work order / T4' +
                        '</th>' +
                        '<th style="text-align: center; word-wrap: break-word; width: 25%;">Entity' +
                        '</th>' +
                        '<th style="text-align: center; word-wrap: break-word; width: 10%;">Legal Entity' +
                        '</th>' +
                        '<th style="text-align: center; word-wrap: break-word; width: 25%;" hidden>Control Account' +
                        '</th>' +
                        '<th style="text-align: center; word-wrap: break-word; width: 7%;">%' +
                        '</th>' +
                        '<th id="lbItemAmt" style="text-align: center; word-wrap: break-word; width: 20%;">Amount(' + d.pr_currency + ')' +
                        '</th>' +
                        '<th style="text-align: center; word-wrap: break-word; width: 20%;">Amount(USD)' +
                        '</th>' +
                        '<th style="text-align: center; word-wrap: break-word; width: 25%;">Remarks' +
                        '</th>' +
                        '</tr>' +
                        '</thead>' +
                        '<tbody>';


                    if (d.detail_chargecode.length > 0) {
                        $.each(d.detail_chargecode, function (l, dcc) {
                            html += '<tr>' +
                                '<td>' + dcc.cost_center_id +' - '+dcc.cost_center_name+'</td>' +
                                '<td>' + dcc.work_order + ' - '+dcc.work_order_description+'</td>' +
                                '<td>' + dcc.entity_id +' - '+dcc.entity_description+ '</td>' +
                                '<td>' + dcc.legal_entity + '</td>' +
                                '<td  style="text-align:center;">' + dcc.percentage + '</td>' +
                                '<td  style="text-align:right;">' + accounting.formatNumber(delCommas(dcc.amount), 2) + '</td>' +
                                '<td  style="text-align:right;">' + accounting.formatNumber(delCommas(dcc.amount_usd), 2) + '</td>' +
                                '<td>' + dcc.remarks + '</td>' +
                                '</tr>';
                        });

                    } else {
                        html += '<tr><td colspan="8" style="text-align:center; font-style:italic;">No data available</td></tr>';
                    }

                  
                    html += '</tbody>' +
                        '</table>' +
                        '</td ></tr > ';
                    */
                });

       
                $("#tblVSItem tbody").append(html);
            }

            populateDetailSupport();
            populateListCurrencyItems();

            if ($("#tblVSItem tfoot").html() == "") {

                var htmlFooter = "";
              
                htmlFooter += '<tr><td colspan="5" style="text-align:right; font-weight:bold;">Supplier Address</td>';
                $.each(headerArr, function (i, d) {
                    htmlFooter += '<td colspan="5" style="text-align:left; font-weight:bold;" id = "vendorAddress_' + d.vendor + '" ></td>';
                });

                htmlFooter += '<td rowspan="15">&nbsp;</td></tr>';

                htmlFooter += '<tr><td colspan="5" style="text-align:right;">Discount</td>';
                $.each(headerArr, function (i, d) {
                    var x = $.grep(detailSupport, function (n, j) {
                        return n["vendor"] === d.vendor;
                    });

                    htmlFooter += '<td colspan="5" style="text-align:right;" id="discount_' + d.vendor + '"><input type="hidden" name="discount" class="number span12" data-decimal-places="2" data-vendor="' + d.vendor + '" value="' + x[0].discount + '"/>'
                        + accounting.formatNumber(x[0].discount, 2)
                        + '</td>';
                });
                htmlFooter += '</tr>';

              
                htmlFooter += '<tr><td colspan="5" style="text-align:right; font-weight:bold;">Total after discount</td>';
                $.each(headerArr, function (i, d) {
                    htmlFooter += '<td colspan="5" style="text-align:right; font-weight:bold;" data-value="" id="TotalAfterDisc_' + d.vendor + '"></td>';
                });
                htmlFooter += '</tr>';

                htmlFooter += '<tr><td colspan="5" style="text-align:right; font-weight:bold;">Total (in USD)</td>';
                $.each(headerArr, function (i, d) {
                    htmlFooter += '<td colspan="5" style="text-align:right; font-weight:bold;" id="TotalUSD_' + d.vendor + '"></td>';
                });
                htmlFooter += '</tr>';


                htmlFooter += '<tr><td colspan="5" style="text-align:right;">Additional discount (in target currency)</td>';
                $.each(headerArr, function (i, d) {
                    var x = $.grep(detailSupport, function (n, j) {
                        return n["vendor"] === d.vendor;
                    });
                    if (($("#status").val() == "50") || ($("#status").val() == "25")) {
                        htmlFooter += '<td colspan="5" style="text-align:right"><input type="text" name="additional_discount" class="number span4" data-decimal-places="2" data-vendor="' + d.vendor + '" value="' + x[0].additional_discount + '" disabled/> / USD <span id="additional_discount_usd_'+d.vendor+'" data-value=""></span></td>';
                    } else
                        htmlFooter += '<td colspan="5" style="text-align:right"><input type="text" name="additional_discount" class="number span4" data-decimal-places="2" data-vendor="' + d.vendor + '" value="' + x[0].additional_discount + '" />  / USD <span id="additional_discount_usd_'+d.vendor+'" data-value=""></span></td>';
                });
                htmlFooter += '</tr>';

                htmlFooter += '<tr><td colspan="5" style="text-align:right; font-weight:bold;">Total after additional discount (in target currency)</td>';
                $.each(headerArr, function (i, d) {
                    htmlFooter += '<td colspan="5" style="text-align:right; font-weight:bold;" id="TotalAfterAddDisc_' + d.vendor + '"></td>';
                });
                htmlFooter += '</tr>';


                htmlFooter += '<tr><td colspan="5" style="text-align:right; font-weight:bold;">Total after additional discount (in USD)</td>';
                $.each(headerArr, function (i, d) {
                    htmlFooter += '<td colspan="5" style="text-align:right; font-weight:bold;" id="TotalAfterAddDiscUSD_' + d.vendor + '"></td>';
                });
                htmlFooter += '</tr>';

          
                htmlFooter += '<tr><td colspan="5" style="text-align:right;">Lead time</td>';
                $.each(headerArr, function (i, d) {
                    var x = $.grep(detailSupport, function (n, j) {
                        return n["vendor"] === d.vendor;
                    });
                    htmlFooter += '<td colspan="5"><textarea class="span12 textareavertical" rows="3" maxlength="500" name="indent_time" data-vendor="' + d.vendor + '"  placeholder="Lead time">' + x[0].indent_time + '</textarea>'
                                 +' <div class="mt-1" style="font-size: 80%; font-style: italic; display: block;">Maximum description is 500 characters</div></td > ';
                });
                htmlFooter += '</tr>';

                htmlFooter += '<tr><td colspan="5" style="text-align:right;">Warranty</td>';
                $.each(headerArr, function (i, d) {
                    var x = $.grep(detailSupport, function (n, j) {
                        return n["vendor"] === d.vendor;
                    });
                    htmlFooter += '<td colspan="5"><textarea class="span12 textareavertical" rows="3" maxlength="500" name="warranty_time" data-vendor="' + d.vendor + '" placeholder="Warranty">' + x[0].warranty_time + '</textarea>'
                        + ' <div class="mt-1" style="font-size: 80%; font-style: italic; display: block;">Maximum description is 500 characters</div></td > ';
                });
                htmlFooter += '</tr>';

                htmlFooter += '<tr><td colspan="5" style="text-align:right;">Delivery time <span style="color:red">*</span></td>';
                $.each(headerArr, function (i, d) {
                    var x = $.grep(detailSupport, function (n, j) {
                        return n["vendor"] === d.vendor;
                    });

                    htmlFooter += '<td colspan="5"><div class="input-prepend" style="margin-right:-32px;">';
                    htmlFooter += '<input type="text" name="expected_delivery_date" data-vendor="' + d.vendor + '" id="_expected_delivery_date' + d.vendor + '" data-validation="date required" data-title="Expected delivery date" class="span10" readonly="readonly" placeholder="Expected delivery date" maxlength="11"/>';
                    htmlFooter += '<span class="add-on icon-calendar" id="expected_delivery_date' + d.vendor + '"></span></div></td>';

                });
                htmlFooter += '</tr>';

                htmlFooter += '<tr><td colspan="5" style="text-align:right;">SELECTED SUPPLIER <span style="color:red">*</span></td>';
                $.each(headerArr, function (i, d) {
                    var x = $.grep(detailSupport, function (n, j) {
                        return n["vendor"] === d.vendor;
                    });

                    var selected = "";
                    if (x[0].is_selected == "1") {
                        selected = "checked";
                        additionalDiscountVendor = x[0].vendor;
                    }
                    if (($("#status").val() == "50")) {
                        htmlFooter += '<td colspan="5" style="text-align:center;"><input type="radio" data-validation="required" data-title="Selected Supplier" name="is_selected" data-vendor="' + d.vendor + '" value="1" ' + selected + ' disabled/></td>';
                    } else {
                        htmlFooter += '<td colspan="5" style="text-align:center;"><input type="radio" data-validation="required" data-title="Selected Supplier" name="is_selected" data-vendor="' + d.vendor + '" value="1" ' + selected + '/></td>';
                    }
                });
                htmlFooter += '</tr>';

                htmlFooter += '<tr><td colspan="5" style="text-align:right;">Reason for selection <span style="color:red">*</span></td>';
                $.each(headerArr, function (i, d) {
                    var x = $.grep(detailSupport, function (n, j) {
                        return n["vendor"] === d.vendor;
                    });
                    htmlFooter += '<td colspan="5"><textarea class="span12 textareavertical" rows="3" maxlength="500" data-validation="required" data-title="Reason for selection" name="reason_for_selection" data-vendor="' + d.vendor + '" placeholder="Reason for selection">' + x[0].reason_for_selection + '</textarea>'
                        + ' <div class="mt-1" style="font-size: 80%; font-style: italic; display: block;">Maximum description is 500 characters</div></td > ';
                });
                htmlFooter += '</tr>';

                htmlFooter += '<tr><td colspan="5" style="text-align:right;">Remarks</td>';
                $.each(headerArr, function (i, d) {
                    var x = $.grep(detailSupport, function (n, j) {
                        return n["vendor"] == d.vendor;
                    });
                    htmlFooter += '<td colspan="5"><textarea class="span12 textareavertical" rows="3" maxlength="2000" name="remarks" data-vendor="' + d.vendor + '" placeholder="Remarks">' + x[0].remarks + '</textarea>'
                        + ' <div class="mt-1" style="font-size: 80%; font-style: italic; display: block;">Maximum description is 2,000 characters</div></td > ';
                });
                htmlFooter += '</tr>';

                htmlFooter += '<tr><td colspan="5" style="text-align:right;">Upload justification (if any)</td>';
                $.each(headerArr, function (i, d) {
                    var x = $.grep(detailSupport, function (n, j) {
                        return n["vendor"] == d.vendor;
                    });

                    htmlFooter += '<td colspan="5">';
                    if (x[0].justification_file !== "") {
                        htmlFooter += '<span class="linkDocument"><a id="linkDocument" href="Files/' + $("#vs_id").val() + '/' + x[0].justification_file + '" target="_blank">' + x[0].justification_file + '</a>&nbsp;</span>';
                        htmlFooter += '<button type="button" class="btn btn-primary editDocument" data-vendor="' + d.vendor + '">Edit</button><input type="file" class="span10" name="filename" data-vendor="' + d.vendor + '" style="display: none;"/>';
                        htmlFooter += '<input type="hidden" name="justification.uploaded" data-vendor="' + d.vendor + '" value="1"/>';
                        htmlFooter += '<button type="button" class="btn btn-success btnFileUploadJustification" data-vendor="' + d.vendor + '" data-type="file_justification" style="display:none;">Upload</button>';
                    } else {
                        htmlFooter += '<span class="linkDocument"><a id="linkDocument" href="" target="_blank"></a>&nbsp;</span>';
                        htmlFooter += '<button type="button" class="btn btn-primary editDocument" data-vendor="' + d.vendor + '" style="display: none;">Edit</button><input type="file" class="span10" name="filename" data-vendor="' + d.vendor + '"/>';
                        htmlFooter += '<input type="hidden" name="justification.uploaded" data-vendor="' + d.vendor + '" value="0"/>';
                        htmlFooter += '<button type="button" class="btn btn-success btnFileUploadJustification" data-vendor="' + d.vendor + '" data-type="file_justification">Upload</button>';
                    }
                    htmlFooter += '<input type="hidden" name="justification_file" value="' + NormalizeString(x[0].justification_file) +'" data-vendor="' + d.vendor + '"/></td>';
                });
                htmlFooter += '</tr>';

                $("#tblVSItem tfoot").append(htmlFooter);

                $("span[id^='expected_delivery_date']").each(function () {
                    var id = $(this).attr("id");
                    $(this).datepicker({
                        format: "dd M yyyy"
                        , autoclose: true
                        , orientation: "auto"
                    }).on("changeDate", function () {
                        $("#_" + id).val($("#" + id).data("date"));
                        $("#" + id).datepicker("hide");
                    });
                });
                $.each(headerArr, function (i, d) {
                    var x = $.grep(detailSupport, function (n, j) {
                        return n["vendor"] == d.vendor;
                    });
                    if (x[0].expected_delivery_date != "" && x[0].expected_delivery_date != null) {
                        var delivDate = new Date(x[0].expected_delivery_date);
                        $("#expected_delivery_date" + d.vendor).datepicker("setDate", delivDate).trigger("changeDate");
                    }
                });
            }

            //calculateTotal();
            repopulateNumber();
            normalizeMultilines();
        }

        $(document).on('click', 'i[name^="cc-collapse"]', function () {
            var tbid = "#tblCostCenters_" + $(this).attr("data-item");
            if (!$(tbid).hasClass('cc-hide')) {
                $(tbid).css("display", "none");
                $(tbid).addClass('cc-hide');
                $(this).removeClass('icon-chevron-sign-down')
                $(this).addClass('icon-chevron-sign-right');
            } else {
                $(tbid).css("display", "");
                $(tbid).removeClass('cc-hide');
                $(this).removeClass('icon-chevron-sign-right');
                $(this).addClass('icon-chevron-sign-down');
            }
        });

        function populateDetailSupport() {
            /* detail support variables */
            detailSupport = [];
            $.each(headerArr, function (i, dha) {
                var arrVendors = $.grep(vsItems, function (n, i) {
                    return n["vendor"] === dha.vendor;
                });

                var vendorDetail = [];
                $.each(arrVendors, function (m, sd){
                    vendorDetail.push(sd.q_id);
                });
                vendorDetail = unique(vendorDetail);

                var indent_time = ""
                    , warranty_time = ""
                    , expected_delivery_date = ""
                    , is_selected = ""
                    , reason_for_selection = ""
                    , remarks = ""
                    , justification_file = ""
                    , discount = 0
                    , additional_discount = 0;

                // populate supporting data
                $.each(arrVendors, function (m, sd) {

                    // if vendor have one quotation;
                    if (vendorDetail.length == 1 && _id == "") {
                        indent_time += sd.indent_time.length > 0 ? sd.indent_time + ", " : "";
                        warranty_time += sd.warranty_time.length > 0 ? sd.warranty_time + ", " : "";
                    } else {
                        indent_time = sd.indent_time.length > 0 ? sd.indent_time + ", " : "";
                        warranty_time = sd.warranty_time.length > 0 ? sd.warranty_time + ", " : "";
                    }


                  
                   
                    expected_delivery_date = sd.expected_delivery_date;
                    is_selected = sd.is_selected;
                    reason_for_selection = sd.reason_for_selection;
                    remarks = sd.remarks;
                    justification_file = sd.justification_file;
                    discount += delCommas(sd.discount);

                    additional_discount += sd.additional_discount;
                

                });

           
                var sp = new Object();
                sp.vendor = dha.vendor;
                sp.indent_time = indent_time.length > 0 ? indent_time.substring(0, indent_time.length - 2) : indent_time;
                sp.warranty_time = warranty_time.length > 0 ? warranty_time.substring(0, warranty_time.length - 2) : warranty_time;
                sp.expected_delivery_date = expected_delivery_date;
                sp.is_selected = is_selected;
                sp.reason_for_selection = reason_for_selection;
                sp.remarks = remarks;
                sp.justification_file = justification_file;
                sp.discount = delCommas(accounting.formatNumber(discount, 2));
                sp.additional_discount = delCommas(accounting.formatNumber(additional_discount, 2));
                detailSupport.push(sp);
                
            });

           

        }

        function repopulateTotalDiscount() {
            $.each(headerArr, function (i, d) {
                var x = $.grep(detailSupport, function (n, j) {
                    return n["vendor"] === d.vendor;
                });
                $("[name='discount'][data-vendor='" + d.vendor + "']").val(x[0].discount);
            });
        }

        $(document).on("change", "[name='vs_quantity'],[name='discount'],[name='additional_discount'], [name='is_selected']", function () {
            if ($(this).prop("name") == "vs_quantity") {
                if (delCommas($(this).data("initial")) != delCommas($(this).val())) {
                    $("[name='discount'][data-vendor='" + $(this).data("vendor") + "']").val("0.00");
                }
            }

            if ($(this).prop("name") == "is_selected") {
                additionalDiscountVendor = $(this).attr("data-vendor");
            }

            calculateTotal();

            if ($(this).prop("name") == "additional_discount") {
                CalculateAdditionalDiscount($(this).attr("data-vendor"));
                //CalculateAdjustment($(this).attr("data-vendor"));
            }
        });

        function calculateTotal() {
            $("[name='vs_quantity']").each(function () {
                var vendor = $(this).data("vendor");
                var pr_detail_id = $(this).closest("tr").find("[name='pr_detail_id']").val();
                var EditVSItem = $.grep(vsItems, function (n, i) {
                    return n["vendor"] == vendor && n["pr_detail_id"] == pr_detail_id;
                });
                EditVSItem[0].quantity = delCommas($(this).val());
            //    EditVSItem[0].cost = delCommas(accounting.formatNumber(EditVSItem[0].quantity * EditVSItem[0].unit_price,2));
                EditVSItem[0].cost_original = EditVSItem[0].quantity * EditVSItem[0].unit_price_original;

                $("#total_" + pr_detail_id + '_' + vendor).text(accounting.formatNumber(delCommas(EditVSItem[0].cost_original), 2));
            });


            //populateCurrentData();
            //populateAfterDiscount(); 
            populateDataPerVendor();
        }

        function populateDataPerVendor() {
            let vendorAddress = "";
            let listVendorAddress = [];
            let is_sundry = "";
            let id = "";

            $.each(detailSupport, function (i, d) {
                var pervendor = $.grep(vsItems, function (n, j) {
                    return n["vendor"] == d.vendor;
                });

                let line_total_sum_pervendor = 0;
                let line_total_sum_pervendor_temp = 0;
                let discount_sum_pervendor = 0;
                let add_discount_sum_pervendor = 0;
                let add_discount_usd = 0;
                let line_total_usd_sum_pervendor = 0;
                let currency_id = "";
                let currency_id_original = "";
                let exchange_sign = "";
                let exchange_rate = "";

                $.each(pervendor, function (k, di) {
                    is_sundry = di.is_sundry;
                    id = di.id != "" ? di.id : di.uid;
                    //populate group vendor address
                    var adid = listVendorAddress.findIndex(x => x.supplier_address === di.supplier_address);
                    if (adid == -1) {
                        listVendorAddress.push({ supplier_address: di.supplier_address });
                    } else {
                        var temp = listVendorAddress[adid];
                        temp.supplier_address = di.supplier_address;
                    }
                    //END populate group vendor address

                    currency_id = di.currency_id;
                    currency_id_original = di.currency_id_original;
                    exchange_sign = di.exchange_sign;
                    exchange_rate = di.exchange_rate;

                    //CALCULATE AMOUNT
                    
                    if ($("[name='target.currency']").val() == currency_id_original) {
                        di.line_total = di.cost_original - di.discount;
                    } else {
                        //if (exchange_sign == "*") {
                        //    di.line_total = (di.line_total_usd / exchange_rate);
                        //} else {
                        //    di.line_total = (di.line_total_usd * exchange_rate);
                        //}
                        di.line_total = (di.line_total_usd * exchange_rate);
                    }

                    line_total_sum_pervendor_temp += delCommas(accounting.formatNumber(di.line_total, 2));
                    line_total_usd_sum_pervendor += di.line_total_usd;
                    discount_sum_pervendor += di.discount;
                    add_discount_sum_pervendor += di.additional_discount;

                    //END CALCULATE AMOUNT
                });

                //group vendor address
                $.each(listVendorAddress, function (k, di) {
                    if (di.supplier_address != null || di.supplier_address != "") {

                        if (is_sundry == "1") {
                            var btnEditSundry = '<span class="label green btnSundryEdit" data-toggle="modal" href="#SundryForm" title="Detail" data-id = ' + id + '><i class="icon-pencil edit" style="opacity: 0.7;"></i></span >'
                            vendorAddress = di.supplier_address + " " + btnEditSundry + "<br>";
                        } else {
                            vendorAddress = di.supplier_address + "<br>";
                        }

                    }
                });
                //END group vendor address

                if ($("[name='target.currency']").val() == currency_id_original) {
                    line_total_sum_pervendor = line_total_sum_pervendor_temp;
                } else {
                    if (exchange_sign == "*") {
                        line_total_sum_pervendor = (line_total_usd_sum_pervendor / exchange_rate);
                        add_discount_usd = (add_discount_sum_pervendor * exchange_rate);
                    } else {
                        line_total_sum_pervendor = (line_total_usd_sum_pervendor * exchange_rate);
                        add_discount_usd = (add_discount_sum_pervendor / exchange_rate);
                    }
                }      

                //if (exchange_sign == "*") {
                //    add_discount_usd = (add_discount_sum_pervendor * exchange_rate);
                //} else {
                //    add_discount_usd = (add_discount_sum_pervendor / exchange_rate);
                //}
                add_discount_usd = (add_discount_sum_pervendor * exchange_rate);

                let gep_line_total = 0;
                if (delCommas(accounting.formatNumber(line_total_sum_pervendor_temp, 2)) > delCommas(accounting.formatNumber(line_total_sum_pervendor, 2))) {
                    gep_line_total = delCommas(accounting.formatNumber(line_total_sum_pervendor_temp, 2)) - delCommas(accounting.formatNumber(line_total_sum_pervendor, 2));
                    pervendor[0]["line_total"] = delCommas(accounting.formatNumber(pervendor[0]["line_total"] - gep_line_total, 2));
                } else if (delCommas(accounting.formatNumber(line_total_sum_pervendor_temp, 2)) < delCommas(accounting.formatNumber(line_total_sum_pervendor, 2))) {
                    gep_line_total = delCommas(accounting.formatNumber(line_total_sum_pervendor, 2)) - delCommas(accounting.formatNumber(line_total_sum_pervendor_temp, 2));
                    pervendor[0]["line_total"] = delCommas(accounting.formatNumber(pervendor[0]["line_total"] + gep_line_total, 2));
                }

                if (isNaN(add_discount_sum_pervendor)) {
                    add_discount_sum_pervendor = 0;
                }

                if (isNaN(add_discount_usd)) {
                    add_discount_usd = 0;
                }

                $("#vendorAddress_" + d.vendor).html(vendorAddress);
                $("#discount_" + d.vendor).html(currency_id + " " + accounting.formatNumber(discount_sum_pervendor,2));
                $("#TotalAfterDisc_" + d.vendor).html(currency_id + " " + accounting.formatNumber(line_total_sum_pervendor, 2));
                $("#TotalAfterDisc_" + d.vendor).attr("data-value", line_total_sum_pervendor);
                $("#TotalUSD_" + d.vendor).text(accounting.formatNumber(line_total_usd_sum_pervendor, 2));
                $("#TotalAfterAddDisc_" + d.vendor).html(currency_id + " " + accounting.formatNumber(line_total_sum_pervendor - add_discount_sum_pervendor, 2));
                $("#TotalAfterAddDiscUSD_" + d.vendor).html(accounting.formatNumber(line_total_usd_sum_pervendor - add_discount_usd, 2));
                $("#additional_discount_usd_" + d.vendor).html(accounting.formatNumber(add_discount_usd, 2));
            });
        }

        function CalculateAdditionalDiscount(vendor_code) {
            let add_discount_usd = 0;
            let add_discount = delCommas($("[name='additional_discount'][data-vendor='" + vendor_code + "']").val());

            //if ($("[name='target.exchange_sign']").val() == "*") {
            //    add_discount_usd = (add_discount * $("[name='target.exchange_rate']").val());
            //} else {
            //    add_discount_usd = (add_discount / $("[name='target.exchange_rate']").val());
            //}
            add_discount_usd = (add_discount * $("[name='target.exchange_rate']").val());
            
            $("#additional_discount_usd_" + vendor_code).html(accounting.formatNumber(add_discount_usd, 2));
            
            total_after_discount = delCommas(accounting.formatNumber($("#TotalAfterDisc_" + vendor_code).attr("data-value"), 2));
            total_after_discount_usd = delCommas($("#TotalUSD_" + vendor_code).html());
            additional_discount = delCommas($("[name='additional_discount'][data-vendor='" + vendor_code + "']").val());
            additional_discount_usd = delCommas($("#additional_discount_usd_" + vendor_code).html());

            $("#TotalAfterAddDisc_" + vendor_code).html($("select[name='target.currency']").attr("selected", "selected").val() + " " + accounting.formatNumber(total_after_discount - add_discount, 2));
            $("#TotalAfterAddDiscUSD_" + vendor_code).html(accounting.formatNumber(total_after_discount_usd - add_discount_usd, 2));

            var pervendor = $.grep(vsItems, function (n, j) {
                return n["vendor"] == vendor_code;
            });

            let additional_discount_sum = 0;
            $.each(pervendor, function (k, di) {
                di.additional_discount = delCommas(accounting.formatNumber((di.line_total_usd / total_after_discount_usd) * additional_discount, 2));
                additional_discount_sum += di.additional_discount;
            });

            let gep_add_disc = 0;

            if (delCommas(accounting.formatNumber(additional_discount_sum, 2)) > delCommas(accounting.formatNumber(add_discount, 2))) {
                gep_add_disc = delCommas(accounting.formatNumber(additional_discount_sum, 2)) - delCommas(accounting.formatNumber(add_discount, 2));
                pervendor[0]["additional_discount"] = delCommas(accounting.formatNumber(pervendor[0]["additional_discount"] - gep_add_disc, 2));
            } else if (delCommas(accounting.formatNumber(additional_discount_sum, 2)) < delCommas(accounting.formatNumber(add_discount, 2))){
                gep_add_disc = delCommas(accounting.formatNumber(add_discount, 2)) - delCommas(accounting.formatNumber(additional_discount_sum, 2));
                pervendor[0]["additional_discount"] = delCommas(accounting.formatNumber(pervendor[0]["additional_discount"] + gep_add_disc, 2));
            }
        }

        //function populateCurrentData() {
        //    $.each(detailSupport, function (i, d) {
        //        var pervendor = $.grep(vsItems, function (n, j) {
        //            return n["vendor"] == d.vendor;
        //        });

        //        var currency_id = "";
        //        var _sign = "";
        //        var _rate = "";
        //        var is_sundry = "";
        //        var groupDiscount = "";
        //        var groupTotalAfterDisc = "";
        //        var groupExchangeRate = "";
        //        var vendorAddress = "";
        //        var totalAfterDisc = 0;
        //        var totalAfterDiscUSD = 0;
        //        var listDiscount = [];
        //        var listAfterDiscount = [];
        //        var listVendorAddress = [];
        //        var listExchngeRate = [];
        //        var id = "";
        //        console.log(pervendor);
        //        $.each(pervendor, function (k, di) {

        //            currency_id = di.currency_id;
        //            is_sundry = di.is_sundry;
        //            id = di.id != "" ? di.id : di.uid;
        //            di.exchange_rate = $("[name='target.exchange_rate']").val();          

        //            _sign = di.exchange_sign;
        //            _rate = di.exchange_rate;

        //            //populate before additional discount
        //            if (isExistingData_ == false) {
        //                di.line_total = delCommas(accounting.formatNumber(di.cost - di.discount, 2));
        //            } else {
        //                console.log('daskdmaskdmkasdmka');
        //                //di.line_total += delCommas(accounting.formatNumber(di.additional_discount, 2));
        //            }

        //            if (isExistingData_ == false) {
        //                if (_sign == "/") {
        //                    di.line_total_usd = delCommas(accounting.formatNumber(di.line_total / delCommas(_rate), 2));
        //                } else {
        //                    di.line_total_usd = delCommas(accounting.formatNumber(di.line_total * delCommas(_rate), 2));
        //                }
        //                totalAfterDiscUSD += di.line_total_usd;
        //            } else {
        //                /*totalAfterDiscUSD += (di.cost_usd - di.discount_usd);*/
        //                totalAfterDiscUSD += di.line_total_usd;
        //            }
                    
        //            totalAfterDisc += di.line_total;
                    


        //            //populate group discount
        //            var did = listDiscount.findIndex(x => x.currency_id === di.currency_id);
        //            if (did == -1) {
        //                listDiscount.push({ currency_id: di.currency_id, discount: di.discount });
        //            } else {
        //                var temp = listDiscount[did];
        //                temp.discount += di.discount;
        //            }

        //            //populate group after discount
        //            var adid = listAfterDiscount.findIndex(x => x.currency_id === di.currency_id);
        //            if (adid == -1) {
        //                listAfterDiscount.push({ currency_id: di.currency_id, cost: di.cost, discount: di.discount, line_total: di.line_total, line_total_usd: di.line_total_usd });
        //            } else {
        //                var temp = listAfterDiscount[adid];
        //                temp.line_total += di.line_total;
        //                temp.line_total_usd += di.line_total_usd;
        //                temp.cost += di.cost;
        //                temp.discount += di.discount;
        //            }


        //            //populate group vendor address
        //            var adid = listVendorAddress.findIndex(x => x.supplier_address === di.supplier_address);
        //            if (adid == -1) {
        //                listVendorAddress.push({ supplier_address: di.supplier_address });
        //            } else {
        //                var temp = listVendorAddress[adid];
        //                temp.supplier_address = di.supplier_address;
        //            }

        //        })


        //        //group vendor address
        //        $.each(listVendorAddress, function (k, di) {
        //            if (di.supplier_address != null || di.supplier_address != "") {
                    
        //                if (is_sundry == "1") {
        //                    var btnEditSundry = '<span class="label green btnSundryEdit" data-toggle="modal" href="#SundryForm" title="Detail" data-id = ' + id + '><i class="icon-pencil edit" style="opacity: 0.7;"></i></span >'
        //                    vendorAddress += di.supplier_address + " " + btnEditSundry + "<br>";
        //                } else {
        //                    vendorAddress += di.supplier_address + "<br>";
        //                } 
      
        //            }
        //        });

        //        //group discount
        //        $.each(listDiscount, function (k, di) {
        //            if (di.currency_id == null) {
        //                groupDiscount += accounting.formatNumber(di.discount, 2) + "<br>";
        //            } else {
        //                groupDiscount +=  di.currency_id + " " + accounting.formatNumber(di.discount, 2) + "<br>";
        //            }
        //        });

        //        //group after discount
        //        $.each(listAfterDiscount, function (k, di) {
        //            if (di.currency_id == null) {
        //                if (isExistingData_ == false) {
        //                    groupTotalAfterDisc += accounting.formatNumber(di.cost - di.discount, 2) + " <br>";
                            
        //                } else {
        //                    groupTotalAfterDisc += accounting.formatNumber(di.line_total, 2) + " <br>";
        //                }
        //            } else {
        //                if (isExistingData_ == false) {
        //                    groupTotalAfterDisc += di.currency_id + " " + accounting.formatNumber((di.cost - di.discount), 2) + " <br>";
        //                } else {
        //                    groupTotalAfterDisc += di.currency_id + " " + accounting.formatNumber(di.line_total, 2) + " <br>";
        //                }   
        //            }
        //        });

                
        //        $("#vendorAddress_" + d.vendor).html(vendorAddress);
        //        $("#discount_" + d.vendor).html(groupDiscount);
        //        $("#TotalAfterDisc_" + d.vendor).html(groupTotalAfterDisc);
        //        $("#TotalAfterDisc_" + d.vendor).attr("data-value", totalAfterDisc);
        //        $("#TotalUSD_" + d.vendor).text(accounting.formatNumber(totalAfterDiscUSD, 2));
        //    });
        //}

        //function populateAfterDiscount() {
        //    $.each(detailSupport, function (i, d) {
        //        var pervendor = $.grep(vsItems, function (n, j) {
        //            return n["vendor"] == d.vendor;
        //        });

        //        var totalGross = 0;
        //        var grandTotalUSDBeforeAddDisc = 0;
        //        $.each(pervendor, function (k, di) {
        //            totalGross += di.cost;
        //            grandTotalUSDBeforeAddDisc += di.line_total_usd;
        //        })


        //        var disc = delCommas($("[name='discount'][data-vendor='" + d.vendor + "']").val());
               
        //         var addDisc = delCommas($("[name='additional_discount'][data-vendor='" + d.vendor + "']").val());
        //            //convert to usd
        //            if ( $("[name='target.exchange_sign']").val() == "/") {
        //                addDisc = delCommas(addDisc / delCommas( $("[name='target.exchange_rate']").val()));
        //            } else {
        //                 addDisc = delCommas(addDisc * delCommas( $("[name='target.exchange_rate']").val()));
        //            }
        //        $("#additional_discount_usd_"+d.vendor).attr("data-value",addDisc);   
        //        $("#additional_discount_usd_"+d.vendor).html(accounting.formatNumber(addDisc, 2));
                   
           
        //        var totalUsedDisc = 0;
        //        var totalUsedAddDisc = 0;
        //        var totalAfterAddDisc = 0;
        //        var totalAfterAddDiscUSD = 0;
        //        var currency_id = "";
        //        var _sign = "";
        //        var _rate = "";

        //        var groupTotalAfterAddDisc = "";


        //        var listAfterAddDiscount = [];
        //        $.each(pervendor, function (k, di) {

        //            currency_id = di.currency_id;
        //            di.exchange_rate = $("[name='target.exchange_rate']").val();
        //            _sign = di.exchange_sign;
        //            _rate = di.exchange_rate

                

        //            //populate additional discount
              
        //            var addDiscPerItem = delCommas(accounting.formatNumber(((di.line_total_usd / grandTotalUSDBeforeAddDisc) * addDisc) / di.exchange_rate, 6));
        //            totalUsedAddDisc += delCommas(accounting.formatNumber(((di.line_total_usd / grandTotalUSDBeforeAddDisc) * addDisc), 6));

        //            if (delCommas(accounting.formatNumber(totalUsedAddDisc, 6)) > delCommas(accounting.formatNumber(addDisc, 6))) {
        //                totalUsedAddDisc -= addDiscPerItem * di.exchange_rate;
        //                addDiscPerItem = delCommas(delCommas(accounting.formatNumber(addDisc, 6)) - delCommas(accounting.formatNumber(totalUsedAddDisc, 6)) / di.exchange_rate);
        //            }

        //            di.additional_discount = delCommas(accounting.formatNumber(addDiscPerItem, 6));

        //            if (isExistingData_ == false) {
        //                di.line_total = delCommas(accounting.formatNumber(di.cost - di.discount - di.additional_discount, 2));
        //            }
                    
        //            

        //            if (isExistingData_ == false) {
        //                if (_sign == "/") {
        //                    di.line_total_usd = delCommas(accounting.formatNumber(di.line_total / delCommas(_rate), 2));
        //                } else {
        //                    di.line_total_usd = delCommas(accounting.formatNumber(di.line_total * delCommas(_rate), 2));
        //                }
        //            }                    

        //            //update cost center detail
        //            if (additionalDiscountVendor == di.vendor) {
        //                populateCostCenterDetail(di.pr_detail_id, di.id,di.line_total, di.line_total_usd);
        //            }
                 
        //            totalAfterAddDisc += di.line_total;
        //            totalAfterAddDiscUSD += di.line_total_usd;

        //            //populate group after additional discount
        //            var adid = listAfterAddDiscount.findIndex(x => x.currency_id === di.currency_id);
        //            if (adid == -1) {
        //                listAfterAddDiscount.push({ currency_id: di.currency_id, line_total: di.line_total, line_total_usd: di.line_total_usd });
        //            } else {
        //                var temp = listAfterAddDiscount[adid];
        //                temp.line_total += di.line_total;
        //                temp.line_total_usd += di.line_total_usd;
        //            }



        //        });

        //        //group after Additional discount
        //        $.each(listAfterAddDiscount, function (k, di) {
        //            if (di.currency_id == null) {
        //                groupTotalAfterAddDisc += accounting.formatNumber(di.line_total, 2) + " <br>";
        //            } else {
        //                groupTotalAfterAddDisc += di.currency_id + " " + accounting.formatNumber(di.line_total, 2) + " <br>";
        //            }
        //        });

        //        $("#TotalAfterAddDisc_" + d.vendor).html(groupTotalAfterAddDisc);

        //        $("#TotalAfterAddDiscUSD_" + d.vendor).text(accounting.formatNumber(totalAfterAddDiscUSD, 2));


        //    });
        //}

        function populateCostCenterDetail(pr_detail_id,vendor_selection_detail_id, amount, amount_usd) {

            if (_id != "") {
                var data = $.grep(vsItems, function (n, i) {
                    return n["id"] == vendor_selection_detail_id;
                });
            } else {
                var data = $.grep(vsItems, function (n, i) {
                    return n["pr_detail_id"] == pr_detail_id;
                });
            }

            $.each(data, function (i, d) {

                if (d.detail_chargecode.length > 0 && d.vendor == additionalDiscountVendor) {

                    if (_id != "") {
                        var cc = $.grep(d.detail_chargecode, function (n, i) {
                            return n["vendor_selection_detail_id"] == d.id;
                        });
                    } else {
                        var cc = $.grep(d.detail_chargecode, function (n, i) {
                            return n["pr_detail_id"] == pr_detail_id;
                        });
                    }
                  


                    var total = 0;
                    var total_usd = 0;
                    $.each(cc, function (i, cd) {
                        cd.amount = delCommas(accounting.formatNumber((cd.percentage / 100) * amount, 2));
                        cd.amount_usd = delCommas(accounting.formatNumber((cd.percentage / 100) * amount_usd, 2));
                        total += cd.amount;
                        total_usd += cd.amount_usd;
                    });

                    total = delCommas(accounting.formatNumber(total, 2));
                    total_usd = delCommas(accounting.formatNumber(total_usd, 2));

                    //adjust Amount
                    while (total != amount) {
                        let last = cc.length - 1;
                        if (total > amount) {
                            cc[last].amount = cc[last].amount - 0.01;
                            total = total - 0.01;

                        } else {
                            cc[last].amount = cc[last].amount + 0.01;
                            total = total + 0.01;
                        }

                        total = delCommas(accounting.formatNumber(total, 2));
                    }

                    //adjust amount usd
                    while (total_usd != amount_usd) {
                        let last = cc.length - 1;
                        if (total_usd > amount_usd) {
                            cc[last].amount_usd = cc[last].amount_usd - 0.01;
                            total_usd = total_usd - 0.01;

                        } else {
                            cc[last].amount_usd = cc[last].amount_usd + 0.01;
                            total_usd = total_usd + 0.01;
                        }
                        total_usd = delCommas(accounting.formatNumber(total_usd, 2));
                    }

                }

            });
        }

        function populateListCurrencyItems() {
            $.each(vsItems, function (i, di) {
                var id = listCurrencyItems.findIndex(x => x.currency_id === di.currency_id);
                if (id == -1) {
                    listCurrencyItems.push({ currency_id: di.currency_id, exchange_rate: di.exchange_rate});
                } 
            });
        }

  
        function populateUsedItems() {
            usedPRItems = null;
            usedPRItems = [];

            $.each(vsItems, function (i, d) {
                usedPRItems.push(d.pr_detail_id);
            });

            usedPRItems = unique(usedPRItems);
        }

        $(document).on("click", ".btnDelete", function () {
            var _sid = $(this).closest("tr").find("input[name='pr_detail_id']").val();
            if (_sid != "") {
                var dels = $.grep(vsItems, function (n, i) {
                    return n["pr_detail_id"] == _sid;
                });

                $.each(dels, function (i, d) {
                    if (d.id != "" && d.id != null && typeof d.id !== "undefined") {
                        var _del = new Object();
                        _del.id = d.id;
                        _del.table = "item";
                        deletedId.push(_del);
                    }

                    if (d.id == "") {
                        var idx = vsItems.findIndex(x => x.uid == d.uid);
                        if (idx != -1) {
                            vsItems.splice(idx, 1);
                        }
                    } else {
                        var idx = vsItems.findIndex(x => x.id == d.id);
                        if (idx != -1) {
                            vsItems.splice(idx, 1);
                        }
                    }
                   
                })

                var idx = vsItemsMain.findIndex(x => x.pr_detail_id == _sid);
                if (idx != -1) {
                    vsItemsMain.splice(idx, 1);
                };
            }
            if (vsItems.length == 0) {
                $("#tblVSItem thead").html("");
                $("#tblVSItem tbody").html("");
                $("#tblVSItem tfoot").html("");

                headerArr = [];
                detailSupport = [];
                vsItemsMain = [];
                dataQuotation = [];
                vendor_ids = [];
                PopulateVSItem();
            }
            $(this).closest("tr").remove();
            $("#chargecode_" + _sid).remove();

            populateDetailSupport();
            repopulateTotalDiscount();

            calculateTotal();
            populateUsedItems();
            repopulateNumber();
        });

        $(document).on("click", ".btnDeleteDoc", function () {
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

            $(this).closest("tr").remove();
        });

        $(document).on("change", "input[name='filename']", function () {
            
            var obj = null;
            if ($(this).hasClass("justification")) {
                
                obj = $(this).closest("td").find("input[name='justification_file']");
                $(this).closest("td").find("input[name='justification.uploaded']").val('0');
                
            } else {
                obj = $(this).closest("tr").find("input[name='attachment.filename']");
                $(this).closest("tr").find("input[name$='attachment.uploaded']").val("0");
            }
            
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

                $(this).closest("td").find("input[name='justification_file']").val(filename);
            }
        });

        $(document).on("click", ".editDocument", function () {
            var obj = $(this).closest("td").find("input[name='filename']");
            var link = $(this).closest("td").find(".linkDocument");

            $(this).closest("tr").find("input[name$='attachment.uploaded']").val("0");
            $(this).closest("td").find(".btnFileUpload").show();

            $(this).closest("tr").find("input[name$='justification.uploaded'][data-vendor='" + $(this).data("vendor") + "']").val("0");
            $("[name='justification_file'][data-vendor='" + $(this).data("vendor") + "']").val('');
            $(this).closest("td").find(".btnFileUploadJustification").show();

            $(obj).show();
            $(link).hide();
            $(this).hide();
        });

        $(document).on("click", "#btnCancel", function () {
            $("#CancelForm").modal("show");
        });

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

                $("input[name='doc_id']").val($("#vs_id").val());
                UploadFileAPI("");
                $(this).closest("div").find("input[name$='cancellation.uploaded']").val("1");
                $(this).closest("div").find("input[name$='cancellation_file']").css({ 'background-color': '' });
            }
        });

        $(document).on("change", "input[name='cancellation_file']", function (e) {
            $("input[name$='cancellation.uploaded']").val("0");
        });

        $(document).on("click", ".btnFileUpload,.btnFileUploadJustification", function () {
            $("#action").val("fileupload");

            btnFileUpload = this;

            if ($(this).data("type") == "file_justification") {
                $("#file_name").val($(this).closest("div").find("input[name='filename'][data-vendor='" + $(this).data("vendor") + "']").val().split('\\').pop());
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
                        $("#error-message").html("<b>" + "- Supporting document(s):" + "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" + errorMsg + "<b>");
                        $("#error-box").show();
                        $('.modal-body').animate({ scrollTop: 0 }, 500);
                    } else {
                        showErrorMessage(errorMsg);
                    }

                    return false;
                }

                UploadFileAPI("");
                //direct_to_finance_file
                if ($(this).data("type") == "file_justification") {
                    $(this).closest("div").find("input[name$='justification.uploaded'][data-vendor='" + $(this).data("vendor") + "']").val("1");
                    $(this).closest("div").find("input[name$='filename']").css({ 'background-color': '' });
                } else {
                    $(this).closest("tr").find("input[name$='attachment.uploaded']").val("1");
                    $(this).closest("tr").css({ 'background-color': '' });
                }
            }
        });

        function GenerateFileLink(row, filename) {
            var vs_id = '';
            var linkdoc = '';

            if ($("#vs_id").val() == '' || $("#vs_id").val() == null) {
                vs_id = $("[name='docidtemp']").val();
                linkdoc = "FilesTemp/" + vs_id + "/" + filename + "";
            } else {
                vs_id = $("#vs_id").val();
                linkdoc = "Files/" + vs_id + "/" + filename + "";
            }

            $(row).closest("td").find("input[name$='filename']").hide();

            $(row).closest("td").find(".editDocument").show();
            $(row).closest("td").find("a#linkDocument").attr("href", linkdoc);
            $(row).closest("td").find("a#linkDocument").text(filename);
            $(row).closest("td").find(".linkDocument").show();

            if ($(row).data("type") == "file_justification") {
                $(row).closest("td").find(".btnFileUploadJustification").hide();
            } else {
                $(row).closest("tr").find(".btnFileUpload").hide();
            }
            
        }

        $(document).on("click", "#btnFundsCheck", function () {

            var fundsCheckChargeCodes = [];
            errorMsgFundsCheck = '';

            btnAction = $(this).data("action").toLowerCase();

            sleep(1).then(() => {
                blockScreenOL();

            });

            sleep(300).then(() => {
                if (vsItems.length > 0) {
                    vsItems.forEach(function (item) {
                        item.detail_chargecode.forEach(function (chargeCode) {
                            chargeCode.pr_id = item.pr_id;
                            fundsCheckChargeCodes.push(chargeCode);
                        });
                    });

                    if (errorMsgFundsCheck !== "") {
                        showErrorMessage(errorMsgFundsCheck);
                    } else {
                        alert('Budget is sufficient');
                    }


                } else {
                    alert('please fill product first');
                }
                unBlockScreenOL();
            }).then(() => {
            });


        });

        var uploadValidationResult = {};
	    $(document).on("click", "#btnSave,#btnSubmit,#btnSaveCancellation", function () {
            sleep(1).then(() => {
                blockScreenOL();
            });

            sleep(300).then(() => {
                var thisHandler = $(this);
                var filedoctype = thisHandler.data("type");
                hideFundsCheckMessage();

                if (!$.trim($("[name='pr.direct_to_finance_justification']").val())) {
                    $("[name=cancellation_file],[name=direct_to_finance_file],[name=filename" + filedoctype + "]").uploadValidation(function (result) {

                        uploadValidationResult = result;
                        onBtnClickSave.call(thisHandler);
                    });
                } else {
                    $("[name=cancellation_file],[name=filename" + filedoctype + "]").uploadValidation(function (result) {

                        uploadValidationResult = result;
                        onBtnClickSave.call(thisHandler);
                    });
                }


            }).then(() => {
                /*   unBlockScreenOL();*/
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
            var quotation_detail_ids = [];
            var errJustifFile = 0;

            var data = new Object();
            data.id = $("#vs_id").val();
            data.vs_no = $("#vs_no").val();
            data.cifor_office_id = cifor_office;
            data.currency_id = $("select[name='target.currency']").attr("selected", "selected").val();
            data.exchange_rate = delCommas(accounting.formatNumber(delCommas($("[name='target.exchange_rate']").val()), 8)) ;
            data.exchange_sign = $("[name='target.exchange_sign']").val();
            data.document_date = $("[name='vs.document_date']").val();
            data.status_id = $("#status").val();
            data.temporary_id = $("[name='docidtemp']").val();
            data.sundry = [];
            $.each(vsItems, function (i, d) {
                d.indent_time = $("[name='indent_time'][data-vendor='" + d.vendor + "']").val();
                d.warranty_time = $("[name='warranty_time'][data-vendor='" + d.vendor + "']").val();
                d.expected_delivery_date = $("[name='expected_delivery_date'][data-vendor='" + d.vendor + "']").val();
                if ($("[name='is_selected'][data-vendor='" + d.vendor + "']").prop("checked")) {
                    d.is_selected = 1;
                    data.currency_id = d.currency_id;
                    data.exchange_sign = d.exchange_sign;
                    data.exchange_rate = d.exchange_rate;
                    var sundry_detail = $.grep(dataSundry, function (n, k) {
                        return n["sundry_supplier_id"] == d.vendor_code
                    });
                    if (sundry_detail.length > 0) {
                        data.sundry.push(sundry_detail[0]);
                    }
;                } else {
                    d.is_selected = 0;
                }           

                d.reason_for_selection = $("[name='reason_for_selection'][data-vendor='" + d.vendor + "']").val();
                d.remarks = $("[name='remarks'][data-vendor='" + d.vendor + "']").val();
                d.justification_file = $("[name='justification_file'][data-vendor='" + d.vendor + "']").val();

                if ($("input[name='justification.uploaded'][data-vendor='" + d.vendor + "']").val() == "0" && d.justification_file != "") {
                    if (errJustifFile == 0) {
                        errorMsg += "<br/> - There are justification file that have not been uploaded, please upload first.";
                    }
                    $("input[name='filename'][data-vendor='" + d.vendor + "']").css({ 'background-color': 'rgb(245, 183, 177)' });
                    errJustifFile++;
                }

                quotation_detail_ids.push(d.quotation_detail_id);
            });
            
            if (data.exchange_rate == "" || typeof data.exchange_rate === "undefined" || data.exchange_rate == null)
                data.exchange_rate = 0;

            data.details = vsItems;
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

            var fundsCheckChargeCodes = [];
            if (btnAction == "submitted" || btnAction == "updated") {
                data.details.forEach(function (item) {
                    item.detail_chargecode.forEach(function (chargeCode) {
                        chargeCode.pr_id = item.pr_id;
                        fundsCheckChargeCodes.push(chargeCode);
                    });
                });
                if (btnAction == "submitted") {
                    $.ajax({
                        url: "<%=Page.ResolveUrl("Input.aspx/isQuotationValid")%>",
                        data: JSON.stringify({ quotation_detail_ids: quotation_detail_ids.join(";") }),
                        dataType: 'json',
                        type: 'post',
                        contentType: "application/json; charset=utf-8",
                        success: function (response) {
                            var output = JSON.parse(response.d);
                            if (output.result != "success") {
                                alert(output.message);
                            } else {
                                if (output.valid == "0") {
                                    errorMsg += "<br/> - Quotation(s) are cancelled. You cannot proceed this quotation analysis.";
                                }
                                
                                errorMsg += GeneralValidation();
                                errorMsg += FileValidation();
                                let cc = $.grep(data.details, function (n, i) {
                                    return n["is_selected"] == 1;
                                });

                                if (cc.length > 0) {
                                    /*errorMsg += CheckSupplier(cc[0]['vendor_code']);*/
                                }
                                
                                SubmitProcess(errorMsg, data, deletedId, workflow, currstatus_id);
                            }
                        }
                    });
                } else {
                    errorMsg += GeneralValidation();
                    errorMsg += FileValidation();
                    let cc = $.grep(data.details, function (n, i) {
                        return n["is_selected"] == 1;
                    });

                    if (cc.length > 0) {
                        /*errorMsg += CheckSupplier(cc[0]['vendor_code']);*/
                    }

                    SubmitProcess(errorMsg, data, deletedId, workflow, currstatus_id);
                }
            } else {
                errorMsg += FileValidation();
                SubmitProcess(errorMsg, data, deletedId, workflow, currstatus_id)
            }            
        }

        function SubmitProcess(errorMsg, data, deletedId, workflow, currstatus_id) {
            if (errorMsg !== "") {
                unBlockScreenOL();
                showErrorMessage(errorMsg);

                return false;
            } else {
                var _data = {
                    "submission": JSON.stringify(data),
                    "deletedIds": JSON.stringify(deletedId),
                    "workflows": JSON.stringify(workflow),
                    "currstatus": currstatus_id,
                    "additionaldiscountvendor": additionalDiscountVendor
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
                            $("#vs_no").val(output.vs_no);
                            $("#vs_id").val(output.id);
                            $("input[name='doc_id']").val(output.id);
                            $("input[name='action']").val("fileupload");
                            //UploadFile();

                            UploadFileAPI("submit");
                        }
                    }
                }
            });
        }

        function UploadFile() {
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
                        alert("Quotation analysis " + $("#vs_no").val() + " has been " + btnAction + " successfully.");
                        blockScreen();
                        if (btnAction.toLowerCase() == "saved") {
                            parent.location.href = "Input.aspx?id="+$("#vs_id").val();
                        } else {
                            parent.location.href = "List.aspx";
                        }
                    }
                }
            });
        }

        function UploadFileAPI(actionType) {
            blockScreenOL();
            var form = $('form')[0];
            var formData = new FormData(form);
            $.ajax({
                type: "POST",
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
                        alert("Quotation analysis " + $("#vs_no").val() + " has been " + btnAction + " successfully.");
                        if (btnAction.toLowerCase() == "saved") {
                            parent.location.href = "Input.aspx?id=" + $("#vs_id").val();
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

        $(document).on("click", "#btnClose", function () {
            location.href = "List.aspx";
        });

        function populateVendorIds() {
            vendor_ids = [];
            $.each(vsItems, function (i, d) {
                var vendor = d.vendor.split("_");
                vendor_ids.push(vendor[0]);
            });

            vendor_ids = unique(vendor_ids);
			if(vendor_ids.join(";")!=""){
				vendor_ids = [vendor_ids.join(";")];
			}
        }

        function populateCurrencyIds() {
            currency_ids = [];
            $.each(vsItems, function (i, d) {
                currency_ids.push(d.currency_id);
            });

			currency_ids = unique(currency_ids);
			if(currency_ids.join(";")!=""){
				currency_ids = [currency_ids.join(";")];
			}
        }

        /* supporting documents */
        $(document).on("click", "#btnAddAttachment", function () {
            addAttachment("", "", "", "");
        });

        function addAttachment(id, uid, description, filename) {
            var _id = $("#vs_id").val();
            if (uid === "" || typeof uid === "undefined" || uid === null) {
                var uid = guid();
            }
            var html = '<tr>';
            html += '<td><input type="hidden" name="attachment.uid" value="' + uid + '"/><input type="text" class="span12" name="attachment.file_description" data-title="Supporting document description" data-validation="required" maxlength="1000" placeholder="Description" value="' + description + '"/></td>';
            html += '<td><input type="hidden" name="attachment.filename" data-title="Supporting document file" data-validation="required" value="' + filename + '"/><div class="fileinput_' + uid + '">';
            if (id !== "" && filename !== "") {
                html += '<span class="linkDocument"><a href="Files/' + _id + '/' + filename + '" target="_blank" id="linkDocument">' + filename + '</a>&nbsp;</span>';
                html += '<button type="button" class="btn btn-primary editDocument" data-type="filegeneral">Edit</button><input type="file" class="span10" name="filename" style="display: none;"/>';
                html += '<button type="button" class="btn btn-success btnFileUpload" data-type="filegeneral" style="display:none;">Upload</button>';
            } else {
                html += '<span class="linkDocument"><a href="" target="_blank" id="linkDocument">' + filename + '</a>&nbsp;</span>';
                html += '<button type="button" class="btn btn-primary editDocument" style="display: none;">Edit</button><input type="file" class="span10" name="filename"/>';
                html += '<button type="button" class="btn btn-success btnFileUpload" data-type="filegeneral">Upload</button>';
            }
            html += '</div></td > ';
            html += '<td><input type="hidden" name="attachment.id" value="' + id + '"/><span class="label red btnDeleteDoc" title="Delete"><i class="icon-trash delete" style="opacity: 1;"></i></span></td>';
            if (filename !== "") {
                html += '<td style="display:none;"><input type="hidden" name="attachment.uploaded" value="1"/></td>';
            } else {
                html += '<td style="display:none;"><input type="hidden" name="attachment.uploaded" value="0"/></td>';
            }
            html += '</tr>';
            $("#tblAttachment tbody").append(html);
        }

        function setdetailcc() {

            if (_id != "") {
                $.each(vsItemsMain, function (i, d) {

                    var cc = $.grep(listChargeCode, function (n, i) {
                        return n["vendor_selection_detail_id"] == d.id;
                    });

                    d.detail_chargecode = cc;

                });

                $.each(vsItems, function (i, d) {
                    var cc = $.grep(listChargeCode, function (n, i) {
                        return n["vendor_selection_detail_id"] == d.id;
                    });

                    d.detail_chargecode = cc;

                });
            } else {
                $.each(vsItemsMain, function (i, d) {

                    var cc = $.grep(listChargeCode, function (n, i) {
                        return n["pr_detail_id"] == d.pr_detail_id;
                    });

                    d.detail_chargecode = cc;

                });

                $.each(vsItems, function (i, d) {
                    var cc = $.grep(listChargeCode, function (n, i) {
                        return n["pr_detail_id"] == d.pr_detail_id;
                    });

                    d.detail_chargecode = cc;

                });
            }

          
        }

        //Sundry supplier
        $(document).on("click", ".btnSundryEdit", function () {

            // Regular expression to check if string is a valid UUID
            const regexExp = /^[0-9a-fA-F]{8}\b-[0-9a-fA-F]{4}\b-[0-9a-fA-F]{4}\b-[0-9a-fA-F]{4}\b-[0-9a-fA-F]{12}$/gi;

            var id = $(this).attr("data-id");
            var idx = "";
            if (regexExp.test(id)) {
                idx = vsItems.findIndex(x => x.uid == id);
            } else {
                idx = vsItems.findIndex(x => x.id == id);
            }
           
            var d = vsItems[idx];
            EditSundry(d);
        });

        function EditSundry(d) {
            $("#SundryForm tbody").empty();
            $("#SundryForm-error-message").empty();
            $("#SundryForm-error-box").hide();

            var qa_id = d.id != "" ? d.id : d.uid;
            var html = AddDetailSundrySupplierHTML(d.vendor_name, d.vendor_code, d.vendor, qa_id, "quotationanalysis");
            //html += '<tr>'
            //    + '<td>Sundry </td>'
            //    + '<td>' +d.vendor_name 
            //    + '<input type="hidden" name="sundry.id" value="'+d.vendor_code+'" data-vendor="'+d.vendor+'" data-qa-id = "'+qa_id+'" >'
            //    + '</td>'
            //    + '</tr>'
            //    + '<tr>'
            //    + '<td>Name <span style="color: red;">*</span></td>'
            //    + '<td>'
            //    + '<div class="">'
            //    + '<div class="">'
            //    + '<input type="text" name="sundry.name" placeholder="Name" value="" class="span12"/>'
            //    + '</div>'
            //    + '</div>'
            //    + '</td>'
            //    + '</tr>'
            //    //
            //    + '<tr>'
            //    + '<td>Contact person <span style="color: red;">*</span></td>'
            //    + '<td>'
            //    + '<div class="">'
            //    + '<div class="">'//
            //    + '<input type="text" name="sundry.contact_person" placeholder="Contact person" value="" class="span12"/>'
            //    + '</div>'
            //    + '</div>'
            //    + '</td>'
            //    + '</tr>'
            //    //
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
            //    + '<tr>'
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
            //    + '<textarea name="sundry.address" class="textareavertical span12" maxlength="2000" rows="10" placeholder="address"></textarea>'
            //    + '<div class="mt-1" style="font-size: 80%; font-style: italic; display: block;">Maximum description is 2,000 characters</div>'
            //    + '</td>'
            //    + '</tr>'
            //    + '<tr>'
            //    + '<td>Place <span style="color: red;">*</span></td>'
            //    + '<td>'
            //    + '<div class="">'
            //    + '<div class="">'
            //    + '<input type="text" name="sundry.place" placeholder="Place" value="" class="span12"/>'
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
            populateSundry(d);
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
                errorMsg += "<br/> - Email is required.";
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

                var sundry_supplier_id = $("[name='sundry.id']").val();
            
                var data = new Object();
                data.id = "";
                data.sundry_supplier_id = sundry_supplier_id;
                data.module_id = "";
                data.module_type = "";
                data.name = $("[name='sundry.name']").val();
                data.contact_person = $("[name='sundry.contact_person']").val();
                data.email = $("[name='sundry.email']").val();
                data.phone_number = $("[name='sundry.phone_number']").val();
                data.address = $("[name='sundry.address']").val();
                data.bank_account = $("[name='sundry.bank_account']").val();
                data.swift = $("[name='sundry.swift']").val();
                data.sort_code = $("[name='sundry.sort_code']").val();
                data.place = $("[name='sundry.place']").val();
                data.province = $("[name='sundry.province']").val();
                data.post_code = $("[name='sundry.post_code']").val();
                data.vat_reg_no = $("[name='sundry.vat_reg_no']").val();

                // check data sundry
                var ids = dataSundry.findIndex(x => x.sundry_supplier_id == sundry_supplier_id);
                if (ids != -1) {
                    data.id = dataSundry[ids].id;
                    dataSundry.splice(ids, 1); // remove sundry
                }

                dataSundry.push(data);
                var vendor = $("[name='sundry.id']").attr("data-vendor");
                var qa_id = $("[name='sundry.id']").attr("data-qa-id");
                var btnEditSundry = '<span class="label green btnSundryEdit" data-toggle="modal" href="#SundryForm" title="Detail" data-id = ' + qa_id + '><i class="icon-pencil edit" style="opacity: 0.7;"></i></span >'
                $("#vendorAddress_" + vendor).html("- " + setSundryAddress(data) + " " + btnEditSundry+"<br>");
                $("#SundryForm").modal("hide");
            }
        }

        function populateSundry(d) {
            var header_id = _id;
            var quotation_id = d.q_id;
            var qa_id = d.id != "" && d.is_selected == "1" ? header_id : "";

            $.ajax({
                url: "<%=Page.ResolveUrl("Input.aspx/getSundry")%>",
                data: JSON.stringify({ id1: qa_id, id2: quotation_id }),
                  dataType: 'json',
                  type: 'post',
                  contentType: "application/json; charset=utf-8",
                  success: function (response) {
                      var output = JSON.parse(response.d);
                      if (output.result == "success")
                      {
                          var d = JSON.parse(output.data);
                          if (d.length > 0) {
                              var ids = dataSundry.findIndex(x => x.sundry_supplier_id == d[0].sundry_supplier_id);
                              if (ids != -1) {
                                  $("[name='sundry.name']").val(dataSundry[ids].name);
                                  $("[name='sundry.address']").text(dataSundry[ids].address);
                                  $("[name='sundry.contact_person']").val(dataSundry[ids].contact_person);
                                  $("[name='sundry.email']").val(dataSundry[ids].email);
                                  $("[name='sundry.phone_number']").val(dataSundry[ids].phone_number);
                                  $("[name='sundry.bank_account']").val(dataSundry[ids].bank_account);
                                  $("[name='sundry.swift']").val(dataSundry[ids].swift);
                                  $("[name='sundry.sort_code']").val(dataSundry[ids].sort_code);
                                  $("[name='sundry.place']").val(dataSundry[ids].place);
                                  $("[name='sundry.province']").val(dataSundry[ids].province);
                                  $("[name='sundry.post_code']").val(dataSundry[ids].post_code);
                                  $("[name='sundry.vat_reg_no']").val(dataSundry[ids].vat_reg_no);
                              } else {
                                  $("[name='sundry.name']").val(d[0].name);
                                  $("[name='sundry.address']").text(d[0].address);
                                  $("[name='sundry.contact_person']").val(d[0].contact_person);
                                  $("[name='sundry.email']").val(d[0].email);
                                  $("[name='sundry.phone_number']").val(d[0].phone_number);
                                  $("[name='sundry.bank_account']").val(d[0].bank_account);
                                  $("[name='sundry.swift']").val(d[0].swift);
                                  $("[name='sundry.sort_code']").val(d[0].sort_code);
                                  $("[name='sundry.place']").val(d[0].place);
                                  $("[name='sundry.province']").val(d[0].province);
                                  $("[name='sundry.post_code']").val(d[0].post_code);
                                  $("[name='sundry.vat_reg_no']").val(d[0].vat_reg_no);
                              }
                          }
                      }
                  }
              });
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

        function CheckSupplier(vs_id) {
            var errMessage = "";
            $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                url: '<%= Page.ResolveUrl("~/" + based_url+service_url + "/CheckSupplier") %>',
                async: false,
                data: "{'vs_id':'" + vs_id + "'}",
                dataType: "json",
                success: function (response) {
                    var result = JSON.parse(response.d);

                    if (result.length > 0) {
                        if (result[0].ocs_supplier_id == '' || result[0].ocs_supplier_id == null || result[0].ocs_supplier_id == 'undefined') {
                            errMessage += "<br> - Supplier cannot be used because it does not have a supplier id ocs";
                        }
                    }
                },
                error: function (jqXHR, exception) {
                    /*unBlockScreenOL();*/
                }
            });
            return errMessage;
        }

        //filter 
        $(document).ready(function () {
            var startDate = new Date("<%=startDate%>");
            var endDate = new Date("<%=endDate%>");
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
        });

        $(document).on("click", "#btnSearch", function () {
            loadItem();
        });


        //Terget currency
        function populateCurrency() {

            _currency = _currency == "" ? "USD" : _currency
            var data = $.grep(listCurrency, function (n, i) {
                return n["CURRENCY_CODE"] == _currency;
            });

            $("[name='target.exchange_rate']").val(data[0].RATE)
            $("[name='target.exchange_sign']").val(data[0].OPERATOR)
            var cboCurr = $("select[name='target.currency");
            cboCurr.empty();
            generateCombo(cboCurr, listCurrency, "CURRENCY_CODE", "CURRENCY_CODE", true);
            $(cboCurr).val(_currency);
            Select2Obj(cboCurr, "Currency");
        }

        $(document).on("change", "[name='target.currency']", function () {
            _currency = $(this).val();
            populateCurrency();
            //populateAdditionalDiscount();
            PopulateVSItem();
            populateDataPerVendor();
        })

        $(document).on("change", "[name='target.exchange_rate']", function () {


            var currency = $("select[name='target.currency']").attr("selected", "selected").val();
            var exchange_rate = $(this).val();
            $.each(vsItems, function (k, di) {
                if (di.currency_id == currency) {
                    di.exchange_rate = exchange_rate;
                }
            });

            $.each(listCurrencyItems, function (k, di) {
                if (di.currency_id == currency) {
                    di.exchange_rate = exchange_rate;
                }
            });
            calculateTotal();
            //populateDataPerVendor();
        });

        function populateWithTargetCurrency() {

            var currency = $("select[name='target.currency']").attr("selected", "selected").val();
            var rate = $("[name='target.exchange_rate']").val();
            var sign = $("[name='target.exchange_sign']").val();
            let isOriginalCurrency = false;

            $.each(vsItemsMain, function (i, d) {
                d.pr_currency = currency;
            });

            $.each(vsItems, function (i, d) {
                isOriginalCurrency = false;
                if (currency == d.currency_id_original) {
                    isOriginalCurrency = true;
                }

                d.currency_id = currency;
                d.exchange_rate = rate;
                d.exchange_sign = sign;
                //if (d.exchange_sign == "*") {
                //    d.cost = delCommas(d.cost_usd / delCommas(rate));
                //    d.discount = delCommas(d.discount_usd / delCommas(rate));
                //    d.unit_price = delCommas(d.unit_price_usd / delCommas(rate));
                //} else {
                //    d.cost = delCommas(d.cost_usd * delCommas(rate));
                //    d.discount = delCommas(d.discount_usd * delCommas(rate));
                //    d.unit_price = delCommas(d.unit_price_usd * delCommas(rate));
                //}
                d.cost = delCommas(d.cost_usd * delCommas(rate));
                d.discount = delCommas(d.discount_usd * delCommas(rate));
                d.unit_price = delCommas(d.unit_price_usd * delCommas(rate));

                if (isOriginalCurrency) {
                    d.cost = d.cost_original;
                    d.unit_price = d.unit_price_original;
                }
            });
            
        }
        //terget currency

        function populateAdditionalDiscount() {
            var vendor = [];
            $.each(vsItems, function (k, di) {
                vendor.push(di.vendor);
            });

            vendor = unique(vendor);

            for (let i = 0; i <= vendor.length; i++) {
                var addDisc = "";
                //convert USD to target currency
                addDisc = delCommas(accounting.formatNumber($("#additional_discount_usd_" + vendor[i]).attr("data-value") / delCommas($("[name='target.exchange_rate']").val()), 2));
                $("[name='additional_discount'][data-vendor='" + vendor[i] + "']").val(delCommas(addDisc));

            }
        }

        function FundsCheck(chargeCodes, errMessage) {
            if (btnAction == 'fundscheck') {
                blockScreenOL();
            }
            var params = [];
            let appSource = [];

            chargeCodes = [...new Map(chargeCodes.map(item => [item['pr_detail_cost_center_id'], item])).values()];

            chargeCodes.forEach(function (item) {
                var chargeCode = {
                    Costc: item.cost_center_id,
                    Workorder: item.work_order,
                    Entity: item.entity_id,
                    Account: item.control_account,
                    Amount: parseFloat(item.amount_usd)
                };
                params.push(chargeCode);

                let appSourceTemp = {
                    SourceId: item.pr_id + '.' + item.pr_detail_id,
                    SourceName: 'Procurement'
                };

                appSource.push(appSourceTemp);
            });



            appSource = [...new Map(appSource.map(item => [item['SourceId'], item])).values()];

            $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                url: '<%= Page.ResolveUrl("~/" + based_url+service_url + "/FundsCheck") %>',
                async: false,
                data: JSON.stringify({ data: [{ Data: params, ApplicationSource: appSource }] }),
                dataType: "json",
                success: function (response) {
                    var result = JSON.parse(response.d);
                    if (result.success == true && result.status == "200") {
                        result.data.forEach(function (item) {
                            if (item.Result == false) {
                                errMessage += "<br> - The budget for Cost center : " + item.Costc + ", Work order: " + item.WorkOrder + ", Entity : " + item.Entity + " has exceeded by USD " + accounting.formatNumber(item.Amount * -1, 2) + ", Account : " + item.control_account;
                            }
                        });
                    } else {
                        errMessage += "<br> - " + result.additionalInfo;
                    }
                    if (btnAction == 'fundscheck') {
                        unBlockScreenOL();
                    }
                },
                error: function (jqXHR, exception) {
                    /*unBlockScreenOL();*/
                }
            });
            return errMessage;
        }

        function sleep(ms) {
            return new Promise(resolve => setTimeout(resolve, ms));
        }

        //function CalculateAdjustment(vendor_code) {
        //    var pervendor = $.grep(vsItems, function (n, j) {
        //        return n["vendor"] == vendor_code;
        //    });

        //    let total_after_discount_temp = 0;
        //    let total_after_discount_usd_temp = 0;
        //    let total_after_discount = 0;
        //    let total_after_discount_usd = 0;
        //    let additional_discount = 0;
        //    let additional_discount_usd = 0;
        //    let additional_discount_temp = 0;

        //    total_after_discount = delCommas($("#TotalAfterDisc_" + vendor_code).attr("data-value"));
        //    total_after_discount_usd = delCommas($("#TotalUSD_" + vendor_code).html());
        //    additional_discount = delCommas($("[name='additional_discount'][data-vendor='" + vendor_code + "']").val());
        //    additional_discount_usd = delCommas($("#additional_discount_usd_" + vendor_code).html());

        //    $.each(pervendor, function (k, d) {
        //        total_after_discount_temp += d.line_total;
        //        total_after_discount_usd_temp += d.line_total_usd;
        //        additional_discount_temp += d.additional_discount;
        //    });

        //    let total_after_add_discount = total_after_discount - parseFloat(additional_discount);
        //    total_after_discount_temp = delCommas(accounting.formatNumber(total_after_discount_temp, 2));

        //    let total_after_add_discount_usd = total_after_discount_usd - parseFloat(additional_discount_usd);
        //    total_after_discount_usd_temp = delCommas(accounting.formatNumber(total_after_discount_usd_temp, 2));

        //    additional_discount_temp = delCommas(accounting.formatNumber(additional_discount_temp, 6));

        //    if (total_after_discount_temp != total_after_add_discount) {
        //        let gep_amt = total_after_discount_temp - total_after_add_discount;
        //        if (gep_amt > 0) {
        //            pervendor[0]["line_total"] = delCommas(accounting.formatNumber(pervendor[0]["line_total"] - gep_amt, 2));
        //        } else {
        //            pervendor[0]["line_total"] = delCommas(accounting.formatNumber(pervendor[0]["line_total"] + (gep_amt * -1), 2));
        //        }
        //    }

        //    if (total_after_discount_usd_temp != total_after_add_discount_usd) {
        //        let gep_amt_usd = total_after_discount_usd_temp - total_after_add_discount_usd;
        //        if (gep_amt_usd > 0) {
        //            pervendor[0]["line_total_usd"] = delCommas(accounting.formatNumber(pervendor[0]["line_total_usd"] - gep_amt_usd, 2));
        //        } else if (gep_amt_usd < 0) {
        //            pervendor[0]["line_total_usd"] = delCommas(accounting.formatNumber(pervendor[0]["line_total_usd"] + (gep_amt_usd * -1), 2));
        //        }
        //    }

        //    let gep_amt_add_discount = 0;
        //    gep_amt_add_discount = delCommas(accounting.formatNumber(additional_discount_temp - delCommas(accounting.formatNumber(additional_discount, 6)), 6));

        //    if (gep_amt_add_discount > 0) {
        //        pervendor[0]["additional_discount"] = delCommas(accounting.formatNumber(pervendor[0]["additional_discount"] - gep_amt_add_discount, 6));
        //    } else if (gep_amt_add_discount < 0) {
        //        pervendor[0]["additional_discount"] = delCommas(accounting.formatNumber(pervendor[0]["additional_discount"] + (gep_amt_add_discount * -1), 6));
        //    }

        //    $("#TotalAfterAddDisc_" + vendor_code).html(pervendor[0]["currency_id"] + " " + accounting.formatNumber(total_after_add_discount, 2));
        //    $("#TotalAfterAddDiscUSD_" + vendor_code).html(accounting.formatNumber(total_after_add_discount_usd, 2));
        //}

        //function ExistingData() {
        //    isExistingData_ = false;
        //}
    </script>
</asp:Content>
