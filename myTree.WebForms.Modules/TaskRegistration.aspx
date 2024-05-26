<%@ Page MasterPageFile="~/Procurement.Master" Language="C#" AutoEventWireup="true" CodeBehind="TaskRegistration.aspx.cs" Inherits="myTree.WebForms.Modules.TaskRegistration" %>


<asp:Content ID="Content1" ContentPlaceHolderID="AppHead" runat="server">
    <title>Summary Task Registration</title>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="AppBody" runat="server">
    <div class="floatingBox" id="error-box" style="display: none">
        <div class="alert alert-error" id="error-message">
        </div>
    </div>
    <div class="row-fluid">
        <div class="floatingBox">
            <div class="container-fluid">
                <div class="control-group">
                    <label class="control-label">
                        Employee name
                    </label>
                    <div class="controls">
                        <select name="emp_user_id" data-title="Employee name" data-validation="required" class="span4" ></select>
                        <button type="button" id="btnRegister" class="btn btn-success">Register</button>    
                    </div>
                </div>
                <div class="control-group last">
                    <div style="width: 97%; overflow-x: auto; display: block;">
                        <table id="tblUser" class="table table-bordered" style="border: 1px solid #ddd">
                            <thead>
                                <tr>
                                    <th style="width:35%;">Employee name</th>
                                    <th style="width:35%;">Registered by</th>
                                    <th style="width:25%;">Registered date</th>
                                    <th style="width:5%;">&nbsp;</th>
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
        var UserTable;

        var listUser = <%=listUser%>
        var listEmployee = <%=listEmployee%>;

        var cboUser = $("select[name='emp_user_id']");

        $(document).ready(function () {
            generateCombo(cboUser, listEmployee, "EMP_USER_ID", "EMP_NAME", true);
            Select2Obj(cboUser, "Employee name");

            UserTable = $('#tblUser').DataTable({
                "bFilter": true, "bDestroy": true, "bRetrieve": true, "pagingType": 'full_numbers',
                "lengthMenu": [[50, 100, -1], [50, 100, "All"]],
                "aaData": listUser,
                "aoColumns": [
                    { "mDataProp": "display_name" },
                    { "mDataProp": "created_by" },
                    { "mDataProp": "created_date" },
                    {
                        "mDataProp": "url"
                        , "mRender": function (d, type, row) {
                            var html = '<input name="id" type="hidden" value="' + row.id + '"/>';
                            html += '<input name="emp_user_id" type="hidden" value="' + row.emp_user_id + '"/>';
                            html += '<span class="label red btnDelete" title="Delete user"><i class="icon-trash delete" style="opacity: 1;"></i></span>';
                            return html;
                        }
                    },
                ],
                "columnDefs": [ {
                    "targets": [3],
                    "orderable": false,
                }],
                "aaSorting": [[0, "asc"]],
                "iDisplayLength": 50
                ,"bLengthChange": false
            });

            $('#tblUser_filter input').unbind();
            $('#tblUser_filter input').bind('keyup', function (e) {
                if (e.keyCode == 13) {
                    UserTable.search(this.value).draw();	
                }
            });	

            $(window).keydown(function(event){
                if(event.keyCode == 13) {
                    event.preventDefault();
                    return false;
                }
            });
        });

        $(document).on("click", "#btnRegister", function () {
            var errorMsg = "";
            var data = {
                "id": "",
                "emp_user_id": $(cboUser).val(),
                "is_active": 1
            }

            errorMsg += GeneralValidation();

            if (errorMsg !== "") {
                showErrorMessage(errorMsg);

                return false;
            } else {
                Save(data);
            }
        });

        $(document).on("click",".btnDelete", function () {
            var _id = $(this).closest("td").find("input[name='id']").val();
            var _emp_user_id = $(this).closest("td").find("input[name='emp_user_id']").val();
            if (confirm("Are you sure?")) {
                Save(_id);
            }

            var data = {
                "id": _id,
                "emp_user_id": _emp_user_id,
                "is_active": 0
            };
            Save(data);
        });

        function Save(data) {
            $.ajax({
                url: 'TaskRegistration.aspx/SaveTaskUser',
                data: JSON.stringify(data),
                dataType: 'json',
                type: 'post',
                contentType: "application/json; charset=utf-8",
                success: function (response) {
                    var output = JSON.parse(response.d);
                    if (output.result != "success") {
                        alert(output.message);
                    } else {
                        if (data.is_active == 0) {
                            alert("User has been unregistered successfully");
                        } else {
                            alert("User has been registered successfully");
                        }
                        blockScreen();
                        location.reload();
                    }
                }
            })
        }
    </script>
</asp:Content>
