using Denver.Infra.Common;
using System;
using System.Collections.Generic;
using System.Text;
using System.Threading.Tasks;
using UserManagementApi.Domain.ViewModels;

namespace UserManagementApi.Domain.Service
{
    public partial class UserManagementService
    {
        public async Task<int> CreateContact(ContactUserAccountApiModel createContact, string SecretKey)
        {
            Cryptograhy crpt = new Cryptograhy();

            EncryptResultModel objEncry = crpt.EncryptText(createContact.UserAccountDetails.Password, SecretKey);
            var password = Convert.ToBase64String(objEncry.Password);
            var salt = Convert.ToBase64String(objEncry.Salt);
            return await _contactRepository.CreateContact(createContact, SecretKey, password, salt);
        }
        public async Task<IEnumerable<NamesByTxnTypeResponseApiModel>> GetLendersPayersContributerContacts(int entityId, string entityType, string searchName)
        {
            return await _contactRepository.GetLendersPayersContributerContacts(entityId, entityType, searchName);
        }

        public async Task<TxnContactDetailResponseApiModel> GetContactDetailsById(int contactId)
        {
            return await _contactRepository.GetContactDetailsById(contactId);
        }
    }
}
