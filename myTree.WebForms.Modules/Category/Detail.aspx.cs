using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using myTree.WebForms.Procurement.General;

namespace myTree.WebForms.Modules.Category
{
    public partial class Detail : System.Web.UI.Page
    {
        protected string _id = string.Empty;

        protected DataModel.Category dmCategory;
        protected DataModel.SubCategory dmSubCategory;

        protected AccessControl authorized = new AccessControl("category");

        protected void Page_Load(object sender, EventArgs e)
        {
            _id = Request.QueryString["id"] ?? "";
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
                        dmCategory.name = dtCategory.Rows[0]["name"].ToString();
                        dmCategory.initial = dtCategory.Rows[0]["initial"].ToString();
                        dmCategory.is_active = dtCategory.Rows[0]["is_active"].ToString();
                    }

                    foreach (DataRow dr in dtSubCategory.Rows)
                    {
                        dmSubCategory = new DataModel.SubCategory();
                        dmSubCategory.id = dr["id"].ToString();
                        dmSubCategory.category = _id;
                        dmSubCategory.name = dr["name"].ToString();
                        dmSubCategory.initial = dr["initial"].ToString();
                        dmSubCategory.is_active = dr["is_active"].ToString();

                        dmCategory.SubCategories.Add(dmSubCategory);
                    }
                }
            }
        }
    }
}