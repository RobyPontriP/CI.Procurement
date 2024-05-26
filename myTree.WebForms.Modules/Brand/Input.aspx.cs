using myTree.WebForms.Procurement.General;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace myTree.WebForms.Modules.Brand
{
    public partial class Input : System.Web.UI.Page
    {
        protected string _id = string.Empty;
        protected string listCategory = string.Empty;
        protected string listBrandCategory = string.Empty;

        protected DataModel.Brand brand;
        protected DataModel.BrandCategory brandCategory;

        protected AccessControl authorized = new AccessControl("brand");

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!authorized.admin)
            {
                Response.Redirect(authorized.redirectPage);
            }

            _id = Request.QueryString["id"] ?? "";
            brand = new DataModel.Brand();
            brand.BrandCategories = new List<DataModel.BrandCategory>();

            if (!string.IsNullOrEmpty(_id))
            {
                brand.id = _id;

                DataSet ds = staticsMaster.Brand.GetData(_id);
                if (ds.Tables.Count > 0)
                {
                    DataTable dtBrand = ds.Tables[0];
                    //DataTable dtBrandCategory = ds.Tables[1];

                    if (dtBrand.Rows.Count > 0)
                    {
                        brand.name = statics.NormalizeString(dtBrand.Rows[0]["name"].ToString());
                        brand.is_active = dtBrand.Rows[0]["is_active"].ToString();
                    }

                    /*foreach (DataRow dr in dtBrandCategory.Rows)
                    {
                        brandCategory = new DataModel.BrandCategory();
                        brandCategory.id = dr["id"].ToString();
                        brandCategory.brand = _id;
                        brandCategory.category = dr["category"].ToString();
                        brandCategory.subcategory = dr["subcategory"].ToString();
                        brandCategory.is_active = dr["is_active"].ToString();

                        brandCategory.category_name = dr["category_name"].ToString();
                        brandCategory.subcategory_name = dr["subcategory_name"].ToString();

                        brand.BrandCategories.Add(brandCategory);
                    }*/
                }
            }

            listCategory = JsonConvert.SerializeObject(Service.GetCategory(""));
            listBrandCategory = JsonConvert.SerializeObject(brand.BrandCategories);
        }

        [WebMethod]
        public static string isExists(string id, string name)
        {
            string result, message = "", exists = "0";
            try
            {
                exists = staticsMaster.Brand.isExists(id, name);
                result = "success";
            }
            catch (Exception ex)
            {
                result = "error";
                message = ex.ToString();
            }
            return JsonConvert.SerializeObject(new
            {
                result = result,
                message = message,
                exists = exists,
            });
        }

        [WebMethod]
        public static string Save(string submission)
        {
            string result, message = "", _id = "";
            try
            {
                DataModel.Brand brand = JsonConvert.DeserializeObject<DataModel.Brand>(submission);

                string action = "SAVED";
                if (!String.IsNullOrEmpty(brand.id))
                {
                    action = "UPDATED";
                }

                _id = staticsMaster.Brand.Save(brand);

                DataModel.Comment comment = new DataModel.Comment();
                comment.module_name = "BRAND";
                comment.module_id = _id;
                comment.action_taken = action;
                statics.Comment.Save(comment);

                result = "success";
            }
            catch (Exception ex)
            {
                result = "error";
                message = ex.ToString();
            }
            return JsonConvert.SerializeObject(new
            {
                result = result,
                message = message,
                id = _id
            });
        }
    }
}