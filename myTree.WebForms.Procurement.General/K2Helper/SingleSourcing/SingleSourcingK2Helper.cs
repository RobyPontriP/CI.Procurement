//using myTree.WebForms.K2Helper;
using myTree.WebForms.Procurement.General.K2Helper.SingleSourcing.Models;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using Serilog;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Linq;

namespace myTree.WebForms.Procurement.General.K2Helper.SingleSourcing
{
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

    //public class SingleSourcingK2Helper
    //{
    //    private const string K2ProcessName = "SingleSourcing";
    //    private readonly K2Helpers k2Help;

    //    static List<K2ActivityUser> UnapproveUsers { get; set; }

    //    public SingleSourcingK2Helper()
    //    {
    //        var k2ApiKey = ConfigurationManager.AppSettings["k2ApiKey"].ToString();
    //        var k2ApiEndpoint = ConfigurationManager.AppSettings["k2ApiEndpoint"].ToString();
    //        k2Help = new K2Helpers(k2ApiKey, k2ApiEndpoint);
    //    }

    //    public void SaveSingleSourcingDataLogList(DataTable ssData)
    //    {
    //        List<DataLog> listDL = new List<DataLog>();

    //        string poId = ssData.Rows[0]["id"].ToString();

    //        DataLog PRAmount = new DataLog
    //        {
    //            RelevantId = poId,
    //            Module = K2ProcessName,
    //            FieldName = "PurchaseOrderAmount",
    //            Value = ssData.Rows[0]["po_amt"].ToString().ToLower()
    //        };

    //        DataLog productDesc = new DataLog
    //        {
    //            RelevantId = poId,
    //            Module = K2ProcessName,
    //            FieldName = "ProductDescription",
    //            Value = ssData.Rows[0]["productDescription"].ToString()
    //        };

    //        listDL.Add(PRAmount);
    //        listDL.Add(productDesc);

    //        SaveDataLog(listDL, K2ProcessName);
    //    }

    //    public static Dictionary<string, object> GetSingleSourcingK2User(DataTable singleSourcingData, string accessManagementToken = "")
    //    {
    //        var poId = singleSourcingData.Rows[0]["id"]?.ToString();
    //        var createdBy = singleSourcingData.Rows[0]["created_by"]?.ToString();
    //        var title = singleSourcingData.Rows[0]["system_code"]?.ToString();
    //        var systemCode = singleSourcingData.Rows[0]["system_code"]?.ToString();
    //        string requester = singleSourcingData.Rows[0]["requestor"]?.ToString();
    //        string procOffId = singleSourcingData.Rows[0]["procurement_office_id"]?.ToString();
    //        string procOffName = singleSourcingData.Rows[0]["procurement_office_name"]?.ToString();
    //        string procOffRegion = singleSourcingData.Rows[0]["procurement_office_region"]?.ToString();
    //        string isFromHQ = singleSourcingData.Rows[0]["isFromHQ"]?.ToString();
    //        string productDescription = singleSourcingData.Rows[0]["productDescription"]?.ToString();
    //        string supplierName = singleSourcingData.Rows[0]["supplier_name"]?.ToString();
    //        string expectedDeliveryDate = singleSourcingData.Rows[0]["expected_delivery_date"]?.ToString();

    //        var userDict = new Dictionary<string, object>();
    //        Log.Information($"Start GetSingleSourcingK2User");

    //        var activityUser = GetSingleSourcingActivityUser(singleSourcingData);
    //        Log.Information($"GetSingleSourcingActivityUser with users: \n{JsonConvert.SerializeObject(activityUser)}");
    //        var approver = GetAllApproverByRelevantId(poId, K2ProcessName);
    //        Log.Information($"GetAllApproverByRelevantId with approver: \n{JsonConvert.SerializeObject(approver)}");

    //        UnapproveUsers = new List<K2ActivityUser>();
    //        foreach (var u in activityUser)
    //        {
    //            bool userAlreadyApproved = approver.Where(x => x.ActivityId == u.ActivityID.ToString()).Any();
    //            if (!userAlreadyApproved)
    //            {
    //                UnapproveUsers.Add(u);
    //            }
    //        }

