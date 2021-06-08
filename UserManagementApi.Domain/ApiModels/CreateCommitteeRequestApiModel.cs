using System;
using System.Collections.Generic;
using System.Text;
using UserManagementApi.Domain.Entities.Committee;

namespace UserManagementApi.Domain.ApiModels.Committee
{
    public class CreateCommitteeRequestApiModel
    {
        public CommitteeInfo CommitteeInfo { get; set; }
    }
}
