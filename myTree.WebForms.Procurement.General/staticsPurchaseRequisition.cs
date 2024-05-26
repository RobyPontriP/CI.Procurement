using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using static myTree.WebForms.Procurement.General.DataModel;
using System.Globalization;

namespace myTree.WebForms.Procurement.General
{
    public class staticsPurchaseRequisition
    {
        public static DataSet GetTaskList(string procOffice = "ALL")
        {
            database db = new database();
            db.ClearParameters();

            db.SPName = "dbo.spPurchaseRequisition_GetTaskList";
            db.AddParameter("@user_id", SqlDbType.NVarChar, statics.GetLogonUsername());
            db.AddParameter("@proc_office", SqlDbType.NVarChar, procOffice);

            DataSet ds = db.ExecuteSP();
            db.Dispose();

            return ds;
        }

        public static DataSet GetTeamTaskList(string procOffice = "ALL")
        {
            database db = new database();
            db.ClearParameters();

            var username = statics.GetLogonUsername();

            db.SPName = "dbo.spPurchaseRequisition_GetTeamTaskList";
            db.AddParameter("@user_id", SqlDbType.NVarChar, username);
            db.AddParameter("@proc_office", SqlDbType.NVarChar, procOffice);

            DataSet ds = db.ExecuteSP();
            db.Dispose();

            return ds;
        }

        public static DataSet GetFinancialReport(string pr_id)
        {
            database db = new database();
            db.ClearParameters();

            db.SPName = "dbo.spPurchaseRequisition_GetFinancialReport";
            db.AddParameter("@id", SqlDbType.NVarChar, pr_id);

            DataSet ds = db.ExecuteSP();
            db.Dispose();

            return ds;
        }

        public static DataSet GetPrintPreview(string po_id)
        {
            database db = new database();
            db.ClearParameters();

            db.SPName = "dbo.spPurchaseRequisition_Print";
            db.AddParameter("@id", SqlDbType.NVarChar, po_id);
            db.AddParameter("@home_url", SqlDbType.NVarChar, string.Format("{0}{1}", statics.GetSetting("myTree_URL"), statics.GetSetting("App_Pool_Name")));

            DataSet ds = db.ExecuteSP();
            db.Dispose();

            return ds;
        }

        public static string GetFullNumber(string id)
        {
            database db = new database();
            db.ClearParameters();

            db.SPName = "dbo.spPurchaseRequisition_GetNumberDetail";
            db.AddParameter("@id", SqlDbType.NVarChar, id);

            DataSet ds = db.ExecuteSP();
            string prnumber = "";
            if (ds.Tables.Count > 0)
            {
                if (ds.Tables[0].Rows.Count > 0)
                {
                    prnumber = ds.Tables[0].Rows[0][1].ToString();
                }
            }
            db.Dispose();

            return prnumber;
        }

        public static DataSet GetStatusId(string pr_id)
        {
            database db = new database();
            db.ClearParameters();

            db.SPName = "dbo.spPurchaseRequisition_GetStatusId";
            db.AddParameter("@id", SqlDbType.NVarChar, pr_id);

            DataSet ds = db.ExecuteSP();
            db.Dispose();

            return ds;
        }

        public static DataSet GetSubmissionDateByPrDetailId(string pr_detail_id)
        {
            database db = new database();
            db.ClearParameters();

            db.SPName = "dbo.spPurchaseRequisition_GetSubmissionDate";
            db.AddParameter("@pr_line_id", SqlDbType.NVarChar, pr_detail_id);

            DataSet ds = db.ExecuteSP();
            db.Dispose();

            return ds;
        }

        public class Main
        {
            public static DataSet GetList(string startDate, string endDate, string status, string cifor_office, string type_PR)
            {
                database db = new database();
                db.ClearParameters();

                db.SPName = "dbo.spPurchaseRequisition_GetList";
                db.AddParameter("@startDate", SqlDbType.NVarChar, startDate);
                db.AddParameter("@endDate", SqlDbType.NVarChar, endDate);
                db.AddParameter("@status", SqlDbType.NVarChar, status);
                db.AddParameter("@cifor_office", SqlDbType.NVarChar, cifor_office);
                db.AddParameter("@user_id", SqlDbType.NVarChar, statics.GetLogonUsername());
                db.AddParameter("@type_pr", SqlDbType.NVarChar, type_PR);
                db.AddParameter("@path_url", SqlDbType.NVarChar, statics.GetSetting("path_url"));

                DataSet ds = db.ExecuteSP();
                db.Dispose();

                return ds;
            }

