using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Text;

namespace UserManagementApi.Domain.ViewModels
{
    public class IssueCommitteeApiModel
    {
        [Required]
        public int ContactID { get; set; }
        public IssueCommitteDetailApiModel IssueCommitteeDetail { get; set; }
        public CommitteeContactApiModel CommitteeContactDetail { get; set; }
        public CommitteeOtherContactApiModel CommitteeOtherContactDetail { get; set; }
    }
}
