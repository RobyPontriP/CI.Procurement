using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using Newtonsoft.Json;
using myTree.WebForms.Procurement.General;

namespace myTree.WebForms.Modules.Item
{
    public partial class Render : System.Web.UI.Page
    {
        private static int start;
        private static int length;
        private static int draw;
        private static string search;
        private static string orderby;
        private Dictionary<string, string> dictSearch = new Dictionary<string, string>();
        private Dictionary<string, string> dictOrder = new Dictionary<string, string>();
        private Dictionary<string, string> dictOrderDirection = new Dictionary<string, string>();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Request.HttpMethod == "POST")
            {

                length = Request.Form["length"] == null ? 1 : int.Parse(Request.Form["length"]);
                draw = Request.Form["draw"] == null ? 1 : int.Parse(Request.Form["draw"]);
                start = Request.Form["start"] == null ? 1 : int.Parse(Request.Form["start"]);

                search = Request.Form["search[value]"];
                dictSearch = new Dictionary<string, string>();
                dictOrder = new Dictionary<string, string>();

                int sortColumn = -1;
                string sortDirection = "asc";
                string colName = "";
                if (length == -1)
                {
                    length = TOTAL_ROWS;
                }


                for (int i = 0; i < Request.Form.AllKeys.Count(); i++)
                {
                    //if (!string.IsNullOrEmpty(Request.Form["columns[" + i + "][search][value]"]))
                    //dictSearch.Add(GetColumnName(i), Request.Form["columns[" + i + "][search][value]"]);

                    if (!string.IsNullOrEmpty(search))
                    {
                        if (i != 8) //filter by status
                        {
                            colName = GetColumnName(i);
                            if (!dictSearch.ContainsKey(colName) && !String.IsNullOrEmpty(colName))
                            {
                                dictSearch.Add(colName, search);
                            }
                        }
                    }
                    if (!string.IsNullOrEmpty(Request.Form["order[" + i + "][column]"]))
                        dictOrder.Add(GetColumnName(int.Parse(Request.Form["order[" + i + "][column]"])), Request.Form["order[" + i + "][dir]"]);
                    //if (!string.IsNullOrEmpty(Request.Form["order[" + i + "][dir]"]))
                    //    dictOrderDirection.Add(GetColumnName(i), Request.Form["order[" + i + "][dir]"]);
                }

                string paramSearch = string.Join(" OR ", dictSearch.Select(x => x.Key + " LIKE '%" + x.Value.Replace("'", "''") + "%'").ToArray());

                string item_status = Request.Form["item_status"] == null ? "" : Request.Form["item_status"];
                if (!string.IsNullOrEmpty(item_status))
                {
                    search = " is_item_active = " + item_status + " ";
                    if (!string.IsNullOrEmpty(paramSearch))
                    {
                        search = search + " AND (" + paramSearch + ") ";
                    }
                }
                else
                {
                    search = paramSearch;
                }

                orderby = string.Join(",", dictOrder.Select(x => x.Key + " " + x.Value).ToArray());
                DataTableData dataTableData = new DataTableData();
                dataTableData.draw = draw;
                dataTableData.recordsTotal = TOTAL_ROWS;
                //int recordsFiltered = 0;
                //dataTableData.data = FilterData(ref recordsFiltered, start, length, search, sortColumn, sortDirection);
                dataTableData.data = CreateData();
                dataTableData.recordsFiltered = FILTERED_ROWS;

                Response.Clear();
                Response.ContentType = "application/json; charset=utf-8";
                Response.Write(JsonConvert.SerializeObject(dataTableData));
                Response.End();
            }
        }

        private static int TOTAL_ROWS = 0;
        private static int FILTERED_ROWS = 0;
        private static readonly List<ItemList> _data = CreateData();

        public class ItemList
        {
            public string id { get; set; }
            public string item_code { get; set; }
            public string sun_code { get; set; }
            public string sun_long_desc { get; set; }
            public string description { get; set; }
            public string category_name { get; set; }
            public string subcategory_name { get; set; }
            public string brand_name { get; set; }
            public string uom_name { get; set; }
            public string item_active_label { get; set; }
        }

        private string GetColumnName(int index)
        {
            string columnName = string.Empty;
            switch (index)
            {
                case 0:
                    columnName = "item_code";
                    break;
                case 1:
                    columnName = "sun_code";
                    break;
                case 2:
                    columnName = "sun_long_desc";
                    break;
                case 3:
                    columnName = "description";
                    break;
                case 4:
                    columnName = "category_name";
                    break;
                case 5:
                    columnName = "subcategory_name";
                    break;
                case 6:
                    columnName = "brand_name";
                    break;
                case 7:
                    columnName = "uom_name";
                    break;
                case 8:
                    columnName = "is_item_active";
                    break;
                default:
                    break;
            }
            return columnName;
        }
        public class DataTableData
        {
            public int draw { get; set; }
            public int recordsTotal { get; set; }
            public int recordsFiltered { get; set; }
            public List<ItemList> data { get; set; }
        }

        private static List<ItemList> CreateData()
        {
            DataSet ds = staticsMaster.Item.GetList(length, start, !string.IsNullOrEmpty(search) ? " AND (" + search + ")" : "", orderby);
            DataTable dtdata = ds.Tables[0];
            TOTAL_ROWS = int.Parse(ds.Tables[1].Rows[0]["COUNTER"].ToString());
            FILTERED_ROWS = int.Parse(ds.Tables[2].Rows[0]["COUNTER"].ToString());
            return JsonConvert.DeserializeObject<List<ItemList>>(JsonConvert.SerializeObject(dtdata));
        }

        private int SortString(string s1, string s2, string sortDirection)
        {
            return sortDirection == "asc" ? s1.CompareTo(s2) : s2.CompareTo(s1);
        }

        private int SortInteger(string s1, string s2, string sortDirection)
        {
            int i1 = int.Parse(s1);
            int i2 = int.Parse(s2);
            return sortDirection == "asc" ? i1.CompareTo(i2) : i2.CompareTo(i1);
        }

        private int SortDateTime(string s1, string s2, string sortDirection)
        {
            DateTime d1 = DateTime.Parse(s1);
            DateTime d2 = DateTime.Parse(s2);
            return sortDirection == "asc" ? d1.CompareTo(d2) : d2.CompareTo(d1);
        }

        // here we simulate SQL search, sorting and paging operations
        // !!!! DO NOT DO THIS IN REAL APPLICATION !!!!
        private List<ItemList> FilterData(ref int recordFiltered, int start, int length, string search, int sortColumn, string sortDirection)
        {
            List<ItemList> list = CreateData();
            recordFiltered = list.Count;
            return CreateData();
        }
    }
}