using Denver.EventBus;
using Denver.EventBus.EventPayLoads;
using Microsoft.Extensions.Configuration;
using System;
using System.Threading.Tasks;

namespace UserManagementApi
{
    public class ProcessData : IProcessData
    {
        private IConfiguration _configuration;

        public ProcessData(IConfiguration configuration)
        {
            _configuration = configuration;
        }
        public async Task Process(UserRegisteredPayLoad myPayload)
        {
            int i = 0;
            Console.WriteLine("Payload Received");
            
        }
    }
}
