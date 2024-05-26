<%@ Page MasterPageFile="~/Procurement.Master" Language="C#" AutoEventWireup="true" CodeBehind="List.aspx.cs" Inherits="myTree.WebForms.Modules.Category.List" %>

<asp:Content ID="Content1" ContentPlaceHolderID="AppHead" runat="server">
    <title>Categories and Sub Categories</title>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="AppBody" runat="server">
    <div class="row-fluid">
        <div class="floatingBox">
            <div class="container-fluid">
                <div class="control-group last">
                    <%  if (authorized.admin)
                        { %>
                    <p><button type="button" id="btnAdd" class="btn btn-success">Add new Category</button></p>
                    <%  } %>
                    <table id="tblCategories" class="table table-bordered table-hover" style="border: 1px solid #ddd">
                        <thead>
                            <tr>
                                <th style="width:40%;">Category code</th>
                                <th style="width:50%;">Category name</th>
                                <th style="width:10%;">&nbsp;</th>
                            </tr>
                        </thead>
                        <tbody>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
    <script>
        var data = <%=listCategory%>;
        var isAdmin = "<%=authorized.admin?"true":"false"%>";
        isAdmin = (isAdmin === "true");

        $(document).ready(function(){
            oTable = $('#tblCategories').DataTable({
                "bFilter": true, "bDestroy": true, "bRetrieve": true, "pagingType": 'full_numbers',
                "aaData": data,
                "aoColumns": [
                    {
                        "mDataProp": "initial"
                        ,"mRender": function (d, type, row) {
                            var html = '<a href="detail.aspx?id=' + row.id + '" title="View detail">' + row.initial + '</a>';
                            return html;
                        }
                    },
                    { "mDataProp": "name" },
                    {
                        "mDataProp": "action"
                        , "sClass": "no-sort"
                        , "visible": isAdmin
                        ,"mRender": function (d, type, row) {
                            var html = '<input name="id" type="hidden" value="'+ row.id +'"/>';

                            html += '<span class="label green btnEdit" title="Edit category"><i class="icon-pencil edit" style="opacity: 0.7;"></i></span>';
                            html += '<span class="label red btnDelete" title="Delete category"><i class="icon-trash delete" style="opacity: 1;"></i></span>'
                            
                            return html;                            
                        }
                    }
                ],
                "columnDefs": [ {
                    "targets": [2],
                    "orderable": false,
                }]
                ,"iDisplayLength": 50
                ,"bLengthChange": false
            });

            $('#tblCategories_filter input').unbind();
            $('#tblCategories_filter input').bind('keyup', function(e) {
                if (e.keyCode == 13) {
                    oTable.search(this.value).draw();	
                }
            });	

            $("form[name='aspnetForm']").submit(function () {
                return false;
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
            })
        }

        $(document).on("click","#btnAdd", function () {
            location.href = "input.aspx";
        });
    </script>
</asp:Content>
