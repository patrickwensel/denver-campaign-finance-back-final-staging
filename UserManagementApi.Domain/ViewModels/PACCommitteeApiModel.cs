using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Text;

namespace UserManagementApi.Domain.ViewModels
{
    public class PACCommitteeApiModel
    {
        [Required]
        public int ContactID { get; set; }
        public PACCommitteeDetailApiModel PACCommitteeDetail { get; set; }
        public CommitteeContactApiModel CommitteeContactDetail { get; set; }
        public CommitteeOtherContactApiModel CommitteeOtherContactDetail { get; set; }
    }
}
