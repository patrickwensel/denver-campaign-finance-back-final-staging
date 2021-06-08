using System;
using System.Collections.Generic;
using System.Text;

namespace UserManagementApi.Domain.ViewModels
{
    public class SaveEventsApiModel
    {
        public int event_id { get; set; }
        public string filer_type_id { get; set; }
        public string Name { get; set; }
        public string Desc { get; set; }
        public DateTime? eventdate { get; set; }
        public bool bump_filing_due { get; set; }
    }
}
