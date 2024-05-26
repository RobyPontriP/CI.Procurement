using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace myTree.WebForms.Procurement.General
{
    public class staticsUserConfirmation
    {
        public static DataSet GetItems(string ids, string base_type)
        {
            database db = new database();
            db.ClearParameters();

            db.SPName = "dbo.spUserConfirmation_GetItems";
            db.AddParameter("@ids", SqlDbType.NVarChar, ids);
            db.AddParameter("@base_type", SqlDbType.NVarChar, base_type);

            DataSet ds = db.ExecuteSP();
            db.Dispose();

            return ds;
        }

        public static Boolean SendConfirmation(string ids, string base_type)
        {
            database db = new database();
            db.ClearParameters();

            db.SPName = "dbo.spUserConfirmation_SendConfirmation";
            db.AddParameter("@ids", SqlDbType.NVarChar, ids);
            db.AddParameter("@base_type", SqlDbType.NVarChar, base_type);
            db.AddParameter("@user_id", SqlDbType.NVarChar, statics.GetLogonUsername());

            DataSet ds = db.ExecuteSP();
            db.Dispose();

            return true;
        }

        public static DataSet GetData(string base_id, string base_type, string page_type)
        {
            database db = new database();
            db.ClearParameters();

            db.SPName = "dbo.spUserConfirmation_GetData";
            db.AddParameter("@base_id", SqlDbType.NVarChar, base_id);
            db.AddParameter("@base_type", SqlDbType.NVarChar, base_type);
            db.AddParameter("@page_type", SqlDbType.NVarChar, page_type);
            db.AddParameter("@user_id", SqlDbType.NVarChar, statics.GetLogonUsername());

            DataSet ds = db.ExecuteSP();
            db.Dispose();

            return ds;
        }

        public static Boolean Save(DataModel.UserConfirmationDetail du)
        {
            database db = new database();
            db.ClearParameters();

            db.SPName = "dbo.spUserConfirmation_Save";
            db.AddParameter("@id", SqlDbType.NVarChar, du.id);
            db.AddParameter("@quantity", SqlDbType.NVarChar, du.quantity);
            db.AddParameter("@quality", SqlDbType.NVarChar, du.quality);
            db.AddParameter("@status_id", SqlDbType.NVarChar, du.status_id);
            db.AddParameter("@user_id", SqlDbType.NVarChar, statics.GetLogonUsername());

            DataSet ds = db.ExecuteSP();
            db.Dispose();
            ds.Dispose();

            return true;
        }

        public static Boolean UpdateStatus(DataModel.UserConfirmationDetail du)
        {
            if (String.IsNullOrEmpty(du.is_notification_sent))
            {
                du.is_notification_sent = "-1";
            }

            if (String.IsNullOrEmpty(du.user_id))
            {
                du.user_id = statics.GetLogonUsername();
            }

            database db = new database();
            db.ClearParameters();

            db.SPName = "dbo.spUserConfirmation_UpdateStatus";
            db.AddParameter("@id", SqlDbType.NVarChar, du.id);
            db.AddParameter("@status_id", SqlDbType.NVarChar, du.status_id);
            db.AddParameter("@additional_person", SqlDbType.NVarChar, du.additional_person);
            db.AddParameter("@is_sent", SqlDbType.NVarChar, du.is_notification_sent);
            db.AddParameter("@user_id", SqlDbType.NVarChar, du.user_id);

            DataSet ds = db.ExecuteSP();
            db.Dispose();
            ds.Dispose();

            return true;
        }

        public static DataSet GetList(string startDate, string endDate, string status, string cifor_office)
        {
            database db = new database();
            db.ClearParameters();

            db.SPName = "dbo.spUserConfirmation_GetList";
            db.AddParameter("@startDate", SqlDbType.NVarChar, startDate);
            db.AddParameter("@endDate", SqlDbType.NVarChar, endDate);
            db.AddParameter("@status", SqlDbType.NVarChar, status);
            db.AddParameter("@cifor_office", SqlDbType.NVarChar, cifor_office);
            db.AddParameter("@user_id", SqlDbType.NVarChar, statics.GetLogonUsername());

            DataSet ds = db.ExecuteSP();
            db.Dispose();

            return ds;
        }

        public class Main
        {
            public class ConfirmationOutput
            {
                public string id { get; set; }
                public string confirmation_code { get; set; }
            }

            public static ConfirmationOutput Save(DataModel.UserConfirmation du)
            {
                database db = new database();
                db.ClearParameters();

                db.SPName = "dbo.spUserConfirmation_Save";
                db.AddParameter("@id", SqlDbType.NVarChar, du.id);
                db.AddParameter("@confirmation_code", SqlDbType.NVarChar, du.confirmation_code);
                db.AddParameter("@document_no", SqlDbType.NVarChar, du.document_no);
                db.AddParameter("@user_id", SqlDbType.NVarChar, statics.GetLogonUsername());

                DataSet ds = db.ExecuteSP();
                ConfirmationOutput output = new ConfirmationOutput();

                if (ds.Tables[0].Rows.Count > 0)
                {
                    output.id = ds.Tables[0].Rows[0]["id"].ToString();
                    output.confirmation_code = ds.Tables[0].Rows[0]["confirmation_code"].ToString();
                }

                db.Dispose();
                ds.Dispose();

                return output;
            }

            public static void UpdateStatusConfirmation(string id)
            {
                database db = new database();
                db.ClearParameters();

                db.SPName = "dbo.spProcurement_UpdateUserConfirmationStatus";
                db.AddParameter("@id", SqlDbType.NVarChar, id);
                db.AddParameter("@user_id", SqlDbType.NVarChar, statics.GetLogonUsername());

                DataSet ds = db.ExecuteSP();
            }

            public static DataSet GetData(string id, string type)
            {
                database db = new database();
                db.ClearParameters();

                db.SPName = "dbo.spUserConfirmation_GetData";
                db.AddParameter("@id", SqlDbType.NVarChar, id);
                db.AddParameter("@type", SqlDbType.NVarChar, type);
                db.AddParameter("@user_id", SqlDbType.NVarChar, statics.GetLogonUsername());

                DataSet ds = db.ExecuteSP();
                db.Dispose();

                return ds;
            }
        }

        public class Detail
        {
            public static Boolean Save(DataModel.UserConfirmationDetail du)
            {
                database db = new database();
                db.ClearParameters();

                db.SPName = "dbo.spUserConfirmationDetail_Save";
                db.AddParameter("@id", SqlDbType.NVarChar, du.id);
                db.AddParameter("@user_confirmation", SqlDbType.NVarChar, du.user_confirmation);
                db.AddParameter("@base_type", SqlDbType.NVarChar, du.base_type);
                db.AddParameter("@base_id", SqlDbType.NVarChar, du.base_id);
                db.AddParameter("@send_quantity", SqlDbType.NVarChar, du.send_quantity);
                db.AddParameter("@quantity", SqlDbType.NVarChar, du.quantity);
                db.AddParameter("@quality", SqlDbType.NVarChar, du.quality);
                db.AddParameter("@additional_person", SqlDbType.NVarChar, du.additional_person);
                db.AddParameter("@status_id", SqlDbType.NVarChar, du.status_id);
                db.AddParameter("@user_id", SqlDbType.NVarChar, statics.GetLogonUsername());

                DataSet ds = db.ExecuteSP();
                db.Dispose();
                ds.Dispose();

                return true;
            }
        }
    }
}