    //        // fill General datafield
    //        userDict.Add(EnumK2SingleSourcingDataField.Title, title);
    //        userDict.Add(EnumK2SingleSourcingDataField.SystemCode, systemCode);
    //        userDict.Add(EnumK2SingleSourcingDataField.InitiatorName, string.IsNullOrEmpty(GetEmployeeNameByUserId(createdBy)) ? "-" : GetEmployeeNameByUserId(createdBy));
    //        userDict.Add(EnumK2SingleSourcingDataField.InitiatorUser, mapUser(EnumK2SingleSourcing.SubmissionActivity, UnapproveUsers));
    //        userDict.Add(EnumK2SingleSourcingDataField.DCSApprovalUser, mapUser(EnumK2SingleSourcing.DCSApproval, UnapproveUsers));
    //        userDict.Add(EnumK2SingleSourcingDataField.DCSRecommendationUser, mapUser(EnumK2SingleSourcing.DCSRecommendation, UnapproveUsers));
    //        userDict.Add(EnumK2SingleSourcingDataField.DGUser, mapUser(EnumK2SingleSourcing.DGApproval, UnapproveUsers));
    //        userDict.Add(EnumK2SingleSourcingDataField.HeadOperationApprovalUser, mapUser(EnumK2SingleSourcing.HeadOfOperationApproval, UnapproveUsers));
    //        userDict.Add(EnumK2SingleSourcingDataField.HeadOperationRecommendationUser, mapUser(EnumK2SingleSourcing.HeadOfOperationRecommendation, UnapproveUsers));
    //        userDict.Add(EnumK2SingleSourcingDataField.ProductDescription, productDescription);
    //        userDict.Add(EnumK2SingleSourcingDataField.SupplierName, supplierName);
    //        userDict.Add(EnumK2SingleSourcingDataField.ExpectedDeliveryDate, expectedDeliveryDate);
    //        userDict.Add(EnumK2SingleSourcingDataField.SupervisorApprovalUser, mapUser(EnumK2SingleSourcing.SupervisorApproval, UnapproveUsers));
    //        Log.Information($"Populate user dict for K2 with Dict: \n{JsonConvert.SerializeObject(userDict)}");
    //        return userDict;
    //    }

    //    public static List<K2ActivityUser> GetSingleSourcingActivityUser(DataTable ssObj, string accessManagementToken = "")
    //    {
    //        var createdBy = ssObj.Rows[0]["created_by"].ToString();
    //        var requester = ssObj.Rows[0]["requestor_user_id"].ToString();
    //        var prId = ssObj.Rows[0]["id"].ToString();
    //        decimal.TryParse(ssObj.Rows[0]["po_amt"].ToString().ToLower(), out decimal poAmount);
    //        var dcsUser = ssObj.Rows[0]["dcsUser"].ToString().ToLower();
    //        var dgUser = ssObj.Rows[0]["dgUser"].ToString().ToLower();
    //        var procOffUser = ssObj.Rows[0]["procOffUser"].ToString().ToLower();
    //        int.TryParse(ssObj.Rows[0]["isFromHQ"].ToString().ToLower(), out int isFromHQ);
    //        var themeLeaderUser = ssObj.Rows[0]["themeLeaderUser"].ToString().ToLower();
    //        var continentDirectorUser = ssObj.Rows[0]["continentDirectorUser"].ToString().ToLower();
    //        var procurementLeadUser = ssObj.Rows[0]["procurement_office_lead"].ToString().ToLower();
    //        var teamLeaderAdminUser = ssObj.Rows[0]["teamLeaderAdminUser"].ToString().ToLower();
    //        var cfoUser = ssObj.Rows[0]["cfoUser"].ToString().ToLower();
    //        var activityUserList = new List<K2ActivityUser>();
    //        var isRequiredSupervisorApproval = ssObj.Rows[0]["isRequiredSupervisorApproval"].ToString().ToLower();
    //        var singleSourcingInitiator = ssObj.Rows[0]["singleSourcingInitiator"].ToString().ToLower();
    //        var supervisorUser = GetDirectSupervisorByUserId(singleSourcingInitiator).Rows[0]["UserId"].ToString().ToLower();

    //        #region Get General User
    //        activityUserList.AddRange((GetInitiatorUser(createdBy))
    //            .Where(x => !activityUserList.Select(z => z.Username.ToLower()).Contains(x.UserId.ToLower()))
    //            .Select(x => new K2ActivityUser() { Username = x.UserId, ActivityID = 0 })
    //            );

    //        activityUserList.AddRange((GetInitiatorUser(requester))
    //           .Where(x => !activityUserList.Select(z => z.Username.ToLower()).Contains(x.UserId.ToLower()))
    //           .Select(x => new K2ActivityUser() { Username = x.UserId, ActivityID = 0 })
    //           );

    //        activityUserList.AddRange((GetInitiatorUser(createdBy))
    //           .Select(x => new K2ActivityUser() { Username = x.UserId, ActivityID = 1 })
    //           );
    //        #endregion

    //        #region Get User
    //        // check if SS required supervisor approval
    //        int[] actIdToCompare = { EnumK2SingleSourcing.HeadOfOperationRecommendation, EnumK2SingleSourcing.HeadOfOperationApproval, EnumK2SingleSourcing.SubmissionActivity };

    //        if (poAmount < 5000) // Include TL Admin Approval
    //        {
    //            activityUserList.AddRange(AddUser(teamLeaderAdminUser, prId, EnumK2SingleSourcing.HeadOfOperationApproval, ssObj)
    //                .Select(x => new K2ActivityUser() { Username = x.UserId, ActivityID = EnumK2SingleSourcing.HeadOfOperationApproval })
    //            );
    //        }
    //        else if (poAmount >= 5000 && poAmount < 35000) // Include TL Admin Recommendation, CFO Recommendation, DCS Approval
    //        {
    //            activityUserList.AddRange(AddUser(teamLeaderAdminUser, prId, EnumK2SingleSourcing.HeadOfOperationRecommendation, ssObj)
    //                .Select(x => new K2ActivityUser() { Username = x.UserId, ActivityID = EnumK2SingleSourcing.HeadOfOperationRecommendation })
    //            );

