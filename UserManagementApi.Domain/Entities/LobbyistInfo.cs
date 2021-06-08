using System;
using System.Collections.Generic;
using System.Text;

namespace UserManagementApi.Domain.Entities
{
    public class LobbyistInfo: UserBaseInfo
    {
        public int LobbyistId { get; set; }
        public string TypeOfUser { get; set; }
    }
}
