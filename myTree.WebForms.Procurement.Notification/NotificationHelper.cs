using myTree.WebForms.Procurement.General;
using Serilog;
using System;
using System.Data;
using System.IO;
using System.Linq;
using System.Web;

namespace myTree.WebForms.Procurement.Notification
{
    public class NotificationHelper
    {
        private static Antlr3.ST.StringTemplateGroup group = new Antlr3.ST.StringTemplateGroup("NotificationHelper");
        //private static Antlr3.ST.StringTemplate template = new Antlr3.ST.StringTemplate();
        public static string StartupPath = (Path.GetDirectoryName(System.Reflection.Assembly.GetExecutingAssembly().CodeBase) + @"\EmailTemplate\").Replace("file:\\", "");
        //public static string StartupPath = HttpContext.Current.Server.MapPath("~/EmailTemplate");

        private static bool IsNotificationActive = bool.Parse(statics.GetSetting("NOTIFICATION_IS_ACTIVE"));
        private static bool IsNotificationTestMode = bool.Parse(statics.GetSetting("NOTIFICATION_TEST_MODE"));
        private static string home_url = statics.GetSetting("home_url");
        private static string app_name = statics.GetSetting("App_Pool_Name");
        private static string cifor_icon_path = statics.GetSetting("cifor_icon_path");
        private static string icraf_icon_path = statics.GetSetting("icraf_icon_path");
        private static string rl_icon_path = statics.GetSetting("rl_icon_path");
        private static string glf_icon_path = statics.GetSetting("glf_icon_path");

        #region Purchase Requisition
        public static string PR_WaitingForVerification(string id)
        {
            try
            {
                string module_name = "PURCHASE REQUISITION";
                string type = "WAITING FOR VERIFICATION";
                Boolean isSent = false;
                Boolean isJustification = false;

                string templateString = string.Empty;

                DataSet ds = NotificationData.PurchaseRequisition.WaitingForVerification(id);

                group.RootDir = StartupPath;
                Antlr3.ST.StringTemplate template = group.GetInstanceOf("PRWaitingForVerification");

                //isSent = IsSent(id, module_name, type);

                if (IsNotificationActive && !isSent)
                {
                    if (ds.Tables.Count > 0)
                    {
                        DataTable recipient = ds.Tables[0];
                        DataTable main = ds.Tables[1];
                        DataTable detail = ds.Tables[2];
                        DataTable attachment = ds.Tables[3];
                        DataTable attachmentGeneral = ds.Tables[4];
                        DataTable cc = ds.Tables[6];
                        DataTable grandTotal = ds.Tables[7];
                        DataTable detailPage = ds.Tables[8];

                        int i = 0;
                        string rowClass = string.Empty, rowDetail = string.Empty, attachmentList, attachmentListGeneral
                                , subject = string.Empty, recipients = string.Empty
                                , MainRecipients = string.Empty, SecondaryRecipients = string.Empty, total = string.Empty
                                , link_workspace = string.Empty, link_detail = string.Empty, officeEmail = string.Empty;
                        Decimal total_usd = 0;

                        foreach (DataRow dr in recipient.Rows)
                        {
                            MainRecipients += dr["Email"].ToString() + ";";
                        }

                        //foreach (DataRow drC in cc.Rows)
                        //{
                        //    SecondaryRecipients += drC["Email"].ToString() + ";";
                        //}

                        // set detail page
                        foreach (DataRow dr in detailPage.Rows)
                        {
                            link_detail = String.Format("{0}{1}", home_url, dr["URL"].ToString());
                        }

                        DataRow drM = main.Rows[0];

                        subject = drM["subject"].ToString();

                        //office mail box
                        var office = drM["cifor_office_id"].ToString();
                        DataTable office_mailbox = statics.GetEmailProcurementOffice(office);
                        foreach (DataRow dr in office_mailbox.Rows)
                        {
                            officeEmail += string.Format(@"<a href='mailto:{0}' target='_blank' rel='noopener noreferrer' 
                                            data-auth='NotApplicable' data-safelink='true' data-linkindex='4' class='email-footer'>{0}</a>, "
                                                   , dr["Email"].ToString());
                        }
                        officeEmail = officeEmail.Remove(officeEmail.Length - 2);

                        /* PR Details */
                        foreach (DataRow dr in detail.Rows)
                        {
                            attachmentList = string.Empty;

                            DataRow[] dtDetailAttachment = attachment.Select("document_id='" + dr["id"].ToString() + "'", "id");
                            int ai = 0;
                            foreach (DataRow dra in dtDetailAttachment)
                            {
                                if (ai != 0)
                                {
                                    attachmentList += "<br/>";
                                }
                                attachmentList += "<a href='" + drM["file_link"].ToString() + dra["filename"].ToString() + "'>" + dra["filename"].ToString() + "</a<br/>";
                                ai++;
                            }

                            if (i % 2 != 0)
                            {
                                rowClass = "basefont";
                            }
                            else
                            {
                                rowClass = "zebra";
                            }

                            Antlr3.ST.StringTemplate row = group.GetInstanceOf("PRDataA");
                            row.SetAttribute("class", rowClass);
                            row.SetAttribute("item_code", dr["item_code"].ToString());
                            row.SetAttribute("description", dr["description"].ToString());
                            row.SetAttribute("quantity", String.Format("{0:#,0.00}", Decimal.Parse(dr["request_qty"].ToString())) ?? "0");
                            row.SetAttribute("uom", dr["uom"].ToString());
                            row.SetAttribute("unit_price", String.Format("{0} {1:#,0.00}", dr["currency_id"].ToString(), Decimal.Parse(dr["unit_price"].ToString())) ?? "0");
                            row.SetAttribute("estimated_cost", String.Format("{0} {1:#,0.00}", dr["currency_id"].ToString(), Decimal.Parse(dr["estimated_cost"].ToString())) ?? "0");
                            row.SetAttribute("estimated_cost_usd", String.Format("{0:#,0.00}", Decimal.Parse(dr["estimated_cost_usd"].ToString())) ?? "0");
                            row.SetAttribute("exchange_rate", String.Format("{0:N6}", Decimal.Parse(dr["exchange_rate"].ToString())) ?? "0");

                            /* Check if has multiple charge codes */
                            //var chargeCodes = dr["charge_codes"].ToString().Split(',');
                            //if (chargeCodes.Length > 0 && chargeCodes.Length != 1)
                            //{
                            //    var strChargeCodes = "<ul>";
                            //    foreach (var c in chargeCodes)
                            //        strChargeCodes += string.Format("<li>{0}</li>", c);
                            //    strChargeCodes += "</ul>";
                            //    row.SetAttribute("charge_codes", strChargeCodes);
                            //}
                            //else
                            //    row.SetAttribute("charge_codes", dr["charge_codes"].ToString());
                            /* End Check if has multiple charge codes */
                            row.SetAttribute("attachment", attachmentList);

                            #region detail cost center
                            Antlr3.ST.StringTemplate rowDcc = group.GetInstanceOf("DetailCostCenter");
                            string rowDetailCostCenter_data = string.Empty, rowDetailCostCenter = string.Empty, ccClass = string.Empty;
                            int j = 0;
                            foreach (DataRow dcc in cc.Rows)
                            {
                                if (dr["id"].ToString() == dcc["pr_detail_id"].ToString())
                                {
                                    if (j % 2 != 0)
                                    {
                                        ccClass = "basefont";
                                    }
                                    else
                                    {
                                        ccClass = "zebra";
                                    }

                                    Antlr3.ST.StringTemplate rowDcc_data = group.GetInstanceOf("DetailCostCenter_Data");

                                    var cost_center = String.Format("{0} - {1}", dcc["cost_center_id"].ToString(), dcc["cost_center_name"].ToString());
                                    rowDcc_data.SetAttribute("class", ccClass);
                                    rowDcc_data.SetAttribute("cost_center", String.Format("{0} - {1}", dcc["cost_center_id"].ToString(), dcc["cost_center_name"].ToString()));
                                    rowDcc_data.SetAttribute("work_order", String.Format("{0} - {1}", dcc["work_order"].ToString(), dcc["work_order_description"].ToString()));
                                    rowDcc_data.SetAttribute("entity", String.Format("{0} - {1}", dcc["entity_id"].ToString(), dcc["entity_description"].ToString()));
                                    rowDcc_data.SetAttribute("legal_entity", dcc["legal_entity"].ToString());
                                    rowDcc_data.SetAttribute("percentage", dcc["percentage"]);
                                    rowDcc_data.SetAttribute("amount", String.Format("{0:#,0.00}", Decimal.Parse(dcc["amount"].ToString())) ?? "0");
                                    rowDcc_data.SetAttribute("amount_usd", String.Format("{0:#,0.00}", Decimal.Parse(dcc["amount_usd"].ToString())) ?? "0");
                                    rowDcc_data.SetAttribute("remarks", dcc["remarks"].ToString());

                                    rowDetailCostCenter_data += rowDcc_data.ToString();
                                    j++;
                                }
                            }


                            rowDcc.SetAttribute("currency_id", dr["currency_id"].ToString());
                            rowDcc.SetAttribute("detail_cost_center_data", rowDetailCostCenter_data);
                            rowDetailCostCenter += rowDcc.ToString();
                            row.SetAttribute("detail_cost_center", rowDetailCostCenter);
                            #endregion

                            rowDetail += row.ToString();

                            i++;
                        }

                        #region grand total
                        foreach (DataRow gTotal in grandTotal.Rows)
                        {
                            total += String.Format("{0} {1} <br/>", gTotal["currency_id"].ToString(),
                                        String.Format("{0:#,0.00}", Decimal.Parse(gTotal["total"].ToString()))
                                    );
                            total_usd += Decimal.Parse(gTotal["total_usd"].ToString());
                        }
                        #endregion

                        attachmentListGeneral = string.Empty;

                        DataRow[] dtDetailAttachmentGeneral = attachmentGeneral.Select("document_id='" + drM["id"].ToString() + "'", "id");
                        int ag = 0;
                        foreach (DataRow dra in dtDetailAttachmentGeneral)
                        {
                            if (ag != 0)
                            {
                                attachmentListGeneral += "<br/>";
                            }
                            attachmentListGeneral += "<a href='" + drM["file_link"].ToString() + dra["filename"].ToString() + "'>" + dra["filename"].ToString() + "</a><br/>";
                            ag++;
                        }

                        template.SetAttribute("isTest", IsNotificationTestMode);
                        if (IsNotificationTestMode)
                        {
                            template.SetAttribute("TO_CC", ProcesTestModeTemplate(MainRecipients, drM["subject"].ToString(), SecondaryRecipients));
                        }
                        else
                        {
                            template.SetAttribute("TO_CC", SecondaryRecipients);
                        }
                        template.SetAttribute("requester", drM["requester_name"].ToString());
                        template.SetAttribute("required_date", drM["required_date"].ToString());
                        template.SetAttribute("office", drM["cifor_office_name"].ToString());

                        /*template.SetAttribute("isDirectToFinance", Boolean.Parse(drM["isDirectToFinance"].ToString()));
                        template.SetAttribute("is_direct_to_finance", drM["is_direct_to_finance"].ToString());
                        template.SetAttribute("direct_to_finance_justification", drM["direct_to_finance_justification"].ToString());*/

                        //template.SetAttribute("cost_center", drM["cost_center"].ToString());
                        //template.SetAttribute("currency", drM["currency_id"].ToString());
                        //template.SetAttribute("exchange_rate", String.Format("{0:#,0.000000}", Decimal.Parse(drM["exchange_rate"].ToString())));


                        if (drM["purchase_type_description"].ToString().ToLower() != "other" && total_usd > 200)
                        {
                            isJustification = true;
                        }
                        template.SetAttribute("isJustification", isJustification);

                        template.SetAttribute("remarks", drM["remarks"].ToString());
                        template.SetAttribute("purchase_type_description", drM["purchase_type_description"].ToString());
                        template.SetAttribute("purchasing_process", Boolean.Parse(drM["purchasing_process"].ToString()));
                        template.SetAttribute("direct_to_finance_justification", drM["direct_to_finance_justification"].ToString());
                        template.SetAttribute("is_show_processing_process", Boolean.Parse(drM["is_show_processing_process"].ToString()));
                        template.SetAttribute("details", rowDetail);
                        template.SetAttribute("attachmentgeneral", attachmentListGeneral);
                        template.SetAttribute("total", total);
                        template.SetAttribute("total_usd", String.Format("{0:#,0.00}", total_usd));

                        Antlr3.ST.StringTemplate Style = group.GetInstanceOf("Style");
                        template.SetAttribute("Style", Style);

                        Antlr3.ST.StringTemplate Footer = group.GetInstanceOf("Footer");
                        Footer.SetAttribute("mailbox", officeEmail);
                        template.SetAttribute("Footer", Footer);

                        template.SetAttribute("link_detail", link_detail);

                        templateString = template.ToString();
                        template.Reset();

                        templateString = SendEmail(MainRecipients, templateString, drM["subject"].ToString(), SecondaryRecipients);
                        InsertLog(id, module_name, type, templateString);
                    }
                }
                return templateString;
            }
            catch (Exception ex)
            {
                Log.Logger.Error(ex.Message == "" ? ex.InnerException.Message : ex.Message);
                return string.Empty;
            }
        }

        public static string PR_WaitingForVerificationUser(string id)
        {
            try
            {
     
                string module_name = "PURCHASE REQUISITION";
                string type = "WAITING FOR VERIFICATION USER";
                Boolean isSent = false, isJustification = false;

                string templateString = string.Empty;

                DataSet ds = NotificationData.PurchaseRequisition.WaitingForVerificationUser(id);

                group.RootDir = StartupPath;
                Antlr3.ST.StringTemplate template = group.GetInstanceOf("PRWaitingForVerificationUser");

                //isSent = IsSent(id, module_name, type);

                if (IsNotificationActive && !isSent)
                {
                    if (ds.Tables.Count > 0)
                    {
                        DataTable recipient = ds.Tables[0];
                        DataTable main = ds.Tables[1];
                        DataTable detail = ds.Tables[2];
                        DataTable attachment = ds.Tables[3];
                        DataTable attachmentGeneral = ds.Tables[4];
                        DataTable cc = ds.Tables[5];
                        DataTable grandTotal = ds.Tables[6];


                        int i = 0;
                        string rowClass = string.Empty, rowDetail = string.Empty, attachmentList, attachmentListGeneral, team = string.Empty
                                , subject = string.Empty, recipients = string.Empty
                                , MainRecipients = string.Empty, SecondaryRecipients = string.Empty, officeEmail = string.Empty
                                , total = string.Empty;
                        Boolean team_email = false;
                        Decimal total_usd = 0;

                        foreach (DataRow dr in recipient.Rows)
                        {
                            MainRecipients += dr["Email"].ToString() + ";";
                        }

                        //foreach (DataRow drC in cc.Rows)
                        //{
                        //    SecondaryRecipients += drC["Email"].ToString() + ";";
                        //}

                        DataRow drM = main.Rows[0];

                        subject = drM["subject"].ToString();
                        //office mail box
                        var office = drM["cifor_office_name"].ToString();
                        DataTable office_mailbox = statics.GetEmailProcurementOffice(office);
                        foreach (DataRow dr in office_mailbox.Rows)
                        {
                            officeEmail += string.Format(@"<a href='mailto:{0}' target='_blank' rel='noopener noreferrer' 
                                            data-auth='NotApplicable' data-safelink='true' data-linkindex='4' class='email-footer'>{0}</a>, "
                                                   , dr["Email"].ToString());
                        }
                        officeEmail = officeEmail.Remove(officeEmail.Length - 2);

                        foreach (DataRow dr in detail.Rows)
                        {
                            attachmentList = string.Empty;

                            DataRow[] dtDetailAttachment = attachment.Select("document_id='" + dr["id"].ToString() + "'", "id");
                            int ai = 0;
                            foreach (DataRow dra in dtDetailAttachment)
                            {
                                if (ai != 0)
                                {
                                    attachmentList += "<br/>";
                                }
                                attachmentList += "<a href='" + drM["file_link"].ToString() + dra["filename"].ToString() + "'>" + dra["filename"].ToString() + "</a><br/>";
                            }

                            if (i % 2 != 0)
                            {
                                rowClass = "basefont";
                            }
                            else
                            {
                                rowClass = "zebra";
                            }

                            Antlr3.ST.StringTemplate row = group.GetInstanceOf("PRDataA");
                            row.SetAttribute("class", rowClass);
                            row.SetAttribute("item_code", dr["item_code"].ToString());
                            row.SetAttribute("description", dr["description"].ToString());
                            row.SetAttribute("quantity", String.Format("{0:#,0.00}", Decimal.Parse(dr["request_qty"].ToString())) ?? "0");
                            row.SetAttribute("uom", dr["uom"].ToString());
                            row.SetAttribute("unit_price", String.Format("{0} {1:#,0.00}", dr["currency_id"].ToString(), Decimal.Parse(dr["unit_price"].ToString())) ?? "0");
                            row.SetAttribute("estimated_cost", String.Format("{0} {1:#,0.00}", dr["currency_id"].ToString(), Decimal.Parse(dr["estimated_cost"].ToString())) ?? "0");
                            row.SetAttribute("estimated_cost_usd", String.Format("{0:#,0.00}", Decimal.Parse(dr["estimated_cost_usd"].ToString())) ?? "0");
                            row.SetAttribute("exchange_rate", String.Format("{0:N6}", Decimal.Parse(dr["exchange_rate"].ToString())) ?? "0");
                            row.SetAttribute("attachment", attachmentList);


                            #region detail cost center
                            Antlr3.ST.StringTemplate rowDcc = group.GetInstanceOf("DetailCostCenter");
                            string rowDetailCostCenter_data = string.Empty, rowDetailCostCenter = string.Empty, ccClass = string.Empty;
                            int j = 0;
                            foreach (DataRow dcc in cc.Rows)
                            {
                                if (dr["id"].ToString() == dcc["pr_detail_id"].ToString())
                                {
                                    if (j % 2 != 0)
                                    {
                                        ccClass = "basefont";
                                    }
                                    else
                                    {
                                        ccClass = "zebra";
                                    }

                                    Antlr3.ST.StringTemplate rowDcc_data = group.GetInstanceOf("DetailCostCenter_Data");

                                    var cost_center = String.Format("{0} - {1}", dcc["cost_center_id"].ToString(), dcc["cost_center_name"].ToString());
                                    rowDcc_data.SetAttribute("class", ccClass);
                                    rowDcc_data.SetAttribute("cost_center", String.Format("{0} - {1}", dcc["cost_center_id"].ToString(), dcc["cost_center_name"].ToString()));
                                    rowDcc_data.SetAttribute("work_order", String.Format("{0} - {1}", dcc["work_order"].ToString(), dcc["work_order_description"].ToString()));
                                    rowDcc_data.SetAttribute("entity", String.Format("{0} - {1}", dcc["entity_id"].ToString(), dcc["entity_description"].ToString()));
                                    rowDcc_data.SetAttribute("legal_entity", dcc["legal_entity"].ToString());
                                    rowDcc_data.SetAttribute("percentage", dcc["percentage"]);
                                    rowDcc_data.SetAttribute("amount", String.Format("{0:#,0.00}", Decimal.Parse(dcc["amount"].ToString())) ?? "0");
                                    rowDcc_data.SetAttribute("amount_usd", String.Format("{0:#,0.00}", Decimal.Parse(dcc["amount_usd"].ToString())) ?? "0");
                                    rowDcc_data.SetAttribute("remarks", dcc["remarks"].ToString());

                                    rowDetailCostCenter_data += rowDcc_data.ToString();
                                    j++;
                                }
                            }


                            rowDcc.SetAttribute("currency_id", dr["currency_id"].ToString());
                            rowDcc.SetAttribute("detail_cost_center_data", rowDetailCostCenter_data);
                            rowDetailCostCenter += rowDcc.ToString();
                            row.SetAttribute("detail_cost_center", rowDetailCostCenter);
                            #endregion

                            rowDetail += row.ToString();
                            i++;
                        }

                        #region grand total
                        foreach (DataRow gTotal in grandTotal.Rows)
                        {
                            total += String.Format("{0} {1} <br/>", gTotal["currency_id"].ToString(),
                                        String.Format("{0:#,0.00}", Decimal.Parse(gTotal["total"].ToString()))
                                    );
                            total_usd += Decimal.Parse(gTotal["total_usd"].ToString());
                        }
                        #endregion

                        attachmentListGeneral = string.Empty;

                        DataRow[] dtDetailAttachmentGeneral = attachmentGeneral.Select("document_id='" + drM["id"].ToString() + "'", "id");
                        int ag = 0;
                        foreach (DataRow dra in dtDetailAttachmentGeneral)
                        {
                            if (ag != 0)
                            {
                                attachmentListGeneral += "<br/>";
                            }
                            attachmentListGeneral += "<a href='" + drM["file_link"].ToString() + dra["filename"].ToString() + "'>" + dra["filename"].ToString() + "</a><br/>";
                            ag++;
                        }

                        team = (drM["status_id"].ToString() == "21" || drM["status_id"].ToString() == "22") ? "Finance" : "Procurement";
                        team_email = (drM["status_id"].ToString() == "21" || drM["status_id"].ToString() == "22") ? true : false;

                        template.SetAttribute("team", team);
                        template.SetAttribute("team_email", team_email);
                        template.SetAttribute("isTest", IsNotificationTestMode);
                        if (IsNotificationTestMode)
                        {
                            template.SetAttribute("TO_CC", ProcesTestModeTemplate(MainRecipients, drM["subject"].ToString(), SecondaryRecipients));
                        }
                        else
                        {
                            template.SetAttribute("TO_CC", "");
                        }
                        template.SetAttribute("requester", drM["requester_name"].ToString());
                        template.SetAttribute("required_date", drM["required_date"].ToString());
                        template.SetAttribute("office", drM["cifor_office_name"].ToString());

                        /*template.SetAttribute("isDirectToFinance", Boolean.Parse(drM["isDirectToFinance"].ToString()));
                        template.SetAttribute("is_direct_to_finance", drM["is_direct_to_finance"].ToString());
                        template.SetAttribute("direct_to_finance_justification", drM["direct_to_finance_justification"].ToString());*/

                        //template.SetAttribute("cost_center", drM["cost_center"].ToString());
                        //template.SetAttribute("currency", drM["currency_id"].ToString());
                        //template.SetAttribute("exchange_rate", String.Format("{0:#,0.000000}", Decimal.Parse(drM["exchange_rate"].ToString())));

                        if (drM["purchase_type_description"].ToString().ToLower() != "other" && total_usd > 200)
                        {
                            isJustification = true;
                        }
                        template.SetAttribute("isJustification", isJustification);

                        template.SetAttribute("remarks", drM["remarks"].ToString());
                        template.SetAttribute("purchase_type_description", drM["purchase_type_description"].ToString());
                        template.SetAttribute("purchasing_process", Boolean.Parse(drM["purchasing_process"].ToString()));
                        template.SetAttribute("direct_to_finance_justification", drM["direct_to_finance_justification"].ToString());
                        template.SetAttribute("is_show_processing_process", Boolean.Parse(drM["is_show_processing_process"].ToString()));
                        template.SetAttribute("details", rowDetail);
                        template.SetAttribute("attachmentgeneral", attachmentListGeneral);
                        template.SetAttribute("total", total);
                        template.SetAttribute("total_usd", String.Format("{0:#,0.00}", total_usd));

                        Antlr3.ST.StringTemplate Style = group.GetInstanceOf("Style");
                        template.SetAttribute("Style", Style);

                        var profile_page = String.Format("<a href='{0}{1}/PurchaseRequisition/detail.aspx?id={2}'>View details</a>", home_url,app_name,id);
                        template.SetAttribute("profile_page", profile_page);

                        Antlr3.ST.StringTemplate Footer = group.GetInstanceOf("Footer");
                        Footer.SetAttribute("mailbox", officeEmail);

                        template.SetAttribute("Footer", Footer);

                        templateString = template.ToString();
                        template.Reset();

                        templateString = SendEmail(MainRecipients, templateString, drM["subject"].ToString(), SecondaryRecipients);
                        InsertLog(id, module_name, type, templateString);
                    }
                }
                return templateString;
            }
            catch (Exception ex)
            {
                Log.Logger.Error(ex.Message == "" ? ex.InnerException.Message : ex.Message);
                return string.Empty;
            }
        }

        public static string PR_WaitingForVerificationFinance(string id)
        {
            try
            {

                string module_name = "PURCHASE REQUISITION";
                string type = "WAITING FOR FINANCE VERIFICATION FINANCE";
                Boolean isSent = false;

                string templateString = string.Empty;

                DataSet ds = NotificationData.PurchaseRequisition.WaitingForVerificationFinance(id);

                group.RootDir = StartupPath;
                Antlr3.ST.StringTemplate template = group.GetInstanceOf("PRWaitingForVerificationFinance");

                //isSent = IsSent(id, module_name, type);

                if (IsNotificationActive && !isSent)
                {
                    if (ds.Tables.Count > 0)
                    {
                        DataTable recipient = ds.Tables[0];
                        DataTable main = ds.Tables[1];
                        DataTable detail = ds.Tables[2];
                        DataTable attachment = ds.Tables[3];
                        //DataTable cc = ds.Tables[4];
                        DataTable cc = ds.Tables[5];
                        DataTable grandTotal = ds.Tables[6];

                        int i = 0;
                        string rowClass = string.Empty, rowDetail = string.Empty, attachmentList
                                , subject = string.Empty, recipients = string.Empty
                                , MainRecipients = string.Empty, SecondaryRecipients = string.Empty, total = string.Empty
                                , link_workspace = string.Empty;
                        Decimal total_usd = 0;
                        foreach (DataRow dr in recipient.Rows)
                        {
                            MainRecipients += dr["Email"].ToString() + ";";
                        }

                        //foreach (DataRow drC in cc.Rows)
                        //{
                        //    SecondaryRecipients += drC["Email"].ToString() + ";";
                        //}

                        DataRow drM = main.Rows[0];

                        subject = drM["subject"].ToString();
                        //office mail box
                        var office = drM["cifor_office_name"].ToString();
                        DataTable office_mailbox = statics.GetProcurementOffice(office);
                        foreach (DataRow dr in office_mailbox.Rows)
                        {
                            SecondaryRecipients += dr["Email"].ToString() + ";";
                        }


                        foreach (DataRow dr in detail.Rows)
                        {
                            attachmentList = string.Empty;

                            DataRow[] dtDetailAttachment = attachment.Select("document_id='" + dr["id"].ToString() + "'", "id");
                            int ai = 0;
                            foreach (DataRow dra in dtDetailAttachment)
                            {
                                if (ai != 0)
                                {
                                    attachmentList += "<br/>";
                                }
                                attachmentList += "<a href='" + drM["file_link"].ToString() + dra["filename"].ToString() + "'>" + dra["filename"].ToString() + "</a><br/>";
                            }

                            if (i % 2 != 0)
                            {
                                rowClass = "basefont";
                            }
                            else
                            {
                                rowClass = "zebra";
                            }

                            Antlr3.ST.StringTemplate row = group.GetInstanceOf("PRDataA");
                            row.SetAttribute("class", rowClass);
                            row.SetAttribute("item_code", dr["item_code"].ToString());
                            row.SetAttribute("description", dr["description"].ToString());
                            row.SetAttribute("quantity", String.Format("{0:#,0.00}", Decimal.Parse(dr["request_qty"].ToString())) ?? "0");
                            row.SetAttribute("uom", dr["uom"].ToString());
                            row.SetAttribute("unit_price", String.Format("{0} {1:#,0.00}", dr["currency_id"].ToString(), Decimal.Parse(dr["unit_price"].ToString())) ?? "0");
                            row.SetAttribute("estimated_cost", String.Format("{0} {1:#,0.00}", dr["currency_id"].ToString(), Decimal.Parse(dr["estimated_cost"].ToString())) ?? "0");
                            row.SetAttribute("estimated_cost_usd", String.Format("{0:#,0.00}", Decimal.Parse(dr["estimated_cost_usd"].ToString())) ?? "0");
                            row.SetAttribute("exchange_rate", String.Format("{0:N6}", Decimal.Parse(dr["exchange_rate"].ToString())) ?? "0");

                            ///* Check if has multiple charge codes */
                            //var chargeCodes = dr["charge_codes"].ToString().Split(',');
                            //if (chargeCodes.Length > 0 && chargeCodes.Length != 1)
                            //{
                            //    var strChargeCodes = "<ul>";
                            //    foreach (var c in chargeCodes)
                            //        strChargeCodes += string.Format("<li>{0}</li>", c);
                            //    strChargeCodes += "</ul>";
                            //    row.SetAttribute("charge_codes", strChargeCodes);
                            //}
                            //else
                            //    row.SetAttribute("charge_codes", dr["charge_codes"].ToString());
                            ///* End Check if has multiple charge codes */

                            row.SetAttribute("attachment", attachmentList);

                            #region detail cost center
                            Antlr3.ST.StringTemplate rowDcc = group.GetInstanceOf("DetailCostCenter");
                            string rowDetailCostCenter_data = string.Empty, rowDetailCostCenter = string.Empty, ccClass = string.Empty;
                            int j = 0;
                            foreach (DataRow dcc in cc.Rows)
                            {
                                if (dr["id"].ToString() == dcc["pr_detail_id"].ToString())
                                {
                                    if (j % 2 != 0)
                                    {
                                        ccClass = "basefont";
                                    }
                                    else
                                    {
                                        ccClass = "zebra";
                                    }

                                    Antlr3.ST.StringTemplate rowDcc_data = group.GetInstanceOf("DetailCostCenter_Data");

                                    var cost_center = String.Format("{0} - {1}", dcc["cost_center_id"].ToString(), dcc["cost_center_name"].ToString());
                                    rowDcc_data.SetAttribute("class", ccClass);
                                    rowDcc_data.SetAttribute("cost_center", String.Format("{0} - {1}", dcc["cost_center_id"].ToString(), dcc["cost_center_name"].ToString()));
                                    rowDcc_data.SetAttribute("work_order", String.Format("{0} - {1}", dcc["work_order"].ToString(), dcc["work_order_description"].ToString()));
                                    rowDcc_data.SetAttribute("entity", String.Format("{0} - {1}", dcc["entity_id"].ToString(), dcc["entity_description"].ToString()));
                                    rowDcc_data.SetAttribute("legal_entity", dcc["legal_entity"].ToString());
                                    rowDcc_data.SetAttribute("percentage", dcc["percentage"]);
                                    rowDcc_data.SetAttribute("amount", dcc["amount"]);
                                    rowDcc_data.SetAttribute("amount_usd", dcc["amount_usd"]);
                                    rowDcc_data.SetAttribute("remarks", dcc["remarks"].ToString());

                                    rowDetailCostCenter_data += rowDcc_data.ToString();
                                    j++;
                                }
                            }


                            rowDcc.SetAttribute("currency_id", dr["currency_id"].ToString());
                            rowDcc.SetAttribute("detail_cost_center_data", rowDetailCostCenter_data);
                            rowDetailCostCenter += rowDcc.ToString();
                            row.SetAttribute("detail_cost_center", rowDetailCostCenter);
                            #endregion

                            rowDetail += row.ToString();
                            i++;
                        }

                        #region grand total
                        foreach (DataRow gTotal in grandTotal.Rows)
                        {
                            total += String.Format("{0} {1} <br/>", gTotal["currency_id"].ToString(), gTotal["total"].ToString());
                            total_usd += Decimal.Parse(gTotal["total_usd"].ToString());
                        }
                        #endregion

                        template.SetAttribute("isTest", IsNotificationTestMode);
                        if (IsNotificationTestMode)
                        {
                            template.SetAttribute("TO_CC", ProcesTestModeTemplate(MainRecipients, drM["subject"].ToString(), SecondaryRecipients));
                        }
                        else
                        {
                            template.SetAttribute("TO_CC", "");
                        }
                        template.SetAttribute("requester", drM["requester_name"].ToString());
                        template.SetAttribute("required_date", drM["required_date"].ToString());
                        template.SetAttribute("office", drM["cifor_office_name"].ToString());

                        /*template.SetAttribute("isDirectToFinance", Boolean.Parse(drM["isDirectToFinance"].ToString()));
                        template.SetAttribute("is_direct_to_finance", drM["is_direct_to_finance"].ToString());
                        template.SetAttribute("direct_to_finance_justification", drM["direct_to_finance_justification"].ToString());*/

                        //template.SetAttribute("cost_center", drM["cost_center"].ToString());
                        //template.SetAttribute("currency", drM["currency_id"].ToString());
                        //template.SetAttribute("exchange_rate", String.Format("{0:#,0.000000}", Decimal.Parse(drM["exchange_rate"].ToString())));

                        template.SetAttribute("remarks", drM["remarks"].ToString());
                        template.SetAttribute("purchase_type_description", drM["purchase_type_description"].ToString());
                        template.SetAttribute("purchasing_process", Boolean.Parse(drM["purchasing_process"].ToString()));
                        template.SetAttribute("direct_to_finance_justification", drM["direct_to_finance_justification"].ToString());
                        template.SetAttribute("is_show_processing_process", Boolean.Parse(drM["is_show_processing_process"].ToString()));
                        template.SetAttribute("details", rowDetail);
                        template.SetAttribute("total", String.Format("{0:#,0.00}", total));
                        template.SetAttribute("total_usd", String.Format("{0:#,0.00}", total_usd));

                        Antlr3.ST.StringTemplate Style = group.GetInstanceOf("Style");
                        template.SetAttribute("Style", Style);

                        Antlr3.ST.StringTemplate Footer = group.GetInstanceOf("Footer");
                        template.SetAttribute("Footer", Footer);

                        link_workspace = String.Format("{0}workspace", home_url);
                        template.SetAttribute("link_workspace", link_workspace);

                        templateString = template.ToString();
                        template.Reset();

                        templateString = SendEmail(MainRecipients, templateString, drM["subject"].ToString(), SecondaryRecipients);
                        InsertLog(id, module_name, type, templateString);
                    }
                }
                return templateString;
            }
            catch (Exception ex)
            {
                Log.Logger.Error(ex.Message == "" ? ex.InnerException.Message : ex.Message);
                return string.Empty;
            }
        }

        public static string PR_WaitingForPayment(string id)
        {
            string module_name = "PURCHASE REQUISITION";
            string type = "WAITING FOR PAYMENT";
            Boolean isSent = false, isJustification = false;

            string templateString = string.Empty;

            DataSet ds = NotificationData.PurchaseRequisition.WaitingForpayment(id);

            group.RootDir = StartupPath;
            Antlr3.ST.StringTemplate template = group.GetInstanceOf("PRWaitingForPayment");

            //isSent = IsSent(id, module_name, type);

            if (IsNotificationActive && !isSent)
            {
                if (ds.Tables.Count > 0)
                {
                    DataTable recipient = ds.Tables[0];
                    DataTable main = ds.Tables[1];
                    DataTable detail = ds.Tables[2];
                    DataTable attachment = ds.Tables[3];
                    DataTable attachmentGeneral = ds.Tables[4];
                    DataTable CC = ds.Tables[5];
                    DataTable cc = ds.Tables[6]; //cost center / charge code
                    DataTable grandTotal = ds.Tables[7];
                    DataTable detailPage = ds.Tables[8];
                    DataTable mailBox = ds.Tables[9];

                    int i = 0;
                    string rowClass = string.Empty, rowDetail = string.Empty, attachmentList, attachmentListGeneral
                            , subject = string.Empty, recipients = string.Empty
                            , MainRecipients = string.Empty, SecondaryRecipients = string.Empty
                            , total = string.Empty
                            , link_workspace = string.Empty
                            , link_detail = string.Empty
                            , mailbox = string.Empty;

                    Decimal total_usd = 0;

                    foreach (DataRow dr in recipient.Rows)
                    {
                        MainRecipients += dr["Email"].ToString() + ";";
                    }

                    //foreach (DataRow drC in CC.Rows)
                    //{
                    //    SecondaryRecipients += drC["Email"].ToString() + ";";
                    //}



                    // set detail page
                    foreach (DataRow dr in detailPage.Rows)
                    {
                        link_detail = String.Format("{0}{1}", home_url, dr["URL"].ToString());
                    }

                    DataRow drM = main.Rows[0];

                    subject = drM["subject"].ToString();

                    #region mailbox
                    if(mailBox.Rows.Count > 0)
                    {
                        foreach (DataRow dr in mailBox.Rows)
                        {

                            mailbox += string.Format(@"<a href='mailto:{0}' target='_blank' rel='noopener noreferrer' 
                                            data-auth='NotApplicable' data-safelink='true' data-linkindex='4' class='email-footer'>{0}</a>, "
                                         , dr["mailbox"].ToString());
                        }
                        mailbox = mailbox.Remove(mailbox.Length - 2);
                    }
                   

                    #endregion



                    foreach (DataRow dr in detail.Rows)
                    {
                        attachmentList = string.Empty;

                        DataRow[] dtDetailAttachment = attachment.Select("document_id='" + dr["id"].ToString() + "'", "id");
                        int ai = 0;
                        foreach (DataRow dra in dtDetailAttachment)
                        {
                            if (ai != 0)
                            {
                                attachmentList += "<br/>";
                            }
                            attachmentList += "<a href='" + drM["file_link"].ToString() + dra["filename"].ToString() + "'>" + dra["filename"].ToString() + "</a><br>";
                        }

                        if (i % 2 != 0)
                        {
                            rowClass = "basefont";
                        }
                        else
                        {
                            rowClass = "zebra";
                        }

                        Antlr3.ST.StringTemplate row = group.GetInstanceOf("PRDataA");
                        row.SetAttribute("class", rowClass);
                        row.SetAttribute("item_code", dr["item_code"].ToString());
                        row.SetAttribute("description", dr["description"].ToString());
                        row.SetAttribute("quantity", String.Format("{0:#,0.00}", Decimal.Parse(dr["request_qty"].ToString())) ?? "0");
                        row.SetAttribute("uom", dr["uom"].ToString());
                        row.SetAttribute("unit_price", String.Format("{0} {1:#,0.00}", dr["currency_id"].ToString(), Decimal.Parse(dr["unit_price"].ToString())) ?? "0");
                        row.SetAttribute("estimated_cost", String.Format("{0} {1:#,0.00}", dr["currency_id"].ToString(), Decimal.Parse(dr["estimated_cost"].ToString())) ?? "0");
                        row.SetAttribute("estimated_cost_usd", String.Format("{0:#,0.00}", Decimal.Parse(dr["estimated_cost_usd"].ToString())) ?? "0");
                        row.SetAttribute("exchange_rate", String.Format("{0:N6}", Decimal.Parse(dr["exchange_rate"].ToString())) ?? "0");
                        row.SetAttribute("attachment", attachmentList);

                        #region detail cost center
                        Antlr3.ST.StringTemplate rowDcc = group.GetInstanceOf("DetailCostCenter");
                        string rowDetailCostCenter_data = string.Empty, rowDetailCostCenter = string.Empty, ccClass = string.Empty;
                        int j = 0;
                        foreach (DataRow dcc in cc.Rows)
                        {
                            if (dr["id"].ToString() == dcc["pr_detail_id"].ToString())
                            {
                                if (j % 2 != 0)
                                {
                                    ccClass = "basefont";
                                }
                                else
                                {
                                    ccClass = "zebra";
                                }

                                Antlr3.ST.StringTemplate rowDcc_data = group.GetInstanceOf("DetailCostCenter_Data");

                                var cost_center = String.Format("{0} - {1}", dcc["cost_center_id"].ToString(), dcc["cost_center_name"].ToString());
                                rowDcc_data.SetAttribute("class", ccClass);
                                rowDcc_data.SetAttribute("cost_center", String.Format("{0} - {1}", dcc["cost_center_id"].ToString(), dcc["cost_center_name"].ToString()));
                                rowDcc_data.SetAttribute("work_order", String.Format("{0} - {1}", dcc["work_order"].ToString(), dcc["work_order_description"].ToString()));
                                rowDcc_data.SetAttribute("entity", String.Format("{0} - {1}", dcc["entity_id"].ToString(), dcc["entity_description"].ToString()));
                                rowDcc_data.SetAttribute("legal_entity", dcc["legal_entity"].ToString());
                                rowDcc_data.SetAttribute("percentage", dcc["percentage"]);
                                rowDcc_data.SetAttribute("amount", String.Format("{0:#,0.00}", Decimal.Parse(dcc["amount"].ToString())) ?? "0");
                                rowDcc_data.SetAttribute("amount_usd", String.Format("{0:#,0.00}", Decimal.Parse(dcc["amount_usd"].ToString())) ?? "0");
                                rowDcc_data.SetAttribute("remarks", dcc["remarks"].ToString());

                                rowDetailCostCenter_data += rowDcc_data.ToString();
                                j++;
                            }
                        }


                        rowDcc.SetAttribute("currency_id", dr["currency_id"].ToString());
                        rowDcc.SetAttribute("detail_cost_center_data", rowDetailCostCenter_data);
                        rowDetailCostCenter += rowDcc.ToString();
                        row.SetAttribute("detail_cost_center", rowDetailCostCenter);
                        #endregion

                        rowDetail += row.ToString();
                        i++;
                    }

                    #region grand total
                    foreach (DataRow gTotal in grandTotal.Rows)
                    {
                        total += String.Format("{0} {1} <br/>", gTotal["currency_id"].ToString(),
                                    String.Format("{0:#,0.00}", Decimal.Parse(gTotal["total"].ToString()))
                                );
                        total_usd += Decimal.Parse(gTotal["total_usd"].ToString());
                    }
                    #endregion

                    attachmentListGeneral = string.Empty;

                    DataRow[] dtDetailAttachmentGeneral = attachmentGeneral.Select("document_id='" + drM["id"].ToString() + "'", "id");
                    int ag = 0;
                    foreach (DataRow dra in dtDetailAttachmentGeneral)
                    {
                        if (ag != 0)
                        {
                            attachmentListGeneral += "<br/>";
                        }
                        attachmentListGeneral += "<a href='" + drM["file_link"].ToString() + dra["filename"].ToString() + "'>" + dra["filename"].ToString() + "</a><br/>";
                        ag++;
                    }

                    template.SetAttribute("isTest", IsNotificationTestMode);
                    if (IsNotificationTestMode)
                    {
                        template.SetAttribute("TO_CC", ProcesTestModeTemplate(MainRecipients, drM["subject"].ToString(), SecondaryRecipients));
                    }
                    else
                    {
                        template.SetAttribute("TO_CC", SecondaryRecipients);
                    }
                    template.SetAttribute("requester", drM["requester_name"].ToString());
                    template.SetAttribute("required_date", drM["required_date"].ToString());
                    template.SetAttribute("office", drM["cifor_office_name"].ToString());

                    template.SetAttribute("isDirectToFinance", Boolean.Parse(drM["isDirectToFinance"].ToString()));
                    template.SetAttribute("is_direct_to_finance", drM["is_direct_to_finance"].ToString());
                    template.SetAttribute("direct_to_finance_justification", drM["direct_to_finance_justification"].ToString());

                    //template.SetAttribute("cost_center", drM["cost_center"].ToString());
                    //template.SetAttribute("currency", drM["currency_id"].ToString());
                    //template.SetAttribute("exchange_rate", String.Format("{0:#,0.000000}", Decimal.Parse(drM["exchange_rate"].ToString())));

                    if (drM["purchase_type_description"].ToString().ToLower() != "other" && total_usd > 200)
                    {
                        isJustification = true;
                    }

                    template.SetAttribute("isJustification", isJustification);
                    template.SetAttribute("remarks", drM["remarks"].ToString());
                    template.SetAttribute("purchase_type_description", drM["purchase_type_description"].ToString());
                    template.SetAttribute("attachmentgeneral", attachmentListGeneral);
                    template.SetAttribute("details", rowDetail);
                    template.SetAttribute("total",total);
                    template.SetAttribute("total_usd", String.Format("{0:#,0.00}", total_usd));

                    Antlr3.ST.StringTemplate Style = group.GetInstanceOf("Style");
                    template.SetAttribute("Style", Style);

                    Antlr3.ST.StringTemplate Footer = group.GetInstanceOf("Footer");
                    Footer.SetAttribute("mailbox", mailbox);
                    template.SetAttribute("Footer", Footer);

                    template.SetAttribute("link_detail", link_detail);

                    templateString = template.ToString();
                    template.Reset();

                    templateString = SendEmail(MainRecipients, templateString, drM["subject"].ToString(), SecondaryRecipients);
                    InsertLog(id, module_name, type, templateString);
                }
            }
            return templateString;
        }

        public static string PR_Verified(string id)
        {
            try
            {
                string module_name = "PURCHASE REQUISITION";
                string type = "VERIFIED";

                string templateString = string.Empty;

                DataSet ds = NotificationData.PurchaseRequisition.Verified(id);

                group.RootDir = StartupPath;
                Antlr3.ST.StringTemplate template = group.GetInstanceOf("PRVerified");


                if (IsNotificationActive)
                {
                    if (ds.Tables.Count > 0)
                    {
                        DataTable TO = ds.Tables[0];
                        DataTable CC = ds.Tables[1];
                        DataTable main = ds.Tables[2];
                        DataTable detail = ds.Tables[3];

                        int i = 0;
                        string rowClass = string.Empty, rowDetail = string.Empty
                                , subject = string.Empty, recipients = string.Empty
                                , MainRecipients = string.Empty
                                , SecondaryRecipients = string.Empty
                                , officeEmail = string.Empty;

                        foreach (DataRow dr in TO.Rows)
                        {
                            MainRecipients += dr["Email"].ToString() + ";";
                        }

                        foreach (DataRow dr in CC.Rows)
                        {
                            SecondaryRecipients += dr["Email"].ToString() + ";";
                        }


                        DataRow drM = main.Rows[0];

                        subject = drM["subject"].ToString();

                        //office mail box
                        var office = drM["cifor_office_name"].ToString();
                        DataTable office_mailbox = statics.GetEmailProcurementOffice(office);
                        foreach (DataRow dr in office_mailbox.Rows)
                        {
                            officeEmail += string.Format(@"<a href='mailto:{0}' target='_blank' rel='noopener noreferrer' 
                                            data-auth='NotApplicable' data-safelink='true' data-linkindex='4' class='email-footer'>{0}</a>, "
                                                   , dr["Email"].ToString());
                        }
                        officeEmail = officeEmail.Remove(officeEmail.Length - 2);


                        foreach (DataRow dr in detail.Rows)
                        {
                            if (i % 2 != 0)
                            {
                                rowClass = "basefont";
                            }
                            else
                            {
                                rowClass = "zebra";
                            }

                            Antlr3.ST.StringTemplate row = group.GetInstanceOf("PRDataB");
                            row.SetAttribute("class", rowClass);
                            row.SetAttribute("item_code", dr["item_code"].ToString());
                            row.SetAttribute("description", dr["description"].ToString());
                            row.SetAttribute("quantity", String.Format("{0:#,0.00}", Decimal.Parse(dr["request_qty"].ToString())) ?? "0");
                            row.SetAttribute("uom", dr["uom"].ToString());

                            rowDetail += row.ToString();

                            i++;
                        }

                        template.SetAttribute("isTest", IsNotificationTestMode);
                        if (IsNotificationTestMode)
                        {
                            template.SetAttribute("TO_CC", ProcesTestModeTemplate(MainRecipients, drM["subject"].ToString(), SecondaryRecipients));
                        }
                        else
                        {
                            template.SetAttribute("TO_CC", "");
                        }
                        template.SetAttribute("requester", drM["requester"].ToString());


                        var profile_page = String.Format("<a href='{0}{1}/PurchaseRequisition/detail.aspx?id={2}'>{3}</a>", home_url, app_name, id, drM["pr_no"]);
                        template.SetAttribute("pr_no", profile_page);

                        template.SetAttribute("footer", drM["footer"].ToString());
                        template.SetAttribute("details", rowDetail);

                        Antlr3.ST.StringTemplate Style = group.GetInstanceOf("Style");
                        template.SetAttribute("Style", Style);

                        Antlr3.ST.StringTemplate Footer = group.GetInstanceOf("Footer");
                        Footer.SetAttribute("mailbox", officeEmail);
                        template.SetAttribute("Footer", Footer);

                        templateString = template.ToString();
                        template.Reset();

                        templateString = SendEmail(MainRecipients, templateString, drM["subject"].ToString(), SecondaryRecipients);
                        InsertLog(id, module_name, type, templateString);
                    }
                }
                return templateString;
            }
            catch (Exception ex)
            {
                Log.Logger.Error(ex.Message == "" ? ex.InnerException.Message : ex.Message);
                return string.Empty;
            }
        }

        public static string PR_VerifiedFinance(string id)
        {
            try
            {
                string module_name = "PURCHASE REQUISITION";
                string type = "VERIFIED BY FINANCE";
                Boolean isSent = false;

                string templateString = string.Empty;

                DataSet ds = NotificationData.PurchaseRequisition.VerifiedFinance(id);

                group.RootDir = StartupPath;
                Antlr3.ST.StringTemplate template = group.GetInstanceOf("PRVerified_Finance");

                //isSent = IsSent(id, module_name, type);

                if (IsNotificationActive && !isSent)
                {
                    if (ds.Tables.Count > 0)
                    {
                        DataTable recipient = ds.Tables[0];
                        DataTable main = ds.Tables[1];
                        DataTable detail = ds.Tables[2];
                        DataTable attachment = ds.Tables[3];
                        DataTable attachmentGeneral = ds.Tables[4];
                        DataTable CC = ds.Tables[5];
                        DataTable cc = ds.Tables[6]; //charge code /cost center
                        DataTable grandTotal = ds.Tables[7];
                        DataTable mailBox = ds.Tables[8];

                        int i = 0;
                        string rowClass = string.Empty, rowDetail = string.Empty, attachmentList, attachmentListGeneral
                                , subject = string.Empty, recipients = string.Empty, officeEmail = string.Empty
                                , MainRecipients = string.Empty, SecondaryRecipients = string.Empty, total = string.Empty, mailbox = string.Empty;
                        Decimal total_usd = 0;

                        foreach (DataRow dr in recipient.Rows)
                        {
                            MainRecipients += dr["Email"].ToString() + ";";
                        }

                        foreach (DataRow drC in CC.Rows)
                        {
                            SecondaryRecipients += drC["Email"].ToString() + ";";
                        }

                        DataRow drM = main.Rows[0];

                        subject = drM["subject"].ToString();


                        #region mailbox

                        if(mailBox.Rows.Count > 0)
                        {
                            foreach (DataRow dr in mailBox.Rows)
                            {

                                mailbox += string.Format(@"<a href='mailto:{0}' target='_blank' rel='noopener noreferrer' 
                                            data-auth='NotApplicable' data-safelink='true' data-linkindex='4' class='email-footer'>{0}</a>, "
                                             , dr["mailbox"].ToString());
                            }
                            mailbox = mailbox.Remove(mailbox.Length - 2);
                        }
                   

                        #endregion


                        foreach (DataRow dr in detail.Rows)
                        {
                            attachmentList = string.Empty;

                            DataRow[] dtDetailAttachment = attachment.Select("document_id='" + dr["id"].ToString() + "'", "id");
                            int ai = 0;
                            foreach (DataRow dra in dtDetailAttachment)
                            {
                                if (ai != 0)
                                {
                                    attachmentList += "<br/>";
                                }
                                attachmentList += "<a href='" + drM["file_link"].ToString() + dra["filename"].ToString() + "'>" + dra["filename"].ToString() + "</a><br>";
                            }

                            if (i % 2 != 0)
                            {
                                rowClass = "basefont";
                            }
                            else
                            {
                                rowClass = "zebra";
                            }

                            Antlr3.ST.StringTemplate row = group.GetInstanceOf("PRDataA");
                            row.SetAttribute("class", rowClass);
                            row.SetAttribute("item_code", dr["item_code"].ToString());
                            row.SetAttribute("description", dr["description"].ToString());
                            row.SetAttribute("quantity", String.Format("{0:#,0.00}", Decimal.Parse(dr["request_qty"].ToString())) ?? "0");
                            row.SetAttribute("uom", dr["uom"].ToString());
                            row.SetAttribute("unit_price", String.Format("{0} {1:#,0.00}", dr["currency_id"].ToString(), Decimal.Parse(dr["unit_price"].ToString())) ?? "0");
                            row.SetAttribute("estimated_cost", String.Format("{0} {1:#,0.00}", dr["currency_id"].ToString(), Decimal.Parse(dr["estimated_cost"].ToString())) ?? "0");
                            row.SetAttribute("estimated_cost_usd", String.Format("{0:#,0.00}", Decimal.Parse(dr["estimated_cost_usd"].ToString())) ?? "0");
                            row.SetAttribute("exchange_rate", String.Format("{0:N6}", Decimal.Parse(dr["exchange_rate"].ToString())) ?? "0");
                            row.SetAttribute("attachment", attachmentList);


                            #region detail cost center
                            Antlr3.ST.StringTemplate rowDcc = group.GetInstanceOf("DetailCostCenter");
                            string rowDetailCostCenter_data = string.Empty, rowDetailCostCenter = string.Empty, ccClass = string.Empty;
                            int j = 0;
                            foreach (DataRow dcc in cc.Rows)
                            {
                                if (dr["id"].ToString() == dcc["pr_detail_id"].ToString())
                                {
                                    if (j % 2 != 0)
                                    {
                                        ccClass = "basefont";
                                    }
                                    else
                                    {
                                        ccClass = "zebra";
                                    }

                                    Antlr3.ST.StringTemplate rowDcc_data = group.GetInstanceOf("DetailCostCenter_Data");

                                    var cost_center = String.Format("{0} - {1}", dcc["cost_center_id"].ToString(), dcc["cost_center_name"].ToString());
                                    rowDcc_data.SetAttribute("class", ccClass);
                                    rowDcc_data.SetAttribute("cost_center", String.Format("{0} - {1}", dcc["cost_center_id"].ToString(), dcc["cost_center_name"].ToString()));
                                    rowDcc_data.SetAttribute("work_order", String.Format("{0} - {1}", dcc["work_order"].ToString(), dcc["work_order_description"].ToString()));
                                    rowDcc_data.SetAttribute("entity", String.Format("{0} - {1}", dcc["entity_id"].ToString(), dcc["entity_description"].ToString()));
                                    rowDcc_data.SetAttribute("legal_entity", dcc["legal_entity"].ToString());
                                    rowDcc_data.SetAttribute("percentage", dcc["percentage"]);
                                    rowDcc_data.SetAttribute("amount", dcc["amount"]);
                                    rowDcc_data.SetAttribute("amount_usd", dcc["amount_usd"]);
                                    rowDcc_data.SetAttribute("remarks", dcc["remarks"].ToString());

                                    rowDetailCostCenter_data += rowDcc_data.ToString();
                                    j++;
                                }
                            }


                            rowDcc.SetAttribute("currency_id", dr["currency_id"].ToString());
                            rowDcc.SetAttribute("detail_cost_center_data", rowDetailCostCenter_data);
                            rowDetailCostCenter += rowDcc.ToString();
                            row.SetAttribute("detail_cost_center", rowDetailCostCenter);
                            #endregion

                            rowDetail += row.ToString();
                            i++;
                        }

                        #region grand total
                        foreach (DataRow gTotal in grandTotal.Rows)
                        {
                            total += String.Format("{0} {1} <br/>", gTotal["currency_id"].ToString(), gTotal["total"].ToString());
                            total_usd += Decimal.Parse(gTotal["total_usd"].ToString());
                        }
                        #endregion

                        attachmentListGeneral = string.Empty;

                        DataRow[] dtDetailAttachmentGeneral = attachmentGeneral.Select("document_id='" + drM["id"].ToString() + "'", "id");
                        int ag = 0;
                        foreach (DataRow dra in dtDetailAttachmentGeneral)
                        {
                            if (ag != 0)
                            {
                                attachmentListGeneral += "<br/>";
                            }
                            attachmentListGeneral += "<a href='" + drM["file_link"].ToString() + dra["filename"].ToString() + "'>" + dra["filename"].ToString() + "</a><br/>";
                            ag++;
                        }

                        template.SetAttribute("isTest", IsNotificationTestMode);
                        if (IsNotificationTestMode)
                        {
                            template.SetAttribute("TO_CC", ProcesTestModeTemplate(MainRecipients, drM["subject"].ToString(), SecondaryRecipients));
                        }
                        else
                        {
                            template.SetAttribute("TO_CC", SecondaryRecipients);
                        }
                        template.SetAttribute("requester", drM["requester_name"].ToString());
                        template.SetAttribute("required_date", drM["required_date"].ToString());
                        template.SetAttribute("office", drM["cifor_office_name"].ToString());

                        /*template.SetAttribute("isDirectToFinance", Boolean.Parse(drM["isDirectToFinance"].ToString()));
                        template.SetAttribute("is_direct_to_finance", drM["is_direct_to_finance"].ToString());
                        template.SetAttribute("direct_to_finance_justification", drM["direct_to_finance_justification"].ToString());*/

                        //template.SetAttribute("cost_center", drM["cost_center"].ToString());
                        //template.SetAttribute("currency", drM["currency_id"].ToString());
                        //template.SetAttribute("exchange_rate", String.Format("{0:#,0.000000}", Decimal.Parse(drM["exchange_rate"].ToString())));

                        template.SetAttribute("remarks", drM["remarks"].ToString());
                        template.SetAttribute("purchase_type_description", drM["purchase_type_description"].ToString());
                        template.SetAttribute("attachmentgeneral", attachmentListGeneral);
                        template.SetAttribute("details", rowDetail);
                        template.SetAttribute("total", String.Format("{0:#,0.00}", total));
                        template.SetAttribute("total_usd", String.Format("{0:#,0.00}", total_usd));

                        template.SetAttribute("footer", drM["footer"].ToString());
                        template.SetAttribute("footer_name", drM["footer_name"].ToString());

                        Antlr3.ST.StringTemplate Style = group.GetInstanceOf("Style");
                        template.SetAttribute("Style", Style);

                        var profile_page = String.Format("<a href='{0}{1}/PurchaseRequisition/detail.aspx?id={2}'>View details</a>", home_url, app_name, id);
                        template.SetAttribute("profile_page", profile_page);

                        Antlr3.ST.StringTemplate Footer = group.GetInstanceOf("Footer");
                        Footer.SetAttribute("mailbox", mailbox);

                        template.SetAttribute("Footer", Footer);

                        templateString = template.ToString();
                        template.Reset();

                        templateString = SendEmail(MainRecipients, templateString, drM["subject"].ToString(), SecondaryRecipients);
                        InsertLog(id, module_name, type, templateString);
                    }
                }
                return templateString;
            }
            catch (Exception ex)
            {
                Log.Logger.Error(ex.Message == "" ? ex.InnerException.Message : ex.Message);
                return string.Empty;
            }
        }

        public static string PR_Cancelled(string id)
        {
            try
            {

                string module_name = "PURCHASE REQUISITION";
                string type = "CANCELLED";

                string templateString = string.Empty;
                Boolean isJustification = false;

                DataSet ds = NotificationData.PurchaseRequisition.Cancelled(id);

                group.RootDir = StartupPath;
                Antlr3.ST.StringTemplate template = group.GetInstanceOf("PRCancelled");


                if (IsNotificationActive)
                {
                    if (ds.Tables.Count > 0)
                    {
                        DataTable TO = ds.Tables[0];
                        DataTable CC = ds.Tables[1];
                        DataTable main = ds.Tables[2];
                        DataTable detail = ds.Tables[3];
                        DataTable dtAtt = new DataTable();
                        DataTable cc = ds.Tables[5]; //charge code /cost center
                        DataTable grandTotal = ds.Tables[6];
                        DataTable attachmentGeneral = ds.Tables[7];
                        DataTable attachment = ds.Tables[8];

                        var rows = ds.Tables[4].AsEnumerable()
                            .Where(x => (string)x["comment_file"].ToString() != "");

                        if (rows.Any())
                            dtAtt = rows.CopyToDataTable();

                        int i = 0;
                        Decimal total_usd = 0;
                        string rowClass = string.Empty, rowDetail = string.Empty
                                , subject = string.Empty, recipients = string.Empty
                                , MainRecipients = string.Empty
                                , SecondaryRecipients = string.Empty
                                , total = string.Empty
                                , officeEmail = string.Empty, attachmentList, attachmentListGeneral;

                        foreach (DataRow dr in TO.Rows)
                        {
                            MainRecipients += dr["Email"].ToString() + ";";
                        }

                        foreach (DataRow dr in CC.Rows)
                        {
                            SecondaryRecipients += dr["Email"].ToString() + ";";
                        }


                        DataRow drM = main.Rows[0];

                        subject = drM["subject"].ToString();

                        //office mail box
                        var office = drM["cifor_office_name"].ToString();
                        DataTable office_mailbox = statics.GetEmailProcurementOffice(office);
                        foreach (DataRow dr in office_mailbox.Rows)
                        {
                            officeEmail += string.Format(@"<a href='mailto:{0}' target='_blank' rel='noopener noreferrer' 
                                            data-auth='NotApplicable' data-safelink='true' data-linkindex='4' class='email-footer'>{0}</a>, "
                                                   , dr["Email"].ToString());
                        }
                        officeEmail = officeEmail.Remove(officeEmail.Length - 2);

                        foreach (DataRow dr in detail.Rows)
                        {
                            attachmentList = string.Empty;

                            DataRow[] dtDetailAttachment = attachment.Select("document_id='" + dr["id"].ToString() + "'", "id");
                            int ai = 0;
                            foreach (DataRow dra in dtDetailAttachment)
                            {
                                if (ai != 0)
                                {
                                    attachmentList += "<br/>";
                                }
                                attachmentList += "<a href='" + drM["file_link"].ToString() + dra["filename"].ToString() + "'>" + dra["filename"].ToString() + "</a><br>";
                            }

                            if (i % 2 != 0)
                            {
                                rowClass = "basefont";
                            }
                            else
                            {
                                rowClass = "zebra";
                            }

                            Antlr3.ST.StringTemplate row = group.GetInstanceOf("PRDataA");
                            row.SetAttribute("class", rowClass);
                            row.SetAttribute("item_code", dr["item_code"].ToString());
                            row.SetAttribute("description", dr["description"].ToString());
                            row.SetAttribute("quantity", String.Format("{0:#,0.00}", Decimal.Parse(dr["request_qty"].ToString())) ?? "0");
                            row.SetAttribute("uom", dr["uom"].ToString());
                            row.SetAttribute("unit_price", String.Format("{0} {1:#,0.00}", dr["currency_id"].ToString(), Decimal.Parse(dr["unit_price"].ToString())) ?? "0");
                            row.SetAttribute("estimated_cost", String.Format("{0} {1:#,0.00}", dr["currency_id"].ToString(), Decimal.Parse(dr["estimated_cost"].ToString())) ?? "0");
                            row.SetAttribute("estimated_cost_usd", String.Format("{0:#,0.00}", Decimal.Parse(dr["estimated_cost_usd"].ToString())) ?? "0");
                            row.SetAttribute("exchange_rate", String.Format("{0:N6}", Decimal.Parse(dr["exchange_rate"].ToString())) ?? "0");
                            row.SetAttribute("attachment", attachmentList);
                            #region detail cost center
                            Antlr3.ST.StringTemplate rowDcc = group.GetInstanceOf("DetailCostCenter");
                            string rowDetailCostCenter_data = string.Empty, rowDetailCostCenter = string.Empty, ccClass = string.Empty;
                            int j = 0;
                            foreach (DataRow dcc in cc.Rows)
                            {
                                if (dr["id"].ToString() == dcc["pr_detail_id"].ToString())
                                {
                                    if (j % 2 != 0)
                                    {
                                        ccClass = "basefont";
                                    }
                                    else
                                    {
                                        ccClass = "zebra";
                                    }

                                    Antlr3.ST.StringTemplate rowDcc_data = group.GetInstanceOf("DetailCostCenter_Data");

                                    var cost_center = String.Format("{0} - {1}", dcc["cost_center_id"].ToString(), dcc["cost_center_name"].ToString());
                                    rowDcc_data.SetAttribute("class", ccClass);
                                    rowDcc_data.SetAttribute("cost_center", String.Format("{0} - {1}", dcc["cost_center_id"].ToString(), dcc["cost_center_name"].ToString()));
                                    rowDcc_data.SetAttribute("work_order", String.Format("{0} - {1}", dcc["work_order"].ToString(), dcc["work_order_description"].ToString()));
                                    rowDcc_data.SetAttribute("entity", String.Format("{0} - {1}", dcc["entity_id"].ToString(), dcc["entity_description"].ToString()));
                                    rowDcc_data.SetAttribute("legal_entity", dcc["legal_entity"].ToString());
                                    rowDcc_data.SetAttribute("percentage", dcc["percentage"]);
                                    rowDcc_data.SetAttribute("amount", String.Format("{0:#,0.00}", Decimal.Parse(dcc["amount"].ToString())) ?? "0");
                                    rowDcc_data.SetAttribute("amount_usd", String.Format("{0:#,0.00}", Decimal.Parse(dcc["amount_usd"].ToString())) ?? "0");
                                    rowDcc_data.SetAttribute("remarks", dcc["remarks"].ToString());

                                    rowDetailCostCenter_data += rowDcc_data.ToString();
                                    j++;
                                }
                            }


                            rowDcc.SetAttribute("currency_id", dr["currency_id"].ToString());
                            rowDcc.SetAttribute("detail_cost_center_data", rowDetailCostCenter_data);
                            rowDetailCostCenter += rowDcc.ToString();
                            row.SetAttribute("detail_cost_center", rowDetailCostCenter);
                            #endregion

                            rowDetail += row.ToString();
                            i++;
                        }

                        #region grand total
                        foreach (DataRow gTotal in grandTotal.Rows)
                        {
                            total += String.Format("{0} {1} <br/>", gTotal["currency_id"].ToString(),
                                        String.Format("{0:#,0.00}", Decimal.Parse(gTotal["total"].ToString()))
                                    );
                            total_usd += Decimal.Parse(gTotal["total_usd"].ToString());
                        }
                        #endregion


                        attachmentListGeneral = string.Empty;

                        DataRow[] dtDetailAttachmentGeneral = attachmentGeneral.Select("document_id='" + drM["id"].ToString() + "'", "id");
                        int ag = 0;
                        foreach (DataRow dra in dtDetailAttachmentGeneral)
                        {
                            if (ag != 0)
                            {
                                attachmentListGeneral += "<br/>";
                            }
                            attachmentListGeneral += "<a href='" + drM["file_link"].ToString() + dra["filename"].ToString() + "'>" + dra["filename"].ToString() + "</a><br/>";
                            ag++;
                        }

                        template.SetAttribute("isTest", IsNotificationTestMode);
                        if (IsNotificationTestMode)
                        {
                            template.SetAttribute("TO_CC", ProcesTestModeTemplate(MainRecipients, drM["subject"].ToString(), SecondaryRecipients));
                        }
                        else
                        {
                            template.SetAttribute("TO_CC", "");
                        }
                        template.SetAttribute("requester", drM["requester"].ToString());
                        template.SetAttribute("pr_no", drM["pr_no"].ToString());
                        template.SetAttribute("required_date", drM["required_date"].ToString());
                        template.SetAttribute("office", drM["cifor_office_name"].ToString());

                        /*template.SetAttribute("isDirectToFinance", Boolean.Parse(drM["isDirectToFinance"].ToString()));
                        template.SetAttribute("is_direct_to_finance", drM["is_direct_to_finance"].ToString());
                        template.SetAttribute("direct_to_finance_justification", drM["direct_to_finance_justification"].ToString());*/

                        //template.SetAttribute("cost_center", drM["cost_center"].ToString());
                        //template.SetAttribute("currency", drM["currency_id"].ToString());
                        //template.SetAttribute("exchange_rate", String.Format("{0:#,0.000000}", Decimal.Parse(drM["exchange_rate"].ToString())));

                        if (drM["purchase_type_description"].ToString().ToLower() != "other" && total_usd > 200)
                        {
                            isJustification = true;
                        }
                        template.SetAttribute("isJustification", isJustification);

                        template.SetAttribute("remarks", drM["remarks"].ToString());
                        template.SetAttribute("purchase_type_description", drM["purchase_type_description"].ToString());
                        template.SetAttribute("purchasing_process", Boolean.Parse(drM["purchasing_process"].ToString()));
                        template.SetAttribute("direct_to_finance_justification", drM["direct_to_finance_justification"].ToString());
                        template.SetAttribute("is_show_processing_process", Boolean.Parse(drM["is_show_processing_process"].ToString()));
                        template.SetAttribute("total",total);
                        template.SetAttribute("total_usd", String.Format("{0:#,0.00}", total_usd));
                        template.SetAttribute("footer", drM["footer"].ToString());
                        template.SetAttribute("details", rowDetail);
                        template.SetAttribute("attachmentgeneral", attachmentListGeneral);

                        if (ds.Tables[4].Rows.Count > 0)
                        {
                            template.SetAttribute("justification", ds.Tables[4].Rows[0]["comment"].ToString());
                        }

                        Antlr3.ST.StringTemplate Style = group.GetInstanceOf("Style");
                        template.SetAttribute("Style", Style);

                        Antlr3.ST.StringTemplate Footer = group.GetInstanceOf("Footer");
                        Footer.SetAttribute("mailbox", officeEmail);
                        template.SetAttribute("Footer", Footer);


                        templateString = template.ToString();
                        template.Reset();

                        templateString = SendEmail(MainRecipients, templateString, drM["subject"].ToString(), SecondaryRecipients, "PURCHASEREQUISITION", id, dtAtt);
                        InsertLog(id, module_name, type, templateString);
                    }
                }
                return templateString;
            }
            catch (Exception ex)
            {
                Log.Logger.Error(ex.Message == "" ? ex.InnerException.Message : ex.Message);
                return string.Empty;
            }
        }

        public static string PR_Rejected(string id)
        {
            try
            {

                string module_name = "PURCHASE REQUISITION";
                string type = "REJECTED";

                string templateString = string.Empty;
                Boolean isJustification = false;

                DataSet ds = NotificationData.PurchaseRequisition.Rejected(id);

                group.RootDir = StartupPath;
                Antlr3.ST.StringTemplate template = group.GetInstanceOf("PRRejected");


                if (IsNotificationActive)
                {
                    if (ds.Tables.Count > 0)
                    {
                        DataTable TO = ds.Tables[0];
                        DataTable CC = ds.Tables[1];
                        DataTable main = ds.Tables[2];
                        DataTable detail = ds.Tables[3];
                        DataTable dtAtt = new DataTable();
                        DataTable cc = ds.Tables[5]; //charge code /cost center
                        DataTable grandTotal = ds.Tables[6];
                        DataTable attachmentGeneral = ds.Tables[7];
                        DataTable attachment = ds.Tables[8];

                        var rows = ds.Tables[4].AsEnumerable()
                            .Where(x => (string)x["comment_file"].ToString() != "");

                        if (rows.Any())
                            dtAtt = rows.CopyToDataTable();

                        int i = 0;
                        Decimal total_usd = 0;
                        string rowClass = string.Empty, rowDetail = string.Empty
                                , subject = string.Empty, recipients = string.Empty
                                , MainRecipients = string.Empty
                                , SecondaryRecipients = string.Empty
                                , total = string.Empty
                                , officeEmail = string.Empty, attachmentListGeneral, attachmentList;

                        foreach (DataRow dr in TO.Rows)
                        {
                            MainRecipients += dr["Email"].ToString() + ";";
                        }

                        foreach (DataRow dr in CC.Rows)
                        {
                            SecondaryRecipients += dr["Email"].ToString() + ";";
                        }


                        DataRow drM = main.Rows[0];

                        subject = drM["subject"].ToString();
                        subject = drM["subject"].ToString();

                        //office mail box
                        var office = drM["cifor_office_name"].ToString();
                        DataTable office_mailbox = statics.GetEmailProcurementOffice(office);
                        foreach (DataRow dr in office_mailbox.Rows)
                        {
                            officeEmail += string.Format(@"<a href='mailto:{0}' target='_blank' rel='noopener noreferrer' 
                                            data-auth='NotApplicable' data-safelink='true' data-linkindex='4' class='email-footer'>{0}</a>, "
                                                   , dr["Email"].ToString());
                        }
                        officeEmail = officeEmail.Remove(officeEmail.Length - 2);




                        foreach (DataRow dr in detail.Rows)
                        {
                            attachmentList = string.Empty;

                            DataRow[] dtDetailAttachment = attachment.Select("document_id='" + dr["id"].ToString() + "'", "id");
                            int ai = 0;
                            foreach (DataRow dra in dtDetailAttachment)
                            {
                                if (ai != 0)
                                {
                                    attachmentList += "<br/>";
                                }
                                attachmentList += "<a href='" + drM["file_link"].ToString() + dra["filename"].ToString() + "'>" + dra["filename"].ToString() + "</a><br>";
                            }

                            if (i % 2 != 0)
                            {
                                rowClass = "basefont";
                            }
                            else
                            {
                                rowClass = "zebra";
                            }

                            Antlr3.ST.StringTemplate row = group.GetInstanceOf("PRDataA");
                            row.SetAttribute("class", rowClass);
                            row.SetAttribute("item_code", dr["item_code"].ToString());
                            row.SetAttribute("description", dr["description"].ToString());
                            row.SetAttribute("quantity", String.Format("{0:#,0.00}", Decimal.Parse(dr["request_qty"].ToString())) ?? "0");
                            row.SetAttribute("uom", dr["uom"].ToString());
                            row.SetAttribute("unit_price", String.Format("{0} {1:#,0.00}", dr["currency_id"].ToString(), Decimal.Parse(dr["unit_price"].ToString())) ?? "0");
                            row.SetAttribute("estimated_cost", String.Format("{0} {1:#,0.00}", dr["currency_id"].ToString(), Decimal.Parse(dr["estimated_cost"].ToString())) ?? "0");
                            row.SetAttribute("estimated_cost_usd", String.Format("{0:#,0.00}", Decimal.Parse(dr["estimated_cost_usd"].ToString())) ?? "0");
                            row.SetAttribute("exchange_rate", String.Format("{0:N6}", Decimal.Parse(dr["exchange_rate"].ToString())) ?? "0");
                            row.SetAttribute("attachment", attachmentList);
                            #region detail cost center
                            Antlr3.ST.StringTemplate rowDcc = group.GetInstanceOf("DetailCostCenter");
                            string rowDetailCostCenter_data = string.Empty, rowDetailCostCenter = string.Empty, ccClass = string.Empty;
                            int j = 0;
                            foreach (DataRow dcc in cc.Rows)
                            {
                                if (dr["id"].ToString() == dcc["pr_detail_id"].ToString())
                                {
                                    if (j % 2 != 0)
                                    {
                                        ccClass = "basefont";
                                    }
                                    else
                                    {
                                        ccClass = "zebra";
                                    }

                                    Antlr3.ST.StringTemplate rowDcc_data = group.GetInstanceOf("DetailCostCenter_Data");

                                    var cost_center = String.Format("{0} - {1}", dcc["cost_center_id"].ToString(), dcc["cost_center_name"].ToString());
                                    rowDcc_data.SetAttribute("class", ccClass);
                                    rowDcc_data.SetAttribute("cost_center", String.Format("{0} - {1}", dcc["cost_center_id"].ToString(), dcc["cost_center_name"].ToString()));
                                    rowDcc_data.SetAttribute("work_order", String.Format("{0} - {1}", dcc["work_order"].ToString(), dcc["work_order_description"].ToString()));
                                    rowDcc_data.SetAttribute("entity", String.Format("{0} - {1}", dcc["entity_id"].ToString(), dcc["entity_description"].ToString()));
                                    rowDcc_data.SetAttribute("legal_entity", dcc["legal_entity"].ToString());
                                    rowDcc_data.SetAttribute("percentage", dcc["percentage"]);
                                    rowDcc_data.SetAttribute("amount", String.Format("{0:#,0.00}", Decimal.Parse(dcc["amount"].ToString())) ?? "0");
                                    rowDcc_data.SetAttribute("amount_usd", String.Format("{0:#,0.00}", Decimal.Parse(dcc["amount_usd"].ToString())) ?? "0");
                                    rowDcc_data.SetAttribute("remarks", dcc["remarks"].ToString());

                                    rowDetailCostCenter_data += rowDcc_data.ToString();
                                    j++;
                                }
                            }


                            rowDcc.SetAttribute("currency_id", dr["currency_id"].ToString());
                            rowDcc.SetAttribute("detail_cost_center_data", rowDetailCostCenter_data);
                            rowDetailCostCenter += rowDcc.ToString();
                            row.SetAttribute("detail_cost_center", rowDetailCostCenter);
                            #endregion

                            rowDetail += row.ToString();
                            i++;
                        }

                        #region grand total
                        foreach (DataRow gTotal in grandTotal.Rows)
                        {
                            total += String.Format("{0} {1} <br/>", gTotal["currency_id"].ToString(),
                                        String.Format("{0:#,0.00}", Decimal.Parse(gTotal["total"].ToString()))
                                    );
                            total_usd += Decimal.Parse(gTotal["total_usd"].ToString());
                        }
                        #endregion


                        attachmentListGeneral = string.Empty;

                        DataRow[] dtDetailAttachmentGeneral = attachmentGeneral.Select("document_id='" + drM["id"].ToString() + "'", "id");
                        int ag = 0;
                        foreach (DataRow dra in dtDetailAttachmentGeneral)
                        {
                            if (ag != 0)
                            {
                                attachmentListGeneral += "<br/>";
                            }
                            attachmentListGeneral += "<a href='" + drM["file_link"].ToString() + dra["filename"].ToString() + "'>" + dra["filename"].ToString() + "</a><br/>";
                            ag++;
                        }

                        template.SetAttribute("isTest", IsNotificationTestMode);
                        if (IsNotificationTestMode)
                        {
                            template.SetAttribute("TO_CC", ProcesTestModeTemplate(MainRecipients, drM["subject"].ToString(), SecondaryRecipients));
                        }
                        else
                        {
                            template.SetAttribute("TO_CC", "");
                        }
                        template.SetAttribute("requester", drM["requester"].ToString());
                        template.SetAttribute("pr_no", drM["pr_no"].ToString());
                        template.SetAttribute("required_date", drM["required_date"].ToString());
                        template.SetAttribute("office", drM["cifor_office_name"].ToString());

                        /*template.SetAttribute("isDirectToFinance", Boolean.Parse(drM["isDirectToFinance"].ToString()));
                        template.SetAttribute("is_direct_to_finance", drM["is_direct_to_finance"].ToString());
                        template.SetAttribute("direct_to_finance_justification", drM["direct_to_finance_justification"].ToString());*/

                        //template.SetAttribute("cost_center", drM["cost_center"].ToString());
                        //template.SetAttribute("currency", drM["currency_id"].ToString());
                        //template.SetAttribute("exchange_rate", String.Format("{0:#,0.000000}", Decimal.Parse(drM["exchange_rate"].ToString())));

                        if (drM["purchase_type_description"].ToString().ToLower() != "other" && total_usd > 200)
                        {
                            isJustification = true;
                        }
                        template.SetAttribute("isJustification", isJustification);
                        template.SetAttribute("remarks", drM["remarks"].ToString());
                        template.SetAttribute("purchase_type_description", drM["purchase_type_description"].ToString());
                        template.SetAttribute("purchasing_process", Boolean.Parse(drM["purchasing_process"].ToString()));
                        template.SetAttribute("direct_to_finance_justification", drM["direct_to_finance_justification"].ToString());
                        template.SetAttribute("is_show_processing_process", Boolean.Parse(drM["is_show_processing_process"].ToString()));
                        template.SetAttribute("total",total);
                        template.SetAttribute("total_usd", String.Format("{0:#,0.00}", total_usd));
                        template.SetAttribute("footer", drM["footer"].ToString());
                        template.SetAttribute("details", rowDetail);
                        template.SetAttribute("attachmentgeneral", attachmentListGeneral);

                        if (ds.Tables[4].Rows.Count > 0)
                        {
                            template.SetAttribute("justification", ds.Tables[4].Rows[0]["comment"].ToString());
                        }

                        Antlr3.ST.StringTemplate Style = group.GetInstanceOf("Style");
                        template.SetAttribute("Style", Style);


                        Antlr3.ST.StringTemplate Footer = group.GetInstanceOf("Footer");
                        Footer.SetAttribute("mailbox", officeEmail);
                        template.SetAttribute("Footer", Footer);

                        templateString = template.ToString();
                        template.Reset();

                        templateString = SendEmail(MainRecipients, templateString, drM["subject"].ToString(), SecondaryRecipients, "PURCHASEREQUISITION", id, dtAtt);
                        InsertLog(id, module_name, type, templateString);
                    }
                }
                return templateString;
            }
            catch (Exception ex)
            {
                Log.Logger.Error(ex.Message == "" ? ex.InnerException.Message : ex.Message);
                return string.Empty;
            }
        }
        public static string PR_Closed()
        {
            try
            {
                string module_name = "PURCHASE REQUISITION";
                string type = "CLOSED";
                Boolean isJustification = false;

                string templateString = string.Empty;

                DataSet ds = NotificationData.PurchaseRequisition.Closed();

                group.RootDir = StartupPath;

                string footerContact = string.Empty;

                if (IsNotificationActive)
                {
                    if (ds.Tables.Count > 0)
                    {
                        if (ds.Tables[0].Rows.Count > 0)
                        {
                            footerContact = ds.Tables[0].Rows[0]["footer"].ToString();
                        }

                        foreach (DataRow dm in ds.Tables[0].Rows)
                        {
                            string key_id = string.Empty
                                , rowClass = string.Empty
                                , rowDetail = string.Empty
                                , subject = string.Empty
                                , recipients = string.Empty
                                , MainRecipients = string.Empty
                                , SecondaryRecipients = string.Empty
                                , vendorName = string.Empty
                                , deliveryDate = string.Empty
                                , item_detail = string.Empty
                                , pr_id = string.Empty
                                , pr_no = string.Empty
                                , attachmentListGeneral = string.Empty
                                , file_link = string.Empty
                                , mailbox = string.Empty
                                , office = string.Empty
                                , initiator_email = string.Empty
                                , requester_email = string.Empty
                                , pr_type = string.Empty;

                            Antlr3.ST.StringTemplate template = group.GetInstanceOf("PRClosed");

                            key_id = dm["id"].ToString();
                            subject = dm["subject"].ToString();
                            recipients = dm["requester_name"].ToString();
                            pr_id = dm["id"].ToString();
                            pr_no = dm["pr_no"].ToString();
                            file_link = dm["file_link"].ToString();
                            bool is_finance = false;
                            is_finance = Boolean.Parse(dm["is_finance"].ToString());
                            pr_type = is_finance ? "request for payment" : "purchase requisition";
                            office = dm["cifor_office_name"].ToString();
                            var proc_mail = string.Empty;
                            bool isProcMail = false;
                            initiator_email = dm["initiator_email"].ToString();
                            requester_email = dm["requester_email"].ToString();


                            /* main receipient */
                            if (ds.Tables[1].Rows.Count > 0)
                            {
                                DataTable dTO = ds.Tables[1].Select("id='" + key_id + "'", "to asc").CopyToDataTable();
                                foreach (DataRow dto in dTO.Rows)
                                {
                                    MainRecipients += dto["to"].ToString() + ";";
                                }
                            }


                            /* secondary receipient */
                            if (!is_finance)
                            {
                                if (ds.Tables[2].Rows.Count > 0)
                                {
                                    DataTable dCC = ds.Tables[2].Select("id='" + key_id + "'", "cc asc").CopyToDataTable();
                                    foreach (DataRow dc in dCC.Rows)
                                    {
                                        if (dc["cc"].ToString() != initiator_email && dc["cc"].ToString() != requester_email && dc["activity_id"].ToString() != "5")
                                        {
                                            SecondaryRecipients += dc["cc"].ToString() + ";";
                                        }

                                    }
                                }
                            }
                            else
                            {
                                DataRow[] financeCC = ds.Tables[5].Select("id='" + key_id + "'", "id");

                                foreach (DataRow dra in financeCC)
                                {

                                    if (dra["mailbox"].ToString() != initiator_email && dra["mailbox"].ToString() != requester_email)
                                    {
                                        SecondaryRecipients += dra["mailbox"].ToString() + ";";
                                    }


                                }
                            }


                            #region support document
                            DataRow[] dtDetailAttachmentGeneral = ds.Tables[4].Select("document_id='" +key_id + "'", "id");
                            int ag = 0;
                            foreach (DataRow dra in dtDetailAttachmentGeneral)
                            {
                                if (ag != 0)
                                {
                                    attachmentListGeneral += "<br/>";
                                }
                                attachmentListGeneral += "<a href='" + file_link + dra["filename"].ToString() + "'>" + dra["filename"].ToString() + "</a><br/>";
                                ag++;
                            }
                            #endregion





                            /* data */
                            DataTable dIt = ds.Tables[3].Select("id='" + key_id + "' ", "line_no asc").CopyToDataTable();
                            int i = 0;
                            foreach (DataRow dr in dIt.Rows)
                            {
                                if (i % 2 != 0)
                                {
                                    rowClass = "basefont";
                                }
                                else
                                {
                                    rowClass = "zebra";
                                }

                                Antlr3.ST.StringTemplate row = group.GetInstanceOf("PRClosed_data");
                                row.SetAttribute("class", rowClass);
                                row.SetAttribute("item_code", dr["item_code"].ToString());
                                row.SetAttribute("description", dr["item_description"].ToString());
                                row.SetAttribute("quantity", String.Format("{0:#,0.00}", Decimal.Parse(dr["quantity"].ToString())) ?? "0");
                                row.SetAttribute("uom", dr["uom"].ToString());
                                row.SetAttribute("confirm_status", dr["confirm_status"].ToString());
                                row.SetAttribute("confirm_date", dr["confirm_date"].ToString());
                                row.SetAttribute("is_finance", is_finance);

                                #region detail cost center
                                DataSet dsCC = new DataSet();
                                dsCC = staticsPurchaseRequisition.Detail.GetCostCenter(pr_id, "");

                                Antlr3.ST.StringTemplate rowDcc = group.GetInstanceOf("DetailCostCenter");
                                string rowDetailCostCenter_data = string.Empty, rowDetailCostCenter = string.Empty, ccClass = string.Empty;
                                int j = 0;
                                foreach (DataRow dcc in dsCC.Tables[0].Rows)
                                {
                                    if (dr["pr_detail_id"].ToString() == dcc["pr_detail_id"].ToString())
                                    {
                                        if (j % 2 != 0)
                                        {
                                            ccClass = "basefont";
                                        }
                                        else
                                        {
                                            ccClass = "zebra";
                                        }

                                        Antlr3.ST.StringTemplate rowDcc_data = group.GetInstanceOf("DetailCostCenter_Data");

                                        var cost_center = String.Format("{0} - {1}", dcc["cost_center_id"].ToString(), dcc["cost_center_name"].ToString());
                                        rowDcc_data.SetAttribute("class", ccClass);
                                        rowDcc_data.SetAttribute("cost_center", String.Format("{0} - {1}", dcc["cost_center_id"].ToString(), dcc["cost_center_name"].ToString()));
                                        rowDcc_data.SetAttribute("work_order", String.Format("{0} - {1}", dcc["work_order"].ToString(), dcc["work_order_description"].ToString()));
                                        rowDcc_data.SetAttribute("entity", String.Format("{0} - {1}", dcc["entity_id"].ToString(), dcc["entity_description"].ToString()));
                                        rowDcc_data.SetAttribute("legal_entity", dcc["legal_entity"].ToString());
                                        rowDcc_data.SetAttribute("percentage", dcc["percentage"]);
                                        rowDcc_data.SetAttribute("amount", String.Format("{0:#,0.00}", Decimal.Parse(dcc["amount"].ToString())) ?? "0");
                                        rowDcc_data.SetAttribute("amount_usd", String.Format("{0:#,0.00}", Decimal.Parse(dcc["amount_usd"].ToString())) ?? "0");
                                        rowDcc_data.SetAttribute("remarks", dcc["remarks"].ToString());

                                        rowDetailCostCenter_data += rowDcc_data.ToString();
                                        j++;
                                    }
                                }


                                rowDcc.SetAttribute("currency_id", dr["currency_id"].ToString());
                                rowDcc.SetAttribute("detail_cost_center_data", rowDetailCostCenter_data);
                                rowDetailCostCenter += rowDcc.ToString();
                                row.SetAttribute("detail_cost_center", rowDetailCostCenter);

                                #endregion

                                item_detail += row.ToString();

                                i++;
                            }
                            template.SetAttribute("details", item_detail);


                            template.SetAttribute("isTest", IsNotificationTestMode);
                            if (IsNotificationTestMode)
                            {
                                template.SetAttribute("TO_CC", ProcesTestModeTemplate(MainRecipients, subject, SecondaryRecipients));
                            }
                            else
                            {
                                template.SetAttribute("TO_CC", "");
                            }
                            template.SetAttribute("requester", recipients);
                            template.SetAttribute("pr_no", pr_no);
                            template.SetAttribute("pr_type", pr_type);
                            template.SetAttribute("required_date", dm["required_date"].ToString());
                            template.SetAttribute("office", dm["cifor_office_name"].ToString());

                      
                            //template.SetAttribute("cost_center", dm["cost_center"].ToString());
                            //template.SetAttribute("currency", dm["currency_id"].ToString());
                            //template.SetAttribute("exchange_rate", String.Format("{0:#,0.000000}", Decimal.Parse(dm["exchange_rate"].ToString())));

                           decimal total_usd = Decimal.Parse(dm["total_usd"].ToString());

                            if (dm["purchase_type_description"].ToString().ToLower() != "other" && total_usd > 200)
                            {
                                isJustification = true;
                            }

                            template.SetAttribute("isJustification", isJustification);
                            template.SetAttribute("remarks", dm["remarks"].ToString());
                            template.SetAttribute("purchase_type_description", dm["purchase_type_description"].ToString());
                            template.SetAttribute("purchasing_process", Boolean.Parse(dm["purchasing_process"].ToString()));
                            template.SetAttribute("direct_to_finance_justification", dm["direct_to_finance_justification"].ToString());
                            template.SetAttribute("is_show_processing_process", Boolean.Parse(dm["is_show_processing_process"].ToString()));
                            template.SetAttribute("attachmentgeneral", attachmentListGeneral);
                            template.SetAttribute("is_finance", Boolean.Parse(dm["is_finance"].ToString()));


                            #region mailbox
                            DataRow[] dtDetailMailbox = ds.Tables[5].Select("id='" + key_id + "'", "id");
                            if(dtDetailAttachmentGeneral.Length > 0)
                            {
                                if (is_finance)
                                {
                                    foreach (DataRow dra in dtDetailMailbox)
                                    {

                                        mailbox += string.Format(@"<a href='mailto:{0}' target='_blank' rel='noopener noreferrer' 
                                            data-auth='NotApplicable' data-safelink='true' data-linkindex='4' class='email-footer'>{0}</a>, "
                                                     , dra["mailbox"].ToString());
                                    }
                                    mailbox = mailbox.Remove(mailbox.Length - 2);
                                }
                                else
                                {
                                    DataTable office_mailbox = statics.GetEmailProcurementOffice(office);
                                    foreach (DataRow dr in office_mailbox.Rows)
                                    {
                                        mailbox += string.Format(@"<a href='mailto:{0}' target='_blank' rel='noopener noreferrer' 
                                            data-auth='NotApplicable' data-safelink='true' data-linkindex='4' class='email-footer'>{0}</a>, "
                                                      , dr["Email"].ToString());
                                    }
                                    mailbox = mailbox.Remove(mailbox.Length - 2);
                                }
                            }
                          

                            #endregion

                            template.SetAttribute("footer", dm["footer"].ToString());

                            Antlr3.ST.StringTemplate Style = group.GetInstanceOf("Style");
                            template.SetAttribute("Style", Style);

                            Antlr3.ST.StringTemplate Footer = group.GetInstanceOf("Footer");
                            Footer.SetAttribute("mailbox", mailbox);

                            template.SetAttribute("Footer", Footer);


                            templateString = template.ToString();


                            template.Reset();

                            templateString = SendEmail(MainRecipients, templateString, subject, SecondaryRecipients);
                            InsertLog(key_id, module_name, type, templateString);
                        }
                    }
                }
                return templateString;
            }
           catch (Exception ex)
            {
                Log.Logger.Error(ex.Message == "" ? ex.InnerException.Message : ex.Message);
                return string.Empty;

            }
        }

        public static string PR_ChangeChargeCodeToBudgetHolder(string id, string emailChargeCode = "")
        {
            try
            {
                string module_name = "PURCHASE REQUISITION";
                string type = "CHANGE CHARGE CODE TO BUDGET HOLDER";
                Boolean isSent = false;

                string templateString = string.Empty;

                DataSet ds = NotificationData.PurchaseRequisition.ChangeChargeCodeToBudgetHolder(id);

                group.RootDir = StartupPath;
                Antlr3.ST.StringTemplate template = group.GetInstanceOf("PRChangeChargeCodeToBudgetHolder");

                //isSent = IsSent(id, module_name, type);

                if (IsNotificationActive && !isSent)
                {
                    if (ds.Tables.Count > 0)
                    {
                        DataTable recipient = ds.Tables[0];
                        DataTable main = ds.Tables[1];
                        DataTable detail = ds.Tables[2];
                        DataTable attachment = ds.Tables[3];
                        DataTable attachmentGeneral = ds.Tables[4];
                        DataTable cc = ds.Tables[5];
                        DataTable grandTotal = ds.Tables[6];


                        int i = 0;
                        string rowClass = string.Empty, rowDetail = string.Empty, attachmentList, attachmentListGeneral, team = string.Empty
                                , subject = string.Empty, recipients = string.Empty
                                , MainRecipients = string.Empty, SecondaryRecipients = string.Empty
                                , total = string.Empty
                                , officeEmail = string.Empty;
                        Boolean team_email = false;
                        Decimal total_usd = 0;

                        //foreach (DataRow dr in recipient.Rows)
                        //{
                        //    MainRecipients += dr["Email"].ToString() + ";";
                        //}

                        //foreach (DataRow drC in cc.Rows)
                        //{
                        //    SecondaryRecipients += drC["Email"].ToString() + ";";
                        //}

                        if (!string.IsNullOrEmpty(emailChargeCode))
                        {
                            MainRecipients += emailChargeCode;
                            MainRecipients += ";";
                        }

                        DataRow drM = main.Rows[0];

                        subject = drM["subject"].ToString();

                        foreach (DataRow dr in detail.Rows)
                        {
                            attachmentList = string.Empty;

                            DataRow[] dtDetailAttachment = attachment.Select("document_id='" + dr["id"].ToString() + "'", "id");
                            int ai = 0;
                            foreach (DataRow dra in dtDetailAttachment)
                            {
                                if (ai != 0)
                                {
                                    attachmentList += "<br/>";
                                }
                                attachmentList += "<a href='" + drM["file_link"].ToString() + dra["filename"].ToString() + "'>" + dra["filename"].ToString() + "</a><br/>";
                            }

                            if (i % 2 != 0)
                            {
                                rowClass = "basefont";
                            }
                            else
                            {
                                rowClass = "zebra";
                            }

                            Antlr3.ST.StringTemplate row = group.GetInstanceOf("PRDataA");
                            row.SetAttribute("class", rowClass);
                            row.SetAttribute("item_code", dr["item_code"].ToString());
                            row.SetAttribute("description", dr["description"].ToString());
                            row.SetAttribute("quantity", String.Format("{0:#,0.00}", Decimal.Parse(dr["request_qty"].ToString())) ?? "0");
                            row.SetAttribute("uom", dr["uom"].ToString());
                            row.SetAttribute("unit_price", String.Format("{0} {1:#,0.00}", dr["currency_id"].ToString(), Decimal.Parse(dr["unit_price"].ToString())) ?? "0");
                            row.SetAttribute("estimated_cost", String.Format("{0} {1:#,0.00}", dr["currency_id"].ToString(), Decimal.Parse(dr["estimated_cost"].ToString())) ?? "0");
                            row.SetAttribute("estimated_cost_usd", String.Format("{0:#,0.00}", Decimal.Parse(dr["estimated_cost_usd"].ToString())) ?? "0");
                            row.SetAttribute("exchange_rate", String.Format("{0:N6}", Decimal.Parse(dr["exchange_rate"].ToString())) ?? "0");
                            row.SetAttribute("attachment", attachmentList);


                            #region detail cost center
                            Antlr3.ST.StringTemplate rowDcc = group.GetInstanceOf("DetailCostCenter");
                            string rowDetailCostCenter_data = string.Empty, rowDetailCostCenter = string.Empty, ccClass = string.Empty;
                            int j = 0;
                            foreach (DataRow dcc in cc.Rows)
                            {
                                if (dr["id"].ToString() == dcc["pr_detail_id"].ToString())
                                {
                                    if (j % 2 != 0)
                                    {
                                        ccClass = "basefont";
                                    }
                                    else
                                    {
                                        ccClass = "zebra";
                                    }

                                    Antlr3.ST.StringTemplate rowDcc_data = group.GetInstanceOf("DetailCostCenter_Data");

                                    var cost_center = String.Format("{0} - {1}", dcc["cost_center_id"].ToString(), dcc["cost_center_name"].ToString());
                                    rowDcc_data.SetAttribute("class", ccClass);
                                    rowDcc_data.SetAttribute("cost_center", String.Format("{0} - {1}", dcc["cost_center_id"].ToString(), dcc["cost_center_name"].ToString()));
                                    rowDcc_data.SetAttribute("work_order", String.Format("{0} - {1}", dcc["work_order"].ToString(), dcc["work_order_description"].ToString()));
                                    rowDcc_data.SetAttribute("entity", String.Format("{0} - {1}", dcc["entity_id"].ToString(), dcc["entity_description"].ToString()));
                                    rowDcc_data.SetAttribute("legal_entity", dcc["legal_entity"].ToString());
                                    rowDcc_data.SetAttribute("percentage", dcc["percentage"]);
                                    rowDcc_data.SetAttribute("amount", String.Format("{0:#,0.00}", Decimal.Parse(dcc["amount"].ToString())) ?? "0");
                                    rowDcc_data.SetAttribute("amount_usd", String.Format("{0:#,0.00}", Decimal.Parse(dcc["amount_usd"].ToString())) ?? "0");
                                    rowDcc_data.SetAttribute("remarks", dcc["remarks"].ToString());

                                    rowDetailCostCenter_data += rowDcc_data.ToString();
                                    j++;
                                }
                            }


                            rowDcc.SetAttribute("currency_id", dr["currency_id"].ToString());
                            rowDcc.SetAttribute("detail_cost_center_data", rowDetailCostCenter_data);
                            rowDetailCostCenter += rowDcc.ToString();
                            row.SetAttribute("detail_cost_center", rowDetailCostCenter);
                            #endregion

                            rowDetail += row.ToString();
                            i++;
                        }

                        #region grand total
                        foreach (DataRow gTotal in grandTotal.Rows)
                        {
                            total += String.Format("{0} {1} <br/>", gTotal["currency_id"].ToString(),
                                        String.Format("{0:#,0.00}", Decimal.Parse(gTotal["total"].ToString()))
                                    );
                            total_usd += Decimal.Parse(gTotal["total_usd"].ToString());
                        }
                        #endregion

                        attachmentListGeneral = string.Empty;

                        DataRow[] dtDetailAttachmentGeneral = attachmentGeneral.Select("document_id='" + drM["id"].ToString() + "'", "id");
                        int ag = 0;
                        foreach (DataRow dra in dtDetailAttachmentGeneral)
                        {
                            if (ag != 0)
                            {
                                attachmentListGeneral += "<br/>";
                            }
                            attachmentListGeneral += "<a href='" + drM["file_link"].ToString() + dra["filename"].ToString() + "'>" + dra["filename"].ToString() + "</a><br/>";
                            ag++;
                        }

                        team = (drM["status_id"].ToString() == "21" || drM["status_id"].ToString() == "22") ? "Finance" : "Procurement";
                        team_email = (drM["status_id"].ToString() == "21" || drM["status_id"].ToString() == "22") ? true : false;

                        template.SetAttribute("team", team);
                        template.SetAttribute("team_email", team_email);
                        template.SetAttribute("isTest", IsNotificationTestMode);
                        if (IsNotificationTestMode)
                        {
                            template.SetAttribute("TO_CC", ProcesTestModeTemplate(MainRecipients, drM["subject"].ToString(), SecondaryRecipients));
                        }
                        else
                        {
                            template.SetAttribute("TO_CC", "");
                        }
                        template.SetAttribute("requester", drM["requester_name"].ToString());
                        template.SetAttribute("required_date", drM["required_date"].ToString());
                        template.SetAttribute("office", drM["cifor_office_name"].ToString());

                        /*template.SetAttribute("isDirectToFinance", Boolean.Parse(drM["isDirectToFinance"].ToString()));
                        template.SetAttribute("is_direct_to_finance", drM["is_direct_to_finance"].ToString());
                        template.SetAttribute("direct_to_finance_justification", drM["direct_to_finance_justification"].ToString());*/

                        //template.SetAttribute("cost_center", drM["cost_center"].ToString());
                        //template.SetAttribute("currency", drM["currency_id"].ToString());
                        //template.SetAttribute("exchange_rate", String.Format("{0:#,0.000000}", Decimal.Parse(drM["exchange_rate"].ToString())));

                        template.SetAttribute("remarks", drM["remarks"].ToString());
                        template.SetAttribute("purchase_type_description", drM["purchase_type_description"].ToString());
                        template.SetAttribute("purchasing_process", Boolean.Parse(drM["purchasing_process"].ToString()));
                        template.SetAttribute("direct_to_finance_justification", drM["direct_to_finance_justification"].ToString());
                        template.SetAttribute("is_show_processing_process", Boolean.Parse(drM["is_show_processing_process"].ToString()));
                        template.SetAttribute("details", rowDetail);
                        template.SetAttribute("attachmentgeneral", attachmentListGeneral);
                        template.SetAttribute("total",total);
                        template.SetAttribute("total_usd", String.Format("{0:#,0.00}", total_usd));

                        Antlr3.ST.StringTemplate Style = group.GetInstanceOf("Style");
                        template.SetAttribute("Style", Style);


                        //office mail box
                        var office = drM["cifor_office_name"].ToString();
                        var office_team_mail = string.Empty;
                        //DataTable office_mailbox = statics.GetProcurementOffice(office);
                        //foreach (DataRow dr in office_mailbox.Rows)
                        //{

                        //    officeEmail = string.Format(@"<a href='mailto:{0}' target='_blank' rel='noopener noreferrer' 
                        //                    data-auth='NotApplicable' data-safelink='true' data-linkindex='4' class='email-footer'>{0}</a>"
                        //                    , dr["Email"].ToString());
                        //    office_team_mail = string.Format(@"<a href='mailto:{0}' target='_blank'>Procurement Unit</a>", dr["Email"].ToString());
                        //}
                        
                        DataTable office_mailbox = statics.GetEmailProcurementOffice(office);
                        foreach (DataRow dr in office_mailbox.Rows)
                        {
                            officeEmail += string.Format(@"<a href='mailto:{0}' target='_blank' rel='noopener noreferrer' 
                                            data-auth='NotApplicable' data-safelink='true' data-linkindex='4' class='email-footer'>{0}</a>, "
                                                   , dr["Email"].ToString());
                            office_team_mail += string.Format(@"{0};", dr["Email"].ToString());
                        }

                        officeEmail = officeEmail.Remove(officeEmail.Length - 2);
                        office_team_mail = string.Format(@"<a href='mailto:{0}' target='_blank'>Procurement Unit</a>", office_team_mail);
                       

                        template.SetAttribute("office_mail", office_team_mail);

                        Antlr3.ST.StringTemplate Footer = group.GetInstanceOf("Footer");
                        Footer.SetAttribute("mailbox", officeEmail);
                        template.SetAttribute("Footer", Footer);

                        templateString = template.ToString();
                        template.Reset();

                        templateString = SendEmail(MainRecipients, templateString, drM["subject"].ToString(), SecondaryRecipients);
                        InsertLog(id, module_name, type, templateString);
                    }
                }
                return templateString;
            }
            catch (Exception ex)
            {
                Log.Logger.Error(ex.Message == "" ? ex.InnerException.Message : ex.Message);
                return string.Empty;
            }
        }
        #endregion Purchase Requisition

        #region RFQ
        public static string RFQ_SendToVendorEmail(string id, string template_no)
        {
            try
            {
                string module_name = "REQUEST FOR QUOTATION";
                string type = "SEND TO VENDOR";

                string templateString = string.Empty;
                if (IsNotificationActive)
                {
                    DataSet ds = NotificationData.RFQ.SendToVendor(id);

                    String subject = string.Empty, recipients = string.Empty
                            , MainRecipients = string.Empty
                            , SecondaryRecipients = string.Empty;

                    DataTable main = ds.Tables[0];

                    foreach (DataRow dr in main.Rows)
                    {
                        MainRecipients += dr["email_to"].ToString() + ";";
                    }

                    DataRow drM = main.Rows[0];

                    //office mail box
                    var office = drM["procurement_office_id"].ToString();
                    DataTable office_mailbox = statics.GetProcurementOffice(office);
                    foreach (DataRow dr in office_mailbox.Rows)
                    {
                        SecondaryRecipients += dr["Email"].ToString() + ";";
                    }

                    subject = drM["email_subject"].ToString();

                    templateString = RFQ_SendToVendor(ds, template_no);
                    templateString = SendEmail(MainRecipients, templateString, subject, SecondaryRecipients);
                    InsertLog(id, module_name, type, templateString);
                }
                return templateString;
            }
            catch (Exception ex)
            {
                Log.Logger.Error(ex.Message == "" ? ex.InnerException.Message : ex.Message);
                return string.Empty;
            }
        }

        public static string RFQ_SendToVendor(DataSet ds, string template_no)
        {
            return RFQ_SendToVendor(ds, template_no, "email");
        }

        public static string RFQ_SendToVendor(DataSet ds, string template_no, string method)
        {
            try
            {

                string templateString = string.Empty;

                group.RootDir = StartupPath;
                Antlr3.ST.StringTemplate template = group.GetInstanceOf("RFQBody_" + template_no);

                if (ds.Tables.Count > 0)
                {
                    DataTable main = ds.Tables[0];
                    DataTable detail = ds.Tables[1];

                    int i = 1;
                    string rowClass = string.Empty, rowDetail = string.Empty
                            , subject = string.Empty, recipients = string.Empty
                            , MainRecipients = string.Empty
                            , SecondaryRecipients = string.Empty
                            , imgHeaderPath = string.Empty
                            , legalEntity = string.Empty
                            , letterhead = string.Empty
                            , linkImgHeader = string.Empty
                            , signature = string.Empty
                            , procurement_office = string.Empty
                            , procurement_office_address = string.Empty
                            , footer = string.Empty;

         
                    DataRow drM = main.Rows[0];

                    subject = drM["email_subject"].ToString();

                    //office mail box
                    var office = drM["procurement_office_id"].ToString();
                    DataTable office_mailbox = statics.GetEmailProcurementOffice(office);
                    foreach (DataRow dr in office_mailbox.Rows)
                    {
                        MainRecipients += dr["Email"].ToString() + ";";
                    }

                    //foreach (DataRow dr in office_mailbox.Rows)
                    //{
                    //    SecondaryRecipients += dr["Email"].ToString() + ";";
                    //}

                    foreach (DataRow dr in detail.Rows)
                    {
                        string item_description = string.Empty;
                        item_description = dr["description"].ToString();

                        if (i % 2 != 0)
                        {
                            rowClass = "basefont";
                        }
                        else
                        {
                            rowClass = "zebra";
                        }

                        if (template_no == "5")
                        {
                            Antlr3.ST.StringTemplate row = group.GetInstanceOf("RFQDataB");
                            row.SetAttribute("class", rowClass);
                            row.SetAttribute("seq_no", i.ToString());
                            row.SetAttribute("description", item_description);
                            row.SetAttribute("quantity", String.Format("{0:#,0.00}", Decimal.Parse(dr["quantity"].ToString())) ?? "0");
                            rowDetail += row.ToString();
                        }
                        else
                        {
                            Antlr3.ST.StringTemplate row = group.GetInstanceOf("RFQData");
                            row.SetAttribute("class", rowClass);
                            row.SetAttribute("seq_no", i.ToString());
                            row.SetAttribute("description", item_description);
                            row.SetAttribute("quantity", String.Format("{0:#,0.00}", Decimal.Parse(dr["quantity"].ToString())) ?? "0");
                            row.SetAttribute("uom", dr["uom"].ToString());
                            rowDetail += row.ToString();
                        }


                        i++;
                    }

                    template.SetAttribute("isTest", IsNotificationTestMode);
                    if (IsNotificationTestMode && method == "email")
                    {
                        template.SetAttribute("TO_CC", ProcesTestModeTemplate(MainRecipients, subject, SecondaryRecipients));
                    }
                    else
                    {
                        template.SetAttribute("TO_CC", "");
                    }
                    string vendor_name = string.Empty;
                    string vendor_address = string.Empty;
                    vendor_name = drM["company_name"].ToString();
                    vendor_address = drM["address"].ToString();
                    legalEntity = drM["legal_entity"].ToString();
                    procurement_office = drM["procurement_office_name"].ToString();
                    procurement_office_address = drM["procurement_office_addresS"].ToString();

                    if (!String.IsNullOrEmpty(drM["address"].ToString()) && template_no != "5")
                    {
                        vendor_name += "<br/>" + vendor_address;
                    }

                    template.SetAttribute("vendor_name", vendor_name);
                    template.SetAttribute("vendor_address", vendor_address);
                    template.SetAttribute("rfq_no", drM["rfq_no"].ToString());
                    template.SetAttribute("vendor_location", drM["vendor_location"].ToString());
                    template.SetAttribute("cp_name", drM["cp_name"].ToString());
                    template.SetAttribute("document_date", drM["document_date"].ToString());
                    template.SetAttribute("due_date", drM["due_date"].ToString());
                    template.SetAttribute("pro_name", drM["pro_name"].ToString());
                    template.SetAttribute("pro_position", drM["pro_position"].ToString());
                    template.SetAttribute("pro_legal_entity", drM["pro_legal_entity"].ToString());
                    template.SetAttribute("pro_email", "<a href='mailto:" + drM["pro_email"].ToString() + "'>" + drM["pro_email"].ToString() + "</a>");
                    template.SetAttribute("legal_entity", legalEntity);
                    template.SetAttribute("procurement_office", procurement_office);
                    template.SetAttribute("procurement_office_address", procurement_office_address);

                    if (template_no == "2")
                    {
                        template.SetAttribute("pro_first_name", drM["pro_first_name"].ToString());
                    }
                    template.SetAttribute("details", rowDetail);

                    if (!string.IsNullOrEmpty(app_name))
                    {
                        app_name = string.Format("{0}/", app_name);
                    }

                    #region legalEntity
                    if (!string.IsNullOrEmpty(legalEntity))
                    {
                        switch (legalEntity)
                        {
                            case "CIFOR":
                                linkImgHeader = cifor_icon_path;
                                signature += string.Format(@"
                                             Center for International Forestry Research (CIFOR)<br/>
                                             {0}<br/>", procurement_office_address);
                                break;  
                            case "ICRAF":
                                signature += string.Format(@"
                                            World Agroforestry Center (ICRAF)<br/>
                                            {0}<br>", procurement_office_address);
                                break;

                            default:
                                break;
                        }
                        template.SetAttribute("signature", signature);
                    }
                    #endregion

                    Antlr3.ST.StringTemplate Style = group.GetInstanceOf("Style");
                    template.SetAttribute("Style", Style);

                    template.SetAttribute("cifor_icon_path", cifor_icon_path);
                    template.SetAttribute("icraf_icon_path", icraf_icon_path);
                    template.SetAttribute("glf_icon_path", glf_icon_path);
                    template.SetAttribute("rl_icon_path", rl_icon_path);

                    footer += string.Format(@" <a href='http://cifor.org/'>cifor.org</a> | <a href=https://www.worldagroforestry.org/'>worldagroforestry.org</a> | <a href='http://www.globallandscapesforum.org/'>globallandscapesforum.org</a> | <a href='http://resilient-landscapes.org/'>resilient-landscapes.org</a> <br/>
                                            <a href='http://www.cifor.org/' style='text-decoration:none'>
                                                <img src='{0}' alt='CIFOR logo.png' style='margin:5px;'>
                                            </a>
                                            <a href='https://www.worldagroforestry.org/' style='text-decoration:none'>
                                                <img src='{1}' alt='ICRAF logo.png' style='margin:5px;'>
                                            </a>
                                            <a href='http://www.globallandscapesforum.org/' style='text-decoration:none'>
                                                <img src='{2}' alt='global landscapes forum logo.png' style='margin:5px;'>
                                            </a>
                                            <a href='http://resilient-landscapes.org/' style='text-decoration:none'>
                                                <img src='{3}' alt='resilient-landscapes logo.png' style='margin:5px;'>
                                            </a><br/>
                                            CIFOR-ICRAF are <a href='http://cgiar.org'>CGIAR Research Center</a>
                                            ", cifor_icon_path, icraf_icon_path, glf_icon_path, rl_icon_path);

                    template.SetAttribute("footer", footer);

                    Antlr3.ST.StringTemplate TOC = group.GetInstanceOf("RFQToc");
                    TOC.SetAttribute("legal_entity", legalEntity);
                    template.SetAttribute("TOC", TOC);

                    templateString = template.ToString();
                    template.Reset();
                }
                return templateString;
            }
            catch (Exception ex)
            {
                Log.Logger.Error(ex.Message == "" ? ex.InnerException.Message : ex.Message);
                return string.Empty;
            }
        }

        public static string RFQ_Due(string dueDate)
        {
            try
            {
                string templateString = string.Empty;

                DataSet ds = NotificationData.RFQ.Due(dueDate);
                DataTable goffice = ds.Tables[0];

                group.RootDir = StartupPath;
                Antlr3.ST.StringTemplate template = group.GetInstanceOf("RFQDue");

                if (IsNotificationActive)
                {
                    if (ds.Tables.Count > 0)
                    {   
                        if(goffice.Rows.Count > 0)
                        {
                            foreach (DataRow d in goffice.Rows)
                            {
                                var office = d["cifor_office_id"].ToString();
                                var subject = d["subject"].ToString();
                                var MainRecipients = string.Empty;
                                var rowClass = string.Empty;
                                var rowDetail = string.Empty;
                                int i = 0;
                                var mailbox = string.Empty;
                                DataTable office_mailbox = statics.GetEmailProcurementOffice(office);

                                /* main receipient */

                                //if (ds.Tables[1].Rows.Count > 0)
                                //{
                                //    DataRow[] recipient = ds.Tables[1].Select("cifor_office_id='" + office + "'", "TO asc");
                                //    foreach (DataRow dto in recipient)
                                //    {
                                //        MainRecipients += dto["TO"].ToString() + ";";
                                //    }

                                //}

                                /* main receipient  by office mail */

                                foreach (DataRow dto in office_mailbox.Rows)
                                {
                                    MainRecipients += dto["Email"].ToString() + "";
                                }

                                /* mailbox */
                                //if (ds.Tables[2].Rows.Count > 0)
                                //{
                                //    DataRow[] dtDetailMailbox = ds.Tables[2].Select("cifor_office_id='" + office + "'", "mailbox");
                                //    foreach (DataRow dra in dtDetailMailbox)
                                //    {

                                //        mailbox = string.Format(@"<a href='mailto:{0}' target='_blank' rel='noopener noreferrer' 
                                //            data-auth='NotApplicable' data-safelink='true' data-linkindex='4' class='email-footer'>{0}</a>"
                                //                     , dra["mailbox"].ToString());
                                //    }
                                //}

                                /* mailbox  by office mail*/
                                foreach (DataRow dr in office_mailbox.Rows)
                                {
                                    mailbox += string.Format(@"<a href='mailto:{0}' target='_blank' rel='noopener noreferrer' 
                                            data-auth='NotApplicable' data-safelink='true' data-linkindex='4' class='email-footer'>{0}</a>, "
                                                           , dr["Email"].ToString());
                                }
                                mailbox = mailbox.Remove(mailbox.Length - 2);

                                /* main */
                                if (ds.Tables[3].Rows.Count > 0)
                                {
                                    DataRow[] main = ds.Tables[3].Select("cifor_office_id='" + office + "'", "id asc");
                                 
                                    foreach (DataRow di in main)
                                    {
                                        if (i % 2 != 0)
                                        {
                                            rowClass = "basefont";
                                        }
                                        else
                                        {
                                            rowClass = "zebra";
                                        }

                                        Antlr3.ST.StringTemplate row = group.GetInstanceOf("RFQDue_data");
                                        row.SetAttribute("class", rowClass);
                                        row.SetAttribute("rfq_no", di["rfq_no"].ToString());
                                        row.SetAttribute("vendor", di["vendor"].ToString());
                                        row.SetAttribute("contact_person", di["contact_person"].ToString());
                                        row.SetAttribute("send_date", di["send_date"].ToString());
                                        rowDetail += row.ToString();
                                        i++;
                                    }
                                }


                                template.SetAttribute("isTest", IsNotificationTestMode);
                                if (IsNotificationTestMode)
                                {
                                    template.SetAttribute("TO_CC", ProcesTestModeTemplate(MainRecipients, subject, ""));
                                }
                                else
                                {
                                    template.SetAttribute("TO_CC", "");
                                }

                                template.SetAttribute("details", rowDetail);

                                Antlr3.ST.StringTemplate Style = group.GetInstanceOf("Style");
                                template.SetAttribute("Style", Style);

                                Antlr3.ST.StringTemplate Footer = group.GetInstanceOf("Footer");
                                Footer.SetAttribute("mailbox", mailbox);
                                template.SetAttribute("Footer", Footer);

                                templateString = template.ToString();
                                template.Reset();

                                templateString = SendEmail(MainRecipients, templateString, subject, "");

                            }
                        }
                    }
                }
                return templateString;
            }
            catch (Exception ex)
            {
                Log.Logger.Error(ex.Message == "" ? ex.InnerException.Message : ex.Message);
                return string.Empty;
            }
        }
        #endregion RFQ

        #region User Confirmation
        public static string UserConfirmation_Send()
        {

            string templateString = string.Empty;

            DataSet ds = NotificationData.UserConfirmation.SendConfirmation();

            group.RootDir = StartupPath;

            if (IsNotificationActive)
            {
                if (ds.Tables.Count > 0)
                {
                    foreach (DataRow drEmail in ds.Tables[0].Rows)
                    {
                        Antlr3.ST.StringTemplate template = group.GetInstanceOf("ItemConfirmation");

                        int i = 0;
                        string rowClass = string.Empty, rowDetail = string.Empty
                                , subject = string.Empty, recipients = string.Empty
                                , MainRecipients = string.Empty
                                , SecondaryRecipients = string.Empty;

                        MainRecipients += drEmail["to"].ToString();
                        SecondaryRecipients += drEmail["cc"].ToString();
                        subject = drEmail["email_subject"].ToString();

                        DataTable detail = ds.Tables[1].Select("key='" + drEmail["key"].ToString() + "'", "id asc").CopyToDataTable();

                        foreach (DataRow dr in detail.Rows)
                        {
                            if (i % 2 != 0)
                            {
                                rowClass = "basefont";
                            }
                            else
                            {
                                rowClass = "zebra";
                            }

                            Antlr3.ST.StringTemplate row = group.GetInstanceOf("ItemConfirmation_Data");
                            row.SetAttribute("class", rowClass);
                            row.SetAttribute("item_code", dr["item_code"].ToString());
                            row.SetAttribute("item_description", dr["item_description"].ToString());
                            row.SetAttribute("pr_quantity", String.Format("{0:#,0.00}", Decimal.Parse(dr["pr_quantity"].ToString())) ?? "0");
                            row.SetAttribute("send_quantity", String.Format("{0:#,0.00}", Decimal.Parse(dr["send_quantity"].ToString())) ?? "0");
                            row.SetAttribute("uom", dr["uom"].ToString());
                            rowDetail += row.ToString();

                            i++;

                            DataModel.UserConfirmationDetail du = new DataModel.UserConfirmationDetail();
                            du.id = dr["id"].ToString();
                            du.is_notification_sent = "1";
                            du.user_id = "myCIFOR-Systems";
                            staticsUserConfirmation.UpdateStatus(du);
                        }

                        template.SetAttribute("isTest", IsNotificationTestMode);
                        if (IsNotificationTestMode)
                        {
                            template.SetAttribute("TO_CC", ProcesTestModeTemplate(MainRecipients, subject, SecondaryRecipients));
                        }
                        else
                        {
                            template.SetAttribute("TO_CC", "");
                        }
                        template.SetAttribute("requester", drEmail["requester"].ToString());
                        template.SetAttribute("footer", drEmail["footer"].ToString());
                        template.SetAttribute("details", rowDetail);

                        templateString = template.ToString();
                        template.Reset();

                        templateString = SendEmail(MainRecipients, templateString, subject, SecondaryRecipients);
                    }
                }
            }
            return templateString;
        }

        public static string UserConfirmation_AutoConfirm()
        {

            string templateString = string.Empty;

            DataSet ds = NotificationData.UserConfirmation.AutoConfirmation();

            group.RootDir = StartupPath;

            if (IsNotificationActive)
            {
                if (ds.Tables.Count > 0)
                {
                    foreach (DataRow drEmail in ds.Tables[0].Rows)
                    {
                        Antlr3.ST.StringTemplate template = group.GetInstanceOf("ItemConfirmationAuto");

                        int i = 0;
                        string rowClass = string.Empty, rowDetail = string.Empty
                                , subject = string.Empty, recipients = string.Empty
                                , MainRecipients = string.Empty
                                , SecondaryRecipients = string.Empty;

                        MainRecipients += drEmail["to"].ToString();
                        SecondaryRecipients += drEmail["cc"].ToString();
                        subject = drEmail["email_subject"].ToString();

                        DataTable detail = ds.Tables[1].Select("key='" + drEmail["key"].ToString() + "'", "id asc").CopyToDataTable();

                        foreach (DataRow dr in detail.Rows)
                        {
                            if (i % 2 != 0)
                            {
                                rowClass = "basefont";
                            }
                            else
                            {
                                rowClass = "zebra";
                            }

                            Antlr3.ST.StringTemplate row = group.GetInstanceOf("ItemConfirmation_Data");
                            row.SetAttribute("class", rowClass);
                            row.SetAttribute("item_code", dr["item_code"].ToString());
                            row.SetAttribute("item_description", dr["item_description"].ToString());
                            row.SetAttribute("pr_quantity", String.Format("{0:#,0.00}", Decimal.Parse(dr["pr_quantity"].ToString())) ?? "0");
                            row.SetAttribute("send_quantity", String.Format("{0:#,0.00}", Decimal.Parse(dr["send_quantity"].ToString())) ?? "0");
                            row.SetAttribute("uom", dr["uom"].ToString());
                            rowDetail += row.ToString();

                            i++;

                            DataModel.UserConfirmationDetail du = new DataModel.UserConfirmationDetail();
                            du.id = dr["id"].ToString();
                            du.status_id = "50";
                            du.user_id = "myCIFOR-Systems";
                            staticsUserConfirmation.UpdateStatus(du);
                        }

                        template.SetAttribute("isTest", IsNotificationTestMode);
                        if (IsNotificationTestMode)
                        {
                            template.SetAttribute("TO_CC", ProcesTestModeTemplate(MainRecipients, subject, SecondaryRecipients));
                        }
                        else
                        {
                            template.SetAttribute("TO_CC", "");
                        }
                        template.SetAttribute("requester", drEmail["requester"].ToString());
                        template.SetAttribute("footer", drEmail["footer"].ToString());
                        template.SetAttribute("details", rowDetail);

                        templateString = template.ToString();
                        template.Reset();

                        templateString = SendEmail(MainRecipients, templateString, subject, SecondaryRecipients);
                    }
                }
            }
            return templateString;
        }

        public static string UserItemConfirmation(string id)
        {
            string module_name = "ITEM CONFIRMATION";
            string type = "CONFIRMED";
            Boolean isSent = false;

            string templateString = string.Empty;

            DataSet ds = NotificationData.UserConfirmation.UserConfirmationConfirmed(id);

            group.RootDir = StartupPath;
            Antlr3.ST.StringTemplate template = group.GetInstanceOf("UserItemConfirmation");

            //isSent = IsSent(id, module_name, type);

            if (IsNotificationActive && !isSent)
            {
                if (ds.Tables.Count > 0)
                {
                    foreach (DataRow drEmail in ds.Tables[0].Rows)
                    {
                        int i = 0;
                        string rowClass = string.Empty, rowDetail = string.Empty
                                , subject = string.Empty, recipients = string.Empty
                                , MainRecipients = string.Empty
                                , SecondaryRecipients = string.Empty;

                        MainRecipients += drEmail["to"].ToString();
                        SecondaryRecipients += drEmail["cc"].ToString();
                        subject = drEmail["email_subject"].ToString();

                        DataTable detail = ds.Tables[1].Select("key='" + drEmail["key"].ToString() + "'", "id asc").CopyToDataTable();

                        foreach (DataRow dr in detail.Rows)
                        {
                            if (i % 2 != 0)
                            {
                                rowClass = "basefont";
                            }
                            else
                            {
                                rowClass = "zebra";
                            }

                            Antlr3.ST.StringTemplate row = group.GetInstanceOf("UserItemConfirmation_Data");
                            row.SetAttribute("class", rowClass);
                            row.SetAttribute("item_description", dr["item_description"].ToString());
                            row.SetAttribute("qty_requested", String.Format("{0:#,0.00}", Decimal.Parse(dr["qty_requested"].ToString())) ?? "0");
                            row.SetAttribute("total_previous_qty", String.Format("{0:#,0.00}", Decimal.Parse(dr["total_previous_qty"].ToString())) ?? "0");
                            row.SetAttribute("send_quantity", String.Format("{0:#,0.00}", Decimal.Parse(dr["send_quantity"].ToString())) ?? "0");
                            row.SetAttribute("qty_not_yet_delivered", String.Format("{0:#,0.00}", Decimal.Parse(dr["qty_not_yet_delivered"].ToString())) ?? "0");
                            row.SetAttribute("quantity", String.Format("{0:#,0.00}", Decimal.Parse(dr["quantity"].ToString())) ?? "0");
                            row.SetAttribute("qty_follow_up", String.Format("{0:#,0.00}", Decimal.Parse(dr["qty_follow_up"].ToString())) ?? "0");
                            rowDetail += row.ToString();

                            i++;

                            DataModel.UserConfirmationDetail du = new DataModel.UserConfirmationDetail();
                            du.id = dr["id"].ToString();
                            du.is_notification_sent = "1";
                            du.user_id = drEmail["created_by"].ToString();
                            staticsUserConfirmation.UpdateStatus(du);
                        }

                        template.SetAttribute("isTest", IsNotificationTestMode);
                        if (IsNotificationTestMode)
                        {
                            template.SetAttribute("TO_CC", ProcesTestModeTemplate(MainRecipients, subject, SecondaryRecipients));
                        }
                        else
                        {
                            template.SetAttribute("TO_CC", "");
                        }
                        template.SetAttribute("requester", drEmail["created_by"].ToString());
                        template.SetAttribute("document_no", drEmail["document_no"].ToString());
                        template.SetAttribute("details", rowDetail);

                        templateString = template.ToString();
                        template.Reset();

                        templateString = SendEmail(MainRecipients, templateString, subject, SecondaryRecipients);
                        InsertLog(id, module_name, type, templateString);
                    }
                }
            }
            return templateString;
        }
        #endregion User Confirmation

        #region Purchase Order
        public static string PO_Approved(string id)
        {
            string module_name = "PURCHASE ORDER";
            string type = "APPROVED";

            string templateString = string.Empty;

            DataSet ds = NotificationData.PurchaseOrder.Approved(id);

            group.RootDir = StartupPath;

            string footerContact = string.Empty;

            if (IsNotificationActive)
            {
                if (ds.Tables.Count > 0)
                {
                    footerContact = ds.Tables[0].Rows[0]["footer"].ToString();

                    foreach (DataRow dm in ds.Tables[0].Rows)
                    {
                        string row_id = string.Empty
                            , rowClass = string.Empty
                            , rowDetail = string.Empty
                            , subject = string.Empty
                            , recipients = string.Empty
                            , MainRecipients = string.Empty
                            , SecondaryRecipients = string.Empty
                            , vendorName = string.Empty
                            , deliveryDate = string.Empty
                            , PRDetail = string.Empty
                            , POLink = string.Empty;

                        Antlr3.ST.StringTemplate template = group.GetInstanceOf("POApproved");

                        subject = dm["subject"].ToString();
                        POLink = dm["po_link"].ToString();
                        recipients = "all";

                        /* secondary receipient */
                        DataTable dCC = ds.Tables[1];
                        foreach (DataRow dc in dCC.Rows)
                        {
                            if (!string.IsNullOrEmpty(dc["TO"].ToString()))
                            {
                                MainRecipients += dc["TO"].ToString() + ";";
                            }                            
                        }

                        /* data */
                        DataTable dPR = ds.Tables[2];
                        foreach (DataRow dp in dPR.Rows)
                        {
                            string pr_id = string.Empty
                                , pr_no = string.Empty
                                , item_detail = string.Empty;

                            pr_id = dp["pr_id"].ToString();
                            pr_no = dp["pr_link"].ToString();

                            Antlr3.ST.StringTemplate rowPR = group.GetInstanceOf("PODetail");
                            rowPR.SetAttribute("pr_no", pr_no);

                            DataTable dIt = ds.Tables[3].Select("pr_id='" + pr_id + "'", "").CopyToDataTable();
                            int i = 0;
                            foreach (DataRow dr in dIt.Rows)
                            {
                                if (i % 2 != 0)
                                {
                                    rowClass = "basefont";
                                }
                                else
                                {
                                    rowClass = "zebra";
                                }

                                Antlr3.ST.StringTemplate row = group.GetInstanceOf("POData");
                                row.SetAttribute("class", rowClass);
                                row.SetAttribute("item_code", dr["item_code"].ToString());
                                row.SetAttribute("description", dr["item_description"].ToString());
                                row.SetAttribute("quantity", String.Format("{0:#,0.00}", Decimal.Parse(dr["quantity"].ToString())) ?? "0");
                                row.SetAttribute("uom", dr["uom"].ToString());
                                item_detail += row.ToString();

                                if (string.IsNullOrEmpty(vendorName))
                                    vendorName = dr["vendor_name"].ToString();
                                if (string.IsNullOrEmpty(deliveryDate))
                                    deliveryDate = dr["delivery_date"].ToString();

                                i++;
                            }
                            rowPR.SetAttribute("item_details", item_detail);

                            rowDetail += rowPR.ToString();
                        }
                        template.SetAttribute("details", rowDetail);

                        template.SetAttribute("isTest", IsNotificationTestMode);
                        if (IsNotificationTestMode)
                        {
                            template.SetAttribute("TO_CC", ProcesTestModeTemplate(MainRecipients, subject, SecondaryRecipients));
                        }
                        else
                        {
                            template.SetAttribute("TO_CC", "");
                        }
                        template.SetAttribute("po_code", POLink);
                        template.SetAttribute("requester", recipients);
                        template.SetAttribute("vendor", vendorName);
                        template.SetAttribute("delivery_date", deliveryDate);
                        template.SetAttribute("footer", dm["footer"].ToString());

                        Antlr3.ST.StringTemplate Style = group.GetInstanceOf("Style");
                        template.SetAttribute("Style", Style);

                        //Antlr3.ST.StringTemplate Footer = group.GetInstanceOf("Footer");
                        //template.SetAttribute("Footer", Footer);

                        Antlr3.ST.StringTemplate Footer = group.GetInstanceOf("Footer");
                        Footer.SetAttribute("mailbox", dm["office_email"].ToString());
                        template.SetAttribute("Footer", Footer);

                        templateString = template.ToString();
                        template.Reset();

                        templateString = SendEmail(MainRecipients, templateString, subject, SecondaryRecipients);
                        InsertLog(id, module_name, type, templateString);
                    }
                }
            }
            return templateString;
        }

        public static string PO_ApprovedToUser(string id)
        {
            try
            {
                string module_name = "PURCHASE ORDER";
                string type = "APPROVED";

                string templateString = string.Empty;

                DataSet ds = NotificationData.PurchaseOrder.ApprovedToUser(id);

                group.RootDir = StartupPath;

                string footerContact = string.Empty;

                if (IsNotificationActive)
                {
                    if (ds.Tables.Count > 0)
                    {
                        footerContact = ds.Tables[0].Rows[0]["footer"].ToString();

                        foreach (DataRow dm in ds.Tables[0].Rows)
                        {
                            string row_id = string.Empty
                                , rowClass = string.Empty
                                , rowDetail = string.Empty
                                , subject = string.Empty
                                , recipients = string.Empty
                                , MainRecipients = string.Empty
                                , SecondaryRecipients = string.Empty
                                , vendorName = string.Empty
                                , deliveryDate = string.Empty
                                , PRDetail = string.Empty;

                            Antlr3.ST.StringTemplate template = group.GetInstanceOf("POApprovedToUser");

                            row_id = dm["ROW_ID"].ToString();
                            subject = dm["subject"].ToString();
                            recipients = dm["requester_name"].ToString();

                            /* main receipient */
                            //if (dm["requester_email"].ToString() == dm["initiator_email"].ToString())
                            //{
                            //    MainRecipients = dm["requester_email"].ToString();
                            //}
                            //else
                            //{
                            //    MainRecipients = dm["requester_email"].ToString() + ";" + dm["initiator_email"].ToString();
                            //}

                            MainRecipients = (string.IsNullOrEmpty(dm["requester_email"].ToString()) ? "" : (dm["requester_email"].ToString()) + ";") + (dm["initiator_email"].ToString() == dm["requester_email"].ToString() ? "" : dm["initiator_email"].ToString());

                            /* secondary receipient */
                            DataTable dCC = ds.Tables[1].Select("ROW_ID='" + row_id + "'", "CC asc").CopyToDataTable();
                            //foreach (DataRow dc in dCC.Rows)
                            //{
                            //    SecondaryRecipients += dc["CC"].ToString() + ";";
                            //}

                            //SecondaryRecipients = dm["initiator_email"].ToString();

                            /* data */
                            //DataTable dPR = ds.Tables[2].Select("ROW_ID='" + row_id + "' ", "pr_no asc").CopyToDataTable();
                            Antlr3.ST.StringTemplate rowPR = group.GetInstanceOf("PODetail");
                            string profile_page = String.Format("<a href='{0}{1}/PurchaseRequisition/detail.aspx?id={2}'>{3}</a>", home_url, app_name, dm["pr_id"].ToString(), dm["pr_no"].ToString());
                            //template.SetAttribute("pr_no", profile_page);
                            rowPR.SetAttribute("pr_no", profile_page);
                            DataTable dPR = ds.Tables[2].Select("ROW_ID='" + row_id + "' and user_id='" + dm["user_id"].ToString() + "'", "pr_no asc").CopyToDataTable();
                            foreach (DataRow dp in dPR.Rows)
                            {
                                string pr_id = string.Empty
                                    , pr_no = string.Empty
                                    , item_detail = string.Empty;

                                pr_id = dp["pr_id"].ToString();
                                pr_no = dp["pr_link"].ToString();

                                //DataTable dIt = ds.Tables[3].Select("ROW_ID='" + row_id + "' and pr_id='" + pr_id + "'", "line_number asc").CopyToDataTable();
                                DataTable dIt = ds.Tables[3].Select("ROW_ID='" + row_id + "' and pr_id='" + pr_id + "' and user_id = '" + dm["user_id"].ToString() + "'", "").CopyToDataTable();
                                int i = 0;
                                foreach (DataRow dr in dIt.Rows)
                                {
                                    if (i % 2 != 0)
                                    {
                                        rowClass = "basefont";
                                    }
                                    else
                                    {
                                        rowClass = "zebra";
                                    }

                                    Antlr3.ST.StringTemplate row = group.GetInstanceOf("POData");
                                    row.SetAttribute("class", rowClass);
                                    row.SetAttribute("item_code", dr["item_code"].ToString());
                                    row.SetAttribute("description", dr["item_description"].ToString());
                                    row.SetAttribute("quantity", String.Format("{0:#,0.00}", Decimal.Parse(dr["quantity"].ToString())) ?? "0");
                                    row.SetAttribute("uom", dr["uom"].ToString());
                                    item_detail += row.ToString();

                                    if (string.IsNullOrEmpty(vendorName))
                                        vendorName = dr["vendor_name"].ToString();
                                    if (string.IsNullOrEmpty(deliveryDate))
                                        deliveryDate = dr["delivery_date"].ToString();

                                    i++;
                                }
                                rowPR.SetAttribute("item_details", item_detail);

                                rowDetail += rowPR.ToString();
                            }
                            template.SetAttribute("details", rowDetail);

                            template.SetAttribute("isTest", IsNotificationTestMode);
                            if (IsNotificationTestMode)
                            {
                                template.SetAttribute("TO_CC", ProcesTestModeTemplate(MainRecipients, subject, SecondaryRecipients));
                            }
                            else
                            {
                                template.SetAttribute("TO_CC", "");
                            }
                            template.SetAttribute("requester", recipients);
                            template.SetAttribute("vendor", vendorName);
                            template.SetAttribute("delivery_date", deliveryDate);
                            template.SetAttribute("footer", dm["footer"].ToString());
                            template.SetAttribute("po_no", String.Format("<a href='{0}{1}/PurchaseOrder/detail.aspx?id={2}'>{3}</a>", home_url, app_name, id, dm["vs_no"].ToString()));

                            Antlr3.ST.StringTemplate Style = group.GetInstanceOf("Style");
                            template.SetAttribute("Style", Style);

                            Antlr3.ST.StringTemplate Footer = group.GetInstanceOf("Footer");
                            Footer.SetAttribute("mailbox", dm["office_email"].ToString());
                            template.SetAttribute("Footer", Footer);


                            templateString = template.ToString();
                            template.Reset();

                            templateString = SendEmail(MainRecipients, templateString, subject, SecondaryRecipients);
                            InsertLog(id, module_name, type, templateString);
                        }
                    }
                }
                return templateString;
            }
            catch (Exception ex)
            {
                ExceptionHelpers.PrintError(ex);
                return "";
            }

            
        }

        public static string PO_ToVendor(string id)
        {
            string templateString = string.Empty;

            DataSet ds = NotificationData.PurchaseOrder.SendToVendor(id);

            group.RootDir = StartupPath;
            Antlr3.ST.StringTemplate template = group.GetInstanceOf("PODraft");

            if (IsNotificationActive)
            {
                if (ds.Tables.Count > 0)
                {
                    DataTable recipient = ds.Tables[0];
                    DataTable cc = ds.Tables[1];
                    DataTable main = ds.Tables[2];
                    DataTable detail = ds.Tables[3];
                    DataTable signed = ds.Tables[4];

                    if (main.Rows.Count > 0)
                    {
                        int i = 0;
                        string rowClass = string.Empty, rowDetail = string.Empty,
                                subject = string.Empty,
                                recipients = string.Empty, MainRecipients = string.Empty, SecondRecipients = string.Empty;

                        if (recipient.Rows.Count > 0)
                        {
                            subject = recipient.Rows[0]["subject"].ToString();
                        }

                        foreach (DataRow dr in recipient.Rows)
                        {
                            MainRecipients += dr["TO"].ToString() + ";";
                        }

                        foreach (DataRow dr in cc.Rows)
                        {
                            SecondRecipients += dr["CC"].ToString() + ";";
                        }

                        foreach (DataRow dm in main.Rows)
                        {
                            string document_date = dm["document_date"].ToString();
                            if (!string.IsNullOrEmpty(document_date))
                            {
                                document_date = DateTime.Parse(document_date).ToString("dd MMM yyyy");
                            }
                            template.SetAttribute("vendor_name", dm["vendor_name"].ToString());
                            template.SetAttribute("po_sun_code", dm["po_sun_code"].ToString());
                            template.SetAttribute("vendor_address", dm["vendor_address"].ToString());
                            template.SetAttribute("document_date", dm["document_date"].ToString());
                            template.SetAttribute("term_of_payment", dm["term_of_payment"].ToString());
                            template.SetAttribute("vendor_telp_no", dm["vendor_telp_no"].ToString());
                            template.SetAttribute("vendor_fax_no", dm["vendor_fax_no"].ToString());
                            template.SetAttribute("vendor_contact_person", dm["vendor_contact_person_name"].ToString());
                            template.SetAttribute("order_reference", dm["order_reference"].ToString());
                            template.SetAttribute("currency_id", dm["currency_id"].ToString());
                            template.SetAttribute("remarks", dm["remarks"].ToString());
                            template.SetAttribute("gross_amount", String.Format("{0:#,0.00}", Decimal.Parse(dm["gross_amount"].ToString())) ?? "0.00");
                            template.SetAttribute("discount", String.Format("{0:#,0.00}", Decimal.Parse(dm["discount"].ToString())) ?? "0.00");
                            template.SetAttribute("tax", String.Format("{0:#,0.00}", Decimal.Parse(dm["tax"].ToString())) ?? "0.00");
                            template.SetAttribute("tax_amount", String.Format("{0:#,0.00}", Decimal.Parse(dm["tax_amount"].ToString())) ?? "0.00");
                            template.SetAttribute("total_amount", String.Format("{0:#,0.00}", Decimal.Parse(dm["total_amount"].ToString())) ?? "0.00");
                            template.SetAttribute("cifor_delivery_address", dm["cifor_delivery_address_name"].ToString());
                            template.SetAttribute("invoice_delivery_address", dm["invoice_delivery_address"].ToString());
                            template.SetAttribute("organization_name", dm["organization_name"].ToString());
                            template.SetAttribute("delivery_telp", dm["cifor_delivery_telp"].ToString());
                            template.SetAttribute("accountant", dm["accountant"].ToString());
                            template.SetAttribute("delivery_fax", dm["cifor_delivery_fax"].ToString());
                            template.SetAttribute("expected_delivery_date", DateTime.Parse(dm["expected_delivery_date"].ToString()).ToString("dd MMM yyyy"));
                            template.SetAttribute("cifor_shipment_account", dm["cifor_shipment_name"].ToString());
                            if (Decimal.Parse(dm["tax"].ToString()) == 0 || String.IsNullOrEmpty(dm["tax"].ToString()))
                            {
                                template.SetAttribute("isZeroVAT", true);
                            }
                        }

                        foreach (DataRow di in detail.Rows)
                        {
                            if (i % 2 != 0)
                            {
                                rowClass = "basefont";
                            }
                            else
                            {
                                rowClass = "zebra";
                            }

                            string description = "";
                            if (!string.IsNullOrEmpty(di["brand_name"].ToString()))
                            {
                                description += di["brand_name"].ToString() + "<br/>";
                            }
                            description += di["description"].ToString() + "<br/>";

                            Antlr3.ST.StringTemplate row = group.GetInstanceOf("PODraft_data");
                            row.SetAttribute("class", rowClass);
                            row.SetAttribute("seq", (i + 1));
                            row.SetAttribute("item_code", di["item_code"].ToString());
                            row.SetAttribute("description", description);
                            row.SetAttribute("quantity", String.Format("{0:#,0.00}", Decimal.Parse(di["po_quantity"].ToString())) ?? "0.00");
                            row.SetAttribute("uom", di["uom"].ToString());
                            row.SetAttribute("unit_price", String.Format("{0:#,0.00}", Decimal.Parse(di["po_unit_price"].ToString())) ?? "0.00");
                            row.SetAttribute("subtotal", String.Format("{0:#,0.00}", Decimal.Parse(di["po_unit_price"].ToString()) * Decimal.Parse(di["po_quantity"].ToString())) ?? "0.00");
                            row.SetAttribute("discount", String.Format("{0:#,0.00}", Decimal.Parse(di["po_discount"].ToString())) ?? "0.00");
                            row.SetAttribute("additional_discount", String.Format("{0:#,0.00}", Decimal.Parse(di["po_additional_discount"].ToString())) ?? "0.00");
                            row.SetAttribute("total", String.Format("{0:#,0.00}", Decimal.Parse(di["po_line_total"].ToString())) ?? "0.00");
                            rowDetail += row.ToString();
                            i++;
                        }

                        foreach (DataRow dsg in signed.Rows)
                        {
                            template.SetAttribute("approver_name", dsg["EMP_NAME"].ToString());
                            template.SetAttribute("approver_title", dsg["JOB_TITLE"].ToString());
                            template.SetAttribute("approver_date", dsg["APPROVED_DATE"].ToString());
                        }

                        template.SetAttribute("isTest", IsNotificationTestMode);
                        if (IsNotificationTestMode)
                        {
                            template.SetAttribute("TO_CC", ProcesTestModeTemplate(MainRecipients, subject, ""));
                        }
                        else
                        {
                            template.SetAttribute("TO_CC", "");
                        }

                        template.SetAttribute("details", rowDetail);
                        Antlr3.ST.StringTemplate po_termcondition = group.GetInstanceOf("PO_TOC");
                        template.SetAttribute("toc", po_termcondition.ToString());

                        Antlr3.ST.StringTemplate Style = group.GetInstanceOf("Style");
                        template.SetAttribute("Style", Style);

                        Antlr3.ST.StringTemplate Footer = group.GetInstanceOf("Footer");
                        template.SetAttribute("Footer", Footer);


                        templateString = template.ToString();
                        template.Reset();

                        templateString = SendEmail(MainRecipients, templateString, subject, SecondRecipients);
                    }
                }
            }
            return templateString;
        }

        public static string PO_Delivery(string dueDate)
        {

            string templateString = string.Empty;

            DataSet ds = NotificationData.PurchaseOrder.Delivery(dueDate);
            DataTable goffice = ds.Tables[0];

            group.RootDir = StartupPath;
            Antlr3.ST.StringTemplate template = group.GetInstanceOf("PODelivery");

            if (IsNotificationActive)
            {
                if (ds.Tables.Count > 0)
                {
                    if (goffice.Rows.Count > 0)
                    {
                        foreach (DataRow d in goffice.Rows)
                        {
                            var office = d["cifor_office_id"].ToString();
                            var subject = d["subject"].ToString();
                            var MainRecipients = string.Empty;
                            var rowClass = string.Empty;
                            var rowDetail = string.Empty;
                            int i = 0;
                            var mailbox = string.Empty;
                            DataTable office_mailbox = statics.GetEmailProcurementOffice(office);


                            /* main receipient */

                            //if (ds.Tables[1].Rows.Count > 0)
                            //{
                            //    DataRow[] recipient = ds.Tables[1].Select("cifor_office_id='" + office + "'", "TO asc");
                            //    foreach (DataRow dto in recipient)
                            //    {
                            //        MainRecipients += dto["TO"].ToString() + ";";
                            //    }

                            //}

                            /* main receipient  by office mail */

                            foreach (DataRow dto in office_mailbox.Rows)
                            {
                                MainRecipients += dto["Email"].ToString() + "";
                            }

                            /* mailbox */
                            //if (ds.Tables[2].Rows.Count > 0)
                            //{
                            //    DataRow[] dtDetailMailbox = ds.Tables[2].Select("cifor_office_id='" + office + "'", "mailbox");
                            //    foreach (DataRow dra in dtDetailMailbox)
                            //    {

                            //        mailbox = string.Format(@"<a href='mailto:{0}' target='_blank' rel='noopener noreferrer' 
                            //            data-auth='NotApplicable' data-safelink='true' data-linkindex='4' class='email-footer'>{0}</a>"
                            //                     , dra["mailbox"].ToString());
                            //    }
                            //}

                            /* mailbox  by office mail*/
                            foreach (DataRow dr in office_mailbox.Rows)
                            {
                                mailbox += string.Format(@"<a href='mailto:{0}' target='_blank' rel='noopener noreferrer' 
                                            data-auth='NotApplicable' data-safelink='true' data-linkindex='4' class='email-footer'>{0}</a>, "
                                                       , dr["Email"].ToString());
                            }
                            mailbox = mailbox.Remove(mailbox.Length - 2);

                            /* main */
                            if (ds.Tables[2].Rows.Count > 0)
                            {
                                DataRow[] main = ds.Tables[2].Select("cifor_office_id='" + office + "'", "id asc");

                                foreach (DataRow di in main)
                                {
                                    if (i % 2 != 0)
                                    {
                                        rowClass = "basefont";
                                    }
                                    else
                                    {
                                        rowClass = "zebra";
                                    }

                                    Antlr3.ST.StringTemplate row = group.GetInstanceOf("PODelivery_data");
                                    row.SetAttribute("class", rowClass);
                                    row.SetAttribute("po_sun", di["po_sun_code"].ToString());
                                    row.SetAttribute("po_code", di["po_no"].ToString());
                                    row.SetAttribute("vendor", di["vendor"].ToString());
                                    row.SetAttribute("item", di["item_description"].ToString());
                                    row.SetAttribute("quantity", String.Format("{0:#,0.00}", Decimal.Parse(di["quantity"].ToString())) ?? "0");
                                    row.SetAttribute("uom", di["uom"].ToString());
                                    rowDetail += row.ToString();
                                    i++;
                                }
                            }

                            template.SetAttribute("isTest", IsNotificationTestMode);
                            if (IsNotificationTestMode)
                            {
                                template.SetAttribute("TO_CC", ProcesTestModeTemplate(MainRecipients, subject, ""));
                            }
                            else
                            {
                                template.SetAttribute("TO_CC", "");
                            }

                            template.SetAttribute("details", rowDetail);

                            Antlr3.ST.StringTemplate Style = group.GetInstanceOf("Style");
                            template.SetAttribute("Style", Style);

                            Antlr3.ST.StringTemplate Footer = group.GetInstanceOf("Footer");
                            Footer.SetAttribute("mailbox", mailbox);

                            template.SetAttribute("Footer", Footer);

                            templateString = template.ToString();
                            template.Reset();

                            templateString = SendEmail(MainRecipients, templateString, subject, "");
                        }
                    }
                }
            }
            return templateString;
        }

        public static string PO_Undelivered(string dueDate)
        {
    
            string templateString = string.Empty;

            DataSet ds = NotificationData.PurchaseOrder.Undelivered(dueDate);
            DataTable goffice = ds.Tables[0];

            group.RootDir = StartupPath;
            Antlr3.ST.StringTemplate template = group.GetInstanceOf("POUndelivered");

            if (IsNotificationActive)
            {
                if (ds.Tables.Count > 0)
                {
                    if (goffice.Rows.Count > 0)
                    {
                        foreach (DataRow d in goffice.Rows)
                        {
                            var office = d["cifor_office_id"].ToString();
                            var subject = d["subject"].ToString();
                            var MainRecipients = string.Empty;
                            var rowClass = string.Empty;
                            var rowDetail = string.Empty;
                            int i = 0;
                            var mailbox = string.Empty;
                            DataTable office_mailbox = statics.GetEmailProcurementOffice(office);


                            /* main receipient */

                            //if (ds.Tables[1].Rows.Count > 0)
                            //{
                            //    DataRow[] recipient = ds.Tables[1].Select("cifor_office_id='" + office + "'", "TO asc");
                            //    foreach (DataRow dto in recipient)
                            //    {
                            //        MainRecipients += dto["TO"].ToString() + ";";
                            //    }

                            //}

                            /* main receipient  by office mail */

                            foreach (DataRow dto in office_mailbox.Rows)
                            {
                                MainRecipients += dto["Email"].ToString() + "";
                            }

                            /* mailbox */
                            //if (ds.Tables[2].Rows.Count > 0)
                            //{
                            //    DataRow[] dtDetailMailbox = ds.Tables[2].Select("cifor_office_id='" + office + "'", "mailbox");
                            //    foreach (DataRow dra in dtDetailMailbox)
                            //    {

                            //        mailbox = string.Format(@"<a href='mailto:{0}' target='_blank' rel='noopener noreferrer' 
                            //            data-auth='NotApplicable' data-safelink='true' data-linkindex='4' class='email-footer'>{0}</a>"
                            //                     , dra["mailbox"].ToString());
                            //    }
                            //}

                            /* mailbox  by office mail*/
                            foreach (DataRow dr in office_mailbox.Rows)
                            {
                                mailbox += string.Format(@"<a href='mailto:{0}' target='_blank' rel='noopener noreferrer' 
                                            data-auth='NotApplicable' data-safelink='true' data-linkindex='4' class='email-footer'>{0}</a>, "
                                                       , dr["Email"].ToString());
                            }
                            mailbox = mailbox.Remove(mailbox.Length - 2);

                            /* main */
                            if (ds.Tables[2].Rows.Count > 0)
                            {
                                DataRow[] main = ds.Tables[2].Select("cifor_office_id='" + office + "'", "id asc");

                                foreach (DataRow di in main)
                                {
                                    if (i % 2 != 0)
                                    {
                                        rowClass = "basefont";
                                    }
                                    else
                                    {
                                        rowClass = "zebra";
                                    }

                                    Antlr3.ST.StringTemplate row = group.GetInstanceOf("POUndelivered_data");
                                    row.SetAttribute("class", rowClass);
                                    row.SetAttribute("po_sun", di["po_sun_code"].ToString());
                                    row.SetAttribute("po_code", di["po_no"].ToString());
                                    row.SetAttribute("vendor", di["vendor"].ToString());
                                    row.SetAttribute("item", di["item_description"].ToString());
                                    row.SetAttribute("quantity", String.Format("{0:#,0.00}", Decimal.Parse(di["quantity"].ToString())) ?? "0");
                                    row.SetAttribute("uom", di["uom"].ToString());
                                    row.SetAttribute("delivery_date", di["delivery_date"].ToString());
                                    rowDetail += row.ToString();
                                    i++;
                                }

                            }

                            template.SetAttribute("isTest", IsNotificationTestMode);
                            if (IsNotificationTestMode)
                            {
                                template.SetAttribute("TO_CC", ProcesTestModeTemplate(MainRecipients, subject, ""));
                            }
                            else
                            {
                                template.SetAttribute("TO_CC", "");
                            }

                            template.SetAttribute("details", rowDetail);

                            Antlr3.ST.StringTemplate Style = group.GetInstanceOf("Style");
                            template.SetAttribute("Style", Style);

                            Antlr3.ST.StringTemplate Footer = group.GetInstanceOf("Footer");
                            Footer.SetAttribute("mailbox", mailbox);
                            template.SetAttribute("Footer", Footer);

                            templateString = template.ToString();
                            template.Reset();

                            templateString = SendEmail(MainRecipients, templateString, subject, "");
                        }
                    }
                }
            }
            return templateString;
        }
        #endregion Purchase Order

        #region Quotation Analysis
        public static string VS_ApprovedSS(string id)
        {
            try
            {
                string module_name = "QUOTATION ANALYSIS";
                string type = "APPROVED";

                string templateString = string.Empty;

                DataSet ds = NotificationData.QuotationAnalysis.ApprovedSS(id);

                group.RootDir = StartupPath;

                string footerContact = string.Empty;

                if (IsNotificationActive)
                {
                    if (ds.Tables.Count > 0)
                    {
                        footerContact = ds.Tables[0].Rows[0]["footer"].ToString();

                        foreach (DataRow dm in ds.Tables[0].Rows)
                        {
                            string row_id = string.Empty
                                , rowClass = string.Empty
                                , rowDetail = string.Empty
                                , subject = string.Empty
                                , recipients = string.Empty
                                , initiator = string.Empty
                                , MainRecipients = string.Empty
                                , SecondaryRecipients = string.Empty
                                , vendorName = string.Empty
                                , deliveryDate = string.Empty
                                , PRDetail = string.Empty;

                            Antlr3.ST.StringTemplate template = group.GetInstanceOf("VSApprovedSS");

                            row_id = dm["ROW_ID"].ToString();
                            subject = dm["subject"].ToString();
                            recipients = dm["requester_name"].ToString();
                            initiator = dm["initiator_name"].ToString();

                            MainRecipients = dm["initiator_email"].ToString();
                            SecondaryRecipients = ds.Tables[1].Rows[0]["CC"].ToString();

                            DataTable dCC = ds.Tables[1].Select("ROW_ID='" + row_id + "'", "CC asc").CopyToDataTable();

                            /* data */
                            //DataTable dPR = ds.Tables[2].Select("ROW_ID='" + row_id + "' ", "pr_no asc").CopyToDataTable();
                            Antlr3.ST.StringTemplate rowPR = group.GetInstanceOf("VSSSDetail");
                            string profile_page = String.Format("<a href='{0}{1}/PurchaseRequisition/detail.aspx?id={2}'>{3}</a>", home_url, app_name, dm["pr_id"].ToString(), dm["pr_no"].ToString());
                            //template.SetAttribute("pr_no", profile_page);
                            rowPR.SetAttribute("pr_no", profile_page);
                            DataTable dPR = ds.Tables[2].Select("ROW_ID='" + row_id + "' and user_id='" + dm["user_id"].ToString() + "'", "pr_no asc").CopyToDataTable();
                            foreach (DataRow dp in dPR.Rows)
                            {
                                string pr_id = string.Empty
                                    , pr_no = string.Empty
                                    , item_detail = string.Empty;

                                pr_id = dp["pr_id"].ToString();
                                pr_no = dp["pr_link"].ToString();

                                //DataTable dIt = ds.Tables[3].Select("ROW_ID='" + row_id + "' and pr_id='" + pr_id + "'", "line_number asc").CopyToDataTable();
                                DataTable dIt = ds.Tables[3].Select("ROW_ID='" + row_id + "' and pr_id='" + pr_id + "' and user_id = '" + dm["user_id"].ToString() + "'", "").CopyToDataTable();
                                int i = 0;
                                foreach (DataRow dr in dIt.Rows)
                                {
                                    if (i % 2 != 0)
                                    {
                                        rowClass = "basefont";
                                    }
                                    else
                                    {
                                        rowClass = "zebra";
                                    }

                                    Antlr3.ST.StringTemplate row = group.GetInstanceOf("VSSSData");
                                    row.SetAttribute("class", rowClass);
                                    row.SetAttribute("vs_no", dr["vs_no"].ToString());
                                    row.SetAttribute("ss_justification", dr["justification_singlesourcing"].ToString() + dr["justification_file_singlesourcing_"].ToString());
                                    item_detail += row.ToString();

                                    i++;
                                }
                                rowPR.SetAttribute("item_details", item_detail);

                                rowDetail += rowPR.ToString();
                            }
                            template.SetAttribute("details", rowDetail);

                            template.SetAttribute("isTest", IsNotificationTestMode);
                            if (IsNotificationTestMode)
                            {
                                template.SetAttribute("TO_CC", ProcesTestModeTemplate(MainRecipients, subject, SecondaryRecipients));
                            }
                            else
                            {
                                template.SetAttribute("TO_CC", "");
                            }
                            //template.SetAttribute("requester", recipients);
                            template.SetAttribute("initiator", initiator);
                            template.SetAttribute("vendor", vendorName);
                            template.SetAttribute("delivery_date", deliveryDate);
                            template.SetAttribute("footer", dm["footer"].ToString());
                            template.SetAttribute("po_no", String.Format("<a href='{0}{1}/PurchaseOrder/detail.aspx?id={2}'>{3}</a>", home_url, app_name, id, dm["vs_no"].ToString()));

                            Antlr3.ST.StringTemplate Style = group.GetInstanceOf("Style");
                            template.SetAttribute("Style", Style);

                            Antlr3.ST.StringTemplate Footer = group.GetInstanceOf("Footer");
                            Footer.SetAttribute("mailbox", dm["office_email"].ToString());
                            template.SetAttribute("Footer", Footer);


                            templateString = template.ToString();
                            template.Reset();

                            templateString = SendEmail(MainRecipients, templateString, subject, SecondaryRecipients);
                            InsertLog(id, module_name, type, templateString);
                        }
                    }
                }
                return templateString;
            }
            catch (Exception ex)
            {
                ExceptionHelpers.PrintError(ex);
                return "";
            }


        }

        public static string VS_RejectedSS(string id)
        {
            try
            {
                string module_name = "QUOTATION ANALYSIS";
                string type = "REJECTED";

                string templateString = string.Empty;

                DataSet ds = NotificationData.QuotationAnalysis.RejectedSS(id);

                group.RootDir = StartupPath;

                string footerContact = string.Empty;

                if (IsNotificationActive)
                {
                    if (ds.Tables.Count > 0)
                    {
                        footerContact = ds.Tables[0].Rows[0]["footer"].ToString();

                        foreach (DataRow dm in ds.Tables[0].Rows)
                        {
                            string row_id = string.Empty
                                , rowClass = string.Empty
                                , rowDetail = string.Empty
                                , subject = string.Empty
                                , recipients = string.Empty
                                , initiator = string.Empty
                                , MainRecipients = string.Empty
                                , SecondaryRecipients = string.Empty
                                , vendorName = string.Empty
                                , deliveryDate = string.Empty
                                , PRDetail = string.Empty;

                            Antlr3.ST.StringTemplate template = group.GetInstanceOf("VSRejectedSS");

                            row_id = dm["ROW_ID"].ToString();
                            subject = dm["subject"].ToString();
                            recipients = dm["requester_name"].ToString();
                            initiator = dm["initiator_name"].ToString();

                            MainRecipients = dm["initiator_email"].ToString();
                            SecondaryRecipients = ds.Tables[1].Rows[0]["CC"].ToString();

                            DataTable dCC = ds.Tables[1].Select("ROW_ID='" + row_id + "'", "CC asc").CopyToDataTable();

                            /* data */
                            //DataTable dPR = ds.Tables[2].Select("ROW_ID='" + row_id + "' ", "pr_no asc").CopyToDataTable();
                            Antlr3.ST.StringTemplate rowPR = group.GetInstanceOf("VSSSDetail");
                            string profile_page = String.Format("<a href='{0}{1}/PurchaseRequisition/detail.aspx?id={2}'>{3}</a>", home_url, app_name, dm["pr_id"].ToString(), dm["pr_no"].ToString());
                            //template.SetAttribute("pr_no", profile_page);
                            rowPR.SetAttribute("pr_no", profile_page);
                            DataTable dPR = ds.Tables[2].Select("ROW_ID='" + row_id + "' and user_id='" + dm["user_id"].ToString() + "'", "pr_no asc").CopyToDataTable();
                            foreach (DataRow dp in dPR.Rows)
                            {
                                string pr_id = string.Empty
                                    , pr_no = string.Empty
                                    , item_detail = string.Empty;

                                pr_id = dp["pr_id"].ToString();
                                pr_no = dp["pr_link"].ToString();

                                //DataTable dIt = ds.Tables[3].Select("ROW_ID='" + row_id + "' and pr_id='" + pr_id + "'", "line_number asc").CopyToDataTable();
                                DataTable dIt = ds.Tables[3].Select("ROW_ID='" + row_id + "' and pr_id='" + pr_id + "' and user_id = '" + dm["user_id"].ToString() + "'", "").CopyToDataTable();
                                int i = 0;
                                foreach (DataRow dr in dIt.Rows)
                                {
                                    if (i % 2 != 0)
                                    {
                                        rowClass = "basefont";
                                    }
                                    else
                                    {
                                        rowClass = "zebra";
                                    }

                                    Antlr3.ST.StringTemplate row = group.GetInstanceOf("VSSSData");
                                    row.SetAttribute("class", rowClass);
                                    row.SetAttribute("vs_no", dr["vs_no"].ToString());
                                    row.SetAttribute("ss_justification", dr["justification_singlesourcing"].ToString() + dr["justification_file_singlesourcing_"].ToString());
                                    item_detail += row.ToString();

                                    i++;
                                }
                                rowPR.SetAttribute("item_details", item_detail);

                                rowDetail += rowPR.ToString();
                            }
                            template.SetAttribute("details", rowDetail);

                            template.SetAttribute("isTest", IsNotificationTestMode);
                            if (IsNotificationTestMode)
                            {
                                template.SetAttribute("TO_CC", ProcesTestModeTemplate(MainRecipients, subject, SecondaryRecipients));
                            }
                            else
                            {
                                template.SetAttribute("TO_CC", "");
                            }
                            //template.SetAttribute("requester", recipients);
                            template.SetAttribute("initiator", initiator);
                            template.SetAttribute("vendor", vendorName);
                            template.SetAttribute("delivery_date", deliveryDate);
                            template.SetAttribute("footer", dm["footer"].ToString());
                            template.SetAttribute("po_no", String.Format("<a href='{0}{1}/PurchaseOrder/detail.aspx?id={2}'>{3}</a>", home_url, app_name, id, dm["vs_no"].ToString()));

                            Antlr3.ST.StringTemplate Style = group.GetInstanceOf("Style");
                            template.SetAttribute("Style", Style);

                            Antlr3.ST.StringTemplate Footer = group.GetInstanceOf("Footer");
                            Footer.SetAttribute("mailbox", dm["office_email"].ToString());
                            template.SetAttribute("Footer", Footer);


                            templateString = template.ToString();
                            template.Reset();

                            templateString = SendEmail(MainRecipients, templateString, subject, SecondaryRecipients);
                            InsertLog(id, module_name, type, templateString);
                        }
                    }
                }
                return templateString;
            }
            catch (Exception ex)
            {
                ExceptionHelpers.PrintError(ex);
                return "";
            }


        }

        public static string VS_CancelledSS(string id)
        {
            try
            {
                string module_name = "QUOTATION ANALYSIS";
                string type = "CANCELLED";

                string templateString = string.Empty;

                DataSet ds = NotificationData.QuotationAnalysis.CancelledSS(id);

                group.RootDir = StartupPath;

                string footerContact = string.Empty;

                if (IsNotificationActive)
                {
                    if (ds.Tables.Count > 0)
                    {
                        footerContact = ds.Tables[0].Rows[0]["footer"].ToString();

                        foreach (DataRow dm in ds.Tables[0].Rows)
                        {
                            string row_id = string.Empty
                                , rowClass = string.Empty
                                , rowDetail = string.Empty
                                , subject = string.Empty
                                , recipients = string.Empty
                                , initiator = string.Empty
                                , MainRecipients = string.Empty
                                , SecondaryRecipients = string.Empty
                                , vendorName = string.Empty
                                , deliveryDate = string.Empty
                                , PRDetail = string.Empty;

                            Antlr3.ST.StringTemplate template = group.GetInstanceOf("VSCancelledSS");

                            row_id = dm["ROW_ID"].ToString();
                            subject = dm["subject"].ToString();
                            recipients = dm["requester_name"].ToString();
                            initiator = dm["initiator_name"].ToString();

                            MainRecipients = dm["initiator_email"].ToString();
                            SecondaryRecipients = ds.Tables[1].Rows[0]["CC"].ToString();

                            DataTable dCC = ds.Tables[1].Select("ROW_ID='" + row_id + "'", "CC asc").CopyToDataTable();

                            /* data */
                            //DataTable dPR = ds.Tables[2].Select("ROW_ID='" + row_id + "' ", "pr_no asc").CopyToDataTable();
                            Antlr3.ST.StringTemplate rowPR = group.GetInstanceOf("VSSSDetail");
                            string profile_page = String.Format("<a href='{0}{1}/PurchaseRequisition/detail.aspx?id={2}'>{3}</a>", home_url, app_name, dm["pr_id"].ToString(), dm["pr_no"].ToString());
                            //template.SetAttribute("pr_no", profile_page);
                            rowPR.SetAttribute("pr_no", profile_page);
                            DataTable dPR = ds.Tables[2].Select("ROW_ID='" + row_id + "' and user_id='" + dm["user_id"].ToString() + "'", "pr_no asc").CopyToDataTable();
                            foreach (DataRow dp in dPR.Rows)
                            {
                                string pr_id = string.Empty
                                    , pr_no = string.Empty
                                    , item_detail = string.Empty;

                                pr_id = dp["pr_id"].ToString();
                                pr_no = dp["pr_link"].ToString();

                                //DataTable dIt = ds.Tables[3].Select("ROW_ID='" + row_id + "' and pr_id='" + pr_id + "'", "line_number asc").CopyToDataTable();
                                DataTable dIt = ds.Tables[3].Select("ROW_ID='" + row_id + "' and pr_id='" + pr_id + "' and user_id = '" + dm["user_id"].ToString() + "'", "").CopyToDataTable();
                                int i = 0;
                                foreach (DataRow dr in dIt.Rows)
                                {
                                    if (i % 2 != 0)
                                    {
                                        rowClass = "basefont";
                                    }
                                    else
                                    {
                                        rowClass = "zebra";
                                    }

                                    Antlr3.ST.StringTemplate row = group.GetInstanceOf("VSSSData");
                                    row.SetAttribute("class", rowClass);
                                    row.SetAttribute("vs_no", dr["vs_no"].ToString());
                                    row.SetAttribute("ss_justification", dr["justification_singlesourcing"].ToString() + dr["justification_file_singlesourcing_"].ToString());
                                    item_detail += row.ToString();

                                    i++;
                                }
                                rowPR.SetAttribute("item_details", item_detail);

                                rowDetail += rowPR.ToString();
                            }
                            template.SetAttribute("details", rowDetail);

                            template.SetAttribute("isTest", IsNotificationTestMode);
                            if (IsNotificationTestMode)
                            {
                                template.SetAttribute("TO_CC", ProcesTestModeTemplate(MainRecipients, subject, SecondaryRecipients));
                            }
                            else
                            {
                                template.SetAttribute("TO_CC", "");
                            }
                            //template.SetAttribute("requester", recipients);
                            template.SetAttribute("initiator", initiator);
                            template.SetAttribute("vendor", vendorName);
                            template.SetAttribute("delivery_date", deliveryDate);
                            template.SetAttribute("footer", dm["footer"].ToString());
                            template.SetAttribute("po_no", String.Format("<a href='{0}{1}/PurchaseOrder/detail.aspx?id={2}'>{3}</a>", home_url, app_name, id, dm["vs_no"].ToString()));

                            Antlr3.ST.StringTemplate Style = group.GetInstanceOf("Style");
                            template.SetAttribute("Style", Style);

                            Antlr3.ST.StringTemplate Footer = group.GetInstanceOf("Footer");
                            Footer.SetAttribute("mailbox", dm["office_email"].ToString());
                            template.SetAttribute("Footer", Footer);


                            templateString = template.ToString();
                            template.Reset();

                            templateString = SendEmail(MainRecipients, templateString, subject, SecondaryRecipients);
                            InsertLog(id, module_name, type, templateString);
                        }
                    }
                }
                return templateString;
            }
            catch (Exception ex)
            {
                ExceptionHelpers.PrintError(ex);
                return "";
            }


        }
        #endregion

        #region Send Email
        private static string ProcesTestModeTemplate(string MainRecipients, string Subject, string CCRecipients)
        {
            Antlr3.ST.StringTemplate template2 = group.GetInstanceOf("TestMode");
            template2.SetAttribute("emailTO", MainRecipients);
            template2.SetAttribute("emailCC", CCRecipients);
            template2.SetAttribute("teamLeader", "");
            template2.SetAttribute("dateExec", DateTime.Now.ToShortTimeString());
            template2.SetAttribute("emailSubject", Subject);

            return template2.ToString();
        }
        private static string SendEmail(string strRecipient, string strBody, string strSubject, string strCC)
        {
            return SendEmail(strRecipient, strBody, strSubject, strCC, null, null, null);
        }

        private static string SendEmail(string strRecipient, string strBody, string strSubject, string strCC, string module_name, string module_id, DataTable dtAttachment)
        {
            string mail_id = string.Empty;
            database db = new database(statics.GetSetting("dbNotification"), statics.GetSetting("dbNotificationName"), statics.GetSetting("dbNotificationUser"), statics.GetSetting("dbNotificationPassword"));
            bool isTest = true;
            isTest = bool.Parse(statics.GetSetting("NOTIFICATION_TEST_MODE"));
            string strSendEmail = "dbo.spInsertMailData";
            db.ClearParameters();

            db.SPName = strSendEmail;

            db.AddParameter("@SUBJECT", SqlDbType.VarChar, strSubject);
            db.AddParameter("@PRIORITY", SqlDbType.TinyInt, 0);
            db.AddParameter("@IS_HTML", SqlDbType.TinyInt, 1);
            db.AddParameter("@SENDER", SqlDbType.VarChar, statics.GetSetting("email_sender"));


            if (!isTest)
            {
                if (strRecipient != "")
                {
                    db.AddParameter("@RECIPIENT", SqlDbType.VarChar, strRecipient);
                }
                else
                {
                    db.AddParameter("@RECIPIENT", SqlDbType.VarChar, statics.GetSetting("email_sender"));
                }

                if (strCC != "")
                {
                    db.AddParameter("@RECIPIENT_CC", SqlDbType.VarChar, strCC);
                }
                else
                {
                    db.AddParameter("@RECIPIENT_CC", SqlDbType.VarChar, "");
                }
            }
            else
            {
                db.AddParameter("@RECIPIENT", SqlDbType.VarChar, statics.GetSetting("email_test_recipients"));
                db.AddParameter("@RECIPIENT_CC", SqlDbType.VarChar, statics.GetSetting("email_test_recipients_cc"));
            }

            db.AddParameter("@RECIPIENT_BCC", SqlDbType.VarChar, statics.GetSetting("email_test_recipients_bcc"));
            db.AddParameter("@MESSAGES", SqlDbType.NText, strBody);
            db.AddParameter("@APP_SENDER", SqlDbType.VarChar, statics.GetSetting("appsender"));
            db.AddParameter("@SEND_TIME", SqlDbType.DateTime, DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss"));

            DataSet ds = db.ExecuteSP();

            if (ds.Tables.Count > 0)
            {
                mail_id = ds.Tables[0].Rows[0][0].ToString();
            }
            db.Dispose();
            ds.Dispose();

            if (dtAttachment != null && !String.IsNullOrEmpty(module_id))
            {
                if (dtAttachment.Rows.Count > 0)
                {
                    UpdateSentStatus(Int64.Parse(mail_id), 1);
                    SendAttachment(mail_id, module_name, module_id, dtAttachment);

                    UpdateSentStatus(Int64.Parse(mail_id), 0);
                }
            }

            return mail_id;
        }

        private static void SendAttachment(string AttID, string module_name, string module_id, DataTable dtfileName)
        {
            if (AttID != "0")
            {
                string folderAttach = statics.GetSetting("MAIL_ATTACHMENT");
                string fileFolder = module_name + @"/Files/" + module_id + @"/";
                string filename = "";
                folderAttach += AttID + @"\";
                fileFolder = fileFolder.Replace(HttpContext.Current.Server.MapPath(HttpRuntime.AppDomainAppVirtualPath), "");
                var myroot = System.AppDomain.CurrentDomain.BaseDirectory;
                if (!Directory.Exists(folderAttach.ToString()))
                    Directory.CreateDirectory(folderAttach.ToString());

                if (dtfileName != null && dtfileName.Rows.Count > 0)
                {
                    foreach (DataRow dr in dtfileName.Rows)
                    {
                        filename = dr["comment_file"].ToString();
                        System.IO.File.Copy(myroot.ToString() + module_name + @"\files\" + module_id + @"\" + filename, folderAttach + filename, true);
                        if (System.IO.File.Exists(myroot.ToString() + module_name + @"\files\" + module_id + @"\" + filename))
                        {
                            database dbAttc = new database(statics.GetSetting("dbNotification"), statics.GetSetting("dbNotificationName"), statics.GetSetting("dbNotificationUser"), statics.GetSetting("dbNotificationPassword"));
                            dbAttc.ClearParameters();
                            dbAttc.SPName = "dbo.spInsertMailAttachment";
                            dbAttc.AddParameter("@MAIL_ID", SqlDbType.Int, AttID);
                            dbAttc.AddParameter("@ATTACHMENT_NAME", SqlDbType.VarChar, filename);
                            dbAttc.ExecuteSP();

                            dbAttc.Dispose();
                        }
                    }
                }
            }
        }

        private static void UpdateSentStatus(Int64 mailID, int status)
        {
            database db = new database(statics.GetSetting("dbNotification"), statics.GetSetting("dbNotificationName"), statics.GetSetting("dbNotificationUser"), statics.GetSetting("dbNotificationPassword"));
            string strSendEmail = "dbo.spUpdateSentStatus_New";
            db.ClearParameters();

            db.SPName = strSendEmail;

            db.AddParameter("@MAIL_ID", SqlDbType.BigInt, mailID);
            db.AddParameter("@SEND_STATUS", SqlDbType.TinyInt, status);

            db.ExecuteSP();
            db.Dispose();
        }
        #endregion Send Email

        #region Email log
        public static void InsertLog(string module_id, string module_name, string type, string mail_id)
        {
            database db = new database();
            db.ClearParameters();
            db.SPName = "dbo.spEmail_InsertLog";
            db.AddParameter("@module_id", SqlDbType.VarChar, module_id);
            db.AddParameter("@module_name", SqlDbType.VarChar, module_name);
            db.AddParameter("@type", SqlDbType.VarChar, type);
            db.AddParameter("@mail_id", SqlDbType.VarChar, mail_id);
            DataSet ds = db.ExecuteSP();

            db.Dispose();
        }

        public static Boolean IsSent(string module_id, string module_name, string type)
        {
            database db = new database();
            db.ClearParameters();
            db.SPName = "dbo.spEmail_CheckLog";
            db.AddParameter("@module_id", SqlDbType.VarChar, module_id);
            db.AddParameter("@module_name", SqlDbType.VarChar, module_name);
            db.AddParameter("@type", SqlDbType.VarChar, type);
            DataSet ds = db.ExecuteSP();

            db.Dispose();

            return Boolean.Parse(ds.Tables[0].Rows[0][0].ToString());
        }
        #endregion Email log
    }

}
