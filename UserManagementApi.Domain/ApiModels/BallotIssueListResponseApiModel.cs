using System;
using System.Collections.Generic;
using System.Text;

namespace UserManagementApi.Domain.ApiModels.Committee
{
    public class BallotIssueListResponseApiModel
    {
        public int BallotId { get; set; }
		public string BallotIssueCode { get; set; }
		public string BallotIssue { get; set; }
		public DateTime? ElectionDate { get; set; }
		public int SequenceNo { get; set; }
		public string createdBy { get; set; }
		public DateTime? createdAt { get; set; }
		public string updatedBy { get; set; }
		public DateTime? updatedOn { get; set; }
	}
}
