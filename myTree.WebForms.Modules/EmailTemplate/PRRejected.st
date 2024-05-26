$Style$
$if(isTest)$
$TO_CC$
$endif$
<p>Dear $requester$,</p>
<p>
  This is to inform you that purchase requisition for below item(s) has been rejected.
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
      <td class="tableheader" style="border-bottom: #ddd solid 1px">
        <p>Reason for cancellation</p>
      </td>
      <td style="border-bottom: #ddd solid 1px">
        <p>$justification$</p>
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
    <tr>
      <td class="tableheader" style="border-bottom: #ddd solid 1px">
        <p>
          Purchase type</P>
        </td>
      <td style="border-bottom: #ddd solid 1px">
        <p>$purchase_type_description$</p>
      </td>
    </tr>
    $if(purchasing_process)$
    <tr>
      <td class="tableheader" style="border-bottom: #ddd solid 1px">
        <p>Reasons for self purchasing by requester</p>
      </td>
      <td style="border-bottom: #ddd solid 1px">
        <p>$direct_to_finance_justification$</p>
      </td>
    </tr>
    $endif$
  </table>
</p>
<p>
  <table border="0" cellspacing="0" cellpadding="5" width="100%">
    <thead>
      <tr>
        <th width="10%" align="left" class="tableheader">Product code</th>
        <th width="30%" align="left" class="tableheader">Description</th>
        <th width="10%" align="right" class="tableheader">Quantity</th>
        <th width="10%" align="left" class="tableheader">UOM</th>
        <th width="10%" align="right" class="tableheader">Unit price </th>
        <th width="15%" align="right" class="tableheader">Cost estimate </th>
        <th width="15%" align="right" class="tableheader">Cost estimate (USD)</th>
        <th width="5%" align="right" class="tableheader">Exchange rate</th>
      </tr>
    </thead>
    <tbody>
      $details$
    </tbody>
    <tfoot>
      <tr>
        <th colspan="5" class="tableheader" align="right">Grand Total</th>
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
<br/>Procurement unit
</p>
<br>
$Footer$