using Denver.Infra.Constants;
using System;
using System.Collections.Generic;
using System.Text;

namespace UserManagementApi.Domain.ApiModels
{
    public class SelectedCommittee
    {
        public int RefId { get; set; }
    }
    public class CommitteeAddlInfoApiModel
    {
        public int UserID { get; set; }
        public string UserType{ get; set; } = Constants.USER_CANDIDATE;
        public int UserRoleId { get; set; }
        public SelectedCommittee[] Committee { get; set; }
        public int RelationshipId { get; set; } = 0;
    }
}
