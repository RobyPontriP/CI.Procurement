using Microsoft.Ajax.Utilities;
//using myTree.WebForms.K2Helper;
using myTree.WebForms.Modules;
using myTree.WebForms.Procurement.General;
using myTree.WebForms.Procurement.General.K2Helper.PurchaseOrder;
using myTree.WebForms.Procurement.General.K2Helper.PurchaseOrder.Models;
using Newtonsoft.Json;
using Serilog;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Services;

namespace Procurement.PurchaseOrder
{
    public partial class Input : System.Web.UI.Page
    {
        protected string _id = string.Empty
            , sn = string.Empty
            , activity_id = string.Empty
            , startDate = string.Empty
            , endDate = string.Empty
            , max_status = string.Empty
            , taskType = string.Empty
            , isfundscheck = string.Empty;

        protected string listPOType = string.Empty
            , listTransType = string.Empty
            , listShipment = string.Empty
            , listDeliveryTerm = string.Empty
            , listDelivery = string.Empty
            , listCurrency = string.Empty
            , listPeriod = string.Empty
            , listPaymentTerm = string.Empty
            , listLegalEntity = string.Empty
            , listTax = string.Empty
            , listProcurementAddress = string.Empty
            , service_url, based_url = string.Empty
            , listProduct = string.Empty
            , listSundry = "[]"
            , listProductGroup = string.Empty;

        protected string PODetails = "[]"
            , dataVS = "[]"
            , PODetailsCC = "[]"
            , POHeaders = "[]";

        protected Boolean isInWorkflow = false, isAllowed = false, isSameOffice = false;

        protected DataModel.PurchaseOrder PO = new DataModel.PurchaseOrder();
        readonly PurchaseOrderK2Helper poK2Helper = new PurchaseOrderK2Helper();

        protected string moduleName = "PURCHASE ORDER";
        protected string user_office = "";
        public string RefreshURL = string.Empty, strAccessToken = string.Empty;

        //protected AccessControl authorized = new AccessControl("PURCHASE ORDER");
        protected UserRoleAccess userRoleAccess = AccessControl.GetUserRoleAccess(AccessControlObjectEnum.ProcurementPurchaseOrder);

