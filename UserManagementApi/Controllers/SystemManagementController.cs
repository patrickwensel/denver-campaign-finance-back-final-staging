using Denver.Common;
using Denver.Infra.Constants;
using Denver.Infra.Exceptions;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;
using UserManagementApi.Configurations;
using UserManagementApi.Domain.ViewModels;
using UserManagementApi.Domain.ApiModels;
using UserManagementApi.Domain.ApiModels.Committee;
using UserManagementApi.Domain.Entities;
using UserManagementApi.Domain.Service;


namespace UserManagementApi.Controllers
{
    
    [ApiController]
    public class SystemManagementController : BaseController
    {
        private readonly AppSettings _appSettings;

        public SystemManagementController(IUserManagementService iUserService, ILogger<UserManagementController> logger, AppSettings appSettings) : base(iUserService, logger)
        {
            _appSettings = appSettings;
        }
        
        [HttpPost("CreateBallotIssues")]
        [AllowAnonymous]
        public async Task<List<ApiResponse<bool>>> CreateBallotIssues([FromBody] BallotIssueApiModel createBallotIssues)
        {
            if (!ModelState.IsValid)
            {
                throw new ValidationException(ValidationMessage.InvalidInput, ModelState.Values.SelectMany(x => x.Errors.Select(y => y.ErrorMessage)).ToList());
            }
            int response = await _iService.CreateBallotIssues(createBallotIssues);
            return response != 0 ? CreateRespWithreturnCollection(response) : GeneralErrorResponse();
        }


        [HttpPut("UpdateBallotIssues")]
        [AllowAnonymous]
        public async Task<List<ApiResponse<bool>>> UpdateBallotIssues([FromBody] BallotIssueApiModel updateBallotIssues)
        {
            if (!ModelState.IsValid)
            {
                throw new ValidationException(ValidationMessage.InvalidInput, ModelState.Values.SelectMany(x => x.Errors.Select(y => y.ErrorMessage)).ToList());
            }
            int response = await _iService.UpdateBallotIssues(updateBallotIssues);
            return response != 0 ? CreateRespWithreturnCollectionForU(response) : GeneralErrorResponse();
        }


       
        [HttpDelete("DeleteBallotIssues")]
        [AllowAnonymous]
        public async Task<List<ApiResponse<bool>>> DeleteBallotIssues(int BallotId)

        {
            int response = await _iService.DeleteBallotIssues(BallotId);
            return response != 0 ? CreateRespWithreturnCollectionForD(response) : GeneralErrorResponse();
        }

        [HttpGet("GetBallotIssuesList")]
        [AllowAnonymous]
        public async Task<List<BallotIssueApiModel>> GetBallotIssuesList()
        {
            if (!ModelState.IsValid)
            {
                throw new ValidationException(ValidationMessage.InvalidInput, ModelState.Values.SelectMany(x => x.Errors.Select(y => y.ErrorMessage)).ToList());
            }
            List<BallotIssueApiModel> responsedt = await _iService.GetBallotIssuesList();
            return responsedt;
        }

        [HttpPost("CreateContributionLimits")]
        [AllowAnonymous]
        public async Task<List<ApiResponse<bool>>> CreateContributionLimits([FromBody] ContributionLimitsApiModel contributionLimits)
        {
            if (!ModelState.IsValid)
            {
                throw new ValidationException(ValidationMessage.InvalidInput, ModelState.Values.SelectMany(x => x.Errors.Select(y => y.ErrorMessage)).ToList());
            }
            int response = await _iService.CreateContributionLimits(contributionLimits);
            return response != 0 ? CreateRespWithreturnCollection(response) : GeneralErrorResponse();
        }


        [HttpPut("UpdateContributionLimits")]
        [AllowAnonymous]
        public async Task<List<ApiResponse<bool>>> UpdateContributionLimits([FromBody] ContributionLimitsApiModel contributionLimits)
        {
            if (!ModelState.IsValid)
            {
                throw new ValidationException(ValidationMessage.InvalidInput, ModelState.Values.SelectMany(x => x.Errors.Select(y => y.ErrorMessage)).ToList());
            }
            int response = await _iService.UpdateContributionLimits(contributionLimits);
            return response != 0 ? CreateRespWithreturnCollectionForU(response) : GeneralErrorResponse();
        }



