using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using Newtonsoft.Json;
using System.Web.Services;
using myTree.WebForms.Procurement.General;

namespace myTree.WebForms.Modules.Item
{
    public partial class Input : System.Web.UI.Page
    {
        protected string _id = string.Empty;

        protected DataModel.Item item;
        protected DataModel.Attachment attachment;

        protected AccessControl authorized = new AccessControl("item");
        protected staticsMaster.Item.ValidationAttribute valid = new staticsMaster.Item.ValidationAttribute();

        protected string listCategory = string.Empty;
        protected string listBrand = string.Empty;
        protected string listUoM = string.Empty;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!authorized.admin)
            {
                Response.Redirect(authorized.redirectPage);
            }

            _id = Request.QueryString["id"] ?? "";

            valid = staticsMaster.Item.CheckValidation(_id);

            item = new DataModel.Item();
            item.attachments = new List<DataModel.Attachment>();

            if (!string.IsNullOrEmpty(_id))
            {
                item.id = _id;

                DataSet ds = staticsMaster.Item.GetData(_id);
                if (ds.Tables.Count > 0)
                {
                    DataTable dtItem = ds.Tables[0];
                    DataTable dtAttachment = ds.Tables[1];

                    if (dtItem.Rows.Count > 0)
                    {
                        item.category = dtItem.Rows[0]["category"].ToString();
                        item.subcategory = dtItem.Rows[0]["subcategory"].ToString();
                        item.brand = dtItem.Rows[0]["brand"].ToString();
                        item.description = statics.NormalizeString(dtItem.Rows[0]["description"].ToString());
                        item.uom = dtItem.Rows[0]["uom"].ToString();
                        item.item_code = dtItem.Rows[0]["item_code"].ToString();
                        item.sun_code = dtItem.Rows[0]["sun_code"].ToString();
                        item.sun_description = statics.NormalizeString(dtItem.Rows[0]["sun_description"].ToString());
                        item.remarks = statics.NormalizeString(dtItem.Rows[0]["remarks"].ToString());
                        item.is_active = dtItem.Rows[0]["is_active"].ToString();
                        item.is_item_active = dtItem.Rows[0]["is_item_active"].ToString();

                        item.sun_lookup_code = dtItem.Rows[0]["sun_lookup_code"].ToString();
                        item.sun_short_desc = statics.NormalizeString(dtItem.Rows[0]["sun_short_desc"].ToString());
                        item.sun_long_desc = statics.NormalizeString(dtItem.Rows[0]["sun_long_desc"].ToString());
                        item.sun_status = dtItem.Rows[0]["sun_status"].ToString();
                        item.sun_item_group = dtItem.Rows[0]["sun_item_group"].ToString();
                        item.sun_account_code = dtItem.Rows[0]["sun_account_code"].ToString();
                        item.category_name = statics.NormalizeString(dtItem.Rows[0]["category_name"].ToString());
                        item.subcategory_name = statics.NormalizeString(dtItem.Rows[0]["subcategory_name"].ToString());
                        item.brand_name = statics.NormalizeString(dtItem.Rows[0]["brand_name"].ToString());
                        item.uom_name = dtItem.Rows[0]["uom_name"].ToString();
                    }

                    foreach (DataRow dr in dtAttachment.Rows)
                    {
                        attachment = new DataModel.Attachment();
                        attachment.id = dr["id"].ToString();
                        attachment.filename = dr["filename"].ToString();
                        attachment.file_description = statics.NormalizeString(dr["file_description"].ToString());
                        attachment.document_id = _id;
                        attachment.document_type = "ITEM";
                        attachment.is_active = dr["is_active"].ToString();

                        item.attachments.Add(attachment);
                    }
                }
            }
            listCategory = JsonConvert.SerializeObject(Service.GetCategory(""));
            listBrand = JsonConvert.SerializeObject(Service.GetBrand(""));
            listUoM = JsonConvert.SerializeObject(Service.GetUoM(""));
        }

        [WebMethod]
        public static string Save(string submission, string deleted)
        {
            string result, message = "", _id = "";
            staticsMaster.Item.ItemOutput opt = new staticsMaster.Item.ItemOutput();

            try
            {
                DataModel.Item item = JsonConvert.DeserializeObject<DataModel.Item>(submission);

                string action = "SAVED";
                if (!String.IsNullOrEmpty(item.id))
                {
                    action = "UPDATED";
                }

                opt = staticsMaster.Item.Save(item);
                _id = opt.id;

                DataModel.Comment comment = new DataModel.Comment();
                comment.module_name = "ITEM";
                comment.module_id = _id;
                comment.action_taken = action;
                statics.Comment.Save(comment);

                foreach (DataModel.Attachment attachment in item.attachments)
                {
                    attachment.document_id = _id;
                    attachment.document_type = "ITEM";
                    statics.Attachment.Save(attachment);
                }
                List<string> deletedIds = JsonConvert.DeserializeObject<List<string>>(deleted);
                foreach (string id in deletedIds)
                {
                    statics.Attachment.Delete(id);
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
                id = _id,
                code = opt.code

            });
        }
    }
}