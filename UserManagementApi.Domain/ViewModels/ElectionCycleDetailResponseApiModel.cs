using System;
using System.Collections.Generic;
using System.Text;

namespace UserManagementApi.Domain.ViewModels
{
    public class ElectionCycleDetailResponseApiModel
    {
        public int ElectionCycleId { get; set; }
        public string ElectionCycle { get; set; }
        public string ElectionCycleTypeId { get; set; }
        public string ElectionCycleType { get; set; }
        public DateTime? StartDate { get; set; }
        public DateTime? EndDate { get; set; }
        public DateTime ElectionDate { get; set; }
        public string Description { get; set; }
        public string District { get; set; }
        public DateTime? IEStartDate { get; set; }
        public DateTime? IEEndDate { get; set; }
        public string OfficeIds { get; set; }
        public string Offices { get; set; }
        public string statusDesc { get; set; }
    }
}
