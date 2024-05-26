using myTree.WebForms.Procurement.General;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;

namespace Procurement.PurchaseOrder
{
    public partial class Tasklist : System.Web.UI.Page
    {
        protected string listPO = string.Empty;
        protected string action = string.Empty;

        private string moduleName = "PURCHASE ORDER";

        protected UserRoleAccess userRoleAccess = AccessControl.GetUserRoleAccess(AccessControlObjectEnum.ProcurementPurchaseOrder);

        private class MainList
        {
            public string id { get; set; }
            public string po_no { get; set; }
            public string po_sun_code { get; set; }
            public string document_date { get; set; }
            public string vendor { get; set; }
            public string vendor_name { get; set; }
            public string currency_id { get; set; }
            public string total_amount { get; set; }
            public string total_amount_usd { get; set; }
            public string remarks { get; set; }
            public string status { get; set; }
            public string status_id { get; set; }
            public string color_code { get; set; }
            public string font_color { get; set; }
            public string exchange_rate { get; set; }
            public string url { get; set; }
            public string details { get; set; }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            action = Request.QueryString["action"] ?? "";
            DataSet ds = new DataSet();
            if (string.IsNullOrEmpty(action))
            {
                ds = staticsPurchaseOrder.GetTaskList();
            }
            else if (action.ToLower() == "team")
            {
                ds = staticsPurchaseOrder.GetTeamTaskList();
            }

            if (ds.Tables.Count > 0) {
                List<MainList> lm = new List<MainList>();
                foreach (DataRow drM in ds.Tables[0].Rows) {
                    MainList m = new MainList();
                    m.id = drM["id"].ToString();
                    m.po_no = drM["po_no"].ToString();
                    m.po_sun_code = drM["po_sun_code"].ToString();
                    m.document_date = drM["document_date"].ToString();
                    m.vendor = drM["vendor"].ToString();
                    m.vendor_name = drM["vendor_name"].ToString();
                    m.currency_id = drM["currency_id"].ToString();
                    m.total_amount = drM["total_amount"].ToString();
                    m.total_amount_usd = drM["total_amount_usd"].ToString();
                    m.remarks = drM["remarks"].ToString();
                    m.status = drM["status_name"].ToString();
                    m.status_id = drM["status_id"].ToString();
                    m.font_color = drM["font_color"].ToString();
                    m.color_code = drM["color_code"].ToString();
                    m.url = drM["url"].ToString();
                    m.exchange_rate = drM["exchange_rate"].ToString();

                    DataTable dtD = new DataTable();
                    var rows = ds.Tables[1].AsEnumerable()
                        .Where(x =>(string)x["id"].ToString() == m.id)
                        .OrderBy(x => x["line_number"]);

                    if (rows.Any())
                        dtD = rows.CopyToDataTable();

                    m.details = JsonConvert.SerializeObject(dtD);
                    lm.Add(m);
                }
                listPO = JsonConvert.SerializeObject(lm);
            }
        }
    }
}