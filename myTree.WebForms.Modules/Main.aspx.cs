using myTree.WebForms.Procurement.General;
using System;

namespace myTree.WebForms.Modules
{
    public partial class Main : System.Web.UI.Page
    {
        protected UserRoleAccess userRoleAccessList = AccessControl.GetUserRoleAccess(AccessControlObjectEnum.ProcurementPurchaseRequisitionList);
        protected string based_url = string.Empty;
        protected string[] nonProcurementOfficerRoles = { AccessControlRoleNameEnum.Finance, AccessControlRoleNameEnum.User, AccessControlRoleNameEnum.FinanceLead };
        protected void Page_Load(object sender, EventArgs e)
        {
            based_url = statics.GetSetting("based_url");
        }

        protected UserRoleAccess roleAccess(string objectName)
        {
            return AccessControl.GetUserRoleAccess(objectName);
        }
    }
}