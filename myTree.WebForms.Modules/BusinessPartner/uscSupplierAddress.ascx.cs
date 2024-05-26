using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace myTree.WebForms.Modules.BusinessPartner
{
    public partial class uscSupplierAddress : System.Web.UI.UserControl
    {
        public string address_type { get; set; }
        public string vendor_id { get; set; }
        protected string eleName;
        protected string address_code;
        protected void Page_Load(object sender, EventArgs e)
        {
            eleName = address_type+"address";
            if (address_type != "main")
            {
                address_code = address_type + " ";
            }
        }
    }
}