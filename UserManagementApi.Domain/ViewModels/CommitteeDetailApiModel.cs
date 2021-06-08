using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Text;

namespace UserManagementApi.Domain.ViewModels
{
    public class CommitteeDetailApiModel
    {
        public int CommitteeID { get; set; }
        [Required]
        [StringLength(500)]
        public string CommitteeName { get; set; }
        public string CommitteeTypeID { get; set; }
        [Required]
        public string OfficeSoughtID { get; set; }
        public string District { get; set; }
        [Required]
        public int ElectionCycleID { get; set; }
        public string CommitteeWebsite { get; set; }
        public string BankName { get; set; }
        [Required]
        public string Address1 { get; set; }
        [Required]
        public string Address2 { get; set; }
        [Required]
        public string City { get; set; }
        [Required]
        public string StateCode { get; set; }
        [Required]
        public string Zip { get; set; }
    }
}
