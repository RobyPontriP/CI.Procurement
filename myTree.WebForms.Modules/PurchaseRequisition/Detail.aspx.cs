using myTree.WebForms.Procurement.General;
using Newtonsoft.Json;
using System;
using System.Data;
using System.Web;
using System.Web.Services;

namespace myTree.WebForms.Modules.PurchaseRequisition
{
    public partial class Detail : System.Web.UI.Page
    {
        protected string _id = string.Empty, blankmode = string.Empty, id_submission_page_type = string.Empty, submission_page_name = string.Empty;
        protected string moduleName = "PURCHASE REQUISITION";
        protected Boolean isEditable = false;
        protected Boolean isInWorkflow = false;
        protected Boolean isAdmin,isUser,isFinance = false;
        protected string UserId = string.Empty;
        protected string service_url, based_url = string.Empty;
        protected UserRoleAccess userRoleAccess = AccessControl.GetUserRoleAccess(AccessControlObjectEnum.ProcurementPurchaseRequisition);
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!HttpContext.Current.User.Identity.IsAuthenticated)
            {
                //HttpContext.Current.GetOwinContext().Authentication.Challenge();
            }
            else
            {
                UserRoleAccess userRoleAccess = AccessControl.GetUserRoleAccess(AccessControlObjectEnum.ProcurementPurchaseRequisition);
                if (!userRoleAccess.isCanRead)
                {
                    Response.Redirect(AccessControl.GetSetting("access_denied"));
                }

                _id = Request.QueryString["id"] ?? "";
                id_submission_page_type = Request.QueryString["submission_page_type"] ?? "";
                blankmode = Request.QueryString["blankmode"] ?? "";
                isEditable = statics.CheckRequestEditable(_id, moduleName, "");
                isInWorkflow = statics.isInWorkflow(_id, moduleName);
                UserId = statics.GetLogonUsername();
                service_url = statics.GetSetting("service_url");
                based_url = statics.GetSetting("based_url");

                isAdmin = userRoleAccess.RoleNameInSystem == AccessControlRoleNameEnum.ProcurementLead || userRoleAccess.RoleNameInSystem == AccessControlRoleNameEnum.ProcurementOfficer ? true : false;
                isUser = userRoleAccess.RoleNameInSystem == AccessControlRoleNameEnum.ProcurementAssistant ? true : false;
                isFinance = userRoleAccess.RoleNameInSystem == AccessControlRoleNameEnum.Finance ? true : false;

                DataTable dtSubmissionPageType = statics.GetSubmissionPageType(_id,moduleName);

                if (dtSubmissionPageType.Rows.Count > 0)
                {
                    foreach (DataRow item in dtSubmissionPageType.Rows)
                    {
                        if (item["id"].ToString() == id_submission_page_type)
                        {
                            submission_page_name = item["page_type"].ToString();
                        }

                        if (string.IsNullOrEmpty(id_submission_page_type))
                        {
                            id_submission_page_type = item["id"].ToString();
                        }
                    }
                }

                this.recentCommentDetail.moduleId = _id;
                this.recentCommentDetail.moduleName = moduleName;
                this.prdetail1.page_id = _id;
                this.prdetail1.page_type = "detail";
                this.historicalInformation1.moduleId = _id;
                this.historicalInformation1.moduleName = moduleName;
                this.financialReport1.usrFinance = userRoleAccess.RoleNameInSystem == AccessControlRoleNameEnum.Finance ? true : false;
                //this.confirmationForm.page_type = "send";
                this.confirmationList.pr_id = _id;
            }
        }

        [WebMethod]
        public static string Return(string id, string workflows)
        {
            string result, message = "";
            DataModel.Workflow workflow = JsonConvert.DeserializeObject<DataModel.Workflow>(workflows);

            try
            {
                /* insert comment */
                DataModel.Comment comment = new DataModel.Comment
                {
                    module_id = id,
                    module_name = "PURCHASE REQUISITION",
                    comment = workflow.comment,
                    comment_file = workflow.comment_file,
                    action_taken = workflow.action,
                    activity_id = workflow.activity_id,
                    roles = workflow.roles
                };
                statics.Comment.Save(comment);

                staticsPurchaseRequisition.Main.SetReturn(id, "1");

                /* life cycle */
                statics.LifeCycle.Save(id, "PURCHASE REQUISITION", "10");
                result = "success";
            }
            catch (Exception ex)
            {
                result = "error";
                message = ex.ToString();
                ExceptionHelpers.PrintError(ex);
            }
            return JsonConvert.SerializeObject(new
            {
                result = result,
                message = message,
                id = id
            });
        }
    }
}