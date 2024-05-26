using myTree.WebForms.Procurement.General;
using Newtonsoft.Json;
using System;
using System.Data;
using System.Web.Services;

namespace myTree.WebForms.Modules
{
    public partial class AuditTrail : System.Web.UI.Page
    {
        protected string module = string.Empty;
        private string id = string.Empty;

        private DataTable dtComment = new DataTable();
        private DataTable dtChanges = new DataTable();

        protected string listComment = string.Empty;
        protected string listChanges = string.Empty;

        protected void Page_Load(object sender, EventArgs e)
        {
            module = Request.QueryString["module"] ?? "";
            id = Request.QueryString["id"] ?? "";

            string comment_module = module;
            switch (module.ToLower())
            {
                case "purchaserequisition":
                    comment_module = "PURCHASE REQUISITION";
                    break;
                case "requestforquotation":
                    comment_module = "REQUEST FOR QUOTATION";
                    break;
                case "vendorselection":
                    comment_module = "VENDOR SELECTION";
                    break;
                case "quotationanalysis":
                    comment_module = "QUOTATION ANALYSIS";
                    break;
                case "purchaseorder":
                    comment_module = "PURCHASE ORDER";
                    break;
                default:
                    break;
            }


            dtComment = statics.Comment.GetData(id, comment_module);
            dtChanges = staticsAuditTrail.GetDataChanges(id, module);

            listComment = JsonConvert.SerializeObject(dtComment);
            listChanges = JsonConvert.SerializeObject(dtChanges);
        }

        [WebMethod]
        public static string GetDetail(string module_id, string module_name, string change_type, string rec_id, string sub_module, string change_time, string approval_no)
        {
            return staticsAuditTrail.GetAuditDetail(module_id, module_name, change_type, rec_id, sub_module, change_time, approval_no);
        }
    }
}