        protected void Page_Load(object sender, EventArgs e)
        {
            RefreshURL = ConfigurationManager.AppSettings["RefreshURL"];
            strAccessToken = AccessControl.GetAccessToken();

            if (!HttpContext.Current.User.Identity.IsAuthenticated)
            {
                //HttpContext.Current.GetOwinContext().Authentication.Challenge();
                Log.Information("Session ended re-challenge...");
            }
            else
            {
                string userId = statics.GetLogonUsername();
                _id = Request.QueryString["id"] ?? "";
                sn = Request.QueryString["sn"] ?? "";
                activity_id = Request.QueryString["activity_id"] ?? "";
                taskType = Request.QueryString["tasktype"] ?? "";
                taskType = taskType.ToLower();
                service_url = statics.GetSetting("service_url");
                based_url = statics.GetSetting("based_url");
                isfundscheck = Request.QueryString["isfundscheck"] ?? "";

                //isInWorkflow = statics.CheckRequestEditable(_id, moduleName, sn);


                bool isLead = statics.isProcurementLead(userId, userRoleAccess);
                user_office = Service.GetProcurementOfficeByOfficerId(userId, isLead);
                DataTable dtOffice = statics.GetCIFOROffice(userId, isLead);
                if (dtOffice.Rows.Count == 1)
                {
                    user_office = user_office.Replace(";", "");
                }

                if (!userRoleAccess.isCanWrite)
                {
                    Response.Redirect(AccessControl.GetSetting("access_denied"));
                    Log.Information("Don't have access control, redirecting...");
                }

                DataSet ds = new DataSet();

                if (!String.IsNullOrEmpty(_id))
                {
                    ds = staticsPurchaseOrder.Main.GetData(_id);
                }

                if (!string.IsNullOrEmpty(sn))
                {
                    isAllowed = true;// poK2Helper.isUserAllowedToAccess(_id, userId, "PurchaseOrder", "CIPROCUREMENT", sn);

                    if (user_office.Contains(ds.Tables[0].Rows[0]["cifor_office_id"].ToString()))
                    {
                        isSameOffice = true;
                    }

                    if (!isAllowed && !isSameOffice)
                    {
                        Response.Redirect(AccessControl.GetSetting("access_denied"));
                    }

                    //ApprovalNotes ApvNotes = PurchaseRequisitionK2Helper.GetPRApvNotes(Convert.ToInt32(activity_id), username, _id);
                    //approval_notes.activity_desc = ApvNotes.ApprovalNotesWording;
                    //approval_notes.activity_name = ApvNotes.Role;
                }

                if (ds.Tables.Count > 0)
                {
                    /* main data */
                    foreach (DataRow dm in ds.Tables[0].Rows)
                    {
                        PO.id = dm["id"].ToString();
                        PO.po_no = dm["po_no"].ToString();
                        PO.po_sun_code = dm["po_sun_code"].ToString();
                        PO.creator_sun_code = dm["creator_sun_code"].ToString();
                        PO.cifor_office_id = dm["cifor_office_id"].ToString();
                        PO.document_date = dm["document_date"].ToString();
                        PO.vendor = dm["vendor"].ToString();
                        PO.vendor_name = dm["vendor_name"].ToString();
                        PO.vendor_code = dm["vendor_code"].ToString();
                        PO.vendor_contact_person = dm["vendor_contact_person"].ToString();
                        PO.remarks = dm["remarks"].ToString();
                        PO.expected_delivery_date = dm["expected_delivery_date"].ToString();
                        PO.send_date = dm["actual_sent_date"].ToString();
                        PO.po_type = dm["po_type"].ToString();
                        PO.sun_trans_type = dm["sun_trans_type"].ToString();
                        PO.po_prefix = dm["po_prefix"].ToString();
                        PO.period = dm["account_period"].ToString();
                        PO.delivery_term = dm["delivery_term"].ToString();
                        PO.cifor_shipment_account = dm["cifor_shipment_account"].ToString();
                        PO.cifor_delivery_address = dm["cifor_delivery_address"].ToString();
                        PO.term_of_payment = dm["term_of_payment"].ToString();
                        PO.other_term_of_payment = dm["other_term_of_payment"].ToString();
                        PO.is_other_term_of_payment = dm["is_other_term_of_payment"].ToString();
                        PO.legal_entity = dm["legal_entity"].ToString();
                        PO.procurement_address = dm["procurement_address"].ToString();
                        PO.account_code = dm["account_code"].ToString();
                        PO.currency_id = dm["currency_id"].ToString();
                        PO.exchange_sign = dm["exchange_sign"].ToString();
                        PO.exchange_rate = dm["exchange_rate"].ToString().Replace(',', '.');
                        PO.gross_amount = dm["gross_amount"].ToString();
                        PO.discount = dm["discount"].ToString();
                        PO.tax = dm["tax"].ToString().Replace(',', '.');
                        PO.tax_type = dm["tax_type"].ToString();
                        PO.total_amount = dm["total_amount"].ToString();
                        PO.total_amount_usd = dm["total_amount_usd"].ToString();
                        PO.status_id = dm["status_id"].ToString();
                        PO.is_other_address = dm["is_other_address"].ToString();
                        PO.other_address = dm["other_address"].ToString();
                        //PO.is_sundry_po = dm["is_sundry_po"].ToString();
                        PO.IsMyTreeSupplier = dm["IsMyTreeSupplier"].ToString();
                        //PO.payable_vat = dm["payable_vat"].ToString();

                        PO.status_name = dm["status_name"].ToString();
                        max_status = dm["max_status"].ToString();

                        PO.ocs_supplier_id = dm["ocs_supplier_id"].ToString();
                        PO.ocs_supplier_code = dm["ocs_supplier_code"].ToString();
                        PO.ocs_supplier_name = dm["ocs_supplier_name"].ToString();

                        PO.detail_sundry = dm["detail_sundry"].ToString();
                        PO.is_goods = dm["is_goods"].ToString();
                    }

                    POHeaders = JsonConvert.SerializeObject(ds.Tables[0]);
                    PODetails = JsonConvert.SerializeObject(ds.Tables[1]);
                    dataVS = JsonConvert.SerializeObject(ds.Tables[2]);
                    PODetailsCC = JsonConvert.SerializeObject(ds.Tables[3]);
                    listSundry = JsonConvert.SerializeObject(ds.Tables[6]);
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

                if (String.IsNullOrEmpty(PO.document_date))
                {
                    PO.document_date = DateTime.Now.ToString("dd MMM yyyy");
                }

                listPOType = JsonConvert.SerializeObject(statics.GetPOType());
                //listTransType = JsonConvert.SerializeObject(statics.GetSUNTransType());
                listTransType = JsonConvert.SerializeObject(new DataTable());
                listShipment = JsonConvert.SerializeObject(statics.GetSUNShipment());
                listDeliveryTerm = JsonConvert.SerializeObject(statics.GetDeliveryTerm());
                //listShipment = JsonConvert.SerializeObject(new DataTable());
                listDelivery = JsonConvert.SerializeObject(statics.GetSUNDeliveryAddress());
                //listDelivery = JsonConvert.SerializeObject(new DataTable());
                listCurrency = JsonConvert.SerializeObject(statics.GetCurrency());
                listPeriod = JsonConvert.SerializeObject(statics.GetAccountingPeriod());
                listPaymentTerm = JsonConvert.SerializeObject(statics.GetPaymentTerm());
                listLegalEntity = JsonConvert.SerializeObject(statics.GetLegalEntity());
                listTax = JsonConvert.SerializeObject(statics.GetTax());
                listProcurementAddress = JsonConvert.SerializeObject(statics.GetProcurementOfficeAddress());
                listProduct = JsonConvert.SerializeObject(statics.GetProduct());
                listProductGroup = JsonConvert.SerializeObject(statics.GetProductGroup());

                this.recentComment.moduleId = _id;
                this.recentComment.moduleName = moduleName;
            }
        }

        [WebMethod]
        public static string Save(string submission, string deletedIds, string workflows)
        {
            string result, message = "",
                _id = "", moduleName = "PURCHASE ORDER", approval_no = "0", po_no = "", vs_id = "",
                status_id = string.Empty;
            int seq = 1;

            Boolean isWorkflow = false, isChange = false, isValidQA = true;
            try
            {
                DataModel.Workflow workflow = JsonConvert.DeserializeObject<DataModel.Workflow>(workflows);
                DataModel.PurchaseOrder po = JsonConvert.DeserializeObject<DataModel.PurchaseOrder>(submission);
                List<DataModel.DeletedId> dels = JsonConvert.DeserializeObject<List<DataModel.DeletedId>>(deletedIds);
                DataModel.LatestActivity latestActivity = new DataModel.LatestActivity();
                string resultValidQA = "";

                if (workflow.action.ToLower() == "submitted")
                {
                    foreach (DataModel.PurchaseOrderDetail d in po.details.DistinctBy(p => p.vs_id).ToList())
                    {
                        DataSet ds_vs = staticsVendorSelection.Main.GetData(d.vs_id);

                        if (ds_vs.Tables[0].Rows[0]["status_id"].ToString() != "25")
                        {
                            string status_label = "";

                            switch (ds_vs.Tables[0].Rows[0]["status_id"].ToString())
                            {
                                case "50":
                                    status_label = "closed";
                                    break;
                                case "95":
                                    status_label = "cancelled";
                                    break;
                                case "15":
                                    status_label = "waiting for approval";
                                    break;
                                default:
                                    break;
                            }

                            isValidQA = false;
                            resultValidQA += "<br/> - The status for Quotation analysis " + d.vs_no + " is " + status_label + ", please use other quotation analysis";
                        }
                    }

                    if (!isValidQA)
                    {
                        return JsonConvert.SerializeObject(new
                        {
                            result = "invalidQA",
                            message = resultValidQA,
                            id = _id,
                            po_no = po_no
                        });
                    }
                }                

                if (workflow.action.ToLower() == "fundscheck")
                {
                    po.status_id = "5";
                    workflow.action = "saved";
                }
                if (workflow.action.ToLower() == "saved")
                {
                    if (String.IsNullOrEmpty(workflow.sn))
                    {
                        po.status_id = "5"; //DRAFT
                    }
                }
                else if (workflow.action.ToLower() == "submitted")
                {
                    po.status_id = "15";
                    isWorkflow = true;
                    if (!String.IsNullOrEmpty(workflow.sn))
                    {
                        workflow.action = "resubmitted";
                    }
                    else
                    {
                        workflow.action = "submitted";
                    }
                }
                else if (workflow.action.ToLower() == "resubmitted for re-approval")
                {
                    isWorkflow = true;
                    po.status_id = "15";
                }
                else if (workflow.action.ToLower() == "updated")
                {
                    po.status_id = "30";
                }
                else if (workflow.action.ToLower() == "cancelled")
                {
                    if (!string.IsNullOrEmpty(workflow.sn))
                    {
                        isWorkflow = true;
                    }
                    po.status_id = "95";
                }
                status_id = po.status_id;

                //if (po.term_of_payment.ToLower() != "oth")
                //{
                //    po.other_term_of_payment = "";
                //}

                staticsPurchaseOrder.Main.POOutput output = staticsPurchaseOrder.Main.Save(po);
                _id = output.id;
                po_no = output.po_no;

                if (string.IsNullOrEmpty(po.id))
                {
                    po.id = _id;
                    po.po_no = output.po_no;
                }

                List<DataModel.PurchaseOrderDetailCostCenter> listPOCc = new List<DataModel.PurchaseOrderDetailCostCenter>();
                //DataSet ds = new DataSet();
                //ds = staticsVendorSelection.Detail.GetCostCenter(po.details[0].vs_id, "");

                foreach (DataModel.PurchaseOrderDetail d in po.details.DistinctBy(p => p.vs_detail_id).ToList())
                {
                    vs_id = d.vs_id;
                    d.purchase_order = _id;
                    d.line_number = seq.ToString();
                    d.id = staticsPurchaseOrder.Detail.Save(d);
                    seq++;


                    #region sundry supplier
                    DataModel.SundrySupplier qsundry = new DataModel.SundrySupplier();

                    if (po.is_sundry == "true")
                    {
                        DataSet POsundry = staticsMaster.SundrySupplier.GetData(_id, moduleName);
                        if (POsundry.Tables[0].Rows.Count > 0)
                        {   //populate form po

                            var dataPOsundry = POsundry.Tables[0].Select("module_detail_id='" + d.id + "'", "id asc");
                            if (dataPOsundry.Any())
                            {
                                DataTable dtid;
                                dtid = POsundry.Tables[0].Select("module_detail_id='" + d.id + "'", "id asc").CopyToDataTable();
                                foreach (DataRow dm in dtid.Rows)
                                {
                                    if (d.id == dm["module_detail_id"].ToString())
                                    {
                                        qsundry.id = dm["id"].ToString();
                                        qsundry.sundry_supplier_id = dm["sundry_supplier_id"].ToString();
                                        qsundry.module_id = _id;
                                        qsundry.module_type = moduleName;
                                        qsundry.name = dm["name"].ToString();
                                        qsundry.address = dm["address"].ToString();
                                        qsundry.bank_account = dm["bank_account"].ToString();
                                        qsundry.swift = dm["swift"].ToString();
                                        qsundry.sort_code = dm["sort_code"].ToString();
                                        qsundry.place = dm["place"].ToString();
                                        qsundry.province = dm["province"].ToString();
                                        qsundry.post_code = dm["post_code"].ToString();
                                        qsundry.vat_reg_no = dm["vat_reg_no"].ToString();
                                        qsundry.contact_person = dm["contact_person"].ToString();
                                        qsundry.email = dm["email"].ToString();
                                        qsundry.phone_number = dm["phone_number"].ToString();
                                    }
                                }

                            }
                            else
                            {
                                DataSet VSsundry = staticsMaster.SundrySupplier.GetData(vs_id, "VENDOR SELECTION");
                                if (VSsundry.Tables[0].Rows.Count > 0)
                                {
                                    //populate from vs
                                    foreach (DataRow vsdm in VSsundry.Tables[0].Rows)
                                    {
                                        qsundry.id = "";
                                        qsundry.sundry_supplier_id = vsdm["sundry_supplier_id"].ToString();
                                        qsundry.module_id = _id;
                                        qsundry.module_type = moduleName;
                                        qsundry.name = vsdm["name"].ToString();
                                        qsundry.address = vsdm["address"].ToString();
                                        qsundry.bank_account = vsdm["bank_account"].ToString();
                                        qsundry.swift = vsdm["swift"].ToString();
                                        qsundry.sort_code = vsdm["sort_code"].ToString();
                                        qsundry.place = vsdm["place"].ToString();
                                        qsundry.province = vsdm["province"].ToString();
                                        qsundry.post_code = vsdm["post_code"].ToString();
                                        qsundry.vat_reg_no = vsdm["vat_reg_no"].ToString();
                                        qsundry.module_detail_id = d.id;
                                        qsundry.contact_person = vsdm["contact_person"].ToString();
                                        qsundry.email = vsdm["email"].ToString();
                                        qsundry.phone_number = vsdm["phone_number"].ToString();

                                    }
                                }
                            }

                            staticsMaster.SundrySupplier.Save(qsundry);
                        }
                        else
                        {
                            DataSet VSsundry = staticsMaster.SundrySupplier.GetData(vs_id, "VENDOR SELECTION");
                            if (VSsundry.Tables[0].Rows.Count > 0)
                            {
                                //populate from vs
                                foreach (DataRow vsdm in VSsundry.Tables[0].Rows)
                                {
                                    qsundry.id = "";
                                    qsundry.sundry_supplier_id = vsdm["sundry_supplier_id"].ToString();
                                    qsundry.module_id = _id;
                                    qsundry.module_type = moduleName;
                                    qsundry.name = vsdm["name"].ToString();
                                    qsundry.address = vsdm["address"].ToString();
                                    qsundry.bank_account = vsdm["bank_account"].ToString();
                                    qsundry.swift = vsdm["swift"].ToString();
                                    qsundry.sort_code = vsdm["sort_code"].ToString();
                                    qsundry.place = vsdm["place"].ToString();
                                    qsundry.province = vsdm["province"].ToString();
                                    qsundry.post_code = vsdm["post_code"].ToString();
                                    qsundry.vat_reg_no = vsdm["vat_reg_no"].ToString();
                                    qsundry.contact_person = vsdm["contact_person"].ToString();
                                    qsundry.email = vsdm["email"].ToString();
                                    qsundry.phone_number = vsdm["phone_number"].ToString();
                                    qsundry.module_detail_id = d.id;

                                }

                                staticsMaster.SundrySupplier.Save(qsundry);
                            }
                        }
                    }
                    else
                    {
                        staticsMaster.SundrySupplier.Delete(_id, moduleName);
                    }
                    #endregion
                }

                string po_idtemp = "";
                string poDetailtemp = "";
                foreach (DataModel.PurchaseOrderDetail d in po.details)
                {
                    foreach (var item in po.detailsCC.OrderBy(x => x.purchase_order_detail_id).ToList().Where(x => x.vendor_selection_detail_cost_center_id == d.vs_cost_centers_detail_id))
                    {
                        item.purchase_order = string.IsNullOrEmpty(d.purchase_order) ? po_idtemp : d.purchase_order;
                        item.purchase_order_detail_id = string.IsNullOrEmpty(d.id) ? poDetailtemp : d.id;
                        item.vendor_selection_detail_id = d.vs_detail_id;

                        po_idtemp = string.IsNullOrEmpty(d.purchase_order) ? po_idtemp : d.purchase_order;
                        poDetailtemp = string.IsNullOrEmpty(d.id) ? po_idtemp : d.id;
                    }
                }

                string vs_detail_id_temp = "";
                int seqNo = 1;
                string po_id = "";
                string poDetail = "";
                foreach (var item in po.detailsCC.OrderBy(x => x.purchase_order_detail_id).ToList())
                {
                    if (string.IsNullOrEmpty(item.purchase_order) || string.IsNullOrEmpty(item.purchase_order_detail_id))
                    {
                        item.purchase_order = po_id;
                        item.purchase_order_detail_id = poDetail;
                    }
                    else
                    {
                        po_id = item.purchase_order;
                        poDetail = item.purchase_order_detail_id;
                    }

                    if (!string.IsNullOrEmpty(vs_detail_id_temp))
                    {
                        if (vs_detail_id_temp != item.purchase_order_detail_id)
                        {
                            seqNo = 1;
                        }
                    }

                    vs_detail_id_temp = item.purchase_order_detail_id;

                    item.sequence_no = seqNo.ToString();

                    staticsPurchaseOrder.Detail.SaveCostCenter(item);

                    seqNo++;

                }

                foreach (DataModel.DeletedId d in dels)
                {
                    switch (d.table.ToLower())
                    {
                        case "item":
                            staticsPurchaseOrder.Detail.Delete(d.id);
                            staticsMaster.SundrySupplier.Delete("", moduleName, d.id);
                            break;
                        default:
                            break;
                    }
                }

                /* update status */
                staticsPurchaseOrder.Main.StatusUpdate(_id, po.status_id);

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
                if (workflow.action.ToLower() == "submitted"
                    || workflow.action.ToLower() == "resubmitted"
                    || workflow.action.ToLower() == "resubmitted for re-approval"
                    || workflow.action.ToLower() == "cancelled"
                    || (workflow.action.ToLower() == "saved" && string.IsNullOrEmpty(po.id)))
                {
                    statics.LifeCycle.Save(_id, moduleName, po.status_id);
                }

                if (workflow.action.ToLower() == "fundscheck")
                {
                    statics.LifeCycle.Save(_id, "PURCHASE ORDER FUNDSCHECK", po.status_id);
                }

                // Not Needed, moved to PO Approval
                //if (workflow.action.ToLower() == "submitted")
                //{
                //    statics.SaveOCSMFLQueue("Procurement", po.id,po.po_no, "Submitted", po.remarks);
                //}

                /* workflow */
                if (isWorkflow && bool.Parse(statics.GetSetting("K2Active")))
                {
                    // Initiate K2 for PO
                    Log.Information("PO workflow.sn = " + workflow.sn + " workflow.action = " + workflow.action);
                    string k2ApiKey = statics.GetSetting("K2ApiKey");
                    string k2ApiEndPoint = statics.GetSetting("K2ApiEndpoint");
                    string k2_folder_name = statics.GetSetting("K2FolderName");
                    string k2_process_name = statics.GetSetting("K2ProcessNamePO");
                    var folio = "CIPROCUREMENT_PurchaseOrder_" + _id;
                    //K2Helpers generalK2Help = new K2Helpers();

                    //CIFOR.Lib.WorkflowIntegration.ExecuteWorkflow K2 = new CIFOR.Lib.WorkflowIntegration.ExecuteWorkflow();
                    switch (workflow.action.ToLower())
                    {
                        case "submitted":
                            if (string.IsNullOrEmpty(workflow.sn))
                            {
                                //bool isReturnToInitiator = po.is_revision.ToLower() == "1";
                                //if (!isReturnToInitiator)
                                //{
                                //    submitWf(_id, statics.GetLogonUsername());
                                //}
                                //else
                                //{
                                //    submitWf(_id, statics.GetLogonUsername(), isReturnToInitiator, workflow.IsProcOffChangedDuringResubmit);
                                //}
                                submitWf(_id, statics.GetLogonUsername());
                            }
                            else
                            {
                                resubmitWF(_id, statics.GetLogonUsername(), workflow.sn, workflow.IsProcOffChangedDuringResubmit);
                            }
                            break;
                        case "resubmitted":
                            if (!string.IsNullOrEmpty(workflow.sn))
                            {
                                resubmitWF(_id, statics.GetLogonUsername(), workflow.sn, workflow.IsProcOffChangedDuringResubmit);
                            }
                            break;
                        case "resubmitted for re-approval":
                            //K2.ResubmitForReapproval(statics.GetLogonUsername(), _id, workflow.sn, "Procurement_PurchaseOrder_" + _id);
                            break;
                        case "cancelled":
                            //generalK2Help.Stop("stop", folio, false);
                            break;
                        default:
                            break;
                    }
                }
                result = "success";
            }
            catch (Exception ex)
            {
                result = "error";
                message = ex.Message.ToString();
                ExceptionHelpers.PrintError(ex);
            }
            return JsonConvert.SerializeObject(new
            {
                result = result,
                message = message,
                id = _id,
                po_no = po_no
            });
        }


        [WebMethod]
        public static string getSundry(string id1, string id2)
        {

            string result, message = "", moduleName = "PURCHASE ORDER", data = "";

            try
            {
                DataSet ds = new DataSet();
                if (!string.IsNullOrEmpty(id1))
                {
                    ds = staticsMaster.SundrySupplier.GetData(id1, moduleName);
                }
                else
                {
                    ds = staticsMaster.SundrySupplier.GetData(id2, "VENDOR SELECTION");
                }

                data = JsonConvert.SerializeObject(ds.Tables[0]);

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
                message = message,
                data = data
            });
        }

