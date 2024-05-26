//using myTree.WebForms.Master;
using myTree.WebForms.Procurement.General;
using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Xml;

namespace myTree.WebForms.Modules.BusinessPartner
{
    public partial class ExportToXML : System.Web.UI.Page
    {
        protected string id = string.Empty;
        protected string type = string.Empty;
        protected string code = string.Empty;

        protected void Page_Load(object sender, EventArgs e)
        {
            string filename = "";

            id = Request.QueryString["id"] ?? "";
            type = Request.QueryString["type"] ?? "";
            code = Request.QueryString["code"] ?? "";

            type = type.ToLower();

            if (!string.IsNullOrEmpty(id))
            {
                XmlDocument xdoc = new XmlDocument();

                database db = new database();
                db.ClearParameters();

                if (type == "address")
                {
                    db.SPName = "dbo.spVendor_ExportToXMLAddress";
                    filename = "address_export";
                }
                else if (type == "supplier")
                {
                    db.SPName = "dbo.spVendor_ExportToXMLSupplier";
                    filename = "supplier_export";
                }
                db.AddParameter("@id", SqlDbType.NVarChar, id);

                //xdoc = db.ExecuteSPtoXML();
                db.Dispose();

                MemoryStream ms = new MemoryStream();
                using (XmlWriter writer = XmlWriter.Create(ms))
                {
                    xdoc.WriteTo(writer); // Write to memorystream
                }

                byte[] data = ms.ToArray();
                HttpContext.Current.Response.Clear();
                HttpContext.Current.Response.ContentType = "text/xml";
                HttpContext.Current.Response.AddHeader("Content-Disposition:",
                                    "attachment;filename=" + HttpUtility.UrlEncode(filename + "_" + code + "_" + DateTime.Now.ToString("ddMMyyyy_hhmmss") + ".xml")); // Replace with name here
                HttpContext.Current.Response.BinaryWrite(data);
                HttpContext.Current.Response.End();
                ms.Flush(); // Probably not needed
                ms.Close();
            }
        }
    }
}