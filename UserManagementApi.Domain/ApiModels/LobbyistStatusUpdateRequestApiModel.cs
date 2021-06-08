using System;
using System.Collections.Generic;
using System.Text;

namespace UserManagementApi.Domain.ApiModels
{
    public class LobbyistStatusUpdateRequestApiModel
    {
        public int Id { get; set; }
        public bool Status { get; set; }
        public string Notes { get; set; }
    }
}
