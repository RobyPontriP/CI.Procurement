using myTree.WebForms.Procurement.General;
using Newtonsoft.Json;
using Procurement.Closure;
using Serilog;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Runtime.InteropServices.ComTypes;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace myTree.WebForms.Modules.VendorSelection
{
    public partial class Input : System.Web.UI.Page
    {
        protected string _id = string.Empty, vsItems = "[]", vsItemsMain = "[]", tblExchangeRate = "[]", listSundry = "[]";
        protected string listCurrency = string.Empty, max_status = string.Empty, listAttachment = "[]", listChargeCode = "[]", cifor_office = string.Empty;
        protected DataModel.VendorSelection VS = new DataModel.VendorSelection();
        protected string service_url, based_url, user_office, userId = string.Empty;
        protected string moduleName = "VENDOR SELECTION";
        protected string startDate = string.Empty;
        protected string endDate = string.Empty;
        protected Boolean isLead = false;
        protected Boolean isExistingData = false;

        private class ItemList
        {
            public string pr_id { get; set; }
            public string pr_detail_id { get; set; }
            public string pr_no { get; set; }
            public string pr_submission_date { get; set; }
            public string cost_center_id { get; set; }
            public string initiator { get; set; }
            public string requester { get; set; }
            public string item_id { get; set; }
            public string item_code { get; set; }
            public string item_description { get; set; }
            public string pr_quantity { get; set; }
            public string vendor_ids { get; set; }
            public string currency_ids { get; set; }
            public string pr_currency { get; set; }
            public string pr_unit_price { get; set; }
            public string uom { get; set; }
            public string qd_description { get; set; }
            public string detail_chargecode { get; set; }



        }

        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                //if (!authorized.admin)
                //{
                //    Response.Redirect(authorized.redirectPage);
                //}

                if (!HttpContext.Current.User.Identity.IsAuthenticated)
                {
                    //HttpContext.Current.GetOwinContext().Authentication.Challenge();
                }
                else
                {
                    UserRoleAccess userRoleAccess = AccessControl.GetUserRoleAccess(AccessControlObjectEnum.ProcurementQuotationAnalysis);


                    if (!(userRoleAccess.isCanWrite))
                    {
                        Response.Redirect(AccessControl.GetSetting("access_denied"));
                        Log.Information("Don't have access control, redirecting...");
                    }

                    userId = statics.GetLogonUsername();
                    isLead = statics.isProcurementLead(userId, userRoleAccess);
                    user_office = Service.GetProcurementOfficeByOfficerId(userId, isLead);
                    DataTable dtOffice = statics.GetCIFOROffice(userId, isLead);
                    if (dtOffice.Rows.Count == 1)
                    {
                        user_office = user_office.Replace(";", "");
                    }


                    _id = Request.QueryString["id"] ?? "";
                    service_url = statics.GetSetting("service_url");
                    based_url = statics.GetSetting("based_url");

                    DataSet ds = new DataSet();
                    if (!String.IsNullOrEmpty(_id))
                    {
                        isExistingData = true;
                        ds = staticsVendorSelection.Main.GetData(_id);
                    }

                    if (ds.Tables.Count > 0)
                    {
                        vsItems = JsonConvert.SerializeObject(ds.Tables[1]);
                        vsItemsMain = JsonConvert.SerializeObject(ds.Tables[0]);
                        tblExchangeRate = JsonConvert.SerializeObject(ds.Tables[3]);
                        listAttachment = JsonConvert.SerializeObject(ds.Tables[4]);
                        listChargeCode = JsonConvert.SerializeObject(ds.Tables[5]);
                        listSundry = JsonConvert.SerializeObject(ds.Tables[6]);

                        foreach (DataRow dr in ds.Tables[2].Rows)
                        {
                            VS.id = _id;
                            VS.vs_no = dr["vs_no"].ToString();
                            VS.document_date = dr["document_date"].ToString();
                            if (!string.IsNullOrEmpty(VS.document_date))
                            {
                                VS.document_date = DateTime.Parse(VS.document_date).ToString("dd MMM yyyy");
                            }
                            VS.currency_id = dr["currency_id"].ToString();
                            VS.exchange_rate = dr["exchange_rate"].ToString();
                            VS.exchange_sign = dr["exchange_sign"].ToString();
                            VS.status_id = dr["status_id"].ToString();
                            VS.status_name = dr["status_name"].ToString();
                            max_status = dr["max_status"].ToString();
                            cifor_office = dr["cifor_office_id"].ToString();
                        }

                    }

                    if (string.IsNullOrEmpty(VS.document_date))
                    {
                        VS.document_date = DateTime.Now.ToString("dd MMM yyyy");
                    }

                    listCurrency = JsonConvert.SerializeObject(statics.GetCurrency());

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

                    this.recentComment.moduleId = _id;
                    this.recentComment.moduleName = moduleName;
                }
            }
            catch (Exception ex)
            {
                ExceptionHelpers.PrintError(ex);
            }
        }

        [WebMethod]
        public static string Save(string submission, string deletedIds, string workflows, string currstatus, string additionaldiscountvendor)
        {
            string result, message = "",
                _id = "", moduleName = "VENDOR SELECTION", approval_no = "0", vs_no = "", quotation_id = "",
                status_id = string.Empty;
            int seq = 1;
            int seqCC = 1;
            bool is_selection_sundry = false;


            try
            {
                DataModel.Workflow workflow = JsonConvert.DeserializeObject<DataModel.Workflow>(workflows);
                DataModel.VendorSelection q = JsonConvert.DeserializeObject<DataModel.VendorSelection>(submission);
                List<DataModel.DeletedId> dels = JsonConvert.DeserializeObject<List<DataModel.DeletedId>>(deletedIds);

                if (workflow.action.ToLower() == "saved")
                {
                    q.status_id = "5"; //DRAFT
                }
                else if (workflow.action.ToLower() == "submitted")
                {
                    q.status_id = "25";
                }
                else if (workflow.action.ToLower() == "updated")
                {
                    if (currstatus != "25" && currstatus != "50")
                    {
                        q.status_id = "30";
                    }
                }
                else if (workflow.action.ToLower() == "cancelled")
                {
                    q.status_id = "95";
                }

                staticsVendorSelection.Main.VSOutput output = staticsVendorSelection.Main.Save(q);
                _id = output.id;
                vs_no = output.vs_no;

                foreach (DataModel.VendorSelectionDetail d in q.details)
                {
                    List<DataModel.VendorSelectionDetailCostCenter> listVSCc = new List<DataModel.VendorSelectionDetailCostCenter>();
                    seqCC = 1;
                    if (d.is_selected == "1" && d.is_sundry == "1")
                    {
                        is_selection_sundry = true;
                        quotation_id = d.q_id;
                    }

                    var vendor = d.vendor;
                    d.vendor = d.vendor_code;
                    var a = d.vendor_contact_person;

                    DataTable dtVendor = statics.GetVendorFirst(d.vendor);
                    if (dtVendor.Rows.Count > 0)
                    {
                        foreach (DataRow dr in dtVendor.Rows)
                        {
                            d.vendor_code = dr["code"].ToString();
                            d.vendor_name = dr["name"].ToString();
                        }
                    }

                    d.vendor_selection = _id;
                    d.line_no = seq.ToString();
                    if (string.IsNullOrEmpty(d.additional_discount))
                    {
                        d.additional_discount = "0";
                    }

                    var _detail_id = staticsVendorSelection.Detail.Save(d);
                    seq++;

                    decimal line_total = Convert.ToDecimal(d.line_total);
                    decimal exchange_rate = Convert.ToDecimal(d.exchange_rate);

                    if (q.status_id == "25")
                    {
                        //if (d.exchange_sign == "*")
                        //{
                        //    d.line_total_usd = ((Convert.ToDecimal(d.line_total)) * exchange_rate).ToString("0.00").Replace(',', '.');
                        //}
                        //else
                        //{
                        //    d.line_total_usd = ((Convert.ToDecimal(d.line_total)) / exchange_rate).ToString("0.00").Replace(',', '.');
                        //}
                        d.line_total_usd = ((Convert.ToDecimal(d.line_total)) * exchange_rate).ToString("0.00").Replace(',', '.');
                    }                    

                    DataSet dsQCC = new DataSet();
                    dsQCC = staticsQuotation.Detail.GetCostCenter(d.q_id, "");

                    foreach (DataRow dm in dsQCC.Tables[0].Rows)
                    {
                        DataModel.VendorSelectionDetailCostCenter cc = new DataModel.VendorSelectionDetailCostCenter();
                        cc.vendor_selection_id = _id;
                        cc.vendor_selection_detail_id = _detail_id;
                        cc.pr_detail_cost_center_id = dm["pr_detail_cost_center_id"].ToString();
                        cc.quotation_detail_cost_center_id = dm["id"].ToString();
                        cc.sequence_no = seqCC.ToString();
                        cc.cost_center_id = dm["cost_center_id"].ToString();
                        cc.work_order = dm["work_order"].ToString();
                        cc.entity_id = dm["entity_id"].ToString();
                        cc.legal_entity = dm["legal_entity"].ToString();
                        cc.control_account = dm["control_account"].ToString();
                        cc.percentage = dm["percentage"].ToString();
                        cc.amount = dm["amount"].ToString();
                        cc.amount_usd = dm["amount_usd"].ToString();

                        if (!String.IsNullOrEmpty(additionaldiscountvendor))
                        {
                            if (vendor == additionaldiscountvendor)
                            {
                                decimal percentage = Convert.ToDecimal(cc.percentage);
                                decimal additional_discount = Convert.ToDecimal(d.additional_discount);

                                cc.amount = ((Convert.ToDecimal(d.line_total)) * (percentage / 100)).ToString("0.00").Replace(',', '.');
                                cc.amount_usd = ((Convert.ToDecimal(d.line_total_usd)) * (percentage / 100)).ToString("0.00").Replace(',', '.');

                                if (Convert.ToDecimal(d.line_total) > 0)
                                {
                                    cc.amount = (Convert.ToDecimal(cc.amount) - (additional_discount * (percentage / 100))).ToString("0.00").Replace(',', '.');
                                    if (d.exchange_sign == "*")
                                    {
                                        cc.amount_usd = (Convert.ToDecimal(cc.amount) * Convert.ToDecimal(d.exchange_rate)).ToString("0.00").Replace(',', '.');
                                    }
                                    else
                                    {
                                        cc.amount_usd = (Convert.ToDecimal(cc.amount) / Convert.ToDecimal(d.exchange_rate)).ToString("0.00").Replace(',', '.');
                                    }

                                }
                            }
                        }                       

                        cc.remarks = dm["remarks"].ToString();
                        cc.is_active = dm["is_active"].ToString();

                        if (d.quotation_detail_id == dm["quotation_detail_id"].ToString())
                        {
                            seqCC++;
                            listVSCc.Add(cc);
                            staticsVendorSelection.Detail.CostCenterDelete(_detail_id);
                        }
                    }

                    foreach (var item in listVSCc)
                    {
                        staticsVendorSelection.Detail.CostCenterSave(item);
                    }
                }                

                foreach (DataModel.Attachment attachment in q.attachments)
                {
                    attachment.document_id = _id;
                    attachment.document_type = moduleName;
                    statics.Attachment.Save(attachment);
                }

                #region sundry
                if (is_selection_sundry)
                {
                    // add sundry
                    if (q.sundry.Count > 0)
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

                        //copy sundry form quotation
                        DataModel.SundrySupplier qsundry = new DataModel.SundrySupplier();
                        DataSet quotation_sundry = staticsMaster.SundrySupplier.GetData(quotation_id, "QUOTATION");

                        foreach (DataRow dm in quotation_sundry.Tables[0].Rows)
                        {
                            qsundry.id = "";
                            qsundry.sundry_supplier_id = dm["sundry_supplier_id"].ToString();
                            qsundry.module_id = _id;
                            qsundry.module_type = moduleName;
                            qsundry.name = dm["name"].ToString();
                            qsundry.contact_person = dm["contact_person"].ToString();
                            qsundry.email = dm["email"].ToString();
                            qsundry.phone_number = dm["phone_number"].ToString();
                            qsundry.address = dm["address"].ToString();
                            qsundry.bank_account = dm["bank_account"].ToString();
                            qsundry.swift = dm["swift"].ToString();
                            qsundry.sort_code = dm["sort_code"].ToString();
                            qsundry.place = dm["place"].ToString();
                            qsundry.province = dm["province"].ToString();
                            qsundry.post_code = dm["post_code"].ToString();
                            qsundry.vat_reg_no = dm["vat_reg_no"].ToString();

                        }


                        DataSet dsundry = staticsMaster.SundrySupplier.GetData(_id, moduleName);
                        foreach (DataRow dm in dsundry.Tables[0].Rows)
                        {
                            if (!string.IsNullOrEmpty(dm["id"].ToString()))
                            {
                                qsundry.id = dm["id"].ToString();
                            }
                        }


                        staticsMaster.SundrySupplier.Save(qsundry);
                    }
                }
                else
                {
                    staticsMaster.SundrySupplier.Delete(_id, moduleName);
                }


                #endregion

                foreach (DataModel.DeletedId d in dels)
                {
                    switch (d.table.ToLower())
                    {
                        case "item":
                            staticsVendorSelection.Detail.Delete(d.id);
                            staticsVendorSelection.Detail.CostCenterDelete(d.id);
                            break;
                        case "attachment":
                            statics.Attachment.Delete(d.id);
                            break;
                        default:
                            break;
                    }
                }



                /* update status */
                staticsVendorSelection.Main.StatusUpdate(_id, q.status_id);

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

                if (workflow.action.ToLower() == "submitted")
                {
                    //foreach (DataModel.VendorSelectionDetail vsd in q.details)
                    //{
                    //    DataModel.ItemClosure itemClosure = new DataModel.ItemClosure();

                    //    itemClosure.reason_for_closing = "MANUAL";
                    //    itemClosure.base_type = "PURCHASE REQUISITION";
                    //    itemClosure.base_id = vsd.pr_id;
                    //    itemClosure.pr_detail_id = vsd.pr_detail_id;
                    //    itemClosure.quantity = vsd.quantity;
                    //    itemClosure.actual_amount = vsd.line_total;
                    //    itemClosure.actual_amount_usd = vsd.line_total_usd;

                    //    staticsItemClosure.SaveClosure(itemClosure);
                    //}
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
                vs_no = vs_no
            });
        }

        [WebMethod]
        public static string isQuotationValid(string quotation_detail_ids)
        {
            string result, message = "", valid = "1";
            try
            {
                valid = staticsVendorSelection.isQuotationValid(quotation_detail_ids);
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

        [WebMethod]
        public static string getSundry(string id1, string id2)
        {
            string result, message = "", moduleName = "VENDOR SELECTION", data = "";

            try
            {
                DataSet ds = new DataSet();
                if (!string.IsNullOrEmpty(id1))
                {
                    ds = staticsMaster.SundrySupplier.GetData(id1, moduleName);
                }
                else
                {
                    ds = staticsMaster.SundrySupplier.GetData(id2, "QUOTATION");
                }

                data = JsonConvert.SerializeObject(ds.Tables[0]);

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
                data = data
            });
        }
    }
}