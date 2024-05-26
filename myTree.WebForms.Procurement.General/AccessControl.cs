using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Linq;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Security.Claims;
using System.Text;
using System.Web;

namespace myTree.WebForms.Procurement.General
{
    public class AccessControl
    {
        protected string _UserId;
        protected string moduleName;

        protected string can_read; //view
        protected string can_write; //edit
        protected string can_swtw; //swtw
        protected string can_file_access; //file_access

        public string redirectPage = statics.GetSetting("redirect_page");
        public string user_group_id = "";
        public Boolean admin, finance, procurement_user;

        public AccessControl()
        {
            InitAccessControl("", "");
        }

        public AccessControl(string module)
        {
            InitAccessControl(module, "");
        }

        private void InitAccessControl(string module, string id)
        {
            _UserId = statics.GetLogonUsername();
            moduleName = module;

            DataRow dr = CheckAccessControlModuleStatus(_UserId, moduleName);
            can_read = dr["can_read"].ToString();
            can_write = dr["can_write"].ToString();
            can_swtw = dr["can_swtw"].ToString();
            can_file_access = dr["can_file_access"].ToString();
            user_group_id = dr["group_name"].ToString();
            admin = user_group_id.ToLower() == "procurement_admin" && can_swtw == "1" ? true : false;
            finance = user_group_id.ToLower() == "finance" ? true : false;
            procurement_user = user_group_id.ToLower() == "procurement_user" ? true : false;
        }

        private DataRow CheckAccessControlModuleStatus(string username, string moduleName)
        {
            database db = new database();
            db.ClearParameters();
            db.SPName = "sp_AccessControl_GetAccessByModule";
            db.AddParameter("@username", SqlDbType.NVarChar, username.ToLower());
            db.AddParameter("@module_name", SqlDbType.NVarChar, moduleName.ToLower());
            DataSet ds1 = db.ExecuteSP();
            db.Dispose();
            if (ds1.Tables[0] != null)
            {
                return ds1.Tables[0].Rows[0];
            }
            else
            {
                return null;
            }
        }

        public Boolean isCanRead()
        {
            return can_read == "1";
        }

        public Boolean isCanWrite()
        {
            return can_write == "1";
        }

        public Boolean isCanSWTW()
        {
            return can_swtw == "1";
        }

        public Boolean isCanFileAccess()
        {
            return can_file_access == "1";
        }

        public static string GetSetting(string KeyName)
        {
            string SettingValue = "";
            try
            {
                SettingValue = ConfigurationManager.AppSettings[KeyName].ToString();
            }
            catch (Exception ex)
            {
                throw new Exception("Key: " + KeyName + " not found");
            }

            return SettingValue;
        }

        public static string GetAccessToken()
        {
            string strAccessToken = string.Empty;
            var identity = HttpContext.Current.User.Identity as ClaimsIdentity;

            IEnumerable<Claim> claim = identity.Claims;

            var accessTokenClaim = claim
                .Where(x => x.Type == "access_token")
                .FirstOrDefault();
            if (accessTokenClaim != null)
            {
                strAccessToken = accessTokenClaim.Value.ToString();
            }

            return strAccessToken;
        }

        public static UserRoleAccess GetUserRoleAccess(string username, string objectName, string accessToken)
        {
            var userRoleAccess = new UserRoleAccess();
            try
            {

                var client = new HttpClient();
                client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", accessToken);
                string accessManagementUrl = ConfigurationManager.AppSettings["AccessManagementUrl"];

                string payload = JsonConvert.SerializeObject(new
                {
                    username,
                    objectName,
                });
                var result = client.PostAsync(accessManagementUrl + "/GetUserRoleAccess?username=" + username + "&objectName=" + objectName, new StringContent(payload, Encoding.UTF8, "application/json")).Result;
                result.EnsureSuccessStatusCode();
                if (result.IsSuccessStatusCode)
                {
                    var str = result.Content.ReadAsStringAsync().Result;
                    userRoleAccess = JsonConvert.DeserializeObject<UserRoleAccess>(result.Content.ReadAsStringAsync().Result);
                }
            }
            catch
            {
                userRoleAccess = new UserRoleAccess();
            }
            return userRoleAccess;
        }

