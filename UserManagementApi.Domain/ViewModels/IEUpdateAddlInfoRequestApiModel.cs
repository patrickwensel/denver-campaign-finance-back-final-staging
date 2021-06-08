using System;
using System.Collections.Generic;
using System.Text;

namespace UserManagementApi.Domain.ViewModels
{
    public class IEUpdateAddlInfoRequestApiModel
    {
        public int ContactId { get; set; }
        public string FilerType { get; set; }
        public string Occupation { get; set; }
        public string Employer { get; set; }
        public string OrganisationName { get; set; }
    }
}
