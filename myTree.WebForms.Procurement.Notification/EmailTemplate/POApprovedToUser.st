$Style$
$if(isTest)$
$TO_CC$
$endif$
<p>Dear $requester$,</p>
<p>
  This is to inform you that the purchase order [$po_no$] related to your purchase requisition on below product(s) is approved.
  <br/>
  The next step for this purchasing is wait for delivery from the selected supplier.
</p>
$details$
<p>
  <table border="0" cellspacing="0" cellpadding="5" width="100%">
    <tr>
      <td width="20%" class="tableheader" style="border-bottom: #ddd solid 1px">
        <p>Supplier</p>
      </td>
      <td width="80%" style="border-bottom: #ddd solid 1px">
        <p>$vendor$</p>
      </td>
    </tr>
    <tr>
      <td width="20%" class="tableheader" style="border-bottom: #ddd solid 1px">
        <p>Estimated delivery date</p>
      </td>
      <td width="80%" style="border-bottom: #ddd solid 1px">
        <p>$delivery_date$</p>
      </td>
    </tr>
  </table>
</p>
<p>
  Should you have any questions kindly contact $footer$
</p>
<p>Thank you,
<br/>Procurement unit
</p>
<br>
 $Footer$