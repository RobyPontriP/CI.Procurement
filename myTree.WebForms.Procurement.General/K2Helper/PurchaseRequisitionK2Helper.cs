
//using myTree.WebForms.K2Helper;
using myTree.WebForms.Procurement.General.K2Helper.PurchaseRequisition.Models;
using Newtonsoft.Json.Linq;
using Serilog;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Linq;

namespace myTree.WebForms.Procurement.General.K2Helper
{
    public class PurchaseRequisitionDetailCostCenterObject
    {
        public string CostCenterId { get; set; }
        public string WorkOrderId { get; set; }
        public string EntityId { get; set; }
        public string Amount { get; set; }
        public string ProductId { get; set; }
        public string Id { get; set; }

    }

    public class PurchaseRequisitionProductObject
    {
        public string PurchaseRequisitionId { get; set; }
        public string Id { get; set; }
        public string CurrencyId { get; set; }
        public string ItemCode { get; set; }
        public string Description { get; set; }
        public string Quantity { get; set; }
        public string UoM { get; set; }
        public string UnitPrice { get; set; }
        public string UnitPriceInUSD { get; set; }
        public string IsActive { get; set; }

    }

    public class K2ActivityUserMapping
    {
        public int ActivityId { get; set; }
        public string Username { get; set; }
        public string Substitute { get; set; }
    }

    public class ParticipantMapping
    {
        public string UserId { get; set; }
        public string Substitute { get; set; }
    }

    //public class PurchaseRequisitionK2Helper
    //{
    //    private K2Helpers k2Help;

    //    static List<K2ActivityUser> unApproveUsers { get; set; }

    //    public PurchaseRequisitionK2Helper()
    //    {
    //        var k2ApiKey = ConfigurationManager.AppSettings["k2ApiKey"].ToString();
    //        var k2ApiEndpoint = ConfigurationManager.AppSettings["k2ApiEndpoint"].ToString();
    //        k2Help = new K2Helpers(k2ApiKey, k2ApiEndpoint);
    //    }

    //    public void SavePRDataLogList(DataTable prData)
    //    {
    //        List<DataLog> listDL = new List<DataLog>();

    //        string prId = prData.Rows[0]["id"].ToString();

    //        DataLog PRType = new DataLog();
    //        PRType.RelevantId = prId;
    //        PRType.Module = "PurchaseRequisition";
    //        PRType.FieldName = "PurchaseRequisitionType";
    //        PRType.Value = prData.Rows[0]["pr_type"].ToString().ToLower();

    //        DataLog PRAmount = new DataLog();
    //        PRAmount.RelevantId = prId;
    //        PRAmount.Module = "PurchaseRequisition";
    //        PRAmount.FieldName = "PurchaseRequisitionAmount";
    //        PRAmount.Value = prData.Rows[0]["pr_amt"].ToString().ToLower();

    //        DataLog chrgCode = new DataLog();
    //        chrgCode.RelevantId = prId;
    //        chrgCode.Module = "PurchaseRequisition";
    //        chrgCode.FieldName = "ChargeCode";
    //        chrgCode.Value = prData.Rows[0]["charge_code"].ToString().ToLower();

    //        DataLog procOffice = new DataLog();
    //        procOffice.RelevantId = prId;
    //        procOffice.Module = "PurchaseRequisition";
    //        procOffice.FieldName = "ProcurementOffice";
    //        procOffice.Value = prData.Rows[0]["procurement_office_id"].ToString().ToLower();

    //        DataLog product = new DataLog();
    //        product.RelevantId = prId;
    //        product.Module = "PurchaseRequisition";
    //        product.FieldName = "Product";
    //        product.Value = prData.Rows[0]["product"].ToString().ToLower();

    //        DataLog productDesc = new DataLog();
    //        productDesc.RelevantId = prId;
    //        productDesc.Module = "PurchaseRequisition";
    //        productDesc.FieldName = "ProductDescription";
    //        productDesc.Value = prData.Rows[0]["productDescription"].ToString();

    //        listDL.Add(PRType);
    //        listDL.Add(PRAmount);
    //        listDL.Add(chrgCode);
    //        listDL.Add(procOffice);
    //        listDL.Add(product);
    //        listDL.Add(productDesc);

    //        SaveDataLog(listDL, "PurchaseRequisition");
    //    }

    //    public static Dictionary<string, object> GetPRK2User(DataTable prData, string accessManagementToken = "")
    //    {
    //        var prId = prData.Rows[0]["id"]?.ToString();
    //        var createdBy = prData.Rows[0]["created_by"]?.ToString();
    //        var title = prData.Rows[0]["system_code"]?.ToString();
    //        string prAmount = prData.Rows[0]["pr_amt"]?.ToString();
    //        string prType = prData.Rows[0]["pr_type"]?.ToString();
    //        string chrgCode = prData.Rows[0]["charge_code"]?.ToString();
    //        string requestor = prData.Rows[0]["requestor"]?.ToString();
    //        string requiredDate = prData.Rows[0]["required_date"]?.ToString();
    //        string procOffId = prData.Rows[0]["procurement_office_id"]?.ToString();
    //        string procOffName = prData.Rows[0]["procurement_office_name"]?.ToString();
    //        string procOffRegion = prData.Rows[0]["procurement_office_region"]?.ToString();
    //        string procSubmissionPageType = prData.Rows[0]["submission_page_type"]?.ToString();

    //        var userDict = new Dictionary<string, object>();
    //        var activityUser = GetPRActivityUser(prData);
    //        var approver = GetAllApproverByRelevantId(prId, "PurchaseRequisition");

    //        unApproveUsers = new List<K2ActivityUser>();
    //        foreach (var u in activityUser)
    //        {
    //            if (u.ActivityID == 4)
    //            {
    //                bool userAlreadyApproved = approver.Where(x => x.ActivityId == u.ActivityID.ToString() && x.Username.ToLower() == u.Username.ToLower()).Any();

    //                if (!userAlreadyApproved)
    //                {
    //                    unApproveUsers.Add(u);
    //                }
    //            }
    //            else
    //            {
    //                bool userAlreadyApproved = approver.Where(x => x.ActivityId == u.ActivityID.ToString()).Any();

    //                if (!userAlreadyApproved)
    //                {
    //                    unApproveUsers.Add(u);
    //                }
    //            }
    //        }

    //        // fill General datafield
    //        userDict.Add("Title", title);
    //        userDict.Add("SystemCode", title);
    //        userDict.Add("InitiatorName", string.IsNullOrEmpty(GetEmployeeNameByUserId(createdBy)) ? "-" : GetEmployeeNameByUserId(createdBy));
    //        userDict.Add("ReservedFieldOne", requestor);
    //        userDict.Add("ReservedFieldTwo", requiredDate);
    //        userDict.Add("ReservedFieldThree", procOffId);
    //        userDict.Add("ReservedFieldFour", procOffRegion);
    //        userDict.Add("ReservedFieldFive", procOffName);
    //        userDict.Add("PurchaseRequisitionType", prType);
    //        userDict.Add("RequisitionAmount", prAmount);

    //        userDict.Add("InitiatorUser", mapUser(1, unApproveUsers));
    //        userDict.Add("DCSUser", mapUser(2, unApproveUsers));
    //        userDict.Add("DGUser", mapUser(3, unApproveUsers));
    //        userDict.Add("BudgetHolderUser", mapUser(4, unApproveUsers));
    //        userDict.Add("ProcurementOfficerUser", mapUser(5, unApproveUsers));
    //        userDict.Add("FinanceUser", mapUser(6, unApproveUsers));
    //        userDict.Add("PaymentUser", mapUser(7, unApproveUsers));
    //        string IsPrForProcurement = procSubmissionPageType == EnumPRPageType.PurchaseRequisition ? "1" : "0";
    //        userDict.Add("IsPRForProcurement", IsPrForProcurement);

    //        return userDict;
    //    }

    //    public static List<K2ActivityUser> GetPRActivityUser(DataTable prObj, string accessManagementToken = "")
    //    {
    //        var CreatedBy = prObj.Rows[0]["created_by"].ToString();
    //        var resquestor = prObj.Rows[0]["requestor_user_id"].ToString();
    //        var prId = prObj.Rows[0]["id"].ToString();
    //        var prType = prObj.Rows[0]["pr_type"].ToString().ToLower();
    //        var prAmount = prObj.Rows[0]["pr_amt"].ToString().ToLower();
    //        var dcsUser = prObj.Rows[0]["dcsUser"].ToString().ToLower();
    //        var dgUser = prObj.Rows[0]["dgUser"].ToString().ToLower();
    //        var bhUser = prObj.Rows[0]["bhUser"].ToString().ToLower();
    //        var procOffUser = prObj.Rows[0]["procOffUser"].ToString().ToLower();
    //        var financeUser = prObj.Rows[0]["financeUser"].ToString().ToLower();
    //        var paymentUser = prObj.Rows[0]["paymentUser"].ToString().ToLower();
    //        var financeLeadUser = prObj.Rows[0]["financeLeadUser"].ToString().ToLower();
    //        var cfooUser = prObj.Rows[0]["cfooUser"].ToString().ToLower();
    //        var countryLeadUser = prObj.Rows[0]["countryLeadUser"].ToString().ToLower();

    //        bool isFromRedirect = false;
    //        var PrTypeBefore = GetLatestPRTypeById(prId);
    //        if (prType.Equals(PrTypeBefore))
    //        {
    //            isFromRedirect = true;
    //        }

    //        var activityUserList = new List<K2ActivityUser>();

    //        #region Get General User
    //        activityUserList.AddRange((GetInitiatorUser(CreatedBy))
    //            .Where(x => !activityUserList.Select(z => z.Username.ToLower()).Contains(x.UserId.ToLower()))
    //            .Select(x => new K2ActivityUser() { Username = x.UserId, ActivityID = 0 })
    //            );

    //        activityUserList.AddRange((GetInitiatorUser(resquestor))
    //           .Where(x => !activityUserList.Select(z => z.Username.ToLower()).Contains(x.UserId.ToLower()))
    //           .Select(x => new K2ActivityUser() { Username = x.UserId, ActivityID = 0 })
    //           );

    //        activityUserList.AddRange((GetInitiatorUser(CreatedBy))
    //           .Select(x => new K2ActivityUser() { Username = x.UserId, ActivityID = 1 })
    //           );
    //        #endregion

    //        #region Get User
    //        string[] noNeedFinance = { "3" };
    //        string[] noNeedFinanceVerif = { "6" };
    //        string[] noNeedJustification = { "3" };

    //        if (!noNeedFinance.Contains(prType))
    //        {
    //            activityUserList.AddRange((AddUser(paymentUser, prId, 7, prObj))
    //            .Where(x => !activityUserList.Select(z => z.Username.ToLower()).Contains(x.UserId.ToLower()))
    //            .Select(x => new K2ActivityUser() { Username = x.UserId, ActivityID = 7 })
    //            );

    //            if (!noNeedFinanceVerif.Contains(prType))
    //            {
    //                //activityUserList.AddRange((AddUser(financeUser, prId, 6))
    //                //.Where(x => !activityUserList.Select(z => z.Username.ToLower()).Contains(x.UserId.ToLower()))
    //                //.Select(x => new K2ActivityUser() { Username = x.UserId, ActivityID = 6 })
    //                //);
    //            }

    //            if (isFromRedirect)
    //            {
    //                var procOffData = CheckProcurementOfficeUserInCurrentSequence(prId);
    //                //cek current Pr Type dan PrType sebelumnya
    //                //Kalo current Prtype not allowed act5 dan last PrType nya not allowed sct 5 juga tapi ada activity5 maka merupakan hasil dari redirect lalu resubmit
    //                //kalo current prtype not allowed act 5 dan last Prtype allowed
    //                if (procOffData != null)
    //                {
    //                    if (procOffData.Rows.Count > 0)
    //                    {
    //                        var isProcOfficeUserExist = procOffData.Rows[0]["isProcOfficeUserExist"].ToString().ToLower() == "true" ? true : false;
    //                        var existProcOfficeUser = procOffData.Rows[0]["procOfficeUser"].ToString();

    //                        //cek is_have_revision_task dan last action return to init
    //                        bool isAllowedToInsertPaymentUser = true;
    //                        bool isReturnToInit = false;

    //                        isReturnToInit = CheckIsHaveRevisionTask(prId);
    //                        if (isReturnToInit)
    //                        {
    //                            //checklast take action
    //                            DataTable lastVerif = CheckPRLastVerif(prId);
    //                            if (lastVerif != null)
    //                            {
    //                                if (lastVerif.Rows.Count > 0)
    //                                {
    //                                    var lastActIdVerif = lastVerif.Rows[0]["activity_id"].ToString();
    //                                    isAllowedToInsertPaymentUser = lastActIdVerif == "5" ? true : false;
    //                                }
    //                            }
    //                        }

    //                        if (isProcOfficeUserExist && isAllowedToInsertPaymentUser)
    //                        {
    //                            activityUserList.AddRange((AddUser(existProcOfficeUser, prId, 5, prObj))
    //                            .Where(x => !activityUserList.Select(z => z.Username.ToLower()).Contains(x.UserId.ToLower()))
    //                            .Select(x => new K2ActivityUser() { Username = x.UserId, ActivityID = 5 })
    //                            );
    //                        }
    //                    }
    //                }
    //            }
    //        }
    //        else
    //        {
    //            if (isFromRedirect)
    //            {
    //                var finData = CheckFinanceInCurrentSequence(prId);
    //                if (finData.Rows.Count > 0)
    //                {
    //                    var isFinanceExist = finData.Rows[0]["isFinanceUserExist"].ToString().ToLower() == "true" ? true : false;
    //                    var isPaymentExist = finData.Rows[0]["isPayUserExist"].ToString().ToLower() == "true" ? true : false; ;
    //                    var existfinanceUser = finData.Rows[0]["financeUser"].ToString();
    //                    var existpaymentUser = finData.Rows[0]["paymentUser"].ToString();

    //                    //cek is_have_revision_task dan last action return to init
    //                    bool isAllowedToInsertPaymentUser = true;
    //                    bool isReturnToInit = false;

    //                    isReturnToInit = CheckIsHaveRevisionTask(prId);
    //                    if (isReturnToInit)
    //                    {
    //                        //checklast take action
    //                        DataTable lastVerif = CheckPRLastVerif(prId);
    //                        if (lastVerif != null)
    //                        {
    //                            if (lastVerif.Rows.Count > 0)
    //                            {
    //                                var lastActIdVerif = lastVerif.Rows[0]["activity_id"].ToString();
    //                                isAllowedToInsertPaymentUser = lastActIdVerif == "7" ? true : false;
    //                            }
    //                        }
    //                    }

    //                    if (isPaymentExist && isAllowedToInsertPaymentUser)
    //                    {
    //                        activityUserList.AddRange((AddUser(existpaymentUser, prId, 7, prObj))
    //                        .Where(x => !activityUserList.Select(z => z.Username.ToLower()).Contains(x.UserId.ToLower()))
    //                        .Select(x => new K2ActivityUser() { Username = x.UserId, ActivityID = 7 })
    //                        );
    //                    }

    //                    if (isFinanceExist)
    //                    {
    //                        //activityUserList.AddRange((AddUser(existfinanceUser, prId, 6))
    //                        //.Where(x => !activityUserList.Select(z => z.Username.ToLower()).Contains(x.UserId.ToLower()))
    //                        //.Select(x => new K2ActivityUser() { Username = x.UserId, ActivityID = 6 })
    //                        //);
    //                    }
    //                }
    //            }

    //            activityUserList.AddRange((AddUser(procOffUser, prId, 5, prObj))
    //            .Where(x => !activityUserList.Select(z => z.Username.ToLower()).Contains(x.UserId.ToLower()))
    //            .Select(x => new K2ActivityUser() { Username = x.UserId, ActivityID = 5 })
    //            );
    //        }

    //        activityUserList.AddRange((AddUser(bhUser, prId, 4, prObj))
    //            .Select(x => new K2ActivityUser() { Username = x.UserId, ActivityID = 4 })
    //            );

    //        int[] actIdToCompare = { 4 };
    //        if (!noNeedJustification.Contains(prType))
    //        {
    //            if (Convert.ToDecimal(prAmount) > 500) // Minimum Justification
    //            {
    //                if (Convert.ToDecimal(prAmount) > 80000) // Threshold to DG
    //                {
    //                    activityUserList.AddRange((AddUser(dgUser, prId, 3, prObj))
    //                        .Where(x => !activityUserList.Where(y => actIdToCompare.Contains(y.ActivityID)).Select(z => z.Username.ToLower()).Contains(x.UserId.ToLower()))
    //                        .Select(x => new K2ActivityUser() { Username = x.UserId, ActivityID = 3 })
    //                        );
    //                }
    //                else // Threshold check
    //                {
    //                    if (Convert.ToDecimal(prAmount) <= 5000)
    //                    {
    //                        // Go to Finance Lead
    //                        activityUserList.AddRange((AddUser(financeLeadUser, prId, 2, prObj))
    //                            .Where(x => !activityUserList.Where(y => actIdToCompare.Contains(y.ActivityID)).Select(z => z.Username.ToLower()).Contains(x.UserId.ToLower()))
    //                            .Select(x => new K2ActivityUser() { Username = x.UserId, ActivityID = 2 })
    //                            );
    //                    }
    //                    else if (Convert.ToDecimal(prAmount) > 5000 && Convert.ToDecimal(prAmount) <= 35000)
    //                    {
    //                        // Go to Country/Head Unit
    //                        activityUserList.AddRange((AddUser(countryLeadUser, prId, 2, prObj))
    //                            .Where(x => !activityUserList.Where(y => actIdToCompare.Contains(y.ActivityID)).Select(z => z.Username.ToLower()).Contains(x.UserId.ToLower()))
    //                            .Select(x => new K2ActivityUser() { Username = x.UserId, ActivityID = 2 })
    //                            );
    //                    }
    //                    else if (Convert.ToDecimal(prAmount) > 35000 && Convert.ToDecimal(prAmount) <= 50000)
    //                    {
    //                        // Go to CFOO
    //                        activityUserList.AddRange((AddUser(cfooUser, prId, 2, prObj))
    //                            .Where(x => !activityUserList.Where(y => actIdToCompare.Contains(y.ActivityID)).Select(z => z.Username.ToLower()).Contains(x.UserId.ToLower()))
    //                            .Select(x => new K2ActivityUser() { Username = x.UserId, ActivityID = 2 })
    //                            );
    //                    }
    //                    else if (Convert.ToDecimal(prAmount) > 50000 && Convert.ToDecimal(prAmount) <= 80000)
    //                    {
    //                        // Go to DCS
    //                        activityUserList.AddRange((AddUser(dcsUser, prId, 2, prObj))
    //                            .Where(x => !activityUserList.Where(y => actIdToCompare.Contains(y.ActivityID)).Select(z => z.Username.ToLower()).Contains(x.UserId.ToLower()))
    //                            .Select(x => new K2ActivityUser() { Username = x.UserId, ActivityID = 2 })
    //                            );
    //                    }
    //                }
    //            }
    //        }
    //        #endregion

    //        return activityUserList;
    //    }

