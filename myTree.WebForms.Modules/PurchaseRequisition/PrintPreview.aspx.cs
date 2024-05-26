using myTree.WebForms.Procurement.General;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Security.Cryptography;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace myTree.WebForms.Modules.PurchaseRequisition
{
    public partial class PrintPreview : System.Web.UI.Page
    {
        string id = string.Empty;

        protected string htmlOutput = string.Empty;
        protected string pr_code = string.Empty, submission_page_name = string.Empty;

        private static Antlr3.ST.StringTemplateGroup group = new Antlr3.ST.StringTemplateGroup("PRHelper");
        private static Antlr3.ST.StringTemplate template = new Antlr3.ST.StringTemplate();
        public static string StartupPath = HttpContext.Current.Server.MapPath("template");

        protected void Page_Load(object sender, EventArgs e)
        {
            id = Request.QueryString["id"] ?? "";
            if (!string.IsNullOrEmpty(id))
            {
                pr_code = staticsPurchaseRequisition.GetFullNumber(id);
                /* PR print */
                //htmlOutput += "<h3 align='center'>PURCHASE REQUISITION " + pr_code + "<h3>" + GetPRTemplate(id);

                DataTable dtSubmissionPageType = statics.GetSubmissionPageType(id, "PURCHASE REQUISITION");
                submission_page_name = dtSubmissionPageType.Rows[0]["page_type"].ToString();

                htmlOutput += "<h3 align='center'>"+ submission_page_name.ToUpper() + " " + pr_code + "<h3>" + GetPRTemplate(id);
            }
        }

        public static string GetPRTemplate(string pr_id)
        {
            string templateString = string.Empty;
            string total = string.Empty;
            string attachmentList = string.Empty;
            Decimal total_usd = 0;
            Boolean isJustification = false;
            Boolean isJournal = false;
            group.RootDir = StartupPath;
            Antlr3.ST.StringTemplate template = group.GetInstanceOf("PRDetail");
            Antlr3.ST.StringTemplate comment = group.GetInstanceOf("Comment");
            Antlr3.ST.StringTemplate attachmentGeneralST = group.GetInstanceOf("AttachmentGeneral");
            Antlr3.ST.StringTemplate AttachmentJournalNoST = group.GetInstanceOf("AttachmentJournalNo");

            DataSet PR = staticsPurchaseRequisition.GetPrintPreview(pr_id);
            DataTable cc = new DataTable();
            DataTable attachment = new DataTable();
            DataTable attachmentGeneral = new DataTable();
            DataTable attachmentJournalNo = new DataTable();
            if (PR.Tables.Count > 0)
            {
                cc = PR.Tables[2];
                attachmentGeneral = PR.Tables[4];
                attachment = PR.Tables[3];
                attachmentJournalNo = PR.Tables[5];
            }

            foreach (DataRow drPR in PR.Tables[0].Rows)
            {
                int i = 1;
                string rowClass = string.Empty;

                /* populate comments */
                string commentDetail = string.Empty;
                DataTable dtComment = statics.Comment.GetData(drPR["id"].ToString(), "PURCHASE REQUISITION");
                foreach (DataRow drC in dtComment.Rows)
                {
                    if (i % 2 != 0)
                    {
                        rowClass = "basefont";
                    }
                    else
                    {
                        rowClass = "zebra";
                    }

                    Antlr3.ST.StringTemplate row = group.GetInstanceOf("CommentDetail");
                    row.SetAttribute("class", rowClass);
                    row.SetAttribute("name", drC["emp_user_id"].ToString());
                    row.SetAttribute("role", drC["roles"].ToString());
                    row.SetAttribute("date", drC["created_date"].ToString());
                    row.SetAttribute("action", drC["action_taken"].ToString());
                    row.SetAttribute("comment", drC["comment"].ToString());
                    commentDetail += row.ToString();
                    i++;
                }
                comment.SetAttribute("details", commentDetail);

                string attachmentListGeneral = string.Empty;
                string attachmentListJournalNo = string.Empty;

                //DataRow[] dtDetailAttachmentGeneral = attachmentGeneral.Select("document_id='" + drM["id"].ToString() + "'", "id");
                int ag = 0;
                foreach (DataRow dra in attachmentGeneral.Rows)
                {
                    if (i % 2 != 0)
                    {
                        rowClass = "basefont";
                    }
                    else
                    {
                        rowClass = "zebra";
                    }

                    Antlr3.ST.StringTemplate row = group.GetInstanceOf("AttachmentGeneralDetail");
                    row.SetAttribute("class", rowClass);
                    row.SetAttribute("description", dra["file_description"].ToString());
                    row.SetAttribute("file_link", "<a href='" + string.Format("{0}{1}", statics.GetSetting("myTree_URL"), statics.GetSetting("App_Pool_Name")) + "/purchaserequisition/files/" + drPR["id"].ToString() + "/" + dra["filename"].ToString() + "'>" + dra["filename"].ToString() + "</a>");
                    attachmentListGeneral += row.ToString();
                    i++;
                }
                attachmentGeneralST.SetAttribute("details", attachmentListGeneral);

                foreach (DataRow dra in attachmentJournalNo.Rows)
                {
                    isJournal = true;
                    if (i % 2 != 0)
                    {
                        rowClass = "basefont";
                    }
                    else
                    {
                        rowClass = "zebra";
                    }

                    Antlr3.ST.StringTemplate row = group.GetInstanceOf("AttachmentJournalNoDetail");
                    row.SetAttribute("class", rowClass);
                    row.SetAttribute("journal_no", dra["journal_no"].ToString());
                    row.SetAttribute("file_link", "<a href='" + string.Format("{0}{1}", statics.GetSetting("myTree_URL"), statics.GetSetting("App_Pool_Name")) + "/purchaserequisition/files/" + drPR["id"].ToString() + "/" + dra["journal_attachment"].ToString() + "'>" + dra["journal_attachment"].ToString() + "</a>");
                    attachmentListJournalNo += row.ToString();
                    i++;
                }
                AttachmentJournalNoST.SetAttribute("details", attachmentListJournalNo);

                templateString += comment.ToString();
                comment.Reset();

                /* populate PR */
                template.SetAttribute("pr_no", drPR["pr_no"].ToString());
                template.SetAttribute("status_name", drPR["status_name"].ToString());
                template.SetAttribute("requester", drPR["requester_name"].ToString());
                template.SetAttribute("required_date", drPR["required_date"].ToString());
                template.SetAttribute("purchase_office", drPR["cifor_office_name"].ToString());

                //template.SetAttribute("isDirectToFinance", Boolean.Parse(drPR["isDirectToFinance"].ToString()));
                //template.SetAttribute("is_direct_to_finance", drPR["is_direct_to_finance"].ToString());
                //template.SetAttribute("direct_to_finance_justification", drPR["direct_to_finance_justification"].ToString());

                template.SetAttribute("remarks", drPR["remarks"].ToString());
                template.SetAttribute("exchange_sign", drPR["exchange_sign"].ToString());
                template.SetAttribute("exchange_rate", String.Format("{0:#,0.000000}", Decimal.Parse(string.IsNullOrEmpty(drPR["exchange_rate"].ToString()) ? "0.00000" : drPR["exchange_rate"].ToString())));
                //template.SetAttribute("total_estimated", String.Format("{0:#,0.00}", Decimal.Parse(drPR["total_estimated"].ToString())) ?? "0");
                //template.SetAttribute("total_estimated_usd", String.Format("{0:#,0.00}", Decimal.Parse(drPR["total_estimated_usd"].ToString())) ?? "0");

                string rowDetail = string.Empty;

                DataTable PRD = PR.Tables[1].Select("pr_id='" + drPR["id"].ToString() + "'", "line_no asc").CopyToDataTable();
                i = 1;
                foreach (DataRow drPRD in PRD.Rows)
                {
                    attachmentList = string.Empty;

                    DataRow[] dtDetailAttachment = attachment.Select("document_id='" + drPRD["id"].ToString() + "'", "id");
                    int ai = 0;
                    foreach (DataRow dra in dtDetailAttachment)
                    {
                        if (ai != 0)
                        {
                            attachmentList += "<br/>";
                        }
                        attachmentList += "<a href='" + drPRD["file_link"].ToString() + dra["filename"].ToString() + "'>" + dra["filename"].ToString() + "</a><br>";
                    }

                    if (i % 2 != 0)
                    {
                        rowClass = "basefont";
                    }
                    else
                    {
                        rowClass = "zebra";
                    }

                    Antlr3.ST.StringTemplate row = group.GetInstanceOf("PRDetail_data");
                    row.SetAttribute("class", rowClass);
                    row.SetAttribute("item_code", drPRD["item_code"].ToString());
                    row.SetAttribute("description", drPRD["item_description"].ToString());
                    row.SetAttribute("product_status", drPRD["status_name"].ToString());
                    row.SetAttribute("quantity", String.Format("{0:#,0.00}", Decimal.Parse(drPRD["request_qty"].ToString())) ?? "0");
                    row.SetAttribute("open_quantity", String.Format("{0:#,0.00}", Decimal.Parse(drPRD["open_qty"].ToString())) ?? "0");
                    row.SetAttribute("uom", drPRD["uom_name"].ToString());
                    row.SetAttribute("currency", drPRD["currency_id"].ToString());
                    //row.SetAttribute("unit_price", String.Format("{0:#,0.00}", Decimal.Parse(drPRD["unit_price"].ToString())) ?? "0");
                    row.SetAttribute("estimated_cost", String.Format("{0:#,0.00}", Decimal.Parse(drPRD["estimated_cost"].ToString())) ?? "0");
                    row.SetAttribute("estimated_cost_usd", String.Format("{0:#,0.00}", Decimal.Parse(drPRD["estimated_cost_usd"].ToString())) ?? "0");
                    row.SetAttribute("attachment", attachmentList);

                    total += String.Format("{0} {1} <br/>", "(" + drPRD["currency_id"].ToString() + ")",
                                        String.Format("{0:#,0.00}", Decimal.Parse(drPRD["estimated_cost"].ToString()))
                                    );
                    total_usd += Decimal.Parse(drPRD["estimated_cost_usd"].ToString());

                    #region detail cost center
                    Antlr3.ST.StringTemplate rowDcc = group.GetInstanceOf("PRDetailCostCenter");
                    string rowDetailCostCenter_data = string.Empty, rowDetailCostCenter = string.Empty, ccClass = string.Empty;
                    int j = 0;
                    foreach (DataRow dcc in cc.Rows)
                    {
                        if (drPRD["id"].ToString() == dcc["pr_detail_id"].ToString())
                        {
                            if (j % 2 != 0)
                            {
                                ccClass = "basefont";
                            }
                            else
                            {
                                ccClass = "zebra";
                            }

                            Antlr3.ST.StringTemplate rowDcc_data = group.GetInstanceOf("PRDetailCostCenter_Data");

                            var cost_center = String.Format("{0} - {1}", dcc["cost_center_id"].ToString(), dcc["CostCenterName"].ToString());
                            rowDcc_data.SetAttribute("class", ccClass);
                            rowDcc_data.SetAttribute("cost_center", String.Format("{0} - {1}", dcc["cost_center_id"].ToString(), dcc["CostCenterName"].ToString()));
                            rowDcc_data.SetAttribute("work_order", String.Format("{0} - {1}", dcc["work_order"].ToString(), dcc["Description"].ToString()));
                            rowDcc_data.SetAttribute("entity", String.Format("{0} - {1}", dcc["entity_id"].ToString(), dcc["entitydesc"].ToString()));
                            rowDcc_data.SetAttribute("legal_entity", dcc["legal_entity"].ToString());
                            rowDcc_data.SetAttribute("percentage", dcc["percentage"]);
                            rowDcc_data.SetAttribute("amount", String.Format("{0:#,0.00}", Decimal.Parse(dcc["amount"].ToString())) ?? "0");
                            rowDcc_data.SetAttribute("amount_usd", String.Format("{0:#,0.00}", Decimal.Parse(dcc["amount_usd"].ToString())) ?? "0");
                            rowDcc_data.SetAttribute("remarks", dcc["remarks"].ToString());

                            rowDetailCostCenter_data += rowDcc_data.ToString();
                            j++;
                        }
                    }

                    rowDcc.SetAttribute("currency_id", drPRD["currency_id"].ToString());
                    rowDcc.SetAttribute("detail_cost_center_data", rowDetailCostCenter_data);
                    rowDetailCostCenter += rowDcc.ToString();
                    row.SetAttribute("detail_cost_center", rowDetailCostCenter);
                    #endregion

                    rowDetail += row.ToString();
                    i++;
                }
                template.SetAttribute("details", rowDetail);
                template.SetAttribute("is_show_pr_type", Boolean.Parse(drPR["is_show_pr_type"].ToString()));
                template.SetAttribute("purchase_type_description", drPR["purchase_type_description"].ToString());
                template.SetAttribute("purchasing_process", Boolean.Parse(drPR["purchasing_process"].ToString()));
                if (drPR["purchase_type_description"].ToString().ToLower() != "others" && total_usd > 200)
                {
                    isJustification = true;
                }
                template.SetAttribute("isJustification", isJustification);
                template.SetAttribute("direct_to_finance_justification", drPR["direct_to_finance_justification"].ToString());
                template.SetAttribute("is_show_processing_process", Boolean.Parse(drPR["is_show_processing_process"].ToString()));
                template.SetAttribute("is_show_reference_no", Boolean.Parse(drPR["is_show_reference_no"].ToString()));
                template.SetAttribute("reference_no", drPR["reference_no"].ToString());
                template.SetAttribute("total_estimated", total);
                template.SetAttribute("total_estimated_usd", String.Format("{0:#,0.00}", total_usd) ?? "0");
                template.SetAttribute("attachmentgeneral", attachmentListGeneral);
                templateString += template.ToString();
                templateString += attachmentGeneralST.ToString();
                if (isJournal)
                {
                    templateString += AttachmentJournalNoST.ToString();
                }                
                attachmentGeneralST.Reset();
                AttachmentJournalNoST.Reset();
                template.Reset();

                i++;
            }
            return templateString;
        }
    }
}