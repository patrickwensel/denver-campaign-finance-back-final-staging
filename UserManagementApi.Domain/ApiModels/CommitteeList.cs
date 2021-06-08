using System;
using System.Collections.Generic;
using System.Text;

namespace UserManagementApi.Domain.ApiModels
{
    public class CommitteeList
    {
        public int CommitteeID { get; set; }
        public string CommitteeName { get; set; }
        public string CommitteePosition { get; set; }
    }
}
