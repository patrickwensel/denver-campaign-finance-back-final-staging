using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Claims;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using UserManagementApi.Domain.Service;
using FluentValidation.Results;
using Denver.Common;
using Denver.Infra;

namespace UserManagementApi.Controllers
{

    [Route("api/[controller]")]
    [ApiController]
    public class BaseController : ControllerBase
    {
        protected readonly ILogger _logger;
        protected readonly IUserManagementService _iService;

        public BaseController(IUserManagementService service, ILogger<BaseController> logger)
        {
            _iService = service;
            _logger = logger;
        }

        protected LoggedInUser GetLoggedInUser()
        {
            string userId = string.Empty;
            string contactId = string.Empty;
            string userType = string.Empty;
            string email = string.Empty;
            var identity = HttpContext.User.Identity as ClaimsIdentity;
            if (identity != null)
            {
                IEnumerable<Claim> claims = identity.Claims;
                userId = claims.Single(x => x.Type == "Id").Value;
                contactId = claims.Single(x => x.Type == "ContactId").Value;
                userType = claims.Single(x => x.Type == ClaimTypes.Role).Value;
                email = claims.Single(x => x.Type == ClaimTypes.Email).Value;
            }
            return new LoggedInUser { Email = email, UserId = userId, ContactId = contactId, UserType = userType };
        }

        [NonAction]
        public ApiResponse<string> SuccessResponseWithCustomMessage(string msg, int pk)
        {
            return new ApiResponse<string>
            {
                HasError = false,
                Result = "",
                pkId = pk,
                Code = 200,
                Message = msg
            };
        }
        [NonAction]
        public List<ApiResponse<bool>> GeneralErrorResponse()
        {
            return new List<ApiResponse<bool>>
            {
                new ApiResponse<bool>()
                {
                HasError = true,
                Result = false,
                Code = 404,
                Message = "Error occured during Add/Update Operation"
                }
            };
        }
        [NonAction]
        public List<ApiResponse<string>> ErrorResponseWithCustomMessages(string errMSG)
        {
            ApiResponse<string> ApiResponse = new ApiResponse<string>();
            List<ApiResponse<string>> ListOfApiResponse = new List<ApiResponse<string>>();
            ApiResponse = new ApiResponse<string>()

            {
                HasError = true,
                Result = "",
                Code = 400,
                Message = errMSG
            };
            ListOfApiResponse.Add(ApiResponse);

            return ListOfApiResponse;
        }
        [NonAction]
        public ApiResponse<string> ErrorResponseWithCustomMessage(string errMSG)
        {
            return new ApiResponse<string>
            {
                HasError = true,
                Result = "",
                Code = 400,
                Message = errMSG
            };
        }
        [NonAction]
        public List<ApiResponse<bool>> CreateRespWithreturnCollection(int? pk)
        {
            ApiResponse<bool> ApiResponse = new ApiResponse<bool>();
            List<ApiResponse<bool>> ListOfApiResponse = new List<ApiResponse<bool>>();
            ApiResponse = new ApiResponse<bool>()
            {
                HasError = false,
                Result = true,
                Code = 200,
                pkId = pk,
                Message = "Record Added Successfully"
            };

            ListOfApiResponse.Add(ApiResponse);

            return ListOfApiResponse;

        }
        [NonAction]
        public List<ApiResponse<string>> CreateRespWithReturnCollection(int? pk)
        {
            ApiResponse<string> ApiResponse = new ApiResponse<string>();
            List<ApiResponse<string>> ListOfApiResponse = new List<ApiResponse<string>>();
            ApiResponse = new ApiResponse<string>()
            {
                HasError = false,
                Result = "",
                Code = 200,
                pkId = pk,
                Message = "Record Added Successfully"
            };

            ListOfApiResponse.Add(ApiResponse);

            return ListOfApiResponse;

        }
        [NonAction]
        public List<ApiResponse<bool>> CreateRespWithreturnCollectionForU(int? pk)
        {
            ApiResponse<bool> ApiResponse = new ApiResponse<bool>();
            List<ApiResponse<bool>> ListOfApiResponse = new List<ApiResponse<bool>>();
            ApiResponse = new ApiResponse<bool>()
            {
                HasError = false,
                Result = true,
                Code = 200,
                pkId = pk,
                Message = "Record Updated Successfully"
            };

            ListOfApiResponse.Add(ApiResponse);

            return ListOfApiResponse;

        }

        [NonAction]
        public List<ApiResponse<bool>> CreateRespWithreturnCollectionForD(int? pk)
        {
            ApiResponse<bool> ApiResponse = new ApiResponse<bool>();
            List<ApiResponse<bool>> ListOfApiResponse = new List<ApiResponse<bool>>();
            ApiResponse = new ApiResponse<bool>()
            {
                HasError = false,
                Result = true,
                Code = 200,
                pkId = pk,
                Message = "Record Deleted Successfully"
            };

            ListOfApiResponse.Add(ApiResponse);

            return ListOfApiResponse;

        }
    }
}
