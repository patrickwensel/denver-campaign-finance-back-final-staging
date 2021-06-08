using System;
using System.Collections.Generic;
using System.Text;

namespace UserManagementApi.Domain.ApiModels
{
    public class ManageFilerRequestApiModel
    {
        public string FilerName { get; set; }
        public string FilerType { get; set; }
        public string FilerStatus { get; set; }
        public DateTime? LastFillingStartDate { get; set; }
        public DateTime? LastFillingEndDate { get; set; }
        public string CommitteType { get; set; }
        public string OfficeType { get; set; }
        public string PublicFundStatus { get; set; }

    }
}
