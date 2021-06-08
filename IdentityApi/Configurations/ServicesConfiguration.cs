using Denver.EventBus.Services;
using IdentityApi.DataCore.Repositories;
using IdentityApi.Domain.Repositories;
using IdentityApi.Domain.Service;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.OpenApi.Models;

namespace IdentityApi.Configurations
{
    public static class ServicesConfiguration
    {
        public static IServiceCollection ConfigureRepositories(this IServiceCollection services)
        {
            services.AddScoped<IIdentityRepository, IdentityRepository>();
            return services;
        }

        public static IServiceCollection ConfigureServices(this IServiceCollection services, Microsoft.Extensions.Configuration.IConfiguration config)
        {
            services.AddScoped<ServiceBusTopicSender>();
            services.AddScoped<IService, Service>();
            return services;
        }

        public static IServiceCollection ConfigureEventBus(this IServiceCollection services)
        {
           
            return services;
        }

        

        public static IServiceCollection AddSwagger(this IServiceCollection services)
        {

            services.AddSwaggerGen(s =>
            {
                s.SwaggerDoc("v1", new OpenApiInfo
                {
                    Title = "API",
                    Description = "API"
                });
                //s.AddSecurityDefinition("Bearer", new OpenApiSecurityScheme
                //{
                //    Name = "Authorization",
                //    Type = SecuritySchemeType.ApiKey,
                //    Scheme = "Bearer",
                //    BearerFormat = "JWT",
                //    In = ParameterLocation.Header,
                //    Description = "JWT Authorization header using the bearer token"
                //});
                //s.AddSecurityRequirement(new OpenApiSecurityRequirement
                //{
                //    {
                //        new OpenApiSecurityScheme
                //        {
                //            Reference = new OpenApiReference
                //            {
                //                Type = ReferenceType.SecurityScheme,
                //                Id = "Bearer"
                //            }
                //        },
                //        new string[] {}
                //    }
                //});
            });
            return services;
        }

        public static IServiceCollection AddCORS(this IServiceCollection services)
        {
            services.AddCors(options =>
            {
                options.AddPolicy("CorsPolicy",
                    builder => builder.AllowAnyOrigin()
                        .AllowAnyMethod()
                        .AllowAnyHeader()
                        );
            });

            return services;
        }
    }
}