    //    public static List<K2ActivityUser> GetPRAllActivityUser(DataTable prObj, string accessManagementToken = "")
    //    {
    //        var CreatedBy = prObj.Rows[0]["created_by"].ToString();
    //        var requestor = prObj.Rows[0]["requestor_user_id"].ToString();
    //        var prId = prObj.Rows[0]["id"].ToString();
    //        var prType = prObj.Rows[0]["pr_type"].ToString().ToLower();
    //        var prAmount = prObj.Rows[0]["pr_amt"].ToString().ToLower();
    //        var dcsUser = prObj.Rows[0]["dcsUser"].ToString().ToLower();
    //        var dgUser = prObj.Rows[0]["dgUser"].ToString().ToLower();
    //        var bhUser = prObj.Rows[0]["bhUser"].ToString().ToLower();
    //        var procOffUser = prObj.Rows[0]["procOffUser"].ToString().ToLower();
    //        var financeUser = prObj.Rows[0]["financeUser"].ToString().ToLower();
    //        var paymentUser = prObj.Rows[0]["paymentUser"].ToString().ToLower();
    //        var financeLeadUser = prObj.Rows[0]["financeLeadUser"].ToString().ToLower();
    //        var cfooUser = prObj.Rows[0]["cfooUser"].ToString().ToLower();
    //        var countryLeadUser = prObj.Rows[0]["countryLeadUser"].ToString().ToLower();
    //        bool isFromRedirect = false;
    //        var PrTypeBefore = GetLatestPRTypeById(prId);
    //        if (prType.Equals(PrTypeBefore))
    //        {
    //            isFromRedirect = true;
    //        }

    //        var activityUserList = new List<K2ActivityUser>();

    //        #region Get General User
    //        activityUserList.AddRange((GetInitiatorUser(CreatedBy))
    //            .Select(x => new K2ActivityUser() { Username = x.UserId, ActivityID = 0 })
    //            );

    //        activityUserList.AddRange((GetInitiatorUser(requestor))
    //           .Select(x => new K2ActivityUser() { Username = x.UserId, ActivityID = 0 })
    //           );

    //        activityUserList.AddRange((GetInitiatorUser(CreatedBy))
    //           .Select(x => new K2ActivityUser() { Username = x.UserId, ActivityID = 1 })
    //           );
    //        #endregion

    //        #region Get User
    //        string[] noNeedFinance = { "3" };
    //        string[] noNeedFinanceVerif = { "6" };
    //        string[] noNeedJustification = { "3" };

    //        if (!noNeedFinance.Contains(prType))
    //        {
    //            activityUserList.AddRange((AddUser(paymentUser, prId, 7, prObj))
    //            .Select(x => new K2ActivityUser() { Username = x.UserId, ActivityID = 7 })
    //            );

    //            if (!noNeedFinanceVerif.Contains(prType))
    //            {
    //                //activityUserList.AddRange((AddUser(financeUser, prId))
    //                //.Select(x => new K2ActivityUser() { Username = x.UserId, ActivityID = 6 })
    //                //);
    //            }

    //            if (isFromRedirect)
    //            {
    //                var procOffData = CheckProcurementOfficeUserInCurrentSequence(prId);
    //                if (procOffData != null)
    //                {
    //                    if (procOffData.Rows.Count > 0)
    //                    {
    //                        var isProcOfficeUserExist = procOffData.Rows[0]["isProcOfficeUserExist"].ToString().ToLower() == "true" ? true : false;
    //                        var existProcOfficeUser = procOffData.Rows[0]["procOfficeUser"].ToString();

    //                        //cek is_have_revision_task dan last action return to init
    //                        bool isAllowedToInsertPaymentUser = true;
    //                        bool isReturnToInit = false;

    //                        isReturnToInit = CheckIsHaveRevisionTask(prId);
    //                        if (isReturnToInit)
    //                        {
    //                            //checklast take action
    //                            DataTable lastVerif = CheckPRLastVerif(prId);
    //                            if (lastVerif != null)
    //                            {
    //                                if (lastVerif.Rows.Count > 0)
    //                                {
    //                                    var lastActIdVerif = lastVerif.Rows[0]["activity_id"].ToString();
    //                                    isAllowedToInsertPaymentUser = lastActIdVerif == "5" ? true : false;
    //                                }
    //                            }
    //                        }

    //                        if (isProcOfficeUserExist && isAllowedToInsertPaymentUser)
    //                        {
    //                            activityUserList.AddRange((AddUser(existProcOfficeUser, prId, 5, prObj))
    //                            .Select(x => new K2ActivityUser() { Username = x.UserId, ActivityID = 5 })
    //                            );
    //                        }
    //                    }
    //                }
    //            }
    //        }
    //        else
    //        {
    //            if (isFromRedirect)
    //            {
    //                var finData = CheckFinanceInCurrentSequence(prId);
    //                if (finData.Rows.Count > 0)
    //                {
    //                    var isFinanceExist = finData.Rows[0]["isFinanceUserExist"].ToString().ToLower() == "true" ? true : false;
    //                    var isPaymentExist = finData.Rows[0]["isPayUserExist"].ToString().ToLower() == "true" ? true : false; ;
    //                    var existfinanceUser = finData.Rows[0]["financeUser"].ToString();
    //                    var existpaymentUser = finData.Rows[0]["paymentUser"].ToString();

    //                    //cek is_have_revision_task dan last action return to init
    //                    bool isAllowedToInsertPaymentUser = true;
    //                    bool isReturnToInit = false;

    //                    isReturnToInit = CheckIsHaveRevisionTask(prId);
    //                    if (isReturnToInit)
    //                    {
    //                        //checklast take action
    //                        DataTable lastVerif = CheckPRLastVerif(prId);
    //                        if (lastVerif != null)
    //                        {
    //                            if (lastVerif.Rows.Count > 0)
    //                            {
    //                                var lastActIdVerif = lastVerif.Rows[0]["activity_id"].ToString();
    //                                isAllowedToInsertPaymentUser = lastActIdVerif == "7" ? true : false;
    //                            }
    //                        }
    //                    }

    //                    if (isPaymentExist && isAllowedToInsertPaymentUser)
    //                    {
    //                        activityUserList.AddRange((AddUser(existpaymentUser, prId, 7, prObj))
    //                        .Select(x => new K2ActivityUser() { Username = x.UserId, ActivityID = 7 })
    //                        );
    //                    }

    //                    if (isFinanceExist)
    //                    {
    //                        //activityUserList.AddRange((AddUser(existfinanceUser, prId, 6))
    //                        //.Select(x => new K2ActivityUser() { Username = x.UserId, ActivityID = 6 })
    //                        //);
    //                    }
    //                }
    //            }

    //            activityUserList.AddRange((AddUser(procOffUser, prId, 5, prObj))
    //            .Select(x => new K2ActivityUser() { Username = x.UserId, ActivityID = 5 })
    //            );
    //        }


    //        activityUserList.AddRange((AddUser(bhUser, prId, 4, prObj))
    //            .Select(x => new K2ActivityUser() { Username = x.UserId, ActivityID = 4 })
    //            );


    //        if (!noNeedJustification.Contains(prType))
    //        {
    //            if (Convert.ToDecimal(prAmount) > 500)
    //            {
    //                if (Convert.ToDecimal(prAmount) > 80000)
    //                {
    //                    activityUserList.AddRange((AddUser(dgUser, prId, 3, prObj))
    //                        .Select(x => new K2ActivityUser() { Username = x.UserId, ActivityID = 3 })
    //                        );
    //                }
    //                else
    //                {
    //                    if (Convert.ToDecimal(prAmount) <= 5000)
    //                    {
    //                        // Go to Finance Lead
    //                        activityUserList.AddRange((AddUser(financeLeadUser, prId, 2, prObj))
    //                        .Select(x => new K2ActivityUser() { Username = x.UserId, ActivityID = 2 })
    //                        );
    //                    }
    //                    else if (Convert.ToDecimal(prAmount) > 5000 && Convert.ToDecimal(prAmount) <= 35000)
    //                    {
    //                        // Go to Country/Head Unit
    //                        activityUserList.AddRange((AddUser(countryLeadUser, prId, 2, prObj))
    //                        .Select(x => new K2ActivityUser() { Username = x.UserId, ActivityID = 2 })
    //                        );
    //                    }
    //                    else if (Convert.ToDecimal(prAmount) > 35000 && Convert.ToDecimal(prAmount) <= 50000)
    //                    {
    //                        // Go to CFOO
    //                        activityUserList.AddRange((AddUser(cfooUser, prId, 2, prObj))
    //                        .Select(x => new K2ActivityUser() { Username = x.UserId, ActivityID = 2 })
    //                        );
    //                    }
    //                    else if (Convert.ToDecimal(prAmount) > 50000 && Convert.ToDecimal(prAmount) <= 80000)
    //                    {
    //                        // Go to DCS
    //                        activityUserList.AddRange((AddUser(dcsUser, prId, 2, prObj))
    //                        .Select(x => new K2ActivityUser() { Username = x.UserId, ActivityID = 2 })
    //                        );
    //                    }
    //                }
    //            }
    //        }
    //        #endregion

    //        return activityUserList;
    //    }

    //    private static List<Participant> GetInitiatorUser(string initiatorUserId)
    //    {
    //        string PIUserName = "";
    //        Participant part = new Participant();
    //        List<Participant> listOfPart = new List<Participant>();

    //        if (!string.IsNullOrEmpty(initiatorUserId))
    //        {
    //            PIUserName = initiatorUserId;
    //        }

    //        part.UserId = PIUserName;
    //        listOfPart.Add(part);

    //        return listOfPart;
    //    }

    //    private static List<Participant> AddUser(string user, string prId = "", int actId = 0, DataTable prData = null)
    //    {
    //        List<Participant> listOfPart = new List<Participant>();

    //        //if (actId == 5)
    //        //{
    //        //    var part = new Participant();
    //        //    part.UserId = "BMBATHI";
    //        //    listOfPart.Add(part);

    //        //    var part2 = new Participant();
    //        //    part2.UserId = "RENDAH";
    //        //    listOfPart.Add(part2);
    //        //}

    //        if (!string.IsNullOrEmpty(user))
    //        {
    //            var userArr = user.Split(';').ToList();

    //            if (userArr.Count > 0)
    //            {
    //                foreach (string a in userArr)
    //                {
    //                    var part = new Participant();

    //                    if (!string.IsNullOrEmpty(a))
    //                    {
    //                        if (prData == null)
    //                        {
    //                            prData = staticsPurchaseRequisition.Main.GetDataForK2(prId);
    //                        }
    //                        string prAmount = prData.Rows[0]["pr_amt"]?.ToString();
    //                        string prType = prData.Rows[0]["pr_type"]?.ToString();
    //                        string bhUser = prData.Rows[0]["bhUser"].ToString().ToLower();
    //                        List<string> bhUserList = bhUser.Split(';').ToList();
    //                        string DGO = statics.GetSetting("DirectorGeneralTeamId");
    //                        string DGOE = statics.GetSetting("DirectorGeneralExecutiveTeamId");
    //                        string DCS = statics.GetSetting("DirectorCorporateServiceTeamId");
    //                        string prLeadUserIdOne = GetPRLeadByCode(statics.GetSetting("PRLEADONE")).Rows[0]["UserId"].ToString();
    //                        string prLeadUserIdTwo = GetPRLeadByCode(statics.GetSetting("PRLEADTWO")).Rows[0]["UserId"].ToString();
    //                        //var DGOUserId = "RNASI".ToLower(); // GetTeamLeaderEmployeeDataByTeamId(DGO).Rows[0]["UserId"].ToString().ToLower();
    //                        //var DGOEUserId = "RPRABHU".ToLower(); // GetTeamLeaderEmployeeDataByTeamId(DGOE).Rows[0]["UserId"].ToString().ToLower();
    //                        var DGOUserId = GetTeamByTeamId(DGO).Rows[0]["TeamLeaderUserId"].ToString().ToLower();
    //                        var DGOEUserId = GetTeamByTeamId(DGOE).Rows[0]["TeamLeaderUserId"].ToString().ToLower();
    //                        bool isInitiator = isUserNameInitiator(prId, a);
    //                        bool isRequestor = isUserNameRequestor(prId, a);
    //                        string[] noNeedJustification = { "3" };
    //                        bool isDgInvolveInWF = false;
    //                        bool isUserIdInvolveInChargeCode = bhUserList.Where(x => x == a).Any();
    //                        bool isDcsInvolveInWF = false;
    //                        bool isDg = CheckIsUsernameATeamLead(a, DGO);
    //                        bool isDcs = CheckIsUsernameATeamLead(a, DCS);
    //                        string financeLeadUser = prData.Rows[0]["financeLeadUser"].ToString().ToLower();

    //                        if (!noNeedJustification.Contains(prType))
    //                        {
    //                            if (Convert.ToDecimal(prAmount) > 500)
    //                            {
    //                                if (Convert.ToDecimal(prAmount) > 80000)
    //                                {
    //                                    isDgInvolveInWF = true;
    //                                }
    //                                else
    //                                {
    //                                    isDcsInvolveInWF = true;
    //                                }
    //                            }
    //                        }

    //                        if (isInitiator || isRequestor)
    //                        {
    //                            if (actId == 2)
    //                            {
    //                                if (Convert.ToDecimal(prAmount) > 50000 && Convert.ToDecimal(prAmount) <= 80000)
    //                                {
    //                                    var teamId = DCS;
    //                                    part.UserId = EscalateToHigherLevel(teamId);
    //                                }
    //                                else
    //                                {
    //                                    var spvData = GetDirectSupervisorByUserId(a);
    //                                    if (spvData != null)
    //                                    {
    //                                        if (spvData.Rows.Count > 0)
    //                                        {
    //                                            if (!string.IsNullOrEmpty(spvData.Rows[0]["UserId"].ToString()))
    //                                            {
    //                                                part.UserId = spvData.Rows[0]["UserId"].ToString().ToLower();
    //                                            }
    //                                        }
    //                                    }
    //                                }

    //                            }
    //                            else if (actId == 3)
    //                            {
    //                                if (a.ToLower() == DGOUserId)
    //                                {
    //                                    part.UserId = DGOEUserId;
    //                                }
    //                                else if (a.ToLower() == DGOEUserId)
    //                                {
    //                                    part.UserId = DGOUserId;
    //                                }
    //                            }
    //                            else if (actId == 4)
    //                            {
    //                                //if actId = 4  escalate to Supervisor
    //                                if (isDg)
    //                                {
    //                                    if (a.ToLower() == DGOUserId)
    //                                    {
    //                                        part.UserId = DGOEUserId;
    //                                    }
    //                                    else if (a.ToLower() == DGOEUserId)
    //                                    {
    //                                        part.UserId = DGOUserId;
    //                                    }
    //                                }
    //                                else if (isDcs)
    //                                {
    //                                    part.UserId = EscalateToHigherLevel(DCS);
    //                                }
    //                                else
    //                                {
    //                                    var spvData = GetDirectSupervisorByUserId(a);
    //                                    if (spvData != null)
    //                                    {
    //                                        if (spvData.Rows.Count > 0)
    //                                        {
    //                                            if (!string.IsNullOrEmpty(spvData.Rows[0]["UserId"].ToString()))
    //                                            {
    //                                                part.UserId = spvData.Rows[0]["UserId"].ToString().ToLower();
    //                                            }
    //                                        }
    //                                    }
    //                                }
    //                            }
    //                            else if (actId == 5)
    //                            {
    //                                var procOffuser = prData.Rows[0]["procOffUser"].ToString().ToLower();
    //                                var procOfficerList = procOffuser.Split(';').ToList();
    //                                procOfficerList.RemoveAll(x => x == "" || x == null);
    //                                var elseParticipantCount = procOfficerList.Where(x => x.ToLower() != a.ToLower()).Count();
    //                                if (elseParticipantCount < 1)
    //                                {
    //                                    if (a.ToLower() == prLeadUserIdOne.ToLower())
    //                                    {
    //                                        part.UserId = prLeadUserIdTwo;
    //                                    }
    //                                    else if (a.ToLower() == prLeadUserIdTwo.ToLower())
    //                                    {
    //                                        part.UserId = prLeadUserIdOne;
    //                                    }
    //                                    else
    //                                    {
    //                                        //var spvData = GetDirectSupervisorByUserId(a);
    //                                        //if (spvData.Rows.Count > 0)
    //                                        //{
    //                                        //    if (!string.IsNullOrEmpty(spvData.Rows[0]["UserId"].ToString()))
    //                                        //    {
    //                                        //        part.UserId = spvData.Rows[0]["UserId"].ToString().ToLower();
    //                                        //    }
    //                                        //    else
    //                                        //    {
    //                                        //        part.UserId = a;
    //                                        //    }
    //                                        //}
    //                                        //else
    //                                        //{
    //                                        //    part.UserId = a;
    //                                        //}

    //                                        part.UserId = a;
    //                                    }
    //                                }
    //                                else
    //                                {
    //                                    part.UserId = a;
    //                                }

    //                            }
    //                            else if (actId == 6)
    //                            {
    //                                if (userArr.Count < 2)
    //                                {
    //                                    var spvData = GetDirectSupervisorByUserId(a);
    //                                    if (spvData.Rows.Count > 0)
    //                                    {
    //                                        if (!string.IsNullOrEmpty(spvData.Rows[0]["UserId"].ToString()))
    //                                        {
    //                                            part.UserId = spvData.Rows[0]["UserId"].ToString().ToLower();
    //                                        }
    //                                    }
    //                                }
    //                                else
    //                                {
    //                                    part.UserId = a;
    //                                }
    //                            }
    //                            else if (actId == 7)
    //                            {
    //                                if (userArr.Count < 2)
    //                                {
    //                                    var financeLeadUserList = financeLeadUser.Split(';').ToList();
    //                                    financeLeadUserList.RemoveAll(x => x == "" || x == null);
    //                                    foreach (var u in financeLeadUserList)
    //                                    {
    //                                        part.UserId = u;
    //                                        listOfPart.Add(part);
    //                                    }
    //                                }
    //                                else
    //                                {
    //                                    part.UserId = a;
    //                                }
    //                            }
    //                            else
    //                            {
    //                                part.UserId = a;
    //                            }
    //                        }
    //                        else if (isDg)
    //                        {
    //                            if (isUserIdInvolveInChargeCode)
    //                            {
    //                                if (actId == 3)
    //                                {
    //                                    if (a == DGOUserId)
    //                                    {
    //                                        part.UserId = DGOEUserId;
    //                                    }
    //                                    else if (a == DGOEUserId)
    //                                    {
    //                                        part.UserId = DGOUserId;
    //                                    }
    //                                }
    //                                else
    //                                {
    //                                    part.UserId = a;
    //                                }
    //                            }
    //                            else
    //                            {
    //                                part.UserId = a;
    //                            }
    //                        }
    //                        else if (isDcs)
    //                        {
    //                            if (isUserIdInvolveInChargeCode)
    //                            {
    //                                if (actId == 2)
    //                                {
    //                                    var teamId = DCS;
    //                                    part.UserId = EscalateToHigherLevel(teamId);
    //                                }
    //                                else
    //                                {
    //                                    part.UserId = a;
    //                                }
    //                            }
    //                            else
    //                            {
    //                                part.UserId = a;
    //                            }
    //                        }
    //                        else
    //                        {
    //                            part.UserId = a;
    //                        }

    //                        if (!listOfPart.Where(x => x.UserId == part.UserId).Any())
    //                        {
    //                            listOfPart.Add(part);
    //                        }
    //                    }
    //                }
    //            }
    //        }

    //        return listOfPart;
    //    }

    //    private static List<ParticipantMapping> AddUserSubsMapping(string user, string prId = "", int actId = 0, DataTable prData = null)
    //    {
    //        List<ParticipantMapping> listOfPart = new List<ParticipantMapping>();

    //        //if (actId == 5)
    //        //{
    //        //    var part = new Participant();
    //        //    part.UserId = "BMBATHI";
    //        //    listOfPart.Add(part);

