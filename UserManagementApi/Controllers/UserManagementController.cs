using Denver.Common;
using Denver.Infra;
using Denver.Infra.Constants;
using Denver.Infra.Exceptions;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Logging;
using Microsoft.Identity.Client;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;
using UserManagementApi.Configurations;
using UserManagementApi.Domain.ApiModels;
using UserManagementApi.Domain.Entities;
using UserManagementApi.Domain.Service;
using UserManagementApi.Domain.ViewModels;

namespace UserManagementApi.Controllers
{

    //[Authorize(AuthenticationSchemes = JwtBearerDefaults.AuthenticationScheme, Roles = UserRole.Admin + "," + UserRole.Candidate + "," + UserRole.CommitteeTreasurer + "," + UserRole.Lobbyist)]
    public class UserManagementController : BaseController
    {
        private readonly AppSettings _appSettings;
        private readonly JwtTokenSettings _jwtSettings;
        private IConfiguration _configuration { get; }

        private readonly PublicClientApplicationOptions _app;

        public UserManagementController(IUserManagementService iUserService, ILogger<UserManagementController> logger, AppSettings appSettings, JwtTokenSettings jwtSettings, IConfiguration configuration, PublicClientApplicationOptions app) : base(iUserService, logger)
        {
            _appSettings = appSettings;
            _jwtSettings = jwtSettings;
            _configuration = configuration;
            _app = app;
        }


        #region New

        /// <summary>
        /// CheckLoginUser - Check whether the user is exists in DB
        /// </summary>
        /// <returns>int<returns>
        [HttpPost("Authenticate")]
        [AllowAnonymous]
        public async Task<LoginResultApiModel> Authenticate(LoginUserInfoRequestApiModel loginUserInfoDetail, CancellationToken ct = new CancellationToken())
        {
            return await _iService.Authenticate(PublicClientApplicationBuilder.CreateWithApplicationOptions(_app).Build(), loginUserInfoDetail, this._appSettings.Secret.SecretKey, this._jwtSettings, ct);
        }


        [HttpPost("refresh")]
        public async Task<ActionResult> Refresh([FromBody] RefreshTokenApiModel refreshRequest, CancellationToken ct = new CancellationToken())
        {
            return Ok(await _iService.RefreshToken(this.GetLoggedInUser(), _jwtSettings.Secret, refreshRequest.Token, refreshRequest.RefreshToken, _jwtSettings.TokenLifeTime, ct));
        }

        ///// <summary>
        ///// GetUserDetails - Retrieve the User details
        ///// </summary>
        ///// <param name="UserID"></param>
        ///// <returns></returns>
        //[HttpPost("GetUserDetails")]
        //[AllowAnonymous]
        //public async Task<IEnumerable<UserInfoResposeApiModel>> GetUserDetails(int UserID)
        //{
        //    var responsedt = await _iService.GetUserDetails(UserID);
        //    return responsedt;

        //}

        /// <summary>
        /// GetUserDetails - Retrieve the User details
        /// </summary>        
        /// <returns></returns>
        [HttpPost("GetLoggedInUserInfo")]
        [AllowAnonymous]
        public async Task<LoggedInUserInfo> GetLoggedInUserInfo()
        {
            return new LoggedInUserInfo { Email = this.GetLoggedInUser().Email };
        }

        [HttpPost("VaidateEmailCheck")]
        [AllowAnonymous]
        public async Task<List<ApiResponse<bool>>> VaidateEmailCheck(string UserEmailID)
        {
            int response = await _iService.VaidateEmailCheck(UserEmailID);
            return response != 0 ? CreateRespWithreturnCollectionForD(response) : GeneralErrorResponse();

        }

        [HttpPost("UpdateIEAdditionalInfo")]
        [AllowAnonymous]
        public async Task<List<ApiResponse<bool>>> UpdateIEAdditionalInfo(IEUpdateAddlInfoRequestApiModel iEUpdateAddlInfo)
        {

            if (iEUpdateAddlInfo.ContactId == 0)
            {
                LoggedInUser loggedInUser = this.GetLoggedInUser();
                iEUpdateAddlInfo.ContactId = Convert.ToInt32(loggedInUser.ContactId);
            }
            int response = await _iService.UpdateIEAdditionalInfo(iEUpdateAddlInfo);
            return response != 0 ? CreateRespWithreturnCollectionForD(response) : GeneralErrorResponse();

        }

        [HttpGet("getUserEntites")]
        [AllowAnonymous]
        public async Task<UserEntitiesResponseApiModel> GetUserEntites()
        {
            LoggedInUser loggedInUser = this.GetLoggedInUser();

            var response = await _iService.GetUserEntites(Convert.ToInt32(loggedInUser.UserId));

            return response;
        }

