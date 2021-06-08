using System;
using System.Collections.Generic;
using System.Text;

namespace UserManagementApi.Domain.ViewModels
{
    public class Client
    {
        public int ContactId { get; set; }
        public int LobbyistClientId { get; set; }
        public string CompanyName { get; set; }
        public int EmployeeId { get; set; }
        public string NatureOfBusiness { get; set; }
        public string LegislativeMatters { get; set; }
        public string Address1 { get; set; }
        public string Address2 { get; set; }
        public string City { get; set; }
        public string StateCode { get; set; }
        public string ZipCode { get; set; }
    }
}
