<%@ Page MasterPageFile="~/Procurement.Master" Language="C#" AutoEventWireup="true" CodeBehind="Detail.aspx.cs" Inherits="myTree.WebForms.Modules.Brand.Detail" %>

<asp:Content ID="Content1" ContentPlaceHolderID="AppHead" runat="server">
    <title>Brand</title>
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
                        Brand
                    </label>
                    <div class="controls">
                        <input type="hidden" name="brand.id" value="<%=brand.id %>"/>
                        <%=brand.name %>
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
            parent.ShowCustomPopUp("audittrail.aspx?blankmode=1&module=brand&id=" + _id);
        });
    </script>
</asp:Content>
