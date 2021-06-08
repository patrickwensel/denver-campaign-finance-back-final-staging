﻿using System;
using System.Collections.Generic;
using System.Text;
using System.ComponentModel.DataAnnotations;

namespace UserManagementApi.Domain.ViewModels
{
    public class FilingPeriodApiModel
    {
        public int FilingPeriodId { get; set; }
        public string FilingPeriodName { get; set; }
        public string Description { get; set; }
        public DateTime? StartDate { get; set; }
        public DateTime? Enddate { get; set; }
        public DateTime? Duedate { get; set; }
        public int ElectionCycleId { get; set; }
        public decimal ItemThreshold { get; set; }
        public string FilingPeriodFilerTypeIds { get; set; }

    }
}
