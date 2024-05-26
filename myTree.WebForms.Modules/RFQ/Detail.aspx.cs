using myTree.WebForms.Procurement.General;
using myTree.WebForms.Procurement.Notification;
using Newtonsoft.Json;
using Serilog;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace myTree.WebForms.Modules.RFQ
{
    public partial class Detail : System.Web.UI.Page
    {
        protected string _id = string.Empty, vendor_categories = string.Empty, listItems = string.Empty, listCategories = string.Empty, blankmode = string.Empty;
        protected DataModel.RequestForQuotation RFQ = new DataModel.RequestForQuotation();
        protected string max_status = string.Empty;
        protected Boolean isAdmin = false;
        protected Boolean isUser = false;
        protected Boolean isEditable = false;
        protected string service_url, based_url = string.Empty;
        protected string moduleName = "REQUEST FOR QUOTATION";

        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                UserRoleAccess userRoleAccess = AccessControl.GetUserRoleAccess(AccessControlObjectEnum.ProcurementRFQ);

                if (!(userRoleAccess.isCanRead))
                {
                    Response.Redirect(AccessControl.GetSetting("access_denied"));
                    Log.Information("Don't have access control, redirecting...");
                }

                if (!(userRoleAccess.RoleNameInSystem == AccessControlRoleNameEnum.ProcurementLead) || !(userRoleAccess.RoleNameInSystem == AccessControlRoleNameEnum.ProcurementOfficer))
                {
                    isAdmin = true;
                }

                if (userRoleAccess.RoleNameInSystem == AccessControlRoleNameEnum.ProcurementAssistant)
                {
                    isUser = true;
                }

                if (userRoleAccess.isCanWrite)
                {
                    isEditable = true;
                }

                _id = Request.QueryString["id"] ?? "";
                blankmode = Request.QueryString["blankmode"] ?? "";
                service_url = statics.GetSetting("service_url");
                based_url = statics.GetSetting("based_url");

                this.recentComment.moduleId = _id;
                this.recentComment.moduleName = moduleName;

                this.udetail.rfq_id = _id;
            }
            catch(Exception ex)
            {
                ExceptionHelpers.PrintError(ex);
            }
           
        }

        [WebMethod]
        public static string RFQCancellation(string id, string comment, string comment_file)
        {
            string result, message = "";
            try
            {
                DataModel.Comment c = new DataModel.Comment();
                c.module_name = "REQUEST FOR QUOTATION";
                c.module_id = id;
                c.action_taken = "CANCELLED";
                c.comment = comment;
                c.comment_file = comment_file;
                statics.Comment.Save(c);

                statics.LifeCycle.Save(id, "REQUEST FOR QUOTATION", "95");

                staticsRFQ.Main.StatusUpdate(id, "95");

                result = "success";
            }
            catch (Exception ex)
            {
                result = "error";
                message = ExceptionHelpers.Message(ex);
                ExceptionHelpers.PrintError(ex);
            }
            return JsonConvert.SerializeObject(new
            {
                result = result,
                message = message
            });
        }

        [WebMethod]
        public static string SendEmail(string id, string template)
        {
            string result, message = "";
            try
            {
                NotificationHelper.RFQ_SendToVendorEmail(id, template);

                result = "success";
            }
            catch (Exception ex)
            {
                result = "error";
                message = ExceptionHelpers.Message(ex);
                ExceptionHelpers.PrintError(ex);
            }
            return JsonConvert.SerializeObject(new
            {
                result = result,
                message = message
            });
        }
    }
}