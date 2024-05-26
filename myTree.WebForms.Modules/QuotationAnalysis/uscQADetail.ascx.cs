//using Microsoft.AspNet.Identity;
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
using static Procurement.PurchaseOrder.CompiledPO;

namespace myTree.WebForms.Modules.QuotationAnalysis
{
    public partial class uscQADetail : System.Web.UI.UserControl
    {
        protected string _id = string.Empty, vsItems = "[]", vsItemsMain = "[]", supportingDocs = "[]", SSChecklist = "[]", blankmode = string.Empty,_single_sourcing = string.Empty;
        protected string listCurrency = string.Empty, max_status = string.Empty,page_name = string.Empty,user_office = string.Empty, listChargeCode = "[]", listSundry = "[]";
        protected DataModel.VendorSelection VS = new DataModel.VendorSelection();
        protected Boolean isAdmin = false;
        protected Boolean isUser = false;
        protected Boolean isFinance = false;
        protected Boolean isSameOffice = false;
        UserRoleAccess userRoleAccess = AccessControl.GetUserRoleAccess(AccessControlObjectEnum.ProcurementQuotationAnalysis);

        protected string moduleName = "VENDOR SELECTION";
        protected string service_url, based_url = string.Empty;
        protected Boolean isEditable = false;
        protected Boolean isInWorkflow = false;

        private class ItemList
        {
            public string pr_id { get; set; }
            public string pr_detail_id { get; set; }
            public string pr_no { get; set; }
            public string pr_submission_date { get; set; }
            public string cost_center_id { get; set; }
            public string initiator { get; set; }
            public string requester { get; set; }
            public string item_id { get; set; }
            public string item_code { get; set; }
            public string item_description { get; set; }
            public string pr_quantity { get; set; }
            public string vendor_ids { get; set; }
            public string currency_ids { get; set; }
            public string pr_currency { get; set; }
            public string pr_unit_price { get; set; }
            public string uom { get; set; }
            public string qd_description { get; set; }
            public string detail_chargecode { get; set; }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                if (!HttpContext.Current.User.Identity.IsAuthenticated)
                {
                    //HttpContext.Current.GetOwinContext().Authentication.Challenge();
                }
                else
                {
                    string userId = statics.GetLogonUsername();
                    
                    UserRoleAccess userRoleAccess = AccessControl.GetUserRoleAccess(AccessControlObjectEnum.ProcurementQuotationAnalysis);
                    bool isLead = statics.isProcurementLead(userId, userRoleAccess);
                    if (!userRoleAccess.isCanRead)
                    {
                        Response.Redirect(AccessControl.GetSetting("access_denied"));
                        Log.Information("Don't have access control, redirecting...");
                    }

                    isAdmin = userRoleAccess.RoleNameInSystem == AccessControlRoleNameEnum.ProcurementLead || userRoleAccess.RoleNameInSystem == AccessControlRoleNameEnum.ProcurementOfficer ? true : false;
                    isUser = userRoleAccess.RoleNameInSystem == AccessControlRoleNameEnum.ProcurementAssistant || userRoleAccess.RoleNameInSystem == AccessControlRoleNameEnum.User ? true : false;
                    isFinance = userRoleAccess.RoleNameInSystem == AccessControlRoleNameEnum.Finance ? true : false;

                    _id = Request.QueryString["id"] ?? "";
                    _single_sourcing = Request.QueryString["singlesourcing"] ?? "";

                    user_office = Service.GetProcurementOfficeByOfficerId(userId, isLead);
                    DataTable dtOffice = statics.GetCIFOROffice(userId, isLead);
                    if (dtOffice.Rows.Count == 1)
                    {
                        user_office = user_office.Replace(";", "");
                    }

                    if (userRoleAccess.isCanWrite)
                    {
                        isEditable = true;
                    }
                    isEditable = true;
                    blankmode = Request.QueryString["blankmode"] ?? "";
                    service_url = statics.GetSetting("service_url");
                    based_url = statics.GetSetting("based_url");

                    isInWorkflow = statics.isInWorkflow(_id, moduleName);

                    DataSet ds = new DataSet();
                    if (!String.IsNullOrEmpty(_id))
                    {
                        ds = staticsVendorSelection.Main.GetData(_id);
                    }

                    if (ds.Tables.Count > 0)
                    {
                        DataTable dtVS = ds.Tables[0];

                        vsItems = JsonConvert.SerializeObject(ds.Tables[1]);
                        vsItemsMain = JsonConvert.SerializeObject(dtVS);
                        supportingDocs = JsonConvert.SerializeObject(ds.Tables[4]);
                        listChargeCode = JsonConvert.SerializeObject(ds.Tables[5]);
                        listSundry = JsonConvert.SerializeObject(ds.Tables[6]);

                        foreach (DataRow dr in ds.Tables[2].Rows)
                        {
                            VS.id = _id;
                            VS.vs_no = dr["vs_no"].ToString();
                            VS.document_date = dr["document_date"].ToString();
                            if (!string.IsNullOrEmpty(VS.document_date))
                            {
                                VS.document_date = DateTime.Parse(VS.document_date).ToString("dd MMM yyyy");
                            }
                            VS.currency_id = dr["currency_id"].ToString();
                            VS.exchange_rate = dr["exchange_rate"].ToString().Replace(",", ".");
                            VS.exchange_sign = dr["exchange_sign"].ToString();
                            VS.status_id = dr["status_id"].ToString();
                            VS.status_name = dr["status_name"].ToString();
                            max_status = dr["max_status"].ToString();
                        }

                        VS.singlesourcing = dtVS.Rows[0]["singlesourcing"].ToString();
                        VS.justification_singlesourcing = dtVS.Rows[0]["justification_singlesourcing"].ToString();
                        VS.justification_file_singlesourcing = dtVS.Rows[0]["justification_file_singlesourcing"].ToString();

                        if (user_office.Contains(dtVS.Rows[0]["cifor_office_id"].ToString()))
                        {
                            isSameOffice = true;
                        }
                    }

                    listCurrency = JsonConvert.SerializeObject(statics.GetCurrency());
                    SSChecklist = JsonConvert.SerializeObject(statics.GetSingleSourceChecklist());

                    this.recentComment.moduleId = _id;
                    this.recentComment.moduleName = moduleName;

                    if (HttpContext.Current.Request.Url.AbsolutePath.Substring(HttpContext.Current.Request.Url.AbsolutePath.LastIndexOf("/")).ToLower().Contains("/singlesourcing.aspx"))
                    {
                        page_name = "inputjustification";
                    }
                    else
                    {
                        page_name = "DETAIL";
                    }

                }

            }
            catch (Exception ex)
            {
                ExceptionHelpers.PrintError(ex);
            }
        }
    }
}