using System;
using System.Collections.Generic;
using System.Text;

namespace UserManagementApi.Domain.ViewModels
{
    public class FeeSummaryApiModel
    {
        public string TotalOutstandingFeeBalance { get; set; }

        public string TotalFeesCollectedToDate { get; set; }

        public string TotalFeesWaived { get; set; }

        public string TotalFeesReduced { get; set; }
    }
}
