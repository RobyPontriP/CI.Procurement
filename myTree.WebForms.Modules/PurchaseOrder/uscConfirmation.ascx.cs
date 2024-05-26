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
    public partial class uscConfirmation : System.Web.UI.UserControl
    {
        public string po_id { get; set; }

        protected string listPOConfirm = "[]";

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!string.IsNullOrEmpty(po_id)) {
                listPOConfirm = JsonConvert.SerializeObject(staticsPurchaseOrder.GetUserConfirmation(po_id));
            }
        }
    }
}