    //            activityUserList.AddRange(AddUser(dcsUser, prId, EnumK2SingleSourcing.DCSApproval, ssObj)
    //                .Select(x => new K2ActivityUser() { Username = x.UserId, ActivityID = EnumK2SingleSourcing.DCSApproval })
    //            );
    //        }
    //        else if (poAmount >= 35000) // Include TL Admin Recommendation, DCS Recommendation, DG Approval
    //        {
    //            activityUserList.AddRange(AddUser(teamLeaderAdminUser, prId, EnumK2SingleSourcing.HeadOfOperationRecommendation, ssObj)
    //                .Select(x => new K2ActivityUser() { Username = x.UserId, ActivityID = EnumK2SingleSourcing.HeadOfOperationRecommendation })
    //            );

    //            activityUserList.AddRange((AddUser(dcsUser, prId, EnumK2SingleSourcing.DCSRecommendation, ssObj))
    //                .Select(x => new K2ActivityUser() { Username = x.UserId, ActivityID = EnumK2SingleSourcing.DCSRecommendation })
    //            );

    //            activityUserList.AddRange((AddUser(dgUser, prId, EnumK2SingleSourcing.DGApproval, ssObj))
    //                .Select(x => new K2ActivityUser() { Username = x.UserId, ActivityID = EnumK2SingleSourcing.DGApproval })
    //            );
    //        }
    //        // This is to handle double role approval
    //        if (isRequiredSupervisorApproval == "1")
    //        {
    //            activityUserList.AddRange(AddUser(supervisorUser, prId, EnumK2SingleSourcing.SupervisorApproval, ssObj)
    //            .Where(x => !activityUserList.Where(y => actIdToCompare.Contains(y.ActivityID)).Select(z => z.Username.ToLower()).Contains(x.UserId.ToLower()))
    //            .Select(x => new K2ActivityUser() { Username = x.UserId, ActivityID = EnumK2SingleSourcing.SupervisorApproval })
    //            );
    //        }
    //        #endregion

    //        return activityUserList;
    //    }

    //    public static List<K2ActivityUser> GetSingleSourcingAllActivityUser(DataTable ssObj, string accessManagementToken = "")
    //    {
    //        var createdBy = ssObj.Rows[0]["created_by"].ToString();
    //        var requester = ssObj.Rows[0]["requestor_user_id"].ToString();
    //        var prId = ssObj.Rows[0]["id"].ToString();
    //        decimal.TryParse(ssObj.Rows[0]["po_amt"].ToString().ToLower(), out decimal poAmount);
    //        var dcsUser = ssObj.Rows[0]["dcsUser"].ToString().ToLower();
    //        var dgUser = ssObj.Rows[0]["dgUser"].ToString().ToLower();
    //        var procOffUser = ssObj.Rows[0]["procOffUser"].ToString().ToLower();
    //        int.TryParse(ssObj.Rows[0]["isFromHQ"].ToString().ToLower(), out int isFromHQ);
    //        var themeLeaderUser = ssObj.Rows[0]["themeLeaderUser"].ToString().ToLower();
    //        var continentDirectorUser = ssObj.Rows[0]["continentDirectorUser"].ToString().ToLower();
    //        var procurementLeadUser = ssObj.Rows[0]["procurement_office_lead"].ToString().ToLower();
    //        var teamLeaderAdminUser = ssObj.Rows[0]["teamLeaderAdminUser"].ToString().ToLower();
    //        var cfoUser = ssObj.Rows[0]["cfoUser"].ToString().ToLower();
    //        var isRequiredSupervisorApproval = ssObj.Rows[0]["isRequiredSupervisorApproval"].ToString().ToLower();
    //        var singleSourcingInitiator = ssObj.Rows[0]["singleSourcingInitiator"].ToString().ToLower();
    //        var supervisorUser = GetDirectSupervisorByUserId(singleSourcingInitiator).Rows[0]["UserId"].ToString().ToLower();

    //        var activityUserList = new List<K2ActivityUser>();

    //        #region Get General User
    //        activityUserList.AddRange((GetInitiatorUser(createdBy))
    //            .Select(x => new K2ActivityUser() { Username = x.UserId, ActivityID = 0 })
    //            );

    //        activityUserList.AddRange((GetInitiatorUser(requester))
    //           .Select(x => new K2ActivityUser() { Username = x.UserId, ActivityID = 0 })
    //           );

    //        activityUserList.AddRange((GetInitiatorUser(createdBy))
    //           .Select(x => new K2ActivityUser() { Username = x.UserId, ActivityID = 1 })
    //           );
    //        #endregion

    //        #region Get User
    //        if (isRequiredSupervisorApproval == "1")
    //        {
    //            activityUserList.AddRange(AddUser(supervisorUser, prId, EnumK2SingleSourcing.SupervisorApproval, ssObj)
    //                    .Select(x => new K2ActivityUser() { Username = x.UserId, ActivityID = EnumK2SingleSourcing.SupervisorApproval })
    //                );
    //        }

