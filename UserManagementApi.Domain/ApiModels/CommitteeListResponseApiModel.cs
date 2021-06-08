using System;
using System.Collections.Generic;
using System.Text;

namespace UserManagementApi.Domain.ApiModels.Committee
{
    public class CommitteeListResponseApiModel
    {
        public int CommitteeId { get; set; }
        public string CommitteeName { get; set; }
        public string CommitteeType { get; set; }
        public string CandidateName { get; set; }
        public string OfficerType { get; set; }
        public string District { get; set; }
        public string Address1 { get; set; }
        public string Address2 { get; set; }
        public string City { get; set; }
        public string StateDesc { get; set; }
        public int Zipcode { get; set; }
    }
}
