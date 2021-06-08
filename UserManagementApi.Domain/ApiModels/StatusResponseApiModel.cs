using System;
using System.Collections.Generic;
using System.Text;

namespace UserManagementApi.Domain.ApiModels
{
    public class StatusResponseApiModel
    {
		public string StatusType { get; set; }
		public string StatusCode { get; set; }
		public string StatusDesc { get; set; }
		public int SequenceNo { get; set; }
		public int TenantId { get; set; }
	}
}
