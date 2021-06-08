using System;
using System.Collections.Generic;
using System.Text;

namespace UserManagementApi.Domain.ApiModels
{
    public class CommitteeDetailsApiModel
    {
        public CommitteeDetail CommitteeDetail { get; set; }
        public Officer[] Officer { get; set; }
    }
}
