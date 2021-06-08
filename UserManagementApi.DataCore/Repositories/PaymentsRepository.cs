using Denver.DataAccess;
using Denver.Infra.Common;
using Microsoft.Extensions.Configuration;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using UserManagementApi.Domain.Helper;
using UserManagementApi.Domain.Repositories;
using UserManagementApi.Domain.ViewModels;

namespace UserManagementApi.DataCore.Repositories
{
    public class PaymentsRepository : IPaymentsRepository
    {
        private DataTableToList tableConverter;
        private DBManager dataContext;

        public PaymentsRepository(IConfiguration configuration)
        {
            dataContext = new DBManager(configuration.GetConnectionString("AppDB"), DataProvider.PostgreSQL);
            tableConverter = new DataTableToList();
        }
    
        //Save the Fee_settings
        public async Task<int> SaveFees(SaveFeesApiModel saveFeesApi)
        {

            int fees = 0;
            IDbDataParameter[] param = new[]
               {
                  dataContext.CreateParameter(DbType.Int32,"_feeId", 100, saveFeesApi.feeId,  ParameterDirection.InputOutput),
                  dataContext.CreateParameter(DbType.String,"_fname", 200, saveFeesApi.name, ParameterDirection.InputOutput),
                  dataContext.CreateParameter(DbType.Decimal,"_amount", 1000, saveFeesApi.amount,  ParameterDirection.InputOutput),
                  dataContext.CreateParameter(DbType.DateTime,"_duedate", 1000, saveFeesApi.duedate,  ParameterDirection.InputOutput),
                  dataContext.CreateParameter(DbType.DateTime,"_invoice_date", 100, saveFeesApi.invoice_date,  ParameterDirection.InputOutput),
                  dataContext.CreateParameter(DbType.String,"_FilerType_id", 1000, saveFeesApi.FilerType_id,  ParameterDirection.InputOutput),
                };
            fees = dataContext.Insert(@"select * from save_feesdetails(:_feeId, :_fname, :_amount, :_duedate, :_invoice_date,:_FilerType_id)", commandType: CommandType.Text, param);

            return fees;
        }
        //Delete the Fee_settings
        public async Task<int> DeleteFees(int fee_id)
        {
            IDbDataParameter[] param = new[]
                {
                  dataContext.CreateParameter(DbType.Int32,"_fee_id", 100, fee_id, ParameterDirection.InputOutput),
                };
            int res = dataContext.Delete(@"select * from delete_feesettings(:_fee_id)", commandType: CommandType.Text, param);
            return res;
        }
        //Get the Fee_settings
        public async Task<List<GetFeesResposneApiModel>> GetFees()
        {
            DataTable ResultDT = dataContext.GetDataTable(@"select * from get_fees()", commandType: CommandType.Text, null);

            List<GetFeesResposneApiModel> getfees = tableConverter.ConvertToList<GetFeesResposneApiModel>(ResultDT);
            return getfees;
        }
        //Get the GetFeeById in Fee_settings
        public async Task<IEnumerable<GetFeesResposneApiModel>> GetFeeById(int fee_Id)
        {
            IDbDataParameter[] param = new[]
            {
                dataContext.CreateParameter(DbType.Int32, "_feeid", 100, fee_Id, ParameterDirection.InputOutput),
            };
            var dtfeevalue = dataContext.GetDataTable("select * from get_feelistbyid(:_feeid)", commandType: CommandType.Text, param);
            IEnumerable<GetFeesResposneApiModel> resposnefees = ConvertDataTableToList.DataTableToList<GetFeesResposneApiModel>(dtfeevalue);
            return resposnefees;
        }


        //   Fine Settings
        public async Task<int> SaveFine(FineSettingsApiModel fineSetting)
        {

            int fineId = 0;
            IDbDataParameter[] param = new[]
               {
                  dataContext.CreateParameter(DbType.Int32,"_fineid", 100, fineSetting.FineId,  ParameterDirection.InputOutput),
                  dataContext.CreateParameter(DbType.String,"_finename", 200, fineSetting.FineName, ParameterDirection.InputOutput),
                  dataContext.CreateParameter(DbType.Decimal,"_amount", 1000, fineSetting.Amount,  ParameterDirection.InputOutput),
                  dataContext.CreateParameter(DbType.Int32,"_graceperiod", 100, fineSetting.GracePeriod,  ParameterDirection.InputOutput),
                  dataContext.CreateParameter(DbType.String,"_frequency", 100, fineSetting.Frequency,  ParameterDirection.InputOutput),
                  dataContext.CreateParameter(DbType.String,"_filertypeids", 1000, fineSetting.FineFilerTypeIds,  ParameterDirection.InputOutput),
                };
            fineId = dataContext.Insert(@"select * from save_finesettingdetails(:_fineid, :_finename, :_amount, :_graceperiod, :_frequency, :_filertypeids)", commandType: CommandType.Text, param);

            return fineId;
        }

