using myTree.WebForms.Procurement.General;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace myTree.WebForms.Modules.UserConfirmation
{
    public partial class uscSendConfirmation : System.Web.UI.UserControl
    {
        protected string listEmployee = "[]";
        public string page_type = string.Empty;
        protected string service_url, based_url = string.Empty;
        protected void Page_Load(object sender, EventArgs e)
        {
            service_url = statics.GetSetting("service_url");
            based_url = statics.GetSetting("based_url");
            listEmployee = JsonConvert.SerializeObject(statics.GetEmployee());
        }
    }
}