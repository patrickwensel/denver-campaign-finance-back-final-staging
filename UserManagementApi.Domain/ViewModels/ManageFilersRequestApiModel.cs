using System;
using System.Collections.Generic;
using System.Text;

namespace UserManagementApi.Domain.ViewModels
{
    public class ManageFilersRequestApiModel
    {
        public string FilerName { get; set; }
        public string FilerType { get; set; }
        public string FilerStatus { get; set; }
        public DateTime? StartDate { get; set; }
        public DateTime? EndDate { get; set; }
        public string CommitteeType { get; set; }
        public string OfficeType { get; set; }
        public DateTime? ElectionDate { get; set; }
        public string PublicFundStatus { get; set; }

    }
}
