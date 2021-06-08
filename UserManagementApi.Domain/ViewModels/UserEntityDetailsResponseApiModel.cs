using System;
using System.Collections.Generic;
using System.Text;

namespace UserManagementApi.Domain.ViewModels
{
    public class UserEntityDetailsResponseApiModel
    {
        public int ContactId { get; set; }
        public string EntityName { get; set; }
        public string EntityType { get; set; }
        public string OrgName { get; set; }
        public string PrimaryName { get; set; }
        public string CandidateName { get; set; }
        public string TreasurerName { get; set; }
        public string ElectionDate { get; set; }
        public string PublicFund { get; set; }
        public string BallotIssue { get; set; }
        public string PositionDesc { get; set; }
        public string PurposeDesc { get; set; }
        public string OccupationDesc { get; set; }
    }
}
