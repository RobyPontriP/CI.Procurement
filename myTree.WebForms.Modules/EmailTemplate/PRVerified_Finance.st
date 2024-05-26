$Style$
$if(isTest)$
$TO_CC$
$endif$
<p>Dear $requester$,</p>
<p>
  This is to inform you that purchase requisition for below item(s) has been approved. 
  Please submit the original invoice and the copy of this purchase requisition to Finance for payment.
</p>
<p>
  <table border="0" cellspacing="0" cellpadding="5" width="100%">
    <tr>
      <td width="20%" class="tableheader" style="border-bottom: #ddd solid 1px">
        <p>PR code</p>
      </td>
      <td width="80%" style="border-bottom: #ddd solid 1px">
        <p>$pr_no$</p>
      </td>
    </tr>
    <tr>
      <td width="20%" class="tableheader" style="border-bottom: #ddd solid 1px">
        <p>Requester</p>
      </td>
      <td width="80%" style="border-bottom: #ddd solid 1px">
        <p>$requester$</p>
      </td>
    </tr>
    <tr>
      <td class="tableheader" style="border-bottom: #ddd solid 1px">
        <p>Required date</p>
      </td>
      <td style="border-bottom: #ddd solid 1px">
        <p>$required_date$</p>
      </td>
    </tr>
    <tr>
      <td class="tableheader" style="border-bottom: #ddd solid 1px">
        <p>Purchase office</p>
      </td>
      <td style="border-bottom: #ddd solid 1px">
        <p>$office$</p>
      </td>
    </tr>
    <tr>
      <td class="tableheader" style="border-bottom: #ddd solid 1px">
        <p>Remarks</p>
      </td>
      <td style="border-bottom: #ddd solid 1px">
        <p>$remarks$</p>
      </td>
    </tr>
  </table>
</p>
<p>
  <table border="0" cellspacing="0" cellpadding="5" width="100%">
    <thead>
      <tr>
        <th width="10%" align="left" class="tableheader">Product code</th>
        <th width="20%" align="left" class="tableheader">Description</th>
        <th width="8%" align="right" class="tableheader">Quantity</th>
        <th width="7%" align="left" class="tableheader">UOM</th>
        <th width="10%" align="right" class="tableheader">Unit price</th>
        <th width="15%" align="right" class="tableheader">Cost estimate</th>
        <th width="15%" align="right" class="tableheader">Cost estimate (USD)</th>
        <th width="5%" align="right" class="tableheader">Exchange rate</th>
        <th width="15%" align="left" class="tableheader">Supporting document(s)</th>
      </tr>
    </thead>
    <tbody>
      $details$
    </tbody>
    <tfoot>
      <tr>
        <th colspan="6" class="tableheader" align="right">Grand Total</th>
        <th class="tableheader" align="right">$total$</th>
        <th class="tableheader" align="right">$total_usd$</th>
        <th  colspan="2" class="tableheader" align="right">&nbsp;</th>
      </tr>
    </tfoot>
  </table>
</p>
<br>
<p>
  Should you have any questions kindly contact $footer$
</p>
<br>
<p>Thank you,
  <br/>
  $footer_name$
</p>
<br>
$Footer$