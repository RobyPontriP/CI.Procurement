using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Newtonsoft.Json;
using System.Configuration;
using System.Data;
using OfficeOpenXml;
using OfficeOpenXml.Style;
using System.Drawing;
using System.Windows;
//using System.Web.Services.Description;
using System.Windows.Media;

namespace myTree.WebForms.Procurement.General
{
    public class statics
    {
        public static string GetSetting(string KeyName)
        {
            return ConfigurationManager.AppSettings[KeyName].ToString();
        }

        public static string GetLogonUsername()
        {
            string strUserLogon = HttpContext.Current.User.Identity.Name.ToLower();
            int index = strUserLogon.IndexOf("\\");
            strUserLogon = strUserLogon.Substring(index + 1);
            //strUserLogon = "mastuti";

            return strUserLogon;
        }

        public static bool isProcurementLead(string userId, UserRoleAccess userRoleAccess)
        {
            Boolean isLead = false;

            //set is leader
            if (userRoleAccess.RoleNameInSystem == AccessControlRoleNameEnum.ProcurementLead)
            {
                isLead = true;
            }
            else
            {
                var tblProcLead = statics.GetProcurementOfficeTeamLeader();
                List<string> leadProc = new List<string>();
                if (tblProcLead != null)
                {
                    if (tblProcLead.Rows.Count > 0)
                    {
                        foreach (DataRow rw in tblProcLead.Rows)
                        {
                            if (!string.IsNullOrEmpty(rw["user_id"].ToString()))
                            {
                                leadProc.Add(rw["user_id"].ToString().ToUpper());
                            }
                        }
                    }
                }

                isLead = leadProc.Contains(userId.ToUpper());
            }

            return isLead;
        }


        public static string GetUserMappingByUsername(string username)
        {
            database db = new database();
            db.ClearParameters();

            db.SPName = "spProcurement_GetUserMappingByUsername";
            db.AddParameter("@User", SqlDbType.NVarChar, username);

            DataSet ds = db.ExecuteSP();
            db.Dispose();

            return ds.Tables[0].Rows[0]["Username"].ToString();
        }

        public static DataModel.Autorhize isAuthorized(string module, string page)
        {
            string user_id = GetLogonUsername();
            database db = new database();
            db.ClearParameters();

            db.SPName = "dbo.spGetAuthorize";
            db.AddParameter("@user_id", SqlDbType.NVarChar, user_id);
            db.AddParameter("@module", SqlDbType.NVarChar, module);
            db.AddParameter("@page", SqlDbType.NVarChar, page);

            DataSet ds = db.ExecuteSP();
            db.Dispose();

            DataModel.Autorhize da = new DataModel.Autorhize();
            if (ds.Tables[0].Rows[0]["isAuthorize"].ToString() == "1")
            {
                da.access = true;
            }
            else
            {
                da.access = false;
            }
            if (ds.Tables[0].Rows[0]["isAdmin"].ToString() == "1")
            {
                da.admin = true;
            }
            else
            {
                da.admin = false;
            }
            return da;
        }

        public static IEnumerable<DataRow> GetCategory(string search)
        {
            database db = new database();
            db.ClearParameters();
            db.SPName = "spGetCategory";
            db.AddParameter("@name", SqlDbType.VarChar, search);
            DataSet ds = db.ExecuteSP();

            db.Dispose();
            return ds.Tables[0].Rows.Cast<System.Data.DataRow>();
        }

        public static IEnumerable<DataRow> GetSubCategory(string category)
        {
            database db = new database();
            db.ClearParameters();
            db.SPName = "spGetSubCategory";
            db.AddParameter("@category", SqlDbType.VarChar, category);
            DataSet ds = db.ExecuteSP();

            db.Dispose();
            return ds.Tables[0].Rows.Cast<System.Data.DataRow>();
        }

        public static IEnumerable<DataRow> GetBrand(string search)
        {
            database db = new database();
            db.ClearParameters();
            db.SPName = "spGetBrand";
            db.AddParameter("@name", SqlDbType.VarChar, search);
            DataSet ds = db.ExecuteSP();

            db.Dispose();
            return ds.Tables[0].Rows.Cast<System.Data.DataRow>();
        }

        public static IEnumerable<DataRow> GetUoM(string search)
        {
            database db = new database();
            db.ClearParameters();
            db.SPName = "spGetUoM";
            db.AddParameter("@name", SqlDbType.VarChar, search);
            DataSet ds = db.ExecuteSP();

            db.Dispose();
            return ds.Tables[0].Rows.Cast<System.Data.DataRow>();
        }

        public static IEnumerable<DataRow> GetSUNItem(string search)
        {
            database db = new database();
            db.ClearParameters();
            db.SPName = "spGetSUNItem";
            db.AddParameter("@name", SqlDbType.VarChar, search);
            DataSet ds = db.ExecuteSP();

            db.Dispose();
            return ds.Tables[0].Rows.Cast<System.Data.DataRow>();
        }

        public static IEnumerable<DataRow> GetSUNSupplier(string search)
        {
            database db = new database();
            db.ClearParameters();
            db.SPName = "spGetSUNSupplier";
            db.AddParameter("@name", SqlDbType.VarChar, search);
            DataSet ds = db.ExecuteSP();

            db.Dispose();
            return ds.Tables[0].Rows.Cast<System.Data.DataRow>();
        }

        public static IEnumerable<DataRow> GetSUNAddress(string search)
        {
            database db = new database();
            db.ClearParameters();
            db.SPName = "spGetSUNAddress";
            db.AddParameter("@name", SqlDbType.VarChar, search);
            DataSet ds = db.ExecuteSP();

            db.Dispose();
            return ds.Tables[0].Rows.Cast<System.Data.DataRow>();
        }

        public static DataTable GetSUNDeliveryAddress()
        {
            database db = new database();
            db.ClearParameters();
            db.SPName = "spGetSUNDeliveryAddress";
            DataSet ds = db.ExecuteSP();

            db.Dispose();
            return ds.Tables[0];
        }

        public static DataTable GetAccountingPeriod()
        {
            database db = new database();
            db.ClearParameters();
            db.SPName = "spGetAccountingPeriod";
            DataSet ds = db.ExecuteSP();

            db.Dispose();
            return ds.Tables[0];
        }

        public static DataTable GetSUNShipment()
        {
            database db = new database();
            db.ClearParameters();
            db.SPName = "spGetSUNShipment";
            DataSet ds = db.ExecuteSP();

            db.Dispose();
            return ds.Tables[0];
        }

        public static DataTable GetDeliveryTerm()
        {
            database db = new database();
            db.ClearParameters();
            db.SPName = "spGetDeliveryTerm";
            DataSet ds = db.ExecuteSP();

            db.Dispose();
            return ds.Tables[0];
        }

