using myTree.WebForms.Procurement.General;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace myTree.WebForms.Modules
{
    public partial class TaskRegistration : System.Web.UI.Page
    {
        protected string listUser = string.Empty;
        protected string listEmployee = string.Empty;

        protected AccessControl authorized = new AccessControl("PURCHASE REQUISITION");

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!authorized.admin)
            {
                Response.Redirect(authorized.redirectPage);
            }

            listUser = JsonConvert.SerializeObject(statics.GetTaskUsers());
            listEmployee = JsonConvert.SerializeObject(statics.GetTaskUnregisteredEmployee());
        }

        [WebMethod]
        public static string SaveTaskUser(string id, string emp_user_id, string is_active)
        {
            string result, message = "";
            try
            {
                statics.SaveTaskUser(id, emp_user_id, is_active);
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