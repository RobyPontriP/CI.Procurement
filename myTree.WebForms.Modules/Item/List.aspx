<%@ Page MasterPageFile="~/Procurement.Master" Language="C#" AutoEventWireup="true" CodeBehind="List.aspx.cs" Inherits="myTree.WebForms.Modules.Item.List" %>

<asp:Content ID="Content1" ContentPlaceHolderID="AppHead" runat="server">
    <title>Items</title>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="AppBody" runat="server">
    <div class="row-fluid">
        <div class="floatingBox">
            <div class="container-fluid">
                <div class="control-group">
                    <label class="control-label">
                        Show items by status
                    </label>
                    <div class="controls">
                        <select id="itemStatus">
                            <option value="">All</option>
                            <option value="1">Active</option>
                            <option value="0">In-active</option>
                        </select>
                    </div>
                </div>
                <div class="control-group last">
                    <%  if (authorized.admin)
                        { %>
                    <p><button type="button" id="btnAdd" class="btn btn-success">Add new Item</button></p>
                    <%  } %>
                    <div style="width: 97%; overflow-x: auto; display: block;">
                        <table id="tblItems" class="table table-bordered table-hover" style="border: 1px solid #ddd">
                            <thead>
                                <tr>
                                    <th style="width:13%">Procurement item code</th>
                                    <th style="width:7%">OCS Item code</th>
                                    <th style="width:7%">OCS description</th>
                                    <th style="width:20%">Additional description</th>
                                    <th style="width:10%">Category</th>
                                    <th style="width:10%">Sub category</th>
                                    <th style="width:8%">Brand</th>
                                    <th style="width:8%">UoM</th>
                                    <th style="width:7%">Status</th>
                                    <th style="width:10%">&nbsp;</th>
                                </tr>
                            </thead>
                            <tbody>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <script>
        var isAdmin = "<%=authorized.admin?"true":"false"%>";
        isAdmin = (isAdmin === "true");

        $(document).ready(function () {
            oTable = $('#tblItems').DataTable({
                "processing": true,
                "serverSide": true,
                "searchDelay": 5000,
                "info": true,
                //"bFilter": true,
                //"bDestroy": true,
                //"bRetrieve": true,
                "pagingType": 'full_numbers',
                //"lengthMenu": [[100, 200, -1], [100, 200, "All"]],
                "ajax": {
                    "url": "Render.aspx",
                    "type": "POST",
                    "data": function (d) {
                        d.item_status = $("#itemStatus").val();
                    }
                },
                //"aaData": data,
                "aoColumns": [
                    {
                        "mDataProp": "item_code"
                        ,"mRender": function (d, type, row) {
                            var html = '<a href="detail.aspx?id=' + row.id + '" title="View detail">' + row.item_code + '</a>';
                            return html;
                        }
                    },
                    { "mDataProp": "sun_code" },
                    { "mDataProp": "sun_long_desc" },
                    { "mDataProp": "description" },
                    { "mDataProp": "category_name" },
                    { "mDataProp": "subcategory_name" },
                    { "mDataProp": "brand_name" },
                    { "mDataProp": "uom_name" },
                    { "mDataProp": "item_active_label" },
                    {
                        "mDataProp": "action"
                        , "sClass": "no-sort"
                        ,"orderable":false
                        ,"visible": isAdmin
                        ,"mRender": function (d, type, row) {
                            var html = '<input name="id" type="hidden" value="'+ row.id +'"/>';

                            html += '<span class="label green btnEdit" title="Edit item"><i class="icon-pencil edit" style="opacity: 0.7;"></i></span>';
                            html += '<span class="label red btnDelete" title="Delete item"><i class="icon-trash delete" style="opacity: 1;"></i></span>';
                            return html;
                        }
                    }
                ],
                "order": [[0, "asc"]]
                //,"sDom": '<l<t>ip>'
                ,"bLengthChange": false,
                "iDisplayLength": 50
                /*"columnDefs": [ {
                    "targets": [2],
                    "orderable": false,
                }]*/
            });

            $('#tblItems_filter input').unbind();
            $('#tblItems_filter input').bind('keyup', function(e) {
                if (e.keyCode == 13) {
                    oTable.search(this.value).draw();	
                }
            });	

            $("form[name='aspnetForm']").submit(function () {
                return false;
            });

            $("#itemStatus")
                .select2()
                .on("change", function () {
                    var searchVal = $("[type='search']").val();
                    oTable.search(searchVal).draw();
                });
        });

        $(document).on("click",".btnEdit", function () {
            var _id = $(this).closest("td").find("input[name='id']").val();
            location.href = "input.aspx?id=" + _id;
        });

        $(document).on("click",".btnDelete", function () {
            var _id = $(this).closest("td").find("input[name='id']").val();
            if (confirm("Are you sure?")) {
                Delete(_id);
            }
        });

        function Delete(id) {
            $.ajax({
                url: 'List.aspx/Delete',
                data: '{"id":"' + id + '"}',
                dataType: 'json',
                type: 'post',
                contentType: "application/json; charset=utf-8",
                success: function (response) {
                    var output = JSON.parse(response.d);
                    if (output.result != "success") {
                        alert(output.message);
                    } else {
                        alert("Data has been deleted successfully");
                        blockScreen();
                        location.href = "List.aspx";
                    }
                }
            });
        }

        $(document).on("click","#btnAdd", function () {
            location.href = "input.aspx";
        });
    </script>
</asp:Content>
