//using IdentityModel;
using myTree.WebForms.Procurement.General;
using Newtonsoft.Json;
using Serilog;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Security.Cryptography;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Procurement.PurchaseOrder
{
    public partial class PrintPO : System.Web.UI.Page
    {
        protected string _id = string.Empty;
        protected string moduleName = "PURCHASE ORDER";
        protected string termcondition = string.Empty;
        protected string service_url, based_url = string.Empty;
        protected string browser_name = string.Empty;
        public string page_id { get; set; }
        public string legal_entity { get; set; }

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
        protected string str_additional_discount = string.Empty;
        protected string str_additional_discount_usd = string.Empty;
        protected string str_discount = string.Empty;
        protected string str_discount_usd = string.Empty;
        protected string str_total_amount = string.Empty;
        protected string str_total_amount_usd = string.Empty;
        protected decimal total_amount = 0;
        protected decimal total_amount_usd = 0;
        protected decimal vat_amount, vat_amount_usd, additional_discount, additional_discount_usd, discount, discount_usd = 0;
        protected Boolean vat_payable = false;
        protected Boolean vat_printable = false;
        private static Antlr3.ST.StringTemplateGroup group = new Antlr3.ST.StringTemplateGroup("POHelper");
        private static Antlr3.ST.StringTemplate template = new Antlr3.ST.StringTemplate();
        public static string StartupPath = HttpContext.Current.Server.MapPath("template");
        protected UserRoleAccess userRoleAccess = AccessControl.GetUserRoleAccess(AccessControlObjectEnum.ProcurementPurchaseOrder);

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!HttpContext.Current.User.Identity.IsAuthenticated)
            {
                //HttpContext.Current.GetOwinContext().Authentication.Challenge();
                Log.Information("Session ended re-challenge...");
            }

            if (!userRoleAccess.isCanRead)
            {
                Response.Redirect(AccessControl.GetSetting("access_denied"));
            }

            _id = Request.QueryString["id"] ?? "";
            page_id = _id;
            service_url = statics.GetSetting("service_url");
            based_url = statics.GetSetting("based_url");
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
                        PO.vendor_contact_person_to_email = dr["vendor_email"].ToString();
                        PO.vendor_contact_person = dr["vendor_contact_person_name"].ToString();
                        PO.term_of_payment = dr["term_of_payment"].ToString();
                        PO.term_of_payment_name = dr["term_of_payment_name"].ToString();
                        PO.other_term_of_payment = dr["other_term_of_payment"].ToString();
                        PO.is_other_term_of_payment = dr["is_other_term_of_payment"].ToString();
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
                        PO.total_amount_usd = String.Format("{0:#,0.00}", Decimal.Parse(dr["total_amount_usd"].ToString()));
                        PO.accountant = dr["accountant"].ToString();
                        PO.status_id = dr["status_id"].ToString();
                        PO.po_sun_code = dr["po_sun_code"].ToString();
                        PO.status_name = dr["status_name"].ToString();
                        PO.procurement_address = dr["procurement_address"].ToString();
                        PO.procurement_address_name = dr["procurement_address_name"].ToString();
                        PO.legal_entity = dr["legal_entity"].ToString();
                        legal_entity = PO.legal_entity;
                        PO.is_print = dr["is_print"].ToString();
                        PO.contact_description = dr["ContactDescription"].ToString();

                        total_amount = Decimal.Parse(dr["total_amount"].ToString());
                        total_amount_usd = Decimal.Parse(dr["total_amount_usd"].ToString());
                    }

                    decimal vat_amount_temp = 0;
                    decimal vat_amount_usd_temp = 0;
                    foreach (DataRow dm in ds.Tables[1].Rows)
                    {
                        vat_amount_temp = string.IsNullOrEmpty(dm["vat_amount"].ToString()) ? 0 : Decimal.Parse(dm["vat_amount"].ToString());

                        if (dm["exchange_sign"].ToString() == "*")
                        {
                            vat_amount_usd_temp = Decimal.Parse(dm["vat_amount"].ToString()) * Decimal.Parse(dm["exchange_rate"].ToString());
                        }
                        else
                        {
                            vat_amount_usd_temp = Decimal.Parse(dm["vat_amount"].ToString()) / Decimal.Parse(dm["exchange_rate"].ToString());
                        }
                        if (string.IsNullOrEmpty(dm["vat_printable"].ToString()) ? Boolean.Parse(dm["vat_payable"].ToString()) : Boolean.Parse(dm["vat_printable"].ToString()))
                        {
                            if (vat_amount_temp == 0 || vat_amount_usd_temp == 0)
                            {
                                vat_amount_temp = ((string.IsNullOrEmpty(dm["po_line_total"].ToString()) ? 0 : Decimal.Parse(dm["po_line_total"].ToString())) * Decimal.Parse(dm["tax"].ToString())) / 100;
                                vat_amount_usd_temp = ((string.IsNullOrEmpty(dm["po_line_total_usd"].ToString()) ? 0 : Decimal.Parse(dm["po_line_total_usd"].ToString())) * Decimal.Parse(dm["tax"].ToString())) / 100;

                                total_amount += vat_amount_temp;
                                total_amount_usd += vat_amount_usd_temp;
                            }
                                vat_amount += vat_amount_temp;
                                vat_amount_usd += vat_amount_usd_temp;
                        }
                        else
                        {
                            total_amount -= vat_amount_temp;
                            total_amount_usd -= vat_amount_usd_temp;
                        }

                        if (!vat_printable)
                        {
                            vat_printable = (string.IsNullOrEmpty(dm["vat_printable"].ToString()) ? Boolean.Parse(dm["vat_payable"].ToString()) : Boolean.Parse(dm["vat_printable"].ToString()));
                        }

                        discount += string.IsNullOrEmpty(dm["po_discount"].ToString()) ? 0 : Decimal.Parse(dm["po_discount"].ToString());
                        additional_discount += string.IsNullOrEmpty(dm["po_additional_discount"].ToString()) ? 0 : Decimal.Parse(dm["po_additional_discount"].ToString());
                        if (dm["exchange_sign"].ToString() == "*")
                        {
                            discount_usd += Decimal.Parse(dm["po_discount"].ToString()) * Decimal.Parse(dm["exchange_rate"].ToString());
                            additional_discount_usd += Decimal.Parse(dm["po_additional_discount"].ToString()) * Decimal.Parse(dm["exchange_rate"].ToString());
                        }
                        else
                        {
                            discount_usd += Decimal.Parse(dm["po_discount"].ToString()) / Decimal.Parse(dm["exchange_rate"].ToString());
                            additional_discount_usd += Decimal.Parse(dm["po_additional_discount"].ToString()) / Decimal.Parse(dm["exchange_rate"].ToString());
                        }
                    }

                    str_vat_amount = String.Format("{0:#,0.00}", vat_amount);
                    str_vat_amount_usd = String.Format("{0:#,0.00}", vat_amount_usd);

                    str_discount = String.Format("{0:#,0.00}", discount);
                    str_discount_usd = String.Format("{0:#,0.00}", discount_usd);
                    str_additional_discount = String.Format("{0:#,0.00}", additional_discount);
                    str_additional_discount_usd = String.Format("{0:#,0.00}", additional_discount_usd);

                    str_total_amount = String.Format("{0:#,0.00}", total_amount);
                    str_total_amount_usd = String.Format("{0:#,0.00}", total_amount_usd);

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

            group.RootDir = StartupPath;
            Antlr3.ST.StringTemplate template = group.GetInstanceOf("PO_TOC");
            termcondition = template.ToString();
            template.Reset();
        }
    }
}