using System;
using System.Collections.Generic;
using System.Text;

namespace UserManagementApi.Domain.ViewModels
{
    public class StateListResponseApiModel
    {
		public string StateId { get; set; }
		public string StateCode { get; set; }
		public string StateDesc { get; set; }
		public int SequenceNo { get; set; }
		public int TenantId { get; set; }
		public string CreatedBy { get; set; }
		public string CreatedAt { get; set; }
		public string UpdatedBy { get; set; }
		public string UpdatedOn { get; set; }
	}
}
