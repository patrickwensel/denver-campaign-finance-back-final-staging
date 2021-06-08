using Denver.DataAccess;
using Denver.Infra.Common;
using Microsoft.Extensions.Configuration;
using System;
using System.Collections.Generic;
using System.Data;
using System.Text;
using System.Threading.Tasks;
using UserManagementApi.Domain.Helper;
using UserManagementApi.Domain.Repositories;
using UserManagementApi.Domain.ViewModels;

namespace UserManagementApi.DataCore.Repositories
{
    public class ContactRepository : IContactRepository
    {
        private DBManager dataContext;
        public ContactRepository(IConfiguration configuration)
        {
            dataContext = new DBManager(configuration.GetConnectionString("AppDB"), DataProvider.PostgreSQL);
        }
        public async Task<int> CreateContact(ContactUserAccountApiModel createContact, string SecretKey, string Password, string Salt)
        {
           
            IDbDataParameter[] param = new[]
               {
                  dataContext.CreateParameter(DbType.String,"_contacttype", 100, "I", ParameterDirection.Input),
                  dataContext.CreateParameter(DbType.String,"_firstname", 150, createContact.ContactDetail.FirstName,  ParameterDirection.Input),
                  dataContext.CreateParameter(DbType.String,"_lastname", 150, createContact.ContactDetail.LastName, ParameterDirection.Input),
                  dataContext.CreateParameter(DbType.String,"_address1", 200, createContact.ContactDetail.Address1, ParameterDirection.Input),
                  dataContext.CreateParameter(DbType.String,"_address2", 200, createContact.ContactDetail.Address2, ParameterDirection.Input),
                  dataContext.CreateParameter(DbType.String,"_city", 200, createContact.ContactDetail.City, ParameterDirection.Input),
                  dataContext.CreateParameter(DbType.String,"_state", 200, createContact.ContactDetail.StateCode, ParameterDirection.Input),
                  dataContext.CreateParameter(DbType.String,"_zip", 200, createContact.ContactDetail.Zip, ParameterDirection.Input),
                  dataContext.CreateParameter(DbType.String,"_phone", 200, createContact.ContactDetail.Phone, ParameterDirection.Input),
                  dataContext.CreateParameter(DbType.String,"_email", 200, createContact.ContactDetail.Email, ParameterDirection.Input),
                };
            int contactid = dataContext.Insert(@"select * from save_contact(:_contacttype, :_firstname, :_lastname, :_address1, :_address2, :_city, :_state, :_zip, :_phone, :_email)", commandType: CommandType.Text, param);

            IDbDataParameter[] paramu = new[]
               {
                  dataContext.CreateParameter(DbType.String,"_password", 100, Password, ParameterDirection.Input),
                  dataContext.CreateParameter(DbType.Int32,"_contactid", 150, contactid,  ParameterDirection.Input),
                  dataContext.CreateParameter(DbType.String,"_status", 150, "ACT",  ParameterDirection.Input),
                  dataContext.CreateParameter(DbType.String,"_salt", 100, Salt, ParameterDirection.Input),
                };
            int userID = dataContext.Insert(@"select * from save_useraccount(:_password, :_contactid, :_status, :_salt)", commandType: CommandType.Text, paramu);

            return contactid;
        }

        public async Task<IEnumerable<NamesByTxnTypeResponseApiModel>> GetLendersPayersContributerContacts(int entityId, string entityType, string searchName)
        {
            IDbDataParameter[] param = new[]
            {
                dataContext.CreateParameter(DbType.Int32, "entityId", 100, entityId, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.String, "entityType", 100, entityType, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.String, "searchname", 300, searchName, ParameterDirection.InputOutput),
            };

            var dtNames = dataContext.GetDataTable("select * from get_contactbyname(:entityId, :entityType, :searchname)", commandType: CommandType.Text, param);

            IEnumerable<NamesByTxnTypeResponseApiModel> respose = ConvertDataTableToList.DataTableToList<NamesByTxnTypeResponseApiModel>(dtNames);

            return respose;
        }

        public async Task<TxnContactDetailResponseApiModel> GetContactDetailsById(int contactId)
        {
            IDbDataParameter[] param = new[]
            {
                dataContext.CreateParameter(DbType.Int32, "_contactId", 100, contactId, ParameterDirection.InputOutput),
            };
            var dtNames = dataContext.GetDataTable(@"select * from get_contactdetailsbyid(:_contactId)", commandType: CommandType.Text, param);

            TxnContactDetailResponseApiModel respose = ConvertDataTableToList.ToClass<TxnContactDetailResponseApiModel>(dtNames);

            return respose;
        }

    }
}
