using myTree.WebForms.Procurement.General.K2Helper.PurchaseOrder;
using myTree.WebForms.Procurement.General;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Serilog;
using Newtonsoft.Json;
using System.Web.Services;
//using myTree.WebForms.K2Helper;
using myTree.WebForms.Procurement.General.K2Helper.SingleSourcing;
using myTree.WebForms.Procurement.General.K2Helper.SingleSourcing.Models;

namespace myTree.WebForms.Modules.VendorSelection
{
    public partial class SingleSourcing : System.Web.UI.Page
    {
        protected string _id = string.Empty
            , sn = string.Empty
            , activity_id = string.Empty
            , approval_type = string.Empty
            , approval_type_label = string.Empty
            , taskType = string.Empty
            , accessToken = string.Empty;
        protected DataModel.ApprovalNotes approval_notes = new DataModel.ApprovalNotes();

        protected string vsItems = "[]", vsItemsMain = "[]", supportingDocs = "[]", blankmode = string.Empty;
        protected string listCurrency = string.Empty, max_status = string.Empty, listChargeCode = "[]", listSundry = "[]";
        protected DataModel.VendorSelection VS = new DataModel.VendorSelection();
        protected Boolean isAdmin = false;
        protected Boolean isUser = false;
        protected Boolean isFinance = false;

        protected UserRoleAccess userRoleAccess = AccessControl.GetUserRoleAccess(AccessControlObjectEnum.ProcurementQuotationAnalysis);
        protected Boolean isInWorkflow = false, isAllowed = false;
        readonly PurchaseOrderK2Helper poK2Helper = new PurchaseOrderK2Helper();

