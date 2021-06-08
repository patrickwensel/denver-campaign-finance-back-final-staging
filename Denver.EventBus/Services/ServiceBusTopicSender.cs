using Denver.EventBus.EventPayLoads;
using Microsoft.Azure.ServiceBus;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Logging;
using Newtonsoft.Json;
using System;
using System.Text;
using System.Threading.Tasks;

namespace Denver.EventBus.Services
{
    public class ServiceBusTopicSender
    {
        private readonly TopicClient _topicClient;
        private readonly IConfiguration _configuration;
        private const string TOPIC_PATH = "registrationtopic";
        private readonly ILogger _logger;

        public ServiceBusTopicSender(IConfiguration configuration, 
            ILogger<ServiceBusTopicSender> logger)
        {
            _configuration = configuration;
            _logger = logger;
            _topicClient = new TopicClient(
                _configuration.GetConnectionString("ServiceBusConnectionString"),
                TOPIC_PATH
            );
        }
        
        public async Task SendMessage(UserRegisteredPayLoad payload)
        {
            string data = JsonConvert.SerializeObject(payload);
            Message message = new Message(Encoding.UTF8.GetBytes(data));
            message.UserProperties.Add("email", payload.Email);
            try
            {
                await _topicClient.SendAsync(message);
            }
            catch (Exception e)
            {
                _logger.LogError(e.Message);
            }
        }
    }
}
