//using IdentityModel;
//using myTree.WebForms.K2Helper;
using myTree.WebForms.Procurement.General;
using myTree.WebForms.Procurement.General.K2Helper.PurchaseOrder;
using myTree.WebForms.Procurement.General.K2Helper.PurchaseOrder.Models;
using myTree.WebForms.Procurement.Notification;
using Newtonsoft.Json;
using Serilog;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Drawing;
using System.Threading;
using System.Threading.Tasks;
using System.Web;
using System.Web.Services;

namespace Procurement.PurchaseOrder
{
    public partial class Approval : System.Web.UI.Page
    {
        protected string _id = string.Empty
            , sn = string.Empty
            , activity_id = string.Empty
            , approval_type = string.Empty
            , approval_type_label = string.Empty
            , taskType = string.Empty
            , accessToken = string.Empty;
        protected DataModel.ApprovalNotes approval_notes = new DataModel.ApprovalNotes();
        protected string moduleName = "PURCHASE ORDER";
        protected string based_url = string.Empty;

        protected UserRoleAccess userRoleAccess = AccessControl.GetUserRoleAccess(AccessControlObjectEnum.ProcurementPurchaseOrder);
        protected Boolean isInWorkflow = false;
        readonly PurchaseOrderK2Helper poK2Helper = new PurchaseOrderK2Helper();
        protected Boolean isAdmin, isUser, isFinance = false;

        protected void Page_Load(object sender, EventArgs e)
        {

            if (!HttpContext.Current.User.Identity.IsAuthenticated)
            {
                //HttpContext.Current.GetOwinContext().Authentication.Challenge();
            }
            else
            {
                _id = Request.QueryString["id"] ?? "";
                sn = Request.QueryString["sn"] ?? "";
                activity_id = Request.QueryString["activity_id"] ?? "";
                taskType = Request.QueryString["tasktype"] ?? "";
                taskType = taskType.ToLower();
                var username = statics.GetLogonUsername();
                accessToken = AccessControl.GetAccessToken();
                based_url = statics.GetSetting("based_url");
                isInWorkflow = statics.isInWorkflow(_id, moduleName);

                UserRoleAccess access = AccessControl.GetUserRoleAccess(AccessControlObjectEnum.ProcurementPurchaseOrder);
                if (!access.isCanRead && !access.isCanWrite)
                {
                    Response.Redirect(AccessControl.GetSetting("access_denied"));
                }

                bool isAllowed = true;//poK2Helper.isUserAllowedToAccess(_id, username, "PurchaseOrder", "CIPROCUREMENT", sn);
                if (!isAllowed)
                {
                    Response.Redirect(AccessControl.GetSetting("access_denied"));
                }

                //ApprovalNotes ApvNotes = new ApprovalNotes();// PurchaseOrderK2Helper.GetPOApvNotes(Convert.ToInt32(activity_id), username, _id);
                //approval_notes.activity_desc = ApvNotes.ApprovalNotesWording;
                //approval_notes.activity_name = ApvNotes.Role;

                isAdmin = userRoleAccess.RoleNameInSystem == AccessControlRoleNameEnum.ProcurementLead || userRoleAccess.RoleNameInSystem == AccessControlRoleNameEnum.ProcurementOfficer ? true : false;
                isUser = userRoleAccess.RoleNameInSystem == AccessControlRoleNameEnum.ProcurementAssistant ? true : false;
                isFinance = userRoleAccess.RoleNameInSystem == AccessControlRoleNameEnum.Finance ? true : false;

                this.recentCommentDetail.moduleId = _id;
                this.recentCommentDetail.moduleName = moduleName;
                this.pod1.page_id = _id;
                this.povs1.page_id = _id;
                this.povs1.page_type = "approval";
                this.historicalInformation1.moduleId = _id;
                this.historicalInformation1.moduleName = moduleName;

                if (!string.IsNullOrEmpty(activity_id))
                {
                    List<int> approvalActivity = new List<int> { EnumK2PO.ProcurementLeaderApproval, EnumK2PO.CountryDirectorApproval, EnumK2PO.HeadOfOperationApproval, EnumK2PO.CFOApproval, EnumK2PO.ContinentDirectorApproval, EnumK2PO.DCSApproval, EnumK2PO.DGApproval };
                    List<int> verificationActivity = new List<int> { EnumK2PO.ProcurementLeaderVerification };
                    List<int> recommendationActivity = new List<int> { EnumK2PO.CountryDirectorRecommendation, EnumK2PO.HeadOfOperationRecommendation, EnumK2PO.CFORecommendation, EnumK2PO.DCSRecommendation };

                    if (verificationActivity.Contains(int.Parse(activity_id)))
                    {
                        approval_type = "verified";
                        approval_type_label = "Verify";
                    }
                    else if (recommendationActivity.Contains(int.Parse(activity_id)))
                    {
                        approval_type = "recommended";
                        approval_type_label = "Recommend";
                    }
                    else
                    {
                        approval_type = "approved";
                        approval_type_label = "Approve";
                    }
                }
            }

        }

