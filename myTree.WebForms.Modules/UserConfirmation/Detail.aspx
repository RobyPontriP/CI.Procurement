<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Detail.aspx.cs" Inherits="myTree.WebForms.Modules.UserConfirmation.Detail" %>
<%@ Register Src="~/UserConfirmation/uscSendConfirmation.ascx" TagName="confirmationform" TagPrefix="uscConfirmation" %>
<asp:Content ID="Content1" ContentPlaceHolderID="AppHead" runat="server">
    <title>User Confirmations</title>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="AppBody" runat="server">
    <input type="hidden" id="confirmationId" name="id" value="<%=id %>" />
    <%--<%  if (authorized.admin || authorized.procurement_user)--%>
    <%  if (userRoleAccess.RoleNameInSystem == "procurement_admin" ||userRoleAccess.RoleNameInSystem == "procurement_user")
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
                        Confirmation code
                    </label>
                    <div class="controls labelDetail confirmationCode">
                        <b><%=du.confirmation_code %></b>
                    </div>
                </div>
                <div class="control-group">
                    <label class="control-label">
                        Send date
                    </label>
                    <div class="controls labelDetail">
                        <%=du.send_date %>
                    </div>
                </div>
                <div class="control-group">
                    <label class="control-label">
                        Status
                    </label>
                    <div class="controls labelDetail">
                        <%=du.status_id %>
                    </div>
                </div>
                <div class="control-group">
                    <label class="control-label">
                        Confirm date
                    </label>
                    <div class="controls labelDetail confirmDate">
                        <%=du.confirm_date %>
                    </div>
                </div>
                <uscConfirmation:confirmationform ID="confirmationForm" runat="server" />
                <div class="control-group last">
                    <label class="control-label">
                    </label>
                    <div class="controls">
                        <button id="btnClose" class="btn" type="button">Close page</button>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <script>
        var source = "<%=source%>";
        var source_id = "<%=source_id%>";

        var blank_mode = "<%=blank_mode%>";

        var listMain = <%=listMain%>;
        var listGroupHeader = <%=listGroupHeader%>;
        var listGroupDetail = <%=listGroupDetail%>;
        var listDocs = <%=listDocs%>;

        var workflow = new Object();
        var btnAction = "";

        $(document).ready(function () {
            ConfirmDetail = listGroupDetail;
            ConfirmMain = listGroupHeader;

            tblConfirm.clear().draw();
            tblConfirm.rows.add(ConfirmMain).draw();

            PopulateDocs();
        });

        function PopulateDocs() {
            $(listDocs).each(function (i, x) {
                var html = '<tr>';
                html += (x.file_description !="") ? '<td>' + x.file_description + '</td>' : '<td> - </td>';
                html += (x.filename !="") ? '<td><a href="Files/' + x.document_id + '/' + x.filename + '" target="_blank">' + x.filename + '</a></td>' : '<td> - </td>';
                html += '</tr>';
                $("#tblSupportingDocuments tbody").append(html);
            });
        }

        $(document).on("click", "#btnClose", function () {
            if (blank_mode == "1") {
                parent.$.colorbox.close();  
            } else {
                blockScreen();
                switch (source.toLowerCase()) {
                    case "polist":
                        parent.location.href = "purchaseorder/List.aspx";
                        break;
                    case "podetail":
                        parent.location.href = "purchaseorder/detail.aspx?id=" + source_id;
                        break;
                    case "prlist":
                        parent.location.href = "purchaserequisition/list.aspx";
                        break;
                    case "prdetail":
                        parent.location.href = "purchaserequisition/detail.aspx?id=" + source_id;
                        break;
                    default:
                        parent.location.href = "/workspace/my-submissions.aspx";
                        break;
                }
            }
        });

        $(document).on("click", "#btnAuditTrail", function () {
            parent.ShowCustomPopUp("audittrail.aspx?blankmode=1&module=userconfirmation&id=" + $("#confirmationId").val());
        });
    </script>
</asp:Content>
