using System;
using System.Collections.Generic;
using System.Text;

namespace UserManagementApi.Domain.ViewModels
{
    public class PaymentHistoryResponseApiModel
    {
        public string InvoiceNumber { get; set; }
        public string FilerName { get; set; }
        public DateTime Date { get; set; }
        public double Amount { get; set; }
        public string Description { get; set; }
        public string User { get; set; }
        public string PaymentMethod { get; set; }
        public string Type { get; set; }

    }
}