            public static DataSet GetData(string id)
            {
                database db = new database();
                db.ClearParameters();

                db.SPName = "dbo.spPurchaseRequisition_GetData";
                db.AddParameter("@id", SqlDbType.NVarChar, id);
                db.AddParameter("@user_id", SqlDbType.NVarChar, statics.GetLogonUsername());

                DataSet ds = db.ExecuteSP();
                db.Dispose();

                return ds;
            }

            public static DataTable GetDataForK2(string id)
            {
                database db = new database();
                db.ClearParameters();

                db.SPName = "dbo.spPurchaseRequisition_GetDataForK2";
                db.AddParameter("@id", SqlDbType.NVarChar, id);

                DataSet ds = db.ExecuteSP();
                db.Dispose();

                return ds.Tables[0];
            }

            public static string Save(DataModel.PurchaseRequisition pr)
            {
                database db = new database();
                db.ClearParameters();

                db.SPName = "dbo.spPurchaseRequisition_Save";
                db.AddParameter("@id", SqlDbType.NVarChar, pr.id);
                db.AddParameter("@requester", SqlDbType.NVarChar, pr.requester);
                db.AddParameter("@required_date", SqlDbType.NVarChar, pr.required_date);
                db.AddParameter("@cifor_office_id", SqlDbType.NVarChar, pr.cifor_office_id);
                db.AddParameter("@cost_center_id", SqlDbType.NVarChar, pr.cost_center_id);
                db.AddParameter("@t4", SqlDbType.NVarChar, pr.t4);
                db.AddParameter("@remarks", SqlDbType.NVarChar, pr.remarks);
                //db.AddParameter("@currency_id", SqlDbType.NVarChar, pr.currency_id);
                //db.AddParameter("@exchange_sign", SqlDbType.NVarChar, pr.exchange_sign);
                //db.AddParameter("@exchange_rate", SqlDbType.NVarChar, pr.exchange_rate);
                db.AddParameter("@total_estimated", SqlDbType.NVarChar, string.IsNullOrEmpty(pr.total_estimated)? "0" : pr.total_estimated);
                db.AddParameter("@created_by", SqlDbType.NVarChar, statics.GetLogonUsername());
                db.AddParameter("@total_estimated_usd", SqlDbType.NVarChar, pr.total_estimated_usd);
                db.AddParameter("@is_direct_to_finance", SqlDbType.NVarChar, pr.is_direct_to_finance);
                db.AddParameter("@direct_to_finance_justification", SqlDbType.NVarChar, pr.direct_to_finance_justification);
                db.AddParameter("@direct_to_finance_file", SqlDbType.NVarChar, pr.direct_to_finance_file);
                db.AddParameter("@purchase_type", SqlDbType.NVarChar, pr.purchase_type);
                db.AddParameter("@other_purchase_type", SqlDbType.NVarChar, pr.other_purchase_type);
                db.AddParameter("@purchasing_process", SqlDbType.NVarChar, pr.purchasing_process);
                db.AddParameter("@is_procurement", SqlDbType.NVarChar, pr.is_procurement);
                db.AddParameter("@temporary_id", SqlDbType.NVarChar, pr.temporary_id);
                db.AddParameter("@is_trigger_audit", SqlDbType.Bit, pr.is_trigger_audit);
                db.AddParameter("@pr_type", SqlDbType.NVarChar, pr.pr_type);
                db.AddParameter("@id_submission_page_type", SqlDbType.NVarChar, pr.id_submission_page_type);

                DataSet ds = db.ExecuteSP();
                db.Dispose();

                return ds.Tables[0].Rows[0]["id"].ToString();
            }

            public static string UpdatePurchaseType(DataModel.PurchaseRequisition pr)
            {
                database db = new database();
                db.ClearParameters();

                db.SPName = "dbo.spPurchaseRequisition_UpdatePurchaseType";
                db.AddParameter("@id", SqlDbType.NVarChar, pr.id);
                db.AddParameter("@pr_type", SqlDbType.NVarChar, pr.pr_type);
                db.AddParameter("@id_submission_page_type", SqlDbType.NVarChar, pr.id_submission_page_type);

                DataSet ds = db.ExecuteSP();
                db.Dispose();

                return ds.Tables[0].Rows[0]["id"].ToString();
            }

