using myTree.WebForms.Procurement.General;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Procurement.Closure
{
    public partial class PurchaseOrder : System.Web.UI.Page
    {
        protected string listClosure = "[]"
            , po_id = string.Empty;

        protected string moduleName = "PURCHASE ORDER";

        //protected AccessControl authorized = new AccessControl("PURCHASE ORDER");

        protected void Page_Load(object sender, EventArgs e)
        {
            //if (!authorized.admin)
            //{
            //    Response.Redirect(authorized.redirectPage);
            //}

            po_id = Request.QueryString["po_id"] ?? "";
            listClosure = JsonConvert.SerializeObject(staticsPurchaseOrder.GetPOClosure(po_id));
        }

        [WebMethod]
        public static string Save(string submission)
        {
            string result, message = "",
                _id = "";
            try
            {
                List<DataModel.ItemClosure> ics = JsonConvert.DeserializeObject<List<DataModel.ItemClosure>>(submission);
                //foreach (DataModel.ItemClosure ic in ics)
                //{
                //    staticsItemClosure.SaveClosure(ic);
                //}
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
                id = _id,
            });
        }
    }
}