        [HttpGet("getUserEntityDetails")]
        [AllowAnonymous]
        public async Task<UserEntityDetailsResponseApiModel> GetUserEntityDetails(int entityId, string entityType)
        {
            var response = await _iService.GetUserEntityDetails(entityId, entityType);
            return response;
        }

        [HttpPost("getManageFilers")]
        [AllowAnonymous]
        public async Task<IEnumerable<ManageFilersResponseApiModel>> GetManageFilers(ManageFilersRequestApiModel manageFilersRequest)
        {
            var response = await _iService.GetManageFilers(manageFilersRequest);
            return response;
        }

        /// <summary>
        /// SaveIndependentSpenderAffiliation - Map Contact and IndependentSpender
        /// </summary>
        /// <param name="independentSpenderAffiliation"></param>
        /// <returns></returns>
        [HttpPost("SaveIndependentSpenderAffiliation")]
        [AllowAnonymous]
        public async Task<List<ApiResponse<bool>>> SaveIndependentSpenderAffiliation([FromBody] IndependentSpendersAffiliationApiModel independentSpenderAffiliation)
        {

            if (independentSpenderAffiliation.ContactID == 0)
            {
                LoggedInUser loggedInUser = this.GetLoggedInUser();
                independentSpenderAffiliation.ContactID = Convert.ToInt32(loggedInUser.ContactId);
            }
            if (!ModelState.IsValid)
            {
                throw new ValidationException(ValidationMessage.InvalidInput, ModelState.Values.SelectMany(x => x.Errors.Select(y => y.ErrorMessage)).ToList());
            }
            int response = await _iService.SaveIndependentSpenderAffiliation(independentSpenderAffiliation);
            return response != 0 ? CreateRespWithreturnCollectionForU(response) : GeneralErrorResponse();
        }

        /// <summary>
        /// GetIndependentSpender - GetIndependentSpender
        /// </summary>
        /// <param name="independentSpenderId"></param>
        /// <returns></returns>
        [HttpGet("GetIndependentSpender")]
        [AllowAnonymous]
        public async Task<List<GetLobbyistEmployee>> GetIndependentSpender(int independentSpenderId)
        {
            List<GetLobbyistEmployee> employees = await _iService.GetIndependentSpender(independentSpenderId);
            return employees;
        }

        [HttpGet("getFilerNamesByName")]
        [AllowAnonymous]
        public async Task<List<string>> GetFilerNamesByName(string searchName)
        {
            var response = await _iService.GetFilerNamesByName(searchName);
            return response;
        }

        [HttpPost("FilerInviteUser")]
        [AllowAnonymous]
        public async Task<List<ApiResponse<bool>>> FilerInviteUser([FromBody] AddUserPaymentApiModel addUserPayment)
        {
            if (!ModelState.IsValid)
            {
                throw new ValidationException(ValidationMessage.InvalidInput, ModelState.Values.SelectMany(x => x.Errors.Select(y => y.ErrorMessage)).ToList());
            }
            int response = await _iService.FilerInviteUser(addUserPayment);
            return response != 0 ? CreateRespWithreturnCollection(response) : GeneralErrorResponse();
        }

        [HttpGet("GetFilerUsers")]
        [AllowAnonymous]
        public async Task<List<GetCurrentUser>> GetFilerUsers(int entityId, string entityType)
        {
            if (!ModelState.IsValid)
            {
                throw new ValidationException(ValidationMessage.InvalidInput, ModelState.Values.SelectMany(x => x.Errors.Select(y => y.ErrorMessage)).ToList());
            }
            List<GetCurrentUser> responsedt = await _iService.GetFilerUsers(entityId, entityType);
            return responsedt;
        }


        [HttpDelete("DeleteFilerContact")]
        [AllowAnonymous]
        public async Task<List<ApiResponse<bool>>> DeleteFilerContact(int contactId, int filerId)

        {
            int response = await _iService.DeleteFilerContact(contactId, filerId);
            return response != 0 ? CreateRespWithreturnCollectionForD(response) : GeneralErrorResponse();
        }

        [HttpPost("SaveMakeTreasurer")]
        [AllowAnonymous]
        public async Task<IEnumerable<MakeTreasurerApiModel>> SaveMakeTreasurer([FromBody] MakeTreasurerApiModel addMakeTreasurer)
        {
            if (!ModelState.IsValid)
            {
                throw new ValidationException(ValidationMessage.InvalidInput, ModelState.Values.SelectMany(x => x.Errors.Select(y => y.ErrorMessage)).ToList());
            }
           IEnumerable<MakeTreasurerApiModel> response = await _iService.SaveMakeTreasurer(addMakeTreasurer);
           return response;
        }

