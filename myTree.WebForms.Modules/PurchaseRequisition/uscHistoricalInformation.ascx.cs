using myTree.WebForms.Procurement.General;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace myTree.WebForms.Modules.PurchaseRequisition
{
    public partial class uscHistoricalInformation : System.Web.UI.UserControl
    {
        public string moduleId { get; set; }
        public string moduleName { get; set; }

        protected DataTable dtHistorical;
        protected string ListHistorical = string.Empty;
        protected string based_url = string.Empty;
        protected void Page_Load(object sender, EventArgs e)
        {
            dtHistorical = statics.LifeCycle.GetData(moduleId, moduleName);
            ListHistorical = JsonConvert.SerializeObject(dtHistorical);

            based_url = statics.GetSetting("based_url");
        }
    }
}