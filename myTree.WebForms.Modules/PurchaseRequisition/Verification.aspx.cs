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
using System.Web.UI.WebControls;

namespace myTree.WebForms.Modules.PurchaseRequisition
{
    public partial class Verification : System.Web.UI.Page
    {
        protected string _id = string.Empty, sn = string.Empty, activity_id = string.Empty, taskType = string.Empty, accessToken = String.Empty;
        protected string moduleName = "PURCHASE REQUISITION";
        protected Boolean isInWorkflow = false;
        protected DataModel.ApprovalNotes approval_notes = new DataModel.ApprovalNotes();
        protected string service_url, based_url = string.Empty;
        protected bool isAdmin, isUser, isFinance, isOfficer = false;

        //protected AccessControl authorized = new AccessControl("PURCHASE REQUISITION");
        protected UserRoleAccess userRoleAccess = AccessControl.GetUserRoleAccess(AccessControlObjectEnum.ProcurementPurchaseRequisition);

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
                service_url = statics.GetSetting("service_url");
                based_url = statics.GetSetting("based_url");

                UserRoleAccess access = AccessControl.GetUserRoleAccess(AccessControlObjectEnum.ProcurementPurchaseRequisition);
                if (!access.isCanRead && !access.isCanWrite)
                {
                    Response.Redirect(statics.GetSetting("redirect_page"));
                }

                isAdmin = userRoleAccess.RoleNameInSystem == AccessControlRoleNameEnum.ProcurementLead || userRoleAccess.RoleNameInSystem == AccessControlRoleNameEnum.ProcurementOfficer ? true : false;
                isUser = userRoleAccess.RoleNameInSystem == AccessControlRoleNameEnum.ProcurementAssistant ? true : false;

