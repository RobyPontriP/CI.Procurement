using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;

namespace myTree.WebForms.Procurement.General
{
    public class staticsRFQ
    {
        public static DataSet GetPRList(string startDate, string endDate, string cifor_office)
        {
            database db = new database();
            db.ClearParameters();

            db.SPName = "dbo.spRFQ_GetListPR";
            db.AddParameter("@startDate", SqlDbType.NVarChar, startDate);
            db.AddParameter("@endDate", SqlDbType.NVarChar, endDate);
            db.AddParameter("@cifor_office", SqlDbType.NVarChar, cifor_office);
            db.AddParameter("@web_url", SqlDbType.NVarChar, statics.GetSetting("path_url"));

            DataSet ds = db.ExecuteSP();
            db.Dispose();

            return ds;
        }

        public static DataSet GetItem(string subcategory, string cifor_office_id, string pr_detail_id)
        {
            database db = new database();
            db.ClearParameters();

            db.SPName = "dbo.spRFQ_GetItem";
            db.AddParameter("@subcategory", SqlDbType.NVarChar, subcategory);
            db.AddParameter("@cifor_office_id", SqlDbType.NVarChar, cifor_office_id);
            db.AddParameter("@pr_line_id", SqlDbType.NVarChar, pr_detail_id);

            DataSet ds = db.ExecuteSP();
            db.Dispose();

            return ds;
        }

        public static DataTable GetVendorContacts(string vendors)
        {
            database db = new database();
            db.ClearParameters();

            db.SPName = "dbo.spRFQ_GetVendorContactPerson";
            db.AddParameter("@vendors", SqlDbType.NVarChar, vendors);

            DataSet ds = db.ExecuteSP();
            db.Dispose();

            return ds.Tables[0];
        }

        public class Main
        {
            public class RFQOutput
            {
                public string id { get; set; }
                public string rfq_no { get; set; }
                public string session_no { get; set; }
            }

            public static DataSet GetData(string id)
            {
                database db = new database();
                db.ClearParameters();

                db.SPName = "dbo.spRFQ_GetData";
                db.AddParameter("@id", SqlDbType.NVarChar, id);

                DataSet ds = db.ExecuteSP();
                db.Dispose();

                return ds;
            }

            public static DataSet GetList(string startDate, string endDate, string status, string cifor_office)
            {
                database db = new database();
                db.ClearParameters();

                db.SPName = "dbo.spRFQ_GetList";
                db.AddParameter("@startDate", SqlDbType.NVarChar, startDate);
                db.AddParameter("@endDate", SqlDbType.NVarChar, endDate);
                db.AddParameter("@status", SqlDbType.NVarChar, status);
                db.AddParameter("@cifor_office", SqlDbType.NVarChar, cifor_office);
                db.AddParameter("@user_id", SqlDbType.NVarChar, statics.GetLogonUsername());

                DataSet ds = db.ExecuteSP();
                db.Dispose();

                return ds;
            }

            public static RFQOutput Save(DataModel.RequestForQuotation rfq)
            {
                database db = new database();
                db.ClearParameters();

                db.SPName = "dbo.spRFQ_Save";
                db.AddParameter("@id", SqlDbType.NVarChar, rfq.id);
                db.AddParameter("@rfq_no", SqlDbType.NVarChar, rfq.rfq_no);
                db.AddParameter("@session_no", SqlDbType.NVarChar, rfq.session_no);
                db.AddParameter("@document_date", SqlDbType.NVarChar, rfq.document_date);
                db.AddParameter("@due_date", SqlDbType.NVarChar, rfq.due_date);
                db.AddParameter("@send_date", SqlDbType.NVarChar, rfq.send_date);
                db.AddParameter("@remarks", SqlDbType.NVarChar, rfq.remarks);
                db.AddParameter("@vendor", SqlDbType.NVarChar, rfq.vendor);
                db.AddParameter("@vendor_name", SqlDbType.NVarChar, rfq.vendor_name);
                db.AddParameter("@vendor_contact_person", SqlDbType.NVarChar, rfq.vendor_contact_person);
                db.AddParameter("@method", SqlDbType.NVarChar, rfq.method);
                db.AddParameter("@template", SqlDbType.NVarChar, rfq.template);
                db.AddParameter("@copy_from_id", SqlDbType.NVarChar, rfq.copy_from_id);
                db.AddParameter("@cifor_office_id", SqlDbType.NVarChar, rfq.cifor_office_id);
                db.AddParameter("@legal_entity", SqlDbType.NVarChar, rfq.legal_entity);
                db.AddParameter("@procurement_office_address", SqlDbType.NVarChar, rfq.procurement_office_address);
                db.AddParameter("@user_id", SqlDbType.NVarChar, statics.GetLogonUsername());

                db.AddParameter("@series", SqlDbType.NVarChar, rfq.series);

                DataSet ds = db.ExecuteSP();
                db.Dispose();

                RFQOutput output = new RFQOutput();

                if (ds.Tables[0].Rows.Count > 0)
                {
                    output.id = ds.Tables[0].Rows[0]["id"].ToString();
                    output.rfq_no = ds.Tables[0].Rows[0]["rfq_no"].ToString();
                    output.session_no = ds.Tables[0].Rows[0]["session_no"].ToString();
                }

                return output;
            }

