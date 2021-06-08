using System;
using System.Collections.Generic;
using System.Text;

namespace UserManagementApi.Domain.ViewModels
{
   public class LobbyistContactInfoApiModel
    {
        public string Year { get; set; }
        public string OrgType { get; set; }
        public string OrgName { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public string Address1 { get; set; }
        public string Address2 { get; set; }
        public string City { get; set; }
        public string StateCode { get; set; }
        public int ZipCode { get; set; }
        public string PhoneNo { get; set; }
        public string Email { get; set; }
        public string StatusCode { get; set; }
    }
}
