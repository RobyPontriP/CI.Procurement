using myTree.WebForms.Procurement.General;
using myTree.WebForms.Procurement.Notification;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace myTree.WebForms.Modules.RFQ
{
    public partial class PrintPreview : System.Web.UI.Page
    {
        protected string rfq_id = string.Empty, template = string.Empty, htmlOutput = string.Empty;
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                rfq_id = Request.QueryString["id"] ?? "";
                template = Request.QueryString["template"] ?? "";

                if (!String.IsNullOrEmpty(rfq_id) && !String.IsNullOrEmpty(template))
                {
                    DataSet ds = NotificationData.RFQ.SendToVendor(rfq_id);
                    htmlOutput = NotificationHelper.RFQ_SendToVendor(ds, template, "print");
                }
            }
            catch(Exception ex)
            {
                ExceptionHelpers.PrintError(ex);
            }
           
        }
    }
}