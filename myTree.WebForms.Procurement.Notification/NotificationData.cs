using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using myTree.WebForms.Procurement.General;

namespace myTree.WebForms.Procurement.Notification
{
    public class NotificationData
    {
        private static string app_name = statics.GetSetting("App_Pool_Name");

        public class PurchaseRequisition
        {

            public static DataSet WaitingForVerification(string id)
            {
                database db = new database();
                db.ClearParameters();
                db.SPName = "dbo.spNotification_PR_WaitingForVerification";
                db.AddParameter("@id", SqlDbType.VarChar, id);
                db.AddParameter("@home_url", SqlDbType.NVarChar, string.Format("{0}{1}", statics.GetSetting("myTree_URL"), app_name));
                DataSet ds = db.ExecuteSP();

                db.Dispose();
                return ds;
            }

            public static DataSet WaitingForpayment(string id)
            {
                database db = new database();
                db.ClearParameters();
                db.SPName = "dbo.spNotification_PR_WaitingForPayment";
                db.AddParameter("@id", SqlDbType.VarChar, id);
                db.AddParameter("@home_url", SqlDbType.NVarChar, string.Format("{0}{1}", statics.GetSetting("myTree_URL"), app_name));
                DataSet ds = db.ExecuteSP();

                db.Dispose();
                return ds;
            }

            public static DataSet WaitingForVerificationUser(string id)
            {
                database db = new database();
                db.ClearParameters();
                db.SPName = "dbo.spNotification_PR_WaitingForVerificationUser";
                db.AddParameter("@id", SqlDbType.VarChar, id);
                db.AddParameter("@home_url", SqlDbType.NVarChar, string.Format("{0}{1}", statics.GetSetting("myTree_URL"), app_name));
                DataSet ds = db.ExecuteSP();

                db.Dispose();
                return ds;
            }

            public static DataSet WaitingForVerificationFinance(string id)
            {
                database db = new database();
                db.ClearParameters();
                db.SPName = "dbo.spNotification_PR_WaitingForVerificationFinance";
                db.AddParameter("@id", SqlDbType.VarChar, id);
                db.AddParameter("@home_url", SqlDbType.NVarChar, string.Format("{0}{1}", statics.GetSetting("myTree_URL"), app_name));
                DataSet ds = db.ExecuteSP();

                db.Dispose();
                return ds;
            }

            public static DataSet Verified(string id)
            {
                database db = new database();
                db.ClearParameters();
                db.SPName = "dbo.spNotification_PR_Verified";
                db.AddParameter("@id", SqlDbType.VarChar, id);
                DataSet ds = db.ExecuteSP();

                db.Dispose();
                return ds;
            }

            public static DataSet Cancelled(string id)
            {
                database db = new database();
                db.ClearParameters();
                db.SPName = "dbo.spNotification_PR_Cancelled";
                db.AddParameter("@id", SqlDbType.VarChar, id);
                db.AddParameter("@home_url", SqlDbType.NVarChar, string.Format("{0}{1}", statics.GetSetting("myTree_URL"), app_name));
                DataSet ds = db.ExecuteSP();

                db.Dispose();
                return ds;
            }

            public static DataSet Rejected(string id)
            {
                database db = new database();
                db.ClearParameters();
                db.SPName = "dbo.spNotification_PR_Rejected";
                db.AddParameter("@id", SqlDbType.VarChar, id);
                db.AddParameter("@home_url", SqlDbType.NVarChar, string.Format("{0}{1}", statics.GetSetting("myTree_URL"), app_name));
                DataSet ds = db.ExecuteSP();

                db.Dispose();
                return ds;
            }

            public static DataSet VerifiedFinance(string id)
            {
                database db = new database();
                db.ClearParameters();
                db.SPName = "dbo.spNotification_PR_VerifiedFinance";
                db.AddParameter("@id", SqlDbType.VarChar, id);
                db.AddParameter("@home_url", SqlDbType.NVarChar, string.Format("{0}{1}", statics.GetSetting("myTree_URL"), app_name));
                DataSet ds = db.ExecuteSP();

                db.Dispose();
                return ds;
            }

            public static DataSet Closed()
            {
                database db = new database();
                db.ClearParameters();
                db.SPName = "dbo.spNotification_PR_Closed";
                db.AddParameter("@home_url", SqlDbType.NVarChar, string.Format("{0}{1}", statics.GetSetting("myTree_URL"), app_name));
                DataSet ds = db.ExecuteSP();

                db.Dispose();
                return ds;
            }

            public static DataSet ChangeChargeCodeToBudgetHolder(string id)
            {
                database db = new database();
                db.ClearParameters();
                db.SPName = "dbo.spNotification_PR_ChangeChargeCodeToBudgetHolder";
                db.AddParameter("@id", SqlDbType.VarChar, id);
                db.AddParameter("@home_url", SqlDbType.NVarChar, string.Format("{0}{1}", statics.GetSetting("myTree_URL"), app_name));
                DataSet ds = db.ExecuteSP();

                db.Dispose();
                return ds;
            }
        }

        public class RFQ
        {
            public static DataSet SendToVendor(string id)
            {
                database db = new database();
                db.ClearParameters();
                db.SPName = "dbo.spNotification_RFQ_SendToVendor";
                db.AddParameter("@id", SqlDbType.VarChar, id);
                db.AddParameter("@user_id", SqlDbType.VarChar, statics.GetLogonUsername());
                DataSet ds = db.ExecuteSP();

                db.Dispose();
                return ds;
            }

