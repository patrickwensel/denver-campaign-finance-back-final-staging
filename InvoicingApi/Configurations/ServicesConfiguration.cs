using Microsoft.Extensions.DependencyInjection;
using Denver.Infra.Constants;
using Denver.Infra.Configuration;

namespace InvoicingApi.Configurations
{
    public static class ServicesConfiguration
    {
        public static IServiceCollection ConfigureRepositories(this IServiceCollection services)
        {
            //services.AddScoped<IUserManagementRepository, UserManagementRepository>();
            //services.AddScoped<ICommitteeRepository, CommitteeRepository>();
            //services.AddScoped<ICommonRepository, CommonRepository>();
            //services.AddScoped<ILobbyistRepository, LobbyistRepository>();
            //services.AddScoped<ISystemManagementRepository, SystemManagementRepository>();
            return services;
        }

        public static IServiceCollection ConfigureServices(this IServiceCollection services, Microsoft.Extensions.Configuration.IConfiguration config)
        {           
            //services.AddScoped<IUserManagementService, UserManagementService>();
            return services;
        }

        public static IServiceCollection ConfigureIntegrtaionServices(this IServiceCollection services)
        {
            //services.AddSingleton<IServiceBusConsumer, ServiceBusConsumer>();
            //services.AddSingleton<IServiceBusTopicSubscription, ServiceBusTopicSubscription>();
            //services.AddSingleton<IProcessData, ProcessData>();
            return services;
        }

        public static IServiceCollection AddSwagger(this IServiceCollection services)
        {

            //services.AddSwaggerGen(s =>
            //{
            //    s.SwaggerDoc("v1", new OpenApiInfo
            //    {
            //        Title = "API",
            //        Description = "API"
            //    });
            //    //s.AddSecurityDefinition("Bearer", new OpenApiSecurityScheme
            //    //{
            //    //    Name = "Authorization",
            //    //    Type = SecuritySchemeType.ApiKey,
            //    //    Scheme = "Bearer",
            //    //    BearerFormat = "JWT",
            //    //    In = ParameterLocation.Header,
            //    //    Description = "JWT Authorization header using the bearer token"
            //    //});
            //    //s.AddSecurityRequirement(new OpenApiSecurityRequirement
            //    //{
            //    //    {
            //    //        new OpenApiSecurityScheme
            //    //        {
            //    //            Reference = new OpenApiReference
            //    //            {
            //    //                Type = ReferenceType.SecurityScheme,
            //    //                Id = "Bearer"
            //    //            }
            //    //        },
            //    //        new string[] {}
            //    //    }
            //    //});
            //});
            return services;
        }
        public static IServiceCollection AddCORS(this IServiceCollection services)
        {           
            services.AddCors(options =>
            {
                options.AddPolicy(Constants.CorsPolicyName,
                    builder => builder.AllowAnyOrigin()
                        .AllowAnyMethod()
                        .AllowAnyHeader()
                        );
            });

            return services;
        }
    }
}
