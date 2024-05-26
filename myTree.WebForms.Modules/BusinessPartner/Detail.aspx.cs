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
    public partial class Detail : System.Web.UI.Page
    {
        protected string _id = string.Empty;
        protected string sun_code = string.Empty;

        protected DataModel.Vendor vendor;
        protected DataModel.VendorCategory category;
        protected DataModel.VendorContactPerson contact;
        protected DataModel.VendorAddress address;

        protected DataModel.Attachment attachment;

        protected string listVendorMainAddress = string.Empty;
        protected string listVendorPaymentAddress = string.Empty;
        protected string listVendorOrderAddress = string.Empty;

        protected string service_url, based_url = string.Empty;
        protected Boolean isMyTreeSupplier = false;

        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                UserRoleAccess userRoleAccess = AccessControl.GetUserRoleAccess(AccessControlObjectEnum.ProcurementSupplier);

               if (!(userRoleAccess.isCanRead))
                {
                    Response.Redirect(AccessControl.GetSetting("access_denied"));
                    Log.Information("Don't have access control, redirecting...");
                }


                if (IsPostBack)
                {
                    _id = Request.Form["id"];
                    sun_code = Request.Form["sun_code"];
                    return;
                }

                _id = Request.QueryString["id"] ?? "";
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
                        //DataTable dtVendorCategory = ds.Tables[2];
                        DataTable dtVendorContacts = ds.Tables[2];
                        //DataTable dtAttachment = ds.Tables[4];

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
                            vendor.tax_system = dtVendor.Rows[0]["tax_system"].ToString();
                            vendor.tax_system_name = dtVendor.Rows[0]["tax_system_name"].ToString();
                            vendor.account_code = dtVendor.Rows[0]["account_code"].ToString();
                            vendor.payment_method = dtVendor.Rows[0]["payment_method"].ToString();
                            vendor.business_type = dtVendor.Rows[0]["business_type"].ToString();
                            vendor.qualification = dtVendor.Rows[0]["qualification"].ToString();
                            vendor.tax_opt1 = dtVendor.Rows[0]["tax_opt1"].ToString();
                            vendor.tax_opt2 = dtVendor.Rows[0]["tax_opt2"].ToString();
                            vendor.is_payment_address_same = dtVendor.Rows[0]["is_payment_address_same"].ToString();
                            vendor.is_order_address_same = dtVendor.Rows[0]["is_order_address_same"].ToString();
                            vendor.sun_status_name = dtVendor.Rows[0]["sun_status_name"].ToString();
                            vendor.payment_method_name = dtVendor.Rows[0]["payment_method_name"].ToString();
                            vendor.business_type_name = dtVendor.Rows[0]["business_type_name"].ToString();
                            vendor.qualification_name = dtVendor.Rows[0]["qualification_name"].ToString();
                            vendor.tax_opt1 = dtVendor.Rows[0]["tax_opt1"].ToString();
                            vendor.tax_opt2 = dtVendor.Rows[0]["tax_opt2"].ToString();
                            vendor.is_vendor_active = dtVendor.Rows[0]["is_vendor_active"].ToString();

                            vendor.remarks = statics.NormalizeString(dtVendor.Rows[0]["remarks"].ToString());
                            vendor.is_active = dtVendor.Rows[0]["is_active"].ToString();
                            vendor.ocs_supplier_code = dtVendor.Rows[0]["ocs_supplier_code"].ToString();

                        }

                        //DataRow[] dtMainAddr = dtVendorAddress.Select("address_type='mainaddress'");
                        //if (dtMainAddr.Length > 0) {
                        //    vendor.main_address.id = dtMainAddr[0]["id"].ToString();
                        //    vendor.main_address.address_type = "mainaddress";
                        //    vendor.main_address.sun_address_code = dtMainAddr[0]["address_name"].ToString();
                        //    vendor.main_address.address1 = dtMainAddr[0]["address1"].ToString();
                        //    vendor.main_address.address2 = dtMainAddr[0]["address2"].ToString();
                        //    vendor.main_address.address3 = dtMainAddr[0]["address3"].ToString();
                        //    vendor.main_address.address4 = dtMainAddr[0]["address4"].ToString();
                        //    vendor.main_address.address5 = dtMainAddr[0]["address5"].ToString();
                        //    vendor.main_address.city = dtMainAddr[0]["city"].ToString();
                        //    vendor.main_address.state = dtMainAddr[0]["state"].ToString();
                        //    vendor.main_address.postal_code = dtMainAddr[0]["postal_code"].ToString();
                        //    vendor.main_address.country_id = dtMainAddr[0]["country_id"].ToString();
                        //    vendor.main_address.country_name = dtMainAddr[0]["country_name"].ToString();
                        //    vendor.main_address.is_active = dtMainAddr[0]["is_active"].ToString();
                        //    vendor.main_address.is_on_sun = dtMainAddr[0]["is_on_sun"].ToString();
                        //}

                        //if (vendor.is_payment_address_same != "1") {
                        //    DataRow[] dtPaymentAddr = dtVendorAddress.Select("address_type='paymentaddress'");
                        //    if (dtPaymentAddr.Length > 0)
                        //    {
                        //        vendor.payment_address.id = dtPaymentAddr[0]["id"].ToString();
                        //        vendor.payment_address.address_type = "paymentaddress";
                        //        vendor.payment_address.sun_address_code = dtPaymentAddr[0]["address_name"].ToString();
                        //        vendor.payment_address.address1 = dtPaymentAddr[0]["address1"].ToString();
                        //        vendor.payment_address.address2 = dtPaymentAddr[0]["address2"].ToString();
                        //        vendor.payment_address.address3 = dtPaymentAddr[0]["address3"].ToString();
                        //        vendor.payment_address.address4 = dtPaymentAddr[0]["address4"].ToString();
                        //        vendor.payment_address.address5 = dtPaymentAddr[0]["address5"].ToString();
                        //        vendor.payment_address.city = dtPaymentAddr[0]["city"].ToString();
                        //        vendor.payment_address.state = dtPaymentAddr[0]["state"].ToString();
                        //        vendor.payment_address.postal_code = dtPaymentAddr[0]["postal_code"].ToString();
                        //        vendor.payment_address.country_id = dtPaymentAddr[0]["country_id"].ToString();
                        //        vendor.payment_address.country_name = dtPaymentAddr[0]["country_name"].ToString();
                        //        vendor.payment_address.is_active = dtPaymentAddr[0]["is_active"].ToString();
                        //        vendor.payment_address.is_on_sun = dtPaymentAddr[0]["is_on_sun"].ToString();
                        //    }
                        //}

                        //if (vendor.is_order_address_same != "1")
                        //{
                        //    DataRow[] dtOrderAddr = dtVendorAddress.Select("address_type='orderaddress'");
                        //    if (dtOrderAddr.Length > 0)
                        //    {
                        //        vendor.order_address.id = dtOrderAddr[0]["id"].ToString();
                        //        vendor.order_address.address_type = "orderaddress";
                        //        vendor.order_address.sun_address_code = dtOrderAddr[0]["address_name"].ToString();
                        //        vendor.order_address.address1 = dtOrderAddr[0]["address1"].ToString();
                        //        vendor.order_address.address2 = dtOrderAddr[0]["address2"].ToString();
                        //        vendor.order_address.address3 = dtOrderAddr[0]["address3"].ToString();
                        //        vendor.order_address.address4 = dtOrderAddr[0]["address4"].ToString();
                        //        vendor.order_address.address5 = dtOrderAddr[0]["address5"].ToString();
                        //        vendor.order_address.city = dtOrderAddr[0]["city"].ToString();
                        //        vendor.order_address.state = dtOrderAddr[0]["state"].ToString();
                        //        vendor.order_address.postal_code = dtOrderAddr[0]["postal_code"].ToString();
                        //        vendor.order_address.country_id = dtOrderAddr[0]["country_id"].ToString();
                        //        vendor.order_address.country_name = dtOrderAddr[0]["country_name"].ToString();
                        //        vendor.order_address.is_active = dtOrderAddr[0]["is_active"].ToString();
                        //        vendor.order_address.is_on_sun = dtOrderAddr[0]["is_on_sun"].ToString();
                        //    }
                        //}

                        //foreach (DataRow dr in dtVendorCategory.Rows)
                        //{
                        //    category = new DataModel.VendorCategory();
                        //    category.id = dr["id"].ToString();
                        //    category.category = dr["category"].ToString();
                        //    category.subcategory = dr["subcategory"].ToString();
                        //    category.category_name = dr["category_name"].ToString();
                        //    category.subcategory_name = dr["subcategory_name"].ToString();
                        //    category.is_active = dr["is_active"].ToString();

                        //    vendor.categories.Add(category);
                        //}


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
                                address.country_name = dr["country_name"].ToString();
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
                            contact.vendor_cp_active_label = dr["vendor_cp_active_label"].ToString();
                            contact.vendor_address_id = dr["id"].ToString();

                            vendor.contacts.Add(contact);
                        }

                        //foreach (DataRow dr in dtAttachment.Rows)
                        //{
                        //    attachment = new DataModel.Attachment();
                        //    attachment.id = dr["id"].ToString();
                        //    attachment.filename = dr["filename"].ToString();
                        //    attachment.file_description = dr["file_description"].ToString();
                        //    attachment.document_id = _id;
                        //    attachment.document_type = "ITEM";
                        //    attachment.is_active = dr["is_active"].ToString();

                        //    vendor.attachments.Add(attachment);
                        //}
                    }
                }
                listVendorMainAddress = JsonConvert.SerializeObject(vendor.main_address);
                listVendorPaymentAddress = JsonConvert.SerializeObject(vendor.payment_address);
                listVendorOrderAddress = JsonConvert.SerializeObject(vendor.order_address);
            }
            catch(Exception ex)
            {
                ExceptionHelpers.PrintError(ex);
            }
        }

        protected void btnExportExcel_Click(object sender, EventArgs e)
        {
            if (_id != "")
            {
                DataSet ds = staticsMaster.Vendor.Export(_id);

                List<string> Titles = new List<string>(new string[] { "", ""});
                List<string> Sheets = new List<string>(new string[] { "General information", "Address information" });

                statics.GenerateExcelFile(ds, "SUN_Export_BusinessPartner_" + sun_code, Titles, Sheets, "xlsx");
            }
        }

        public void ExportTableData(DataSet dsData)
        {
            DataTable dtExcel = new DataTable();
        }
        }
}