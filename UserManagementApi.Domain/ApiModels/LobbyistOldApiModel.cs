using System;
using System.Collections.Generic;
using System.Text;
using UserManagementApi.Domain.Entities;

namespace UserManagementApi.Domain.ApiModels
{
    public class LobbyistOldApiModel
    {
        public int LobbyistID { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public string Email { get; set; }
        public string OrganisationName { get; set; }
        public string Address1 { get; set; }
        public string Address2 { get; set; }
        public string City { get; set; }
        public string StateCode { get; set; }
        public string ZipCode { get; set; }
        public string Phone { get; set; }
        public string ImageURL { get; set; }
        public string Type { get; set; }
        public int Year { get; set; }
        public int UserID { get; set; }
        public LobbyistInfo[] EmployeeInfo { get; set; }
        public LobbyistInfo[] SubContractorInfo { get; set; }
        public LobbyistInfo[] ClientInfo { get; set; }
        public LobbyistInfo[] Relationship { get; set; }
        public string Signature { get; set; }
    }
}
