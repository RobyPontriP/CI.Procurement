$Style$
$if(isTest)$
$TO_CC$
$endif$
<p>Dear all,</p>
<p>
  This is to inform you that your purchase requisition is in verification process by $team$ unit.
</p>
<p>
  <table border="0" cellspacing="0" cellpadding="5" width="100%">
    <tr>
      <td width="20%" class="tableheader" style="border-bottom: #ddd solid 1px">
        <p>Requester</p>
      </td>
      <td width="80%" style="border-bottom: #ddd solid 1px">
        <p>$requester$ &nbsp&nbsp$profile_page$</p>
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
        <p>Purchase/finance office</p>
      </td>
      <td style="border-bottom: #ddd solid 1px">
        <p>$office$</p>
      </td>
    </tr>
    <!--<tr>
      <td class="tableheader" style="border-bottom: #ddd solid 1px">
        <p>Charge code</p>
      </td>
      <td style="border-bottom: #ddd solid 1px">
        <p>$cost_center$</p>
      </td>
    </tr>
    <tr>
      <td class="tableheader" style="border-bottom: #ddd solid 1px">
        <p>Currency</p>
      </td>
      <td style="border-bottom: #ddd solid 1px">
        <p>$currency$</p>
      </td>
    </tr>
    <tr>
      <td class="tableheader" style="border-bottom: #ddd solid 1px">
        <p>Exchange rate (to USD)</p>
      </td>
      <td style="border-bottom: #ddd solid 1px">
        <p>$exchange_rate$</p>
      </td>
    </tr>-->
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
    $if(isJustification)$
    <tr>
      <td class="tableheader" style="border-bottom: #ddd solid 1px">
        <p>Reasons for self purchasing by requester</p>
      </td>
      <td style="border-bottom: #ddd solid 1px">
        <p>$direct_to_finance_justification$</p>
      </td>
    </tr>
    $endif$
    <tr>
      <td width="20%" class="tableheader" style="border-bottom: #ddd solid 1px">
        <p>Supporting document(s)</p>
      </td>
      <td width="80%" style="border-bottom: #ddd solid 1px">
        <p>$attachmentgeneral$</p>
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
        <th width="10%" align="right" class="tableheader">Quantity</th>
        <th width="5%" align="left" class="tableheader">UoM</th>
        <th width="10%" align="right" class="tableheader">Unit price</th>
        <th width="15%" align="right" class="tableheader">Cost estimated</th>
        <th width="15%" align="right" class="tableheader">Cost estimated (USD)</th>
        <th width="5%" align="right" class="tableheader">Exchange rate</th>
        <th width="10" align="left" class="tableheader">Supporting document(s)</th>
      </tr>
    </thead>
    <tbody>
      $details$
    </tbody>
    <tfoot>
      <tr>
        <th colspan="6" class="tableheader" align="right">Grand Total</th>
        <th class="tableheader" align="right" width="20%">$total$</th>
        <th class="tableheader" align="right" width="20%">$total_usd$</th>
        <th  colspan="2" class="tableheader" align="right">&nbsp;</th>
      </tr>
    </tfoot>
  </table>
</p>
<br>
<p>Thank you.</p>
<br>
$Footer$