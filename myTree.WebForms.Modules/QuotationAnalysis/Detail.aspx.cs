using myTree.WebForms.Procurement.General;
using Newtonsoft.Json;
using Serilog;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace myTree.WebForms.Modules.VendorSelection
{
    public partial class Detail : System.Web.UI.Page
    {
        protected string _id = string.Empty, vsItems = "[]", vsItemsMain = "[]", supportingDocs = "[]", blankmode = string.Empty;
        protected string listCurrency = string.Empty, max_status = string.Empty, listChargeCode = "[]", listSundry = "[]";
        protected DataModel.VendorSelection VS = new DataModel.VendorSelection();
        protected Boolean isAdmin = false;
        protected Boolean isUser = false;
        protected Boolean isFinance = false;

        protected string moduleName = "VENDOR SELECTION";
        protected string service_url, based_url,page_type = string.Empty;
        protected Boolean isEditable = false;

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
                    UserRoleAccess userRoleAccess = AccessControl.GetUserRoleAccess(AccessControlObjectEnum.ProcurementQuotationAnalysis);

                    if (!userRoleAccess.isCanRead)
                    {
                        Response.Redirect(AccessControl.GetSetting("access_denied"));
                        Log.Information("Don't have access control, redirecting...");
                    }

                    page_type = "DETAIL";

                }

            }
            catch (Exception ex)
            {
                ExceptionHelpers.PrintError(ex);
            }
        }

        [WebMethod]
        public static string VendorSelectionCancellation(string id, string comment, string comment_file)
        {
            string result, message = "";
            try
            {
                DataModel.Comment c = new DataModel.Comment();
                c.module_name = "VENDOR SELECTION";
                c.module_id = id;
                c.action_taken = "CANCELLED";
                c.comment = comment;
                c.comment_file = comment_file;
                statics.Comment.Save(c);

                staticsVendorSelection.Main.StatusUpdate(id, "95");

                statics.LifeCycle.Save(id, "VENDOR SELECTION", "95");

                result = "success";
            }
            catch (Exception ex)
            {
                result = "error";
                message = ExceptionHelpers.Message(ex);
                ExceptionHelpers.PrintError(ex);
            }
            return JsonConvert.SerializeObject(new
            {
                result = result,
                message = message
            });
        }

        [WebMethod]
        public static string UploadDocs(string id, string attachment, string deleted)
        {
            string result, message = "";
            try
            {
                string module_name = "VENDOR SELECTION";

                DataModel.Comment c = new DataModel.Comment();
                c.module_name = module_name;
                c.module_id = id;
                c.action_taken = "UPDATED";
                statics.Comment.Save(c);

                List<DataModel.Attachment> att = JsonConvert.DeserializeObject<List<DataModel.Attachment>>(attachment);
                foreach (DataModel.Attachment da in att)
                {
                    da.document_id = id;
                    da.document_type = module_name;
                    if (!string.IsNullOrEmpty(da.filename))
                    {
                        statics.Attachment.Save(da);
                    }
                }

                List<DataModel.DeletedId> deletedIds = JsonConvert.DeserializeObject<List<DataModel.DeletedId>>(deleted);
                foreach (DataModel.DeletedId del in deletedIds)
                {
                    if (del.table == "attachment")
                    {
                        statics.Attachment.Delete(del.id);
                    }
                }

                result = "success";
            }
            catch (Exception ex)
            {
                result = "error";
                message = ExceptionHelpers.Message(ex);
                ExceptionHelpers.PrintError(ex);
            }
            return JsonConvert.SerializeObject(new
            {
                result = result,
                message = message
            });
        }

        [WebMethod]
        public static string RequestJustification(string submission)
        {
            string result, message = "",
                _id = "", moduleName = "VENDOR SELECTION";

            try
            {
                DataModel.VendorSelection vs = JsonConvert.DeserializeObject<DataModel.VendorSelection>(submission);
                vs.ss_initiated_by = statics.GetLogonUsername();
                vs.is_submission = "1";
                staticsVendorSelection.Main.SaveJustification(vs);

                result = "success";

            }
            catch (Exception ex)
            {
                result = "error";
                message = ExceptionHelpers.Message(ex);
                ExceptionHelpers.PrintError(ex);
            }
            return JsonConvert.SerializeObject(new
            {
                result = result,
                message = message,
                id = _id,
                vs_no = ""
            });
        }
    }
}