using Microsoft.Extensions.Logging;
using System.Collections.Generic;
using System.Threading.Tasks;
using UserManagementApi.Domain.ApiModels;
using UserManagementApi.Domain.Repositories;
using Denver.Infra.Constants;
using UserManagementApi.Domain.Entities;
using UserManagementApi.Domain.ApiModels.Committee;
using Denver.Infra.Common;
using Microsoft.Identity.Client;
using System.Threading;
using System.Security;
using System.Linq;
using System;
using System.Data;
using System.Reflection;
using Denver.Infra.Utility;
using Newtonsoft.Json;
using System.IdentityModel.Tokens.Jwt;
using System.Text;
using System.Security.Claims;
using Microsoft.IdentityModel.Tokens;
using System.Security.Cryptography;
using Denver.Infra;
using UserManagementApi.Domain.ViewModels;
//using UserManagementApi;

namespace UserManagementApi.Domain.Service
{
    public partial class UserManagementService : IUserManagementService
    {
        private readonly IUserManagementRepository _identityRepository;
        private readonly ICommitteeRepository _committeeRepository;
        private readonly ICommonRepository _commonRepository;
        private readonly TokenValidationParameters _tokenValidationParameters;
        private readonly ISystemManagementRepository _systemManagementRepository;
        private readonly ILobbyistRepository _lobbyistRepository;
        private readonly ILookUpRepository _lookUpRepository;
        private readonly IContactRepository _contactRepository;
        private readonly ICalendarRepository _calendarRepository;
        private readonly IPaymentsRepository _paymentsRepository;
        private readonly ITransactionRepository _transactionRepository;
        private readonly ILogger _logger;

        public UserManagementService(TokenValidationParameters tokenValidationParameters, 
            ILogger<UserManagementService> logger, 
            IUserManagementRepository identityRepository, 
            ICommitteeRepository committeeRepository, 
            ICommonRepository commonRepository, 
            ILobbyistRepository lobbyistRepository, 
            ISystemManagementRepository systemManagementRepository, 
            IContactRepository contactRepository, 
            ILookUpRepository lookUpRepository, 
            ICalendarRepository calendarRepository, 
            IPaymentsRepository paymentsRepository,
            ITransactionRepository transactionRepository)
        {
            _tokenValidationParameters = tokenValidationParameters;
            _logger = logger;
            _identityRepository = identityRepository;
            _committeeRepository = committeeRepository;
            _commonRepository = commonRepository;
            _systemManagementRepository = systemManagementRepository;
            _lobbyistRepository = lobbyistRepository;
            _lookUpRepository = lookUpRepository;
            _contactRepository = contactRepository;
            _calendarRepository = calendarRepository;
            _paymentsRepository = paymentsRepository;
            _transactionRepository = transactionRepository;


        }
        private readonly IUserManagementRepository userManagementRepository;
        public async Task<int> CreateContactInfo(ContactInformationApiModel contactinfo)
        {
            return await _identityRepository.CreateContactInfo(contactinfo);
        }

        public async Task<int> LoginInformation(UserModel contactinfo, string SecretKey)
        {

            return await _identityRepository.LoginInformation(contactinfo, SecretKey);
        }
        public async Task<int> ResetPassword(ResetPasswordModel contactinfo, string SecretKey)
        {

            return await _identityRepository.ResetPassword(contactinfo, SecretKey);
        }

        public async Task<int> SelectUserType(UserTypeModel contactinfo)
        {

            return await _identityRepository.SelectUserType(contactinfo);
        }
        public async Task<bool> CreateLobbyist(LobbyistOldApiModel loyyist, EmailReq emailReq)
        {
            //return await _identityRepository.CreateLobbyist(loyyist);

            var retValue = await _identityRepository.CreateLobbyist(loyyist);

            var response = await _identityRepository.GetUserDetails(loyyist.UserID);
            UserInfoResposeApiModel userInfo = null;
            foreach (UserInfoResposeApiModel user in response)
            {
                userInfo = user;
            }
            string name = string.Empty;
            if (userInfo != null)
            {
                name = string.Format("{0} {1}", userInfo.FName, userInfo.LName);
                emailReq.ToEmail = userInfo.EmailId;
                if (retValue)
                {
                    emailReq.Subject = string.Format(Constants.CreateAccountSubject, userInfo.UserType);
                    emailReq.BodyMessage = string.Format(Constants.CreateAccountMessage, name, userInfo.UserType);

                    retValue = await SendEmail.SendMail(emailReq.SMTPServer, emailReq.SMTPPort, emailReq.FromEmail,
                                                      emailReq.ToEmail, emailReq.Password, emailReq.CcEmail,
                                                      emailReq.BccEmail, emailReq.Subject, emailReq.BodyMessage, emailReq.BodyTemplate);

                }
            }
            return retValue;


        }
        public async Task<int> CreateLobbyistEmployee(LobbyistInfo loyyist)
        {
            return await _identityRepository.CreateLobbyistEmployee(loyyist);
        }

