//using Microsoft.AspNet.Identity;
//using myTree.WebForms.K2Helper;
using myTree.WebForms.Procurement.General;
using myTree.WebForms.Procurement.General.K2Helper;
using myTree.WebForms.Procurement.Notification;
using Newtonsoft.Json;
using Serilog;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;
using System.Web;
using System.Web.Services;
using System.Web.UI.WebControls;

namespace myTree.WebForms.Modules.PurchaseRequisition
{
    public partial class FinanceVerification : System.Web.UI.Page
    {
        protected string _id = string.Empty, sn = string.Empty, activity_id = string.Empty, taskType = string.Empty, accessToken = String.Empty;
        protected string moduleName = "PURCHASE REQUISITION";
        protected Boolean isInWorkflow = false;
        protected DataModel.ApprovalNotes approval_notes = new DataModel.ApprovalNotes();

        protected string service_url, based_url = string.Empty;
        protected UserRoleAccess userRoleAccess = AccessControl.GetUserRoleAccess(AccessControlObjectEnum.ProcurementPurchaseRequisition);
        protected bool isAdmin, isUser, isFinance, isOfficer = false;

        //PurchaseRequisitionK2Helper prK2Helper = new PurchaseRequisitionK2Helper();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!HttpContext.Current.User.Identity.IsAuthenticated)
            {
                //HttpContext.Current.GetOwinContext().Authentication.Challenge();
            }
            else
            {
                if (!userRoleAccess.isCanRead && !userRoleAccess.isCanWrite)
                {
                    Response.Redirect(AccessControl.GetSetting("access_denied"));
                }

                isAdmin = userRoleAccess.RoleNameInSystem == AccessControlRoleNameEnum.ProcurementLead || userRoleAccess.RoleNameInSystem == AccessControlRoleNameEnum.ProcurementOfficer ? true : false;
                isUser = userRoleAccess.RoleNameInSystem == AccessControlRoleNameEnum.ProcurementAssistant ? true : false;

                _id = Request.QueryString["id"] ?? "";
                sn = Request.QueryString["sn"] ?? "";
                activity_id = Request.QueryString["activity_id"] ?? "";
                taskType = Request.QueryString["tasktype"] ?? "";
                taskType = taskType.ToLower();
                service_url = statics.GetSetting("service_url");
                based_url = statics.GetSetting("based_url");
                var username = statics.GetLogonUsername();
                accessToken = AccessControl.GetAccessToken();

                bool isAllowed = true;// prK2Helper.isUserAllowedToAccess(_id, username, "PurchaseRequisition", "CIPROCUREMENT", sn);
                if (!isAllowed)
                {
                    Response.Redirect(AccessControl.GetSetting("access_denied"));
                }

                //isInWorkflow = statics.CheckRequestEditable(_id, moduleName, sn);

                //if (!isInWorkflow && !String.IsNullOrEmpty(sn))
                //{
                //    Response.Redirect(statics.GetSetting("redirect_page"));
                //}

                //ApprovalNotes ApvNotes = new ApprovalNotes();// PurchaseRequisitionK2Helper.GetPRApvNotes(Convert.ToInt32(activity_id), username, _id);
                //approval_notes.activity_desc = ApvNotes.ApprovalNotesWording;
                //approval_notes.activity_name = ApvNotes.Role;
                this.recentComment.moduleId = _id;
                this.recentComment.moduleName = moduleName;
                this.predit1.page_id = _id;
                this.predit1.page_name = "finance_verification";
            }
        }

