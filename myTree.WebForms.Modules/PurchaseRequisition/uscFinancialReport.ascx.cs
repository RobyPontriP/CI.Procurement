using myTree.WebForms.Procurement.General;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace myTree.WebForms.Modules.PurchaseRequisition
{
    public partial class uscFinancialReport : System.Web.UI.UserControl
    {
        public string pr_id { get; set; }
        protected string _id = string.Empty;
        protected string statusId = string.Empty;
        protected string UserId = string.Empty;
        protected Boolean is_show_btneditjournal = false;

        protected string listJournal = "[]";
        protected string listGRM = "[]";

        private Boolean usr_finance = false;
        private string status_id = string.Empty;

        public Boolean usrFinance
        {
            get { return usr_finance; }
            set { usr_finance = value; }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            UserId = statics.GetLogonUsername();
            _id = Request.QueryString["id"] ?? "";
            if (!string.IsNullOrEmpty(_id))
            {
                DataSet ds = staticsPurchaseRequisition.GetFinancialReport(_id);
                if (ds.Tables.Count > 0)
                {
                    DataTable dtJournal = ds.Tables[0];
                    DataTable dtGRM = ds.Tables[2];

                    statusId = ds.Tables[1].Rows[0]["status_id"].ToString();
                    is_show_btneditjournal = Boolean.Parse(ds.Tables[1].Rows[0]["is_show_btneditjournal"].ToString());

                    listJournal = JsonConvert.SerializeObject(dtJournal);
                    listGRM = JsonConvert.SerializeObject(dtGRM);
                }
            }
        }
    }
}