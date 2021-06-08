using System;
using System.Collections.Generic;
using System.Text;

namespace UserManagementApi.Domain.ViewModels
{
    public class EmployeeList
    {
        public int ContactId { get; set; }
        public string ContactType { get; set; }
        public string FirstName { get; set; }
        public string MiddleName { get; set; }
        public string LastName { get; set; }
        public string FullName { get; set; }
        public string PhoneNo { get; set; }
        public string EmailId { get; set; }
    }
}
