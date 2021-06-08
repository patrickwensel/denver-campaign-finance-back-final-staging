using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Text;

namespace UserManagementApi.Domain.ViewModels
{
    public class AddMatchingLimitApiModel
    {
        public int MatchingId { get; set; }
        public decimal QualifyingContributionAmount { get; set; }
        public decimal MatchingContributionAmount { get; set; }
        public int NumberRequiredQualifyingContributions { get; set; }
        public string MatchingRatio { get; set; }
        public int ContributionLimitsforParticipate { get; set; }
        public decimal TotalAvailableFunds { get; set; }     
        public string QualifyingOffices { get; set; }     
        public string OfficeTypeId { get; set; }
        public DateTime? StartDate { get; set; }
        public DateTime? Enddate { get; set; }      
        public string ElectionCycle { get; set; }
    }
}
