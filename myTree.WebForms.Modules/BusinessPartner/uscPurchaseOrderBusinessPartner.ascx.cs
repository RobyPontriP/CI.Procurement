using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using OfficeOpenXml;
using OfficeOpenXml.Style;
using System.Drawing;
using myTree.WebForms.Procurement.General;

namespace myTree.WebForms.Modules.BusinessPartner
{
    public partial class uscPurchaseOrderBusinessPartner : System.Web.UI.UserControl
    {
        
        protected string listPR = string.Empty;
        protected string vendor_id = "";

        private class MainList
        {
            public string id { get; set; }
            public string po_no { get; set; }
            public string po_sun_code { get; set; }
            public string document_date { get; set; }
            public string vendor { get; set; }
            public string vendor_name { get; set; }
            public string delivery_date { get; set; }
            public string currency_id { get; set; }
            public string total_amount { get; set; }
            public string total_amount_usd { get; set; }
            public string remarks { get; set; }
            public string status { get; set; }
            public string status_id { get; set; }
            public string color_code { get; set; }
            public string font_color { get; set; }
            public string actions { get; set; }
            public string details { get; set; }
        }
        protected void Page_Load(object sender, EventArgs e)
        {
            vendor_id = Request.QueryString["id"];

            DataSet ds = staticsPurchaseOrder.Main.GetListBP_PO(vendor_id);

            if (ds.Tables.Count > 0)
            {
                List<MainList> lm = new List<MainList>();
                foreach (DataRow drM in ds.Tables[0].Rows)
                {
                    MainList m = new MainList();
                    m.id = drM["id"].ToString();
                    m.po_no = drM["po_no"].ToString();
                    m.po_sun_code = drM["po_sun_code"].ToString();
                    m.document_date = drM["document_date"].ToString();
                    m.vendor = drM["vendor"].ToString();
                    m.vendor_name = drM["vendor_name"].ToString();
                    m.delivery_date = drM["delivery_date"].ToString();
                    m.currency_id = drM["currency_id"].ToString();
                    m.total_amount = drM["total_amount"].ToString();
                    m.total_amount_usd = drM["total_amount_usd"].ToString();
                    m.remarks = drM["remarks"].ToString();
                    m.status = drM["status_name"].ToString();
                    m.status_id = drM["status_id"].ToString();
                    m.font_color = drM["font_color"].ToString();
                    m.color_code = drM["color_code"].ToString();
                    DataTable dtD = new DataTable();
                    //dtD = ds.Tables[1].Select("id='" + m.id + "'","line_number asc").CopyToDataTable();
                    var rows = ds.Tables[1].AsEnumerable()
                        .Where(x => (string)x["id"].ToString() == m.id)
                        .OrderBy(x => x["line_number"]);

                    if (rows.Any())
                        dtD = rows.CopyToDataTable();

                    m.details = JsonConvert.SerializeObject(dtD);
                    lm.Add(m);
                }
                listPR = JsonConvert.SerializeObject(lm);
            }

            //Export to excel
            if (IsPostBack)
            {
                string fileName = string.Format("PO_related");
                DataTable dt = staticsMaster.Vendor.GetDataPORelated(vendor_id).Tables[0];

                if (Request.Form["btnExport"] == "Export to excel")
                    GenerateExcel_POrelated(dt, fileName);
            }
        }
        public static void GenerateExcel_POrelated(DataTable dt, string filename)
        {
            ExcelPackage package = new ExcelPackage();
            var worksheet = package.Workbook.Worksheets.Add("sheet 1");
            //Color _green = ColorTranslator.FromHtml("#73b147");

            DataTable dtTemp = dt;

            worksheet.Cells["A1:C1"].Merge = true;
            worksheet.Cells["A1"].Value = "PO related";
            worksheet.Cells["A1"].Style.Font.Size = 16;
            worksheet.Cells["A1"].Style.Font.Bold = true;

            worksheet.Cells[3, 1].LoadFromDataTable(dtTemp, true);
            worksheet.Cells[worksheet.Dimension.Address.ToString()].AutoFitColumns();
            //worksheet.Cells[worksheet.Dimension.Address.ToString()].AutoFilter = true;
            var headerCells = worksheet.Cells[3, 1, 3, dtTemp.Columns.Count];
            var fill = headerCells.Style.Fill;
            fill.PatternType = ExcelFillStyle.Solid;
            //fill.BackgroundColor.SetColor(_green);
            fill.BackgroundColor.SetColor(Color.LightBlue);

            worksheet.Cells[3, 1, dtTemp.Rows.Count + 3, dtTemp.Columns.Count].Style.Border.Top.Style = ExcelBorderStyle.Thin;
            worksheet.Cells[3, 1, dtTemp.Rows.Count + 3, dtTemp.Columns.Count].Style.Border.Left.Style = ExcelBorderStyle.Thin;
            worksheet.Cells[3, 1, dtTemp.Rows.Count + 3, dtTemp.Columns.Count].Style.Border.Right.Style = ExcelBorderStyle.Thin;
            worksheet.Cells[3, 1, dtTemp.Rows.Count + 3, dtTemp.Columns.Count].Style.Border.Bottom.Style = ExcelBorderStyle.Thin;
            worksheet.Column(9).Style.HorizontalAlignment = ExcelHorizontalAlignment.Right;
            worksheet.Column(10).Style.HorizontalAlignment = ExcelHorizontalAlignment.Right;
            worksheet.Column(20).Style.HorizontalAlignment = ExcelHorizontalAlignment.Right;
            worksheet.Column(21).Style.HorizontalAlignment = ExcelHorizontalAlignment.Right;

            worksheet.Cells["A1:A2"].AutoFitColumns();
            worksheet.Cells[3, 1, dtTemp.Rows.Count + 3, dtTemp.Columns.Count].AutoFitColumns();

            HttpContext.Current.Response.Clear();
            HttpContext.Current.Response.ContentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
            HttpContext.Current.Response.AddHeader("Content-Disposition", string.Format("attachment;filename={0}.xlsx", filename));
            HttpContext.Current.Response.BinaryWrite(package.GetAsByteArray());
            HttpContext.Current.Response.End();
        }
    }
}