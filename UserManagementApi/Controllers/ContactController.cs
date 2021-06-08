using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Denver.Common;
using Denver.Infra.Constants;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using UserManagementApi.Configurations;
using UserManagementApi.Domain.Service;
using UserManagementApi.Domain.ViewModels;
using Denver.Infra.Exceptions;

namespace UserManagementApi.Controllers
{
    [ApiController]
    public class ContactController : BaseController
    {
        private readonly AppSettings _appSettings;

        protected readonly IUserManagementService _iUserManagementService;
        public ContactController(IUserManagementService iUserService, ILogger<CommitteeController> logger, AppSettings appSettings) : base(iUserService, logger)
        {
            _appSettings = appSettings;
        }
        /// <summary>
        /// CreateContact - Save Contact Details
        /// </summary>
        /// <param name="createContact"></param>
        /// <returns></returns>
        [HttpPost("createContact")]
        [AllowAnonymous]
        public async Task<List<ApiResponse<bool>>> CreateContact([FromBody] ContactUserAccountApiModel createContact)
        {
            if (!ModelState.IsValid)
            {
                throw new ValidationException(ValidationMessage.InvalidInput, ModelState.Values.SelectMany(x => x.Errors.Select(y => y.ErrorMessage)).ToList());
            }
            int response = await _iService.CreateContact(createContact, (this._appSettings.Secret.SecretKey));
            return response != 0 ? CreateRespWithreturnCollection(response) : GeneralErrorResponse();

        }

        /// <summary>
        /// getLendersPayersContributerContacts - Retrieve the Contact detail list
        /// </summary>
        /// <returns>NamesByTxnTypeResponseApiModel<returns>
        /// 
        [HttpGet("getLendersPayersContributerContacts")]
        [AllowAnonymous]
        public async Task<ActionResult> GetLendersPayersContributerContacts(int entityId, string entityType, string searchName)
        {
            return Ok(await _iService.GetLendersPayersContributerContacts(entityId, entityType, searchName));
        }

        /// <summary>
        /// GetContactDetailsById - Retrieve the Contact detail
        /// </summary>
        /// <returns>TxnContactDetailResponseApiModel<returns>
        /// 
        [HttpGet("getContactDetailsById")]
        [AllowAnonymous]
        public async Task<ActionResult> GetContactDetailsById(int contactId)
        {
            return Ok(await _iService.GetContactDetailsById(contactId));
        }
    }
}