            public static string UpdatePRPurchaseType(DataModel.PurchaseRequisition pr)
            {
                database db = new database();
                db.ClearParameters();

                db.SPName = "dbo.spPurchaseRequisition_PurchaseTypeUpdate";
                db.AddParameter("@id", SqlDbType.NVarChar, pr.id);
                db.AddParameter("@purchase_type", SqlDbType.NVarChar, pr.purchase_type);
                db.AddParameter("@user_id", SqlDbType.NVarChar, statics.GetLogonUsername());

                DataSet ds = db.ExecuteSP();
                db.Dispose();

                return pr.id.ToString();
            }

            public static Boolean Delete(string id)
            {
                database db = new database();
                db.ClearParameters();

                db.SPName = "dbo.spPurchaseRequisition_Delete";
                db.AddParameter("@id", SqlDbType.NVarChar, id);

                DataSet ds = db.ExecuteSP();
                db.Dispose();

                return true;
            }

            public static string StatusUpdate(string id, string status_id)
            {
                string pr_no = string.Empty;
                database db = new database();
                db.ClearParameters();

                db.SPName = "dbo.spPurchaseRequisition_StatusUpdate";
                db.AddParameter("@id", SqlDbType.NVarChar, id);
                db.AddParameter("@status", SqlDbType.NVarChar, status_id);
                db.AddParameter("@user_id", SqlDbType.NVarChar, statics.GetLogonUsername());

                DataSet ds = db.ExecuteSP();
                db.Dispose();

                if (ds.Tables.Count > 0)
                {
                    if (ds.Tables[0].Rows.Count > 0)
                    {
                        pr_no = ds.Tables[0].Rows[0][0].ToString();
                    }
                }
                return pr_no;
            }

            public static string IsRevisionUpdate(string id, string rev_status)
            {
                string pr_no = string.Empty;
                database db = new database();
                db.ClearParameters();

                db.SPName = "dbo.spPurchaseRequisition_IsRevisionUpdate";
                db.AddParameter("@id", SqlDbType.NVarChar, id);
                db.AddParameter("@rev_status", SqlDbType.NVarChar, rev_status);
                db.AddParameter("@user_id", SqlDbType.NVarChar, statics.GetLogonUsername());

                DataSet ds = db.ExecuteSP();
                db.Dispose();

                if (ds.Tables.Count > 0)
                {
                    if (ds.Tables[0].Rows.Count > 0)
                    {
                        pr_no = ds.Tables[0].Rows[0][0].ToString();
                    }
                }
                return pr_no;
            }

            public static string SetPRNoForPayment(string id)
            {
                string pr_no = string.Empty;
                database db = new database();
                db.ClearParameters();

                db.SPName = "dbo.spPurchaseRequisition_SetPRNoForPayment";
                db.AddParameter("@id", SqlDbType.NVarChar, id);
                db.AddParameter("@user_id", SqlDbType.NVarChar, statics.GetLogonUsername());

                DataSet ds = db.ExecuteSP();
                db.Dispose();

                if (ds.Tables.Count > 0)
                {
                    if (ds.Tables[0].Rows.Count > 0)
                    {
                        pr_no = ds.Tables[0].Rows[0][0].ToString();
                    }
                }
                return pr_no;
            }

            public static string SaveJournalNo(DataModel.JournalNo journalno)
            {
                database db = new database();
                db.ClearParameters();

                db.SPName = "dbo.spPurchaseRequisitionJournalNo_Save";
                db.AddParameter("@id", SqlDbType.NVarChar, journalno.id);
                db.AddParameter("@pr_id", SqlDbType.NVarChar, journalno.pr_id);
                db.AddParameter("@journal_no", SqlDbType.NVarChar, journalno.journal_no);

                DataSet ds = db.ExecuteSP();
                db.Dispose();

                return ds.Tables[0].Rows[0]["id"].ToString();
            }

            public static Boolean DeleteJournalNo(string id)
            {
                database db = new database();
                db.ClearParameters();

                db.SPName = "dbo.spPurchaseRequisitionJournalNo_Delete";
                db.AddParameter("@id", SqlDbType.NVarChar, id);

                DataSet ds = db.ExecuteSP();
                db.Dispose();

                return true;
            }

            public static DataTable GetUserConfirmation(string po_id)
            {
                database db = new database();
                db.ClearParameters();

                db.SPName = "dbo.spPurchaseRequisition_GetConfirmation";
                db.AddParameter("@id", SqlDbType.NVarChar, po_id);

                DataSet ds = db.ExecuteSP();
                db.Dispose();

                return ds.Tables[0];
            }

