using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using Newtonsoft.Json;
using System.Web.Services;
using myTree.WebForms.Procurement.General;
using Serilog;
using System.Globalization;

namespace myTree.WebForms.Modules.BusinessPartner
{
    public partial class Input : System.Web.UI.Page
    {
        protected string _id = string.Empty;

        protected DataModel.Vendor vendor;
        protected DataModel.VendorCategory category;
        protected DataModel.VendorContactPerson contact;
        protected DataModel.VendorAddress address;

        protected DataModel.Attachment attachment;

        protected UserRoleAccess userRoleAccess = AccessControl.GetUserRoleAccess(AccessControlObjectEnum.ProcurementPurchaseRequisitionList);
        protected UserRoleAccess userRoleAccessSubmissionPR = AccessControl.GetUserRoleAccess(AccessControlObjectEnum.ProcurementPurchaseRequisition);
        protected staticsMaster.Vendor.ValidationAttribute valid = new staticsMaster.Vendor.ValidationAttribute();

        protected string service_url, based_url = string.Empty;

        protected string listVendorCategory = string.Empty;
        protected string listVendorContact = string.Empty;
        protected string listVendorMainAddress = string.Empty;
        protected string listVendorPaymentAddress = string.Empty;
        protected string listVendorOrderAddress = string.Empty;

