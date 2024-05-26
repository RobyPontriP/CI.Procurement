using myTree.WebForms.Procurement.General;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace myTree.WebForms.Modules.UserConfirmation
{
    public partial class uscItemData : System.Web.UI.UserControl
    {
        public string base_id { get; set; }
        public string base_type { get; set; }
        public string page_type { get; set; }

        private DataSet dsItem;

        protected string listHeader = "[]"
            , listItem = "[]";

        protected void Page_Load(object sender, EventArgs e)
        {
            if (String.IsNullOrEmpty(base_id))
            {
                base_id = "0";
            }

            base_type = base_type ?? "";
            page_type = page_type ?? "";

            dsItem = staticsUserConfirmation.GetData(base_id, base_type, page_type);
            if (dsItem.Tables.Count > 0)
            {
                listHeader = JsonConvert.SerializeObject(dsItem.Tables[0]);
                listItem = JsonConvert.SerializeObject(dsItem.Tables[1]);
            }
        }
    }
}