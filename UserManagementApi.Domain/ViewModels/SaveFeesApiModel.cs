using System;
using System.Collections.Generic;
using System.Text;

namespace UserManagementApi.Domain.ViewModels
{
    public class SaveFeesApiModel
    {

        public int feeId { get; set; }
        public string name { get; set; }
        public decimal amount { get; set; }

        public DateTime? duedate { get; set; }
        public DateTime invoice_date { get; set; }
        public string FilerType_id { get; set; }

    }
}