            public static void SetReturn(string pr_id, string is_task)
            {
                database db = new database();
                db.ClearParameters();

                db.SPName = "dbo.spPurchaseRequisition_SetReturn";
                db.AddParameter("@id", SqlDbType.NVarChar, pr_id);
                db.AddParameter("@user_id", SqlDbType.NVarChar, statics.GetLogonUsername());
                if (!String.IsNullOrEmpty(is_task))
                {
                    db.AddParameter("@revision_task", SqlDbType.NVarChar, is_task);
                }

                DataSet ds = db.ExecuteSP();
                db.Dispose();
            }

            public static string SavePayment(DataModel.PurchaseRequisition pr)
            {
                database db = new database();
                db.ClearParameters();

                db.SPName = "dbo.spPurchaseRequisition_Payment";
                db.AddParameter("@id", SqlDbType.NVarChar, pr.id);
                db.AddParameter("@reference_no", SqlDbType.NVarChar, pr.reference_no);
                db.AddParameter("@is_payment", SqlDbType.NVarChar, pr.is_payment);
                db.AddParameter("@purchase_type", SqlDbType.NVarChar, pr.purchase_type);

                DataSet ds = db.ExecuteSP();
                db.Dispose();

                return ds.Tables[0].Rows[0]["id"].ToString();
            }



            public static void PRTypeUpdate(DataModel.PurchaseRequisition pr)
            {
                database db = new database();
                db.ClearParameters();

                db.SPName = "dbo.spPurchaseRequisition_PRTypeUpdate";
                db.AddParameter("@id", SqlDbType.NVarChar, pr.id);
                db.AddParameter("@pr_type", SqlDbType.NVarChar, pr.pr_type);
                db.AddParameter("@user_id", SqlDbType.NVarChar, statics.GetLogonUsername());

                DataSet ds = db.ExecuteSP();
                db.Dispose();
            }


            public static string SaveIsProcurement(DataModel.PurchaseRequisition pr)
            {
                database db = new database();
                db.ClearParameters();

                db.SPName = "dbo.spPurchaseRequisition_RevisePayment";
                db.AddParameter("@id", SqlDbType.NVarChar, pr.id);
                db.AddParameter("@is_procurement", SqlDbType.NVarChar, pr.is_procurement);
                db.AddParameter("@purchase_type", SqlDbType.NVarChar, pr.purchase_type);
                db.AddParameter("@pr_type", SqlDbType.NVarChar, pr.pr_type);
                db.AddParameter("@id_submission_page_type", SqlDbType.NVarChar, pr.id_submission_page_type);

                DataSet ds = db.ExecuteSP();
                db.Dispose();

                return ds.Tables[0].Rows[0]["id"].ToString();
            }

            public static void RedirectUserList(DataModel.PurchaseRequisition pr)
            {
                database db = new database();
                db.ClearParameters();

                db.SPName = "dbo.spPurchaseRequisition_RedirectUserList";
                db.AddParameter("@PR_ID", SqlDbType.NVarChar, pr.id);
                db.AddParameter("@IS_PROCUREMENT", SqlDbType.NVarChar, pr.is_procurement);

                DataSet ds = db.ExecuteSP();
                db.Dispose();
            }

            public static Boolean SaveReferenceNo(string pr_id, string pr_reference_no)
            {
                database db = new database();
                db.ClearParameters();

                db.SPName = "dbo.spPurchaseRequisition_SaveReferenceNo";
                db.AddParameter("@id", SqlDbType.NVarChar, pr_id);
                db.AddParameter("@reference_no", SqlDbType.NVarChar, pr_reference_no);
                db.AddParameter("@user_id", SqlDbType.NVarChar, statics.GetLogonUsername());

                DataSet ds = db.ExecuteSP();
                db.Dispose();

                return true;
            }

            public static Boolean SavePaymentNo(string pr_id, string pr_field_name, string pr_field_no)
            {
                database db = new database();
                db.ClearParameters();

                db.SPName = "dbo.spPurchaseRequisition_SavePayment";
                db.AddParameter("@id", SqlDbType.NVarChar, pr_id);
                db.AddParameter("@field_name", SqlDbType.NVarChar, pr_field_no);
                db.AddParameter("@field_no", SqlDbType.NVarChar, pr_field_no);
                db.AddParameter("@user_id", SqlDbType.NVarChar, statics.GetLogonUsername());

                DataSet ds = db.ExecuteSP();
                db.Dispose();

                return true;
            }

