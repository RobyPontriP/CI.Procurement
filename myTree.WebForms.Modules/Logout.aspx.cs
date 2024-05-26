using System;
using System.Configuration;

namespace myTree.WebForms.Modules
{
    public partial class Logout : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            string appName = ConfigurationManager.AppSettings["Oidc:ClientId"];
            string mytree_url = ConfigurationManager.AppSettings["mytree_logout_url"];

            var cookieList = Request.Cookies.AllKeys;
            foreach (var c in cookieList)
            {
                if (c.Contains(appName))
                {
                    Response.Cookies[c].Expires = DateTime.Now.AddDays(-1);
                }
            }

            Response.Redirect(mytree_url);
        }
    }
}