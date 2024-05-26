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

namespace Procurement.Closure
{
    public partial class ItemClosure : System.Web.UI.Page
    {
        protected DataModel.ItemClosure ic = new DataModel.ItemClosure();

        protected string base_id = string.Empty
            , base_type = string.Empty
            , listCurrency = string.Empty
            , source = string.Empty
            , source_id = string.Empty
            , is_direct_purchase = string.Empty;

        protected string moduleName = "PURCHASE ORDER";
        protected string service_url, based_url = string.Empty;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!HttpContext.Current.User.Identity.IsAuthenticated)
            {
                //HttpContext.Current.GetOwinContext().Authentication.Challenge();
                Log.Information("Session ended re-challenge...");
            }

            UserRoleAccess userRoleAccess = AccessControl.GetUserRoleAccess(AccessControlObjectEnum.ProcurementItemClosure);


            if (!userRoleAccess.isCanWrite)
            {
                Response.Redirect(AccessControl.GetSetting("access_denied"));
                Log.Information("Don't have access control, redirecting...");
            }

            base_id = Request.QueryString["base_id"] ?? "0";
            base_type = Request.QueryString["base_type"] ?? "";

            source = Request.QueryString["source"] ?? "";
            source_id = Request.QueryString["source_id"] ?? "";
            service_url = statics.GetSetting("service_url");
            based_url = statics.GetSetting("based_url");

            is_direct_purchase = Request.QueryString["isdirectpurchase"] ?? "";

            if (!string.IsNullOrEmpty(base_id) && !string.IsNullOrEmpty(base_type)){
                DataTable dt = staticsItemClosure.GetData(base_id, base_type);
                foreach(DataRow dr in dt.Rows) {
                    ic.id = dr["id"].ToString();
                    ic.temporary_id = "";
                    ic.po_code = dr["po_no"].ToString();
                    ic.pr_code = dr["pr_no"].ToString();
                    ic.item_code = dr["item_code"].ToString();
                    ic.item_description = dr["item_description"].ToString();
                    ic.po_quantity = dr["origin_quantity"].ToString();
                    if (string.IsNullOrEmpty(ic.po_quantity)) {
                        ic.po_quantity = "0";
                    }
                    ic.po_quantity = String.Format("{0:#,0.00}", Decimal.Parse(ic.po_quantity));
                    ic.uom = dr["uom"].ToString();
                    ic.actual_vendor = dr["actual_vendor"].ToString();
                    ic.estimated_cost = String.Format("{0:#,0.00}", Decimal.Parse(dr["estimated_cost"].ToString()));
                    ic.estimated_cost_usd = String.Format("{0:#,0.00}", Decimal.Parse(dr["estimated_cost_usd"].ToString()));
                    ic.po_cost = String.Format("{0:#,0.00}", Decimal.Parse(dr["po_cost"].ToString()));
                    ic.po_cost_usd = String.Format("{0:#,0.00}", Decimal.Parse(dr["po_cost_usd"].ToString()));
                    ic.pr_currency_id = dr["pr_curr"].ToString();
                    ic.po_currency_id = dr["po_curr"].ToString();
                    ic.unit_price = dr["unit_price"].ToString();
                    ic.pr_detail_id = dr["pr_detail_id"].ToString();
                    ic.confirm_date = dr["confirm_date"].ToString();
                    if (!string.IsNullOrEmpty(ic.confirm_date)) {
                        ic.confirm_date = DateTime.Parse(ic.confirm_date).ToString("dd MMM yyyy");
                    }
                    ic.remaining_quantity = dr["remaining_qty"].ToString();
                }

                listCurrency = JsonConvert.SerializeObject(statics.GetCurrency());
            }
        }

        [WebMethod]
        public static string Save(string submission)
        {
            string result, message = "", moduleName = "ITEM CLOSURE",
                _id = "";
            try
            {
                DataModel.ItemClosure ic = JsonConvert.DeserializeObject<DataModel.ItemClosure>(submission);
                _id = staticsItemClosure.SaveClosure(ic);

                foreach (DataModel.Attachment d in ic.attachments)
                {
                    d.document_id = _id;
                    d.document_type = moduleName;
                    statics.Attachment.Save(d);
                }

                result = "success";
            }
            catch (Exception ex)
            {
                result = "error";
                message = ex.ToString();
            }
            return JsonConvert.SerializeObject(new
            {
                result = result,
                message = message,
                id = _id,
            });
        }
    }
}