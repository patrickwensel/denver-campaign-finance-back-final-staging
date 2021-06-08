using System;
using System.Collections.Generic;
using System.Text;

namespace UserManagementApi.Domain.ApiModels
{
    public class LobbyistRelationship
    {
        public string Lobbyist { get; set; }
        public string Relationship { get; set; }
        public string OfficeName { get; set; }
        public string OfficeTitle { get; set; }
        public string EntityName { get; set; }
    }
}
