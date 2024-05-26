using myTree.WebForms.Procurement.General;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Procurement.PurchaseOrder
{
    public partial class uscPurchaseOrderDetail : System.Web.UI.UserControl
    {
        public string page_id { get; set; }

        private DataTable dtHeader = new DataTable();
        private DataTable dtDetail = new DataTable();

        protected DataModel.PurchaseOrder PO = new DataModel.PurchaseOrder();
        protected string PODetail = "[]"
            , PODetailsCC = "[]";

        protected string approver_name = string.Empty;
        protected string approver_title = string.Empty;
        protected string approver_date = string.Empty;
        protected string str_vat_amount = string.Empty;
        protected string str_vat_amount_usd = string.Empty;

        protected decimal vat_amount, vat_amount_usd = 0;
        protected Boolean vat_payable = false;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!String.IsNullOrEmpty(page_id))
            {
                DataSet ds = staticsPurchaseOrder.Main.GetDataDetail(page_id);
                if (ds.Tables.Count > 0)
                {
                    dtHeader = ds.Tables[0];
                    if (dtHeader.Rows.Count > 0)
                    {
                        DataRow dr = dtHeader.Rows[0];
                        PO.id = page_id;
                        PO.po_no = dr["po_no"].ToString();
                        PO.vendor_name = dr["vendor_name"].ToString();
                        PO.vendor_address = dr["vendor_address"].ToString();
                        PO.vendor_telp_no = dr["vendor_telp_no"].ToString();
                        PO.vendor_fax_no = dr["vendor_fax_no"].ToString();
                        PO.vendor_contact_person = dr["vendor_contact_person_name"].ToString();
                        PO.term_of_payment = dr["term_of_payment"].ToString();
                        PO.term_of_payment_name = dr["term_of_payment_name"].ToString();
                        PO.other_term_of_payment = dr["other_term_of_payment"].ToString();
                        PO.remarks = dr["remarks"].ToString();
                        PO.document_date = dr["document_date"].ToString();
                        if (!string.IsNullOrEmpty(PO.document_date))
                        {
                            PO.document_date = DateTime.Parse(dr["document_date"].ToString()).ToString("dd MMM yyyy");
                        }
                        PO.expected_delivery_date = dr["expected_delivery_date"].ToString();
                        if (!string.IsNullOrEmpty(PO.expected_delivery_date))
                        {
                            PO.expected_delivery_date = DateTime.Parse(dr["expected_delivery_date"].ToString()).ToString("dd MMM yyyy");
                        }
                        PO.cifor_delivery_address = dr["cifor_delivery_address_name"].ToString();
                        PO.is_other_address = dr["is_other_address"].ToString();
                        PO.other_address = dr["other_address"].ToString();
                        PO.delivery_telp = dr["cifor_delivery_telp"].ToString();
                        PO.delivery_fax = dr["cifor_delivery_fax"].ToString();
                        PO.cifor_shipment_account = dr["cifor_shipment_name"].ToString();
                        PO.order_reference = dr["order_reference"].ToString();
                        PO.currency_id = dr["currency_id"].ToString();
                        PO.gross_amount = String.Format("{0:#,0.00}", Decimal.Parse(dr["gross_amount"].ToString()));
                        PO.discount = String.Format("{0:#,0.00}", Decimal.Parse(dr["discount"].ToString()));
                        PO.tax = String.Format("{0:#,0.00}", Decimal.Parse(dr["tax"].ToString())) + "%";
                        PO.tax_amount = String.Format("{0:#,0.00}", Decimal.Parse(dr["tax_amount"].ToString()));
                        PO.total_amount = String.Format("{0:#,0.00}", Decimal.Parse(dr["total_amount"].ToString()));
                        PO.accountant = dr["accountant"].ToString();
                        PO.status_id = dr["status_id"].ToString();
                        PO.po_sun_code = dr["po_sun_code"].ToString();
                        PO.status_name = dr["status_name"].ToString();
                    }

                    foreach (DataRow dm in ds.Tables[1].Rows)
                    {
                        if (Boolean.Parse(dm["vat_payable"].ToString()))
                        {
                            vat_amount += string.IsNullOrEmpty(dm["vat_amount"].ToString()) ? 0 : Decimal.Parse(dm["vat_amount"].ToString());

                            if (dm["exchange_sign"].ToString() == "*")
                            {
                                vat_amount_usd += Decimal.Parse(dm["vat_amount"].ToString()) * Decimal.Parse(dm["exchange_rate"].ToString());
                            }
                            else
                            {
                                vat_amount_usd += Decimal.Parse(dm["vat_amount"].ToString()) / Decimal.Parse(dm["exchange_rate"].ToString());
                            }
                        }

                        if (!vat_payable)
                        {
                            vat_payable = Boolean.Parse(dm["vat_payable"].ToString());
                        }

                    }

                    str_vat_amount = String.Format("{0:#,0.00}", vat_amount);
                    str_vat_amount_usd = String.Format("{0:#,0.00}", vat_amount_usd);

                    dtDetail = ds.Tables[1];
                    PODetailsCC = JsonConvert.SerializeObject(ds.Tables[3]);
                    PODetail = JsonConvert.SerializeObject(dtDetail);

                    foreach (DataRow dr in ds.Tables[2].Rows)
                    {
                        approver_name = dr["EMP_NAME"].ToString();
                        approver_title = dr["JOB_TITLE"].ToString();
                        approver_date = dr["APPROVED_DATE"].ToString();
                    }
                }

            }
        }
    }
}