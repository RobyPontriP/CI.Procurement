using myTree.WebForms.Modules;
using myTree.WebForms.Procurement.General;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;

namespace Procurement.PurchaseOrder
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
        protected string service_url, based_url = string.Empty;
        private string moduleName = "PURCHASE ORDER";

        //protected AccessControl authorized = new AccessControl("PURCHASE ORDER");
        protected UserRoleAccess userRoleAccess = AccessControl.GetUserRoleAccess(AccessControlObjectEnum.ProcurementPurchaseOrderList);
        protected UserRoleAccess userRoleAccessSubmissionPO = AccessControl.GetUserRoleAccess(AccessControlObjectEnum.ProcurementPurchaseOrder);

        protected bool isAdmin, isUser, isFinance, isFinanceLead, isOfficer, isEditAble, isLead, isMultipleOffice = false, isCountryLead;

        private class MainList
        {
            public string id { get; set; }
            public string po_detail_id { get; set; }
            public string po_no { get; set; }
            public string po_sun_code { get; set; }
            public string document_date { get; set; }
            public string expected_delivery_date { get; set; }
            public string vendor { get; set; }
            public string vendor_code { get; set; }
            public string vendor_name { get; set; }
            public string sundry_name { get; set; }
            public string currency_id { get; set; }
            public string total_amount { get; set; }
            public string total_amount_usd { get; set; }
            public string remarks { get; set; }
            public string status { get; set; }
            public string status_id { get; set; }
            public string color_code { get; set; }
            public string font_color { get; set; }
            public string actions { get; set; }
            public string details { get; set; }
            public string details_charge_code { get; set; }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            service_url = statics.GetSetting("service_url");
            based_url = statics.GetSetting("based_url");

            if (!userRoleAccess.isCanRead)
            {
                Response.Redirect(AccessControl.GetSetting("access_denied"));
            }

            //if (userRoleAccess.RoleNameInSystem != "procurement_admin" && userRoleAccess.RoleNameInSystem != "finance" && userRoleAccess.RoleNameInSystem != "procurement_user")
            //{
            //    //Response.Redirect(authorized.redirectPage);
            //    Response.Redirect(statics.GetSetting("redirect_page"));
            //}

            isAdmin = userRoleAccess.RoleNameInSystem == AccessControlRoleNameEnum.ProcurementLead || userRoleAccess.RoleNameInSystem == AccessControlRoleNameEnum.ProcurementOfficer ? true : false;
            isUser = userRoleAccess.RoleNameInSystem == AccessControlRoleNameEnum.ProcurementAssistant ? true : false;
            isFinance = userRoleAccess.RoleNameInSystem == AccessControlRoleNameEnum.Finance ? true : false;
            isFinanceLead = userRoleAccess.RoleNameInSystem == AccessControlRoleNameEnum.FinanceLead ? true : false;
            isOfficer = userRoleAccess.RoleNameInSystem == AccessControlRoleNameEnum.ProcurementOfficer ? true : false;
            isEditAble = userRoleAccessSubmissionPO.isCanWrite;
            isCountryLead = userRoleAccess.RoleNameInSystem == AccessControlRoleNameEnum.CountryLead ? true : false;

            string userId = statics.GetLogonUsername();
            isLead = statics.isProcurementLead(userId, userRoleAccess);

            if (isFinanceLead)
            {
                isLead = true;
            }

            DataTable dtOffice = (isFinance || isFinanceLead) ? statics.GetCIFOROfficeByUserIdFinance(userId) : statics.GetCIFOROffice(userId, isLead, isCountryLead);
            if (dtOffice.Rows.Count > 1)
            {
                isMultipleOffice = true;
            }

            if (IsPostBack)
            {
                startDate = Request.Form["startDate"] ?? "";
                endDate = Request.Form["endDate"] ?? "";
                status = Request.Form["status"] ?? "";
                cifor_office = Request.Form["cifor_office"] ?? "";
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
                //status = "10,20,25,30";
                if (isFinance || isFinanceLead)
                {
                    status = "35";
                }
                else if (isCountryLead)
                {
                    status = "15,25,35";
                }
                else
                {
                    status = "5,35";
                }
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
                    cifor_office = Service.GetProcurementOfficeByOfficerId(userId, isLead, isCountryLead);
                }
            }

            if (!isMultipleOffice)
            {
                cifor_office = cifor_office.Replace(";", "");
            }

            DataSet ds = staticsPurchaseOrder.Main.GetList(startDate, endDate, status, cifor_office);

            if (ds.Tables.Count > 0)
            {
                List<MainList> lm = new List<MainList>();
                foreach (DataRow drM in ds.Tables[0].Rows)
                {
                    MainList m = new MainList
                    {
                        id = drM["id"].ToString(),
                        //m.po_detail_id = drM["po_detail_id"].ToString();
                        po_no = drM["po_no"].ToString(),
                        po_sun_code = drM["po_sun_code"].ToString(),
                        document_date = drM["document_date"].ToString(),
                        vendor = drM["vendor"].ToString(),
                        vendor_code = drM["vendor_code"].ToString(),
                        vendor_name = drM["vendor_name"].ToString(),
                        sundry_name = drM["sundry_name"].ToString(),
                        //m.currency_id = drM["currency_id"].ToString();
                        total_amount = drM["total_amount"].ToString(),
                        total_amount_usd = drM["total_amount_usd"].ToString(),
                        remarks = drM["remarks"].ToString(),
                        status = drM["status_name"].ToString(),
                        status_id = drM["status_id"].ToString(),
                        font_color = drM["font_color"].ToString(),
                        color_code = drM["color_code"].ToString(),
                        actions = drM["actions"].ToString(),
                        expected_delivery_date = drM["delivery_date"].ToString()
                    };

                    DataTable dtD = new DataTable();
                    //dtD = ds.Tables[1].Select("id='" + m.id + "'","line_number asc").CopyToDataTable();
                    var rows = ds.Tables[1].AsEnumerable()
                        .Where(x => x["id"].ToString() == m.id)
                        .OrderBy(x => x["line_number"]);

                    if (rows.Any())
                        dtD = rows.CopyToDataTable();

                    DataTable dtDCC;
                    dtDCC = ds.Tables[2].Select("purchase_order='" + m.id + "'", "purchase_order asc").Length > 0 ? ds.Tables[2].Select("purchase_order='" + m.id + "'", "purchase_order asc").CopyToDataTable() : new DataTable();
                    m.details_charge_code = JsonConvert.SerializeObject(dtDCC);

                    m.details = JsonConvert.SerializeObject(dtD);
                    lm.Add(m);
                }
                listPR = JsonConvert.SerializeObject(lm);
            }

            listStatus = JsonConvert.SerializeObject(statics.GetModuleStatus(moduleName, "1"));
            //listOffice = JsonConvert.SerializeObject(statics.GetCIFOROffice());
            if (isFinance)
            {
                listOffice = JsonConvert.SerializeObject(statics.GetCIFOROfficeByUserIdFinance(userId));
            }
            else
            {
                listOffice = JsonConvert.SerializeObject(statics.GetCIFOROffice(userId, isLead, isCountryLead));
            }

            itemStatus = JsonConvert.SerializeObject(statics.GetModuleStatus("PO ITEM", "0"));

            confirmationForm.page_type = "send";
        }
    }
}