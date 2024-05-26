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
    public partial class detail : System.Web.UI.Page
    {
        protected DataModel.ItemClosure ic = new DataModel.ItemClosure();

        protected string base_id = string.Empty
            , base_type = string.Empty
            , listCurrency = string.Empty
            , listAttachment = string.Empty
            , source = string.Empty
            , source_id = string.Empty
            , is_direct_purchase = string.Empty
            , _id = string.Empty;

        protected string moduleName = "PURCHASE ORDER";

        //protected AccessControl authorized = new AccessControl("item closure");

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!HttpContext.Current.User.Identity.IsAuthenticated)
            {
                //HttpContext.Current.GetOwinContext().Authentication.Challenge();
                Log.Information("Session ended re-challenge...");
            }

            _id = Request.QueryString["id"] ?? "0";

            UserRoleAccess userRoleAccess = AccessControl.GetUserRoleAccess(AccessControlObjectEnum.ProcurementItemClosure);

            if (!userRoleAccess.isCanRead)
            {
                Response.Redirect(AccessControl.GetSetting("access_denied"));
                Log.Information("Don't have access control, redirecting...");
            }

            if (!string.IsNullOrEmpty(_id))
            {
                DataSet ds = staticsItemClosure.GetDataDetail(_id);
                if (ds.Tables.Count > 0)
                {
                    DataTable dt = ds.Tables[0];
                    DataTable dtAttachment = ds.Tables[1];
                    foreach (DataRow dr in dt.Rows)
                    {
                        ic.po_code = dr["po_no"].ToString();
                        ic.pr_code = dr["pr_no"].ToString();
                        ic.item_code = dr["item_code"].ToString();
                        ic.item_description = dr["item_description"].ToString();
                        ic.po_quantity = dr["origin_quantity"].ToString();
                        if (string.IsNullOrEmpty(ic.po_quantity))
                        {
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
                        if (!string.IsNullOrEmpty(ic.confirm_date))
                        {
                            ic.confirm_date = DateTime.Parse(ic.confirm_date).ToString("dd MMM yyyy");
                        }
                        ic.remaining_quantity = dr["remaining_qty"].ToString();
                        base_type = dr["base_type"].ToString();
                        ic.reason_for_closing = dr["reason_for_closing"].ToString();
                        ic.reason_for_closing_name = dr["reason_for_closing_name"].ToString();
                        ic.close_date = DateTime.Parse(dr["close_date"].ToString()).ToString("dd MMM yyyy");
                        ic.quantity = String.Format("{0:#,0.00}", Decimal.Parse(dr["closed_qty"].ToString()));
                        ic.grm_no = dr["grm_no"].ToString();
                        ic.remarks = dr["remarks"].ToString();
                        ic.actual_amount = String.Format("{0:#,0.00}", Decimal.Parse(dr["actual_amount"].ToString()));
                        ic.actual_amount_usd = String.Format("{0:#,0.00}", Decimal.Parse(dr["actual_amount_usd"].ToString()));
                        ic.attachments = new List<DataModel.Attachment>();
                        if (dtAttachment.Rows.Count > 0)
                        {
                            DataRow[] dtAttachments = dtAttachment.Select("document_id='" + _id + "'", "id");

                            foreach (DataRow drg in dtAttachments)
                            {
                                DataModel.Attachment attachment = new DataModel.Attachment();
                                attachment.id = drg["id"].ToString();
                                attachment.filename = drg["filename"].ToString();
                                attachment.file_description = statics.NormalizeString(drg["file_description"].ToString());
                                attachment.document_id = drg["document_id"].ToString();
                                attachment.document_type = "ITEM CLOSURE";
                                attachment.is_active = drg["is_active"].ToString();

                                ic.attachments.Add(attachment);
                            }
                        }
                    }
                }

                listCurrency = JsonConvert.SerializeObject(statics.GetCurrency());
                listAttachment = JsonConvert.SerializeObject(ic.attachments);
            }
        }
    }
}