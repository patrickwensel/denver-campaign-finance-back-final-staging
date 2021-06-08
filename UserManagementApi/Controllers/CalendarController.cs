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
using UserManagementApi.Domain.Service;
using UserManagementApi.Domain.ViewModels;

namespace UserManagementApi.Controllers
{
    public class CalendarController : BaseController
    {
        private readonly AppSettings _appSettings;

        public CalendarController(IUserManagementService iUserService, ILogger<CalendarController> logger, AppSettings appSettings) : base(iUserService, logger)
        {
            _appSettings = appSettings;
        }

        /// <summary>
        /// saveElectionCycle - Save Election Cycle Details
        /// </summary>
        /// <param name="saveLobbyist"></param>
        /// <returns></returns>
        [HttpPost("saveElectionCycle")]
        [AllowAnonymous]
        public async Task<List<ApiResponse<bool>>> SaveElectionCycle([FromBody] ElectionCycleRequestApiModel electionCycleRequest)
        {
            if (!ModelState.IsValid)
            {
                throw new ValidationException(ValidationMessage.InvalidInput, null, ModelState.Values.SelectMany(x => x.Errors.Select(y => y.ErrorMessage)).ToList());
            }

            int response = await _iService.SaveElectionCycle(electionCycleRequest);
            return response != 0 ? CreateRespWithreturnCollection(response) : GeneralErrorResponse();
        }

        /// <summary>
        /// deleteElectionCycle - Delete Election Cycle Details
        /// </summary>
        /// <param name="saveLobbyist"></param>
        /// <returns></returns>
        [HttpPost("deleteElectionCycle")]
        [AllowAnonymous]
        public async Task<List<ApiResponse<bool>>> DeleteElectionCycle(int electionCycleId)
        {
            if (!ModelState.IsValid)
            {
                throw new ValidationException(ValidationMessage.InvalidInput, null, ModelState.Values.SelectMany(x => x.Errors.Select(y => y.ErrorMessage)).ToList());
            }
            int response = await _iService.DeleteElectionCycle(electionCycleId);
            return response != 0 ? CreateRespWithreturnCollectionForD(response) : GeneralErrorResponse();
        }

        /// <summary>
        /// getElectionCycleById - Get Election Cycle Details
        /// </summary>
        /// <param name="saveLobbyist"></param>
        /// <returns></returns>
        [HttpGet("getElectionCycleById")]
        [AllowAnonymous]
        public async Task<IEnumerable<ElectionCycleResponseApiModel>> getElectionCycleById(int electionCycleId)
        {
            if (!ModelState.IsValid)
            {
                throw new ValidationException(ValidationMessage.InvalidInput, null, ModelState.Values.SelectMany(x => x.Errors.Select(y => y.ErrorMessage)).ToList());
            }
            var response = await _iService.GetElectionCycleById(electionCycleId);
            return response;
        }
        /// <summary>
        /// SaveEvents - Employee List
        /// </summary>
        /// <param name="SaveEvents"></param>
        /// <returns></returns>

        [HttpPost("SaveEvents")]
        [AllowAnonymous]
        public async Task<List<ApiResponse<bool>>> SaveEvents([FromBody] SaveEventsApiModel saveEvents)
        {
            if (!ModelState.IsValid)
            {
                throw new ValidationException(ValidationMessage.InvalidInput, null,ModelState.Values.SelectMany(x => x.Errors.Select(y => y.ErrorMessage)).ToList());
            }
            int response = await _iService.SaveEvents(saveEvents);
            return response != 0 ? CreateRespWithreturnCollection(response) : GeneralErrorResponse();
        }
        /// <summary>
        /// DeleteEvents -  List
        /// </summary>
        /// <param name="eventId"></param>
        /// <returns></returns>
        [HttpPost("DeleteEvents")]
        [AllowAnonymous]
        public async Task<List<ApiResponse<bool>>> DeleteEvents(int eventId)

