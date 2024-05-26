using myTree.WebForms.Procurement.General;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace myTree.WebForms.Modules.RFQ
{
    public partial class uscSearchItem : System.Web.UI.UserControl
    {
        public string page_type { get; set; }
        protected string subcategory = string.Empty, cifor_office_id = string.Empty, pr_line_id = string.Empty;
        protected string listCategory = string.Empty, listItem = string.Empty, listVendor = string.Empty; 

        protected DataTable dtCategory, dtItem, dtVendor;

        protected void Page_Load(object sender, EventArgs e)
        {

        }
    }
}