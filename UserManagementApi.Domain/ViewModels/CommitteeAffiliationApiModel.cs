using System;
using System.Collections.Generic;
using System.Text;

namespace UserManagementApi.Domain.ApiModels
{
    public class CommitteeAffiliationApiModel
    {
        public int ContactID { get; set; }
        public string Notes { get; set; }
        public IEnumerable<CommitteeAffiliationDetailApiModel> CommitteeIds { get; set; }
    }
}
