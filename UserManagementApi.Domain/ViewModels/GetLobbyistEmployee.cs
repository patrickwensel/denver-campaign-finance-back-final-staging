using System;
using System.Collections.Generic;
using System.Text;

namespace UserManagementApi.Domain.ViewModels
{
   public class GetLobbyistEmployee
    {      
        public int ContactId { get; set; }
        public string EmployeeType { get; set; }
        public string EmployeeName { get; set; }
    }
}
