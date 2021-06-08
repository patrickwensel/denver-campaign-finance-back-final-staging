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
    
    public class PaymentsController : BaseController
    {
        private readonly AppSettings _appSettings;

        public PaymentsController(IUserManagementService iUserService, ILogger<PaymentsController> logger, AppSettings appSettings) : base(iUserService, logger)
        {
            _appSettings = appSettings;
        }

        /// <summary>
        /// SaveFee - 
        /// </summary>
        /// <param name="SaveFee"></param>
        /// <returns></returns>

        [HttpPost("SaveFees")]
        [AllowAnonymous]
        public async Task<List<ApiResponse<bool>>> SaveFees([FromBody] SaveFeesApiModel saveFeesApi)
        {
            if (!ModelState.IsValid)
            {
                throw new ValidationException(ValidationMessage.InvalidInput, null, ModelState.Values.SelectMany(x => x.Errors.Select(y => y.ErrorMessage)).ToList());
            }
            int response = await _iService.SaveFees(saveFeesApi);
            return response != 0 ? CreateRespWithreturnCollection(response) : GeneralErrorResponse();
        }
        /// <summary>
        /// DeleteFee -  List
        /// </summary>
        /// <param name="fee_Id"></param>
        /// <returns></returns>
        [HttpPost("DeleteFees")]
        [AllowAnonymous]
        public async Task<List<ApiResponse<bool>>> DeleteFees(int fee_Id)

        {
            int response = await _iService.DeleteFees(fee_Id);
            return response != 0 ? CreateRespWithreturnCollectionForD(response) : GeneralErrorResponse();
        }
        /// <summary>
        /// GetFees -  List
        /// </summary>
        /// <param name="GetFees"></param>
        /// <returns></returns>
        [HttpGet("GetFees")]
        [AllowAnonymous]
        public async Task<List<GetFeesResposneApiModel>> GetFees()
        {
            if (!ModelState.IsValid)
            {
                throw new ValidationException(ValidationMessage.InvalidInput, null, ModelState.Values.SelectMany(x => x.Errors.Select(y => y.ErrorMessage)).ToList());
            }
            List<GetFeesResposneApiModel> responsedt = await _iService.GetFees();
            return responsedt;
        }
        /// <summary>
        /// GetFeeById -  List
        /// </summary>
        /// <param name="Fee_id"></param>
        /// <returns></returns>
        [HttpGet("GetFeeById")]
        [AllowAnonymous]
        public async Task<IEnumerable<GetFeesResposneApiModel>> GetFeeById(int fee_id)
        {
            if (!ModelState.IsValid)
            {
                throw new ValidationException(ValidationMessage.InvalidInput, null, ModelState.Values.SelectMany(x => x.Errors.Select(y => y.ErrorMessage)).ToList());
            }
            var response = await _iService.GetFeeById(fee_id);
            return response;
        }

        [HttpPost("SavePenalty")]
        [AllowAnonymous]
        public async Task<List<ApiResponse<bool>>> SavePenalty([FromBody] PenaltyApiModel savepenaltyApi)
        {
            if (!ModelState.IsValid)
            {
                throw new ValidationException(ValidationMessage.InvalidInput, null, ModelState.Values.SelectMany(x => x.Errors.Select(y => y.ErrorMessage)).ToList());
            }
            int response = await _iService.SavePenalty(savepenaltyApi);
            return response != 0 ? CreateRespWithreturnCollection(response) : GeneralErrorResponse();
        }

        [HttpPost("SaveTransaction")]
        [AllowAnonymous]
        public async Task<List<ApiResponse<bool>>> SaveTransaction([FromBody] PaymentApiModel paymentapi)
        {
            if (!ModelState.IsValid)
            {
                throw new ValidationException(ValidationMessage.InvalidInput, null, ModelState.Values.SelectMany(x => x.Errors.Select(y => y.ErrorMessage)).ToList());
            }
            int response = await _iService.SaveTransaction(paymentapi);
            return response != 0 ? CreateRespWithreturnCollection(response) : GeneralErrorResponse();
        }

        [HttpGet("GetInvoices")]
        [AllowAnonymous]
        public async Task<IEnumerable<InvoiceApiModel>> GetInvoices(int filerid)
        {
            if (!ModelState.IsValid)
            {
                throw new ValidationException(ValidationMessage.InvalidInput, null, ModelState.Values.SelectMany(x => x.Errors.Select(y => y.ErrorMessage)).ToList());
            }
            var response = await _iService.GetInvoices(filerid);
            return response;
        }
        [HttpGet("GetFilerInvoices")]
        [AllowAnonymous]
        public async Task<IEnumerable<InvoiceApiModel>> GetFilerInvoices(int entityid, string entitytype)
        {
            if (!ModelState.IsValid)
            {
                throw new ValidationException(ValidationMessage.InvalidInput, null, ModelState.Values.SelectMany(x => x.Errors.Select(y => y.ErrorMessage)).ToList());
            }
            var response = await _iService.GetFilerInvoices(entityid,entitytype);
            return response;
        }
        [HttpGet("GetFilerOutStandingFeeSummary")]
        [AllowAnonymous]
        public async Task<IEnumerable<FeeSummaryApiModel>> GetFilerOutStandingFeeSummary(int entityid, string entitytype)
        {
            if (!ModelState.IsValid)
            {
                throw new ValidationException(ValidationMessage.InvalidInput, null, ModelState.Values.SelectMany(x => x.Errors.Select(y => y.ErrorMessage)).ToList());
            }
            var response = await _iService.GetFilerOutStandingFeeSummary(entityid, entitytype);
            return response;
        }
        [HttpGet("GetOutStandingFeeSummary")]
        [AllowAnonymous]
        public async Task<IEnumerable<FeeSummaryApiModel>> GetOutStandingFeeSummary(int filerid)
        {
            if (!ModelState.IsValid)
            {
                throw new ValidationException(ValidationMessage.InvalidInput, null, ModelState.Values.SelectMany(x => x.Errors.Select(y => y.ErrorMessage)).ToList());
            }
            var response = await _iService.GetOutStandingFeeSummary(filerid);
            return response;
        }
        [HttpGet("GetInvoiceInfoFromId")]
        [AllowAnonymous]
        public async Task<IEnumerable<InvoiceApiModel>> GetInvoiceInfoFromId(int invoiceid, int filerid)
        {
            if (!ModelState.IsValid)
            {
                throw new ValidationException(ValidationMessage.InvalidInput, null, ModelState.Values.SelectMany(x => x.Errors.Select(y => y.ErrorMessage)).ToList());
            }
            var response = await _iService.GetInvoiceInfoFromId(invoiceid, filerid);
            return response;
        }



        [HttpPost("UpdateInvoiceStatus")]
        [AllowAnonymous]
        public async Task<List<ApiResponse<bool>>> UpdateInvoiceStatus([FromBody] InvoiceApiModel invoiceapi)
        {
            if (!ModelState.IsValid)
            {
                throw new ValidationException(ValidationMessage.InvalidInput, null, ModelState.Values.SelectMany(x => x.Errors.Select(y => y.ErrorMessage)).ToList());
            }
            int response = await _iService.UpdateInvoiceStatus(invoiceapi.InvoiceId,invoiceapi.InvoiceStatus);
            return response != 0 ? CreateRespWithreturnCollection(response) : GeneralErrorResponse();
        }


        #region Fine Settings

        [HttpPost("SaveFine")]
        [AllowAnonymous]
        public async Task<List<ApiResponse<bool>>> SaveFineSettings([FromBody] FineSettingsApiModel fineSetting)
        {
            if (!ModelState.IsValid)
            {
                throw new ValidationException(ValidationMessage.InvalidInput, null, ModelState.Values.SelectMany(x => x.Errors.Select(y => y.ErrorMessage)).ToList());
            }
            int response = await _iService.SaveFine(fineSetting);
            return response != 0 ? CreateRespWithreturnCollection(response) : GeneralErrorResponse();
        }

        [HttpGet("GetFines")]
        [AllowAnonymous]
        public async Task<List<GetFineSettingsApiModel>> GetFines()
        {
            if (!ModelState.IsValid)
            {
                throw new ValidationException(ValidationMessage.InvalidInput, null, ModelState.Values.SelectMany(x => x.Errors.Select(y => y.ErrorMessage)).ToList());
            }
            List<GetFineSettingsApiModel> responsedt = await _iService.GetFines();
            return responsedt;
        }

        [HttpDelete("DeleteFine")]
        [AllowAnonymous]
        public async Task<List<ApiResponse<bool>>> DeleteFine(int fineId)

        {
            int response = await _iService.DeleteFine(fineId);
            return response != 0 ? CreateRespWithreturnCollectionForD(response) : GeneralErrorResponse();
        }

        [HttpGet("GetFineById")]
        [AllowAnonymous]
        public async Task<IEnumerable<GetFineSettingsApiModel>> GetFineById(int fineId)
        {
            if (!ModelState.IsValid)
            {
                throw new ValidationException(ValidationMessage.InvalidInput, null, ModelState.Values.SelectMany(x => x.Errors.Select(y => y.ErrorMessage)).ToList());
            }
            var response = await _iService.GetFineById(fineId);
            return response;
        }
        #endregion Fine Settings

        /// <summary>
        /// getPaymentHistory - get Payment History based on search criteria
        /// </summary>
        /// <param name="filerName"></param>
        /// <param name="filerType"></param>
        /// <param name="startDate"></param>
        /// <param name="endDate"></param>
        /// <param name="electionCycleId"></param>
        /// <returns></returns>
        [HttpGet("getPaymentHistory")]
        [AllowAnonymous]
        public async Task<List<PaymentHistoryResponseApiModel>> getPaymentHistory(string filerName, string filerType, string startDate, string endDate, int? electionCycleId)
        {
            List<PaymentHistoryResponseApiModel> response = await _iService.getPaymentHistory(filerName, filerType, startDate, endDate, electionCycleId);
            return response;
        }


        /// <summary>
        /// getFilerPaymentHistory - get Filer Payment History
        /// </summary>
        /// <param name="filerId"></param>
        /// <returns></returns>
        [HttpGet("getFilerPaymentHistory")]
        [AllowAnonymous]
        public async Task<List<PaymentHistoryResponseApiModel>> getFilerPaymentHistory(int filerId)
        {
            List<PaymentHistoryResponseApiModel> response = await _iService.getFilerPaymentHistory(filerId);
            return response;
        }

        /// <summary>
        /// getEntityPaymentHistory - get Entity Payment History
        /// </summary>
        /// <param name="entityId"></param>
        /// <param name="entityType"></param>
        /// <returns></returns>
        [HttpGet("getEntityPaymentHistory")]
        [AllowAnonymous]
        public async Task<List<PaymentHistoryResponseApiModel>> getEntityPaymentHistory(int entityId, string entityType)
        {
            List<PaymentHistoryResponseApiModel> response = await _iService.getEntityPaymentHistory(entityId, entityType);
            return response;
        }

        /// <summary>
        /// DownloadPaymentHistory - Download Payment History as CSV
        /// </summary>
        /// <param name="filerName"></param>
        /// <param name="filerType"></param>
        /// <param name="startDate"></param>
        /// <param name="endDate"></param>
        /// <param name="electionCycleId"></param>
        /// <returns></returns>
        [HttpGet("DownloadPaymentHistory")]
        [AllowAnonymous]
        public async Task<HistoryResponseApiModel> DownloadPaymentHistory(string filerName, string filerType, string startDate, string endDate, int? electionCycleId)
        {
            var responsedt = await _iService.DownloadPaymentHistory(filerName, filerType, startDate, endDate, electionCycleId);
            return responsedt;

        }
    }
}
