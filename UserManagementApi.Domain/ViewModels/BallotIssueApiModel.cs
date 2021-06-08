using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Text;

namespace UserManagementApi.Domain.ViewModels
{
    public class BallotIssueApiModel
    {
		public int BallotId { get; set; }
		public string BallotIssueCode { get; set; }
		public string BallotIssue { get; set; }
		public string CreatedBy { get; set; }
		public DateTime? CreatedAt { get; set; }
		public string UpdatedBy { get; set; }
		public DateTime? UpdatedOn { get; set; }
		public string ElectionCycle { get; set; }
		public string Description { get; set; }
		public int? Flag { get; set; }
	}
}
