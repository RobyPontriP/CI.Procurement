using myTree.WebForms.Procurement.General;
using Newtonsoft.Json;
using Serilog;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Security.Cryptography;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace myTree.WebForms.Modules.RFQ
{
    public partial class uscPRList : System.Web.UI.UserControl
    {
        protected string itemStatus = string.Empty;

        protected string listPR = string.Empty;
        protected string listOffice = string.Empty;

        protected string startDate = string.Empty;
        protected string endDate = string.Empty;
        protected string cifor_office = string.Empty;
        protected Boolean isOfficer = false;
        protected Boolean isLead = false;
        protected Boolean isMultipleOffice = false;
        protected Boolean isAllTax = false;
        protected string userId = string.Empty;
        protected string pr_line_id = string.Empty;

        private class MainList
        {
            public string id { get; set; }
            public string kpi { get; set; }
            public string pr_no { get; set; }
            public string created_date { get; set; }
            public string submission_date { get; set; }
            public string requester { get; set; }
            public string cifor_office { get; set; }
            public string required_date { get; set; }
            public string remarks { get; set; }
            public string cost_center { get; set; }
            public string status { get; set; }
            public string color_code { get; set; }
            public string font_color { get; set; }
            public string details { get; set; }
        }

        private class ItemList
        {   public string id { get; set; }
            public string pr_id { get; set; }
            public string item_code { get; set; }
            public string description { get; set; }
            public string request_qty { get; set; }
            public string po_qty { get; set; }
            public string grm_qty { get; set; }
            public string uom_name { get; set; }
            public string currency_id { get; set; }
            public string estimated_cost { get; set; }
            public string exchange_rate { get; set; }
            public string estimated_cost_usd { get; set; }
            public string is_direct_purchase { get; set; }
            public string status { get; set; }
            public string color_code { get; set; }
            public string font_color { get; set; }
            public string attachment { get; set; }
            public string subcategory { get; set;  }
            public string balance { get; set; }
            public string detail { get; set; }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                UserRoleAccess userRoleAccess = AccessControl.GetUserRoleAccess(AccessControlObjectEnum.ProcurementRFQ);


                if (!(userRoleAccess.isCanWrite))
                {
                    Response.Redirect(AccessControl.GetSetting("access_denied"));
                    Log.Information("Don't have access control, redirecting...");
                }


                userId = statics.GetLogonUsername();
                isLead = statics.isProcurementLead(userId, userRoleAccess);
                DataTable dtOffice = statics.GetCIFOROffice(userId, isLead);
                if (dtOffice.Rows.Count > 1)
                {
                    isMultipleOffice = true;
                }

                pr_line_id = Request.QueryString["pr_line_id"] ?? "";
                if (IsPostBack)
                {
                    startDate = Request.Form["startDate"] ?? "";
                    endDate = Request.Form["endDate"] ?? "";
                    cifor_office = Request.Form["cifor_office"] ?? "";
                }
                else
                {
                    startDate = Request.QueryString["startDate"] ?? "";
                    endDate = Request.QueryString["endDate"] ?? "";
                }

                if (!string.IsNullOrEmpty(pr_line_id))
                {
                    DataSet dsSubmission = staticsPurchaseRequisition.GetSubmissionDateByPrDetailId(pr_line_id);
                    if (dsSubmission.Tables.Count > 0)
                    {
                        startDate = dsSubmission.Tables[0].Rows[0]["submission_date"].ToString();
                        DateTime lastDayOfMonth = DateTime.Now.AddMonths(1).AddDays(-DateTime.Now.Day);
                        endDate = lastDayOfMonth.ToString();
                    }
                }

                if (String.IsNullOrEmpty(startDate))
                {
                    DateTime t = new DateTime(DateTime.Now.Year, DateTime.Now.Month, 1);
                    startDate = t.ToString("dd MMM yyyy");
                }
                if (String.IsNullOrEmpty(endDate))
                {
                    DateTime t = new DateTime(DateTime.Now.Year, DateTime.Now.Month, DateTime.DaysInMonth(DateTime.Now.Year, DateTime.Now.Month));
                    endDate = t.ToString("dd MMM yyyy");
                }

                if (String.IsNullOrEmpty(cifor_office) || cifor_office == "ALL")
                {
                    cifor_office = Service.GetProcurementOfficeByOfficerId(userId, isLead);
                }

                DataTable dtAllTaxSystem = statics.GetMappingAllTaxSystem(cifor_office);

                if (dtAllTaxSystem.Rows.Count > 0)
                {
                    isAllTax = true;
                }

                if (!isMultipleOffice)
                {
                    cifor_office = cifor_office.Replace(";", "");
                }

                DataSet ds = staticsRFQ.GetPRList(startDate, endDate, cifor_office);

                if (ds.Tables.Count > 0)
                {
                    List<MainList> lm = new List<MainList>();
                    foreach (DataRow drM in ds.Tables[0].Rows)
                    {
                        MainList m = new MainList();
                        m.id = drM["id"].ToString();
                        m.kpi = drM["kpi"].ToString();
                        m.pr_no = drM["pr_no"].ToString();
                        m.created_date = drM["created_date"].ToString();
                        m.submission_date = drM["submission_date"].ToString();
                        m.requester = drM["requester"].ToString();
                        m.cifor_office = drM["cifor_office"].ToString();
                        m.required_date = drM["required_date"].ToString();
                        m.remarks = drM["remarks"].ToString();
                        m.cost_center = drM["cost_center"].ToString();
                        m.status = drM["status"].ToString();
                        m.font_color = drM["font_color"].ToString();
                        m.color_code = drM["color_code"].ToString();

                        var rowItm = ds.Tables[1].Select("pr_id='" + m.id + "'", "id asc");
                        if (rowItm.Any())
                        {
                            DataTable dtD;
                            dtD = ds.Tables[1].Select("pr_id='" + m.id + "'", "id asc").CopyToDataTable();

                            List<ItemList> li = new List<ItemList>();
                            foreach (DataRow drI in dtD.Rows)
                            {
                                ItemList itm = new ItemList();
                                itm.id = drI["id"].ToString();
                                itm.pr_id = drI["pr_id"].ToString();
                                itm.item_code = drI["item_code"].ToString();
                                itm.description = drI["description"].ToString();
                                itm.request_qty = drI["request_qty"].ToString();
                                itm.po_qty = drI["po_qty"].ToString();
                                itm.grm_qty = drI["grm_qty"].ToString();
                                itm.uom_name = drI["uom_name"].ToString();
                                itm.currency_id = drI["currency_id"].ToString();
                                itm.estimated_cost = drI["estimated_cost"].ToString();
                                itm.exchange_rate = drI["exchange_rate"].ToString();
                                itm.estimated_cost_usd = drI["estimated_cost_usd"].ToString();
                                itm.is_direct_purchase = drI["is_direct_purchase"].ToString();
                                itm.status = drI["status"].ToString();
                                itm.color_code = drI["color_code"].ToString();
                                itm.font_color = drI["font_color"].ToString();
                                itm.attachment = drI["attachment"].ToString();
                                itm.subcategory = drI["subcategory"].ToString();
                                itm.balance = drI["balance"].ToString();

                                var row = ds.Tables[2].Select("pr_detail_id='" + itm.id + "'", "id asc");
                                if (row.Any())
                                {
                                    DataTable dtid;
                                    dtid = ds.Tables[2].Select("pr_detail_id='" + itm.id + "'", "id asc").CopyToDataTable();
                                    itm.detail = JsonConvert.SerializeObject(dtid);
                                }
                                else
                                {
                                    itm.detail = String.Empty;
                                }

                                li.Add(itm);
                            }

                            m.details = JsonConvert.SerializeObject(li);

                            lm.Add(m);
                        }
                        else
                        {

                            List<ItemList> li = new List<ItemList>();
                            ItemList itm = new ItemList();
                            itm.id = string.Empty;
                            itm.pr_id = string.Empty;
                            itm.item_code = string.Empty;
                            itm.description = string.Empty;
                            itm.request_qty = string.Empty;
                            itm.po_qty = string.Empty;
                            itm.grm_qty = string.Empty;
                            itm.uom_name = string.Empty;
                            itm.currency_id = string.Empty;
                            itm.estimated_cost = string.Empty;
                            itm.exchange_rate = string.Empty;
                            itm.estimated_cost_usd = string.Empty;
                            itm.is_direct_purchase = string.Empty;
                            itm.status = string.Empty;
                            itm.color_code = string.Empty;
                            itm.font_color = string.Empty;
                            itm.attachment = string.Empty;
                            itm.subcategory = string.Empty;
                            itm.balance = string.Empty;
                            itm.detail = string.Empty;

                            li.Add(itm);
                            m.details = JsonConvert.SerializeObject(li);
                            lm.Add(m);
                        }

                    }

                    listPR = JsonConvert.SerializeObject(lm);

                }

                listOffice = JsonConvert.SerializeObject(statics.GetCIFOROffice(userId, isLead));
            }
            catch(Exception ex)
            {
                ExceptionHelpers.PrintError(ex);
            }
        }
    }
}