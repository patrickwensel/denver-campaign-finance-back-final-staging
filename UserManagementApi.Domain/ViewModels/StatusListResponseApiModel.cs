using System;
using System.Collections.Generic;
using System.Text;

namespace UserManagementApi.Domain.ViewModels
{
   public class StatusListResponseApiModel
    {
		public string StatusType { get; set; }
		public string StatusCode { get; set; }
		public string StatusDesc { get; set; }
		public int StatusOrder { get; set; }
		public bool IsActive { get; set; }
	}
}
