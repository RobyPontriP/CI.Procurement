using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using myTree.WebForms.Procurement.General;
using Newtonsoft.Json;

namespace myTree.WebForms.Modules.Item
{
    public partial class List : System.Web.UI.Page
    {
        protected string listItem = string.Empty;
        protected AccessControl authorized = new AccessControl("item");

        protected void Page_Load(object sender, EventArgs e)
        {
            //listItem = JsonConvert.SerializeObject(staticsMaster.Item.GetList());
        }

        [WebMethod]
        public static string Delete(string id)
        {
            string result, message = "";
            try
            {
                staticsMaster.Item.ValidationAttribute valid = staticsMaster.Item.CheckValidation(id);

                if (valid.isCanDelete)
                {
                    DataModel.Comment comment = new DataModel.Comment();
                    comment.module_name = "ITEM";
                    comment.module_id = id;
                    comment.action_taken = "DELETED";
                    statics.Comment.Save(comment);

                    staticsMaster.Item.Delete(id);

                    result = "success";
                }
                else
                {
                    result = "error";
                    message = "This item cannot be deleted due to already used in procurement process";
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