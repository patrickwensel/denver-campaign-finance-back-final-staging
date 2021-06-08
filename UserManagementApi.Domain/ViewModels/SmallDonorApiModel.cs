using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Text;

namespace UserManagementApi.Domain.ViewModels
{
    public class SmallDonorApiModel
    {
        [Required]
        public int ContactID { get; set; }
        public SmallDonorCommitteeDetailApiModel SmallDonorCommitteeDetail { get; set; }
        public CommitteeContactApiModel CommitteeContactDetail { get; set; }
        public CommitteeOtherContactApiModel CommitteeOtherContactDetail { get; set; }
    }
}
