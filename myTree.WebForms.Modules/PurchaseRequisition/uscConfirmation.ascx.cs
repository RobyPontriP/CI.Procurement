using myTree.WebForms.Procurement.General;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace myTree.WebForms.Modules.PurchaseRequisition
{
    public partial class uscConfirmation : System.Web.UI.UserControl
    {
        public string pr_id { get; set; }

        protected string listPRConfirm = "[]";

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!string.IsNullOrEmpty(pr_id))
            {
                listPRConfirm = JsonConvert.SerializeObject(staticsPurchaseRequisition.Main.GetUserConfirmation(pr_id));
            }
        }
    }
}