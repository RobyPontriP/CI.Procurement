<p>
  <table border="0" cellspacing="0" cellpadding="5" width="100%" class="tblPrint">
    <tr>
      <td width="20%" style="border-bottom: #C2D69A solid 1px">
        PR code
      </td>
      <td width="80%" style="border-bottom: #C2D69A solid 1px">
        $pr_no$
      </td>
    </tr>
    <tr>
      <td width="20%" style="border-bottom: #C2D69A solid 1px">
        PR status
      </td>
      <td width="80%" style="border-bottom: #C2D69A solid 1px">
        $status_name$
      </td>
    </tr>
    <tr>
      <td style="border-bottom: #C2D69A solid 1px">
        Requester
      </td>
      <td style="border-bottom: #C2D69A solid 1px">
        $requester$
      </td>
    </tr>
    <tr>
      <td style="border-bottom: #C2D69A solid 1px">
        Required date
      </td>
      <td style="border-bottom: #C2D69A solid 1px">
        $required_date$
      </td>
    </tr>
    <tr>
      <td style="border-bottom: #C2D69A solid 1px">
        Purchase/finance office
      </td>
      <td style="border-bottom: #C2D69A solid 1px">
        $purchase_office$
      </td>
    </tr>
    <tr>
      <td style="border-bottom: #C2D69A solid 1px">
        Remarks
      </td>
      <td style="border-bottom: #C2D69A solid 1px">
        $remarks$
      </td>
    </tr>
    <!--<tr>
      <td style="border-bottom: #C2D69A solid 1px">
        Currency
      </td>
      <td style="border-bottom: #C2D69A solid 1px">
        $currency$ &nbsp;&nbsp;&nbsp; Exchange rate (to USD)&nbsp; $exchange_sign$ $exchange_rate$
      </td>
    </tr>-->
  </table>
  <br/>
  <table border="0" cellspacing="0" cellpadding="7" width="100%" class="tblPrint">
    <thead>
      <tr>
        <th width="5%" align="left">Product code</th>
        <th width="25%" align="left">Description</th>
        <th width="10%" align="left">Product status</th>
        <th width="5%" align="right">Requested quantity</th>
        <th width="5%" align="right">Outstanding quantity</th>
        <th width="5%" align="left">UoM</th>
        <th width="5%" align="left">Currency</th>
        <!--<th width="10%" align="right">Unit price</th>-->
        <th width="10%" align="right">Cost estimated</th>
        <th width="10%" align="right">Cost estimated (USD)</th>
        <th width="10%" align="right">Supporting document(s)</th>
      </tr>
    </thead>
    <tbody>
      $details$
      <tr>
        <th align="right" colspan="7">Grand total</th>
        <!--<th align="right">$total_estimated$</th>
        <th align="right">$total_estimated_usd$</th>-->
        <th align="right">$total_estimated$</th>
        <th align="right">$total_estimated_usd$</th>
      </tr>
    </tbody>
  </table>
  <br/>
  <table border="0" cellspacing="0" cellpadding="5" width="100%" class="tblPrint">
    <tr>
      <td width="20%" style="border-bottom: #C2D69A solid 1px">
        Purchase type
      </td>
      <td width="80%" style="border-bottom: #C2D69A solid 1px; word-break: break-all;">
        $purchase_type_description$
      </td>
    </tr>
    <!--$if(is_show_pr_type)$
    <tr>
      <td style="border-bottom: #C2D69A solid 1px">
        Reasons for self purchasing by requester
      </td>
      <td style="border-bottom: #C2D69A solid 1px; word-break: break-all;">
        $direct_to_finance_justification$
      </td>
    </tr>
    $endif$-->
    $if(isJustification)$
    <tr>
      <td class="tableheader" style="border-bottom: #ddd solid 1px">
        <p>Justification</p>
      </td>
      <td style="border-bottom: #ddd solid 1px">
        <p>$direct_to_finance_justification$</p>
      </td>
    </tr>
    $endif$
    $if(is_show_reference_no)$
    <tr>
      <td style="border-bottom: #C2D69A solid 1px">
        Reference number
      </td>
      <td style="border-bottom: #C2D69A solid 1px; word-break: break-all;">
        $reference_no$
      </td>
    </tr>
    $endif$
  </table>
</p>
<br/>