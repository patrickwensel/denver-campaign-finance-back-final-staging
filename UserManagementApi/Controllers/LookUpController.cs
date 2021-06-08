using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using UserManagementApi.Domain.ApiModels;
using UserManagementApi.Domain.Service;
using UserManagementApi.Domain.ViewModels;

namespace UserManagementApi.Controllers
{
    [Route("api/LookUp")]
    [ApiController]
    public class LookUpController : ControllerBase
    {
        protected readonly ILogger _logger;
        protected readonly IUserManagementService _iUserManagementService;
        public LookUpController(IUserManagementService iUserManagementService, ILogger<LookUpController> logger)
        {
            _iUserManagementService = iUserManagementService;
            _logger = logger;
        }

        [HttpGet("getLookUps")]
        [AllowAnonymous]
        public async Task<ActionResult> GetLookUpTypeList(string lookUpTypeCode)
        {
            return Ok(await _iUserManagementService.GetLookUpTypeList(lookUpTypeCode));
        }

       
        /// GetStateList - Retrieve the State details list
        /// </summary>
        /// <returns>StatesResponse<returns>
        [HttpGet("getStatesList")]
        [AllowAnonymous]
        public async Task<ActionResult> GetStatesList()
        {
            return Ok(await _iUserManagementService.GetStatesList());
        }

        /// <summary>
        /// GetStatus - Retrieve the Status detail list
        /// </summary>
        /// <returns>StatusResponse<returns>
        /// 
        [HttpGet("getStatusList")]
        [AllowAnonymous]
        public async Task<ActionResult> GetStatusList(string statusCode)
        {
            return Ok(await _iUserManagementService.GetStatusList(statusCode));
        }
        
        /// <summary>
        /// GetElectionCycleByType - Retrieve the Election Cycle detail list
        /// </summary>
        /// <returns>ElectionCycleResponse<returns>
        /// 
        [HttpGet("getElectionCycleByType")]
        [AllowAnonymous]
        public async Task<ActionResult> GetElectionCycleByType(string typeCode)
        {
            return Ok(await _iUserManagementService.GetElectionCycleByType(typeCode));
        }

        [HttpGet("getElectionDates")]
        [AllowAnonymous]
        public async Task<ActionResult> GetElectionDates()
        {
           return Ok(await _iUserManagementService.GetElectionDates());
        }

    }
}
