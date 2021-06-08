using System;
using System.Collections.Generic;
using System.Text;
using System.Threading.Tasks;
using UserManagementApi.Domain.ViewModels;

namespace UserManagementApi.Domain.Repositories
{
    public interface ILookUpRepository
    {
        Task<IEnumerable<LookUpResponseApiModel>> GetLookUpTypeList(string LookUpType);
        Task<IEnumerable<StateListResponseApiModel>> GetStatesList();
        Task<IEnumerable<StatusListResponseApiModel>> GetStatusList(string statusCode);
        Task<IEnumerable<ElectionCycleDDResponseApiModel>> GetElectionCycleByType(string typeCode);
        Task<IEnumerable<GetElectionDate>> GetElectionDates(); 
    }
}
