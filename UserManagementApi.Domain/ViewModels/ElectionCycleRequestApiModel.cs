using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Text;

namespace UserManagementApi.Domain.ViewModels
{
    public class ElectionCycleRequestApiModel
    {
        public int ElectionCycleId { get; set; }
        [Required]
        public string Name { get; set; }
        [Required]
        public string ElectionTypeId { get; set; }
        public DateTime? StartDate { get; set; }
        public DateTime? EndDate { get; set; }
        [Required] 
        public DateTime ElectionDate { get; set; }
        [Required]
        public string Status { get; set; }
        public string Description { get; set; }
        public string District { get; set; }
        public DateTime? IEStartDate { get; set; }
        public DateTime? IEEndDate { get; set; }
        public string UserId { get; set; }
        public string[] Offices { get; set; }
    }
}
