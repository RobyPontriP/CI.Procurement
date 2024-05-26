using myTree.WebForms.Procurement.General;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace myTree.WebForms.Modules.Usc
{
    public partial class uscRecentComment : System.Web.UI.UserControl
    {
        public string moduleName { get; set; }
        public string moduleId { get; set; }
        List<DataModel.Comment> comments = new List<DataModel.Comment>();
        protected string listComments = string.Empty;
        protected void Page_Load(object sender, EventArgs e)
        {
            DataTable dtComment = new DataTable();
            if (!String.IsNullOrEmpty(moduleId) && !String.IsNullOrEmpty(moduleName))
            {
                dtComment = statics.Comment.GetData(moduleId, moduleName);
                foreach (DataRow dr in dtComment.Rows)
                {
                    string comment = statics.NormalizeString(dr["comment"].ToString());
                    string comment_file = dr["comment_file_link"].ToString();
                    if (!string.IsNullOrEmpty(comment_file) && !string.IsNullOrEmpty(comment))
                    {
                        comment = comment + "<br/>" + comment_file;
                    }
                    else if (!string.IsNullOrEmpty(comment_file) && string.IsNullOrEmpty(comment))
                    {
                        comment = comment_file;
                    }
                    DataModel.Comment c = new DataModel.Comment
                    {
                        emp_user_id = statics.NormalizeString(dr["emp_user_id"].ToString()),
                        roles = statics.NormalizeString(dr["roles"].ToString()),
                        created_date = dr["created_date"].ToString(),
                        comment = comment,
                        action_taken = dr["action_taken"].ToString()
                    };
                    comments.Add(c);
                }
            }
            listComments = JsonConvert.SerializeObject(comments);
        }
    }
}