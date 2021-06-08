using Denver.Infra.Constants;
using System;
using System.Collections.Generic;
using System.Text;

namespace UserManagementApi.Domain.ApiModels
{
    public class SelectedLobbyist
    {
        public int RefId { get; set; }
    }
    public class LobbyistAddlInfoApiModel
    {
        public int UserID { get; set; }
        public string UserType { get; set; } = Constants.USER_LOBBYIST;
        public int UserRoleId { get; set; }
        public SelectedLobbyist[] Lobbyist { get; set; }
        public int RelationshipId { get; set; }
    }
}
