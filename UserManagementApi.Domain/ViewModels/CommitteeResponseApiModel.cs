using System;
using System.Collections.Generic;
using System.Text;

namespace UserManagementApi.Domain.ViewModels
{
    public class CommitteeResponseApiModel
    {
        public int CommitteeID { get; set; }
        public string CommitteeName { get; set; }
        public string OfficeSought { get; set; }
        public string District { get; set; }
        public DateTime ElectionDate { get; set; }
        public string CandidateName { get; set; }
        public string Status { get; set; }
    }
}