    //        //    var part2 = new Participant();
    //        //    part2.UserId = "RENDAH";
    //        //    listOfPart.Add(part2);
    //        //}

    //        if (!string.IsNullOrEmpty(user))
    //        {
    //            var userArr = user.Split(';').ToList();

    //            if (userArr.Count > 0)
    //            {
    //                foreach (string a in userArr)
    //                {
    //                    var part = new ParticipantMapping();
    //                    part.UserId = a;
    //                    part.Substitute = "";

    //                    if (!string.IsNullOrEmpty(a))
    //                    {
    //                        if (prData == null)
    //                        {
    //                            prData = staticsPurchaseRequisition.Main.GetDataForK2(prId);
    //                        }
    //                        string prAmount = prData.Rows[0]["pr_amt"]?.ToString();
    //                        string prType = prData.Rows[0]["pr_type"]?.ToString();
    //                        string bhUser = prData.Rows[0]["bhUser"].ToString().ToLower();
    //                        List<string> bhUserList = bhUser.Split(';').ToList();
    //                        string DGO = statics.GetSetting("DirectorGeneralTeamId");
    //                        string DGOE = statics.GetSetting("DirectorGeneralExecutiveTeamId");
    //                        string DCS = statics.GetSetting("DirectorCorporateServiceTeamId");
    //                        string prLeadUserIdOne = GetPRLeadByCode(statics.GetSetting("PRLEADONE")).Rows[0]["UserId"].ToString();
    //                        string prLeadUserIdTwo = GetPRLeadByCode(statics.GetSetting("PRLEADTWO")).Rows[0]["UserId"].ToString();
    //                        //var DGOUserId = "RNASI".ToLower(); // GetTeamLeaderEmployeeDataByTeamId(DGO).Rows[0]["UserId"].ToString().ToLower();
    //                        //var DGOEUserId = "RPRABHU".ToLower(); // GetTeamLeaderEmployeeDataByTeamId(DGOE).Rows[0]["UserId"].ToString().ToLower();
    //                        var DGOUserId = GetTeamByTeamId(DGO).Rows[0]["TeamLeaderUserId"].ToString().ToLower();
    //                        var DGOEUserId = GetTeamByTeamId(DGOE).Rows[0]["TeamLeaderUserId"].ToString().ToLower();
    //                        bool isInitiator = isUserNameInitiator(prId, a);
    //                        bool isRequestor = isUserNameRequestor(prId, a);
    //                        string[] noNeedJustification = { "3" };
    //                        bool isDgInvolveInWF = false;
    //                        bool isDcsInvolveInWF = false;
    //                        bool isUserIdInvolveInChargeCode = bhUserList.Where(x => x == a).Any();
    //                        bool isDg = CheckIsUsernameATeamLead(a, DGO);
    //                        bool isDcs = CheckIsUsernameATeamLead(a, DCS);
    //                        string financeLeadUser = prData.Rows[0]["financeLeadUser"].ToString().ToLower();
                            
    //                        if (!noNeedJustification.Contains(prType))
    //                        {
    //                            if (Convert.ToDecimal(prAmount) > 500)
    //                            {
    //                                if (Convert.ToDecimal(prAmount) > 80000)
    //                                {
    //                                    isDgInvolveInWF = true;
    //                                }
    //                                else
    //                                {
    //                                    isDcsInvolveInWF = true;
    //                                }
    //                            }
    //                        }

    //                        if (isInitiator || isRequestor)
    //                        {
    //                            if (actId == 2)
    //                            {
    //                                if (Convert.ToDecimal(prAmount) > 50000 && Convert.ToDecimal(prAmount) <= 80000)
    //                                {
    //                                    var teamId = DCS;
    //                                    part.UserId = EscalateToHigherLevel(teamId);
    //                                }
    //                                else
    //                                {
    //                                    var spvData = GetDirectSupervisorByUserId(a);
    //                                    if (spvData != null)
    //                                    {
    //                                        if (spvData.Rows.Count > 0)
    //                                        {
    //                                            if (!string.IsNullOrEmpty(spvData.Rows[0]["UserId"].ToString()))
    //                                            {
    //                                                part.UserId = spvData.Rows[0]["UserId"].ToString().ToLower();
    //                                            }
    //                                        }
    //                                    }
    //                                }

    //                            }
    //                            else if (actId == 3)
    //                            {
    //                                if (a.ToLower() == DGOUserId)
    //                                {
    //                                    part.UserId = a;
    //                                    part.Substitute = DGOEUserId;
    //                                }
    //                                else if (a.ToLower() == DGOEUserId)
    //                                {
    //                                    part.UserId = a;
    //                                    part.Substitute = DGOUserId;
    //                                }
    //                            }
    //                            else if (actId == 4)
    //                            {
    //                                //if actId = 4  escalate to Supervisor
    //                                if (isDg)
    //                                {
    //                                    if (a.ToLower() == DGOUserId)
    //                                    {
    //                                        part.UserId = a;
    //                                        part.Substitute = DGOEUserId;
    //                                    }
    //                                    else if (a.ToLower() == DGOEUserId)
    //                                    {
    //                                        part.UserId = a;
    //                                        part.Substitute = DGOUserId;
    //                                    }
    //                                }
    //                                else if (isDcs)
    //                                {
    //                                    part.UserId = a;
    //                                    part.Substitute = EscalateToHigherLevel(DCS);
    //                                }
    //                                else
    //                                {
    //                                    var spvData = GetDirectSupervisorByUserId(a);
    //                                    if (spvData != null)
    //                                    {
    //                                        if (spvData.Rows.Count > 0)
    //                                        {
    //                                            if (!string.IsNullOrEmpty(spvData.Rows[0]["UserId"].ToString()))
    //                                            {
    //                                                part.UserId = a;
    //                                                part.Substitute = spvData.Rows[0]["UserId"].ToString().ToLower();
    //                                            }
    //                                        }
    //                                    }
    //                                }
    //                            }
    //                            else if (actId == 5)
    //                            {
    //                                var procOffuser = prData.Rows[0]["procOffUser"].ToString().ToLower();
    //                                var procOfficerList = procOffuser.Split(';').ToList();
    //                                procOfficerList.RemoveAll(x => x == "" || x == null);
    //                                var elseParticipantCount = procOfficerList.Where(x => x.ToLower() != a.ToLower()).Count();
    //                                if (elseParticipantCount < 1)
    //                                {
    //                                    if (a.ToLower() == prLeadUserIdOne.ToLower())
    //                                    {
    //                                        part.UserId = a;
    //                                        part.Substitute = prLeadUserIdTwo;
    //                                    }
    //                                    else if (a.ToLower() == prLeadUserIdTwo.ToLower())
    //                                    {
    //                                        part.UserId = a;
    //                                        part.Substitute = prLeadUserIdOne;
    //                                    }
    //                                    else
    //                                    {
    //                                        //var spvData = GetDirectSupervisorByUserId(a);
    //                                        //if (spvData.Rows.Count > 0)
    //                                        //{
    //                                        //    if (!string.IsNullOrEmpty(spvData.Rows[0]["UserId"].ToString()))
    //                                        //    {
    //                                        //        part.UserId = a;
    //                                        //        part.Substitute = spvData.Rows[0]["UserId"].ToString().ToLower();
    //                                        //    }
    //                                        //    else
    //                                        //    {
    //                                        //        part.UserId = a;
    //                                        //    }
    //                                        //}
    //                                        //else
    //                                        //{
    //                                        //    part.UserId = a;
    //                                        //}

    //                                        part.UserId = a;
    //                                    }
    //                                }
    //                                else
    //                                {
    //                                    part.UserId = a;
    //                                }

    //                            }
    //                            else if (actId == 6)
    //                            {
    //                                if (userArr.Count < 2)
    //                                {
    //                                    var spvData = GetDirectSupervisorByUserId(a);
    //                                    if (spvData.Rows.Count > 0)
    //                                    {
    //                                        if (!string.IsNullOrEmpty(spvData.Rows[0]["UserId"].ToString()))
    //                                        {
    //                                            part.UserId = a;
    //                                            part.Substitute = spvData.Rows[0]["UserId"].ToString().ToLower();
    //                                        }
    //                                    }
    //                                }
    //                                else
    //                                {
    //                                    part.UserId = a;
    //                                }
    //                            }
    //                            else if (actId == 7)
    //                            {
    //                                if (userArr.Count < 2)
    //                                {
    //                                    var financeLeadUserList = financeLeadUser.Split(';').ToList();
    //                                    financeLeadUserList.RemoveAll(x => x == "" || x == null);
    //                                    foreach (var u in financeLeadUserList)
    //                                    {
    //                                        part.UserId = u;
    //                                        listOfPart.Add(part);
    //                                    }
    //                                }
    //                                else
    //                                {
    //                                    part.UserId = a;
    //                                }
    //                            }
    //                            else
    //                            {
    //                                part.UserId = a;
    //                            }
    //                        }
    //                        else if (isDg)
    //                        {
    //                            if (isUserIdInvolveInChargeCode)
    //                            {
    //                                if (actId == 3)
    //                                {
    //                                    if (a == DGOUserId)
    //                                    {
    //                                        part.UserId = a;
    //                                        part.Substitute = DGOEUserId;
    //                                    }
    //                                    else if (a == DGOEUserId)
    //                                    {
    //                                        part.UserId = a;
    //                                        part.Substitute = DGOUserId;
    //                                    }
    //                                }
    //                                else
    //                                {
    //                                    part.UserId = a;
    //                                }
    //                            }
    //                            else
    //                            {
    //                                part.UserId = a;
    //                            }
    //                        }
    //                        else if (isDcs)
    //                        {
    //                            if (isUserIdInvolveInChargeCode)
    //                            {
    //                                if (actId == 2)
    //                                {
    //                                    var teamId = DCS;
    //                                    part.UserId = a;
    //                                    part.Substitute = EscalateToHigherLevel(teamId);
    //                                }
    //                                else
    //                                {
    //                                    part.UserId = a;
    //                                }
    //                            }
    //                            else
    //                            {
    //                                part.UserId = a;
    //                            }
    //                        }
    //                        else
    //                        {
    //                            part.UserId = a;
    //                        }

    //                        //if (!listOfPart.Where(x => x.UserId.ToLower().Equals(part.UserId.ToLower())).Any())
    //                        //{
    //                        listOfPart.Add(part);
    //                        Log.Information($"Add list of participant {part.UserId} and substitute : {part.Substitute} and current username : {a}");
    //                        //}
    //                    }
    //                }
    //            }
    //        }

    //        return listOfPart;
    //    }

    //    private bool isUserNamePrincipalInvestigator(string prId, string username)
    //    {
    //        var taData = staticsPurchaseRequisition.Main.GetData(prId).Tables[0];
    //        var PIId = taData.Rows[0]["PI"].ToString();

    //        var res = false;

    //        if (username.ToLower().Contains(PIId.ToLower()))
    //        {
    //            res = true;
    //        }
    //        return res;
    //    }

    //    private static bool isUserNameInitiator(string prId, string username)
    //    {
    //        var taData = staticsPurchaseRequisition.Main.GetData(prId).Tables[0];
    //        var initiator = taData.Rows[0]["created_by"].ToString();

    //        var res = false;

    //        if (username.ToLower().Contains(initiator.ToLower()))
    //        {
    //            res = true;
    //        }
    //        return res;
    //    }

    //    private static bool isUserNameRequestor(string prId, string username)
    //    {
    //        var taData = staticsPurchaseRequisition.Main.GetData(prId).Tables[0];
    //        var requester = taData.Rows[0]["requester"].ToString();

    //        var res = false;

    //        if (username.ToLower().Contains(requester.ToLower()))
    //        {
    //            res = true;
    //        }
    //        return res;
    //    }

    //    public static int GetDataLogNextSeqNo(string id, string module)
    //    {
    //        int nextSeqNo = 0;

    //        database db = new database();

    //        try
    //        {
    //            db.ClearParameters();

    //            db.SPName = "sp_General_GetK2DataLogMaxSeqNo";
    //            db.AddParameter("@RelevantId", SqlDbType.NVarChar, id);
    //            db.AddParameter("@Module", SqlDbType.NVarChar, module);
    //            DataSet ds = db.ExecuteSP();

    //            if (ds.Tables.Count > 0)
    //            {
    //                if (ds.Tables[0].Rows.Count > 0)
    //                {
    //                    nextSeqNo = Convert.ToInt32(ds.Tables[0].Rows[0]["MaxSeqNo"].ToString()) + 1;
    //                }
    //            }

    //        }
    //        catch (Exception x) { throw new Exception(x.Message); }
    //        finally { db.Dispose(); }

    //        return nextSeqNo;
    //    }

    //    public static void ResetApproveStateByRelevantIdModuleAndActivityId(string relevantId, string module, string actId)
    //    {
    //        database db = new database();

    //        try
    //        {
    //            db.ClearParameters();

    //            db.SPName = "sp_General_ResetApproveStateByRelevantIdModuleAndActivityId";
    //            db.AddParameter("@relevantId", SqlDbType.NVarChar, relevantId);
    //            db.AddParameter("@module", SqlDbType.NVarChar, module);
    //            db.AddParameter("@actId", SqlDbType.NVarChar, actId);
    //            DataSet ds = db.ExecuteSP();
    //        }
    //        catch (Exception x)
    //        {
    //            throw new Exception(x.Message);
    //        }
    //        finally
    //        {
    //            db.Dispose();
    //        }
    //    }

    //    public static void InsertListDataLog(List<DataLog> logObj)
    //    {
    //        database db = new database();

    //        try
    //        {
    //            foreach (DataLog obj in logObj)
    //            {
    //                db.ClearParameters();

    //                db.SPName = "sp_General_InsertK2DataLog";
    //                db.AddParameter("@RelevantId", SqlDbType.NVarChar, obj.RelevantId);
    //                db.AddParameter("@Module", SqlDbType.NVarChar, obj.Module);
    //                db.AddParameter("@FieldName", SqlDbType.NVarChar, obj.FieldName);
    //                db.AddParameter("@Value", SqlDbType.NVarChar, obj.Value);
    //                db.AddParameter("@SeqNo", SqlDbType.Int, obj.SeqNo);
    //                DataSet ds = db.ExecuteSP();
    //            }
    //        }
    //        catch (Exception x) { throw new Exception(x.Message); }
    //        finally { db.Dispose(); }
    //    }

    //    public string SaveK2ActUser(string id, List<K2ActivityUser> userListObj, string module = "")
    //    {

    //        var itemToRemove = userListObj.Where(x => x.ActivityID == 0).ToList();
    //        if (itemToRemove != null)
    //        {
    //            if (itemToRemove.Count() > 0)
    //            {
    //                foreach (K2ActivityUser item in itemToRemove)
    //                {
    //                    userListObj.Remove(item);
    //                }
    //            }
    //        }

    //        string seqNo = GetK2UserMaxSeqNo(id, module);

    //        database db = new database();

    //        try
    //        {
    //            foreach (K2ActivityUser obj in userListObj)
    //            {
    //                db.ClearParameters();

    //                db.SPName = "sp_General_InsertK2ActivityUserList";
    //                db.AddParameter("@RelevantId", SqlDbType.NVarChar, id.ToString());
    //                db.AddParameter("@Username", SqlDbType.NVarChar, obj.Username);
    //                db.AddParameter("@ActivityId", SqlDbType.Int, obj.ActivityID);
    //                db.AddParameter("@Module", SqlDbType.NVarChar, module);
    //                db.AddParameter("@SeqNo", SqlDbType.Int, Convert.ToInt32(seqNo) + 1);
    //                DataSet ds = db.ExecuteSP();
    //            }
    //        }
    //        catch (Exception x) { throw new Exception(x.Message); }
    //        finally { db.Dispose(); }

    //        string ret = "";

    //        return ret;
    //    }

    //    public string SaveProcOffFinanceK2ActUser(string id, List<K2ActivityUser> userListObj, string module = "")
    //    {

    //        var itemToRemove = userListObj.Where(x => x.ActivityID == 0).ToList();
    //        if (itemToRemove != null)
    //        {
    //            if (itemToRemove.Count() > 0)
    //            {
    //                foreach (K2ActivityUser item in itemToRemove)
    //                {
    //                    userListObj.Remove(item);
    //                }
    //            }
    //        }

    //        string seqNo = GetK2UserMaxSeqNo(id, module);

    //        database db = new database();

    //        try
    //        {
    //            foreach (K2ActivityUser obj in userListObj)
    //            {
    //                db.ClearParameters();

    //                db.SPName = "sp_General_InsertK2ActivityUserListForProcOffAndFinance";
    //                db.AddParameter("@RelevantId", SqlDbType.NVarChar, id.ToString());
    //                db.AddParameter("@Username", SqlDbType.NVarChar, obj.Username);
    //                db.AddParameter("@ActivityId", SqlDbType.Int, obj.ActivityID);
    //                db.AddParameter("@Module", SqlDbType.NVarChar, module);
    //                db.AddParameter("@SeqNo", SqlDbType.Int, Convert.ToInt32(seqNo));
    //                DataSet ds = db.ExecuteSP();
    //            }
    //        }
    //        catch (Exception x) { throw new Exception(x.Message); }
    //        finally { db.Dispose(); }

    //        string ret = "";

    //        return ret;
    //    }

    //    public string DeleteProcOffK2ActUser(string id, List<K2ActivityUser> userListObj, string module = "", int actId = 0)
    //    {

    //        var itemToRemove = userListObj.Where(x => x.ActivityID == 0).ToList();
    //        if (itemToRemove != null)
    //        {
    //            if (itemToRemove.Count() > 0)
    //            {
    //                foreach (K2ActivityUser item in itemToRemove)
    //                {
    //                    userListObj.Remove(item);
    //                }
    //            }
    //        }

    //        string seqNo = GetK2UserMaxSeqNo(id, module);

    //        database db = new database();

    //        try
    //        {
    //            foreach (K2ActivityUser obj in userListObj)
    //            {
    //                db.ClearParameters();

    //                db.SPName = "sp_General_DeleteAllK2ActivityUserListByRelevantIdUsernameAndActivityId";
    //                db.AddParameter("@RelevantId", SqlDbType.NVarChar, id.ToString());
    //                db.AddParameter("@Username", SqlDbType.NVarChar, obj.Username);
    //                db.AddParameter("@ActivityId", SqlDbType.Int, actId);
    //                db.AddParameter("@Module", SqlDbType.NVarChar, module);
    //                db.AddParameter("@SeqNo", SqlDbType.Int, Convert.ToInt32(seqNo));
    //                DataSet ds = db.ExecuteSP();
    //            }
    //        }
    //        catch (Exception x) { throw new Exception(x.Message); }
    //        finally { db.Dispose(); }

    //        string ret = "";

    //        return ret;
    //    }

    //    public static string GetK2UserMaxSeqNo(string id, string module = "")
    //    {
    //        string stringseqNo = "";
    //        database db = new database();

    //        try
    //        {
    //            db.ClearParameters();

    //            db.SPName = "sp_General_GetK2ActivityUserListMaxSeqNo";
    //            db.AddParameter("@RelevantId", SqlDbType.NVarChar, id.ToString());
    //            db.AddParameter("@Module", SqlDbType.NVarChar, module);
    //            DataSet ds = db.ExecuteSP();

    //            if (ds.Tables.Count > 0)
    //            {
    //                if (ds.Tables[0].Rows.Count > 0)
    //                {
    //                    stringseqNo = ds.Tables[0].Rows[0]["MaxSeqNo"].ToString();
    //                }
    //            }
    //        }
    //        catch (Exception x)
    //        {
    //            throw new Exception(x.Message);
    //        }
    //        finally
    //        {
    //            db.Dispose();
    //        }

