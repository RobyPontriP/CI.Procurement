<%@ Page MasterPageFile="~/Procurement.Master" Language="C#" AutoEventWireup="true" CodeBehind="Input.aspx.cs" Inherits="myTree.WebForms.Modules.Brand.Input" %>

<asp:Content ID="Content1" ContentPlaceHolderID="AppHead" runat="server">
    <title>Brand</title>
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
                        Brand
                    </label>
                    <div class="controls">
                        <input type="hidden" name="brand.id" value="<%=brand.id %>"/>
                        <input type="text" name="brand.name" data-title="Brand" data-validation="required" class="span3" value="<%=brand.name %>" placeholder="Brand name" maxlength="50"/>
                    </div>
                </div>
                <div class="control-group required" style="display:none;">
                    <div class="controls">
                        <table id="tblCategories" class="table table-bordered table-hover required" data-title="Categories" style="border: 1px solid #ddd">
                            <thead>
                                <tr>
                                    <th style="width:40%;">Category</th>
                                    <th style="width:40%;">Subcategory</th>
                                    <th style="width:20%;">&nbsp;</th>
                                </tr>
                            </thead>
                            <tbody>
                            </tbody>
                        </table>
                        <button id="btnAdd" class="btn btn-success" type="button">Add row</button>
                        <br />
                        <br />
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
        var dataCategory = <%=listCategory%>;
        var BrandCategory = <%=listBrandCategory%>;


        $(document).ready(function () {
            //ShowBrandCategory();
        });

        function ShowBrandCategory() {
            $.each(BrandCategory, function (i, x) {
                AddBrandCategory(x.id,x.category, x.subcategory);
            })
        }

        function AddBrandCategory(id, category, subcategory) {
            var _uid = guid();
            var html = "<tr id='" + _uid + "'>";
            html += '<td><select class="span12" name="brandcategory.category" data-title="Category" data-validation="required"></select></td>';
            html += '<td><select class="span12" name="brandcategory.subcategory" data-title="Subcategory" data-validation="required"></select></td>';
            html += '<td><input type="hidden" name="brandcategory.id" value="' + id + '"/><span class="label red btnDelete"><i class="icon-trash delete" style="opacity: 1;"></i></span></td > ';
            html += "</tr>";

            $("#tblCategories tbody").append(html);

            var obj = $("#" + _uid + " select[name='brandcategory.category']");
            generateCombo(obj, dataCategory, "id", "text", true);
            $(obj).val(category);
            Select2Category(obj);

            var objSub = $("#" + _uid + " select[name='brandcategory.subcategory']");
            CreateSubCategory(objSub, category, subcategory)
        }

        function Select2Category(obj) {
            $(obj).select2({
                placeholder: "Category",
            }).on('select2:select', function (e) {
                var cboSub = $(this).closest("tr").find("select[name='brandcategory.subcategory']");
                CreateSubCategory(cboSub, $(this).val(), "");
            });
        }

        
        $(document).on("click", "#btnAdd", function () {
            AddBrandCategory("", "", "");            
        });

        $(document).on("click", "#btnClose", function () {
            location.href = "List.aspx";
        })

        $(document).on("click", "#btnSave", function () {
            SubmitValidation();
        });

        function SubmitValidation() {
            var errorMsg = "";
            var data = new Object();
            data.id = $("input[name='brand.id']").val();
            data.name = $("input[name='brand.name']").val();

            var param = new Object();
            param.id = data.id;
            param.name = data.name;

            $.ajax({
                url: 'Input.aspx/isExists',
                data: JSON.stringify(param),
                dataType: 'json',
                type: 'post',
                contentType: "application/json; charset=utf-8",
                success: function (response) {
                    var output = JSON.parse(response.d);
                    if (output.result != "success") {
                        alert(output.message);
                    } else {
                        if (output.exists == "1") {
                            errorMsg += "<br/> - Brand already used ";
                        }
                        errorMsg += GeneralValidation();

                        if (errorMsg != "") {
                            showErrorMessage(errorMsg);

                            return false;
                        } else {
                            var _data = {
                                "submission": JSON.stringify(data),
                            }
                
                            Submit(_data);
                        }
                    }
                }
            });
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
            })
        }
    </script>
</asp:Content>
