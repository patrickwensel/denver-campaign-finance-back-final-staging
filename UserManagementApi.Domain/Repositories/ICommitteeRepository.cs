using System;
using System.Collections.Generic;
using System.Text;
using System.Threading.Tasks;
using UserManagementApi.Domain.ApiModels;
using UserManagementApi.Domain.ViewModels;
using UserManagementApi.Domain.ApiModels.Committee;
using UserManagementApi.Domain.ViewModels;

namespace UserManagementApi.Domain.Repositories
{
    public interface ICommitteeRepository
    {
        Task<IEnumerable<CommitteeListResponseApiModel>> GetCommitteeList();
        Task<IEnumerable<BallotIssueListResponseApiModel>> GetBallotIssueList();
        Task<bool> UpdateCommitteeAdditionalInfo(CommitteeAddlInfoApiModel committeeAddlInfo);
        Task<IEnumerable<CommitteeListResponseApiModel>> GetCommitteeListByName(CommitteeListRequestApiModel searchCommitte);
        Task<IEnumerable<SwitchCommitteeDetail>> GetCommitteeorLobbyistbyID(int id, string type);
        Task<IEnumerable<CommitteeandLobbyistbyUser>> GetCommitteeandLobbyistbyUser(int id);
        Task<bool> UpdateCommitteeStatus(CommitteeStatusUpdateRequestApiModel committeeStatusUpdate);
        Task<IEnumerable<CommitteeListResponseApiModel>> SearchCommittee(SearchCommitteeRequestApiModel searchreq);
		Task<IEnumerable<ManageCommitteListResponseApiModel>> GetManageCommitteeList(ManageCommitteListRequestApiModel manageCommitteListRequest);
        Task<ApiModels.CommitteeDetailsApiModel> GetCommitteeDetail(int committteeId);
		Task<int> TerminateCommittee(int committteeId);
        Task<UserEmailDetailResponseApiModel> GetCommitteeUserEmail(int Id);
        Task<bool> SendCommitteeNote(SendCommitteNoteRequestApiModel sendCommitteNote);
        Task<int> CreateCommittee(CommitteApiModel createCommittee);
        Task<int> SaveOfficer(OfficersApiModel createOfficer);
       //Method of GetCommitteeByName
        Task<IEnumerable<CommitteeListResponseApiModels>> GetCommitteeByName(string searchCommittee, string committeetype); 
        Task<List<GetOfficerApiModel>> GetOfficersList(int committeeid);
        Task<int> UpdateBankInfo(BankInfoApiModel updateBankInfo);
        Task<int> SaveCommitteeAffiliation(CommitteeAffiliationApiModel committeeAffiliation);
        Task<int> DeleteOfficer(int contactid);
        Task<int> CreateIssueCommittee(IssueCommitteeApiModel createIssueCommittee);
        Task<int> CreatePACCommittee(PACCommitteeApiModel createPACCommittee);
        Task<int> CreateSmallDonorCommittee(SmallDonorApiModel createSmallDonorCommittee);
        Task<List<GetOfficerApiModel>> GetOfficersListByName(string officerName, int committeeId);
        Task<int> CreateCoveredOfficial(int contactId);
        Task<CommitteeDetailsResponseApiModel> GetCommitteeDetails(int committeeid);
        Task<int> UpdateCommitteeorLobbyistStatus(StatusUpdateRequestApiModel statusUpdate);
    }
}
