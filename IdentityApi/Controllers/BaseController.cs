using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Claims;
using System.Threading.Tasks;
using IdentityApi.Domain.Service;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;

namespace IdentityApi.Controllers
{
    

    [Route("api/[controller]")]
    [ApiController]
    public class BaseController : ControllerBase
    {
        protected readonly ILogger _logger;
        protected readonly IService _iService;

        public BaseController(IService service, ILogger<BaseController> logger)
        {
            _iService = service;
            _logger = logger;
        }

        protected string GetLoggedInUser()
        {
            string loggedInUserId = string.Empty;
            var identity = HttpContext.User.Identity as ClaimsIdentity;
            if (identity != null)
            {
                IEnumerable<Claim> claims = identity.Claims;
                loggedInUserId = claims.Single(x => x.Type == "Id").Value;
            }
            return loggedInUserId;
        }
    }
}
