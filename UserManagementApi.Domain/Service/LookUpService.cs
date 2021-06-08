using Denver.Infra.Common;
using Denver.Infra.Constants;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Text;
using System.Threading.Tasks;
using UserManagementApi.Domain.ViewModels;
using UserManagementApi.Domain.Helper;
using UserManagementApi.Domain.Repositories;

namespace UserManagementApi.Domain.Service
{
    public partial class UserManagementService
    {
        public async Task<IEnumerable<LookUpResponseApiModel>> GetLookUpTypeList(string LookUpType)
        {
            return await _lookUpRepository.GetLookUpTypeList(LookUpType);
        }  
        public async Task<IEnumerable<StateListResponseApiModel>> GetStatesList()
        {
            return await _lookUpRepository.GetStatesList();
        }

        public async Task<IEnumerable<StatusListResponseApiModel>> GetStatusList(string statusCode)
        {
            return await _lookUpRepository.GetStatusList(statusCode);
        }

        public async Task<IEnumerable<ElectionCycleDDResponseApiModel>> GetElectionCycleByType(string typeCode)
        {
            return await _lookUpRepository.GetElectionCycleByType(typeCode);
        }

        public async Task<IEnumerable<GetElectionDate>> GetElectionDates()
        {
            return await _lookUpRepository.GetElectionDates(); 
        }
    }
}
