using Microsoft.Ajax.Utilities;
//using Microsoft.IdentityModel.Logging;
//using myTree.WebForms.Master;
using myTree.WebForms.Procurement.General;
using Newtonsoft.Json;
using Serilog;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Windows.Media;

namespace myTree.WebForms.Modules.RFQ
{
    public partial class Wizard : System.Web.UI.Page
    {
        protected Boolean isAdmin = false;
        protected void Page_Load(object sender, EventArgs e)
        {
            try {

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


                    isAdmin = true;
                }
            }
            catch(Exception ex)
            {
                ExceptionHelpers.PrintError(ex);
            }              
        }

        [WebMethod]
        public static string GetItems(string subcategory, string cifor_office_id, string pr_line_id)
        {
            UserRoleAccess userRoleAccess = AccessControl.GetUserRoleAccess(AccessControlObjectEnum.ProcurementRFQ);
            var userId = statics.GetLogonUsername();
            Boolean isLead = statics.isProcurementLead(userId, userRoleAccess);

            if (String.IsNullOrEmpty(cifor_office_id) || cifor_office_id == "ALL")
            {
                cifor_office_id = Service.GetProcurementOfficeByOfficerId(userId, isLead);
            }

            DataTable dtOffice = statics.GetCIFOROffice(userId, isLead);
            if (dtOffice.Rows.Count == 1)
            {
                cifor_office_id = cifor_office_id.Replace(";", "");
            }

            DataSet ds = staticsRFQ.GetItem(subcategory, cifor_office_id, pr_line_id);
    
            return JsonConvert.SerializeObject(new
            {
                listCategory = JsonConvert.SerializeObject(ds.Tables[0]),
                listItem = JsonConvert.SerializeObject(ds.Tables[1]),
            });
        }

        [WebMethod]
        public static string Save(string submission)
        {
            string result, message = "", _id = "", rfq_no = ""
                    , moduleName = "REQUEST FOR QUOTATION";
            int series = 0;
            try
            {
                List<DataModel.RequestForQuotation> rfqs = JsonConvert.DeserializeObject<List<DataModel.RequestForQuotation>>(submission);
                List<DataModel.RequestForQuotationDetailCostCenter> listRfqCc = new List<DataModel.RequestForQuotationDetailCostCenter>();
                string action = "SAVED";

                if (rfqs.Count > 1)
                {
                    series++;
                }
                foreach (DataModel.RequestForQuotation rfq in rfqs)
                {
                    rfq.series = series.ToString();
                    rfq.rfq_no = rfq_no;

                    DataTable dtVendor = statics.GetVendorFirst(rfq.vendor);
                    if(dtVendor.Rows.Count > 0)
                    {
                        foreach (DataRow dr in dtVendor.Rows)
                        {
                            rfq.vendor_code = dr["code"].ToString();
                            rfq.vendor_name = dr["name"].ToString();
                        }
                    }

                    staticsRFQ.Main.RFQOutput output = staticsRFQ.Main.Save(rfq);
                    _id = output.id;
                    rfq_no = output.session_no;

                    int i = 1;
                    
                    foreach (DataModel.RequestForQuotationDetail rfqd in rfq.details)
                    {
                        rfqd.rfq_id = _id;
                        rfqd.line_number = i.ToString();
                        i++;
                        string rfqdIDTemp = staticsRFQ.Detail.Save(rfqd);

                        DataSet ds = new DataSet();
                        ds = staticsPurchaseRequisition.Detail.GetCostCenter(rfqd.pr_id, rfqd.item_code);

                        int seqNo = 1;
                        
                        foreach (DataRow dm in ds.Tables[0].Rows)
                        {
                            bool isChange = false;
                            DataModel.RequestForQuotationDetailCostCenter rfqCc = new DataModel.RequestForQuotationDetailCostCenter();

                            if (Convert.ToDecimal(rfqd.request_quantity.Replace('.', ',')).ToString("0.00") != dm["request_qty"].ToString())
                            {
                                isChange = true;
                            }

                            if (isChange)
                            {
                                decimal reqQty = Convert.ToDecimal(rfqd.request_quantity);
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
                            rfqCc.rfq_detail_id = rfqdIDTemp;
                            rfqCc.pr_detail_cost_center_id = dm["id"].ToString();
                            rfqCc.sequence_no = seqNo.ToString();
                            rfqCc.cost_center_id = dm["cost_center_id"].ToString();
                            rfqCc.work_order = dm["work_order"].ToString();
                            rfqCc.entity_id = dm["entity_id"].ToString();
                            rfqCc.legal_entity = dm["legal_entity"].ToString();
                            rfqCc.control_account = dm["control_account"].ToString();
                            rfqCc.percentage = dm["percentage"].ToString().Replace(',', '.');
                            rfqCc.remarks = dm["remarks"].ToString();

                            listRfqCc.Add(rfqCc);

                            seqNo++;
                        }
                    }

                    #region sundry
                    if (rfq.sundry.Count() > 0)
                    {
                        foreach (DataModel.SundrySupplier rfqsundry in rfq.sundry)
                        {
                            rfqsundry.module_id = _id;
                            rfqsundry.module_type = moduleName;
                            staticsMaster.SundrySupplier.Save(rfqsundry);
                        }
                    }
                    #endregion

                    DataModel.Comment comment = new DataModel.Comment();
                    comment.module_name = moduleName;
                    comment.module_id = _id;
                    comment.action_taken = action;
                    statics.Comment.Save(comment);

                    statics.LifeCycle.Save(_id, moduleName, "5");

                    series++;
                }

                foreach (var item in listRfqCc)
                {
                    staticsRFQ.Detail.SaveCostCenter(item);
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