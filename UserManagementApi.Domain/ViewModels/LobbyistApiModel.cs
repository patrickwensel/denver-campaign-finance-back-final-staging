using System;
using System.Collections.Generic;
using System.Text;

namespace UserManagementApi.Domain.ViewModels
{
    public class LobbyistApiModel
    {
        public int LobbyistID { get; set; }
        public string Year { get; set; }
        public string LobbyistType { get; set; }
        public int ContactID { get; set; }
        public string SignFirstName { get; set; }
        public string SignLastName { get; set; }
        public string SignEmail { get; set; }
        public string SignImageURL { get; set; }
        public string AdminNotes { get; set; }
        public LobbyistContactApiModel LobbyistDetail { get; set; }
    }
}
