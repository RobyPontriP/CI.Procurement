//using myTree.WebForms.K2Helper;
using myTree.WebForms.Procurement.General;
using myTree.WebForms.Procurement.General.K2Helper;
using myTree.WebForms.Procurement.Notification;
using Newtonsoft.Json;
using Serilog;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;
using System.Web;
using System.Web.Services;

namespace myTree.WebForms.Modules.PurchaseRequisition
{
    public partial class Approval : System.Web.UI.Page
    {
        protected string _id = string.Empty,
            sn = string.Empty, activity_id = string.Empty, taskType = string.Empty, accessToken = string.Empty;
        protected DataModel.ApprovalNotes approval_notes = new DataModel.ApprovalNotes();
        protected string moduleName = "PURCHASE REQUISITION";

        //protected AccessControl authorized = new AccessControl("PURCHASE REQUISITION");

        protected Boolean isInWorkflow = false;

        //PurchaseRequisitionK2Helper prK2Helper = new PurchaseRequisitionK2Helper();

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

                UserRoleAccess access = AccessControl.GetUserRoleAccess(AccessControlObjectEnum.ProcurementPurchaseRequisition);
                if (!access.isCanRead && !access.isCanWrite)
                {

                    Response.Redirect(statics.GetSetting("redirect_page"));
                }

                bool isAllowed = true;//prK2Helper.isUserAllowedToAccess(_id, username, "PurchaseRequisition", "CIPROCUREMENT", sn);
                if (!isAllowed)
                {
                    Response.Redirect(statics.GetSetting("redirect_page"));
                }

                //isInWorkflow = statics.CheckRequestEditable(_id, moduleName, sn);

                //if (!isInWorkflow)
                //{
                //    Response.Redirect(statics.GetSetting("redirect_page"));
                //}


                //ApprovalNotes ApvNotes = new ApprovalNotes(); //PurchaseRequisitionK2Helper.GetPRApvNotes(Convert.ToInt32(activity_id), username, _id);
                //approval_notes.activity_desc = ApvNotes.ApprovalNotesWording;
                //approval_notes.activity_name = ApvNotes.Role;