        protected string listStatus = string.Empty;
        protected string listCountry = string.Empty;
        protected string listPayment = string.Empty;
        protected string listBusinessType = string.Empty;
        protected string listQualification = string.Empty;
        protected string listTaxOption1 = string.Empty;
        protected string listTaxOption2 = string.Empty;
        protected string listCategory = string.Empty;
        protected string listOCSAddress = string.Empty;
        protected string listAddressType = string.Empty;
        protected Boolean isMyTreeSupplier = false;

        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {

                UserRoleAccess userRoleAccess = AccessControl.GetUserRoleAccess(AccessControlObjectEnum.ProcurementSupplier);


                if (!userRoleAccess.isCanWrite)
                {
                    Response.Redirect(AccessControl.GetSetting("access_denied"));
                    Log.Information("Don't have access control, redirecting...");
                }

                _id = Request.QueryString["id"] ?? "";

                valid = staticsMaster.Vendor.CheckValidation(_id);
                service_url = statics.GetSetting("service_url");
                based_url = statics.GetSetting("based_url");

                vendor = new DataModel.Vendor();
                vendor.main_address = new List<DataModel.VendorAddress>();
                vendor.payment_address = new DataModel.VendorAddress();
                vendor.order_address = new DataModel.VendorAddress();
                vendor.categories = new List<DataModel.VendorCategory>();
                vendor.contacts = new List<DataModel.VendorContactPerson>();
                var textinfo = new CultureInfo("en-US", false).TextInfo;


                if (!string.IsNullOrEmpty(_id))
                {
                    vendor.id = _id;

                    DataSet ds = staticsMaster.Vendor.GetData(_id);
                    if (ds.Tables.Count > 0)
                    {
                        DataTable dtVendor = ds.Tables[0];
                        DataTable dtVendorAddress = ds.Tables[1];
                        DataTable dtVendorContacts = ds.Tables[2];
  
                        if (dtVendor.Rows.Count > 0)
                        {
                            if (dtVendor.Rows[0]["mytree_supplier_code"].ToString() != "")
                            {
                                isMyTreeSupplier = true;
                            }

                            vendor.company_code = dtVendor.Rows[0]["company_code"].ToString();
                            vendor.sun_code = dtVendor.Rows[0]["sun_code"].ToString();
                            vendor.lookup_code = dtVendor.Rows[0]["lookup_code"].ToString();
                            vendor.sun_status = dtVendor.Rows[0]["sun_status"].ToString();
                            vendor.short_desc = statics.NormalizeString(dtVendor.Rows[0]["short_desc"].ToString());
                            vendor.company_name = statics.NormalizeString(dtVendor.Rows[0]["company_name"].ToString());
                            vendor.description = statics.NormalizeString(dtVendor.Rows[0]["description"].ToString());
                            vendor.telp_no = dtVendor.Rows[0]["telp_no"].ToString();
                            vendor.fax_no = dtVendor.Rows[0]["fax_no"].ToString();
                            vendor.email = dtVendor.Rows[0]["email"].ToString();
                            vendor.mobile_no = dtVendor.Rows[0]["mobile_no"].ToString();
                            vendor.website = dtVendor.Rows[0]["website"].ToString();
                            vendor.account_code = dtVendor.Rows[0]["account_code"].ToString();
                            vendor.payment_method = dtVendor.Rows[0]["payment_method"].ToString();
                            vendor.business_type = dtVendor.Rows[0]["business_type"].ToString();
                            vendor.qualification = dtVendor.Rows[0]["qualification"].ToString();
                            vendor.tax_opt1 = dtVendor.Rows[0]["tax_opt1"].ToString();
                            vendor.tax_opt2 = dtVendor.Rows[0]["tax_opt2"].ToString();
                            vendor.is_payment_address_same = dtVendor.Rows[0]["is_payment_address_same"].ToString();
                            vendor.is_order_address_same = dtVendor.Rows[0]["is_order_address_same"].ToString();
                            vendor.sun_status_name = dtVendor.Rows[0]["sun_status"].ToString();
                            vendor.payment_method_name = dtVendor.Rows[0]["payment_method_name"].ToString();
                            vendor.business_type_name = dtVendor.Rows[0]["business_type_name"].ToString();
                            vendor.qualification_name = dtVendor.Rows[0]["qualification_name"].ToString();
                            vendor.tax_opt1 = dtVendor.Rows[0]["tax_opt1"].ToString();
                            vendor.tax_opt2 = dtVendor.Rows[0]["tax_opt2"].ToString();
                            vendor.is_vendor_active = dtVendor.Rows[0]["is_vendor_active"].ToString();
                            vendor.remarks = statics.NormalizeString(dtVendor.Rows[0]["remarks"].ToString());
                            vendor.is_active = dtVendor.Rows[0]["is_active"].ToString();
                            vendor.ocs_supplier_code = dtVendor.Rows[0]["ocs_supplier_code"].ToString();
                            vendor.tax_system = dtVendor.Rows[0]["tax_system"].ToString();
                            vendor.tax_system_name = dtVendor.Rows[0]["tax_system_name"].ToString();
                        }


                        if (dtVendorAddress.Rows.Count > 0)
                        {


                            foreach (DataRow dr in dtVendorAddress.Rows)
                            {
                                address = new DataModel.VendorAddress();
                                address.id = dr["id"].ToString();
                                address.address_type = textinfo.ToTitleCase(dr["address_type"].ToString());
                                address.address_name = dr["address_name"].ToString();
                                address.city = dr["city"].ToString();
                                address.state = dr["state"].ToString();
                                address.postal_code = dr["postal_code"].ToString();
                                address.country_id = dr["country_id"].ToString();
                                address.url = dr["url"].ToString();
                                address.vendor_address_active_label = dr["vendor_address_active_label"].ToString();
                                vendor.main_address.Add(address);
                            }

                        }

                        foreach (DataRow dr in dtVendorContacts.Rows)
                        {
                            contact = new DataModel.VendorContactPerson();
                            contact.id = dr["id"].ToString();
                            contact.name = statics.NormalizeString(dr["name"].ToString());
                            contact.position = statics.NormalizeString(dr["position"].ToString());
                            contact.home_phone = statics.NormalizeString(dr["home_phone"].ToString());
                            contact.mobile_phone = statics.NormalizeString(dr["mobile_phone"].ToString());
                            contact.email = statics.NormalizeString(dr["email"].ToString());
                            contact.cc_email = statics.NormalizeString(dr["cc_email"].ToString());
                            contact.vendor_address_id = dr["id"].ToString();
                            contact.vendor_cp_active_label = dr["vendor_cp_active_label"].ToString();

                            vendor.contacts.Add(contact);
                        }
                    }
                }
                listVendorCategory = JsonConvert.SerializeObject(vendor.categories);
                listVendorContact = JsonConvert.SerializeObject(vendor.contacts);
                listVendorMainAddress = JsonConvert.SerializeObject(vendor.main_address);
                listVendorPaymentAddress = JsonConvert.SerializeObject(vendor.payment_address);
                listVendorOrderAddress = JsonConvert.SerializeObject(vendor.order_address);

                /* load master data */
                listAddressType = JsonConvert.SerializeObject(statics.GetAddressType());
                listStatus = JsonConvert.SerializeObject(statics.GetSUNStatus());
                listCountry = JsonConvert.SerializeObject(statics.GetCountry());
                listPayment = JsonConvert.SerializeObject(statics.GetSUNSuppPayment());
                listCategory = JsonConvert.SerializeObject(Service.GetCategory(""));
                listOCSAddress = JsonConvert.SerializeObject(Service.GetSUNAddress(""));
            }
            catch(Exception ex)
            {
                ExceptionHelpers.PrintError(ex);
            }
            
        }

