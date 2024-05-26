using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using static myTree.WebForms.Procurement.General.staticsMaster.Vendor;

namespace myTree.WebForms.Procurement.General
{
    public class staticsMaster
    {
        public class Category
        {
            public class ValidationAttribute
            {
                public Boolean isCanEdit { get; set; }
                public Boolean isCanDelete { get; set; }
            }

            public static DataTable GetList()
            {
                database db = new database();
                db.ClearParameters();

                db.SPName = "dbo.spCategory_GetList";

                DataSet ds = db.ExecuteSP();
                db.Dispose();

                return ds.Tables[0];
            }

            public static DataSet GetData(string id)
            {
                database db = new database();
                db.ClearParameters();

                db.SPName = "dbo.spCategory_GetData";
                db.AddParameter("@id", SqlDbType.NVarChar, id);

                DataSet ds = db.ExecuteSP();
                db.Dispose();

                return ds;
            }

            public static string Save(DataModel.Category category)
            {
                database db = new database();
                db.ClearParameters();

                db.SPName = "dbo.spCategory_Save";
                db.AddParameter("@id", SqlDbType.NVarChar, category.id);
                db.AddParameter("@name", SqlDbType.NVarChar, category.name);
                db.AddParameter("@initial", SqlDbType.NVarChar, category.initial);
                db.AddParameter("@user_id", SqlDbType.NVarChar, statics.GetLogonUsername());

                DataSet ds = db.ExecuteSP();
                db.Dispose();

                return ds.Tables[0].Rows[0]["id"].ToString();
            }

            public static string isExists(string id, string initial)
            {
                string exists = "0";
                database db = new database();
                db.ClearParameters();

                db.SPName = "dbo.spCategory_CheckExisting";
                db.AddParameter("@id", SqlDbType.NVarChar, id);
                db.AddParameter("@initial", SqlDbType.NVarChar, initial);

                DataSet ds = db.ExecuteSP();
                db.Dispose();

                if (ds.Tables.Count > 0)
                {
                    if (ds.Tables[0].Rows.Count > 0)
                    {
                        exists = ds.Tables[0].Rows[0]["isExists"].ToString();
                    }
                }

                return exists;
            }

            public static Boolean Delete(string id)
            {
                database db = new database();
                db.ClearParameters();

                db.SPName = "dbo.spCategory_Delete";
                db.AddParameter("@id", SqlDbType.NVarChar, id);

                DataSet ds = db.ExecuteSP();
                db.Dispose();

                return true;
            }

            public static Category.ValidationAttribute CheckValidation(string id)
            {
                database db = new database();
                db.ClearParameters();

                db.SPName = "dbo.spCategory_Validation";
                db.AddParameter("@id", SqlDbType.NVarChar, id);

                DataSet ds = db.ExecuteSP();
                db.Dispose();

                Category.ValidationAttribute valid = new Category.ValidationAttribute();
                valid.isCanEdit = true;
                valid.isCanDelete = true;

                if (ds.Tables.Count > 0)
                {
                    foreach (DataRow dr in ds.Tables[0].Rows)
                    {
                        valid.isCanEdit = Boolean.Parse(dr["can_edit"].ToString());
                        valid.isCanDelete = Boolean.Parse(dr["can_delete"].ToString());
                    }
                }

                return valid;
            }
        }

        public class SubCategory
        {
            public static Boolean Save(DataModel.SubCategory subcategory)
            {
                database db = new database();
                db.ClearParameters();

                db.SPName = "dbo.spSubCategory_Save";
                db.AddParameter("@id", SqlDbType.NVarChar, subcategory.id);
                db.AddParameter("@category", SqlDbType.NVarChar, subcategory.category);
                db.AddParameter("@name", SqlDbType.NVarChar, subcategory.name);
                db.AddParameter("@initial", SqlDbType.NVarChar, subcategory.initial);

                DataSet ds = db.ExecuteSP();
                db.Dispose();

                return true;
            }

            public static Boolean Delete(string id)
            {
                database db = new database();
                db.ClearParameters();

                db.SPName = "dbo.spSubCategory_Delete";
                db.AddParameter("@id", SqlDbType.NVarChar, id);

                DataSet ds = db.ExecuteSP();
                db.Dispose();

                return true;
            }
        }

        public class Brand
        {
            public static DataTable GetList()
            {
                database db = new database();
                db.ClearParameters();

                db.SPName = "dbo.spBrand_GetList";

                DataSet ds = db.ExecuteSP();
                db.Dispose();

                return ds.Tables[0];
            }

