$Style$
$if(isTest)$
$TO_CC$
$endif$
<div>
  <table id="tblPODraft" style="border:0px; width:100%;">
    <tr class="noborder">
      <td style="width:15%;"></td>
      <td style="width:35%;"></td>
      <td style="width:10%;"></td>
      <td style="width:15%;"></td>
      <td style="width:25%;"></td>
    </tr>
    <tr class="noborder">
      <td>
        <label>To</label>
      </td>
      <td>
        <label>
          $vendor_name$
        </label>
      </td>
      <td>&nbsp;</td>
      <td>
        <label>P.O. number</label>
      </td>
      <td>
        <label>
          <b>
            $po_sun_code$
          </b>
        </label>
      </td>
    </tr>
    <tr class="noborder">
      <td rowspan="2">&nbsp;</td>
      <td rowspan="2">
        <label>
          $vendor_address$
        </label>
      </td>
      <td rowspan="2">&nbsp;</td>
      <td>
        <label>P.O. date</label>
      </td>
      <td>
        <label>
          $document_date$
        </label>
      </td>
    </tr>
    <tr class="noborder">
      <td>
        <label>Term of payment</label>
      </td>
      <td>
        <label>
          $term_of_payment$
        </label>
      </td>
    </tr>
    <tr class="noborder">
      <td>
        <label>Telephone</label>
      </td>
      <td>
        <label>
          $vendor_telp_no$
        </label>
      </td>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
    </tr>
    <tr class="noborder">
      <td>
        <label>Fax / Telex</label>
      </td>
      <td>
        <label>
          $vendor_fax_no$
        </label>
      </td>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
    </tr>
    <tr class="noborder">
      <td>
        <label>Contact person</label>
      </td>
      <td>
        <label>
          $vendor_contact_person$
        </label>
      </td>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
    </tr>
    <tr class="noborder">
      <td>
        <label>Order reffered to</label>
      </td>
      <td>
        <label>
          $order_reference$
        </label>
      </td>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
    </tr>
    <tr class="noborder">
      <td>&nbsp;</td>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
    </tr>
    <tr>
      <td colspan="5" style="border-top: 0;">
        <table id="tblPODetail" class="table table-bordered" style="border: 1px solid #ddd">
          <thead>
            <tr>
              <th style="width:3%;">No</th>
              <th style="width:10%;">Product code</th>
              <th style="width:30%;">Description</th>
              <th style="width:7%; text-align:right;">Quantity</th>
              <th style="width:5%;">Unit</th>
              <th style="width:10%; text-align:right;">
                Unit price ($currency_id$)
              </th>
              <th style="width:10%; text-align:right;">
                Sub total
              </th>
              <th style="width:8%; text-align:right;">Discount amount</th>
              <th style="width:7%; text-align:right;">Additional discount amount</th>
              <th style="width:10%; text-align:right;">
                Total ($currency_id$)
              </th>
            </tr>
          </thead>
          <tbody>
            $details$
          </tbody>
          <tfoot>
            <tr>
              <th style="border-left:1px solid #ddd !important; text-align:left;" valign="top" rowspan="4" colspan="2">Remarks</th>
              <th style="border-left:1px solid #ddd !important; text-align:left;" valign="top" rowspan="4" colspan="4">
                $remarks$
              </th>
              <th style="border-left:1px solid #ddd !important; font-weight:bold; text-align:left;" colspan="3">Grand total</th>
              <th style="border-left:1px solid #ddd !important; font-weight:bold; text-align:right;">
                $gross_amount$
              </th>
            </tr>
            <tr>
              <th style="border-left:1px solid #ddd !important; font-weight:bold; text-align:left;" colspan="3">Total discount</th>
              <th style="border-left:1px solid #ddd !important; font-weight:bold; text-align:right;">
                $discount$
              </th>
            </tr>
            $if(!isZeroVAT)$
            <tr>
              <th style="border-left:1px solid #ddd !important; font-weight:bold; text-align:left;" colspan="3">
                VAT ($tax$)
              </th>
              <th style="border-left:1px solid #ddd !important; font-weight:bold; text-align:right;">
                $tax_amount$
              </th>
            </tr>
            $endif$
            <tr>
              <th style="border-left:1px solid #ddd !important; font-weight:bold; text-align:left;" colspan="3">Total amount</th>
              <th style="border-left:1px solid #ddd !important; font-weight:bold; text-align:right;">
                $total_amount$
              </th>
            </tr>
          </tfoot>
        </table>
        <p></p>
      </td>
    </tr>
    <tr class="noborder">
      <td colspan="2">
        <label>
          Delivery address:<br />
          $cifor_delivery_address$
        </label>
      </td>
      <td>&nbsp;</td>
      <td colspan="2">
        <label>
          For payment send invoice (Quote PO number reference) and proof of delivery to:<br />
          $invoice_delivery_address$
        </label>
      </td>
    </tr>
    <tr class="noborder">
      <td>
        <label>Telephone</label>
      </td>
      <td>
        <label>
          $delivery_telp$
        </label>
      </td>
      <td>&nbsp;</td>
      <td>
        <label>Attention</label>
      </td>
      <td>
        <label>
          $accountant$
        </label>
      </td>
    </tr>
    <tr class="noborder">
      <td>
        <label>Fax number</label>
      </td>
      <td>
        <label>
          $delivery_fax$
        </label>
      </td>
      <td>&nbsp;</td>
      <td>
        <label>Delivery date</label>
      </td>
      <td>
        <label>
          $expected_delivery_date$
        </label>
      </td>
    </tr>
    <tr class="noborder">
      <td>
        <label>Attention</label>
      </td>
      <td>
        <label>Operation Assistant</label>
      </td>
      <td>&nbsp;</td>
      <td>
        <label>Ship via</label>
      </td>
      <td>
        <label>
          $cifor_shipment_account$
        </label>
      </td>
    </tr>
    <tr class="noborder">
      <td>
        <label>Copies to</label>
      </td>
      <td>
        <label>
          1. Administration<br />
          2. Accounting
        </label>
      </td>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
    </tr>
    <tr class="noborder for-print">
      <td colspan="5">&nbsp;</td>
    </tr>
    <tr class="noborder for-print">
      <td colspan="3">&nbsp;</td>
      <td colspan="2" style="text-align:center;">
        <label>
          Authorized for $organization_name$
          <br />
          <br />
          $approver_name$<br />
          $approver_title$<br />
          Approved date: $approver_date$<br />
          <br />
        </label>
      </td>
    </tr>
    <!--<tr class="noborder for-print">
      <td colspan="5" style="text-align:center;">
        <label>CIFOR is a recognize International non-profit organization and is exempt from Indonesian V.A.T according to article 7 of the headquarters agreement.</label>
        <br />
      </td>
    </tr>-->
    <tr class="noborder for-print">
      <td colspan="5" style="text-align:center; font-size:9px;">This is a computer-generated document. No signature is required.</td>
    </tr>
  </table>
</div>
<p>&nbsp;</p>
<p>&nbsp;</p>
$toc$
<p>&nbsp;</p>
<p>&nbsp;</p>
<p>Thank you,
<br/>Procurement unit
</p>
<br>
 $Footer$