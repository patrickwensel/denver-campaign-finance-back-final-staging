using System;
using System.Collections.Generic;
using System.Text;
using System.Threading.Tasks;
using UserManagementApi.Domain.ViewModels;

namespace UserManagementApi.Domain.Repositories
{
    public interface IContactRepository
    {
        Task<int> CreateContact(ContactUserAccountApiModel createContact, string SecretKey, string Password, string Salt);
        Task<IEnumerable<NamesByTxnTypeResponseApiModel>> GetLendersPayersContributerContacts(int entityId, string entityType, string searchName);
        Task<TxnContactDetailResponseApiModel> GetContactDetailsById(int contactId);
    }
  
}