        public async Task<int> UpdateLobbyistEmployee(LobbyistInfo loyyist)
        {
            return await _identityRepository.UpdateLobbyistEmployee(loyyist);
        }
        public async Task<int> DeleteLobbyistUser(int LobbyistEmployeeID)
        {
            return await _identityRepository.DeleteLobbyistUser(LobbyistEmployeeID);
        }

        public async Task<List<UserTypeRefDataModel>> GetAllUserType()
        {
            return await _identityRepository.GetAllUserType();

        }
        public async Task<int> CreateRolerelationship(RolerelationshipApiModel rolerelationshipinfo)
        {
            return await _identityRepository.CreateRolerelationship(rolerelationshipinfo);
        }

        public async Task<bool> UpdateIEFAdditionalInfo(IEFAddlInfoApiModel IEFDetails, EmailReq emailReq)
        {
            return await _identityRepository.UpdateIEFAdditionalInfo(IEFDetails);
        }
        public async Task<bool> UpdateLobbyistAdditionalInfo(LobbyistAddlInfoApiModel lobbyistAddlInfoDetails, EmailReq emailReq)
        {
            return await _identityRepository.UpdateLobbyistAdditionalInfo(lobbyistAddlInfoDetails);
        }
        public async Task<List<LobbyistOldApiModel>> GetLobbyistList()
        {
            return await _identityRepository.GetLobbyistList();
        }

        public async Task<IEnumerable<UAConfirmationAndSubmitResponseApiModel>> GetUserAccountConfirmAndSubmit(UAConfirmationAndSubmitRequestApiModel UAConfirmDetails)
        {
            return await _identityRepository.GetUserAccountConfirmAndSubmit(UAConfirmDetails);
        }

        public async Task<IEnumerable<UserBaseInfo>> GetOfficerListByName(OfficerListRequestApiModel searchOfficer)
        {
            return await _identityRepository.GetOfficerListByName(searchOfficer);
        }
        public async Task<IEnumerable<ClientsResponseApiModel>> GetClientListByName(ClientListRequestApiModel searchOfficer)
        {
            return await _identityRepository.GetClientListByName(searchOfficer);
        }
        public async Task<IEnumerable<LobbyistOldApiModel>> GetLobbyListByName(string searchLobbyName)
        {
            return await _identityRepository.GetLobbyListByName(searchLobbyName);
        }
        public async Task<LoginResultApiModel> Authenticate(IPublicClientApplication app, LoginUserInfoRequestApiModel loginUserInfoDetail, string secretKey, JwtTokenSettings jwtSettings, CancellationToken ct = new CancellationToken())
        {
            var validationResult = await _identityRepository.ValidateCredentials(loginUserInfoDetail, secretKey);
            if (validationResult != null)
            {
                string strDecryptPWD = GetDecryptText(validationResult.PWD, secretKey, validationResult.SaltKey);
                if (loginUserInfoDetail.Password == strDecryptPWD)
                {
                    validationResult.IsAuthenticated = true;
                    validationResult.RolesandTypes = await _identityRepository.GetUserRoles(Convert.ToInt32(validationResult.ContactId));
                }
            }

            if (validationResult == null || validationResult.IsAuthenticated == false)
            {
                validationResult = await ValidateAdminUser(app, loginUserInfoDetail, ct);
                if (validationResult.IsAuthenticated == true)
                {
                    validationResult.RolesandTypes.Add(new RolesandTypesApiModel
                    {
                        RoleID = 1,
                        Role = "Admin",
                        EntityID = 0,
                        EntityType = "",
                        EntityName = ""
                    });
                }
            }

            if (validationResult.IsAuthenticated)
            {
                return await GenerateAuthenticationResult(validationResult.EmailId, validationResult.UserId, validationResult.ContactId, jwtSettings.Secret, jwtSettings.TokenLifeTime, ct, validationResult.RolesandTypes);
            }
            else
            {
                return new LoginResultApiModel { IsAuthenticated = false, Token = string.Empty, RefreshToken = string.Empty, ErrorMessage = new List<string> { validationResult.Message } };

            }
        }


