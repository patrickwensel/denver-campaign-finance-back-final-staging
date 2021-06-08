using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Text;

namespace UserManagementApi.Domain.ViewModels
{
    public class CommitteApiModel
    {
        [Required]
        public int ContactID { get; set; }
        public CommitteeDetailApiModel CommitteeDetail { get; set; }
        public CandidateContactApiModel CandidateContactDetail { get; set; }
        public CommitteeContactApiModel CommitteeContactDetail { get; set; }
        public CommitteeOtherContactApiModel CommitteeOtherContactDetail { get; set; }
    }
}
