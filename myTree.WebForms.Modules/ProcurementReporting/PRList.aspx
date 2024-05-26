<%@ Page MasterPageFile="~/Procurement.Master" Language="C#" AutoEventWireup="true" CodeBehind="PRList.aspx.cs" Inherits="Procurement.ProcurementReporting.PRList" %>

<%@ Import Namespace="Procurement.ProcurementReporting" %>


<asp:Content ID="Content1" ContentPlaceHolderID="AppHead" runat="server"> 
    <title>Purchase requisition Reporting </title>
 
    <style type="text/css">
        .tfoot {
            border-bottom: 1px solid #ddd !important;
            background-color:#f0f8db;
        }
        .alignRight {
            text-align: right !important; 
        }
        .alignCenter {
            text-align: center !important; 
        }
        form.form-horizontal.contentForm .control-group {
            padding-bottom: 0px !important;
            border-bottom: 1px solid #f5f5f5 !important;
        }
        .form-horizontal .control-group {
            margin-bottom: 0px !important;
        }
        .form-horizontal .control-group {
            margin-bottom: 10px !important;
        }
        label {
            font-size: 13px !important;
        }
        form.form-horizontal.contentForm .control-group.last {
            padding-bottom: 0 !important;
            border-bottom: 0 !important;
        }
        .row-fluid [class*="span"] {
            min-height: 30px !important;
        }
        #TblPRList tbody tr td, .clsAllocation
        {
            text-align: right !important;
            
        }
        .text-wrap{
            white-space:normal;
        }
        .width-300{
            width:300px;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="AppBody" runat="server">    
    <form id="form1" type="post" class="form-horizontal contentForm">
    <div class="floatingBox table">
        <div class="container-fluid">
            <div id="error-box" style="display: none">
                <div class="alert alert-error" id="error-message">
                </div>
            </div>
            <div class="control-group">
                <label class="control-label" style="text-align: left; width: 120px">
                    Period
                </label>
                <div class="controls divselinst" style="margin-left: 90px;">
                    <div class="input-prepend" style="margin-right:-32px;">
                        <input type="text" name="StartDate" id="_StartDate" data-title="Start date" data-validation="required" class="span8" readonly="readonly" placeholder="Start date" maxlength="11" value="<%=startDate %>" />
                        <span class="add-on icon-calendar" id="StartDate"></span>
                    </div>
                    To&nbsp;&nbsp;&nbsp;
                    <div class="input-prepend">
                        <input type="text" name="EndDate" id="_EndDate" data-title="End date" data-validation="required" class="span8" readonly="readonly" placeholder="End date" maxlength="11" value="<%=endDate %>" />
                        <span class="add-on icon-calendar" id="EndDate"></span>
                    </div>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label" style="text-align: left; width: 120px">
                    Procurement office
                </label>
                <div class="controls divselinst" style="margin-left: 90px;">
                    <select id="cboOffice" name="cifor_office" style="width: 30%;" class="span2 select2" data-placeholder="Select procurement office">
                        <option value="ALL">ALL PROCUREMENT OFFICES</option>
                    </select>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label" style="text-align: left; width: 120px">
                    PR Type
                </label>
                <div class="controls divselinst" style="margin-left: 90px;">
                    <select id="SelType" name="Type" style="width: 30%;" class="span2 select2" data-placeholder="Select a type">
                            <option value="1">All</option>
                            <option value="2">PR For Procurement</option>
                            <option value="3">PR For Finance</option>
                    </select>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label" style="text-align: left; width: 120px">
                    Requester Team 
                </label>
                <div class="controls divselinst" style="margin-left: 90px;">
                    <select id="SelTeam" name="TEAM" style="width: 30%;" class="span2 select2" data-placeholder="Select teams">
                        <option value="ALL">All teams</option>
                    </select>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label" style="text-align: left; width: 120px">
                    Requester
                </label>
                <div class="controls divselinst" style="margin-left: 90px;">
                    <select id="SelStaff" name="STAFF_ID" style="width: 30%;" class="span2 select2" data-placeholder="Staff name"
                        multiple="multiple">
                        <option value="ALL">All staff</option>
                    </select>
                </div>
            </div>
            <div class="control-group last">
                <div>
                    <button id="btnSearch" value="Search" class="btn btn-small btn-success" style="float: none;
                        display: inline; margin: 0px;">
                        Search</button>
                </div>
            </div>
        </div> 
    </div>
    <div class="floatingBox" style="margin-bottom:0px;">
        <div class="container-fluid">
            <div class="controls text-right">
                <input type="submit" name= "btnExport" value="Export to excel" class="btn btn-small btn-success btnExportExcel"
                style="float: Right;display:none" />
            </div> 
        </div>
    </div>
     <div class="control-group">
    </div>
    <div class="floatingBox table">
        <div class="container-fluid" style="width: 100%">
            <div style="width: 97%; overflow-x: auto; white-space: nowrap; display: block;">
                <span style="margin-bottom:5px;"><i>Scroll right to see more information</i></span><br /><br />
                <table id="tblPRList" class="table table-bordered table-condensed tfoot" style="white-space: nowrap;" width="100%">
                    <thead>
                        <tr>
                            <th>
                                PR code
                            </th>
                            <th>
                                PR status
                            </th>
                            <th>
                                PR created date
                            </th>
                            <th>
                                PR submission date
                            </th>
                            <th>
                                PR submission time
                            </th>
                            <th>
                                Project code	
                            </th>
                            <th>
                                Required date
                            </th>
                            <th>
                                Expected order date	
                            </th>
                            <th>
                                Initiator	
                            </th>
                            <th>
                                Requester
                            </th>	
                            <th>
                                Requester team
                            </th>
                            <th>
                                Product code
                            </th>	
                            <th>
                                Product description
                            </th>	
                             <th>
                                Unit price (USD)
                            </th>	
                            <th>
                                PR Qty
                            </th>	
                            <th>
                                Currency
                            </th>	
                            <th>
                                Cost estimated
                            </th>	
                            <th>
                                Direct purchase
                            </th>
                            <th>
                                Product status
                            </th>
                            <th>	
                                Quotation analysis
                            </th>
                            <th>
                                PO Qty	
                            </th>
                            <th>
                                PO code	
                            </th>
                            <th>
                                Expected delivery date	
                            </th>
                            <th>
                                Remarks
                            </th>
                            <th> 
                                PR type
                            </th>
                            <th>
                                Procurement office
                            </th>
                        </tr>
                    </thead>
                    <tfoot>
                        <tr>
                        </tr>
                    </tfoot>
                </table>
            </div>
        </div>
    </div>
    <input type="hidden" id="hidTeam" name="hidTeam" />
    <input type="hidden" id="hidStaff" name="hidStaff" />
    <input type="hidden" id="hidStaffName" name="hidStaffName" />
    <input type="hidden" id="hidTeamName" name="hidTeamName" />
    <input type="hidden" id="hidStartDate" name="hidStartDate" />
    <input type="hidden" id="hidEndDate" name="hidEndDate" />
    <input type="hidden" id="hidType" name="hidType" />
    <input type="hidden" id="hidTypeName" name="hidTypeName" />
    <input type="hidden" id="hidCiforOffice" name="hidCiforOffice" />
    <input type="hidden" id="hidCiforOfficeExc" name="hidCiforOfficeExc" />

    </form>
    <script type="text/javascript" >
        var oTable = null;
        var ListTeam = <%= _ListTeam %>;
        var listOffice = <%=listOffice%>;
      
        $(document).ready(function () {
            $("#StartDate").datepicker({
                format: "dd M yyyy"
                , autoclose: true
            }).on("changeDate", function () {
                $("#_StartDate").val($("#StartDate").data("date"));
                $("#StartDate").datepicker("hide");
            });

            $("#EndDate").datepicker({
                format: "dd M yyyy"
                , autoclose: true
            }).on("changeDate", function () {
                $("#_EndDate").val($("#EndDate").data("date"));
                $("#EndDate").datepicker("hide");
            });

            for (i = 0; i < ListTeam.length; i++) {
                addOption('SelTeam', ListTeam[i]["DIVISION_CODE"], ListTeam[i]["DIVISION_NAME"]);
            } 
            $("#SelTeam").val('All').trigger('change');
            $("#SelTeam").select2();
            $("#SelStaff").select2();
            $("#SelType").select2();

            var cboOffice = $("#cboOffice");
            generateCombo(cboOffice, listOffice, "office_id", "office_name", true);
            Select2Obj(cboOffice, "Purchase office");
        });

         function initTable(data) {
            if (oTable != null) {
                oTable.destroy();
            }

            oTable = $('#tblPRList').DataTable(
            {
                "deferRender":    true,
                //"scrollX":        true,
                //"scrollY":        400,
                //"scrollCollapse": true,
                //"scroller":       true,
                "order": [[ 3, "desc" ]],
                "bFilter": true, "bDestroy": true, "bRetrieve": true, "pagingType": 'full_numbers',
                "lengthMenu": [[25, 50, 100, -1], [25, 50, 100, "All"]],
                "fnRowCallback": function( nRow, aData, iDisplayIndex ) {  
                    $(nRow).css('background-color', aData.color_code);
                    $(nRow).css('color', aData.font_color);
                },
                "aaData": data,
                "aoColumns": [
                    { "mDataProp": "PR_No"},
                    { "mDataProp": "PR_Status" },
                    { "mDataProp": "Created_date" },
                    { "mDataProp": "PR_submission_date" },
                    { "mDataProp": "PR_submission_time" },
                    { "mDataProp": "Project_code" },
                    { "mDataProp": "Required_date" },
                    { "mDataProp": "Expected_Order_Date"},
                    { "mDataProp": "Initiator"},
                    { "mDataProp": "Requester" },
                    { "mDataProp": "Requester_team" },
                    { "mDataProp": "Item_Code" },
                    { "mDataProp": "Item_Desc" },
                    { "mDataProp": "unit_price_usd", sClass: "clsAllocation" },
                    { "mDataProp": "PR_Qty", sClass: "clsAllocation" },
                    { "mDataProp": "Currency" },
                    { "mDataProp": "Cost_estimate", sClass: "clsAllocation" },
                    { "mDataProp": "Direct_Purchase"},
                    { "mDataProp": "Status"},
                    { "mDataProp": "Vendor_S_No"},	
                    { "mDataProp": "PO_Qty", sClass: "clsAllocation"},	
                    { "mDataProp": "PO_No"},	
                    { "mDataProp": "Expected_Delivery_Date"},	
                    { "mDataProp": "remarks"},
                    { "mDataProp": "pr_type" },
                    { "mDataProp": "office_name" }
                ],
                    columnDefs: [
                {
                    render: function (data, type, full, meta) {
                        return "<div class='text-wrap width-300'>" + data + "</div>";
                    },
                    targets: 12
                }
             ]
            });
        }

        $(document).on("change", "#SelTeam", function () {
            $('#SelStaff').find('option').remove();
            var Team = $(this).val();
            var AllstaffText = "All staff";
            if (Team.toLowerCase() != "all") { AllstaffText = "All staff from " + Team; }
            var data = { searchText: Team };
            $.ajax({
                type: "POST",
                url: '<%= Page.ResolveUrl("~/" + based_url+service_url + "/GetStaffByTeam") %>',
                data: JSON.stringify(data),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (msg) {
                    var res = $.parseJSON(msg.d);
                        addOption('SelStaff', "All", AllstaffText);
                    for (i = 0; i < res.length; i++) {
                        addOption('SelStaff', res[i]["ROW_ID"], res[i]["EMP_NAME"]);
                    }
                    $('#SelStaff').val('All').trigger('change');
                }
            });
        });

        $('#btnSearch').on('click', function (e) {
            let cifor_office = "";
            if ($("#cboOffice").val() == "ALL") {
                $.each(listOffice, function (i, x) {
                    cifor_office += x.office_id + ";";
                });
            } else {
                cifor_office = $("#cboOffice").val() + ";";
            }

            $("#hidCiforOfficeExc").val(cifor_office);

            e.preventDefault();

            if (ValidSearch() == 0){
                var str,
                element = $('#SelStaff').val();
                if (element != null) {
                    str = $('#SelStaff').val().join(",");
                }
                else {
                    str = "";
                }
                var data = { startdate: $('#_StartDate').val(), enddate: $('#_EndDate').val(), prtype: $('#SelType').val(), team: $('#SelTeam').val(), staff_id: str, procurement_office: cifor_office };
                $('#hidTeam').val($('#SelTeam').val());
                $('#hidTeamName').val($('#SelTeam option:selected').text());
                $('#hidTypeName').val($('#SelType option:selected').text());
                $('#hidStartDate').val($('#_StartDate').val());
                $('#hidEndDate').val($('#_EndDate').val());
                $('#hidStaff').val(str);
                $('#hidType').val($('#SelType').val());
                $('#hidCiforOffice').val($("#cboOffice option:selected").text());

                var arrStaffName = [];
                $("#SelStaff option:selected").each(function () {
                   var $this = $(this);
                   if ($this.length) {
                       var selText = $this.text();
                       arrStaffName.push(selText);
                   }
                });
                $('#hidStaffName').val(arrStaffName.join(","));
                $.ajax({
                    type: "POST",
                    url: '<%= Page.ResolveUrl("~/" + based_url+service_url + "/LoadSummarizePRReport") %>',
                    data: JSON.stringify(data),
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (msg) {
                        var res = $.parseJSON(msg.d);
                        initTable(res);
                        $('.btnExportExcel').show();
                        $('select[name=tblPRList_length]').select2({ width: '58px',minimumResultsForSearch: -1 });
                    }
                });
            }
        });

    function addOption(combo, val, txt) {
            var option = document.createElement('option');
            option.value = val;
            option.title = txt;
            option.appendChild(document.createTextNode(txt));
            document.getElementById(combo).appendChild(option);
        }

    function ValidSearch() {
            var countError = 0;
            var errorMsg = "";

            if ($('#_StartDate').val() == "") {
                errorMsg += "<br> - Start date is required.";
                countError += 1;
            }
            if ($('#_EndDate').val() == "") {
                errorMsg += "<br> - End date is required.";
                countError += 1;
            }
//            if ($('#SelTeam').val() == "") {
//                errorMsg += "<br> - Team is required.";
//                countError += 1;
//            }
            if ($('#SelStaff').val() == null || $('#SelStaff').val() == "") {
                errorMsg += "<br> - Requester is required.";
                countError += 1;
            }

            if (errorMsg != "") {
                errorMsg = "Please correct the following error(s):" + errorMsg;
                $("#error-message").html("<b>" + errorMsg + "<b>");
                $("#error-box").show();
                errorMsg = '';
            }
            else {
                $("#error-box").hide();
            }

            if (countError > 0)
                return 1;
            else
                return 0;
        }

    </script>
</asp:Content>