using System;
using System.Collections.Generic;
using System.Text;

namespace UserManagementApi.Domain.ApiModels
{
    public class ManageFilerResponseApiModel
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public string PrimaryUser { get; set; }
        public string Status { get; set; }
        public string LastFillingDate { get; set; }
        public string ElectionDate { get; set; }
        public string FilerType { get; set; }
    }
}
