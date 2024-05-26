using OfficeOpenXml.Style;
using OfficeOpenXml;
using System;
using System.Collections.Generic;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Web;

namespace myTree.WebForms.Procurement.General
{
    public class staticsProcurementReporting
    {
        public static bool can_access_PR_PO()
        {
            database db = new database();
            db.ClearParameters();

            db.SPName = "dbo.spGetReporting_PR_PO_UserAccess";
            db.AddParameter("@emp_user_id", SqlDbType.NVarChar, statics.GetLogonUsername());

            DataSet ds = db.ExecuteSP();
            DataTable dt = ds.Tables[0];
            db.Dispose();
            if (dt.Rows.Count > 0)
                return Convert.ToBoolean(dt.Rows[0]["can_access"]);
            else
                return false;
        }

        public static DataTable GetTeam()
        {
            DataTable dt = new DataTable();
            database db = new database();
            db.ClearParameters();

            db.SPName = "Sp_GetTeam";
            DataSet ds = db.ExecuteSP();
            dt = ds.Tables[0];
            db.Dispose();
            return dt;
        }

        public static void GenerateExcelFileReportSummarizePO(DataTable dt, string filename, string stardate, string enddate, string team, string staffname, string ciforoffice)
        {
            //ExcelPackage.LicenseContext = LicenseContext.NonCommercial;
            ExcelPackage package = new ExcelPackage();

            var worksheet = package.Workbook.Worksheets.Add("sheet 1");
            Color _green = ColorTranslator.FromHtml("#73b147");

            DataTable dtTemp = dt;

            worksheet.Cells["A1:C1"].Merge = true;
            worksheet.Cells["A1"].Value = "Purchase Order Report";
            worksheet.Cells["A1"].Style.Font.Size = 16;
            worksheet.Cells["A1"].Style.Font.Bold = true;
            worksheet.Cells["A3"].Value = "Period";
            worksheet.Cells["B3"].Value = stardate + '-' + enddate;
            worksheet.Cells["A4"].Value = "Procurement office";
            worksheet.Cells["B4"].Value = ciforoffice;
            worksheet.Cells["A5"].Value = "Requester team";
            worksheet.Cells["B5"].Value = team;
            worksheet.Cells["A6"].Value = "Requester";
            worksheet.Cells["B6"].Value = staffname;

            worksheet.Cells[7, 1].LoadFromDataTable(dtTemp, true);
            worksheet.Cells[worksheet.Dimension.Address].AutoFitColumns();
            var headerCells = worksheet.Cells[7, 1, 7, dtTemp.Columns.Count];
            var fill = headerCells.Style.Fill;
            fill.PatternType = ExcelFillStyle.Solid;
            fill.BackgroundColor.SetColor(_green);

            worksheet.Cells[7, 2, dtTemp.Rows.Count + 7, dtTemp.Columns.Count].Style.HorizontalAlignment = ExcelHorizontalAlignment.Left;
            worksheet.Cells[7, 1, dtTemp.Rows.Count + 7, dtTemp.Columns.Count].Style.Border.Top.Style = ExcelBorderStyle.Thin;
            worksheet.Cells[7, 1, dtTemp.Rows.Count + 7, dtTemp.Columns.Count].Style.Border.Left.Style = ExcelBorderStyle.Thin;
            worksheet.Cells[7, 1, dtTemp.Rows.Count + 7, dtTemp.Columns.Count].Style.Border.Right.Style = ExcelBorderStyle.Thin;
            worksheet.Cells[7, 1, dtTemp.Rows.Count + 7, dtTemp.Columns.Count].Style.Border.Bottom.Style = ExcelBorderStyle.Thin;

            worksheet.Cells["A1:A5"].AutoFitColumns();
            worksheet.Column(17).Style.HorizontalAlignment = ExcelHorizontalAlignment.Right;
            worksheet.Column(25).Style.WrapText = true;
            worksheet.Column(21).Style.HorizontalAlignment = ExcelHorizontalAlignment.Right;
            worksheet.Column(22).Style.HorizontalAlignment = ExcelHorizontalAlignment.Right;
            worksheet.Column(23).Style.HorizontalAlignment = ExcelHorizontalAlignment.Right;
            worksheet.Column(26).Style.HorizontalAlignment = ExcelHorizontalAlignment.Right;
            worksheet.Column(28).Style.HorizontalAlignment = ExcelHorizontalAlignment.Right;
            worksheet.Column(29).Style.HorizontalAlignment = ExcelHorizontalAlignment.Right;


            HttpContext.Current.Response.Clear();
            HttpContext.Current.Response.ContentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
            HttpContext.Current.Response.AddHeader("Content-Disposition", string.Format("attachment;filename={0}.xlsx", filename));
            HttpContext.Current.Response.BinaryWrite(package.GetAsByteArray());
            HttpContext.Current.Response.End();
        }