        public static UserRoleAccess GetUserRoleAccess(string objectName)
        {
            var userRoleAccess = new UserRoleAccess();
            string username = statics.GetLogonUsername();
            try
            {
                var client = new HttpClient();
                client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", GetAccessToken());
                string accessManagementUrl = ConfigurationManager.AppSettings["AccessManagementUrl"];

                string payload = JsonConvert.SerializeObject(new
                {
                    username,
                    objectName,
                });
                var result = client.PostAsync(accessManagementUrl + "/GetUserRoleAccess?username=" + username + "&objectName=" + objectName, new StringContent(payload, Encoding.UTF8, "application/json")).Result;
                result.EnsureSuccessStatusCode();
                if (result.IsSuccessStatusCode)
                {
                    var str = result.Content.ReadAsStringAsync().Result;
                    userRoleAccess = JsonConvert.DeserializeObject<UserRoleAccess>(result.Content.ReadAsStringAsync().Result);
                }
            }
            catch
            {
                userRoleAccess = new UserRoleAccess();
            }
            return userRoleAccess;

        }

        public List<UserRoleAccess> GetUsersByRoleAndObjectName(string roleNameInSystem, string objectName, string accessToken)
        {
            var userRoleAccessList = new List<UserRoleAccess>();
            try
            {
                var client = new HttpClient();
                client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", accessToken);
                string accessManagementUrl = ConfigurationManager.AppSettings["AccessManagementUrl"];
                string payload = JsonConvert.SerializeObject(new
                {
                    roleNameInSystem,
                    objectName,
                });
                var result = client.PostAsync(accessManagementUrl + "/GetUsersByRoleAndObjectName?roleNameInSystem=" + roleNameInSystem + "&objectName=" + objectName, new StringContent(payload, Encoding.UTF8, "application/json")).Result;
                result.EnsureSuccessStatusCode();
                if (result.IsSuccessStatusCode)
                {
                    var str = result.Content.ReadAsStringAsync().Result;
                    userRoleAccessList = JsonConvert.DeserializeObject<List<UserRoleAccess>>(result.Content.ReadAsStringAsync().Result);
                    var x = 0;
                }
            }
            catch
            {
                userRoleAccessList = new List<UserRoleAccess>();
            }
            return userRoleAccessList;
        }
    }
    public class UserRoleAccess
    {
        public string RoleName;
        public string RoleNameInSystem;
        public string ObjectName;
        public string Username;
        public string RoleDescription;
        public bool isCanRead;
        public bool isCanDownload;
        public bool isCanWrite;
        public bool isCanOverride;
        public bool isCanInitiate;
        public bool isAct;
        public bool isMasking;
    }

    public static class AccessControlObjectEnum
    {
        public const string Procurement = "Procurement";
        public const string ProcurementPurchaseRequisition = "Procurement.PurchaseRequisition";
        public const string ProcurementPurchaseRequisitionList = "Procurement.PurchaseRequisition.List";
        public const string ProcurementPurchaseRequisitionTaskist = "Procurement.PurchaseRequisition.Tasklist";
        public const string ProcurementRFQ = "Procurement.RFQ";
        public const string ProcurementRFQList = "Procurement.RFQ.List";
        public const string ProcurementQuotation = "Procurement.Quotation";
        public const string ProcurementQuotationList = "Procurement.Quotation.List";
        public const string ProcurementQuotationAnalysis = "Procurement.QuotationAnalysis";
        public const string ProcurementQuotationAnalysisList = "Procurement.QuotationAnalysis.List";
        public const string ProcurementPurchaseOrder = "Procurement.PurchaseOrder";
        public const string ProcurementPurchaseOrderList = "Procurement.PurchaseOrder.List";
        public const string ProcurementSupplier = "Procurement.Supplier";
        public const string ProcurementSupplierList = "Procurement.Supplier.List";
        public const string ProcurementItemClosure = "Procurement.ItemClosure";
        public const string ProcurementDirectPurchase = "Procurement.DirectPurchase";
    }

    public static class AccessControlRoleNameEnum
    {
        public const string ProcurementLead = "Procurement.ProcurementLead";
        public const string ProcurementOfficer = "Procurement.ProcurementOfficer";
        public const string ProcurementAssistant = "Procurement.ProcurementAssistant";
        public const string Finance = "finance";
        public const string FinanceLead = "Procurement.FinanceLead";
        public const string User = "user";
        public const string CountryLead = "Procurement.CountryLead";
    }
}