            public static void CheckUpdateEmailLog(string pr_id)
            {
                database db = new database();
                db.ClearParameters();

                db.SPName = "dbo.spPurchaseRequisition_CheckUpdateEmailLog";
                db.AddParameter("@module_id", SqlDbType.NVarChar, pr_id);
                db.AddParameter("@module_name", SqlDbType.NVarChar, statics.GetSetting("module_name"));
                db.AddParameter("@email_type", SqlDbType.NVarChar, statics.GetSetting("email_type"));

                DataSet ds = db.ExecuteSP();
                db.Dispose();
            }

            public static Boolean MovePurchaseOffice(string id,string office_id)
            {
                database db = new database();
                db.ClearParameters();

                db.SPName = "dbo.spPurchaseRequisition_MovePurchaseOffice";
                db.AddParameter("@id", SqlDbType.NVarChar, id);
                db.AddParameter("@office_id", SqlDbType.NVarChar, office_id);

                DataSet ds = db.ExecuteSP();
                db.Dispose();

                return true;
            }
        }

        public class Detail
        {
            public static string Save(DataModel.PurchaseRequisitionDetail prd)
            {
                database db = new database();
                db.ClearParameters();

                db.SPName = "dbo.spPurchaseRequisitionDetail_Save";
                db.AddParameter("@id", SqlDbType.NVarChar, prd.id);
                db.AddParameter("@pr_id", SqlDbType.NVarChar, prd.pr_id);
                db.AddParameter("@line_no", SqlDbType.NVarChar, prd.line_no);
                db.AddParameter("@item_id", SqlDbType.NVarChar, 0);/*prd.item_id);*/
                db.AddParameter("@item_code", SqlDbType.NVarChar, prd.item_code);
                db.AddParameter("@category", SqlDbType.NVarChar, prd.category);
                db.AddParameter("@subcategory", SqlDbType.NVarChar, prd.subcategory);
                db.AddParameter("@brand", SqlDbType.NVarChar, prd.brand);
                db.AddParameter("@brand_name", SqlDbType.NVarChar, prd.brand_name);
                db.AddParameter("@description", SqlDbType.NVarChar, prd.description);
                db.AddParameter("@request_qty", SqlDbType.NVarChar, prd.request_qty);
                db.AddParameter("@uom", SqlDbType.NVarChar, prd.uom);
                db.AddParameter("@uom_name", SqlDbType.NVarChar, prd.uom_name);
                db.AddParameter("@unit_price", SqlDbType.NVarChar, prd.unit_price);
                db.AddParameter("@unit_price_usd", SqlDbType.NVarChar, prd.unit_price_usd);
                db.AddParameter("@estimated_cost", SqlDbType.NVarChar, prd.estimated_cost);
                db.AddParameter("@estimated_cost_usd", SqlDbType.NVarChar, prd.estimated_cost_usd);
                db.AddParameter("@last_price_currency", SqlDbType.NVarChar, prd.last_price_currency);
                db.AddParameter("@last_price_amount", SqlDbType.NVarChar, prd.last_price_amount);
                db.AddParameter("@last_price_quantity", SqlDbType.NVarChar, prd.last_price_quantity);
                db.AddParameter("@last_price_uom", SqlDbType.NVarChar, prd.last_price_uom);
                db.AddParameter("@last_price_date", SqlDbType.NVarChar, prd.last_price_date);
                db.AddParameter("@purpose", SqlDbType.NVarChar, prd.purpose);
                db.AddParameter("@delivery_address", SqlDbType.NVarChar, prd.delivery_address);
                db.AddParameter("@other_delivery_address", SqlDbType.NVarChar, prd.other_delivery_address);
                db.AddParameter("@is_other_address", SqlDbType.NVarChar, prd.is_other_address);
                db.AddParameter("@currency_id", SqlDbType.NVarChar, prd.currency_id);
                db.AddParameter("@exchange_rate", SqlDbType.NVarChar, prd.exchange_rate);
                db.AddParameter("@exchange_sign", SqlDbType.NVarChar, prd.exchange_sign);
                db.AddParameter("@is_trigger_audit", SqlDbType.Bit, prd.is_trigger_audit);

                DataSet ds = db.ExecuteSP();
                db.Dispose();

                return ds.Tables[0].Rows[0]["id"].ToString();
            }

            public static Boolean Delete(string id)
            {
                database db = new database();
                db.ClearParameters();

                db.SPName = "dbo.spPurchaseRequisitionDetail_Delete";
                db.AddParameter("@id", SqlDbType.NVarChar, id);

                DataSet ds = db.ExecuteSP();
                db.Dispose();

                return true;
            }

