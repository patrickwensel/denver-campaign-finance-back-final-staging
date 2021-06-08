using System;
using System.Collections.Generic;
using System.Text;

namespace UserManagementApi.Domain.ViewModels
{
    public class LobbyistEntitiesResponseApiModel
    {
        public int contactId { get; set; }
        public string firstName { get; set; }
        public string middleName { get; set; }
        public string lastName { get; set; }
        public string fullName { get; set; }
        public string phoneNo { get; set; }
        public string emailId { get; set; }
        public string contactType { get; set; }
        public string orgName { get; set; }
        public string lobFullName { get; set; }
        public int employeeId { get; set; }
        public string natureOfBusiness { get; set; }
        public string legislativeMatters { get; set; }
        public string address1 { get; set; }
        public string address2 { get; set; }
        public string city { get; set; }
        public string stateCode { get; set; }
        public string zipCode { get; set; }
        public string officialName { get; set; }
        public string officialTitle { get; set; }
        public string relationship { get; set; }
        public string entityName { get; set; }

    }
}