    //        activityUserList.AddRange((AddUser(teamLeaderAdminUser, prId, EnumK2SingleSourcing.HeadOfOperationRecommendation, ssObj))
    //        .Select(x => new K2ActivityUser() { Username = x.UserId, ActivityID = EnumK2SingleSourcing.HeadOfOperationRecommendation })
    //        );

    //        activityUserList.AddRange(AddUser(dcsUser, prId, EnumK2SingleSourcing.DCSRecommendation, ssObj)
    //        .Select(x => new K2ActivityUser() { Username = x.UserId, ActivityID = EnumK2SingleSourcing.DCSRecommendation })
    //        );

    //        activityUserList.AddRange((AddUser(teamLeaderAdminUser, prId, EnumK2SingleSourcing.HeadOfOperationApproval, ssObj))
    //        .Select(x => new K2ActivityUser() { Username = x.UserId, ActivityID = EnumK2SingleSourcing.HeadOfOperationApproval })
    //        );

    //        activityUserList.AddRange((AddUser(dcsUser, prId, EnumK2SingleSourcing.DCSApproval, ssObj))
    //        .Select(x => new K2ActivityUser() { Username = x.UserId, ActivityID = EnumK2SingleSourcing.DCSApproval })
    //        );

    //        activityUserList.AddRange((AddUser(dgUser, prId, EnumK2SingleSourcing.DGApproval, ssObj))
    //        .Select(x => new K2ActivityUser() { Username = x.UserId, ActivityID = EnumK2SingleSourcing.DGApproval })
    //        );
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

    //    private static List<Participant> AddUser(string user, string ssId = "", int actId = 0, DataTable ssData = null)
    //    {
    //        List<Participant> listOfPart = new List<Participant>();
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
    //                        if (ssData == null)
    //                        {
    //                            ssData = staticsVendorSelection.Main.GetDataForK2(ssId);
    //                        }
    //                        string poAmount = ssData.Rows[0]["po_amt"]?.ToString();
    //                        var procurementLeadUser = ssData.Rows[0]["procurement_office_lead"].ToString().ToLower();
    //                        var teamLeaderAdminUser = ssData.Rows[0]["teamLeaderAdminUser"].ToString().ToLower();
    //                        string DGO = statics.GetSetting("DirectorGeneralTeamId");
    //                        string DGOE = statics.GetSetting("DirectorGeneralExecutiveTeamId");
    //                        string DCS = statics.GetSetting("DirectorCorporateServiceTeamId");
    //                        string prLeadUserIdOne = GetPRLeadByCode(statics.GetSetting("PRLEADONE")).Rows[0]["UserId"].ToString();
    //                        string prLeadUserIdTwo = GetPRLeadByCode(statics.GetSetting("PRLEADTWO")).Rows[0]["UserId"].ToString();
    //                        var DGOUserId = GetTeamByTeamId(DGO).Rows[0]["TeamLeaderUserId"].ToString().ToLower();
    //                        var DGOEUserId = GetTeamByTeamId(DGOE).Rows[0]["TeamLeaderUserId"].ToString().ToLower();
    //                        bool isInitiator = isUserNameInitiator(ssId, a);
    //                        bool isRequestor = isUserNameRequestor(ssId, a);
    //                        bool isDg = CheckIsUsernameATeamLead(a, DGO);
    //                        bool isDcs = CheckIsUsernameATeamLead(a, DCS);

    //                        if (isInitiator)
    //                        {
    //                            if (actId == EnumK2SingleSourcing.HeadOfOperationRecommendation || actId == EnumK2SingleSourcing.HeadOfOperationApproval)
    //                            {

    //                                var spvData = GetDirectSupervisorByUserId(a);
    //                                Log.Information($"Escalation of the current user : {a} as also initiator of activity id : {actId} with direct supervisor : {JsonConvert.SerializeObject(spvData)}");
    //                                if (spvData != null)
    //                                {
    //                                    if (spvData.Rows.Count > 0)
    //                                    {
    //                                        if (!string.IsNullOrEmpty(spvData.Rows[0]["UserId"].ToString()))
    //                                        {
    //                                            part.UserId = spvData.Rows[0]["UserId"].ToString().ToLower();
    //                                        }
    //                                    }
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

    //        if (!string.IsNullOrEmpty(user))
    //        {
    //            var userArr = user.Split(';').ToList();

    //            if (userArr.Count > 0)
    //            {
    //                foreach (string a in userArr)
    //                {
    //                    var part = new ParticipantMapping
    //                    {
    //                        UserId = a,
    //                        Substitute = ""
    //                    };

