//using IdentityModel;
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
    public partial class Payment : System.Web.UI.Page
    {
        protected string _id = string.Empty,
            sn = string.Empty, activity_id = string.Empty, taskType = string.Empty, statusId = string.Empty, accessToken = String.Empty, listPRType = string.Empty;
        protected DataModel.ApprovalNotes approval_notes = new DataModel.ApprovalNotes();
        protected string moduleName = "PURCHASE REQUISITION";

        protected Boolean isInWorkflow = false;
        protected bool isAdmin, isUser, isFinance, isOfficer = false;

        protected string service_url, based_url = string.Empty;

        //PurchaseRequisitionK2Helper prK2Helper = new PurchaseRequisitionK2Helper();

        protected void Page_Load(object sender, EventArgs e)
        {
            UserRoleAccess userRoleAccess = AccessControl.GetUserRoleAccess(AccessControlObjectEnum.ProcurementPurchaseRequisition);

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
                isFinance = userRoleAccess.RoleNameInSystem == AccessControlRoleNameEnum.Finance ? true : false;

                _id = Request.QueryString["id"] ?? "";
                sn = Request.QueryString["sn"] ?? "";
                activity_id = Request.QueryString["activity_id"] ?? "";
                taskType = Request.QueryString["tasktype"] ?? "";
                taskType = taskType.ToLower();
                var username = statics.GetLogonUsername();
                accessToken = myTree.WebForms.Procurement.General.AccessControl.GetAccessToken();
                service_url = statics.GetSetting("service_url");
                based_url = statics.GetSetting("based_url");

                bool isAllowed = true;//prK2Helper.isUserAllowedToAccess(_id, username, "PurchaseRequisition", "CIPROCUREMENT", sn);
                if (!isAllowed)
                {
                    Response.Redirect(AccessControl.GetSetting("access_denied"));
                }

                if (!string.IsNullOrEmpty(_id))
                {
                    DataSet ds = staticsPurchaseRequisition.GetStatusId(_id);
                    if (ds.Tables.Count > 0)
                    {
                        statusId = ds.Tables[0].Rows[0]["status_id"].ToString();
                    }
                }

                isInWorkflow = statics.CheckRequestEditable(_id, moduleName, sn);

                //if (!isInWorkflow && statusId != "50")
                //{
                //    Response.Redirect(statics.GetSetting("redirect_page"));
                //}
                //if (statusId != "50")
                //{
                //    Response.Redirect(statics.GetSetting("redirect_page"));
                //}
                listPRType = JsonConvert.SerializeObject(statics.GetPRType());

                //ApprovalNotes ApvNotes = new ApprovalNotes();// PurchaseRequisitionK2Helper.GetPRApvNotes(Convert.ToInt32(activity_id), username, _id);
                //approval_notes.activity_desc = ApvNotes.ApprovalNotesWording;
                //approval_notes.activity_name = ApvNotes.Role;

                this.recentComment.moduleId = _id;
                this.recentComment.moduleName = moduleName;
                this.prdetail1.page_id = _id;
                this.prdetail1.page_type = "payment";
                //this.prdetail.page_id = _id;
                //this.prdetail.page_name = "payment";
            }
        }

        [WebMethod]
        public static string Submit(string id, string submission, string deletedIds, string workflows)
        {
            string result, message = "", pr_no = "",
                _id = "", moduleName = "PURCHASE REQUISITION", approval_no = "0", status_id = "";
            _id = id;

            DataModel.Workflow workflow = JsonConvert.DeserializeObject<DataModel.Workflow>(workflows);
            DataModel.PurchaseRequisition pr = JsonConvert.DeserializeObject<DataModel.PurchaseRequisition>(submission);
            List<DataModel.DeletedId> dels = JsonConvert.DeserializeObject<List<DataModel.DeletedId>>(deletedIds);
            Boolean isRequesterActive = statics.CheckActiveRequester(_id, moduleName)
                    , sendEmail = false, sendEmailRejected = false, sendEmailVerifyFinance = false, sendEmailWaitingForVerification = false;
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

                    if (workflow.action == "verified")
                    {
                        /* Budget clearance */
                        if (workflow.activity_id == K2ActivityEnum.PaymentProcessApproval)// && workflow.is_direct_to_finance == "0")
                        {
                            status_id = "50";
                            sendEmail = true;
                        }

                        if (workflow.activity_id == "7")
                        {
                            sendEmailVerifyFinance = true;
                        }


                        pr.pr_type = "1"; // PR FOR FINANCE

                    }
                    else if (workflow.action.ToLower() == "requested for revision")
                    {
                        status_id = "10";

                        if (Boolean.Parse(statics.GetSetting("K2Active")))
                        {
                            if (Decimal.Parse(workflow.amount.Replace(",", "")) <= 200)
                            {
                                //generalK2Help.Revise(dict, username, workflow.sn);
                            }
                            else if (Decimal.Parse(workflow.amount.Replace(",", "")) > 200)
                            {
                                //status_id = "21";
                                pr.is_procurement = "1";
                                
                                //generalK2Help.Revise(dict, username, workflow.sn);
                            }
                        }

                        _id = staticsPurchaseRequisition.Main.SaveIsProcurement(pr);
                    }
                    else if (workflow.action.ToLower() == "redirect")
                    {
                        pr.status_id = "20";
                        status_id = pr.status_id;
                        sendEmail = false;
                        //sendEmailUser = false;
                        sendEmailWaitingForVerification = true;
                        pr.is_procurement = "2";
                        pr.purchase_type = "3";
                        pr.pr_type= "0";
                        pr.id_submission_page_type= "1";

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

                    if (isRequesterActive)
                    {

                        if (status_id != "90" && status_id != "10" && status_id != "21" && status_id != "20" && Boolean.Parse(statics.GetSetting("K2Active")))
                        {
                            /* get number*/
                            if (!String.IsNullOrEmpty(pr.pr_no))
                            {
                                pr_no = pr.pr_no;
                                if (pr_no.Substring(0, 2) != "FI")
                                {
                                    pr_no = staticsPurchaseRequisition.Main.SetPRNoForPayment(_id);
                                }
                            }
                            else
                            {
                                pr_no = staticsPurchaseRequisition.Main.SetPRNoForPayment(_id);
                            }

                            if (workflow.action == "verified")
                            {
                                //generalK2Help.Approve(dict, username, workflow.sn);
                                //prK2Help.SaveApproveState(username, workflow.activity_id, _id, "PurchaseRequisition");
                            }
                        }
                        staticsPurchaseRequisition.Main.CheckUpdateEmailLog(_id);
                        /* update status */
                        staticsPurchaseRequisition.Main.StatusUpdate(_id, status_id);

                        _id = staticsPurchaseRequisition.Main.SavePayment(pr);

                        string id_journal = string.Empty;
                        foreach (DataModel.JournalNo prjournalno in pr.journalno)
                        {
                            id_journal = staticsPurchaseRequisition.Main.SaveJournalNo(prjournalno);

                            DataModel.Attachment pratt = new DataModel.Attachment();
                            pratt.id = prjournalno.journal_attachment_id;
                            pratt.filename = prjournalno.journal_attachment;
                            pratt.file_description = prjournalno.journal_attachment_description;
                            pratt.document_id = id_journal;
                            pratt.document_type = moduleName + " PAYMENT JOURNAL NO";

                            statics.Attachment.Save(pratt);
                        }

                        foreach (DataModel.DeletedId d in dels)
                        {
                            staticsPurchaseRequisition.Main.DeleteJournalNo(d.id);
                        }

                        // update pr type
                        if (pr.pr_type == "1")
                        {
                            staticsPurchaseRequisition.Main.PRTypeUpdate(pr);
                        }

                        /* insert comment */
                        if (workflow.action == "verified")
                        {
                            comment.action_taken = "PAYMENT COMPLETED";
                        }
                        approval_no = statics.Comment.Save(comment);

                        /* life cycle */
                        statics.LifeCycle.Save(_id, moduleName, status_id);

                        /* send notification*/
                        if (sendEmail)
                        {
                            NotificationHelper.PR_Closed();
                        }

                        /* send notification verify finance*/
                        //if (sendEmailVerifyFinance)
                        //{
                        //    NotificationHelper.PR_VerifiedFinance(_id);
                        //}


                        /* send notificaiton to rejected*/
                        if (sendEmailRejected)
                        {
                            NotificationHelper.PR_Rejected(_id);
                        }


                        try
                        {
                            Log.Information("SyncK2Activity");
                            Log.Information("Id: " + _id);
                            Log.Information("Folder Name: " + k2_folder_name);
                            Log.Information("Process name:" + k2_process_name);
                            Log.Information("URL:" + ConfigurationManager.AppSettings["MySubmissionSvcEndpoint"].ToString());

                            Thread.Sleep(5000);
                            //var approvalTask = Task.Run(() => generalK2Help.SyncK2Approval(_id));
                            //var processTask = Task.Run(() => generalK2Help.SyncK2Process(_id));
                            //var activityTask = Task.Run(() => generalK2Help.SyncK2ActivityName(_id));
                            //var activeActivityTask = Task.Run(() => generalK2Help.SyncK2Activity(_id, k2_folder_name, k2_process_name));

                            //Task.WhenAll(approvalTask, processTask, activityTask, activeActivityTask);
                            Log.Information("Return: All Sync Passed");

                            Thread.Sleep(3000);
                            /* send notification waiting for verification*/
                            if (sendEmailWaitingForVerification)
                            {
                                NotificationHelper.PR_WaitingForVerification(_id);
                            }
                        }
                        catch (Exception ex)
                        {
                            ExceptionHelpers.PrintError(ex);
                            Log.Information("SyncK2Activity gagal. Id: " + _id);
                        }

                        string[] fieldToCompare = { "PurchaseRequisitionType"};
                        bool isChanged = false;

                        Dictionary<string, string> currentDataLog = new Dictionary<string, string>();//PurchaseRequisitionK2Helper.GetListCurrentDataLog(_id, "PurchaseRequisition");
                        Dictionary<string, string> submitDataLog = new Dictionary<string, string>();
                        submitDataLog.Add("PurchaseRequisitionType", pr.purchase_type);

                        foreach (var currentData in currentDataLog)
                        {
                            if (fieldToCompare.Contains(currentData.Key, StringComparer.OrdinalIgnoreCase)) //diisi array list dari field2 y mau dibandingkan
                            {
                                if (currentData.Value.ToLower() != submitDataLog.FirstOrDefault(x => x.Key == currentData.Key).Value.ToLower())
                                {
                                    isChanged = true;
                                }
                            }
                        }

                        if (isChanged)
                        {
                            //prK2Help.UpdateDataLogProperty(pr.id, "PurchaseRequisitionType", pr.purchase_type);
                        }

                        result = "success";
                    }
                    else
                    {
                        result = "error";
                        message = "Requester is not an active staff. Please reject the request.";
                    }
                }
                else
                {
                    result = "errorwf";
                    message = "The data has already taken.";
                }
                #endregion
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

        [WebMethod]
        public static string Edit(string id, string workflows)
        {
            string result = string.Empty, message = string.Empty, _id = string.Empty, moduleName = "PURCHASE REQUISITION", approval_no = "0";
            _id = id;

            DataModel.Workflow workflow = JsonConvert.DeserializeObject<DataModel.Workflow>(workflows);
            try
            {
                DataModel.Comment comment = new DataModel.Comment
                {
                    module_id = _id,
                    module_name = moduleName,
                    comment = workflow.comment,
                    action_taken = workflow.action,
                    activity_id = workflow.activity_id,
                    roles = workflow.roles
                };

                /* insert comment */
                approval_no = statics.Comment.Save(comment);

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
                id = _id
            });
        }
    }
}