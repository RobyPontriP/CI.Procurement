using myTree.WebForms.Procurement.General;
using myTree.WebForms.Procurement.Notification;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace myTree.WebForms.Modules.UserConfirmation
{
    public partial class ItemConfirmation : System.Web.UI.Page
    {
        protected string id = string.Empty
            , page_type = "submission";

        protected string listMain = "[]", listGroupHeader = "[]", listGroupDetail = "[]", listDocs = "[]";

        protected DataModel.UserConfirmation du = new DataModel.UserConfirmation();

        protected void Page_Load(object sender, EventArgs e)
        {
            id = Request.QueryString["id"] ?? "0";
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

            this.confirmationForm.page_type = page_type;
        }

        [WebMethod]
        public static string Submit(string submission, string workflows, string deleted)
        {
            string result, message = ""
                , moduleName = "ITEM CONFIRMATION";
            Boolean sendEmail = false;
            staticsUserConfirmation.Main.ConfirmationOutput output = new staticsUserConfirmation.Main.ConfirmationOutput();

            DataModel.UserConfirmation data = JsonConvert.DeserializeObject<DataModel.UserConfirmation>(submission);
            DataModel.Workflow workflow = JsonConvert.DeserializeObject<DataModel.Workflow>(workflows);

            try
            {
                output = staticsUserConfirmation.Main.Save(data);

                foreach (DataModel.UserConfirmationDetail du in data.details)
                {
                    if (workflow.action == "saved")
                    {
                        du.status_id = "25";
                    }
                    else if (workflow.action == "submitted")
                    {
                        du.status_id = "50";
                        sendEmail = true;
                    }

                    du.user_confirmation = output.id;

                    staticsUserConfirmation.Detail.Save(du);
                }

                foreach (DataModel.Attachment attachment in data.documents)
                {
                    attachment.document_id = output.id;
                    attachment.document_type = "USER CONFIRMATION";
                    statics.Attachment.Save(attachment);
                }

                staticsUserConfirmation.Main.UpdateStatusConfirmation(output.id);

                /* send notification*/
                if (sendEmail)
                {
                    NotificationHelper.UserItemConfirmation(output.id);
                }

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
                id = output.id,
                confirmation_code = output.confirmation_code
            });
        }
    }
}