    //        return stringseqNo;
    //    }

    //    public static List<ApproveState> GetAllApproverByRelevantId(string PayReqId, string module)
    //    {
    //        List<ApproveState> listofApprover = new List<ApproveState>();

    //        database db = new database();
    //        db.ClearParameters();

    //        db.SPName = "sp_General_GetAllApprover";
    //        db.AddParameter("@RelevantId", SqlDbType.NVarChar, PayReqId);
    //        db.AddParameter("@Module", SqlDbType.NVarChar, module);
    //        DataSet ds = db.ExecuteSP();
    //        db.Dispose();

    //        if (ds.Tables.Count > 0)
    //        {
    //            DataTable PIData = ds.Tables[0];
    //            if (PIData.Rows.Count > 0)
    //            {
    //                foreach (DataRow row in PIData.Rows)
    //                {
    //                    ApproveState apvState = new ApproveState();
    //                    apvState.RelevantId = row["RelevantId"].ToString();
    //                    apvState.Module = row["Module"].ToString();
    //                    apvState.Username = row["Username"].ToString();
    //                    apvState.ActivityId = row["ActivityId"].ToString();
    //                    apvState.State = Convert.ToInt32(row["State"].ToString());

    //                    listofApprover.Add(apvState);
    //                }
    //            }
    //        }

    //        return listofApprover;
    //    }

    //    public static List<ApproveState> GetApprovedUser(string relevantId, string module, string username, string actId, int state)
    //    {
    //        List<ApproveState> listofApprover = new List<ApproveState>();

    //        database db = new database();
    //        db.ClearParameters();

    //        db.SPName = "sp_General_GetApprovedUser";
    //        db.AddParameter("@RelevantId", SqlDbType.NVarChar, relevantId);
    //        db.AddParameter("@Module", SqlDbType.NVarChar, module);
    //        db.AddParameter("@Username", SqlDbType.NVarChar, username);
    //        db.AddParameter("@ActivityId", SqlDbType.NVarChar, actId);
    //        db.AddParameter("@State", SqlDbType.Int, state);
    //        DataSet ds = db.ExecuteSP();
    //        db.Dispose();

    //        if (ds.Tables.Count > 0)
    //        {
    //            DataTable PIData = ds.Tables[0];
    //            if (PIData.Rows.Count > 0)
    //            {
    //                foreach (DataRow row in PIData.Rows)
    //                {
    //                    ApproveState apvState = new ApproveState();
    //                    apvState.RelevantId = row["RelevantId"].ToString();
    //                    apvState.Module = row["Module"].ToString();
    //                    apvState.Username = row["Username"].ToString();
    //                    apvState.ActivityId = row["ActivityId"].ToString();
    //                    apvState.State = Convert.ToInt32(row["State"].ToString());

    //                    listofApprover.Add(apvState);
    //                }
    //            }
    //        }

    //        return listofApprover;
    //    }

    //    public static string GetDatalogMaxSeqNo(string id, string module)
    //    {
    //        string stringseqNo = "";
    //        database db = new database();

    //        try
    //        {
    //            db.ClearParameters();

    //            db.SPName = "sp_General_GetK2DataLogMaxSeqNo";
    //            db.AddParameter("@RelevantId", SqlDbType.NVarChar, id.ToString());
    //            db.AddParameter("@Module", SqlDbType.NVarChar, module);
    //            DataSet ds = db.ExecuteSP();

    //            if (ds.Tables.Count > 0)
    //            {
    //                if (ds.Tables[0].Rows.Count > 0)
    //                {
    //                    stringseqNo = ds.Tables[0].Rows[0]["MaxSeqNo"].ToString();
    //                }
    //            }
    //        }
    //        catch (Exception x)
    //        {
    //            throw new Exception(x.Message);
    //        }
    //        finally
    //        {
    //            db.Dispose();
    //        }

    //        return stringseqNo;
    //    }

    //    public static Dictionary<string, string> GetDatalogBySeqNo(string id, string module, int seqno)
    //    {
    //        database db = new database();
    //        Dictionary<string, string> dict = new Dictionary<string, string>();

    //        try
    //        {
    //            db.ClearParameters();

    //            db.SPName = "sp_General_GetK2DataLogBySeqNo";
    //            db.AddParameter("@RelevantId", SqlDbType.NVarChar, id.ToString());
    //            db.AddParameter("@Module", SqlDbType.NVarChar, module);
    //            db.AddParameter("@SeqNo", SqlDbType.Int, seqno);
    //            DataSet ds = db.ExecuteSP();

    //            if (ds.Tables.Count > 0)
    //            {
    //                if (ds.Tables[0].Rows.Count > 0)
    //                {
    //                    foreach (DataRow row in ds.Tables[0].Rows)
    //                    {
    //                        var fieldname = row["FieldName"].ToString();
    //                        var value = row["Value"].ToString();

    //                        dict.Add(fieldname, value);
    //                    }
    //                }
    //            }
    //        }
    //        catch (Exception x)
    //        {
    //            throw new Exception(x.Message);
    //        }
    //        finally
    //        {
    //            db.Dispose();
    //        }

    //        return dict;
    //    }

    //    public static void UpdateApproveStateWithCustomStateByRelevantId(String Id, int customState)
    //    {
    //        database db = new database();

    //        try
    //        {
    //            db.ClearParameters();

    //            db.SPName = "sp_General_UpdateApproveStateWithCustomStateByRelevantId";
    //            db.AddParameter("@RelevantId", SqlDbType.NVarChar, Id);
    //            db.AddParameter("@CustomState", SqlDbType.Int, customState);
    //            DataSet ds = db.ExecuteSP();
    //        }
    //        catch (Exception x)
    //        {
    //            throw new Exception(x.Message);
    //        }
    //        finally
    //        {
    //            db.Dispose();
    //        }
    //    }

    //    public static void UpdateApproveStateByRelevantIdActivityIdAndListUsername(String Id, int customState, string actId, string module, List<string> userList)
    //    {
    //        foreach (string bh in userList)
    //        {
    //            database db = new database();

    //            try
    //            {
    //                db.ClearParameters();

    //                db.SPName = "sp_General_UpdateApproveStateWithCustomStateByRelevantIdActivityIdAndUsername";
    //                db.AddParameter("@RelevantId", SqlDbType.NVarChar, Id);
    //                db.AddParameter("@ActivityId", SqlDbType.NVarChar, actId);
    //                db.AddParameter("@Module", SqlDbType.NVarChar, module);
    //                db.AddParameter("@CustomState", SqlDbType.Int, customState);
    //                db.AddParameter("@Username", SqlDbType.NVarChar, bh);
    //                DataSet ds = db.ExecuteSP();
    //            }
    //            catch (Exception x)
    //            {
    //                throw new Exception(x.Message);
    //            }
    //            finally
    //            {
    //                db.Dispose();
    //            }
    //        }
    //    }

    //    public static void UpdateApproveStateWithCustomStateByRelevantIdAndActivityId(String Id, string actId, int customState)
    //    {
    //        database db = new database();

    //        try
    //        {
    //            db.ClearParameters();

    //            db.SPName = "sp_General_UpdateApproveStateWithCustomStateByRelevantIdAndActivityId";
    //            db.AddParameter("@RelevantId", SqlDbType.NVarChar, Id);
    //            db.AddParameter("ActivityId", SqlDbType.NVarChar, actId);
    //            db.AddParameter("@CustomState", SqlDbType.Int, customState);
    //            DataSet ds = db.ExecuteSP();
    //        }
    //        catch (Exception x)
    //        {
    //            throw new Exception(x.Message);
    //        }
    //        finally
    //        {
    //            db.Dispose();
    //        }
    //    }

    //    public static void UpdateApproveStateWithCustomStateByRelevantIdAndActivityIdForRedirectScenario(String Id, string actId, int customState)
    //    {
    //        database db = new database();

    //        try
    //        {
    //            db.ClearParameters();

    //            db.SPName = "sp_General_UpdateApproveStateWithCustomStateByRelevantIdAndActivityIdForRedirectScenario";
    //            db.AddParameter("@RelevantId", SqlDbType.NVarChar, Id);
    //            db.AddParameter("ActivityId", SqlDbType.NVarChar, actId);
    //            db.AddParameter("@CustomState", SqlDbType.Int, customState);
    //            DataSet ds = db.ExecuteSP();
    //        }
    //        catch (Exception x)
    //        {
    //            throw new Exception(x.Message);
    //        }
    //        finally
    //        {
    //            db.Dispose();
    //        }
    //    }

    //    public void SaveApproveState(string username, string activityId, string relevantId, string module = "")
    //    {
    //        database db = new database();

    //        try
    //        {
    //            db.ClearParameters();

    //            db.SPName = "sp_General_SavePaymentRequestApproveState";
    //            db.AddParameter("@RelevantId", SqlDbType.NVarChar, relevantId);
    //            db.AddParameter("@Username", SqlDbType.NVarChar, username);
    //            db.AddParameter("@ActivityId", SqlDbType.NVarChar, activityId);
    //            db.AddParameter("@Module", SqlDbType.NVarChar, module);
    //            db.AddParameter("@State", SqlDbType.Int, 1);
    //            DataSet ds = db.ExecuteSP();
    //        }
    //        catch (Exception x)
    //        {
    //            throw new Exception(x.Message);
    //        }
    //        finally
    //        {
    //            db.Dispose();
    //        }
    //    }

    //    public static Dictionary<string, string> GetListOlderDataLog(string Id, string Module)
    //    {
    //        int prevSeqNo = 0;
    //        string maxseqnostr = GetDatalogMaxSeqNo(Id, Module);
    //        prevSeqNo = Convert.ToInt32(maxseqnostr) - 1;

    //        Dictionary<string, string> res = new Dictionary<string, string>();
    //        res = GetDatalogBySeqNo(Id, Module, prevSeqNo);

    //        return res;
    //    }

    //    public static Dictionary<string, string> GetListCurrentDataLog(string Id, string Module)
    //    {
    //        int maxSeqNo = 0;
    //        maxSeqNo = Convert.ToInt32(GetDatalogMaxSeqNo(Id, Module));

    //        Dictionary<string, string> res = new Dictionary<string, string>();
    //        res = GetDatalogBySeqNo(Id, Module, maxSeqNo);

    //        return res;
    //    }

    //    public static void SaveDataLog(List<DataLog> logObj, string module = "")
    //    {
    //        try
    //        {
    //            int seqNo = GetDataLogNextSeqNo(logObj.Select(x => x.RelevantId).FirstOrDefault(), module);
    //            foreach (DataLog log in logObj)
    //            {
    //                log.SeqNo = seqNo;
    //            }

    //            InsertListDataLog(logObj);
    //        }
    //        catch (Exception e)
    //        {
    //            //Log.Error("Error on Save Data //Log for ID: " + logObj[0].RelevantId.ToString() + ". Error Message: " + e.Message.ToString());
    //        }
    //    }

    //    public void UpdateDataLogProperty(string relevantId, string propertyName, string propertyValue, string module = "PurchaseRequisition")
    //    {
    //        try
    //        {
    //            string currentSeqNo = GetDatalogMaxSeqNo(relevantId, module);
    //            database db = new database();
    //            try
    //            {
    //                db.ClearParameters();

    //                db.SPName = "sp_General_UpdateK2DataLogProperty";
    //                db.AddParameter("@RelevantId", SqlDbType.NVarChar, relevantId);
    //                db.AddParameter("@Module", SqlDbType.NVarChar, module);
    //                db.AddParameter("@FieldName", SqlDbType.NVarChar, propertyName);
    //                db.AddParameter("@Value", SqlDbType.NVarChar, propertyValue);
    //                db.AddParameter("@SeqNo", SqlDbType.Int, int.Parse(currentSeqNo));
    //                DataSet ds = db.ExecuteSP();
    //            }
    //            catch (Exception ex)
    //            {
    //                ExceptionHelpers.PrintError(ex);
    //                throw new Exception(ex.Message);
    //            }
    //            finally { db.Dispose(); }
    //        }
    //        catch (Exception ex)
    //        {
    //            ExceptionHelpers.PrintError(ex);
    //        }
    //    }

    //    public static string mapUser(int activityId, List<K2ActivityUser> unApproveUsers)
    //    {
    //        string ret = string.Join(";", unApproveUsers.Where(x => x.ActivityID.Equals(activityId)).Select(x => x.Username).ToArray());
    //        return ret;
    //    }

    //    public bool CompareLog(string Id, bool isReject = false, string[] fieldToCompare = null, string module = "", bool isProcOffChangedDuringResubmit = false)
    //    {
    //        bool res = false;
    //        int differentCount = 0;
    //        List<string> listOfDifferentCostC = new List<string>();
    //        var prData = staticsPurchaseRequisition.Main.GetDataForK2(Id);

    //        if (isReject == false)
    //        {
    //            Dictionary<string, string> oldGrantData = GetListOlderDataLog(Id, module);
    //            Dictionary<string, string> newGrantData = GetListCurrentDataLog(Id, module);

    //            string[] fields = fieldToCompare;

    //            foreach (var oldData in oldGrantData)
    //            {
    //                if (fields.Contains(oldData.Key, StringComparer.OrdinalIgnoreCase)) //diisi array list dari field2 y mau dibandingkan
    //                {
    //                    if (oldData.Value.ToLower() != newGrantData.FirstOrDefault(x => x.Key == oldData.Key).Value.ToLower())
    //                    {
    //                        if (oldData.Key.ToLower().Contains("product".ToLower()))
    //                        {
    //                            string[] separator = { "||" };
    //                            var oldDataArray = oldData.Value.ToString().Split(separator, StringSplitOptions.None);
    //                            var newDataArray = newGrantData.FirstOrDefault(x => x.Key == oldData.Key).Value.ToString().Split(separator, StringSplitOptions.None);

    //                            var diffChargeCodeOnNewData = newDataArray.Except(oldDataArray).ToList();

    //                            if (diffChargeCodeOnNewData.Count() > 0)
    //                            {
    //                                differentCount++;
    //                            }
    //                        }
    //                        else if (oldData.Key.ToLower().Contains("chargecode".ToLower()))
    //                        {
    //                            var oldDataArray = oldData.Value.ToString().Split(';');
    //                            var newDataArray = newGrantData.FirstOrDefault(x => x.Key == oldData.Key).Value.ToString().Split(';');

    //                            var diffChargeCodeData = newDataArray.Except(oldDataArray).ToList();
    //                            foreach (string str in diffChargeCodeData)
    //                            {
    //                                var diffArray = str.Split('|');
    //                                var costCenterId = diffArray[0];

    //                                var costCenterUserId = "";
    //                                var tableEmp = GetCostCenterEmployeeDataByCostCenterId(costCenterId);
    //                                if (tableEmp != null)
    //                                {
    //                                    if (tableEmp.Rows.Count > 0)
    //                                    {
    //                                        if (!string.IsNullOrEmpty(tableEmp.Rows[0]["UserId"].ToString()))
    //                                        {
    //                                            costCenterUserId = tableEmp.Rows[0]["UserId"].ToString().ToLower();

    //                                            //var prData = staticsPurchaseRequisition.Main.GetDataForK2(Id);
    //                                            string prAmount = prData.Rows[0]["pr_amt"]?.ToString();
    //                                            string prType = prData.Rows[0]["pr_type"]?.ToString();

    //                                            string DGO = statics.GetSetting("DirectorGeneralTeamId");
    //                                            string DGOE = statics.GetSetting("DirectorGeneralExecutiveTeamId");
    //                                            string DCS = statics.GetSetting("DirectorCorporateServiceTeamId");
    //                                            //var DGOUserId = "RNASI".ToLower(); // GetTeamLeaderEmployeeDataByTeamId(DGO).Rows[0]["UserId"].ToString().ToLower();
    //                                            //var DGOEUserId = "RPRABHU".ToLower(); // GetTeamLeaderEmployeeDataByTeamId(DGOE).Rows[0]["UserId"].ToString().ToLower();
    //                                            var DGOUserId = GetTeamByTeamId(DGO).Rows[0]["TeamLeaderUserId"].ToString().ToLower();
    //                                            var DGOEUserId = GetTeamByTeamId(DGOE).Rows[0]["TeamLeaderUserId"].ToString().ToLower();
    //                                            bool isInitiator = isUserNameInitiator(Id, costCenterUserId);
    //                                            bool isRequestor = isUserNameRequestor(Id, costCenterUserId);
    //                                            string[] noNeedJustification = { "3" };
    //                                            bool isDgInvolveInWF = false;
    //                                            bool isDcsInvolveInWF = false;
    //                                            bool isDg = CheckIsUsernameATeamLead(costCenterUserId, DGO);
    //                                            bool isDcs = CheckIsUsernameATeamLead(costCenterUserId, DCS);

    //                                            if (!noNeedJustification.Contains(prType))
    //                                            {
    //                                                if (Convert.ToDecimal(prAmount) > 500)
    //                                                {
    //                                                    if (Convert.ToDecimal(prAmount) > 80000)
    //                                                    {
    //                                                        isDgInvolveInWF = true;
    //                                                    }
    //                                                    else
    //                                                    {
    //                                                        isDcsInvolveInWF = true;
    //                                                    }
    //                                                }
    //                                            }

    //                                            if (isInitiator || isRequestor)
    //                                            {
    //                                                if (isDg)
    //                                                {
    //                                                    if (costCenterUserId.ToLower() == DGOUserId.ToLower())
    //                                                    {
    //                                                        costCenterUserId = DGOEUserId;
    //                                                    }
    //                                                    else if (costCenterUserId.ToLower() == DGOEUserId.ToLower())
    //                                                    {
    //                                                        costCenterUserId = DGOUserId;
    //                                                    }
    //                                                }
    //                                                else if (isDcs)
    //                                                {
    //                                                    costCenterUserId = EscalateToHigherLevel(DCS);
    //                                                }
    //                                                else
    //                                                {
    //                                                    var spvData = GetDirectSupervisorByUserId(costCenterUserId);
    //                                                    if (spvData != null)
    //                                                    {
    //                                                        if (spvData.Rows.Count > 0)
    //                                                        {
    //                                                            if (!string.IsNullOrEmpty(spvData.Rows[0]["UserId"].ToString()))
    //                                                            {
    //                                                                costCenterUserId = spvData.Rows[0]["UserId"].ToString().ToLower();
    //                                                            }
    //                                                        }
    //                                                    }
    //                                                }
    //                                            }
    //                                            else if (isDg)
    //                                            {
    //                                                if (isDgInvolveInWF)
    //                                                {
    //                                                    //if (costCenterUserId.ToLower() == DGOUserId.ToLower())
    //                                                    //{
    //                                                    //    costCenterUserId = DGOEUserId;
    //                                                    //}
    //                                                    //else if (costCenterUserId.ToLower() == DGOEUserId.ToLower())
    //                                                    //{
    //                                                    //    costCenterUserId = DGOUserId;
    //                                                    //}
    //                                                }
    //                                            }
    //                                            else if (isDcs)
    //                                            {
    //                                                if (isDcsInvolveInWF)
    //                                                {
    //                                                    //var teamId = DCS;
    //                                                    //costCenterUserId = EscalateToHigherLevel(teamId);
    //                                                }
    //                                            }
    //                                        }
    //                                    }
    //                                }

