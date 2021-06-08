using System;
using System.Collections.Generic;
using System.Text;

namespace UserManagementApi.Domain.ViewModels
{
    public class LobbyistEntitiesByNameRequestApiModel
    {
        public int LobbyistId { get; set; }
        public string SearchName { get; set; }
        public string RoleType { get; set; }
    }
}
