
using Denver.DataAccess;
using IdentityApi.Domain.ApiModels;
using IdentityApi.Domain.Entities;
using IdentityApi.Domain.Repositories;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;

namespace IdentityApi.DataCore.Repositories
{
    public class IdentityRepository : IIdentityRepository
    {
        private DBManager dataContext;
        public IdentityRepository(IConfiguration configuration)
        {
            dataContext = new DBManager(configuration.GetConnectionString("AppDB"), DataProvider.PostgreSQL);
        }

        public async Task<User> CheckLoginAsync(LoginApiModel NewLogin, CancellationToken ct = new CancellationToken())
        {
            IDbDataParameter[] param = new[]
                {
                  dataContext.CreateParameter(DbType.Int32,"@AutoID", 50, ParameterDirection.ReturnValue),
                  dataContext.CreateParameter(DbType.String, "@OperatorName", 50, ParameterDirection.InputOutput),
                  dataContext.CreateParameter(DbType.String,"@Date", 50, ParameterDirection.InputOutput),
                  dataContext.CreateParameter(DbType.String,"@StartDate", 50, ParameterDirection.Input),
                  dataContext.CreateParameter(DbType.String, "@EndDate", 50, ParameterDirection.Input),
                };
            var dt = dataContext.GetDataTable("sql", commandType: CommandType.StoredProcedure, param);
            return null;
        }

        public void Dispose()
        {
          
        }
    }
}
