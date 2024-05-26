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
using static myTree.WebForms.Procurement.Notification.NotificationData;

namespace myTree.WebForms.Modules.Quotation
{
    public partial class Input : System.Web.UI.Page
    {
        protected string _id = string.Empty, copy_id = string.Empty, pr_detail_id = string.Empty, exchange_sign_label = string.Empty
            , listDetails = "[]", listAttachments = "[]", listOffice = string.Empty, listHeaders = "[]"
            , listCurrency = string.Empty, listSupplierAddress = string.Empty, listPaymentTerm = string.Empty, listSundry= "[]";
        protected string startDate = string.Empty;
        protected string endDate = string.Empty;
        protected string max_status = string.Empty;
        protected string service_url, based_url, cifor_office, userId = string.Empty;

        protected Boolean isAdmin = false;
        protected Boolean isLead = false;

        protected DataModel.Quotation Q = new DataModel.Quotation();

        protected string moduleName = "QUOTATION";


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
                    UserRoleAccess userRoleAccess = AccessControl.GetUserRoleAccess(AccessControlObjectEnum.ProcurementQuotation);


                    if (!(userRoleAccess.isCanWrite))
                    {
                        Response.Redirect(AccessControl.GetSetting("access_denied"));
                        Log.Information("Don't have access control, redirecting...");
                    }

                    userId = statics.GetLogonUsername();
                    isLead = statics.isProcurementLead(userId, userRoleAccess);
                    cifor_office = Service.GetProcurementOfficeByOfficerId(userId, isLead);

                    DataTable dtOffice = statics.GetCIFOROffice(userId, isLead);
                    if (dtOffice.Rows.Count == 1)
                    {
                        cifor_office = cifor_office.Replace(";", "");
                    }

                    isAdmin = true;

                    _id = Request.QueryString["id"] ?? "";
                    copy_id = Request.QueryString["copy_id"] ?? "";
                    pr_detail_id = Request.QueryString["pr_line_id"] ?? "";
                    service_url = statics.GetSetting("service_url");
                    based_url = statics.GetSetting("based_url");

                    DataSet ds = new DataSet();

                    if (!String.IsNullOrEmpty(_id))
                    {
                        ds = staticsQuotation.Main.GetData(_id);
                    }
                    else if (!String.IsNullOrEmpty(copy_id))
                    {
                        ds = staticsQuotation.Main.GetData(copy_id);
                    }