            public static DataSet Due(string dueDate)
            {
                database db = new database();
                db.ClearParameters();
                db.SPName = "dbo.spNotificationReminder_RFQ_Due";
                db.AddParameter("@dueDate", SqlDbType.VarChar, dueDate);
                db.AddParameter("@home_url", SqlDbType.NVarChar, string.Format("{0}{1}", statics.GetSetting("myTree_URL"), app_name));
                DataSet ds = db.ExecuteSP();

                db.Dispose();
                return ds;
            }
        }

        public class UserConfirmation
        {
            public static DataSet SendConfirmation()
            {
                database db = new database();
                db.ClearParameters();
                db.SPName = "dbo.spNotification_UserConfirmation_SendConfirmation";
                DataSet ds = db.ExecuteSP();

                db.Dispose();
                return ds;
            }

            public static DataSet AutoConfirmation()
            {
                database db = new database();
                db.ClearParameters();
                db.SPName = "dbo.spNotification_UserConfirmation_AutoConfirmation";
                DataSet ds = db.ExecuteSP();

                db.Dispose();
                return ds;
            }

            public static DataSet UserConfirmationConfirmed(string id)
            {
                database db = new database();
                db.ClearParameters();
                db.SPName = "dbo.spNotification_UserConfirmation_Confirmed";
                db.AddParameter("@id", SqlDbType.VarChar, id);
                DataSet ds = db.ExecuteSP();

                db.Dispose();
                return ds;
            }
        }

        public class PurchaseOrder
        {
            public static DataSet Approved(string id)
            {
                database db = new database();
                db.ClearParameters();
                db.SPName = "dbo.spNotification_PO_Approved";
                db.AddParameter("@id", SqlDbType.VarChar, id);
                db.AddParameter("@home_url", SqlDbType.NVarChar, string.Format("{0}{1}", statics.GetSetting("myTree_URL"), app_name));
                DataSet ds = db.ExecuteSP();

                db.Dispose();
                return ds;
            }

            public static DataSet ApprovedToUser(string id)
            {
                database db = new database();
                db.ClearParameters();
                db.SPName = "dbo.spNotification_PO_ApprovedToUser";
                db.AddParameter("@id", SqlDbType.VarChar, id);
                db.AddParameter("@home_url", SqlDbType.NVarChar, string.Format("{0}{1}", statics.GetSetting("myTree_URL"), app_name));
                DataSet ds = db.ExecuteSP();

                db.Dispose();
                return ds;
            }

            public static DataSet SendToVendor(string id)
            {
                database db = new database();
                db.ClearParameters();
                db.SPName = "dbo.spNotification_PO_SendToVendor";
                db.AddParameter("@id", SqlDbType.VarChar, id);
                DataSet ds = db.ExecuteSP();

                db.Dispose();
                return ds;
            }

            public static DataSet Delivery(string dueDate)
            {
                database db = new database();
                db.ClearParameters();
                db.SPName = "dbo.spNotificationReminder_PO_Delivery";
                db.AddParameter("@dueDate", SqlDbType.VarChar, dueDate);
                db.AddParameter("@home_url", SqlDbType.NVarChar, string.Format("{0}{1}", statics.GetSetting("myTree_URL"), app_name));
                DataSet ds = db.ExecuteSP();

                db.Dispose();
                return ds;
            }

            public static DataSet Undelivered(string dueDate)
            {
                database db = new database();
                db.ClearParameters();
                db.SPName = "dbo.spNotificationReminder_PO_Undelivered";
                db.AddParameter("@dueDate", SqlDbType.VarChar, dueDate);
                db.AddParameter("@home_url", SqlDbType.NVarChar, string.Format("{0}{1}", statics.GetSetting("myTree_URL"), app_name));
                DataSet ds = db.ExecuteSP();

                db.Dispose();
                return ds;
            }
        }

        public class QuotationAnalysis
        {
            public static DataSet ApprovedSS(string id)
            {
                database db = new database();
                db.ClearParameters();
                db.SPName = "dbo.spNotification_VS_Approved";
                db.AddParameter("@id", SqlDbType.VarChar, id);
                db.AddParameter("@home_url", SqlDbType.NVarChar, string.Format("{0}{1}", statics.GetSetting("myTree_URL"), app_name));
                DataSet ds = db.ExecuteSP();

                db.Dispose();
                return ds;
            }

            public static DataSet RejectedSS(string id)
            {
                database db = new database();
                db.ClearParameters();
                db.SPName = "dbo.spNotification_VS_Rejected";
                db.AddParameter("@id", SqlDbType.VarChar, id);
                db.AddParameter("@home_url", SqlDbType.NVarChar, string.Format("{0}{1}", statics.GetSetting("myTree_URL"), app_name));
                DataSet ds = db.ExecuteSP();

                db.Dispose();
                return ds;
            }

            public static DataSet CancelledSS(string id)
            {
                database db = new database();
                db.ClearParameters();
                db.SPName = "dbo.spNotification_VS_Cancelled";
                db.AddParameter("@id", SqlDbType.VarChar, id);
                db.AddParameter("@home_url", SqlDbType.NVarChar, string.Format("{0}{1}", statics.GetSetting("myTree_URL"), app_name));
                DataSet ds = db.ExecuteSP();

                db.Dispose();
                return ds;
            }

        }
    }
}
