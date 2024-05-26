using myTree.WebForms.Procurement.General;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Procurement.PurchaseOrder
{
    public partial class CompiledPO : System.Web.UI.Page
    {
        string id = string.Empty;

        protected string htmlOutput = string.Empty;
        protected string po_code = string.Empty;

        private static Antlr3.ST.StringTemplateGroup group = new Antlr3.ST.StringTemplateGroup("POHelper");
        private static Antlr3.ST.StringTemplate template = new Antlr3.ST.StringTemplate();
        public static string StartupPath = HttpContext.Current.Server.MapPath("template");

        protected void Page_Load(object sender, EventArgs e)
        {
            id = Request.QueryString["id"] ?? "";
            if (!string.IsNullOrEmpty(id)) {
                po_code = staticsPurchaseOrder.GetFullNumber(id);
                /* PR print */
                htmlOutput += "<h3 align='center'>PURCHASE REQUISITION(S)<h3>" + GetPRTemplate(id) + "<p style='page-break-after: always;'>&nbsp;</p>";

                /* Business partner selection print */
                htmlOutput += "<h3 align='center'>QUOTATION ANALYSIS<h3>" + GetVSTemplate(id) + "<p style='page-break-after: always;'>&nbsp;</p>";

                /* PO print */
                htmlOutput += "<h3 align='center'>PURCHASE ORDER<h3>" + GetPOTemplate(id);
            }
        }

        public static string GetPRTemplate(string po_id) {
            string templateString = string.Empty;
            group.RootDir = StartupPath;
            Antlr3.ST.StringTemplate template = group.GetInstanceOf("PRDetail");
            Antlr3.ST.StringTemplate comment = group.GetInstanceOf("Comment");

            DataSet PR = staticsPurchaseOrder.CompiledPO.PRData(po_id);
            DataTable cc = new DataTable();

            if (PR.Tables.Count >0)
            {
                cc = PR.Tables[2];
            }

            foreach (DataRow drPR in PR.Tables[0].Rows)
            {
                int i = 1;
                string rowClass = string.Empty;

                /* populate comments */
                string commentDetail = string.Empty;
                DataTable dtComment = statics.Comment.GetData(drPR["id"].ToString(), "PURCHASE REQUISITION");
                foreach (DataRow drC in dtComment.Rows)
                {
                    if (i % 2 != 0)
                    {
                        rowClass = "basefont";
                    }
                    else
                    {
                        rowClass = "zebra";
                    }

                    Antlr3.ST.StringTemplate row = group.GetInstanceOf("CommentDetail");
                    row.SetAttribute("class", rowClass);
                    row.SetAttribute("name", drC["emp_user_id"].ToString());
                    row.SetAttribute("role", drC["roles"].ToString());
                    row.SetAttribute("date", drC["created_date"].ToString());
                    row.SetAttribute("action", drC["action_taken"].ToString());
                    row.SetAttribute("comment", drC["comment"].ToString());
                    commentDetail += row.ToString();
                    i++;
                }
                comment.SetAttribute("details", commentDetail);
                templateString += comment.ToString();
                comment.Reset();

                /* populate PR */
                template.SetAttribute("pr_no", drPR["pr_no"].ToString());
                template.SetAttribute("requester", drPR["requester_name"].ToString());
                template.SetAttribute("required_date", drPR["required_date"].ToString());
                template.SetAttribute("purchase_office", drPR["cifor_office_name"].ToString());

                /*template.SetAttribute("isDirectToFinance", Boolean.Parse(drPR["isDirectToFinance"].ToString()));
                template.SetAttribute("is_direct_to_finance", drPR["is_direct_to_finance"].ToString());
                template.SetAttribute("direct_to_finance_justification", drPR["direct_to_finance_justification"].ToString());*/

                template.SetAttribute("cost_center", drPR["cost_center"].ToString());
                template.SetAttribute("remarks", drPR["remarks"].ToString());
                template.SetAttribute("currency", drPR["currency_id"].ToString());
                template.SetAttribute("exchange_sign", drPR["exchange_sign"].ToString());
                template.SetAttribute("exchange_rate", drPR["exchange_rate"].ToString());
                //template.SetAttribute("total_estimated", String.Format("{0:#,0.00}", Decimal.Parse(drPR["total_estimated"].ToString())) ?? "0");
                //template.SetAttribute("total_estimated_usd", String.Format("{0:#,0.00}", Decimal.Parse(drPR["total_estimated_usd"].ToString())) ?? "0");

                string rowDetail = string.Empty;
                decimal estimatedcost_usd = 0;
                List<string> listCurrency = new List<string>();
                DataTable PRD = PR.Tables[1].Select("pr_id='" + drPR["id"].ToString() + "'", "line_no asc").CopyToDataTable();
                i = 1;
                foreach (DataRow drPRD in PRD.Rows)
                {
                    if (i % 2 != 0)
                    {
                        rowClass = "basefont";
                    }
                    else
                    {
                        rowClass = "zebra";
                    }

                    Antlr3.ST.StringTemplate row = group.GetInstanceOf("PRDetail_data");
                    row.SetAttribute("class", rowClass);
                    row.SetAttribute("item_code", drPRD["item_code"].ToString());
                    row.SetAttribute("description", drPRD["item_description"].ToString());
                    row.SetAttribute("quantity", String.Format("{0:#,0.00}", Decimal.Parse(drPRD["request_qty"].ToString())) ?? "0");
                    row.SetAttribute("uom", drPRD["uom_name"].ToString());
                    row.SetAttribute("unit_price", String.Format("{0:#,0.00}", Decimal.Parse(drPRD["unit_price"].ToString())) ?? "0");
                    row.SetAttribute("currency_id", drPRD["currency_id"].ToString());
                    row.SetAttribute("exchange_rate", drPRD["exchange_rate"].ToString());
                    row.SetAttribute("exchange_sign", drPRD["exchange_sign"].ToString());
                    row.SetAttribute("estimated_cost", String.Format("{0:#,0.00}", Decimal.Parse(drPRD["estimated_cost"].ToString())) ?? "0");
                    row.SetAttribute("estimated_cost_usd", String.Format("{0:#,0.00}", Decimal.Parse(drPRD["estimated_cost_usd"].ToString())) ?? "0");

                    #region detail cost center
                    Antlr3.ST.StringTemplate rowDcc = group.GetInstanceOf("PRDetailCostCenter");
                    string rowDetailCostCenter_data = string.Empty, rowDetailCostCenter = string.Empty, ccClass = string.Empty;
                    int j = 0;
                    foreach (DataRow dcc in cc.Rows)
                    {
                        if (drPRD["id"].ToString() == dcc["pr_detail_id"].ToString())
                        {
                            if (j % 2 != 0)
                            {
                                ccClass = "basefont";
                            }
                            else
                            {
                                ccClass = "zebra";
                            }

                            Antlr3.ST.StringTemplate rowDcc_data = group.GetInstanceOf("PRDetailCostCenter_Data");

                            var cost_center = String.Format("{0} - {1}", dcc["cost_center_id"].ToString(), dcc["CostCenterName"].ToString());
                            rowDcc_data.SetAttribute("class", ccClass);
                            rowDcc_data.SetAttribute("cost_center", String.Format("{0} - {1}", dcc["cost_center_id"].ToString(), dcc["CostCenterName"].ToString()));
                            rowDcc_data.SetAttribute("work_order", String.Format("{0} - {1}", dcc["work_order"].ToString(), dcc["Description"].ToString()));
                            rowDcc_data.SetAttribute("entity", String.Format("{0} - {1}", dcc["entity_id"].ToString(), dcc["entitydesc"].ToString()));
                            rowDcc_data.SetAttribute("legal_entity", dcc["legal_entity"].ToString());
                            rowDcc_data.SetAttribute("percentage", dcc["percentage"]);
                            rowDcc_data.SetAttribute("amount", String.Format("{0:#,0.00}", Decimal.Parse(dcc["amount"].ToString())) ?? "0");
                            rowDcc_data.SetAttribute("amount_usd", String.Format("{0:#,0.00}", Decimal.Parse(dcc["amount_usd"].ToString())) ?? "0");
                            rowDcc_data.SetAttribute("remarks", dcc["remarks"].ToString());

                            rowDetailCostCenter_data += rowDcc_data.ToString();
                            j++;
                        }
                    }

                    rowDcc.SetAttribute("currency_id", drPRD["currency_id"].ToString());
                    rowDcc.SetAttribute("detail_cost_center_data", rowDetailCostCenter_data);
                    rowDetailCostCenter += rowDcc.ToString();
                    row.SetAttribute("detail_cost_center", rowDetailCostCenter);
                    #endregion

                    rowDetail += row.ToString();

                    if (!listCurrency.Contains(drPRD["currency_id"].ToString()))
                    {
                        listCurrency.Add(drPRD["currency_id"].ToString());
                    }

                    estimatedcost_usd += Decimal.Parse(drPRD["estimated_cost_usd"].ToString());
                    i++;
                }

                template.SetAttribute("total_estimated_usd", String.Format("{0:#,0.00}", estimatedcost_usd) ?? "0");

                string strestimated_cost = "";
                foreach (var item in listCurrency)
                {
                    string currencyTemp = "";
                    decimal estimated_cost_temp = 0;
                    DataRow[] PRDCurrency = PRD.Select("currency_id='"+ item.ToString() + "'", "line_no asc");

                    foreach (DataRow drPRDc in PRDCurrency)
                    {
                        currencyTemp = drPRDc["currency_id"].ToString();
                        estimated_cost_temp += Decimal.Parse(drPRDc["estimated_cost"].ToString());
                    }

                    strestimated_cost += "(" + currencyTemp + ") " + (String.Format("{0:#,0.00}", estimated_cost_temp) ?? "0") + "</br>";
                }

                template.SetAttribute("total_estimated", strestimated_cost);

                template.SetAttribute("details", rowDetail);
                templateString += template.ToString();
                template.Reset();

                i++;
            }
            return templateString;
        }

        public static string GetPOTemplate(string po_id)
        {
            string templateString = string.Empty;
            group.RootDir = StartupPath;
            Antlr3.ST.StringTemplate template = group.GetInstanceOf("PODetail");
            Antlr3.ST.StringTemplate comment = group.GetInstanceOf("Comment");

            DataSet ds = staticsPurchaseOrder.Main.GetDataDetail(po_id);

            DataTable main = ds.Tables[0];
            DataTable detail = ds.Tables[1];
            DataTable signed = ds.Tables[2];

            DataTable cc = new DataTable();

            if (ds.Tables.Count > 0)
            {
                cc = ds.Tables[3];
            }

            if (main.Rows.Count > 0)
            {
                int i = 0;
                string rowClass = string.Empty, rowDetail = string.Empty,
                        subject = string.Empty,
                        recipients = string.Empty, MainRecipients = string.Empty, SecondRecipients = string.Empty;

                /* populate comments */
                string commentDetail = string.Empty;
                DataTable dtComment = statics.Comment.GetData(po_id, "PURCHASE ORDER");
                foreach (DataRow drC in dtComment.Rows)
                {
                    if (i % 2 != 0)
                    {
                        rowClass = "basefont";
                    }
                    else
                    {
                        rowClass = "zebra";
                    }

                    Antlr3.ST.StringTemplate row = group.GetInstanceOf("CommentDetail");
                    row.SetAttribute("class", rowClass);
                    row.SetAttribute("name", drC["emp_user_id"].ToString());
                    row.SetAttribute("role", drC["roles"].ToString());
                    row.SetAttribute("date", drC["created_date"].ToString());
                    row.SetAttribute("action", drC["action_taken"].ToString());
                    row.SetAttribute("comment", drC["comment"].ToString());
                    commentDetail += row.ToString();
                    i++;
                }
                comment.SetAttribute("details", commentDetail);
                templateString += comment.ToString();
                comment.Reset();

                foreach (DataRow dm in main.Rows)
                {
                    template.SetAttribute("vendor_name", dm["vendor_name"].ToString());
                    if (string.IsNullOrEmpty(dm["po_sun_code"].ToString()))
                    {
                        template.SetAttribute("po_sun_code", dm["po_no"].ToString() + "/(OCS PO Number - New)");
                    }
                    else
                    {
                        template.SetAttribute("po_sun_code", dm["po_no"].ToString() + " / " + dm["po_sun_code"].ToString());
                    }
                    //<%=PO.po_no %>/(OCS PO Number - New)
                    template.SetAttribute("vendor_address", dm["vendor_address"].ToString());
                    template.SetAttribute("document_date", dm["document_date"].ToString());
                    //template.SetAttribute("term_of_payment", dm["term_of_payment"].ToString());
                    if (dm["is_other_term_of_payment"].ToString() == "1")
                    {
                        template.SetAttribute("payment_term_label", "Other payment term:");
                        template.SetAttribute("term_of_payment", dm["other_term_of_payment"].ToString());
                    }
                    else
                    {
                        template.SetAttribute("payment_term_label", "Payment term:");
                        template.SetAttribute("term_of_payment", dm["term_of_payment_name"].ToString());
                    }
                    template.SetAttribute("vendor_telp_no", dm["vendor_telp_no"].ToString());
                    template.SetAttribute("vendor_fax_no", dm["vendor_fax_no"].ToString());
                    template.SetAttribute("vendor_contact_person", dm["vendor_contact_person_name"].ToString());
                    template.SetAttribute("order_reference", dm["order_reference"].ToString());
                    template.SetAttribute("currency_id", dm["currency_id"].ToString());
                    template.SetAttribute("remarks", dm["remarks"].ToString());
                    //template.SetAttribute("gross_amount", dm["currency_id"].ToString() + " " + String.Format("{0:#,0.00}", Decimal.Parse(dm["gross_amount"].ToString())) ?? "0.00");
                    template.SetAttribute("tax", String.Format("{0:#,0.00}", Decimal.Parse(dm["tax"].ToString())) ?? "0.00");
                    template.SetAttribute("tax_amount", String.Format("{0:#,0.00}", Decimal.Parse(dm["tax_amount"].ToString())) ?? "0.00");
                    //if (dm["currency_id"].ToString().ToLower() == "usd")
                    //{
                    //    template.SetAttribute("total_amount", dm["currency_id"].ToString() + " "+ String.Format("{0:#,0.00}", Decimal.Parse(dm["total_amount"].ToString())) ?? "0.00");
                    //}
                    //else
                    //{
                    //    template.SetAttribute("total_amount", dm["currency_id"].ToString() + " " + (String.Format("{0:#,0.00}", Decimal.Parse(dm["total_amount"].ToString())) ?? "0.00") + " / USD " + String.Format("{0:#,0.00}", Decimal.Parse(dm["total_amount_usd"].ToString())) ?? "0.00");
                    //}
                    
                    if (dm["is_other_address"].ToString() == "1")
                    {
                        template.SetAttribute("delivery_address_label", "Delivery address:");
                        template.SetAttribute("cifor_delivery_address", dm["other_address"].ToString());
                    }
                    else
                    {
                        template.SetAttribute("delivery_address_label", "Delivery address:");
                        template.SetAttribute("cifor_delivery_address", dm["cifor_delivery_address_name"].ToString());
                    }
                    
                    template.SetAttribute("delivery_telp", dm["cifor_delivery_telp"].ToString());
                    template.SetAttribute("accountant", dm["accountant"].ToString());
                    template.SetAttribute("delivery_fax", dm["cifor_delivery_fax"].ToString());
                    template.SetAttribute("expected_delivery_date", DateTime.Parse(dm["expected_delivery_date"].ToString()).ToString("dd MMM yyyy"));
                    template.SetAttribute("cifor_shipment_account", dm["cifor_shipment_name"].ToString());

                    if (Decimal.Parse(dm["tax"].ToString()) == 0 || String.IsNullOrEmpty(dm["tax"].ToString())) {
                        template.SetAttribute("isZeroVAT", true);
                    }

                    template.SetAttribute("legal_entity", (dm["legal_entity"].ToString().ToLower() == "cifor" || dm["legal_entity"].ToString().ToLower() == "germany") ? "CIFOR" : "ICRAF");
                    template.SetAttribute("proc_office_address_name_desc", dm["procurement_address_desc"].ToString());
                    template.SetAttribute("proc_office_address", dm["procurement_address_poa"].ToString());
                }

                decimal discount = 0;
                decimal additional_discount = 0;
                decimal discount_usd = 0;
                decimal additional_discount_usd = 0;
                decimal total_amount = 0;
                decimal total_amount_usd = 0;
                decimal vat_amount = 0;
                decimal vat_amount_usd = 0;
                decimal vat_amount_temp = 0;
                decimal vat_amount_usd_temp = 0;
                string str_vat_amount = "";
                string str_vat_amount_usd = "";
                string str_total_amount = "";
                string str_total_amount_usd = "";
                string str_additional_discount = string.Empty;
                string str_additional_discount_usd = string.Empty;
                string str_discount = string.Empty;
                string str_discount_usd = string.Empty;
                string currency_id= string.Empty;
                Boolean vat_payable = false;
                Boolean vat_printable = false;
                i = 0;

                total_amount = Decimal.Parse(main.Rows[0]["total_amount"].ToString());
                total_amount_usd = Decimal.Parse(main.Rows[0]["total_amount_usd"].ToString());

                foreach (DataRow di in detail.Rows)
                {
                    if (i % 2 != 0)
                    {
                        rowClass = "basefont";
                    }
                    else
                    {
                        rowClass = "zebra";
                    }

                    string description = "";
                    //if (!string.IsNullOrEmpty(di["brand_name"].ToString()))
                    //{
                    //    description += di["brand_name"].ToString() + "<br/>";
                    //}
                    //description += di["description"].ToString() + "<br/>";

                    Antlr3.ST.StringTemplate row = group.GetInstanceOf("PODetail_data");
                    row.SetAttribute("class", rowClass);
                    row.SetAttribute("seq", (i + 1));
                    row.SetAttribute("item_code", di["item_code"].ToString());
                    row.SetAttribute("description", di["quotation_description"]);
                    row.SetAttribute("quantity", String.Format("{0:#,0.00}", Decimal.Parse(di["po_quantity"].ToString())) ?? "0.00");
                    row.SetAttribute("uom", di["uom_name"].ToString());
                    row.SetAttribute("currency", di["currency_id"].ToString());
                    currency_id = di["currency_id"].ToString();
                    row.SetAttribute("unit_price", String.Format("{0:#,0.00}", Decimal.Parse(di["po_unit_price"].ToString())) ?? "0.00");
                    //row.SetAttribute("subtotal", String.Format("{0:#,0.00}", Decimal.Parse(di["po_unit_price"].ToString()) * Decimal.Parse(di["po_quantity"].ToString())) ?? "0.00");
                    
                    row.SetAttribute("discount", String.Format("{0:#,0.00}", Decimal.Parse(di["po_discount"].ToString())) ?? "0.00");
                    row.SetAttribute("additional_discount", String.Format("{0:#,0.00}", Decimal.Parse(di["po_additional_discount"].ToString())) ?? "0.00");
                    row.SetAttribute("total", String.Format("{0:#,0.00}", Decimal.Parse(di["po_line_total"].ToString())) ?? "0.00");

                    discount += string.IsNullOrEmpty(di["po_discount"].ToString()) ? 0 : Decimal.Parse(di["po_discount"].ToString());
                    additional_discount += string.IsNullOrEmpty(di["po_additional_discount"].ToString()) ? 0 : Decimal.Parse(di["po_additional_discount"].ToString());

                    vat_amount_temp = string.IsNullOrEmpty(di["vat_amount"].ToString()) ? 0 : Decimal.Parse(di["vat_amount"].ToString());

                    if (di["exchange_sign"].ToString() == "*")
                    {
                        vat_amount_usd_temp = Decimal.Parse(di["vat_amount"].ToString()) * Decimal.Parse(di["exchange_rate"].ToString());
                    }
                    else
                    {
                        vat_amount_usd_temp = Decimal.Parse(di["vat_amount"].ToString()) / Decimal.Parse(di["exchange_rate"].ToString());
                    }
                    if (string.IsNullOrEmpty(di["vat_printable"].ToString()) ? Boolean.Parse(di["vat_payable"].ToString()) : Boolean.Parse(di["vat_printable"].ToString()))
                    {
                        if (vat_amount_temp == 0 || vat_amount_usd_temp == 0)
                        {
                            vat_amount_temp = ((string.IsNullOrEmpty(di["po_line_total"].ToString()) ? 0 : Decimal.Parse(di["po_line_total"].ToString())) * Decimal.Parse(di["tax"].ToString())) / 100;
                            vat_amount_usd_temp = ((string.IsNullOrEmpty(di["po_line_total_usd"].ToString()) ? 0 : Decimal.Parse(di["po_line_total_usd"].ToString())) * Decimal.Parse(di["tax"].ToString())) / 100;

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
                        vat_printable = (string.IsNullOrEmpty(di["vat_printable"].ToString()) ? Boolean.Parse(di["vat_payable"].ToString()) : Boolean.Parse(di["vat_printable"].ToString()));
                    }

                    if (Boolean.Parse(di["vat_payable"].ToString()))
                    {
                        row.SetAttribute("subtotal", String.Format("{0:#,0.00}", Decimal.Parse(di["po_line_total"].ToString()) + Decimal.Parse(di["vat_amount"].ToString())) ?? "0.00");
                    }
                    else
                    {
                        row.SetAttribute("subtotal", String.Format("{0:#,0.00}", Decimal.Parse(di["po_line_total"].ToString())) ?? "0.00");
                    }
                    if (string.IsNullOrEmpty(di["vat_printable"].ToString()) ? Boolean.Parse(di["vat_payable"].ToString()) : Boolean.Parse(di["vat_printable"].ToString()))
                    {

                    }
                    row.SetAttribute("vat_name", di["tax_name"].ToString() + "<br/>"+ "VAT Payable ? "+ (Boolean.Parse(di["vat_payable"].ToString()) == true ? "Yes" : "No")+ "<br/>"+ "VAT Printable ? " + ((string.IsNullOrEmpty(di["vat_printable"].ToString()) ? Boolean.Parse(di["vat_payable"].ToString()) : Boolean.Parse(di["vat_printable"].ToString())) == true ? "Yes" : "No"));
                    //row.SetAttribute("vat_payable", Boolean.Parse(di["vat_payable"].ToString()) == true ? "Yes" : "No");
                    row.SetAttribute("vat_amt_unit", String.Format("{0:#,0.00}", Decimal.Parse(di["vat_amount"].ToString()) / Decimal.Parse(di["po_quantity"].ToString())) ?? "0.00");
                    row.SetAttribute("vat_amount", String.Format("{0:#,0.00}", Decimal.Parse(di["vat_amount"].ToString())) ?? "0.00");
                    
                    if (di["exchange_sign"].ToString() == "*")
                    {
                        discount_usd += Decimal.Parse(di["po_discount"].ToString()) * Decimal.Parse(di["exchange_rate"].ToString());
                        additional_discount_usd += Decimal.Parse(di["po_additional_discount"].ToString()) * Decimal.Parse(di["exchange_rate"].ToString());
                    }
                    else
                    {
                        discount_usd += Decimal.Parse(di["po_discount"].ToString()) / Decimal.Parse(di["exchange_rate"].ToString());
                        additional_discount_usd += Decimal.Parse(di["po_additional_discount"].ToString()) / Decimal.Parse(di["exchange_rate"].ToString());
                    }
                    
                    #region detail cost center
                    Antlr3.ST.StringTemplate rowDcc = group.GetInstanceOf("PODetailCostCenter");
                    string rowDetailCostCenter_data = string.Empty, rowDetailCostCenter = string.Empty, ccClass = string.Empty;
                    int j = 0;
                    foreach (DataRow dcc in cc.Rows)
                    {
                        if (di["id"].ToString() == dcc["purchase_order_detail_id"].ToString())
                        {
                            if (j % 2 != 0)
                            {
                                ccClass = "basefont";
                            }
                            else
                            {
                                ccClass = "zebra";
                            }

                            Antlr3.ST.StringTemplate rowDcc_data = group.GetInstanceOf("PODetailCostCenter_Data");

                            var cost_center = String.Format("{0} - {1}", dcc["cost_center_id"].ToString(), dcc["cost_center_name"].ToString());
                            rowDcc_data.SetAttribute("class", ccClass);
                            rowDcc_data.SetAttribute("cost_center", String.Format("{0} - {1}", dcc["cost_center_id"].ToString(), dcc["cost_center_name"].ToString()));
                            rowDcc_data.SetAttribute("work_order", String.Format("{0} - {1}", dcc["work_order"].ToString(), dcc["work_order_description"].ToString()));
                            rowDcc_data.SetAttribute("entity", dcc["entity_description"].ToString());
                            rowDcc_data.SetAttribute("legal_entity", dcc["legal_entity"].ToString());
                            rowDcc_data.SetAttribute("percentage", dcc["percentage"]);

                            if (Boolean.Parse(di["vat_payable"].ToString()))
                            {
                                rowDcc_data.SetAttribute("amount", String.Format("{0:#,0.00}", Decimal.Parse(dcc["amount"].ToString()) + Decimal.Parse(dcc["amount_vat"].ToString())) ?? "0");
                                rowDcc_data.SetAttribute("amount_usd", String.Format("{0:#,0.00}", Decimal.Parse(dcc["amount_usd"].ToString()) + Decimal.Parse(dcc["amount_usd_vat"].ToString())) ?? "0");
                            }
                            else
                            {
                                rowDcc_data.SetAttribute("amount", String.Format("{0:#,0.00}", Decimal.Parse(dcc["amount"].ToString())) ?? "0");
                                rowDcc_data.SetAttribute("amount_usd", String.Format("{0:#,0.00}", Decimal.Parse(dcc["amount_usd"].ToString())) ?? "0");
                            }
                            
                            rowDcc_data.SetAttribute("remarks", dcc["remarks"].ToString());

                            rowDetailCostCenter_data += rowDcc_data.ToString();
                            j++;
                        }
                    }

                    rowDcc.SetAttribute("currency_id", di["currency_id"].ToString());
                    rowDcc.SetAttribute("detail_cost_center_data", rowDetailCostCenter_data);
                    rowDetailCostCenter += rowDcc.ToString();
                    row.SetAttribute("detail_cost_center", rowDetailCostCenter);
                    #endregion

                    rowDetail += row.ToString();
                    i++;
                }

                str_vat_amount = String.Format("{0:#,0.00}", vat_amount);
                str_vat_amount_usd = String.Format("{0:#,0.00}", vat_amount_usd);

                str_discount = String.Format("{0:#,0.00}", discount);
                str_discount_usd = String.Format("{0:#,0.00}", discount_usd);
                str_additional_discount = String.Format("{0:#,0.00}", additional_discount);
                str_additional_discount_usd = String.Format("{0:#,0.00}", additional_discount_usd);

                str_total_amount = String.Format("{0:#,0.00}", total_amount);
                str_total_amount_usd = String.Format("{0:#,0.00}", total_amount_usd);

                template.SetAttribute("discount", currency_id + " " + String.Format("{0:#,0.00}", String.Format("{0:#,0.00}", discount)) ?? "0.00");
                template.SetAttribute("additional_discount", currency_id + " " + String.Format("{0:#,0.00}", String.Format("{0:#,0.00}", additional_discount)) ?? "0.00");
                template.SetAttribute("gross_amount", main.Rows[0]["currency_id"].ToString() + " " + String.Format("{0:#,0.00}", Decimal.Parse(main.Rows[0]["gross_amount"].ToString())) ?? "0.00");
                template.SetAttribute("total_amount", currency_id + " " + str_total_amount + " / USD " + str_total_amount_usd);
                if (currency_id.ToLower() == "usd")
                {
                    template.SetAttribute("vat", currency_id + " " + str_vat_amount);
                }
                else
                {
                    template.SetAttribute("vat", currency_id + " " + str_vat_amount + " / USD " + str_vat_amount_usd);
                }

                foreach (DataRow dsg in signed.Rows)
                {
                    template.SetAttribute("approver_name", dsg["EMP_NAME"].ToString());
                    template.SetAttribute("approver_title", dsg["JOB_TITLE"].ToString());
                    template.SetAttribute("approver_date", dsg["APPROVED_DATE"].ToString());
                }
                template.SetAttribute("details", rowDetail);

                templateString += template.ToString();
                template.Reset();
            }


            return templateString;
        }

        public class VendorHeader {
            public string id;
            public string name;
            public string currency;
            public string unit_price;
            public string quantity;
            public string total;
            public string exchange_rate;
            public string indent_time;
            public string warranty_time;
            public string delivery_time;
            public string selected;
            public string reason_for_selection;
            public string remarks;
            public string justification_file;
        }

        public class VSItem
        {
            public string id;
            public string item_code;
            public string item_description;
            public string pr_no;
            public string cost_center;
            public string currency;
            public string unit_price;
            public string quantity;
            public string uom;
        }

        public static string GetVSTemplate(string po_id)
        {
            string templateString = string.Empty;
            group.RootDir = StartupPath;
            Antlr3.ST.StringTemplate template = group.GetInstanceOf("VSDetail");

            DataSet VS = staticsPurchaseOrder.CompiledPO.VSData(po_id);
            foreach (DataRow drVS in VS.Tables[0].Rows)
            {
                template.SetAttribute("vs_no", drVS["vs_no"].ToString());
                template.SetAttribute("document_date", drVS["document_date"].ToString());
                
                string rowClass = string.Empty;
                string rowDetail = string.Empty;
                string rowDetails = string.Empty;
                int i = 1;

                DataTable VSD = VS.Tables[1].Select("vs_id='" + drVS["id"].ToString() + "'", "pr_detail_id asc, line_no asc").CopyToDataTable();
                List<VendorHeader> vendorHeaders = new List<VendorHeader>();
                List<VSItem> vsItems = new List<VSItem>();

                string pr_detail_id = string.Empty;
                foreach (DataRow drVSD in VSD.Rows)
                {
                    VendorHeader vH = new VendorHeader();
                    vH.id = drVSD["vendor"].ToString();
                    vH.name = drVSD["vendor_name"].ToString();
                    vH.currency = drVSD["currency_id"].ToString();
                    vH.unit_price = String.Format("{0:#,0.00}", Decimal.Parse(drVSD["unit_price"].ToString())) ?? "0.00";
                    vH.quantity = String.Format("{0:#,0.00}", Decimal.Parse(drVSD["quantity"].ToString())) ?? "0.00";
                    vH.total = String.Format("{0:#,0.00}", Decimal.Parse(drVSD["cost"].ToString())) ?? "0.00";

                    vH.exchange_rate = String.Format("{0:#,0.00000000}", Decimal.Parse(drVSD["exchange_rate"].ToString())) ?? "0.00";
                    vH.indent_time = drVSD["indent_time"].ToString();
                    vH.warranty_time = drVSD["warranty_time"].ToString();
                    vH.delivery_time = drVSD["expected_delivery_date"].ToString();
                    vH.selected = drVSD["is_selected"].ToString();
                    if (vH.selected == "1")
                    {
                        vH.selected = "Yes";
                    }
                    else {
                        vH.selected = "No";
                    }
                    vH.reason_for_selection = drVSD["reason_for_selection"].ToString();
                    vH.remarks = drVSD["remarks"].ToString();
                    vH.justification_file = drVSD["justification_file"].ToString();

                    vendorHeaders.Add(vH);

                    VSItem vsi = new VSItem();
                    vsi.id = drVSD["pr_detail_id"].ToString();
                    vsi.item_code = drVSD["item_code"].ToString();
                    vsi.item_description = drVSD["item_description"].ToString();
                    vsi.pr_no = drVSD["pr_no"].ToString();
                    vsi.cost_center = drVSD["cost_center"].ToString();
                    vsi.currency = drVSD["currency_id"].ToString();
                    vsi.unit_price = String.Format("{0:#,0.00}", Decimal.Parse(drVSD["pr_unit_price"].ToString())) ?? "0.00";
                    vsi.quantity = String.Format("{0:#,0.00}", Decimal.Parse(drVSD["request_qty"].ToString())) ?? "0.00";
                    vsi.uom = drVSD["uom_name"].ToString();

                    vsItems.Add(vsi);

                    if (pr_detail_id != drVSD["pr_detail_id"].ToString())
                    {
                        if (i % 2 != 0)
                        {
                            rowClass = "basefont";
                        }
                        else
                        {
                            rowClass = "zebra";
                        }

                        rowDetails += rowDetail;
                        if (!string.IsNullOrEmpty(pr_detail_id)) {
                            rowDetails += "</tr>";
                        }
                        rowDetail = "<tr><td align='left' valign='top' class='"+ rowClass + "'>" + vsi.item_code + "</td>";
                        rowDetail += "<td align='left' valign='top' class='" + rowClass + "'>" + vsi.item_description + "</td>";
                        rowDetail += "<td align='left' valign='top' class='" + rowClass + "'>" + vsi.pr_no + "</td>";
                        //rowDetail += "<td align='left' valign='top' class='" + rowClass + "'>" + vsi.cost_center + "</td>";
                        rowDetail += "<td align='right' valign='top' class='" + rowClass + "'>" + vsi.currency + " " + vsi.unit_price + "</td>";
                        rowDetail += "<td align='right' valign='top' class='" + rowClass + "'>" + vsi.quantity + " " + vsi.uom + "</td>";
                        i++;
                    }
                    
                    rowDetail += "<td align='left' valign='top' class='" + rowClass + "'>" + vH.currency + "</td>";
                    rowDetail += "<td align='right' valign='top' class='" + rowClass + "'>" + vH.unit_price + "</td>";
                    rowDetail += "<td align='right' valign='top' class='" + rowClass + "'>" + vH.quantity + "</td>";
                    rowDetail += "<td align='right' valign='top' class='" + rowClass + "'>" + vH.total + "</td>";

                    pr_detail_id = drVSD["pr_detail_id"].ToString();
                }
                rowDetails += rowDetail + "</tr>";

                int vendors = vendorHeaders.Select(x => x.id).Distinct().Count();
                string vendor_header = string.Empty;
                for (int x = 0; x < vendors; x++) {
                    vendor_header += "<th colspan='4' style='text-align:center;'>" + vendorHeaders[x].name + "</th>";
                }

                string vendor_header_detail = string.Empty;
                for (int x = 0; x < vendors; x++)
                {
                    vendor_header_detail += "<th>Curr.</th>";
                    vendor_header_detail += "<th style='text-align:right;'>Unit price</th>";
                    vendor_header_detail += "<th style='text-align:right;'>Qty.</th>";
                    vendor_header_detail += "<th style='text-align:right;'>Total</th>";
                }

                template.SetAttribute("vendor_header", vendor_header);
                template.SetAttribute("vendor_header_detail", vendor_header_detail);
                template.SetAttribute("detail", rowDetails);

                string discount = string.Empty;
                for (int x = 0; x < vendors; x++)
                {
                    decimal discount_temp = 0;
                    foreach (DataRow dm in VSD.Rows)
                    {
                        if (dm["vendor"].ToString() == vendorHeaders[x].id)
                        {
                            discount_temp += Convert.ToDecimal(dm["discount"].ToString());
                        }
                    }
                    //string dsc = String.Format("{0:#,0.00}", Convert.ToDecimal(VSD.Compute("SUM(discount)", "vendor=" + vendorHeaders[x].id))) ?? "0.00";
                    string dsc = String.Format("{0:#,0.00}", discount_temp) ?? "0.00";

                    discount += "<td colspan='4' style='text-align:right;'>"+ dsc + "</td>";
                }
                template.SetAttribute("discount", discount);

                string additional_discount = string.Empty;
                for (int x = 0; x < vendors; x++)
                {
                    decimal additional_discount_temp = 0;
                    foreach (DataRow dm in VSD.Rows)
                    {
                        if (dm["vendor"].ToString() == vendorHeaders[x].id)
                        {
                            additional_discount_temp += Convert.ToDecimal(dm["additional_discount"].ToString());
                        }
                    }

                    //string adddsc = String.Format("{0:#,0.00}", Convert.ToDecimal(VSD.Compute("SUM(additional_discount)", "vendor=" + vendorHeaders[x].id))) ?? "0.00";
                    string adddsc = String.Format("{0:#,0.00}", Convert.ToDecimal(additional_discount_temp)) ?? "0.00";

                    additional_discount += "<td colspan='4' style='text-align:right;'>" + adddsc + "</td>";
                }
                template.SetAttribute("additional_discount", additional_discount);

                string total = string.Empty;
                for (int x = 0; x < vendors; x++)
                {
                    decimal ttl_temp = 0;
                    foreach (DataRow dm in VSD.Rows)
                    {
                        if (dm["vendor"].ToString() == vendorHeaders[x].id)
                        {
                            ttl_temp += Convert.ToDecimal(dm["line_total"].ToString());
                        }
                    }

                    //string ttl = String.Format("{0:#,0.00}", Convert.ToDecimal(VSD.Compute("SUM(line_total)", "vendor=" + vendorHeaders[x].id))) ?? "0.00";
                    string ttl = String.Format("{0:#,0.00}", Convert.ToDecimal(ttl_temp)) ?? "0.00";

                    total += "<td colspan='4' style='text-align:right;'>" + ttl + "</td>";
                }
                template.SetAttribute("total", total);

                string exchange_rate = string.Empty;
                for (int x = 0; x < vendors; x++)
                {
                    exchange_rate += "<td colspan='4' style='text-align:right;'>" + vendorHeaders[x].exchange_rate + "</td>";
                }
                template.SetAttribute("exchange_rate", exchange_rate);

                string total_usd = string.Empty;
                for (int x = 0; x < vendors; x++)
                {
                    decimal ttlusd_temp = 0;
                    foreach (DataRow dm in VSD.Rows)
                    {
                        if (dm["vendor"].ToString() == vendorHeaders[x].id)
                        {
                            ttlusd_temp += Convert.ToDecimal(dm["line_total_usd"].ToString());
                        }
                    }

                    //string ttlusd = String.Format("{0:#,0.00}", Convert.ToDecimal(VSD.Compute("SUM(line_total_usd)", "vendor=" + vendorHeaders[x].id))) ?? "0.00";
                    string ttlusd = String.Format("{0:#,0.00}", Convert.ToDecimal(ttlusd_temp)) ?? "0.00";

                    total_usd += "<td colspan='4' style='text-align:right;'>" + ttlusd + "</td>";
                }
                template.SetAttribute("total_usd", total_usd);

                string indent_time = string.Empty;
                for (int x = 0; x < vendors; x++)
                {
                    indent_time += "<td colspan='4' style='text-align:left;' valign='top'>" + vendorHeaders[x].indent_time + "</td>";
                }
                template.SetAttribute("indent_time", indent_time);

                string warranty_time = string.Empty;
                for (int x = 0; x < vendors; x++)
                {
                    warranty_time += "<td colspan='4' style='text-align:left;' valign='top'>" + vendorHeaders[x].warranty_time + "</td>";
                }
                template.SetAttribute("warranty_time", warranty_time);

                string delivery_time = string.Empty;
                for (int x = 0; x < vendors; x++)
                {
                    delivery_time += "<td colspan='4' style='text-align:left;' valign='top'>" + vendorHeaders[x].delivery_time + "</td>";
                }
                template.SetAttribute("delivery_time", delivery_time);

                string selected = string.Empty;
                for (int x = 0; x < vendors; x++)
                {
                    selected += "<td colspan='4' style='text-align:left;' valign='top'>" + vendorHeaders[x].selected + "</td>";
                }
                template.SetAttribute("selected", selected);

                string reason_for_selection = string.Empty;
                for (int x = 0; x < vendors; x++)
                {
                    reason_for_selection += "<td colspan='4' style='text-align:left;' valign='top'>" + vendorHeaders[x].reason_for_selection + "</td>";
                }
                template.SetAttribute("reason_for_selection", reason_for_selection);

                string remarks = string.Empty;
                for (int x = 0; x < vendors; x++)
                {
                    remarks += "<td colspan='4' style='text-align:left;' valign='top'>" + vendorHeaders[x].remarks + "</td>";
                }
                template.SetAttribute("remarks", remarks);

                string justification_file = string.Empty;
                for (int x = 0; x < vendors; x++)
                {
                    justification_file += "<td colspan='4' style='text-align:left;' valign='top'>" + vendorHeaders[x].justification_file + "</td>";
                }
                template.SetAttribute("justification_file", justification_file);

                templateString += template.ToString();
                template.Reset();
            }
            return templateString;
        }
    }
}