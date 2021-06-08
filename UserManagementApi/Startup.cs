using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using UserManagementApi.Configurations;
using UserManagementApi.Middleware;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;
using Serilog;
using Denver.Infra.Constants;
using Denver.EventBus;
using Denver.EventBus.Services;

namespace UserManagementApi
{
    public class Startup
    {
        public Startup(IConfiguration configuration)
        {
            Configuration = configuration;
        }

        public IConfiguration Configuration { get; }

        // This method gets called by the runtime. Use this method to add services to the container.
        public void ConfigureServices(IServiceCollection services)
        {
            services.AddControllers();
            services.AddControllersWithViews();
            services.ConfigureRepositories();           
            services.ConfigureServices(Configuration);
            services.AddAuthentication(Configuration);
            services.ConfigureIntegrtaionServices();
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
                app.UseDeveloperExceptionPage();
            }

            app.UseSwagger();
            app.UseSwaggerUI(s => s.SwaggerEndpoint(appSettings.StartUpSettings.SwaggerUrl, "API"));

            app.UseHttpsRedirection();

            app.UseRouting();

            app.UseAuthentication();

            app.UseAuthorization();

            app.UseStaticFiles();

            app.UseMiddleware<ExceptionMiddleware>();            

            app.UseCors(Constants.CorsPolicyName);

            app.UseEndpoints(endpoints =>
            {
                endpoints.MapControllers();
                endpoints.MapControllerRoute("default", "{controller=UserManagementHome}/{action=Index}/{id?}");
            });

            var busSubscription = app.ApplicationServices.GetService<IServiceBusTopicSubscription>();
            busSubscription.PrepareFiltersAndHandleMessages().GetAwaiter().GetResult();
        }
    }
}