        public async Task<List<GetFineSettingsApiModel>> GetFines()
        {
            DataTable ResultDT = dataContext.GetDataTable(@"select * from get_finesettinglist()", commandType: CommandType.Text, null);

            List<GetFineSettingsApiModel> fineSettingslist = tableConverter.ConvertToList<GetFineSettingsApiModel>(ResultDT);
            return fineSettingslist;
        }

        public async Task<int> DeleteFine(int fineId)
        {
            IDbDataParameter[] param = new[]
                {
                  dataContext.CreateParameter(DbType.Int32,"_fineid", 100, fineId, ParameterDirection.InputOutput),
                };
            int res = dataContext.Delete(@"select * from delete_finesettings(:_fineid)", commandType: CommandType.Text, param);
            return  res;
        }


        public async Task<IEnumerable<GetFineSettingsApiModel>> GetFineById(int fineId)
        {
            IDbDataParameter[] param = new[]
            {
                dataContext.CreateParameter(DbType.Int32, "_fineid", 100, fineId, ParameterDirection.InputOutput),
            };
            var dtFilingPeriod = dataContext.GetDataTable("select * from get_finesettinglistbyid(:_fineid)", commandType: CommandType.Text, param);

            IEnumerable<GetFineSettingsApiModel> responseFineSettings = ConvertDataTableToList.DataTableToList<GetFineSettingsApiModel>(dtFilingPeriod);

            return responseFineSettings;
        }

        //   Fine Settings

        public async Task<int> SavePenalty(PenaltyApiModel penalty)
        {
            int penaltyid = 0;
            IDbDataParameter[] param = new[]
               {

                  dataContext.CreateParameter(DbType.Decimal,"_amount", 100, penalty.Amount,  ParameterDirection.InputOutput),
                  dataContext.CreateParameter(DbType.Date,"_pymtdate", 200, penalty.Paymentdate, ParameterDirection.InputOutput),
                  dataContext.CreateParameter(DbType.String,"_reason", 1000, penalty.Reason,  ParameterDirection.InputOutput),
                  dataContext.CreateParameter(DbType.Int32,"_entityid", 100, penalty.EntityId,  ParameterDirection.InputOutput),
                  dataContext.CreateParameter(DbType.String,"_entitytype",100,penalty.Entitytype,ParameterDirection.InputOutput)
                };

            penaltyid = dataContext.Insert(@"select * from save_penalty(:_amount, :_pymtdate, :_reason, :_entityid,:_entitytype)", commandType: CommandType.Text, param);

            return penaltyid;

        }

        
        public async Task<IEnumerable<InvoiceApiModel>> GetInvoices(int filerid)
        {
            IDbDataParameter[] param = new[]
            {
                 dataContext.CreateParameter(DbType.Int32, "_filerid", 100,filerid , ParameterDirection.InputOutput),
            };
            DataTable ResultDT = dataContext.GetDataTable(@"select * from get_invoicesforadmin(:_filerid)", commandType: CommandType.Text, param);

            IEnumerable<InvoiceApiModel> invoicelist = tableConverter.ConvertToList<InvoiceApiModel>(ResultDT);
            return invoicelist;
        }

        public async Task<IEnumerable<InvoiceApiModel>> GetInvoiceInfoFromId(int invoiceid,int filerid)
        {
            IDbDataParameter[] param = new[]
            {
                 dataContext.CreateParameter(DbType.Int32, "_invoiceid", 100,invoiceid , ParameterDirection.InputOutput),
                  dataContext.CreateParameter(DbType.Int32, "_filerid", 100,filerid , ParameterDirection.InputOutput),
            };
            DataTable ResultDT = dataContext.GetDataTable(@"select * from get_invoiceinfofromid(:_invoiceid,:_filerid)", commandType: CommandType.Text, param);

            IEnumerable<InvoiceApiModel> invoicelist = tableConverter.ConvertToList<InvoiceApiModel>(ResultDT);
            return invoicelist;
        }

