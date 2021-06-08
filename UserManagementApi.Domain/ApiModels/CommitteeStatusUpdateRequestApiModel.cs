using System;
using System.Collections.Generic;
using System.Text;

namespace UserManagementApi.Domain.ApiModels
{
    public class CommitteeStatusUpdateRequestApiModel
    {
        public int Id { get; set; }
        public bool Status { get; set; }
        public string Notes { get; set; }
    }
}
