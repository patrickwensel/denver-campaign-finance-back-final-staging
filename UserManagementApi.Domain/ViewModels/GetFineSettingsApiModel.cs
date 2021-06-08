using System;
using System.Collections.Generic;
using System.Text;

namespace UserManagementApi.Domain.ViewModels
{
    public class GetFineSettingsApiModel
    {

        public int FineId { get; set; }
        public string FineName { get; set; }
        public decimal Amount { get; set; }
        public int GracePeriod { get; set; }
        public string Frequency { get; set; }
        public string FineFilerTypeIds { get; set; }
        public int? FineFilerMapId { get; set; }
        public string FilerTypeId { get; set; }
        public string FilerType { get; set; }
    }
}
