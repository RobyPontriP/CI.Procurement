using myTree.WebForms.Procurement.General;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.Web;

namespace myTree.WebForms.Modules.PurchaseRequisition
{
    public partial class List : System.Web.UI.Page
    {
        protected string itemStatus = string.Empty;

        protected string listPR = string.Empty;
        //protected string listPRDetail = string.Empty;
        protected string listStatus = string.Empty;
        protected string listOffice = string.Empty;

        protected string startDate = string.Empty;
        protected string endDate = string.Empty;
        protected string status = string.Empty;
        protected string cifor_office = string.Empty;
        protected string type_PR = string.Empty;

        private string moduleName = "PURCHASE REQUISITION";

        //protected AccessControl authorized = new AccessControl("PURCHASE REQUISITION");
        protected UserRoleAccess userRoleAccess = AccessControl.GetUserRoleAccess(AccessControlObjectEnum.ProcurementPurchaseRequisitionList);
        protected UserRoleAccess userRoleAccessSubmissionPR = AccessControl.GetUserRoleAccess(AccessControlObjectEnum.ProcurementPurchaseRequisition);

        protected bool isAdmin, isUser, isFinance, isFinanceLead, isOfficer,isEditAble, isLead, isMultipleOffice = false;

        private class MainList
        {
            public string id { get; set; }
            public string kpi { get; set; }
            public string pr_no { get; set; }
            public string created_date { get; set; }
            public string submission_date { get; set; }
            public string requester { get; set; }
            public string cifor_office { get; set; }
            public string required_date { get; set; }
            public string remarks { get; set; }
            public string cost_center { get; set; }
            public string status { get; set; }
            public string color_code { get; set; }
            public string font_color { get; set; }
            public string details { get; set; }
            public string details_charge_code { get; set; }
            public string pr_type { get; set; }
            public string purchase_type_name { get; set; }

