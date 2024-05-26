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
    public partial class uscReconfirmationForm : System.Web.UI.UserControl
    {
        protected string listEmployee = "[]";

        protected void Page_Load(object sender, EventArgs e)
        {
            listEmployee = JsonConvert.SerializeObject(statics.GetEmployee());
        }
    }
}