        public async Task<LoginResultApiModel> RefreshToken(LoggedInUser loggedInUser, string secret, string token, string refreshToken, TimeSpan tokenLifeTime, CancellationToken ct = new CancellationToken())
        {
            //validating the token to make sure it has the same signature

            var validatedToken = GetClaimsPrincipalFromToken(token);

            if (validatedToken == null)
            {
                return new LoginResultApiModel { ErrorMessage = new List<string> { "Invalid Token" }, Success = false };
            }

            #region OptionalValidation_ToCheckIfTokenExpired

            var expiryDateUnix =
                long.Parse(validatedToken.Claims.Single(x => x.Type == JwtRegisteredClaimNames.Exp).Value);
            var expiryDateTimeUtc = new DateTime(1970, 1, 1, 0, 0, 0, DateTimeKind.Utc).AddSeconds(expiryDateUnix);

            if (expiryDateTimeUtc < DateTime.UtcNow)
            {
                return new LoginResultApiModel
                {
                    ErrorMessage = new List<string> { "Token Expired" },

                    Success = false
                };
            }

            #endregion OptionalValidation_ToCheckIfTokenExpired

            var jti = validatedToken.Claims.Single(x => x.Type == JwtRegisteredClaimNames.Jti).Value;


            RefreshToken storedRefreshToken = _identityRepository.GetRefreshTokenByToken(refreshToken);

            if (storedRefreshToken == null || (DateTime.UtcNow > storedRefreshToken.ExpiredDate) || storedRefreshToken.Invalidated || storedRefreshToken.IsUsed || storedRefreshToken.JwtId != jti)
            {
                return new LoginResultApiModel
                {
                    ErrorMessage = new List<string> { "InValidToken" },
                    Success = false
                };
            }
            #region diffrent refresh token validations

            //if (DateTime.UtcNow > storedRefreshToken.ExpiredDate)
            //{
            //    return new AuthenticationResultApiModel
            //    {
            //        ErrorMessage = new List<string> { "Refresh Token dont exist" },
            //        Success = false
            //    };
            //}

            //if (DateTime.UtcNow > storedRefreshToken.ExpiredDate)
            //{
            //    return new AuthenticationResultApiModel
            //    {
            //        ErrorMessage = new List<string> { "Refresh token has expired" },
            //        Success = false
            //    };
            //}

            //if (storedRefreshToken.Invalidated)
            //{
            //    return new AuthenticationResultApiModel
            //    {
            //        ErrorMessage = new List<string> { "Refresh token has been invalidated" },
            //        Success = false
            //    };
            //}

            //if (storedRefreshToken.IsUsed)
            //{
            //    return new AuthenticationResultApiModel
            //    {
            //        ErrorMessage = new List<string> { "Refresh token has been used" },
            //        Success = false
            //    };
            //}

            //if (storedRefreshToken.JwtId != jti)
            //{
            //    return new AuthenticationResultApiModel
            //    {
            //        ErrorMessage = new List<string> { "Refresh token does not match JWT token" },
            //        Success = false
            //    };
            //}

            #endregion diffrent refresh token validations
            storedRefreshToken.IsUsed = true;
            _identityRepository.UpdateRefreshToken(refreshToken, storedRefreshToken.IsUsed); ;
            List<RolesandTypesApiModel> rolesandTypes = null;
            return await GenerateAuthenticationResult(loggedInUser.Email, loggedInUser.UserId, loggedInUser.UserType, secret, tokenLifeTime, ct, rolesandTypes);
        }

        public string GenerateBitRandomNumber(int size)
        {
            var randomNumber = new byte[size];
            using (var rng = RandomNumberGenerator.Create())
            {
                rng.GetBytes(randomNumber);
                return Convert.ToBase64String(randomNumber);
            }
        }