    //                                if (!listOfDifferentCostC.Where(x => x.ToLower().Contains(costCenterUserId.ToLower())).Any())
    //                                {
    //                                    listOfDifferentCostC.Add(costCenterUserId);
    //                                }
    //                            }
    //                        }
    //                        else if (oldData.Key.ToLower().Contains("ProcurementOffice".ToLower()))
    //                        {
    //                            if (isProcOffChangedDuringResubmit)
    //                            {
    //                                differentCount++;
    //                            }
    //                        }
    //                        else
    //                        {
    //                            differentCount++;
    //                        }
    //                    }
    //                }
    //            }
    //        }

    //        if (isReject == true || differentCount > 0)
    //        {
    //            //Set All Approver State to 0
    //            UpdateApproveStateWithCustomStateByRelevantId(Id, 0);

    //            var prType = prData.Rows[0]["pr_type"]?.ToString();
    //            var parTypeProcurementWF = new string[] { "3" };//Other dan Cash Advance

    //            //blok dibawah adalah untuk menghindari activity diluar rule yg masuk ke WF kembali setelah adanya resubmit dengan reset WF (dari redirect skenario)
    //            //hanya boleh activity2 yang bersangkutan thd PR type saja yang bisa masuk WF setelah reset
    //            if (parTypeProcurementWF.Contains(prType))
    //            {
    //                //type PR WF to Procurement Office
    //                //kembalikan state Activity Finance menjadi 1
    //                //UpdateApproveStateWithCustomStateByRelevantIdAndActivityId(Id, "6", 1);
    //                //UpdateApproveStateWithCustomStateByRelevantIdAndActivityId(Id, "7", 1);
    //                UpdateApproveStateWithCustomStateByRelevantIdAndActivityIdForRedirectScenario(Id, "6", 1);
    //                UpdateApproveStateWithCustomStateByRelevantIdAndActivityIdForRedirectScenario(Id, "7", 1);
    //            }
    //            else
    //            {
    //                //type PR WF to Finance
    //                //kembalikan state Activity Procurement office menjadi 1
    //                //UpdateApproveStateWithCustomStateByRelevantIdAndActivityId(Id, "5", 1);
    //                UpdateApproveStateWithCustomStateByRelevantIdAndActivityIdForRedirectScenario(Id, "5", 1);
    //            }

    //            res = true;
    //        }
    //        else if (listOfDifferentCostC.Count > 0)
    //        {
    //            //UpdateApproverStateForBudgetHolder
    //            UpdateApproveStateByRelevantIdActivityIdAndListUsername(Id, 0, "4", module, listOfDifferentCostC);
    //            UpdateApproveStateByRelevantIdActivityIdAndListUsername(Id, 0, "6", module, listOfDifferentCostC);
    //            res = true;
    //        }

    //        return res;
    //    }

    //    public bool isUserAllowedToAccess(string id, string userid, string processName, string folder, string sn = "")
    //    {
    //        string snFromUrl = sn;
    //        bool res = true;
    //        userid = string.IsNullOrEmpty(userid) ? "--" : userid; // diberi logic ini karena jika mengirim string kosong maka get current activity tetap akan memberi hasil pencarian berdasar dengan id, prcessname dan folder

    //        ApiResponse resCurrentActivity = k2Help.K2GetCurrentActivityByAPI(id, processName, folder, userid);
    //        var listResult = (JArray)resCurrentActivity.Message;
    //        var snList = new List<string>();
    //        if (listResult.Count == 0)
    //        {
    //            res = false;
    //        }
    //        else
    //        {
    //            snList = listResult.Children().Select(x => (string)x["SN"]).ToList();
    //            if (!snList.Contains(snFromUrl))
    //            {
    //                res = false;
    //            }
    //        }

    //        return res;
    //    }

    //    public List<TasklistModel> GetTasks(string id, string userid, string processName, string folder)
    //    {
    //        List<TasklistModel> res = new List<TasklistModel>();

    //        ApiResponse resCurrentActivity = k2Help.K2GetTaskByAPI(id, processName, folder, userid);
    //        var listResult = (JArray)resCurrentActivity.Message;

    //        if (listResult.Count == 0)
    //        {
    //        }
    //        else
    //        {
    //            foreach (JObject obj in listResult.Children())
    //            {
    //                TasklistModel tasklist = new TasklistModel();
    //                //tasklist.Id = obj.Select(x => x["Id"]).ToString();
    //                tasklist.Id = obj["T_ID"].ToString();
    //                tasklist.Username = obj["USER_NAME"].ToString();
    //                tasklist.TaskName = obj["NAME"].ToString();
    //                tasklist.Url = obj["URL"].ToString();
    //                tasklist.UrlDetail = obj["URL_DETAILS"].ToString();
    //                tasklist.ActivityName = obj["STATUS"].ToString();
    //                tasklist.ActivityId = obj["ACTIVITY_ID"].ToString();
    //                tasklist.SN = obj["SN"].ToString();

    //                res.Add(tasklist);
    //            }
    //        }

    //        return res;
    //    }

    //    public List<TasklistModel> GetCurrentActivity(string id, string userid, string processName, string folder)
    //    {
    //        List<TasklistModel> res = new List<TasklistModel>();

    //        ApiResponse resCurrentActivity = k2Help.K2GetCurrentActivityByAPI(id, processName, folder, userid);
    //        var listResult = (JArray)resCurrentActivity.Message;

    //        if (listResult.Count > 0)
    //        {
    //            foreach (var obj in listResult.Children())
    //            {
    //                TasklistModel tasklist = new TasklistModel();
    //                tasklist.Id = obj["RelevantID"].ToString();
    //                tasklist.Username = obj["ActivityUser"].ToString();
    //                tasklist.TaskName = "";
    //                tasklist.Url = obj["URL"].ToString();
    //                tasklist.UrlDetail = obj["URLDetail"].ToString();
    //                tasklist.ActivityName = obj["ActivityName"].ToString();
    //                tasklist.ActivityId = obj["ActivityDesc"].ToString();
    //                tasklist.SN = obj["SN"].ToString();
    //                tasklist.DueDate = obj["DueDate"].ToString();

    //                res.Add(tasklist);
    //            }
    //        }

    //        return res;
    //    }

    //    public static DataTable GetTeamByTeamId(string teamId)
    //    {
    //        DataTable PIData = new DataTable();

    //        database db = new database();
    //        db.ClearParameters();

    //        db.SPName = "sp_General_GetTeamLeaderByTeamId";
    //        db.AddParameter("@TeamId", SqlDbType.NVarChar, teamId);
    //        DataSet ds = db.ExecuteSP();
    //        db.Dispose();

    //        if (ds.Tables.Count > 0)
    //        {
    //            PIData = ds.Tables[0];
    //        }

    //        return PIData;
    //    }

    //    public static DataTable GetPRLeadByCode(string code)
    //    {
    //        DataTable PIData = new DataTable();

    //        database db = new database();
    //        db.ClearParameters();

    //        db.SPName = "sp_General_GetPRLeadByCode";
    //        db.AddParameter("@Code", SqlDbType.NVarChar, code);
    //        DataSet ds = db.ExecuteSP();
    //        db.Dispose();

    //        if (ds.Tables.Count > 0)
    //        {
    //            PIData = ds.Tables[0];
    //        }

    //        return PIData;
    //    }

    //    public static string GetProcurementOfficerByProcurementOfficeId(string procOffId)
    //    {
    //        string user = "";

    //        database db = new database();
    //        db.ClearParameters();

    //        db.SPName = "sp_General_GetProcurementOfficerUserByProcurementOfficeId";
    //        db.AddParameter("@ProcOfficeId", SqlDbType.NVarChar, procOffId);
    //        DataSet ds = db.ExecuteSP();
    //        db.Dispose();

    //        if (ds.Tables.Count > 0)
    //        {
    //            user = ds.Tables[0].Rows[0]["procOffUser"].ToString();
    //        }

    //        return user;
    //    }

    //    public static string GetStringProcurementOfficeRegionByProcurementOfficeId(string procOffId)
    //    {
    //        string user = "";

    //        database db = new database();
    //        db.ClearParameters();

    //        db.SPName = "sp_General_GetStringProcurementOfficeRegionByProcurementOfficeId";
    //        db.AddParameter("@ProcOfficeId", SqlDbType.NVarChar, procOffId);
    //        DataSet ds = db.ExecuteSP();
    //        db.Dispose();

    //        if (ds.Tables.Count > 0)
    //        {
    //            user = ds.Tables[0].Rows[0]["name"].ToString();
    //        }

    //        return user;
    //    }

    //    public static DataTable GetProcurementOfficeByProcurementOfficeId(string procOffId)
    //    {
    //        DataTable ret = new DataTable();
    //        database db = new database();
    //        db.ClearParameters();

    //        db.SPName = "sp_general_GetProcurementOfficeByOfficeId";
    //        db.AddParameter("@ProcOfficeId", SqlDbType.NVarChar, procOffId);
    //        DataSet ds = db.ExecuteSP();
    //        db.Dispose();

    //        if (ds.Tables.Count > 0)
    //        {
    //            ret = ds.Tables[0];
    //        }

    //        return ret;
    //    }

    //    public static DataTable GetTeamLeaderEmployeeDataByTeamId(string teamId)
    //    {
    //        DataTable PIData = new DataTable();

    //        database db = new database();
    //        db.ClearParameters();

    //        db.SPName = "sp_General_GetTeamLeaderEmployeeDataByTeamId";
    //        db.AddParameter("@TeamId", SqlDbType.NVarChar, teamId);
    //        DataSet ds = db.ExecuteSP();
    //        db.Dispose();

    //        if (ds.Tables.Count > 0)
    //        {
    //            PIData = ds.Tables[0];
    //        }

    //        return PIData;
    //    }

    //    public static DataTable GetDirectSupervisorByUserId(string UserId)
    //    {
    //        DataTable spvData = new DataTable();

    //        database db = new database();
    //        db.ClearParameters();

    //        db.SPName = "sp_General_GetDirectSupervisorByUserId";
    //        db.AddParameter("@UserId", SqlDbType.NVarChar, UserId);
    //        DataSet ds = db.ExecuteSP();
    //        db.Dispose();

    //        if (ds.Tables.Count > 0)
    //        {
    //            spvData = ds.Tables[0];
    //        }

    //        return spvData;
    //    }

    //    public static bool CheckIsUsernameATeamLead(string UserId, string teamId)
    //    {
    //        DataTable spvData = new DataTable();
    //        bool res = false;

    //        database db = new database();
    //        db.ClearParameters();

    //        db.SPName = "sp_General_CheckIsUsernameATeamLead";
    //        db.AddParameter("@UserId", SqlDbType.NVarChar, UserId);
    //        db.AddParameter("@TeamId", SqlDbType.NVarChar, teamId);
    //        DataSet ds = db.ExecuteSP();
    //        db.Dispose();

    //        if (ds.Tables.Count > 0)
    //        {
    //            if (ds.Tables[0].Rows.Count > 0)
    //            {
    //                if (!string.IsNullOrEmpty(ds.Tables[0].Rows[0]["status"].ToString()))
    //                {
    //                    res = ds.Tables[0].Rows[0]["status"].ToString() == "1";
    //                }
    //            }
    //        }

    //        return res;
    //    }

    //    public static DataTable CheckFinanceInCurrentSequence(string PrId)
    //    {
    //        DataTable finData = new DataTable();

    //        database db = new database();
    //        db.ClearParameters();

    //        db.SPName = "sp_General_CheckPRFinanceActivityInCurrentSequenceByRelevantId";
    //        db.AddParameter("@relevantId", SqlDbType.NVarChar, PrId);
    //        DataSet ds = db.ExecuteSP();
    //        db.Dispose();

    //        if (ds.Tables.Count > 0)
    //        {
    //            finData = ds.Tables[0];
    //        }

    //        return finData;
    //    }

    //    public static DataTable CheckProcurementOfficeUserInCurrentSequence(string PrId)
    //    {
    //        DataTable finData = new DataTable();

    //        database db = new database();
    //        db.ClearParameters();

    //        db.SPName = "sp_General_CheckPRProcurementOfficeActivityInCurrentSequenceByRelevantId";
    //        db.AddParameter("@relevantId", SqlDbType.NVarChar, PrId);
    //        DataSet ds = db.ExecuteSP();
    //        db.Dispose();

    //        if (ds.Tables.Count > 0)
    //        {
    //            finData = ds.Tables[0];
    //        }

    //        return finData;
    //    }

    //    public static DataTable CheckPRLastVerif(string PrId)
    //    {
    //        DataTable commentsData = new DataTable();

    //        database db = new database();
    //        db.ClearParameters();

    //        db.SPName = "spPurchaseRequisition_CheckLastVerif";
    //        db.AddParameter("@id", SqlDbType.NVarChar, PrId);
    //        DataSet ds = db.ExecuteSP();
    //        db.Dispose();

    //        if (ds.Tables.Count > 0)
    //        {
    //            commentsData = ds.Tables[0];
    //        }

    //        return commentsData;
    //    }

    //    public static bool CheckIsHaveRevisionTask(string PrId)
    //    {
    //        bool res = false;

    //        database db = new database();
    //        db.ClearParameters();

    //        db.SPName = "spPurchaseRequisition_CheckIsHaveRevisionTask";
    //        db.AddParameter("@id", SqlDbType.NVarChar, PrId);
    //        DataSet ds = db.ExecuteSP();
    //        db.Dispose();

    //        if (ds.Tables.Count > 0)
    //        {
    //            res = ds.Tables[0].Rows[0]["is_have_revision_task"].ToString().ToLower() == "true" ? true : false;
    //        }

    //        return res;
    //    }

    //    public static DataTable GetTeamByTeamLeaderUserId(string teamLeaderUserId)
    //    {
    //        DataTable PIData = new DataTable();

    //        database db = new database();
    //        db.ClearParameters();

    //        db.SPName = "sp_General_GetTeamByTeamLeaderUserId";
    //        db.AddParameter("@TeamLeaderUserId", SqlDbType.NVarChar, teamLeaderUserId);
    //        DataSet ds = db.ExecuteSP();
    //        db.Dispose();

    //        if (ds.Tables.Count > 0)
    //        {
    //            PIData = ds.Tables[0];
    //        }

    //        return PIData;

    //    }

    //    public static string GetEmployeeNameByUserId(string userid)
    //    {
    //        string PIName = "";

    //        database db = new database();
    //        db.ClearParameters();

    //        db.SPName = "sp_General_GetEmployeeByUserId";
    //        db.AddParameter("@UserId", SqlDbType.NVarChar, userid);
    //        DataSet ds = db.ExecuteSP();
    //        db.Dispose();

    //        if (ds.Tables.Count > 0)
    //        {
    //            DataTable PIData = ds.Tables[0];
    //            if (PIData.Rows.Count > 0)
    //            {
    //                //if (!string.IsNullOrEmpty(PIData.Rows[0]["FullName"].ToString()))
    //                //{
    //                //    PIName = PIData.Rows[0]["FullName"].ToString();
    //                //}
    //                //testinglokal
    //                if (!string.IsNullOrEmpty(PIData.Rows[0]["first_name"].ToString()))
    //                {
    //                    PIName = PIData.Rows[0]["first_name"].ToString() + " " + PIData.Rows[0]["middle_name"].ToString() + " " + PIData.Rows[0]["last_name"].ToString();
    //                }
    //            }
    //        }

    //        return PIName;
    //    }

    //    public static DataTable GetCostCenterEmployeeDataByCostCenterId(string costcenterId)
    //    {
    //        DataTable cosCEmp = new DataTable();

    //        database db = new database();
    //        db.ClearParameters();

    //        db.SPName = "sp_General_GetCostCenterEmployeeDataByCostCenterId";
    //        db.AddParameter("@CostCenterId", SqlDbType.NVarChar, costcenterId);
    //        DataSet ds = db.ExecuteSP();
    //        db.Dispose();

    //        if (ds.Tables.Count > 0)
    //        {
    //            cosCEmp = ds.Tables[0];
    //        }

    //        return cosCEmp;
    //    }

    //    public static string GetEmployeeNameByEmployeeId(string empId)
    //    {
    //        string PIName = "";

    //        database db = new database();
    //        db.ClearParameters();

    //        db.SPName = "sp_General_GetEmployeeByEmployeeId";
    //        db.AddParameter("@EmployeeId", SqlDbType.NVarChar, empId);
    //        DataSet ds = db.ExecuteSP();
    //        db.Dispose();

    //        if (ds.Tables.Count > 0)
    //        {
    //            DataTable PIData = ds.Tables[0];
    //            if (PIData.Rows.Count > 0)
    //            {
    //                if (!string.IsNullOrEmpty(PIData.Rows[0]["FullName"].ToString()))
    //                {
    //                    PIName = PIData.Rows[0]["FullName"].ToString();
    //                }
    //            }
    //        }

    //        return PIName;
    //    }

    //    public static string GetLatestPRTypeById(string Id)
    //    {
    //        string PIName = "";

    //        database db = new database();
    //        db.ClearParameters();

    //        db.SPName = "SP_General_GetLatestPRTypeFromK2DataLog";
    //        db.AddParameter("@id", SqlDbType.NVarChar, Id);
    //        DataSet ds = db.ExecuteSP();
    //        db.Dispose();

    //        if (ds.Tables.Count > 0)
    //        {
    //            DataTable PIData = ds.Tables[0];
    //            if (PIData.Rows.Count > 0)
    //            {
    //                if (!string.IsNullOrEmpty(PIData.Rows[0]["Value"].ToString()))
    //                {
    //                    PIName = PIData.Rows[0]["Value"].ToString();
    //                }
    //            }
    //        }

    //        return PIName;
    //    }

    //    public static List<int> GetAllInvolvingActivityId(string Id, string folder, string processName)
    //    {
    //        List<int> listActId = new List<int>();

    //        database db = new database();
    //        db.ClearParameters();

    //        db.SPName = "sp_General_GetAllInvolvingActivityId";
    //        db.AddParameter("@folder", SqlDbType.NVarChar, folder);
    //        db.AddParameter("@processName", SqlDbType.NVarChar, processName);
    //        db.AddParameter("@relevantId", SqlDbType.NVarChar, Id);
    //        DataSet ds = db.ExecuteSP();
    //        db.Dispose();

    //        if (ds.Tables.Count > 0)
    //        {
    //            DataTable PIData = ds.Tables[0];
    //            if (PIData.Rows.Count > 0)
    //            {
    //                foreach (DataRow dr in PIData.Rows)
    //                {
    //                    //activity_id
    //                    if (!string.IsNullOrEmpty(dr["activity_id"].ToString()))
    //                    {
    //                        listActId.Add(Convert.ToInt32(dr["activity_id"].ToString()));
    //                    }
    //                }
    //            }
    //        }

    //        listActId = listActId.OrderBy(x => x).ToList();

    //        return listActId;
    //    }

    //    public static bool CheckIsLastBudgetHolder(string prId)
    //    {
    //        bool res = false;
    //        database db = new database();

    //        try
    //        {
    //            db.ClearParameters();

    //            db.SPName = "sp_General_CheckPRBudgetHolderIsLastBudgetHolder";
    //            db.AddParameter("@prId", SqlDbType.NVarChar, prId);
    //            DataSet ds = db.ExecuteSP();

    //            if (ds.Tables.Count > 0)
    //            {
    //                if (ds.Tables[0].Rows.Count > 0)
    //                {
    //                    if (!string.IsNullOrEmpty(ds.Tables[0].Rows[0]["isLastBh"].ToString()))
    //                    {
    //                        res = ds.Tables[0].Rows[0]["isLastBh"].ToString().ToLower() == "true";
    //                    }
    //                }
    //            }

