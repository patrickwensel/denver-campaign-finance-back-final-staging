using System;
using System.Collections.Generic;
using System.Text;

namespace UserManagementApi.Domain.ApiModels
{
    public class Officer
    {
        public int UId { get; set; }
        public string UTitle { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public string UAddress1 { get; set; }
        public string UAddress2 { get; set; }
        public string UCity { get; set; }
        public string UStatecode { get; set; }
        public string UState { get; set; }
        public string UCountry { get; set; }
        public string UZipcode { get; set; }
        public string UEmail { get; set; }
        public string UPhone { get; set; }
        public string UGroup { get; set; }
        public DateTime NotifyEmailSentOn { get; set; }
        public DateTime NotifyAcceptedOn { get; set; }
        public bool IsNotifyAccepted { get; set; }
        public string OrgName { get; set; }
        public string BussinessNature { get; set; }
        public string UOccupation { get; set; }
        public string UVoterid { get; set; }
        public string URemarks { get; set; }
        public string OfficeType { get; set; }
    }
}
