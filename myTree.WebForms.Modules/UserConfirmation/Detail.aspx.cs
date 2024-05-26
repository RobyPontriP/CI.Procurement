using myTree.WebForms.Procurement.General;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace myTree.WebForms.Modules.UserConfirmation
{
    public partial class Detail : System.Web.UI.Page
    {
        protected string id = string.Empty
            , page_type = "detail";

        protected string listMain = "[]", listGroupHeader = "[]", listGroupDetail = "[]", listDocs = "[]";

        protected DataModel.UserConfirmation du = new DataModel.UserConfirmation();

        protected string source = string.Empty
            , source_id = string.Empty
            , blank_mode = string.Empty;

        protected UserRoleAccess userRoleAccess = AccessControl.GetUserRoleAccess(AccessControlObjectEnum.ProcurementPurchaseOrder);

        protected void Page_Load(object sender, EventArgs e)
        {
            id = Request.QueryString["id"] ?? "0";
            blank_mode = Request.QueryString["blankmode"] ?? "0";
            source = Request.QueryString["source"] ?? "";
            source_id = Request.QueryString["source_id"] ?? "";

            DataSet ds = staticsUserConfirmation.Main.GetData(id, page_type);
            if (ds.Tables.Count >= 4)
            {
                foreach (DataRow dr in ds.Tables[0].Rows)
                {
                    du.confirmation_code = dr["confirmation_code"].ToString();
                    du.status_id = dr["status_name"].ToString();
                    du.send_date = dr["senddate"].ToString();
                    du.confirm_date = dr["confirmdate"].ToString();
                }
                listGroupHeader = JsonConvert.SerializeObject(ds.Tables[1]);
                listGroupDetail = JsonConvert.SerializeObject(ds.Tables[2]);
                listDocs = JsonConvert.SerializeObject(ds.Tables[3]);
            }
           
            //this.confirmationForm.page_type = page_type;
        }
    }
}