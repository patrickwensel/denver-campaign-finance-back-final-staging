using Denver.DataAccess;
using Microsoft.Extensions.Configuration;
using Npgsql;
using System;
using System.Collections.Generic;
using System.Data;
using System.Net.Mail;
using System.Text;
using System.Threading.Tasks;
using UserManagementApi.Domain.ViewModels;
using UserManagementApi.Domain.Entities;
using UserManagementApi.Domain.Helper;
using UserManagementApi.Domain.Repositories;

namespace UserManagementApi.DataCore.Repositories
{
    public class LookUpRepository : ILookUpRepository
    {
        private DBManager dataContext;
        public LookUpRepository(IConfiguration configuration)
        {
            dataContext = new DBManager(configuration.GetConnectionString("AppDB"), DataProvider.PostgreSQL);
        }

        public async Task<IEnumerable<LookUpResponseApiModel>> GetLookUpTypeList(string LookUpType)
        {
            IDbDataParameter[] param = new[]{
                  dataContext.CreateParameter(DbType.String,"lookuptype", 100, LookUpType, ParameterDirection.InputOutput)
            };
            var dtLookUps = dataContext.GetDataTable(@"SELECT * FROM get_lookups(:lookuptype)", commandType: CommandType.Text, param);

            IEnumerable<LookUpResponseApiModel> resposeDt = ConvertDataTableToList.DataTableToList<LookUpResponseApiModel>(dtLookUps);
            return resposeDt;
        }
     
        public async Task<IEnumerable<StateListResponseApiModel>> GetStatesList()
        {
            var dtStates = dataContext.GetDataTable(@"SELECT * FROM get_statelist()", commandType: CommandType.Text);

            IEnumerable<StateListResponseApiModel> resposeDt = ConvertDataTableToList.DataTableToList<StateListResponseApiModel>(dtStates);
            return resposeDt;
        }
        public async Task<IEnumerable<StatusListResponseApiModel>> GetStatusList(string statusCode)
        {
            IDbDataParameter[] param = new[]{
                dataContext.CreateParameter(DbType.String,"sType", 100, statusCode, ParameterDirection.InputOutput)
            };
            var dtStatus = dataContext.GetDataTable(@"SELECT * FROM public.get_status(:sType)", commandType: CommandType.Text, param);

            IEnumerable<StatusListResponseApiModel> resposeDt = ConvertDataTableToList.DataTableToList<StatusListResponseApiModel>(dtStatus);
            return resposeDt;
        }

        public async Task<IEnumerable<ElectionCycleDDResponseApiModel>> GetElectionCycleByType(string typeCode)
        {
            IDbDataParameter[] param = new[]{
                dataContext.CreateParameter(DbType.String,"typeCode", 100, typeCode, ParameterDirection.InputOutput)
            };
            var dtStatus = dataContext.GetDataTable(@"SELECT * FROM public.get_electioncyclebytype(:typeCode)", commandType: CommandType.Text, param);

            IEnumerable<ElectionCycleDDResponseApiModel> resposeDt = ConvertDataTableToList.DataTableToList<ElectionCycleDDResponseApiModel>(dtStatus);
            return resposeDt;
        }

        public async Task<IEnumerable<GetElectionDate>> GetElectionDates()
        {
           
            var dtStatus = dataContext.GetDataTable(@"SELECT * FROM public.get_electioncycledates()", commandType: CommandType.Text, null);
            IEnumerable<GetElectionDate> resposeDt = ConvertDataTableToList.DataTableToList<GetElectionDate>(dtStatus);
            return resposeDt;
        }
    }
}
