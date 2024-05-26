$Style$
$if(isTest)$
$TO_CC$
$endif$
<p>Dear $requester$,</p>
<p>
  This is to inform you that your $pr_type$ is complete and all the product(s) requested are confirmed and received.
  <br/>
  Below are the product(s) you requested and their status.
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
        <p>Purchase/finance office</p>
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
        $if(is_finance)$
        <th width="30%" align="left" class="tableheader">Product code</th>
        <th width="50%" align="left" class="tableheader">Description</th>
        <th width="10%" align="right" class="tableheader">Quantity</th>
        <th width="10%" align="left" class="tableheader">UOM</th>
        $else$
        <th width="20%" align="left" class="tableheader">Product code</th>
        <th width="35%" align="left" class="tableheader">Description</th>
        <th width="10%" align="right" class="tableheader">Quantity</th>
        <th width="5%" align="left" class="tableheader">UOM</th>
        <th width="15%" align="left" class="tableheader">Confirmation status</th>
        <th width="15%" align="left" class="tableheader">Confirmation date</th>
        $endif$
      </tr>
    </thead>
    <tbody>
      $details$
    </tbody>
  </table>
</p>
<br>

<br>
<p>
  $if(is_finance)$
  Thank you,
  <br/>Finance
  $else$
  Thank you.
  $endif$
</p>
<br>
$Footer$