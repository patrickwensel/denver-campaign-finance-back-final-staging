using System;
using System.Collections.Generic;
using System.Text;

namespace UserManagementApi.Domain.ViewModels
{
    public class PenaltyApiModel
    {
        public int PenaltyID { get; set; }
        public Decimal Amount { get; set; }
        public string Reason { get; set; }
        public int EntityId { get; set; }

        public string Entitytype { get; set; }
        public DateTime Paymentdate { get; set; }


    }
}