                    if (ds.Tables.Count > 0)
                    {
                        /* main data */
                        foreach (DataRow dm in ds.Tables[0].Rows)
                        {
                            Q.id = dm["id"].ToString();
                            Q.q_no = dm["q_no"].ToString();
                            Q.cifor_office_id = dm["cifor_office_id"].ToString();
                            Q.vendor = dm["vendor"].ToString();
                            Q.vendor_name = dm["vendor_name"].ToString();
                            Q.vendor_code = dm["vendor_code"].ToString();
                            Q.vendor_document_no = dm["vendor_document_no"].ToString();
                            Q.vendor_address_id = dm["vendor_address_id"].ToString();
                            if (!String.IsNullOrEmpty(dm["receive_date"].ToString()))
                            {
                                Q.receive_date = DateTime.Parse(dm["receive_date"].ToString()).ToString("dd MMM yyyy");
                            }
                            else
                            {
                                Q.receive_date = "";
                            }
                            if (!String.IsNullOrEmpty(dm["document_date"].ToString()))
                            {
                                Q.document_date = DateTime.Parse(dm["document_date"].ToString()).ToString("dd MMM yyyy");
                            }
                            else
                            {
                                Q.document_date = "";
                            }
                            if (!String.IsNullOrEmpty(dm["due_date"].ToString()))
                            {
                                Q.due_date = DateTime.Parse(dm["due_date"].ToString()).ToString("dd MMM yyyy") ?? "";
                            }
                            else
                            {
                                Q.due_date = "";
                            }
                            Q.payment_terms = dm["payment_terms"].ToString();
                            Q.other_payment_terms = string.Format(@"{0}",dm["other_payment_terms"].ToString());
                            Q.is_other_payment_terms = dm[13].ToString();
                            Q.remarks = dm["remarks"].ToString();
                            Q.currency_id = dm["currency_id"].ToString();
                            Q.exchange_sign = dm["exchange_sign"].ToString();
                            Q.exchange_rate = dm["exchange_rate"].ToString();
                            Q.discount_type = dm["discount_type"].ToString();
                            Q.discount = dm["discount"].ToString();
                            Q.discount_currency = dm["discount_currency"].ToString();
                            Q.total_discount = dm["total_discount"].ToString();
                            Q.quotation_amount = dm["quotation_amount"].ToString();
                            Q.quotation_amount_usd = dm["quotation_amount_usd"].ToString();
                            Q.rfq_id = dm["rfq_id"].ToString();
                            Q.rfq_no = dm["rfq_no"].ToString();
                            Q.copy_from_id = dm["copy_from_id"].ToString();
                            Q.status_id = dm["status_id"].ToString();
                            Q.reff_rfq_no = dm["reff_rfq_no"].ToString();

                            Q.status_name = dm["status_name"].ToString();

                            exchange_sign_label = Q.exchange_sign == "*" ? "x" : "&divide;";

                            if (!String.IsNullOrEmpty(copy_id))
                            {
                                Q.copy_from_id = copy_id;
                                Q.id = "0";
                                Q.q_no = "";
                                Q.status_id = "5";
                                Q.status_name = "DRAFT";
                            }
                            else
                            {
                                Q.copy_from_id = dm["copy_from_id"].ToString(); ;
                            }

                            max_status = dm["max_status"].ToString();
                        }

                        if (String.IsNullOrEmpty(Q.exchange_sign))
                        {
                            exchange_sign_label = "&divide;";
                            Q.exchange_sign = "/";
                            Q.exchange_rate = "0";
                        }

                        listHeaders = JsonConvert.SerializeObject(ds.Tables[0]);
                        listDetails = JsonConvert.SerializeObject(ds.Tables[1]);
                        listAttachments = JsonConvert.SerializeObject(ds.Tables[2]);
                        listSundry = JsonConvert.SerializeObject(ds.Tables[3]);
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

                    if (Q.rfq_id == "" || Q.rfq_id == "0")
                    {
                        Q.source = "2";
                    }
                    else
                    {
                        Q.source = "1";
                    }

                    if (String.IsNullOrEmpty(Q.discount_type))
                    {
                        Q.discount_type = "$";
                    }

                    listOffice = JsonConvert.SerializeObject(statics.GetCIFOROffice());
                    listCurrency = JsonConvert.SerializeObject(statics.GetCurrency());
                    listSupplierAddress = JsonConvert.SerializeObject(statics.GetSupplierAddress());
                    listPaymentTerm = JsonConvert.SerializeObject(statics.GetPaymentTerm());

                    this.recentComment.moduleId = _id;
                    this.recentComment.moduleName = moduleName;
                }
            }
            catch(Exception ex)
            {
                ExceptionHelpers.PrintError(ex);
            }
        }

        [WebMethod]
        public static string Save(string submission, string deletedIds, string workflows)
        {
            string result, message = "",
                _id = "", moduleName = "QUOTATION", approval_no = "0", q_no = "",
                status_id = string.Empty;
            int seq = 1;
            var old_vendor = string.Empty;
            try
            {
                DataModel.Workflow workflow = JsonConvert.DeserializeObject<DataModel.Workflow>(workflows);
                DataModel.Quotation q = JsonConvert.DeserializeObject<DataModel.Quotation>(submission);
                List<DataModel.DeletedId> dels = JsonConvert.DeserializeObject<List<DataModel.DeletedId>>(deletedIds);

                if (workflow.action.ToLower() == "saved")
                {
                    q.status_id = "5"; //DRAFT
                }
                else if (workflow.action.ToLower() == "submitted")
                {
                    q.status_id = "25";
                }
                else if (workflow.action.ToLower() == "updated" && q.status_id != "50")
                {
                    q.status_id = "30";
                }
                else if (workflow.action.ToLower() == "cancelled")
                {
                    q.status_id = "95";
                }

                if (string.IsNullOrEmpty(q.vendor_address_id))
                {
                    q.vendor_address_id = "00000000-0000-0000-0000-000000000000";
                }

                //if(q.payment_terms.ToLower() != "oth")
                //{
                //    q.other_payment_terms = "";
                //}

                DataTable dtVendor = statics.GetVendorFirst(q.vendor);
                if (dtVendor.Rows.Count > 0)
                {
                    foreach (DataRow dr in dtVendor.Rows)
                    {
                        q.vendor_code = dr["code"].ToString();
                        q.vendor_name = dr["name"].ToString();
                    }
                }

                staticsQuotation.Main.QuotationOutput output = staticsQuotation.Main.Save(q);
                _id = output.id;
                q_no = output.q_no;

                List<DataModel.QuotationDetailCostCenter> listQuotationCc = new List<DataModel.QuotationDetailCostCenter>();
                DataSet dsrfq = new DataSet();
                dsrfq = staticsQuotation.Detail.GetCostCenter(_id, "");

                foreach (DataRow dm in dsrfq.Tables[0].Rows)
                {
                    DataModel.QuotationDetailCostCenter qCc = new DataModel.QuotationDetailCostCenter();

                    qCc.id = dm["id"].ToString();
                    qCc.quotation = dm["quotation"].ToString();
                    qCc.quotation_detail_id = dm["quotation_detail_id"].ToString();
                    qCc.pr_detail_cost_center_id = dm["pr_detail_cost_center_id"].ToString();
                    qCc.rfq_detail_cost_center_id = dm["rfq_detail_cost_center_id"].ToString();
                    qCc.sequence_no = dm["sequence_no"].ToString();
                    qCc.cost_center_id = dm["cost_center_id"].ToString();
                    qCc.work_order = dm["work_order"].ToString();
                    qCc.entity_id = dm["entity_id"].ToString();
                    qCc.legal_entity = dm["legal_entity"].ToString();
                    qCc.control_account = dm["control_account"].ToString();
                    qCc.percentage = dm["percentage"].ToString().Replace(',', '.');
                    qCc.amount = dm["amount"].ToString().Replace(',', '.');
                    qCc.amount_usd = dm["amount_usd"].ToString().Replace(',', '.');
                    qCc.remarks = dm["remarks"].ToString();

                    listQuotationCc.Add(qCc);
                }

                foreach (DataModel.QuotationDetail d in q.details)
                {
                    d.quotation = _id;
                    d.line_number = seq.ToString();
                    string quotation_detail_id = staticsQuotation.Detail.Save(d);
                    seq++;

                    DataSet ds = new DataSet();

                    if (q.source == "1")
                    {
                        ds = staticsRFQ.Detail.GetCostCenter(d.rfq_id, d.item_code);
                    }
                    else if(q.source == "2")
                    {
                        ds = staticsPurchaseRequisition.Detail.GetCostCenter(d.pr_id, d.item_code);
                    }                    

                    int seqNo = 1;

                    foreach (DataRow dm in ds.Tables[0].Rows)
                    {
                        bool isChange = false;
                        DataModel.QuotationDetailCostCenter quotationCc = new DataModel.QuotationDetailCostCenter();

                        decimal reqQty = Convert.ToDecimal(d.quotation_quantity);
                        decimal percentage = Convert.ToDecimal(dm["percentage"]);

                        quotationCc.amount = ((Convert.ToDecimal(d.line_total)) * (percentage / 100)).ToString("0.00").Replace(',', '.');
                        quotationCc.amount_usd = ((Convert.ToDecimal(d.line_total_usd)) * (percentage / 100)).ToString("0.00").Replace(',', '.');

                        quotationCc.quotation = _id;
                        quotationCc.quotation_detail_id = quotation_detail_id;

                        if (q.source == "1")
                        {
                            quotationCc.pr_detail_cost_center_id = dm["pr_detail_cost_center_id"].ToString();
                        }
                        else if (q.source == "2")
                        {
                            quotationCc.pr_detail_cost_center_id = dm["id"].ToString();
                        }
                        
                        quotationCc.rfq_detail_cost_center_id = dm["id"].ToString();
                        quotationCc.sequence_no = seqNo.ToString();
                        quotationCc.cost_center_id = dm["cost_center_id"].ToString();
                        quotationCc.work_order = dm["work_order"].ToString();
                        quotationCc.entity_id = dm["entity_id"].ToString();
                        quotationCc.legal_entity = dm["legal_entity"].ToString();
                        quotationCc.control_account = dm["control_account"].ToString();
                        quotationCc.percentage = dm["percentage"].ToString().Replace(',', '.');
                        quotationCc.remarks = dm["remarks"].ToString();

                        if (q.source == "1")
                        {
                            if (!listQuotationCc.Any(x => x.rfq_detail_cost_center_id == dm["id"].ToString()))
                            {
                                listQuotationCc.Add(quotationCc);
                                seqNo++;
                            }
                            
                        }
                        else if (q.source == "2")
                        {
                            if (!listQuotationCc.Any(x => x.pr_detail_cost_center_id == dm["id"].ToString()))
                            {
                                if (d.pr_detail_id == dm["pr_detail_id"].ToString())
                                {
                                    listQuotationCc.Add(quotationCc);
                                    seqNo++;
                                }                                
                            }
                        }                        
                    }
                }

                foreach (var item in listQuotationCc)
                {
                    staticsQuotation.Detail.SaveCostCenter(item);
                }

                foreach (DataModel.Attachment d in q.attachments)
                {
                    d.document_id = _id;
                    d.document_type = moduleName;
                    statics.Attachment.Save(d);
                }

                foreach (DataModel.DeletedId d in dels)
                {
                    switch (d.table.ToLower())
                    {
                        case "attachment":
                            statics.Attachment.Delete(d.id);
                            break;
                        case "item":
                            staticsQuotation.Detail.Delete(d.id);
                            break;
                        default:
                            break;
                    }
                }

                #region sundry

                if (q.sundry.Count() > 0)
                {
                    foreach (DataModel.SundrySupplier qsundry in q.sundry)
                    {
                        if (string.IsNullOrEmpty(qsundry.id))
                        {
                            DataSet dsundry = staticsMaster.SundrySupplier.GetData(_id, moduleName);

                            foreach (DataRow dm in dsundry.Tables[0].Rows)
                            {
                                if (!string.IsNullOrEmpty(dm["id"].ToString()))
                                {
                                    qsundry.id = dm["id"].ToString();
                                }
                            }
                        }

                        qsundry.module_id = _id;
                        qsundry.module_type = moduleName;
                        staticsMaster.SundrySupplier.Save(qsundry);
                    }
                }
                else
                {
                    staticsMaster.SundrySupplier.Delete(_id, moduleName);
                }
                #endregion
                /* update status */
                staticsQuotation.Main.StatusUpdate(_id, q.status_id);

                /* insert comment */
                DataModel.Comment comment = new DataModel.Comment
                {
                    module_id = _id,
                    module_name = moduleName,
                    comment = workflow.comment,
                    comment_file = workflow.comment_file,
                    action_taken = workflow.action,
                    activity_id = workflow.activity_id,
                    roles = workflow.roles
                };
                approval_no = statics.Comment.Save(comment);

                /* life cycle */
                statics.LifeCycle.Save(_id, moduleName, q.status_id);
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
                q_no = q_no
            });
        }

        [WebMethod]
        public static string isRFQValid(string rfq_id)
        {
            string result, message = "", valid = "1";
            try
            {
                valid = staticsQuotation.isRFQValid(rfq_id);
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
                valid = valid,
            });
        }
    }
}