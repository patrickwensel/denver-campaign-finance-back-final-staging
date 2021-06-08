using System;
using System.Collections.Generic;
using System.Text;

namespace UserManagementApi.Domain.ApiModels
{
    public class LobbyistSubContractor
    {
        public int LobbyistId { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public string EmailId { get; set; }
        public string PhoneNo { get; set; }
        public string UserType { get; set; }
        public string OrganisationName { get; set; }
    }
}