        public static DataTable GetSUNTransType()
        {
            database db = new database();
            db.ClearParameters();
            db.SPName = "spGetSUNTransType";
            DataSet ds = db.ExecuteSP();

            db.Dispose();
            return ds.Tables[0];
        }

        public static DataTable GetPOType()
        {
            database db = new database();
            db.ClearParameters();
            db.SPName = "spGetPOType";
            DataSet ds = db.ExecuteSP();

            db.Dispose();
            return ds.Tables[0];
        }

        public static DataTable GetPRType()
        {
            database db = new database();
            db.ClearParameters();
            db.SPName = "spGetPRType";
            DataSet ds = db.ExecuteSP();

            db.Dispose();
            return ds.Tables[0];
        }

        public static DataTable GetPurchaseType()
        {
            database db = new database();
            db.ClearParameters();
            db.SPName = "spGetPurchaseType";
            DataSet ds = db.ExecuteSP();

            db.Dispose();
            return ds.Tables[0];
        }

        public static DataTable GetSubmissionPageType(string id, string module_name)
        {
            database db = new database();
            db.ClearParameters();
            db.SPName = "spGetSubmissionPageType";
            db.AddParameter("@module_id", SqlDbType.VarChar, id);
            db.AddParameter("@module_name", SqlDbType.VarChar, module_name);
            DataSet ds = db.ExecuteSP();

            db.Dispose();
            return ds.Tables[0];
        }

        public static DataTable GetVendorList()
        {
            database db = new database();
            db.ClearParameters();
            db.SPName = "spGetVendor";
            DataSet ds = db.ExecuteSP();

            db.Dispose();
            return ds.Tables[0];
        }

        public static IEnumerable<DataRow> GetVendor(string vendor_name)
        {
            return GetVendor(vendor_name, "");
        }

        public static IEnumerable<DataRow> GetVendor(string vendor_name, string subcategory)
        {
            database db = new database();
            db.ClearParameters();
            db.SPName = "spGetVendor";
            db.AddParameter("@name", SqlDbType.VarChar, vendor_name);
            db.AddParameter("@subcategory", SqlDbType.VarChar, subcategory);
            DataSet ds = db.ExecuteSP();

            db.Dispose();
            return ds.Tables[0].Rows.Cast<System.Data.DataRow>();
        }

        public static string GetVendorCategories(string vendor_id)
        {
            string val = "";
            database db = new database();
            db.ClearParameters();
            db.SPName = "spGetVendorCategories";
            db.AddParameter("@vendor", SqlDbType.VarChar, vendor_id);
            DataSet ds = db.ExecuteSP();

            db.Dispose();
            if (ds.Tables[0].Rows.Count > 0)
            {
                val = ds.Tables[0].Rows[0][0].ToString();
            }
            return val;
        }

        public static DataTable GetVendorCategoryList(string categories)
        {
            string val = "";
            database db = new database();
            db.ClearParameters();
            db.SPName = "spGetVendorCategoryList";
            db.AddParameter("@categories", SqlDbType.VarChar, categories);
            DataSet ds = db.ExecuteSP();

            db.Dispose();
            return ds.Tables[0];
        }

        public static string GetVendorAddress(string vendor_id)
        {
            string val = "";
            database db = new database();
            db.ClearParameters();
            db.SPName = "spGetVendorAddress";
            db.AddParameter("@vendor", SqlDbType.VarChar, vendor_id);
            DataSet ds = db.ExecuteSP();

            db.Dispose();
            if (ds.Tables[0].Rows.Count > 0)
            {
                val = ds.Tables[0].Rows[0][0].ToString();
            }
            return val;
        }


        public static DataTable GetVendorAddressList(string vendor_id)
        {
            database db = new database();
            db.ClearParameters();
            db.SPName = "spGetVendorAddressList";
            db.AddParameter("@vendor", SqlDbType.VarChar, vendor_id);
            DataSet ds = db.ExecuteSP();
            DataTable dt = new DataTable();
            db.Dispose();
            if (ds.Tables.Count > 0)
            {
                dt = ds.Tables[0];
            }
            return dt;
        }

        public static DataTable GetVendorTax(string vendor_id)
        {
            database db = new database();
            db.ClearParameters();
            db.SPName = "spGetVendorTax";
            db.AddParameter("@vendor", SqlDbType.VarChar, vendor_id);
            DataSet ds = db.ExecuteSP();
            DataTable dt = new DataTable();
            db.Dispose();
            if (ds.Tables.Count > 0)
            {
                dt = ds.Tables[0];
            }
            return dt;
        }

        public static DataTable GetProductCategoryList(string products)
        {
            database db = new database();
            db.ClearParameters();
            db.SPName = "spGetProductCategoryList";
            db.AddParameter("@products", SqlDbType.VarChar, products);
            DataSet ds = db.ExecuteSP();

            db.Dispose();
            return ds.Tables[0];
        }

        public static DataTable GetSUNItemDetail(string code)
        {
            database db = new database();
            db.ClearParameters();
            db.SPName = "spGetSUNItemDetail";
            db.AddParameter("@code", SqlDbType.VarChar, code);
            DataSet ds = db.ExecuteSP();

            db.Dispose();
            return ds.Tables[0];
        }

        public static DataSet GetSUNSupplierDetail(string code)
        {
            database db = new database();
            db.ClearParameters();
            db.SPName = "spGetSUNSupplierDetail";
            db.AddParameter("@code", SqlDbType.VarChar, code);
            DataSet ds = db.ExecuteSP();

            db.Dispose();
            return ds;
        }

        public static DataTable GetSUNAddressDetail(string code)
        {
            database db = new database();
            db.ClearParameters();
            db.SPName = "spGetSUNAddressDetail";
            db.AddParameter("@code", SqlDbType.VarChar, code);
            DataSet ds = db.ExecuteSP();

            db.Dispose();
            return ds.Tables[0];
        }

        public static DataTable GetANLCode(string category)
        {
            /* 
             * 17 - Supplier business type
             * 18 - Supplier qualification
             * 19 - Supplier tax 1
             * 20 - Supplier tax 2
             */
            database db = new database();
            db.ClearParameters();
            db.SPName = "spGetANLCode";
            db.AddParameter("@cat_id", SqlDbType.VarChar, category);
            DataSet ds = db.ExecuteSP();

            db.Dispose();
            return ds.Tables[0];
        }

        public static DataTable GetSUNSuppPayment()
        {
            database db = new database();
            db.ClearParameters();
            db.SPName = "spGetSUNSuppPayment";
            DataSet ds = db.ExecuteSP();

            db.Dispose();
            return ds.Tables[0];
        }

        public static DataTable GetSUNStatus()
        {
            database db = new database();
            db.ClearParameters();
            db.SPName = "spGetSUNStatus";
            DataSet ds = db.ExecuteSP();

            db.Dispose();
            return ds.Tables[0];
        }

