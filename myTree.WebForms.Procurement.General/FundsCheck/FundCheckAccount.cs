using Newtonsoft.Json;
using System;
using System.Configuration;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Text;

namespace myTree.WebForms.Procurement.General
{
    public class FundCheckAccount
    {
        public static FundsCheckModel.FundsCheckResult FundsCheckAPI(string param, string accessToken)
        //public static FundsCheck FundsCheckAPI(FundsCheck param)
        {
            FundsCheckModel.FundsCheckResult fundsCheckResult;
            try
            {
                var client = new HttpClient();
                client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", accessToken);
                string fundsCheckUrl = ConfigurationManager.AppSettings["FundsCheckUrl"];
                var httpContent = new StringContent(param, Encoding.UTF8, "application/json");
                var result = client.PostAsync(fundsCheckUrl, httpContent).Result;
                result.EnsureSuccessStatusCode();
                if (result.IsSuccessStatusCode)
                {
                    var x = result.Content.ReadAsStringAsync().Result;
                    fundsCheckResult = JsonConvert.DeserializeObject<FundsCheckModel.FundsCheckResult>(result.Content.ReadAsStringAsync().Result);
                }
                else
                {
                    fundsCheckResult = null;
                }
            }
            catch (Exception ex)
            {
                var a = ex.ToString();
                fundsCheckResult = null;
            }
            return fundsCheckResult;
        }


    }
}