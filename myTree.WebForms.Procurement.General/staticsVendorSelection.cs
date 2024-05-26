using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;


namespace myTree.WebForms.Procurement.General
{
    public class staticsVendorSelection
    {
        public static string isQuotationValid(string quotation_detail_ids)
        {
            string valid = "1";
            database db = new database();
            db.ClearParameters();

            db.SPName = "dbo.spVendorSelection_ValidateQuotation";
            db.AddParameter("@quotation_detail_ids", SqlDbType.NVarChar, quotation_detail_ids);

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

        public static DataSet GetItem(string usedItems, string vendor_ids, string currency_ids,
            string date, string startdate, string enddate, string search, string cifor_office)
        {
            database db = new database();
            db.ClearParameters();

            db.SPName = "dbo.spVendorSelection_GetItems";
            db.AddParameter("@pr_detail_id", SqlDbType.NVarChar, usedItems);
            db.AddParameter("@vendors", SqlDbType.NVarChar, vendor_ids);
            db.AddParameter("@currencies", SqlDbType.NVarChar, currency_ids);
            db.AddParameter("@date", SqlDbType.NVarChar, date);
            db.AddParameter("@startdate", SqlDbType.NVarChar, startdate);
            db.AddParameter("@enddate", SqlDbType.NVarChar, enddate);
            db.AddParameter("@search", SqlDbType.NVarChar, search);
            db.AddParameter("@cifor_office", SqlDbType.NVarChar, cifor_office);
            DataSet ds = db.ExecuteSP();
            db.Dispose();

            return ds;
        }

        public class Main
        {
            public class VSOutput
            {
                public string id { get; set; }
                public string vs_no { get; set; }
            }

            public static DataSet GetData(string id)
            {
                database db = new database();
                db.ClearParameters();

                db.SPName = "dbo.spVendorSelection_GetData";
                db.AddParameter("@id", SqlDbType.NVarChar, id);

                DataSet ds = db.ExecuteSP();
                db.Dispose();

                return ds;
            }

            public static DataSet GetVendorSelectionDetailData(string vs_id)
            {
                database db = new database();
                db.ClearParameters();

                db.SPName = "dbo.spVendorSelectionDetail_GetData";
                db.AddParameter("@vs_id", SqlDbType.NVarChar, vs_id);

                DataSet ds = db.ExecuteSP();
                db.Dispose();

                return ds;
            }

            public static DataSet GetList(string startDate, string endDate, string status, string cifor_office)
            {
                return GetList(startDate, endDate, status, cifor_office,"");
            }

            public static DataSet GetList(string startDate, string endDate, string status, string cifor_office, string usedVS)
            {
                database db = new database();
                db.ClearParameters();

                db.SPName = "dbo.spVendorSelection_GetList";
                db.AddParameter("@startDate", SqlDbType.NVarChar, startDate);
                db.AddParameter("@endDate", SqlDbType.NVarChar, endDate);
                db.AddParameter("@status", SqlDbType.NVarChar, status);
                db.AddParameter("@cifor_office", SqlDbType.NVarChar, cifor_office);
                db.AddParameter("@based_url", SqlDbType.NVarChar, statics.GetSetting("path_url"));
                db.AddParameter("@usedVS", SqlDbType.NVarChar, usedVS);
                db.AddParameter("@user_id", SqlDbType.NVarChar, statics.GetLogonUsername());

                DataSet ds = db.ExecuteSP();
                db.Dispose();

                return ds;
            }

            public static VSOutput Save(DataModel.VendorSelection vs)
            {
                database db = new database();
                db.ClearParameters();

                db.SPName = "dbo.spVendorSelection_Save";
                db.AddParameter("@id", SqlDbType.NVarChar, vs.id);
                db.AddParameter("@vs_no", SqlDbType.NVarChar, vs.vs_no);
                db.AddParameter("@document_date", SqlDbType.NVarChar, vs.document_date);
                db.AddParameter("@currency_id", SqlDbType.NVarChar, vs.currency_id);
                db.AddParameter("@exchange_sign", SqlDbType.NVarChar, vs.exchange_sign);
                db.AddParameter("@exchange_rate", SqlDbType.NVarChar, vs.exchange_rate);
                db.AddParameter("@cifor_office_id", SqlDbType.NVarChar, vs.cifor_office_id);
                db.AddParameter("@status_id", SqlDbType.NVarChar, vs.status_id);
                db.AddParameter("@user_id", SqlDbType.NVarChar, statics.GetLogonUsername());

                DataSet ds = db.ExecuteSP();
                db.Dispose();

                VSOutput output = new VSOutput();

                if (ds.Tables[0].Rows.Count > 0)
                {
                    output.id = ds.Tables[0].Rows[0]["id"].ToString();
                    output.vs_no = ds.Tables[0].Rows[0]["vs_no"].ToString();
                }

                return output;
            }

            public static Boolean Delete(string id)
            {
                database db = new database();
                db.ClearParameters();

                db.SPName = "dbo.spVendorSelection_Delete";
                db.AddParameter("@id", SqlDbType.NVarChar, id);

                DataSet ds = db.ExecuteSP();
                db.Dispose();

                return true;
            }

            public static Boolean StatusUpdate(string id, string status_id)
            {
                database db = new database();
                db.ClearParameters();

                db.SPName = "dbo.spVendorSelection_StatusUpdate";
                db.AddParameter("@id", SqlDbType.NVarChar, id);
                db.AddParameter("@status", SqlDbType.NVarChar, status_id);
                db.AddParameter("@user_id", SqlDbType.NVarChar, statics.GetLogonUsername());

                DataSet ds = db.ExecuteSP();
                db.Dispose();

                return true;
            }

            public static VSOutput SaveJustification(DataModel.VendorSelection vs)
            {
                database db = new database();
                db.ClearParameters();

                db.SPName = "dbo.spVendorSelection_SaveJustification";
                db.AddParameter("@id", SqlDbType.NVarChar, vs.id);
                db.AddParameter("@vs_no", SqlDbType.NVarChar, vs.vs_no);
                db.AddParameter("@singlesourcing", SqlDbType.NVarChar, vs.singlesourcing);
                db.AddParameter("@justification_singlesourcing", SqlDbType.NVarChar, vs.justification_singlesourcing);
                db.AddParameter("@justification_file_singlesourcing", SqlDbType.NVarChar, vs.justification_file_singlesourcing);
                db.AddParameter("@status_id", SqlDbType.NVarChar, vs.status_id);
                db.AddParameter("@user_id", SqlDbType.NVarChar, statics.GetLogonUsername());
                db.AddParameter("@ss_initiated_by", SqlDbType.NVarChar, vs.ss_initiated_by);
                db.AddParameter("@is_submission", SqlDbType.NVarChar, vs.is_submission);
                db.AddParameter("@ss_guideline", SqlDbType.NVarChar, vs.ss_guideline);

                DataSet ds = db.ExecuteSP();
                db.Dispose();

                VSOutput output = new VSOutput();

                if (ds.Tables[0].Rows.Count > 0)
                {
                    output.id = ds.Tables[0].Rows[0]["id"].ToString();
                    output.vs_no = ds.Tables[0].Rows[0]["vs_no"].ToString();
                }

                return output;
            }

            public static DataTable GetDataForK2(string id)
            {
                database db = new database();
                db.ClearParameters();

                db.SPName = "dbo.spVendorSelection_GetDataForK2";
                db.AddParameter("@id", SqlDbType.NVarChar, id);

                DataSet ds = db.ExecuteSP();
                db.Dispose();

                return ds.Tables[0];
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

            public static Boolean UpdateSingleSource(string id, string singlesourcing, string justification_singlesourcing, string justification_file_singlesourcing,string ss_initiated_by)
            {
                database db = new database();
                db.ClearParameters();

                db.SPName = "dbo.spVendorSelection_UpdateSingleSource";
                db.AddParameter("@id", SqlDbType.NVarChar, id);
                db.AddParameter("@singlesourcing", SqlDbType.NVarChar, singlesourcing);
                db.AddParameter("@justification_singlesourcing", SqlDbType.NVarChar, justification_singlesourcing);
                db.AddParameter("@justification_file_singlesourcing", SqlDbType.NVarChar, justification_file_singlesourcing);
                db.AddParameter("@ss_initiated_by", SqlDbType.NVarChar, ss_initiated_by);

                DataSet ds = db.ExecuteSP();
                db.Dispose();

                return true;
            }
        }

        public class Detail
        {
       
            public static string Save(DataModel.VendorSelectionDetail vsd)
            {
                database db = new database();
                db.ClearParameters();

                db.SPName = "dbo.spVendorSelectionDetail_Save";
                db.AddParameter("@id", SqlDbType.NVarChar, vsd.id);
                db.AddParameter("@vendor_selection", SqlDbType.NVarChar, vsd.vendor_selection);
                db.AddParameter("@vendor_id", SqlDbType.NVarChar, vsd.vendor);
                db.AddParameter("@vendor_name", SqlDbType.NVarChar, vsd.vendor_name);
                db.AddParameter("@vendor_code", SqlDbType.NVarChar, vsd.vendor_code);
                db.AddParameter("@vendor_contact_person", SqlDbType.NVarChar, vsd.vendor_contact_person);
                db.AddParameter("@quotation_detail_id", SqlDbType.NVarChar, vsd.quotation_detail_id);
                db.AddParameter("@pr_detail_id", SqlDbType.NVarChar, vsd.pr_detail_id);
                db.AddParameter("@source_quantity", SqlDbType.NVarChar, vsd.source_quantity);
                db.AddParameter("@quantity", SqlDbType.NVarChar, vsd.quantity);
                db.AddParameter("@uom", SqlDbType.NVarChar, vsd.uom_id);
                db.AddParameter("@unit_price", SqlDbType.NVarChar, vsd.unit_price);
                db.AddParameter("@discount", SqlDbType.NVarChar, vsd.discount);
                db.AddParameter("@line_total", SqlDbType.NVarChar, vsd.line_total);
                db.AddParameter("@line_total_usd", SqlDbType.NVarChar, vsd.line_total_usd);
                db.AddParameter("@indent_time", SqlDbType.NVarChar, vsd.indent_time);
                db.AddParameter("@warranty_time", SqlDbType.NVarChar, vsd.warranty_time);
                db.AddParameter("@expected_delivery_date", SqlDbType.NVarChar, vsd.expected_delivery_date);
                db.AddParameter("@reason_for_selection", SqlDbType.NVarChar, vsd.reason_for_selection);
                db.AddParameter("@remarks", SqlDbType.NVarChar, vsd.remarks);
                db.AddParameter("@justification_file", SqlDbType.NVarChar, vsd.justification_file);
                db.AddParameter("@is_selected", SqlDbType.NVarChar, vsd.is_selected);
                db.AddParameter("@line_no", SqlDbType.NVarChar, vsd.line_no);
                db.AddParameter("@pr_id", SqlDbType.NVarChar, vsd.pr_id);
                db.AddParameter("@pr_no", SqlDbType.NVarChar, vsd.pr_no);
                db.AddParameter("@currency_id", SqlDbType.NVarChar, vsd.currency_id);
                db.AddParameter("@exchange_sign", SqlDbType.NVarChar, vsd.exchange_sign);
                db.AddParameter("@exchange_rate", SqlDbType.NVarChar, vsd.exchange_rate);
                db.AddParameter("@additional_discount", SqlDbType.NVarChar, vsd.additional_discount);

                DataSet ds = db.ExecuteSP();
                db.Dispose();

                return ds.Tables[0].Rows[0]["id"].ToString();
            }

            public static Boolean Delete(string id)
            {
                database db = new database();
                db.ClearParameters();

                db.SPName = "dbo.spVendorSelectionDetail_Delete";
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

                db.SPName = "dbo.spVendorSelectionDetail_Close";
                db.AddParameter("@id", SqlDbType.NVarChar, qd.id);
                db.AddParameter("@close_quantity", SqlDbType.NVarChar, qd.close_quantity);
                db.AddParameter("@close_remarks", SqlDbType.NVarChar, qd.close_remarks);
                db.AddParameter("@user_id", SqlDbType.NVarChar, statics.GetLogonUsername());

                DataSet ds = db.ExecuteSP();
                db.Dispose();

                return true;
            }

            public static DataSet GetCostCenter(string vs_id, string item_code)
            {
                database db = new database();
                db.ClearParameters();

                db.SPName = "dbo.spVendorSelection_GetCostCenter";
                db.AddParameter("@vs_id", SqlDbType.NVarChar, vs_id);
                db.AddParameter("@item_code", SqlDbType.NVarChar, item_code);

                DataSet ds = db.ExecuteSP();
                db.Dispose();

                return ds;
            }

            public static string CostCenterSave(DataModel.VendorSelectionDetailCostCenter cc)
            {
                database db = new database();
                db.ClearParameters();

                db.SPName = "dbo.spVendorSelectionDetailCostCenter_Save";
                db.AddParameter("@id", SqlDbType.NVarChar, cc.id);
                db.AddParameter("@vendor_selection_id", SqlDbType.NVarChar, cc.vendor_selection_id);
                db.AddParameter("@vendor_selection_detail_id", SqlDbType.NVarChar, cc.vendor_selection_detail_id);
                db.AddParameter("@pr_detail_cost_center_id", SqlDbType.NVarChar, cc.pr_detail_cost_center_id);
                db.AddParameter("@quotation_detail_cost_center_id", SqlDbType.NVarChar, cc.quotation_detail_cost_center_id);
                db.AddParameter("@sequence_no", SqlDbType.NVarChar, cc.sequence_no);
                db.AddParameter("@cost_center_id", SqlDbType.NVarChar, cc.cost_center_id);
                db.AddParameter("@work_order", SqlDbType.NVarChar, cc.work_order);
                db.AddParameter("@entity_id", SqlDbType.NVarChar, cc.entity_id);
                db.AddParameter("@legal_entity", SqlDbType.NVarChar, cc.legal_entity);
                db.AddParameter("@control_account", SqlDbType.NVarChar, cc.control_account);
                db.AddParameter("@percentage", SqlDbType.NVarChar, cc.percentage);
                db.AddParameter("@amount", SqlDbType.NVarChar, cc.amount);
                db.AddParameter("@amount_usd", SqlDbType.NVarChar, cc.amount_usd);
                db.AddParameter("@remarks", SqlDbType.NVarChar, cc.remarks);
                db.AddParameter("@is_active", SqlDbType.NVarChar, cc.is_active);


                DataSet ds = db.ExecuteSP();
                db.Dispose();

                return ds.Tables[0].Rows[0]["id"].ToString();
            }

            public static Boolean CostCenterDelete(string id)
            {
                database db = new database();
                db.ClearParameters();

                db.SPName = "dbo.spVendorSelectionDetailCostCenter_Delete";
                db.AddParameter("@id", SqlDbType.NVarChar, id);

                DataSet ds = db.ExecuteSP();
                db.Dispose();

                return true;
            }
        }

        
    }
}
