using Denver.DataAccess;
using Denver.Infra.Common;
using Microsoft.Azure.Amqp.Framing;
using Microsoft.Extensions.Configuration;
using System;
using System.Collections.Generic;
using System.Data;
using System.Text;
using System.Threading.Tasks;
using UserManagementApi.Domain.ApiModels;
using UserManagementApi.Domain.Helper;
using UserManagementApi.Domain.Repositories;
using UserManagementApi.Domain.ViewModels;

namespace UserManagementApi.DataCore.Repositories
{
    public class LobbyistRepository : ILobbyistRepository
    {

        private DataTableToList tableConverter;
        private DBManager dataContext;
        public LobbyistRepository(IConfiguration configuration)
        {
            dataContext = new DBManager(configuration.GetConnectionString("AppDB"), DataProvider.PostgreSQL);
            tableConverter = new DataTableToList();
        }

        public async Task<int> CreateLobbyistEmployee(LobbyistOldApiModel lobbyistEmployee)
        {
            IDbDataParameter[] param = new[]
               {
                  dataContext.CreateParameter(DbType.String,"firstname", 100, lobbyistEmployee.FirstName, ParameterDirection.InputOutput),
                  dataContext.CreateParameter(DbType.String,"lastname", 100, lobbyistEmployee.LastName,  ParameterDirection.InputOutput),
                  dataContext.CreateParameter(DbType.String,"email", 500, lobbyistEmployee.Email, ParameterDirection.Input),
                  dataContext.CreateParameter(DbType.String,"phone", 500, lobbyistEmployee.ImageURL, ParameterDirection.Input),
                };
            int res = dataContext.Insert(@"select * from save_lobbyistemployee(:firstname, :lastname, :email, :phone)", commandType: CommandType.Text, param);
            return res;
        }


        public async Task<int> UpdateLobbyistEmployee(LobbyistOldApiModel lobbyistEmployee)
        {
            IDbDataParameter[] param = new[]
               {
                  dataContext.CreateParameter(DbType.Int32,"id", 100, lobbyistEmployee.LobbyistID, ParameterDirection.InputOutput),
                  dataContext.CreateParameter(DbType.String,"_firstname", 100, lobbyistEmployee.FirstName, ParameterDirection.InputOutput),
                  dataContext.CreateParameter(DbType.String,"_lastname", 100, lobbyistEmployee.LastName,  ParameterDirection.InputOutput),
                  dataContext.CreateParameter(DbType.String,"_email", 500, lobbyistEmployee.Email, ParameterDirection.Input),
                  dataContext.CreateParameter(DbType.String,"_phone", 500, lobbyistEmployee.ImageURL, ParameterDirection.Input),
                };
            int res = dataContext.Update(@"select * from update_lobbyistemployee(:id, :_firstname, :_lastname, :_email, :_phone)", commandType: CommandType.Text, param);
            return res;
        }


        public async Task<int> DeleteLobbyistEmployee(int LobbyistEmployeeID)
        {
            IDbDataParameter[] param = new[]
                {
                  dataContext.CreateParameter(DbType.Int32,"id", 100, LobbyistEmployeeID, ParameterDirection.InputOutput),
                };
            int res = dataContext.Delete(@"select * from delete_lobbyistemployee(:id)", commandType: CommandType.Text, param);
            return res;
        }

        #region New
        public async Task<List<EmployeeList>> GetEmployees(int lobbyistId)
        {
            IDbDataParameter[] param = new[]
            {
                dataContext.CreateParameter(DbType.Int32, "entityId", 100, lobbyistId, ParameterDirection.InputOutput),
            };

            DataTable employees = dataContext.GetDataTable(@"select * from get_employees(:entityId)", commandType: CommandType.Text, param);

            List<EmployeeList> employeeList = tableConverter.ConvertToList<EmployeeList>(employees);
            return employeeList;
        }

