using Denver.Common;
using Denver.Infra;
using Microsoft.Identity.Client;
using System;
using System.Collections.Generic;
using System.Data;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using UserManagementApi.Domain.ViewModels;
using UserManagementApi.Domain.ApiModels.Committee;
using UserManagementApi.Domain.ApiModels.LookUp;
using UserManagementApi.Domain.ApiModels.State;
using UserManagementApi.Domain.Entities;
using UserManagementApi.Domain.Entities.Committee;
using UserManagementApi.Domain.ApiModels;

namespace UserManagementApi.Domain.Service
{
    public interface IUserManagementService
    {
        Task<int> LoginInformation(UserModel contactinfo, string SecretKey);
        Task<int> ResetPassword(ResetPasswordModel contactinfo, string SecretKey);
        Task<int> SelectUserType(UserTypeModel contactinfo);
        Task<int> CreateContactInfo(ContactInformationApiModel contactinfo);
        Task<int> CreateLobbyistEmployee(LobbyistInfo contactinfo);
        Task<bool> CreateLobbyist(LobbyistOldApiModel contactinfo, EmailReq emailReq);
        Task<int> UpdateLobbyistEmployee(LobbyistInfo contactinfo);
        Task<int> DeleteLobbyistUser(int LobbyistEmployeeID);
        Task<int> DeleteLobbyistEmployee(int LobbyistEmployeeID);
        Task<List<UserTypeRefDataModel>> GetAllUserType();
        Task<int> UpdateExpireDateTime(EmailReq emailReq);
        Task<int> CreateRolerelationship(RolerelationshipApiModel contactinfo);
        Task<IEnumerable<CommitteeListResponseApiModel>> GetCommitteeList();
        Task<IEnumerable<BallotIssueListResponseApiModel>> GetBallotIssueList();
        Task<IEnumerable<LookUpListResponseApiModel>> GetLookUps(string LookUpType);
        Task<IEnumerable<ClientsResponseApiModel>> GetClientListByName(ClientListRequestApiModel searchOfficer);
        Task<IEnumerable<LobbyistOldApiModel>> GetLobbyListByName(string searchLobbyName);
        Task<IEnumerable<StatesListResponseApiModel>> GetStateList();
        Task<bool> UpdateIEFAdditionalInfo(IEFAddlInfoApiModel IEFDetails, EmailReq emailReq);
        Task<bool> UpdateCommitteeAdditionalInfo(CommitteeAddlInfoApiModel committeeAddlInfoDetails, EmailReq emailReq);
        Task<bool> UpdateLobbyistAdditionalInfo(LobbyistAddlInfoApiModel lobbyistAddlInfoDetails, EmailReq emailReq);
        Task<List<LobbyistOldApiModel>> GetLobbyistList();
        Task<IEnumerable<UAConfirmationAndSubmitResponseApiModel>> GetUserAccountConfirmAndSubmit(UAConfirmationAndSubmitRequestApiModel UAConfirmDetails);
        Task<IEnumerable<CommitteeListResponseApiModel>> GetCommitteeListByName(CommitteeListRequestApiModel searchCommitte);
        Task<IEnumerable<UserBaseInfo>> GetOfficerListByName(OfficerListRequestApiModel searchOfficer);
        Task<LoginResultApiModel> Authenticate(IPublicClientApplication app, LoginUserInfoRequestApiModel loginUserInfoDetail, string secretKey, JwtTokenSettings jwtSettings, CancellationToken ct = new CancellationToken());

        Task<LoginResultApiModel> RefreshToken(LoggedInUser loggedInUser, string secret, string token, string refreshToken, TimeSpan tokenLifeTime, CancellationToken ct);
        Task<bool> SendMail(EmailReq emailInfo);


        Task<int> CreateBallotIssues(BallotIssueApiModel createBallotIssues);
        Task<int> DeleteBallotIssues(int BallotId);
        Task<int> UpdateBallotIssues(BallotIssueApiModel updateBallotIssues);
        Task<List<BallotIssueApiModel>> GetBallotIssuesList();

        Task<int> CreateContributionLimits(ContributionLimitsApiModel contributionLimits);
        Task<int> DeleteContributionLimits(int id);
        Task<int> UpdateContributionLimits(ContributionLimitsApiModel contributionLimits);
        Task<List<ContributionLimitsApiModel>> GetContributionLimitsList();

