using System;
using System.Collections.Generic;
using System.Text;

namespace UserManagementApi.Domain.ViewModels
{
    public class CommitteeContactResponseApiModel
    {
        public int ContactID { get; set; }
        public string Address1 { get; set; }
        public string Address2 { get; set; }
        public string City { get; set; }
        public string State { get; set; }
        public string Zip { get; set; }
        public string Email { get; set; }
        public string Phone { get; set; }
        public string AltEmail { get; set; }
        public string AltPhone { get; set; }
        public string CampaignWebsite { get; set; }
    }
}
