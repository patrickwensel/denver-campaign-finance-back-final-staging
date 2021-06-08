using System;
using System.Collections.Generic;
using System.Text;

namespace UserManagementApi.Domain.ViewModels
{
    public class StatusUpdateRequestApiModel
    {
        public int Id { get; set; }
        public bool Status { get; set; }
        public string Notes { get; set; }
        public string EntityType { get; set; }
    }
}