    //        }
    //        catch (Exception x) { throw new Exception(x.Message); }
    //        finally { db.Dispose(); }

    //        return res;
    //    }

    //    public static string EscalateToHigherLevel(string TeamId)
    //    {
    //        string higherOrdinat = "";
    //        string DGO = statics.GetSetting("DirectorGeneralTeamId");
    //        string DGOE = statics.GetSetting("DirectorGeneralExecutiveTeamId");
    //        DataTable currentTeam = GetTeamByTeamId(TeamId);
    //        if (currentTeam.Rows.Count > 0)
    //        {
    //            if (TeamId.ToUpper() == DGO.ToUpper())
    //            {
    //                DataTable higherTeam = GetTeamByTeamId(DGOE.ToUpper());
    //                if (higherTeam.Rows.Count > 0)
    //                {
    //                    higherOrdinat = higherTeam.Rows[0]["TeamLeaderUserId"].ToString();
    //                }
    //            }
    //            else
    //            {
    //                string parentTeamId = currentTeam.Rows[0]["ParentTeamId"].ToString();
    //                DataTable higherTeam = GetTeamByTeamId(parentTeamId);
    //                if (higherTeam.Rows.Count > 0)
    //                {
    //                    higherOrdinat = higherTeam.Rows[0]["TeamLeaderUserId"].ToString();
    //                }
    //            }
    //        }

    //        return higherOrdinat;
    //    }

    //    public static string EscalateToHigherLevelByUsername(string username)
    //    {
    //        string higherOrdinat = "";
    //        string DGO = statics.GetSetting("DirectorGeneralTeamId");
    //        string DGOE = statics.GetSetting("DirectorGeneralExecutiveTeamId");
    //        DataTable currentTeam = GetTeamByTeamLeaderUserId(username);
    //        if (currentTeam.Rows.Count > 0)
    //        {
    //            if (currentTeam.Rows[0]["TeamId"].ToString().ToUpper() == DGO.ToUpper())
    //            {
    //                DataTable higherTeam = GetTeamByTeamId(DGOE.ToUpper());
    //                if (higherTeam.Rows.Count > 0)
    //                {
    //                    higherOrdinat = higherTeam.Rows[0]["TeamLeaderUserId"].ToString();
    //                }
    //            }
    //            else
    //            {
    //                string parentTeamId = currentTeam.Rows[0]["ParentTeamId"].ToString();
    //                DataTable higherTeam = GetTeamByTeamId(parentTeamId);
    //                if (higherTeam.Rows.Count > 0)
    //                {
    //                    higherOrdinat = higherTeam.Rows[0]["TeamLeaderUserId"].ToString();
    //                }
    //            }
    //        }

    //        return higherOrdinat;
    //    }

    //    public static string EscalateToHigherLevelByTeamLeaderUserId(string TeamLeaderUserId)
    //    {
    //        string higherOrdinat = "";
    //        string DGO = statics.GetSetting("DirectorGeneralTeamId");
    //        string DGOE = statics.GetSetting("DirectorGeneralExecutiveTeamId");
    //        DataTable currentTeam = GetTeamByTeamLeaderUserId(TeamLeaderUserId);
    //        if (currentTeam.Rows.Count > 0)
    //        {
    //            string TeamId = currentTeam.Rows[0]["TeamId"].ToString();
    //            if (TeamId.ToUpper() == DGO.ToUpper())
    //            {
    //                DataTable higherTeam = GetTeamByTeamId(DGOE.ToUpper());
    //                if (higherTeam.Rows.Count > 0)
    //                {
    //                    higherOrdinat = higherTeam.Rows[0]["TeamLeaderUserId"].ToString();
    //                }
    //            }
    //            else
    //            {
    //                string parentTeamId = currentTeam.Rows[0]["ParentTeamId"].ToString();
    //                DataTable higherTeam = GetTeamByTeamId(parentTeamId);
    //                if (higherTeam.Rows.Count > 0)
    //                {
    //                    higherOrdinat = higherTeam.Rows[0]["TeamLeaderUserId"].ToString();
    //                }
    //            }
    //        }

    //        return higherOrdinat;
    //    }

    //    public static DataTable GetChargeCodeDetailbyIdAndBhUsername(string prId, string bhUserid)
    //    {
    //        DataTable PIData = new DataTable();

    //        database db = new database();
    //        db.ClearParameters();

    //        db.SPName = "sp_General_GetChargeCodeDetailbyIdAndBhUsername";
    //        db.AddParameter("@prId", SqlDbType.NVarChar, prId);
    //        db.AddParameter("@bhUserId", SqlDbType.NVarChar, bhUserid);
    //        DataSet ds = db.ExecuteSP();
    //        db.Dispose();

    //        if (ds.Tables.Count > 0)
    //        {
    //            PIData = ds.Tables[0];
    //        }

    //        return PIData;
    //    }

    //    public static ApprovalNotes GetPRApvNotes(int activityId, string username, string prId)
    //    {
    //        ApprovalNotes actObj = new ApprovalNotes();

    //        List<int> listActId = new List<int>();
    //        List<string> listStringActivity = new List<string>();
    //        List<string> listStringRole = new List<string>();
    //        string trueBudgetHolder = "";
    //        string _actDesc = "-";
    //        string _actName = "-";
    //        string procOfficeName = "";
    //        string prType = "";
    //        string action = "";
    //        string submissionPageType = "";
    //        bool isReAction = false;

    //        List<ApproveState> aps = GetApprovedUser(prId, "PurchaseRequisition", username, activityId.ToString(), 0); //ApprovedUser but need to reApprove
    //        if (aps.Count > 0)
    //        {
    //            isReAction = true;
    //        }

    //        if (isReAction)
    //        {
    //            action = "re-";
    //        }

    //        int[] actVerify = new int[] { 5, 6 };
    //        int[] actApprove = new int[] { 2, 3, 4, 7 };

    //        if (actVerify.Contains(activityId))
    //        {
    //            action += "verifying";
    //        }
    //        else if (actApprove.Contains(activityId))
    //        {
    //            action += "approving";
    //        }

    //        if (activityId == 1)
    //        {
    //            _actDesc = "You are ";
    //        }
    //        else
    //        {
    //            _actDesc = "You are " + action + " this request for ";
    //        }

    //        _actDesc += "<ul>";

    //        DataTable taData = staticsPurchaseRequisition.Main.GetDataForK2(prId);
    //        if (taData != null)
    //        {
    //            if (taData.Rows.Count > 0)
    //            {
    //                if (!string.IsNullOrEmpty(taData.Rows[0]["procurement_office_name"].ToString()))
    //                {
    //                    procOfficeName = taData.Rows[0]["procurement_office_name"].ToString();
    //                }

    //                if (!string.IsNullOrEmpty(taData.Rows[0]["pr_type"].ToString()))
    //                {
    //                    prType = taData.Rows[0]["pr_type"].ToString();
    //                }

    //                if (!string.IsNullOrEmpty(taData.Rows[0]["submission_page_type"].ToString()))
    //                {
    //                    submissionPageType = taData.Rows[0]["submission_page_type"].ToString();
    //                }
    //            }
    //        }

    //        // Get PR amount
    //        double threshold = 0.0;
    //        double.TryParse(taData.Rows[0]["pr_amt"].ToString(), out threshold);

    //        var thresholdWording = "";
    //        if (submissionPageType == "2")
    //        {
    //            thresholdWording = "for total amount Request for Payment ";

    //        }

    //        if (Convert.ToDecimal(threshold) > 500) // Minimum Justification
    //        {
    //            if (Convert.ToDecimal(threshold) > 80000) // Threshold to DG
    //            {
    //                thresholdWording += "> USD 80,000";
    //            }
    //            else // Threshold check
    //            {
    //                if (Convert.ToDecimal(threshold) <= 5000)
    //                {
    //                    // Go to Finance Lead
    //                    thresholdWording += "> USD 500 and <= USD 5,000";
    //                }
    //                else if (Convert.ToDecimal(threshold) > 5000 && Convert.ToDecimal(threshold) <= 35000)
    //                {
    //                    // Go to Country/Head Unit
    //                    thresholdWording += "> USD 5,000 and <= USD 35,000";
    //                }
    //                else if (Convert.ToDecimal(threshold) > 35000 && Convert.ToDecimal(threshold) <= 50000)
    //                {
    //                    // Go to CFOO
    //                    thresholdWording += "> USD 35,000 and <= USD 50,000";
    //                }
    //                else if (Convert.ToDecimal(threshold) > 50000 && Convert.ToDecimal(threshold) <= 80000)
    //                {
    //                    // Go to DCS
    //                    thresholdWording += "> USD 50,000 and <= USD 80,000";
    //                }
    //            }
    //        }


    //        //List<K2ActivityUser> allActivityUser = GetPRAllActivityUser(taData);
    //        List<K2ActivityUserMapping> allActivityUserMapped = GetPRAllActivityUserWithSubstitute(taData);

    //        //foreach (K2ActivityUser user in allActivityUser)
    //        //{
    //        //    if (user.Username.ToLower() == username.ToLower())
    //        //    {
    //        //        listActId.Add(user.ActivityID);
    //        //    }
    //        //}

    //        Log.Information("Start Apv Notes. Id: " + prId);
    //        foreach (K2ActivityUserMapping user in allActivityUserMapped)
    //        {
    //            Log.Information($"UserId : {user.Username}, ActivityId : {user.ActivityId} Subtitute : {user.Substitute} Username : {username}");
    //            if (!string.IsNullOrEmpty(user.Substitute))
    //            {
    //                if (user.Substitute.ToLower() == username.ToLower())
    //                {
    //                    listActId.Add(user.ActivityId);
    //                }
    //            }
    //            else if (!string.IsNullOrEmpty(user.Username))
    //            {
    //                if (user.Username.ToLower() == username.ToLower())
    //                {
    //                    listActId.Add(user.ActivityId);
    //                }
    //            }
    //        }

    //        if (listActId.Count > 0)
    //        {
    //            listActId.RemoveAll(item => item == 0);
    //            if (activityId != 1)
    //            {
    //                listActId.RemoveAll(item => item == 1);
    //            }

    //            if (activityId == 4 && submissionPageType != "2")
    //            {
    //                listActId.RemoveAll(item => item < activityId);
    //            }

    //            string[] noNeedFinanceAct = { "6", "5", "3" };
    //            if (activityId == 6)
    //            {
    //                listActId.RemoveAll(item => item == 4);
    //            }

    //            if (activityId == 7)
    //            {
    //                listActId.RemoveAll(item => item == 5);
    //            }

    //            listActId.RemoveAll(item => item > activityId);

    //            listActId.Reverse();
    //            listActId = listActId.Select(x => x).Distinct().ToList();

    //            Log.Information("List Activity Id to be build in Apv Notes: ");
    //            foreach (int actId in listActId)
    //            {
    //                Log.Information(actId.ToString());
    //            }

    //            string teamLeaderId = taData.Rows[0]["leading_thematic_unit"].ToString();
    //            DataTable teamLeader = GetTeamByTeamId(teamLeaderId);
    //            string team = "-";
    //            string teamId = "-";
    //            if (teamLeader.Rows.Count > 0)
    //            {
    //                foreach (DataRow row in teamLeader.Rows)
    //                {
    //                    if (!string.IsNullOrEmpty(row["Name"].ToString()))
    //                    {
    //                        team = row["Name"].ToString();
    //                    }

    //                    if (!string.IsNullOrEmpty(row["TeamId"].ToString()))
    //                    {
    //                        teamId = row["TeamId"].ToString();
    //                    }
    //                }
    //            }

    //            var wordingForProcOffice = "Procurement Office " + procOfficeName;
    //            var wordingForBudgetHolder = "";
    //            if (listActId.Contains(4))
    //            {
    //                trueBudgetHolder = username.ToLower();

    //                if (allActivityUserMapped.Where(c => c.ActivityId == 4 && c.Substitute.ToLower() == username.ToLower()).Select(c => c.Username).Any())
    //                {
    //                    trueBudgetHolder = allActivityUserMapped.Where(c => c.ActivityId == 4 && c.Substitute.ToLower() == username.ToLower()).FirstOrDefault().Username.ToLower();
    //                }

    //                var cc = GetChargeCodeDetailbyIdAndBhUsername(prId, trueBudgetHolder);

    //                if (cc != null)
    //                {
    //                    if (cc.Rows.Count > 0)
    //                    {
    //                        if (!string.IsNullOrEmpty(cc.Rows[0]["descr"].ToString()))
    //                        {
    //                            var bhData = cc.Rows[0]["descr"].ToString().Split(';');
    //                            foreach (string a in bhData)
    //                            {
    //                                wordingForBudgetHolder += "<li>Budget holder of ";
    //                                wordingForBudgetHolder += a;
    //                                wordingForBudgetHolder += "</li>";
    //                            }
    //                        }
    //                    }
    //                }
    //            }



    //            Dictionary<int, string> dictOfActivity = new Dictionary<int, string>
    //                {
    //                    {1, "Submission/Resubmission" },
    //                    {2, $"Justification {thresholdWording}" },
    //                    {3, $"Justification {thresholdWording}" },
    //                    {4, wordingForBudgetHolder },
    //                    {5, wordingForProcOffice },
    //                    {6, "Team Leader, Finance or Chief Finance Officer" },
    //                    {7, "Payment Process" },
    //                };

    //            Dictionary<int, string> dictOfRole = new Dictionary<int, string>
    //                {
    //                    {1, "Initiator" },
    //                    {2, $"Justification Approval" },
    //                    {3, $"Justification Approval" },
    //                    {4, "Budget Holder Approval" },
    //                    {5, "Procurement Office Verification" },
    //                    {6, "Team Leader, Finance or Chief Finance Officer Verification" },
    //                    {7, "Payment Process By Finance" },
    //                };

    //            foreach (int i in listActId)
    //            {
    //                string act = dictOfActivity.Where(dActId => dActId.Key == i).Select(dActId => dActId.Value).FirstOrDefault();
    //                string role = dictOfRole.Where(dRole => dRole.Key == i).Select(dRole => dRole.Value).FirstOrDefault();

    //                if (!string.IsNullOrEmpty(act))
    //                {
    //                    listStringActivity.Add(act);
    //                }

    //                if (!string.IsNullOrEmpty(role))
    //                {
    //                    listStringRole.Add(role);
    //                }
    //            }

    //            Log.Information("Pass through all Apv Notes Builder. Id: " + prId);
    //            var maxDataLogNextSeqNo = GetDataLogNextSeqNo(prId, "PurchaseRequisition");
    //            var maxSeqNoDataLog = maxDataLogNextSeqNo < 1 ? maxDataLogNextSeqNo : maxDataLogNextSeqNo - 1;

    //            if (isReAction && maxSeqNoDataLog > 1)
    //            {
    //                Log.Information("Start Apv Notes Wording for re-action. Id: " + prId);
    //                string[] separator = { "||" };

    //                #region Penambahan Wording Apv Notes Untuk Resubmission dan Jika ada perubahan data
    //                Dictionary<string, string> oldGrantData = GetListOlderDataLog(prId, "PurchaseRequisition");
    //                Dictionary<string, string> newGrantData = GetListCurrentDataLog(prId, "PurchaseRequisition");
    //                List<DifferentData> listDiff = new List<DifferentData>();

    //                var oldprodDesc = oldGrantData.Where(x => x.Key.ToLower() == "ProductDescription".ToLower()).Select(y => y.Value).FirstOrDefault().ToString();
    //                var oldProdDescArray = oldprodDesc.Split(separator, StringSplitOptions.None);
    //                Log.Information("Get old prod desc done. Id: " + prId);

    //                var newprodDesc = newGrantData.Where(x => x.Key.ToLower() == "ProductDescription".ToLower()).Select(y => y.Value).FirstOrDefault().ToString();
    //                var newProdDescArray = newprodDesc.Split(separator, StringSplitOptions.None);
    //                Log.Information("Get new prod desc done. Id: " + prId);

    //                List<PurchaseRequisitionProductObject> oldProdDescList = new List<PurchaseRequisitionProductObject>();
    //                foreach (string old in oldProdDescArray)
    //                {
    //                    var oldRec = old.Split('|');
    //                    PurchaseRequisitionProductObject prodDescObj = new PurchaseRequisitionProductObject();
    //                    prodDescObj.PurchaseRequisitionId = oldRec[0];
    //                    prodDescObj.Id = oldRec[1];
    //                    prodDescObj.CurrencyId = "";
    //                    prodDescObj.ItemCode = oldRec[2];
    //                    prodDescObj.Description = oldRec[3];
    //                    prodDescObj.Quantity = "";
    //                    prodDescObj.UnitPrice = "";
    //                    prodDescObj.UnitPriceInUSD = "";
    //                    prodDescObj.IsActive = oldRec[4];
    //                    prodDescObj.UoM = "";

    //                    oldProdDescList.Add(prodDescObj);
    //                }
    //                Log.Information("Move old prod desc into object done. Id: " + prId);

    //                List<PurchaseRequisitionProductObject> newProdDescList = new List<PurchaseRequisitionProductObject>();
    //                foreach (string newDes in newProdDescArray)
    //                {
    //                    var newRec = newDes.Split('|');
    //                    PurchaseRequisitionProductObject prodDescObj = new PurchaseRequisitionProductObject();
    //                    prodDescObj.PurchaseRequisitionId = newRec[0];
    //                    prodDescObj.Id = newRec[1];
    //                    prodDescObj.CurrencyId = "";
    //                    prodDescObj.ItemCode = newRec[2];
    //                    prodDescObj.Description = newRec[3];
    //                    prodDescObj.Quantity = "";
    //                    prodDescObj.UnitPrice = "";
    //                    prodDescObj.UnitPriceInUSD = "";
    //                    prodDescObj.IsActive = newRec[4];
    //                    prodDescObj.UoM = "";

    //                    newProdDescList.Add(prodDescObj);
    //                }
    //                Log.Information("Move new prod desc into object done. Id: " + prId);

    //                foreach (var oldData in oldGrantData)
    //                {
    //                    if (oldData.Value.ToLower() != newGrantData.FirstOrDefault(x => x.Key == oldData.Key).Value.ToLower())
    //                    {
    //                        DifferentData difData = new DifferentData();
    //                        difData.FieldName = oldData.Key;
    //                        difData.OldValue = oldData.Value;
    //                        difData.NewValue = newGrantData.FirstOrDefault(x => x.Key == oldData.Key).Value;

    //                        listDiff.Add(difData);
    //                    }
    //                }

    //                if (listDiff.Count > 0)
    //                {
    //                    foreach (DifferentData diff in listDiff)
    //                    {
    //                        if (diff.FieldName.ToLower().Equals("PurchaseRequisitionType".ToLower()))
    //                        {
    //                            Log.Information("Build PurchaseRequisitionType reaction apv notes. Id: " + prId);

    //                            string prtypeOld = "";
    //                            prtypeOld = diff.OldValue.ToString().ToLower();
    //                            prtypeOld = string.IsNullOrEmpty(prtypeOld) ? "unspecified purchase type" : prtypeOld;

    //                            string prtypeNew = "";
    //                            prtypeNew = diff.NewValue.ToString().ToLower();
    //                            prtypeNew = string.IsNullOrEmpty(prtypeNew) ? "unspecified purchase type" : prtypeNew;

    //                            listStringActivity.Add("Change purchase type from " + GetPurchaseTypeNameById(prtypeOld) + " to " + GetPurchaseTypeNameById(prtypeNew));
    //                        }
    //                        else if (diff.FieldName.ToLower().Equals("PurchaseRequisitionAmount".ToLower()))
    //                        {
    //                            Log.Information("Build PurchaseRequisitionAmount reaction apv notes. Id: " + prId);

