using System;
using System.Collections.Generic;
using System.Runtime.Serialization;
using System.Text;
using System.Text.Json.Serialization;

namespace UserManagementApi.Domain.ViewModels
{
    public class ExpenditureRequestApiModel
    {
        public int TransactionId { get; set; }
        [JsonIgnore]
        public int TransactionVersionId { get; set; } = 1;
        public int EntityId { get; set; }
        public string EntityType { get; set; }
        public ExpenditureContactInfo contactInfo { get; set; }
        public string TransactionTypeId { get; set; }
        public decimal TransactionAmount { get; set; }
        public DateTime? TransactionDate { get; set; }
        [JsonIgnore]
        public int ElectioncycleId { get; set; } = 0;
        [JsonIgnore]
        public string Description { get; set; } = string.Empty;
        public bool RefundOrPaidFlag { get; set; }
        public DateTime? RefundOrPaidDate { get; set; }
        public decimal RefundOrPaidAmount { get; set; }
        [JsonIgnore]
        public string RefundReason { get; set; } = string.Empty;
        [JsonIgnore]
        public int ParentTransactionId { get; set; } = 0;
        public string Notes { get; set; }
        [JsonIgnore]
        public string ContributionTypeId { get; set; } = string.Empty;
        [JsonIgnore]
        public string MonetaryTypeId { get; set; } = string.Empty;
        public bool PostElectionExemptFlag { get; set; }
        public string TransactionCategoryId { get; set; } = string.Empty;
        public string TransactionPurpose { get; set; }
        public bool FairElectionFundFlag { get; set; }
        [JsonIgnore]
        public bool ElectioneeringCommFlag { get; set; } = false;
        [JsonIgnore]
        public bool IEFlag { get; set; }
        [JsonIgnore]
        public bool NonDonorFundFlag { get; set; } = false;
        [JsonIgnore]
        public string NonDonorSource { get; set; } = string.Empty;
        [JsonIgnore]
        public decimal NonDonorAmount { get; set; } = 0;
        [JsonIgnore]
        public string MethodOfCommunication { get; set; } = string.Empty;
        [JsonIgnore]
        public string IETargetType { get; set; } = string.Empty;
        [JsonIgnore]
        public string PositionDesc { get; set; } = string.Empty;
        [JsonIgnore]
        public int BallotIssueId { get; set; } = 0;
        [JsonIgnore]
        public string BallotIssueDesc { get; set; } = string.Empty;
        [JsonIgnore]
        public string CandidateName { get; set; } = string.Empty;
        [JsonIgnore]
        public string OfficeSought { get; set; } = string.Empty;
        [JsonIgnore]
        public string District { get; set; } = string.Empty;
        [JsonIgnore]
        public string AdminNotes { get; set; } = string.Empty;
        [JsonIgnore]
        public string FEFStatus { get; set; } = string.Empty;
        [JsonIgnore]
        public int DisbursementId { get; set; } = 0;
        public int UserId { get; set; }
        [JsonIgnore]
        public string RoleType { get; set; } = "Payee";
    }
    public class ExpenditureContactInfo
    {
        public int ContactId { get; set; }
        public string ContactType { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public string EmployerName { get; set; }
        [JsonIgnore]
        public string OccupationDesc { get; set; } = string.Empty;
        [JsonIgnore]
        public string VoterId { get; set; } = string.Empty;
        public string Caddress1 { get; set; }
        public string Caddress2 { get; set; }
        public string CityName { get; set; }
        public string StateCode { get; set; }
        public string Zipcode { get; set; }
        public bool ContactUpdatedFlag { get; set; }
    }
}
