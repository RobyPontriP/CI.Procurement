using myTree.WebForms.Procurement.General;
using Newtonsoft.Json;
using Serilog;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace myTree.WebForms.Modules.VendorSelection
{
    public partial class List : System.Web.UI.Page
    {
        protected string listVS = string.Empty;
        protected string listStatus = string.Empty;
        protected string listOffice = string.Empty;

        protected string startDate = string.Empty;
        protected string endDate = string.Empty;
        protected string status = string.Empty;
        protected string cifor_office = string.Empty;
        protected Boolean isAdmin = false;
        protected Boolean isOfficer = false;
        protected Boolean isMultipleOffice = false;
        protected Boolean isLead = false;
        protected string userId = string.Empty;
        protected Boolean isEditable = false;
        protected string service_url, based_url = string.Empty;
        private string moduleName = "VENDOR SELECTION";

        private class MainList
        {
            public string id { get; set; }
            public string vs_no { get; set; }
            public string created_date { get; set; }
            public string remarks { get; set; }
            public string pr_no { get; set; }
            public string cifor_office { get; set; }
            public string cifor_office_id { get; set; }
            public string status { get; set; }
            public string color_code { get; set; }
            public string font_color { get; set; }
            public string actions { get; set; }
            public string vendors { get; set; }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                service_url = statics.GetSetting("service_url");
                based_url = statics.GetSetting("based_url");

                if (!HttpContext.Current.User.Identity.IsAuthenticated)
                {
                    //HttpContext.Current.GetOwinContext().Authentication.Challenge();
                }
                else
                {
                    UserRoleAccess userRoleAccess = AccessControl.GetUserRoleAccess(AccessControlObjectEnum.ProcurementQuotationAnalysisList);

                    if (!(userRoleAccess.isCanRead))
                    {
                        Response.Redirect(AccessControl.GetSetting("access_denied"));
                        Log.Information("Don't have access control, redirecting...");
                    }

                    userId = statics.GetLogonUsername();
                    isLead = statics.isProcurementLead(userId, userRoleAccess);

                    DataTable dtOffice = statics.GetCIFOROffice(userId, isLead);
                    if (dtOffice.Rows.Count > 1)
                    {
                        isMultipleOffice = true;
                    }

                    if (!(userRoleAccess.RoleNameInSystem == AccessControlRoleNameEnum.ProcurementAssistant))
                    {

                        isAdmin = true;
                    }

                    UserRoleAccess userRoleAccessEdittable = AccessControl.GetUserRoleAccess(AccessControlObjectEnum.ProcurementQuotationAnalysis);
                    if (userRoleAccessEdittable.isCanWrite)
                    {
                        isEditable = true;
                    }

                    isEditable = true;

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
                        status = "5,25,30";
                    }

                    if (String.IsNullOrEmpty(cifor_office) || cifor_office == "ALL")
                    {
                        cifor_office = Service.GetProcurementOfficeByOfficerId(userId, isLead);
                    }

                    if (!isMultipleOffice)
                    {
                        cifor_office = cifor_office.Replace(";", "");
                    }

                    DataSet ds = staticsVendorSelection.Main.GetList(startDate, endDate, status, cifor_office);

                    if (ds.Tables.Count > 0)
                    {
                        List<MainList> lm = new List<MainList>();
                        foreach (DataRow drM in ds.Tables[0].Rows)
                        {
                            MainList m = new MainList();
                            m.id = drM["id"].ToString();
                            m.vs_no = drM["vs_no"].ToString();
                            m.created_date = drM["created_date"].ToString();
                            m.remarks = drM["remarks"].ToString();
                            m.pr_no = drM["pr_no"].ToString();
                            m.cifor_office = drM["office_name"].ToString();
                            m.cifor_office_id = drM["office_id"].ToString();
                            m.status = drM["status_name"].ToString();
                            m.actions = drM["actions"].ToString();
                            m.color_code = drM["color_code"].ToString();
                            m.font_color = drM["font_color"].ToString();
                            m.vendors = drM["vendors"].ToString();

                            lm.Add(m);
                        }
                        listVS = JsonConvert.SerializeObject(lm);
                    }

                    listStatus = JsonConvert.SerializeObject(statics.GetModuleStatus(moduleName, "1"));
                    listOffice = JsonConvert.SerializeObject(statics.GetCIFOROffice(userId, isLead));

                }


            }
            catch (Exception ex)
            {
                ExceptionHelpers.PrintError(ex);
            }

        }
    }
}