using System;
using System.Collections.Generic;
using System.Text;

namespace UserManagementApi.Domain.ViewModels
{
    public class PaymentHistoryRequestApiModel
    {
        public string FilerName { get; set; }
        public string FilerType { get; set; }
        public DateTime? StartDate { get; set; }
        public DateTime? EndDate { get; set; }
        public int? ElectionCycleID { get; set; }
    }
}
