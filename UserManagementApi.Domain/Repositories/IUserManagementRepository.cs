using Denver.Common;
using Denver.Infra;
using System;
using System.Collections.Generic;
using System.Data;
using System.Text;
using System.Threading.Tasks;
using UserManagementApi.Domain.ApiModels;
using UserManagementApi.Domain.ApiModels.Committee;
using UserManagementApi.Domain.ApiModels.LookUp;
using UserManagementApi.Domain.ApiModels.State;
using UserManagementApi.Domain.Entities;
using UserManagementApi.Domain.ViewModels;

namespace UserManagementApi.Domain.Repositories
{
    public interface IUserManagementRepository
    {

        Task<int> LoginInformation(UserModel contactinfo, string SecretKey);
        Task<int> ResetPassword(ResetPasswordModel contactinfo, string SecretKey);
        Task<int> SelectUserType(UserTypeModel contactinfo);
        Task<int> CreateContactInfo(ContactInformationApiModel contactinfo);
        Task<int> CreateLobbyistEmployee(LobbyistInfo contactinfo);
        Task<bool> CreateLobbyist(LobbyistOldApiModel contactinfo);
        Task<int> DeleteLobbyistUser(int LobbyistEmployeeID);
        Task<int> UpdateLobbyistEmployee(LobbyistInfo contactinfo);
        Task<int> DeleteLobbyistEmployee(int LobbyistEmployeeID);
        Task<List<LobbyistOldApiModel>> GetLobbyistEmployeebyID(int LobbyistEmployeeID);
        Task<List<LobbyistOldApiModel>> GetLobbyistEmployeebyList();
        Task<List<UserTypeRefDataModel>> GetAllUserType();
        Task<int> UpdateExpireDateTime(EmailReq emailReq);
        Task<int> CreateRolerelationship(RolerelationshipApiModel contactinfo);
        Task<bool> UpdateIEFAdditionalInfo(IEFAddlInfoApiModel IEFDetails);
        Task<bool> UpdateLobbyistAdditionalInfo(LobbyistAddlInfoApiModel lobbyistAddlInfoDetails);
        Task<List<LobbyistOldApiModel>> GetLobbyistList();
        Task<IEnumerable<LobbyistOldApiModel>> GetLobbyListByName(string searchLobbyName);
        Task<IEnumerable<UAConfirmationAndSubmitResponseApiModel>> GetUserAccountConfirmAndSubmit(UAConfirmationAndSubmitRequestApiModel UAConfirmDetails);
        Task<IEnumerable<UserBaseInfo>> GetOfficerListByName(OfficerListRequestApiModel searchOfficer);
        Task<IEnumerable<ClientsResponseApiModel>> GetClientListByName(ClientListRequestApiModel searchOfficer);
        Task<LoginUserInfoResposeApiModel> ValidateCredentials(LoginUserInfoRequestApiModel loginUserInfoDetail, string secretKey);
        Task<int> SendIndependentSpender(IndependentSpenderAffiliationApiModel independentSpenderAffiliation);
        Task<IEnumerable<IndependentSpenderApiModel>> GetIndependentSpender(SearchIERequestApiModel searchIERequest);
		Task<LobbyistDetailResponseApiModel> GetLobbyistDetail(int lobbyistId);
        Task<IEnumerable<SwitchCommitteeDetail>> GetSwitchCommitteeDetails(int id);
        Task<IEnumerable<SwitchLobbyistDetail>> GetSwitchLobbyistDetails(int id);
        Task<IEnumerable<SwitchIEDetail>> GetSwitchIEDetails(int id);
        Task<IEnumerable<ManageFilerResponseApiModel>> GetManageFilerDetail(ManageFilerRequestApiModel manageFilerRequest);
        Task<DataTable> DownloadManageFiler(ManageFilerRequestApiModel manageFilerRequest);
        Task<IEnumerable<UserInfoResposeApiModel>> GetUserDetails(int UserID);
		Task<UserEmailDetailResponseApiModel> GetLobbyistUserEmail(int Id);
        Task<bool> UpdateLobbyistStatus(LobbyistStatusUpdateRequestApiModel lobbyistStatusUpdate);
        int SaveRefreshToken(RefreshToken newRefreshToken);
        RefreshToken GetRefreshTokenByToken(string token);
        int UpdateRefreshToken(string token, bool IsUsed);
        Task<int> VaidateEmailCheck(string UserEmailID);
        Task<int> UpdateIEAdditionalInfo(IEUpdateAddlInfoRequestApiModel iEUpdateAddlInfo);
        Task<UserEntitiesResponseApiModel> GetUserEntites(int userId);
        Task<List<RolesandTypesApiModel>> GetUserRoles(int userId);
        Task<UserEntityDetailsResponseApiModel> GetUserEntityDetails(int entityId, string entityType);
        Task<IEnumerable<ManageFilersResponseApiModel>> GetManageFilers(ManageFilersRequestApiModel manageFilerRequest);
        Task<int> SaveIndependentSpenderAffiliation(IndependentSpendersAffiliationApiModel independentSpenderAffiliation);
        Task<List<GetLobbyistEmployee>> GetIndependentSpender(int independentSpenderId);
        Task<List<string>> GetFilerNamesByName(string searchName);
        Task<int> FilerInviteUser(AddUserPaymentApiModel addUserPayment);
        Task<List<GetCurrentUser>> GetFilerUsers(int entityId, string entityType);

        Task<int> DeleteFilerContact(int contactId, int filerId);
        Task<IEnumerable<MakeTreasurerApiModel>> SaveMakeTreasurer(MakeTreasurerApiModel addMakeTreasurer);
        Task<List<GetAdminUsers>> GetFilerAdminUsers(int filerId, int userId, string filerType, string status, DateTime lastActiveStartDate, DateTime lastActiveEndDate, DateTime createdStartDate, DateTime createdEndDate);
        Task<List<GetAdminUsers>> GetUserAffiliations(int filerId, int userId, string filerType, string status, DateTime lastActiveStartDate, DateTime lastActiveEndDate, DateTime createdStartDate, DateTime createdEndDate);
    }
}