            public static DataSet GetCostCenter(string pr_id,string item_code)
            {
                database db = new database();
                db.ClearParameters();

                db.SPName = "dbo.spPurchaseRequisition_GetCostCenter";
                db.AddParameter("@pr_id", SqlDbType.NVarChar, pr_id);
                db.AddParameter("@item_code", SqlDbType.NVarChar, item_code);

                DataSet ds = db.ExecuteSP();
                db.Dispose();

                return ds;
            }
        }

        public class DirectPurchase
        {
            public static string Save(DataModel.DirectPurchase dp)
            {
                database db = new database();
                db.ClearParameters();

                db.SPName = "dbo.spDirectPurchase_Save";
                db.AddParameter("@id", SqlDbType.NVarChar, dp.id);
                db.AddParameter("@pr_line_id", SqlDbType.NVarChar, dp.pr_line_id);
                db.AddParameter("@item_id", SqlDbType.NVarChar, dp.item_id);
                db.AddParameter("@vendor_id", SqlDbType.NVarChar, dp.vendor_id);
                db.AddParameter("@purchase_currency", SqlDbType.NVarChar, dp.purchase_currency);
                db.AddParameter("@purchase_qty", SqlDbType.NVarChar, dp.purchase_qty);
                db.AddParameter("@exchange_sign", SqlDbType.NVarChar, dp.exchange_sign);
                db.AddParameter("@exchange_rate", SqlDbType.NVarChar, dp.exchange_rate);
                db.AddParameter("@unit_price", SqlDbType.NVarChar, dp.unit_price);
                db.AddParameter("@total_cost", SqlDbType.NVarChar, dp.total_cost);
                db.AddParameter("@total_cost_usd", SqlDbType.NVarChar, dp.total_cost_usd);
                db.AddParameter("@purchase_date", SqlDbType.NVarChar, dp.purchase_date);
                db.AddParameter("@created_by", SqlDbType.NVarChar, statics.GetLogonUsername());
                db.AddParameter("@temporary_id", SqlDbType.NVarChar, dp.temporary_id);
                db.AddParameter("@vendor_address_id", SqlDbType.NVarChar, dp.vendor_address_id);

                DataSet ds = db.ExecuteSP();
                db.Dispose();

                return ds.Tables[0].Rows[0]["id"].ToString();
            }

            public static DataSet GetData(string id, string pr_line_id)
            {
                database db = new database();
                db.ClearParameters();

                db.SPName = "dbo.spDirectPurchase_GetData";
                db.AddParameter("@id", SqlDbType.NVarChar, id);
                db.AddParameter("@pr_line_id", SqlDbType.NVarChar, pr_line_id);

                DataSet ds = db.ExecuteSP();
                db.Dispose();

                return ds;
            }
        }

