using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;

namespace myTree.WebForms.Procurement.General
{
    public class staticsQuotation
    {
        public static string isRFQValid(string rfq_id)
        {
            string valid = "1";
            database db = new database();
            db.ClearParameters();

            db.SPName = "dbo.spQuotation_ValidateRFQ";
            db.AddParameter("@rfq_id", SqlDbType.NVarChar, rfq_id);

            DataSet ds = db.ExecuteSP();
            db.Dispose();

            if (ds.Tables.Count > 0)
            {
                if (ds.Tables[0].Rows.Count > 0)
                {
                    valid = ds.Tables[0].Rows[0]["max_status"].ToString() == "95" ? "0" : "1";
                }
            }

            return valid;
        }

        public class Main
        {
            public class QuotationOutput
            {
                public string id { get; set; }
                public string q_no { get; set; }
            }

            public static DataSet GetData(string id)
            {
                database db = new database();
                db.ClearParameters();

                db.SPName = "dbo.spQuotation_GetData";
                db.AddParameter("@id", SqlDbType.NVarChar, id);

                DataSet ds = db.ExecuteSP();
                db.Dispose();

                return ds;
            }

            public static DataSet GetList(string startDate, string endDate, string status, string cifor_office)
            {
                database db = new database();
                db.ClearParameters();

                db.SPName = "dbo.spQuotation_GetList";
                db.AddParameter("@startDate", SqlDbType.NVarChar, startDate);
                db.AddParameter("@endDate", SqlDbType.NVarChar, endDate);
                db.AddParameter("@status", SqlDbType.NVarChar, status);
                db.AddParameter("@cifor_office", SqlDbType.NVarChar, cifor_office);
                db.AddParameter("@based_url", SqlDbType.NVarChar, statics.GetSetting("path_url"));
                db.AddParameter("@user_id", SqlDbType.NVarChar, statics.GetLogonUsername());

                DataSet ds = db.ExecuteSP();
                db.Dispose();

                return ds;
            }

            public static QuotationOutput Save(DataModel.Quotation q)
            {
                database db = new database();
                db.ClearParameters();

                db.SPName = "dbo.spQuotation_Save";
                db.AddParameter("@id", SqlDbType.NVarChar, q.id);
                db.AddParameter("@q_no", SqlDbType.NVarChar, q.q_no);
                db.AddParameter("@cifor_office_id", SqlDbType.NVarChar, q.cifor_office_id);
                db.AddParameter("@vendor", SqlDbType.NVarChar, q.vendor);
                db.AddParameter("@vendor_name", SqlDbType.NVarChar, q.vendor_name);
                db.AddParameter("@vendor_code", SqlDbType.NVarChar, q.vendor_code);
                db.AddParameter("@vendor_document_no", SqlDbType.NVarChar, q.vendor_document_no);
                db.AddParameter("@vendor_address_id", SqlDbType.NVarChar, q.vendor_address_id);
                db.AddParameter("@receive_date", SqlDbType.NVarChar, q.receive_date);
                db.AddParameter("@document_date", SqlDbType.NVarChar, q.document_date);
                db.AddParameter("@due_date", SqlDbType.NVarChar, q.due_date);
                db.AddParameter("@payment_terms", SqlDbType.NVarChar, q.payment_terms);
                db.AddParameter("@other_payment_terms", SqlDbType.NVarChar, q.other_payment_terms);
                db.AddParameter("@is_other_payment_terms", SqlDbType.NVarChar, q.is_other_payment_terms);
                db.AddParameter("@remarks", SqlDbType.NVarChar, q.remarks);
                db.AddParameter("@currency_id", SqlDbType.NVarChar, q.currency_id);
                db.AddParameter("@exchange_sign", SqlDbType.NVarChar, q.exchange_sign);
                db.AddParameter("@exchange_rate", SqlDbType.NVarChar, q.exchange_rate);
                db.AddParameter("@discount_type", SqlDbType.NVarChar, q.discount_type);
                db.AddParameter("@discount", SqlDbType.NVarChar, q.discount);
                db.AddParameter("@discount_currency", SqlDbType.NVarChar, q.discount_currency);
                db.AddParameter("@total_discount", SqlDbType.NVarChar, q.total_discount);
                db.AddParameter("@quotation_amount", SqlDbType.NVarChar, q.quotation_amount);
                db.AddParameter("@quotation_amount_usd", SqlDbType.NVarChar, q.quotation_amount_usd);
                db.AddParameter("@rfq_id", SqlDbType.NVarChar, q.rfq_id);
                db.AddParameter("@rfq_no", SqlDbType.NVarChar, q.rfq_no);
                db.AddParameter("@reff_rfq_no", SqlDbType.NVarChar, q.reff_rfq_no);
                db.AddParameter("@copy_from_id", SqlDbType.NVarChar, q.copy_from_id);
                db.AddParameter("@status_id", SqlDbType.NVarChar, q.status_id);
                db.AddParameter("@user_id", SqlDbType.NVarChar, statics.GetLogonUsername());
                db.AddParameter("@temporary_id", SqlDbType.NVarChar, q.temporary_id);

                DataSet ds = db.ExecuteSP();
                db.Dispose();

                QuotationOutput output = new QuotationOutput();

                if (ds.Tables[0].Rows.Count > 0)
                {
                    output.id = ds.Tables[0].Rows[0]["id"].ToString();
                    output.q_no = ds.Tables[0].Rows[0]["q_no"].ToString();
                }

                return output;
            }