        [HttpGet("GetFilerAdminUsers")]
        [AllowAnonymous]
        public async Task<List<GetAdminUsers>> GetFilerAdminUsers(int filerId, int userId, string filerType, string status, DateTime lastActiveStartDate, DateTime lastActiveEndDate, DateTime createdStartDate, DateTime createdEndDate)
        {
            if (!ModelState.IsValid)
            {
                throw new ValidationException(ValidationMessage.InvalidInput, ModelState.Values.SelectMany(x => x.Errors.Select(y => y.ErrorMessage)).ToList());
            }
            List<GetAdminUsers> responsedt = await _iService.GetFilerAdminUsers(filerId, userId, filerType, status, lastActiveStartDate, lastActiveEndDate, createdStartDate, createdEndDate);
            return responsedt;
        }

        [HttpGet("GetUserAffiliations")]
        [AllowAnonymous]
        public async Task<List<GetAdminUsers>> GetUserAffiliations(int filerId, int userId, string filerType, string status, DateTime lastActiveStartDate, DateTime lastActiveEndDate, DateTime createdStartDate, DateTime createdEndDate)
        {
            if (!ModelState.IsValid)
            {
                throw new ValidationException(ValidationMessage.InvalidInput, ModelState.Values.SelectMany(x => x.Errors.Select(y => y.ErrorMessage)).ToList());
            }
            List<GetAdminUsers> responsedt = await _iService.GetUserAffiliations(filerId, userId, filerType, status, lastActiveStartDate, lastActiveEndDate, createdStartDate, createdEndDate);
            return responsedt;
        }
        #endregion New

        #region Old       

        ///// <summary>
        ///// CreateContactInformation - Insert ContactInformation
        ///// </summary>
        ///// <param name="createContactInformation"></param>
        ///// <returns></returns>
        //[HttpPost("CreateContactInformation")]
        //[AllowAnonymous]
        //public async Task<List<ApiResponse<bool>>> CreateContactInformation([FromBody] ContactInformationApiModel createContactInformation)
        //{
        //    if (!ModelState.IsValid)
        //    {
        //        throw new ValidationException(ValidationMessage.InvalidInput, ModelState.Values.SelectMany(x => x.Errors.Select(y => y.ErrorMessage)).ToList());
        //    }
        //    int response = await _iService.CreateContactInfo(createContactInformation);
        //    return response != 0 ? CreateRespWithreturnCollection(response) : GeneralErrorResponse();

        //}


        ///// <summary>
        ///// SetPassword - Creates a new login with Email and Password
        ///// </summary>
        ///// <param name="userInformation"></param>
        ///// <returns></returns>
        //[HttpPost("LoginInformation")]
        //[AllowAnonymous]
        //public async Task<List<ApiResponse<string>>> LoginInformation([FromBody] UserModel userInformation)
        //{
        //    if (userInformation.Password != userInformation.ConfirmPassword)
        //    {
        //        throw new ValidationException(ValidationMessage.MatchPassword, ModelState.Values.SelectMany(x => x.Errors.Select(y => y.ErrorMessage)).ToList());
        //    }

        //    var response = await _iService.LoginInformation(userInformation, (this._appSettings.Secret.SecretKey));
        //    return response != 0 ? CreateRespWithReturnCollection(response) : ErrorResponseWithCustomMessages(ValidationMessage.PasswordValidation);

        //}
        ///// <summary>
        ///// Choose UserType - User selects his usertype 
        ///// </summary>
        ///// <param name="userInformation"></param>
        ///// <returns></returns>
        //[HttpPost("ChooseUserType")]
        //[AllowAnonymous]
        //public async Task<List<ApiResponse<bool>>> SelectUserType([FromBody] UserTypeModel userInformation)
        //{
        //    if (!ModelState.IsValid)
        //    {
        //        throw new ValidationException(ValidationMessage.InvalidInput, ModelState.Values.SelectMany(x => x.Errors.Select(y => y.ErrorMessage)).ToList());
        //    }
        //    var response = await _iService.SelectUserType(userInformation);
        //    return response != 0 ? CreateRespWithreturnCollection(response) : GeneralErrorResponse();


