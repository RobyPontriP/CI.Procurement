using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using Newtonsoft.Json;
using myTree.WebForms.Procurement.General;
using System.EnterpriseServices;

namespace myTree.WebForms.Modules.PurchaseRequisition
{
    public partial class uscPREdit : System.Web.UI.UserControl
    {
        public string page_id { get; set; }
        public string page_name { get; set; }

        protected string minDate = string.Empty;

        protected string listCategory = string.Empty;
        protected string listEmployee = string.Empty;
        protected string listOffice = string.Empty;
        protected string listCostCenter = string.Empty;
        protected string listCurrency = string.Empty;
        protected string listUoM = string.Empty;
        protected string listDelivery = string.Empty;
        protected string listEntity = string.Empty;
        protected string listPRType = string.Empty;
        //protected string listProduct = string.Empty;
        protected string hostURL = string.Empty;
        protected string service_url,based_url = string.Empty;

        protected string PRHeader = string.Empty;
        protected string PRDetail = string.Empty;
        protected string PRAttachmentGeneral = string.Empty;

        protected string justification_file_link_200 = string.Empty;
        protected string justification_file_link_1000 = string.Empty;
        protected string justification_file_link_2500 = string.Empty;
        protected string justification_file_link_below_25000 = string.Empty;
        protected string justification_file_link_above_25000 = string.Empty;
        protected string procOfficeFromDB = string.Empty;
        protected string entityRequester = string.Empty;

        protected DataModel.PurchaseRequisition pr;
        protected DataModel.PurchaseRequisitionDetail prd;
        private readonly Dictionary<string, string> DutyMapping = new Dictionary<string, string>() {
            { "ICRAF", "KENYA" },
            { "CIFOR", "INDONE" },
            { "GERMANY", "INDONE" },
        };

        private string DutySearch = string.Empty;

