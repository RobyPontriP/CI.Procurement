//using Microsoft.AspNet.Identity;
using myTree.WebForms.Procurement.General;
using myTree.WebForms.Procurement.Notification;
using Newtonsoft.Json;
using Serilog;
using System;
using System.Collections.Generic;
using System.Data;
using System.Web;
using System.Web.Services;

namespace Procurement.PurchaseOrder
{
    public partial class Detail : System.Web.UI.Page
    {
        protected string _id = string.Empty
            , max_status = string.Empty
            , blankmode = string.Empty
            , invoiceStatus = string.Empty
            , str_vat_amount = string.Empty
            , str_vat_amount_usd = string.Empty
            , gross_amount = string.Empty
            , gross_amount_usd = string.Empty
            , total_after_discount = string.Empty
            , po_status = string.Empty
            , po_status_name = string.Empty
            , ocs_po_status = string.Empty
            , ocs_po_status_id = string.Empty
            , ocs_po_status_name = string.Empty
            , listSundry = "[]"
            , listProcurementAddress = string.Empty
            , listLegalEntity = string.Empty;

        protected string PODetails = "[]"
            , dataVS = "[]"
            , supportingDocs = "[]"
            , PODetailsCC = "[]";

        protected decimal vat_amount, vat_amount_usd = 0;

        protected DataModel.PurchaseOrder PO = new DataModel.PurchaseOrder();

        protected string moduleName = "PURCHASE ORDER";

        //protected AccessControl authorized = new AccessControl("PURCHASE ORDER");
        protected UserRoleAccess userRoleAccess = AccessControl.GetUserRoleAccess(AccessControlObjectEnum.ProcurementPurchaseOrder);
        protected string service_url, based_url = string.Empty;
        protected Boolean isInWorkflow = false;
        protected Boolean isAdmin, isUser, isFinance,isCountryLead, vat_payable = false;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!HttpContext.Current.User.Identity.IsAuthenticated)
            {
                //HttpContext.Current.GetOwinContext().Authentication.Challenge();
                Log.Information("Session ended re-challenge...");
            }

            if (!userRoleAccess.isCanRead)
            {
                Response.Redirect(AccessControl.GetSetting("access_denied"));
                Log.Information("Don't have access control, redirecting...");
            }

            _id = Request.QueryString["id"] ?? "";
            isInWorkflow = statics.isInWorkflow(_id, moduleName);
            blankmode = Request.QueryString["blankmode"] ?? "";
            service_url = statics.GetSetting("service_url");
            based_url = statics.GetSetting("based_url");

            //NotificationHelper.PO_ApprovedToUser(_id);
            //NotificationHelper.PO_Approved(_id);

            isAdmin = userRoleAccess.RoleNameInSystem == AccessControlRoleNameEnum.ProcurementLead || userRoleAccess.RoleNameInSystem == AccessControlRoleNameEnum.ProcurementOfficer ? true : false;
            isUser = userRoleAccess.RoleNameInSystem == AccessControlRoleNameEnum.ProcurementAssistant ? true : false;
            isFinance = userRoleAccess.RoleNameInSystem == AccessControlRoleNameEnum.Finance ? true : false;
            isCountryLead = userRoleAccess.RoleNameInSystem == AccessControlRoleNameEnum.CountryLead ? true : false;

            DataSet ds = new DataSet();

            if (!String.IsNullOrEmpty(_id))
            {
                ds = staticsPurchaseOrder.Main.GetData(_id);
            }

