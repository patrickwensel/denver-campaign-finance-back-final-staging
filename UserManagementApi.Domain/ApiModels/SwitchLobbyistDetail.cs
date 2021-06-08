using System;
using System.Collections.Generic;
using System.Text;

namespace UserManagementApi.Domain.ApiModels
{
    public class SwitchLobbyistDetail
    {
        public int LobbyistID { get; set; }
        public string LobbyistName { get; set; }
        public string LobbyistType { get; set; }
        public string OrganizationName { get; set; }
        public string PrimaryLobbyistName { get; set; }
    }
}