        //}
        ///// <summary>
        ///// GetAllUserType - Retrieve All UserType 
        ///// </summary>
        ///// <returns></returns>
        //[HttpGet("GetAllUserType")]
        //[AllowAnonymous]
        //public async Task<List<UserTypeRefDataModel>> GetAllUserType()
        //{
        //    if (!ModelState.IsValid)
        //    {
        //        throw new ValidationException(ValidationMessage.InvalidInput, ModelState.Values.SelectMany(x => x.Errors.Select(y => y.ErrorMessage)).ToList());
        //    }
        //    var responsedt = await _iService.GetAllUserType();
        //    return responsedt;

        //}

        ///// <summary>
        ///// CreateUserRolerelationship - Insert UserRolerelationship
        ///// </summary>
        ///// <param name="createRolerelationship"></param>
        ///// <returns></returns>
        //[HttpPost("CreateRolerelationship")]
        //[AllowAnonymous]
        ////[Authorize(Roles = UserRole.Lobbyist + "," + UserRole.ForeignCityEmployee)]
        //public async Task<List<ApiResponse<bool>>> CreateRolerelationship([FromBody] RolerelationshipApiModel createRolerelationship)
        //{
        //    if (!ModelState.IsValid)
        //    {
        //        throw new ValidationException(ValidationMessage.InvalidInput, ModelState.Values.SelectMany(x => x.Errors.Select(y => y.ErrorMessage)).ToList());
        //    }
        //    int response = await _iService.CreateRolerelationship(createRolerelationship);
        //    return response != 0 ? CreateRespWithreturnCollection(response) : GeneralErrorResponse();
        //}

        ///// <summary>
        ///// Udpate Additional details for IEF User
        ///// </summary>
        ///// <param name="IEFAddlInfoApiModel"></param>
        ///// <returns></returns>
        //[HttpPost("UpdateIEFAdditionalInfo")]
        //[AllowAnonymous]
        //public async Task<ApiResponse<string>> UpdateIEFAdditionalInfo([FromBody] IEFAddlInfoApiModel IEFDetails)
        //{
        //    if (!ModelState.IsValid)
        //    {
        //        throw new ValidationException(ValidationMessage.InvalidInput, ModelState.Values.SelectMany(x => x.Errors.Select(y => y.ErrorMessage)).ToList());
        //    }
        //    EmailReq emailReq = new EmailReq();
        //    emailReq.FromEmail = this._appSettings.EmailSettings.SmtpUserName;
        //    emailReq.CcEmail = this._appSettings.EmailSettings.CCEmails;
        //    emailReq.BccEmail = this._appSettings.EmailSettings.BccEmails;
        //    emailReq.Password = this._appSettings.EmailSettings.SmtpPassword;
        //    emailReq.SMTPServer = this._appSettings.EmailSettings.SmtpServer;
        //    emailReq.UILink = this._appSettings.EmailSettings.UILink;
        //    emailReq.SMTPPort = Convert.ToInt32(this._appSettings.EmailSettings.SmtpPort);

        //    bool response = await _iService.UpdateIEFAdditionalInfo(IEFDetails, emailReq);
        //    if (response)
        //        return SuccessResponseWithCustomMessage("Email Sent Successfully", 1);
        //    else
        //        return ErrorResponseWithCustomMessage("Error Occured while sending Mail");
        //}

        ///// <summary>
        ///// Get the User Account Confirmation details
        ///// </summary>
        ///// <param name="UAConfirmationAndSubmitRequestApiModel"></param>
        ///// <returns></returns>
        //[HttpPost("GetUserAccountConfirmAndSubmit")]
        //[AllowAnonymous]
        //public async Task<ActionResult> GetUserAccountConfirmAndSubmit([FromBody] UAConfirmationAndSubmitRequestApiModel UAConfirmDetails)
        //{
        //    return Ok(await _iService.GetUserAccountConfirmAndSubmit(UAConfirmDetails));
        //}

        ///// <summary>
        ///// Send Email Or Fax. 
        ///// </summary>
        ///// <param name="ID"></param>
        ///// <remarks>
        ///// example:
        ///// ID-id of user
        ///// </remarks>
        ///// <returns></returns>
        //[Route("~/api/UserManagement/ForgotPassword")]
        //[HttpPost]
        //public async Task<ApiResponse<string>> ForgotPassword(string EmailId)
        //{
        //    try
        //    {
        //        EmailReq emailReq = new EmailReq();
        //        emailReq.ToEmail = EmailId;
        //        emailReq.FromEmail = this._appSettings.EmailSettings.SmtpUserName;
        //        emailReq.CcEmail = this._appSettings.EmailSettings.CCEmails;
        //        emailReq.BccEmail = this._appSettings.EmailSettings.BccEmails;
        //        emailReq.Password = this._appSettings.EmailSettings.SmtpPassword;
        //        emailReq.SMTPServer = this._appSettings.EmailSettings.SmtpServer;
        //        emailReq.UILink = this._appSettings.EmailSettings.UILink;
        //        emailReq.SMTPPort = Convert.ToInt32(this._appSettings.EmailSettings.SmtpPort);
        //        emailReq.Subject = Constants.EmailSubject;
        //        int retValue = await _iService.UpdateExpireDateTime(emailReq);
        //        if (retValue > 0)
        //            return SuccessResponseWithCustomMessage("Email Sent Successfully", retValue);
        //        else if (retValue == -1)
        //            return ErrorResponseWithCustomMessage("Error Occured while sending Mail");
        //        else
        //            return ErrorResponseWithCustomMessage("Please enter vaild email");
        //    }
        //    catch (Exception ex)
        //    {
        //        throw ex;
        //    }

