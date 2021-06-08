using System;
using System.Collections.Generic;
using System.Text;

namespace UserManagementApi.Domain.ApiModels
{
    public class SwitchCommitteeDetail
    {
        public int ID { get; set; }
        public string Name { get; set; }
        public string Type { get; set; }
        public string CandidateName { get; set; }
        public string BallotIssue { get; set; }
        public string PositionName { get; set; }
        public string TreasurerName { get; set; }
        public string TypeName { get; set; }
        public DateTime ElectionDate { get; set; }
        public string PublicFundingStatus { get; set; }
        public string Purpose { get; set; }
    }
}