    //                            string prAmtOld = "";
    //                            prAmtOld = diff.OldValue.ToString().ToLower();
    //                            prAmtOld = string.IsNullOrEmpty(prAmtOld) ? "unspecified purchase requisition amount" : prAmtOld;

    //                            string prAmtNew = "";
    //                            prAmtNew = diff.NewValue.ToString().ToLower();
    //                            prAmtNew = string.IsNullOrEmpty(prAmtNew) ? "unspecified purchase requisition amount" : prAmtNew;

    //                            listStringActivity.Add("Change of total cost estimated from USD " + String.Format("{0:N2}", Convert.ToDecimal(prAmtOld)) + " to USD " + String.Format("{0:N2}", Convert.ToDecimal(prAmtNew)));
    //                        }
    //                        else if (diff.FieldName.ToLower().Equals("ProcurementOffice".ToLower()))
    //                        {
    //                            Log.Information("Build ProcurementOffice reaction apv notes. Id: " + prId);

    //                            string prOffOld = "";
    //                            prOffOld = diff.OldValue.ToString().ToLower();
    //                            prOffOld = string.IsNullOrEmpty(prOffOld) ? "unspecified purchase requisition office" : prOffOld;

    //                            string prOffNew = "";
    //                            prOffNew = diff.NewValue.ToString().ToLower();
    //                            prOffNew = string.IsNullOrEmpty(prOffNew) ? "unspecified purchase requisition office" : prOffNew;

    //                            listStringActivity.Add("Change of purchase requisition office from " + statics.GetPurchaseRequisitionOfficeNameById(prOffOld) + " to " + statics.GetPurchaseRequisitionOfficeNameById(prOffNew));
    //                        }
    //                        else if (diff.FieldName.ToLower().Equals("Product".ToLower()))
    //                        {
    //                            Log.Information("Build Product reaction apv notes. Id: " + prId);

    //                            List<PurchaseRequisitionProductObject> oldData = new List<PurchaseRequisitionProductObject>();
    //                            List<PurchaseRequisitionProductObject> newData = new List<PurchaseRequisitionProductObject>();

    //                            //string[] separator = { "||" };
    //                            var oldDataArray = diff.OldValue.ToString().Split(separator, StringSplitOptions.None);
    //                            foreach (string str in oldDataArray)
    //                            {
    //                                var oldRec = str.Split('|');
    //                                PurchaseRequisitionProductObject prodObj = new PurchaseRequisitionProductObject();
    //                                prodObj.PurchaseRequisitionId = oldRec[0];
    //                                prodObj.Id = oldRec[1];
    //                                prodObj.CurrencyId = oldRec[2];
    //                                prodObj.ItemCode = oldRec[3];
    //                                prodObj.Description = oldRec[4];
    //                                prodObj.Quantity = oldRec[5];
    //                                prodObj.UnitPrice = oldRec[6];
    //                                prodObj.UnitPriceInUSD = oldRec[7];
    //                                prodObj.IsActive = oldRec[8];
    //                                prodObj.UoM = oldRec[9];

    //                                oldData.Add(prodObj);
    //                            }
    //                            Log.Information("Build Product reaction apv notes. move old product record to object done. Id: " + prId);

    //                            var newDataArray = diff.NewValue.ToString().Split(separator, StringSplitOptions.None);
    //                            foreach (string str in newDataArray)
    //                            {
    //                                var newRecord = str.Split('|');
    //                                PurchaseRequisitionProductObject prodObj = new PurchaseRequisitionProductObject();
    //                                prodObj.PurchaseRequisitionId = newRecord[0];
    //                                prodObj.Id = newRecord[1];
    //                                prodObj.CurrencyId = newRecord[2];
    //                                prodObj.ItemCode = newRecord[3];
    //                                prodObj.Description = newRecord[4];
    //                                prodObj.Quantity = newRecord[5];
    //                                prodObj.UnitPrice = newRecord[6];
    //                                prodObj.UnitPriceInUSD = newRecord[7];
    //                                prodObj.IsActive = newRecord[8];
    //                                prodObj.UoM = newRecord[9];

    //                                newData.Add(prodObj);
    //                            }
    //                            Log.Information("Build Product reaction apv notes. move new product record to object done. Id: " + prId);

    //                            oldData.OrderBy(x => x.Id);
    //                            newData.OrderBy(x => x.Id);

    //                            foreach (PurchaseRequisitionProductObject newDataObj in newData)
    //                            {
    //                                Log.Information("Build Product reaction apv notes. Going into Foreach. Id: " + prId);
    //                                var oldDataObjs = oldData.Where(x => x.Id == newDataObj.Id && x.PurchaseRequisitionId == newDataObj.PurchaseRequisitionId).ToList();
    //                                if (oldDataObjs.Count > 0)
    //                                {
    //                                    foreach (PurchaseRequisitionProductObject oldDataObj in oldDataObjs)
    //                                    {
    //                                        if (newDataObj.ItemCode != oldDataObj.ItemCode
    //                                            || newDataObj.Description != oldDataObj.Description
    //                                            || newDataObj.Quantity != oldDataObj.Quantity
    //                                            || newDataObj.UnitPrice != oldDataObj.UnitPrice
    //                                            || newDataObj.UnitPriceInUSD != oldDataObj.UnitPriceInUSD
    //                                            || newDataObj.IsActive != oldDataObj.IsActive
    //                                            || newDataObj.CurrencyId != oldDataObj.CurrencyId
    //                                            || newDataObj.UoM != oldDataObj.UoM
    //                                            )
    //                                        {
    //                                            Log.Information("Build Product reaction apv notes. There differences in Product record. Id: " + prId);

    //                                            var newProdId = newDataObj.ItemCode.ToUpper();
    //                                            var newProdDescListCnt = newProdDescList.Count;
    //                                            Log.Information("Build Product reaction apv notes. newProdDescListCnt :" + newProdDescListCnt.ToString() + ". Id: " + prId);
    //                                            Log.Information("Build Product reaction apv notes. newDataObj.PurchaseRequisitionId  :" + newDataObj.PurchaseRequisitionId.ToString() + ". Id: " + prId);
    //                                            Log.Information("Build Product reaction apv notes. newDataObj.Id  :" + newDataObj.Id.ToString() + ". Id: " + prId);
    //                                            Log.Information("Build Product reaction apv notes. newDataObj.ItemCode  :" + newDataObj.ItemCode.ToString() + ". Id: " + prId);
    //                                            Log.Information("Build Product reaction apv notes. newDataObj.IsActive  :" + newDataObj.IsActive.ToString() + ". Id: " + prId);
    //                                            var newDescription = "";
    //                                            var newDescObj = newProdDescList.Where(x => x.PurchaseRequisitionId.ToUpper() == newDataObj.PurchaseRequisitionId.ToUpper()
    //                                                                                         && x.Id.ToUpper() == newDataObj.Id.ToUpper()
    //                                                                                         && x.ItemCode.ToUpper() == newDataObj.ItemCode.ToUpper()
    //                                                                                         && x.IsActive.ToUpper() == newDataObj.IsActive.ToUpper()).FirstOrDefault();
    //                                            if (newDescObj != null)
    //                                            {
    //                                                newDescription = newDescObj.Description.ToString();
    //                                            }
    //                                            Log.Information("Build Product reaction apv notes. newDescription :" + newDescription + ". Id: " + prId);
    //                                            Log.Information("Build Product reaction apv notes. Get new Prod Desc done. Id: " + prId);
    //                                            var newQuantity = String.Format("{0:N2}", Convert.ToDecimal(newDataObj.Quantity));
    //                                            var newCurrency = newDataObj.CurrencyId;
    //                                            var newUnitPrice = String.Format("{0:N2}", Convert.ToDecimal(newDataObj.UnitPrice));
    //                                            var newUnitPriceUsd = String.Format("{0:N2}", Convert.ToDecimal(newDataObj.UnitPriceInUSD));
    //                                            var newIsActive = newDataObj.IsActive;
    //                                            var newUom = newDataObj.UoM;

    //                                            var oldProdId = oldDataObj.ItemCode.ToUpper();
    //                                            var oldDescription = "";
    //                                            var oldDescObj = oldProdDescList.Where(x => x.PurchaseRequisitionId.ToUpper() == oldDataObj.PurchaseRequisitionId.ToUpper()
    //                                                                                         && x.Id.ToUpper() == oldDataObj.Id.ToUpper()
    //                                                                                         && x.ItemCode.ToUpper() == oldDataObj.ItemCode.ToUpper()
    //                                                                                         && x.IsActive.ToUpper() == oldDataObj.IsActive.ToUpper()).FirstOrDefault();
    //                                            if (oldDescObj != null)
    //                                            {
    //                                                oldDescription = oldDescObj.Description.ToString();
    //                                            }
    //                                            Log.Information("Build Product reaction apv notes. oldDescription :" + oldDescription + ". Id: " + prId);
    //                                            Log.Information("Build Product reaction apv notes. Get old Prod Desc done. Id: " + prId);
    //                                            var oldQuantity = String.Format("{0:N2}", Convert.ToDecimal(oldDataObj.Quantity));
    //                                            var oldCurrency = oldDataObj.CurrencyId;
    //                                            var oldUnitPrice = String.Format("{0:N2}", Convert.ToDecimal(oldDataObj.UnitPrice));
    //                                            var oldUnitPriceUsd = String.Format("{0:N2}", Convert.ToDecimal(oldDataObj.UnitPriceInUSD));
    //                                            var oldIsActive = oldDataObj.IsActive;
    //                                            var oldUom = oldDataObj.UoM;

    //                                            bool isProdChanged = false;
    //                                            //bool isDescChanged = false;
    //                                            bool isQuantityChanged = false;
    //                                            bool isPriceChanged = false;
    //                                            bool isPriceUSDChanged = false;
    //                                            bool isActiveChanged = false;
    //                                            bool isCurrencyChanged = false;
    //                                            //bool isUoMChanged = false;

    //                                            if (newProdId != oldProdId)
    //                                            {
    //                                                isProdChanged = true;
    //                                            }
    //                                            //if (newDescription != oldDescription)
    //                                            //{
    //                                            //    isDescChanged = true;
    //                                            //}
    //                                            if (newQuantity != oldQuantity)
    //                                            {
    //                                                isQuantityChanged = true;
    //                                            }
    //                                            if (newUnitPrice != oldUnitPrice || newCurrency != oldCurrency)
    //                                            {
    //                                                isPriceChanged = true;
    //                                            }
    //                                            if (newUnitPriceUsd != oldUnitPriceUsd)
    //                                            {
    //                                                isPriceUSDChanged = true;
    //                                            }
    //                                            if (newIsActive != oldIsActive)
    //                                            {
    //                                                isActiveChanged = true;
    //                                            }
    //                                            if (newCurrency != oldCurrency)
    //                                            {
    //                                                isCurrencyChanged = true;
    //                                            }
    //                                            //if (newUom != oldUom)
    //                                            //{
    //                                            //    isUoMChanged = true;
    //                                            //}

    //                                            var liTag = "<li>";
    //                                            var endLiTag = "</li>";
    //                                            var ulTag = "<ul style='margin-top: 0px'>";
    //                                            var ulEndTag = "</ul>";

    //                                            var res = "";

    //                                            if (!isActiveChanged)
    //                                            {
    //                                                res += liTag;

    //                                                if (isProdChanged)
    //                                                {
    //                                                    res += "Change of";
    //                                                }
    //                                                else
    //                                                {
    //                                                    res += "Change of product " + newProdId.ToUpper() + " details: ";
    //                                                }

    //                                                res += ulTag;
    //                                                if (isProdChanged)
    //                                                {
    //                                                    res += liTag + "Product code from " + oldProdId + "-" + oldDescription + " into " + newProdId + "-" + newDescription + endLiTag;
    //                                                }

    //                                                if (!isProdChanged)
    //                                                {
    //                                                    //res += liTag + "Product code from " + oldProdId + " into " + newProdId + endLiTag;
    //                                                    //if (isDescChanged)
    //                                                    //{
    //                                                    //    res += liTag + "Product description from " + oldDescription + " into " + newDescription + endLiTag;
    //                                                    //}
    //                                                    if (isQuantityChanged)
    //                                                    {
    //                                                        res += liTag + "Product quantity from " + oldQuantity + " into " + newQuantity + endLiTag;
    //                                                    }
    //                                                    if (isPriceUSDChanged || isPriceChanged || isCurrencyChanged)
    //                                                    {
    //                                                        var oldCurrWord = "";
    //                                                        var newCurrWord = "";
    //                                                        if (oldCurrency.ToLower() == "usd")
    //                                                        {
    //                                                            oldCurrWord = "USD " + oldUnitPriceUsd;
    //                                                        }
    //                                                        else
    //                                                        {
    //                                                            oldCurrWord = oldCurrency.ToUpper() + " " + oldUnitPrice + " (USD " + oldUnitPriceUsd + ")";
    //                                                        }

    //                                                        if (newCurrency.ToLower() == "usd")
    //                                                        {
    //                                                            newCurrWord = "USD " + newUnitPriceUsd;
    //                                                        }
    //                                                        else
    //                                                        {
    //                                                            newCurrWord = newCurrency.ToUpper() + " " + newUnitPrice + " (USD " + newUnitPriceUsd + ")";
    //                                                        }

    //                                                        res += liTag + "Product price from " + oldCurrWord + " into " + newCurrWord + endLiTag;
    //                                                    }
    //                                                }
    //                                                res += ulEndTag;
    //                                                res += endLiTag;
    //                                            }
    //                                            else
    //                                            {
    //                                                //res += liTag;
    //                                                //if (newDataObj.IsActive == "1")
    //                                                //{
    //                                                //    res += "Add product of";
    //                                                //    res += " " + newProdId + "-" + newDescription;
    //                                                //}
    //                                                //else
    //                                                //{
    //                                                //    res += "Removed product of";
    //                                                //    res += " " + newProdId + "-" + newDescription;
    //                                                //}
    //                                                //res += endLiTag;
    //                                            }

    //                                            if (!string.IsNullOrEmpty(res))
    //                                            {
    //                                                listStringActivity.Add(res);
    //                                            }
    //                                        }
    //                                    }
    //                                }
    //                                else
    //                                {
    //                                    //var res = "";
    //                                    //res += "<li>";
    //                                    //res += "Added product of";
    //                                    //res += " " + newDataObj.ItemCode + "-" + newDataObj.Description;
    //                                    //res += "</li>";

    //                                    //listStringActivity.Add(res);
    //                                }
    //                            }
    //                        }
    //                        else if (diff.FieldName.ToLower().Equals("ChargeCode".ToLower()))
    //                        {
    //                            Log.Information("Build ChargeCode reaction apv notes. Id: " + prId);

    //                            List<PurchaseRequisitionDetailCostCenterObject> oldData = new List<PurchaseRequisitionDetailCostCenterObject>();
    //                            List<PurchaseRequisitionDetailCostCenterObject> newData = new List<PurchaseRequisitionDetailCostCenterObject>();

    //                            var oldDataArray = diff.OldValue.ToString().Split(';');
    //                            foreach (string str in oldDataArray)
    //                            {
    //                                var oldRec = str.Split('|');
    //                                PurchaseRequisitionDetailCostCenterObject bhObj = new PurchaseRequisitionDetailCostCenterObject();
    //                                bhObj.CostCenterId = oldRec[0];
    //                                bhObj.WorkOrderId = oldRec[1];
    //                                bhObj.EntityId = oldRec[2];
    //                                bhObj.Amount = oldRec[3];
    //                                bhObj.ProductId = oldRec[4];
    //                                bhObj.Id = oldRec[5];

    //                                oldData.Add(bhObj);
    //                            }

    //                            var newDataArray = diff.NewValue.ToString().Split(';');
    //                            foreach (string str in newDataArray)
    //                            {
    //                                var diffArray = str.Split('|');
    //                                PurchaseRequisitionDetailCostCenterObject bhObj = new PurchaseRequisitionDetailCostCenterObject();
    //                                bhObj.CostCenterId = diffArray[0];
    //                                bhObj.WorkOrderId = diffArray[1];
    //                                bhObj.EntityId = diffArray[2];
    //                                bhObj.Amount = diffArray[3];
    //                                bhObj.ProductId = diffArray[4];
    //                                bhObj.Id = diffArray[5];

    //                                newData.Add(bhObj);
    //                            }

    //                            var listOfOldDataProduct = oldData.Select(x => x.ProductId).ToArray().Distinct();
    //                            var listOfOldCostCenterId = oldData.Select(x => x.CostCenterId).ToArray().Distinct();
    //                            var listOfNewDataProduct = newData.Select(x => x.ProductId).ToArray().Distinct();
    //                            var listOfNewCostCenterId = newData.Select(x => x.CostCenterId).ToArray().Distinct();

    //                            //added product
    //                            //var addedProduct = listOfNewDataProduct.Except(listOfOldDataProduct).ToList().Distinct();
    //                            //if (addedProduct.Count() > 0)
    //                            //{
    //                            //    foreach (string addedProd in addedProduct)
    //                            //    {
    //                            //        var ProductName = addedProd;
    //                            //        DataTable PrDetail = statics.GetPurchaseRequisitionDetailById(addedProd);
    //                            //        if (PrDetail != null)
    //                            //        {
    //                            //            if (PrDetail.Rows.Count > 0)
    //                            //            {
    //                            //                ProductName = PrDetail.Rows[0]["item_code"].ToString().ToUpper() + "-" + PrDetail.Rows[0]["description"].ToString();
    //                            //            }
    //                            //        }
    //                            //        listStringActivity.Add("Added new product of " + ProductName);
    //                            //    }
    //                            //}

    //                            ////deleted product
    //                            //var deletedProduct = listOfOldDataProduct.Except(listOfNewDataProduct).ToList().Distinct();
    //                            //if (deletedProduct.Count() > 0)
    //                            //{
    //                            //    foreach (string delProd in deletedProduct)
    //                            //    {
    //                            //        var ProductName = delProd;
    //                            //        DataTable PrDetail = statics.GetPurchaseRequisitionDetailById(delProd);
    //                            //        if (PrDetail != null)
    //                            //        {
    //                            //            if (PrDetail.Rows.Count > 0)
    //                            //            {
    //                            //                ProductName = PrDetail.Rows[0]["item_code"].ToString().ToUpper() + "-" + PrDetail.Rows[0]["description"].ToString();
    //                            //            }
    //                            //        }
    //                            //        listStringActivity.Add("Removed product of " + ProductName);
    //                            //    }
    //                            //}

    //                            //ngecek data budget holder lain yg ditambah
    //                            //var addedBh = listOfNewCostCenterId.Except(listOfOldCostCenterId).ToList().Distinct();
    //                            //if (addedBh.Count() > 0)
    //                            //{
    //                            //    addedBh.ToList().RemoveAll(x => x.ToLower() == trueBudgetHolder.ToLower());
    //                            //    foreach (string newBh in addedBh)
    //                            //    {
    //                            //        var completeNewBhData = newData.Where(x => x.CostCenterId.ToLower() == newBh.ToLower()).ToList();
    //                            //        if (completeNewBhData.Count() > 0)
    //                            //        {
    //                            //            foreach (PurchaseRequisitionDetailCostCenterObject bhObj in completeNewBhData)
    //                            //            {
    //                            //                var ProductName = bhObj.ProductId;
    //                            //                DataTable PrDetail = statics.GetPurchaseRequisitionDetailById(bhObj.ProductId);
    //                            //                if (PrDetail != null)
    //                            //                {
    //                            //                    if (PrDetail.Rows.Count > 0)
    //                            //                    {
    //                            //                        ProductName = PrDetail.Rows[0]["item_code"].ToString().ToUpper() + "-" + PrDetail.Rows[0]["description"].ToString();
    //                            //                    }
    //                            //                }