        public async Task<int> UpdateLobbyistSignature(LobbyistSignatureApiModel lobbyistSignature)
        {
            IDbDataParameter[] param = new[]
               {
                  dataContext.CreateParameter(DbType.Int32,"_lobbyistid", 100, lobbyistSignature.LobbyistId, ParameterDirection.InputOutput),
                  dataContext.CreateParameter(DbType.String,"_signfirstname", 150, lobbyistSignature.SignFirstName, ParameterDirection.InputOutput),
                  dataContext.CreateParameter(DbType.String,"_signlastname", 150, lobbyistSignature.SignLastName,  ParameterDirection.InputOutput),
                  dataContext.CreateParameter(DbType.String,"_signemail", 250, lobbyistSignature.SignEmail, ParameterDirection.Input),
                  dataContext.CreateParameter(DbType.String,"_signimageurl", 100000, lobbyistSignature.SignImageURL, ParameterDirection.Input),
                             };
            int res = dataContext.Update(@"select * from update_lobbyistsignature(:_lobbyistid, :_signfirstname, :_signlastname, :_signemail, :_signimageurl)", commandType: CommandType.Text, param);
            return res;
        }

        public async Task<int> SaveEmployee(LobbyistEmployeeRequestApiModel lobbyistEmployee)
        {
            int response = 0;
            var lobbyistId = lobbyistEmployee.LobbyistEntityId;

            Employee emp = lobbyistEmployee.Employee;

            IDbDataParameter[] param = new[]
            {
                    dataContext.CreateParameter(DbType.Int32, "lobbyistentityid", 100, lobbyistId, ParameterDirection.InputOutput),
                    dataContext.CreateParameter(DbType.Int32, "contactid", 100, emp.ContactId, ParameterDirection.InputOutput),
                    dataContext.CreateParameter(DbType.String, "fname", 100, emp.FirstName, ParameterDirection.InputOutput),
                    dataContext.CreateParameter(DbType.String, "mname", 100, emp.MiddleName, ParameterDirection.InputOutput),
                    dataContext.CreateParameter(DbType.String, "lname", 100, emp.LastName, ParameterDirection.InputOutput),
                    dataContext.CreateParameter(DbType.String, "phoneno", 100, emp.PhoneNo, ParameterDirection.InputOutput),
                    dataContext.CreateParameter(DbType.String, "emailid", 100, emp.EmailId, ParameterDirection.InputOutput),
                    dataContext.CreateParameter(DbType.String, "userid", 100, "", ParameterDirection.InputOutput),
            };

            StringBuilder sbQuery = new StringBuilder();
            sbQuery.Clear();
            sbQuery.AppendLine(@"select * from save_employees(");
            sbQuery.AppendLine(":lobbyistentityid, ");
            sbQuery.AppendLine(":contactid, ");
            sbQuery.AppendLine(":fname, ");
            sbQuery.AppendLine(":mname, ");
            sbQuery.AppendLine(":lname, ");
            sbQuery.AppendLine(":phoneno, ");
            sbQuery.AppendLine(":emailid, ");
            sbQuery.AppendLine(":userid)");

            response = dataContext.Insert(sbQuery.ToString(), commandType: CommandType.Text, param);
            return response;
        }

        public async Task<int> DeleteEmployee(int contactId)
        {
            int response = 0;

            IDbDataParameter[] param = new[]
            {
                dataContext.CreateParameter(DbType.Int32, "contactId", 100, contactId, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.String, "userId", 100, "", ParameterDirection.InputOutput),
            };

            StringBuilder sbQuery = new StringBuilder();
            sbQuery.Clear();
            sbQuery.AppendLine(@"select * from delete_employee(");
            sbQuery.AppendLine(":contactid, ");
            sbQuery.AppendLine(":userid)");

            response = dataContext.Delete(sbQuery.ToString(), commandType: CommandType.Text, param);
            return response;
        }

        public async Task<int> SaveSubcontractor(LobbyistSubcontractorRequestApiModel lobbyistSubcontractor)
        {
            int response = 0;
            var lobbyistId = lobbyistSubcontractor.LobbyistEntityId;

            Subcontractor subcontractor = lobbyistSubcontractor.Subcontractor;

            IDbDataParameter[] param = new[]
            {
                dataContext.CreateParameter(DbType.Int32, "lobbyistentityid", 100, lobbyistId, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.Int32, "contactid", 100, subcontractor.ContactId, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.String, "typeid", 100, subcontractor.TypeId, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.String, "fname", 100, subcontractor.FirstName, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.String, "mname", 100, subcontractor.MiddleName, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.String, "lname", 100, subcontractor.LastName, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.String, "phoneno", 100, subcontractor.PhoneNo, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.String, "emailid", 100, subcontractor.EmailId, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.String, "userid", 100, "", ParameterDirection.InputOutput),
            };

            StringBuilder sbQuery = new StringBuilder();
            sbQuery.Clear();
            sbQuery.AppendLine(@"select * from save_subcontractors(");
            sbQuery.AppendLine(":lobbyistentityid, ");
            sbQuery.AppendLine(":contactid, ");
            sbQuery.AppendLine(":typeid, ");
            sbQuery.AppendLine(":fname, ");
            sbQuery.AppendLine(":mname, ");
            sbQuery.AppendLine(":lname, ");
            sbQuery.AppendLine(":phoneno, ");
            sbQuery.AppendLine(":emailid, ");
            sbQuery.AppendLine(":userid)");

            response = dataContext.Insert(sbQuery.ToString(), commandType: CommandType.Text, param);
            return response;
        }