    //                    if (!string.IsNullOrEmpty(a))
    //                    {
    //                        if (prData == null)
    //                        {
    //                            prData = staticsVendorSelection.Main.GetDataForK2(prId);
    //                        }
    //                        string prAmount = prData.Rows[0]["po_amt"]?.ToString();
    //                        var procurementLeadUser = prData.Rows[0]["procurement_office_lead"].ToString().ToLower();
    //                        var teamLeaderAdminUser = prData.Rows[0]["teamLeaderAdminUser"].ToString().ToLower();
    //                        string DGO = statics.GetSetting("DirectorGeneralTeamId");
    //                        string DGOE = statics.GetSetting("DirectorGeneralExecutiveTeamId");
    //                        string DCS = statics.GetSetting("DirectorCorporateServiceTeamId");
    //                        string prLeadUserIdOne = GetPRLeadByCode(statics.GetSetting("PRLEADONE")).Rows[0]["UserId"].ToString();
    //                        string prLeadUserIdTwo = GetPRLeadByCode(statics.GetSetting("PRLEADTWO")).Rows[0]["UserId"].ToString();
    //                        string adminLeadUserIdOne = "NNoviantina";
    //                        string adminLeadUserIdTwo = "MKitutu";
    //                        //var DGOUserId = "RNASI".ToLower(); // GetTeamLeaderEmployeeDataByTeamId(DGO).Rows[0]["UserId"].ToString().ToLower();
    //                        //var DGOEUserId = "RPRABHU".ToLower(); // GetTeamLeaderEmployeeDataByTeamId(DGOE).Rows[0]["UserId"].ToString().ToLower();
    //                        var DGOUserId = GetTeamByTeamId(DGO).Rows[0]["TeamLeaderUserId"].ToString().ToLower();
    //                        var DGOEUserId = GetTeamByTeamId(DGOE).Rows[0]["TeamLeaderUserId"].ToString().ToLower();
    //                        bool isInitiator = isUserNameInitiator(prId, a);
    //                        bool isRequestor = isUserNameRequestor(prId, a);
    //                        bool isDg = CheckIsUsernameATeamLead(a, DGO);
    //                        bool isDcs = CheckIsUsernameATeamLead(a, DCS);

    //                        if (isInitiator || isRequestor)
    //                        {
    //                            if (actId == EnumK2SingleSourcing.HeadOfOperationRecommendation || actId == EnumK2SingleSourcing.HeadOfOperationApproval)
    //                            {
    //                                var tlAdminUsers = teamLeaderAdminUser.Split(';').ToList();
    //                                tlAdminUsers.RemoveAll(x => x == "" || x == null);
    //                                if (a.ToLower() == adminLeadUserIdOne)
    //                                {
    //                                    part.UserId = adminLeadUserIdTwo;
    //                                }
    //                                else if (a.ToLower() == adminLeadUserIdTwo)
    //                                {
    //                                    part.UserId = adminLeadUserIdOne;
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
    //                        //}
    //                    }
    //                }
    //            }
    //        }

    //        return listOfPart;
    //    }

    //    private static bool isUserNameInitiator(string poId, string username)
    //    {
    //        var taData = staticsVendorSelection.Main.GetDataForK2(poId);
    //        var initiator = taData.Rows[0]["created_by"].ToString();
    //        Log.Information($"Check isUserNameInitiator with id : {poId} username : {username}, initiator : {initiator}");
    //        var res = false;

    //        if (username.ToLower().Contains(initiator.ToLower()))
    //        {
    //            res = true;
    //            Log.Information($"User is the initiator");
    //        }
    //        return res;
    //    }

    //    private static bool isUserNameRequestor(string prId, string username)
    //    {
    //        var taData = staticsVendorSelection.Main.GetDataForK2(prId);
    //        var requester = taData.Rows[0]["requestor_user_id"].ToString();

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
    //                    ApproveState apvState = new ApproveState
    //                    {
    //                        RelevantId = row["RelevantId"].ToString(),
    //                        Module = row["Module"].ToString(),
    //                        Username = row["Username"].ToString(),
    //                        ActivityId = row["ActivityId"].ToString(),
    //                        State = Convert.ToInt32(row["State"].ToString())
    //                    };

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
    //                    ApproveState apvState = new ApproveState
    //                    {
    //                        RelevantId = row["RelevantId"].ToString(),
    //                        Module = row["Module"].ToString(),
    //                        Username = row["Username"].ToString(),
    //                        ActivityId = row["ActivityId"].ToString(),
    //                        State = Convert.ToInt32(row["State"].ToString())
    //                    };

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
    //            Log.Information($"Success SaveDataLog with object : \n{JsonConvert.SerializeObject(logObj)}");
    //        }
    //        catch (Exception e)
    //        {
    //            //Log.Error("Error on Save Data //Log for ID: " + logObj[0].RelevantId.ToString() + ". Error Message: " + e.Message.ToString());
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
    //        var prData = staticsVendorSelection.Main.GetDataForK2(Id);

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
    //                                            string prAmount = prData.Rows[0]["po_amt"]?.ToString();

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

    //            var parTypeProcurementWF = new string[] { "3" };//Other dan Cash Advance



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
    //        string PIName = string.Empty;

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
    //                // Refers to dbCI_Procurement, [vwdbMasterData_Employee]
    //                if (string.IsNullOrEmpty(PIData.Rows[0]["prefered_name"].ToString()))
    //                {
    //                    PIName = PIData.Rows[0]["first_name"].ToString() + " " + PIData.Rows[0]["last_name"].ToString();
    //                    PIName = PIName.Trim();
    //                }
    //                else
    //                {
    //                    PIName = PIData.Rows[0]["prefered_name"].ToString();
    //                    PIName = PIName.Trim();
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

