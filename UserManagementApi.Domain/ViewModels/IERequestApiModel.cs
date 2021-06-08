using System;
using System.Collections.Generic;
using System.Text;
using System.Text.Json.Serialization;

namespace UserManagementApi.Domain.ViewModels
{
    public class IERequestApiModel
    {
        public int TransactionId { get; set; }
        [JsonIgnore]
        public int TransactionVersionId { get; set; } = 1;
        public int EntityId { get; set; }
        public string EntityType { get; set; }
        public IEContactInfo contactInfo { get; set; }
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
        [JsonIgnore]
        public bool PostElectionExemptFlag { get; set; } = false;
        [JsonIgnore]
        public string TransactionCategoryId { get; set; } = string.Empty;
        public string TransactionPurpose { get; set; } 
        [JsonIgnore]
        public bool FairElectionFundFlag { get; set; } = false;
        public bool ElectioneeringCommFlag { get; set; } 
        public bool IEFlag { get; set; }
        public bool NonDonorFundFlag { get; set; } = false;
        public string NonDonorSource { get; set; } = string.Empty;
        public decimal NonDonorAmount { get; set; } = 0;
        public string MethodOfCommunication { get; set; }
        public string IETargetType { get; set; }
        public string PositionDesc { get; set; } 
        public int BallotIssueId { get; set; } 
        public string BallotIssueDesc { get; set; }
        public string CandidateName { get; set; }
        public string OfficeSought { get; set; }
        public string District { get; set; }
        [JsonIgnore]
        public string AdminNotes { get; set; } = string.Empty;
        [JsonIgnore]
        public string FEFStatus { get; set; } = string.Empty;
        public int DisbursementId { get; set; }
        public int UserId { get; set; }
        [JsonIgnore]
        public string RoleType { get; set; } = "Payee";
    }

    public class IEContactInfo
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
