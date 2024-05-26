using myTree.WebForms.Procurement.General;
using Newtonsoft.Json;
using Serilog;
using System;
using System.Collections.Generic;
using System.Data;
using System.Web;
using System.Web.Services;

namespace myTree.WebForms.Modules.Quotation
{
    public partial class Detail : System.Web.UI.Page
    {

        protected string _id = string.Empty, blankmode = string.Empty
            , listDetails = "[]", listAttachments = "[]", listCurrency = string.Empty, listHeader = string.Empty
            , discountTotal = string.Empty, grandTotal = string.Empty, listSundry = "[]";
        protected string max_status = string.Empty, user_office = string.Empty;

        protected DataModel.Quotation Q = new DataModel.Quotation();

        protected string moduleName = "QUOTATION";

        protected Boolean isEditable = false;
        protected Boolean isAdmin = false;
        protected Boolean isUser = false;
        protected Boolean isSameOffice = false;
        protected string service_url, based_url = string.Empty;

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
                    string userId = statics.GetLogonUsername();
                    bool isLead = statics.isProcurementLead(userId, userRoleAccess);

                    if (!userRoleAccess.isCanRead)
                    {
                        Response.Redirect(AccessControl.GetSetting("access_denied"));
                        Log.Information("Don't have access control, redirecting...");
                    }

                    if (!(userRoleAccess.RoleNameInSystem == AccessControlRoleNameEnum.ProcurementLead) || !(userRoleAccess.RoleNameInSystem == AccessControlRoleNameEnum.ProcurementOfficer))
                    {
                        isAdmin = true;
                    }

                    if (userRoleAccess.RoleNameInSystem == AccessControlRoleNameEnum.ProcurementAssistant)
                    {
                        isUser = true;
                    }

                    _id = Request.QueryString["id"] ?? "";
                    service_url = statics.GetSetting("service_url");
                    based_url = statics.GetSetting("based_url");

                    if (userRoleAccess.isCanWrite)
                    {
                        isEditable = true;
                    }

                    blankmode = Request.QueryString["blankmode"] ?? "";

                    user_office = Service.GetProcurementOfficeByOfficerId(userId, isLead);
                    DataTable dtOffice = statics.GetCIFOROffice(userId, isLead);

                    if (dtOffice.Rows.Count == 1)
                    {
                        user_office = user_office.Replace(";", "");
                    }

                    DataSet ds = new DataSet();

                    if (!String.IsNullOrEmpty(_id))
                    {
                        ds = staticsQuotation.Main.GetData(_id);
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
                            Q.payment_terms_name = dm["payment_terms_name"].ToString();
                            //if (Q.payment_terms.ToLower() == "oth" && string.IsNullOrEmpty(Q.payment_terms_name))
                            //{
                            //    Q.payment_terms_name = "Other";
                            //}

                            Q.other_payment_terms = dm["other_payment_terms"].ToString();
                            Q.is_other_payment_terms = dm["is_other_payment_terms"].ToString();

                            if (string.IsNullOrEmpty(Q.payment_terms_name))
                            {
                                if (dm["other_payment_terms"].ToString() == "1")
                                {
                                    Q.payment_terms_name = "Other";
                                }
                            }

                            Q.remarks = dm["remarks"].ToString();
                            Q.currency_id = dm["currency_id"].ToString();
                            Q.exchange_sign = dm["exchange_sign"].ToString();
                            Q.exchange_sign_format = Q.exchange_sign == "*" ? "x" : "&divide;";
                            Q.exchange_rate = String.Format("{0:#,0.000000}", Decimal.Parse(dm["exchange_rate"].ToString()));
                            Q.discount_type = dm["discount_type"].ToString();
                            Q.discount = String.Format("{0:#,0.00}", Decimal.Parse(dm["discount"].ToString()));
                            Q.discount_currency = dm["discount_currency"].ToString();
                            Q.total_discount = String.Format("{0:#,0.00}", Decimal.Parse(dm["total_discount"].ToString()));
                            Q.quotation_amount = String.Format("{0:#,0.00}", Decimal.Parse(dm["quotation_amount"].ToString()));
                            Q.quotation_amount_usd = String.Format("{0:#,0.00}", Decimal.Parse(dm["quotation_amount_usd"].ToString()));
                            Q.rfq_id = dm["rfq_id"].ToString();
                            Q.rfq_no = dm["rfq_no"].ToString();
                            Q.reff_rfq_no = dm["reff_rfq_no"].ToString();
                            Q.status_id = dm["status_id"].ToString();

                            Q.status_name = dm["status_name"].ToString();
                            max_status = dm["max_status"].ToString();
                            discountTotal = dm["total_discount"].ToString();


                            if (user_office.Contains(dm["cifor_office_id"].ToString()))
                            {
                                isSameOffice = true;
                            }
                        }

                        listDetails = JsonConvert.SerializeObject(ds.Tables[1]);
                        listAttachments = JsonConvert.SerializeObject(ds.Tables[2]);
                        listSundry = JsonConvert.SerializeObject(ds.Tables[3]);
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

                    if (String.IsNullOrEmpty(Q.cifor_office_id))
                    {
                        Q.cifor_office_id = Service.GetRequesterOffice(statics.GetLogonUsername()); ;
                    }


                    listCurrency = JsonConvert.SerializeObject(statics.GetCurrency());
                    listHeader = JsonConvert.SerializeObject(Q);

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
        public static string QuotationCancellation(string id, string comment, string comment_file)
        {
            string result, message = "";
            try
            {
                DataModel.Comment c = new DataModel.Comment();
                c.module_name = "QUOTATION";
                c.module_id = id;
                c.action_taken = "CANCELLED";
                c.comment = comment;
                c.comment_file = comment_file;
                statics.Comment.Save(c);

                staticsQuotation.Main.StatusUpdate(id, "95");

                statics.LifeCycle.Save(id, "QUOTATION", "95");

                result = "success";
            }
            catch (Exception ex)
            {
                result = "error";
                message =ExceptionHelpers.Message(ex);
                ExceptionHelpers.PrintError(ex);
            }
            return JsonConvert.SerializeObject(new
            {
                result = result,
                message = message
            });
        }

        [WebMethod]
        public static string ItemClosing(string quo_detail)
        {
            string result, message = "";
            try
            {
                DataModel.QuotationDetail qd = JsonConvert.DeserializeObject<DataModel.QuotationDetail>(quo_detail);

                staticsQuotation.Detail.Close(qd);

                DataModel.Comment c = new DataModel.Comment();
                c.module_name = "QUOTATION";
                c.module_id = qd.quotation;
                c.action_taken = "UPDATED";
                c.comment = "";
                c.comment_file = "";
                statics.Comment.Save(c);

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
                string module_name = "QUOTATION";

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
                message =ExceptionHelpers.Message(ex);
                ExceptionHelpers.PrintError(ex);
            }
            return JsonConvert.SerializeObject(new
            {
                result = result,
                message = message
            });
        }
    }
}