            public static DataSet GetData(string id)
            {
                database db = new database();
                db.ClearParameters();

                db.SPName = "dbo.spBrand_GetData";
                db.AddParameter("@id", SqlDbType.NVarChar, id);

                DataSet ds = db.ExecuteSP();
                db.Dispose();

                return ds;
            }

            public static string Save(DataModel.Brand brand)
            {
                database db = new database();
                db.ClearParameters();

                db.SPName = "dbo.spBrand_Save";
                db.AddParameter("@id", SqlDbType.NVarChar, brand.id);
                db.AddParameter("@name", SqlDbType.NVarChar, brand.name);
                db.AddParameter("@user_id", SqlDbType.NVarChar, statics.GetLogonUsername());

                DataSet ds = db.ExecuteSP();
                db.Dispose();

                return ds.Tables[0].Rows[0]["id"].ToString();
            }

            public static string isExists(string id, string name)
            {
                string exists = "0";
                database db = new database();
                db.ClearParameters();

                db.SPName = "dbo.spBrand_CheckExisting";
                db.AddParameter("@id", SqlDbType.NVarChar, id);
                db.AddParameter("@name", SqlDbType.NVarChar, name);

                DataSet ds = db.ExecuteSP();
                db.Dispose();

                if (ds.Tables.Count > 0)
                {
                    if (ds.Tables[0].Rows.Count > 0)
                    {
                        exists = ds.Tables[0].Rows[0]["isExists"].ToString();
                    }
                }

                return exists;
            }

            public static Boolean Delete(string id)
            {
                database db = new database();
                db.ClearParameters();

                db.SPName = "dbo.spBrand_Delete";
                db.AddParameter("@id", SqlDbType.NVarChar, id);

                DataSet ds = db.ExecuteSP();
                db.Dispose();

                return true;
            }
        }

        public class BrandCategory
        {
            public static Boolean Save(DataModel.BrandCategory brandcategory)
            {
                database db = new database();
                db.ClearParameters();

                db.SPName = "dbo.spBrandCategory_Save";
                db.AddParameter("@id", SqlDbType.NVarChar, brandcategory.id);
                db.AddParameter("@brand", SqlDbType.NVarChar, brandcategory.brand);
                db.AddParameter("@category", SqlDbType.NVarChar, brandcategory.category);
                db.AddParameter("@subcategory", SqlDbType.NVarChar, brandcategory.subcategory);

                DataSet ds = db.ExecuteSP();
                db.Dispose();

                return true;
            }

            public static Boolean Delete(string id)
            {
                database db = new database();
                db.ClearParameters();

                db.SPName = "dbo.spBrandCategory_Delete";
                db.AddParameter("@id", SqlDbType.NVarChar, id);

                DataSet ds = db.ExecuteSP();
                db.Dispose();

                return true;
            }
        }

        public class Item
        {
            public class ValidationAttribute
            {
                public Boolean isCanEdit { get; set; }
                public Boolean isCanDelete { get; set; }
            }

            public class ItemOutput
            {
                public string id { get; set; }
                public string code { get; set; }
            }

            public static DataSet GetList(int page_size, int start, string search, string orderBy)
            {
                database db = new database();
                db.ClearParameters();

                db.SPName = "dbo.spItem_GetList";
                db.AddParameter("@page_size", SqlDbType.NVarChar, page_size);
                db.AddParameter("@start", SqlDbType.NVarChar, start);
                db.AddParameter("@search", SqlDbType.NVarChar, search);
                db.AddParameter("@orderBy", SqlDbType.NVarChar, orderBy);

                DataSet ds = db.ExecuteSP();
                db.Dispose();

                return ds;
            }

            public static DataSet GetData(string id)
            {
                database db = new database();
                db.ClearParameters();

                db.SPName = "dbo.spItem_GetData";
                db.AddParameter("@id", SqlDbType.NVarChar, id);

                DataSet ds = db.ExecuteSP();
                db.Dispose();

                return ds;
            }

