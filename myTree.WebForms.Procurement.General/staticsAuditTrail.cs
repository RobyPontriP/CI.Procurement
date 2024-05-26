using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;

namespace myTree.WebForms.Procurement.General
{
    public class staticsAuditTrail
    {
        public static DataTable GetDataChanges(string id, string module)
        {
            database db = new database();
            db.ClearParameters();

            db.SPName = "dbo.spAudit_" + module;
            db.AddParameter("@id", SqlDbType.NVarChar, id);

            DataSet ds = db.ExecuteSP();
            db.Dispose();

            return ds.Tables[0];
        }

        public static String GetAuditDetail(string module_id, string module_name, string change_type, string rec_id, string sub_module, string change_time, string approval_no)
        {
            database db = new database();
            db.ClearParameters();
            db.SPName = "spAuditDetail";
            db.AddParameter("@module_name", SqlDbType.NVarChar, module_name);
            db.AddParameter("@module_id", SqlDbType.NVarChar, module_id);
            db.AddParameter("@rec_id", SqlDbType.NVarChar, rec_id);
            db.AddParameter("@sub_module", SqlDbType.NVarChar, sub_module);
            db.AddParameter("@change_type", SqlDbType.NVarChar, change_type);
            db.AddParameter("@change_time", SqlDbType.NVarChar, change_time);
            db.AddParameter("@approval_no", SqlDbType.NVarChar, approval_no);
            DataSet ds = db.ExecuteSP();
            db.Dispose();
            if (ds.Tables[0].Rows.Count > 0)
            {
                var result = ds.Tables[0].Rows[0][0].ToString();
                result = System.Net.WebUtility.HtmlDecode(result);

                return result;
            }
            else
            {
                return "";
            }
        }
    }
}