        private static void submitWf(string poId, string userName, bool isReturnToInit = false, bool isProcOffIsChangedDuringResubmit = false)
        {
            //K2Helpers generalK2Help = new K2Helpers();
            PurchaseOrderK2Helper poK2Help = new PurchaseOrderK2Helper();
            var moduleName = statics.GetSetting("K2ProcessNamePO");
            var folderName = statics.GetSetting("K2FolderName");

            // Initiate data for K2
            var poForK2 = staticsPurchaseOrder.Main.GetDataForK2(poId);
            // Save the PO data for K2 log
            //poK2Help.SavePODataLogList(poForK2);
            if (isReturnToInit)
            {
                string[] fieldToCompare = { "PurchaseOrderAmount" };
                var isChanged = true;//poK2Help.CompareLog(poId, false, fieldToCompare, moduleName, isProcOffIsChangedDuringResubmit);
                if (isChanged)
                {
                    //Jika ada perubahan data maka set status id PR menjadi Waiting for Approval
                    staticsPurchaseOrder.Main.StatusUpdate(poId, "15");
                }
            }
            // Initiate K2 participant
            //var k2Users = PurchaseOrderK2Helper.GetPOK2User(poForK2);
            //Log.Information($"Submit Purchase Order K2 WF with data :\n{JsonConvert.SerializeObject(k2Users)}");
            //generalK2Help.Submit(folderName, moduleName, poId, k2Users, userName);

            //var userList = PurchaseOrderK2Helper.GetPOActivityUser(poForK2, "");
            //poK2Help.SaveK2ActUser(poId, userList, moduleName);
            //taK2Help.SavePRDataLogList(taForK2);

            //jika ketika submit dan data merupakan data hasil dari Return To Init maka flag is_have_revision_task diupdate menjadi 0 kembali untuk menghilangkan tasklist di Initiator
            if (isReturnToInit)
            {
                var po_no = staticsPurchaseOrder.Main.IsRevisionUpdate(poId, "0");
            }
        }

