using System;
using System.Collections.Generic;
using System.Text;

namespace UserManagementApi.Domain.Entities
{
    public class OfficerInfo: UserBaseInfo
    {
        public string OfficerType { get; set; }
        public string Description { get; set; }
    }
}
