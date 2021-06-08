using System;
using System.Collections.Generic;
using System.Text;

namespace UserManagementApi.Domain.ViewModels
{
    public class GetEventsResponseApiModel
    {
        public int event_id { get; set; }
        public string name { get; set; }
        public string descr { get; set; }
        public DateTime eventdate { get; set; }
        public string filer_type_id { get; set; }
        public int event_filer_map_id { get; set; }
        public string filername { get; set; }
        public bool bump_filing_due { get; set; }

    }
}
