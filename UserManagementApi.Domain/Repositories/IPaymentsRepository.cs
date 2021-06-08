using System;
using System.Collections.Generic;
using System.Data;
using System.Text;
using System.Threading.Tasks;
using UserManagementApi.Domain.ViewModels;

namespace UserManagementApi.Domain.Repositories
{
    public interface IPaymentsRepository
    {
        Task<int> SaveFees(SaveFeesApiModel saveFeesApi);
        Task<int> DeleteFees(int fee_Id);
        Task<List<GetFeesResposneApiModel>> GetFees();
        Task<IEnumerable<GetFeesResposneApiModel>> GetFeeById(int fee_Id);

        /// Fine Settings
        /// 
        Task<int> SaveFine(FineSettingsApiModel fineSetting);
        Task<List<GetFineSettingsApiModel>> GetFines();
        Task<int> DeleteFine(int fineId);
        Task<IEnumerable<GetFineSettingsApiModel>> GetFineById(int fineId);
        // Fine Settings

        Task<int> SavePenalty(PenaltyApiModel penalty);

        Task<int> SaveTransaction(PaymentApiModel payment);

        Task<IEnumerable<InvoiceApiModel>> GetInvoices(int filerid);

        Task<IEnumerable<InvoiceApiModel>> GetFilerInvoices(int entityid, string entitytype);

        Task<IEnumerable<FeeSummaryApiModel>> GetOutStandingFeeSummary(int filerid);

        Task<IEnumerable<FeeSummaryApiModel>> GetFilerOutStandingFeeSummary(int entityid, string entitytype);

        Task<IEnumerable<InvoiceApiModel>> GetInvoiceInfoFromId(int invoiceid, int filerid);

        Task<int> UpdateInvoiceStatus(int invoiceid,string invoicestatus);
        Task<List<PaymentHistoryResponseApiModel>> getPaymentHistory(string filerName, string filerType, DateTime? startDate, DateTime? endDate, int? electionCycleId);
        Task<List<PaymentHistoryResponseApiModel>> getFilerPaymentHistory(int filerId);
        Task<List<PaymentHistoryResponseApiModel>> getEntityPaymentHistory(int entityId, string entityType);

        Task<DataTable> DownloadPaymentHistory(string filerName, string filerType, DateTime? startDate, DateTime? endDate, int? electionCycleId);
    }
}
