using System;
using System.Configuration;
using System.Data.SqlClient;

namespace myTree.WebForms.Procurement.General
{
    public class connection
    {
        //variable list
        private string strCon = "";

        private SqlConnection conn;
        public SqlConnection oConnection
        {
            get { return conn; }
        }

        private bool trusted_connection;
        public bool TrustedConnection
        {
            get { return trusted_connection; }
            set { trusted_connection = value; }
        }

        private string database_server;
        public string DatabaseServer
        {
            get { return database_server; }
            set { database_server = value; }
        }

        private string database_catalog;
        public string DatabaseCatalog
        {
            get { return database_catalog; }
            set { database_catalog = value; }
        }

        private string database_user;
        public string DatabaseUser
        {
            get { return database_user; }
            set { database_user = value; }
        }

        private string database_password;
        public string DatabasePassword
        {
            get { return database_password; }
            set { database_password = value; }
        }

        private static int database_timeout;
        public int DatabaseTimeout
        {
            get { return database_timeout; }
            set { database_timeout = value; }
        }


        public connection()
        {
            trusted_connection = bool.Parse(ConfigurationManager.AppSettings["trusted_connection"]);
            database_server = ConfigurationManager.AppSettings["database_server"];
            database_catalog = ConfigurationManager.AppSettings["database_app_catalog"];
            database_user = ConfigurationManager.AppSettings["database_user"];
            database_password = ConfigurationManager.AppSettings["database_password"];
            database_timeout = Int16.Parse(ConfigurationManager.AppSettings["database_timeout"]);
        }

        public string GetConnectionString()
        {
            string strTimeOut = "; Connection Timeout=" + database_timeout.ToString();

            if (trusted_connection)
                strCon = "Data Source=" + database_server + ";Initial Catalog=" + database_catalog + ";Integrated Security=SSPI;";
            else
                strCon = "User ID=" + database_user + ";Password=" + database_password + ";Initial Catalog=" + database_catalog + ";Data Source=" + database_server; //+strTimeOut;

            return strCon;
        }

        //public SqlConnection OpenConnection()
        public void OpenConnection()
        {
            GetConnectionString();

            conn = new SqlConnection(strCon);

            if (conn.State == System.Data.ConnectionState.Closed) conn.Open();


            //return conn;
        }

        //IDisposable Members
        public void Dispose()
        {
            if (conn != null)
            {
                conn.Close();
                conn.Dispose();
            }
        }

    }
}
