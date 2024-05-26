//using myTree.WebForms.K2Helper;
using myTree.WebForms.Procurement.General;
using myTree.WebForms.Procurement.General.K2Helper.PurchaseOrder;
using myTree.WebForms.Procurement.General.K2Helper.PurchaseOrder.Models;
using myTree.WebForms.Procurement.Notification;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.IO;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Web;
using System.Web.Services;

namespace myTree.WebForms.Modules
{
    public partial class Service : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!HttpContext.Current.User.Identity.IsAuthenticated)
            {
                //HttpContext.Current.GetOwinContext().Authentication.Challenge();
            }
            string result = "", message = "", _id = "";
            try
            {
                string action, doc_id, doc_type, is_cancel, file_name, docidtemp;
                action = Request.Form["action"] ?? "";
                doc_id = Request.Form["doc_id"] ?? "";
                doc_type = Request.Form["doc_type"] ?? "";
                doc_type = doc_type.Replace(" ", string.Empty);
                is_cancel = Request.Form["is_cancel"] ?? "";
                file_name = Request.Form["file_name"] ?? "";
                docidtemp = Request.Form["docidtemp"] ?? "";

                if (file_name.EndsWith(","))
                {
                    file_name = file_name.Remove(file_name.Length - 1);
                }

                if (action.ToLower() == "upload" && !String.IsNullOrEmpty(doc_id) && !String.IsNullOrEmpty(doc_type))
                {
                    string path = Server.MapPath(doc_type + "/Files/" + doc_id.Replace(",", ""));

                    if (!Directory.Exists(path))
                    {
                        Directory.CreateDirectory(path);
                    }
                    for (int i = 0; i < Request.Files.Count; i++)
                    {
                        if (Request.Files[i].FileName != "")
                        {
                            HttpPostedFile file = Request.Files[i];
                            file.SaveAs(path + "/" + System.IO.Path.GetFileName(file.FileName));


                        }
                    }
                }
                else if (action.ToLower() == "fileupload")
                {
                    #region UploadFileAPI
                    List<string> fileNames = new List<string>();
                    for (int i = 0; i < Request.Files.Count; i++)
                    {
                        if (Request.Files[i].FileName != "")
                        {
                            fileNames.Add(Request.Files[i].FileName);
                        }
                    }

                    for (int i = 0; i < Request.Files.Count; i++)
                    {
                        if (Request.Files[i].FileName != "")
                        {
                            byte[] fileData = null;
                            using (var binaryReader = new BinaryReader(Request.Files[i].InputStream))
                            {
                                MemoryStream ms = new MemoryStream();
                                Request.Files[i].InputStream.CopyTo(ms);
                                fileData = ms.ToArray();
                            }

                            if (!string.IsNullOrEmpty(file_name))
                            {
                                if (Request.Files[i].FileName == file_name)
                                {
                                    result = FileUpload(doc_id, docidtemp, fileData, Request.Files[i].FileName, fileNames.ToArray(), doc_type);
                                }
                            }
                            //else
                            //{
                            //    FileUpload(doc_id, pridtemp, fileData, Request.Files[i].FileName, fileNames.ToArray());
                            //}
                        }
                    }

                    if (string.IsNullOrEmpty(file_name))
                    {
                        result = FileUpload(doc_id, docidtemp, new byte[0], "", fileNames.ToArray(), doc_type);
                    }
                    #endregion
                }

                if (!String.IsNullOrEmpty(is_cancel) && doc_type.ToLower() == "purchaserequisition")
                {
                    NotificationHelper.PR_Cancelled(doc_id);
                }
                //result = "success";


                _id = doc_id;


                // logic bypass pr kebutuhan untuk training 
                //if (Request.PathInfo.ToLower() == "/updatepr")
                //{   
                //    _id = Request.QueryString["id"] ?? "";
                //    statics.GetUpdatePR(_id);
                //    message = "update pr";
                //    result = "success";

                //}

                //if (Request.PathInfo.ToLower() == "/resetpr")
                //{
                //    _id = Request.QueryString["id"] ?? "";
                //    statics.GetResetPR(_id);
                //    message = "reset pr";
                //    result = "success";
                //}
                //end logic bypass pr kebutuhan untuk training 

            }
            catch (Exception ex)
            {
                result = "error";
                message = ex.ToString();
            }
            Response.Write(JsonConvert.SerializeObject(new
            {
                result = result,
                message = message,
                id = _id
            }));
        }

        private string FileUpload(string id, string tempId, byte[] file, string fileName, string[] fileNames, string doc_type)
        {
            string prid = string.IsNullOrEmpty(id) ? tempId : id;
            string dirPath = HttpContext.Current.Server.MapPath(doc_type);
            string result;
            if (string.IsNullOrEmpty(id))
            {
                result = FileUpload(prid, file, fileName, dirPath + "\\FilesTemp");
            }
            else
            {
                if (Directory.Exists(dirPath + "\\FilesTemp\\" + tempId))
                {
                    result = FileUploadMove(dirPath + "\\FilesTemp\\" + tempId, dirPath + "\\Files\\" + id, fileNames);
                }
                else
                {
                    result = FileUpload(prid, file, fileName, dirPath + "\\Files\\");
                }
            }

            return result;
        }

        [WebMethod]
        public string FileUpload(string id, byte[] file, string fileName, string targetPath)
        {
            string result = "";
            string accessToken = AccessControl.GetAccessToken();
            try
            {
                HttpClient client = new HttpClient();
                client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", accessToken);
                //System.Net.ServicePointManager.ServerCertificateValidationCallback = delegate { return true; };

                if (!string.IsNullOrEmpty(fileName))
                {
                    MultipartFormDataContent form = new MultipartFormDataContent
                {
                    { new StringContent(id), "Id" },
                    { new ByteArrayContent(file), "File", fileName },
                    { new StringContent(targetPath), "TargetPath" }
                };
                    var resultapi = client.PostAsync(statics.GetSetting("file_upload_api") + "/Upload", form).Result;
                    resultapi.EnsureSuccessStatusCode();
                    if (resultapi.IsSuccessStatusCode)
                    {
                        result = resultapi.Content.ReadAsStringAsync().Result;
                    }
                }

                return result;
            }
            catch (Exception e)
            {
                ExceptionHelpers.PrintError(e);
                result = e.Message;
                return result;
            }
        }

        private string FileUploadMove(string originalPath, string destinationPath, string[] fileNames)
        {
            string result = "";
            string accessToken = AccessControl.GetAccessToken();
            try
            {
                HttpClient client = new HttpClient();
                client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", accessToken);
                System.Net.ServicePointManager.ServerCertificateValidationCallback = delegate { return true; };
                client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("multipart/form-data"));

                MultipartFormDataContent form = new MultipartFormDataContent();

                form.Add(new StringContent(originalPath), "OriginalPath");
                form.Add(new StringContent(destinationPath), "DestinationPath");

                foreach (string data in fileNames)
                {
                    form.Add(new StringContent(data), "FileNames");
                }
                //form.Add(new StringContent(JsonConvert.SerializeObject(fileNames)), "FileNames");
                if (Directory.Exists(originalPath))
                {
                    var resultapi = client.PostAsync(statics.GetSetting("file_upload_api") + "/Move", form).Result;
                    resultapi.EnsureSuccessStatusCode();
                    if (resultapi.IsSuccessStatusCode)
                    {
                        result = resultapi.Content.ReadAsStringAsync().Result;
                    }
                }

                return result;
            }
            catch (Exception e)
            {
                result = e.Message;
                return result;
            }
        }

        [WebMethod]
        public static List<DataModel.Select2> GetCategory(string search)
        {
            List<DataModel.Select2> tcm = new List<DataModel.Select2>();

            IEnumerable<DataRow> dt = statics.GetCategory(search);
            foreach (DataRow item in dt)
                tcm.Add(new DataModel.Select2() { id = item["id"].ToString(), text = item["text"].ToString() });

            return tcm;
        }

        [WebMethod]
        public static List<DataModel.Select2> GetSubCategory(string category)
        {
            List<DataModel.Select2> tcm = new List<DataModel.Select2>();

            IEnumerable<DataRow> dt = statics.GetSubCategory(category);
            foreach (DataRow item in dt)
                tcm.Add(new DataModel.Select2() { id = item["id"].ToString(), text = item["text"].ToString() });

            return tcm;
        }

        [WebMethod]
        public static List<DataModel.Select2> GetBrand(string search)
        {
            List<DataModel.Select2> tcm = new List<DataModel.Select2>();

            IEnumerable<DataRow> dt = statics.GetBrand(search);
            foreach (DataRow item in dt)
                tcm.Add(new DataModel.Select2() { id = item["id"].ToString(), text = item["text"].ToString() });

            return tcm;
        }

        [WebMethod]
        public static List<DataModel.Select2> GetUoM(string search)
        {
            List<DataModel.Select2> tcm = new List<DataModel.Select2>();

            IEnumerable<DataRow> dt = statics.GetUoM(search);
            foreach (DataRow item in dt)
                tcm.Add(new DataModel.Select2() { id = item["id"].ToString(), text = item["text"].ToString() });

            return tcm;
        }

        [WebMethod]
        public static List<DataModel.Select2> GetSUNItem(string search)
        {
            List<DataModel.Select2> tcm = new List<DataModel.Select2>();

            IEnumerable<DataRow> dt = statics.GetSUNItem(search);
            foreach (DataRow item in dt)
                tcm.Add(new DataModel.Select2() { id = item["id"].ToString(), text = item["text"].ToString() });

            return tcm;
        }

        [WebMethod]
        public static string GetSUNItemDetail(string item_code)
        {
            DataTable dt = statics.GetSUNItemDetail(item_code);

            return JsonConvert.SerializeObject(dt);
        }

        [WebMethod]
        public static List<DataModel.Select2> GetSUNSupplier(string search)
        {
            List<DataModel.Select2> tcm = new List<DataModel.Select2>();

            IEnumerable<DataRow> dt = statics.GetSUNSupplier(search);
            foreach (DataRow item in dt)
                tcm.Add(new DataModel.Select2() { id = item["id"].ToString(), text = item["text"].ToString() });

            return tcm;
        }

        [WebMethod]
        public static string GetSUNSupplierDetail(string supp_code)
        {
            DataSet ds = statics.GetSUNSupplierDetail(supp_code);

            return JsonConvert.SerializeObject(ds);
        }

        [WebMethod]
        public static List<DataModel.Select2> GetSUNAddress(string search)
        {
            List<DataModel.Select2> tcm = new List<DataModel.Select2>();

            IEnumerable<DataRow> dt = statics.GetSUNAddress(search);
            foreach (DataRow item in dt)
                tcm.Add(new DataModel.Select2() { id = item["id"].ToString(), text = item["text"].ToString() });

            return tcm;
        }

        [WebMethod]
        public static string GetSUNAddressDetail(string addr_code)
        {
            DataTable dt = statics.GetSUNAddressDetail(addr_code);

            return JsonConvert.SerializeObject(dt);
        }

        [WebMethod]
        public static List<DataModel.Select2> GetSUNT4(string code)
        {
            List<DataModel.Select2> tcm = new List<DataModel.Select2>();

            IEnumerable<DataRow> dt = statics.GetSUNT4(code);
            foreach (DataRow item in dt)
                tcm.Add(new DataModel.Select2() { id = item["T4"].ToString(), text = item["T4"].ToString() + " - " + item["DESCRIPTION"].ToString() });

            return tcm;
        }

        [WebMethod]
        public static string SearchItem(string general, string brand, string description)
        {
            DataTable dt = statics.GetSearchItem(general, brand, description);

            return JsonConvert.SerializeObject(dt);
        }

        [WebMethod]
        public static string GetVendorList()
        {
            return JsonConvert.SerializeObject(statics.GetVendorList());
        }

        [WebMethod]
        public static List<DataModel.Select2> GetVendor(string search)
        {
            List<DataModel.Select2> tcm = new List<DataModel.Select2>();

            IEnumerable<DataRow> dt = statics.GetVendor(search);
            foreach (DataRow item in dt)
                tcm.Add(new DataModel.Select2()
                {
                    id = item["id"].ToString(),
                    text = item["vendor_Name"].ToString(),
                    condition = item["ocs_supplier_code"].ToString()
                });

            return tcm;
        }

        [WebMethod]
        public static List<DataModel.Select2> GetVendorByCategory(string search, string subcategory)
        {
            List<DataModel.Select2> tcm = new List<DataModel.Select2>();

            IEnumerable<DataRow> dt = statics.GetVendor(search, subcategory);

            DataTable dts = statics.GetTaxSystemByUserId();

            string user_office = GetProcurementOfficeByOfficerId(statics.GetLogonUsername());
            DataTable dtOffice = statics.GetCIFOROffice(statics.GetLogonUsername());

            DataTable dtAllTaxSystem = statics.GetMappingAllTaxSystem(user_office);

            if (dtOffice.Rows.Count == 1)
            {
                user_office = user_office.Replace(";", "");
            }

            foreach (DataRow item in dt)
            {
                foreach (DataRow itemE in dts.Rows)
                {
                    if (dtAllTaxSystem.Rows.Count > 0 || item["IsSundry"].ToString() == "1")
                    {
                        tcm.Add(new DataModel.Select2() { id = item["id"].ToString(), text = item["vendor_Name"].ToString() });
                    }
                    else
                    {
                        if (item["Entity"].ToString() == itemE["Entity"].ToString())
                        {
                            tcm.Add(new DataModel.Select2() { id = item["id"].ToString(), text = item["vendor_Name"].ToString() });
                        }
                    }
                    
                }                
            }                

            return tcm;
        }

        [WebMethod]
        public static string GetVendorContactPerson(string vendors)
        {
            return JsonConvert.SerializeObject(staticsRFQ.GetVendorContacts(vendors));
        }

        [WebMethod]
        public static string GetVendorAddress(string vendor_id)
        {
            return statics.GetVendorAddress(vendor_id);
        }

        [WebMethod]
        public static string GetVendorAddressList(string vendor_id)
        {
            return JsonConvert.SerializeObject(statics.GetVendorAddressList(vendor_id));
        }

        [WebMethod]
        public static string GetVendorTax(string vendor_id)
        {
            return JsonConvert.SerializeObject(statics.GetVendorTax(vendor_id));
        }

        [WebMethod]
        public static string GetMinimumDate(string date, string additional)
        {
            return DateTime.Parse(statics.GetMinimumDate(date, additional)).ToString("dd MMM yyyy");
        }

        [WebMethod]
        public static string GetRequesterOffice(string user_id)
        {
            DataTable dtOffice = statics.GetCIFOROffice(user_id);
            String office = "";
            if (dtOffice.Rows.Count > 0)
            {
                office = dtOffice.Rows[0]["office_id"].ToString();
            }
            return office;
        }

        public static string GetProcurementOfficeByOfficerId(string user_id, bool is_lead = false, bool is_contry_lead = false)
        {
            DataTable dtOffice = statics.GetCIFOROffice(user_id, is_lead, is_contry_lead);
            String office = "";

            foreach (DataRow dr in dtOffice.Rows)
            {
                if (!string.IsNullOrEmpty(dr["office_id"].ToString()))
                {
                    office += dr["office_id"].ToString() + ";";
                }

            }

            return office;
        }

        public static string GetProcurementOfficeByFinanceOfficerId(string user_id)
        {
            DataTable dtOffice = statics.GetCIFOROfficeByUserIdFinance(user_id);
            String office = "";

            foreach (DataRow dr in dtOffice.Rows)
            {
                if (!string.IsNullOrEmpty(dr["office_id"].ToString()))
                {
                    office += dr["office_id"].ToString() + ";";
                }

            }

            return office;
        }

        [WebMethod]
        public static string GetRequesterProcurementOffice(string user_id)
        {
            DataTable dtOffice = statics.GetRequesterCIFOROffice(user_id);
            String office = "";
            if (dtOffice.Rows.Count > 0)
            {
                office = dtOffice.Rows[0]["office_id"].ToString();
            }
            return office;
        }

        [WebMethod]
        public static string GetRFQItems(string subcategories, string cifor_office_id, string pr_detail_id)
        {
            DataSet ds = staticsRFQ.GetItem(subcategories, cifor_office_id, pr_detail_id);
            return JsonConvert.SerializeObject(ds);
        }

        [WebMethod]
        public static string GetRFQList(string startDate, string endDate, string status, string cifor_office)
        {
            DataSet ds = staticsRFQ.Main.GetList(startDate, endDate, status, cifor_office);
            return JsonConvert.SerializeObject(ds.Tables[0]);
        }

        [WebMethod]
        public static string GetRFQData(string rfq_id)
        {
            DataSet ds = staticsRFQ.Main.GetData(rfq_id);
            return JsonConvert.SerializeObject(ds);
        }

        [WebMethod]
        public static string GetVSList(string startDate, string endDate, string status, string cifor_office, string usedVS)
        {
            DataSet ds = staticsVendorSelection.Main.GetList(startDate, endDate, status, cifor_office, usedVS);
            return JsonConvert.SerializeObject(ds.Tables[0]);
        }

        [WebMethod]
        public static string GetVSItems(string vs_ids)
        {
            DataSet ds = staticsPurchaseOrder.GetItems(vs_ids);
            return JsonConvert.SerializeObject(ds.Tables[0]);
        }

        [WebMethod]
        public static string GetVSDetailData(string vs_id)
        {
            DataSet ds = staticsVendorSelection.Main.GetVendorSelectionDetailData(vs_id);
            return JsonConvert.SerializeObject(ds.Tables[0]);
        }

        [WebMethod]
        public static string GetVendorCategories(string vendor_id)
        {
            return statics.GetVendorCategories(vendor_id);
        }

        [WebMethod]
        public static string GetVendorCategoryList(string categories)
        {
            return JsonConvert.SerializeObject(statics.GetVendorCategoryList(categories));
        }

        [WebMethod]
        public static string GetVendorSelectionItem(string used_items, string vendor_ids, string currency_ids, string date,
            string startdate, string enddate, string search, string cifor_office)
        {
            DataSet ds = staticsVendorSelection.GetItem(used_items, vendor_ids, currency_ids, date, startdate, enddate, search, cifor_office);
            return JsonConvert.SerializeObject(ds);
        }

        [WebMethod]
        public static string GetProductCategoryList(string products)
        {
            return JsonConvert.SerializeObject(statics.GetProductCategoryList(products));
        }

        //[WebMethod]
        //public static string GetSUNPO(string id)
        //{
        //    string sun_po_no = staticsPurchaseOrder.Main.GetSUNPO(id);
        //    return sun_po_no;
        //}

        //[WebMethod]
        //public static string sendConfirmation(string ids, string base_type)
        //{
        //    string result, message = "";
        //    try
        //    {
        //        staticsUserConfirmation.SendConfirmation(ids, base_type);

        //        result = "success";
        //    }
        //    catch (Exception ex)
        //    {
        //        result = "error";
        //        message = ex.ToString();
        //    }
        //    return JsonConvert.SerializeObject(new
        //    {
        //        result = result,
        //        message = message
        //    });
        //}

        //[WebMethod]
        //public static string updateConfirmation(string id, string additional_person, string uc_id)
        //{
        //    string result, message = "";
        //    try
        //    {
        //        DataModel.UserConfirmationDetail du = new DataModel.UserConfirmationDetail();
        //        du.id = id;
        //        du.additional_person = additional_person;
        //        du.status_id = "30";
        //        staticsUserConfirmation.UpdateStatus(du);

        //        staticsUserConfirmation.Main.UpdateStatusConfirmation(uc_id);

        //        result = "success";
        //    }
        //    catch (Exception ex)
        //    {
        //        result = "error";
        //        message = ex.ToString();
        //    }
        //    return JsonConvert.SerializeObject(new
        //    {
        //        result = result,
        //        message = message
        //    });
        //}

        //[WebMethod]
        //public static string saveSUNPO(string po_id, string po_sun_code)
        //{
        //    string result, message = "";
        //    try
        //    {
        //        staticsPurchaseOrder.Main.SaveSUNPO(po_id, po_sun_code);
        //        result = "success";
        //    }
        //    catch (Exception ex)
        //    {
        //        result = "error";
        //        message = ex.ToString();
        //    }
        //    return JsonConvert.SerializeObject(new
        //    {
        //        result = result,
        //        message = message
        //    });
        //}

        [WebMethod]
        public static string SavePODeliveryDate(string po_id, string po_delivery_date)
        {
            string result, message = string.Empty;
            try
            {
                var isSaveSuccess = staticsPurchaseOrder.Main.SaveDeliveryDate(po_id, po_delivery_date);

                var k2ApiKey = ConfigurationManager.AppSettings["k2ApiKey"].ToString();
                var k2ApiEndpoint = ConfigurationManager.AppSettings["k2ApiEndpoint"].ToString();

                //K2Helpers k2Help = new K2Helpers(k2ApiKey, k2ApiEndpoint);
                PurchaseOrderK2Helper poK2Help = new PurchaseOrderK2Helper();

                // Initiate data for K2
                var poForK2 = staticsPurchaseOrder.Main.GetDataForK2(po_id);
                string expectedDeliveryDate = poForK2.Rows[0]["expected_delivery_date"]?.ToString();
                string processInstID = poForK2.Rows[0]["ProcessInstID"]?.ToString();

                Dictionary<string, object> deliveryDateDict = new Dictionary<string, object>
                {
                    { EnumK2PODataField.ReservedFieldTwo, expectedDeliveryDate }
                };
                //var isUpdateK2DataSuccess = k2Help.K2UpdateProcessDataAPI(processInstID, deliveryDateDict);
                //if (isSaveSuccess && isUpdateK2DataSuccess.Status)
                //{
                //    result = "success";
                //}
                //else
                //{
                //    result = "error";
                //    if (!isSaveSuccess)
                //    {
                //        message += "Save expected delivery date is failed\n";
                //    }
                //    if (!isUpdateK2DataSuccess.Status)
                //    {
                //        message += $"Update K2 expected delivery date is failed\nWith message : {isUpdateK2DataSuccess.Message}";
                //    }
                //}
            }
            catch (Exception ex)
            {
                result = "error";
                message = ex.ToString();
            }
            return JsonConvert.SerializeObject(new
            {
                result = "result",
                message = message
            });
        }

        [WebMethod]
        public static string SavePOProcurementAddress(string po_id, string po_procurement_address)
        {
            string result, message = "";
            try
            {
                staticsPurchaseOrder.Main.SaveProcurementAddress(po_id, po_procurement_address);
                result = "success";
            }
            catch (Exception ex)
            {
                result = "error";
                message = ex.ToString();
            }
            return JsonConvert.SerializeObject(new
            {
                result = result,
                message = message
            });
        }

        [WebMethod]
        public static string SavePrintOutPO(string po_id, string po_procurement_address, string po_legal_entity)
        {
            string result, message = "";
            try
            {
                staticsPurchaseOrder.Main.SavePrintOutPO(po_id, po_procurement_address, po_legal_entity);
                result = "success";
            }
            catch (Exception ex)
            {
                result = "error";
                message = ex.ToString();
            }
            return JsonConvert.SerializeObject(new
            {
                result = result,
                message = message
            });
        }

        [WebMethod]
        public static string SavePOLegalEntity(string po_id, string po_legal_entity)
        {
            string result, message = "";
            try
            {
                staticsPurchaseOrder.Main.SaveLegalEntity(po_id, po_legal_entity);
                result = "success";
            }
            catch (Exception ex)
            {
                result = "error";
                message = ex.ToString();
            }
            return JsonConvert.SerializeObject(new
            {
                result = result,
                message = message
            });
        }

        [WebMethod]
        public static string SavePOSendDate(string po_id, string po_send_date)
        {
            string result, message = "";
            try
            {
                staticsPurchaseOrder.Main.SaveSendDate(po_id, po_send_date);
                result = "success";
            }
            catch (Exception ex)
            {
                result = "error";
                message = ex.ToString();
            }
            return JsonConvert.SerializeObject(new
            {
                result = result,
                message = message
            });
        }

        [WebMethod]
        public static List<DataModel.Select2> GetRFQSession(string search)
        {
            List<DataModel.Select2> tcm = new List<DataModel.Select2>();

            IEnumerable<DataRow> dt = statics.GetRFQSession(search);
            foreach (DataRow data in dt)
                tcm.Add(new DataModel.Select2() { id = data["session_no"].ToString(), text = data["session_no"].ToString() });

            return tcm;
        }

        [WebMethod]
        public static string GetSpecificExchangeRate(string destination, string source, string date)
        {
            DataTable dt = statics.GetSpecificExchangeRate(destination, source, date);
            return JsonConvert.SerializeObject(dt);
        }

        [WebMethod]
        public static string GetUserConfirmationItems(string ids, string base_type)
        {
            DataSet ds = staticsUserConfirmation.GetItems(ids, base_type);
            DataSet newDs = new DataSet();

            if (ds.Tables.Count > 0)
            {
                DataTable dtMain = ds.Tables[0].Copy();
                dtMain.TableName = "groupheader";

                DataTable dtDetail = ds.Tables[1].Copy();
                dtDetail.TableName = "groupdetail";

                newDs.Tables.Add(dtMain);
                newDs.Tables.Add(dtDetail);
            }

            return JsonConvert.SerializeObject(newDs);
        }

        [WebMethod]
        public static string saveReferenceNo(string pr_id, string pr_reference_no, string workflows)
        {
            string result, message = "", moduleName = "PURCHASE REQUISITION", _id = string.Empty, approval_no = string.Empty;
            _id = pr_id;

            DataModel.Workflow workflow = JsonConvert.DeserializeObject<DataModel.Workflow>(workflows);
            try
            {
                staticsPurchaseRequisition.Main.SaveReferenceNo(pr_id, pr_reference_no);

                DataModel.Comment comment = new DataModel.Comment
                {
                    module_id = _id,
                    module_name = moduleName,
                    comment = workflow.comment,
                    action_taken = workflow.action,
                    activity_id = workflow.activity_id,
                    roles = workflow.roles
                };

                /* insert comment */
                approval_no = statics.Comment.Save(comment);

                result = "success";
            }
            catch (Exception ex)
            {
                result = "error";
                message = ex.ToString();
            }
            return JsonConvert.SerializeObject(new
            {
                result = result,
                message = message
            });
        }

        [WebMethod]
        public static string savePaymentNo(string id, string submission, string deletedIds, string workflows, string purchaseRequisition)
        {
            string result, message = "", moduleName = "PURCHASE REQUISITION", _id = string.Empty, approval_no = string.Empty;
            string id_journal = string.Empty;
            _id = id;
            List<DataModel.JournalNo> prjournal = JsonConvert.DeserializeObject<List<DataModel.JournalNo>>(submission);
            List<DataModel.DeletedId> dels = JsonConvert.DeserializeObject<List<DataModel.DeletedId>>(deletedIds);
            DataModel.Workflow workflow = JsonConvert.DeserializeObject<DataModel.Workflow>(workflows);
            DataModel.PurchaseRequisition pr = JsonConvert.DeserializeObject<DataModel.PurchaseRequisition>(purchaseRequisition);

            try
            {
                foreach (DataModel.JournalNo prjournalno in prjournal)
                {
                    id_journal = staticsPurchaseRequisition.Main.SaveJournalNo(prjournalno);

                    DataModel.Attachment pratt = new DataModel.Attachment();
                    pratt.id = prjournalno.journal_attachment_id;
                    pratt.filename = prjournalno.journal_attachment;
                    pratt.file_description = prjournalno.journal_attachment_description;
                    pratt.document_id = id_journal;
                    pratt.document_type = moduleName + " PAYMENT JOURNAL NO";

                    statics.Attachment.Save(pratt);
                }

                foreach (DataModel.DeletedId d in dels)
                {
                    staticsPurchaseRequisition.Main.DeleteJournalNo(d.id);
                }

                DataModel.Comment comment = new DataModel.Comment
                {
                    module_id = _id,
                    module_name = moduleName,
                    comment = workflow.comment,
                    //action_taken = workflow.action,
                    action_taken = "SAVED",
                    activity_id = workflow.activity_id,
                    roles = workflow.roles
                };

                /* insert comment */
                approval_no = statics.Comment.Save(comment);

                staticsPurchaseRequisition.Main.UpdatePRPurchaseType(pr);

                result = "success";
            }
            catch (Exception ex)
            {
                result = "error";
                message = ex.ToString();
            }
            return JsonConvert.SerializeObject(new
            {
                result = result,
                message = message
            });
        }

        [WebMethod]
        public static string FundsCheck(IEnumerable<object> data)
        {
            var falseResult = new FundsCheckModel.FundsCheckResult()
            {
                data = null,
                status = "500",
                additionalInfo = "Failed to hit API Fundscheck",
                success = false
            };
            try
            {
                var fundChecks = FundCheckAccount.FundsCheckAPI(JsonConvert.SerializeObject(data), AccessControl.GetAccessToken());
                if (fundChecks != null)
                    return JsonConvert.SerializeObject(fundChecks);
                else
                    return JsonConvert.SerializeObject(falseResult);
            }
            catch (Exception ex)
            {
                falseResult.additionalInfo = ex.Message;
                return JsonConvert.SerializeObject(falseResult);
            }
        }

        [WebMethod]
        public static string CheckSupplier(string vendor_id)
        {
            DataTable dt = statics.CheckSupplier(vendor_id);
            return JsonConvert.SerializeObject(dt);
        }

        [WebMethod]
        public static string GetProductList()
        {
            return JsonConvert.SerializeObject(statics.GetProduct());
        }

        [WebMethod]
        public static bool UpdatePrint(string id, string module)
        {
            bool result = statics.UpdatePrint(id, module);
            return result;
        }

        [WebMethod]
        public static string GetTaxSystem(string office_id)
        {
            return JsonConvert.SerializeObject(statics.GetTaxSystem(office_id));
        }

        [WebMethod]
        public static string GetProductGroup()
        {
            return JsonConvert.SerializeObject(statics.GetProductGroup());
        }

        [WebMethod]
        public static string GetJournalDetail(string journal_number)
        {
            DataTable to = statics.GetJournalDetail(journal_number);
            return JsonConvert.SerializeObject(to);
        }

        [WebMethod]
        public static string spGetMappingAllTaxSystem(string cifor_office)
        {
            DataTable to = statics.GetMappingAllTaxSystem(cifor_office);
            return JsonConvert.SerializeObject(to);
        }

        [WebMethod]
        public static string GetVSData(string vs_id)
        {
            DataTable to = statics.GetVSData(vs_id);
            return JsonConvert.SerializeObject(to);
        }

        [WebMethod]
        public static string SaveLifeCycle(string module_id, string module_name,string status_id,string fundscheck_result)
        {
            Boolean success = statics.LifeCycle.Save(module_id,module_name,status_id);
            statics.SaveFundscheckResult(module_id, module_name, fundscheck_result);
            return success.ToString();
        }

        #region ProcurementReporting
        [WebMethod]
        public static string GetStaffByTeam(string searchText)
        {
            return JsonConvert.SerializeObject(staticsProcurementReporting.GetEmployee(searchText));
        }

        [WebMethod]
        public static string LoadSummarizePOReport(string startdate, string enddate, string team, string staff_id, string procurement_office)
        {
            return JsonConvert.SerializeObject(staticsProcurementReporting.getSummarizePOReport(startdate, enddate, team, staff_id, procurement_office).Tables[0]);
        }

        [WebMethod]
        public static string LoadSummarizePRReport(string startdate, string enddate, string prtype, string team, string staff_id, string procurement_office)
        {
            return JsonConvert.SerializeObject(staticsProcurementReporting.getSummarizePRReport(startdate, enddate, prtype, team, staff_id, procurement_office).Tables[0]);
        }
        #endregion
    }
}