        /*public static DataModel.PurchaseRequisition GetPreviousData(string id) {
            DataModel.PurchaseRequisition pr = new DataModel.PurchaseRequisition();
            pr.details = new List<DataModel.PurchaseRequisitionDetail>();
            DataModel.PurchaseRequisitionDetail prd = new DataModel.PurchaseRequisitionDetail();

            DataSet ds = Main.GetData(id);
            if (ds.Tables.Count > 0)
            {
                DataTable dtPR = ds.Tables[0];

                if (dtPR.Rows.Count > 0)
                {
                    pr.id = dtPR.Rows[0]["id"].ToString();
                    pr.pr_no = dtPR.Rows[0]["pr_no"].ToString();
                    pr.requester = dtPR.Rows[0]["requester"].ToString();
                    pr.required_date = dtPR.Rows[0]["required_date"].ToString();
                    pr.cifor_office_id = dtPR.Rows[0]["cifor_office_id"].ToString();
                    pr.cost_center_id = dtPR.Rows[0]["cost_center_id"].ToString();
                    pr.t4 = dtPR.Rows[0]["t4"].ToString();
                    pr.remarks = statics.NormalizeString(dtPR.Rows[0]["remarks"].ToString());
                    pr.submission_date = dtPR.Rows[0]["submission_date"].ToString();
                    pr.currency_id = dtPR.Rows[0]["currency_id"].ToString();
                    pr.exchange_sign = dtPR.Rows[0]["exchange_sign"].ToString();
                    pr.exchange_sign_format = pr.exchange_sign == "*" ? "x" : "&divide;";
                    pr.exchange_rate = dtPR.Rows[0]["exchange_rate"].ToString();
                    pr.total_estimated = dtPR.Rows[0]["total_estimated"].ToString();
                    pr.total_estimated_usd = dtPR.Rows[0]["total_estimated_usd"].ToString();
                    pr.status_id = dtPR.Rows[0]["status_id"].ToString();
                    pr.is_active = dtPR.Rows[0]["is_active"].ToString();
                    pr.created_by = dtPR.Rows[0]["created_by"].ToString();

                    pr.t4_name = statics.NormalizeString(dtPR.Rows[0]["t4_name"].ToString());
                    pr.requester_name = statics.NormalizeString(dtPR.Rows[0]["requester_name"].ToString());
                    pr.cifor_office_name = statics.NormalizeString(dtPR.Rows[0]["cifor_office_name"].ToString());

                    pr.required_date = DateTime.Parse(pr.required_date).ToString("dd MMM yyyy");
                }

                DataTable dtDetail = ds.Tables[1];
                DataTable dtAttachment = ds.Tables[2];
                if (dtDetail.Rows.Count > 0)
                {
                    foreach (DataRow dr in dtDetail.Rows)
                    {
                        prd = new DataModel.PurchaseRequisitionDetail();
                        prd.id = dr["id"].ToString();
                        prd.pr_id = dr["pr_id"].ToString();
                        prd.line_no = dr["line_no"].ToString();
                        prd.item_id = dr["item_id"].ToString();
                        prd.item_code = dr["item_code"].ToString();
                        prd.category = statics.NormalizeString(dr["category"].ToString());
                        prd.subcategory = statics.NormalizeString(dr["subcategory"].ToString());
                        prd.brand = statics.NormalizeString(dr["brand"].ToString());
                        prd.description = statics.NormalizeString(dr["description"].ToString());
                        prd.request_qty = dr["request_qty"].ToString();
                        prd.uom = dr["uom"].ToString();
                        prd.unit_price = dr["unit_price"].ToString();
                        prd.unit_price_usd = dr["unit_price_usd"].ToString();
                        prd.estimated_cost = dr["estimated_cost"].ToString();
                        prd.estimated_cost_usd = dr["estimated_cost_usd"].ToString();
                        prd.open_qty = dr["open_qty"].ToString();
                        prd.is_direct_purchase = dr["is_direct_purchase"].ToString();
                        prd.last_price_currency = dr["last_price_currency"].ToString();
                        prd.last_price_amount = dr["last_price_amount"].ToString();
                        prd.status_id = dr["status_id"].ToString();
                        prd.is_active = dr["is_active"].ToString();

                        prd.category_name = dr["category_name"].ToString();
                        prd.subcategory_name = dr["subcategory_name"].ToString();
                        prd.brand_name = dr["brand_name"].ToString();
                        prd.uom_name = dr["uom_name"].ToString();

                        prd.attachments = new List<DataModel.Attachment>();

                        DataRow[] dtDetailAttachment = dtAttachment.Select("document_id='" + prd.id + "'", "id");
                        foreach (DataRow dra in dtDetailAttachment)
                        {
                            DataModel.Attachment attachment = new DataModel.Attachment();
                            attachment.id = dra["id"].ToString();
                            attachment.filename = dra["filename"].ToString();
                            attachment.file_description = statics.NormalizeString(dra["file_description"].ToString());
                            attachment.document_id = dra["document_id"].ToString();
                            attachment.document_type = "PURCHASE REQUISITION";
                            attachment.is_active = dra["is_active"].ToString();

                            prd.attachments.Add(attachment);
                        }

                        pr.details.Add(prd);
                    }
                }
            }
            return pr;
        }*/

        public static DataModel.PurchaseRequisition GetPreviousData(string id)
        {
            DataModel.PurchaseRequisition pr = new DataModel.PurchaseRequisition();
            pr.details = new List<DataModel.PurchaseRequisitionDetail>();

            database db = new database();
            db.ClearParameters();

            db.SPName = "dbo.spPurchaseRequisition_GetPreviousLog";
            db.AddParameter("@id", SqlDbType.NVarChar, id);

            DataSet ds = db.ExecuteSP();
            db.Dispose();

            if (ds.Tables.Count > 0)
            {
                pr.id = id;
                foreach (DataRow dr in ds.Tables[0].Rows)
                {
                    pr.total_estimated_usd = dr["total_estimated_usd"].ToString();
                    pr.cost_center_id = dr["cost_center_id"].ToString();
                }

                foreach (DataRow dr in ds.Tables[1].Rows)
                {
                    DataModel.PurchaseRequisitionDetail prd = new DataModel.PurchaseRequisitionDetail();
                    prd.id = dr["id"].ToString();
                    prd.item_id = dr["item_id"].ToString();
                    pr.details.Add(prd);
                }
            }

            if (string.IsNullOrEmpty(pr.total_estimated_usd))
            {
                pr.total_estimated_usd = "0";
            }
            if (pr.cost_center_id == null)
            {
                pr.cost_center_id = "";
            }

            return pr;
        }

