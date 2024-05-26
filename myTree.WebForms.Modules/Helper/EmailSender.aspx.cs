using myTree.WebForms.Procurement.Notification;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace myTree.WebForms.Modules.Helper
{
    public partial class EmailSender : System.Web.UI.Page
    {
        protected string email_type, module_id, template_no, result, param_date, indays;
        protected void Page_Load(object sender, EventArgs e)
        {
            result = string.Empty;


            if (IsPostBack)
            {
                email_type = Request.Form["email_type"].ToString();
                module_id = Request.Form["module_id"].ToString();
                template_no = Request.Form["template_no"].ToString();
                param_date = Request.Form["param_date"].ToString();
                indays = Request.Form["indays"].ToString();

                switch (email_type)
                {
                    case "prclearance":
                        NotificationHelper.PR_WaitingForVerification(module_id);
                        break;
                    case "prclearanceuser":
                        NotificationHelper.PR_WaitingForVerificationUser(module_id);
                        break;
                    case "prclearancefinance":
                        NotificationHelper.PR_WaitingForVerificationFinance(module_id);
                        break;
                    case "prwaitforpayment":
                        NotificationHelper.PR_WaitingForPayment(module_id);
                        break;
                    case "prverified":
                        NotificationHelper.PR_Verified(module_id);
                        break;
                    case "prverifiedfinance":
                        NotificationHelper.PR_VerifiedFinance(module_id);
                        break;
                    case "prclosed":
                        NotificationHelper.PR_Closed();
                        break;
                    case "prcancelled":
                        NotificationHelper.PR_Cancelled(module_id);
                        break;
                    case "prrejected":
                        NotificationHelper.PR_Rejected(module_id);
                        break;
                    case "prchangechargecode":
                        NotificationHelper.PR_ChangeChargeCodeToBudgetHolder(module_id);
                        break;
                    case "rfqsendtovendor":
                        NotificationHelper.RFQ_SendToVendorEmail(module_id, template_no);
                        break;
                    case "rfqdue":
                        NotificationHelper.RFQ_Due(param_date);
                        break;
                    //case "itemconfirmation":
                    //    NotificationHelper.UserConfirmation_Send();
                    //    break;
                    //case "autoconfirmation":
                    //    NotificationHelper.UserConfirmation_AutoConfirm();
                        //break;
                    case "poapproved":
                        NotificationHelper.PO_Approved(module_id);
                        break;
                    case "poapproveduser":
                        NotificationHelper.PO_ApprovedToUser(module_id);
                        break;
                    case "potovendor":
                        NotificationHelper.PO_ToVendor(module_id);
                        break;
                    case "podelivery":
                        NotificationHelper.PO_Delivery(param_date);
                        break;
                    case "poundelivered":
                        NotificationHelper.PO_Undelivered(param_date);
                        break;
                    default:
                        break;
                }
            }
        }
    }
}