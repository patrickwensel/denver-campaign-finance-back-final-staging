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
using UserManagementApi.DataCore.Repositories;
using System.Text;
using System.Threading.Tasks;
using UserManagementApi.Domain.Repositories;
using UserManagementApi.Domain.ViewModels;

namespace UserManagementApi.DataCore.Repositories
{

    public class TransactionRepository: ITransactionRepository
    {
        private DataTableToList tableConverter;
        private DBManager dataContext;

        public TransactionRepository(IConfiguration configuration)
        {
            dataContext = new DBManager(configuration.GetConnectionString("AppDB"), DataProvider.PostgreSQL);
            tableConverter = new DataTableToList();
        }

        public async Task<int> SaveLoan(LoanApiModel transactionsApi)
        {
            int loanid = 0;
            IDbDataParameter[] param = new[]
            {
                    dataContext.CreateParameter(DbType.Int32, "_contact_id", 100, transactionsApi.contact_id, ParameterDirection.InputOutput),
                    dataContext.CreateParameter(DbType.String, "_firstName", 200, transactionsApi.firstname, ParameterDirection.InputOutput),
                    dataContext.CreateParameter(DbType.String, "_lastName", 100, transactionsApi.lastname, ParameterDirection.InputOutput),
                    dataContext.CreateParameter(DbType.String, "_addressre1", 150, transactionsApi.Address1, ParameterDirection.InputOutput),
                    dataContext.CreateParameter(DbType.String, "_addressre2", 100 , transactionsApi.Address2, ParameterDirection.InputOutput),
                    dataContext.CreateParameter(DbType.String, "_city", 100, transactionsApi.city, ParameterDirection.InputOutput),
                    dataContext.CreateParameter(DbType.String, "_stateCode", 20, transactionsApi.state, ParameterDirection.InputOutput),
                    dataContext.CreateParameter(DbType.Int32, "_zipCode", 1000, transactionsApi.zip, ParameterDirection.InputOutput),
                    dataContext.CreateParameter(DbType.String,"_occupation", 100, transactionsApi.occupation,  ParameterDirection.InputOutput),
                    dataContext.CreateParameter(DbType.String,"_employee", 100, transactionsApi.employee,  ParameterDirection.InputOutput),
                    dataContext.CreateParameter(DbType.Int32,"_voterId", 100, transactionsApi.voterId,  ParameterDirection.InputOutput),
                    dataContext.CreateParameter(DbType.String,"_entity_type", 100, transactionsApi.entity_type,  ParameterDirection.InputOutput),
                    dataContext.CreateParameter(DbType.Int32,"_entity_id", 100, transactionsApi.entity_id,  ParameterDirection.InputOutput),
                    dataContext.CreateParameter(DbType.String,"_contact_type", 100, transactionsApi.contact_Type,  ParameterDirection.InputOutput),
                    dataContext.CreateParameter(DbType.Int32, "_loanType", 100, transactionsApi.loanType, ParameterDirection.InputOutput),
                    dataContext.CreateParameter(DbType.DateTime, "_date_loan", 100, transactionsApi.date_loan, ParameterDirection.InputOutput),
                    dataContext.CreateParameter(DbType.Int32, "_amount", 1000, transactionsApi.amount, ParameterDirection.InputOutput),
                    dataContext.CreateParameter(DbType.String,"_name_of_guarantor", 100, transactionsApi.name_of_guarantor_or_endorser,  ParameterDirection.InputOutput),
                    dataContext.CreateParameter(DbType.Int32,"_amount_Guaranteed", 100, transactionsApi.Amount_Guaranteed,  ParameterDirection.InputOutput),
                    dataContext.CreateParameter(DbType.String,"_interest_teams", 100, transactionsApi.interest_teams,  ParameterDirection.InputOutput),
                    dataContext.CreateParameter(DbType.DateTime,"_duedate", 100, transactionsApi.duedate,  ParameterDirection.InputOutput),
                    dataContext.CreateParameter(DbType.Boolean,"_contactupdatedflag", 100, transactionsApi.contactupdatedflag,  ParameterDirection.InputOutput),
                    dataContext.CreateParameter(DbType.Int32,"_loanId", 100, transactionsApi.loanId,  ParameterDirection.InputOutput),
            };

            loanid = dataContext.Insert(@"select * from save_loan(:_contact_id,:_firstName,:_lastName,:_addressre1,:_addressre2,:_city,:_stateCode,:_zipCode,:_occupation,:_employee,:_voterId,:_entity_type,:_entity_id,:_contact_type,:_loanType,:_date_loan,:_amount,:_name_of_guarantor,:_amount_Guaranteed,:_interest_teams,:_duedate,:_contactupdatedflag,:_loanId)", commandType: CommandType.Text, param);

            foreach (SubTransactionApiModel sub in transactionsApi.subtransactions)
            {
                IDbDataParameter[] paramu = new[]
                {
                     dataContext.CreateParameter(DbType.Int32, "_loanid", 1000,loanid, ParameterDirection.InputOutput),
                    dataContext.CreateParameter(DbType.String, "_sub_transactiontype", 1000, sub.sub_transactiontype, ParameterDirection.InputOutput),
                    dataContext.CreateParameter(DbType.Int32, "_sub_transactionAmount", 1000,sub.sub_transactionAmount, ParameterDirection.InputOutput),
                    dataContext.CreateParameter(DbType.DateTime, "_sub_transaction_date", 1000, sub.sub_transaction_date, ParameterDirection.InputOutput),
                };
                int Ids = dataContext.Insert(@"select * from save_subtransactions(:_loanid,:_sub_transactiontype, :_sub_transactionAmount, :_sub_transaction_date)", commandType: CommandType.Text, paramu);
            }
            return loanid;
        }
        public async Task<int> SaveContribution(ContributionRequestApiModel transactionRequest)
        {
            int txnId = 0;

            IDbDataParameter[] param = new[]
            {
                dataContext.CreateParameter(DbType.Int32, "txnid", 100, transactionRequest.TransactionId, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.Int32, "txnversionid", 300, transactionRequest.TransactionVersionId, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.Int32, "entityId", 100, transactionRequest.EntityId, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.String, "entityType", 100, transactionRequest.EntityType, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.String, "txntypeid", 100, transactionRequest.TransactionTypeId, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.Decimal, "txnamount", 100, transactionRequest.TransactionAmount, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.Date, "txndate", 100, transactionRequest.TransactionDate, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.Int32, "contactid", 100, transactionRequest.contactInfo.ContactId, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.String, "contacttype", 1000, transactionRequest.contactInfo.ContactType, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.String, "firstname", 100, transactionRequest.contactInfo.FirstName, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.String, "lastname", 100, transactionRequest.contactInfo.LastName, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.String, "employername", 100, transactionRequest.contactInfo.EmployerName, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.String, "occupationdesc", 100, transactionRequest.contactInfo.OccupationDesc, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.String, "voterid", 100, transactionRequest.contactInfo.VoterId, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.String, "caddress1", 100, transactionRequest.contactInfo.Caddress1, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.String, "caddress2", 100, transactionRequest.contactInfo.Caddress2, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.String, "cityname", 100, transactionRequest.contactInfo.CityName, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.String, "statecode", 100, transactionRequest.contactInfo.StateCode, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.String, "zipcode", 100, transactionRequest.contactInfo.Zipcode, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.Int32, "electioncycleid", 100, transactionRequest.ElectioncycleId, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.Boolean, "refundorpaidflag", 100, transactionRequest.RefundOrPaidFlag, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.Date, "refundorpaiddate", 100, transactionRequest.RefundOrPaidDate, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.Decimal, "refundorpaidamount", 100, transactionRequest.RefundOrPaidAmount, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.String, "refundreason", 100, transactionRequest.RefundReason, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.Int32, "parenttxnid", 100, transactionRequest.ParentTransactionId, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.String, "notes", 100, transactionRequest.Notes, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.String, "contributiontypeid", 100, transactionRequest.ContributionTypeId, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.String, "monetarytypeid", 100, transactionRequest.MonetaryTypeId, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.Boolean, "postelectionexemptflag", 100, transactionRequest.PostElectionExemptFlag, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.String, "txncategoryid", 100, transactionRequest.TransactionCategoryId, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.String, "txnpurpose", 100, transactionRequest.TransactionPurpose, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.Boolean, "fairelectionfundflag", 100, transactionRequest.FairElectionFundFlag, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.Boolean, "electioneeringcommflag", 100, transactionRequest.ElectioneeringCommFlag, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.Boolean, "ieflag", 100, transactionRequest.IEFlag, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.Boolean, "nondonorfundflag", 100, transactionRequest.NonDonorFundFlag, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.String, "nondonorsource", 100, transactionRequest.NonDonorSource, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.Decimal, "nondonoramount", 100, transactionRequest.NonDonorAmount, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.String, "methodofcommunication", 100, transactionRequest.MethodOfCommunication, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.String, "ietargettype", 100, transactionRequest.IETargetType, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.String, "positiondesc", 100, transactionRequest.PositionDesc, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.Int32, "ballotissueid", 100, transactionRequest.BallotIssueId, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.String, "ballotissuedesc", 100, transactionRequest.BallotIssueDesc, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.String, "candidatename", 100, transactionRequest.CandidateName, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.String, "officesought", 100, transactionRequest.OfficeSought, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.String, "district", 100, transactionRequest.District, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.String, "adminnotes", 100, transactionRequest.AdminNotes, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.String, "fefstatus", 100, transactionRequest.FEFStatus, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.Int32, "disbursementid", 100, transactionRequest.DisbursementId, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.String, "roletype", 100, transactionRequest.RoleType, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.Boolean, "contactupdatedflag", 100, transactionRequest.contactInfo.ContactUpdatedFlag, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.Int32, "userid", 100, 0, ParameterDirection.InputOutput),
            };

            StringBuilder sbQuery = new StringBuilder();
            sbQuery.Clear();
            sbQuery.AppendLine(@"select * from save_contributiontxn(");
            sbQuery.AppendLine(":txnid, ");
            sbQuery.AppendLine(":txnversionid, ");
            sbQuery.AppendLine(":entityId, ");
            sbQuery.AppendLine(":entityType, ");
            sbQuery.AppendLine(":txntypeid, ");
            sbQuery.AppendLine(":txnamount, ");
            sbQuery.AppendLine(":txndate, ");
            sbQuery.AppendLine(":contactid, ");
            sbQuery.AppendLine(":contacttype, ");
            sbQuery.AppendLine(":firstname, ");
            sbQuery.AppendLine(":lastname, ");
            sbQuery.AppendLine(":employername, ");
            sbQuery.AppendLine(":occupationdesc, ");
            sbQuery.AppendLine(":voterid, ");
            sbQuery.AppendLine(":caddress1, ");
            sbQuery.AppendLine(":caddress2, ");
            sbQuery.AppendLine(":cityname, ");
            sbQuery.AppendLine(":statecode, ");
            sbQuery.AppendLine(":zipcode, ");
            sbQuery.AppendLine(":electioncycleid, ");
            sbQuery.AppendLine(":refundorpaidflag, ");
            sbQuery.AppendLine(":refundorpaiddate, ");
            sbQuery.AppendLine(":refundorpaidamount, ");
            sbQuery.AppendLine(":refundreason, ");
            sbQuery.AppendLine(":parenttxnid, ");
            sbQuery.AppendLine(":notes, ");
            sbQuery.AppendLine(":contributiontypeid, ");
            sbQuery.AppendLine(":monetarytypeid, ");
            sbQuery.AppendLine(":postelectionexemptflag, ");
            sbQuery.AppendLine(":txncategoryid, ");
            sbQuery.AppendLine(":txnpurpose, ");
            sbQuery.AppendLine(":fairelectionfundflag, ");
            sbQuery.AppendLine(":electioneeringcommflag, ");
            sbQuery.AppendLine(":ieflag, ");
            sbQuery.AppendLine(":nondonorfundflag, ");
            sbQuery.AppendLine(":nondonorsource, ");
            sbQuery.AppendLine(":nondonoramount, ");
            sbQuery.AppendLine(":methodofcommunication, ");
            sbQuery.AppendLine(":ietargettype, ");
            sbQuery.AppendLine(":positiondesc, ");
            sbQuery.AppendLine(":ballotissueid, ");
            sbQuery.AppendLine(":ballotissuedesc, ");
            sbQuery.AppendLine(":candidatename, ");
            sbQuery.AppendLine(":officesought, ");
            sbQuery.AppendLine(":district, ");
            sbQuery.AppendLine(":adminnotes, ");
            sbQuery.AppendLine(":fefstatus, ");
            sbQuery.AppendLine(":disbursementid, ");
            sbQuery.AppendLine(":roletype, ");
            sbQuery.AppendLine(":contactupdatedflag, ");
            sbQuery.AppendLine(":userid)");

            txnId = dataContext.Insert(sbQuery.ToString(), commandType: CommandType.Text, param);

            return txnId;

        }
        public async Task<int> SaveExpenditure(ExpenditureRequestApiModel transactionRequest)
        {
            int txnId = 0;

            IDbDataParameter[] param = new[]
            {
                dataContext.CreateParameter(DbType.Int32, "txnid", 100, transactionRequest.TransactionId, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.Int32, "txnversionid", 300, transactionRequest.TransactionVersionId, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.Int32, "entityId", 100, transactionRequest.EntityId, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.String, "entityType", 100, transactionRequest.EntityType, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.String, "txntypeid", 100, transactionRequest.TransactionTypeId, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.Decimal, "txnamount", 100, transactionRequest.TransactionAmount, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.Date, "txndate", 100, transactionRequest.TransactionDate, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.Int32, "contactid", 100, transactionRequest.contactInfo.ContactId, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.String, "contacttype", 1000, transactionRequest.contactInfo.ContactType, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.String, "firstname", 100, transactionRequest.contactInfo.FirstName, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.String, "lastname", 100, transactionRequest.contactInfo.LastName, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.String, "employername", 100, transactionRequest.contactInfo.EmployerName, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.String, "occupationdesc", 100, transactionRequest.contactInfo.OccupationDesc, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.String, "voterid", 100, transactionRequest.contactInfo.VoterId, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.String, "caddress1", 100, transactionRequest.contactInfo.Caddress1, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.String, "caddress2", 100, transactionRequest.contactInfo.Caddress2, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.String, "cityname", 100, transactionRequest.contactInfo.CityName, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.String, "statecode", 100, transactionRequest.contactInfo.StateCode, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.String, "zipcode", 100, transactionRequest.contactInfo.Zipcode, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.Int32, "electioncycleid", 100, transactionRequest.ElectioncycleId, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.Boolean, "refundorpaidflag", 100, transactionRequest.RefundOrPaidFlag, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.Date, "refundorpaiddate", 100, transactionRequest.RefundOrPaidDate, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.Decimal, "refundorpaidamount", 100, transactionRequest.RefundOrPaidAmount, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.String, "refundreason", 100, transactionRequest.RefundReason, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.Int32, "parenttxnid", 100, transactionRequest.ParentTransactionId, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.String, "notes", 100, transactionRequest.Notes, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.String, "contributiontypeid", 100, transactionRequest.ContributionTypeId, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.String, "monetarytypeid", 100, transactionRequest.MonetaryTypeId, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.Boolean, "postelectionexemptflag", 100, transactionRequest.PostElectionExemptFlag, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.String, "txncategoryid", 100, transactionRequest.TransactionCategoryId, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.String, "txnpurpose", 100, transactionRequest.TransactionPurpose, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.Boolean, "fairelectionfundflag", 100, transactionRequest.FairElectionFundFlag, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.Boolean, "electioneeringcommflag", 100, transactionRequest.ElectioneeringCommFlag, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.Boolean, "ieflag", 100, transactionRequest.IEFlag, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.Boolean, "nondonorfundflag", 100, transactionRequest.NonDonorFundFlag, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.String, "nondonorsource", 100, transactionRequest.NonDonorSource, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.Decimal, "nondonoramount", 100, transactionRequest.NonDonorAmount, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.String, "methodofcommunication", 100, transactionRequest.MethodOfCommunication, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.String, "ietargettype", 100, transactionRequest.IETargetType, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.String, "positiondesc", 100, transactionRequest.PositionDesc, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.Int32, "ballotissueid", 100, transactionRequest.BallotIssueId, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.String, "ballotissuedesc", 100, transactionRequest.BallotIssueDesc, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.String, "candidatename", 100, transactionRequest.CandidateName, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.String, "officesought", 100, transactionRequest.OfficeSought, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.String, "district", 100, transactionRequest.District, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.String, "adminnotes", 100, transactionRequest.AdminNotes, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.String, "fefstatus", 100, transactionRequest.FEFStatus, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.Int32, "disbursementid", 100, transactionRequest.DisbursementId, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.String, "roletype", 100, transactionRequest.RoleType, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.Boolean, "contactupdatedflag", 100, transactionRequest.contactInfo.ContactUpdatedFlag, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.String, "_description", 100, transactionRequest.Description, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.Int32, "userid", 100, 0, ParameterDirection.InputOutput),
            };

            StringBuilder sbQuery = new StringBuilder();
            sbQuery.Clear();
            sbQuery.AppendLine(@"select * from save_expendituretxn(");
            sbQuery.AppendLine(":txnid, ");
            sbQuery.AppendLine(":txnversionid, ");
            sbQuery.AppendLine(":entityId, ");
            sbQuery.AppendLine(":entityType, ");
            sbQuery.AppendLine(":txntypeid, ");
            sbQuery.AppendLine(":txnamount, ");
            sbQuery.AppendLine(":txndate, ");
            sbQuery.AppendLine(":contactid, ");
            sbQuery.AppendLine(":contacttype, ");
            sbQuery.AppendLine(":firstname, ");
            sbQuery.AppendLine(":lastname, ");
            sbQuery.AppendLine(":employername, ");
            sbQuery.AppendLine(":occupationdesc, ");
            sbQuery.AppendLine(":voterid, ");
            sbQuery.AppendLine(":caddress1, ");
            sbQuery.AppendLine(":caddress2, ");
            sbQuery.AppendLine(":cityname, ");
            sbQuery.AppendLine(":statecode, ");
            sbQuery.AppendLine(":zipcode, ");
            sbQuery.AppendLine(":electioncycleid, ");
            sbQuery.AppendLine(":refundorpaidflag, ");
            sbQuery.AppendLine(":refundorpaiddate, ");
            sbQuery.AppendLine(":refundorpaidamount, ");
            sbQuery.AppendLine(":refundreason, ");
            sbQuery.AppendLine(":parenttxnid, ");
            sbQuery.AppendLine(":notes, ");
            sbQuery.AppendLine(":contributiontypeid, ");
            sbQuery.AppendLine(":monetarytypeid, ");
            sbQuery.AppendLine(":postelectionexemptflag, ");
            sbQuery.AppendLine(":txncategoryid, ");
            sbQuery.AppendLine(":txnpurpose, ");
            sbQuery.AppendLine(":fairelectionfundflag, ");
            sbQuery.AppendLine(":electioneeringcommflag, ");
            sbQuery.AppendLine(":ieflag, ");
            sbQuery.AppendLine(":nondonorfundflag, ");
            sbQuery.AppendLine(":nondonorsource, ");
            sbQuery.AppendLine(":nondonoramount, ");
            sbQuery.AppendLine(":methodofcommunication, ");
            sbQuery.AppendLine(":ietargettype, ");
            sbQuery.AppendLine(":positiondesc, ");
            sbQuery.AppendLine(":ballotissueid, ");
            sbQuery.AppendLine(":ballotissuedesc, ");
            sbQuery.AppendLine(":candidatename, ");
            sbQuery.AppendLine(":officesought, ");
            sbQuery.AppendLine(":district, ");
            sbQuery.AppendLine(":adminnotes, ");
            sbQuery.AppendLine(":fefstatus, ");
            sbQuery.AppendLine(":disbursementid, ");
            sbQuery.AppendLine(":roletype, ");
            sbQuery.AppendLine(":contactupdatedflag, ");
            sbQuery.AppendLine(":_description, ");
            sbQuery.AppendLine(":userid)");

            txnId = dataContext.Insert(sbQuery.ToString(), commandType: CommandType.Text, param);

            return txnId;

        }
        public async Task<int> SaveUnpaidObligation(UnpaidObligationsRequestApiModel transactionRequest)
        {
            int txnId = 0;

            IDbDataParameter[] param = new[]
            {
                dataContext.CreateParameter(DbType.Int32, "txnid", 100, transactionRequest.TransactionId, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.Int32, "txnversionid", 300, transactionRequest.TransactionVersionId, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.Int32, "entityId", 100, transactionRequest.EntityId, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.String, "entityType", 100, transactionRequest.EntityType, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.String, "txntypeid", 100, transactionRequest.TransactionTypeId, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.Decimal, "txnamount", 100, transactionRequest.TransactionAmount, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.Date, "txndate", 100, transactionRequest.TransactionDate, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.Int32, "contactid", 100, transactionRequest.contactInfo.ContactId, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.String, "contacttype", 1000, transactionRequest.contactInfo.ContactType, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.String, "firstname", 100, transactionRequest.contactInfo.FirstName, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.String, "lastname", 100, transactionRequest.contactInfo.LastName, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.String, "employername", 100, transactionRequest.contactInfo.EmployerName, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.String, "occupationdesc", 100, transactionRequest.contactInfo.OccupationDesc, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.String, "voterid", 100, transactionRequest.contactInfo.VoterId, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.String, "caddress1", 100, transactionRequest.contactInfo.Caddress1, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.String, "caddress2", 100, transactionRequest.contactInfo.Caddress2, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.String, "cityname", 100, transactionRequest.contactInfo.CityName, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.String, "statecode", 100, transactionRequest.contactInfo.StateCode, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.String, "zipcode", 100, transactionRequest.contactInfo.Zipcode, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.Int32, "electioncycleid", 100, transactionRequest.ElectioncycleId, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.Boolean, "refundorpaidflag", 100, transactionRequest.RefundOrPaidFlag, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.Date, "refundorpaiddate", 100, transactionRequest.RefundOrPaidDate, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.Decimal, "refundorpaidamount", 100, transactionRequest.RefundOrPaidAmount, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.String, "refundreason", 100, transactionRequest.RefundReason, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.Int32, "parenttxnid", 100, transactionRequest.ParentTransactionId, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.String, "notes", 100, transactionRequest.Notes, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.String, "contributiontypeid", 100, transactionRequest.ContributionTypeId, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.String, "monetarytypeid", 100, transactionRequest.MonetaryTypeId, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.Boolean, "postelectionexemptflag", 100, transactionRequest.PostElectionExemptFlag, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.String, "txncategoryid", 100, transactionRequest.TransactionCategoryId, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.String, "txnpurpose", 100, transactionRequest.TransactionPurpose, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.Boolean, "fairelectionfundflag", 100, transactionRequest.FairElectionFundFlag, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.Boolean, "electioneeringcommflag", 100, transactionRequest.ElectioneeringCommFlag, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.Boolean, "ieflag", 100, transactionRequest.IEFlag, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.Boolean, "nondonorfundflag", 100, transactionRequest.NonDonorFundFlag, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.String, "nondonorsource", 100, transactionRequest.NonDonorSource, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.Decimal, "nondonoramount", 100, transactionRequest.NonDonorAmount, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.String, "methodofcommunication", 100, transactionRequest.MethodOfCommunication, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.String, "ietargettype", 100, transactionRequest.IETargetType, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.String, "positiondesc", 100, transactionRequest.PositionDesc, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.Int32, "ballotissueid", 100, transactionRequest.BallotIssueId, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.String, "ballotissuedesc", 100, transactionRequest.BallotIssueDesc, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.String, "candidatename", 100, transactionRequest.CandidateName, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.String, "officesought", 100, transactionRequest.OfficeSought, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.String, "district", 100, transactionRequest.District, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.String, "adminnotes", 100, transactionRequest.AdminNotes, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.String, "fefstatus", 100, transactionRequest.FEFStatus, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.Int32, "disbursementid", 100, transactionRequest.DisbursementId, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.String, "roletype", 100, transactionRequest.RoleType, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.Boolean, "contactupdatedflag", 100, transactionRequest.contactInfo.ContactUpdatedFlag, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.Int32, "userid", 100, 0, ParameterDirection.InputOutput),
            };

            StringBuilder sbQuery = new StringBuilder();
            sbQuery.Clear();
            sbQuery.AppendLine(@"select * from save_unpaidobligationtxn(");
            sbQuery.AppendLine(":txnid, ");
            sbQuery.AppendLine(":txnversionid, ");
            sbQuery.AppendLine(":entityId, ");
            sbQuery.AppendLine(":entityType, ");
            sbQuery.AppendLine(":txntypeid, ");
            sbQuery.AppendLine(":txnamount, ");
            sbQuery.AppendLine(":txndate, ");
            sbQuery.AppendLine(":contactid, ");
            sbQuery.AppendLine(":contacttype, ");
            sbQuery.AppendLine(":firstname, ");
            sbQuery.AppendLine(":lastname, ");
            sbQuery.AppendLine(":employername, ");
            sbQuery.AppendLine(":occupationdesc, ");
            sbQuery.AppendLine(":voterid, ");
            sbQuery.AppendLine(":caddress1, ");
            sbQuery.AppendLine(":caddress2, ");
            sbQuery.AppendLine(":cityname, ");
            sbQuery.AppendLine(":statecode, ");
            sbQuery.AppendLine(":zipcode, ");
            sbQuery.AppendLine(":electioncycleid, ");
            sbQuery.AppendLine(":refundorpaidflag, ");
            sbQuery.AppendLine(":refundorpaiddate, ");
            sbQuery.AppendLine(":refundorpaidamount, ");
            sbQuery.AppendLine(":refundreason, ");
            sbQuery.AppendLine(":parenttxnid, ");
            sbQuery.AppendLine(":notes, ");
            sbQuery.AppendLine(":contributiontypeid, ");
            sbQuery.AppendLine(":monetarytypeid, ");
            sbQuery.AppendLine(":postelectionexemptflag, ");
            sbQuery.AppendLine(":txncategoryid, ");
            sbQuery.AppendLine(":txnpurpose, ");
            sbQuery.AppendLine(":fairelectionfundflag, ");
            sbQuery.AppendLine(":electioneeringcommflag, ");
            sbQuery.AppendLine(":ieflag, ");
            sbQuery.AppendLine(":nondonorfundflag, ");
            sbQuery.AppendLine(":nondonorsource, ");
            sbQuery.AppendLine(":nondonoramount, ");
            sbQuery.AppendLine(":methodofcommunication, ");
            sbQuery.AppendLine(":ietargettype, ");
            sbQuery.AppendLine(":positiondesc, ");
            sbQuery.AppendLine(":ballotissueid, ");
            sbQuery.AppendLine(":ballotissuedesc, ");
            sbQuery.AppendLine(":candidatename, ");
            sbQuery.AppendLine(":officesought, ");
            sbQuery.AppendLine(":district, ");
            sbQuery.AppendLine(":adminnotes, ");
            sbQuery.AppendLine(":fefstatus, ");
            sbQuery.AppendLine(":disbursementid, ");
            sbQuery.AppendLine(":roletype, ");
            sbQuery.AppendLine(":contactupdatedflag, ");
            sbQuery.AppendLine(":userid)");

            txnId = dataContext.Insert(sbQuery.ToString(), commandType: CommandType.Text, param);

            return txnId;

        }
        public async Task<int> SaveIE(IERequestApiModel transactionRequest)
        {
            int txnId = 0;

            IDbDataParameter[] param = new[]
            {
                dataContext.CreateParameter(DbType.Int32, "txnid", 100, transactionRequest.TransactionId, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.Int32, "txnversionid", 300, transactionRequest.TransactionVersionId, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.Int32, "entityId", 100, transactionRequest.EntityId, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.String, "entityType", 100, transactionRequest.EntityType, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.String, "txntypeid", 100, transactionRequest.TransactionTypeId, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.Decimal, "txnamount", 100, transactionRequest.TransactionAmount, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.Date, "txndate", 100, transactionRequest.TransactionDate, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.Int32, "contactid", 100, transactionRequest.contactInfo.ContactId, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.String, "contacttype", 1000, transactionRequest.contactInfo.ContactType, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.String, "firstname", 100, transactionRequest.contactInfo.FirstName, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.String, "lastname", 100, transactionRequest.contactInfo.LastName, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.String, "employername", 100, transactionRequest.contactInfo.EmployerName, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.String, "occupationdesc", 100, transactionRequest.contactInfo.OccupationDesc, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.String, "voterid", 100, transactionRequest.contactInfo.VoterId, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.String, "caddress1", 100, transactionRequest.contactInfo.Caddress1, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.String, "caddress2", 100, transactionRequest.contactInfo.Caddress2, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.String, "cityname", 100, transactionRequest.contactInfo.CityName, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.String, "statecode", 100, transactionRequest.contactInfo.StateCode, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.String, "zipcode", 100, transactionRequest.contactInfo.Zipcode, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.Int32, "electioncycleid", 100, transactionRequest.ElectioncycleId, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.Boolean, "refundorpaidflag", 100, transactionRequest.RefundOrPaidFlag, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.Date, "refundorpaiddate", 100, transactionRequest.RefundOrPaidDate, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.Decimal, "refundorpaidamount", 100, transactionRequest.RefundOrPaidAmount, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.String, "refundreason", 100, transactionRequest.RefundReason, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.Int32, "parenttxnid", 100, transactionRequest.ParentTransactionId, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.String, "notes", 100, transactionRequest.Notes, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.String, "contributiontypeid", 100, transactionRequest.ContributionTypeId, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.String, "monetarytypeid", 100, transactionRequest.MonetaryTypeId, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.Boolean, "postelectionexemptflag", 100, transactionRequest.PostElectionExemptFlag, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.String, "txncategoryid", 100, transactionRequest.TransactionCategoryId, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.String, "txnpurpose", 100, transactionRequest.TransactionPurpose, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.Boolean, "fairelectionfundflag", 100, transactionRequest.FairElectionFundFlag, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.Boolean, "electioneeringcommflag", 100, transactionRequest.ElectioneeringCommFlag, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.Boolean, "ieflag", 100, transactionRequest.IEFlag, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.Boolean, "nondonorfundflag", 100, transactionRequest.NonDonorFundFlag, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.String, "nondonorsource", 100, transactionRequest.NonDonorSource, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.Decimal, "nondonoramount", 100, transactionRequest.NonDonorAmount, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.String, "methodofcommunication", 100, transactionRequest.MethodOfCommunication, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.String, "ietargettype", 100, transactionRequest.IETargetType, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.String, "positiondesc", 100, transactionRequest.PositionDesc, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.Int32, "ballotissueid", 100, transactionRequest.BallotIssueId, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.String, "ballotissuedesc", 100, transactionRequest.BallotIssueDesc, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.String, "candidatename", 100, transactionRequest.CandidateName, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.String, "officesought", 100, transactionRequest.OfficeSought, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.String, "district", 100, transactionRequest.District, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.String, "adminnotes", 100, transactionRequest.AdminNotes, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.String, "fefstatus", 100, transactionRequest.FEFStatus, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.Int32, "disbursementid", 100, transactionRequest.DisbursementId, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.String, "roletype", 100, transactionRequest.RoleType, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.Boolean, "contactupdatedflag", 100, transactionRequest.contactInfo.ContactUpdatedFlag, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.Int32, "userid", 100, 0, ParameterDirection.InputOutput),
            };

            StringBuilder sbQuery = new StringBuilder();
            sbQuery.Clear();
            sbQuery.AppendLine(@"select * from save_ietxn(");
            sbQuery.AppendLine(":txnid, ");
            sbQuery.AppendLine(":txnversionid, ");
            sbQuery.AppendLine(":entityId, ");
            sbQuery.AppendLine(":entityType, ");
            sbQuery.AppendLine(":txntypeid, ");
            sbQuery.AppendLine(":txnamount, ");
            sbQuery.AppendLine(":txndate, ");
            sbQuery.AppendLine(":contactid, ");
            sbQuery.AppendLine(":contacttype, ");
            sbQuery.AppendLine(":firstname, ");
            sbQuery.AppendLine(":lastname, ");
            sbQuery.AppendLine(":employername, ");
            sbQuery.AppendLine(":occupationdesc, ");
            sbQuery.AppendLine(":voterid, ");
            sbQuery.AppendLine(":caddress1, ");
            sbQuery.AppendLine(":caddress2, ");
            sbQuery.AppendLine(":cityname, ");
            sbQuery.AppendLine(":statecode, ");
            sbQuery.AppendLine(":zipcode, ");
            sbQuery.AppendLine(":electioncycleid, ");
            sbQuery.AppendLine(":refundorpaidflag, ");
            sbQuery.AppendLine(":refundorpaiddate, ");
            sbQuery.AppendLine(":refundorpaidamount, ");
            sbQuery.AppendLine(":refundreason, ");
            sbQuery.AppendLine(":parenttxnid, ");
            sbQuery.AppendLine(":notes, ");
            sbQuery.AppendLine(":contributiontypeid, ");
            sbQuery.AppendLine(":monetarytypeid, ");
            sbQuery.AppendLine(":postelectionexemptflag, ");
            sbQuery.AppendLine(":txncategoryid, ");
            sbQuery.AppendLine(":txnpurpose, ");
            sbQuery.AppendLine(":fairelectionfundflag, ");
            sbQuery.AppendLine(":electioneeringcommflag, ");
            sbQuery.AppendLine(":ieflag, ");
            sbQuery.AppendLine(":nondonorfundflag, ");
            sbQuery.AppendLine(":nondonorsource, ");
            sbQuery.AppendLine(":nondonoramount, ");
            sbQuery.AppendLine(":methodofcommunication, ");
            sbQuery.AppendLine(":ietargettype, ");
            sbQuery.AppendLine(":positiondesc, ");
            sbQuery.AppendLine(":ballotissueid, ");
            sbQuery.AppendLine(":ballotissuedesc, ");
            sbQuery.AppendLine(":candidatename, ");
            sbQuery.AppendLine(":officesought, ");
            sbQuery.AppendLine(":district, ");
            sbQuery.AppendLine(":adminnotes, ");
            sbQuery.AppendLine(":fefstatus, ");
            sbQuery.AppendLine(":disbursementid, ");
            sbQuery.AppendLine(":roletype, ");
            sbQuery.AppendLine(":contactupdatedflag, ");
            sbQuery.AppendLine(":userid)");

            txnId = dataContext.Insert(sbQuery.ToString(), commandType: CommandType.Text, param);

            return txnId;

        }

    }
}
