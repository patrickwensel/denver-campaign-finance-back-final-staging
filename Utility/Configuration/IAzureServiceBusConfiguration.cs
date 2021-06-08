using System;
using System.Collections.Generic;
using System.Text;

namespace Denver.Infra.Configuration
{
    public interface IAzureServiceBusConfiguration
    {
        string ConnectionString { get; set; }
        string SubscriptionClientName { get; set; }
    }
}
