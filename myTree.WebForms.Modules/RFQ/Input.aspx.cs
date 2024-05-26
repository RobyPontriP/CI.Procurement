using myTree.WebForms.Procurement.General;
using myTree.WebForms.Procurement.Notification;
using Newtonsoft.Json;
using Serilog;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Security.Policy;
using System.Web;
using System.Web.Services;
using static myTree.WebForms.Procurement.Notification.NotificationData;

namespace myTree.WebForms.Modules.RFQ
{
    public partial class Input : System.Web.UI.Page
    {
        protected string _id = string.Empty, copy_id = string.Empty, vendor_categories = string.Empty, listItems = string.Empty,
            listCategories = string.Empty, listSundry = string.Empty, listLegalEntity = string.Empty, listProcurementOfficeAddress = string.Empty, listHeader = string.Empty;
        protected DataModel.RequestForQuotation RFQ = new DataModel.RequestForQuotation();
        protected string max_status = string.Empty;
        protected Boolean isAdmin = false;
        protected string service_url, based_url, cifor_office, userId = string.Empty;
        protected Boolean isSundry = false;
        protected Boolean isLead = false;
        protected string moduleName = "REQUEST FOR QUOTATION";

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
                    UserRoleAccess userRoleAccess = AccessControl.GetUserRoleAccess(AccessControlObjectEnum.ProcurementRFQ);

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
                    service_url = statics.GetSetting("service_url");
                    based_url = statics.GetSetting("based_url");

                    DataSet ds = new DataSet();

                    if (!String.IsNullOrEmpty(_id))
                    {
                        ds = staticsRFQ.Main.GetData(_id);
                    }
                    else if (!String.IsNullOrEmpty(copy_id))
                    {
                        ds = staticsRFQ.Main.GetData(copy_id);
                    }

                    if (ds.Tables.Count > 0)
                    {
                        foreach (DataRow dm in ds.Tables[0].Rows)
                        {
                            RFQ.id = dm["id"].ToString();
                            RFQ.rfq_no = dm["rfq_no"].ToString();
                            RFQ.session_no = dm["session_no"].ToString();
                            RFQ.document_date = dm["document_date"].ToString();
                            RFQ.due_date = dm["due_date"].ToString();
                            RFQ.send_date = dm["send_date"].ToString();
                            RFQ.remarks = statics.NormalizeString(dm["remarks"].ToString());
                            RFQ.method = dm["method"].ToString();
                            RFQ.template = dm["template"].ToString();
                            RFQ.vendor = dm["vendor"].ToString();
                            RFQ.vendor_code = dm["vendor_code"].ToString();
                            RFQ.vendor_name = dm["vendor_name"].ToString();
                            RFQ.status_id = dm["status_id"].ToString();
                            RFQ.status_name = dm["status_name"].ToString();
                            RFQ.vendor_address = dm["vendor_address"].ToString();
                            RFQ.vendor_contact_person = dm["vendor_contact_person"].ToString();
                            RFQ.vendor_contact_person_name = dm["vendor_contact_person_name"].ToString();
                            RFQ.vendor_contact_person_email = dm["vendor_contact_person_email"].ToString();
                            RFQ.cifor_office_id = dm["cifor_office_id"].ToString();
                            RFQ.legal_entity = dm["legal_entity"].ToString();
                            RFQ.procurement_office_address_id = dm["procurement_office_address_id"].ToString();

                            if (!String.IsNullOrEmpty(copy_id))
                            {
                                RFQ.copy_from_id = copy_id;
                                RFQ.id = "0";
                                RFQ.rfq_no = "";
                                RFQ.status_id = "5";
                                RFQ.status_name = "DRAFT";
                            }
                            else
                            {
                                RFQ.copy_from_id = dm["copy_from_id"].ToString(); ;
                            }

                            max_status = dm["max_status"].ToString();
                            if (dm["IsSundry"].ToString() == "1")
                            {
                                isSundry = true;
                            }

                        }

                        listItems = JsonConvert.SerializeObject(ds.Tables[1]);
                        listCategories = JsonConvert.SerializeObject(ds.Tables[2]);
                        listSundry = JsonConvert.SerializeObject(ds.Tables[3]);
                        listHeader = JsonConvert.SerializeObject(RFQ);

                        List<string> ct = new List<string>();
                        foreach (DataRow dc in ds.Tables[2].Rows)
                        {
                            ct.Add(dc["subcategory"].ToString());
                        }
                        vendor_categories = String.Join(";", ct.ToArray());
                    }
                    this.recentComment.moduleId = _id;
                    this.recentComment.moduleName = moduleName;

