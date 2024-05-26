using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using Newtonsoft.Json;
using myTree.WebForms.Procurement.General;

namespace Procurement.ProcurementReporting
{
    public partial class POList : System.Web.UI.Page
    {
        protected string _ListTeam = string.Empty;
        protected bool can_access = false;
        protected string startDate = string.Empty;
        protected string service_url, based_url, endDate = string.Empty;
        protected string listOffice = string.Empty;

        protected void Page_Load(object sender, EventArgs e)
        {
            service_url = statics.GetSetting("service_url");
            based_url = statics.GetSetting("based_url");

            if (IsPostBack)
            {
                startDate = Request.Form["startDate"] ?? "";
                endDate = Request.Form["endDate"] ?? "";

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

            can_access = staticsProcurementReporting.can_access_PR_PO();

            if (!can_access)
            {
                //Response.Redirect(statics.GetSetting("MyCifor_url"));
                Response.Redirect(AccessControl.GetSetting("access_denied"));
            }

            _ListTeam = JsonConvert.SerializeObject(staticsProcurementReporting.GetTeam());

            string startdate = Request.Form["hidStartDate"] + ' ';
            string enddate = ' ' + Request.Form["hidEndDate"];
            string staffname = Request.Form["hidStaffName"];
            string teamname = Request.Form["hidTeamName"];
            string staff = Request.Form["hidStaff"];
            string team = Request.Form["hidTeam"];
            string ciforofficeExc = Request.Form["hidCiforOfficeExc"];
            string ciforoffice = Request.Form["hidCiforOffice"];

            string fileName = string.Format(statics.GetSetting("PO_Report"));

            if (Request.Form["btnExport"] == "Export to excel")
                staticsProcurementReporting.GenerateExcelFileReportSummarizePO(staticsProcurementReporting.GetSummarizePOExcel(startdate, enddate, team, staff, ciforofficeExc), fileName, startdate, enddate, teamname, staffname,ciforoffice);

            //if (isFinance)
            //{
            //    listOffice = JsonConvert.SerializeObject(statics.GetCIFOROfficeByUserIdFinance(userId));
            //}
            //else
            //{
            //    listOffice = JsonConvert.SerializeObject(statics.GetCIFOROffice(userId, isLead, isCountryLead));
            //}
            listOffice = JsonConvert.SerializeObject(statics.GetCIFOROffice(statics.GetLogonUsername(), true, false));
        }

        //protected void btnExportExcel_Click(object sender, EventArgs e)
        //{
        //    string startdate = Request.Form["hidStartDate"];
        //    string enddate = Request.Form["hidEndDate"];
        //    DataTable dt = statics.GetSummarizePOExcel(startdate, enddate);
        //    string fileName = string.Format(statics.GettSetting("PO_Report"));
        //    statics.GenerateExcelFileReportSummarizePO(dt, fileName, startdate, enddate);
        //}
    }
}