        public static DataTable GetEmployee()
        {
            database db = new database();
            db.ClearParameters();
            db.SPName = "spGETEmployee";
            DataSet ds = db.ExecuteSP();

            db.Dispose();
            return ds.Tables[0];
        }

        public static DataTable GetEmployee(string user_id)
        {
            database db = new database();
            db.ClearParameters();
            db.SPName = "spGetAllEmployee";
            db.AddParameter("@user_id", SqlDbType.VarChar, user_id);
            DataSet ds = db.ExecuteSP();

            db.Dispose();
            return ds.Tables[0];
        }

        public static DataTable GetCIFOROffice()
        {
            return GetCIFOROffice("");
        }

        public static DataTable GetCIFOROffice(string user_id, bool is_lead = false, bool is_country_lead = false)
        {
            database db = new database();
            db.ClearParameters();
            db.SPName = "spGetCIFOROffice";
            db.AddParameter("@user_id", SqlDbType.VarChar, user_id);
            db.AddParameter("@isLead", SqlDbType.Bit, is_lead);
            db.AddParameter("@isCountryLead", SqlDbType.Bit, is_country_lead);
            DataSet ds = db.ExecuteSP();

            db.Dispose();
            return ds.Tables[0];
        }

        public static DataTable GetCIFOROfficeByUserIdFinance(string user_id)
        {
            database db = new database();
            bool isFinance = true;
            db.ClearParameters();
            db.SPName = "spGetCIFOROffice";
            db.AddParameter("@user_id", SqlDbType.VarChar, user_id);
            db.AddParameter("@isFinance", SqlDbType.Bit, isFinance);
            DataSet ds = db.ExecuteSP();

            db.Dispose();
            return ds.Tables[0];
        }

        public static DataTable GetRequesterCIFOROffice(string user_id)
        {
            database db = new database();
            db.ClearParameters();
            db.SPName = "spGetRequesterCIFOROffice";
            db.AddParameter("@user_id", SqlDbType.VarChar, user_id);
            DataSet ds = db.ExecuteSP();

            db.Dispose();
            return ds.Tables[0];
        }

        public static DataTable GetCurrency()
        {
            database db = new database();
            db.ClearParameters();
            db.SPName = "spGetSUNCurrency";
            DataSet ds = db.ExecuteSP();

            db.Dispose();
            return ds.Tables[0];
        }

        public static DataTable GetSUNCostCenter()
        {
            database db = new database();
            db.ClearParameters();
            db.SPName = "spGetSUNCostCenter";
            DataSet ds = db.ExecuteSP();

            db.Dispose();
            return ds.Tables[0];
        }

        public static IEnumerable<DataRow> GetSUNT4(string code)
        {
            database db = new database();
            db.ClearParameters();
            db.SPName = "spGetSUNT4";
            db.AddParameter("@StartWith", SqlDbType.VarChar, code);
            DataSet ds = db.ExecuteSP();

            db.Dispose();
            return ds.Tables[0].Rows.Cast<System.Data.DataRow>();
        }

        public static DataTable GetEntity(string costCenterID)
        {
            database db = new database();
            db.ClearParameters();
            db.SPName = "spGetEntity";
            db.AddParameter("@CostCenterID", SqlDbType.VarChar, costCenterID == string.Empty ? null : costCenterID);
            DataSet ds = db.ExecuteSP();

            db.Dispose();
            return ds.Tables[0];
        }

        public static string GetMinimumDate(string date, string additional)
        {
            database db = new database();
            db.ClearParameters();
            db.SPName = "spGetMinimumDate";
            db.AddParameter("@date", SqlDbType.Date, DateTime.Parse(date));
            if (!String.IsNullOrEmpty(additional) && isNumeric(additional))
            {
                db.AddParameter("@additional", SqlDbType.VarChar, additional);
            }
            db.AddParameter("@dutypost", SqlDbType.VarChar, DBNull.Value);
            DataSet ds = db.ExecuteSP();

            db.Dispose();
            return ds.Tables[0].Rows[0][0].ToString();
        }
        public static string GetMinimumDate(string date, string additional, string legalEntityId)
        {
            database db = new database();
            db.ClearParameters();
            db.SPName = "spGetMinimumDate";
            db.AddParameter("@date", SqlDbType.Date, DateTime.Parse(date));
            if (!String.IsNullOrEmpty(additional) && isNumeric(additional))
            {
                db.AddParameter("@additional", SqlDbType.VarChar, additional);
            }
            db.AddParameter("@dutypost", SqlDbType.VarChar, legalEntityId);
            DataSet ds = db.ExecuteSP();

            db.Dispose();
            return ds.Tables[0].Rows[0][0].ToString();
        }

        public static DataTable GetSearchItem(string general, string brand, string description)
        {
            database db = new database();
            db.ClearParameters();
            db.SPName = "spGetItem";
            db.AddParameter("@general", SqlDbType.VarChar, general);
            DataSet ds = db.ExecuteSP();

            db.Dispose();
            return ds.Tables[0];
        }

        public static Boolean isNumeric(string number)
        {
            int i = 0;
            return int.TryParse(number, out i);
        }

        public static string GetFileUrl(string type, string id, string filename)
        {
            string url = GetSetting(type + "_File_Url");
            return url + id + "/" + filename;
        }

        public static string NormalizeString(string text)
        {
            text = text.Replace("''", "'");
            text = text.Replace("'", "&apos;");
            text = text.Replace("\"", "&quot;");
            //text = HttpUtility.HtmlEncode(text);
            return text;
        }

        public class Comment
        {
            public static string Save(DataModel.Comment comment)
            {
                database db = new database();
                db.ClearParameters();

                db.SPName = "dbo.spComments_Save";
                db.AddParameter("@module_name", SqlDbType.NVarChar, comment.module_name);
                db.AddParameter("@module_id", SqlDbType.NVarChar, comment.module_id);
                db.AddParameter("@emp_user_id", SqlDbType.NVarChar, GetLogonUsername());
                db.AddParameter("@roles", SqlDbType.NVarChar, comment.roles);
                db.AddParameter("@action_taken", SqlDbType.NVarChar, comment.action_taken.ToUpper());
                db.AddParameter("@comment", SqlDbType.NVarChar, comment.comment);
                db.AddParameter("@comment_file", SqlDbType.NVarChar, comment.comment_file);
                db.AddParameter("@activity_id", SqlDbType.NVarChar, comment.activity_id);

                DataSet ds = db.ExecuteSP();
                db.Dispose();

                return ds.Tables[0].Rows[0][0].ToString();
            }

            public static DataTable GetData(string id, string module)
            {
                database db = new database();
                db.ClearParameters();

                db.SPName = "dbo.spComments_GetData";
                db.AddParameter("@module_id", SqlDbType.NVarChar, id);
                db.AddParameter("@module_name", SqlDbType.NVarChar, module);
                db.AddParameter("@web_url", SqlDbType.NVarChar, statics.GetSetting("path_url"));

                DataSet ds = db.ExecuteSP();
                db.Dispose();

                return ds.Tables[0];
            }