        {
            int response = await _iService.DeleteEvents(eventId);
            return response != 0 ? CreateRespWithreturnCollectionForD(response) : GeneralErrorResponse();
        }
        /// <summary>
        /// GetEventList - GetEventList
        /// </summary>
        /// <returns>GetEventList<returns>
        /// <summary>
        [HttpGet("GetEvents")]
        [AllowAnonymous]
        public async Task<ActionResult> GetEventList()
        {
            return Ok(await _iService.GetEventList());
        }
     
        #region Filing Period
        [HttpPost("SaveFilingPeriod")]
        [AllowAnonymous]
        public async Task<List<ApiResponse<bool>>> SaveFilingPeriod([FromBody] FilingPeriodApiModel filingPeriod)
        {
            if (!ModelState.IsValid)
            {
                throw new ValidationException(ValidationMessage.InvalidInput, null, ModelState.Values.SelectMany(x => x.Errors.Select(y => y.ErrorMessage)).ToList());
            }
            int response = await _iService.SaveFilingPeriod(filingPeriod);
            return response != 0 ? CreateRespWithreturnCollection(response) : GeneralErrorResponse();
        }

        [HttpGet("GetFilingPeriods")]
        [AllowAnonymous]
        public async Task<List<GetFilingPeriodApiModel>> GetFilingPeriods()
        {
            if (!ModelState.IsValid)
            {
                throw new ValidationException(ValidationMessage.InvalidInput, null, ModelState.Values.SelectMany(x => x.Errors.Select(y => y.ErrorMessage)).ToList());
            }
            List<GetFilingPeriodApiModel> responsedt = await _iService.GetFilingPeriods();
            return responsedt;
        }

        [HttpDelete("DeleteFilingPeriod")]
        [AllowAnonymous]
        public async Task<List<ApiResponse<bool>>> DeleteFilingPeriod(int filingperiodid)

        {
            int response = await _iService.DeleteFilingPeriod(filingperiodid);
            return response != 0 ? CreateRespWithreturnCollectionForD(response) : GeneralErrorResponse();
        }

        [HttpGet("GetFilingPeriodById")]
        [AllowAnonymous]
        public async Task<IEnumerable<GetFilingPeriodApiModel>> GetFilingPeriodById(int filingperiodid)
        {
            if (!ModelState.IsValid)
            {
                throw new ValidationException(ValidationMessage.InvalidInput, null, ModelState.Values.SelectMany(x => x.Errors.Select(y => y.ErrorMessage)).ToList());
            }
            var response = await _iService.GetFilingPeriodById(filingperiodid);
            return response;
        }

        #endregion Filing Period

        /// <summary>
        /// GetElectionCycles - Retrieve the Election Cycle detail list
        /// </summary>
        /// <returns>ElectionCycleResponse<returns>
        /// 
        [HttpGet("getElectionCycles")]
        [AllowAnonymous]
        public async Task<ActionResult> GetElectionCycles()
        {
            return Ok(await _iService.GetElectionCycles());
        }

        /// <summary>
        /// getCalendarDetailsBasedOnFilerType - Get Calendar Details Based On FilerType
        /// </summary>
        /// <param name="filerType"></param>
        /// <param name="month"></param>
        /// <param name="year"></param>
        /// <returns></returns>
        [HttpGet("getCalendarEvents")]
        [AllowAnonymous]
        public async Task<CalendarEventsApiModel> getCalendarDetails(string filerType, string month, string year)
        {
            if (!ModelState.IsValid)
            {
                throw new ValidationException(ValidationMessage.InvalidInput, null, ModelState.Values.SelectMany(x => x.Errors.Select(y => y.ErrorMessage)).ToList());
            }
            var response = await _iService.GetCalendarDetails(filerType, month, year);
            return response;

        }
        [HttpGet("GetEventsById")]
        [AllowAnonymous]
        public async Task<IEnumerable<GetEventsResponseApiModel>> GetEventsById(int eventId)
        {
            if (!ModelState.IsValid)
            {
                throw new ValidationException(ValidationMessage.InvalidInput, null, ModelState.Values.SelectMany(x => x.Errors.Select(y => y.ErrorMessage)).ToList());
            }
            var response = await _iService.GetEventsById(eventId);
            return response;
        }
    }
}
