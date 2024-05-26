using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Xml;

namespace myTree.WebForms.Procurement.General
{
    public class database
    {
        //Variable list
        private string spname;
        public string SPName
        {
            get { return spname; }
            set { spname = value; }
        }

        //private static SqlConnection con;
        private connection clscon;

        private List<SqlParameter> parameters = new List<SqlParameter>();

        //public Database() { new Database("", "", "", ""); }
        public database() { InitDatabase("", "", "", ""); }

        //public Database(string DatabaseServer) { new Database(DatabaseServer, "", "", ""); }
        public database(string DatabaseServer) { InitDatabase(DatabaseServer, "", "", ""); }

        //public Database(string DatabaseServer, string DatabaseCatalog) { new Database(DatabaseServer, DatabaseCatalog, "", ""); }
        public database(string DatabaseServer, string DatabaseCatalog) { InitDatabase(DatabaseServer, DatabaseCatalog, "", ""); }

        //public Database(string DatabaseServer, string DatabaseCatalog, string DatabaseUsername) { new Database(DatabaseServer, DatabaseCatalog, DatabaseUsername, ""); }
        public database(string DatabaseServer, string DatabaseCatalog, string DatabaseUsername) { InitDatabase(DatabaseServer, DatabaseCatalog, DatabaseUsername, ""); }

        public database(string DatabaseServer, string DatabaseCatalog, string DatabaseUsername, string DatabasePassword)
        {
            //update
            InitDatabase(DatabaseServer, DatabaseCatalog, DatabaseUsername, DatabasePassword);
        }

        private void InitDatabase(string DatabaseServer, string DatabaseCatalog, string DatabaseUsername, string DatabasePassword)
        {
            ClearParameters();

            clscon = new connection();

            if (DatabaseServer != "") clscon.DatabaseServer = DatabaseServer;
            if (DatabaseCatalog != "") clscon.DatabaseCatalog = DatabaseCatalog;
            if (DatabaseUsername != "") clscon.DatabaseUser = DatabaseUsername;
            if (DatabasePassword != "") clscon.DatabasePassword = DatabasePassword;

            //con = clscon.OpenConnection();
        }

        public void AddParameter(string ParameterName, SqlDbType ParameterType, object ParameterValue)
        {
            SqlParameter param = new SqlParameter();
            param.ParameterName = ParameterName;
            param.SqlDbType = ParameterType;
            param.Value = ParameterValue;
            param.Direction = ParameterDirection.Input;

            parameters.Add(param);
        }

        public void ClearParameters()
        {
            parameters.Clear();
            spname = "";
        }

        public DataSet ExecuteSP()
        {
            return ExecuteSP(spname);
        }

        public DataSet ExecuteSP(string SPName)
        {
            DataSet dsData = new DataSet();

            try
            {
                clscon.OpenConnection();
                SqlDataAdapter da;
                //SqlCommand cmd = con.CreateCommand();
                SqlCommand cmd = clscon.oConnection.CreateCommand();
                cmd.Parameters.Clear();
                cmd.CommandText = SPName;
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.CommandTimeout = clscon.DatabaseTimeout;

                foreach (SqlParameter parameter in parameters)
                {
                    SqlParameter parm = new SqlParameter(parameter.ParameterName, parameter.SqlDbType);
                    parm.Value = parameter.Value;
                    parm.Direction = parameter.Direction;
                    cmd.Parameters.Add(parm);

                    //cmd.Parameters.Add(parameter.ParameterName, parameter.SqlDbType).Value = parameter.Value;
                }

                da = new SqlDataAdapter(cmd);
                da.Fill(dsData);
                da.Dispose();

                clscon.Dispose();
            }
            catch (Exception ex)
            {
                this.Dispose();
                throw new Exception("SP Name: " + SPName + "\n\n" + ex.ToString());
            }

            return dsData;
        }

        public int ExecuteSPtoString()
        {
            int strValue = 0;
            try
            {
                clscon.OpenConnection();
                //SqlDataAdapter da;
                //SqlCommand cmd = con.CreateCommand();
                SqlCommand cmd = clscon.oConnection.CreateCommand();

                cmd.CommandText = SPName;
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.CommandTimeout = clscon.DatabaseTimeout;

                foreach (SqlParameter parameter in parameters)
                {
                    SqlParameter parm = new SqlParameter(parameter.ParameterName, parameter.SqlDbType);
                    parm.Value = parameter.Value;
                    parm.Direction = parameter.Direction;
                    cmd.Parameters.Add(parm);
                }
                strValue = (int)cmd.ExecuteScalar();
                //con.Close();
                clscon.Dispose();
            }
            catch (Exception ex)
            {
                this.Dispose();
                throw new Exception("SP Name: " + SPName + "\n\n" + ex.ToString());
            }

            return strValue;
        }

        public XmlDocument ExecuteSPtoXML()
        {
            XmlDocument xdoc = new XmlDocument();
            try
            {
                clscon.OpenConnection();
                //SqlDataAdapter da;
                //SqlCommand cmd = con.CreateCommand();
                SqlCommand cmd = clscon.oConnection.CreateCommand();

                cmd.CommandText = SPName;
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.CommandTimeout = clscon.DatabaseTimeout;

                foreach (SqlParameter parameter in parameters)
                {
                    SqlParameter parm = new SqlParameter(parameter.ParameterName, parameter.SqlDbType);
                    parm.Value = parameter.Value;
                    parm.Direction = parameter.Direction;
                    cmd.Parameters.Add(parm);
                }

                XmlReader reader = cmd.ExecuteXmlReader();
                if (reader.Read())
                {
                    xdoc.Load(reader);
                }
                clscon.Dispose();
            }
            catch (Exception ex)
            {
                this.Dispose();
                throw new Exception("SP Name: " + SPName + "\n\n" + ex.ToString());
            }

            return xdoc;
        }

        public DataSet ExecuteQuery(string query)
        {
            DataSet ds = new DataSet();
            //clscon = new Connection();

            //if (con.State == ConnectionState.Closed)
            //    con = clscon.OpenConnection();

            try
            {
                clscon.OpenConnection();
                SqlDataAdapter da;
                //SqlCommand cmd = con.CreateCommand();
                SqlCommand cmd = clscon.oConnection.CreateCommand();

                cmd.CommandText = query;
                cmd.CommandType = CommandType.Text;
                cmd.CommandTimeout = clscon.DatabaseTimeout;

                da = new SqlDataAdapter(cmd);
                da.Fill(ds);
                da.Dispose();
                clscon.Dispose();
            }
            catch (Exception ex)
            {
                this.Dispose();
                throw new Exception("Execute query error. \n\n" + ex.ToString());
            }


            return ds;
        }

        //IDisposable Members
        public void Dispose()
        {
            clscon.Dispose();
            //con.Close();
            //con.Dispose();
        }
    }
}