    //    public static ApprovalNotes GetSSApvNotes(int activityId, string username, string ssId)
    //    {
    //        ApprovalNotes actObj = new ApprovalNotes();

    //        List<int> listActId = new List<int>();
    //        List<string> listStringActivity = new List<string>();
    //        List<string> listStringRole = new List<string>();
    //        string trueBudgetHolder = "";
    //        string _actDesc = "-";
    //        string _actName = "-";
    //        string procOfficeName = "";
    //        string action = "";
    //        bool isReAction = false;
    //        decimal poAmt = 0;

    //        List<ApproveState> aps = GetApprovedUser(ssId, K2ProcessName, username, activityId.ToString(), 0); //ApprovedUser but need to reApprove
    //        if (aps.Count > 0)
    //        {
    //            isReAction = true;
    //        }

    //        if (isReAction)
    //        {
    //            action = "re-";
    //        }

    //        int[] actApprove = new int[] { EnumK2SingleSourcing.SupervisorApproval, EnumK2SingleSourcing.HeadOfOperationApproval, EnumK2SingleSourcing.DCSApproval, EnumK2SingleSourcing.DGApproval };
    //        int[] actRecommend = new int[] { EnumK2SingleSourcing.HeadOfOperationRecommendation, EnumK2SingleSourcing.DCSRecommendation };

    //        if (actApprove.Contains(activityId))
    //        {
    //            action += "approving";
    //        }
    //        else if (actRecommend.Contains(activityId))
    //        {
    //            action += "recommending";
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

    //        DataTable taData = staticsVendorSelection.Main.GetDataForK2(ssId);
    //        if (taData != null)
    //        {
    //            if (taData.Rows.Count > 0)
    //            {
    //                if (!string.IsNullOrEmpty(taData.Rows[0]["procurement_office_name"].ToString()))
    //                {
    //                    procOfficeName = taData.Rows[0]["procurement_office_name"].ToString();
    //                }

    //                decimal.TryParse(taData.Rows[0]["po_amt"].ToString().ToLower(), out poAmt);
    //            }
    //        }

    //        List<K2ActivityUser> allActivityUser = GetSingleSourcingAllActivityUser(taData);

    //        foreach (K2ActivityUser user in allActivityUser)
    //        {
    //            if (user.Username.ToLower() == username.ToLower())
    //            {
    //                listActId.Add(user.ActivityID);
    //            }
    //        }

    //        Log.Information("Start Apv Notes. Quotation analysis Id: " + ssId);

    //        if (listActId.Count > 0)
    //        {
    //            Log.Information("listActId count: " + listActId.Count);
    //            Log.Information($"All activity user : \n{JsonConvert.SerializeObject(allActivityUser)}");
    //            listActId.RemoveAll(item => item == 0);
    //            if (activityId != EnumK2SingleSourcing.SubmissionActivity)
    //            {
    //                listActId.RemoveAll(item => item == EnumK2SingleSourcing.SubmissionActivity);
    //            }

    //            /* Recommendations */

    //            if (activityId == EnumK2SingleSourcing.HeadOfOperationRecommendation)
    //            {
    //                listActId.RemoveAll(item => item == EnumK2SingleSourcing.HeadOfOperationApproval);
    //            }

    //            if (activityId == EnumK2SingleSourcing.DCSRecommendation)
    //            {
    //                listActId.RemoveAll(item => item == EnumK2SingleSourcing.DCSApproval);
    //            }

    //            /* Approval */

    //            if (activityId == EnumK2SingleSourcing.HeadOfOperationApproval)
    //            {
    //                listActId.RemoveAll(item => item == EnumK2SingleSourcing.HeadOfOperationRecommendation); // Remove TL Admin Recommendation Apv Note (2)
    //            }

    //            if (activityId == EnumK2SingleSourcing.DCSApproval)
    //            {
    //                listActId.RemoveAll(item => item == EnumK2SingleSourcing.DCSRecommendation);
    //            }

    //            listActId.RemoveAll(item => item > activityId);

    //            listActId.Reverse();

    //            listActId = listActId.Select(x => x).Distinct().ToList();

    //            Log.Information("List Activity Id to be build in Apv Notes: ");
    //            foreach (int actId in listActId)
    //            {
    //                Log.Information(actId.ToString());
    //            }

    //            var wordingForProcOffice = "Procurement Office " + procOfficeName;

    //            Dictionary<int, string> dictOfActivity = new Dictionary<int, string>
    //                {
    //                    {EnumK2SingleSourcing.SubmissionActivity, "Submission/Resubmission" },
    //                    {EnumK2SingleSourcing.SupervisorApproval, "Direct Supervisor Approval" },
    //                    {EnumK2SingleSourcing.HeadOfOperationRecommendation, "Head of Operation Recommendation" },
    //                    {EnumK2SingleSourcing.DCSRecommendation, "Director Corporate Service Recommendation" },
    //                    {EnumK2SingleSourcing.HeadOfOperationApproval, "Head of Operation Approval" },
    //                    {EnumK2SingleSourcing.DCSApproval, "Director Corporate Service Approval" },
    //                    {EnumK2SingleSourcing.DGApproval, "Director General Approval" }
    //                };

