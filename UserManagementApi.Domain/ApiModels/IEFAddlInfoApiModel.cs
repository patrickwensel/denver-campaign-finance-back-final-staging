using System;
using System.Collections.Generic;
using System.Text;

namespace UserManagementApi.Domain.ApiModels
{
    public class IEFAddlInfoApiModel
    {
        public int UserID { get; set; }
        public string UserTypeId { get; set; }
        public string FilerType { get; set; }
        public string Occupation { get; set; }
        public string Employer { get; set; }
    }
}
