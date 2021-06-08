using System;
using System.Collections.Generic;
using System.Text;

namespace UserManagementApi.Domain.ApiModels
{
    public class LobbyistDetailResponseApiModel
    {
        public int LobbyistId { get; set; }
        public int Year { get; set; }
        public string OrganisationName { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public string Email { get; set; }
        public string Address1 { get; set; }
        public string Address2 { get; set; }
        public string City { get; set; }
        public string State { get; set; }
        public string ZipCode { get; set; }
        public string Phone { get; set; }
        public LobbyistDetail Lobbyist { get; set; }
        public LobbyistEmployee[] Employees { get; set; }
        public LobbyistSubContractor[] SubContractors { get; set; }
        public LobbyistClient[] Clients { get; set; }
        public LobbyistRelationship[] Relationships { get; set; }
        public LobbyistSignature Signature { get; set; }
        public string Status { get; set; }
    }
}