            public static List<DataModel.Comment> GetDataIntoCommentObject(string id, string module)
            {
                List<DataModel.Comment> ret = new List<DataModel.Comment>();
                database db = new database();
                db.ClearParameters();

                db.SPName = "dbo.spComments_GetData";
                db.AddParameter("@module_id", SqlDbType.NVarChar, id);
                db.AddParameter("@module_name", SqlDbType.NVarChar, module);
                db.AddParameter("@web_url", SqlDbType.NVarChar, statics.GetSetting("path_url"));

                DataSet ds = db.ExecuteSP();
                db.Dispose();

                if (ds != null)
                {
                    if (ds.Tables[0] != null && ds.Tables[0].Rows.Count > 0)
                    {
                        foreach (DataRow dr in ds.Tables[0].Rows)
                        {
                            DataModel.Comment com = new DataModel.Comment();
                            com.id = dr["id"].ToString();
                            com.module_name = dr["module_name"].ToString();
                            com.module_id = dr["module_id"].ToString();
                            com.emp_user_id = dr["emp_user_id"].ToString();
                            com.roles = dr["roles"].ToString();
                            com.created_date = dr["created_date"].ToString();
                            com.action_taken = dr["action_taken"].ToString();
                            com.comment = dr["comment"].ToString();
                            com.comment_file = dr["comment_file"].ToString();
                            com.approval_no = dr["approval_no"].ToString();
                            com.activity_id = dr["activity_id"].ToString();

                            ret.Add(com);
                        }
                    }
                }

                return ret;
            }
        }

        public class Attachment
        {
            public static Boolean Save(DataModel.Attachment attachment)
            {
                database db = new database();
                db.ClearParameters();

                db.SPName = "dbo.spAttachment_Save";
                db.AddParameter("@id", SqlDbType.NVarChar, attachment.id);
                db.AddParameter("@filename", SqlDbType.NVarChar, attachment.filename);
                db.AddParameter("@file_description", SqlDbType.NVarChar, attachment.file_description);
                db.AddParameter("@document_type", SqlDbType.NVarChar, attachment.document_type);
                db.AddParameter("@document_id", SqlDbType.NVarChar, attachment.document_id);
                db.AddParameter("@is_provide_file", SqlDbType.NVarChar, (attachment.is_provide_file == "1") ? "1" : "0");

                DataSet ds = db.ExecuteSP();
                db.Dispose();

                return true;
            }

            public static Boolean SaveNew(DataModel.Attachment attachment)
            {
                database db = new database();
                db.ClearParameters();

                db.SPName = "dbo.spAttachment_Save_new";
                db.AddParameter("@id", SqlDbType.NVarChar, attachment.id);
                db.AddParameter("@filename", SqlDbType.NVarChar, attachment.filename);
                db.AddParameter("@file_description", SqlDbType.NVarChar, attachment.file_description);
                db.AddParameter("@document_type", SqlDbType.NVarChar, attachment.document_type);
                db.AddParameter("@document_id", SqlDbType.NVarChar, attachment.document_id);
                db.AddParameter("@is_provide_file", SqlDbType.NVarChar, (attachment.is_provide_file == "1") ? "1" : "0");
                db.AddParameter("@change_time", SqlDbType.NVarChar, attachment.change_time);

                DataSet ds = db.ExecuteSP();
                db.Dispose();

                return true;
            }

            public static Boolean Delete(string id)
            {
                database db = new database();
                db.ClearParameters();

                db.SPName = "dbo.spAttachment_Delete";
                db.AddParameter("@id", SqlDbType.NVarChar, id);

                DataSet ds = db.ExecuteSP();
                db.Dispose();

                return true;
            }
        }

        public class CostCenter
        {
            public static Boolean Save(DataModel.PurchaseRequisitionDetailCostCenter costCenter)
            {
                database db = new database();
                db.ClearParameters();

                db.SPName = "dbo.spCostCenter_Save";
                db.AddParameter("@id", SqlDbType.NVarChar, costCenter.id);
                db.AddParameter("@pr_id", SqlDbType.NVarChar, costCenter.pr_id);
                db.AddParameter("@pr_detail_id", SqlDbType.NVarChar, costCenter.pr_detail_id);
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
                db.AddParameter("@is_trigger_audit", SqlDbType.Bit, costCenter.is_trigger_audit);
                //db.AddParameter("@is_active", SqlDbType.NVarChar, (costCenter.is_active == "1") ? "1" : "0");

                DataSet ds = db.ExecuteSP();
                db.Dispose();

                return true;
            }

            public static Boolean Delete(string id)
            {
                database db = new database();
                db.ClearParameters();

                db.SPName = "dbo.spCostCenter_Delete";
                db.AddParameter("@id", SqlDbType.NVarChar, id);

                DataSet ds = db.ExecuteSP();
                db.Dispose();

                return true;
            }
        }

        public static DataModel.LatestActivity GetLatestActivity(string module_id, string module_name)
        {
            DataModel.LatestActivity activity = new DataModel.LatestActivity();
            activity.activity_id = "";
            activity.action = "";

            database db = new database();
            db.ClearParameters();

            db.SPName = "dbo.spGetLatestActivity";
            db.AddParameter("@module_id", SqlDbType.NVarChar, module_id);
            db.AddParameter("@module_name", SqlDbType.NVarChar, module_name);

            DataSet ds = db.ExecuteSP();
            db.Dispose();

            if (ds.Tables[0].Rows.Count > 0)
            {
                activity.activity_id = ds.Tables[0].Rows[0]["activity_id"].ToString();
                activity.action = ds.Tables[0].Rows[0]["action_taken"].ToString();
            }
            return activity;
        }

        public static Boolean CheckRequestEditable(string module_id, string module_name, string sn)
        {
            database db = new database();
            db.ClearParameters();

            db.SPName = "dbo.spCheckRequestEditable";
            db.AddParameter("@module_id", SqlDbType.NVarChar, module_id);
            db.AddParameter("@module_name", SqlDbType.NVarChar, module_name);
            db.AddParameter("@sn", SqlDbType.NVarChar, sn);
            db.AddParameter("@user_id", SqlDbType.NVarChar, GetLogonUsername());

            DataSet ds = db.ExecuteSP();
            db.Dispose();

            return Boolean.Parse(ds.Tables[0].Rows[0][0].ToString());
        }

        public static Boolean CheckActiveRequester(string user_id)
        {
            return CheckActiveRequester("", "", user_id);
        }

        public static Boolean CheckActiveRequester(string module_id, string module_name)
        {
            return CheckActiveRequester(module_id, module_name, "");
        }