                    listLegalEntity = JsonConvert.SerializeObject(statics.GetLegalEntity());
                    listProcurementOfficeAddress = JsonConvert.SerializeObject(statics.GetProcurementOfficeAddress());
                }

            }
            catch(Exception ex)
            {
                ExceptionHelpers.PrintError(ex);
            }
        }

        [WebMethod]
        public static string Save(string submission, string deletedIds, string workflows, string detailSundry)
        {
            string result, message = "",
                _id = "", moduleName = "REQUEST FOR QUOTATION", approval_no = "0", rfq_no = "",
                status_id = string.Empty;
            int seq = 1;
            try
            {
                DataModel.Workflow workflow = JsonConvert.DeserializeObject<DataModel.Workflow>(workflows);
                DataModel.RequestForQuotation rfq = JsonConvert.DeserializeObject<DataModel.RequestForQuotation>(submission);
                List<DataModel.DeletedId> dels = JsonConvert.DeserializeObject<List<DataModel.DeletedId>>(deletedIds);
                DataModel.SundrySupplier sundry = JsonConvert.DeserializeObject < DataModel.SundrySupplier>(detailSundry);

                if (workflow.action.ToLower() == "saved")
                {
                    rfq.status_id = "5"; //DRAFT
                }
                else if (workflow.action.ToLower() == "submitted")
                {
                    rfq.status_id = "25";
                }
                else if (workflow.action.ToLower() == "updated")
                {
                    rfq.status_id = "30";
                }
                else if (workflow.action.ToLower() == "cancelled")
                {
                    rfq.status_id = "95";
                }

                staticsRFQ.Main.RFQOutput output = staticsRFQ.Main.Save(rfq);
                _id = output.id;
                rfq_no = output.rfq_no;

                List<DataModel.RequestForQuotationDetailCostCenter> listRfqCc = new List<DataModel.RequestForQuotationDetailCostCenter>();
                DataSet dsrfq = new DataSet();
                dsrfq = staticsRFQ.Detail.GetCostCenter(_id, "");
                foreach (DataRow dm in dsrfq.Tables[0].Rows)
                {
                    DataModel.RequestForQuotationDetailCostCenter rfqCc = new DataModel.RequestForQuotationDetailCostCenter();

                    rfqCc.id = dm["id"].ToString();
                    rfqCc.rfq_id = dm["rfq_id"].ToString();
                    rfqCc.rfq_detail_id = dm["rfq_detail_id"].ToString();
                    rfqCc.pr_detail_cost_center_id = dm["pr_detail_cost_center_id"].ToString();
                    rfqCc.sequence_no = dm["sequence_no"].ToString();
                    rfqCc.cost_center_id = dm["cost_center_id"].ToString();
                    rfqCc.work_order = dm["work_order"].ToString();
                    rfqCc.entity_id = dm["entity_id"].ToString();
                    rfqCc.legal_entity = dm["legal_entity"].ToString();
                    rfqCc.control_account = dm["control_account"].ToString();
                    rfqCc.percentage = dm["percentage"].ToString().Replace(',', '.');
                    rfqCc.amount = dm["amount"].ToString().Replace(',', '.');
                    rfqCc.amount_usd = dm["amount_usd"].ToString().Replace(',', '.');
                    rfqCc.remarks = dm["remarks"].ToString();

                    listRfqCc.Add(rfqCc);
                }

                foreach (DataModel.RequestForQuotationDetail d in rfq.details)
                {
                    d.rfq_id = _id;
                    d.line_number = seq.ToString();
                    string rfq_detail_id = staticsRFQ.Detail.Save(d);
                    seq++;

                    DataSet ds = new DataSet();
                    ds = staticsPurchaseRequisition.Detail.GetCostCenter(d.pr_id, d.item_code);

                    int seqNo = 1;

                    foreach (DataRow dm in ds.Tables[0].Rows)
                    {
                        bool isChange = false;
                        DataModel.RequestForQuotationDetailCostCenter rfqCc = new DataModel.RequestForQuotationDetailCostCenter();

                        if (Convert.ToDecimal(d.request_quantity.Replace('.', ',')).ToString("0.00") != dm["request_qty"].ToString())
                        {
                            isChange = true;
                        }

                        if (isChange)
                        {
                            decimal reqQty = Convert.ToDecimal(d.request_quantity);
                            decimal percentage = Convert.ToDecimal(dm["percentage"]);

                            rfqCc.amount = ((reqQty * Convert.ToDecimal(dm["unit_price"])) * (percentage / 100)).ToString("0.00").Replace(',', '.');
                            rfqCc.amount_usd = ((reqQty * Convert.ToDecimal(dm["unit_price_usd"])) * (percentage / 100)).ToString("0.00").Replace(',', '.');
                        }
                        else
                        {
                            rfqCc.amount = dm["amount"].ToString().Replace(',', '.');
                            rfqCc.amount_usd = dm["amount_usd"].ToString().Replace(',', '.');
                        }

                        rfqCc.rfq_id = _id;
                        rfqCc.rfq_detail_id = rfq_detail_id;
                        rfqCc.pr_detail_cost_center_id = dm["id"].ToString();
                        rfqCc.sequence_no = seqNo.ToString();
                        rfqCc.cost_center_id = dm["cost_center_id"].ToString();
                        rfqCc.work_order = dm["work_order"].ToString();
                        rfqCc.entity_id = dm["entity_id"].ToString();
                        rfqCc.legal_entity = dm["legal_entity"].ToString();
                        rfqCc.control_account = dm["control_account"].ToString();
                        rfqCc.percentage = dm["percentage"].ToString().Replace(',', '.');
                        rfqCc.remarks = dm["remarks"].ToString();

                        if (listRfqCc.Any(x => x.pr_detail_cost_center_id == dm["id"].ToString()))
                        {
                            foreach (var item in listRfqCc.Where(w => w.pr_detail_cost_center_id == dm["id"].ToString()))
                            {
                                item.amount = rfqCc.amount;
                                item.amount_usd = rfqCc.amount_usd;
                            }
                        }

                        if (!listRfqCc.Any(x => x.pr_detail_cost_center_id == dm["id"].ToString()))
                        {
                            listRfqCc.Add(rfqCc);
                        }

                        seqNo++;
                    }
                }

                foreach (var item in listRfqCc)
                {
                    staticsRFQ.Detail.SaveCostCenter(item);
                }

                foreach (DataModel.DeletedId d in dels)
                {
                    staticsRFQ.Detail.Delete(d.id);
                }

                #region SUNDRY SUPPLIER
                if(sundry != null)
                {
                    staticsMaster.SundrySupplier.Save(sundry);
                }
                #endregion

                /* update status */
                staticsRFQ.Main.StatusUpdate(_id, rfq.status_id);

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
                statics.LifeCycle.Save(_id, moduleName, rfq.status_id);

                if (workflow.action.ToLower() == "submitted" || workflow.action.ToLower() == "updated")
                {
                    if (rfq.method == "1")
                    {
                        NotificationHelper.RFQ_SendToVendorEmail(_id, rfq.template);
                    }
                }
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
                rfq_no = rfq_no
            });
        }
    }
}