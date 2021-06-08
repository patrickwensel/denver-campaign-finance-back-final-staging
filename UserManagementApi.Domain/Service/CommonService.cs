using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Text;
using System.Threading.Tasks;
using UserManagementApi.Domain.ApiModels;
using UserManagementApi.Domain.ApiModels.LookUp;
using UserManagementApi.Domain.ApiModels.State;
using UserManagementApi.Domain.Entities;
using UserManagementApi.Domain.Repositories;

namespace UserManagementApi.Domain.Service
{
    public partial class UserManagementService
    {
     
        public async Task<IEnumerable<LookUpListResponseApiModel>> GetLookUps(string LookUpType)
        {
            return await _commonRepository.GetLookUps(LookUpType);
        }

        public async Task<IEnumerable<StatesListResponseApiModel>> GetStateList()
        {
            return await _commonRepository.GetStateList();
        }

        public async Task<IEnumerable<StatusResponseApiModel>> GetStatus(StatusRequestApiModel statusRequest)
        {
            return await _commonRepository.GetStatus(statusRequest);
        }
    }
}
