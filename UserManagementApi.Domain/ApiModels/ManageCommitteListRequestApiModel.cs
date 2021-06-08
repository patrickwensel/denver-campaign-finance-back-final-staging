using System;
using System.Collections.Generic;
using System.Text;

namespace UserManagementApi.Domain.ApiModels
{
    public class ManageCommitteListRequestApiModel
    {
        public string Name { get; set; }
        public string Type { get; set; }
        public string Status { get; set; }
        public DateTime? LastFillingStartDate { get; set; }
        public DateTime? LastFillingEndDate { get; set; }
        public string OfficeType { get; set; }
        public string PublicFundStatus { get; set; }
    }
}
