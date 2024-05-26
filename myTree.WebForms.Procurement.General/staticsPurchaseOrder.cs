using System;
using System.Collections.Generic;
using System.Data;


namespace myTree.WebForms.Procurement.General
{
    public class staticsPurchaseOrder
    {
        public static DataSet GetTaskList()
        {
            database db = new database();
            db.ClearParameters();

            db.SPName = "dbo.spPurchaseOrder_GetTaskList";
            db.AddParameter("@user_id", SqlDbType.NVarChar, statics.GetLogonUsername());

            DataSet ds = db.ExecuteSP();
            db.Dispose();

            return ds;
        }

        public static DataSet GetTeamTaskList()
        {
            database db = new database();
            db.ClearParameters();

            db.SPName = "dbo.spPurchaseOrder_GetTeamTaskList";
            db.AddParameter("@user_id", SqlDbType.NVarChar, statics.GetLogonUsername());

            DataSet ds = db.ExecuteSP();
            db.Dispose();

            return ds;
        }

        public static string GetNumberDetail(string id)
        {
            database db = new database();
            db.ClearParameters();

            db.SPName = "dbo.spPurchaseOrder_GetNumberDetail";
            db.AddParameter("@id", SqlDbType.NVarChar, id);

            DataSet ds = db.ExecuteSP();
            string ponumber = "";
            if (ds.Tables.Count > 0)
            {
                if (ds.Tables[0].Rows.Count > 0)
                {
                    ponumber = ds.Tables[0].Rows[0][0].ToString();
                }
            }
            db.Dispose();

            return ponumber;
        }

        public static string GetFullNumber(string id)
        {
            database db = new database();
            db.ClearParameters();

            db.SPName = "dbo.spPurchaseOrder_GetNumberDetail";
            db.AddParameter("@id", SqlDbType.NVarChar, id);

            DataSet ds = db.ExecuteSP();
            string ponumber = "";
            if (ds.Tables.Count > 0)
            {
                if (ds.Tables[0].Rows.Count > 0)
                {
                    ponumber = ds.Tables[0].Rows[0][1].ToString();
                }
            }
            db.Dispose();

            return ponumber;
        }

        public static DataSet GetItems(string vs_ids)
        {
            database db = new database();
            db.ClearParameters();

            db.SPName = "dbo.spPurchaseOrder_GetItems";
            db.AddParameter("@vs_ids", SqlDbType.NVarChar, vs_ids);

            DataSet ds = db.ExecuteSP();
            db.Dispose();

            return ds;
        }

        public static DataTable GetDetailVendorSelection(string po_id)
        {
            database db = new database();
            db.ClearParameters();

            db.SPName = "dbo.spPurchaseOrder_GetDataDetailVendorSelection";
            db.AddParameter("@id", SqlDbType.NVarChar, po_id);

            DataSet ds = db.ExecuteSP();
            db.Dispose();

            return ds.Tables[0];
        }

        public static DataSet GetBackgroundInformation(string po_id)
        {
            database db = new database();
            db.ClearParameters();

            db.SPName = "dbo.spPurchaseOrder_GetBackgroundInformation";
            db.AddParameter("@id", SqlDbType.NVarChar, po_id);
            db.AddParameter("@path_url", SqlDbType.NVarChar, statics.GetSetting("path_url"));

            DataSet ds = db.ExecuteSP();
            db.Dispose();

            return ds;
        }

        public static DataSet GetFinancialReport(string po_id)
        {
            database db = new database();
            db.ClearParameters();

            db.SPName = "dbo.spPurchaseOrder_GetFinancialReport";
            db.AddParameter("@id", SqlDbType.NVarChar, po_id);

            DataSet ds = db.ExecuteSP();
            db.Dispose();

            return ds;
        }

        public static DataTable GetUserConfirmation(string po_id)
        {
            database db = new database();
            db.ClearParameters();

            db.SPName = "dbo.spPurchaseOrder_GetConfirmation";
            db.AddParameter("@id", SqlDbType.NVarChar, po_id);

            DataSet ds = db.ExecuteSP();
            db.Dispose();

            return ds.Tables[0];
        }