            public string currency_id { get; set; }
            public string estimated_cost { get; set; }
            public string estimated_cost_usd { get; set; }
            public string id_submission_page_type { get; set; }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!HttpContext.Current.User.Identity.IsAuthenticated)
            {
                //HttpContext.Current.GetOwinContext().Authentication.Challenge();
            }
            else
            {
                if (!userRoleAccess.isCanRead)
                {
                    Response.Redirect(AccessControl.GetSetting("access_denied"));
                }

                isAdmin = userRoleAccess.RoleNameInSystem == AccessControlRoleNameEnum.ProcurementLead || userRoleAccess.RoleNameInSystem == AccessControlRoleNameEnum.ProcurementOfficer ? true : false;
                isUser = userRoleAccess.RoleNameInSystem == AccessControlRoleNameEnum.ProcurementAssistant ? true : false;
                isFinance = userRoleAccess.RoleNameInSystem == AccessControlRoleNameEnum.Finance ? true : false;
                isFinanceLead = userRoleAccess.RoleNameInSystem == AccessControlRoleNameEnum.FinanceLead ? true : false;
                isOfficer = userRoleAccess.RoleNameInSystem == AccessControlRoleNameEnum.ProcurementOfficer ? true : false;
                isEditAble = userRoleAccessSubmissionPR.isCanWrite;

                string userId = statics.GetLogonUsername();
                isLead = statics.isProcurementLead(userId, userRoleAccess);

                if (isFinanceLead)
                {
                    isLead = true;
                }
                // isAdmin = true;
                //isUser = true;
                //isFinance = true;
                //isOfficer = true;
                //isEditAble = true;

                if (IsPostBack)
                {
                    startDate = Request.Form["startDate"] ?? "";
                    endDate = Request.Form["endDate"] ?? "";
                    status = Request.Form["status"] ?? "";
                    cifor_office = Request.Form["cifor_office"] ?? "";
                    type_PR = Request.Form["type_PR"] ?? "";
                }
                if (String.IsNullOrEmpty(startDate))
                {
                    DateTime t = new DateTime(DateTime.Now.Year, DateTime.Now.Month, 1);
                    startDate = t.ToString("dd MMM yyyy");
                }
                if (String.IsNullOrEmpty(endDate))
                {
                    DateTime t = new DateTime(DateTime.Now.Year, DateTime.Now.Month, DateTime.DaysInMonth(DateTime.Now.Year, DateTime.Now.Month));
                    endDate = t.ToString("dd MMM yyyy");
                }
                if (String.IsNullOrEmpty(status))
                {
                    //if (authorized.finance)
                    if (isFinance || isFinanceLead)
                    {
                        status = "21,22";
                    }
                    else
                    {
                        status = "10,20,25,30";
                    }
                }

                DataTable dtOffice = (isFinance || isFinanceLead) ? statics.GetCIFOROfficeByUserIdFinance(userId) : statics.GetCIFOROffice(userId, isLead);
                if (dtOffice.Rows.Count > 1)
                {
                    isMultipleOffice = true;
                }
                //if (String.IsNullOrEmpty(cifor_office))
                //{
                //    cifor_office = "-1";
                //}

                //if (isOfficer && userRoleAccess.RoleNameInSystem != AccessControlRoleNameEnum.ProcurementLead)
                //{
                //    listOffice = JsonConvert.SerializeObject(statics.GetCIFOROffice(statics.GetLogonUsername()));
                //    cifor_office = Service.GetRequesterOffice(statics.GetLogonUsername());
                //}
                //else
                //{
                //    listOffice = JsonConvert.SerializeObject(statics.GetCIFOROffice());
                //}
                if (String.IsNullOrEmpty(cifor_office) || cifor_office == "ALL")
                {
                    if (isFinance)
                    {
                        cifor_office = Service.GetProcurementOfficeByFinanceOfficerId(userId);
                    }
                    else
                    {
                        cifor_office = Service.GetProcurementOfficeByOfficerId(userId, isLead);
                    }
                }

                if (!isMultipleOffice)
                {
                    cifor_office = cifor_office.Replace(";", "");
                }

   
                if (String.IsNullOrEmpty(type_PR))
                {
                    if (isFinance || isFinanceLead)
                    {
                        type_PR = "1";

                    }
                    else if (isOfficer || isLead)
                    {
                        type_PR = "0";
                    }
                    else
                    {
                        type_PR = "-1";
                    }
                }

                DataSet ds = staticsPurchaseRequisition.Main.GetList(startDate, endDate, status, cifor_office, type_PR);

                if (ds.Tables.Count > 0)
                {
                    List<MainList> lm = new List<MainList>();
                    foreach (DataRow drM in ds.Tables[0].Rows)
                    {
                        MainList m = new MainList();
                        m.id = drM["id"].ToString();
                        m.kpi = drM["kpi"].ToString();
                        m.pr_no = drM["pr_no"].ToString();
                        m.created_date = drM["created_date"].ToString();
                        m.submission_date = drM["submission_date"].ToString();
                        m.requester = drM["requester"].ToString();
                        m.cifor_office = drM["cifor_office"].ToString();
                        m.required_date = drM["required_date"].ToString();
                        m.remarks = drM["remarks"].ToString();
                        m.cost_center = drM["cost_center"].ToString();
                        m.status = drM["status"].ToString();
                        m.font_color = drM["font_color"].ToString();
                        m.color_code = drM["color_code"].ToString();
                        m.currency_id = drM["currency_id"].ToString();
                        m.pr_type = drM["pr_type"].ToString();
                        m.estimated_cost = String.Format("{0:#,0.00}", Decimal.Parse(drM["total_estimated"].ToString())) ?? "0";
                        m.estimated_cost_usd = String.Format("{0:#,0.00}", Decimal.Parse(drM["total_estimated_usd"].ToString())) ?? "0";
                        m.id_submission_page_type = drM["id_submission_page_type"].ToString();
                        m.purchase_type_name = drM["purchase_type_name"].ToString();
                        DataTable dtD = new DataTable();

                        if (ds.Tables[1].Rows.Count > 0)
                        {
                            dtD = ds.Tables[1].Select("pr_id='" + m.id + "'", "id asc").Length > 0 ? ds.Tables[1].Select("pr_id='" + m.id + "'", "id asc").CopyToDataTable() : new DataTable();
                        }
                        
                        m.details = JsonConvert.SerializeObject(dtD);

                        DataTable dtDCC = new DataTable();

                        if (ds.Tables[2].Rows.Count > 0)
                        {
                            dtDCC = ds.Tables[2].Select("pr_id='" + m.id + "'", "id asc").Length > 0 ? ds.Tables[2].Select("pr_id='" + m.id + "'", "id asc").CopyToDataTable() : new DataTable();
                        }
                        
                        m.details_charge_code = JsonConvert.SerializeObject(dtDCC);


                        lm.Add(m);
                    }
                    listPR = JsonConvert.SerializeObject(lm);
                    //listPR = JsonConvert.SerializeObject(ds.Tables[0]);
                    //listPRDetail = JsonConvert.SerializeObject(ds.Tables[1]);
                }

                listStatus = JsonConvert.SerializeObject(statics.GetModuleStatus(moduleName, "1"));
                if (isFinance)
                {
                    listOffice = JsonConvert.SerializeObject(statics.GetCIFOROfficeByUserIdFinance(userId));
                }
                else
                {
                    listOffice = JsonConvert.SerializeObject(statics.GetCIFOROffice(userId, isLead));
                }


                itemStatus = JsonConvert.SerializeObject(statics.GetModuleStatus("ITEM", "0"));

                //confirmationForm.page_type = "send";
            }
        }
    }
}