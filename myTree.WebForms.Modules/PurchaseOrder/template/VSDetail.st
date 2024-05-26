<p>
  <table border="0" cellspacing="0" cellpadding="5" width="100%" class="tblPrint tblBorder">
    <tr>
      <td width="20%" style="border-bottom: #C2D69A solid 1px">
        <p>Quotation analysis code</p>
      </td>
      <td width="80%" style="border-bottom: #C2D69A solid 1px">
        <p>$vs_no$</p>
      </td>
    </tr>
    <tr>
      <td width="20%" style="border-bottom: #C2D69A solid 1px">
        <p>Quotation analysis date</p>
      </td>
      <td width="80%" style="border-bottom: #C2D69A solid 1px">
        <p>$document_date$</p>
      </td>
    </tr>
  </table>
  <br/>
  <table border="0" cellspacing="0" cellpadding="5" width="100%" class="tblPrint tblBorder">
    <thead>
      <tr>
        <th rowspan="2" style="width:5%; vertical-align:top;">Product code</th>
        <th rowspan="2" style="vertical-align:top;">Product description</th>
        <th rowspan="2" style="width:5%; vertical-align:top;">PR code</th>
        <th colspan="2" style="width:10%; text-align:center; vertical-align:top;">Purchase requisition</th>
        $vendor_header$
      </tr>
      <tr>
        <th style="text-align:right;">Unit price</th>
        <th style="text-align:right;">Quantity</th>
        $vendor_header_detail$
      </tr>
    </thead>
    <tbody>
      $detail$
      <tr>
        <td colspan="6" style="text-align:right;">Discount</td>$discount$
      </tr>
      <tr>
        <td colspan="6" style="text-align:right;">Additional discount</td>$additional_discount$
      </tr>
      <tr>
        <td colspan="6" style="text-align:right;">Total after additional discount (in target currency)</td>$total$
        <!--<td colspan="6" style="text-align:right;"><b>Total after discount (in original currency)</b></td>$total$-->
      </tr>
      <tr>
        <!--<td colspan="6" style="text-align:right;"><b>Exchange rate</b></td>$exchange_rate$-->
        <td colspan="6" style="text-align:right;">
          Exchange rate
        </td>$exchange_rate$
      </tr>
      <tr>
        <!--<td colspan="6" style="text-align:right;"><b>Total after discount (in USD)</b></td>$total_usd$-->
        <td colspan="6" style="text-align:right;">
          Total after discount (in USD)
        </td>$total_usd$
      </tr>
      <tr>
        <td colspan="6" style="text-align:right;">Lead time</td>$indent_time$
      </tr>
      <tr>
        <td colspan="6" style="text-align:right;">Warranty time</td>$warranty_time$
      </tr>
      <tr>
        <td colspan="6" style="text-align:right;">Delivery time</td>$delivery_time$
      </tr>
      <tr>
        <td colspan="6" style="text-align:right;">Selected supplier</td>$selected$
      </tr>
      <tr>
        <td colspan="6" style="text-align:right;">Reason for selection</td>$reason_for_selection$
      </tr>
      <tr>
        <td colspan="6" style="text-align:right;">Remarks	</td>$remarks$
      </tr>
      <tr>
        <td colspan="6" style="text-align:right;">Upload justification (if any)</td>$justification_file$
      </tr>
    </tbody>
  </table>
</p>
<br/>