        public static string GetApprovalButton(string activity_id)
        {
            string btn = string.Empty;
            database db = new database();
            db.ClearParameters();

            db.SPName = "dbo.spPurchaseOrder_GetApprovalButton";
            db.AddParameter("@activity_id", SqlDbType.NVarChar, activity_id);

            DataSet ds = db.ExecuteSP();
            db.Dispose();

            if (ds.Tables[0].Rows.Count > 0)
            {
                btn = ds.Tables[0].Rows[0][0].ToString();
            }
            return btn;
        }

        public static DataTable GetPOClosure(string po_id)
        {
            database db = new database();
            db.ClearParameters();

            db.SPName = "dbo.spPurchaseOrder_GetPOClosure";
            db.AddParameter("@po_id", SqlDbType.NVarChar, po_id);

            DataSet ds = db.ExecuteSP();
            db.Dispose();

            return ds.Tables[0];
        }

        public static void UpdateFlagEmailToUser(string po_id)
        {
            database db = new database();
            db.ClearParameters();

            db.SPName = "dbo.spPurchaseOrder_UpdateFlagEmailUser";
            db.AddParameter("@id", SqlDbType.NVarChar, po_id);
            db.AddParameter("@user_id", SqlDbType.NVarChar, statics.GetLogonUsername());

            DataSet ds = db.ExecuteSP();
            db.Dispose();
        }

        public static DataSet GetFinancialReportData(string po_id)
        {
            database db = new database();
            db.ClearParameters();

            db.SPName = "dbo.spGetFinancialReport";
            db.AddParameter("@POId", SqlDbType.NVarChar, po_id);

            DataSet ds = db.ExecuteSP();
            db.Dispose();

            return ds;
        }

        public class Main
        {
            public class POOutput
            {
                public string id { get; set; }
                public string po_no { get; set; }
            }

            public static Boolean SaveSUNPO(string po_id, string po_sun_code)
            {
                database db = new database();
                db.ClearParameters();

                db.SPName = "dbo.spPurchaseOrder_SaveSUNPO";
                db.AddParameter("@id", SqlDbType.NVarChar, po_id);
                db.AddParameter("@sun_po", SqlDbType.NVarChar, po_sun_code);
                db.AddParameter("@user_id", SqlDbType.NVarChar, statics.GetLogonUsername());

                DataSet ds = db.ExecuteSP();
                db.Dispose();

                return true;
            }

            public static Boolean SaveDeliveryDate(string po_id, string po_delivery_date)
            {
                database db = new database();
                db.ClearParameters();

                db.SPName = "dbo.spPurchaseOrder_SaveDeliveryDate";
                db.AddParameter("@id", SqlDbType.NVarChar, po_id);
                db.AddParameter("@delivery_date", SqlDbType.NVarChar, po_delivery_date);
                db.AddParameter("@user_id", SqlDbType.NVarChar, statics.GetLogonUsername());

                DataSet ds = db.ExecuteSP();
                db.Dispose();

                return true;
            }

            public static Boolean SaveProcurementAddress(string po_id, string po_procurement_address)
            {
                database db = new database();
                db.ClearParameters();

                db.SPName = "dbo.spPurchaseOrder_SaveProcurementAddress";
                db.AddParameter("@id", SqlDbType.NVarChar, po_id);
                db.AddParameter("@procurement_address", SqlDbType.NVarChar, po_procurement_address);
                db.AddParameter("@user_id", SqlDbType.NVarChar, statics.GetLogonUsername());

                DataSet ds = db.ExecuteSP();
                db.Dispose();

                return true;
            }