        public async Task<IEnumerable<InvoiceApiModel>> GetFilerInvoices(int entityid, string entitytype)
        {
            IDbDataParameter[] param = new[]
            {
                 dataContext.CreateParameter(DbType.Int32, "_entityid", 100,entityid , ParameterDirection.InputOutput),
                 dataContext.CreateParameter(DbType.String, "_entitytype", 100,entitytype , ParameterDirection.InputOutput),
            };
            DataTable ResultDT = dataContext.GetDataTable(@"select * from get_filerinvoices(:_entityid,:_entitytype)", commandType: CommandType.Text, param);

            IEnumerable<InvoiceApiModel> invoicelist = tableConverter.ConvertToList<InvoiceApiModel>(ResultDT);
            return invoicelist;
        }


        public async Task<IEnumerable<FeeSummaryApiModel>> GetFilerOutStandingFeeSummary(int entityid, string entitytype)
        {
            IDbDataParameter[] param = new[]
            {
                 dataContext.CreateParameter(DbType.Int32, "_entityid", 100,entityid , ParameterDirection.InputOutput),
                 dataContext.CreateParameter(DbType.String, "_entitytype", 100,entitytype , ParameterDirection.InputOutput),
            };
            DataTable ResultDT = dataContext.GetDataTable(@"select * from get_fileroutstandingfeesummary(:_entityid,:_entitytype)", commandType: CommandType.Text, param);

            List<FeeSummaryApiModel> feesummary = new List<FeeSummaryApiModel>();
            FeeSummaryApiModel newrecord = new FeeSummaryApiModel();
            if (ResultDT.Rows.Count > 0)
            {

                newrecord.TotalOutstandingFeeBalance = string.Format("{0:G}", ResultDT.Rows[0].Field<decimal>("totalfine"));
                newrecord.TotalFeesCollectedToDate = string.Format("{0:G}", ResultDT.Rows[1].Field<decimal>("totalfine"));
                newrecord.TotalFeesWaived = string.Format("{0:G}", ResultDT.Rows[2].Field<decimal>("totalfine"));
                newrecord.TotalFeesReduced = string.Format("{0:G}", ResultDT.Rows[3].Field<decimal>("totalfine"));
            }
            feesummary.Add(newrecord); 
                     
            return feesummary;
        }


        public async Task<IEnumerable<FeeSummaryApiModel>> GetOutStandingFeeSummary(int filerid)
        {
            IDbDataParameter[] param = new[]
            {
                 dataContext.CreateParameter(DbType.Int32, "_filer_id", 100,filerid , ParameterDirection.InputOutput),
            };
            DataTable ResultDT = dataContext.GetDataTable(@"select * from get_outstandingfeesummary(:_filer_id)", commandType: CommandType.Text, param);

            List<FeeSummaryApiModel> feesummary = new List<FeeSummaryApiModel>();
            FeeSummaryApiModel newrecord = new FeeSummaryApiModel();
            if (ResultDT.Rows.Count > 0)
            {

                newrecord.TotalOutstandingFeeBalance = string.Format("{0:G}", ResultDT.Rows[0].Field<decimal>("totalfine"));
                newrecord.TotalFeesCollectedToDate = string.Format("{0:G}", ResultDT.Rows[1].Field<decimal>("totalfine"));
                newrecord.TotalFeesWaived = string.Format("{0:G}", ResultDT.Rows[2].Field<decimal>("totalfine"));
                newrecord.TotalFeesReduced = string.Format("{0:G}", ResultDT.Rows[3].Field<decimal>("totalfine"));
            }
            feesummary.Add(newrecord);

            return feesummary;
        }

        public async Task<int> UpdateInvoiceStatus (int invoiceid, string invoicestatus)
        {
            IDbDataParameter[] param = new[]
            {
                 dataContext.CreateParameter(DbType.Int32, "_invoiceid", 100,invoiceid , ParameterDirection.InputOutput),
                  dataContext.CreateParameter(DbType.String, "_statustype", 100,invoicestatus , ParameterDirection.InputOutput),
            };

            invoiceid = dataContext.Update(@"select * from Update_InvoiceStatus(:_invoiceid, :_statustype)", commandType: CommandType.Text, param);

            return invoiceid;

        }
        