        [HttpDelete("DeleteContributionLimits")]
        [AllowAnonymous]
        public async Task<List<ApiResponse<bool>>> DeleteContributionLimits(int id)

        {
            int response = await _iService.DeleteContributionLimits(id);
            return response != 0 ? CreateRespWithreturnCollectionForD(response) : GeneralErrorResponse();
        }

        [HttpGet("GetContributionLimitsList")]
        [AllowAnonymous]
        public async Task<List<ContributionLimitsApiModel>> GetContributionLimitsList()
        {
            if (!ModelState.IsValid)
            {
                throw new ValidationException(ValidationMessage.InvalidInput, ModelState.Values.SelectMany(x => x.Errors.Select(y => y.ErrorMessage)).ToList());
            }
            List<ContributionLimitsApiModel> responsedt = await _iService.GetContributionLimitsList();
            return responsedt;
        }

        [HttpGet("GetFillerTypeList")]
        [AllowAnonymous]
        public async Task<List<FillerTypeApiModel>> GetFillerTypeList()
        {
            if (!ModelState.IsValid)
            {
                throw new ValidationException(ValidationMessage.InvalidInput, ModelState.Values.SelectMany(x => x.Errors.Select(y => y.ErrorMessage)).ToList());
            }
            List<FillerTypeApiModel> responsedt = await _iService.GetFillerTypeList();
            return responsedt;
        }

        [HttpGet("GetDonorTypeList")]
        [AllowAnonymous]
        public async Task<List<DonorTypeApiModel>> GetDonorTypeList()
        {
            if (!ModelState.IsValid)
            {
                throw new ValidationException(ValidationMessage.InvalidInput, ModelState.Values.SelectMany(x => x.Errors.Select(y => y.ErrorMessage)).ToList());
            }
            List<DonorTypeApiModel> responsedt = await _iService.GetDonorTypeList();
            return responsedt;
        }

        [HttpGet("GetOfficeTypeList")]
        [AllowAnonymous]
        public async Task<List<OfficeTypeApiModel>> GetOfficeTypeList()
        {
            if (!ModelState.IsValid)
            {
                throw new ValidationException(ValidationMessage.InvalidInput, ModelState.Values.SelectMany(x => x.Errors.Select(y => y.ErrorMessage)).ToList());
            }
            List<OfficeTypeApiModel> responsedt = await _iService.GetOfficeTypeList();
            return responsedt;
        }

        [HttpGet("GetElectionList")]
        [AllowAnonymous]
        public async Task<List<ElectionApiModel>> GetElectionList()
        {
            if (!ModelState.IsValid)
            {
                throw new ValidationException(ValidationMessage.InvalidInput, ModelState.Values.SelectMany(x => x.Errors.Select(y => y.ErrorMessage)).ToList());
            }
            List<ElectionApiModel> responsedt = await _iService.GetElectionList();
            return responsedt;
        }

        /// <summary>
        /// AddCommitteType - Insert AddCommitteType
        /// </summary>
        /// <param name="AddCommitteType"></param>
        /// <returns></returns>
        [HttpPost("SaveCommitteType")]
        [AllowAnonymous]
        public async Task<List<ApiResponse<bool>>> SaveCommitteType([FromBody] GetCommitteListTypeApiModel addCommitteTypes)
        {
            if (!ModelState.IsValid)
            {
                throw new ValidationException(ValidationMessage.InvalidInput, ModelState.Values.SelectMany(x => x.Errors.Select(y => y.ErrorMessage)).ToList());
            }
            int response = await _iService.SaveCommitteType(addCommitteTypes);
            return response != 0 ? CreateRespWithreturnCollection(response) : GeneralErrorResponse();
        }


        /// <summary>
        /// DeleteCommitteeType - Delete DeleteCommitteeType
        /// </summary>
        /// <param name="DeleteCommitteeTypeId"></param>
        /// <returns></returns>
        [HttpDelete("DeleteCommitteeType")]
        [AllowAnonymous]
        public async Task<List<ApiResponse<bool>>> DeleteCommitteeType(string typeId, string typeCode)

