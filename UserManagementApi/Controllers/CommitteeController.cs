using Denver.Common;
using Denver.Infra.Constants;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Threading.Tasks;
using UserManagementApi.Configurations;
using UserManagementApi.Domain.ApiModels;
using UserManagementApi.Domain.ViewModels;
using UserManagementApi.Domain.ApiModels.Committee;
using UserManagementApi.Domain.Entities;
using UserManagementApi.Domain.Entities.Committee;
using UserManagementApi.Domain.Service;
using Denver.Infra;

namespace UserManagementApi.Controllers
{
    [ApiController]
    public class CommitteeController : BaseController
    {
        private readonly AppSettings _appSettings;
        public CommitteeController(IUserManagementService iUserService, ILogger<CommitteeController> logger, AppSettings appSettings) : base(iUserService, logger)
        {
            _appSettings = appSettings;
        }

        #region New

        /// <summary>
        /// GetcommitteeByname - 
        /// </summary>
        /// <returns>CommitteeResponse<returns>
        [HttpGet("GetCommitteeByName")]
        [AllowAnonymous]
        public async Task<ActionResult> GetCommitteeByName(string searchCommittee, string committeetype)
        {
            return Ok(await _iService.GetCommitteeByName(searchCommittee, committeetype));
        }

        /// <summary>
        /// createCommittee - Save Committee Details
        /// </summary>
        /// <param name="createCommittee"></param>
        /// <returns></returns>
        [HttpPost("createCommittee")]
        [AllowAnonymous]
        public async Task<List<ApiResponse<bool>>> CreateCommittee([FromBody] CommitteApiModel createCommittee)
        {
            if (createCommittee.ContactID == 0)
            {
                LoggedInUser loggedInUser = this.GetLoggedInUser();
                createCommittee.ContactID = Convert.ToInt32(loggedInUser.ContactId);
            }
            if (!ModelState.IsValid)
            {
                throw new ValidationException(ValidationMessage.InvalidInput, null, ModelState.Values.SelectMany(x => x.Errors.Select(y => y.ErrorMessage)).ToList());
            }
            int response = await _iService.CreateCommittee(createCommittee);
            return response != 0 ? CreateRespWithreturnCollection(response) : GeneralErrorResponse();

        }

        /// <summary>
        /// createOfficers - Save Officer Details
        /// </summary>
        /// <param name="createOfficer"></param>
        /// <returns></returns>
        [HttpPost("SaveOfficer")]
        [AllowAnonymous]
        public async Task<List<ApiResponse<bool>>> SaveOfficer([FromBody] OfficersApiModel createOfficer)
        {
            if (!ModelState.IsValid)
            {
                throw new ValidationException(ValidationMessage.InvalidInput, null, ModelState.Values.SelectMany(x => x.Errors.Select(y => y.ErrorMessage)).ToList());
            }
            int response = await _iService.SaveOfficer(createOfficer);
            return response != 0 ? CreateRespWithreturnCollection(response) : GeneralErrorResponse();

        }

        /// <summary>
        /// UpdateBankInfo - Update BankInfo Details
        /// </summary>
        /// <param name="updateBankInfo"></param>
        /// <returns></returns>
        [HttpPost("updateBankInfo")]
        [AllowAnonymous]
        public async Task<List<ApiResponse<bool>>> UpdateBankInfo([FromBody] BankInfoApiModel updateBankInfo)
        {
            if (!ModelState.IsValid)
            {
                throw new ValidationException(ValidationMessage.InvalidInput, null, ModelState.Values.SelectMany(x => x.Errors.Select(y => y.ErrorMessage)).ToList());
            }
            int response = await _iService.UpdateBankInfo(updateBankInfo);
            return response != 0 ? CreateRespWithreturnCollection(response) : GeneralErrorResponse();

        }