        public async Task<bool> SendMail(EmailReq emailInfo)
        {
            return await _commonRepository.SendMail(emailInfo);
        }

        public async Task<int> DeleteLobbyistEmployee(int LobbyistEmployeeID)
        {
            return await _lobbyistRepository.DeleteLobbyistEmployee(LobbyistEmployeeID);
        }

        public async Task<int> UpdateExpireDateTime(EmailReq emailReq)
        {
            int retValue = 0;
            retValue = await _identityRepository.UpdateExpireDateTime(emailReq);
            if (retValue > 0)
            {
                string ResetPage = string.Format("{0}{1}?id={2}", emailReq.UILink, Constants.ResetPage, retValue);
                emailReq.BodyMessage = string.Format(Constants.ForgotMessage, ResetPage);

                bool sendEmail = await SendEmail.SendMail(emailReq.SMTPServer, emailReq.SMTPPort, emailReq.FromEmail,
                                                       emailReq.ToEmail, emailReq.Password, emailReq.CcEmail,
                                                       emailReq.BccEmail, emailReq.Subject, emailReq.BodyMessage, emailReq.BodyTemplate);
                if (!sendEmail)
                    retValue = -1;
            }
            return retValue;

        }
        public async Task<int> SendIndependentSpender(IndependentSpenderAffiliationApiModel independentSpenderAffiliation)
        {
            return await _identityRepository.SendIndependentSpender(independentSpenderAffiliation);
        }
        public async Task<IEnumerable<IndependentSpenderApiModel>> GetIndependentSpender(SearchIERequestApiModel searchIERequest)
        {
            return await _identityRepository.GetIndependentSpender(searchIERequest);
        }
        private string GetDecryptText(string pPassword, string pSecretKey, string pSalt)
        {
            Cryptograhy cryptograhy = new Cryptograhy();
            string decryptValue = cryptograhy.DecryptText(pPassword, pSecretKey, pSalt);
            return decryptValue;
        }

        public async Task<LobbyistDetailResponseApiModel> GetLobbyistDetail(int lobbyistId)
        {
            return await _identityRepository.GetLobbyistDetail(lobbyistId);
        }
        public async Task<IEnumerable<SwitchCommitteeDetail>> GetSwitchCommitteeDetails(int id)
        {
            return await _identityRepository.GetSwitchCommitteeDetails(id);
        }
        public async Task<IEnumerable<SwitchLobbyistDetail>> GetSwitchLobbyistDetails(int id)
        {
            return await _identityRepository.GetSwitchLobbyistDetails(id);
        }
        public async Task<IEnumerable<SwitchIEDetail>> GetSwitchIEDetails(int id)
        {
            return await _identityRepository.GetSwitchIEDetails(id);
        }

        private async Task<LoginUserInfoResposeApiModel> ValidateAdminUser(IPublicClientApplication app, LoginUserInfoRequestApiModel credentials, CancellationToken ct = new CancellationToken())
        {
            var tokenAcquisitionHelper = new Denver.Infra.AzureAdValidator(app);
            SecureString password = new SecureString();
            credentials.Password.ToCharArray().ToList().ForEach(password.AppendChar);
            password.MakeReadOnly();
            var authenticationResult = await tokenAcquisitionHelper.AcquireAzureADTokenFromUsernamePasswordAsync(new string[] { "User.Read", "User.ReadBasic.All" }, credentials.EmailId, password);

            if (authenticationResult.Result != null)
            {
                return new LoginUserInfoResposeApiModel { EmailId = credentials.EmailId, IsAuthenticated = true, TypeId = 0, UserType = "Admin", UserId = authenticationResult.Result.UniqueId, RolesandTypes = new List<RolesandTypesApiModel>(), ContactId = string.Empty };
            }
            else
            {
                return new LoginUserInfoResposeApiModel { EmailId = credentials.EmailId, IsAuthenticated = false, Message = authenticationResult.Message };
            }
        }
        public async Task<IEnumerable<ManageFilerResponseApiModel>> GetManageFilerDetail(ManageFilerRequestApiModel manageFilerRequest)
        {
            return await _identityRepository.GetManageFilerDetail(manageFilerRequest);
        }

