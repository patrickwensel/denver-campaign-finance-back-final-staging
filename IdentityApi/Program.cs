using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore;
using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;
using Serilog;

namespace IdentityApi
{
    public class Program
    {
        public static void Main(string[] args)
        {
            var host = CreateHostBuilder(args).Build();//.Run();
            var logger = host.Services.GetRequiredService<ILogger<Program>>();
            logger.LogInformation("Application Starting Up... {Time}", LogLevel.Information, DateTime.UtcNow);
            host.Run();
        }

        public static IHostBuilder CreateHostBuilder(string[] args)
        {            
            return Host.CreateDefaultBuilder(args)
                        .ConfigureWebHostDefaults(webBuilder =>
                        {
                            webBuilder.UseStartup<Startup>();
                        })
                        .ConfigureLogging(builder =>
                        {
                            builder.AddApplicationInsights("36aa9526-7a53-4357-aebb-fecd08a62474");

                            // Optional: Apply filters to control what logs are sent to Application Insights.
                            // The following configures LogLevel Information or above to be sent to
                            // Application Insights for all categories.
                            builder.AddFilter<Microsoft.Extensions.Logging.ApplicationInsights.ApplicationInsightsLoggerProvider>
                                             ("", LogLevel.Information);

                            // Adding the filter below to ensure logs of all severity from Startup.cs
                            // is sent to ApplicationInsights.
                            builder.AddFilter<Microsoft.Extensions.Logging.ApplicationInsights.ApplicationInsightsLoggerProvider>
                                             (typeof(Startup).FullName, LogLevel.Trace);
                        });
        }
    }
}
