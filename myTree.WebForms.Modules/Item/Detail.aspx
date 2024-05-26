<%@ Page MasterPageFile="~/Procurement.Master" Language="C#" AutoEventWireup="true" CodeBehind="Detail.aspx.cs" Inherits="myTree.WebForms.Modules.Item.Detail" %>

<asp:Content ID="Content1" ContentPlaceHolderID="AppHead" runat="server">
    <title>Item</title>
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
                        OCS item code
                    </label>
                    <div class="controls">
                        <input type="hidden" name="item.id" value="<%=item.id %>"/>
                        <%=item.sun_code %>
                    </div>
                </div>
                <div class="control-group">
                    <label class="control-label">
                        OCS lookup code
                    </label>
                    <div class="controls">
                        <%=item.sun_lookup_code%>
                    </div>
                </div>
                <div class="control-group">
                    <label class="control-label">
                        OCS item description
                    </label>
                    <div class="controls">
                        <%=item.sun_long_desc%>
                    </div>
                </div>
                <div class="control-group">
                    <label class="control-label">
                        OCS item short heading
                    </label>
                    <div class="controls">
                        <%=item.sun_short_desc%>
                    </div>
                </div>
                <div class="control-group">
                    <label class="control-label">
                        OCS item status
                    </label>
                    <div class="controls">
                        <%=item.sun_status%>
                    </div>
                </div>
                <div class="control-group">
                    <label class="control-label">
                        OCS item grouping
                    </label>
                    <div class="controls">
                        <%=item.sun_item_group%>
                    </div>
                </div>
                <div class="control-group">
                    <label class="control-label">
                        OCS item account code
                    </label>
                    <div class="controls">
                        <%=item.sun_account_code%>
                    </div>
                </div>
                <div class="control-group">
                    <label class="control-label">
                        Procurement item code
                    </label>
                    <div class="controls">
                        <b><%=item.item_code%></b>
                    </div>
                </div>
                <div class="control-group">
                    <label class="control-label">
                        Description
                    </label>
                    <div class="controls multilines"><%=item.description%></div>
                </div>
                <div class="control-group">
                    <label class="control-label">
                        Unit of measurement
                    </label>
                    <div class="controls">
                        <%=item.uom_name %>
                    </div>
                </div>
                <div class="control-group">
                    <label class="control-label">
                        Category
                    </label>
                    <div class="controls">
                        <%=item.category_name %>
                    </div>
                </div>
                <div class="control-group">
                    <label class="control-label">
                        Sub category
                    </label>
                    <div class="controls">
                        <%=item.subcategory_name %>
                    </div>
                </div>
                <div class="control-group">
                    <label class="control-label">
                        Brand
                    </label>
                    <div class="controls">
                        <%=item.brand_name %>
                    </div>
                </div>
                <div class="control-group">
                    <label class="control-label">
                        Attachment(s)
                    </label>
                    <div class="controls">
                        <table id="tblAttachment" class="table table-bordered table-hover" data-title="Attachment(s)" style="border: 1px solid #ddd">
                            <thead>
                                <tr>
                                    <th style="width:60%;">Description</th>
                                    <th style="width:40%;">File</th>
                                </tr>
                            </thead>
                            <tbody>
                                <%  foreach (myTree.WebForms.Procurement.General.DataModel.Attachment att in item.attachments)
                                    { %>
                                <tr>
                                    <td><%=att.file_description %></td>
                                    <td><span class="linkDocument"><a href="<%=myTree.WebForms.Procurement.General.statics.GetFileUrl("ITEM",item.id,att.filename) %>" target='_blank'><%=att.filename%></a></span></td>                                        
                                </tr>
                                <%  } %>
                            </tbody>
                        </table>
                    </div>
                </div>
                <div class="control-group">
                    <label class="control-label">
                        Procurement item status
                    </label>
                    <div class="controls">
                        <%=item.item_active_label%>
                    </div>
                </div>
                <div class="control-group">
                    <label class="control-label">
                        Remarks
                    </label>
                    <div class="controls multilines"><%=item.remarks%></div>
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
            parent.ShowCustomPopUp("audittrail.aspx?blankmode=1&module=item&id=" + _id);
        });

        $(document).ready(function () {
            normalizeMultilines();
        });
    </script>
</asp:Content>