        public async Task<int> DeleteSubcontractor(int contactId)
        {
            int response = 0;

            IDbDataParameter[] param = new[]
            {
                dataContext.CreateParameter(DbType.Int32, "contactId", 100, contactId, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.String, "userId", 100, "", ParameterDirection.InputOutput),
            };

            StringBuilder sbQuery = new StringBuilder();
            sbQuery.Clear();
            sbQuery.AppendLine(@"select * from delete_subcontractor(");
            sbQuery.AppendLine(":contactid, ");
            sbQuery.AppendLine(":userid)");

            response = dataContext.Delete(sbQuery.ToString(), commandType: CommandType.Text, param);
            return response;
        }

        public async Task<int> SaveClient(LobbyistClientApiModel lobbyistClient)
        {
            int response = 0;
            var lobbyistId = lobbyistClient.LobbyistEntityId;

            Client client = lobbyistClient.Client;

            IDbDataParameter[] param = new[]
            {
                dataContext.CreateParameter(DbType.Int32, "lobbyistentityid", 100, lobbyistId, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.Int32, "contactid", 100, client.ContactId, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.Int32, "lobbyistclientid", 100, client.LobbyistClientId, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.String, "comname", 100, client.CompanyName, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.Int32, "employeeid", 100, client.EmployeeId, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.String, "nbusiness", 100, client.NatureOfBusiness, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.String, "lmatters", 100, client.LegislativeMatters, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.String, "addr1", 100, client.Address1, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.String, "addr2", 100, client.Address2, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.String, "cityname", 100, client.City, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.String, "statecode", 100, client.StateCode, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.String, "zipcode", 100, client.ZipCode, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.String, "userid", 100, "", ParameterDirection.InputOutput),
            };

            StringBuilder sbQuery = new StringBuilder();
            sbQuery.Clear();
            sbQuery.AppendLine(@"select * from save_clients(");
            sbQuery.AppendLine(":lobbyistentityid, ");
            sbQuery.AppendLine(":contactid, ");
            sbQuery.AppendLine(":lobbyistclientid, ");
            sbQuery.AppendLine(":comname, ");
            sbQuery.AppendLine(":employeeid, ");
            sbQuery.AppendLine(":nbusiness, ");
            sbQuery.AppendLine(":lmatters, ");
            sbQuery.AppendLine(":addr1, ");
            sbQuery.AppendLine(":addr2, ");
            sbQuery.AppendLine(":cityname, ");
            sbQuery.AppendLine(":statecode, ");
            sbQuery.AppendLine(":zipcode, ");
            sbQuery.AppendLine(":userid)");

            response = dataContext.Insert(sbQuery.ToString(), commandType: CommandType.Text, param);
            return response;
        }

        public async Task<int> DeleteClient(int contactId)
        {
            int response = 0;

            IDbDataParameter[] param = new[]
            {
                dataContext.CreateParameter(DbType.Int32, "contactId", 100, contactId, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.String, "userId", 100, "", ParameterDirection.InputOutput),
            };

            StringBuilder sbQuery = new StringBuilder();
            sbQuery.Clear();
            sbQuery.AppendLine(@"select * from delete_client(");
            sbQuery.AppendLine(":contactid, ");
            sbQuery.AppendLine(":userid)");

            response = dataContext.Delete(sbQuery.ToString(), commandType: CommandType.Text, param);
            return response;
        }