            public static Boolean SavePrintOutPO(string po_id,string po_procurement_address, string po_legal_entity)
            {
                database db = new database();
                db.ClearParameters();

                db.SPName = "dbo.spPurchaseOrder_SavePrintOut";
                db.AddParameter("@id", SqlDbType.NVarChar, po_id);
                db.AddParameter("@procurement_address", SqlDbType.NVarChar, po_procurement_address);
                db.AddParameter("@legal_entity", SqlDbType.NVarChar, po_legal_entity);
                db.AddParameter("@user_id", SqlDbType.NVarChar, statics.GetLogonUsername());

                DataSet ds = db.ExecuteSP();
                db.Dispose();

                return true;
            }

            public static Boolean SaveLegalEntity(string po_id, string po_legal_entity)
            {
                database db = new database();
                db.ClearParameters();

                db.SPName = "dbo.spPurchaseOrder_SaveLegalEntity";
                db.AddParameter("@id", SqlDbType.NVarChar, po_id);
                db.AddParameter("@legal_entity", SqlDbType.NVarChar, po_legal_entity);
                db.AddParameter("@user_id", SqlDbType.NVarChar, statics.GetLogonUsername());

                DataSet ds = db.ExecuteSP();
                db.Dispose();

                return true;
            }

            public static Boolean SaveSendDate(string po_id, string po_send_date)
            {
                database db = new database();
                db.ClearParameters();

                db.SPName = "dbo.spPurchaseOrder_SaveSendDate";
                db.AddParameter("@id", SqlDbType.NVarChar, po_id);
                db.AddParameter("@send_date", SqlDbType.NVarChar, po_send_date);
                db.AddParameter("@user_id", SqlDbType.NVarChar, statics.GetLogonUsername());

                DataSet ds = db.ExecuteSP();
                db.Dispose();

                return true;
            }

            public static DataSet GetList(string startDate, string endDate, string status, string cifor_office)
            {
                database db = new database();
                db.ClearParameters();

                db.SPName = "dbo.spPurchaseOrder_GetList";
                db.AddParameter("@startDate", SqlDbType.NVarChar, startDate);
                db.AddParameter("@endDate", SqlDbType.NVarChar, endDate);
                db.AddParameter("@status", SqlDbType.NVarChar, status);
                db.AddParameter("@cifor_office", SqlDbType.NVarChar, cifor_office);
                db.AddParameter("@user_id", SqlDbType.NVarChar, statics.GetLogonUsername());

                DataSet ds = db.ExecuteSP();
                db.Dispose();

                return ds;
            }

            public static DataSet GetListBP_PO(string _id)
            {
                database db = new database();
                db.ClearParameters();

                db.SPName = "dbo.spBusinessPartnerPO_GetList";
                db.AddParameter("@vendor_id", SqlDbType.NVarChar, _id);
                //db.AddParameter("@user_id", SqlDbType.NVarChar, statics.GetLogonUsername());

                DataSet ds = db.ExecuteSP();
                db.Dispose();

                return ds;
            }

            public static DataSet GetData(string id)
            {
                database db = new database();
                db.ClearParameters();

                db.SPName = "dbo.spPurchaseOrder_GetData";
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

                db.SPName = "dbo.spPurchaseOrder_GetDataForK2";
                db.AddParameter("@id", SqlDbType.NVarChar, id);

                DataSet ds = db.ExecuteSP();
                db.Dispose();

                return ds.Tables[0];
            }

            public static DataSet GetDataDetail(string id)
            {
                database db = new database();
                db.ClearParameters();

                db.SPName = "dbo.spPurchaseOrder_GetDataDetail";
                db.AddParameter("@id", SqlDbType.NVarChar, id);

                DataSet ds = db.ExecuteSP();
                db.Dispose();

                return ds;
            }