            public static Boolean Delete(string id)
            {
                database db = new database();
                db.ClearParameters();

                db.SPName = "dbo.spQuotation_Delete";
                db.AddParameter("@id", SqlDbType.NVarChar, id);

                DataSet ds = db.ExecuteSP();
                db.Dispose();

                return true;
            }

            public static Boolean StatusUpdate(string id, string status_id)
            {
                database db = new database();
                db.ClearParameters();

                db.SPName = "dbo.spQuotation_StatusUpdate";
                db.AddParameter("@id", SqlDbType.NVarChar, id);
                db.AddParameter("@status", SqlDbType.NVarChar, status_id);
                db.AddParameter("@user_id", SqlDbType.NVarChar, statics.GetLogonUsername());

                DataSet ds = db.ExecuteSP();
                db.Dispose();

                return true;
            }
        }

        public class Detail
        {
            public static string Save(DataModel.QuotationDetail qd)
            {
                database db = new database();
                db.ClearParameters();

                db.SPName = "dbo.spQuotationDetail_Save";
                db.AddParameter("@id", SqlDbType.NVarChar, qd.id);
                db.AddParameter("@quotation", SqlDbType.NVarChar, qd.quotation);
                db.AddParameter("@line_number", SqlDbType.NVarChar, qd.line_number);
                db.AddParameter("@item_id", SqlDbType.NVarChar, qd.item_id);
                db.AddParameter("@item_code", SqlDbType.NVarChar, qd.item_code);
                db.AddParameter("@brand_name", SqlDbType.NVarChar, qd.brand_name);
                db.AddParameter("@description", SqlDbType.NVarChar, qd.description);
                db.AddParameter("@uom", SqlDbType.NVarChar, qd.uom_id);
                db.AddParameter("@quantity", SqlDbType.NVarChar, qd.quantity);
                db.AddParameter("@quotation_quantity", SqlDbType.NVarChar, qd.quotation_quantity);
                db.AddParameter("@quotation_description", SqlDbType.NVarChar, qd.quotation_description);
                db.AddParameter("@unit_price", SqlDbType.NVarChar, qd.unit_price);
                db.AddParameter("@discount_type", SqlDbType.NVarChar, qd.discount_type);
                db.AddParameter("@discount", SqlDbType.NVarChar, qd.discount);
                db.AddParameter("@discount_amount", SqlDbType.NVarChar, qd.discount_amount);
                db.AddParameter("@additional_discount", SqlDbType.NVarChar, qd.additional_discount);
                db.AddParameter("@line_total", SqlDbType.NVarChar, qd.line_total);
                db.AddParameter("@line_total_usd", SqlDbType.NVarChar, qd.line_total_usd);
                db.AddParameter("@indent_time", SqlDbType.NVarChar, qd.indent_time);
                db.AddParameter("@warranty", SqlDbType.NVarChar, qd.warranty);
                db.AddParameter("@remarks", SqlDbType.NVarChar, qd.remarks);
                db.AddParameter("@rfq_detail_id", SqlDbType.NVarChar, qd.rfq_detail_id);
                db.AddParameter("@rfq_id", SqlDbType.NVarChar, qd.rfq_id);
                db.AddParameter("@rfq_no", SqlDbType.NVarChar, qd.rfq_no);
                db.AddParameter("@pr_detail_id", SqlDbType.NVarChar, qd.pr_detail_id);
                db.AddParameter("@pr_id", SqlDbType.NVarChar, qd.pr_id);
                db.AddParameter("@pr_no", SqlDbType.NVarChar, qd.pr_no);
                db.AddParameter("@source_quantity", SqlDbType.NVarChar, qd.source_quantity);
                db.AddParameter("@currency_id", SqlDbType.NVarChar, qd.currency_id);
                db.AddParameter("@exchange_sign", SqlDbType.NVarChar, qd.exchange_sign);
                db.AddParameter("@exchange_rate", SqlDbType.NVarChar, qd.exchange_rate);
                db.AddParameter("@total_discount", SqlDbType.NVarChar, qd.total_discount);
                db.AddParameter("@total_discount_usd", SqlDbType.NVarChar, qd.total_discount_usd);

                DataSet ds = db.ExecuteSP();
                db.Dispose();

                return ds.Tables[0].Rows[0]["id"].ToString();
            }

