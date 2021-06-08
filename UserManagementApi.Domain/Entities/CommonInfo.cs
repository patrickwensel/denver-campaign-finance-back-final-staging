using System;
using System.Collections.Generic;
using System.Text;

namespace UserManagementApi.Domain.Entities
{
    public class CommonInfo
    {
        public int TenantId { get; set; }
        public string CreatedBy { get; set; }
        public DateTime? CreatedAt { get; set; }
        public string UpdatedBy { get; set; }
        public DateTime? UpdatedOn { get; set; }
    }
}
