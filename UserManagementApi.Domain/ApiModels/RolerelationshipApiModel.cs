using System;
using System.Collections.Generic;
using System.Text;

namespace UserManagementApi.Domain.ApiModels
{
    public class RolerelationshipApiModel
    {
        public int RolerelationshipID { get; set; }
        public int RoleID { get; set; }
        public string RoleType { get; set; }
        public int RefID { get; set; }
        public int RelationshipID { get; set; }
        public int UserID { get; set; }
        public int LobbyistID { get; set; }
    }
}
