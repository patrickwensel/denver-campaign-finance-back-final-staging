using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.EntityFrameworkCore;

namespace UserManagementApi.Configurations
{
    public static class ConnectionConfigurations
    {
        public static IServiceCollection AddConnectionProvider(this IServiceCollection services,
            IConfiguration configuration)
        {
            //var connection = configuration.GetConnectionString("SQLConnection");
            //services.AddDbContextPool<DataContext>(options => options.UseSqlServer(connection));
            return services;
        }
    }
}
