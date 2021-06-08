using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using IdentityApi.Configurations;
using IdentityApi.Middleware;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;
using Serilog;

namespace IdentityApi
{
    public class Startup
    {
        //private readonly Microsoft.Extensions.Logging.ILogger _logger;
        public Startup(IConfiguration configuration)
        {
            Configuration = configuration;
            //_logger = logger;
        }

        public IConfiguration Configuration { get; }

        // This method gets called by the runtime. Use this method to add services to the container.
        public void ConfigureServices(IServiceCollection services)
        {
            //_logger.LogInformation("ConfigureServices.");

            services.AddControllers();
            services.AddControllersWithViews();
            services.ConfigureRepositories();
            services.ConfigureServices(Configuration);
            services.ConfigureEventBus();
            services.AddConnectionProvider(Configuration);
            services.AddAppSettings(Configuration);
            services.AddCORS();
            services.AddSwagger();
        }

        // This method gets called by the runtime. Use this method to configure the HTTP request pipeline.
        public void Configure(IApplicationBuilder app, IWebHostEnvironment env, AppSettings appSettings)
        {
            if (env.IsDevelopment())
            {
                //_logger.LogInformation("Configuring for Development environment");
                app.UseDeveloperExceptionPage();
            }
            else
            {
                //_logger.LogInformation("Configuring for Production environment");
            }

            app.UseSwagger();
            app.UseSwaggerUI(s => s.SwaggerEndpoint(appSettings.StartUpSettings.SwaggerUrl, "API"));

            app.UseHttpsRedirection();

            app.UseRouting();

            app.UseAuthentication();

            app.UseAuthorization();

            app.UseStaticFiles();

            app.UseMiddleware<ExceptionMiddleware>();

            //app.FormatResponse();

            //app.UseSerilogRequestLogging();

            app.UseCors("CorsPolicy");

            app.UseEndpoints(endpoints =>
            {
                endpoints.MapControllers();
                endpoints.MapControllerRoute("default", "{controller=Home}/{action=Index}/{id?}");
            });
        }
    }
}