        public async Task<int> SaveTransaction(PaymentApiModel payment)
        {
            int paymentid = 0;
            IDbDataParameter[] param = new[]
               {

                  dataContext.CreateParameter(DbType.Int32,"_invoiceid", 100, payment.InvoiceId,  ParameterDirection.InputOutput),
                  dataContext.CreateParameter(DbType.Decimal,"_amount", 200, payment.amount, ParameterDirection.InputOutput),
                  dataContext.CreateParameter(DbType.String,"_invoicedesc", 1000, payment.Description,  ParameterDirection.InputOutput),
                  dataContext.CreateParameter(DbType.Date,"_paymentdate", 100, payment.PaymentDate,  ParameterDirection.InputOutput),
                  dataContext.CreateParameter(DbType.String,"_user",100,payment.User,ParameterDirection.InputOutput),
                  dataContext.CreateParameter(DbType.String,"_paymentmethod",100,payment.PaymentMethod,ParameterDirection.InputOutput),
                  
                };

            paymentid = dataContext.Insert(@"select * from save_transaction(:_invoiceid, :_amount, :_invoicedesc, :_paymentdate,:_user,:_paymentmethod)", commandType: CommandType.Text, param);

            return paymentid;

        }
        public async Task<List<PaymentHistoryResponseApiModel>> getPaymentHistory(string filerName, string filerType, DateTime? startDate, DateTime? endDate, int? electionCycleId)
        {
            IDbDataParameter[] param = new[]
             {
                dataContext.CreateParameter(DbType.String, "_searchval", 1000, filerName, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.String, "_filertype", 1000, filerType, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.Date, "_mindate", 1000, startDate, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.Date, "_maxdate", 1000, endDate, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.Int32, "_electioncycleid", 1000, electionCycleId, ParameterDirection.InputOutput),
            };
            var dtPaymentHistory = dataContext.GetDataTable("select * from get_paymenthistory(:_searchval, :_filertype, :_mindate, :_maxdate, :_electioncycleid)", commandType: CommandType.Text, param);

            List<PaymentHistoryResponseApiModel> responsePaymentHis = ConvertDataTableToList.DataTableToList<PaymentHistoryResponseApiModel>(dtPaymentHistory).ToList();

            return responsePaymentHis;
        }

        public async Task<List<PaymentHistoryResponseApiModel>> getFilerPaymentHistory(int filerId)
        {
            IDbDataParameter[] param = new[]
            {
                dataContext.CreateParameter(DbType.Int32, "_filerid", 1000, filerId, ParameterDirection.InputOutput),
            };
            var dtPaymentHistory = dataContext.GetDataTable("select * from get_filerpaymenthistory(:_filerid)", commandType: CommandType.Text, param);

            List<PaymentHistoryResponseApiModel> responsePaymentHis = ConvertDataTableToList.DataTableToList<PaymentHistoryResponseApiModel>(dtPaymentHistory).ToList();

            return responsePaymentHis;
        }

        public async Task<List<PaymentHistoryResponseApiModel>> getEntityPaymentHistory(int entityId, string entityType)
        {
            IDbDataParameter[] param = new[]
            {
                dataContext.CreateParameter(DbType.Int32, "_entityid", 1000, entityId, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.String, "_entitytype", 1000, entityType, ParameterDirection.InputOutput),
            };
            var dtPaymentHistory = dataContext.GetDataTable("select * from get_entitypaymenthistory(:_entityid, :_entitytype)", commandType: CommandType.Text, param);

            List<PaymentHistoryResponseApiModel> responsePaymentHis = ConvertDataTableToList.DataTableToList<PaymentHistoryResponseApiModel>(dtPaymentHistory).ToList();

            return responsePaymentHis;
        }

        public async Task<DataTable> DownloadPaymentHistory(string filerName, string filerType, DateTime? startDate, DateTime? endDate, int? electionCycleId)
        {
            IDbDataParameter[] param = new[]
             {
                dataContext.CreateParameter(DbType.String, "_searchval", 1000, filerName, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.String, "_filertype", 1000, filerType, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.Date, "_mindate", 1000, startDate, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.Date, "_maxdate", 1000, endDate, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.Int32, "_electioncycleid", 1000, electionCycleId, ParameterDirection.InputOutput),
            };
            var dtPaymentHistory = dataContext.GetDataTable("select * from get_paymenthistory(:_searchval, :_filertype, :_mindate, :_maxdate, :_electioncycleid)", commandType: CommandType.Text, param);
            return dtPaymentHistory;
        }
    }
}
