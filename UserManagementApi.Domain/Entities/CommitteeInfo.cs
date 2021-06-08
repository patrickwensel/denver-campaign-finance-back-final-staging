using System;
using System.Collections.Generic;
using System.Text;

namespace UserManagementApi.Domain.Entities.Committee
{
    public class CommitteeInfo: CommonInfo
    {
        public int CommitteeId { get; set; }
        public string CommitteeName { get; set; }
        public string CommitteType { get; set; }
        public string CandidateFirstName { get; set; }
        public string CandidateLastName { get; set; }
        public string OfficerType { get; set; }
        public string District { get; set; }
        public int ElectionDateRefId { get; set; }
        public string BallotIssueNo { get; set; }
        public string BallotIssueNote { get; set; }
        public string Position { get; set; }
        public string Purpose { get; set; }
        public string Address1 { get; set; }
        public string Address2 { get; set; }
        public string City { get; set; }
        public string StateCode { get; set; }
        public int Zipcode { get; set; }
        public string CampaignPhone { get; set; }
        public string CampaignEmail { get; set; }
        public string OtherPhone { get; set; }
        public string OtherEmail { get; set; }
        public string CampaignWebsite { get; set; }
        public string BankName { get; set; }
        public string BankAddress1 { get; set; }
        public string BankAddress2 { get; set; }
        public string BankCity { get; set; }
        public string BankStateCode { get; set; }
        public int BankZipcode { get; set; }
        public int UserID { get; set; }
        public OfficerInfo[] OfficerInfo { get; set; }
    }
}
