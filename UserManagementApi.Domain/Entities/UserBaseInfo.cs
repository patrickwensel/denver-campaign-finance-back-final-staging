using System;
using System.Collections.Generic;
using System.Text;

namespace UserManagementApi.Domain.Entities
{
    public class UserBaseInfo: CommonInfo
    {
        public int UserId { get; set; }
        public string Title { get; set; } = "";
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public string Address1 { get; set; }
        public string Address2 { get; set; }
        public string City { get; set; }
        public string StateCode { get; set; }
        public string Zipcode { get; set; }
        public string CountryCode { get; set; }
        public string Email { get; set; }
        public string Phone { get; set; }
        public DateTime? NotifyEmailSentOn { get; set; } = DateTime.Now;
        public DateTime? NotifyAcceptedOn { get; set; } = DateTime.Now;
        public bool IsNotifyAccepted { get; set; } = false;
        public string UserName { get; set; } = "";
        public string UserPassword { get; set; } = "";
        public string Salt { get; set; } = "";
        public string OrganisationName { get; set; } = "";
        public string BusinessName { get; set; } = "";
        public string Occupation { get; set; } = "";
        public string VoterId { get; set; } = "";
        public string Remarks { get; set; } = "";
    }
}
