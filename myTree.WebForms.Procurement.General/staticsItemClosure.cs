using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;

namespace myTree.WebForms.Procurement.General
{
    public class staticsItemClosure
    {
        public static string SaveClosure(DataModel.ItemClosure ic)
        {
            database db = new database();
            db.ClearParameters();

            db.SPName = "dbo.spItemClosure_Save";
            db.AddParameter("@id", SqlDbType.NVarChar, ic.id);
            db.AddParameter("@temporary_id", SqlDbType.NVarChar, ic.temporary_id);
            db.AddParameter("@reason_for_closing", SqlDbType.NVarChar, ic.reason_for_closing);
            db.AddParameter("@base_type", SqlDbType.NVarChar, ic.base_type);
            db.AddParameter("@base_id", SqlDbType.NVarChar, ic.base_id);
            db.AddParameter("@pr_detail_id", SqlDbType.NVarChar, ic.pr_detail_id);
            db.AddParameter("@grm_no", SqlDbType.NVarChar, ic.grm_no);
            db.AddParameter("@grm_line", SqlDbType.NVarChar, ic.grm_line);
            db.AddParameter("@close_date", SqlDbType.NVarChar, ic.close_date);
            db.AddParameter("@quantity", SqlDbType.NVarChar, ic.quantity);
            db.AddParameter("@actual_amount", SqlDbType.NVarChar, ic.actual_amount);
            db.AddParameter("@actual_amount_usd", SqlDbType.NVarChar, ic.actual_amount_usd);
            db.AddParameter("@remarks", SqlDbType.NVarChar, ic.remarks);
            db.AddParameter("@user_id", SqlDbType.NVarChar, statics.GetLogonUsername());

            DataSet ds = db.ExecuteSP();
            db.Dispose();

            return ds.Tables[0].Rows[0]["id"].ToString(); ;
        }

        public static DataTable GetData(string base_id, string base_type)
        {
            database db = new database();
            db.ClearParameters();

            db.SPName = "dbo.spItemClosure_GetData";
            db.AddParameter("@base_id", SqlDbType.NVarChar, base_id);
            db.AddParameter("@base_type", SqlDbType.NVarChar, base_type);

            DataSet ds = db.ExecuteSP();
            db.Dispose();

            return ds.Tables[0];
        }

        public static DataSet GetDataDetail(string id)
        {
            database db = new database();
            db.ClearParameters();

            db.SPName = "dbo.spItemClosure_GetDataDetail";
            db.AddParameter("@id", SqlDbType.NVarChar, id);

            DataSet ds = db.ExecuteSP();
            db.Dispose();

            return ds;
        }
    }
}