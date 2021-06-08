using System;
using System.Collections.Generic;
using System.Text;

namespace UserManagementApi.Domain.ViewModels
{
    public class LobbyistEmployeeRequestApiModel
    {
        public int LobbyistEntityId { get; set; }
        public Employee Employee { get; set; }
    }
}