    //            Dictionary<int, string> dictOfRole = new Dictionary<int, string>
    //                {
    //                    {EnumK2SingleSourcing.SubmissionActivity, "Initiator" },
    //                    {EnumK2SingleSourcing.SupervisorApproval, "Direct Supervisor Approval" },
    //                    {EnumK2SingleSourcing.HeadOfOperationRecommendation, "Head of Operation Recommendation" },
    //                    {EnumK2SingleSourcing.DCSRecommendation, "Director Corporate Service Recommendation"  },
    //                    {EnumK2SingleSourcing.HeadOfOperationApproval, "Head of Operation Approval" },
    //                    {EnumK2SingleSourcing.DCSApproval, "Director Corporate Service Approval" },
    //                    {EnumK2SingleSourcing.DGApproval, "Director General Approval" },
    //                };

    //            // Sort the activity id
    //            listActId.Sort();

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

    //            Log.Information("Pass through all Apv Notes Builder. Id: " + ssId);
    //            var maxDataLogNextSeqNo = GetDataLogNextSeqNo(ssId, K2ProcessName);
    //            var maxSeqNoDataLog = maxDataLogNextSeqNo < 1 ? maxDataLogNextSeqNo : maxDataLogNextSeqNo - 1;

    //            if (isReAction && maxSeqNoDataLog > 1)
    //            {
    //                Log.Information("Start Apv Notes Wording for re-action. Id: " + ssId);
    //                string[] separator = { "||" };

    //                #region Penambahan Wording Apv Notes Untuk Resubmission dan Jika ada perubahan data
    //                Dictionary<string, string> oldGrantData = GetListOlderDataLog(ssId, K2ProcessName);
    //                Dictionary<string, string> newGrantData = GetListCurrentDataLog(ssId, K2ProcessName);
    //                List<DifferentData> listDiff = new List<DifferentData>();

    //                var oldprodDesc = oldGrantData.Where(x => x.Key.ToLower() == "ProductDescription".ToLower()).Select(y => y.Value).FirstOrDefault().ToString();
    //                var oldProdDescArray = oldprodDesc.Split(separator, StringSplitOptions.None);
    //                Log.Information("Get old prod desc done. Id: " + ssId);

    //                var newprodDesc = newGrantData.Where(x => x.Key.ToLower() == "ProductDescription".ToLower()).Select(y => y.Value).FirstOrDefault().ToString();
    //                var newProdDescArray = newprodDesc.Split(separator, StringSplitOptions.None);
    //                Log.Information("Get new prod desc done. Id: " + ssId);

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
    //                Log.Information("Move old prod desc into object done. Id: " + ssId);

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
    //                Log.Information("Move new prod desc into object done. Id: " + ssId);

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
    //                        if (diff.FieldName.ToLower().Equals("PurchaseOrderAmount".ToLower()))
    //                        {
    //                            Log.Information("Build PurchaseOrderAmount reaction apv notes. Id: " + ssId);

    //                            string prAmtOld = "";
    //                            prAmtOld = diff.OldValue.ToString().ToLower();
    //                            prAmtOld = string.IsNullOrEmpty(prAmtOld) ? "unspecified purchase order amount" : prAmtOld;

    //                            string prAmtNew = "";
    //                            prAmtNew = diff.NewValue.ToString().ToLower();
    //                            prAmtNew = string.IsNullOrEmpty(prAmtNew) ? "unspecified purchase order amount" : prAmtNew;

    //                            listStringActivity.Add("Change of total cost estimated from USD " + String.Format("{0:N2}", Convert.ToDecimal(prAmtOld)) + " to USD " + String.Format("{0:N2}", Convert.ToDecimal(prAmtNew)));
    //                        }
    //                        else if (diff.FieldName.ToLower().Equals("Product".ToLower()))
    //                        {
    //                            Log.Information("Build Product reaction apv notes. Id: " + ssId);

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
    //                            Log.Information("Build Product reaction apv notes. move old product record to object done. Id: " + ssId);

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
    //                            Log.Information("Build Product reaction apv notes. move new product record to object done. Id: " + ssId);

    //                            oldData.OrderBy(x => x.Id);
    //                            newData.OrderBy(x => x.Id);

    //                            foreach (PurchaseRequisitionProductObject newDataObj in newData)
    //                            {
    //                                Log.Information("Build Product reaction apv notes. Going into Foreach. Id: " + ssId);
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
    //                                            Log.Information("Build Product reaction apv notes. There differences in Product record. Id: " + ssId);

