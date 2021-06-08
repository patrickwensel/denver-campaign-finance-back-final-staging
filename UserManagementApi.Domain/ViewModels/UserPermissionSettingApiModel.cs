using System;
using System.Collections.Generic;
using System.Text;

namespace UserManagementApi.Domain.ViewModels
{
    public class UserPermissionSettingApiModel
    {
        public int id { get; set; }
        public int Tenantid { get; set; }
        public string Modulename { get; set; }
        public int Candidate { get; set; }
        public int Treasurer { get; set; }
        public int CommitteeOfficer { get; set; }
        public int PrimaryLobbyList { get; set; }
        public int Lobbyist { get; set; }
        public int Official { get; set; }
    }
}