        protected string moduleName = "VENDOR SELECTION";
        protected string service_url, based_url, page_type = string.Empty;
        protected Boolean isEditable = false;

        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                if (!HttpContext.Current.User.Identity.IsAuthenticated)
                {
                    //HttpContext.Current.GetOwinContext().Authentication.Challenge();
                    Log.Information("Session ended re-challenge...");
                }
                else
                {
                    string userId = statics.GetLogonUsername();
                    _id = Request.QueryString["id"] ?? "";
                    sn = Request.QueryString["sn"] ?? "";
                    activity_id = Request.QueryString["activity_id"] ?? "";
                    taskType = Request.QueryString["tasktype"] ?? "";
                    taskType = taskType.ToLower();
                    service_url = statics.GetSetting("service_url");
                    based_url = statics.GetSetting("based_url");

                    UserRoleAccess userRoleAccess = AccessControl.GetUserRoleAccess(AccessControlObjectEnum.ProcurementQuotationAnalysis);

                    if (!userRoleAccess.isCanRead)
                    {
                        Response.Redirect(AccessControl.GetSetting("access_denied"));
                        Log.Information("Don't have access control, redirecting...");
                    }

                    if (!string.IsNullOrEmpty(sn))
                    {
                        isAllowed = true;//poK2Helper.isUserAllowedToAccess(_id, userId, "SingleSourcing", "CIPROCUREMENT", sn);
                        if (!isAllowed)
                        {
                            Response.Redirect(AccessControl.GetSetting("access_denied"));
                        }
                    }

                    page_type = "JUSTIFICATION";

                }

            }
            catch (Exception ex)
            {
                ExceptionHelpers.PrintError(ex);
            }
        }

        [WebMethod]
        public static string Submit(string submission, string workflows)
        {
            string result, message,is_submission = string.Empty,
                _id = string.Empty, moduleName = "VENDOR SELECTION", status_id = string.Empty, approval_no = "0",singlesourcing = "", justification_singlesourcing = "", justification_file_singlesourcing = "", ss_initiated_by ="";
            Boolean isWorkflow = false, isChange = false;
            try
            {
                DataModel.VendorSelection vs = JsonConvert.DeserializeObject<DataModel.VendorSelection>(submission);
                DataModel.Workflow workflow = JsonConvert.DeserializeObject<DataModel.Workflow>(workflows);

                singlesourcing = vs.singlesourcing;
                justification_singlesourcing = vs.justification_singlesourcing;
                justification_file_singlesourcing = vs.justification_file_singlesourcing;
                ss_initiated_by = statics.GetLogonUsername();

                is_submission = "0";
                // Set VS id
                _id = vs.id;
                Log.Information($"Start Submitting Single source with Id : {vs.id} with action : {workflow.action}");
                if (workflow.action.ToLower() == "submitted")
                {
                    vs.status_id = "15";
                    isWorkflow = true;
                    if (!String.IsNullOrEmpty(workflow.sn))
                    {
                        workflow.action = "resubmitted";
                        is_submission = "1";
                    }
                    else
                    {
                        workflow.action = "submitted";
                        workflow.roles = "Single Sourcing Request";
                    }

                    vs.ss_initiated_by = statics.GetLogonUsername();
                }
                else if (workflow.action.ToLower() == "resubmitted for re-approval")
                {
                    isWorkflow = true;
                    vs.status_id = "15";
                }
                else if (workflow.action.ToLower() == "updated")
                {
                    vs.status_id = "30";
                }
                else if (workflow.action.ToLower() == "cancelled")
                {
                    if (!string.IsNullOrEmpty(workflow.sn))
                    {
                        isWorkflow = true;
                    }
                    vs.status_id = "95";
                    vs.singlesourcing = "0";
                    vs.justification_singlesourcing = "";
                    vs.justification_file_singlesourcing = "";
                }

                status_id = vs.status_id;

                #region K2 Area
                /* Recent comment */
                DataModel.Comment comment = new DataModel.Comment
                {
                    module_id = _id,
                    module_name = vs.status_id == "95" ? "SINGLE SOURCING" : "SINGLE SOURCING",
                    comment = workflow.comment,
                    comment_file = vs.status_id == "95" ? workflow.comment_file : "",
                    action_taken = workflow.action,
                    activity_id = workflow.activity_id,
                    roles = workflow.roles
                };
                approval_no = statics.Comment.Save(comment);

                /* Life cycle */
                if (workflow.action.ToLower() == "submitted"
                    || workflow.action.ToLower() == "resubmitted"
                    || workflow.action.ToLower() == "resubmitted for re-approval"
                    || workflow.action.ToLower() == "cancelled"
                    || (workflow.action.ToLower() == "saved" && string.IsNullOrEmpty(vs.id)))
                {
                    statics.LifeCycle.Save(_id, vs.status_id == "95" ? "SINGLE SOURCING" : "SINGLE SOURCING", vs.status_id);
                }

                

                // Save justification to myTree
                try
                {
                    vs.is_submission = is_submission;
                    staticsVendorSelection.Main.SaveJustification(vs);

                    if (workflow.action.ToLower() == "cancelled")
                    {
                        staticsVendorSelection.Main.StatusUpdate(_id, "25"); // Cancel on revision, will open the Quotation Analysis again.
                    }

                    /* Workflow */
                    //if (isWorkflow && bool.Parse(statics.GetSetting("K2Active")))
                    //{
                    //    // Initiate K2 for Single sourcing
                    //    Log.Information("Single sourcing workflow.sn = " + workflow.sn + " workflow.action = " + workflow.action);
                    //    string k2ApiKey = statics.GetSetting("K2ApiKey");
                    //    string k2ApiEndPoint = statics.GetSetting("K2ApiEndpoint");
                    //    string k2_folder_name = statics.GetSetting("K2FolderName");
                    //    string k2_process_name = statics.GetSetting("K2ProcessNameSS");
                    //    var folio = "CIPROCUREMENT_SingleSourcing_" + _id;
                    //    K2Helpers generalK2Help = new K2Helpers();

                    //    //CIFOR.Lib.WorkflowIntegration.ExecuteWorkflow K2 = new CIFOR.Lib.WorkflowIntegration.ExecuteWorkflow();
                    //    switch (workflow.action.ToLower())
                    //    {
                    //        case "submitted":
                    //            if (string.IsNullOrEmpty(workflow.sn))
                    //            {
                    //                //bool isReturnToInitiator = po.is_revision.ToLower() == "1";
                    //                //if (!isReturnToInitiator)
                    //                //{
                    //                //    submitWf(_id, statics.GetLogonUsername());
                    //                //}
                    //                //else
                    //                //{
                    //                //    submitWf(_id, statics.GetLogonUsername(), isReturnToInitiator, workflow.IsProcOffChangedDuringResubmit);
                    //                //}
                    //                submitWf(_id, statics.GetLogonUsername());
                    //            }
                    //            else
                    //            {
                    //                resubmitWF(_id, statics.GetLogonUsername(), workflow.sn, workflow.IsProcOffChangedDuringResubmit);
                    //            }
                    //            break;
                    //        case "resubmitted":
                    //            if (!string.IsNullOrEmpty(workflow.sn))
                    //            {
                    //                resubmitWF(_id, statics.GetLogonUsername(), workflow.sn, workflow.IsProcOffChangedDuringResubmit);
                    //            }
                    //            break;
                    //        case "resubmitted for re-approval":
                    //            //K2.ResubmitForReapproval(statics.GetLogonUsername(), _id, workflow.sn, "Procurement_PurchaseOrder_" + _id);
                    //            break;
                    //        case "cancelled":
                    //            generalK2Help.Stop("stop", folio, false);
                    //            //staticsVendorSelection.Main.StatusUpdate(_id, "25"); // Cancel on revision, will open the Quotation Analysis again.
                    //            staticsVendorSelection.Main.UpdateSingleSource(_id, singlesourcing, justification_singlesourcing, justification_file_singlesourcing,ss_initiated_by);
                    //            WebForms.Procurement.Notification.NotificationHelper.VS_CancelledSS(vs.id);
                    //            vs.status_id = "25";
                    //            staticsVendorSelection.Main.SaveJustification(vs);
                    //            break;
                    //        default:
                    //            break;
                    //    }
                    //}
                }
                catch (Exception ex)
                {
                    result = "error";
                    message = ex.Message.ToString();
                    ExceptionHelpers.PrintError(ex);
                }
                #endregion

                result = "success";
                message = "success";

            }
            catch (Exception ex)
            {
                result = "error";
                message = ExceptionHelpers.Message(ex);
                ExceptionHelpers.PrintError(ex);
            }
            return JsonConvert.SerializeObject(new
            {
                result,
                message,
                id = _id,
                vs_no = string.Empty
            });
        }

        private static void submitWf(string vsId, string userName, bool isReturnToInit = false, bool isProcOffIsChangedDuringResubmit = false)
        {
            Log.Information("submitWf with Id = " + vsId );

            //K2Helpers generalK2Help = new K2Helpers();
            //SingleSourcingK2Helper ssK2Help = new SingleSourcingK2Helper();
            var moduleName = statics.GetSetting("K2ProcessNameSS");
            var folderName = statics.GetSetting("K2FolderName");

            // Initiate data for K2
            var ssForK2 = staticsVendorSelection.Main.GetDataForK2(vsId);
            Log.Information($"GetDataForK2 with data: \n{JsonConvert.SerializeObject(ssForK2)}");

            // Save the PO data for K2 log
            //ssK2Help.SaveSingleSourcingDataLogList(ssForK2);
            if (isReturnToInit)
            {
                string[] fieldToCompare = { "PurchaseOrderAmount" };
                var isChanged = true;//ssK2Help.CompareLog(vsId, false, fieldToCompare, moduleName, isProcOffIsChangedDuringResubmit);
                if (isChanged)
                {
                    //Jika ada perubahan data maka set status id PR menjadi Waiting for Approval
                    staticsVendorSelection.Main.StatusUpdate(vsId, "15");
                }
            }
            // Initiate K2 participant
            //var k2Users = SingleSourcingK2Helper.GetSingleSourcingK2User(ssForK2);
            //generalK2Help.Submit(folderName, moduleName, vsId, k2Users, userName);

            //var userList = SingleSourcingK2Helper.GetSingleSourcingActivityUser(ssForK2, "");
            //ssK2Help.SaveK2ActUser(vsId, userList, moduleName);
            //taK2Help.SavePRDataLogList(taForK2);

            //jika ketika submit dan data merupakan data hasil dari Return To Init maka flag is_have_revision_task diupdate menjadi 0 kembali untuk menghilangkan tasklist di Initiator
            if (isReturnToInit)
            {
                var po_no = staticsVendorSelection.Main.IsRevisionUpdate(vsId, "0");
            }
        }

        private static void resubmitWF(string vsId, string userName, string sn, bool isProcOffIsChangedDuringResubmit = false)
        {
            string k2ApiKey = statics.GetSetting("K2ApiKey");
            string k2ApiEndPoint = statics.GetSetting("K2ApiEndpoint");
            //K2Helpers generalK2Help = new K2Helpers();
            //SingleSourcingK2Helper ssK2Help = new SingleSourcingK2Helper();
            var moduleName = statics.GetSetting("K2ProcessNameSS");
            var folderName = statics.GetSetting("K2FolderName");
            var ssForK2 = staticsVendorSelection.Main.GetDataForK2(vsId);

            //ssK2Help.SaveSingleSourcingDataLogList(ssForK2);
            //string[] fieldToCompare = { "PurchaseOrderAmount" };
            //ssK2Help.CompareLog(vsId, false, fieldToCompare, moduleName, isProcOffIsChangedDuringResubmit);
            //var k2Users = SingleSourcingK2Helper.GetSingleSourcingK2User(ssForK2);
            //generalK2Help.Resubmit(k2Users, userName, sn);
            //var userList = SingleSourcingK2Helper.GetSingleSourcingActivityUser(ssForK2);
            //ssK2Help.SaveK2ActUser(vsId, userList, moduleName);

            List<int> listOfInvolvingActId = new List<int>();
            //userDict.Add("DCSUser", mapUser(2, unApproveUsers));
            //userDict.Add("DGUser", mapUser(3, unApproveUsers));
            //userDict.Add("BudgetHolderUser", mapUser(4, unApproveUsers));
            //userDict.Add("ProcurementOfficerUser", mapUser(5, unApproveUsers));
            //userDict.Add("FinanceUser", mapUser(6, unApproveUsers));
            //userDict.Add("PaymentUser", mapUser(7, unApproveUsers));
            //if (!string.IsNullOrEmpty(k2Users[EnumK2SingleSourcingDataField.HeadOperationRecommendationUser].ToString()))
            //{
            //    listOfInvolvingActId.Add(EnumK2SingleSourcing.HeadOfOperationRecommendation); // Activity 4
            //}
            //if (!string.IsNullOrEmpty(k2Users[EnumK2SingleSourcingDataField.DCSRecommendationUser].ToString()))
            //{
            //    listOfInvolvingActId.Add(EnumK2SingleSourcing.DCSRecommendation); // Activity 6
            //}
            //if (!string.IsNullOrEmpty(k2Users[EnumK2SingleSourcingDataField.HeadOperationApprovalUser].ToString()))
            //{
            //    listOfInvolvingActId.Add(EnumK2SingleSourcing.HeadOfOperationApproval); // Activity 9
            //}
            //if (!string.IsNullOrEmpty(k2Users[EnumK2SingleSourcingDataField.DCSApprovalUser].ToString()))
            //{
            //    listOfInvolvingActId.Add(EnumK2SingleSourcing.DCSApproval); // Activity 12
            //}
            //if (!string.IsNullOrEmpty(k2Users[EnumK2SingleSourcingDataField.DGUser].ToString()))
            //{
            //    listOfInvolvingActId.Add(EnumK2SingleSourcing.DGApproval); // Activity 13
            //}

            string nextActId = listOfInvolvingActId.Where(x => x > 1).OrderBy(y => y).FirstOrDefault().ToString();
            string status_id = "15";

            if (!string.IsNullOrEmpty(status_id))
            {
                staticsVendorSelection.Main.StatusUpdate(vsId, status_id);
            }

            //isChargeCodeChange(poId);
        }
    }
}