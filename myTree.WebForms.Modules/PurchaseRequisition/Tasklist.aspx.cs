using myTree.WebForms.Procurement.General;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
//using myTree.WebForms.K2Helper;
using System.Collections;
using Serilog;

namespace myTree.WebForms.Modules.PurchaseRequisition
{
    public partial class Tasklist : System.Web.UI.Page
    {
        protected string listPR = string.Empty;
        protected string action = string.Empty;
        protected string listOffice = string.Empty;
        private string moduleName = "PURCHASE REQUISITION";
        protected string cifor_office = string.Empty;
        protected Boolean isOfficer = false;
        protected Boolean isLead = false;
        protected string userId = string.Empty;
        protected string paramToSP = string.Empty;

        //protected AccessControl authorized = new AccessControl("PURCHASE REQUISITION");
        protected UserRoleAccess userRoleAccess = AccessControl.GetUserRoleAccess(AccessControlObjectEnum.ProcurementPurchaseRequisitionTaskist);

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
            public string url { get; set; }
            public string details { get; set; }
            public string details_charge_code { get; set; }
            public string currency_id { get; set; }
            public string estimated_cost { get; set; }
            public string estimated_cost_usd { get; set; }
            public string pr_type { get; set; }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!userRoleAccess.isCanRead)
            {
                Response.Redirect(AccessControl.GetSetting("access_denied"));
            }

            userId = statics.GetLogonUsername();

            //string k2ApiKey = statics.GetSetting("K2ApiKey");
            //string k2ApiEndPoint = statics.GetSetting("K2ApiEndpoint");
            //string k2_folder_name = statics.GetSetting("K2FolderName");
            //string k2_process_name = statics.GetSetting("K2ProcessName");
            //K2Helpers generalK2Help = new K2Helpers(k2ApiKey, k2ApiEndPoint);

            //generalK2Help.SyncK2Activity("2444", k2_folder_name, k2_process_name, "");
            //var ret = generalK2Help.SyncK2ActivityNew(null, k2_folder_name, k2_process_name, null, userId); //sync K2 by ProcessName, Folder and UserId
            //Log.Information("Return SyncK2ActivityNew: " + ret);
            //var getActivities = generalK2Help.K2GetActivitiesByAPI("", "", "");

            if (userRoleAccess.RoleNameInSystem == AccessControlRoleNameEnum.ProcurementLead || userRoleAccess.RoleNameInSystem == AccessControlRoleNameEnum.ProcurementOfficer)
            {
                if (userRoleAccess.RoleNameInSystem == AccessControlRoleNameEnum.ProcurementOfficer)
                {
                    isOfficer = true;
                }

                if (userRoleAccess.RoleNameInSystem == AccessControlRoleNameEnum.ProcurementLead)
                {
                    isLead = true;
                }
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

            var tableProcOff = statics.GetCIFOROfficeWithParamLead(userId, isLead);
            listOffice = JsonConvert.SerializeObject(tableProcOff);

            var procOffCount = tableProcOff.Rows.Count;

            cifor_office = Service.GetRequesterOffice(userId);
            cifor_office = !string.IsNullOrEmpty(cifor_office) ? cifor_office : "ALL";
            action = Request.QueryString["action"] ?? "";
            var cifor_office_param = Request.QueryString["procurementOffice"] ?? "";
            if (!string.IsNullOrEmpty(cifor_office_param))
            {
                cifor_office = cifor_office_param.ToUpper();
            }
            else
            {
                if (isLead || procOffCount > 1)
                {
                    cifor_office = "ALL";
                }
                //cifor_office = isLead ? "ALL" : cifor_office;
            }

            if (procOffCount == 1)
            {
                paramToSP = "ALL";
            }
            else
            {
                paramToSP = cifor_office;
            }

            DataSet ds = new DataSet();
            if (string.IsNullOrEmpty(action))
            {
                ds = staticsPurchaseRequisition.GetTaskList(paramToSP);
            }
            else if (action.ToLower() == "team")
            {
                ds = staticsPurchaseRequisition.GetTeamTaskList(paramToSP);
            }

            if (ds.Tables.Count > 0)
            {
                List<MainList> lm = new List<MainList>();
                foreach (DataRow drM in ds.Tables[0].Rows)
                {
                    MainList m = new MainList();
                    m.id = drM["id"].ToString();
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
                    m.url = drM["url"].ToString();
                    m.currency_id = drM["currency_id"].ToString();
                    var totalEstimated = string.IsNullOrEmpty(drM["total_estimated"].ToString()) ? "0" : drM["total_estimated"].ToString();
                    m.estimated_cost = String.Format("{0:#,0.00}", Decimal.Parse(totalEstimated)) ?? "0";
                    var totEstUsd = string.IsNullOrEmpty(drM["total_estimated_usd"].ToString()) ? "0" : drM["total_estimated_usd"].ToString();
                    m.estimated_cost_usd = String.Format("{0:#,0.00}", Decimal.Parse(totEstUsd)) ?? "0";
                    m.pr_type = drM["pr_type"].ToString();

                    DataTable dtD = new DataTable();
                    var mId = string.IsNullOrEmpty(m.id) ? "0" : m.id;
                    if (ds.Tables[1].Select("pr_id='" + mId + "'", "id asc").Count() > 0)
                    {
                        dtD = ds.Tables[1].Select("pr_id='" + mId + "'", "id asc").CopyToDataTable();
                    }
                    m.details = JsonConvert.SerializeObject(dtD);

                    DataTable dtDCC = new DataTable();

                    if (ds.Tables[2].Rows.Count > 0)
                    {
                        dtDCC = ds.Tables[2].Select("pr_id='" + mId + "'", "id asc").Length > 0 ? ds.Tables[2].Select("pr_id='" + mId + "'", "id asc").CopyToDataTable() : new DataTable();
                    }

                    m.details_charge_code = JsonConvert.SerializeObject(dtDCC);

                    lm.Add(m);
                }
                listPR = JsonConvert.SerializeObject(lm);
            }
        }
    }
}