            public static ItemOutput Save(DataModel.Item item)
            {
                ItemOutput opt = new ItemOutput();
                database db = new database();
                db.ClearParameters();

                db.SPName = "dbo.spItem_Save";
                db.AddParameter("@id", SqlDbType.NVarChar, item.id);
                db.AddParameter("@category", SqlDbType.NVarChar, item.category);
                db.AddParameter("@subcategory", SqlDbType.NVarChar, item.subcategory);
                db.AddParameter("@brand", SqlDbType.NVarChar, item.brand);
                db.AddParameter("@description", SqlDbType.NVarChar, item.description);
                db.AddParameter("@uom", SqlDbType.NVarChar, item.uom);
                db.AddParameter("@item_code", SqlDbType.NVarChar, item.item_code);
                db.AddParameter("@sun_code", SqlDbType.NVarChar, item.sun_code);
                db.AddParameter("@sun_description", SqlDbType.NVarChar, item.sun_long_desc);
                db.AddParameter("@remarks", SqlDbType.NVarChar, item.remarks);
                db.AddParameter("@is_item_active", SqlDbType.NVarChar, item.is_item_active);
                db.AddParameter("@user_id", SqlDbType.NVarChar, statics.GetLogonUsername());

                DataSet ds = db.ExecuteSP();
                db.Dispose();

                foreach (DataRow dr in ds.Tables[0].Rows)
                {
                    opt.id = dr["id"].ToString();
                    opt.code = dr["item_code"].ToString();
                }
                return opt;
            }

            public static Boolean Delete(string id)
            {
                database db = new database();
                db.ClearParameters();

                db.SPName = "dbo.spItem_Delete";
                db.AddParameter("@id", SqlDbType.NVarChar, id);

                DataSet ds = db.ExecuteSP();
                db.Dispose();

                return true;
            }

            public static Item.ValidationAttribute CheckValidation(string id)
            {
                database db = new database();
                db.ClearParameters();

                db.SPName = "dbo.spItem_Validation";
                db.AddParameter("@id", SqlDbType.NVarChar, id);

                DataSet ds = db.ExecuteSP();
                db.Dispose();

                Item.ValidationAttribute valid = new Item.ValidationAttribute();
                valid.isCanEdit = true;
                valid.isCanDelete = true;

                if (ds.Tables.Count > 0)
                {
                    foreach (DataRow dr in ds.Tables[0].Rows)
                    {
                        valid.isCanEdit = Boolean.Parse(dr["can_edit"].ToString());
                        valid.isCanDelete = Boolean.Parse(dr["can_delete"].ToString());
                    }
                }

                return valid;
            }
        }

        public class Attachment
        {
            public static Boolean Save(DataModel.Attachment attachment)
            {
                database db = new database();
                db.ClearParameters();

                db.SPName = "dbo.spAttachment_Save";
                db.AddParameter("@id", SqlDbType.NVarChar, attachment.id);
                db.AddParameter("@filename", SqlDbType.NVarChar, attachment.filename);
                db.AddParameter("@file_description", SqlDbType.NVarChar, attachment.file_description);
                db.AddParameter("@document_type", SqlDbType.NVarChar, attachment.document_type);
                db.AddParameter("@document_id", SqlDbType.NVarChar, attachment.document_id);

                DataSet ds = db.ExecuteSP();
                db.Dispose();

                return true;
            }

            public static Boolean Delete(string id)
            {
                database db = new database();
                db.ClearParameters();

                db.SPName = "dbo.spAttachment_Delete";
                db.AddParameter("@id", SqlDbType.NVarChar, id);

                DataSet ds = db.ExecuteSP();
                db.Dispose();

                return true;
            }
        }

        public class Vendor
        {
            public class ValidationAttribute
            {
                public Boolean isCanEdit { get; set; }
                public Boolean isCanDelete { get; set; }
            }

            public class VendorOutput
            {
                public string id { get; set; }
                public string code { get; set; }
            }

            public static DataSet GetList(int page_size, int start, string search, string orderBy)
            {
                database db = new database();
                db.ClearParameters();

                db.SPName = "dbo.spVendor_GetList_myTree";
                db.AddParameter("@page_size", SqlDbType.NVarChar, page_size);
                db.AddParameter("@start", SqlDbType.NVarChar, start);
                db.AddParameter("@search", SqlDbType.NVarChar, search);
                db.AddParameter("@orderBy", SqlDbType.NVarChar, orderBy);

                DataSet ds = db.ExecuteSP();
                db.Dispose();

                return ds;
            }

            public static DataSet GetListMytree(string isActive)
            {
                database db = new database();
                db.ClearParameters();

                db.SPName = "dbo.spVendor_GetListVendor";
                db.AddParameter("@isActive", SqlDbType.Int, string.IsNullOrEmpty(isActive) ? -1 : Convert.ToInt16(isActive));
                //db.AddParameter("@start", SqlDbType.NVarChar, start);
                //db.AddParameter("@search", SqlDbType.NVarChar, search);
                //db.AddParameter("@orderBy", SqlDbType.NVarChar, orderBy);

                DataSet ds = db.ExecuteSP();
                db.Dispose();

                return ds;
            }

