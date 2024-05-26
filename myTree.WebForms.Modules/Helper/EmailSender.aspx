<%@ Page MasterPageFile="~/Procurement.Master" Language="C#" AutoEventWireup="true" CodeBehind="EmailSender.aspx.cs" Inherits="myTree.WebForms.Modules.Helper.EmailSender" %>

<asp:Content ID="Content1" ContentPlaceHolderID="AppHead" runat="server">
    <title>Email sender</title>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="AppBody" runat="server">
<div class="row-fluid">
    <div class="floatingBox">
        <div class="container-fluid">
            <div class="control-group">
                <label class="control-label">
                    Email type
                </label>
                <div class="controls">
                    <select name="email_type">
                        <option></option>
                        <option value="prclearance" data-type="notification">PR wait for verification</option>
                        <option value="prclearanceuser" data-type="notification">PR wait for verification user</option>
                        <option value="prclearancefinance" data-type="notification">PR wait for verification finance</option>
                        <option value="prwaitforpayment" data-type="notification">PR wait for payment</option>
                        <option value="prverified" data-type="notification">PR verified</option>
                        <option value="prverifiedfinance" data-type="notification">PR verified by Finance</option>
                        <option value="prclosed" data-type="notification">PR closed</option>
                        <option value="prcancelled" data-type="notification">PR cancelled</option>
                        <option value="prrejected" data-type="notification">PR rejected</option>
                        <option value="prchangechargecode" data-type="notification">PR change charge code</option>
                        <option value="rfqsendtovendor" data-type="notification">RFQ send to vendor</option>
                        <option value="rfqdue" data-type="reminder">RFQ due</option>
                      <%--  <option value="itemconfirmation" data-type="notification">Request for user confirmation</option>
                        <option value="autoconfirmation" data-type="notification">Auto confirmation</option>--%>
                        <option value="poapproved" data-type="notification">PO approved</option>
                        <option value="potovendor" data-type="notification">PO approved to Vendor</option>
                        <option value="poapproveduser" data-type="notification">PO approved to User</option>
                        <option value="podelivery" data-type="notification">PO delivery</option>
                        <option value="poundelivered" data-type="notification">PO undelivered</option>
                    </select>              
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">
                    Module id
                </label>
                <div class="controls">
                    <input type="text" name="module_id" class="span2" maxlength="10"/>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">
                    Template no (only applicable for RFQ)
                </label>
                <div class="controls">
                    <select name="template_no">
                        <option></option>
                        <option value="1">Template #1 Template without procurement team name</option>
                        <option value="2">Template #2 Template with procurement team name</option>
                        <option value="5">Template #3 New template</option>
                    </select>              
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">
                    Date
                </label>
                <div class="controls">
                    <input type="text" name="param_date" class="span2" maxlength="10"/>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">
                    In days
                </label>
                <div class="controls">
                    <input type="text" name="indays" class="span2" maxlength="1"/>
                </div>
            </div>
            <div class="control-group last">
                <div class="controls">
                    <button type="submit">Send</button>
                </div>
            </div>
            <div class="control-group last">
                <%=result %>
            </div>
        </div>
    </div>
</div>
</asp:Content>
