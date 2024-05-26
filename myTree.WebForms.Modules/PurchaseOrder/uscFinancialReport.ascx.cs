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
    public partial class uscFinancialReport : System.Web.UI.UserControl
    {
        public string po_id { get; set; }

        protected string listInvoice = "[]";
        protected string listReceipt = "[]";

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!string.IsNullOrEmpty(po_id)) {
                DataSet ds = staticsPurchaseOrder.GetFinancialReportData(po_id);
                if (ds.Tables.Count > 0) {
                    DataTable dtInvoice = ds.Tables[0];
                    DataTable dtReceipt = ds.Tables[1];

                    listInvoice = JsonConvert.SerializeObject(dtInvoice);
                    listReceipt = JsonConvert.SerializeObject(dtReceipt);
                }
            }
        }
    }
}