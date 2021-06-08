using System;
using System.Collections.Generic;
using System.Text;

namespace UserManagementApi.Domain.ViewModels
{
    public class Relationship
    {
        public int ContactId { get; set; }
        public int RelationshipId { get; set; }
        public int EmployeeId { get; set; }
        public string OfficeName { get; set; }
        public string OfficeTitle { get; set; }
        public string RelationshipDesc { get; set; }
        public string EntityName { get; set; }
    }
}
