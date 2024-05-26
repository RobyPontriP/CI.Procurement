<div>
  <table style="border:0px; width:100%;" class="tblPrint">
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
        <label>$payment_term_label$</label>
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
        <table class="table table-bordered" style="border: 1px solid #ddd">
          <thead>
            <tr>
              <th >No</th>
              <th>Product code</th>
              <th style="width:20%;">Description</th>
              <th style="text-align:right;">Quantity</th>
              <th>Unit</th>
              <th>Currency</th>
              <th style="text-align:right;">
                Unit price ($currency_id$)
              </th>
              <th style="text-align:right;">Discount amount</th>
              <th style="text-align:right;">Additional discount amount</th>
              <th style="text-align:right;">
                Sub total
              </th>
              <th>VAT</th>
              <th>VAT amount per unit</th>
              <th>Total VAT amount</th>
              <th style="text-align:right;">
                Total ($currency_id$)
              </th>
              <!--<th>No</th>
              <th>Product code</th>
              <th>Description</th>
              <th style="text-align:right;">Quantity</th>
              <th>Unit</th>
              <th>Currency</th>
              <th style="text-align:right;">
                Unit price
              </th>
              <th style="text-align:right;">
                Sub total
              </th>
              <th style="text-align:right;">Discount amount</th>
              <th style="text-align:right;">Additional discount amount</th>
              <th>VAT code</th>
              <th>VAT payable?</th>
              <th>VAT amount per unit</th>
              <th>Total VAT amount</th>
              <th style="text-align:right;">
                Total
              </th>-->
            </tr>
          </thead>
          <tbody>
            $details$
          </tbody>
          <tfoot>
            <tr>
              <th style="border-left:1px solid #ddd !important; text-align:left;" valign="top" rowspan="5" colspan="2">Remarks</th>
              <th style="border-left:1px solid #ddd !important; text-align:left;" valign="top" rowspan="5" colspan="9">
                $remarks$
              </th>
              <th style="border-left:1px solid #ddd !important; font-weight:bold; text-align:left;" colspan="2">Total amount</th>
              <th style="border-left:1px solid #ddd !important; font-weight:bold; text-align:right;" colspan="2">
                $gross_amount$
              </th>
            </tr>
            <tr>
              <th style="border-left:1px solid #ddd !important; font-weight:bold; text-align:left;" colspan="2">Total discount</th>
              <th style="border-left:1px solid #ddd !important; font-weight:bold; text-align:right;" colspan="2">
                $discount$
              </th>
            </tr>
            <tr>
              <th style="border-left:1px solid #ddd !important; font-weight:bold; text-align:left;" colspan="2">Additional discount</th>
              <th style="border-left:1px solid #ddd !important; font-weight:bold; text-align:right;" colspan="2">
                $additional_discount$
              </th>
            </tr>
            <tr>
              <th style="border-left:1px solid #ddd !important; font-weight:bold; text-align:left;" colspan="2">VAT</th>
              <th style="border-left:1px solid #ddd !important; font-weight:bold; text-align:right;" colspan="2">
                $vat$
              </th>
            </tr>
            <tr>
              <th style="border-left:1px solid #ddd !important; font-weight:bold; text-align:left;" colspan="2">Grand total</th>
              <th style="border-left:1px solid #ddd !important; font-weight:bold; text-align:right;" colspan="2">
                $total_amount$
              </th>
            </tr>
            <!--$if(!isZeroVAT)$
            <tr>
              <th style="border-left:1px solid #ddd !important; font-weight:bold; text-align:left;" colspan="3">
                VAT ($tax$)
              </th>
              <th style="border-left:1px solid #ddd !important; font-weight:bold; text-align:right;">
                $tax_amount$
              </th>
            </tr>
            $endif$-->
          </tfoot>
        </table>
        <p></p>
      </td>
    </tr>
    <tr class="noborder">
      <td colspan="2" valign="top">
        <label>
          $delivery_address_label$<br />
          $cifor_delivery_address$
          <!--Delivery address:<br />
          $cifor_delivery_address$-->
        </label>
      </td>
      <td>&nbsp;</td>
      <td colspan="2">
        <label>
          For payment send invoice (Quote PO number reference) and proof of delivery to:<br />
          $proc_office_address_name_desc$<br />
          $proc_office_address$<br />
          <!--Bogor Barat 16115<br />-->
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
      <!--<td>
        <label>Attention</label>
      </td>
      <td>
        <label>
          $accountant$
        </label>
      </td>-->
    </tr>
    <tr class="noborder">
      <td>
        <label>Email</label>
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
        <label></label>
      </td>
      <td>
        <label></label>
      </td>
      <td>&nbsp;</td>
      <td>
        <label>Delivery method</label>
      </td>
      <td>
        <label>
          $cifor_shipment_account$
        </label>
      </td>
    </tr>
    <tr class="noborder">
      <td>
        <label></label>
      </td>
      <td>
        <label>
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
          Authorized for $legal_entity$
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
      <td colspan="5" align="center">
        <label>CIFOR is a recognize International non-profit organization and is exempt from Indonesian V.A.T according to article 7 of the headquarters agreement.</label>
        <br />
      </td>
    </tr>
    <tr class="noborder for-print">
      <td colspan="5" style="text-align:center; font-size:9px;">This is a computer-generated document. No signature is required.</td>
    </tr>-->
  </table>
</div>