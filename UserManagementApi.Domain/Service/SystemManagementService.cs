using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Text;
using System.Threading.Tasks;
using UserManagementApi.Common;
using UserManagementApi.Domain.ViewModels;
using UserManagementApi.Domain.ApiModels;
using UserManagementApi.Domain.ApiModels.Committee;
using UserManagementApi.Domain.Repositories;

namespace UserManagementApi.Domain.Service
{
    public partial class UserManagementService
    {
        public async Task<int> CreateBallotIssues(BallotIssueApiModel BallotIssues)
        {
            return await _systemManagementRepository.CreateBallotIssues(BallotIssues);
        }

        public async Task<int> UpdateBallotIssues(BallotIssueApiModel BallotIssues)
        {
            return await _systemManagementRepository.UpdateBallotIssues(BallotIssues);
        }

        public async Task<int> DeleteBallotIssues(int BallotId)
        {
            return await _systemManagementRepository.DeleteBallotIssues(BallotId);
        }

        public async Task<List<BallotIssueApiModel>> GetBallotIssuesList()
        {
            return await _systemManagementRepository.GetBallotIssuesList();

        }

        public async Task<int> CreateContributionLimits(ContributionLimitsApiModel contributionLimits)
        {
            return await _systemManagementRepository.CreateContributionLimits(contributionLimits);
        }

        public async Task<int> UpdateContributionLimits(ContributionLimitsApiModel contributionLimits)
        {
            return await _systemManagementRepository.UpdateContributionLimits(contributionLimits);
        }

        public async Task<int> DeleteContributionLimits(int id)
        {
            return await _systemManagementRepository.DeleteContributionLimits(id);
        }

        public async Task<List<ContributionLimitsApiModel>> GetContributionLimitsList()
        {
            return await _systemManagementRepository.GetContributionLimitsList();

        }

        public async Task<List<FillerTypeApiModel>> GetFillerTypeList()
        {
            return await _systemManagementRepository.GetFillerTypeList();

        }

        public async Task<List<DonorTypeApiModel>> GetDonorTypeList()
        {
            return await _systemManagementRepository.GetDonorTypeList();

        }

        public async Task<List<OfficeTypeApiModel>> GetOfficeTypeList()
        {
            return await _systemManagementRepository.GetOfficeTypeList();

        }

        public async Task<List<ElectionApiModel>> GetElectionList()
        {
            return await _systemManagementRepository.GetElectionList();

        }

        public async Task<int> SaveCommitteType(GetCommitteListTypeApiModel addCommittetype)
        {
            return await _systemManagementRepository.SaveCommitteType(addCommittetype);
        }
   
        public async Task<int> DeleteCommitteeType(string typeId, string typeCode)
        {
            return await _systemManagementRepository.DeleteCommitteeType(typeId, typeCode);
        }

        public async Task<int> SaveOffice(AddOfficeApiModel addOffice)
        {
            return await _systemManagementRepository.SaveOffice(addOffice);
        }
      
        public async Task<List<GetCommitteListTypeApiModel>> GetCommitteTypeList()
        {
            return await _systemManagementRepository.GetCommitteTypeList();

        }

        public async Task<int> DeleteOffices(string typeId, string typeCode)
        {
            return await _systemManagementRepository.DeleteOffices(typeId, typeCode);
        }

        public async Task<List<AddOfficeApiModel>> GetallOfficeList()
        {
            return await _systemManagementRepository.GetallOfficeList();
        }

        public async Task<int> AddMatchingLimits(AddMatchingLimitApiModel AddMachingLimits)
        {
            return await _systemManagementRepository.AddMatchingLimits(AddMachingLimits);
        }

        public async Task<int> UpdateMatchingLimits(AddMatchingLimitApiModel UpdateMachingLimits) 
        {
            return await _systemManagementRepository.UpdateMatchingLimits(UpdateMachingLimits);
        }

        public async Task<int> DeleteMatchingLimits(int Id) 
        {
            return await _systemManagementRepository.DeleteMatchingLimits(Id);
        }

        public async Task<List<AddMatchingLimitApiModel>> GetMatchingLimitsList()
        {
            return await _systemManagementRepository.GetMatchingLimitsList();
        }

        public async Task<int> CreateModifyFormImageUpload(AppTenantRequestApiModel appTenantRequestAPI) 
        {
            return await _systemManagementRepository.CreateModifyFormImageUpload(appTenantRequestAPI);
        }

        public async Task<int> UpdateModifyFormImageUpload(AppTenantRequestApiModel appTenantRequestAPI) 
        {
            return await _systemManagementRepository.UpdateModifyFormImageUpload(appTenantRequestAPI);
        }
        //Get the UserPermission Settings
        public async Task<List<UserPermissionSettingApiModel>> GetUserPermissionList()
        {
            return await _systemManagementRepository.GetUserPermissionList();

        }

        public async Task<List<CommitteeList>> GetCommiteeListMatchingBallotCode(int ballotIssueID)
        {
            return await _systemManagementRepository.GetCommiteeListMatchingBallotCode(ballotIssueID);

        }

        public async Task<List<AppTenantRequestApiModel>> GetModifyFormImage(int appid)
        {
            return await _systemManagementRepository.GetModifyFormImage(appid);

        }
    }
}
