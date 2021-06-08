using System;
using System.Collections.Generic;
using System.Text;

namespace UserManagementApi.Domain.ViewModels
{
    public class CommitteeDetailsResponseApiModel
    {
        public List<CommitteeResponseApiModel> CommitteeDetail { get; set; }
        public List<CommitteeContactResponseApiModel> CommitteeContactDetail { get; set; }
        public List<GetOfficerApiModel> OfficerDetail { get; set; }
        public List<BankInfoApiModel> BankInfoDetail { get; set; }
    }
}
