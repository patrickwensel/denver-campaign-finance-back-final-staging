using System;
using System.Collections.Generic;
using System.Text;

namespace UserManagementApi.Domain.ViewModels
{
    // Method of Get CommitteeByname
    public class CommitteeListResponseApiModels
    {
        public int CommitteeId { get; set; }
        public string CommitteeName { get; set; }
        public string CommitteeType { get; set; }
    }
}