            public static POOutput Save(DataModel.PurchaseOrder po)
            {
                database db = new database();
                db.ClearParameters();

                db.SPName = "dbo.spPurchaseOrder_Save";
                db.AddParameter("@id", SqlDbType.NVarChar, po.id);
                db.AddParameter("@po_no", SqlDbType.NVarChar, po.po_no);
                db.AddParameter("@po_sun_code", SqlDbType.NVarChar, po.po_sun_code);
                db.AddParameter("@cifor_office_id", SqlDbType.NVarChar, po.cifor_office_id);
                db.AddParameter("@document_date", SqlDbType.NVarChar, po.document_date);
                db.AddParameter("@vendor_id", SqlDbType.NVarChar, po.vendor);
                db.AddParameter("@vendor_name", SqlDbType.NVarChar, po.vendor_name);
                db.AddParameter("@vendor_code", SqlDbType.NVarChar, po.vendor_code);
                db.AddParameter("@vendor_contact_person", SqlDbType.NVarChar, po.vendor_contact_person);
                db.AddParameter("@remarks", SqlDbType.NVarChar, po.remarks);
                db.AddParameter("@expected_delivery_date", SqlDbType.NVarChar, po.expected_delivery_date);
                db.AddParameter("@send_date", SqlDbType.NVarChar, po.send_date);
                db.AddParameter("@po_type", SqlDbType.NVarChar, po.po_type);
                db.AddParameter("@sun_trans_type", SqlDbType.NVarChar, po.sun_trans_type);
                db.AddParameter("@po_prefix", SqlDbType.NVarChar, po.po_prefix);
                db.AddParameter("@cifor_shipment_account", SqlDbType.NVarChar, po.cifor_shipment_account);
                db.AddParameter("@cifor_delivery_address", SqlDbType.NVarChar, po.cifor_delivery_address);
                db.AddParameter("@delivery_term", SqlDbType.NVarChar, po.delivery_term);
                db.AddParameter("@term_of_payment", SqlDbType.NVarChar, po.term_of_payment);
                db.AddParameter("@other_term_of_payment", SqlDbType.NVarChar, po.other_term_of_payment);
                db.AddParameter("@is_other_term_of_payment", SqlDbType.NVarChar, po.is_other_term_of_payment);
                db.AddParameter("@account_code", SqlDbType.NVarChar, po.account_code);
                db.AddParameter("@account_period", SqlDbType.NVarChar, po.period);
                //db.AddParameter("@currency_id", SqlDbType.NVarChar, po.currency_id);
                //db.AddParameter("@exchange_sign", SqlDbType.NVarChar, po.exchange_sign);
                //db.AddParameter("@exchange_rate", SqlDbType.NVarChar, po.exchange_rate);
                db.AddParameter("@gross_amount", SqlDbType.NVarChar, po.gross_amount);
                db.AddParameter("@gross_amount_usd", SqlDbType.NVarChar, po.gross_amount_usd);
                db.AddParameter("@discount", SqlDbType.NVarChar, po.discount);
                db.AddParameter("@tax", SqlDbType.NVarChar, po.tax);
                db.AddParameter("@tax_type", SqlDbType.NVarChar, po.tax_type);
                db.AddParameter("@total_amount", SqlDbType.NVarChar, po.total_amount);
                db.AddParameter("@total_amount_usd", SqlDbType.NVarChar, po.total_amount_usd);
                db.AddParameter("@status_id", SqlDbType.NVarChar, po.status_id);
                db.AddParameter("@is_other_address", SqlDbType.NVarChar, po.is_other_address);
                db.AddParameter("@other_address", SqlDbType.NVarChar, po.other_address);
                db.AddParameter("@legal_entity", SqlDbType.NVarChar, po.legal_entity);
                db.AddParameter("@procurement_address", SqlDbType.NVarChar, po.procurement_address);
                db.AddParameter("@is_goods", SqlDbType.NVarChar, po.is_goods);
                //db.AddParameter("@is_sundry_po", SqlDbType.NVarChar, po.is_sundry_po);
                db.AddParameter("@user_id", SqlDbType.NVarChar, statics.GetLogonUsername());

                DataSet ds = db.ExecuteSP();
                db.Dispose();

                POOutput output = new POOutput();

                if (ds.Tables[0].Rows.Count > 0)
                {
                    output.id = ds.Tables[0].Rows[0]["id"].ToString();
                    output.po_no = ds.Tables[0].Rows[0]["po_no"].ToString();
                }

                return output;
            }