        [WebMethod]
        public static string Submit(string purchaseorders, string workflows)
        {
            string result, message = string.Empty,
                //_id = "", 
                moduleName = "PURCHASE ORDER", approval_no = "0", status_id = string.Empty;

            var Objpurchaseorder = new { id = string.Empty, po_no = string.Empty, remarks = string.Empty };
            var purchaseorder = JsonConvert.DeserializeAnonymousType(purchaseorders, Objpurchaseorder);
            try
            {
                DataModel.Workflow workflow = JsonConvert.DeserializeObject<DataModel.Workflow>(workflows);
                bool isRequesterActive = statics.CheckActiveRequester(purchaseorder.id, moduleName);

                /* insert comment */
                DataModel.Comment comment = new DataModel.Comment
                {
                    module_id = purchaseorder.id,
                    module_name = moduleName,
                    comment = workflow.comment,
                    action_taken = workflow.action,
                    activity_id = workflow.activity_id,
                    roles = workflow.roles
                };
                status_id = workflow.current_status;
                workflow.action = workflow.action.ToLower();

                //CIFOR.Lib.WorkflowIntegration.ExecuteWorkflow K2 = new CIFOR.Lib.WorkflowIntegration.ExecuteWorkflow();
                string k2ApiKey = statics.GetSetting("K2ApiKey");
                string k2ApiEndPoint = statics.GetSetting("K2ApiEndpoint");
                string k2_folder_name = statics.GetSetting("K2FolderName");
                string k2_process_name = statics.GetSetting("K2ProcessNamePO");
                //K2Helpers //generalK2Help = new K2Helpers(k2ApiKey, k2ApiEndPoint);
                PurchaseOrderK2Helper poK2Help = new PurchaseOrderK2Helper();
                Dictionary<string, object> dict = new Dictionary<string, object>();
                var username = statics.GetLogonUsername();

                bool isAllowed = true;//poK2Help.isUserAllowedToAccess(purchaseorder.id, username, "PurchaseOrder", "CIPROCUREMENT", workflow.sn);
                if (isAllowed)
                {
                    if (workflow.action == "approved" || workflow.action == "verified" || workflow.action == "recommended")
                    {
                        if (workflow.action == "verified")
                        {
                            //generalK2Help.Verify(dict, username, workflow.sn);
                            status_id = "15";
                        }
                        else if (workflow.action == "recommended")
                        {
                            //generalK2Help.Recommend(dict, username, workflow.sn);
                            status_id = "15";
                        }
                        else
                        {
                            //generalK2Help.Approve(dict, username, workflow.sn);
                            status_id = "25";
                            statics.SaveOCSMFLQueue("Procurement", purchaseorder.id, purchaseorder.po_no, "Submitted", string.Empty);
                        }
                        isRequesterActive = true;
                        //poK2Help.SaveApproveState(username, workflow.activity_id, purchaseorder.id, "PurchaseOrder");
                    }
                    else if (workflow.action == "rejected")
                    {
                        isRequesterActive = true;
                        status_id = "30";
                        if (Boolean.Parse(statics.GetSetting("K2Active")))
                        {
                            //generalK2Help.Reject(dict, username, workflow.sn);
                            //poK2Help.CompareLog(purchaseorder.id, true, null, "PurchaseOrder");
                        }
                    }
                    else if (workflow.action == "requested for revision")
                    {
                        isRequesterActive = true;
                        status_id = "10";
                        if (Boolean.Parse(statics.GetSetting("K2Active")))
                        {
                            //generalK2Help.Revise(dict, username, workflow.sn);
                        }
                    }

                    if (isRequesterActive)
                    {

                        /* update status */
                        staticsPurchaseOrder.Main.StatusUpdate(purchaseorder.id, status_id);

                        /* insert comment */
                        approval_no = statics.Comment.Save(comment);

                        /* life cycle */
                        statics.LifeCycle.Save(purchaseorder.id, moduleName, status_id);

                        /* send notification */
                        if (status_id == "25")
                        {
                            NotificationHelper.PO_ApprovedToUser(purchaseorder.id);
                            NotificationHelper.PO_Approved(purchaseorder.id);
                        }

                        result = "success";
                    }
                    else
                    {
                        result = "error";
                        message = "Requester is not an active staff. Please reject the request.";
                    }

                    try
                    {
                        Log.Information("SyncK2Activity");
                        Log.Information("Id: " + purchaseorder.id);
                        Log.Information("Folder Name: " + k2_folder_name);
                        Log.Information("Process name:" + k2_process_name);
                        Log.Information("URL:" + ConfigurationManager.AppSettings["MySubmissionSvcEndpoint"].ToString());

                        Thread.Sleep(5000);
                        //string ret = //generalK2Help.SyncK2Activity(_id, k2_folder_name, k2_process_name);
                        //var approvalTask = Task.Run(() => //generalK2Help.SyncK2Approval(purchaseorder.id));
                        //var processTask = Task.Run(() => //generalK2Help.SyncK2Process(purchaseorder.id));
                        //var activityTask = Task.Run(() => //generalK2Help.SyncK2ActivityName(purchaseorder.id));
                        //var activeActivityTask = Task.Run(() => //generalK2Help.SyncK2Activity(purchaseorder.id, k2_folder_name, k2_process_name));

                        //Task.WhenAll(approvalTask, processTask, activityTask, activeActivityTask);
                        Log.Information("Return: All Sync Passed");

                        Thread.Sleep(3000);

                    }
                    catch (Exception ex)
                    {
                        Log.Information("SyncK2Activity gagal. Id: " + purchaseorder.id);
                        ExceptionHelpers.PrintError(ex);
                    }
                }
                else
                {
                    result = "errorwf";
                    message = "The data has already taken.";
                }
            }
            catch (Exception ex)
            {
                result = "error";
                message = ex.ToString();
                ExceptionHelpers.PrintError(ex);
            }
            return JsonConvert.SerializeObject(new
            {
                result,
                message,
                purchaseorder.id
            });
        }
    }
}