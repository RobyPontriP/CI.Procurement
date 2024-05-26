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

namespace myTree.WebForms.Modules.Category
{
    public partial class Input : System.Web.UI.Page
    {
        protected string _id = string.Empty;

        protected DataModel.Category dmCategory;
        protected DataModel.SubCategory dmSubCategory;

        protected AccessControl authorized = new AccessControl("category");
        protected staticsMaster.Category.ValidationAttribute valid = new staticsMaster.Category.ValidationAttribute();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!authorized.admin)
            {
                Response.Redirect(authorized.redirectPage);
            }

            _id = Request.QueryString["id"] ?? "";

            valid = staticsMaster.Category.CheckValidation(_id);

            dmCategory = new DataModel.Category();
            dmCategory.SubCategories = new List<DataModel.SubCategory>();

            if (!string.IsNullOrEmpty(_id))
            {
                dmCategory.id = _id;

                DataSet ds = staticsMaster.Category.GetData(_id);
                if (ds.Tables.Count > 0)
                {
                    DataTable dtCategory = ds.Tables[0];
                    DataTable dtSubCategory = ds.Tables[1];

                    if (dtCategory.Rows.Count > 0)
                    {
                        dmCategory.name = statics.NormalizeString(dtCategory.Rows[0]["name"].ToString());
                        dmCategory.initial = statics.NormalizeString(dtCategory.Rows[0]["initial"].ToString());
                        dmCategory.is_active = dtCategory.Rows[0]["is_active"].ToString();
                    }

                    foreach (DataRow dr in dtSubCategory.Rows)
                    {
                        dmSubCategory = new DataModel.SubCategory();
                        dmSubCategory.id = dr["id"].ToString();
                        dmSubCategory.category = _id;
                        dmSubCategory.name = statics.NormalizeString(dr["name"].ToString());
                        dmSubCategory.initial = statics.NormalizeString(dr["initial"].ToString());
                        dmSubCategory.is_active = dr["is_active"].ToString();
                        dmSubCategory.can_edit = dr["can_edit"].ToString();

                        dmCategory.SubCategories.Add(dmSubCategory);
                    }
                }
            }
        }

        [WebMethod]
        public static string isExists(string id, string initial)
        {
            string result, message = "", exists = "0";
            try
            {
                exists = staticsMaster.Category.isExists(id, initial);
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
        public static string Save(string submission, string deleted)
        {
            string result, message = "", _id = "";
            try
            {
                DataModel.Category category = JsonConvert.DeserializeObject<DataModel.Category>(submission);

                string action = "SAVED";
                if (!String.IsNullOrEmpty(category.id))
                {
                    action = "UPDATED";
                }

                _id = staticsMaster.Category.Save(category);

                DataModel.Comment comment = new DataModel.Comment();
                comment.module_name = "CATEGORY";
                comment.module_id = _id;
                comment.action_taken = action;
                statics.Comment.Save(comment);

                foreach (DataModel.SubCategory subcategory in category.SubCategories)
                {
                    subcategory.category = _id;
                    staticsMaster.SubCategory.Save(subcategory);
                }
                List<string> deletedIds = JsonConvert.DeserializeObject<List<string>>(deleted);
                foreach (string id in deletedIds)
                {
                    staticsMaster.SubCategory.Delete(id);
                }
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