        [HttpGet("GetOfficersList")]
        [AllowAnonymous]
        public async Task<List<GetOfficerApiModel>> GetOfficersList(int committeeid)
        {
            if (!ModelState.IsValid)
            {
                throw new ValidationException(ValidationMessage.InvalidInput,null, ModelState.Values.SelectMany(x => x.Errors.Select(y => y.ErrorMessage)).ToList());
            }
            List<GetOfficerApiModel> responsedata = await _iService.GetOfficersList(committeeid);
            return responsedata;
        }

        /// <summary>
        /// SaveCommitteeAffiliation - Map Contact and Committee
        /// </summary>
        /// <param name="committeeAffiliation"></param>
        /// <returns></returns>
        [HttpPost("SaveCommitteeAffiliation")]
        [AllowAnonymous]
        public async Task<List<ApiResponse<bool>>> SaveCommitteeAffiliation([FromBody] CommitteeAffiliationApiModel committeeAffiliation)
        {
           
            if (committeeAffiliation.ContactID == 0)
            {
                LoggedInUser loggedInUser = this.GetLoggedInUser();
                committeeAffiliation.ContactID = Convert.ToInt32(loggedInUser.ContactId);
            }
            if (!ModelState.IsValid)
            {
                throw new ValidationException(ValidationMessage.InvalidInput, null, ModelState.Values.SelectMany(x => x.Errors.Select(y => y.ErrorMessage)).ToList());
            }
            int response = await _iService.SaveCommitteeAffiliation(committeeAffiliation);
            return response != 0 ? CreateRespWithreturnCollectionForU(response) : GeneralErrorResponse();
        }

        [HttpDelete("DeleteOfficer")]
        [AllowAnonymous]
        public async Task<List<ApiResponse<bool>>> DeleteOfficer(int contactid)

        {
            int response = await _iService.DeleteOfficer(contactid);
            return response != 0 ? CreateRespWithreturnCollectionForD(response) : GeneralErrorResponse();
        }

        /// <summary>
        /// createIssueCommittee - Save Issue Committee Details
        /// </summary>
        /// <param name="createIssueCommittee"></param>
        /// <returns></returns>
        [HttpPost("createIssueCommittee")]
        [AllowAnonymous]
        public async Task<List<ApiResponse<bool>>> CreateIssueCommittee([FromBody] IssueCommitteeApiModel createIssueCommittee)
        {
            
            if (createIssueCommittee.ContactID == 0)
            {
                LoggedInUser loggedInUser = this.GetLoggedInUser();
                createIssueCommittee.ContactID = Convert.ToInt32(loggedInUser.ContactId);
            }
            if (!ModelState.IsValid)
            {
                throw new ValidationException(ValidationMessage.InvalidInput, null, ModelState.Values.SelectMany(x => x.Errors.Select(y => y.ErrorMessage)).ToList());
            }
            int response = await _iService.CreateIssueCommittee(createIssueCommittee);
            return response != 0 ? CreateRespWithreturnCollection(response) : GeneralErrorResponse();

        }

        /// <summary>
        /// createPACCommittee - Save PAC Committee Details
        /// </summary>
        /// <param name="createPACCommittee"></param>
        /// <returns></returns>
        [HttpPost("createPACCommittee")]
        [AllowAnonymous]
        public async Task<List<ApiResponse<bool>>> CreatePACCommittee([FromBody] PACCommitteeApiModel createPACCommittee)
        {
            

            if (createPACCommittee.ContactID == 0)
            {
                LoggedInUser loggedInUser = this.GetLoggedInUser();
                createPACCommittee.ContactID = Convert.ToInt32(loggedInUser.ContactId);
            }
            if (!ModelState.IsValid)
            {
                throw new ValidationException(ValidationMessage.InvalidInput, null, ModelState.Values.SelectMany(x => x.Errors.Select(y => y.ErrorMessage)).ToList());
            }
            int response = await _iService.CreatePACCommittee(createPACCommittee);
            return response != 0 ? CreateRespWithreturnCollection(response) : GeneralErrorResponse();

        }

