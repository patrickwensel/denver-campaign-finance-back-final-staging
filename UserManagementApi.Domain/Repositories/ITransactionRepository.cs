using System;
using System.Collections.Generic;
using System.Text;
using System.Threading.Tasks;
using UserManagementApi.Domain.ViewModels;

namespace UserManagementApi.Domain.Repositories
{

   public interface ITransactionRepository
    {
        Task<int> SaveLoan(LoanApiModel transactionsApi);
		Task<int> SaveContribution(ContributionRequestApiModel transactionRequest);
        Task<int> SaveExpenditure(ExpenditureRequestApiModel transactionRequest);
        Task<int> SaveUnpaidObligation(UnpaidObligationsRequestApiModel transactionRequest);
        Task<int> SaveIE(IERequestApiModel transactionRequest);
    }
}