        Task<List<FillerTypeApiModel>> GetFillerTypeList();
        Task<List<DonorTypeApiModel>> GetDonorTypeList();
        Task<List<OfficeTypeApiModel>> GetOfficeTypeList();
        Task<List<ElectionApiModel>> GetElectionList();

        Task<IEnumerable<SwitchCommitteeDetail>> GetCommitteeorLobbyistbyID(int id, string type);
        Task<IEnumerable<CommitteeandLobbyistbyUser>> GetCommitteeandLobbyistbyUser(int id);
        Task<bool> UpdateCommitteeStatus(CommitteeStatusUpdateRequestApiModel committeeStatusUpdate, EmailReq emailReq);
        Task<IEnumerable<CommitteeListResponseApiModel>> SearchCommittee(SearchCommitteeRequestApiModel searchreq);
        Task<IEnumerable<ManageCommitteListResponseApiModel>> GetManageCommitteeList(ManageCommitteListRequestApiModel manageCommitteListRequest);
        Task<ApiModels.CommitteeDetailsApiModel> GetCommitteeDetail(int committteeId);
        Task<int> SaveCommitteType(GetCommitteListTypeApiModel addCommittetype);
        Task<int> DeleteCommitteeType(string typeId, string typeCode);
        Task<List<GetCommitteListTypeApiModel>> GetCommitteTypeList();
        Task<int> SaveOffice(AddOfficeApiModel addOffice);
        Task<int> DeleteOffices(string typeId, string typeCode);
        Task<List<AddOfficeApiModel>> GetallOfficeList();
        Task<int> AddMatchingLimits(AddMatchingLimitApiModel AddMachingLimits);
        Task<int> UpdateMatchingLimits(AddMatchingLimitApiModel UpdateMachingLimits);
        Task<int> DeleteMatchingLimits(int Id);
        Task<List<AddMatchingLimitApiModel>> GetMatchingLimitsList();
        Task<int> SendIndependentSpender(IndependentSpenderAffiliationApiModel independentSpenderAffiliation);
        Task<IEnumerable<IndependentSpenderApiModel>> GetIndependentSpender(SearchIERequestApiModel searchIERequest);
        Task<int> TerminateCommittee(int committteeId);
        Task<LobbyistDetailResponseApiModel> GetLobbyistDetail(int lobbyistId);
        Task<int> CreateModifyFormImageUpload(AppTenantRequestApiModel appTenantRequestAPI);
        Task<int> UpdateModifyFormImageUpload(AppTenantRequestApiModel appTenantRequestAPI);
        //Get the UserPermission Settings
        Task<List<UserPermissionSettingApiModel>> GetUserPermissionList();
        Task<IEnumerable<StatusResponseApiModel>> GetStatus(StatusRequestApiModel statusRequest);
        Task<IEnumerable<SwitchCommitteeDetail>> GetSwitchCommitteeDetails(int id);
        Task<IEnumerable<SwitchLobbyistDetail>> GetSwitchLobbyistDetails(int id);
        Task<IEnumerable<SwitchIEDetail>> GetSwitchIEDetails(int id);
        Task<IEnumerable<ManageFilerResponseApiModel>> GetManageFilerDetail(ManageFilerRequestApiModel manageFilerRequest);

        Task<List<CommitteeList>> GetCommiteeListMatchingBallotCode(int ballotIssueID);

        Task<List<AppTenantRequestApiModel>> GetModifyFormImage(int appid);

        Task<ManageCommitteeDownload> DownloadManageFiler(ManageFilerRequestApiModel manageFilerRequest);
        Task<IEnumerable<UserInfoResposeApiModel>> GetUserDetails(int UserID);
        Task<bool> UpdateLobbyistStatus(LobbyistStatusUpdateRequestApiModel lobbyistStatusUpdate, EmailReq emailReq);
        Task<bool> SendCommitteeNote(SendCommitteNoteRequestApiModel sendCommitteNote, EmailReq emailReq);
        Task<IEnumerable<LookUpResponseApiModel>> GetLookUpTypeList(string LookUpType); 
        Task<IEnumerable<StateListResponseApiModel>> GetStatesList();
        Task<IEnumerable<StatusListResponseApiModel>> GetStatusList(string statusCode);
        Task<int> CreateContact(ContactUserAccountApiModel createContact, string SecretKey);
        Task<int> CreateCommittee(CommitteApiModel createCommittee);
        Task<int> SaveOfficer(OfficersApiModel createOfficer);
        // Method of Get CommitteeByname
        Task<IEnumerable<CommitteeListResponseApiModels>> GetCommitteeByName(string searchCommittee, string committeetype); 
        Task<int> VaidateEmailCheck(string UserEmailID);
        Task<List<GetOfficerApiModel>> GetOfficersList(int committeeid);
        Task<int> UpdateBankInfo(BankInfoApiModel updateBankInfo);
        Task<List<EmployeeList>> GetEmployees(int lobbyistId);
        Task<int> SaveLobbyist(LobbyistApiModel saveLobbyist);

