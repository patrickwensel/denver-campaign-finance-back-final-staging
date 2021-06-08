using System;
using System.Collections.Generic;
using System.Text;

namespace UserManagementApi.Domain.ApiModels.Committee
{
    public class ClientsResponseApiModel
    {
        public int ClientId { get; set; }
        public string CompanyName { get; set; }
        public string NatureOfBusiness { get; set; }
        public string LegislativeMatters { get; set; }
        public string Address1 { get; set; }
        public string Address2 { get; set; }
        public string City { get; set; }
        public string StateDesc { get; set; }
        public int Zipcode { get; set; }
    }
}
