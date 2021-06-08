using System;
using System.Collections.Generic;
using System.Text;

namespace UserManagementApi.Domain.ViewModels
{
   public  class PaymentApiModel
    {

        public int InvoiceId { get; set; }

        public decimal amount { get; set; }

        public string Description { get; set; }

        public DateTime PaymentDate { get; set; }
        
        public string User { get; set; }

        public string PaymentMethod { get; set; }

        
    }
}
