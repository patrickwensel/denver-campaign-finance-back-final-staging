using System;
using System.Collections.Generic;
using System.Text;

namespace UserManagementApi.Domain.ViewModels
{
    public class FineSettingsApiModel
    {

        public int FineId { get; set; }
        public string FineName { get; set; }
        public decimal Amount { get; set; }
        public int GracePeriod { get; set; }
        public string Frequency { get; set; }
        public string FineFilerTypeIds { get; set; }
       
    }
}