        public static Boolean CheckActiveRequester(string module_id, string module_name, string user_id)
        {
            database db = new database();
            db.ClearParameters();

            db.SPName = "dbo.spCheckActiveRequester";
            db.AddParameter("@module_id", SqlDbType.NVarChar, module_id);
            db.AddParameter("@module_name", SqlDbType.NVarChar, module_name);
            db.AddParameter("@user_id", SqlDbType.NVarChar, user_id);

            DataSet ds = db.ExecuteSP();
            db.Dispose();

            return Boolean.Parse(ds.Tables[0].Rows[0][0].ToString());
        }

        public class LifeCycle
        {
            public static Boolean Save(string module_id, string module_name, string status_id)
            {
                database db = new database();
                db.ClearParameters();

                db.SPName = "dbo.spLifecycle_Save";
                db.AddParameter("@module_id", SqlDbType.NVarChar, module_id);
                db.AddParameter("@module_name", SqlDbType.NVarChar, module_name);
                db.AddParameter("@status_id", SqlDbType.NVarChar, status_id);
                db.AddParameter("@user_id", SqlDbType.NVarChar, GetLogonUsername());

                DataSet ds = db.ExecuteSP();
                db.Dispose();

                return true;
            }

            public static DataTable GetData(string module_id, string module_name)
            {
                DataTable dt = new DataTable();
                database db = new database();
                db.ClearParameters();

                db.SPName = "dbo.spLifecycle_GetData";
                db.AddParameter("@module_id", SqlDbType.NVarChar, module_id);
                db.AddParameter("@module_name", SqlDbType.NVarChar, module_name);

                DataSet ds = db.ExecuteSP();
                db.Dispose();

                if (ds.Tables.Count > 0)
                {
                    dt = ds.Tables[0];
                }
                return dt;
            }
        }

        public static DataTable GetModuleStatus(string module_name, string all)
        {
            DataTable dt = new DataTable();
            database db = new database();
            db.ClearParameters();

            db.SPName = "dbo.spGetModuleStatus";
            db.AddParameter("@module_name", SqlDbType.NVarChar, module_name);
            db.AddParameter("@all", SqlDbType.NVarChar, all);

            DataSet ds = db.ExecuteSP();
            db.Dispose();

            if (ds.Tables.Count > 0)
            {
                dt = ds.Tables[0];
            }
            return dt;
        }

        public static void K2_AddApproveState(string ID, string Module, string Activity_ID)
        {
            DataTable dt = new DataTable();
            database db = new database();
            db.ClearParameters();

            db.SPName = "dbo.K2_AddApproveState";
            db.AddParameter("@module_id", SqlDbType.NVarChar, ID);
            db.AddParameter("@module", SqlDbType.NVarChar, Module.Replace(" ", ""));
            db.AddParameter("@activity_id", SqlDbType.NVarChar, Activity_ID);
            db.AddParameter("@emp_user_id", SqlDbType.NVarChar, GetLogonUsername());

            DataSet ds = db.ExecuteSP();
            db.Dispose();
        }

        public static DataModel.ApprovalNotes K2_GetApprovalNotes(string Module, string Activity_ID, string SN)
        {
            DataTable dt = new DataTable();
            database db = new database();
            db.ClearParameters();

            db.SPName = "dbo.K2_GetApprovalNotes";
            db.AddParameter("@module", SqlDbType.NVarChar, Module.Replace(" ", ""));
            db.AddParameter("@activity_id", SqlDbType.NVarChar, Activity_ID);
            db.AddParameter("@emp_user_id", SqlDbType.NVarChar, GetLogonUsername());
            db.AddParameter("@sn", SqlDbType.NVarChar, SN);

            DataSet ds = db.ExecuteSP();
            db.Dispose();

            DataModel.ApprovalNotes notes = new DataModel.ApprovalNotes();
            if (ds.Tables.Count > 0)
            {
                DataTable dtA = ds.Tables[0];
                notes.activity_name = dtA.Rows[0]["activity_name"].ToString();
                notes.activity_desc = dtA.Rows[0]["activity_description"].ToString();
            }

            return notes;
        }

        public static List<String> K2_GetMultiSN(string SN)
        {
            DataTable dt = new DataTable();
            database db = new database();
            db.ClearParameters();

            db.SPName = "dbo.K2_GetMultiSN";
            db.AddParameter("@sn", SqlDbType.NVarChar, SN);

            DataSet ds = db.ExecuteSP();
            db.Dispose();

            List<String> lsn = new List<string>();
            if (ds.Tables.Count > 0)
            {
                foreach (DataRow dr in ds.Tables[0].Rows)
                {
                    lsn.Add(dr["SN"].ToString());
                }
            }

            return lsn;
        }

        public static Boolean isPOLastActivity(string id, string activity_id, string sn)
        {
            string isLast = "0";
            DataTable dt = new DataTable();
            database db = new database();
            db.ClearParameters();

            db.SPName = "dbo.K2_PO_IsLastActivity";
            db.AddParameter("@id", SqlDbType.NVarChar, id);
            db.AddParameter("@activity_id", SqlDbType.NVarChar, activity_id);
            db.AddParameter("@sn", SqlDbType.NVarChar, sn);

            DataSet ds = db.ExecuteSP();
            db.Dispose();

            if (ds.Tables.Count > 0)
            {
                foreach (DataRow dr in ds.Tables[0].Rows)
                {
                    isLast = dr["is_last"].ToString();
                }
            }

            return isLast == "1" ? true : false;
        }

        public static Boolean isInWorkflow(string id, string module)
        {
            string isInWorkflow = "false";
            DataTable dt = new DataTable();
            database db = new database();
            db.ClearParameters();

            db.SPName = "dbo.spIsInWorkflow";
            db.AddParameter("@id", SqlDbType.NVarChar, id);
            db.AddParameter("@module", SqlDbType.NVarChar, module);

            DataSet ds = db.ExecuteSP();
            db.Dispose();

            if (ds.Tables.Count > 0)
            {
                foreach (DataRow dr in ds.Tables[0].Rows)
                {
                    isInWorkflow = dr["isinworkflow"].ToString();
                }
            }

            return Boolean.Parse(isInWorkflow);
        }

        public static IEnumerable<DataRow> GetRFQSession(string search)
        {
            database db = new database();
            db.ClearParameters();
            db.SPName = "spGetRFQSession";
            db.AddParameter("@rfq_no", SqlDbType.VarChar, search);
            DataSet ds = db.ExecuteSP();

            db.Dispose();
            return ds.Tables[0].Rows.Cast<System.Data.DataRow>();
        }

        public static DataTable GetSpecificExchangeRate(string destination, string source, string date)
        {
            database db = new database();
            db.ClearParameters();
            db.SPName = "spGetConvertRate";
            db.AddParameter("@convert_to", SqlDbType.VarChar, destination);
            db.AddParameter("@source", SqlDbType.VarChar, source);
            db.AddParameter("@period", SqlDbType.VarChar, date);
            DataSet ds = db.ExecuteSP();

            db.Dispose();
            return ds.Tables[0];
        }

