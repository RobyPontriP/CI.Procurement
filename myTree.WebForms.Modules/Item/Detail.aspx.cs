using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using myTree.WebForms.Procurement.General;

namespace myTree.WebForms.Modules.Item
{
    public partial class Detail : System.Web.UI.Page
    {
        protected string _id = string.Empty;

        protected DataModel.Item item;
        protected DataModel.Attachment attachment;

        protected AccessControl authorized = new AccessControl("item");

        protected void Page_Load(object sender, EventArgs e)
        {
            _id = Request.QueryString["id"] ?? "";
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
                        item.description = dtItem.Rows[0]["description"].ToString();
                        item.uom = dtItem.Rows[0]["uom"].ToString();
                        item.item_code = dtItem.Rows[0]["item_code"].ToString();
                        item.sun_code = dtItem.Rows[0]["sun_code"].ToString();
                        item.sun_description = dtItem.Rows[0]["sun_description"].ToString();
                        item.remarks = dtItem.Rows[0]["remarks"].ToString();
                        item.is_active = dtItem.Rows[0]["is_active"].ToString();

                        item.sun_lookup_code = dtItem.Rows[0]["sun_lookup_code"].ToString();
                        item.sun_short_desc = dtItem.Rows[0]["sun_short_desc"].ToString();
                        item.sun_long_desc = dtItem.Rows[0]["sun_long_desc"].ToString();
                        item.sun_status = dtItem.Rows[0]["sun_status"].ToString();
                        item.sun_item_group = dtItem.Rows[0]["sun_item_group"].ToString();
                        item.sun_account_code = dtItem.Rows[0]["sun_account_code"].ToString();
                        item.category_name = dtItem.Rows[0]["category_name"].ToString();
                        item.subcategory_name = dtItem.Rows[0]["subcategory_name"].ToString();
                        item.brand_name = dtItem.Rows[0]["brand_name"].ToString();
                        item.uom_name = dtItem.Rows[0]["uom_name"].ToString();
                        item.item_active_label = dtItem.Rows[0]["item_active_label"].ToString();
                    }

                    foreach (DataRow dr in dtAttachment.Rows)
                    {
                        attachment = new DataModel.Attachment();
                        attachment.id = dr["id"].ToString();
                        attachment.filename = dr["filename"].ToString();
                        attachment.file_description = dr["file_description"].ToString();
                        attachment.document_id = _id;
                        attachment.document_type = "ITEM";
                        attachment.is_active = dr["is_active"].ToString();

                        item.attachments.Add(attachment);
                    }
                }
            }
        }
    }
}