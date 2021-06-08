using System;
using System.Collections.Generic;
using System.Text;

namespace UserManagementApi.Domain.Entities
{
    public  class UserInfo: UserBaseInfo
    {
        public string Title { get; set; }
        public string UserGroup { get; set; }
        public string NotifyEmailSentOn { get; set; }
        public string NotifyAcceptedOn { get; set; }
        public bool IsNotifyAccepted { get; set; }
        public string Password { get; set; }
        public string OrganisationName { get; set; }
        public string BusinessNature { get; set; }
        public string Occupation { get; set; }
        public string VoterId { get; set; }
        public string Remarks { get; set; }
    }
}
