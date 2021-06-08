using System;
using System.Collections.Generic;
using System.Text;

namespace UserManagementApi.Domain.ViewModels
{
    public class LobbyistAffiliationApiModel
    {
        public int ContactID { get; set; }
        public string Notes { get; set; }
        public IEnumerable<LobbyistAffiliationDetailApiModel> LobbyistIds { get; set; }
    }
}