            if (ds.Tables.Count > 0)
            {
                /* main data */
                foreach (DataRow dm in ds.Tables[0].Rows)
                {
                    PO.id = dm["id"].ToString();
                    PO.po_no = dm["po_no"].ToString();
                    PO.po_sun_code = dm["po_sun_code"].ToString();
                    if (string.IsNullOrEmpty(PO.po_sun_code))
                    {
                        PO.po_sun_code = "N/A";
                    }
                    PO.creator_sun_code = dm["creator_sun_code"].ToString();
                    PO.document_date = dm["document_date"].ToString();
                    if (!String.IsNullOrEmpty(PO.document_date))
                    {
                        PO.document_date = DateTime.Parse(PO.document_date).ToString("dd MMM yyyy");
                    }
                    PO.vendor = dm["vendor"].ToString();
                    PO.vendor_name = dm["vendor_name"].ToString();
                    PO.vendor_code = dm["vendor_code"].ToString();
                    PO.vendor_contact_person_name = dm["vendor_contact_person_name"].ToString();
                    PO.vendor_contact_person_to_email = dm["ToEmail"].ToString();
                    PO.remarks = dm["remarks"].ToString();
                    PO.expected_delivery_date = dm["expected_delivery_date"].ToString();
                    if (!String.IsNullOrEmpty(PO.expected_delivery_date))
                    {
                        PO.expected_delivery_date = DateTime.Parse(PO.expected_delivery_date).ToString("dd MMM yyyy");
                    }
                    PO.send_date = dm["actual_sent_date"].ToString();
                    if (!String.IsNullOrEmpty(PO.send_date))
                    {
                        PO.send_date = DateTime.Parse(PO.send_date).ToString("dd MMM yyyy");
                    }
                    PO.po_type = dm["po_type_name"].ToString();
                    PO.sun_trans_type = dm["po_prefix_name"].ToString();
                    PO.po_prefix = dm["po_prefix"].ToString();
                    PO.period = dm["account_period"].ToString();
                    PO.cifor_shipment_account = dm["cifor_shipment_name"].ToString();
                    PO.cifor_shipment_account_name = dm["cifor_shipment_account_name"].ToString();
                    PO.cifor_delivery_address = dm["cifor_delivery_address_name"].ToString();
                    PO.cifor_delivery_full_address = dm["cifor_delivery_full_address"].ToString();
                    if (string.IsNullOrEmpty(PO.cifor_delivery_full_address))
                    {
                        if (dm["is_other_address"].ToString() == "1")
                        {
                            PO.cifor_delivery_full_address = "Other";
                        }
                    }
                    PO.delivery_term_name = dm["delivery_term_name"].ToString();
                    PO.term_of_payment = dm["term_of_payment"].ToString();
                    PO.term_of_payment_name = dm["term_of_payment_name"].ToString();
                    PO.other_term_of_payment = dm["other_term_of_payment"].ToString();
                    if (string.IsNullOrEmpty(PO.term_of_payment_name))
                    {
                        if (dm["is_other_term_of_payment"].ToString() == "1")
                        {
                            PO.term_of_payment_name = "Other";
                        }
                    }
                    PO.account_code = dm["account_code"].ToString();
                    PO.currency_id = dm["currency_id"].ToString();
                    PO.exchange_sign = dm["exchange_sign"].ToString();
                    PO.exchange_rate = dm["exchange_rate"].ToString();
                    PO.gross_amount = String.Format("{0:#,0.00}", Decimal.Parse(dm["gross_amount"].ToString()));
                    PO.gross_amount_usd = String.Format("{0:#,0.00}", Decimal.Parse(dm["gross_amount_usd"].ToString()));
                    PO.discount = String.Format("{0:#,0.00}", Decimal.Parse(dm["discount"].ToString()));
                    PO.total_after_discount = String.Format("{0:#,0.00}", Decimal.Parse(dm["total_after_discount"].ToString()));
                    PO.tax = String.Format("{0:#,0.00}", Decimal.Parse(dm["tax"].ToString()));
                    PO.tax_type = dm["tax_type"].ToString();
                    PO.tax_amount = String.Format("{0:#,0.00}", Decimal.Parse(dm["tax_amount"].ToString()));
                    PO.total_amount = String.Format("{0:#,0.00}", Decimal.Parse(dm["total_amount"].ToString()));
                    PO.total_amount_usd = String.Format("{0:#,0.00}", Decimal.Parse(dm["total_amount_usd"].ToString()));
                    PO.status_id = dm["status_id"].ToString();
                    po_status = dm["status_id"].ToString();
                    PO.is_notification_sent_to_user = dm["is_notification_sent_to_user"].ToString();
                    PO.is_other_address = dm["is_other_address"].ToString();
                    PO.is_other_term_of_payment = dm["is_other_term_of_payment"].ToString();
                    PO.other_address = dm["other_address"].ToString();
                    PO.legal_entity = dm["legal_entity"].ToString();
                    PO.procurement_address = dm["procurement_address"].ToString();
                    PO.procurement_address_name = dm["procurement_address_name"].ToString();
                    PO.is_sundry_po = dm["is_sundry_po"].ToString();
                    PO.IsMyTreeSupplier = dm["IsMyTreeSupplier"].ToString();

                    if (PO.is_other_address == "0")
                    {
                        PO.other_address = "";
                    }

                    PO.status_name = dm["status_name"].ToString();
                    po_status_name = PO.status_name;
                    max_status = dm["max_status"].ToString();

                    PO.ocs_supplier_id = dm["ocs_supplier_id"].ToString();
                    PO.ocs_supplier_code = dm["ocs_supplier_code"].ToString();
                    PO.ocs_supplier_name = dm["ocs_supplier_name"].ToString();

                    ocs_po_status_id = dm["ocs_status_id"].ToString();
                    ocs_po_status_name = dm["ocs_status_name"].ToString();
                }

                foreach (DataRow dm in ds.Tables[1].Rows)
                {
                    if (Boolean.Parse(dm["vat_payable"].ToString()))
                    {
                        vat_amount += string.IsNullOrEmpty(dm["vat_amount"].ToString()) ? 0 : Decimal.Parse(dm["vat_amount"].ToString());

                        if (dm["exchange_sign"].ToString() == "*")
                        {
                            vat_amount_usd += Decimal.Parse(dm["vat_amount"].ToString()) * Decimal.Parse(dm["exchange_rate"].ToString());
                        }
                        else
                        {
                            vat_amount_usd += Decimal.Parse(dm["vat_amount"].ToString()) / Decimal.Parse(dm["exchange_rate"].ToString());
                        }
                    }

                    if (!vat_payable)
                    {
                        vat_payable = Boolean.Parse(dm["vat_payable"].ToString());
                    }

                }

                str_vat_amount = String.Format("{0:#,0.00}", vat_amount);
                str_vat_amount_usd = String.Format("{0:#,0.00}", vat_amount_usd);

                //gross_amount = String.Format("{0:#,0.00}", Decimal.Parse(PO.gross_amount) - vat_amount);
                //total_after_discount = String.Format("{0:#,0.00}", Decimal.Parse(PO.total_after_discount) - vat_amount);

                //gross_amount_usd = String.Format("{0:#,0.00}", Decimal.Parse(PO.gross_amount_usd) - vat_amount_usd);
                gross_amount = String.Format("{0:#,0.00}", Decimal.Parse(PO.gross_amount));
                total_after_discount = String.Format("{0:#,0.00}", Decimal.Parse(PO.total_after_discount));

                gross_amount_usd = String.Format("{0:#,0.00}", Decimal.Parse(PO.gross_amount_usd));

                PODetails = JsonConvert.SerializeObject(ds.Tables[1]);
                dataVS = JsonConvert.SerializeObject(ds.Tables[2]);
                PODetailsCC = JsonConvert.SerializeObject(ds.Tables[3]);
                supportingDocs = JsonConvert.SerializeObject(ds.Tables[4]);
                listSundry = JsonConvert.SerializeObject(ds.Tables[6]);

                invoiceStatus = ds.Tables[5].Rows[0][0].ToString();

                //if (ds.Tables[7].Rows.Count == 0 && ocs_po_status_id == "T")
                if (ds.Tables[8].Rows.Count > 0)
                {
                    if (ds.Tables[7].Rows.Count == 0 && ds.Tables[8].Rows[0][0].ToString() == "T")
                    {
                        ocs_po_status = OCSPurchaseOrderStatusEnum.T + ". Status mismatch, please kindly check PO status on the OCS.";
                    }
                }
            }

