using System;
using System.Collections.Generic;
using System.Text;

namespace UserManagementApi.Domain.ViewModels
{
    public class LobbyistRelationshipRequestApiModel
    {
        public int LobbyistEntityId { get; set; }
        public Relationship Relationship { get; set; }
    }
}
