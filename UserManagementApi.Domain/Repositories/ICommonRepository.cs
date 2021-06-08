using System;
using System.Collections.Generic;
using System.Text;
using System.Threading.Tasks;
using UserManagementApi.Domain.ApiModels;
using UserManagementApi.Domain.ApiModels.LookUp;
using UserManagementApi.Domain.ApiModels.State;

namespace UserManagementApi.Domain.Repositories
{
    public interface ICommonRepository
    {
        Task<IEnumerable<LookUpListResponseApiModel>> GetLookUps(string LookUpType);
        Task<IEnumerable<StatesListResponseApiModel>> GetStateList();
        Task<bool> SendMail(EmailReq emailInfo);
        Task<IEnumerable<StatusResponseApiModel>> GetStatus(StatusRequestApiModel statusRequest);

    }
}