        public static DataTable GetSummarizePOExcel(string startdate, string enddate, string team, string staff_id, string procurement_office)
        {
            DataTable dt = new DataTable();
            database db = new database();
            db.ClearParameters();
            db.SPName = "spPurchaseOrder_GetReportList_Excel";
            db.AddParameter("@startdate", SqlDbType.NVarChar, startdate);
            db.AddParameter("@enddate", SqlDbType.NVarChar, enddate);
            db.AddParameter("@team", SqlDbType.NVarChar, team);
            db.AddParameter("@staff_id", SqlDbType.NVarChar, staff_id);
            db.AddParameter("@procurement_office", SqlDbType.NVarChar, procurement_office);
            dt = db.ExecuteSP().Tables[0];
            db.Dispose();

            return dt;
        }

        public static DataTable GetEmployee(string param)
        {
            DataTable dt = new DataTable();
            database db = new database();
            db.ClearParameters();

            db.SPName = "Sp_GetEmployee";
            db.AddParameter("@team", SqlDbType.NVarChar, param);
            DataSet ds = db.ExecuteSP();
            db.Dispose();
            dt = ds.Tables[0];
            return dt;
        }

        public static DataSet getSummarizePOReport(string startdate, string enddate, string team, string staff_id, string procurement_office)
        {
            database db = new database();
            db.ClearParameters();
            db.SPName = "spPurchaseOrder_GetReportList";
            db.AddParameter("@startdate", SqlDbType.NVarChar, startdate);
            db.AddParameter("@enddate", SqlDbType.NVarChar, enddate);
            db.AddParameter("@team", SqlDbType.NVarChar, team);
            db.AddParameter("@staff_id", SqlDbType.NVarChar, staff_id);
            db.AddParameter("@procurement_office", SqlDbType.NVarChar, procurement_office);
            DataSet ds = db.ExecuteSP();
            db.Dispose();
            return ds;
        }

        public static DataSet getSummarizePRReport(string startdate, string enddate, string prtype, string team, string staff_id, string procurement_office)
        {
            database db = new database();
            db.ClearParameters();
            db.SPName = "spPurchaseRequisition_GetReportList";
            db.AddParameter("@startdate", SqlDbType.NVarChar, startdate);
            db.AddParameter("@enddate", SqlDbType.NVarChar, enddate);
            db.AddParameter("@prtype", SqlDbType.NVarChar, prtype);
            db.AddParameter("@team", SqlDbType.NVarChar, team);
            db.AddParameter("@staff_id", SqlDbType.NVarChar, staff_id);
            db.AddParameter("@procurement_office", SqlDbType.NVarChar, procurement_office);
            DataSet ds = db.ExecuteSP();
            db.Dispose();
            return ds;
        }