    //                                            var newProdId = newDataObj.ItemCode.ToUpper();
    //                                            var newProdDescListCnt = newProdDescList.Count;
    //                                            Log.Information("Build Product reaction apv notes. newProdDescListCnt :" + newProdDescListCnt.ToString() + ". Id: " + ssId);
    //                                            Log.Information("Build Product reaction apv notes. newDataObj.PurchaseRequisitionId  :" + newDataObj.PurchaseRequisitionId.ToString() + ". Id: " + ssId);
    //                                            Log.Information("Build Product reaction apv notes. newDataObj.Id  :" + newDataObj.Id.ToString() + ". Id: " + ssId);
    //                                            Log.Information("Build Product reaction apv notes. newDataObj.ItemCode  :" + newDataObj.ItemCode.ToString() + ". Id: " + ssId);
    //                                            Log.Information("Build Product reaction apv notes. newDataObj.IsActive  :" + newDataObj.IsActive.ToString() + ". Id: " + ssId);
    //                                            var newDescription = "";
    //                                            var newDescObj = newProdDescList.Where(x => x.PurchaseRequisitionId.ToUpper() == newDataObj.PurchaseRequisitionId.ToUpper()
    //                                                                                         && x.Id.ToUpper() == newDataObj.Id.ToUpper()
    //                                                                                         && x.ItemCode.ToUpper() == newDataObj.ItemCode.ToUpper()
    //                                                                                         && x.IsActive.ToUpper() == newDataObj.IsActive.ToUpper()).FirstOrDefault();
    //                                            if (newDescObj != null)
    //                                            {
    //                                                newDescription = newDescObj.Description.ToString();
    //                                            }
    //                                            Log.Information("Build Product reaction apv notes. newDescription :" + newDescription + ". Id: " + ssId);
    //                                            Log.Information("Build Product reaction apv notes. Get new Prod Desc done. Id: " + ssId);
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
    //                                            Log.Information("Build Product reaction apv notes. oldDescription :" + oldDescription + ". Id: " + ssId);
    //                                            Log.Information("Build Product reaction apv notes. Get old Prod Desc done. Id: " + ssId);
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
    //                            Log.Information("Build ChargeCode reaction apv notes. Id: " + ssId);

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

    //                Log.Information("Finish Apv Notes Wording for re-action. Id" + ssId);
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



    //    public static List<K2ActivityUserMapping> GetSSAllActivityUserWithSubstitute(DataTable prObj)
    //    {
    //        var createdBy = prObj.Rows[0]["created_by"].ToString();
    //        var requester = prObj.Rows[0]["requestor_user_id"].ToString();
    //        var prId = prObj.Rows[0]["id"].ToString();
    //        decimal.TryParse(prObj.Rows[0]["po_amt"].ToString().ToLower(), out decimal poAmount);
    //        var dcsUser = prObj.Rows[0]["dcsUser"].ToString().ToLower();
    //        var dgUser = prObj.Rows[0]["dgUser"].ToString().ToLower();
    //        var procOffUser = prObj.Rows[0]["procOffUser"].ToString().ToLower();
    //        int.TryParse(prObj.Rows[0]["isFromHQ"].ToString().ToLower(), out int isFromHQ);
    //        var themeLeaderUser = prObj.Rows[0]["themeLeaderUser"].ToString().ToLower();
    //        var continentDirectorUser = prObj.Rows[0]["continentDirectorUser"].ToString().ToLower();
    //        var procurementLeadUser = prObj.Rows[0]["procurement_office_lead"].ToString().ToLower();
    //        var teamLeaderAdminUser = prObj.Rows[0]["teamLeaderAdminUser"].ToString().ToLower();
    //        var cfoUser = prObj.Rows[0]["cfoUser"].ToString().ToLower();

    //        var activityUserList = new List<K2ActivityUserMapping>();

    //        #region Get General User
    //        activityUserList.AddRange((GetInitiatorUser(createdBy))
    //            .Select(x => new K2ActivityUserMapping() { Username = x.UserId, ActivityId = 0, Substitute = "" })
    //            );

    //        activityUserList.AddRange((GetInitiatorUser(requester))
    //           .Select(x => new K2ActivityUserMapping() { Username = x.UserId, ActivityId = 0, Substitute = "" })
    //           );

    //        activityUserList.AddRange((GetInitiatorUser(createdBy))
    //           .Select(x => new K2ActivityUserMapping() { Username = x.UserId, ActivityId = 1, Substitute = "" })
    //           );
    //        #endregion

    //        activityUserList.AddRange(AddUserSubsMapping(teamLeaderAdminUser, prId, EnumK2SingleSourcing.HeadOfOperationApproval, prObj)
    //            .Select(x => new K2ActivityUserMapping() { Username = x.UserId, ActivityId = EnumK2SingleSourcing.HeadOfOperationApproval, Substitute = x.Substitute })
    //            );

    //        activityUserList.AddRange(AddUserSubsMapping(teamLeaderAdminUser, prId, EnumK2SingleSourcing.HeadOfOperationRecommendation, prObj)
    //            .Select(x => new K2ActivityUserMapping() { Username = x.UserId, ActivityId = EnumK2SingleSourcing.HeadOfOperationRecommendation, Substitute = x.Substitute })
    //            );

    //        return activityUserList;
    //    }
    //}
}