        protected void Page_Load(object sender, EventArgs e)
        {
            string _id = page_id;
            justification_file_link_200 = statics.GetSetting("justification_file_link_200");
            justification_file_link_1000 = statics.GetSetting("justification_file_link_1000");
            justification_file_link_2500 = statics.GetSetting("justification_file_link_2500");
            justification_file_link_below_25000 = statics.GetSetting("justification_file_link_below_25000");
            justification_file_link_above_25000 = statics.GetSetting("justification_file_link_above_25000");
            hostURL = statics.GetSetting("myTree_URL");
            service_url = statics.GetSetting("service_url");
            based_url = statics.GetSetting("based_url");

            pr = new DataModel.PurchaseRequisition();
            pr.details = new List<DataModel.PurchaseRequisitionDetail>();

            //minDate = DateTime.Parse(statics.GetMinimumDate(DateTime.Now.ToString("dd MMM yyyy"), "22")).ToString("dd MMM yyyy");

            //var dtEmployee = statics.GetEmployee(statics.GetLogonUsername().ToLower());
            //if (dtEmployee.Rows.Count > 0)
            //{
            //    foreach (DataRow item in dtEmployee.Rows)
            //    {
            //        if (item["UserID"].ToString().ToLower() == statics.GetLogonUsername().ToLower())
            //        {
            //            entityRequester = item["LegalEntity"].ToString();
            //        }
            //    }
            //}

            //DutySearch = DutyMapping[entityRequester];
            minDate = DateTime.Parse(statics.GetMinimumDate(DateTime.Now.ToString("dd MMM yyyy"), "22","")).ToString("dd MMM yyyy");

            if (!string.IsNullOrEmpty(_id))
            {
                pr.id = _id;

                DataSet ds = staticsPurchaseRequisition.Main.GetData(_id);
                if (ds.Tables.Count > 0)
                {
                    DataTable dtPR = ds.Tables[0];
                    DataTable dtAttachmentGeneral = ds.Tables[3];

                    if (dtPR.Rows.Count > 0)
                    {
                        pr.id = dtPR.Rows[0]["id"].ToString();
                        pr.pr_no = dtPR.Rows[0]["pr_no"].ToString();
                        pr.requester = dtPR.Rows[0]["requester"].ToString();
                        pr.required_date = dtPR.Rows[0]["required_date"].ToString();
                        pr.cifor_office_id = dtPR.Rows[0]["cifor_office_id"].ToString();
                        pr.cost_center_id = dtPR.Rows[0]["cost_center_id"].ToString();
                        pr.t4 = dtPR.Rows[0]["t4"].ToString();
                        pr.remarks = statics.NormalizeString(dtPR.Rows[0]["remarks"].ToString());
                        pr.submission_date = dtPR.Rows[0]["submission_date"].ToString();
                        pr.currency_id = dtPR.Rows[0]["currency_id"].ToString();
                        pr.exchange_sign = dtPR.Rows[0]["exchange_sign"].ToString();
                        pr.exchange_sign_format = pr.exchange_sign == "*" ? "x" : "&divide;";
                        pr.exchange_rate = dtPR.Rows[0]["exchange_rate"].ToString();
                        pr.total_estimated = dtPR.Rows[0]["total_estimated"].ToString();
                        pr.total_estimated_usd = dtPR.Rows[0]["total_estimated_usd"].ToString();
                        pr.status_id = dtPR.Rows[0]["status_id"].ToString();
                        pr.is_active = dtPR.Rows[0]["is_active"].ToString();
                        pr.created_by = dtPR.Rows[0]["created_by"].ToString();

                        pr.t4_name = statics.NormalizeString(dtPR.Rows[0]["t4_name"].ToString());
                        pr.requester_name = statics.NormalizeString(dtPR.Rows[0]["requester_name"].ToString());
                        pr.cifor_office_name = statics.NormalizeString(dtPR.Rows[0]["cifor_office_name"].ToString());

                        pr.is_direct_to_finance = dtPR.Rows[0]["is_direct_to_finance"].ToString();
                        pr.purchasing_process = dtPR.Rows[0]["purchasing_process"].ToString();
                        pr.direct_to_finance_justification = statics.NormalizeString(dtPR.Rows[0]["direct_to_finance_justification"].ToString());
                        pr.direct_to_finance_file = dtPR.Rows[0]["direct_to_finance_file"].ToString();
                        pr.purchase_type = dtPR.Rows[0]["purchase_type"].ToString();
                        pr.other_purchase_type = dtPR.Rows[0]["other_purchase_type"].ToString();
                        pr.is_procurement = dtPR.Rows[0]["is_procurement"].ToString();
                        pr.submission_page_name = dtPR.Rows[0]["submission_page_name"].ToString();

                        //if (pr.status_id == "5" //draft
                        //    || String.IsNullOrEmpty(pr.required_date))
                        //{
                        if (String.IsNullOrEmpty(pr.required_date))
                        {
                            pr.required_date = minDate;
                        }
                        else
                        {
                            if ((DateTime.Parse(minDate) > DateTime.Parse(pr.required_date)) && String.IsNullOrEmpty(pr.required_date))
                            {
                                pr.required_date = minDate;
                            }
                            else
                            {
                                pr.required_date = DateTime.Parse(pr.required_date).ToString("dd MMM yyyy");
                            }
                        }

                        pr.attachments_general = new List<DataModel.Attachment>();
                        if (dtAttachmentGeneral.Rows.Count > 0)
                        {
                            DataRow[] dtAttachmentGenerals = dtAttachmentGeneral.Select("document_id='" + pr.id + "'", "id");

                            foreach (DataRow drg in dtAttachmentGenerals)
                            {
                                DataModel.Attachment attachmentgeneral = new DataModel.Attachment();
                                attachmentgeneral.id = drg["id"].ToString();
                                attachmentgeneral.filename = drg["filename"].ToString();
                                attachmentgeneral.file_description = statics.NormalizeString(drg["file_description"].ToString());
                                attachmentgeneral.document_id = drg["document_id"].ToString();
                                attachmentgeneral.document_type = "PURCHASE REQUISITION GENERAL";
                                attachmentgeneral.is_active = drg["is_active"].ToString();

                                pr.attachments_general.Add(attachmentgeneral);
                            }
                        }
                    }

                    procOfficeFromDB = pr.cifor_office_id;

                    DataTable dtDetail = ds.Tables[1];
                    DataTable dtAttachment = ds.Tables[2];
                    DataTable dtCostCenters = ds.Tables[5];

                    if (dtDetail.Rows.Count > 0)
                    {
                        foreach (DataRow dr in dtDetail.Rows)
                        {
                            prd = new DataModel.PurchaseRequisitionDetail();
                            prd.id = dr["id"].ToString();
                            prd.pr_id = dr["pr_id"].ToString();
                            prd.line_no = dr["line_no"].ToString();
                            prd.item_id = dr["item_id"].ToString();
                            prd.item_code = dr["item_code"].ToString();
                            prd.category = dr["category"].ToString();
                            prd.subcategory = dr["subcategory"].ToString();
                            prd.brand = dr["brand"].ToString();
                            prd.description = dr["description"].ToString();
                            prd.request_qty = dr["request_qty"].ToString().Replace(',', '.');
                            prd.uom = dr["uom"].ToString();
                            prd.unit_price = dr["unit_price"].ToString().Replace(',', '.');
                            prd.unit_price_usd = dr["unit_price_usd"].ToString().Replace(',', '.');
                            prd.estimated_cost = dr["estimated_cost"].ToString().Replace(',', '.');
                            prd.estimated_cost_usd = dr["estimated_cost_usd"].ToString().Replace(',', '.');
                            prd.open_qty = dr["open_qty"].ToString();
                            prd.is_direct_purchase = dr["is_direct_purchase"].ToString();
                            prd.last_price_currency = dr["last_price_currency"].ToString();
                            prd.last_price_amount = dr["last_price_amount"].ToString().Replace(',', '.');
                            prd.last_price_quantity = dr["last_price_quantity"].ToString().Replace(',', '.');
                            prd.last_price_uom = dr["last_price_uom"].ToString();
                            prd.last_price_date = dr["last_price_date"].ToString();
                            prd.purpose = dr["purpose"].ToString();
                            prd.delivery_address = dr["delivery_address"].ToString();
                            prd.other_delivery_address = dr["other_delivery_address"].ToString();
                            prd.is_other_address = dr["is_other_address"].ToString().ToLower() == "true"? "1" : "0";
                            if (!string.IsNullOrEmpty(prd.last_price_date))
                            {
                                prd.last_price_date = DateTime.Parse(prd.last_price_date).ToString("dd MMM yyyy");
                            }
                            prd.status_id = dr["status_id"].ToString();
                            prd.is_active = dr["is_active"].ToString();
                            prd.currency_id = dr["currency_id"].ToString();
                            prd.exchange_sign = dr["exchange_sign"].ToString();
                            prd.exchange_sign_format = pr.exchange_sign == "*" ? "x" : "&divide;";
                            prd.exchange_rate = dr["exchange_rate"].ToString().Replace(',', '.');

                            prd.category_name = dr["category_name"].ToString();
                            prd.subcategory_name = dr["subcategory_name"].ToString();
                            prd.brand_name = dr["brand_name"].ToString();
                            prd.uom_name = dr["uom_name"].ToString();
                            prd.item_description = dr["item_description"].ToString();

                            prd.attachments = new List<DataModel.Attachment>();

                            DataRow[] dtDetailAttachment = dtAttachment.Select("document_id='" + prd.id + "'", "id");
                            foreach (DataRow dra in dtDetailAttachment)
                            {
                                DataModel.Attachment attachment = new DataModel.Attachment();
                                attachment.id = dra["id"].ToString();
                                attachment.filename = dra["filename"].ToString();
                                attachment.file_description = statics.NormalizeString(dra["file_description"].ToString());
                                attachment.document_id = dra["document_id"].ToString();
                                attachment.document_type = "PURCHASE REQUISITION";
                                attachment.is_active = dra["is_active"].ToString();

                                prd.attachments.Add(attachment);
                            }

                            prd.costCenters = new List<DataModel.PurchaseRequisitionDetailCostCenter>();
                            DataRow[] dtDetailCostCenter = dtCostCenters.Select("pr_detail_id='" + prd.id + "'", "id");
                            foreach (DataRow drcc in dtDetailCostCenter)
                            {
                                DataModel.PurchaseRequisitionDetailCostCenter costCenter = new DataModel.PurchaseRequisitionDetailCostCenter();
                                costCenter.id = drcc["id"].ToString();
                                costCenter.pr_id = drcc["pr_id"].ToString();
                                costCenter.pr_detail_id = drcc["pr_detail_id"].ToString();
                                costCenter.cost_center_id = drcc["cost_center_id"].ToString();
                                costCenter.work_order = drcc["work_order"].ToString();
                                costCenter.entity_id = drcc["entity_id"].ToString();
                                costCenter.legal_entity = drcc["legal_entity"].ToString();
                                costCenter.control_account = drcc["control_account"].ToString();
                                costCenter.percentage = drcc["percentage"].ToString().Replace(',', '.');
                                costCenter.amount = drcc["amount"].ToString().Replace(',', '.');
                                costCenter.amount_usd = drcc["amount_usd"].ToString().Replace(',', '.');
                                costCenter.remarks = drcc["remarks"].ToString();
                                costCenter.is_active = drcc["is_active"].ToString();

                                costCenter.cost_center_name = costCenter.cost_center_id + " - " + drcc["CostCenterName"].ToString();
                                costCenter.work_order_name = drcc["Description"].ToString();
                                costCenter.entity_name = costCenter.entity_id + " - " + drcc["entitydesc"].ToString();

                                prd.costCenters.Add(costCenter);
                            }

                            pr.details.Add(prd);
                        }
                    }
                }
            }
            else
            {
                pr.required_date = minDate;
            }

            if (String.IsNullOrEmpty(pr.exchange_sign))
            {
                pr.exchange_sign_format = "&divide;";
                pr.exchange_sign = "/";
                pr.exchange_rate = "0";
            }

            //listCategory = JsonConvert.SerializeObject(Service.GetCategory(""));
            listEmployee = JsonConvert.SerializeObject(statics.GetEmployee());
            listOffice = JsonConvert.SerializeObject(statics.GetCIFOROffice());
            listCostCenter = JsonConvert.SerializeObject(statics.GetSUNCostCenter());
            listCurrency = JsonConvert.SerializeObject(statics.GetCurrency());
            listUoM = JsonConvert.SerializeObject(Service.GetUoM(""));
            listEntity = JsonConvert.SerializeObject(statics.GetEntity(""));
            listDelivery = JsonConvert.SerializeObject(statics.GetSUNDeliveryAddress());
            //listProduct = JsonConvert.SerializeObject(statics.GetProduct());
            listPRType = JsonConvert.SerializeObject(statics.GetPRType());

            PRHeader = JsonConvert.SerializeObject(pr);
            PRDetail = JsonConvert.SerializeObject(pr.details);
            PRAttachmentGeneral = JsonConvert.SerializeObject(pr.attachments_general);
        }
    }
}