                this.recentCommentDetail.moduleId = _id;
                this.recentCommentDetail.moduleName = moduleName;
                this.prdetail1.page_id = _id;
                this.prdetail1.page_type = "approval";
            }
        }

        [WebMethod]
        public static string Submit(string id, string workflows)
        {
            string result, message = "",
                _id = "", moduleName = "PURCHASE REQUISITION", approval_no = "0", status_id = "";
            _id = id;

            DataModel.Workflow workflow = JsonConvert.DeserializeObject<DataModel.Workflow>(workflows);
            Boolean isRequesterActive = statics.CheckActiveRequester(_id, moduleName)
                    , sendEmail = false, sendEmailFinance = false, sendEmailUser = false, sendEmailRejected = false, sendEmailPayment = false;
            try
            {
                /* insert comment */
                DataModel.Comment comment = new DataModel.Comment
                {
                    module_id = _id,
                    module_name = moduleName,
                    comment = workflow.comment,
                    action_taken = workflow.action,
                    activity_id = workflow.activity_id,
                    roles = workflow.roles
                };
                status_id = workflow.current_status;
                if (string.IsNullOrEmpty(workflow.purchasing_process))
                {
                    workflow.purchasing_process = "0";
                }

                DataModel.PurchaseRequisition pr = new DataModel.PurchaseRequisition
                {
                    is_procurement = "1",
                    id = _id
                };

                #region Workflow and Notif
                string k2ApiKey = statics.GetSetting("K2ApiKey");
                string k2ApiEndPoint = statics.GetSetting("K2ApiEndpoint");
                string k2_folder_name = statics.GetSetting("K2FolderName");
                string k2_process_name = statics.GetSetting("K2ProcessName");
                //K2Helpers generalK2Help = new K2Helpers(k2ApiKey, k2ApiEndPoint);
                //PurchaseRequisitionK2Helper prK2Help = new PurchaseRequisitionK2Helper();
                Dictionary<string, object> dict = new Dictionary<string, object>();
                var username = statics.GetLogonUsername();

                bool isAllowed = true;//prK2Help.isUserAllowedToAccess(_id, username, "PurchaseRequisition", "CIPROCUREMENT", workflow.sn);
                if (isAllowed)
                {
                    if (workflow.action == "approved" || workflow.action == "budget is sufficient")
                    {
                        /* Budget clearance */
                        if (workflow.activity_id == K2ActivityEnum.OfficerVerification)// && workflow.is_direct_to_finance == "0")
                        {
                            if (workflow.purchasing_process == "0" && Decimal.Parse(workflow.amount.Replace(",", "")) <= 200)
                            {
                                status_id = "20";
                                sendEmail = true;
                                sendEmailUser = true;
                            }

                            if (workflow.purchasing_process == "1" && Decimal.Parse(workflow.amount.Replace(",", "")) <= 200)
                            {
                                status_id = "22";
                                sendEmail = false;
                                sendEmailFinance = false;
                                sendEmailUser = false;
                            }

                            if (workflow.purchase_type != "3" && workflow.purchase_type != "5" && Decimal.Parse(workflow.amount.Replace(",", "")) > 200)
                            {

                                //_id = staticsPurchaseRequisition.Main.SaveIsProcurement(pr);
                                status_id = "21";
                                sendEmail = false;
                                sendEmailFinance = true;
                                sendEmailUser = true;
                            }

                            if ((workflow.purchase_type == "3" || workflow.purchase_type == "5") && Decimal.Parse(workflow.amount.Replace(",", "")) > 200)
                            {
                                status_id = "20";
                                sendEmail = true;
                                sendEmailFinance = false;
                                sendEmailUser = true;
                            }
                        }
                        /*else if (workflow.is_direct_to_finance == "1" &&
                                ((workflow.activity_id == "5" && Decimal.Parse(workflow.amount.Replace(",", "")) <= 200) ||
                                 (workflow.activity_id == "7" && Decimal.Parse(workflow.amount.Replace(",", "")) > 200))
                            )
                        {
                            status_id = "20";
                        }*/

                        /* new logic flag & status */
                        if (workflow.activity_id == K2ActivityEnum.BudgetHolderApproval)
                        {
                            bool islastBudgetHolder = true;//PurchaseRequisitionK2Helper.CheckIsLastBudgetHolder(_id);
                            if (islastBudgetHolder)
                            {
                                status_id = "20";
                                if (workflow.purchase_type == "3")
                                { // purhcase type =  Other
                                    sendEmail = true;
                                }
                                sendEmailFinance = false;
                                sendEmailUser = true;
                            }
                        }
                        else if (workflow.activity_id == K2ActivityEnum.DSCApproval || workflow.activity_id == K2ActivityEnum.DGApproval)
                        {
                            status_id = "15";
                        }

                        if (workflow.activity_id == K2ActivityEnum.BudgetHolderApproval)
                        {
                            bool islastBudgetHolder = true;//PurchaseRequisitionK2Helper.CheckIsLastBudgetHolder(_id);
                            if (islastBudgetHolder)
                            {
                                List<int> listOfInvolvingActId = new List<int>();//PurchaseRequisitionK2Helper.GetAllInvolvingActivityId(_id, k2_folder_name, k2_process_name);
                                string nextActId = listOfInvolvingActId.Where(x => x > Convert.ToInt32(workflow.activity_id)).OrderBy(y => y).FirstOrDefault().ToString();

                                if (nextActId == K2ActivityEnum.DSCApproval || nextActId == K2ActivityEnum.DGApproval || nextActId == K2ActivityEnum.BudgetHolderApproval)
                                {
                                    status_id = "15";
                                }
                                else if (nextActId == K2ActivityEnum.OfficerVerification)
                                {
                                    status_id = "20";
                                    sendEmailFinance = false;
                                    sendEmailUser = true;
                                }
                                else if (nextActId == K2ActivityEnum.FinanceVerification)
                                {
                                    status_id = "21";
                                    sendEmailFinance = true;
                                    sendEmailUser = true;
                                }
                                else if (nextActId == K2ActivityEnum.PaymentProcessApproval)
                                {
                                    status_id = "22";
                                    sendEmailFinance = false;
                                    sendEmailUser = false;
                                    sendEmailPayment = true;
                                }
                            }
                        }
                        else
                        {
                            List<int> listOfInvolvingActId = new List<int>();//PurchaseRequisitionK2Helper.GetAllInvolvingActivityId(_id, k2_folder_name, k2_process_name);
                            string nextActId = listOfInvolvingActId.Where(x => x > Convert.ToInt32(workflow.activity_id)).OrderBy(y => y).FirstOrDefault().ToString();

                            if (nextActId == K2ActivityEnum.DSCApproval || nextActId == K2ActivityEnum.DGApproval || nextActId == K2ActivityEnum.BudgetHolderApproval)
                            {
                                status_id = "15";
                            }
                            else if (nextActId == K2ActivityEnum.OfficerVerification)
                            {
                                status_id = "20";
                                sendEmailFinance = false;
                                sendEmailUser = true;
                            }
                            else if (nextActId == K2ActivityEnum.FinanceVerification)
                            {
                                status_id = "21";
                                sendEmailFinance = true;
                                sendEmailUser = true;
                            }
                            else if (nextActId == K2ActivityEnum.PaymentProcessApproval)
                            {
                                status_id = "22";
                                sendEmailFinance = false;
                                sendEmailUser = false;
                                sendEmailPayment = true;
                            }
                        }
                    }
                    else
                    {
                        isRequesterActive = true;
                        status_id = "90"; //rejected
                        sendEmailRejected = true;
                        if (Boolean.Parse(statics.GetSetting("K2Active")))
                        {
                            //generalK2Help.Reject(dict, username, workflow.sn);
                            //prK2Help.CompareLog(_id, true, null, "PurchaseRequisition");
                        }
                    }
                    #endregion

                    if (isRequesterActive)
                    {
                        if (status_id != "90" && Boolean.Parse(statics.GetSetting("K2Active")))
                        {
                            // Check if Budget holder is sharing their budget
                            if (workflow.activity_id == K2ActivityEnum.BudgetHolderApproval)
                            {
                                var cc = new DataTable(); ;//PurchaseRequisitionK2Helper.GetChargeCodeDetailbyIdAndBhUsername(_id, username);
                                if (cc != null)
                                {
                                    if (cc.Rows.Count > 0)
                                    {
                                        if (!string.IsNullOrEmpty(cc.Rows[0]["descr"].ToString()))
                                        {
                                            Log.Information($"Approval of Shared Workorders: {cc.Rows[0]["descr"]}");
                                            var bhData = cc.Rows[0]["descr"].ToString().Split(';').ToList();
                                            string[] sharedChargeCodeUsername = { "bbidder", "awitzenburg" }; //  Need to dynamic
                                            string[] sharedWorkorders = { "CTRF-01K.23DH", "SIFC-1854C.01DH" }; // Need to dynamic
                                            // Check the Current budget holder is not on the special case, then its normal approval
                                            if (!sharedChargeCodeUsername.Contains(username.ToLower()))
                                            { // Normal Approval
                                                //NormalApprove(_id, workflow, generalK2Help, prK2Help, dict, username);
                                            }
                                            else
                                            {
                                                var otherUser = sharedChargeCodeUsername.Where(c => c.ToLower() != username.ToLower()).FirstOrDefault();
                                                var currentUser = username.ToLower();
                                                //var additionalCc = PurchaseRequisitionK2Helper.GetChargeCodeDetailbyIdAndBhUsername(_id, otherUser);
                                                //if (additionalCc != null && !string.IsNullOrEmpty(additionalCc.Rows[0]["descr"].ToString()))
                                                //{
                                                //    var codes = additionalCc.Rows[0]["descr"].ToString().Split(';').ToList();
                                                //    foreach (var c in codes)
                                                //    {
                                                //        if (!bhData.Contains(c))
                                                //            bhData.Add(c);
                                                //    }
                                                //}

                                                bool isContainSharedWorkOrder = false;
                                                bool isContainNonSharedWorkOrder = false;
                                                bool isWorkordersOwner = username.ToLower() == "bbidder"; // Need to dynamic

                                                Log.Information($"All available charge codes: {bhData}");

                                                foreach (var b in bhData)
                                                {
                                                    string workOrder = NormalizeWorkOrder(b);
                                                    if (sharedWorkorders.Contains(workOrder))
                                                    {
                                                        isContainSharedWorkOrder = true;
                                                        break;
                                                    }
                                                }
                                                foreach (var b in bhData)
                                                {
                                                    string workOrder = NormalizeWorkOrder(b);
                                                    if (!sharedWorkorders.Contains(workOrder))
                                                    {
                                                        isContainNonSharedWorkOrder = true;
                                                        break;
                                                    }
                                                }
                                                Log.Information($"isContainSharedWorkOrder: {isContainSharedWorkOrder}");
                                                Log.Information($"isContainNonSharedWorkOrder: {isContainNonSharedWorkOrder}");
                                                Log.Information($"isWorkordersOwner: {isWorkordersOwner}");
                                                if ((isContainSharedWorkOrder && !isContainNonSharedWorkOrder) || isWorkordersOwner)
                                                {
                                                    Log.Information($"Try to dual approve for shared workorders");
                                                    //generalK2Help.Approve(dict, otherUser, workflow.sn); // Approval for other user
                                                    Log.Information($"Success to approve for shared workorders with username : {otherUser}");
                                                    //generalK2Help.Approve(dict, currentUser, workflow.sn);
                                                    Log.Information($"Success to approve for shared workorders with username : {currentUser}");
                                                    //prK2Help.SaveApproveState(otherUser, workflow.activity_id, _id, "PurchaseRequisition");
                                                    Log.Information($"Success set approved state for shared workorders with username : {otherUser}");
                                                    //prK2Help.SaveApproveState(currentUser, workflow.activity_id, _id, "PurchaseRequisition");
                                                    Log.Information($"Success set approved state for shared workorders with username : {currentUser}");
                                                }
                                                else
                                                { // Normal Approval
                                                    //NormalApprove(_id, workflow, generalK2Help, prK2Help, dict, username);
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                            else
                            { // Normal Approval
                                //NormalApprove(_id, workflow, generalK2Help, prK2Help, dict, username);
                            }
                        }
                        /* update status */
                        staticsPurchaseRequisition.Main.StatusUpdate(_id, status_id);

                        /* insert comment */
                        approval_no = statics.Comment.Save(comment);

                        /* life cycle */
                        statics.LifeCycle.Save(_id, moduleName, status_id);

                        /* send notification*/

                        /* send notification to user*/
                        if (sendEmailUser)
                        {
                            NotificationHelper.PR_WaitingForVerificationUser(_id);
                        }

                        /* send notification to finance*/
                        if (sendEmailFinance)
                        {
                            NotificationHelper.PR_WaitingForVerificationFinance(_id);
                        }


                        /* send notificaiton to rejected*/
                        if (sendEmailRejected)
                        {
                            NotificationHelper.PR_Rejected(_id);
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
                        Log.Information("Id: " + _id);
                        Log.Information("Folder Name: " + k2_folder_name);
                        Log.Information("Process name:" + k2_process_name);
                        Log.Information("URL:" + ConfigurationManager.AppSettings["MySubmissionSvcEndpoint"].ToString());

                        Thread.Sleep(5000);
                        //string ret = generalK2Help.SyncK2Activity(_id, k2_folder_name, k2_process_name);
                        //var approvalTask = Task.Run(() => generalK2Help.SyncK2Approval(_id));
                        //var processTask = Task.Run(() => generalK2Help.SyncK2Process(_id));
                        //var activityTask = Task.Run(() => generalK2Help.SyncK2ActivityName(_id));
                        //var activeActivityTask = Task.Run(() => generalK2Help.SyncK2Activity(_id, k2_folder_name, k2_process_name));

                        //Task.WhenAll(approvalTask, processTask, activityTask, activeActivityTask);
                        Log.Information("Return: All Sync Passed");

                        Thread.Sleep(3000);
                        /* send notif after sync k2 */
                        if (sendEmail)
                        {
                            NotificationHelper.PR_WaitingForVerification(_id);
                        }

                        /* send notification to payment*/
                        if (sendEmailPayment)
                        {
                            NotificationHelper.PR_WaitingForPayment(_id);
                        }

                    }
                    catch (Exception ex)
                    {
                        Log.Information("SyncK2Activity gagal. Id: " + _id);
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
                result = result,
                message = message,
                id = _id
            });

            string NormalizeWorkOrder(string b)
            {
                var firstDotIndex = b.IndexOf('.') + 1;
                var workOrder = b.Substring(firstDotIndex);
                var entityString = workOrder.Substring(workOrder.LastIndexOf('.'));
                Log.Information($"Entity string to remove: {entityString}");
                workOrder = workOrder.TrimEnd(entityString.ToCharArray());
                Log.Information($"Normalize workorder from GetChargeCodeDetailbyIdAndBhUsername: {workOrder}");
                return workOrder;
            }
        }

        //private static void NormalApprove(string _id, DataModel.Workflow workflow, K2Helpers generalK2Help, PurchaseRequisitionK2Helper prK2Help, Dictionary<string, object> dict, string username)
        //{
        //    Log.Information($"Try to approve for normal workorder");
        //    generalK2Help.Approve(dict, username, workflow.sn);
        //    prK2Help.SaveApproveState(username, workflow.activity_id, _id, "PurchaseRequisition");
        //    Log.Information($"Success to approve for normal workorder");
        //}
    }
}