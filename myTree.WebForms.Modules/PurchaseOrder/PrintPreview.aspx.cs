using myTree.WebForms.Procurement.General;
using Serilog;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Procurement.PurchaseOrder
{
    public partial class preview : System.Web.UI.Page
    {
        protected string _id = string.Empty;
        protected string moduleName = "PURCHASE ORDER";
        protected string termcondition = string.Empty;
        protected string service_url, based_url = string.Empty;
        protected string browser_name = string.Empty;

        private static Antlr3.ST.StringTemplateGroup group = new Antlr3.ST.StringTemplateGroup("POHelper");
        private static Antlr3.ST.StringTemplate template = new Antlr3.ST.StringTemplate();
        public static string StartupPath = HttpContext.Current.Server.MapPath("template");

        //protected AccessControl authorized = new AccessControl("PURCHASE ORDER");
        protected UserRoleAccess userRoleAccess = AccessControl.GetUserRoleAccess(AccessControlObjectEnum.ProcurementPurchaseOrder);

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!HttpContext.Current.User.Identity.IsAuthenticated)
            {
                //HttpContext.Current.GetOwinContext().Authentication.Challenge();
                Log.Information("Session ended re-challenge...");
            }

            if (!userRoleAccess.isCanRead)
            {
                Response.Redirect(AccessControl.GetSetting("access_denied"));
            }

            _id = Request.QueryString["id"] ?? "";
            service_url = statics.GetSetting("service_url");
            based_url = statics.GetSetting("based_url");
            this.pod1.page_id = _id;

            string templateString = string.Empty;
            browser_name = HttpContext.Current.Request.Browser.Browser;
            group.RootDir = StartupPath;
            Antlr3.ST.StringTemplate template = group.GetInstanceOf("PO_TOC");

            termcondition = template.ToString();
            template.Reset();
        }
    }
}