        //}
        ///// <summary>
        ///// SetPassword - Creates a new login with Email and Password
        ///// </summary>
        ///// <param name="userInformation"></param>
        ///// <returns></returns>
        //[HttpPost("ResetPassword")]
        //[AllowAnonymous]
        //public async Task<ApiResponse<string>> ResetPassword([FromBody] ResetPasswordModel userInformation)
        //{
        //    string resMessage = string.Empty;
        //    if (userInformation.Password != userInformation.ConfirmPassword)
        //    {
        //        throw new ValidationException(ValidationMessage.MatchPassword, ModelState.Values.SelectMany(x => x.Errors.Select(y => y.ErrorMessage)).ToList());
        //    }
        //    if (userInformation.Password == userInformation.OldPassword)
        //    {
        //        throw new ValidationException(ValidationMessage.MisMatchPassword, ModelState.Values.SelectMany(x => x.Errors.Select(y => y.ErrorMessage)).ToList());
        //    }
        //    var response = await _iService.ResetPassword(userInformation, (this._appSettings.Secret.SecretKey));
        //    if (response == 1)
        //    {
        //        resMessage = "The password has been changed successfully !!!";
        //        return SuccessResponseWithCustomMessage(resMessage, response);
        //    }
        //    else if (response == 2)
        //    {
        //        resMessage = "The reset password link is expired.";
        //        return ErrorResponseWithCustomMessage(resMessage);
        //    }
        //    else
        //    {
        //        resMessage = "Error occured during Update Operation.";
        //        return ErrorResponseWithCustomMessage(resMessage);
        //    }
        //}

        ///// <summary>
        ///// GetOfficerListByName - Retrieve Officer detail list
        ///// </summary>
        ///// <returns>OfficerListRequestApiModel<returns>
        //[HttpPost("GetOfficerListByName")]
        //[AllowAnonymous]
        //public async Task<ActionResult> GetOfficerListByName(OfficerListRequestApiModel searchOfficer)
        //{
        //    return Ok(await _iService.GetOfficerListByName(searchOfficer));
        //}        

        ///// <summary>
        ///// SendIndependentSpender - Map User and Independent Spender
        ///// </summary>
        ///// <param name="independentSpenderAffiliation"></param>
        ///// <returns></returns>
        //[HttpPost("SendIndependentSpender")]
        //[AllowAnonymous]
        //public async Task<List<ApiResponse<bool>>> SendIndependentSpender(IndependentSpenderAffiliationApiModel independentSpenderAffiliation)
        //{
        //    int response = await _iService.SendIndependentSpender(independentSpenderAffiliation);
        //    return response != 0 ? CreateRespWithreturnCollectionForU(response) : GeneralErrorResponse();
        //}

        ///// <summary>
        ///// GetIndependentSpender - Retrieve the Independent Spender details
        ///// </summary>
        ///// <param name="searchIERequest"></param>
        ///// <returns></returns>
        //[HttpPost("GetIndependentSpender")]
        //[AllowAnonymous]
        //public async Task<IEnumerable<IndependentSpenderApiModel>> GetIndependentSpender(SearchIERequestApiModel searchIERequest)
        //{
        //    var responsedt = await _iService.GetIndependentSpender(searchIERequest);
        //    return responsedt;

        //}
        ///// <summary>
        ///// GetManageFiler - Retrieve the Filer details
        ///// </summary>
        ///// <param name="manageFilerRequest"></param>
        ///// <returns></returns>
        //[HttpPost("GetManageFilerDetail")]
        //[AllowAnonymous]
        //public async Task<IEnumerable<ManageFilerResponseApiModel>> GetManageFilerDetail(ManageFilerRequestApiModel manageFilerRequest)
        //{
        //    var responsedt = await _iService.GetManageFilerDetail(manageFilerRequest);
        //    return responsedt;

        //}



        #endregion Old
    }
}