        /// <summary>
        /// createSmallDonorCommittee - Save Small Donor Committee Details
        /// </summary>
        /// <param name="createSmallDonorCommittee"></param>
        /// <returns></returns>
        [HttpPost("createSmallDonorCommittee")]
        [AllowAnonymous]
        public async Task<List<ApiResponse<bool>>> CreateSmallDonorCommittee([FromBody] SmallDonorApiModel createSmallDonorCommittee)
        {
            

            if (createSmallDonorCommittee.ContactID == 0)
            {
                LoggedInUser loggedInUser = this.GetLoggedInUser();
                createSmallDonorCommittee.ContactID = Convert.ToInt32(loggedInUser.ContactId);
            }
            if (!ModelState.IsValid)
            {
                throw new ValidationException(ValidationMessage.InvalidInput, null, ModelState.Values.SelectMany(x => x.Errors.Select(y => y.ErrorMessage)).ToList());
            }
            int response = await _iService.CreateSmallDonorCommittee(createSmallDonorCommittee);
            return response != 0 ? CreateRespWithreturnCollection(response) : GeneralErrorResponse();

        }

        [HttpGet("GetOfficersListByName")]
        [AllowAnonymous]
        public async Task<List<GetOfficerApiModel>> GetOfficersListByName(string officerName, int committeeId)
        {
            if (!ModelState.IsValid)
            {
                throw new ValidationException(ValidationMessage.InvalidInput, null, ModelState.Values.SelectMany(x => x.Errors.Select(y => y.ErrorMessage)).ToList());
            }
            List<GetOfficerApiModel> responsedata = await _iService.GetOfficersListByName(officerName, committeeId);
            return responsedata;
        }

        /// <summary>
        /// createCoveredOfficials - Save Covered Officials Details
        /// </summary>
        /// <param name="createCoveredOfficials"></param>
        /// <returns></returns>
        [HttpPost("createCoveredOfficials")]
        [AllowAnonymous]
        public async Task<List<ApiResponse<bool>>> CreateCoveredOfficial(int contactId)
        {
            

            if (contactId == 0)
            {
                LoggedInUser loggedInUser = this.GetLoggedInUser();
                contactId = Convert.ToInt32(loggedInUser.ContactId);
            }
            if (!ModelState.IsValid)
            {
                throw new ValidationException(ValidationMessage.InvalidInput, null, ModelState.Values.SelectMany(x => x.Errors.Select(y => y.ErrorMessage)).ToList());
            }
            int response = await _iService.CreateCoveredOfficial(contactId);
            return response != 0 ? CreateRespWithreturnCollection(response) : GeneralErrorResponse();

        }


        /// <summary>
        /// GetCommitteeDetails - Get Committee details based on ID
        /// </summary>
        /// <param name="committeeid"></param>
        /// <returns></returns>
        [HttpGet("GetCommitteeDetails")]
        [AllowAnonymous]
        public async Task<CommitteeDetailsResponseApiModel> GetCommitteeDetails(int committeeid)
        {
            if (!ModelState.IsValid)
            {
                throw new ValidationException(ValidationMessage.InvalidInput, null, ModelState.Values.SelectMany(x => x.Errors.Select(y => y.ErrorMessage)).ToList());
            }
            CommitteeDetailsResponseApiModel responsedata = await _iService.GetCommitteeDetails(committeeid);
            return responsedata;
        }

        /// <summary>
        /// Update  Status
        /// </summary>
        /// <param name="statusUpdate"></param>
        /// <returns></returns>
        [HttpPost("UpdateCommitteeorLobbyistStatus")]
        [AllowAnonymous]
        public async Task<List<ApiResponse<bool>>> UpdateCommitteeorLobbyistStatus(StatusUpdateRequestApiModel statusUpdate)
        {
            if (!ModelState.IsValid)
            {
                throw new ValidationException(ValidationMessage.InvalidInput, null, ModelState.Values.SelectMany(x => x.Errors.Select(y => y.ErrorMessage)).ToList());
            }
            int response = await _iService.UpdateCommitteeorLobbyistStatus(statusUpdate);
            return response != 0 ? CreateRespWithreturnCollection(response) : GeneralErrorResponse();
        }
        #endregion New