        Task<int> SaveLobbyistAffiliation(LobbyistAffiliationApiModel lobbyistAffiliation);
        Task<int> SaveCommitteeAffiliation(CommitteeAffiliationApiModel committeeAffiliation);
        Task<int> DeleteOfficer(int contactid);
        Task<int> UpdateLobbyistSignature(LobbyistSignatureApiModel lobbyistSignature);
        Task<int> CreateIssueCommittee(IssueCommitteeApiModel createIssueCommittee);
        Task<int> CreatePACCommittee(PACCommitteeApiModel createPACCommittee);
        Task<int> CreateSmallDonorCommittee(SmallDonorApiModel createSmallDonorCommittee);
        Task<List<LobbyistEntitiesResponseApiModel>> GetLobbyistEntities(int lobbyistId, string roleType);
        Task<List<GetLobbyistEmployee>> GetLobbyist(int lobbyistId);
        Task<List<LobbyistEntitiesResponseApiModel>> GetLobbyistEntitiesbyName(int lobbyistId, string searchName, string roleType);
        Task<int> SaveEmployee(LobbyistEmployeeRequestApiModel lobbyistEmployee);
        Task<int> DeleteEmployee(int contactId);
        Task<int> SaveSubcontractor(LobbyistSubcontractorRequestApiModel lobbyistSubcontractor);
        Task<int> DeleteSubcontractor(int contactId);
        Task<int> SaveClient(LobbyistClientApiModel lobbyistClient);
        Task<int> DeleteClient(int contactId);
        Task<int> SaveRelationship(LobbyistRelationshipRequestApiModel lobbyistRelationship);
        Task<int> DeleteRelationship(int contactId);
        Task<int> UpdateIEAdditionalInfo(IEUpdateAddlInfoRequestApiModel iEUpdateAddlInfo);
        Task<List<GetOfficerApiModel>> GetOfficersListByName(string officerName, int committeeId);
        Task<int> CreateCoveredOfficial(int contactId);
        Task<int> SaveElectionCycle(ElectionCycleRequestApiModel electionCycleRequest);
        Task<int> DeleteElectionCycle(int electionCycleId);
        Task<IEnumerable<ElectionCycleResponseApiModel>> GetElectionCycleById(int electionCycleId);
        Task<int> SaveEvents(SaveEventsApiModel saveEvents);
        //Delete the Events
        Task<int> DeleteEvents(int eventId);
        //Get the EventList
        Task<List<SaveEventsResponseApiModel>> GetEventList();

        Task<IEnumerable<ElectionCycleDetailResponseApiModel>> GetElectionCycles();
        Task<IEnumerable<ElectionCycleDDResponseApiModel>> GetElectionCycleByType(string typeCode);
        Task<CalendarEventsApiModel> GetCalendarDetails(string filerType, string month, string year);
        Task<UserEntitiesResponseApiModel> GetUserEntites(int userId);