        public async Task<int> SaveRelationship(LobbyistRelationshipRequestApiModel lobbyistRelationship)
        {
            int response = 0;
            var lobbyistId = lobbyistRelationship.LobbyistEntityId;

            Relationship rel = lobbyistRelationship.Relationship;

            IDbDataParameter[] param = new[]
            {
                dataContext.CreateParameter(DbType.Int32, "lobbyistentityid", 100, lobbyistId, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.Int32, "contactid", 100, rel.ContactId, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.Int32, "lobbyistrelationshipid", 100, rel.RelationshipId, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.Int32, "employeeid", 100, rel.EmployeeId, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.String, "offname", 100, rel.OfficeName, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.String, "offtitle", 100, rel.OfficeTitle, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.String, "relationshipDesc", 100, rel.RelationshipDesc, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.String, "entityname", 100, rel.EntityName, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.String, "userid", 100, "", ParameterDirection.InputOutput),
            };

            StringBuilder sbQuery = new StringBuilder();
            sbQuery.Clear();
            sbQuery.AppendLine(@"select * from save_relationships(");
            sbQuery.AppendLine(":lobbyistentityid, ");
            sbQuery.AppendLine(":contactid, ");
            sbQuery.AppendLine(":lobbyistrelationshipid, ");
            sbQuery.AppendLine(":employeeid, ");
            sbQuery.AppendLine(":offname, ");
            sbQuery.AppendLine(":offtitle, ");
            sbQuery.AppendLine(":relationshipDesc, ");
            sbQuery.AppendLine(":entityname, ");
            sbQuery.AppendLine(":userid)");

            response = dataContext.Insert(sbQuery.ToString(), commandType: CommandType.Text, param);
            return response;
        }
        public async Task<int> DeleteRelationship(int contactId)
        {
            int response = 0;

            IDbDataParameter[] param = new[]
            {
                dataContext.CreateParameter(DbType.Int32, "contactId", 100, contactId, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.String, "userId", 100, "", ParameterDirection.InputOutput),
            };

            StringBuilder sbQuery = new StringBuilder();
            sbQuery.Clear();
            sbQuery.AppendLine(@"select * from delete_relationship(");
            sbQuery.AppendLine(":contactid, ");
            sbQuery.AppendLine(":userid)");

            response = dataContext.Delete(sbQuery.ToString(), commandType: CommandType.Text, param);
            return response;
        }
        #endregion New
        public async Task<int> SaveLobbyist(LobbyistApiModel saveLobbyist)
        {
            IDbDataParameter[] param = new[]
               {
                  dataContext.CreateParameter(DbType.String,"_contacttype", 100, saveLobbyist.LobbyistType, ParameterDirection.InputOutput),
                  dataContext.CreateParameter(DbType.String,"_orgname", 500, saveLobbyist.LobbyistDetail.OrganizationName, ParameterDirection.InputOutput),
                  dataContext.CreateParameter(DbType.String,"_firstname", 500, saveLobbyist.LobbyistDetail.FirstName,  ParameterDirection.InputOutput),
                  dataContext.CreateParameter(DbType.String,"_lastname", 500, saveLobbyist.LobbyistDetail.LastName, ParameterDirection.Input),
                  dataContext.CreateParameter(DbType.String,"_address1", 500, saveLobbyist.LobbyistDetail.Address1, ParameterDirection.Input),
                  dataContext.CreateParameter(DbType.String,"_address2", 500, saveLobbyist.LobbyistDetail.Address2, ParameterDirection.Input),
                  dataContext.CreateParameter(DbType.String,"_city", 500, saveLobbyist.LobbyistDetail.City, ParameterDirection.Input),
                  dataContext.CreateParameter(DbType.String,"_statecode", 500, saveLobbyist.LobbyistDetail.StateCode, ParameterDirection.Input),
                  dataContext.CreateParameter(DbType.String,"_zip", 500, saveLobbyist.LobbyistDetail.Zip, ParameterDirection.Input),
                  dataContext.CreateParameter(DbType.String,"_phone", 500, saveLobbyist.LobbyistDetail.Phone, ParameterDirection.Input),
                  dataContext.CreateParameter(DbType.String,"_email", 500, saveLobbyist.LobbyistDetail.Email, ParameterDirection.Input),
                  dataContext.CreateParameter(DbType.Int32,"_lobbyistid", 500, saveLobbyist.LobbyistID, ParameterDirection.Input),
                };
            int ContactID = dataContext.Insert(@"select * from save_lobbyistcontact(:_contacttype, :_orgname, :_firstname, :_lastname, :_address1, :_address2, :_city, :_statecode, :_zip, :_phone, :_email, :_lobbyistid)", commandType: CommandType.Text, param);


            IDbDataParameter[] paramL = new[]
             {
                  dataContext.CreateParameter(DbType.String,"_year", 100, saveLobbyist.Year, ParameterDirection.InputOutput),
                  dataContext.CreateParameter(DbType.String,"_type", 100, saveLobbyist.LobbyistType, ParameterDirection.InputOutput),
                  dataContext.CreateParameter(DbType.Int32,"_primarycontactid", 500, saveLobbyist.ContactID,  ParameterDirection.InputOutput),
                  dataContext.CreateParameter(DbType.Int32,"_filercontactid", 500, ContactID, ParameterDirection.Input),
                  dataContext.CreateParameter(DbType.Int32,"_lobbyistid", 500, saveLobbyist.LobbyistID, ParameterDirection.Input),
                };
            int LobbyistID = dataContext.Insert(@"select * from save_lobbyist(:_year, :_type, :_primarycontactid, :_filercontactid, :_lobbyistid)", commandType: CommandType.Text, paramL);
            if (saveLobbyist.LobbyistID == 0)
            {
                IDbDataParameter[] paramf = new[]
               {
                  dataContext.CreateParameter(DbType.String,"_entitytype", 1000, "L", ParameterDirection.Input),
                  dataContext.CreateParameter(DbType.Int32,"_entityid", 150, LobbyistID,  ParameterDirection.Input),
                  dataContext.CreateParameter(DbType.Int32,"_categoryid", 150, 3,  ParameterDirection.Input),
                  dataContext.CreateParameter(DbType.String,"_filerstatus", 150, "A",  ParameterDirection.Input),
                };
                int filerID = dataContext.Insert(@"select * from save_filer(:_entitytype, :_entityid, :_categoryid, :_filerstatus)", commandType: CommandType.Text, paramf);

                IDbDataParameter[] paramcrmm = new[]
    {
                  dataContext.CreateParameter(DbType.Int32,"_contactid", 200, saveLobbyist.ContactID,  ParameterDirection.Input),
                  dataContext.CreateParameter(DbType.Int32,"_filerid", 150, filerID,  ParameterDirection.Input),
                };
                int contactrolemappingidd = dataContext.Update(@"select * from save_contactrolemappinglobby( :_contactid, :_filerid)", commandType: CommandType.Text, paramcrmm);
            }
            return LobbyistID;
        }
        public async Task<int> SaveLobbyistAffiliation(LobbyistAffiliationApiModel lobbyistAffiliation)
        {
            var currentDate = DateTime.UtcNow.Date;
            var expiryDate = DateTime.UtcNow.Date.AddHours(48);
            IDbDataParameter[] param = new[]
{
                  dataContext.CreateParameter(DbType.Int32,"_emailtypeid", 100, 3, ParameterDirection.Input),
                  dataContext.CreateParameter(DbType.String,"_txnrefid", 200, "",  ParameterDirection.Input),
                  dataContext.CreateParameter(DbType.String,"_receiverid", 1500, "",  ParameterDirection.Input),
                  dataContext.CreateParameter(DbType.String,"_subject", 1500, "User Access Permission",  ParameterDirection.Input),
                  dataContext.CreateParameter(DbType.String, "_message", 10000, "To be Decided",  ParameterDirection.Input),
                  dataContext.CreateParameter(DbType.Date, "_sendon", 100, currentDate,  ParameterDirection.Input),
                  dataContext.CreateParameter(DbType.Boolean, "_isuseractionrequired", 100, true,  ParameterDirection.Input),
                  dataContext.CreateParameter(DbType.Date, "_expirydatetime", 100, expiryDate,  ParameterDirection.Input),
                };
            int emailMessageId = dataContext.Update(@"select * from save_emailmessages(:_emailtypeid, :_txnrefid, :_receiverid, :_subject, :_message, :_sendon, :_isuseractionrequired, :_expirydatetime)", commandType: CommandType.Text, param);
            foreach (LobbyistAffiliationDetailApiModel lobbyistid in lobbyistAffiliation.LobbyistIds)
            {
                IDbDataParameter[] paramu = new[]
                {
                  dataContext.CreateParameter(DbType.String,"_requesttype", 100, "R", ParameterDirection.Input),
                  dataContext.CreateParameter(DbType.String,"_useremail", 150, "",  ParameterDirection.Input),
                  dataContext.CreateParameter(DbType.Int32,"_usercontactid", 150, lobbyistAffiliation.ContactID,  ParameterDirection.Input),
                  dataContext.CreateParameter(DbType.Int32, "_invitercontactid", 100, 0,  ParameterDirection.Input),
                  dataContext.CreateParameter(DbType.Int32, "_emailmessageid", 100, emailMessageId,  ParameterDirection.Input),
                  dataContext.CreateParameter(DbType.String, "_userjoinnote", 1000, lobbyistAffiliation.Notes,  ParameterDirection.Input),
                  dataContext.CreateParameter(DbType.Int32, "_lobbyistid", 100, lobbyistid.LobbyistID,  ParameterDirection.Input),
                };
                int userJoinRequestId = dataContext.Update(@"select * from save_userjoinrequestlob(:_requesttype, :_useremail, :_usercontactid, :_invitercontactid, :_emailmessageid, :_userjoinnote, :_lobbyistid)", commandType: CommandType.Text, paramu);
            }

            return emailMessageId;
        }