        [WebMethod]
        public static string Save(string submission, string deleted)
        {
            string result, message = "", _id="";
            staticsMaster.Vendor.VendorOutput vo = new staticsMaster.Vendor.VendorOutput();
            staticsMaster.Vendor.VendorOutput voaddress = new staticsMaster.Vendor.VendorOutput();
            try
            {
                DataModel.Vendor vendor = JsonConvert.DeserializeObject<DataModel.Vendor>(submission);

                string action = "SAVED";
                if (!String.IsNullOrEmpty(vendor.id))
                {
                    action = "UPDATED";
                }


                if(vendor.sun_status == "N")
                {
                    vendor.is_vendor_active = "1";
                }
                else
                {
                    vendor.is_vendor_active = "0";
                }

                vo = staticsMaster.Vendor.Save(vendor);
                _id = vo.id;

                DataModel.Comment comment = new DataModel.Comment();
                comment.module_name = "VENDOR";
                comment.module_id = _id;
                comment.action_taken = action;
                statics.Comment.Save(comment);

                var _vo_address = string.Empty;
                foreach (DataModel.VendorAddress address in vendor.main_address)
                {
                    address.vendor_id = _id;
                    address.address1 = address.address_name;
                    address.address_type = "General";
                    voaddress =  staticsMaster.VendorAddress.Save(address);
                    _vo_address = voaddress.id;
                }

                foreach (DataModel.VendorContactPerson contact in vendor.contacts)
                {
                    contact.vendor_id = _id;
                    contact.vendor_address_id = _vo_address;
                    contact.cell_phone = contact.mobile_phone;
                    contact.work_phone = contact.home_phone;
                    staticsMaster.VendorContactPerson.Save(contact);
                }

                List<DataModel.DeletedId> deletedIds = JsonConvert.DeserializeObject<List<DataModel.DeletedId>>(deleted);
                foreach (DataModel.DeletedId _del in deletedIds) {
                    switch (_del.table.ToLower()) {
                        case "vendoraddress":
                            staticsMaster.VendorAddress.Delete(_del.id);
                            break;
                        case "vendorcategory":
                            staticsMaster.VendorCategory.Delete(_del.id);
                            break;
                        case "vendorcontactperson":
                            staticsMaster.VendorContactPerson.Delete(_del.id);
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
                message = ExceptionHelpers.Message(ex);
                ExceptionHelpers.PrintError(ex);
            }
            return JsonConvert.SerializeObject(new
            {
                result = result,
                message = message,
                id = _id,
                code = vo.code
            });
        }
    }
}