using System;
using System.Collections.Generic;
using System.Text;
using UserManagementApi.Domain.ApiModels;
using UserManagementApi.Domain.ApiModels.Committee;

namespace UserManagementApi.Domain.ApiModels
{
    public class CommitteeandLobbyistbyUser
    {
        public IEnumerable<CommitteeList> committeelist { get; set; }
        public IEnumerable<LobbyistList> lobbyistlist { get; set; }
        public IEnumerable<IEList> ielist { get; set; }
        public string userType { get; set; }
    }
}