        public static Boolean IsChange(DataModel.PurchaseRequisition oldPR, DataModel.PurchaseRequisition newPR)
        {
            Boolean _isChange = false;

            var newEstUsd = newPR.total_estimated_usd.Replace(',', '.');
            var doubleNewEstUsd = Convert.ToDouble(newEstUsd);
            newPR.total_estimated_usd = doubleNewEstUsd.ToString("0.00");


            var oldCostCDataset = oldPR.cost_center_id;
            var newCostCDataset = "";

            foreach (PurchaseRequisitionDetail pr in newPR.details)
            {
                foreach (PurchaseRequisitionDetailCostCenter cc in pr.costCenters)
                {
                    var ccAmountUsd = cc.amount_usd.Replace(',', '.');
                    var doubleccAmountUsd = Convert.ToDouble(ccAmountUsd);
                    cc.amount_usd = doubleccAmountUsd.ToString("0.00");

                    newCostCDataset += cc.cost_center_id + "|" + cc.work_order + "|" + cc.entity_id + "|" + cc.amount_usd;
                    newCostCDataset += ";";
                }
            }

            newCostCDataset = newCostCDataset.Trim(';');

            string[] oldCostCArray = oldCostCDataset.Split(';');
            string[] newCostCArray = newCostCDataset.Split(';');

            string[] diff = newCostCArray.Except(oldCostCArray).ToArray();

            if (diff.Count() > 0 || Decimal.Parse(oldPR.total_estimated_usd.Replace(',', '.'), CultureInfo.InvariantCulture) != Decimal.Parse(newPR.total_estimated_usd.Replace(',', '.'), CultureInfo.InvariantCulture))
            {
                _isChange = true;
            }

            //string cost_center_id = newPR.cost_center_id + " / " + newPR.t4_name;

            ///*if (oldPR.requester.ToLower() != newPR.requester.ToLower()
            //    || Decimal.Parse(oldPR.total_estimated) != Decimal.Parse(newPR.total_estimated)
            //    || oldPR.currency_id != newPR.currency_id
            //    || oldPR.cost_center_id != newPR.cost_center_id
            //    || oldPR.t4 != newPR.t4
            //    || oldPR.cifor_office_id != newPR.cifor_office_id
            //    || oldPR.details.Count != newPR.details.Count
            //    )
            //{*/

            //if (oldPR.cost_center_id.Trim() != cost_center_id.Trim() || Decimal.Parse(oldPR.total_estimated_usd) != Decimal.Parse(newPR.total_estimated_usd))
            //{
            //    _isChange = true;
            //}

            if (!(Math.Abs(Decimal.Parse(oldPR.total_estimated_usd.Replace(',', '.'), CultureInfo.InvariantCulture) - Decimal.Parse(newPR.total_estimated_usd.Replace(',', '.'), CultureInfo.InvariantCulture)) < 100))
            {
                _isChange = true;
            }

            if ((Decimal.Parse(oldPR.total_estimated_usd.Replace(',', '.'), CultureInfo.InvariantCulture) <= 200 && Decimal.Parse(newPR.total_estimated_usd.Replace(',', '.'), CultureInfo.InvariantCulture) > 200) || (Decimal.Parse(oldPR.total_estimated_usd.Replace(',', '.'), CultureInfo.InvariantCulture) > 200 && Decimal.Parse(newPR.total_estimated_usd.Replace(',', '.'), CultureInfo.InvariantCulture) <= 200))
            {
                _isChange = true;
            }

            if (oldPR.details.Count > 0 || newPR.details.Count > 0)
            {
                foreach (DataModel.PurchaseRequisitionDetail prd in oldPR.details)
                {
                    string detail_id = prd.id.Trim();
                    var search = newPR.details.FirstOrDefault(o => o.id == detail_id);
                    if (search != null)
                    {
                        if (prd.item_id.Trim() != search.item_id.Trim())// && prd.item_id != "0")
                        {
                            _isChange = true;
                        }
                    }
                    else
                    {
                        _isChange = true;
                    }

                }

                foreach (DataModel.PurchaseRequisitionDetail prd in newPR.details)
                {
                    if (prd.id == "")
                    {
                        _isChange = true;
                    }
                }
            }

            return _isChange;
        }
    }
}