        public static void GenerateExcelFile(DataSet ds, string filename, List<string> titles, List<string> worksheets, string extension)
        {
            ExcelPackage package = new ExcelPackage();

            int index = 0;
            foreach (DataTable dt in ds.Tables)
            {
                dt.Columns.RemoveAt(0);
                dt.AcceptChanges();

                string wsname = "";
                try
                {
                    wsname = worksheets[index];
                }
                catch (Exception ex)
                {
                    //no exception
                }

                string title = "";
                try
                {
                    title = titles[index];
                }
                catch (Exception ex)
                {
                    //no exception
                }

                var worksheet = package.Workbook.Worksheets.Add(wsname);
                var startColumn = 1;
                var startRows = 1;
                if (title != "")
                {
                    var titleCells = worksheet.Cells[1, 1, 1, dt.Columns.Count];
                    titleCells.Merge = true;
                    titleCells.Value = title;
                    titleCells.Style.Font.Bold = true;
                    startColumn = 3;
                    startRows = 3;
                }

                worksheet.Cells[startColumn, 1].LoadFromDataTable(dt, true);
                worksheet.Cells[worksheet.Dimension.Address.ToString()].AutoFitColumns();

                var headerCells = worksheet.Cells[startRows, 1, startRows, dt.Columns.Count];
                var fill = headerCells.Style.Fill;
                fill.PatternType = ExcelFillStyle.Solid;
                fill.BackgroundColor.SetColor(System.Drawing.Color.Gray);

                index++;
            }

            HttpContext.Current.Response.Clear();
            HttpContext.Current.Response.ContentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
            HttpContext.Current.Response.AddHeader("Content-Disposition", string.Format("attachment;filename={0}.{1}", filename, extension));
            HttpContext.Current.Response.BinaryWrite(package.GetAsByteArray());
            HttpContext.Current.Response.End();
        }

        public static void GenerateExcelFileBusinessPartnerList(DataTable dt, string filename, string status)
        {

            DataTable dtTemp = dt.Copy();
            string[] UserColumns = { "company_code", "sun_code", "company_name", "address", "categories", "vendor_active_label", "contact_person", "position", "cell_phone", "work_phone", "fax", "email" };

            foreach (DataColumn s in dtTemp.Columns.Cast<DataColumn>().Where(x => !UserColumns.Contains(x.ColumnName.ToLower())).ToList())
            {
                dtTemp.Columns.Remove(s.ColumnName);
            }
            for (int i = 0; i < UserColumns.Length; i++)
            {
                dtTemp.Columns[UserColumns[i]].SetOrdinal(i);
            }
            switch (status)
            {
                case "1":
                    status = "Active";
                    break;
                case "0":
                    status = "InActive";
                    break;
                default:
                    status = "All";
                    break;
            }
            foreach (DataColumn dc in dtTemp.Columns)
            {

                switch (dc.ToString())
                {

                    case "company_code":
                        dc.ColumnName = "Code";
                        break;
                    case "sun_code":
                        dc.ColumnName = "OCS supplier code";
                        break;
                    case "company_name":
                        dc.ColumnName = "Name";
                        break;
                    case "address":
                        dc.ColumnName = "Address";
                        break;
                    case "categories":
                        dc.ColumnName = "Category(s) and Sub category(s)";
                        break;
                    case "vendor_active_label":
                        dc.ColumnName = "Status";
                        break;
                    case "contact_person":
                        dc.ColumnName = "Contact person";
                        break;
                    case "position":
                        dc.ColumnName = "Position";
                        break;
                    case "cell_phone":
                        dc.ColumnName = "Cell phone";
                        break;
                    case "work_phone":
                        dc.ColumnName = "Work phone";
                        break;
                    case "fax":
                        dc.ColumnName = "Fax";
                        break;
                    case "Email":
                        dc.ColumnName = "Emial";
                        break;
                }
                dtTemp.AcceptChanges();
            }

            ExcelPackage package = new ExcelPackage();
            var worksheet = package.Workbook.Worksheets.Add("Business partner" + status);
            worksheet.Cells[1, 1].LoadFromDataTable(dtTemp, true);
            worksheet.Cells[worksheet.Dimension.Address.ToString()].AutoFitColumns();
            worksheet.Cells[worksheet.Dimension.Address.ToString()].AutoFilter = true;
            var headerCells = worksheet.Cells[1, 1, 1, dtTemp.Columns.Count];
            var fill = headerCells.Style.Fill;

            fill.PatternType = ExcelFillStyle.Solid;
            fill.BackgroundColor.SetColor(System.Drawing.Color.LightBlue);

            //byte[] fileContents = package.GetAsByteArray();
            //string excelName = $"{filename + status}-{DateTime.Now.ToString("yyyyMMddHHmmssfff")}.xlsx";
            //return File(
            //        fileContents: fileContents,
            //        contentType: "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
            //        fileDownloadName: excelName
            //    );

            HttpContext.Current.Response.Clear();
            HttpContext.Current.Response.ContentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
            HttpContext.Current.Response.AddHeader("Content-Disposition", string.Format("attachment;filename={0}.xlsx", filename + status + DateTime.Now.ToString("yyyyMMddHHmmssfff")));
            HttpContext.Current.Response.BinaryWrite(package.GetAsByteArray());
            HttpContext.Current.Response.End();
        }

        /* Task registration */
        public static DataTable GetTaskUsers()
        {
            database db = new database();
            db.ClearParameters();
            db.SPName = "spTasklistForAdmin_GetList";
            DataSet ds = db.ExecuteSP();

            db.Dispose();
            return ds.Tables[0];
        }

        public static void SaveTaskUser(string id, string emp_user_id, string is_active)
        {
            database db = new database();
            db.ClearParameters();
            db.SPName = "spTasklistForAdmin_Save";
            db.AddParameter("@id", SqlDbType.VarChar, id);
            db.AddParameter("@emp_user_id", SqlDbType.VarChar, emp_user_id);
            db.AddParameter("@is_active", SqlDbType.VarChar, is_active);
            db.AddParameter("@user_id", SqlDbType.VarChar, GetLogonUsername());
            DataSet ds = db.ExecuteSP();

            db.Dispose();
        }

        public static DataTable GetTaskUnregisteredEmployee()
        {
            database db = new database();
            db.ClearParameters();
            db.SPName = "spTasklistForAdmin_GetUnregisteredEmployee";
            DataSet ds = db.ExecuteSP();

            db.Dispose();
            return ds.Tables[0];
        }

        public static DataTable GetSupplierAddress()
        {
            database db = new database();
            db.ClearParameters();
            db.SPName = "spGetSupplierAddress";
            DataSet ds = db.ExecuteSP();

            db.Dispose();
            return ds.Tables[0];
        }

