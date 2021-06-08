using System;
using System.Collections.Generic;
using System.Text;

namespace UserManagementApi.Domain.ApiModels
{
    public class OfficerListResponseApiModel
    {
        public int officerId { get; set; }
        public string officerFirstName { get; set; }
        public string officerLastName { get; set; }
    }
}
