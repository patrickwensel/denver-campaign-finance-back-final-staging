using System;
using System.Collections.Generic;
using System.Text;

namespace UserManagementApi.Domain.ApiModels
{
    public class SwitchIEDetail
    {
        public int IEID { get; set; }
        public string IEName { get; set; }
        public string IEType { get; set; }
        public string OrganizationName { get; set; }
        public string Employer { get; set; }
        public string Occupation { get; set; }
    }
}
