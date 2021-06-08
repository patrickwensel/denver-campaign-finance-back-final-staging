using System;
using System.Collections.Generic;
using System.Text;

namespace UserManagementApi.Domain.ViewModels
{
    public class LobbyistClientApiModel
    {
        public int LobbyistEntityId { get; set; }
        public Client Client { get; set; }
    }
}