        public async Task<List<LobbyistEntitiesResponseApiModel>> GetLobbyistEntities(int lobbyistId, string roleType)
        {
            IDbDataParameter[] param = new[]
            {
                dataContext.CreateParameter(DbType.Int32, "lobbyistentityid", 100, lobbyistId, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.String, "roletype", 100, roleType, ParameterDirection.InputOutput),
            };

            DataTable dtlobbyisEntities = dataContext.GetDataTable(@"select * from get_lobbyistentities(:lobbyistentityid, :roletype)", commandType: CommandType.Text, param);

            List<LobbyistEntitiesResponseApiModel> lobbyisEntities = tableConverter.ConvertToList<LobbyistEntitiesResponseApiModel>(dtlobbyisEntities);
            return lobbyisEntities;
        }

        public async Task<List<GetLobbyistEmployee>> GetLobbyist(int lobbyistId)
        {
            IDbDataParameter[] param = new[]
              {
                  dataContext.CreateParameter(DbType.Int32,"_lobbyistid", 100, lobbyistId, ParameterDirection.InputOutput),
               };
            DataTable ResultDT = dataContext.GetDataTable(@"select * from getlobbyistemployee(:_lobbyistid)", commandType: CommandType.Text, param);

            List<GetLobbyistEmployee> employeelist = tableConverter.ConvertToList<GetLobbyistEmployee>(ResultDT);
            return employeelist;
        }

