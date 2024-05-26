using System.Collections.Generic;
namespace myTree.WebForms.Procurement.General
{
    public class FundsCheckModel
    {
        public class FundsCheck
        {
            public string Costc { get; set; }
            public string WorkOrder { get; set; }
            public string Entity { get; set; }
            public string Account { get; set; }
            public decimal Amount { get; set; }
            public bool Result { get; set; }
        }
        public class FundsCheckParameter
        {
            public string Costc { get; set; }
            public string Workorder { get; set; }
            public string Entity { get; set; }
            public string Account { get; set; }
            public decimal Amount { get; set; }
        }
        public class FundsCheckData
        {
            public List<FundsCheck> data { get; set; }

        }

        public class FundsCheckResult
        {
            public bool success { get; set; }
            public string status { get; set; }
            public string additionalInfo { get; set; }
            public List<FundsCheck> data { get; set; }
        }
        public class FundsCheckList
        {
            public List<FundsCheck> data { get; set; }

        }
    }
}