        [WebMethod]
        public static string Save(string submission, string deletedIds, string workflows)
        {
            string result, message = "",
                _id = "", _line_id = "", pr_no = "",
                moduleName = "PURCHASE REQUISITION", approval_no = "0";
            Boolean sendEmail = false, sendEmailUser = false, sendEmailRejected = false, sendEmailVerifyFinance = false, sendEmailClosed= false;
            int seq = 1;
            try
            {
                DataModel.Workflow workflow = JsonConvert.DeserializeObject<DataModel.Workflow>(workflows);
                DataModel.PurchaseRequisition pr = JsonConvert.DeserializeObject<DataModel.PurchaseRequisition>(submission);
                List<DataModel.DeletedId> dels = JsonConvert.DeserializeObject<List<DataModel.DeletedId>>(deletedIds);

                _id = pr.id;

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
                    if (workflow.action.ToLower() == "rejected")
                    {
                        pr.status_id = "90";
                        sendEmailRejected = true;
                        if (Boolean.Parse(statics.GetSetting("K2Active")))
                        {
                            //generalK2Help.Reject(dict, username, workflow.sn);
                            //prK2Help.CompareLog(_id, true, null, k2_process_name);
                        }
                    }
                    else if (workflow.action.ToLower() == "requested for revision")
                    {
                        pr.status_id = "10";
                        if (Boolean.Parse(statics.GetSetting("K2Active")))
                        {
                            //generalK2Help.Revise(dict, username, workflow.sn);
                        }
                    }
                    else if (workflow.action.ToLower() == "verified")
                    {
                        pr.status_id = "22";
                        if (Boolean.Parse(statics.GetSetting("K2Active")))
                        {
                            if (workflow.activity_id.ToLower() == K2ActivityEnum.FinanceVerification)
                            {
                                //generalK2Help.Verify(dict, username, workflow.sn);
                            }
                            else if (workflow.activity_id.ToLower() == K2ActivityEnum.PaymentProcessApproval)
                            {
                                pr.status_id = "50";
                                //generalK2Help.Approve(dict, username, workflow.sn);
                                sendEmailClosed = true;
                            }
                            //prK2Help.SaveApproveState(username, workflow.activity_id, _id, k2_process_name);
                        }
                    }
                    else if (workflow.action.ToLower() == "redirect")
                    {
                        pr.status_id = "20";
                        sendEmail = false;
                        sendEmailUser = false;
                        pr.is_procurement = "2";
                        _id = staticsPurchaseRequisition.Main.SaveIsProcurement(pr);
                        //staticsPurchaseRequisition.Main.RedirectUserList(pr);
                        if (Boolean.Parse(statics.GetSetting("K2Active")))
                        {
                            var taForK2 = staticsPurchaseRequisition.Main.GetDataForK2(_id);
                            if (taForK2 != null)
                            {
                                List<string> userIdNeedToRemove = new List<string>();
                                var requestorUserId = "";
                                var initiatorUserId = "";
                                var newProcOffId = "";
                                var procOfficeLead = "";

                                if (!string.IsNullOrEmpty(taForK2.Rows[0]["created_by"].ToString()))
                                {
                                    initiatorUserId = taForK2.Rows[0]["created_by"].ToString();
                                    userIdNeedToRemove.Add(initiatorUserId);
                                }

                                if (!string.IsNullOrEmpty(taForK2.Rows[0]["requestor_user_id"].ToString()))
                                {
                                    requestorUserId = taForK2.Rows[0]["requestor_user_id"].ToString();
                                    userIdNeedToRemove.Add(requestorUserId);
                                }

                                if (!string.IsNullOrEmpty(taForK2.Rows[0]["procurement_office_id"].ToString()))
                                {
                                    newProcOffId = taForK2.Rows[0]["procurement_office_id"].ToString();
                                }

                                if (!string.IsNullOrEmpty(taForK2.Rows[0]["procurement_office_lead"].ToString()))
                                {
                                    procOfficeLead = taForK2.Rows[0]["procurement_office_lead"].ToString();
                                }

                                if (!string.IsNullOrEmpty(taForK2.Rows[0]["procOffUser"].ToString()))
                                {
                                    var procurementOfficerUser = taForK2.Rows[0]["procOffUser"].ToString();
                                    var destinationProcOfficeList = procurementOfficerUser.Split(';').ToList();
                                    var procOffLeadList = new List<string>();
                                    procOffLeadList = procOfficeLead.Split(';').ToList();
                                    List<string> mergedProcOffList = destinationProcOfficeList.Union(procOffLeadList).ToList();
                                    mergedProcOffList.RemoveAll(x => userIdNeedToRemove.Contains(x.ToLower()));
                                    procurementOfficerUser = string.Join(";", mergedProcOffList);

                                    string instanceId = "";
                                    instanceId = workflow.sn.Substring(0, workflow.sn.IndexOf("_"));

                                    Dictionary<string, object> redirObj = new Dictionary<string, object>();
                                    redirObj.Add("ProcurementOfficerUser", procurementOfficerUser);
                                    redirObj.Add("ProcurementOfficerState", 0);
                                    redirObj.Add("ReservedFieldThree", newProcOffId);
                                    //var response = generalK2Help.K2UpdateProcessDataAPI(instanceId, redirObj);

                                    Console.WriteLine("Proc Off User: " + procurementOfficerUser);
                                    Console.WriteLine("Instance ID: " + instanceId);
                                    //Console.WriteLine("Status Update Process Data dengan API: " + response.Status.ToString() + " | " + response.Message.ToString());

                                    //if (response.Status)
                                    //{
                                    //    List<string> listOfProcOfficer = procurementOfficerUser.Split(';').ToList();
                                    //    List<K2ActivityUser> listProcOffUser = new List<K2ActivityUser>();
                                    //    if (listOfProcOfficer.Count > 0)
                                    //    {
                                    //        foreach (string user in listOfProcOfficer)
                                    //        {
                                    //            K2ActivityUser prcOffUser = new K2ActivityUser()
                                    //            {
                                    //                ActivityID = 5,
                                    //                Username = user
                                    //            };

                                    //            if (!string.IsNullOrEmpty(user))
                                    //            {
                                    //                listProcOffUser.Add(prcOffUser);
                                    //            }
                                    //        }
                                    //    }

                                    //    ////Perlu hapus Current All Proc di K2ActUser??
                                    //    //prK2Help.SaveProcOffFinanceK2ActUser(_id, listProcOffUser, k2_process_name);
                                    //    generalK2Help.Redirect(dict, username, workflow.sn);
                                    //    //PurchaseRequisitionK2Helper.ResetApproveStateByRelevantIdModuleAndActivityId(_id, k2_process_name, "5");
                                    //    //prK2Help.SaveApproveState(username, workflow.activity_id, _id, k2_process_name);
                                    //}
                                    //else
                                    //{
                                    //    throw new Exception("Error Redirect Finance to Procurement Officer. Error on Update Process Data. Error Message: " + response.Message);
                                    //}
                                }
                            }
                        }
                    }

                    foreach (DataModel.PurchaseRequisitionDetail prd in pr.details)
                    {
                        prd.pr_id = _id;
                        prd.line_no = seq.ToString();
                        _line_id = staticsPurchaseRequisition.Detail.Save(prd);
                        foreach (DataModel.Attachment att in prd.attachments)
                        {
                            att.document_id = _line_id;
                            att.document_type = moduleName;
                            statics.Attachment.Save(att);
                        }
                        seq++;
                    }

                    if (workflow.action.ToLower() != "saved")
                    {
                        /* update status */
                        pr_no = staticsPurchaseRequisition.Main.StatusUpdate(_id, pr.status_id);
                        if (!String.IsNullOrEmpty(pr.pr_no))
                        {
                            pr_no = pr.pr_no;
                        }
                    }

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
                    approval_no = statics.Comment.Save(comment);

                    if (workflow.action.ToLower() != "saved")
                    {
                        /* life cycle */
                        statics.LifeCycle.Save(_id, moduleName, pr.status_id);
                    }

                    /* send notification*/
                    if (sendEmail)
                    {
                        NotificationHelper.PR_WaitingForVerification(_id);
                    }

                    /* send notification to user*/
                    if (sendEmailUser)
                    {
                        NotificationHelper.PR_WaitingForVerificationUser(_id);
                    }

                    /* send notification Rejected*/
                    if (sendEmailRejected)
                    {
                        NotificationHelper.PR_Rejected(_id);
                    }

                    /* send notification verify finance*/
                    if (sendEmailClosed)
                    {
                        NotificationHelper.PR_Closed();
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
                    }
                    catch (Exception ex)
                    {
                        Log.Information("SyncK2Activity gagal. Id: " + _id);
                        ExceptionHelpers.PrintError(ex);
                    }

                    result = "success";
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
                id = _id,
                pr_no = pr_no
            });
        }
    }
}