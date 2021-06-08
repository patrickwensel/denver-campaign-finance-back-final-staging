using System;
using System.Collections.Generic;
using System.Text;

namespace UserManagementApi.Domain.ViewModels
{
    public class InvoiceApiModel
    {
        public int InvoiceId { get; set; }

        public string InvoiceType { get; set; }

        public string InvoiceDesc { get; set; }

        public string FilerName { get; set; }

        public string InvoiceStatus { get; set; }

        public decimal Amount { get; set; }

        public decimal RemainingAmount { get; set; }

        public int PenaltyAttachmentId { get; set; }
    }
}