            listProcurementAddress = JsonConvert.SerializeObject(statics.GetProcurementOfficeAddress());
            listLegalEntity = JsonConvert.SerializeObject(statics.GetLegalEntity());

            this.historicalInformation1.moduleId = _id;
            this.historicalInformation1.moduleName = moduleName;

            this.recentComment.moduleId = _id;
            this.recentComment.moduleName = moduleName;

            this.financialReport1.po_id = _id;
            this.confirmation1.po_id = _id;

            this.confirmationForm.page_type = "send";

        }

        [WebMethod]
        public static string POCancellation(string id, string comment, string comment_file)
        {
            string result, message = "";
            try
            {
                DataModel.Comment c = new DataModel.Comment();
                c.module_name = "PURCHASE ORDER";
                c.module_id = id;
                c.action_taken = "CANCELLED";
                c.comment = comment;
                c.comment_file = comment_file;
                statics.Comment.Save(c);

                statics.LifeCycle.Save(id, "PURCHASE ORDER", "95");

                staticsPurchaseOrder.Main.StatusUpdate(id, "95");

                result = "success";
            }
            catch (Exception ex)
            {
                result = "error";
                message = ex.ToString();
                ExceptionHelpers.PrintError(ex);
            }
            return JsonConvert.SerializeObject(new
            {
                result = result,
                message = message
            });
        }

        [WebMethod]
        public static string EmailToUser(string id)
        {
            string result, message = "";
            try
            {
                //NotificationHelper.PO_ApprovedToUser(id);
                staticsPurchaseOrder.UpdateFlagEmailToUser(id);
                result = "success";
            }
            catch (Exception ex)
            {
                result = "error";
                message = ex.ToString();
                ExceptionHelpers.PrintError(ex);
            }
            return JsonConvert.SerializeObject(new
            {
                result = result,
                message = message
            });
        }

        [WebMethod]
        public static string EmailToBusinessPartner(string id)
        {
            string result, message = "";
            try
            {
                //NotificationHelper.PO_ToVendor(id);
                result = "success";
            }
            catch (Exception ex)
            {
                result = "error";
                message = ex.ToString();
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
                string module_name = "PURCHASE ORDER";
                
                DataModel.Comment c = new DataModel.Comment();
                c.module_name = module_name;
                c.module_id = id;
                c.action_taken = "UPLOAD";
                statics.Comment.Save(c);

                List<DataModel.Attachment> att = JsonConvert.DeserializeObject<List<DataModel.Attachment>>(attachment);
                foreach (DataModel.Attachment da in att) {
                    da.document_id = id;
                    da.document_type = module_name;
                    //statics.Attachment.Save(da);
                }

                List<DataModel.DeletedId> deletedIds = JsonConvert.DeserializeObject<List<DataModel.DeletedId>>(deleted);
                foreach (DataModel.DeletedId del in deletedIds)
                {
                    if (del.table == "attachment")
                    {
                        //statics.Attachment.Delete(del.id);
                    }
                }

                result = "success";
            }
            catch (Exception ex)
            {
                result = "error";
                message = ex.ToString();
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