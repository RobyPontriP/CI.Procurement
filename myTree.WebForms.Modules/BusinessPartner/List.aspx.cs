using myTree.WebForms.Procurement.General;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using Serilog;
using System;
using System.Data;
//using System.IdentityModel.Protocols.WSTrust;
using System.Linq;
using System.Runtime.InteropServices.ComTypes;
using System.Web;
using System.Web.Services;

namespace myTree.WebForms.Modules.BusinessPartner
{
    public partial class List : System.Web.UI.Page
    {
        protected string listVendor = string.Empty;
        protected string listVendorDetail = string.Empty;
        protected string vendorStatus = string.Empty;
        protected UserRoleAccess userRoleAccess = AccessControl.GetUserRoleAccess(AccessControlObjectEnum.ProcurementPurchaseRequisitionList);
        protected UserRoleAccess userRoleAccessSubmissionPR = AccessControl.GetUserRoleAccess(AccessControlObjectEnum.ProcurementPurchaseRequisition);
        protected bool isAdmin, isUser, isFinance, isOfficer, isEditAble = false;

        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                UserRoleAccess userRoleAccess = AccessControl.GetUserRoleAccess(AccessControlObjectEnum.ProcurementSupplierList);


                if (!(userRoleAccess.isCanRead))
                {
                    Response.Redirect(AccessControl.GetSetting("access_denied"));
                    Log.Information("Don't have access control, redirecting...");
                }

                if (IsPostBack)
                {
                    vendorStatus = Request.Form["_vendorStatus"];
                    Console.WriteLine("tes");
                }

                DataSet ds = staticsMaster.Vendor.GetListMytree(vendorStatus);

                listVendor = JsonConvert.SerializeObject(ds.Tables[0]);
                listVendorDetail = JsonConvert.SerializeObject(ds.Tables[1]);
            }
            catch(Exception ex)
            {
                ExceptionHelpers.PrintError(ex);
            }
        }

        [WebMethod]
        public static string Delete(string id)
        {
            string result, message = "";
            try
            {
                staticsMaster.Vendor.ValidationAttribute valid = staticsMaster.Vendor.CheckValidation(id);
                if (valid.isCanDelete)
                {
                    DataModel.Comment comment = new DataModel.Comment();
                    comment.module_name = "VENDOR";
                    comment.module_id = id;
                    comment.action_taken = "DELETED";
                    statics.Comment.Save(comment);

                    staticsMaster.Vendor.Delete(id);

                    result = "success";
                }
                else
                {
                    result = "error";
                    message = "This business partner cannot be deleted due to already used in procurement process";
                }
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

        protected void BtnExportToExcelBP_Click(object sender, EventArgs e)
        {
            
            string status = Request.Form["_vendorStatus"].ToString();
            DataSet ds = staticsMaster.Vendor.GetExportList(status);
            DataTable dtdata = ds.Tables[0];
            //DataTable dtdata = dtdatatemp.Copy();
            DataTable dtdatatemp = new DataTable();
            dtdatatemp.Clear();
            dtdatatemp.Columns.Add("company_code", typeof(String));
            dtdatatemp.Columns.Add("sun_code", typeof(String));
            dtdatatemp.Columns.Add("company_name", typeof(String));
            dtdatatemp.Columns.Add("address", typeof(String));
            dtdatatemp.Columns.Add("categories", typeof(String));
            dtdatatemp.Columns.Add("vendor_active_label", typeof(String));
            dtdatatemp.Columns.Add("contact_person", typeof(String));
            dtdatatemp.Columns.Add("position", typeof(String));
            dtdatatemp.Columns.Add("cell_phone", typeof(String));
            dtdatatemp.Columns.Add("work_phone", typeof(String));
            dtdatatemp.Columns.Add("fax", typeof(String));
            dtdatatemp.Columns.Add("email", typeof(String));

            foreach (DataRow row in dtdata.Rows) {
                var x = 0;
                JArray result = JsonConvert.DeserializeObject<JArray>(row["contacts"].ToString());
                if (result.Count > 0)
                {
                    foreach (var itemdata in result)
                    {
                        dtdatatemp.Rows.Add(row["company_code"].ToString(), row["sun_code"].ToString(), row["company_name"].ToString(), row["address"].ToString(), row["categories"].ToString(), row["vendor_active_label"].ToString(), (string)itemdata["c0"], (string)itemdata["c1"], (string)itemdata["c2"], (string)itemdata["c3"], (string)itemdata["c4"], (string)itemdata["c5"]);
                    }
                }
                else {
                    dtdatatemp.Rows.Add(row["company_code"].ToString(), row["sun_code"].ToString(), row["company_name"].ToString(), row["address"].ToString(), row["categories"].ToString(), row["vendor_active_label"].ToString(), "", "", "", "", "", "");
                }
            }

            statics.GenerateExcelFileBusinessPartnerList(dtdatatemp, "ListOfBusinessPartner", status);
        }
    }
}