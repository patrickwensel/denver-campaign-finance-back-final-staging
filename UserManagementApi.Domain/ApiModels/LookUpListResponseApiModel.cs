using System;
using System.Collections.Generic;
using System.Text;
using UserManagementApi.Domain.Entities.LookUp;

namespace UserManagementApi.Domain.ApiModels.LookUp
{
    public class LookUpListResponseApiModel
    {
        public string LookUpType { get; set; }
        public string LookUpTypeId { get; set; }
        public string LookUpName { get; set; }
        public string LookUpDesc { get; set; }
        public int SequenceNo { get; set; }
        public int TenantId { get; set; }
        public string CreatedBy { get; set; }
        public DateTime? CreatedAt { get; set; }
        public string UpdatedBy { get; set; }
        public DateTime? UpdatedOn { get; set; }
    }
}
