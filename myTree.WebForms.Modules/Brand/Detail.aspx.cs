using myTree.WebForms.Procurement.General;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace myTree.WebForms.Modules.Brand
{
    public partial class Detail : System.Web.UI.Page
    {
        protected string _id = string.Empty;

        protected DataModel.Brand brand;


        protected void Page_Load(object sender, EventArgs e)
        {
            _id = Request.QueryString["id"] ?? "";
            brand = new DataModel.Brand();

            if (!string.IsNullOrEmpty(_id))
            {
                brand.id = _id;

                DataSet ds = staticsMaster.Brand.GetData(_id);
                if (ds.Tables.Count > 0)
                {
                    DataTable dtBrand = ds.Tables[0];

                    if (dtBrand.Rows.Count > 0)
                    {
                        brand.name = dtBrand.Rows[0]["name"].ToString();
                        brand.is_active = dtBrand.Rows[0]["is_active"].ToString();
                    }
                }
            }
        }
    }
}