        {
            int response = await _iService.DeleteCommitteeType(typeId, typeCode);
            return response != 0 ? CreateRespWithreturnCollectionForD(response) : GeneralErrorResponse();
        }



        /// <summary>
        /// GetCommitteList - Retrieve CommitteList detail list
        /// </summary>
        /// <returns>CommitteeResponse<returns>
        /// <summary>
        [HttpGet("GetCommitteTypeList")]
        [AllowAnonymous]
        public async Task<ActionResult> GetCommitteTypeList()
        {
            return Ok(await _iService.GetCommitteTypeList());
        }

        /// <summary>
        /// AddOffice - Insert AddOffice
        /// </summary>
        /// <param name="AddOffice"></param>
        /// <returns></returns>
        [HttpPost("SaveOffice")]
        [AllowAnonymous]
        public async Task<List<ApiResponse<bool>>> SaveOffice([FromBody] AddOfficeApiModel addOffice)
        {
            if (!ModelState.IsValid)
            {
                throw new ValidationException(ValidationMessage.InvalidInput, ModelState.Values.SelectMany(x => x.Errors.Select(y => y.ErrorMessage)).ToList());
            }
            int response = await _iService.SaveOffice(addOffice);
            return response != 0 ? CreateRespWithreturnCollection(response) : GeneralErrorResponse();

        }

        [HttpDelete("DeleteOffice")]
        [AllowAnonymous]
        public async Task<List<ApiResponse<bool>>> DeleteOffices(string typeId, string typeCode)

        {
            int response = await _iService.DeleteOffices(typeId, typeCode);
            return response != 0 ? CreateRespWithreturnCollectionForD(response) : GeneralErrorResponse();
        }


        /// <summary>
        /// GetallOfficeList - Retrieve GetallOfficeList detail list
        /// </summary>
        /// <returns>GetallOfficeList<returns>
        /// <summary>
        [HttpGet("GetallOfficeList")]
        [AllowAnonymous]
        public async Task<List<AddOfficeApiModel>> GetallOfficeList()
        {
            if (!ModelState.IsValid)
            {
                throw new ValidationException(ValidationMessage.InvalidInput, ModelState.Values.SelectMany(x => x.Errors.Select(y => y.ErrorMessage)).ToList());
            }
            List<AddOfficeApiModel> responsedt = (List<AddOfficeApiModel>)
            await _iService.GetallOfficeList();
            return responsedt;
        }

        /// <summary>
        /// AddMatchingLimits - Insert AddMatchingLimits
        /// </summary>
        /// <param name="AddMatchingLimits"></param>
        /// <returns></returns>
        [HttpPost("AddMatchingLimits")] 
        [AllowAnonymous]
        public async Task<List<ApiResponse<bool>>> AddMatchingLimits([FromBody] AddMatchingLimitApiModel addMatchingLimit)
        {
            if (!ModelState.IsValid)
            {
                throw new ValidationException(ValidationMessage.InvalidInput, ModelState.Values.SelectMany(x => x.Errors.Select(y => y.ErrorMessage)).ToList());
            }
            int response = await _iService.AddMatchingLimits(addMatchingLimit);
            return response != 0 ? CreateRespWithreturnCollection(response) : GeneralErrorResponse();

        }

        /// <summary>
        /// UpdateMatchingLimits - Update UpdateMatchingLimits
        /// </summary>
        /// <param name="UpdateMatchingLimits"></param>
        /// <returns></returns>
        [HttpPut("UpdateMatchingLimits")]
        [AllowAnonymous]
        public async Task<List<ApiResponse<bool>>> UpdateMatchingLimits([FromBody] AddMatchingLimitApiModel UpdatmatchingLimitse)
        {
            if (!ModelState.IsValid)
            {
                throw new ValidationException(ValidationMessage.InvalidInput, ModelState.Values.SelectMany(x => x.Errors.Select(y => y.ErrorMessage)).ToList());
            }
            int response = await _iService.UpdateMatchingLimits(UpdatmatchingLimitse);
            return response != 0 ? CreateRespWithreturnCollection(response) : GeneralErrorResponse();

        }

