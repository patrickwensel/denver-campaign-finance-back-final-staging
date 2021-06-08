using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using UserManagementApi.Domain.Service;
using UserManagementApi.Configurations;
using Microsoft.Extensions.Logging;
using Microsoft.AspNetCore.Authorization;
using Denver.Common;
using System.ComponentModel.DataAnnotations;
using Denver.Infra.Constants;


using UserManagementApi.Domain.ViewModels;

namespace UserManagementApi.Controllers
{

    public class TransactionController : BaseController
    {
        private readonly AppSettings _appSettings;

        public TransactionController(IUserManagementService iUserService, ILogger<TransactionController> logger, AppSettings appSettings) : base(iUserService, logger)
        {
            _appSettings = appSettings;
        }

        [HttpPost("SaveLoan")]
        [AllowAnonymous]
        public async Task<List<ApiResponse<bool>>> SaveLoan([FromBody] LoanApiModel transactionsApi)
        {
            if (!ModelState.IsValid)
            {
                throw new ValidationException(ValidationMessage.InvalidInput, null, ModelState.Values.SelectMany(x => x.Errors.Select(y => y.ErrorMessage)).ToList());
            }
            int response = await _iService.SaveLoan(transactionsApi);
            return response != 0 ? CreateRespWithreturnCollection(response) : GeneralErrorResponse();
        }

            /// <summary>
            /// SaveContribution - Save Transaction Details
            /// </summary>
            /// <param name="TransactionRequestApiModel"></param>
            /// <returns></returns>
            [HttpPost("saveContribution")]
            [AllowAnonymous]
            public async Task<List<ApiResponse<bool>>> SaveContribution(ContributionRequestApiModel transactionRequest)
            {
                if (!ModelState.IsValid)
                {
                    throw new ValidationException(ValidationMessage.InvalidInput, null, ModelState.Values.SelectMany(x => x.Errors.Select(y => y.ErrorMessage)).ToList());
                }

                int response = await _iService.SaveContribution(transactionRequest);

                return response != 0 ? CreateRespWithreturnCollection(response) : GeneralErrorResponse();
            }
        

        /// <summary>
        /// SaveExpenditure - Save Transaction Details
        /// </summary>
        /// <param name="ExpenditureRequestApiModel"></param>
        /// <returns></returns>
        [HttpPost("saveExpenditure")]
        [AllowAnonymous]
        public async Task<List<ApiResponse<bool>>> SaveExpenditure(ExpenditureRequestApiModel transactionRequest)
        {
            if (!ModelState.IsValid)
            {
                throw new ValidationException(ValidationMessage.InvalidInput, null, ModelState.Values.SelectMany(x => x.Errors.Select(y => y.ErrorMessage)).ToList());
            }

            int response = await _iService.SaveExpenditure(transactionRequest);
            return response != 0 ? CreateRespWithreturnCollection(response) : GeneralErrorResponse();
        }

        /// <summary>
        /// SaveUnpaidObligation - Save Unpaid Obligation Transaction Details
        /// </summary>
        /// <param name="ExpenditureRequestApiModel"></param>
        /// <returns></returns>
        [HttpPost("saveUnpaidObligation")]
        [AllowAnonymous]
        public async Task<List<ApiResponse<bool>>> SaveUnpaidObligation(UnpaidObligationsRequestApiModel transactionRequest)
        {
            if (!ModelState.IsValid)
            {
                throw new ValidationException(ValidationMessage.InvalidInput, null, ModelState.Values.SelectMany(x => x.Errors.Select(y => y.ErrorMessage)).ToList());
            }

            int response = await _iService.SaveUnpaidObligation(transactionRequest);
            return response != 0 ? CreateRespWithreturnCollection(response) : GeneralErrorResponse();
        }

        /// <summary>
        /// SaveIE - Save IE Transaction Details
        /// </summary>
        /// <param name="IERequestApiModel"></param>
        /// <returns></returns>
        [HttpPost("saveIE")]
        [AllowAnonymous]
        public async Task<List<ApiResponse<bool>>> SaveIE(IERequestApiModel transactionRequest)
        {
            if (!ModelState.IsValid)
            {
                throw new ValidationException(ValidationMessage.InvalidInput, null, ModelState.Values.SelectMany(x => x.Errors.Select(y => y.ErrorMessage)).ToList());
            }

            int response = await _iService.SaveIE(transactionRequest);
            return response != 0 ? CreateRespWithreturnCollection(response) : GeneralErrorResponse();
        }


    }
}
