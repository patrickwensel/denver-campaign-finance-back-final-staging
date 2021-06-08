using IdentityApi.Domain.Repositories;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Text;
using System.Threading;
using System.Threading.Tasks;

namespace IdentityApi.Domain.Service
{
    public partial class Service: IService
    {      
        private readonly IIdentityRepository _identityRepository;
        private readonly ILogger _logger;
        public Service()
        {

        }

        public Service(ILogger<Service> logger, IIdentityRepository identityRepository)
        {
            _logger = logger;
            _identityRepository = identityRepository;          
        }        
    }
}
