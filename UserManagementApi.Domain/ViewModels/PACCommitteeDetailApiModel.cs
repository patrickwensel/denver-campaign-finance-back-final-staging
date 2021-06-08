using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Text;

namespace UserManagementApi.Domain.ViewModels
{
    public class PACCommitteeDetailApiModel
    {
        public int CommitteeID { get; set; }
        [Required]
        [StringLength(500)]
        public string CommitteeName { get; set; }
        public string CommitteeTypeID { get; set; }
        public string Purpose { get; set; }
    }
}
