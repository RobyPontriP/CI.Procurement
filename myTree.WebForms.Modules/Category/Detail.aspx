<%@ Page MasterPageFile="~/Procurement.Master" Language="C#" AutoEventWireup="true" CodeBehind="Detail.aspx.cs" Inherits="myTree.WebForms.Modules.Category.Detail" %>

<asp:Content ID="Content1" ContentPlaceHolderID="AppHead" runat="server">
    <title>Categories and Sub Categories</title>
    <style>
        .controls {
            padding-top: 5px;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="AppBody" runat="server">
    <%  if (authorized.admin || authorized.procurement_user)
        { %>
    <div class="row-fluid">
        <div class="floatingBox" style="margin-bottom:0px;">
            <div class="container-fluid">
                <div class="controls text-right">
                    <button id="btnAuditTrail" class="btn btn-success" type="button">Audit trail</button>                           
                </div> 
            </div>
        </div>
    </div>
    <%  } %>
    <div class="row-fluid">
        <div class="floatingBox">
            <div class="container-fluid">
                <div class="control-group">
                    <label class="control-label">
                        Category code
                    </label>
                    <div class="controls">
                        <%=dmCategory.initial %>
                    </div>
                </div>
                <div class="control-group">
                    <label class="control-label">
                        Category name
                    </label>
                    <div class="controls">
                        <input type="hidden" name="category.id" value="<%=dmCategory.id %>"/>
                        <%=dmCategory.name %>
                    </div>
                </div>
                <div class="control-group">
                    <label class="control-label">
                        Sub category(s)
                    </label>
                    <div class="controls">
                        <table id="tblSubcategories" class="table table-bordered table-hover required" data-title="Sub category(s)" style="border: 1px solid #ddd">
                            <thead>
                                <tr>
                                    <th style="width:40%;">Sub category code</th>
                                    <th style="width:60%;">Sub category name</th>
                                </tr>
                            </thead>
                            <tbody>
                                <%  foreach(myTree.WebForms.Procurement.General.DataModel.SubCategory dsc in dmCategory.SubCategories){  %>
                                    <tr>
                                        <td><%=dsc.initial %></td>
                                        <td><%=dsc.name %></td>
                                    </tr>
                                <%  } %>
                            </tbody>
                        </table>
                    </div>
                </div>
                <div class="control-group last">
                    <div class="controls">
                        <button id="btnClose" class="btn" type="button">Close page</button>&nbsp;&nbsp;&nbsp;
                        <%   if (authorized.admin)
                            { %>
                        <button id="btnEdit" class="btn btn-success" type="button">Edit</button>                           
                        <button id="btnDelete" class="btn btn-danger" type="button">Delete</button>
                        <%   } %>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <script>
        var _id = "<%=_id%>";
        $(document).on("click", "#btnEdit", function () {
            location.href = "Input.aspx?id=" + _id;
        });

        $(document).on("click", "#btnClose", function () {
            location.href = "List.aspx";
        });

        $(document).on("click","#btnDelete", function () {
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

        $(document).on("click", "#btnAuditTrail", function () {
            parent.ShowCustomPopUp("audittrail.aspx?blankmode=1&module=category&id=" + _id);
        });
    </script>
</asp:Content>