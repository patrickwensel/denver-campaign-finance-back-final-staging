using System;
using System.Collections.Generic;
using System.Text;
using System.Threading.Tasks;
using UserManagementApi.Domain.ViewModels;
using UserManagementApi.Domain.ApiModels;
using UserManagementApi.Domain.ApiModels.Committee;

namespace UserManagementApi.Domain.Repositories
{
   public interface ISystemManagementRepository
    {
        Task<int> CreateBallotIssues(BallotIssueApiModel createBallotIssues);
        Task<int> DeleteBallotIssues(int BallotId);
        Task<int> UpdateBallotIssues(BallotIssueApiModel updateBallotIssues);
        Task<List<BallotIssueApiModel>> GetBallotIssuesList();

        Task<int> CreateContributionLimits(ContributionLimitsApiModel createcontributionLimits);
        Task<int> DeleteContributionLimits(int id);
        Task<int> UpdateContributionLimits(ContributionLimitsApiModel updatecontributionLimits);
        Task<List<ContributionLimitsApiModel>> GetContributionLimitsList();

        Task<List<FillerTypeApiModel>> GetFillerTypeList();
        Task<List<DonorTypeApiModel>> GetDonorTypeList();

        Task<List<ElectionApiModel>> GetElectionList();
        Task<List<OfficeTypeApiModel>> GetOfficeTypeList();

        Task<int> SaveCommitteType(GetCommitteListTypeApiModel addcommitteetypes);
     
        Task<int> DeleteCommitteeType(string typeId, string typeCode);

        Task<List<GetCommitteListTypeApiModel>> GetCommitteTypeList();

        Task<int> SaveOffice(AddOfficeApiModel addOffice);
        Task<int> DeleteOffices(string typeId, string typeCode);

        Task<List<AddOfficeApiModel>> GetallOfficeList();

        Task<int> AddMatchingLimits(AddMatchingLimitApiModel addMatchingLimit);

        Task<int> UpdateMatchingLimits(AddMatchingLimitApiModel UpdateMatchingLimit);

        Task<int> DeleteMatchingLimits(int Id);

        Task<List<AddMatchingLimitApiModel>> GetMatchingLimitsList();
        Task<int> CreateModifyFormImageUpload(AppTenantRequestApiModel appTenantRequestAPI); 
        Task<int> UpdateModifyFormImageUpload(AppTenantRequestApiModel appTenantRequestAPI);
        //Get the User Permission Settings
        Task<List<UserPermissionSettingApiModel>> GetUserPermissionList();
        Task<List<CommitteeList>> GetCommiteeListMatchingBallotCode(int ballotIssueID);
        Task<List<AppTenantRequestApiModel>> GetModifyFormImage(int appid);

    }
}
