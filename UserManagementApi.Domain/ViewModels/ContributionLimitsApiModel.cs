using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Text;

namespace UserManagementApi.Domain.ViewModels
{
   public  class ContributionLimitsApiModel
    {
        public int Id { get; set; }
        public string CommiteeTypeId { get; set; }     
        public string CommiteeType { get; set; }
        public string OfficeTypeId { get; set; }
        public string OfficeType { get; set; }
        public string DonorTypeId { get; set; }
        public string DonorType { get; set; }
        public decimal ContLimit { get; set; }
        public int ElectionCycleId { get; set; }
        public string ElectionYear { get; set; }
        public string Descript { get; set; }
        public int TenantId { get; set; }

    }
}
