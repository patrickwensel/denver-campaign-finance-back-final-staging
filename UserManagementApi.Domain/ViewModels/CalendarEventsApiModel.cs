using System;
using System.Collections.Generic;
using System.Text;

namespace UserManagementApi.Domain.ViewModels
{
    public class CalendarEventsApiModel
    {
        public List<CalendarApiModel> ElectionCycleDetails { get; set; }
        public List<CalendarApiModel> EventDetails { get; set; }
        public List<CalendarApiModel> FilingPeriodDetails { get; set; }
    }
}