        public async Task<List<LobbyistEntitiesResponseApiModel>> GetLobbyistEntitiesbyName(int lobbyistId, string searchName, string roleType)
        {
            IDbDataParameter[] param = new[]
            {
                dataContext.CreateParameter(DbType.Int32, "lobbyistentityid", 100, lobbyistId, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.String, "lobbyistsearchname", 100, searchName, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.String, "roletype", 100, roleType, ParameterDirection.InputOutput),
            };

            DataTable dtlobbyisEntities = dataContext.GetDataTable(@"select * from get_lobbyistentitiesbyname(:lobbyistentityid, :lobbyistsearchname, :roletype)", commandType: CommandType.Text, param);

            List<LobbyistEntitiesResponseApiModel> lobbyisEntities = tableConverter.ConvertToList<LobbyistEntitiesResponseApiModel>(dtlobbyisEntities);
            return lobbyisEntities;
        }
        public async Task<LobbyistSignatureDetailApiModel> GetLobbyistSignature(int lobbyistId)
        {
            IDbDataParameter[] param = new[]
            {
                dataContext.CreateParameter(DbType.Int32,"lobbyistId", 100, lobbyistId, ParameterDirection.InputOutput),
            };
            DataTable dtSignature = dataContext.GetDataTable(@"select * from get_signaturedetail(:lobbyistId)", commandType: CommandType.Text, param);
            LobbyistSignatureDetailApiModel response = ConvertDataTableToList.ToClass<LobbyistSignatureDetailApiModel>(dtSignature);
            return response;
        }
        public async Task<LobbyistContactInfoApiModel> GetLobbyistContactInformation(int lobbyistId)
        {
            IDbDataParameter[] param = new[]
            {
                dataContext.CreateParameter(DbType.Int32,"lobbyistId", 100, lobbyistId, ParameterDirection.InputOutput),
            };
            DataTable dtContactInfo = dataContext.GetDataTable(@"select * from get_lobyyistcontactinfo(:lobbyistId)", commandType: CommandType.Text, param);
            LobbyistContactInfoApiModel response = ConvertDataTableToList.ToClass<LobbyistContactInfoApiModel>(dtContactInfo);
            return response;
        }


    }
}
