using System;
using System.Collections.Generic;
using System.Text;

namespace UserManagementApi.Domain.ViewModels
{
    public class LobbyistSubcontractorRequestApiModel
    {
        public int LobbyistEntityId { get; set; }
        public Subcontractor Subcontractor { get; set; }
    }
}
