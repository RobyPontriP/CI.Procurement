//using myTree.WebForms.K2Helper;
using myTree.WebForms.Procurement.General;
using myTree.WebForms.Procurement.General.K2Helper;
using myTree.WebForms.Procurement.Notification;
using Newtonsoft.Json;
using Serilog;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Services;

namespace myTree.WebForms.Modules.DirectPurchase
{
    public partial class Input : System.Web.UI.Page
    {
        protected string _id = string.Empty, _pr_line_id = string.Empty, listCurrency = string.Empty, listAttachment = string.Empty, source = string.Empty, listSupplierAddress = string.Empty;
        protected string moduleName = "DIRECT PURCHASE";
        protected Boolean isAdmin = false;
        protected Boolean isUser = false;
        protected DataModel.DirectPurchase dp = new DataModel.DirectPurchase();
        protected string service_url, based_url, supplier_id = string.Empty, supplier_address_id = string.Empty, listSundry = "[]"; 
       

        //protected AccessControl authorized = new AccessControl("DIRECT PURCHASE");

        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                //if (!authorized.admin)
                //{
                //    Response.Redirect(authorized.redirectPage);
                //}
                if (!HttpContext.Current.User.Identity.IsAuthenticated)
                {
                    //HttpContext.Current.GetOwinContext().Authentication.Challenge();
                    Log.Information("Session ended re-challenge...");
                }

                //isAdmin = true;
                //isUser = true;
                UserRoleAccess userRoleAccess = AccessControl.GetUserRoleAccess(AccessControlObjectEnum.ProcurementDirectPurchase);

                if (!userRoleAccess.isCanWrite)
                {
                    Response.Redirect(AccessControl.GetSetting("access_denied"));
                    Log.Information("Don't have access control, redirecting...");
                }

                isAdmin = userRoleAccess.RoleNameInSystem == AccessControlRoleNameEnum.ProcurementLead || userRoleAccess.RoleNameInSystem == AccessControlRoleNameEnum.ProcurementOfficer ? true : false;
                //isUser = userRoleAccess.RoleNameInSystem == AccessControlRoleNameEnum.ProcurementAssistant ? true : false;

                _id = Request.QueryString["id"] ?? "";
                _pr_line_id = Request.QueryString["pr_line_id"] ?? "";
                source = Request.QueryString["source"] ?? "";
                service_url = statics.GetSetting("service_url");
                based_url = statics.GetSetting("based_url");

                dp.attachments = new List<DataModel.Attachment>();

                dp.id = _id;
                dp.pr_line_id = _pr_line_id;

                if (!String.IsNullOrEmpty(_id) || !String.IsNullOrEmpty(_pr_line_id))
                {
                    DataSet ds = staticsPurchaseRequisition.DirectPurchase.GetData(_id, _pr_line_id);
                    DataTable dtPurchase = ds.Tables[0];
                    DataTable dtAttachment = ds.Tables[1];
                    listSundry = JsonConvert.SerializeObject(ds.Tables[2]);
                    if (dtPurchase.Rows.Count > 0)
                    {
                        dp.id = _id;
                        dp.pr_line_id = dtPurchase.Rows[0]["pr_line_id"].ToString();
                        dp.vendor_id = dtPurchase.Rows[0]["vendor_id"].ToString();
                        dp.vendor_address_id = dtPurchase.Rows[0]["vendor_address_id"].ToString();
                        supplier_id = dp.vendor_id;
                        supplier_address_id = dp.vendor_address_id;
                        dp.purchase_currency = dtPurchase.Rows[0]["purchase_currency"].ToString();
                        dp.exchange_sign = dtPurchase.Rows[0]["exchange_sign"].ToString();
                        if (dp.exchange_sign == "/")
                        {
                            dp.exchange_sign_format = "&divide;";
                        }
                        else
                        {
                            dp.exchange_sign_format = "x";
                        }
                        dp.exchange_rate = dtPurchase.Rows[0]["exchange_rate"].ToString().Replace(',', '.');
                        dp.unit_price = dtPurchase.Rows[0]["unit_price"].ToString().Replace(',', '.');
                        dp.total_cost = dtPurchase.Rows[0]["total_cost"].ToString().Replace(',', '.');
                        dp.total_cost_usd = dtPurchase.Rows[0]["total_cost_usd"].ToString().Replace(',', '.');
                        dp.purchase_date = dtPurchase.Rows[0]["purchase_date"].ToString();

                        dp.pr_no = dtPurchase.Rows[0]["pr_no"].ToString();
                        dp.pr_id = dtPurchase.Rows[0]["pr_id"].ToString();
                        dp.pr_currency = dtPurchase.Rows[0]["pr_currency"].ToString();
                        dp.pr_exchange_sign = dtPurchase.Rows[0]["pr_exchange_sign"].ToString();
                        // dp.pr_exchange_rate = String.Format("{0:#,0.000000}", Decimal.Parse( dtPurchase.Rows[0]["pr_exchange_rate"].ToString().Replace(',', '.'))) ?? "0";
                        dp.pr_exchange_rate = dtPurchase.Rows[0]["pr_exchange_rate"].ToString().Replace(',', '.');
                        //dp.pr_unit_price = String.Format("{0:#,0.00}", Decimal.Parse(dtPurchase.Rows[0]["pr_unit_price"].ToString())) ?? "0";
                        dp.pr_unit_price = dtPurchase.Rows[0]["pr_unit_price"].ToString().Replace(',', '.');
                        //dp.pr_total_cost = String.Format("{0:#,0.00}", Decimal.Parse(dtPurchase.Rows[0]["pr_total_cost"].ToString())) ?? "0";
                        dp.pr_total_cost = dtPurchase.Rows[0]["pr_total_cost"].ToString().Replace(',', '.');
                        //dp.pr_total_cost_usd = String.Format("{0:#,0.00}", Decimal.Parse(dtPurchase.Rows[0]["pr_total_cost_usd"].ToString())) ?? "0";
                        dp.pr_total_cost_usd = dtPurchase.Rows[0]["pr_total_cost_usd"].ToString().Replace(',', '.');

                        dp.item_id = dtPurchase.Rows[0]["item_id"].ToString();
                        dp.item_code = dtPurchase.Rows[0]["item_code"].ToString();
                        dp.brand_name = dtPurchase.Rows[0]["brand_name"].ToString();
                        dp.description = dtPurchase.Rows[0]["description"].ToString();
                        dp.purchase_qty = dtPurchase.Rows[0]["request_qty"].ToString().Replace(',', '.');
                        dp.direct_purchase_qty = dtPurchase.Rows[0]["purchase_qty"].ToString();
                        if (!string.IsNullOrEmpty(_pr_line_id))
                        {
                            dp.direct_purchase_qty = dtPurchase.Rows[0]["item_balance"].ToString() == "" ? "0.00" : dtPurchase.Rows[0]["item_balance"].ToString();
                        }
                        dp.vendor_name = dtPurchase.Rows[0]["vendor_name"].ToString();

                        foreach (DataRow dr in dtAttachment.Rows)
                        {
                            DataModel.Attachment attachment = new DataModel.Attachment();
                            attachment.id = dr["id"].ToString();
                            attachment.filename = dr["filename"].ToString();
                            attachment.file_description = statics.NormalizeString(dr["file_description"].ToString());
                            attachment.document_id = dr["document_id"].ToString();
                            attachment.document_type = moduleName;
                            attachment.is_active = dr["is_active"].ToString();

                            dp.attachments.Add(attachment);
                        }
                    }
                }

