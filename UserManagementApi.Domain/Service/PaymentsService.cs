using Denver.Infra.Constants;
using Denver.Infra.Utility;
using Microsoft.Azure.Amqp.Framing;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Data;
using System.Globalization;
using System.Text;
using System.Threading.Tasks;
using UserManagementApi.Domain.ViewModels;


namespace UserManagementApi.Domain.Service
{
    public partial class UserManagementService
    {
        //Fine Settings
        public async Task<int> SaveFine(FineSettingsApiModel fineSetting)
        {
            return await _paymentsRepository.SaveFine(fineSetting);
        }

        public async Task<List<GetFineSettingsApiModel>> GetFines()
        {
            return await _paymentsRepository.GetFines();

        }

        public async Task<int> DeleteFine(int fineId)
        {
            return await _paymentsRepository.DeleteFine(fineId);
        }

        public async Task<IEnumerable<GetFineSettingsApiModel>> GetFineById(int fineId)
        {
            return await _paymentsRepository.GetFineById(fineId);
        }

        //Fine Settings

        public async Task<int> SaveFees(SaveFeesApiModel saveFeesApi)
        {
            return await _paymentsRepository.SaveFees(saveFeesApi);
        }
        public async Task<int> DeleteFees(int fee_Id)
        {
            return await _paymentsRepository.DeleteFees(fee_Id);
        }
        public async Task<List<GetFeesResposneApiModel>> GetFees()
        {
            return await _paymentsRepository.GetFees();
        }
        public async Task<IEnumerable<GetFeesResposneApiModel>> GetFeeById(int fee_Id)
        {
            return await _paymentsRepository.GetFeeById(fee_Id);
        }

        public async Task<int> SavePenalty(PenaltyApiModel penalty)
        {
            return await _paymentsRepository.SavePenalty(penalty);
        }

        public async Task<int> SaveTransaction(PaymentApiModel payment)
        {
            return await _paymentsRepository.SaveTransaction(payment);
        }

        public async Task<IEnumerable<InvoiceApiModel>> GetInvoices(int filerid)
        {
            return await _paymentsRepository.GetInvoices(filerid); 
        }
        public async Task<IEnumerable<InvoiceApiModel>> GetFilerInvoices(int entityid, string entitytype)
       {
            return await _paymentsRepository.GetFilerInvoices(entityid, entitytype);
       }
       public async Task<IEnumerable<FeeSummaryApiModel>> GetOutStandingFeeSummary(int filerid)
        {
            return await _paymentsRepository.GetOutStandingFeeSummary(filerid);
        }
       public async Task<IEnumerable<FeeSummaryApiModel>> GetFilerOutStandingFeeSummary(int entityid, string entitytype)
        {
            return await _paymentsRepository.GetFilerOutStandingFeeSummary(entityid, entitytype);
        }
       public async Task<IEnumerable<InvoiceApiModel>> GetInvoiceInfoFromId(int invoiceid,int filerid)
        {
            return await _paymentsRepository.GetInvoiceInfoFromId(invoiceid,filerid);
        }
        public async Task<int> UpdateInvoiceStatus(int invoiceid, string invoicestatus)
        {
            return await _paymentsRepository.UpdateInvoiceStatus(invoiceid, invoicestatus);
        }

        public async Task<List<PaymentHistoryResponseApiModel>> getPaymentHistory(string filerName, string filerType, string startDate, string endDate, int? electionCycleId)
        {
            DateTime minDate = DateTime.Now;
            DateTime maxDate = DateTime.Now;
            if (startDate == null)
            {
                minDate = DateTime.MinValue;
            }
            if (endDate == null)
            {
                maxDate = DateTime.MaxValue;
            }
            if (filerName == null)
            {
                filerName = "";
            }
            if (filerType == null)
            {
                filerType = "";
            }
            return await _paymentsRepository.getPaymentHistory(filerName, filerType, minDate, maxDate, electionCycleId);
        }
        public async Task<List<PaymentHistoryResponseApiModel>> getFilerPaymentHistory(int filerId)
        {
            return await _paymentsRepository.getFilerPaymentHistory(filerId);
        }

        public async Task<List<PaymentHistoryResponseApiModel>> getEntityPaymentHistory(int entityId, string entityType)
        {
            return await _paymentsRepository.getEntityPaymentHistory(entityId, entityType);
        }
        public async Task<HistoryResponseApiModel> DownloadPaymentHistory(string filerName, string filerType, string startDate, string endDate, int? electionCycleId)
        {
            var latest = new HistoryResponseApiModel();
            DateTime minDate = DateTime.Now;
            DateTime maxDate = DateTime.Now;
            if (startDate == null)
            {
                minDate = DateTime.MinValue;
            }
            if (endDate == null)
            {
                maxDate = DateTime.MaxValue;
            }
            if (filerName == null)
            {
                filerName = "";
            }
            if (filerType == null)
            {
                filerType = "";
            }

            DataTable dataTable = await _paymentsRepository.DownloadPaymentHistory(filerName, filerType, minDate, maxDate, electionCycleId);
            latest.ExcelDocumentByte = ExportToExcel.GenerateExcel(dataTable);
            return latest;
        }
    }
}
