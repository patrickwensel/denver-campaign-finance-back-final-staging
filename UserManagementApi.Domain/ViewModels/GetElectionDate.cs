using System;
using System.Collections.Generic;
using System.Text;

namespace UserManagementApi.Domain.ViewModels
{
   public  class GetElectionDate
    {
        public int ElectionCycleId { get; set; }
        public string ElectionCycleTypeId { get; set; }
        public DateTime ElectionDate { get; set; }

    }
}