        private static void resubmitWF(string poId, string userName, string sn, bool isProcOffIsChangedDuringResubmit = false)
        {
            string k2ApiKey = statics.GetSetting("K2ApiKey");
            string k2ApiEndPoint = statics.GetSetting("K2ApiEndpoint");
            //K2Helpers generalK2Help = new K2Helpers();
            PurchaseOrderK2Helper poK2Help = new PurchaseOrderK2Helper();
            var moduleName = statics.GetSetting("K2ProcessNamePO");
            var folderName = statics.GetSetting("K2FolderName");
            var taForK2 = staticsPurchaseOrder.Main.GetDataForK2(poId);

            //poK2Help.SavePODataLogList(taForK2);
            string[] fieldToCompare = { "PurchaseOrderAmount" };
            //poK2Help.CompareLog(poId, false, fieldToCompare, moduleName, isProcOffIsChangedDuringResubmit);
            //var k2Users = PurchaseOrderK2Helper.GetPOK2User(taForK2);
            //generalK2Help.Resubmit(k2Users, userName, sn);
            //var userList = PurchaseOrderK2Helper.GetPOActivityUser(taForK2);
            //poK2Help.SaveK2ActUser(poId, userList, moduleName);

            List<int> listOfInvolvingActId = new List<int>();
            //userDict.Add("DCSUser", mapUser(2, unApproveUsers));
            //userDict.Add("DGUser", mapUser(3, unApproveUsers));
            //userDict.Add("BudgetHolderUser", mapUser(4, unApproveUsers));
            //userDict.Add("ProcurementOfficerUser", mapUser(5, unApproveUsers));
            //userDict.Add("FinanceUser", mapUser(6, unApproveUsers));
            //userDict.Add("PaymentUser", mapUser(7, unApproveUsers));
            //if (!string.IsNullOrEmpty(k2Users[EnumK2PODataField.ProcurementLeadUser].ToString()))
            //{
            //    listOfInvolvingActId.Add(EnumK2PO.ProcurementLeaderVerification); // Activity 2
            //}
            //if (!string.IsNullOrEmpty(k2Users[EnumK2PODataField.ThemeLeaderRecommendationUser].ToString()))
            //{
            //    listOfInvolvingActId.Add(EnumK2PO.CountryDirectorRecommendation); // Activity 3
            //}
            //if (!string.IsNullOrEmpty(k2Users[EnumK2PODataField.HeadOperationRecommendationUser].ToString()))
            //{
            //    listOfInvolvingActId.Add(EnumK2PO.HeadOfOperationRecommendation); // Activity 4
            //}
            //if (!string.IsNullOrEmpty(k2Users[EnumK2PODataField.FinanceLeadRecommendationUser].ToString()))
            //{
            //    listOfInvolvingActId.Add(EnumK2PO.CFORecommendation); // Activity 5
            //}
            //if (!string.IsNullOrEmpty(k2Users[EnumK2PODataField.DCSRecommendationUser].ToString()))
            //{
            //    listOfInvolvingActId.Add(EnumK2PO.DCSRecommendation); // Activity 6
            //}
            //if (!string.IsNullOrEmpty(k2Users[EnumK2PODataField.ProcurementLeaderApprovalUser].ToString()))
            //{
            //    listOfInvolvingActId.Add(EnumK2PO.ProcurementLeaderApproval); // Activity 7
            //}
            //if (!string.IsNullOrEmpty(k2Users[EnumK2PODataField.ThemeLeaderApprovalUser].ToString()))
            //{
            //    listOfInvolvingActId.Add(EnumK2PO.CountryDirectorApproval); // Activity 8
            //}
            //if (!string.IsNullOrEmpty(k2Users[EnumK2PODataField.HeadOperationApprovalUser].ToString()))
            //{
            //    listOfInvolvingActId.Add(EnumK2PO.HeadOfOperationApproval); // Activity 9
            //}
            //if (!string.IsNullOrEmpty(k2Users[EnumK2PODataField.FinanceLeadApprovalUser].ToString()))
            //{
            //    listOfInvolvingActId.Add(EnumK2PO.CFOApproval); // Activity 10
            //}
            //if (!string.IsNullOrEmpty(k2Users[EnumK2PODataField.ContinentDirectorUser].ToString()))
            //{
            //    listOfInvolvingActId.Add(EnumK2PO.ContinentDirectorApproval); // Activity 11
            //}
            //if (!string.IsNullOrEmpty(k2Users[EnumK2PODataField.DCSApprovalUser].ToString()))
            //{
            //    listOfInvolvingActId.Add(EnumK2PO.DCSApproval); // Activity 12
            //}
            //if (!string.IsNullOrEmpty(k2Users[EnumK2PODataField.DGUser].ToString()))
            //{
            //    listOfInvolvingActId.Add(EnumK2PO.DGApproval); // Activity 13
            //}

            string nextActId = listOfInvolvingActId.Where(x => x > 1).OrderBy(y => y).FirstOrDefault().ToString();
            string status_id = "15";

            if (!string.IsNullOrEmpty(status_id))
            {
                staticsPurchaseOrder.Main.StatusUpdate(poId, status_id);
            }

            //isChargeCodeChange(poId);
        }
    }
}