            public static DataSet GetData(string id)
            {
                database db = new database();
                db.ClearParameters();

                db.SPName = "dbo.spVendor_GetData";
                db.AddParameter("@id", SqlDbType.NVarChar, id);

                DataSet ds = db.ExecuteSP();
                db.Dispose();

                return ds;
            }

            public static VendorOutput Save(DataModel.Vendor vendor)
            {
                VendorOutput vo = new VendorOutput();
                database db = new database();
                db.ClearParameters();

                db.SPName = "dbo.spVendor_Save";
                db.AddParameter("@id", SqlDbType.NVarChar, vendor.id);
                db.AddParameter("@company_code", SqlDbType.NVarChar, vendor.company_code);
                db.AddParameter("@sun_code", SqlDbType.NVarChar, vendor.sun_code);
                db.AddParameter("@lookup_code", SqlDbType.NVarChar, vendor.lookup_code);
                db.AddParameter("@sun_status", SqlDbType.NVarChar, vendor.sun_status);
                db.AddParameter("@short_desc", SqlDbType.NVarChar, vendor.short_desc);
                db.AddParameter("@company_name", SqlDbType.NVarChar, vendor.company_name);
                db.AddParameter("@description", SqlDbType.NVarChar, vendor.description);
                db.AddParameter("@telp_no", SqlDbType.NVarChar, vendor.telp_no);
                db.AddParameter("@fax_no", SqlDbType.NVarChar, vendor.fax_no);
                db.AddParameter("@email", SqlDbType.NVarChar, vendor.email);
                db.AddParameter("@mobile_no", SqlDbType.NVarChar, vendor.mobile_no);
                db.AddParameter("@website", SqlDbType.NVarChar, vendor.website);
                db.AddParameter("@tax_system", SqlDbType.NVarChar, vendor.tax_system);
                db.AddParameter("@tax_system_name", SqlDbType.NVarChar, vendor.tax_system_name);
                db.AddParameter("@account_code", SqlDbType.NVarChar, vendor.account_code);
                db.AddParameter("@payment_method", SqlDbType.NVarChar, vendor.payment_method);
                db.AddParameter("@business_type", SqlDbType.NVarChar, vendor.business_type);
                db.AddParameter("@qualification", SqlDbType.NVarChar, vendor.qualification);
                db.AddParameter("@tax_opt1", SqlDbType.NVarChar, vendor.tax_opt1);
                db.AddParameter("@tax_opt2", SqlDbType.NVarChar, vendor.tax_opt2);
                db.AddParameter("@remarks", SqlDbType.NVarChar, vendor.remarks);
                db.AddParameter("@is_payment_address_same", SqlDbType.NVarChar, vendor.is_payment_address_same);
                db.AddParameter("@is_order_address_same", SqlDbType.NVarChar, vendor.is_order_address_same);
                db.AddParameter("@is_vendor_active", SqlDbType.NVarChar, vendor.is_vendor_active);
                db.AddParameter("@user_id", SqlDbType.NVarChar, statics.GetLogonUsername());

                DataSet ds = db.ExecuteSP();
                db.Dispose();

                if (ds.Tables[0].Rows.Count > 0)
                {
                    foreach (DataRow dr in ds.Tables[0].Rows)
                    {
                        vo.id = dr["id"].ToString();
                        vo.code = dr["vendor_code"].ToString();
                    }
                }
                return vo;
            }

            public static Boolean Delete(string id)
            {
                database db = new database();
                db.ClearParameters();

                db.SPName = "dbo.spVendor_Delete";
                db.AddParameter("@id", SqlDbType.NVarChar, id);

                DataSet ds = db.ExecuteSP();
                db.Dispose();

                return true;
            }

            public static Vendor.ValidationAttribute CheckValidation(string id)
            {
                database db = new database();
                db.ClearParameters();

                db.SPName = "dbo.spVendor_Validation";
                db.AddParameter("@id", SqlDbType.NVarChar, id);

                DataSet ds = db.ExecuteSP();
                db.Dispose();

                Vendor.ValidationAttribute valid = new Vendor.ValidationAttribute();
                valid.isCanEdit = true;
                valid.isCanDelete = true;

                if (ds.Tables.Count > 0)
                {
                    foreach (DataRow dr in ds.Tables[0].Rows)
                    {
                        valid.isCanEdit = Boolean.Parse(dr["can_edit"].ToString());
                        valid.isCanDelete = Boolean.Parse(dr["can_delete"].ToString());
                    }
                }

                return valid;
            }

