using System;
using System.Collections.Generic;
using System.Text;

namespace UserManagementApi.Domain.ApiModels
{
    public class ManageCommitteListResponseApiModel
    {
        public int CommitteId { get; set; }
        public string CommitteeName { get; set; }
        public string CommitteeStatus { get; set; }
        public string TreasureName { get; set; }
        public DateTime? LastFillingDate { get; set; }
        public DateTime? CreatedDate { get; set; }
        public DateTime? ElectionDate { get; set; }
    }
}
