using System;
using System.Collections.Generic;
using System.Text;

namespace UserManagementApi.Domain.ViewModels
{
    public class SubTransactionApiModel
    {
        public string sub_transactiontype { get; set; }
        public int sub_transactionAmount { get; set; }
        public DateTime sub_transaction_date { get; set; }
    }
}