            public static DataSet Export(string id)
            {
                database db = new database();
                db.ClearParameters();

                db.SPName = "dbo.spVendor_ExportSUN";
                db.AddParameter("@id", SqlDbType.NVarChar, id);

                DataSet ds = db.ExecuteSP();
                db.Dispose();

                return ds;
            }

            public static DataSet GetExportList(string status)
            {
                database db = new database();
                db.ClearParameters();

                db.SPName = "dbo.spVendor_GetExportToExcelList";
                db.AddParameter("@STATUS", SqlDbType.NVarChar, status);

                DataSet ds = db.ExecuteSP();
                db.Dispose();

                return ds;
            }

            public static DataSet GetDataPORelated(string vendor_id)
            {
                database db = new database();
                db.ClearParameters();

                db.SPName = "spBusinessPartnerPO_ExportExcel";
                db.AddParameter("@vendor_id", SqlDbType.NVarChar, vendor_id);

                DataSet ds = db.ExecuteSP();
                db.Dispose();

                return ds;
            }
        }

        public class VendorAddress
        {
            public static VendorOutput Save(DataModel.VendorAddress address)
            {

                VendorOutput vo = new VendorOutput();
                database db = new database();
                db.ClearParameters();

                db.SPName = "dbo.spVendorAddress_Save";
                db.AddParameter("@id", SqlDbType.NVarChar, address.id);
                db.AddParameter("@vendor_id", SqlDbType.NVarChar, address.vendor_id);
                db.AddParameter("@address_type", SqlDbType.NVarChar, address.address_type);
                db.AddParameter("@sun_code", SqlDbType.NVarChar, address.sun_address_code);
                db.AddParameter("@address1", SqlDbType.NVarChar, address.address1);
                db.AddParameter("@address2", SqlDbType.NVarChar, address.address2);
                db.AddParameter("@address3", SqlDbType.NVarChar, address.address3);
                db.AddParameter("@address4", SqlDbType.NVarChar, address.address4);
                db.AddParameter("@address5", SqlDbType.NVarChar, address.address5);
                db.AddParameter("@city", SqlDbType.NVarChar, address.city);
                db.AddParameter("@state", SqlDbType.NVarChar, address.state);
                db.AddParameter("@postal_code", SqlDbType.NVarChar, address.postal_code);
                db.AddParameter("@country_id", SqlDbType.NVarChar, address.country_id);
                db.AddParameter("@url", SqlDbType.NVarChar, address.url);

                DataSet ds = db.ExecuteSP();
                db.Dispose();

                if (ds.Tables[0].Rows.Count > 0)
                {
                    foreach (DataRow dr in ds.Tables[0].Rows)
                    {
                        vo.id = dr["id"].ToString();
                    }
                }


                return vo;
            }

            public static Boolean Delete(string id)
            {
                database db = new database();
                db.ClearParameters();

                db.SPName = "dbo.spVendorAddress_Delete";
                db.AddParameter("@id", SqlDbType.NVarChar, id);

                DataSet ds = db.ExecuteSP();
                db.Dispose();

                return true;
            }
        }

        public class VendorCategory
        {
            public static Boolean Save(DataModel.VendorCategory category)
            {
                database db = new database();
                db.ClearParameters();

                db.SPName = "dbo.spVendorCategory_Save";
                db.AddParameter("@id", SqlDbType.NVarChar, category.id);
                db.AddParameter("@vendor_id", SqlDbType.NVarChar, category.vendor_id);
                db.AddParameter("@category", SqlDbType.NVarChar, category.category);
                db.AddParameter("@subcategory", SqlDbType.NVarChar, category.subcategory);

                DataSet ds = db.ExecuteSP();
                db.Dispose();

                return true;
            }

            public static Boolean Delete(string id)
            {
                database db = new database();
                db.ClearParameters();

                db.SPName = "dbo.spVendorCategory_Delete";
                db.AddParameter("@id", SqlDbType.NVarChar, id);

                DataSet ds = db.ExecuteSP();
                db.Dispose();

                return true;
            }
        }

