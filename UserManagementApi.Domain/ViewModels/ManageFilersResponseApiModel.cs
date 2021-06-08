using System;
using System.Collections.Generic;
using System.Text;

namespace UserManagementApi.Domain.ViewModels
{
    public class ManageFilersResponseApiModel
    {
        public int FilerId { get; set; }
        public string FilerName { get; set; }
        public string PrimaryUser { get; set; }
        public string Status { get; set; }
        public string LastFillingDate { get; set; }
        public string CreatedDate { get; set; }
        public string ElectionDate { get; set; }
        public string FilerType { get; set; }
        
    }
}
