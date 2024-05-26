using myTree.WebForms.Procurement.General;
using Newtonsoft.Json;
using Serilog;
using System;
using System.Collections.Generic;
using System.Data;

namespace myTree.WebForms.Modules.RFQ
{
    public partial class uscDetail : System.Web.UI.UserControl
    {
        public string rfq_id { get; set; }
        protected string _id = string.Empty, vendor_categories = string.Empty, listItems = string.Empty, listCategories = string.Empty, listSundry = string.Empty, listHeader = string.Empty;
        protected DataModel.RequestForQuotation RFQ = new DataModel.RequestForQuotation();
        protected string max_status = string.Empty;
        protected Boolean isEditable = false;
        protected Boolean isAdmin = false;
        protected Boolean isUser = false;
        protected Boolean isSundry = false;

        protected string moduleName = "REQUEST FOR QUOTATION";

        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                UserRoleAccess userRoleAccess = AccessControl.GetUserRoleAccess(AccessControlObjectEnum.ProcurementRFQ);

                if (!(userRoleAccess.isCanRead))
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

                _id = rfq_id;

                if (userRoleAccess.isCanWrite)
                {
                    isEditable = true;
                }

                DataSet ds = new DataSet();

                if (!String.IsNullOrEmpty(_id))
                {
                    ds = staticsRFQ.Main.GetData(_id);
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
                        RFQ.vendor_name = dm["vendor_name"].ToString();
                        RFQ.status_id = dm["status_id"].ToString();
                        RFQ.status_name = dm["status_name"].ToString();
                        RFQ.vendor_address = dm["vendor_address"].ToString();
                        RFQ.vendor_contact_person = dm["vendor_contact_person"].ToString();
                        RFQ.vendor_contact_person_name = dm["vendor_contact_person_name"].ToString();
                        RFQ.vendor_contact_person_email = dm["vendor_contact_person_email"].ToString();
                        RFQ.cifor_office_id = dm["cifor_office_id"].ToString();
                        RFQ.cifor_office = dm["cifor_office"].ToString();
                        RFQ.copy_from_id = dm["copy_from_id"].ToString();
                        RFQ.legal_entity_name = dm["legal_entity_name"].ToString();
                        RFQ.procurement_office_address = dm["procurement_office_address"].ToString();

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
            }
            catch(Exception ex)
            {
                ExceptionHelpers.PrintError(ex);
            }
        }
    }
}