        public async Task<ManageCommitteeDownload> DownloadManageFiler(ManageFilerRequestApiModel manageFilerRequest)
        {
            var latest = new ManageCommitteeDownload();
            DataTable dataTable = await _identityRepository.DownloadManageFiler(manageFilerRequest);
            latest.ExcelDocumentByte = ExportToExcel.GenerateExcel(dataTable);
            return latest;
        }

        public async Task<IEnumerable<UserInfoResposeApiModel>> GetUserDetails(int UserID)
        {
            return await _identityRepository.GetUserDetails(UserID);
        }
        public async Task<bool> UpdateLobbyistStatus(LobbyistStatusUpdateRequestApiModel lobbyistStatusUpdate, EmailReq emailReq)
        {
            bool retValue = await _identityRepository.UpdateLobbyistStatus(lobbyistStatusUpdate);
            var userEmailDetail = await _identityRepository.GetLobbyistUserEmail(lobbyistStatusUpdate.Id);
            string name = string.Empty;
            if (userEmailDetail != null)
            {
                name = string.Format("{0} {1}", userEmailDetail.FirstName, userEmailDetail.LastName);
                emailReq.ToEmail = userEmailDetail.Email;
                if (retValue)
                {
                    if (lobbyistStatusUpdate.Status)
                    {
                        emailReq.Subject = string.Format(Constants.LobbyistApprovedOrDeniedEmailSubject, Constants.STATUS_APPROVED);
                        emailReq.BodyMessage = string.Format(Constants.LobbyistApprovedOrDeniedMessage, name, Constants.STATUS_APPROVED.ToLower());
                    }
                    else
                    {
                        emailReq.Subject = string.Format(Constants.LobbyistApprovedOrDeniedEmailSubject, Constants.STATUS_REJECTED);
                        emailReq.BodyMessage = string.Format(Constants.LobbyistApprovedOrDeniedMessage, name, Constants.STATUS_REJECTED.ToLower());
                    }
                    retValue = await SendEmail.SendMail(emailReq.SMTPServer, emailReq.SMTPPort, emailReq.FromEmail,
                                                      emailReq.ToEmail, emailReq.Password, emailReq.CcEmail,
                                                      emailReq.BccEmail, emailReq.Subject, emailReq.BodyMessage, emailReq.BodyTemplate);

                }
            }
            return retValue;
        }


        private ClaimsPrincipal GetClaimsPrincipalFromToken(string token)
        {
            var tokenHandler = new JwtSecurityTokenHandler();
            try
            {
                var principal = tokenHandler.ValidateToken(token, _tokenValidationParameters, out var validatedToken);
                return !IsJwtWithValidSecurityAlgorithm(validatedToken) ? null : principal;
            }
            catch
            {
                return null;
            }
        }

        private bool IsJwtWithValidSecurityAlgorithm(SecurityToken validatedToken)
        {
            return (validatedToken is JwtSecurityToken jwtSecurityToken) &&
                   jwtSecurityToken.Header.Alg.Equals(SecurityAlgorithms.HmacSha256, StringComparison.InvariantCulture);
        }

        private async Task<LoginResultApiModel> GenerateAuthenticationResult(string email, string userId, string contactId, string secret, TimeSpan tokenLifeTime, CancellationToken ct, List<RolesandTypesApiModel> rolesandTypes)
        {
            var tokenHandler = new JwtSecurityTokenHandler();
            var key = Encoding.ASCII.GetBytes(secret);
            var tokenDescriptor = new SecurityTokenDescriptor
            {
                Subject = new ClaimsIdentity(new[]
                {   new Claim(JwtRegisteredClaimNames.Sub, email),
                    new Claim(JwtRegisteredClaimNames.Email, email),
                    new Claim(JwtRegisteredClaimNames.Jti, Guid.NewGuid().ToString()),
                    new Claim("Id", userId.ToString()),
                    new Claim("ContactId", contactId.ToString()),
                    new Claim("role", "")
                }),
                Expires = DateTime.UtcNow.Add(tokenLifeTime),
                SigningCredentials = new SigningCredentials(new SymmetricSecurityKey(key), SecurityAlgorithms.HmacSha256Signature)
            };
            var token = tokenHandler.CreateToken(tokenDescriptor);
            var refreshToken = this.GenerateBitRandomNumber(32);
            var newRefreshToken = new RefreshToken
            {
                JwtId = token.Id,
                UserId = userId,
                ExpiredDate = DateTime.UtcNow.AddDays(1),
                Token = refreshToken
            };
            _identityRepository.SaveRefreshToken(newRefreshToken);
            return new LoginResultApiModel
            {
                Success = true,
                IsAuthenticated = true,
                Token = tokenHandler.WriteToken(token),
                RefreshToken = refreshToken,
                RolesandTypes = rolesandTypes
            };
        }

