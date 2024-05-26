using myTree.WebForms.Procurement.General;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace myTree.WebForms.Modules.Brand
{
    public partial class List : System.Web.UI.Page
    {
        protected string listBrand = string.Empty;
        protected AccessControl authorized = new AccessControl("brand");

        protected void Page_Load(object sender, EventArgs e)
        {
            listBrand = JsonConvert.SerializeObject(staticsMaster.Brand.GetList());
        }

        [WebMethod]
        public static string Delete(string id)
        {
            string result, message = "";
            try
            {
                DataModel.Comment comment = new DataModel.Comment();
                comment.module_name = "BRAND";
                comment.module_id = id;
                comment.action_taken = "DELETED";
                statics.Comment.Save(comment);

                staticsMaster.Brand.Delete(id);

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
                message = message
            });
        }
    }
}