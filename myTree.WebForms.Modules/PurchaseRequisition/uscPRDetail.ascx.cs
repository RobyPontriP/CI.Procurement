//using myTree.WebForms.K2Helper;
using myTree.WebForms.Procurement.General;
using myTree.WebForms.Procurement.General.K2Helper;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;

namespace myTree.WebForms.Modules.PurchaseRequisition
{
    public partial class uscPRDetail : System.Web.UI.UserControl
    {
        public string page_id { get; set; }
        public string page_type { get; set; }

        protected string PRDetail = string.Empty;
        protected string PRAttachmentGeneral = string.Empty;
        protected string PRJournalNo = string.Empty;
        protected string max_status = string.Empty;
        protected string hostURL = string.Empty;
        protected string usc_id_submission_page_type= string.Empty, usc_submission_page_name = string.Empty;
        protected string service_url, based_url = string.Empty;

        protected DataModel.PurchaseRequisition pr;
        protected DataModel.PurchaseRequisitionDetail prd;

        protected string status_name = string.Empty;
        protected string LastActivity = "";
        protected bool isJournal = false;
        protected Boolean isFinance = false;
        //protected AccessControl authorized = new AccessControl("PURCHASE ORDER");
        //protected UserRoleAccess userRoleAccess = AccessControl.GetUserRoleAccess(AccessControlObjectEnum.ProcurementPurchaseOrder);