                bool isAllowed = true;//prK2Helper.isUserAllowedToAccess(_id, username, "PurchaseRequisition", "CIPROCUREMENT", sn);
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
                this.predit1.page_name = "verification";
            }
        }

        [WebMethod]
        public static string Save(string submission, string deletedIds, string workflows)
        {
            string result, message = "",
                _id = "", _line_id = "", pr_no = "",
                moduleName = "PURCHASE REQUISITION", approval_no = "0";
            Boolean sendEmailFinance = false, sendEmailRejected = false, sendEmail = false, sendEmailPayment = false, sendEmailClosed = false;
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
                        pr.status_id = "25";
                        pr.pr_type = "0"; // PR FOR PROCUREMENT
                        if (pr.purchase_type == "5")
                        {
                            pr.status_id = "50";
                            sendEmailClosed = true;
                        }


                        //if (workflow.activity_id == "8")
                        //{   
                        //    sendEmailFinance = true;
                        //}

                        // the verification of PR by procurement team
                        if (workflow.activity_id == "5")
                        {
                            sendEmail = true;
                        }

                        if (Boolean.Parse(statics.GetSetting("K2Active")))
                        {
                            //generalK2Help.Verify(dict, username, workflow.sn);
                            //prK2Help.SaveApproveState(username, workflow.activity_id, _id, k2_process_name);
                            sendEmail = true;
                        }
                    }
                    else if (workflow.action.ToLower() == "redirect")
                    {
                        pr.status_id = "22";
                        //if (workflow.activity_id == "8")
                        //{
                        //    sendEmailFinance = true;
                        //}

                        sendEmailPayment = true;
                        pr.is_procurement = "1";
                        pr.purchase_type = "0";
                        pr.pr_type = "1";
                        pr.id_submission_page_type = "2";

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

                                if (!string.IsNullOrEmpty(taForK2.Rows[0]["paymentUser"].ToString()))
                                {
                                    //var financeUser = taForK2.Rows[0]["financeUser"].ToString();
                                    var paymentUser = "";
                                    if (!string.IsNullOrEmpty(taForK2.Rows[0]["paymentUser"].ToString()))
                                    {
                                        paymentUser = taForK2.Rows[0]["paymentUser"].ToString();
                                    }

                                    // var financeUserList = financeUser.Split(';').ToList();
                                    var paymentUserList = paymentUser.Split(';').ToList();
                                    //financeUserList.RemoveAll(x => userIdNeedToRemove.Contains(x));
                                    paymentUserList.RemoveAll(x => userIdNeedToRemove.Contains(x));

                                    //financeUser = string.Join(";", financeUserList);
                                    paymentUser = string.Join(";", paymentUserList);

                                    string instanceId = "";
                                    instanceId = workflow.sn.Substring(0, workflow.sn.IndexOf("_"));

                                    Dictionary<string, object> redirObj = new Dictionary<string, object>
                                    {
                                        //redirObj.Add("FinanceUser", financeUser);
                                        //redirObj.Add("FinanceState", 0);
                                        { "PaymentUser", paymentUser },
                                        { "PaymentState", 0 },
                                        { "IsPRForProcurement", string.Empty }
                                    };

                                    // Update data log
                                    //prK2Help.UpdateDataLogProperty(pr.id, "IsPRForProcurement", string.Empty);
                                    //prK2Help.UpdateDataLogProperty(pr.id, "PurchaseRequisitionType", string.Empty);

                                    // Update K2 State
                                    //var response = generalK2Help.K2UpdateProcessDataAPI(instanceId, redirObj);
                                    //if (response.Status)
                                    //{
                                    //    //List<string> listOfFinance = financeUser.Split(';').ToList();
                                    //    List<string> listOfPayment = paymentUser.Split(';').ToList();
                                    //    List<K2ActivityUser> listFinUser = new List<K2ActivityUser>();
                                    //    //if (listOfFinance.Count > 0)
                                    //    //{
                                    //    //    foreach (string user in listOfFinance)
                                    //    //    {
                                    //    //        K2ActivityUser fnUser = new K2ActivityUser()
                                    //    //        {
                                    //    //            ActivityID = 6,
                                    //    //            Username = user
                                    //    //        };

                                    //    //        listFinUser.Add(fnUser);
                                    //    //    }
                                    //    //}

                                    //    if (listOfPayment.Count > 0)
                                    //    {
                                    //        foreach (string user in listOfPayment)
                                    //        {
                                    //            K2ActivityUser fnUser = new K2ActivityUser()
                                    //            {
                                    //                ActivityID = 7,
                                    //                Username = user
                                    //            };

                                    //            listFinUser.Add(fnUser);
                                    //        }
                                    //    }

                                    //    //Perlu hapus Current all Fin di K2ActUser??
                                    //    //prK2Help.SaveProcOffFinanceK2ActUser(_id, listFinUser, k2_process_name);
                                    //    //generalK2Help.Redirect(dict, username, workflow.sn);
                                    //    generalK2Help.Redirect(dict, username, workflow.sn);
                                    //    //PurchaseRequisitionK2Helper.ResetApproveStateByRelevantIdModuleAndActivityId(_id, k2_process_name, "7");
                                    //    //prK2Help.SaveApproveState(username, workflow.activity_id, _id, k2_process_name);
                                    //}
                                    //else
                                    //{
                                    //    throw new Exception("Error Redirect Procurement Officer to Finance. Error on Update Process Data. Error Message: " + response.Message);
                                    //}
                                }
                            }
                        }
                    }
                    else if (workflow.action.ToLower() == "movepurchaseoffice")
                    {
                        var prForK2 = staticsPurchaseRequisition.Main.GetDataForK2(_id);


                        if (Boolean.Parse(statics.GetSetting("K2Active")))
                        {
                            var newProcOfficeUser = new DataTable();

                            if (prForK2 != null)
                            {
                                List<string> userIdNeedToRemove = new List<string>();
                                var requestorUserId = "";
                                var initiatorUserId = "";
                                var newProcOffId = "";
                                var procOfficeLead = "";

                                if (!string.IsNullOrEmpty(prForK2.Rows[0]["created_by"].ToString()))
                                {
                                    initiatorUserId = prForK2.Rows[0]["created_by"].ToString();
                                    userIdNeedToRemove.Add(initiatorUserId);
                                }

                                if (!string.IsNullOrEmpty(prForK2.Rows[0]["requestor_user_id"].ToString()))
                                {
                                    requestorUserId = prForK2.Rows[0]["requestor_user_id"].ToString();
                                    userIdNeedToRemove.Add(requestorUserId);
                                }

                                if (!string.IsNullOrEmpty(prForK2.Rows[0]["procurement_office_id"].ToString()))
                                {
                                    newProcOffId = prForK2.Rows[0]["procurement_office_id"].ToString();
                                }

                                if (!string.IsNullOrEmpty(prForK2.Rows[0]["procurement_office_lead"].ToString()))
                                {
                                    procOfficeLead = prForK2.Rows[0]["procurement_office_lead"].ToString();
                                }

                                if (!string.IsNullOrEmpty(prForK2.Rows[0]["procOffUser"].ToString()))
                                {
                                    var oldProcOfficerUser = prForK2.Rows[0]["procOffUser"].ToString();
                                    List<string> listOfOldProcOfficer = oldProcOfficerUser.Split(';').ToList();
                                    //var destinationProcOfficer = PurchaseRequisitionK2Helper.GetProcurementOfficerByProcurementOfficeId(pr.cifor_office_id);
                                    //var destinationProcOffRegion = PurchaseRequisitionK2Helper.GetStringProcurementOfficeRegionByProcurementOfficeId(pr.cifor_office_id);
                                    //var destinationProcOff = PurchaseRequisitionK2Helper.GetProcurementOfficeByProcurementOfficeId(pr.cifor_office_id);
                                    var destinationProcOffName = "";
                                    //if (destinationProcOff != null)
                                    //{
                                    //    if (destinationProcOff.Rows.Count > 0)
                                    //    {
                                    //        if (!string.IsNullOrEmpty(destinationProcOff.Rows[0]["Name"].ToString()))
                                    //        {
                                    //            destinationProcOffName = destinationProcOff.Rows[0]["Name"].ToString();
                                    //        }
                                    //    }
                                    //}

                                    string instanceId = "";
                                    instanceId = workflow.sn.Substring(0, workflow.sn.IndexOf("_"));

                                    //var k2Users = PurchaseRequisitionK2Helper.GetPRK2User(prForK2);

                                    //var destinationProcOfficeList = destinationProcOfficer.Split(';').ToList();
                                    //var procOffLeadList = new List<string>();
                                    //procOffLeadList = procOfficeLead.Split(';').ToList();
                                    //List<string> mergedProcOffList = destinationProcOfficeList.Union(procOffLeadList).ToList();
                                    //mergedProcOffList.RemoveAll(x => userIdNeedToRemove.Contains(x));
                                    //destinationProcOfficer = string.Join(";", mergedProcOffList);
                                    //k2Users["ProcurementOfficerUser"] = destinationProcOfficer;
                                    //k2Users["ReservedFieldThree"] = pr.cifor_office_id;
                                    //k2Users["ReservedFieldFour"] = destinationProcOffRegion;
                                    //k2Users["ReservedFieldFive"] = destinationProcOffName;

                                    //Dictionary<string, object> redirObj = new Dictionary<string, object>();
                                    //redirObj.Add("ProcurementOfficerUser", destinationProcOfficer);
                                    //redirObj.Add("ReservedFieldThree", pr.cifor_office_id);
                                    //redirObj.Add("ReservedFieldFour", destinationProcOffRegion);
                                    //redirObj.Add("ReservedFieldFive", destinationProcOffName);
                                    //var response = generalK2Help.K2UpdateProcessDataAPI(instanceId, redirObj);

                                    //if (response.Status)
                                    //{
                                    //    List<string> listOfNewProcOfficer = destinationProcOfficer.Split(';').ToList();
                                    //    List<K2ActivityUser> listProcOffUser = new List<K2ActivityUser>();
                                    //    if (listOfNewProcOfficer.Count > 0)
                                    //    {
                                    //        foreach (string user in listOfNewProcOfficer)
                                    //        {
                                    //            K2ActivityUser fnUser = new K2ActivityUser()
                                    //            {
                                    //                ActivityID = 5,
                                    //                Username = user
                                    //            };

                                    //            listProcOffUser.Add(fnUser);
                                    //        }
                                    //    }

                                    //    List<K2ActivityUser> listOldProcOffUser = new List<K2ActivityUser>();
                                    //    if (listOfOldProcOfficer.Count > 0)
                                    //    {
                                    //        foreach (string user in listOfOldProcOfficer)
                                    //        {
                                    //            K2ActivityUser fnUser = new K2ActivityUser()
                                    //            {
                                    //                ActivityID = 5,
                                    //                Username = user
                                    //            };

                                    //            listOldProcOffUser.Add(fnUser);
                                    //        }
                                    //    }

                                    //    prK2Help.DeleteProcOffK2ActUser(_id, listOldProcOffUser, k2_process_name, 5); //hapus dulu semua ProcOffice lama
                                    //    prK2Help.SaveProcOffFinanceK2ActUser(_id, listProcOffUser, k2_process_name); //masukan proc office baru
                                    //    staticsPurchaseRequisition.Main.MovePurchaseOffice(_id, pr.cifor_office_id);
                                    //    generalK2Help.GoToActivity("CIProcurement_PurchaseRequisition_" + _id, "Initial Data", k2Users); //refresh WF agar tasklist tergenerate ke user yg baru
                                    //}
                                    //else
                                    //{
                                    //    throw new Exception("Error Redirect Procurement Officer to Other Procurement Office. Error on Update Process Data. Error Message: " + response.Message);
                                    //}
                                }
                            }
                        }

                        workflow.action = "REDIRECT TO OTHER PURCHASE OFFICE";

                        result = "movepurchaseoffice";
                        message = "Purchase office redirect successfully";

                        //return JsonConvert.SerializeObject(new
                        //{
                        //    result = "movepurchaseoffice",
                        //    message = "Purchase office redirect successfully",
                        //    id = _id,
                        //    pr_no = pr_no
                        //});
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

                    // update pr type
                    if (pr.pr_type == "0")
                    {
                        staticsPurchaseRequisition.Main.PRTypeUpdate(pr);
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


                    /* send notification
                     * deactivated based on CIFOR request*/
                    if (sendEmail)
                    {
                        NotificationHelper.PR_Verified(_id);
                    }


                    //if (sendEmailFinance) {
                    //    NotificationHelper.PR_Verified(_id);
                    //}

                    /* send notificaiton to rejected*/
                    if (sendEmailRejected)
                    {
                        NotificationHelper.PR_Rejected(_id);
                    }

                    if (sendEmailClosed)
                    {
                        NotificationHelper.PR_Closed();
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