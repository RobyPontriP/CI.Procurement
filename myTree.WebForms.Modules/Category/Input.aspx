<%@ Page Language="C#" MasterPageFile="~/Procurement.Master" AutoEventWireup="true" CodeBehind="Input.aspx.cs" Inherits="myTree.WebForms.Modules.Category.Input" %>

<asp:Content ID="Content1" ContentPlaceHolderID="AppHead" runat="server">
    <title>Categories and Sub Categories</title>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="AppBody" runat="server">

    <div class="floatingBox" id="error-box" style="display: none">
        <div class="alert alert-error" id="error-message">
        </div>
    </div>
    <div class="row-fluid">
        <div class="floatingBox">
            <div class="container-fluid">
                <div class="control-group required">
                    <label class="control-label">
                        Category code
                    </label>
                    <div class="controls">
                        <input type="text" name="category.initial" data-title="Category code" data-validation="required" class="span3" value="<%=dmCategory.initial %>" placeholder="Category code" maxlength="10"/>
                    </div>
                </div>
                <div class="control-group required">
                    <label class="control-label">
                        Category name
                    </label>
                    <div class="controls">
                        <input type="hidden" name="category.id" value="<%=dmCategory.id %>"/>
                        <input type="text" name="category.name" data-title="Category name" data-validation="required" class="span3" value="<%=dmCategory.name %>" placeholder="Category name" maxlength="50"/>
                    </div>
                </div>
                <div class="control-group required">
                    <label class="control-label">
                        Sub category(s)
                    </label>
                    <div class="controls">
                        <table id="tblSubcategories" class="table table-bordered table-hover required" data-title="Sub category(s)" style="border: 1px solid #ddd">
                            <thead>
                                <tr>
                                    <th class="required" style="width:30%;">Sub category code</th>
                                    <th class="required" style="width:50%;">Sub category name</th>
                                    <th style="width:20%;">&nbsp;</th>
                                </tr>
                            </thead>
                            <tbody>
                                <%  foreach(myTree.WebForms.Procurement.General.DataModel.SubCategory dsc in dmCategory.SubCategories){
                                        string disabledInput = "";
                                        if (dsc.can_edit == "false") {
                                            disabledInput = " disabled='disabled' ";
                                        }
                                        %>
                                    <tr>
                                        <td><input type="text" class="span12" name="subcategory.initial" <%=disabledInput %> data-title="Sub category code" data-validation="required"  value="<%=dsc.initial %>" maxlength="10" placeholder="Sub category code"/></td>
                                        <td><input type="text" class="span12" name="subcategory.name" <%=disabledInput %> data-title="Sub category name" data-validation="required"  value="<%=dsc.name %>" maxlength="50" placeholder="Sub category name"/></td>
                                        <td><input type="hidden" name="subcategory.id" value="<%=dsc.id %>" />
                                            <%  if (dsc.can_edit == "true")
                                                { %>
                                            <span class="label red btnDelete"><i class="icon-trash delete" style="opacity: 1;"></i></span>
                                            <%  } %>
                                        </td>
                                    </tr>
                                <%  } %>
                            </tbody>
                        </table>
                        <p><button id="btnAdd" class="btn btn-success" type="button">Add sub category</button></p>
                    </div>
                </div>
                <div class="control-group last">
                    <div class="controls">
                        <button id="btnClose" class="btn" type="button">Close page</button>&nbsp;&nbsp;&nbsp;
                        <button id="btnSave" class="btn btn-success" type="button">Save</button>                           
                    </div>
                </div>
            </div>
        </div>
    </div>
    <script>
        var deletedId = [];

        var isCanEdit = "<%=valid.isCanEdit%>";
        isCanEdit = isCanEdit.toLowerCase() === "true" ? true : false;

        $(document).ready(function () {
            if (!isCanEdit) {
                $("[name='category.initial']").prop("disabled", true);
                $("[name='category.name']").prop("disabled", true);
            }
        });

        function SubmitValidation(data) {
            var errorMsg = "";

            var valid = new Object();
            valid.id = data.id;
            valid.initial = data.initial;

            $.ajax({
                url: 'Input.aspx/isExists',
                data: JSON.stringify(valid),
                dataType: 'json',
                type: 'post',
                contentType: "application/json; charset=utf-8",
                success: function (response) {
                    var output = JSON.parse(response.d);
                    if (output.result !== "success") {
                        alert(output.message);
                    } else {
                        if (output.exists === "1") {
                            errorMsg += "<br/> - Category code already used in another category";
                        }
                        errorMsg += GeneralValidation();
                        if (errorMsg !== "") {
                            showErrorMessage(errorMsg);

                            return false;
                        }

                        var _data = {
                            "submission": JSON.stringify(data),
                            "deleted": JSON.stringify(deletedId)
                        };

                        Submit(_data);
                    }
                }
            });
        }

        $(document).on("click", ".btnDelete", function () {
            var _sid = $(this).closest("td").find("input[name='subcategory.id']").val();
            if (_sid !== "") {
                deletedId.push(_sid);
            }

            $(this).closest("tr").remove();
        });

        $(document).on("click", "#btnClose", function () {
            location.href = "List.aspx";
        });

        $(document).on("click", "#btnAdd", function () {
            var html = '<tr>';
            html += '<td><input type="text" class="span12" name="subcategory.initial" data-title="Sub category code" data-validation="required unique" maxlength="10" placeholder="Sub category code"/></td>';
            html += '<td><input type="text" class="span12" name="subcategory.name" data-title="Sub category name" data-validation="required unique" maxlength="50" placeholder="Sub category name"/></td>';
            html += '<td><input type="hidden" name="subcategory.id"/><span class="label red btnDelete"><i class="icon-trash delete" style="opacity: 1;"></i></span></td>';
            html += '</tr>';
            $("#tblSubcategories tbody").append(html);
        });

        $(document).on("click", "#btnSave", function () {
            var submission = GetSubmission();
            SubmitValidation(submission); 
        });

        function GetSubmission() {
            var data = new Object();
            data.id = $("input[name='category.id']").val();
            data.name = $("input[name='category.name']").val();
            data.initial = $("input[name='category.initial']").val();
            data.SubCategories = [];

            $("#tblSubcategories tbody tr").each(function () {
                var _sCat = new Object();
                _sCat["id"] = $(this).find("input[name='subcategory.id']").val();
                _sCat["name"] = $(this).find("input[name='subcategory.name']").val();
                _sCat["initial"] = $(this).find("input[name='subcategory.initial']").val();
                data.SubCategories.push(_sCat);
            });

            return data;
        }

        function Submit(_data) {
            $.ajax({
                url: 'Input.aspx/Save',
                data: JSON.stringify(_data),
                dataType: 'json',
                type: 'post',
                contentType: "application/json; charset=utf-8",
                success: function (response) {
                    var output = JSON.parse(response.d);
                    if (output.result != "success") {
                        alert(output.message);
                    } else {
                        alert("Data has been saved successfully");
                        blockScreen();
                        location.href = "List.aspx";
                    }
                }
            });
        }
    </script>
</asp:Content>