            public static Boolean StatusUpdate(string id, string status_id)
            {
                database db = new database();
                db.ClearParameters();

                db.SPName = "dbo.spPurchaseOrder_StatusUpdate";
                db.AddParameter("@id", SqlDbType.NVarChar, id);
                db.AddParameter("@status", SqlDbType.NVarChar, status_id);
                db.AddParameter("@user_id", SqlDbType.NVarChar, statics.GetLogonUsername());

                DataSet ds = db.ExecuteSP();
                db.Dispose();

                return true;
            }

            public static string GetSUNPO(string id)
            {
                string sun_po = string.Empty;

                database db = new database();
                db.ClearParameters();

                db.SPName = "dbo.spPurchaseOrder_GetSUNPO";
                db.AddParameter("@id", SqlDbType.NVarChar, id);

                DataSet ds = db.ExecuteSP();
                db.Dispose();

                if (ds.Tables[0].Rows.Count > 0)
                {
                    sun_po = ds.Tables[0].Rows[0]["SUN_PO_NO"].ToString();
                }
                return sun_po;
            }

            public static string IsRevisionUpdate(string id, string rev_status)
            {
                string pr_no = string.Empty;
                database db = new database();
                db.ClearParameters();

                db.SPName = "dbo.spPurchaseOrder_IsRevisionUpdate";
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

            public static bool GetIsPOFromHQ(string procurementOfficeId)
            {
                List<string> HQOffices = new List<string>() { "BOGOR", "KENYA" };
                if (HQOffices.Contains(procurementOfficeId))
                    return true;
                else
                    return false;
            }
        }

        public class Detail
        {
            public static string Save(DataModel.PurchaseOrderDetail pod)
            {
                database db = new database();
                db.ClearParameters();

                db.SPName = "dbo.spPurchaseOrderDetail_Save";
                db.AddParameter("@id", SqlDbType.NVarChar, pod.id);
                db.AddParameter("@purchase_order", SqlDbType.NVarChar, pod.purchase_order);
                db.AddParameter("@line_number", SqlDbType.NVarChar, pod.line_number);
                db.AddParameter("@item_id", SqlDbType.NVarChar, pod.item_id);
                db.AddParameter("@item_code", SqlDbType.NVarChar, pod.item_code);
                db.AddParameter("@brand_name", SqlDbType.NVarChar, pod.brand_name);
                db.AddParameter("@description", SqlDbType.NVarChar, pod.description);
                db.AddParameter("@quotation_description", SqlDbType.NVarChar, pod.quotation_description);
                db.AddParameter("@uom", SqlDbType.NVarChar, pod.uom);
                db.AddParameter("@pr_detail_id", SqlDbType.NVarChar, pod.pr_detail_id);
                db.AddParameter("@pr_id", SqlDbType.NVarChar, pod.pr_id);
                db.AddParameter("@pr_no", SqlDbType.NVarChar, pod.pr_no);
                db.AddParameter("@rfq_id", SqlDbType.NVarChar, pod.rfq_id);
                db.AddParameter("@rfq_no", SqlDbType.NVarChar, pod.rfq_no);
                db.AddParameter("@q_id", SqlDbType.NVarChar, pod.q_id);
                db.AddParameter("@q_no", SqlDbType.NVarChar, pod.q_no);
                db.AddParameter("@vs_detail_id", SqlDbType.NVarChar, pod.vs_detail_id);
                db.AddParameter("@vs_id", SqlDbType.NVarChar, pod.vs_id);
                db.AddParameter("@vs_no", SqlDbType.NVarChar, pod.vs_no);
                db.AddParameter("@cost_center_id", SqlDbType.NVarChar, pod.cost_center_id);
                db.AddParameter("@t4", SqlDbType.NVarChar, pod.work_order);
                db.AddParameter("@quantity", SqlDbType.NVarChar, pod.quantity);
                db.AddParameter("@unit_price", SqlDbType.NVarChar, pod.unit_price);
                db.AddParameter("@discount", SqlDbType.NVarChar, pod.discount);
                db.AddParameter("@additional_discount", SqlDbType.NVarChar, pod.additional_discount);
                db.AddParameter("@line_total", SqlDbType.NVarChar, pod.line_total);
                db.AddParameter("@line_total_usd", SqlDbType.NVarChar, pod.line_total_usd);
                db.AddParameter("@remarks", SqlDbType.NVarChar, pod.remarks);
                db.AddParameter("@currency_id", SqlDbType.NVarChar, pod.currency_id);
                db.AddParameter("@exchange_sign", SqlDbType.NVarChar, pod.exchange_sign);
                db.AddParameter("@exchange_rate", SqlDbType.NVarChar, pod.exchange_rate);
                db.AddParameter("@payable_vat", SqlDbType.NVarChar, pod.vat_payable);
                db.AddParameter("@printable_vat", SqlDbType.NVarChar, pod.vat_printable);
                db.AddParameter("@vat_amount", SqlDbType.NVarChar, pod.vat_amount);
                db.AddParameter("@vat", SqlDbType.NVarChar, pod.vat);
                db.AddParameter("@vat_type", SqlDbType.NVarChar, pod.vat_type);

                DataSet ds = db.ExecuteSP();
                db.Dispose();

                string output = "";

                if (ds.Tables[0].Rows.Count > 0)
                {
                    output = ds.Tables[0].Rows[0]["id"].ToString();
                }

                return output;
            }

