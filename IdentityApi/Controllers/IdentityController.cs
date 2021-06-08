using Azure.Messaging.ServiceBus;
using Denver.EventBus.EventPayLoads;
using Denver.EventBus.Services;
using Denver.Infra;
using Denver.Infra.Constants;
using Denver.Infra.Exceptions;
using IdentityApi.Configurations;
using IdentityApi.Domain.ApiModels;
using IdentityApi.Domain.Service;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using Microsoft.Identity.Client;
using System;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;

namespace IdentityApi.Controllers
{
    public class IdentityController : BaseController
    {
        private readonly JwtTokenSettings _jwtSettings;
        private readonly AppSettings _appSettings;
        private readonly PublicClientApplicationOptions _app;
        private readonly ServiceBusTopicSender _serviceBusTopicSender;
        public IdentityController(IService iService, ILogger<IdentityController> logger, JwtTokenSettings jwtSettings, AppSettings appSettings, PublicClientApplicationOptions app, ServiceBusTopicSender serviceBusTopicSender) : base(iService, logger)
        {
            _jwtSettings = jwtSettings;
            _appSettings = appSettings;
            _app = app;
            _serviceBusTopicSender = serviceBusTopicSender;
        }  
    }
}