        public static DataTable GetPaymentTerm()
        {
            database db = new database();
            db.ClearParameters();
            db.SPName = "spGetPaymentTerm";
            DataSet ds = db.ExecuteSP();

            db.Dispose();
            return ds.Tables[0];
        }

        public static DataTable GetPurchaseRequisitionDetailById(string Id)
        {
            database db = new database();
            db.ClearParameters();
            db.SPName = "sp_PurchaseRequisition_GetPurchaseRequisitionDetailById";
            db.AddParameter("@Id", SqlDbType.VarChar, Id);
            DataSet ds = db.ExecuteSP();

            db.Dispose();
            return ds.Tables[0];
        }

        public static DataTable GetPurchaseRequisitionOfficeById(string Id)
        {
            DataTable res = new DataTable();
            database db = new database();
            try
            {
                db.ClearParameters();

                db.SPName = "sp_PurchaseRequisition_GetPurchaseRequisitionOfficeById";
                db.AddParameter("@Id", SqlDbType.NVarChar, Id);
                DataSet ds = db.ExecuteSP();

                if (ds.Tables.Count > 0)
                {
                    if (ds.Tables[0].Rows.Count > 0)
                    {
                        res = ds.Tables[0];
                    }
                }
            }
            catch (Exception x) { throw new Exception(x.Message); }
            finally { db.Dispose(); }

            return res;
        }

        public static string GetPurchaseRequisitionOfficeNameById(string Id)
        {
            string res = "Unspecified purchase office";
            DataTable purchaseOffData = GetPurchaseRequisitionOfficeById(Id);
            if (purchaseOffData != null)
            {
                if (purchaseOffData.Rows.Count > 0)
                {
                    if (!string.IsNullOrEmpty(purchaseOffData.Rows[0]["Name"].ToString()))
                    {
                        res = purchaseOffData.Rows[0]["Name"].ToString();
                    }
                }
            }

            return res;
        }

        public static string GetCostCenterIdByUserId(string userId)
        {
            string res = "";

            database db = new database();
            try
            {
                db.ClearParameters();

                db.SPName = "sp_PurchaseRequisition_GetCostCenterIdByUserId";
                db.AddParameter("@UserId", SqlDbType.NVarChar, userId);
                DataSet ds = db.ExecuteSP();

                if (ds.Tables.Count > 0)
                {
                    if (ds.Tables[0].Rows.Count > 0)
                    {
                        if (!string.IsNullOrEmpty(ds.Tables[0].Rows[0]["CostCenters"].ToString()))
                        {
                            res = ds.Tables[0].Rows[0]["CostCenters"].ToString();
                        }
                    }
                }
            }
            catch (Exception x) { throw new Exception(x.Message); }
            finally { db.Dispose(); }

            return res;
        }

        public static void AddLogForApps(string prId)
        {
            database db = new database();
            try
            {
                db.ClearParameters();

                db.SPName = "K2_PR_AddToLog";
                db.AddParameter("@id", SqlDbType.NVarChar, prId);
                DataSet ds = db.ExecuteSP();

            }
            catch (Exception x) { throw new Exception(x.Message); }
            finally { db.Dispose(); }
        }

        public static string SaveOCSMFLQueue(string sourceName,string sourceId,string po_no,string status,string remark)
        {
            database db = new database(ConfigurationSettings.AppSettings["database_server"], "dbIntegratedPortal");
            db.ClearParameters();

            db.SPName = "dbo.spOCSMFLQueue_Save";
            //db.AddParameter("@id", SqlDbType.NVarChar, id);
            db.AddParameter("@MyTreeReferenceNo", SqlDbType.NVarChar, po_no);
            db.AddParameter("@SourceName", SqlDbType.NVarChar, sourceName);
            db.AddParameter("@SourceId", SqlDbType.NVarChar, sourceId);
            db.AddParameter("@UserId", SqlDbType.NVarChar, GetLogonUsername());
            db.AddParameter("@DueTime", SqlDbType.NVarChar, ConfigurationSettings.AppSettings["mfl_due_time"]);
            db.AddParameter("@Status", SqlDbType.NVarChar, status);
            db.AddParameter("@Remark", SqlDbType.NVarChar, remark);

            DataSet ds = db.ExecuteSP();
            db.Dispose();

            string output = "";

            return output;
        }

        public static DataTable GetCIFOROfficeWithParamLead(string user_id, bool isLead)
        {
            database db = new database();
            db.ClearParameters();
            db.SPName = "spGetCIFOROfficeForTasklistSummary";
            db.AddParameter("@user_id", SqlDbType.VarChar, user_id);
            db.AddParameter("@isLead", SqlDbType.Bit, isLead);
            DataSet ds = db.ExecuteSP();

            db.Dispose();
            return ds.Tables[0];
        }

        public static DataTable GetProcurementOfficeTeamLeader()
        {
            DataTable result = new DataTable();

            database db = new database();
            db.ClearParameters();
            db.SPName = "sp_General_GetProcurementOfficeTeamLeader";
            DataSet ds = db.ExecuteSP();

            db.Dispose();
            if (ds.Tables != null)
            {
                if (ds.Tables[0].Rows.Count > 0)
                {
                    result = ds.Tables[0];
                }
            }
            return result;
        }

        public static DataTable CheckSupplier(string vendor_id)
        {
            int number = 1;

            database db = new database();
            db.ClearParameters();
            db.SPName = "spCheckSupplier";
            db.AddParameter("@vendor_id", SqlDbType.NVarChar, vendor_id);
            DataSet ds = db.ExecuteSP();

            db.Dispose();
            return ds.Tables[0];
        }

        public static DataTable GetLegalEntity()
        {
            database db = new database();
            db.ClearParameters();
            db.SPName = "spGetLegalEntity";
            DataSet ds = db.ExecuteSP();

            db.Dispose();
            return ds.Tables[0];
        }

        public static DataTable GetEmailProcurementOffice(string office)
        {
            database db = new database();
            db.ClearParameters();
            db.SPName = "spGetEmailProcurementOffice";
            db.AddParameter("@office_id", SqlDbType.NVarChar, office);
            DataSet ds = db.ExecuteSP();

            db.Dispose();
            return ds.Tables[0];
        }

        public static DataTable GetProcurementOffice(string office)
        {
            database db = new database();
            db.ClearParameters();
            db.SPName = "spGetProcurementOffice";
            db.AddParameter("@office_id", SqlDbType.NVarChar, office);
            DataSet ds = db.ExecuteSP();

            db.Dispose();
            return ds.Tables[0];
        }

        public static DataTable GetProcurementOfficeAddress()
        {
            database db = new database();
            db.ClearParameters();
            db.SPName = "spGetProcurementOfficeAddress";
            DataSet ds = db.ExecuteSP();

            db.Dispose();
            return ds.Tables[0];
        }

