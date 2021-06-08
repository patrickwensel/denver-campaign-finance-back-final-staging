using System;
using System.Collections.Generic;
using System.Text;

namespace UserManagementApi.Domain.ViewModels
{
    public class ElectionCycleResponseApiModel
    {
        public int ElectionCycleId { get; set; }
        public string ElectionName { get; set; }
        public string ElectionTypeId { get; set; }
        public string ElectionTypeDesc { get; set; }
        public DateTime? StartDate { get; set; }
        public DateTime? EndDate { get; set; }
        public DateTime? ElectionDate { get; set; }
        public string Status { get; set; }
        public string StatusDesc { get; set; }
        public string Description { get; set; }
        public string District { get; set; }
        public DateTime? IEStartDate { get; set; }
        public DateTime? IEEndDate { get; set; }
        public string ElectionCycleStatus { get; set; }
        public string OfficeIds { get; set; }
        public string Offices { get; set; }
    }
}
