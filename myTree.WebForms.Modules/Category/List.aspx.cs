using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using myTree.WebForms.Procurement.General;
using Newtonsoft.Json;

namespace myTree.WebForms.Modules.Category
{
    public partial class List : System.Web.UI.Page
    {
        protected string listCategory = string.Empty;
        protected AccessControl authorized = new AccessControl("category");

        protected void Page_Load(object sender, EventArgs e)
        {
            listCategory = JsonConvert.SerializeObject(staticsMaster.Category.GetList());
        }

        [WebMethod]
        public static string Delete(string id)
        {
            string result, message = "";
            try
            {
                staticsMaster.Category.ValidationAttribute valid = staticsMaster.Category.CheckValidation(id);

                if (valid.isCanDelete)
                {
                    DataModel.Comment comment = new DataModel.Comment();
                    comment.module_name = "CATEGORY";
                    comment.module_id = id;
                    comment.action_taken = "DELETED";
                    statics.Comment.Save(comment);

                    staticsMaster.Category.Delete(id);

                    result = "success";
                }
                else
                {
                    message = "This category cannot be deleted due to already linked with item/business partner";
                    result = "error";
                }
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