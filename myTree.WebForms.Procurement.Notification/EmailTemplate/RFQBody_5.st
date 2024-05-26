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

       <!-- detail supplier -->
      <table>
        <tr>
          <td>
            <table border="0" cellspacing="0" cellpadding="5" width="100%">
              <tr>
                <td width="40%" class="tableheader" style="border-bottom: #ddd solid 1px;">
                  Supplier
                </td>
                <td width="60%" style="border-bottom: #ddd solid 1px; padding:5px;">
                 $vendor_name$
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
                    Supplier location
                  </td>
                  <td width="60%" style="border-bottom: #ddd solid 1px; padding:5px;">
                     $vendor_location$
                  </td>
                </tr>
            </table>
          </td>
          <td >
            <p style="margin-left: 30%;">
                $pro_name$<br>
                $pro_position$
                <br>$legal_entity$
                <br>Procurement office $procurement_office$
                <br>$procurement_office_address$
            </p>
          </td>
        </tr>
      </table>
  <!-- end detail supplier -->
  
      <p style="padding-top:20px;padding-bottom:20px;">You are invited to submit quotation on product(s) listed below: <br> Notes:</p>
     <table>
        <tr>
          <td width="50%">
            <ol type="a" style="padding-left:15px!important">
              <li>THIS IS NOT AN ORDER.  Read the conditions and instructions on reverse before quoting.</li>
              <li>This quotation should be submitted electronically with email subject line marked.</li>
            </ol>
          </td>
          <td>
            <ol type="a" start="3" style="margin-left: 10%;">
              <li>Your quotation should indicate final unit price including All costs for delivery, discount, duty and EXCLUSIVE of tax.</li>
              <li>Provide all applicable product technical data sheets/brochures.</li>
            </ol>
          </td>
        </tr>
      </table>

       <div class="grid-container">
      <div class="grid-item" style="">
        <p>Request for quotation No. $rfq_no$</p>
        <p> And be addressed to reach the buyer not later than;  $due_date$</p>
      </div>
    </div>

      <table border="0" cellspacing="0" cellpadding="5" width="100%">
        <thead>
          <tr>
            <th width="5%" align="left" class="tableheader">Code no.</th>
            <th width="20%" align="left" class="tableheader">Product description</th>
            <th width="10%" align="left" class="tableheader">Quantity</th>
            <th width="10%" align="left" class="tableheader">Unit price</th>
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
        <br>  
        <p>Pre-requisites for award: </p>
        <div class="grid-container">
          <div class="grid-item" style="">
            <ol style="padding-left:15px!important">
              <li> Attach duly filled and signed $legal_entity$ of Conduct provided in this link - <a href="https://www.worldagroforestry.org/sites/default/files/users/admin/ICRAF%20Supplier%20Code%20of%20Conduct%20-%20V1%202017_0.pdf">Supplier Code of Conduct (Sign off) </a></li>
              <li> Provide a current and Valid Tax Compliance Certificate (for all Kenyan-Based Companies) </li>
            </ol>
          </div>
        </div>
       <div class="content" style="padding-bottom:100px">
            <div class="content-left">
                <p>Seller’s Signature and Stamp </p>
                ............................................................................
                <br><br>Date : ..................................................................
          </div>
        </div>

        <div class="pagebreak"></div>
        $TOC$
</body>