            public static Boolean Delete(string id)
            {
                database db = new database();
                db.ClearParameters();

                db.SPName = "dbo.spRFQ_Delete";
                db.AddParameter("@id", SqlDbType.NVarChar, id);

                DataSet ds = db.ExecuteSP();
                db.Dispose();

                return true;
            }

            public static Boolean StatusUpdate(string id, string status_id)
            {
                database db = new database();
                db.ClearParameters();

                db.SPName = "dbo.spRFQ_StatusUpdate";
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
            public static string Save(DataModel.RequestForQuotationDetail rfqd)
            {
                database db = new database();
                db.ClearParameters();

                db.SPName = "dbo.spRFQDetail_Save";
                db.AddParameter("@id", SqlDbType.NVarChar, rfqd.id);
                db.AddParameter("@rfq_id", SqlDbType.NVarChar, rfqd.rfq_id);
                db.AddParameter("@line_number", SqlDbType.NVarChar, rfqd.line_number);
                db.AddParameter("@item_id", SqlDbType.NVarChar, rfqd.item_id);
                db.AddParameter("@item_code", SqlDbType.NVarChar, rfqd.item_code);
                db.AddParameter("@brand_name", SqlDbType.NVarChar, rfqd.brand_name);
                db.AddParameter("@description", SqlDbType.NVarChar, rfqd.description);
                db.AddParameter("@request_quantity", SqlDbType.NVarChar, rfqd.request_quantity);
                db.AddParameter("@uom", SqlDbType.NVarChar, rfqd.uom);
                db.AddParameter("@pr_detail_id", SqlDbType.NVarChar, rfqd.pr_detail_id);
                db.AddParameter("@pr_id", SqlDbType.NVarChar, rfqd.pr_id);
                db.AddParameter("@pr_no", SqlDbType.NVarChar, rfqd.pr_no);

                DataSet ds = db.ExecuteSP();
                db.Dispose();

                return ds.Tables[0].Rows[0]["id"].ToString();
            }

            public static Boolean Delete(string id)
            {
                database db = new database();
                db.ClearParameters();

                db.SPName = "dbo.spRFQDetail_Delete";
                db.AddParameter("@id", SqlDbType.NVarChar, id);
                db.AddParameter("@user_id", SqlDbType.NVarChar, statics.GetLogonUsername());

                DataSet ds = db.ExecuteSP();
                db.Dispose();

                return true;
            }

            public static Boolean SaveCostCenter(DataModel.RequestForQuotationDetailCostCenter costCenter)
            {
                database db = new database();
                db.ClearParameters();

                db.SPName = "dbo.spRFQ_CostCenter_Save";
                db.AddParameter("@id", SqlDbType.NVarChar, costCenter.id);
                db.AddParameter("@rfq_id", SqlDbType.NVarChar, costCenter.rfq_id);
                db.AddParameter("@rfq_detail_id", SqlDbType.NVarChar, costCenter.rfq_detail_id);
                db.AddParameter("@pr_detail_cost_center_id", SqlDbType.NVarChar, costCenter.pr_detail_cost_center_id);
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

            public static DataSet GetCostCenter(string rfq_id, string item_code)
            {
                database db = new database();
                db.ClearParameters();

                db.SPName = "dbo.spRequestForQuotation_GetCostCenter";
                db.AddParameter("@rfq_id", SqlDbType.NVarChar, rfq_id);
                db.AddParameter("@item_code", SqlDbType.NVarChar, item_code);

                DataSet ds = db.ExecuteSP();
                db.Dispose();

                return ds;
            }
        }
    }
}
