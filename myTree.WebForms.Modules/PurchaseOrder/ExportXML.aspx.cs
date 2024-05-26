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

namespace Procurement.PurchaseOrder
{
    public partial class ExportXML : System.Web.UI.Page
    {
        protected string id = string.Empty;

        protected void Page_Load(object sender, EventArgs e)
        {
            id = Request.QueryString["id"] ?? "";
            if (!string.IsNullOrEmpty(id))
            {
                XmlDocument xdoc = new XmlDocument();

                string po_number = staticsPurchaseOrder.GetNumberDetail(id);

                database db = new database();
                db.ClearParameters();

                db.SPName = "dbo.spPurchaseOrder_ExportToXML";
                db.AddParameter("@id", SqlDbType.NVarChar, id);

                xdoc = db.ExecuteSPtoXML();
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
                                    "attachment;filename=" + HttpUtility.UrlEncode("poexport_" + po_number + "_"+DateTime.Now.ToString("ddMMyyyy_hhmmss")+".xml")); // Replace with name here
                HttpContext.Current.Response.BinaryWrite(data);
                HttpContext.Current.Response.End();
                ms.Flush(); // Probably not needed
                ms.Close();
            }
        }
    }
}