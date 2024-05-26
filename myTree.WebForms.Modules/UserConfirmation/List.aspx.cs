using myTree.WebForms.Procurement.General;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;

namespace myTree.WebForms.Modules.UserConfirmation
{
    public partial class List : System.Web.UI.Page
    {
        protected string itemStatus = string.Empty;

        protected string listUConfirmation = string.Empty;
        protected string listUDetail = string.Empty;
        protected string listStatus = string.Empty;
        protected string listOffice = string.Empty;

        protected string startDate = string.Empty;
        protected string endDate = string.Empty;
        protected string status = string.Empty;
        protected string cifor_office = string.Empty;

        //protected AccessControl authorized = new AccessControl("PURCHASE REQUISITION");
        protected UserRoleAccess userRoleAccess = AccessControl.GetUserRoleAccess(AccessControlObjectEnum.ProcurementPurchaseRequisitionList);

        private class MainList
        {
            public string uc_id { get; set; }
            public string confirmation_code { get; set; }
            public string status { get; set; }
            public string po_no { get; set; }
            public string send_date { get; set; }
            public string confirm_date { get; set; }
            public string details { get; set; }
            public string send_date_order { get; set; }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (userRoleAccess.RoleNameInSystem != "procurement_admin" && userRoleAccess.RoleNameInSystem != "procurement_user")
            {
                //Response.Redirect(authorized.redirectPage);
                Response.Redirect(statics.GetSetting("redirect_page"));
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
                status = "25,30,50";
            }
            if (String.IsNullOrEmpty(cifor_office))
            {
                cifor_office = "-1";
            }

            DataSet ds = staticsUserConfirmation.GetList(startDate, endDate, status, cifor_office);

            if (ds.Tables.Count > 0)
            {
                List<MainList> lm = new List<MainList>();
                foreach (DataRow drM in ds.Tables[0].Rows)
                {
                    MainList m = new MainList();
                    m.uc_id = drM["uc_id"].ToString();
                    m.confirmation_code = drM["confirmation_code"].ToString();
                    m.status = drM["status_main"].ToString();
                    m.po_no = drM["po_no"].ToString();
                    m.send_date = drM["send_date"].ToString();
                    m.confirm_date = drM["confirm_date_main"].ToString();
                    m.send_date_order = drM["send_date_order"].ToString();

                    DataTable dtD;
                    dtD = ds.Tables[1].Select("uc_id='" + drM["uc_id"].ToString() + "'", "ucd_id asc").CopyToDataTable();
                    m.details = JsonConvert.SerializeObject(dtD);
                    lm.Add(m);
                }
                listUConfirmation = JsonConvert.SerializeObject(lm);
                listUDetail = JsonConvert.SerializeObject(ds.Tables[1]);
            }

            listStatus = JsonConvert.SerializeObject(statics.GetModuleStatus("ITEM CONFIRMATION", "1"));
            listOffice = JsonConvert.SerializeObject(statics.GetCIFOROffice());

            itemStatus = JsonConvert.SerializeObject(statics.GetModuleStatus("ITEM CONFIRMATION", "0"));
        }
    }
}