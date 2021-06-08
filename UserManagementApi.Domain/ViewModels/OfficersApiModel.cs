using System;
using System.Collections.Generic;
using System.Text;

namespace UserManagementApi.Domain.ViewModels
{
    public class OfficersApiModel
    {
        public int ContactID { get; set; }
        public string FirstName { get; set; }
        public string ModdleName { get; set; }
        public string LastName { get; set; }
        public string OrganizationName { get; set; }
        public string Address1 { get; set; }
        public string Address2 { get; set; }
        public string City { get; set; }
        public string StateCode { get; set; }
        public string CountryCode { get; set; }
        public string Zip { get; set; }
        public string Email { get; set; }
        public string Phone { get; set; }
        public string Occupation { get; set; }
        public string VoterID { get; set; }
        public string Description { get; set; }
        public int CommitteeID { get; set; }
    }
}
