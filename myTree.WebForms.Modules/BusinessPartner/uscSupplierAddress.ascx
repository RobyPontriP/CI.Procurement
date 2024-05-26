<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="uscSupplierAddress.ascx.cs" Inherits="myTree.WebForms.Modules.BusinessPartner.uscSupplierAddress" %>
<%  if(address_type!="main"){ %>
<div class="control-group <%=eleName %>check">
    <label class="controls">
        <input type="checkbox" name="<%=eleName %>.is_same" />Address is the same with the main address.
    </label>
</div>
<%  } %>
<div class="<%=eleName %>info">
    <div class="control-group">
        <label class="control-label">
            OCS <%=address_code %>address code
        </label>
        <div class="controls">
            <%--<select name="<%=eleName %>.sun_address_code" class="span3" data-id="<%=eleName %>">--%>
            <select name="<%=eleName %>.sun_address_code" class="span3" data-id="<%=eleName %>">
            </select>
            <input type="hidden" name="<%=eleName %>.id"/>
        </div>
    </div>
    <div class="control-group">
        <label class="control-label">
            Address
        </label>
        <div class="controls">
            <input type="text" maxlength="50" name="<%=eleName %>.address1" class="span8 <%=eleName %>" placeholder="Address 1"/>
        </div>
    </div>
    <div class="control-group">
        <div class="controls">
            <input type="text" maxlength="50" name="<%=eleName %>.address2" class="span8 <%=eleName %>" placeholder="Address 2"/>
        </div>
    </div>
    <div class="control-group">
        <div class="controls">
            <input type="text" maxlength="50" name="<%=eleName %>.address3" class="span8 <%=eleName %>" placeholder="Address 3"/>
        </div>
    </div>
    <div class="control-group">
        <div class="controls">
            <input type="text" maxlength="50" name="<%=eleName %>.address4" class="span8 <%=eleName %>" placeholder="Address 4"/>
        </div>
    </div>
    <div class="control-group">
        <div class="controls">
            <input type="text" maxlength="50" name="<%=eleName %>.address5" class="span8 <%=eleName %>" placeholder="Address 5"/>
        </div>
    </div>
    <div class="control-group">
        <label class="control-label">
            Town / city
        </label>
        <div class="controls">
            <input type="text" maxlength="50" name="<%=eleName %>.city" class="span8 <%=eleName %>" placeholder="Town / city"/>
        </div>
    </div>
    <div class="control-group">
        <label class="control-label">
            State
        </label>
        <div class="controls">
            <input type="text" maxlength="50" name="<%=eleName %>.state" class="span8 <%=eleName %>" placeholder="State"/>
        </div>
    </div>
    <div class="control-group">
        <label class="control-label">
            Postal code
        </label>
        <div class="controls">
            <input type="text" maxlength="20" name="<%=eleName %>.postal_code" class="span3 <%=eleName %>" placeholder="Postal code"/>
        </div>
    </div>
   <%-- <div class="control-group">
        <label class="control-label">
            Country
        </label>
        <div class="controls">
            <select name="<%=eleName %>.country_id" class="span4 <%=eleName %> country">

            </select>
        </div>
    </div>--%>
    <div class="control-group">
        <label class="control-label">
            Country
        </label>
        <div class="controls">
            <input type="text" maxlength="20" name="<%=eleName %>.country_id" class="span3 <%=eleName %>" placeholder="Country"/>
        </div>
    </div>
</div>