    //                            //                var prodId = ProductName;
    //                            //                var cosC = bhObj.CostCenterId;
    //                            //                var woId = bhObj.WorkOrderId;
    //                            //                var entId = bhObj.EntityId;
    //                            //                var amt = String.Format("{0:N2}", Convert.ToDecimal(bhObj.Amount));

    //                            //                var res = "Added new charge code of";
    //                            //                res += " " + cosC.ToUpper() + "." + woId.ToUpper() + "." + entId.ToUpper();
    //                            //                res += " with amount of USD " + amt;
    //                            //                res += " within product of";
    //                            //                res += " " + ProductName;

    //                            //                listStringActivity.Add(res);
    //                            //            }
    //                            //        }
    //                            //    }
    //                            //}

    //                            ////ngecek data budget holder lain yg dihapus
    //                            //var deletedBh = listOfOldCostCenterId.Except(listOfNewCostCenterId).ToList().Distinct();
    //                            //if (deletedBh.Count() > 0)
    //                            //{
    //                            //    deletedBh.ToList().RemoveAll(x => x.ToLower() == trueBudgetHolder.ToLower());
    //                            //    foreach (string delBh in deletedBh)
    //                            //    {
    //                            //        var completeOldBhData = oldData.Where(x => x.CostCenterId.ToLower() == delBh.ToLower()).ToList();
    //                            //        if (completeOldBhData.Count() > 0)
    //                            //        {
    //                            //            foreach (PurchaseRequisitionDetailCostCenterObject bhObj in completeOldBhData)
    //                            //            {
    //                            //                var ProductName = bhObj.ProductId;
    //                            //                DataTable PrDetail = statics.GetPurchaseRequisitionDetailById(bhObj.ProductId);
    //                            //                if (PrDetail != null)
    //                            //                {
    //                            //                    if (PrDetail.Rows.Count > 0)
    //                            //                    {
    //                            //                        ProductName = PrDetail.Rows[0]["item_code"].ToString().ToUpper() + "-" + PrDetail.Rows[0]["description"].ToString();
    //                            //                    }
    //                            //                }

    //                            //                var prodId = ProductName;
    //                            //                var cosC = bhObj.CostCenterId;
    //                            //                var woId = bhObj.WorkOrderId;
    //                            //                var entId = bhObj.EntityId;
    //                            //                var amt = String.Format("{0:N2}", Convert.ToDecimal(bhObj.Amount));

    //                            //                var res = "Deleted charge code of";
    //                            //                res += " " + cosC.ToUpper() + "." + woId.ToUpper() + "." + entId.ToUpper();
    //                            //                res += " with amount of USD " + amt;
    //                            //                res += " within product of";
    //                            //                res += " " + ProductName;

    //                            //                listStringActivity.Add(res);
    //                            //            }
    //                            //        }
    //                            //    }
    //                            //}

    //                            //Ngecek data diri sendiri yg berubah
    //                            var differentChargeCodeData = new List<PurchaseRequisitionDetailCostCenterObject>();
    //                            var differentChargeCodeDataArr = newDataArray.Except(oldDataArray).ToList();
    //                            if (differentChargeCodeDataArr.Count() > 0)
    //                            {
    //                                foreach (string str in differentChargeCodeDataArr)
    //                                {
    //                                    var arr = str.Split('|');
    //                                    PurchaseRequisitionDetailCostCenterObject obj = new PurchaseRequisitionDetailCostCenterObject();
    //                                    obj.CostCenterId = arr[0];
    //                                    obj.WorkOrderId = arr[1];
    //                                    obj.EntityId = arr[2];
    //                                    obj.Amount = arr[3];
    //                                    obj.ProductId = arr[4];
    //                                    obj.Id = arr[5];

    //                                    differentChargeCodeData.Add(obj);
    //                                }
    //                            }

    //                            string stringCostCenters = statics.GetCostCenterIdByUserId(trueBudgetHolder).ToLower();

    //                            List<string> costCenterList = stringCostCenters.Split(';').ToList();

    //                            var dataByUserId = differentChargeCodeData.Where(x => costCenterList.Contains(x.CostCenterId) && oldData.Select(y => y.Id).ToList().Contains(x.Id)).ToList();
    //                            foreach (PurchaseRequisitionDetailCostCenterObject obj in dataByUserId)
    //                            {
    //                                var oldDataWordingSet = oldData.Where(x => x.Id == obj.Id).FirstOrDefault();
    //                                var oldProductName = oldDataWordingSet.ProductId;
    //                                DataTable oldPrDetail = statics.GetPurchaseRequisitionDetailById(oldDataWordingSet.ProductId);
    //                                if (oldPrDetail != null)
    //                                {
    //                                    if (oldPrDetail.Rows.Count > 0)
    //                                    {
    //                                        oldProductName = oldPrDetail.Rows[0]["item_code"].ToString().ToUpper() + "-" + oldPrDetail.Rows[0]["description"].ToString();
    //                                    }
    //                                }
    //                                string oldPrdct = oldProductName;
    //                                string oldCostC = oldDataWordingSet.CostCenterId;
    //                                string oldWoId = oldDataWordingSet.WorkOrderId;
    //                                string oldEntId = oldDataWordingSet.EntityId;
    //                                string oldMmt = oldDataWordingSet.Amount;

    //                                var newProductName = obj.ProductId;
    //                                DataTable newPrDetail = statics.GetPurchaseRequisitionDetailById(obj.ProductId);
    //                                if (newPrDetail != null)
    //                                {
    //                                    if (newPrDetail.Rows.Count > 0)
    //                                    {
    //                                        newProductName = newPrDetail.Rows[0]["item_code"].ToString().ToUpper() + "-" + newPrDetail.Rows[0]["description"].ToString();
    //                                    }
    //                                }
    //                                string newPrdct = newProductName;
    //                                string newCostC = obj.CostCenterId;
    //                                string newWoId = obj.WorkOrderId;
    //                                string newEntId = obj.EntityId;
    //                                string newMmt = obj.Amount;

    //                                string res = "Change of charge code from";
    //                                res += " " + oldPrdct + "/" + oldCostC.ToUpper() + "." + oldWoId.ToUpper() + "." + oldEntId.ToUpper();
    //                                res += " with amount of";
    //                                res += " USD " + String.Format("{0:N2}", Convert.ToDecimal(oldMmt));
    //                                res += " into";
    //                                res += " " + newPrdct + "/" + newCostC.ToUpper() + "." + newWoId.ToUpper() + "." + newEntId.ToUpper();
    //                                res += " with amount of";
    //                                res += " USD " + String.Format("{0:N2}", Convert.ToDecimal(newMmt));

    //                                listStringActivity.Add(res);
    //                            }
    //                        }
    //                    }
    //                }
    //                #endregion

    //                Log.Information("Finish Apv Notes Wording for re-action. Id" + prId);
    //            }

    //            if (listStringActivity.Count > 0)
    //            {
    //                foreach (string act in listStringActivity)
    //                {
    //                    if (!act.Contains("</li>"))
    //                    {
    //                        _actDesc += "<li>";
    //                        _actDesc += act;
    //                        _actDesc += "</li>";
    //                    }
    //                    else
    //                    {
    //                        _actDesc += act;
    //                    }
    //                }
    //            }

    //            if (listStringRole.Count > 0)
    //            {
    //                _actName = string.Join("; ", listStringRole.ToArray());
    //            }
    //        }

    //        _actDesc += "</ul>";

    //        actObj.ApprovalNotesWording = _actDesc; //Masuk ke Approval Notes
    //        actObj.Role = _actName; //Masuk ke Role di Comment


    //        return actObj;
    //    }

    //    private static string GetPurchaseTypeNameById(string Id)
    //    {
    //        string res = "";

    //        DataTable dt = statics.GetPurchaseType();

    //        if (dt.Rows.Count > 0)
    //        {
    //            foreach (DataRow dr in dt.Rows)
    //            {
    //                if (dr["value"].ToString() == Id)
    //                {
    //                    res = dr["description"].ToString();
    //                }
    //            }
    //        }
    //            //switch (Id)
    //            //{

    //            //    case "0":
    //            //        res = "Invoice from other CGIAR center";
    //            //        break;

    //            //    case "1":
    //            //        res = "Payment using a credit card";
    //            //        break;

    //            //    case "2":
    //            //        res = "Subscriptions (journal, web hosting etc.)";
    //            //        break;

    //            //    case "3":
    //            //        res = "Others";
    //            //        break;

    //            //    case "4":
    //            //        res = "Reimbursement";
    //            //        break;

    //            //    case "5":
    //            //        res = "Cash advance";
    //            //        break;

    //            //    case "6":
    //            //        res = "Direct payment to supplier";
    //            //        break;

    //            //    case "7":
    //            //        res = "Lease/rental of real estate";
    //            //        break;

    //            //    case "8":
    //            //        res = "Honorarium and Workshop/Training/Meeting Facilitator’s fees where CIFOR and ICRAF have a fixed approved rate";
    //            //        break;

    //            //    case "9":
    //            //        res = "Performing Artists";
    //            //        break;

    //            //    case "10":
    //            //        res = "Writers";
    //            //        break;

    //            //    case "11":
    //            //        res = "Memberships";
    //            //        break;

    //            //    case "12":
    //            //        res = "Utilities";
    //            //        break;

    //            //    case "13":
    //            //        res = "Design competitions";
    //            //        break;

    //            //    case "14":
    //            //        res = "Government’s fees/duties";
    //            //        break;

    //            //    default:
    //            //        res = "Unspecified purchase type";
    //            //        break;
    //            //}

    //            return res;
    //    }

    //    public static List<K2ActivityUserMapping> GetPRAllActivityUserWithSubstitute(DataTable prObj)
    //    {
    //        var CreatedBy = prObj.Rows[0]["created_by"].ToString();
    //        var requestor = prObj.Rows[0]["requestor_user_id"].ToString();
    //        var prId = prObj.Rows[0]["id"].ToString();
    //        var prType = prObj.Rows[0]["pr_type"].ToString().ToLower();
    //        var prAmount = prObj.Rows[0]["pr_amt"].ToString().ToLower();
    //        var dcsUser = prObj.Rows[0]["dcsUser"].ToString().ToLower();
    //        var dgUser = prObj.Rows[0]["dgUser"].ToString().ToLower();
    //        var bhUser = prObj.Rows[0]["bhUser"].ToString().ToLower();
    //        var procOffUser = prObj.Rows[0]["procOffUser"].ToString().ToLower();
    //        var financeUser = prObj.Rows[0]["financeUser"].ToString().ToLower();
    //        var paymentUser = prObj.Rows[0]["paymentUser"].ToString().ToLower();
    //        var financeLeadUser = prObj.Rows[0]["financeLeadUser"].ToString().ToLower();
    //        var cfooUser = prObj.Rows[0]["cfooUser"].ToString().ToLower();
    //        var countryLeadUser = prObj.Rows[0]["countryLeadUser"].ToString().ToLower();
    //        //bool isFromRedirect = false;
    //        //var PrTypeBefore = GetLatestPRTypeById(prId);
    //        //if (prType.Equals(PrTypeBefore) || string.IsNullOrEmpty(PrTypeBefore))
    //        //{
    //        //    isFromRedirect = true;
    //        //}

    //        var activityUserList = new List<K2ActivityUserMapping>();

    //        #region Get General User
    //        activityUserList.AddRange((GetInitiatorUser(CreatedBy))
    //            .Select(x => new K2ActivityUserMapping() { Username = x.UserId, ActivityId = 0, Substitute = "" })
    //            );

    //        activityUserList.AddRange((GetInitiatorUser(requestor))
    //           .Select(x => new K2ActivityUserMapping() { Username = x.UserId, ActivityId = 0, Substitute = "" })
    //           );

    //        activityUserList.AddRange((GetInitiatorUser(CreatedBy))
    //           .Select(x => new K2ActivityUserMapping() { Username = x.UserId, ActivityId = 1, Substitute = "" })
    //           );
    //        #endregion


    //        string[] noNeedFinance = { "3" };
    //        string[] noNeedFinanceVerif = { "6" };
    //        string[] noNeedJustification = { "3" };

    //        if (!noNeedFinance.Contains(prType))
    //        {
    //            activityUserList.AddRange((AddUserSubsMapping(paymentUser, prId, 7, prObj))
    //            .Select(x => new K2ActivityUserMapping() { Username = x.UserId, ActivityId = 7, Substitute = x.Substitute })
    //            );

    //            if (!noNeedFinanceVerif.Contains(prType))
    //            {
    //                //activityUserList.AddRange((AddUserSubsMapping(financeUser, prId, 6))
    //                //.Select(x => new K2ActivityUserMapping() { Username = x.UserId, ActivityId = 6, Substitute = x.Substitute })
    //                //);
    //            }

    //            //if (isFromRedirect)
    //            //{
    //            var procOffData = CheckProcurementOfficeUserInCurrentSequence(prId);
    //            if (procOffData != null)
    //            {
    //                if (procOffData.Rows.Count > 0)
    //                {
    //                    var isProcOfficeUserExist = procOffData.Rows[0]["isProcOfficeUserExist"].ToString().ToLower() == "true" ? true : false;
    //                    var existProcOfficeUser = procOffData.Rows[0]["procOfficeUser"].ToString();

    //                    //cek is_have_revision_task dan last action return to init
    //                    bool isAllowedToInsertPaymentUser = true;
    //                    bool isReturnToInit = false;

    //                    isReturnToInit = CheckIsHaveRevisionTask(prId);
    //                    if (isReturnToInit)
    //                    {
    //                        //checklast take action
    //                        DataTable lastVerif = CheckPRLastVerif(prId);
    //                        if (lastVerif != null)
    //                        {
    //                            if (lastVerif.Rows.Count > 0)
    //                            {
    //                                var lastActIdVerif = lastVerif.Rows[0]["activity_id"].ToString();
    //                                isAllowedToInsertPaymentUser = lastActIdVerif == "5" ? true : false;
    //                            }
    //                        }
    //                    }

    //                    if (isProcOfficeUserExist && isAllowedToInsertPaymentUser)
    //                    {
    //                        activityUserList.AddRange((AddUserSubsMapping(existProcOfficeUser, prId, 5, prObj))
    //                        .Select(x => new K2ActivityUserMapping() { Username = x.UserId, ActivityId = 5, Substitute = x.Substitute })
    //                        );
    //                    }
    //                }
    //            }
    //            //}
    //        }
    //        else
    //        {
    //            //if (isFromRedirect)
    //            //{
    //            var finData = CheckFinanceInCurrentSequence(prId);
    //            if (finData.Rows.Count > 0)
    //            {
    //                var isFinanceExist = finData.Rows[0]["isFinanceUserExist"].ToString().ToLower() == "true" ? true : false;
    //                var isPaymentExist = finData.Rows[0]["isPayUserExist"].ToString().ToLower() == "true" ? true : false; ;
    //                var existfinanceUser = finData.Rows[0]["financeUser"].ToString();
    //                var existpaymentUser = finData.Rows[0]["paymentUser"].ToString();

    //                //cek is_have_revision_task dan last action return to init
    //                bool isAllowedToInsertPaymentUser = true;
    //                bool isReturnToInit = false;

    //                isReturnToInit = CheckIsHaveRevisionTask(prId);
    //                if (isReturnToInit)
    //                {
    //                    //checklast take action
    //                    DataTable lastVerif = CheckPRLastVerif(prId);
    //                    if (lastVerif != null)
    //                    {
    //                        if (lastVerif.Rows.Count > 0)
    //                        {
    //                            var lastActIdVerif = lastVerif.Rows[0]["activity_id"].ToString();
    //                            isAllowedToInsertPaymentUser = lastActIdVerif == "7" ? true : false;
    //                        }
    //                    }
    //                }

    //                if (isPaymentExist && isAllowedToInsertPaymentUser)
    //                {
    //                    activityUserList.AddRange((AddUserSubsMapping(existpaymentUser, prId, 7, prObj))
    //                    .Select(x => new K2ActivityUserMapping() { Username = x.UserId, ActivityId = 7, Substitute = x.Substitute })
    //                    );
    //                }

    //                if (isFinanceExist)
    //                {
    //                    //activityUserList.AddRange((AddUserSubsMapping(existfinanceUser, prId, 6))
    //                    //.Select(x => new K2ActivityUserMapping() { Username = x.UserId, ActivityId = 6, Substitute = x.Substitute })
    //                    //);
    //                }
    //            }
    //            //}

    //            activityUserList.AddRange((AddUserSubsMapping(procOffUser, prId, 5, prObj))
    //            .Select(x => new K2ActivityUserMapping() { Username = x.UserId, ActivityId = 5, Substitute = x.Substitute })
    //            );
    //        }


    //        activityUserList.AddRange((AddUserSubsMapping(bhUser, prId, 4, prObj))
    //            .Select(x => new K2ActivityUserMapping() { Username = x.UserId, ActivityId = 4, Substitute = x.Substitute })
    //            );


    //        if (!noNeedJustification.Contains(prType))
    //        {
    //            if (Convert.ToDecimal(prAmount) > 500)
    //            {
    //                if (Convert.ToDecimal(prAmount) > 80000)
    //                {
    //                    activityUserList.AddRange((AddUserSubsMapping(dgUser, prId, 3, prObj))
    //                        .Select(x => new K2ActivityUserMapping() { Username = x.UserId, ActivityId = 3, Substitute = x.Substitute })
    //                        );
    //                }
    //                else
    //                {
    //                    if (Convert.ToDecimal(prAmount) <= 5000)
    //                    {
    //                        // Go to Finance Lead
    //                        activityUserList.AddRange((AddUserSubsMapping(financeLeadUser, prId, 2, prObj))
    //                        .Select(x => new K2ActivityUserMapping() { Username = x.UserId, ActivityId = 2, Substitute = x.Substitute })
    //                        );
    //                    }
    //                    else if (Convert.ToDecimal(prAmount) > 5000 && Convert.ToDecimal(prAmount) <= 35000)
    //                    {
    //                        // Go to Country/Head Unit
    //                        activityUserList.AddRange((AddUserSubsMapping(countryLeadUser, prId, 2, prObj))
    //                        .Select(x => new K2ActivityUserMapping() { Username = x.UserId, ActivityId = 2, Substitute = x.Substitute })
    //                        );
    //                    }
    //                    else if (Convert.ToDecimal(prAmount) > 35000 && Convert.ToDecimal(prAmount) <= 50000)
    //                    {
    //                        // Go to CFOO
    //                        activityUserList.AddRange((AddUserSubsMapping(cfooUser, prId, 2, prObj))
    //                        .Select(x => new K2ActivityUserMapping() { Username = x.UserId, ActivityId = 2, Substitute = x.Substitute })
    //                        );
    //                    }
    //                    else if (Convert.ToDecimal(prAmount) > 50000 && Convert.ToDecimal(prAmount) <= 80000)
    //                    {
    //                        // Go to DCS
    //                        activityUserList.AddRange((AddUserSubsMapping(dcsUser, prId, 2, prObj))
    //                        .Select(x => new K2ActivityUserMapping() { Username = x.UserId, ActivityId = 2, Substitute = x.Substitute })
    //                        );
    //                    }
    //                }
    //            }
    //        }

    //        return activityUserList;
    //    }
    //}
}