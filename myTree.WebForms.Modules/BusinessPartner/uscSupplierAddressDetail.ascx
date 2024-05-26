<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="uscSupplierAddressDetail.ascx.cs" Inherits="myTree.WebForms.Modules.BusinessPartner.uscSupplierAddressDetail" %>
<%  if(address_type!="main"){ %>
<div class="control-group <%=eleName %>check">
    <input type="checkbox" name="<%=eleName %>.is_same" disabled="disabled"/>Address is the same with the main address.
</div>
<%  } %>
<div class="<%=eleName %>info">
    <div class="control-group">
        <label class="control-label">
            OCS <%=address_code %>address code
        </label>
        <div class="controls" id="<%=eleName %>.sun_address_code">

        </div>
    </div>
    <div class="control-group">
        <label class="control-label">
            Address
        </label>
        <div class="controls" id="<%=eleName %>.address1">
        
        </div>
    </div>
    <div class="control-group">
        <div class="controls" id="<%=eleName %>.address2">

        </div>
    </div>
    <div class="control-group">
        <div class="controls" id="<%=eleName %>.address3">
        
        </div>
    </div>
    <div class="control-group">
        <div class="controls" id="<%=eleName %>.address4">

        </div>
    </div>
    <div class="control-group">
        <div class="controls" id="<%=eleName %>.address5">

        </div>
    </div>
    <div class="control-group">
        <label class="control-label">
            Town / city
        </label>
        <div class="controls" id="<%=eleName %>.city">
        
        </div>
    </div>
    <div class="control-group">
        <label class="control-label">
            State
        </label>
        <div class="controls" id="<%=eleName %>.state">
        
        </div>
    </div>
    <div class="control-group">
        <label class="control-label">
            Postal code
        </label>
        <div class="controls" id="<%=eleName %>.postal_code">
        
        </div>
    </div>
    <div class="control-group">
        <label class="control-label">
            Country
        </label>
        <div class="controls" id="<%=eleName %>.country_name">

        </div>
    </div>
</div>