        public async Task<int> VaidateEmailCheck(string UserEmailID)
        {
            return await _identityRepository.VaidateEmailCheck(UserEmailID);
        }
        public async Task<int> UpdateIEAdditionalInfo(IEUpdateAddlInfoRequestApiModel iEUpdateAddlInfo)
        {
            return await _identityRepository.UpdateIEAdditionalInfo(iEUpdateAddlInfo);
        }
        public async Task<UserEntitiesResponseApiModel> GetUserEntites(int userId)
        {
            return await _identityRepository.GetUserEntites(userId);
        }
        public async Task<UserEntityDetailsResponseApiModel> GetUserEntityDetails(int entityId, string entityType)
        {
            return await _identityRepository.GetUserEntityDetails(entityId, entityType);
        }

        public async Task<IEnumerable<ManageFilersResponseApiModel>> GetManageFilers(ManageFilersRequestApiModel manageFilerRequest)
        {
            if (manageFilerRequest.StartDate == null)
            {
                manageFilerRequest.StartDate = DateTime.MinValue;
            }

            if (manageFilerRequest.EndDate == null)
            {
                manageFilerRequest.EndDate = DateTime.MaxValue;
            }

            if (manageFilerRequest.ElectionDate == null)
            {
                manageFilerRequest.ElectionDate = DateTime.MaxValue;
            }
            return await _identityRepository.GetManageFilers(manageFilerRequest);
        }


        public async Task<int> SaveIndependentSpenderAffiliation(IndependentSpendersAffiliationApiModel independentSpenderAffiliation)
        {
            return await _identityRepository.SaveIndependentSpenderAffiliation(independentSpenderAffiliation);
        }

        public async Task<List<GetLobbyistEmployee>> GetIndependentSpender(int independentSpenderId)
        {
            return await _identityRepository.GetIndependentSpender(independentSpenderId);
        }

        public async Task<List<string>> GetFilerNamesByName(string searchName)
        {
            return await _identityRepository.GetFilerNamesByName(searchName);
        }

        public async Task<int> FilerInviteUser(AddUserPaymentApiModel addUserPayment)
        {
            return await _identityRepository.FilerInviteUser(addUserPayment);
        }

        public async Task<List<GetCurrentUser>> GetFilerUsers(int entityId, string entityType)
        {
            return await _identityRepository.GetFilerUsers(entityId, entityType);
        }

        public async Task<int> DeleteFilerContact(int contactId, int filerId)
        {
            return await _identityRepository.DeleteFilerContact(contactId, filerId);
        }

        public async Task<IEnumerable<MakeTreasurerApiModel>> SaveMakeTreasurer(MakeTreasurerApiModel addMakeTreasurer)
        {
            return await _identityRepository.SaveMakeTreasurer(addMakeTreasurer);
        }

        public async Task<List<GetAdminUsers>> GetFilerAdminUsers(int filerId, int userId, string filerType, string status, DateTime lastActiveStartDate, DateTime lastActiveEndDate, DateTime createdStartDate, DateTime createdEndDate)
        {
            return await _identityRepository.GetFilerAdminUsers(filerId, userId, filerType, status, lastActiveStartDate, lastActiveEndDate, createdStartDate, createdEndDate);
        }
        public async Task<List<GetAdminUsers>> GetUserAffiliations(int filerId, int userId, string filerType, string status, DateTime lastActiveStartDate, DateTime lastActiveEndDate, DateTime createdStartDate, DateTime createdEndDate)
        {
            return await _identityRepository.GetUserAffiliations(filerId, userId, filerType, status, lastActiveStartDate, lastActiveEndDate, createdStartDate, createdEndDate);
        }
    }
}
