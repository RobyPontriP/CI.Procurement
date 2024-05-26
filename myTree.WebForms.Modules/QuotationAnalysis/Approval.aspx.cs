//using myTree.WebForms.K2Helper;
using myTree.WebForms.Procurement.General;
using myTree.WebForms.Procurement.General.K2Helper.SingleSourcing;
using myTree.WebForms.Procurement.General.K2Helper.SingleSourcing.Models;
using myTree.WebForms.Procurement.Notification;
using Newtonsoft.Json;
using Serilog;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Threading;
using System.Threading.Tasks;
using System.Web;
using System.Web.Services;

namespace myTree.WebForms.Modules.VendorSelection
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

        protected string vsItems = "[]", vsItemsMain = "[]", supportingDocs = "[]", blankmode = string.Empty;
        protected string listCurrency = string.Empty, max_status = string.Empty, listChargeCode = "[]", listSundry = "[]";
        protected DataModel.VendorSelection VS = new DataModel.VendorSelection();


        protected UserRoleAccess userRoleAccess = AccessControl.GetUserRoleAccess(AccessControlObjectEnum.ProcurementQuotationAnalysis);
        protected Boolean isInWorkflow = false;
        //readonly SingleSourcingK2Helper ssK2Helper = new SingleSourcingK2Helper();

        protected string moduleName = "VENDOR SELECTION";
        protected string service_url, based_url, page_type = string.Empty;
        protected Boolean isEditable = false;

        private class ApprovalObj
        {
            public string approval_type { get; set; }
        }

        private class ItemList
        {
            public string pr_id { get; set; }
            public string pr_detail_id { get; set; }
            public string pr_no { get; set; }
            public string pr_submission_date { get; set; }
            public string cost_center_id { get; set; }
            public string initiator { get; set; }
            public string requester { get; set; }
            public string item_id { get; set; }
            public string item_code { get; set; }
            public string item_description { get; set; }
            public string pr_quantity { get; set; }
            public string vendor_ids { get; set; }
            public string currency_ids { get; set; }
            public string pr_currency { get; set; }
            public string pr_unit_price { get; set; }
            public string uom { get; set; }
            public string qd_description { get; set; }
            public string detail_chargecode { get; set; }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            try
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

                    UserRoleAccess userRoleAccess = AccessControl.GetUserRoleAccess(AccessControlObjectEnum.ProcurementQuotationAnalysis);

                    if (!userRoleAccess.isCanRead)
                    {
                        Response.Redirect(AccessControl.GetSetting("access_denied"));
                        Log.Information("Don't have access control, redirecting...");
                    }

                    bool isAllowed = true;// ssK2Helper.isUserAllowedToAccess(_id, username, "SingleSourcing", "CIPROCUREMENT", sn);
                    if (!isAllowed)
                    {
                        Response.Redirect(AccessControl.GetSetting("access_denied"));
                    }

                    //ApprovalNotes ApvNotes = new ApprovalNotes();// SingleSourcingK2Helper.GetSSApvNotes(Convert.ToInt32(activity_id), username, _id);
                    //approval_notes.activity_desc = ApvNotes.ApprovalNotesWording;
                    //approval_notes.activity_name = ApvNotes.Role;

                    if (!string.IsNullOrEmpty(activity_id))
                    {
                        List<int> approvalActivity = new List<int> { EnumK2SingleSourcing.HeadOfOperationApproval, EnumK2SingleSourcing.DCSApproval, EnumK2SingleSourcing.DGApproval };
                        List<int> recommendationActivity = new List<int> { EnumK2SingleSourcing.HeadOfOperationRecommendation, EnumK2SingleSourcing.DCSRecommendation };

                        if (recommendationActivity.Contains(int.Parse(activity_id)))
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

                    page_type = "APPROVAL";

                }

            }
            catch (Exception ex)
            {
                ExceptionHelpers.PrintError(ex);
            }
        }

        [WebMethod]
        public static string SubmitWF(string submission, string workflows, string strApprovalObj)
        {
            string result, message = string.Empty,
                _id = string.Empty, moduleName = "VENDOR SELECTION", approval_no = "0", status_id = string.Empty;

            try
            {
                DataModel.VendorSelection vs = JsonConvert.DeserializeObject<DataModel.VendorSelection>(submission);
                DataModel.Workflow workflow = JsonConvert.DeserializeObject<DataModel.Workflow>(workflows);
                ApprovalObj approvalObj = JsonConvert.DeserializeObject<ApprovalObj>(strApprovalObj);
                //bool isRequesterActive = statics.CheckActiveRequester(vs.id, moduleName);

                Log.Information($"Start SubmitWF Approval single source with Id : {vs.id} activity id : {workflow.activity_id} and workflow action : {workflow.action}");

                /* insert comment */
                DataModel.Comment comment = new DataModel.Comment
                {
                    module_id = vs.id,
                    module_name = moduleName,
                    comment = workflow.comment,
                    action_taken = workflow.action,
                    activity_id = workflow.activity_id,
                    roles = workflow.roles
                };

                if (approvalObj.approval_type == "approved" || approvalObj.approval_type == "recommended")
                {
                    comment.roles += " for Single Sourcing";
                }

                status_id = workflow.current_status;
                workflow.action = workflow.action.ToLower();

                #region K2 Area
                string k2ApiKey = statics.GetSetting("K2ApiKey");
                string k2ApiEndPoint = statics.GetSetting("K2ApiEndpoint");
                string k2_folder_name = statics.GetSetting("K2FolderName");
                string k2_process_name = statics.GetSetting("K2ProcessNameSS");
                //K2Helpers generalK2Help = new K2Helpers(k2ApiKey, k2ApiEndPoint);
                //SingleSourcingK2Helper ssK2Help = new SingleSourcingK2Helper();
                Dictionary<string, object> dict = new Dictionary<string, object>();
                var username = statics.GetLogonUsername();
                var folio = "CIPROCUREMENT_SingleSourcing_" + _id;
                bool isAllowed = true;//ssK2Help.isUserAllowedToAccess(vs.id, username, "SingleSourcing", "CIPROCUREMENT", workflow.sn);
                if (isAllowed)
                {
                    if (workflow.action == "approved" || workflow.action == "recommended")
                    {
                        if (workflow.action == "recommended")
                        {
                            //generalK2Help.Recommend(dict, username, workflow.sn);
                            status_id = "15";
                        }
                        else
                        {
                            //generalK2Help.Approve(dict, username, workflow.sn);
                            status_id = "25";
                        }
                        //ssK2Help.SaveApproveState(username, workflow.activity_id, vs.id, "SingleSourcing");
                    }
                    else if (workflow.action == "rejected")
                    {
                        Log.Information($"Action rejected triggered");
                        status_id = "25";
                        if (bool.Parse(statics.GetSetting("K2Active")))
                        {
                            //generalK2Help.Reject(dict, username, workflow.sn);
                            Log.Information($"Success reject K2 with dict: \n{JsonConvert.SerializeObject(dict)}");
                            //generalK2Help.Stop("stop", folio, false);
                            Log.Information($"Success stop K2 with folio: \n{folio}");
                            //ssK2Help.CompareLog(vs.id, true, null, "SingleSourcing");
                        }
                    }
                    else if (workflow.action == "requested for revision")
                    {
                        status_id = "10";
                        if (bool.Parse(statics.GetSetting("K2Active")))
                        {
                            //generalK2Help.Revise(dict, username, workflow.sn);
                        }
                    }

                    //if (isRequesterActive)
                    //{

                    /* update status */
                    staticsVendorSelection.Main.StatusUpdate(vs.id, status_id);

                    /* insert comment */
                    approval_no = statics.Comment.Save(comment);

                    /* life cycle */
                    statics.LifeCycle.Save(vs.id, moduleName, status_id);

                        /* send notification */
                        if (workflow.action == "approved")
                        {
                            NotificationHelper.VS_ApprovedSS(vs.id);
                        }
                        else if (workflow.action == "rejected")
                        {
                            NotificationHelper.VS_RejectedSS(vs.id);
                            staticsVendorSelection.Main.UpdateSingleSource(vs.id, "0", "", "", "");
                        }

                    result = "success";
                    //}
                    //else
                    //{
                    //    result = "error";
                    //    message = "Requester is not an active staff. Please reject the request.";
                    //}

                    try
                    {
                        Log.Information("SyncK2Activity");
                        Log.Information("Id: " + vs.id);
                        Log.Information("Folder Name: " + k2_folder_name);
                        Log.Information("Process name:" + k2_process_name);
                        Log.Information("URL:" + ConfigurationManager.AppSettings["MySubmissionSvcEndpoint"].ToString());

                        Thread.Sleep(5000);
                        //string ret = generalK2Help.SyncK2Activity(_id, k2_folder_name, k2_process_name);
                        //var approvalTask = Task.Run(() => generalK2Help.SyncK2Approval(vs.id));
                        //var processTask = Task.Run(() => generalK2Help.SyncK2Process(vs.id));
                        //var activityTask = Task.Run(() => generalK2Help.SyncK2ActivityName(vs.id));
                        //var activeActivityTask = Task.Run(() => generalK2Help.SyncK2Activity(vs.id, k2_folder_name, k2_process_name));

                        //Task.WhenAll(approvalTask, processTask, activityTask, activeActivityTask);
                        Log.Information("Return: All Sync Passed");

                        Thread.Sleep(3000);

                    }
                    catch (Exception ex)
                    {
                        Log.Information("SyncK2Activity gagal. Id: " + vs.id);
                        ExceptionHelpers.PrintError(ex);
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
    }
}