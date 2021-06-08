using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Text;

namespace UserManagementApi.Domain.ViewModels
{
    public class CommitteeOtherContactApiModel
    {
        public string Phone { get; set; }
        public string Email { get; set; }
        public string AltPhone { get; set; }
        public string AltEmail { get; set; }
    }
}
