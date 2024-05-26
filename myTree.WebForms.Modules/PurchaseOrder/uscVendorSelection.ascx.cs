using myTree.WebForms.Procurement.General;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Procurement.PurchaseOrder
{
    public partial class uscVendorSelection : System.Web.UI.UserControl
    {
        public string page_id { get; set; }
        public string page_type { get; set; }

        protected DataSet POBackgroundInfo = new DataSet();
        protected DataTable dtPR = new DataTable();
        protected DataTable dtVS = new DataTable();
        protected DataTable dtVSD = new DataTable();
        protected string listPR = "[]", listVS = "[]";

        private class VSList
        {
            public string vs_id { get; set; }
            public string vs_no { get; set; }
            public string vendor_code { get; set; }
            public string vendor { get; set; }
            public string vendor_name { get; set; }
            public string supporting_documents { get; set; }
            public string details { get; set; }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            string _id = page_id;

            if (!string.IsNullOrEmpty(_id))
            {
                POBackgroundInfo = staticsPurchaseOrder.GetBackgroundInformation(_id);
                dtPR = POBackgroundInfo.Tables[0];
                if (POBackgroundInfo.Tables[1].Rows.Count > 0)
                {
                    List<VSList> lm = new List<VSList>();
                    foreach (DataRow drM in POBackgroundInfo.Tables[1].Rows)
                    {
                        VSList m = new VSList();
                        m.vs_id = drM["vs_id"].ToString();
                        m.vs_no = drM["vs_no"].ToString();
                        m.vendor_code = drM["vendor_code"].ToString();
                        m.vendor = drM["vendor"].ToString();
                        m.vendor_name = drM["vendor_name"].ToString();
                        m.supporting_documents = drM["vs_docs"].ToString();

                        DataTable dtD;
                        dtD = POBackgroundInfo.Tables[2].Select("vs_id='" + m.vs_id + "'", "vendor_name asc, q_id asc").CopyToDataTable();
                        m.details = JsonConvert.SerializeObject(dtD);

                        lm.Add(m);
                    }
                    listVS = JsonConvert.SerializeObject(lm);
                }
                listPR = JsonConvert.SerializeObject(dtPR);
            }
        }
    }
}