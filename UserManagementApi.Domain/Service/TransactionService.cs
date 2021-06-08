
﻿using Denver.Infra.Constants;
using Microsoft.Azure.Amqp.Framing;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Globalization;
﻿using System;
using System.Collections.Generic;
using System.Text;
using System.Threading.Tasks;
using UserManagementApi.Domain.ViewModels;
namespace UserManagementApi.Domain.Service
{
    public partial class UserManagementService
    {


        public async Task<int> SaveLoan(LoanApiModel transactionsApi)
        {
            return await _transactionRepository.SaveLoan(transactionsApi);
        }
        public async Task<int> SaveContribution(ContributionRequestApiModel transactionRequest)
        {
            if (transactionRequest.TransactionDate == null)
            {
                transactionRequest.TransactionDate = DateTime.MaxValue;
            }
            if (transactionRequest.RefundOrPaidDate == null)
            {
                transactionRequest.RefundOrPaidDate = DateTime.MaxValue;
            }
            return await _transactionRepository.SaveContribution(transactionRequest);
        }
        public async Task<int> SaveExpenditure(ExpenditureRequestApiModel transactionRequest)
        {
            if (transactionRequest.TransactionDate == null)
            {
                transactionRequest.TransactionDate = DateTime.MaxValue;
            }
            if (transactionRequest.RefundOrPaidDate == null)
            {
                transactionRequest.RefundOrPaidDate = DateTime.MaxValue;
            }
            return await _transactionRepository.SaveExpenditure(transactionRequest);
        }
        public async Task<int> SaveUnpaidObligation(UnpaidObligationsRequestApiModel transactionRequest)
        {
            if (transactionRequest.TransactionDate == null)
            {
                transactionRequest.TransactionDate = DateTime.MaxValue;
            }
            if (transactionRequest.RefundOrPaidDate == null)
            {
                transactionRequest.RefundOrPaidDate = DateTime.MaxValue;
            }
            return await _transactionRepository.SaveUnpaidObligation(transactionRequest);
        }

        public async Task<int> SaveIE(IERequestApiModel transactionRequest)
        {
            if (transactionRequest.TransactionDate == null)
            {
                transactionRequest.TransactionDate = DateTime.MaxValue;
            }
            if (transactionRequest.RefundOrPaidDate == null)
            {
                transactionRequest.RefundOrPaidDate = DateTime.MaxValue;
            }
            return await _transactionRepository.SaveIE(transactionRequest);
        }
    }
}
