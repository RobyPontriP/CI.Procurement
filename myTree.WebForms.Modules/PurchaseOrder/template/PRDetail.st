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
  <table border="0" cellspacing="0" cellpadding="5" width="100%" class="tblPrint">
    <thead>
      <tr>
        <th width="10%" align="left">Product code</th>
        <th width="35%" align="left">Description</th>
        <th width="5%" align="right">Quantity</th>
        <th width="5%" align="left">UOM</th>
        <th width="10%" align="right">Unit price</th>
        <th width="5%" align="left">Currency</th>
        <th width="15%" align="right">Estimated cost</th>
        <th width="15%" align="right">Estimated cost (USD)</th>
      </tr>
    </thead>
    <tbody>
      $details$
      <tr>
        <th align="left" colspan="6">Total</th>
        <th align="right">$total_estimated$</th>
        <th align="right">$total_estimated_usd$</th>
      </tr>
    </tbody>
  </table>
</p>
<br/>