            public static Boolean Delete(string id)
            {
                database db = new database();
                db.ClearParameters();

                db.SPName = "dbo.spQuotationDetail_Delete";
                db.AddParameter("@id", SqlDbType.NVarChar, id);
                db.AddParameter("@user_id", SqlDbType.NVarChar, statics.GetLogonUsername());

                DataSet ds = db.ExecuteSP();
                db.Dispose();

                return true;
            }

            public static Boolean Close(DataModel.QuotationDetail qd)
            {
                database db = new database();
                db.ClearParameters();

                db.SPName = "dbo.spQuotationDetail_Close";
                db.AddParameter("@id", SqlDbType.NVarChar, qd.id);
                db.AddParameter("@close_quantity", SqlDbType.NVarChar, qd.close_quantity);
                db.AddParameter("@close_remarks", SqlDbType.NVarChar, qd.close_remarks);
                db.AddParameter("@user_id", SqlDbType.NVarChar, statics.GetLogonUsername());

                DataSet ds = db.ExecuteSP();
                db.Dispose();

                return true;
            }

            public static DataSet GetCostCenter(string quotation_id, string item_code)
            {
                database db = new database();
                db.ClearParameters();

                db.SPName = "dbo.spQuotation_GetCostCenter";
                db.AddParameter("@quotation_id", SqlDbType.NVarChar, quotation_id);
                db.AddParameter("@item_code", SqlDbType.NVarChar, item_code);

                DataSet ds = db.ExecuteSP();
                db.Dispose();

                return ds;
            }

            public static Boolean SaveCostCenter(DataModel.QuotationDetailCostCenter costCenter)
            {
                database db = new database();
                db.ClearParameters();

                db.SPName = "dbo.spQuotation_CostCenter_Save";
                db.AddParameter("@id", SqlDbType.NVarChar, costCenter.id);
                db.AddParameter("@quotation_id", SqlDbType.NVarChar, costCenter.quotation);
                db.AddParameter("@quotation_detail_id", SqlDbType.NVarChar, costCenter.quotation_detail_id);
                db.AddParameter("@pr_detail_cost_center_id", SqlDbType.NVarChar, costCenter.pr_detail_cost_center_id);
                db.AddParameter("@rfq_detail_cost_center_id", SqlDbType.NVarChar, costCenter.rfq_detail_cost_center_id);
                db.AddParameter("@seq_no", SqlDbType.NVarChar, costCenter.sequence_no);
                db.AddParameter("@cost_center_id", SqlDbType.NVarChar, costCenter.cost_center_id);
                db.AddParameter("@work_order", SqlDbType.NVarChar, costCenter.work_order);
                db.AddParameter("@entity_id", SqlDbType.NVarChar, costCenter.entity_id);
                db.AddParameter("@legal_entity", SqlDbType.NVarChar, costCenter.legal_entity);
                db.AddParameter("@control_account", SqlDbType.NVarChar, costCenter.control_account);
                db.AddParameter("@percentage", SqlDbType.NVarChar, costCenter.percentage);
                db.AddParameter("@amount", SqlDbType.NVarChar, costCenter.amount);
                db.AddParameter("@amount_usd", SqlDbType.NVarChar, costCenter.amount_usd);
                db.AddParameter("@remarks", SqlDbType.NVarChar, costCenter.remarks);
                //db.AddParameter("@is_active", SqlDbType.NVarChar, (costCenter.is_active == "1") ? "1" : "0");

                DataSet ds = db.ExecuteSP();
                db.Dispose();

                return true;
            }
        }
    }
}
