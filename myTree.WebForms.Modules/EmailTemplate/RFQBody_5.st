$Style$
$if(isTest)$
$TO_CC$
$endif$
<body>
    <div class="header">

        <p>Request for quotation. $rfq_no$
            <br>Date : $document_date$</p>

        <div class="version">
            RFQ FORM (version 1-2021)
          </div>
      </div>

      <div class="content" style="padding-bottom: 100px;">
        <div class="content-left" style="width:50%">
            <table border="0" cellspacing="0" cellpadding="5" width="100%">
                <tr>
                  <td width="40%" class="tableheader" style="border-bottom: #ddd solid 1px;">
                    Supplier
                  </td>
                  <td width="60%" style="border-bottom: #ddd solid 1px; padding:5px;">
                    $cp_name$
                  </td>
                </tr>
                <tr>
                    <td width="40%" class="tableheader" style="border-bottom: #ddd solid 1px">
                      Address
                    </td>
                    <td width="60%" style="border-bottom: #ddd solid 1px; padding:5px;">
                      $vendor_address$
                    </td>
                  </tr>
                  <tr>
                    <td width="40%" class="tableheader" style="border-bottom: #ddd solid 1px">
                      Supplier Location
                    </td>
                    <td width="60%" style="border-bottom: #ddd solid 1px; padding:5px;">
                      $vendor_location$
                    </td>
                  </tr>
              </table>
        </div>
        <div class="content-right" style="width:30%">
            $pro_name$<br>
            $pro_position$
            <br>$legal_entity$
            <br>Procurement office $procurement_office$
            <br>$procurement_office_address$
        </div>
      </div>
      <br>
      <p>You are invited to submit quotation on product(s) listed below: <br> Notes:</p>
     <div class="content" style="padding-bottom: 50px;padding-top:20px;">
        <div class="content-left" style="width:45%">
            (a)  THIS IS NOT AN ORDER.  Read the conditions and<br> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;instructions on reverse before quoting<br> 
            (b)  This quotation should be submitted electronically with<br> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;email subject line marked.<br>
        </div>
        <div class="content-right" style="width:45%">
            (c)  Your quotation should indicate final unit price
            <br> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;including All costs for delivery, discount, duty and <br> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;EXCLUSIVE of tax. <br>
            (d)  Provide all applicable product technical data<br> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;sheets/brochures. <br>
        </div>
      </div>
      <div class="content" style="padding-bottom: 70px;padding-top:50px">
        <div class="content-left" style="width:100%">
            <p style="margin-left:30px">Request for quotation No. $rfq_no$</p>
            <p style="margin-left:20px"> And be addressed to reach the buyer not later than;  $due_date$</p>
        </div>
      </div>

      <table border="0" cellspacing="0" cellpadding="5" width="100%">
        <thead>
          <tr>
            <th width="5%" align="left" class="tableheader">Code no.</th>
            <th width="20%" align="left" class="tableheader">Product Description</th>
            <th width="10%" align="left" class="tableheader">Quantity</th>
            <th width="5%" align="left" class="tableheader">Unit cost</th>
            <th width="10%" align="left" class="tableheader">Total cost</th>
            <th width="10%" align="left" class="tableheader">Other charges</th>
            <th width="10%" align="left" class="tableheader">Lead time</th>
            <th width="10%" align="left" class="tableheader">Warranty</th>
            <th width="10%" align="left" class="tableheader">Remarks</th>
          </tr>
        </thead>
        <tbody>
        $details$
        </tbody>
        </table>

        <p style="padding-top:20px;padding-bottom: 20px;">Pre-requisites for award: </p>
        <p style="margin-left: 20px;">
            1. Attach duly filled and signed $legal_entity$ of Conduct provided in this link - 
            <a href="https://www.worldagroforestry.org/sites/default/files/users/admin/ICRAF%20Supplier%20Code%20of%20Conduct%20-%20V1%202017_0.pdf">Supplier Code of Conduct (Sign off) </a><br><br>

            2. Provide a current and Valid Tax Compliance Certificate (for all Kenyan-Based Companies) <br>
        </p>

       <div class="content" style="padding-top:20px;padding-bottom:100px">
            <div class="content-left">
                <p>Seller’s Signature and Stamp </p>
                ............................................................................
                <br><br>Date : ..................................................................
          </div>
        </div>

        <div class="pagebreak"></div>
        $TOC$
</body>
