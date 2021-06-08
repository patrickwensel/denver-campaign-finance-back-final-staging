using System;
using System.Collections.Generic;
using System.Text;

namespace UserManagementApi.Domain.ApiModels
{
    public class CommitteeDetail: Officer
    {
        public int CId { get; set; }
        public string CName { get; set; }
        public string CandidateName { get; set; }
        public string TreasurerName { get; set; }
        public string OfficerType { get; set; }
        public string CType { get; set; }
        public string CDistrict { get; set; }
        public DateTime ElectionDate { get; set; }
        public string BallotNo { get; set; }
        public string BallotNote { get; set; }
        public string CPosition { get; set; }
        public string CPurpose { get; set; }
        public string CAddress1 { get; set; }
        public string CAddress2 { get; set; }
        public string CCity { get; set; }
        public string CStateCode { get; set; }
        public string CState { get; set; }
        public int CZipcode { get; set; }
        public string CampaignPhone { get; set; }
        public string CompaignEmail { get; set; }
        public string OtherPhone { get; set; }
        public string OtherEmail { get; set; }
        public string CompaignWebsite { get; set; }
        public string BankName { get; set; }
        public string BankAddress1 { get; set; }
        public string BankAddress2 { get; set; }
        public string BankCity { get; set; }
        public string BankStateCode { get; set; }
        public string BankState { get; set; }
        public int BankZipcode { get; set; }
        public string Status { get; set; }
    }
}