        protected void Page_Load(object sender, EventArgs e)
        {
            string _id = page_id;
            pr = new DataModel.PurchaseRequisition
            {
                details = new List<DataModel.PurchaseRequisitionDetail>()
            };
            hostURL = statics.GetSetting("myTree_URL");

            if (!string.IsNullOrEmpty(_id))
            {
                pr.id = _id;

                DataSet ds = staticsPurchaseRequisition.Main.GetData(_id);
                if (ds.Tables.Count > 0)
                {
                    DataTable dtPR = ds.Tables[0];
                    DataTable dtAttachmentGeneral = ds.Tables[3];
                    DataTable dtPRJournal = ds.Tables[4];

                    if (dtPR.Rows.Count > 0)
                    {
                        pr.id = dtPR.Rows[0]["id"].ToString();
                        pr.pr_no = dtPR.Rows[0]["pr_no"].ToString();
                        pr.requester = dtPR.Rows[0]["requester"].ToString();
                        pr.required_date = dtPR.Rows[0]["required_date"].ToString();
                        pr.cifor_office_id = dtPR.Rows[0]["cifor_office_id"].ToString();
                        pr.cost_center_id = dtPR.Rows[0]["cost_center_id"].ToString();
                        pr.cost_center_id_name = dtPR.Rows[0]["cost_center_id_name"].ToString();
                        pr.t4 = dtPR.Rows[0]["t4"].ToString();
                        pr.remarks = statics.NormalizeString(dtPR.Rows[0]["remarks"].ToString());
                        pr.submission_date = dtPR.Rows[0]["submission_date"].ToString();
                        pr.currency_id = dtPR.Rows[0]["currency_id"].ToString();
                        pr.exchange_sign = dtPR.Rows[0]["exchange_sign"].ToString();
                        pr.exchange_sign_format = pr.exchange_sign == "*" ? "x" : "&divide;";
                        pr.exchange_rate = String.Format("{0:#,0.000000}", Decimal.Parse(string.IsNullOrEmpty(dtPR.Rows[0]["exchange_rate"].ToString()) ? "0" : dtPR.Rows[0]["exchange_rate"].ToString()));
                        pr.total_estimated = dtPR.Rows[0]["total_estimated"].ToString();
                        pr.total_estimated_usd = dtPR.Rows[0]["total_estimated_usd"].ToString();
                        pr.status_id = dtPR.Rows[0]["status_id"].ToString();
                        status_name = dtPR.Rows[0]["status_name"].ToString();
                        pr.is_active = dtPR.Rows[0]["is_active"].ToString();
                        pr.created_by = dtPR.Rows[0]["created_by"].ToString();
                        pr.created_date = dtPR.Rows[0]["created_date"].ToString();

                        pr.t4_name = statics.NormalizeString(dtPR.Rows[0]["t4_name"].ToString());
                        pr.requester_name = statics.NormalizeString(dtPR.Rows[0]["requester_name"].ToString());
                        pr.cifor_office_name = statics.NormalizeString(dtPR.Rows[0]["cifor_office_name"].ToString());

                        pr.is_direct_to_finance = dtPR.Rows[0]["is_direct_to_finance"].ToString();
                        pr.purchasing_process = dtPR.Rows[0]["purchasing_process"].ToString();
                        pr.direct_to_finance_justification = statics.NormalizeString(dtPR.Rows[0]["direct_to_finance_justification"].ToString());
                        pr.direct_to_finance_file = dtPR.Rows[0]["direct_to_finance_file"].ToString();
                        pr.purchase_type = dtPR.Rows[0]["purchase_type"].ToString();
                        pr.purchase_type_description = dtPR.Rows[0]["purchase_type_description"].ToString();
                        pr.other_purchase_type = dtPR.Rows[0]["other_purchase_type"].ToString();
                        pr.journal_no = dtPR.Rows[0]["journal_no"].ToString() == "0" ? "" : dtPR.Rows[0]["journal_no"].ToString();
                        pr.is_payment = dtPR.Rows[0]["is_payment"].ToString();
                        pr.reference_no = dtPR.Rows[0]["reference_no"].ToString();


                        pr.required_date = DateTime.Parse(pr.required_date).ToString("dd MMM yyyy");
                        pr.id_submission_page_type = dtPR.Rows[0]["id_submission_page_type"].ToString();
                        usc_id_submission_page_type = pr.id_submission_page_type;
                        pr.submission_page_name = dtPR.Rows[0]["submission_page_name"].ToString();

                        max_status = dtPR.Rows[0]["max_status"].ToString();
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

                        pr.journalno = new List<DataModel.JournalNo>();
                        if (dtPRJournal.Rows.Count > 0)
                        {
                            DataRow[] dtPRHJurnalNos = dtPRJournal.Select("pr_id='" + pr.id + "'", "id");

                            foreach (DataRow drg in dtPRHJurnalNos)
                            {
                                DataModel.JournalNo prjournal_no = new DataModel.JournalNo();
                                prjournal_no.id = drg["id"].ToString();
                                prjournal_no.pr_id = drg["pr_id"].ToString();
                                prjournal_no.journal_no = drg["journal_no"].ToString();
                                prjournal_no.is_active = drg["is_active"].ToString();
                                prjournal_no.journal_attachment_id = drg["journal_attachment_id"].ToString();
                                prjournal_no.journal_attachment = drg["journal_attachment"].ToString();
                                prjournal_no.journal_attachment_description = drg["journal_attachment_description"].ToString();

                                pr.journalno.Add(prjournal_no);
                            }
                        }

                        if (pr.journalno.Count > 0)
                        {
                            isJournal = true;
                        }

                        if (pr.status_id == "25" || pr.status_id == "50")
                        {
                            //get all comment
                            List<DataModel.Comment> listcomment = statics.Comment.GetDataIntoCommentObject(pr.id, "PURCHASE REQUISITION");
                            //List<ApproveState> listApvState = PurchaseRequisitionK2Helper.GetAllApproverByRelevantId(pr.id, "PurchaseRequisition");
                            var maxActivityIdApproved = listcomment.OrderByDescending(x => Convert.ToDateTime(x.created_date)).Select(x => x.activity_id).FirstOrDefault();
                            LastActivity = maxActivityIdApproved;
                        }

                    }

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
                            prd.category = statics.NormalizeString(dr["category"].ToString());
                            prd.subcategory = statics.NormalizeString(dr["subcategory"].ToString());
                            prd.brand = statics.NormalizeString(dr["brand"].ToString());
                            prd.description = statics.NormalizeString(dr["description"].ToString());
                            prd.request_qty = dr["request_qty"].ToString().Replace(',', '.');
                            prd.uom = dr["uom"].ToString();
                            prd.unit_price = dr["unit_price"].ToString();
                            prd.unit_price_usd = dr["unit_price_usd"].ToString();
                            prd.estimated_cost = dr["estimated_cost"].ToString();
                            prd.estimated_cost_usd = dr["estimated_cost_usd"].ToString();
                            prd.open_qty = dr["open_qty"].ToString().Replace(',', '.');
                            prd.is_direct_purchase = dr["is_direct_purchase"].ToString();
                            prd.last_price_currency = dr["last_price_currency"].ToString();
                            prd.last_price_amount = dr["last_price_amount"].ToString();
                            prd.purpose = dr["purpose"].ToString();
                            prd.currency_id = dr["currency_id"].ToString();
                            //prd.exchange_rate = dr["exchange_rate"].ToString();
                            //prd.exchange_rate = String.Format("{0:#,0.000000}", Decimal.Parse(dr["exchange_rate"].ToString()));
                            //prd.exchange_rate = String.Format("{0:#,0.000000}", Decimal.Parse(string.IsNullOrEmpty(dtPR.Rows[0]["exchange_rate"].ToString()) ? "0" : dtPR.Rows[0]["exchange_rate"].ToString()));
                            prd.exchange_rate = dr["exchange_rate"].ToString().Replace(',', '.');
                            prd.exchange_sign = dr["exchange_sign"].ToString();
                            prd.exchange_sign_format = prd.exchange_sign == "*" ? "x" : "&divide;";
                            prd.status_id = dr["status_id"].ToString();
                            prd.is_active = dr["is_active"].ToString();

                            prd.category_name = dr["category_name"].ToString();
                            prd.subcategory_name = dr["subcategory_name"].ToString();
                            prd.brand_name = dr["brand_name"].ToString();
                            prd.uom_name = dr["uom_name"].ToString();

                            prd.actions = dr["actions"].ToString();
                            prd.status_name = dr["status_name"].ToString();
                            prd.closing_remarks = dr["closing_remarks"].ToString();

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
                                costCenter.amount = drcc["amount"].ToString();
                                costCenter.amount_usd = drcc["amount_usd"].ToString().Replace(',', '.');
                                costCenter.remarks = drcc["remarks"].ToString();
                                costCenter.is_active = drcc["is_active"].ToString();

                                costCenter.cost_center_name = drcc["CostCenterName"].ToString();
                                costCenter.work_order_name = drcc["Description"].ToString();
                                costCenter.entity_name = drcc["entitydesc"].ToString();

                                prd.costCenters.Add(costCenter);
                            }

                            prd.directPurchase = new DataModel.DirectPurchase();
                            if (dr["is_direct_purchase"].ToString() == "1")
                            {
                                prd.directPurchase.purchase_qty = String.Format("{0:#,0.00}", dr["purchase_qty"].ToString());
                                prd.directPurchase.vendor_name = dr["vendor_name"].ToString();
                                prd.directPurchase.purchase_currency = dr["purchase_currency"].ToString();
                                prd.directPurchase.unit_price = String.Format("{0:#,0.00}", dr["purchase_unit_price"].ToString());
                                prd.directPurchase.total_cost = String.Format("{0:#,0.00}", dr["purchase_total"].ToString());
                                prd.directPurchase.total_cost_usd = String.Format("{0:#,0.00}", dr["purchase_total_usd"].ToString());
                                prd.directPurchase.purchase_date = dr["purchase_date"].ToString();
                                prd.directPurchase.status_id = dr["direct_purchase_status"].ToString();
                                prd.directPurchase.actions = dr["direct_purchase_action"].ToString();

                                if (!String.IsNullOrEmpty(prd.directPurchase.purchase_date))
                                {
                                    prd.directPurchase.purchase_date = DateTime.Parse(prd.directPurchase.purchase_date).ToString("dd MMM yyyy");
                                }
                            }

                            pr.details.Add(prd);
                        }
                    }
                }
            }

            DataTable dtSubmissionPageType = statics.GetSubmissionPageType(pr.id,"PURCHASE REQUISITION");

            if (dtSubmissionPageType.Rows.Count > 0)
            {
                foreach (DataRow item in dtSubmissionPageType.Rows)
                {
                    if (item["id"].ToString() == usc_id_submission_page_type)
                    {
                        usc_submission_page_name = item["page_type"].ToString();
                    }

                    if (string.IsNullOrEmpty(usc_id_submission_page_type))
                    {
                        usc_id_submission_page_type = item["id"].ToString();
                    }
                }
            }

            if (String.IsNullOrEmpty(pr.exchange_sign))
            {
                pr.exchange_sign_format = "&divide;";
                pr.exchange_sign = "/";
                pr.exchange_rate = "0";
            }

            service_url = statics.GetSetting("service_url");
            based_url = statics.GetSetting("based_url");

            PRDetail = JsonConvert.SerializeObject(pr.details);
            PRAttachmentGeneral = JsonConvert.SerializeObject(pr.attachments_general);
            PRJournalNo = JsonConvert.SerializeObject(pr.journalno);

            UserRoleAccess userRoleAccess = AccessControl.GetUserRoleAccess(AccessControlObjectEnum.ProcurementPurchaseRequisition);
            isFinance = userRoleAccess.RoleNameInSystem == AccessControlRoleNameEnum.Finance ? true : false;
        }
    }
}