        public static DataTable GetSummarizePRExcel(string startdate, string enddate, string prtype, string team, string staff_id, string procurement_office)
        {
            DataTable dt = new DataTable();
            database db = new database();
            db.ClearParameters();
            db.SPName = "spPurchaseRequisition_GetReportList_excel";
            db.AddParameter("@startdate", SqlDbType.NVarChar, startdate);
            db.AddParameter("@enddate", SqlDbType.NVarChar, enddate);
            db.AddParameter("@prtype", SqlDbType.NVarChar, prtype);
            db.AddParameter("@team", SqlDbType.NVarChar, team);
            db.AddParameter("@staff_id", SqlDbType.NVarChar, staff_id);
            db.AddParameter("@procurement_office", SqlDbType.NVarChar, procurement_office);
            dt = db.ExecuteSP().Tables[0];
            db.Dispose();

            return dt;
        }

        public static void GenerateExcelFileReportSummarizePR(DataTable dt, string filename, string stardate, string enddate, string type, string team, string staffname, string ciforoffice)
        {
            //ExcelPackage.LicenseContext = LicenseContext.NonCommercial;
            ExcelPackage package = new ExcelPackage();
            var worksheet = package.Workbook.Worksheets.Add("sheet 1");
            Color _green = ColorTranslator.FromHtml("#73b147");

            DataTable dtTemp = dt;

            worksheet.Cells["A1:C1"].Merge = true;
            worksheet.Cells["A1"].Value = "Purchase Requisition Report";
            worksheet.Cells["A1"].Style.Font.Size = 16;
            worksheet.Cells["A1"].Style.Font.Bold = true;
            worksheet.Cells["A3"].Value = "Period";
            worksheet.Cells["B3"].Value = stardate + '-' + enddate;
            worksheet.Cells["A4"].Value = "Procurement office";
            worksheet.Cells["B4"].Value = ciforoffice;
            worksheet.Cells["A5"].Value = "PR type";
            worksheet.Cells["B5"].Value = type;
            worksheet.Cells["A6"].Value = "Requester team";
            worksheet.Cells["B6"].Value = team;
            worksheet.Cells["A7"].Value = "Requester";
            worksheet.Cells["B7"].Value = staffname;

            worksheet.Cells[8, 1].LoadFromDataTable(dtTemp, true);
            worksheet.Cells[worksheet.Dimension.Address].AutoFitColumns();
            var headerCells = worksheet.Cells[8, 1, 8, dtTemp.Columns.Count];
            var fill = headerCells.Style.Fill;
            fill.PatternType = ExcelFillStyle.Solid;
            fill.BackgroundColor.SetColor(_green);

            worksheet.Cells[8, 2, dtTemp.Rows.Count + 8, dtTemp.Columns.Count].Style.HorizontalAlignment = ExcelHorizontalAlignment.Left;
            worksheet.Cells[8, 1, dtTemp.Rows.Count + 8, dtTemp.Columns.Count].Style.Border.Top.Style = ExcelBorderStyle.Thin;
            worksheet.Cells[8, 1, dtTemp.Rows.Count + 8, dtTemp.Columns.Count].Style.Border.Left.Style = ExcelBorderStyle.Thin;
            worksheet.Cells[8, 1, dtTemp.Rows.Count + 8, dtTemp.Columns.Count].Style.Border.Right.Style = ExcelBorderStyle.Thin;
            worksheet.Cells[8, 1, dtTemp.Rows.Count + 8, dtTemp.Columns.Count].Style.Border.Bottom.Style = ExcelBorderStyle.Thin;

            worksheet.Cells["A1:A5"].AutoFitColumns();
            worksheet.Column(14).Style.HorizontalAlignment = ExcelHorizontalAlignment.Right;
            worksheet.Column(15).Style.HorizontalAlignment = ExcelHorizontalAlignment.Right;
            worksheet.Column(17).Style.HorizontalAlignment = ExcelHorizontalAlignment.Right;
            worksheet.Column(21).Style.HorizontalAlignment = ExcelHorizontalAlignment.Right;

            HttpContext.Current.Response.Clear();
            HttpContext.Current.Response.ContentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
            HttpContext.Current.Response.AddHeader("Content-Disposition", string.Format("attachment;filename={0}.xlsx", filename));
            HttpContext.Current.Response.BinaryWrite(package.GetAsByteArray());
            HttpContext.Current.Response.End();
        }
    }
}