        /// <summary>
        /// MatchingLimits - Delete MatchingLimits
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        [HttpDelete("DeleteMatchingLimits")]
        [AllowAnonymous]
        public async Task<List<ApiResponse<bool>>> DeleteMatchingLimits(int Id)

        {
            int response = await _iService.DeleteMatchingLimits(Id);
            return response != 0 ? CreateRespWithreturnCollectionForD(response) : GeneralErrorResponse();
        }

        [HttpGet("GetMatchingLimitsList")]
        [AllowAnonymous]
        public async Task<List<AddMatchingLimitApiModel>> GetMatchingLimitsList()
        {
            if (!ModelState.IsValid)
            {
                throw new ValidationException(ValidationMessage.InvalidInput, ModelState.Values.SelectMany(x => x.Errors.Select(y => y.ErrorMessage)).ToList());
            }
            List<AddMatchingLimitApiModel> responsedt = (List<AddMatchingLimitApiModel>)
            await _iService.GetMatchingLimitsList();
            return responsedt;
        }

        [HttpPost("CreateModifyFormImageUpload")]
        [AllowAnonymous]
        public async Task<List<ApiResponse<bool>>>  CreateModifyFormImageUpload([FromBody] AppTenantRequestApiModel appTenantRequestAPI)
        {
            if (!ModelState.IsValid)
            {
                throw new ValidationException(ValidationMessage.InvalidInput, ModelState.Values.SelectMany(x => x.Errors.Select(y => y.ErrorMessage)).ToList());
            }
            int response = await _iService.CreateModifyFormImageUpload(appTenantRequestAPI);
            return response != 0 ? CreateRespWithreturnCollection(response) : GeneralErrorResponse();
        }

        [HttpPut("UpdateModifyFormImageUpload")]
        [AllowAnonymous]
        public async Task<List<ApiResponse<bool>>>  UpdateModifyFormImageUpload([FromBody] AppTenantRequestApiModel appTenantRequestAPI)
        {
            if (!ModelState.IsValid)
            {
                throw new ValidationException(ValidationMessage.InvalidInput, ModelState.Values.SelectMany(x => x.Errors.Select(y => y.ErrorMessage)).ToList());
            }
            int response = await _iService.UpdateModifyFormImageUpload(appTenantRequestAPI);
            return response != 0 ? CreateRespWithreturnCollectionForU(response) : GeneralErrorResponse();
        }
        [HttpGet("GetUserPermissionList")]
        [AllowAnonymous]
        public async Task<List<UserPermissionSettingApiModel>> GetUserPermissionList()
        {
            if (!ModelState.IsValid)
            {
                throw new ValidationException(ValidationMessage.InvalidInput, ModelState.Values.SelectMany(x => x.Errors.Select(y => y.ErrorMessage)).ToList());
            }
            List<UserPermissionSettingApiModel> responsedata = await _iService.GetUserPermissionList();
            return responsedata;
        }

        [HttpGet("GetCommiteeListMatchingBallotCode")]
        [AllowAnonymous]
        public async Task<List<CommitteeList>> GetCommiteeListMatchingBallotCode(int ballotIssueID)
        {
            if (!ModelState.IsValid)
            {
                throw new ValidationException(ValidationMessage.InvalidInput, ModelState.Values.SelectMany(x => x.Errors.Select(y => y.ErrorMessage)).ToList());
            }
            List<CommitteeList> responsedt = (List<CommitteeList>)
            await _iService.GetCommiteeListMatchingBallotCode(ballotIssueID);
            return responsedt;
        }

        [HttpGet("GetModifyFormImage")]
        [AllowAnonymous]
        public async Task<List<AppTenantRequestApiModel>> GetModifyFormImage(int appid)
        {
            if (!ModelState.IsValid)
            {
                throw new ValidationException(ValidationMessage.InvalidInput, ModelState.Values.SelectMany(x => x.Errors.Select(y => y.ErrorMessage)).ToList());
            }
            List<AppTenantRequestApiModel> responsedt = (List<AppTenantRequestApiModel>)
            await _iService.GetModifyFormImage(appid);
            return responsedt;
        }
    }
}
