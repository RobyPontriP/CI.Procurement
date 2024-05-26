$Style$
$if(isTest)$
$TO_CC$
$endif$
<p>Dear $requester$,</p>
<p>
  This is to inform you that your purchase requisition for below item(s) has been verified.
  <br/>
  Procurement unit will start the purchasing process.
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
  </table>
</p>
<p>
  <table border="0" cellspacing="0" cellpadding="5" width="100%">
    <thead>
      <tr>
        <th width="20%" align="left" class="tableheader">Product code</th>
        <th width="50%" align="left" class="tableheader">Description</th>
        <th width="15%" align="right" class="tableheader">Quantity</th>
        <th width="15%" align="left" class="tableheader">UOM</th>
      </tr>
    </thead>
    <tbody>
      $details$
    </tbody>
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