            public static Boolean Delete(string id)
            {
                database db = new database();
                db.ClearParameters();

                db.SPName = "dbo.spPurchaseOrderDetail_Delete";
                db.AddParameter("@id", SqlDbType.NVarChar, id);

                DataSet ds = db.ExecuteSP();
                db.Dispose();

                return true;
            }

            public static Boolean SaveCostCenter(DataModel.PurchaseOrderDetailCostCenter costCenter)
            {
                database db = new database();
                db.ClearParameters();

                db.SPName = "dbo.spPurchaseOrder_CostCenter_Save";
                db.AddParameter("@id", SqlDbType.NVarChar, costCenter.id);
                db.AddParameter("@purchase_order", SqlDbType.NVarChar, costCenter.purchase_order);
                db.AddParameter("@purchase_order_detail_id", SqlDbType.NVarChar, costCenter.purchase_order_detail_id);
                db.AddParameter("@vendor_selection_detail_cost_center_id", SqlDbType.NVarChar, costCenter.vendor_selection_detail_cost_center_id);
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
                db.AddParameter("@amount_usd_vat", SqlDbType.NVarChar, costCenter.amount_usd_vat);
                db.AddParameter("@amount_vat", SqlDbType.NVarChar, costCenter.amount_vat);
                db.AddParameter("@amount_vat_product", SqlDbType.NVarChar, costCenter.amount_vat_product);
                db.AddParameter("@remarks", SqlDbType.NVarChar, costCenter.remarks);

                DataSet ds = db.ExecuteSP();
                db.Dispose();

                return true;
            }
        }

        public class CompiledPO
        {
            public static DataSet PRData(string po_id)
            {
                database db = new database();
                db.ClearParameters();

                db.SPName = "dbo.spPurchaseOrder_CompiledPO_PR_data";
                db.AddParameter("@id", SqlDbType.NVarChar, po_id);
                db.AddParameter("@path_url", SqlDbType.NVarChar, statics.GetSetting("path_url"));

                DataSet ds = db.ExecuteSP();
                db.Dispose();

                return ds;
            }

            public static DataSet VSData(string po_id)
            {
                database db = new database();
                db.ClearParameters();

                db.SPName = "dbo.spPurchaseOrder_CompiledPO_VS_data";
                db.AddParameter("@id", SqlDbType.NVarChar, po_id);

                DataSet ds = db.ExecuteSP();
                db.Dispose();

                return ds;
            }
        }
    }

    public static class OCSPurchaseOrderStatusEnum
    {
        public const string O = "Ordered";
        public const string T = "Terminated";
        public const string N = "Active/Not ordered";
        public const string F = "Finished";
        public const string P = "Rejected";
        public const string C = "Closed";
    }
}