        #region Old

        ///// <summary>
        ///// GetCommitteeList - Retrieve Committee detail list
        ///// </summary>
        ///// <returns>CommitteeResponse<returns>
        //[HttpGet("getList")]
        //[AllowAnonymous]
        //public async Task<ActionResult> GetCommitteeList()
        //{
        //    return Ok(await _iService.GetCommitteeList());
        //}

        ///// <summary>
        ///// GetBallotIssueList - Retrieve Ballot Issue detail list
        ///// </summary>
        ///// <returns>CommitteeResponse<returns>
        //[HttpGet("ballotissue/getList")]
        //[AllowAnonymous]
        //public async Task<ActionResult> GetBallotIssueList()
        //{
        //    return Ok(await _iService.GetBallotIssueList());
        //}


        ///// <summary>
        ///// AddCommitteeDetails - To add new committes
        ///// </summary>
        ///// <returns>int<returns>

        ///// <summary>
        ///// Update Committee Additional Iformation
        ///// </summary>
        ///// <param name="committeeAddlInfo"></param>
        ///// <returns></returns>
        //[HttpPost("UpdateCommitteeAdditionalInfo")]
        //[AllowAnonymous]
        //public async Task<ApiResponse<string>> UpdateCommitteeAdditionalInfo([FromBody] CommitteeAddlInfoApiModel committeeAddlInfo)
        //{
        //    if (!ModelState.IsValid)
        //    {
        //        throw new ValidationException(ValidationMessage.InvalidInput, null, ModelState.Values.SelectMany(x => x.Errors.Select(y => y.ErrorMessage)).ToList());
        //    }
        //    EmailReq emailReq = new EmailReq();
        //    emailReq.FromEmail = this._appSettings.EmailSettings.SmtpUserName;
        //    emailReq.CcEmail = this._appSettings.EmailSettings.CCEmails;
        //    emailReq.BccEmail = this._appSettings.EmailSettings.BccEmails;
        //    emailReq.Password = this._appSettings.EmailSettings.SmtpPassword;
        //    emailReq.SMTPServer = this._appSettings.EmailSettings.SmtpServer;
        //    emailReq.UILink = this._appSettings.EmailSettings.UILink;
        //    emailReq.SMTPPort = Convert.ToInt32(this._appSettings.EmailSettings.SmtpPort);

        //    bool response = await _iService.UpdateCommitteeAdditionalInfo(committeeAddlInfo, emailReq);
        //    if (response)
        //        return SuccessResponseWithCustomMessage("Email Sent Successfully", 1);
        //    else
        //        return ErrorResponseWithCustomMessage("Error Occured while sending Mail");

        //}
        ///// <summary>
        ///// GetCommitteeListByName - Retrieve Committee detail list
        ///// </summary>
        ///// <returns>CommitteeResponse<returns>
        //[HttpPost("getListByName")]
        //[AllowAnonymous]
        //public async Task<ActionResult> GetCommitteeListByName(CommitteeListRequestApiModel searchCommitte)
        //{
        //    return Ok(await _iService.GetCommitteeListByName(searchCommitte));
        //}

        ///// <summary>
        ///// GetCommitteeorLobbyistbyID - Retrieve GetCommittee or Lobbyist details by ID;
        ///// </summary>
        ///// <param name="id"></param>
        ///// <param name="type"></param>
        ///// <returns>CommitteeorLobbyistDetailResponse<returns>
        //[HttpPost("GetCommitteeorLobbyistbyID")]
        //[AllowAnonymous]
        //public async Task<ActionResult> GetCommitteeorLobbyistbyID(int id, string type)
        //{
        //    return Ok(await _iService.GetCommitteeorLobbyistbyID(id, type));
        //}