        public class VendorContactPerson
        {
            public static Boolean Save(DataModel.VendorContactPerson contact)
            {
                database db = new database();
                db.ClearParameters();

                db.SPName = "dbo.spVendorContactPerson_Save";
                db.AddParameter("@id", SqlDbType.NVarChar, contact.id);
                db.AddParameter("@vendor_id", SqlDbType.NVarChar, contact.vendor_id);
                db.AddParameter("@salutation", SqlDbType.NVarChar, contact.salutation);
                db.AddParameter("@first_name", SqlDbType.NVarChar, contact.first_name);
                db.AddParameter("@last_name", SqlDbType.NVarChar, contact.last_name);
                db.AddParameter("@name", SqlDbType.NVarChar, contact.name);
                db.AddParameter("@position", SqlDbType.NVarChar, contact.position);
                db.AddParameter("@cell_phone", SqlDbType.NVarChar, contact.cell_phone);
                db.AddParameter("@work_phone", SqlDbType.NVarChar, contact.work_phone);
                db.AddParameter("@fax", SqlDbType.NVarChar, contact.fax);
                db.AddParameter("@email", SqlDbType.NVarChar, contact.email);
                db.AddParameter("@cc_email", SqlDbType.NVarChar, contact.cc_email);
                db.AddParameter("@vendor_address_id", SqlDbType.NVarChar, contact.vendor_address_id);

                DataSet ds = db.ExecuteSP();
                db.Dispose();

                return true;
            }

            public static Boolean Delete(string id)
            {
                database db = new database();
                db.ClearParameters();

                db.SPName = "dbo.spVendorContactPerson_Delete";
                db.AddParameter("@id", SqlDbType.NVarChar, id);

                DataSet ds = db.ExecuteSP();
                db.Dispose();

                return true;
            }
        }
    
        public class SundrySupplier
        {
            public static Boolean Save(DataModel.SundrySupplier data)
            {
                database db = new database();
                db.ClearParameters();

                db.SPName = "dbo.spSundrySupplier_Save";
                db.AddParameter("@id", SqlDbType.NVarChar, data.id);
                db.AddParameter("@sundry_supplier_id", SqlDbType.NVarChar, data.sundry_supplier_id);
                db.AddParameter("@module_id", SqlDbType.NVarChar, data.module_id);
                db.AddParameter("@module_type", SqlDbType.NVarChar, data.module_type);
                db.AddParameter("@name", SqlDbType.NVarChar, data.name);
                db.AddParameter("@address", SqlDbType.NVarChar, data.address);
                db.AddParameter("@contact_person", SqlDbType.NVarChar, data.contact_person);
                db.AddParameter("@email", SqlDbType.NVarChar, data.email);
                db.AddParameter("@phone_number", SqlDbType.NVarChar, data.phone_number);
                db.AddParameter("@bank_account", SqlDbType.NVarChar, data.bank_account);
                db.AddParameter("@swift", SqlDbType.NVarChar, data.swift);
                db.AddParameter("@sort_code", SqlDbType.NVarChar, data.sort_code);
                db.AddParameter("@place", SqlDbType.NVarChar, data.place);
                db.AddParameter("@province", SqlDbType.NVarChar, data.province);
                db.AddParameter("@post_code", SqlDbType.NVarChar, data.post_code);
                db.AddParameter("@vat_reg_no", SqlDbType.NVarChar, data.vat_reg_no);
                db.AddParameter("@module_detail_id", SqlDbType.NVarChar, data.module_detail_id);


                DataSet ds = db.ExecuteSP();
                db.Dispose();

                return true;
            }

            public static Boolean Delete(string module_id, string module_type,string module_detail_id = "")
            {
                database db = new database();
                db.ClearParameters();

                db.SPName = "dbo.spSundrySupplier_Delete";
                db.AddParameter("@module_id", SqlDbType.NVarChar, module_id);
                db.AddParameter("@module_type", SqlDbType.NVarChar, module_type);
                db.AddParameter("@module_detail_id", SqlDbType.NVarChar, module_detail_id);

                DataSet ds = db.ExecuteSP();
                db.Dispose();

                return true;
            }

            public static DataSet GetData(string module_id, string module_type)
            {
                database db = new database();
                db.ClearParameters();

                db.SPName = "dbo.spSundrySupplier_GetData";
                db.AddParameter("@module_id", SqlDbType.NVarChar, module_id);
                db.AddParameter("@module_type", SqlDbType.NVarChar, module_type);

                DataSet ds = db.ExecuteSP();
                db.Dispose();

                return ds;
            }
        }
    }
}
