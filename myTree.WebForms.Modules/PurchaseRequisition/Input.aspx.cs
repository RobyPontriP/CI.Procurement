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
    public partial class Input : System.Web.UI.Page
    {
        protected string _id = string.Empty, sn = string.Empty, activity_id = string.Empty, taskType = string.Empty, is_revision = string.Empty, strAccessToken = string.Empty, id_submission_page_type = string.Empty, submission_page_type = string.Empty, submission_page_name = string.Empty;
        protected string listProduct = string.Empty;
        protected string moduleName = "PURCHASE REQUISITION";
        protected Boolean isInWorkflow = false;
        public Boolean isAllowed = false;
        protected DataModel.ApprovalNotes approval_notes = new DataModel.ApprovalNotes();

        //protected AccessControl authorized = new AccessControl("PURCHASE REQUISITION");
        protected string service_url, based_url = string.Empty;
        //readonly PurchaseRequisitionK2Helper prK2Helper = new PurchaseRequisitionK2Helper();
        public string RefreshURL = string.Empty;

        protected void Page_Load(object sender, EventArgs e)
        {
            RefreshURL = ConfigurationManager.AppSettings["RefreshURL"];
            string strUserLogon = HttpContext.Current.User.Identity.Name.ToLower();
            strAccessToken = AccessControl.GetAccessToken();

            //if (!HttpContext.Current.User.Identity.IsAuthenticated)
            if (false)
            {
                //HttpContext.Current.GetOwinContext().Authentication.Challenge();
                Log.Information("Session ended re-challenge...");
            }
            else
            {
                UserRoleAccess userRoleAccess = AccessControl.GetUserRoleAccess(AccessControlObjectEnum.ProcurementPurchaseRequisition);


                if (!userRoleAccess.isCanWrite)
                {
                    Response.Redirect(AccessControl.GetSetting("access_denied"));
                    Log.Information("Don't have access control, redirecting...");
                }

                _id = Request.QueryString["id"] ?? "";
                sn = Request.QueryString["sn"] ?? "";
                activity_id = Request.QueryString["activity_id"] ?? "";
                taskType = Request.QueryString["tasktype"] ?? "";
                taskType = taskType.ToLower();
                is_revision = Request.QueryString["is_revision"] ?? "";
                id_submission_page_type = Request.QueryString["submission_page_type"] ?? "";
                isInWorkflow = statics.CheckRequestEditable(_id, moduleName, sn);
                service_url = statics.GetSetting("service_url");
                based_url = statics.GetSetting("based_url");
                var username = statics.GetLogonUsername();

                if (!string.IsNullOrEmpty(sn))
                {
                    isAllowed = true;//prK2Helper.isUserAllowedToAccess(_id, username, "PurchaseRequisition", "CIPROCUREMENT", sn);
                    if (!isAllowed)
                    {
                        Response.Redirect(AccessControl.GetSetting("access_denied"));
                    }

                    //ApprovalNotes ApvNotes = PurchaseRequisitionK2Helper.GetPRApvNotes(Convert.ToInt32(activity_id), username, _id);
                    //approval_notes.activity_desc = ApvNotes.ApprovalNotesWording;
                    //approval_notes.activity_name = ApvNotes.Role;
                }

                //if (!isInWorkflow && !String.IsNullOrEmpty(sn))
                //{
                //    Response.Redirect(statics.GetSetting("redirect_page"));
                //}

                DataTable dtSubmissionPageType = statics.GetSubmissionPageType(_id, moduleName);

                if (dtSubmissionPageType.Rows.Count > 0)
                {
                    foreach (DataRow item in dtSubmissionPageType.Rows)
                    {
                        if (string.IsNullOrEmpty(_id))
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
                        else
                        {
                            id_submission_page_type = item["id"].ToString();
                            submission_page_name = submission_page_name = item["page_type"].ToString();
                        }
                    }
                }

                listProduct = JsonConvert.SerializeObject(statics.GetProduct());

                this.recentComment.moduleId = _id;
                this.recentComment.moduleName = moduleName;
                this.predit1.page_id = _id;
                this.predit1.page_name = "input";
            }
        }

        [WebMethod]
        public static string Save(string submission, string deletedIds, string workflows)
        {
            Log.Information("string submission, string deletedIds, string workflows");
            string result = "", message = "",
                _id = "", _line_id = "",
                moduleName = "PURCHASE REQUISITION", approval_no = "0", moduleNameGeneral = "PURCHASE REQUISITION GENERAL",
                status_id = string.Empty;

            string strUserLogon = HttpContext.Current.User.Identity.Name.ToLower();
            if (!String.IsNullOrEmpty(strUserLogon))
            {
                DataModel.LatestActivity latestActivity = new DataModel.LatestActivity();

                int seq = 1;
                Boolean isChange = false, isWorkflow = false, sendEmail = false, sendEmailUser = false, sendEmailFinance = false, sendEmailCancel = false, isInitData = true;
                try
                {
                    DataModel.Workflow workflow = JsonConvert.DeserializeObject<DataModel.Workflow>(workflows);
                    DataModel.PurchaseRequisition pr = JsonConvert.DeserializeObject<DataModel.PurchaseRequisition>(submission);
                    List<DataModel.DeletedId> dels = JsonConvert.DeserializeObject<List<DataModel.DeletedId>>(deletedIds);
                    //PurchaseRequisitionK2Helper taK2Help = new PurchaseRequisitionK2Helper();

                    bool isAllowed = true;
                    if (!string.IsNullOrEmpty(workflow.sn) && workflow.activity_id == "1")
                    {
                        isAllowed = true;//taK2Help.isUserAllowedToAccess(pr.id, strUserLogon, "PurchaseRequisition", "CIPROCUREMENT", workflow.sn);
                    }
                    if (isAllowed)
                    {
                        //Fadly 25 May 23 - initiate data flag
                        if (!String.IsNullOrEmpty(workflow.sn))
                            isInitData = false;

                        //insert K2Datalog for apps
                        if (workflow.action.ToLower() == "submitted" && workflow.activity_id == "1")
                        {
                            statics.AddLogForApps(pr.id);
                        }

                        Log.Information("workflow.sn = " + workflow.sn + " workflow.action = " + workflow.action);
                        if (!String.IsNullOrEmpty(workflow.sn) || pr.is_revision == "1")
                        {
                            latestActivity = statics.GetLatestActivity(pr.id, moduleName);
                            Log.Information("latestActivity = " + latestActivity.activity_id + " latestActivity.action = " + latestActivity.action);
                            DataModel.PurchaseRequisition oldPR = staticsPurchaseRequisition.GetPreviousData(pr.id);
                            isChange = staticsPurchaseRequisition.IsChange(oldPR, pr);
                            Log.Information("isChange = " + isChange);
                        }

                        //set default pr_type;
                        if (pr.purchase_type != "3")
                        {
                            pr.pr_type = "1"; // PR FOR FINANCE
                        }
                        else
                        {
                            pr.pr_type = "0"; //PR FOR PROCUREMENT
                        }

                        if (string.IsNullOrEmpty(pr.purchasing_process))
                        {
                            pr.purchasing_process = "0";
                        }

                        if (workflow.action.ToLower() == "saved")
                        {
                            if (String.IsNullOrEmpty(workflow.sn))
                            {
                                pr.status_id = "5"; //DRAFT

                            }
                        }
                        else if (workflow.action.ToLower() == "submitted")
                        {
                            pr.status_id = "15"; //WAIT FOR APPROVAL
                            isWorkflow = true;
                            if (((!String.IsNullOrEmpty(workflow.sn)
                                && (latestActivity.activity_id == K2ActivityEnum.OfficerVerification || latestActivity.activity_id == K2ActivityEnum.FinanceVerification || latestActivity.activity_id == K2ActivityEnum.PaymentProcessApproval)
                                && latestActivity.action.ToLower() != "rejected")
                                   || !String.IsNullOrEmpty(pr.is_revision)) && !isChange
                                )
                            {
                                workflow.action = "resubmitted";
                                Log.Information("workflow.action = resubmitted");
                                if (pr.purchasing_process == "1" && Decimal.Parse(pr.total_estimated_usd.Replace(",", "")) <= 200)
                                {
                                    pr.status_id = "22";
                                    Log.Information("workflow.action = resubmitted, status_id = 22");
                                }
                                else if (pr.purchasing_process == "0" && Decimal.Parse(pr.total_estimated_usd.Replace(",", "")) <= 200 && latestActivity.activity_id == K2ActivityEnum.FinanceVerification)
                                {
                                    pr.status_id = "21";
                                    Log.Information("workflow.action = resubmitted, status_id = 21");
                                }
                                else if (pr.purchasing_process == "0" && Decimal.Parse(pr.total_estimated_usd.Replace(",", "")) <= 200 && latestActivity.activity_id == K2ActivityEnum.PaymentProcessApproval)
                                {
                                    pr.status_id = "20";
                                    sendEmail = true;
                                    sendEmailUser = true;
                                    Log.Information("workflow.action = resubmitted, status_id = 20, sendEmail = true, sendEmailUser = true");
                                }
                                else if (pr.purchase_type != "3" && pr.purchase_type != "5" && Decimal.Parse(pr.total_estimated_usd.Replace(",", "")) > 200 && latestActivity.activity_id == K2ActivityEnum.FinanceVerification && pr.is_procurement != "2")
                                {
                                    pr.status_id = "21";
                                    sendEmail = false;
                                    sendEmailUser = true;
                                    sendEmailFinance = true;
                                    Log.Information("workflow.action = resubmitted, status_id = 21, sendEmail = false, sendEmailUser = true, sendEmailFinance = true");
                                }
                                else if (pr.purchase_type != "3" && pr.purchase_type != "5" && Decimal.Parse(pr.total_estimated_usd.Replace(",", "")) > 200 && latestActivity.activity_id == K2ActivityEnum.OfficerVerification && pr.is_procurement != "2")
                                {
                                    pr.status_id = "21";
                                    sendEmail = false;
                                    sendEmailUser = true;
                                    sendEmailFinance = true;
                                    Log.Information("workflow.action = resubmitted, status_id = 21, sendEmail = false, sendEmailUser = true, sendEmailFinance = true");
                                }
                                else if (pr.purchase_type != "3" && pr.purchase_type != "5" && Decimal.Parse(pr.total_estimated_usd.Replace(",", "")) > 200 && latestActivity.activity_id == K2ActivityEnum.FinanceVerification && pr.is_procurement == "2")
                                {
                                    pr.status_id = "20";
                                    sendEmail = false;
                                    sendEmailUser = false;
                                    sendEmailFinance = false;
                                    Log.Information("workflow.action = resubmitted, status_id = 20, sendEmail = false, sendEmailUser = false, sendEmailFinance = false");
                                }
                                else if (pr.purchase_type != "3" && pr.purchase_type != "5" && Decimal.Parse(pr.total_estimated_usd.Replace(",", "")) > 200 && latestActivity.activity_id == K2ActivityEnum.OfficerVerification && pr.is_procurement == "2")
                                {
                                    pr.status_id = "20";
                                    sendEmail = false;
                                    sendEmailUser = false;
                                    sendEmailFinance = false;
                                    Log.Information("workflow.action = resubmitted, status_id = 20, sendEmail = false, sendEmailUser = false, sendEmailFinance = false");
                                }
                                else if (latestActivity.activity_id == "0")
                                {
                                    if (pr.purchase_type != "3" && pr.purchase_type != "5" && Decimal.Parse(pr.total_estimated_usd.Replace(",", "")) > 200 && pr.is_procurement != "2")
                                    {
                                        pr.status_id = "21";
                                        sendEmail = false;
                                        sendEmailUser = true;
                                        sendEmailFinance = true;
                                        Log.Information("workflow.action = resubmitted, status_id = 21, sendEmail = false, sendEmailUser = true, sendEmailFinance = false");
                                    }
                                    else if (pr.purchasing_process == "0" && Decimal.Parse(pr.total_estimated_usd.Replace(",", "")) <= 200)
                                    {
                                        pr.status_id = "20";
                                        sendEmail = true;
                                        sendEmailUser = true;
                                        Log.Information("workflow.action = resubmitted, status_id = 21, sendEmail = false, sendEmailUser = true, sendEmailFinance = false");
                                    }
                                    else if (pr.purchasing_process == "1" && Decimal.Parse(pr.total_estimated_usd.Replace(",", "")) <= 200)
                                    {
                                        pr.status_id = "22";
                                        Log.Information("workflow.action = resubmitted, status_id = 22");
                                    }
                                    else
                                    {
                                        pr.status_id = "20"; //REQUEST FOR REVISION FROM PROCUREMENT UNIT
                                        sendEmail = true;
                                        sendEmailUser = true;
                                        Log.Information("workflow.action = resubmitted, status_id = 20, sendEmail = true, sendEmailUser = true");
                                    }
                                }
                                else
                                {
                                    pr.status_id = "20"; //REQUEST FOR REVISION FROM PROCUREMENT UNIT
                                    sendEmail = true;
                                    sendEmailUser = true;
                                    Log.Information("workflow.action = resubmitted, status_id = 20, sendEmail = true, sendEmailUser = true");
                                }
                            }
                            else if (!String.IsNullOrEmpty(workflow.sn) && String.IsNullOrEmpty(pr.is_revision))
                            {
                                workflow.action = "resubmitted";
                            }
                            else
                            {
                                workflow.action = "submitted";
                            }
                        }
                        else if (workflow.action.ToLower() == "cancelled")
                        {
                            isWorkflow = statics.CheckRequestEditable(pr.id, moduleName, workflow.sn);
                            pr.status_id = "95";
                            sendEmailCancel = true;

                            /* life cycle */
                            statics.LifeCycle.Save(pr.id, moduleName, pr.status_id);
                        }
                        status_id = pr.status_id;

                        //_id = staticsPurchaseRequisition.Main.Save(pr);

                        var is_trigger_audit = false;
                        //isInitData = false;
                        //if (workflow.activity_id == "1" && workflow.action.ToLower() == "resubmitted" && pr.status_id != "5")
                        if (!isInitData)
                        {
                            is_trigger_audit = true;
                            pr.is_trigger_audit = is_trigger_audit;
                        }

                        //if (pr.status_id != "5" && workflow.action == "resubmitted")
                        //{
                        //    is_trigger_audit = true;
                        //    pr.is_trigger_audit = is_trigger_audit;
                        //}

                        _id = staticsPurchaseRequisition.Main.Save(pr);
                        var changeTime = DateTime.Now;

                        foreach (DataModel.Attachment pratt in pr.attachments_general)
                        {
                            pratt.document_id = _id;
                            pratt.document_type = moduleNameGeneral;
                            statics.Attachment.Save(pratt);
                        }

                        foreach (DataModel.PurchaseRequisitionDetail prd in pr.details)
                        {
                            prd.pr_id = _id;
                            prd.line_no = seq.ToString();
                            prd.is_trigger_audit = is_trigger_audit;
                            //prd.category = "PROD CATEGORY";

                            //prd.attachments = new List<DataModel.Attachment>();
                            //var tes = new DataModel.Attachment();
                            //tes.document_type = "tes";
                            //tes.filename = "file tes";
                            //tes.document_id = "0000";
                            //prd.attachments.Add(tes);

                            _line_id = staticsPurchaseRequisition.Detail.Save(prd);

                            foreach (DataModel.Attachment att in prd.attachments)
                            {
                                att.document_id = _line_id;
                                att.document_type = moduleName;
                                att.change_time = changeTime.ToString();
                                //statics.Attachment.Save(att);
                                statics.Attachment.SaveNew(att);
                            }

                            if (is_trigger_audit)
                            {
                                statics.CheckPRDetailAndAttachmentForAuditTrail(_line_id);
                            }

                            int seq_no = 1;
                            foreach (DataModel.PurchaseRequisitionDetailCostCenter cc in prd.costCenters)
                            {
                                cc.pr_id = _id;
                                cc.pr_detail_id = _line_id;
                                cc.sequence_no = seq_no.ToString();
                                cc.is_trigger_audit = is_trigger_audit;
                                statics.CostCenter.Save(cc);
                                seq_no++;
                            }
                            seq++;
                        }

                        foreach (DataModel.DeletedId d in dels)
                        {
                            switch (d.table.ToLower())
                            {
                                case "attachment":
                                    statics.Attachment.Delete(d.id);
                                    break;
                                case "item":
                                    staticsPurchaseRequisition.Detail.Delete(d.id);
                                    break;
                                case "chargecode":
                                    statics.CostCenter.Delete(d.id);
                                    break;
                                default:
                                    break;
                            }
                        }

                        //foreach (DataModel.PurchaseRequisitionDetail prd in pr.details)
                        //{
                        //    statics.SyncAuditTrail(changeTime, prd.id);
                        //}

                        /* update status */
                        staticsPurchaseRequisition.Main.StatusUpdate(_id, pr.status_id);

                        /* insert comment */
                        DataModel.Comment comment = new DataModel.Comment
                        {
                            module_id = _id,
                            module_name = moduleName,
                            comment = workflow.comment,
                            comment_file = workflow.comment_file,
                            action_taken = workflow.action,
                            activity_id = workflow.activity_id,
                            roles = workflow.roles
                        };
                        approval_no = statics.Comment.Save(comment);

                        /* life cycle */
                        if (workflow.action.ToLower() == "submitted" || workflow.action.ToLower() == "resubmitted")
                        {
                            statics.LifeCycle.Save(_id, moduleName, pr.status_id);
                        }

                        if (workflow.action.ToLower() == "resubmitted" && !String.IsNullOrEmpty(pr.is_revision))
                        {
                            workflow.action = "submitted";
                        }

                        #region Workflow
                        if (isWorkflow && Boolean.Parse(statics.GetSetting("K2Active")))
                        {
                            string k2ApiKey = statics.GetSetting("K2ApiKey");
                            string k2ApiEndPoint = statics.GetSetting("K2ApiEndpoint");
                            string k2_folder_name = statics.GetSetting("K2FolderName");
                            string k2_process_name = statics.GetSetting("K2ProcessName");
                            var folio = "CIPROCUREMENT_PurchaseRequisition_" + _id;
                            //K2Helpers generalK2Help = new K2Helpers();

                            switch (workflow.action.ToLower())
                            {
                                case "submitted":
                                    if (string.IsNullOrEmpty(workflow.sn))
                                    {
                                        bool isReturnToInitiator = pr.is_revision.ToLower() == "1";
                                        if (!isReturnToInitiator)
                                        {
                                            submitWf(_id, statics.GetLogonUsername());
                                        }
                                        else
                                        {
                                            submitWf(_id, statics.GetLogonUsername(), isReturnToInitiator, workflow.IsProcOffChangedDuringResubmit);
                                        }
                                    }
                                    else
                                    {
                                        resubmitWF(_id, statics.GetLogonUsername(), workflow.sn, workflow.IsProcOffChangedDuringResubmit);
                                    }
                                    break;
                                case "resubmitted":
                                    if (!string.IsNullOrEmpty(workflow.sn))
                                    {
                                        resubmitWF(_id, statics.GetLogonUsername(), workflow.sn, workflow.IsProcOffChangedDuringResubmit);
                                    }
                                    break;
                                case "cancelled":
                                    //generalK2Help.Stop("Stop", folio, false);
                                    break;
                                default:
                                    break;
                            }

                            //Thread.Sleep(3000);
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
                        }
                        #endregion

                        //sendemail = true;
                        //sendemailuser = true;
                        //sendemailfinance = true;

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

                        /* send notification to finance*/
                        if (sendEmailFinance)
                        {
                            NotificationHelper.PR_WaitingForVerificationFinance(_id);
                        }

                        ///* send notification to cancel*/
                        //if (sendEmailCancel)
                        //{
                        //    NotificationHelper.PR_Cancelled(_id);
                        //}

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
            }
            else
            {
                result = "error";
                message = "Session has ended. Please relogin.";
            }

            return JsonConvert.SerializeObject(new
            {
                result = result,
                message = message,
                id = _id
            });
        }

        private static void submitWf(string prId, string userName, bool isReturnToInit = false, bool isProcOffIsChangedDuringResubmit = false)
        {
            string k2ApiKey = statics.GetSetting("K2ApiKey");
            string k2ApiEndPoint = statics.GetSetting("K2ApiEndpoint");
            //K2Helpers generalK2Help = new K2Helpers();
            //urchaseRequisitionK2Helper taK2Help = new PurchaseRequisitionK2Helper();
            var moduleName = statics.GetSetting("K2ProcessName");
            var folderName = statics.GetSetting("K2FolderName");
            var taForK2 = staticsPurchaseRequisition.Main.GetDataForK2(prId);

            //taK2Help.SavePRDataLogList(taForK2);
            if (isReturnToInit)
            {
                string[] fieldToCompare = { "PurchaseRequisitionType", "PurchaseRequisitionAmount", "ChargeCode", "ProcurementOffice", "Product", "IsPRForProcurement" };
                var isChanged = true;//taK2Help.CompareLog(prId, false, fieldToCompare, moduleName, isProcOffIsChangedDuringResubmit);
                if (isChanged)
                {
                    //Jika ada perubahan data maka set status id PR menjadi Waiting for Approval
                    staticsPurchaseRequisition.Main.StatusUpdate(prId, "15");
                }
            }
            //var k2Users = PurchaseRequisitionK2Helper.GetPRK2User(taForK2);
            //generalK2Help.Submit(folderName, moduleName, prId, k2Users, userName);
            //var userList = PurchaseRequisitionK2Helper.GetPRActivityUser(taForK2, "");
            //taK2Help.SaveK2ActUser(prId, userList, moduleName);
            //taK2Help.SavePRDataLogList(taForK2);

            //jika ketika submit dan data merupakan data hasil dari Return To Init maka flag is_have_revision_task diupdate menjadi 0 kembali untuk menghilangkan tasklist di Initiator
            if (isReturnToInit)
            {
                var pr_no = staticsPurchaseRequisition.Main.IsRevisionUpdate(prId, "0");
            }
        }

        private static void resubmitWF(string prId, string userName, string sn, bool isProcOffIsChangedDuringResubmit = false)
        {
            string k2ApiKey = statics.GetSetting("K2ApiKey");
            string k2ApiEndPoint = statics.GetSetting("K2ApiEndpoint");
            //K2Helpers generalK2Help = new K2Helpers();
            //PurchaseRequisitionK2Helper taK2Help = new PurchaseRequisitionK2Helper();
            var moduleName = statics.GetSetting("K2ProcessName");
            var folderName = statics.GetSetting("K2FolderName");
            var taForK2 = staticsPurchaseRequisition.Main.GetDataForK2(prId);

            //taK2Help.SavePRDataLogList(taForK2);
            //string[] fieldToCompare = { "PurchaseRequisitionType", "PurchaseRequisitionAmount", "ChargeCode", "ProcurementOffice", "Product", "IsPRForProcurement" };
            //taK2Help.CompareLog(prId, false, fieldToCompare, moduleName, isProcOffIsChangedDuringResubmit);
            //var k2Users = PurchaseRequisitionK2Helper.GetPRK2User(taForK2);
            //generalK2Help.Resubmit(k2Users, userName, sn);
            //var userList = PurchaseRequisitionK2Helper.GetPRActivityUser(taForK2);
            //taK2Help.SaveK2ActUser(prId, userList, moduleName);

            List<int> listOfInvolvingActId = new List<int>();
            //userDict.Add("DCSUser", mapUser(2, unApproveUsers));
            //userDict.Add("DGUser", mapUser(3, unApproveUsers));
            //userDict.Add("BudgetHolderUser", mapUser(4, unApproveUsers));
            //userDict.Add("ProcurementOfficerUser", mapUser(5, unApproveUsers));
            //userDict.Add("FinanceUser", mapUser(6, unApproveUsers));
            //userDict.Add("PaymentUser", mapUser(7, unApproveUsers));
            //if (!string.IsNullOrEmpty(k2Users["DCSUser"].ToString()))
            //{
            //    listOfInvolvingActId.Add(2);
            //}
            //if (!string.IsNullOrEmpty(k2Users["DGUser"].ToString()))
            //{
            //    listOfInvolvingActId.Add(3);
            //}
            //if (!string.IsNullOrEmpty(k2Users["BudgetHolderUser"].ToString()))
            //{
            //    listOfInvolvingActId.Add(4);
            //}
            //if (!string.IsNullOrEmpty(k2Users["ProcurementOfficerUser"].ToString()))
            //{
            //    listOfInvolvingActId.Add(5);
            //}
            //if (!string.IsNullOrEmpty(k2Users["FinanceUser"].ToString()))
            //{
            //    listOfInvolvingActId.Add(6);
            //}
            //if (!string.IsNullOrEmpty(k2Users["PaymentUser"].ToString()))
            //{
            //    listOfInvolvingActId.Add(7);
            //}

            string nextActId = listOfInvolvingActId.Where(x => x > 1).OrderBy(y => y).FirstOrDefault().ToString();
            string status_id = "";
            if (nextActId == K2ActivityEnum.DSCApproval || nextActId == K2ActivityEnum.DGApproval || nextActId == K2ActivityEnum.BudgetHolderApproval)
            {
                status_id = "15";
            }
            else if (nextActId == K2ActivityEnum.OfficerVerification)
            {
                status_id = "20";
            }
            else if (nextActId == K2ActivityEnum.FinanceVerification)
            {
                status_id = "21";
            }
            else if (nextActId == K2ActivityEnum.PaymentProcessApproval)
            {
                status_id = "22";
            }

            if (!string.IsNullOrEmpty(status_id))
            {
                staticsPurchaseRequisition.Main.StatusUpdate(prId, status_id);
            }

            isChargeCodeChange(prId);
        }

        private static bool isChargeCodeChange(string prid)
        {
            //PurchaseRequisitionK2Helper purchK2 = new PurchaseRequisitionK2Helper();
            string[] fieldToCompare = { "ChargeCode" };
            string[] fields = fieldToCompare;
            var moduleName = statics.GetSetting("K2ProcessName");

            var res = false;
            Dictionary<string, string> oldGrantData = new Dictionary<string, string>();// PurchaseRequisitionK2Helper.GetListOlderDataLog(prid, moduleName);
            Dictionary<string, string> newGrantData = new Dictionary<string, string>();//PurchaseRequisitionK2Helper.GetListCurrentDataLog(prid, moduleName);

            foreach (var oldData in oldGrantData)
            {
                if (fields.Contains(oldData.Key, StringComparer.OrdinalIgnoreCase)) //diisi array list dari field2 y mau dibandingkan
                {
                    if (oldData.Value.ToLower() != newGrantData.FirstOrDefault(x => x.Key == oldData.Key).Value.ToLower())
                    {
                        if (oldData.Key.ToLower().Contains("ChargeCode".ToLower()))
                        {
                            var oldDataArray = oldData.Value.ToString().Split(';');
                            var newDataArray = newGrantData.FirstOrDefault(x => x.Key == oldData.Key).Value.ToString().Split(';');

                            var diffChargeCodeData = newDataArray.Except(oldDataArray).ToList();
                            if (diffChargeCodeData.Count > 0)
                            {
                                res = true;
                            }
                        }
                    }
                }
            }

            if (res)
            {
                string olderChargeCode = oldGrantData.Where(x => x.Key.ToLower() == "ChargeCode".ToLower()).Select(y => y.Value.ToString()).FirstOrDefault();
                string newerChargeCode = newGrantData.Where(x => x.Key.ToLower() == "ChargeCode".ToLower()).Select(y => y.Value.ToString()).FirstOrDefault();

                var oldArrayDataset = olderChargeCode.Split(';');
                var newArrayDataset = newerChargeCode.Split(';');

                List<string> chargeCodeParticipant = new List<string>();
                foreach (string item in oldArrayDataset)
                {
                    var singleRow = item.Split('|');
                    chargeCodeParticipant.Add(singleRow[0]);
                }
                foreach (string item in newArrayDataset)
                {
                    var singleRow = item.Split('|');
                    chargeCodeParticipant.Add(singleRow[0]);
                }

                chargeCodeParticipant = chargeCodeParticipant.Distinct().ToList();

                if (chargeCodeParticipant.Count > 0)
                {
                    List<string> listEmail = new List<string>();
                    foreach (string a in chargeCodeParticipant)
                    {
                        database db = new database();
                        db.ClearParameters();

                        db.SPName = "sp_General_GetCostCenterEmployeeDataByCostCenterId";
                        db.AddParameter("@CostCenterId", SqlDbType.NVarChar, a);
                        DataSet ds = db.ExecuteSP();
                        db.Dispose();

                        if (ds.Tables.Count > 0)
                        {
                            DataTable empData = ds.Tables[0];
                            if (empData.Rows.Count > 0)
                            {
                                string email = empData.Rows[0]["EMAIL"].ToString();
                                if (!string.IsNullOrEmpty(email))
                                {
                                    listEmail.Add(email);
                                }
                            }
                        }
                    }

                    if (listEmail.Count > 0)
                    {
                        var stringEmail = String.Join(";", listEmail);
                        NotificationHelper.PR_ChangeChargeCodeToBudgetHolder(prid, stringEmail);
                    }

                }
            }

            return res;
        }

        [WebMethod]
        public static string UploadFile(object user_id)
        {
            DataTable dtOffice = statics.GetCIFOROffice("");
            String office = "";
            if (dtOffice.Rows.Count > 0)
            {
                office = dtOffice.Rows[0]["office_id"].ToString();
            }
            return office;
        }

        [WebMethod]
        public static string SaveChangePurchaseType(string submission)
        {
            Log.Information("string submission");
            string result = "", message = "",
                _id = "",
                status_id = string.Empty;

            string strUserLogon = HttpContext.Current.User.Identity.Name.ToLower();
            if (!String.IsNullOrEmpty(strUserLogon))
            {
                try
                {
                    DataModel.PurchaseRequisition pr = JsonConvert.DeserializeObject<DataModel.PurchaseRequisition>(submission);

                    if (pr.id_submission_page_type != "1")
                    {
                        pr.pr_type = "1"; // PR FOR FINANCE
                    }
                    else
                    {
                        pr.pr_type = "0"; //PR FOR PROCUREMENT
                    }

                    _id = staticsPurchaseRequisition.Main.UpdatePurchaseType(pr);

                    result = "success";
                }
                catch (Exception ex)
                {
                    result = "error";
                    message = ex.ToString();
                    ExceptionHelpers.PrintError(ex);
                }
            }
            else
            {
                result = "error";
                message = "Session has ended. Please relogin.";
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