        ///// <summary>
        ///// GetCommitteeandLobbyistbyUser - Retrieve GetCommittee and Lobbyist details by User;
        ///// </summary>
        ///// <param name="id"></param>
        ///// <returns>CommitteeorLobbyistDetailResponse<returns>
        //[HttpPost("GetCommitteeandLobbyistbyUser")]
        //[AllowAnonymous]
        //public async Task<ActionResult> GetCommitteeandLobbyistbyUser(int id)
        //{
        //    return Ok(await _iService.GetCommitteeandLobbyistbyUser(id));
        //}

        ///// <summary>
        ///// Update Committee Status
        ///// </summary>
        ///// <param name="committeeID"></param>
        ///// <param name="status"></param>
        ///// <param name="notes"></param>
        ///// <returns></returns>
        //[HttpPost("UpdateCommitteeStatus")]
        //[AllowAnonymous]
        //public async Task<ApiResponse<string>> UpdateCommitteeStatus(CommitteeStatusUpdateRequestApiModel committeeStatusUpdate)
        //{
        //    EmailReq emailReq = new EmailReq();
        //    emailReq.FromEmail = this._appSettings.EmailSettings.SmtpUserName;
        //    emailReq.CcEmail = this._appSettings.EmailSettings.CCEmails;
        //    emailReq.BccEmail = this._appSettings.EmailSettings.BccEmails;
        //    emailReq.Password = this._appSettings.EmailSettings.SmtpPassword;
        //    emailReq.SMTPServer = this._appSettings.EmailSettings.SmtpServer;
        //    emailReq.UILink = this._appSettings.EmailSettings.UILink;
        //    emailReq.SMTPPort = Convert.ToInt32(this._appSettings.EmailSettings.SmtpPort);

        //    bool retValue = await _iService.UpdateCommitteeStatus(committeeStatusUpdate, emailReq);
        //    if (retValue)
        //        return SuccessResponseWithCustomMessage("Email Sent Successfully", 1);
        //    else
        //        return ErrorResponseWithCustomMessage("Error Occured while sending Mail");

        //}

        ///// <summary>
        ///// SearchCommittee based on Search criteria 
        ///// </summary>
        ///// <param name="searchreq"></param>
        ///// <returns></returns>
        //[HttpPost("SearchApprovedCommittee")]
        //[AllowAnonymous]
        //public async Task<ActionResult> SearchCommittee(SearchCommitteeRequestApiModel searchreq)
        //{
        //    return Ok(await _iService.SearchCommittee(searchreq));
        //}

        ///// <summary>
        ///// GetManageCommitteeList - Retrieve All Committee list
        ///// </summary>
        ///// <returns></returns>
        //[HttpPost("GetManageCommitteeList")]
        //[AllowAnonymous]
        //public async Task<IEnumerable<ManageCommitteListResponseApiModel>> GetManageCommitteeList(ManageCommitteListRequestApiModel manageCommitteListRequest)
        //{
        //    var responsedt = await _iService.GetManageCommitteeList(manageCommitteListRequest);
        //    return responsedt;

        //}

        ///// <summary>
        ///// GetCommitteeDetail - Retrieve the Committee details
        ///// </summary>
        ///// <returns></returns>
        //[HttpPost("GetCommitteeDetail")]
        //[AllowAnonymous]
        //public async Task<Domain.ApiModels.CommitteeDetailsApiModel> GetCommitteeDetail(int committeeId)
        //{
        //    var responsedt = await _iService.GetCommitteeDetail(committeeId);
        //    return responsedt;
        //}