                if (String.IsNullOrEmpty(dp.purchase_date))
                {
                    dp.purchase_date = DateTime.Now.ToString("dd MMM yyyy");
                }
                else
                {
                    dp.purchase_date = DateTime.Parse(dp.purchase_date).ToString("dd MMM yyyy");
                }

                if (String.IsNullOrEmpty(dp.exchange_sign))
                {
                    dp.exchange_sign_format = "&divide;";
                    dp.exchange_sign = "/";
                    dp.exchange_rate = "0";
                }

                if (String.IsNullOrEmpty(dp.purchase_currency))
                {
                    dp.purchase_currency = dp.pr_currency;
                    dp.exchange_rate = dp.pr_exchange_rate;
                    dp.exchange_sign = dp.pr_exchange_sign;
                }

                listCurrency = JsonConvert.SerializeObject(statics.GetCurrency());
                listAttachment = JsonConvert.SerializeObject(dp.attachments);
                listSupplierAddress = JsonConvert.SerializeObject(statics.GetSupplierAddress());

                //this.recentComment.moduleName = moduleName;
                //this.recentComment.moduleId = _id;
            }
            catch (Exception ex)
            {
                ExceptionHelpers.PrintError(ex);
            }
        }

        [WebMethod]
        public static string Save(string submission, string deleted)
        {
            string result, message = "", _id = "", moduleName = "DIRECT PURCHASE";
            try
            {
                string action = "SAVED";
                DataModel.DirectPurchase dp = JsonConvert.DeserializeObject<DataModel.DirectPurchase>(submission);
                if (!String.IsNullOrEmpty(dp.id)) {
                    action = "UPDATED";
                }
                _id = staticsPurchaseRequisition.DirectPurchase.Save(dp);

                DataModel.Comment comment = new DataModel.Comment();
                comment.module_name = moduleName;
                comment.module_id = _id;
                comment.action_taken = action;
                statics.Comment.Save(comment);

                foreach (DataModel.Attachment attachment in dp.attachments)
                {
                    attachment.document_id = _id;
                    attachment.document_type = moduleName;
                    statics.Attachment.Save(attachment);
                }
                List<DataModel.DeletedId> deletedIds = JsonConvert.DeserializeObject<List<DataModel.DeletedId>>(deleted);
                foreach (DataModel.DeletedId del in deletedIds)
                {
                    if (del.table == "attachment")
                    {
                        statics.Attachment.Delete(del.id);
                    }
                }

                #region sundry

                if (dp.sundry.Count() > 0)
                {
                    foreach (DataModel.SundrySupplier dpsundry in dp.sundry)
                    {
                        if (string.IsNullOrEmpty(dpsundry.id))
                        {
                            DataSet dsundry = staticsMaster.SundrySupplier.GetData(_id, moduleName);

                            foreach (DataRow dm in dsundry.Tables[0].Rows)
                            {
                                if (!string.IsNullOrEmpty(dm["id"].ToString()))
                                {
                                    dpsundry.id = dm["id"].ToString();
                                }
                            }
                        }

                        dpsundry.module_id = _id;
                        dpsundry.module_type = moduleName;
                        staticsMaster.SundrySupplier.Save(dpsundry);
                    }
                }
                else
                {
                    staticsMaster.SundrySupplier.Delete(_id, moduleName);
                }
                #endregion

                result = "success";
            }
            catch (Exception ex)
            {
                result = "error";
                message = ExceptionHelpers.Message(ex);
                ExceptionHelpers.PrintError(ex);
            }
            return JsonConvert.SerializeObject(new
            {
                result = result,
                message = message,
                id = _id
            });
        }
    }
}