using System;
using System.Collections.Generic;
using System.Text;

namespace UserManagementApi.Domain.ApiModels
{
    public class LobbyingListApiResponseModel
    {
        public int LobbyistId { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
    }
}