        ///// <summary>
        ///// Terminate the Committee
        ///// </summary>
        ///// <returns></returns>
        //[HttpPost("TerminateCommittee")]
        //[AllowAnonymous]
        //public async Task<List<ApiResponse<bool>>> TerminateCommittee(int committeeId)
        //{
        //    var response = await _iService.TerminateCommittee(committeeId);
        //    return response != 0 ? CreateRespWithreturnCollectionForU(response) : GeneralErrorResponse();
        //}


        ///// <summary>
        ///// GetSwitchCommitteeDetails - Retrieve the Switch Committee Details
        ///// </summary>
        ///// <param name="id"></param>
        ///// <returns></returns>
        //[HttpPost("GetSwitchCommitteeDetails")]
        //[AllowAnonymous]
        //public async Task<IEnumerable<SwitchCommitteeDetail>> GetSwitchCommitteeDetails(int id)
        //{
        //    var responsedt = await _iService.GetSwitchCommitteeDetails(id);
        //    return responsedt;

        //}

        ///// <summary>
        ///// GetSwitchCommitteeDetails - Retrieve the Switch Committee Details
        ///// </summary>
        ///// <param name="id"></param>
        ///// <returns></returns>
        //[HttpPost("GetSwitchLobbyistDetails")]
        //[AllowAnonymous]
        //public async Task<IEnumerable<SwitchLobbyistDetail>> GetSwitchLobbyistDetails(int id)
        //{
        //    var responsedt = await _iService.GetSwitchLobbyistDetails(id);
        //    return responsedt;

        //}

        ///// <summary>
        ///// GetSwitchIEDetails - Retrieve the Independent Spender details
        ///// </summary>
        ///// <param name="id"></param>
        ///// <returns></returns>
        //[HttpPost("GetSwitchIEDetails")]
        //[AllowAnonymous]
        //public async Task<IEnumerable<SwitchIEDetail>> GetSwitchIEDetails(int id)
        //{
        //    var responsedt = await _iService.GetSwitchIEDetails(id);
        //    return responsedt;

        //}

        ///// <summary>
        ///// DownloadManageFiler - Download Manage Filer as CSV
        ///// </summary>
        ///// <param name="manageFilerRequest"></param>
        ///// <returns></returns>
        //[HttpPost("DownloadManageFilerList")]
        //[AllowAnonymous]
        //public async Task<ManageCommitteeDownload> DownloadManageFiler(ManageFilerRequestApiModel manageFilerRequest)
        //{
        //    var responsedt = await _iService.DownloadManageFiler(manageFilerRequest);
        //    return responsedt;

        //}

        ///// <summary>
        ///// SendCommitteeNote - Send message
        ///// </summary>
        ///// <returns></returns>
        //[HttpPost("SendCommitteeNote")]
        //[AllowAnonymous]
        //public async Task<ApiResponse<string>> SendCommitteeNote(SendCommitteNoteRequestApiModel sendCommitteNote)
        //{
        //    EmailReq emailReq = new EmailReq();
        //    emailReq.FromEmail = this._appSettings.EmailSettings.SmtpUserName;
        //    emailReq.CcEmail = this._appSettings.EmailSettings.CCEmails;
        //    emailReq.BccEmail = this._appSettings.EmailSettings.BccEmails;
        //    emailReq.Password = this._appSettings.EmailSettings.SmtpPassword;
        //    emailReq.SMTPServer = this._appSettings.EmailSettings.SmtpServer;
        //    emailReq.UILink = this._appSettings.EmailSettings.UILink;
        //    emailReq.SMTPPort = Convert.ToInt32(this._appSettings.EmailSettings.SmtpPort);
        //    emailReq.Subject = sendCommitteNote.Subject;
        //    emailReq.BodyMessage = sendCommitteNote.Message;
        //    var retValue = await _iService.SendCommitteeNote(sendCommitteNote, emailReq);
        //    if (retValue)
        //        return SuccessResponseWithCustomMessage("Email Sent Successfully", 1);
        //    else
        //        return ErrorResponseWithCustomMessage("Error Occured while sending Mail");

        //}

        #endregion Old



    }
}