        public static DataTable GetVendorFirst(string id)
        {
            database db = new database();
            db.ClearParameters();
            db.SPName = "spGetVendor_Data";
            db.AddParameter("@id", SqlDbType.NVarChar, id);
            DataSet ds = db.ExecuteSP();

            db.Dispose();
            return ds.Tables[0];
        }

        public static DataTable GetTax()
        {
            database db = new database();
            db.ClearParameters();
            db.SPName = "spGetTax";
            DataSet ds = db.ExecuteSP();

            db.Dispose();
            return ds.Tables[0];
        }

        public static void SyncAuditTrail(DateTime date, string prDetailId)
        {
            database db = new database();
            try
            {
                db.ClearParameters();

                db.SPName = "spAttachment_SyncToAuditData";
                db.AddParameter("@date", SqlDbType.DateTime, date);
                db.AddParameter("@pr_detail_id", SqlDbType.NVarChar, prDetailId);
                DataSet ds = db.ExecuteSP();

            }
            catch (Exception x) { throw new Exception(x.Message); }
            finally { db.Dispose(); }
        }

        public static void CheckPRDetailAndAttachmentForAuditTrail(string prDetailId)
        {
            database db = new database();
            try
            {
                db.ClearParameters();

                db.SPName = "spAttachment_CheckPRDetailAndAttachmentInAuditData";
                db.AddParameter("@pr_detail_id", SqlDbType.NVarChar, prDetailId);
                DataSet ds = db.ExecuteSP();

            }
            catch (Exception x) { throw new Exception(x.Message); }
            finally { db.Dispose(); }
        }

        public static DataTable GetAddressType()
        {
            database db = new database();
            db.ClearParameters();
            db.SPName = "spGetAddressType";
            DataSet ds = db.ExecuteSP();

            db.Dispose();
            return ds.Tables[0];
        }

        public static DataTable GetCountry()
        {
            database db = new database();
            db.ClearParameters();
            db.SPName = "spGetCountry";
            DataSet ds = db.ExecuteSP();

            db.Dispose();
            return ds.Tables[0];
        }

        public static DataTable GetProduct()
        {
            database db = new database();
            db.ClearParameters();
            db.SPName = "spGetProduct";
            DataSet ds = db.ExecuteSP();

            db.Dispose();
            return ds.Tables[0];
        }

        public static bool GetUpdatePR(string id)
        {
            database db = new database();
            db.ClearParameters();

            db.SPName = "dbo.spPurchaseRequisition_SetStatusVerified";
            db.AddParameter("@id", SqlDbType.NVarChar, id);
            db.AddParameter("@user_id", SqlDbType.NVarChar, statics.GetLogonUsername());

            DataSet ds = db.ExecuteSP();
            db.Dispose();

            return true;
        }

        public static bool GetResetPR(string id)
        {
            database db = new database();
            db.ClearParameters();

            db.SPName = "dbo.spPurchaseRequisition_ResetPR";
            db.AddParameter("@id", SqlDbType.NVarChar, id);
            db.AddParameter("@user_id", SqlDbType.NVarChar, statics.GetLogonUsername());

            DataSet ds = db.ExecuteSP();
            db.Dispose();

            return true;
        }

        public static bool UpdatePrint(string id, string module)
        {
            database db = new database();
            db.ClearParameters();

            db.SPName = "dbo.spPrint_Update";
            db.AddParameter("@id", SqlDbType.NVarChar, id);
            db.AddParameter("@module", SqlDbType.NVarChar, module);

            DataSet ds = db.ExecuteSP();
            db.Dispose();

            return true;
        }

        //public static DataTable GetTaxSystem()
        //{
        //    database db = new database();
        //    db.ClearParameters();
        //    db.SPName = "spGetTaxSystem";
        //    db.AddParameter("@user_id", SqlDbType.NVarChar, statics.GetLogonUsername());
        //    DataSet ds = db.ExecuteSP();

        //    db.Dispose();
        //    return ds.Tables[0];
        //}
        public static DataTable GetTaxSystem(string office_id)
        {
            database db = new database();
            db.ClearParameters();
            db.SPName = "spGetTaxSystem";
            db.AddParameter("@office_id", SqlDbType.NVarChar, office_id);
            DataSet ds = db.ExecuteSP();

            db.Dispose();
            return ds.Tables[0];
        }

        public static DataTable GetTaxSystemByUserId()
        {
            database db = new database();
            db.ClearParameters();
            db.SPName = "spGetTaxSystemByUserId";
            db.AddParameter("@user_id", SqlDbType.NVarChar, GetLogonUsername());
            DataSet ds = db.ExecuteSP();

            db.Dispose();
            return ds.Tables[0];
        }

        public static DataTable GetProductGroup()
        {
            database db = new database();
            db.ClearParameters();
            db.SPName = "spGetProductGroup";
            DataSet ds = db.ExecuteSP();

            db.Dispose();
            return ds.Tables[0];
        }

        public static DataTable GetJournalDetail(string journal_number)
        {
            database db = new database();
            db.ClearParameters();
            db.SPName = "spGetJournalDetail";
            db.AddParameter("@journal_number", SqlDbType.NVarChar, journal_number);
            DataSet ds = db.ExecuteSP();

            db.Dispose();

            return ds.Tables[0];
        }

        public static DataTable GetMappingAllTaxSystem(string cifor_office)
        {
            database db = new database();
            db.ClearParameters();
            db.SPName = "spGetMappingAllTaxSystem";
            db.AddParameter("@cifor_office", SqlDbType.NVarChar, cifor_office);
            DataSet ds = db.ExecuteSP();

            db.Dispose();

            return ds.Tables[0];
        }

        public static DataTable GetSingleSourceChecklist()
        {
            database db = new database();
            db.ClearParameters();
            db.SPName = "spGetSingleSourceChecklist";
            DataSet ds = db.ExecuteSP();

            db.Dispose();

            return ds.Tables[0];
        }

        public static DataTable GetVSData(string vs_id)
        {
            database db = new database();
            db.ClearParameters();
            db.SPName = "spGetVSData";
            db.AddParameter("@vs_id", SqlDbType.NVarChar, vs_id);
            DataSet ds = db.ExecuteSP();

            db.Dispose();

            return ds.Tables[0];
        }

        public static Boolean SaveFundscheckResult(string module_id, string module_name, string fundscheck_result)
        {
            database db = new database();
            db.ClearParameters();

            db.SPName = "dbo.spFundsCheckResult_Save";
            db.AddParameter("@module_id", SqlDbType.NVarChar, module_id);
            db.AddParameter("@module_name", SqlDbType.NVarChar, module_name);
            db.AddParameter("@fundscheck_result", SqlDbType.NVarChar, fundscheck_result);

            DataSet ds = db.ExecuteSP();
            db.Dispose();

            return true;
        }
    }
}