        /// Filing Period
        /// 
        Task<int> SaveFilingPeriod(FilingPeriodApiModel filingPeriod);
        Task<List<GetFilingPeriodApiModel>> GetFilingPeriods();
        Task<int> DeleteFilingPeriod(int filingperiodid);
        Task<IEnumerable<GetFilingPeriodApiModel>> GetFilingPeriodById(int filingperiodid);
        // Filing Period
        Task<UserEntityDetailsResponseApiModel> GetUserEntityDetails(int entityId, string entityType);
        Task<LobbyistSignatureDetailApiModel> GetLobbyistSignature(int lobbyistId);
        Task<CommitteeDetailsResponseApiModel> GetCommitteeDetails(int committeeid);
        Task<IEnumerable<GetEventsResponseApiModel>> GetEventsById(int eventId);
        Task<LobbyistContactInfoApiModel> GetLobbyistContactInformation(int lobbyistId);
        Task<IEnumerable<ManageFilersResponseApiModel>> GetManageFilers(ManageFilersRequestApiModel manageFilerRequest);
        Task<int> UpdateCommitteeorLobbyistStatus(StatusUpdateRequestApiModel statusUpdate);
        Task<int> SaveIndependentSpenderAffiliation(IndependentSpendersAffiliationApiModel independentSpenderAffiliation);
        Task<List<GetLobbyistEmployee>> GetIndependentSpender(int independentSpenderId);
        /// Fine Settings
        Task<int> SaveFine(FineSettingsApiModel fineSetting);
        Task<List<GetFineSettingsApiModel>> GetFines();
        Task<int> DeleteFine(int fineId);
        Task<IEnumerable<GetFineSettingsApiModel>> GetFineById(int fineId);
        // Fine Settings
        Task<List<string>> GetFilerNamesByName(string searchName);

        //Save the FeeSettings
        Task<int> SaveFees(SaveFeesApiModel saveFeesApi);
        //Delete the Feesettings
        Task<int> DeleteFees(int fee_Id);
        //Get the Fees
        Task<List<GetFeesResposneApiModel>> GetFees();
        //Get the FeeById
        Task<IEnumerable<GetFeesResposneApiModel>> GetFeeById(int fee_Id);
        Task<IEnumerable<GetElectionDate>> GetElectionDates();
        Task<int> FilerInviteUser(AddUserPaymentApiModel addUserPayment);
        Task<List<GetCurrentUser>> GetFilerUsers(int entityId, string entityType);

        Task<int> SaveLoan(LoanApiModel transactionsApi);

        Task<int> DeleteFilerContact(int contactId, int filerId);
        Task<int> SavePenalty(PenaltyApiModel savePenaltyApi);

        Task<IEnumerable<MakeTreasurerApiModel>> SaveMakeTreasurer(MakeTreasurerApiModel addMakeTreasurer);
        Task<IEnumerable<InvoiceApiModel>> GetInvoices(int filerid);
        Task<int> SaveTransaction(PaymentApiModel paymentapi);

        Task<IEnumerable<InvoiceApiModel>> GetFilerInvoices(int entityid, string entitytype);

        Task<IEnumerable<FeeSummaryApiModel>> GetOutStandingFeeSummary(int filerid);

        Task<IEnumerable<FeeSummaryApiModel>> GetFilerOutStandingFeeSummary(int entityid, string entitytype);

        Task<IEnumerable<InvoiceApiModel>> GetInvoiceInfoFromId(int invoiceid, int filerid);

        Task<int> UpdateInvoiceStatus(int invoiceid, string invoicestatus);

        Task<List<PaymentHistoryResponseApiModel>> getPaymentHistory(string filerName, string filerType, string startDate, string endDate, int? electionCycleId);
        Task<List<PaymentHistoryResponseApiModel>> getFilerPaymentHistory(int filerId);
        Task<List<PaymentHistoryResponseApiModel>> getEntityPaymentHistory(int entityId, string entityType);

        Task<HistoryResponseApiModel> DownloadPaymentHistory(string filerName, string filerType, string startDate, string endDate, int? electionCycleId);
        Task<IEnumerable<NamesByTxnTypeResponseApiModel>> GetLendersPayersContributerContacts(int entityId, string entityType, string searchName);
        Task<TxnContactDetailResponseApiModel> GetContactDetailsById(int contactId);

        Task<int> SaveContribution(ContributionRequestApiModel transactionRequest);

        Task<int> SaveExpenditure(ExpenditureRequestApiModel transactionRequest);
        Task<int> SaveUnpaidObligation(UnpaidObligationsRequestApiModel transactionRequest);
        Task<List<GetAdminUsers>> GetFilerAdminUsers(int filerId, int userId, string filerType, string status, DateTime lastActiveStartDate, DateTime lastActiveEndDate, DateTime createdStartDate, DateTime createdEndDate);
        Task<List<GetAdminUsers>> GetUserAffiliations(int filerId, int userId, string filerType, string status, DateTime lastActiveStartDate, DateTime lastActiveEndDate, DateTime createdStartDate, DateTime createdEndDate);
        Task<int> SaveIE(IERequestApiModel transactionRequest);
    }
}
