using System;
using System.Collections.Generic;
using System.Text;

namespace UserManagementApi.Domain.ApiModels
{
    public class LobbyistClient
    {
        public int LobbyistId { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public string OrganisationName { get; set; }
        public string UserType { get; set; }
        public string NatureOfBusiness { get; set; }
        public string lMatters { get; set; }
        public string CAddress1 { get; set; }
        public string CAddress2 { get; set; }
        public string Ccity { get; set; }
        public string Cstate { get; set; }
        public string Czip { get; set; }
    }
}
