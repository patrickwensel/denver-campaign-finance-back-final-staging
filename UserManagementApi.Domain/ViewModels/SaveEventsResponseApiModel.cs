using System;
using System.Collections.Generic;
using System.Text;

namespace UserManagementApi.Domain.ViewModels
{
    public class SaveEventsResponseApiModel
    {
        public int event_id { get; set; }
        public string Name { get; set; }
        public string Descr { get; set; }
        public DateTime? eventdate { get; set; }
        public bool bump_filing_due { get; set; }
        public string filertype { get; set; }
        public string filerId { get; set; }
    }
}
