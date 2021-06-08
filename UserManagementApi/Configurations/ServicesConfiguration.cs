using UserManagementApi.DataCore.Repositories;
using UserManagementApi.Domain.Repositories;
using UserManagementApi.Domain.Service;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.OpenApi.Models;
using Denver.Infra.Constants;
using Denver.Infra.Configuration;
using Denver.EventBus.Services;
using Denver.EventBus;
using Microsoft.Extensions.Configuration;
using Microsoft.IdentityModel.Tokens;
using System.Text;
using Denver.Infra;
using Microsoft.AspNetCore.Authentication.JwtBearer;

namespace UserManagementApi.Configurations
{
    public static class ServicesConfiguration
    {
        public static IServiceCollection ConfigureRepositories(this IServiceCollection services)
        {
            services.AddScoped<IUserManagementRepository, UserManagementRepository>();
            services.AddScoped<ICommitteeRepository, CommitteeRepository>();
            services.AddScoped<ICommonRepository, CommonRepository>();
            services.AddScoped<ILobbyistRepository, LobbyistRepository>();
            services.AddScoped<ISystemManagementRepository, SystemManagementRepository>();
            services.AddScoped<ILookUpRepository, LookUpRepository>();
            services.AddScoped<IContactRepository, ContactRepository>();
            services.AddScoped<ICalendarRepository, CalendarRepository>();
            services.AddScoped<IPaymentsRepository, PaymentsRepository>();
            services.AddScoped<ITransactionRepository, TransactionRepository>();
            return services;
        }

        public static IServiceCollection ConfigureServices(this IServiceCollection services, Microsoft.Extensions.Configuration.IConfiguration config)
        {           
            services.AddScoped<IUserManagementService, UserManagementService>();
            return services;
        }

        public static IServiceCollection ConfigureIntegrtaionServices(this IServiceCollection services)
        {
            //services.AddSingleton<IServiceBusConsumer, ServiceBusConsumer>();
            services.AddSingleton<IServiceBusTopicSubscription, ServiceBusTopicSubscription>();
            services.AddSingleton<IProcessData, ProcessData>();
            return services;
        }

        public static IServiceCollection AddSwagger(this IServiceCollection services)
        {

            services.AddSwaggerGen(s =>
            {
                s.SwaggerDoc("v1", new OpenApiInfo
                {
                    Title = "Registration_Identity API ",
                    Description = "EndPoints for User Registrations and Authentication"
                });
                s.AddSecurityDefinition("Bearer", new OpenApiSecurityScheme
                {
                    Name = "Authorization",
                    Type = SecuritySchemeType.ApiKey,
                    Scheme = "Bearer",
                    BearerFormat = "JWT",
                    In = ParameterLocation.Header,
                    Description = "JWT Authorization header using the bearer token"
                });
                s.AddSecurityRequirement(new OpenApiSecurityRequirement
                {
                    {
                        new OpenApiSecurityScheme
                        {
                            Reference = new OpenApiReference
                            {
                                Type = ReferenceType.SecurityScheme,
                                Id = "Bearer"
                            }
                        },
                        new string[] {}
                    }
                });
            });
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

        public static IServiceCollection AddAuthentication(this IServiceCollection services, IConfiguration configuration)
        {
            var jwtSettings = new JwtTokenSettings();
            configuration.Bind(nameof(jwtSettings), jwtSettings);
            services.AddSingleton(jwtSettings);

            var tokenValidationParameters = new TokenValidationParameters
            {
                ValidateIssuerSigningKey = true,
                IssuerSigningKey = new SymmetricSecurityKey(Encoding.ASCII.GetBytes(jwtSettings.Secret)),
                ValidateIssuer = false,
                ValidateAudience = false,
                RequireExpirationTime = false,
                ValidateLifetime = true,
            };
            services.AddSingleton(tokenValidationParameters);
            services.AddAuthentication(x =>
            {
                x.DefaultAuthenticateScheme = JwtBearerDefaults.AuthenticationScheme;
                x.DefaultScheme = JwtBearerDefaults.AuthenticationScheme;
                x.DefaultChallengeScheme = JwtBearerDefaults.AuthenticationScheme;
            }).AddJwtBearer(x =>
            {
                x.SaveToken = true;

                x.TokenValidationParameters = tokenValidationParameters;
            });
            services.AddAuthorization();
            return services;
        }
    }
}
