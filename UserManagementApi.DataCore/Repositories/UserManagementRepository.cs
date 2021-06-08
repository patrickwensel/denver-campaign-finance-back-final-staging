using Denver.DataAccess;
using System;
using System.Collections.Generic;
using System.Data;
using System.Text;
using System.Threading.Tasks;
using UserManagementApi.Domain.ApiModels;
using UserManagementApi.Domain.Repositories;
using Microsoft.Extensions.Configuration;
using UserManagementApi.Domain.Helper;
using Denver.Infra.Exceptions;
using UserManagementApi.Domain.Entities;
using UserManagementApi.Domain.ApiModels.Committee;
using Denver.Infra.Common;
using Denver.Infra.Constants;
using Denver.Infra.Utility;
using Denver.Infra;
using UserManagementApi.Domain.ViewModels;
using System.Linq;

namespace UserManagementApi.DataCore.Repositories
{
    public partial class UserManagementRepository : IUserManagementRepository
    {
        private DataTableToList tableConverter;
        private DBManager dataContext;
        public UserManagementRepository(IConfiguration configuration)
        {
            dataContext = new DBManager(configuration.GetConnectionString("AppDB"), DataProvider.PostgreSQL);
            tableConverter = new DataTableToList();
        }

        public async Task<int> CreateContactInfo(ContactInformationApiModel contactinfo)
        {
            IDbDataParameter[] param = new[]
               {
                  dataContext.CreateParameter(DbType.String,"firstname", 100, contactinfo.FirstName, ParameterDirection.InputOutput),
                  dataContext.CreateParameter(DbType.String,"lastname", 100, contactinfo.LastName,  ParameterDirection.InputOutput),
                  dataContext.CreateParameter(DbType.String,"mailingaddress1", 500, contactinfo.MailingAddress1, ParameterDirection.Input),
                  dataContext.CreateParameter(DbType.String,"mailingaddress2", 500, contactinfo.MailingAddress2, ParameterDirection.Input),
                  dataContext.CreateParameter(DbType.String,"city", 500, contactinfo.City, ParameterDirection.Input),
                  dataContext.CreateParameter(DbType.String,"state", 500, contactinfo.State, ParameterDirection.Input),
                  dataContext.CreateParameter(DbType.String,"zipcode", 500, contactinfo.Zipcode, ParameterDirection.Input),
                  dataContext.CreateParameter(DbType.String,"phone", 500, contactinfo.Phone, ParameterDirection.Input),
                };
            int res = dataContext.Insert(@"select * from save_contactinformation(:firstname, :lastname, :mailingaddress1, :mailingaddress2, :city, :state, :zipcode, :phone)", commandType: CommandType.Text, param);
            return res;

        }

        public async Task<bool> CreateLobbyist(LobbyistOldApiModel lobbyistEmployee)
        {
            int userId = 0;
            int lobbyistId = 0;
            UseRoleRefApiModel userRoleRefApiModel;
            IDbTransaction transactionScope = null;
            using (var connection = dataContext.GetDatabaseConnection())
            {
                connection.Open();
                transactionScope = connection.BeginTransaction();

                StringBuilder sbSQL = new StringBuilder();
                try
                {

                    IDbDataParameter[] param = new[]
               {
                  dataContext.CreateParameter(DbType.Int32,"year", 100, lobbyistEmployee.Year, ParameterDirection.InputOutput),
                  dataContext.CreateParameter(DbType.String,"type", 100, lobbyistEmployee.Type, ParameterDirection.InputOutput),
                  dataContext.CreateParameter(DbType.String,"firstname", 100, lobbyistEmployee.FirstName, ParameterDirection.InputOutput),
                  dataContext.CreateParameter(DbType.String,"lastname", 100, lobbyistEmployee.LastName,  ParameterDirection.InputOutput),
                  dataContext.CreateParameter(DbType.String,"organisationname", 500, lobbyistEmployee.OrganisationName, ParameterDirection.Input),
                  dataContext.CreateParameter(DbType.String,"address1", 500, lobbyistEmployee.Address1, ParameterDirection.Input),
                  dataContext.CreateParameter(DbType.String,"address2", 500, lobbyistEmployee.Address2, ParameterDirection.Input),
                  dataContext.CreateParameter(DbType.String,"city", 500, lobbyistEmployee.City, ParameterDirection.Input),
                  dataContext.CreateParameter(DbType.String,"statecode", 3, lobbyistEmployee.StateCode, ParameterDirection.Input),
                  dataContext.CreateParameter(DbType.String,"zipcode", 20, lobbyistEmployee.ZipCode, ParameterDirection.Input),
                  dataContext.CreateParameter(DbType.String,"phone", 30, lobbyistEmployee.Phone, ParameterDirection.Input),
                  dataContext.CreateParameter(DbType.String,"email", 500, lobbyistEmployee.Email, ParameterDirection.Input),
                  dataContext.CreateParameter(DbType.String,"imageurl", 500, lobbyistEmployee.ImageURL, ParameterDirection.Input),
                   dataContext.CreateParameter(DbType.Int32,"_userid", 100, lobbyistEmployee.UserID, ParameterDirection.InputOutput),
                };

                    lobbyistId = dataContext.Insert(@"select * from save_lobbyist(:year, :type, :firstname, :lastname, :organisationname,:address1,:address2,:city,:statecode,:zipcode,:phone, :email, :imageurl, :_userid)", commandType: CommandType.Text, param);
                    foreach (LobbyistInfo Employee in lobbyistEmployee.EmployeeInfo)
                    {
                        IDbDataParameter[] userAccountParams = new[]
                        {
                    dataContext.CreateParameter(DbType.String, "userName", 10, Employee.UserName, ParameterDirection.InputOutput),
                    dataContext.CreateParameter(DbType.String, "userTitle", 10, Employee.Title, ParameterDirection.InputOutput),
                    dataContext.CreateParameter(DbType.String, "firstName", 200, Employee.FirstName, ParameterDirection.InputOutput),
                    dataContext.CreateParameter(DbType.String, "lastName", 10, Employee.LastName, ParameterDirection.InputOutput),
                    dataContext.CreateParameter(DbType.String, "address1", 150, Employee.Address1, ParameterDirection.InputOutput),
                    dataContext.CreateParameter(DbType.String, "address2", 100 , Employee.Address2, ParameterDirection.InputOutput),
                    dataContext.CreateParameter(DbType.String, "city", 10, Employee.City, ParameterDirection.InputOutput),
                    dataContext.CreateParameter(DbType.String, "stateCode", 20, Employee.StateCode, ParameterDirection.InputOutput),
                    dataContext.CreateParameter(DbType.String, "countryCode", 50, Employee.CountryCode, ParameterDirection.InputOutput),
                    dataContext.CreateParameter(DbType.String, "zip", 1000, Employee.Zipcode, ParameterDirection.InputOutput),
                    dataContext.CreateParameter(DbType.String, "email", 200, Employee.Email, ParameterDirection.InputOutput),
                    dataContext.CreateParameter(DbType.String, "phone", 150, Employee.Phone, ParameterDirection.InputOutput),
                    dataContext.CreateParameter(DbType.String, "userGroup", 150, "N", ParameterDirection.InputOutput),
                    dataContext.CreateParameter(DbType.Date, "notifyEmailSentOn", 100, Employee.NotifyEmailSentOn, ParameterDirection.InputOutput),
                    dataContext.CreateParameter(DbType.Date, "notifyAcceptedOn", 100, Employee.NotifyAcceptedOn, ParameterDirection.InputOutput),
                    dataContext.CreateParameter(DbType.Boolean, "isNotifyAccepted", 10, Employee.IsNotifyAccepted, ParameterDirection.InputOutput),
                    dataContext.CreateParameter(DbType.String, "userPassword", 200, Employee.UserPassword, ParameterDirection.InputOutput),
                    dataContext.CreateParameter(DbType.String, "salt", 15, Employee.Salt, ParameterDirection.InputOutput),
                    dataContext.CreateParameter(DbType.String, "organisationName", 200, Employee.OrganisationName, ParameterDirection.InputOutput),
                    dataContext.CreateParameter(DbType.String, "businessName", 200, Employee.BusinessName, ParameterDirection.InputOutput),
                    dataContext.CreateParameter(DbType.String, "occupation", 150, Employee.Occupation, ParameterDirection.InputOutput),
                    dataContext.CreateParameter(DbType.String, "voterId", 200, Employee.VoterId, ParameterDirection.InputOutput),
                    dataContext.CreateParameter(DbType.String, "remarks", 150, Employee.Remarks, ParameterDirection.InputOutput),
                    dataContext.CreateParameter(DbType.Int32, "tenantId", 100, Employee.TenantId, ParameterDirection.InputOutput)
                };

                        sbSQL = new StringBuilder();
                        sbSQL.Clear();
                        sbSQL.Append("SELECT * FROM save_usersaccountdetails(");
                        sbSQL.Append(":userName,");
                        sbSQL.Append(":userTitle,");
                        sbSQL.Append(":firstName,");
                        sbSQL.Append(":lastName,");
                        sbSQL.Append(":address1,");
                        sbSQL.Append(":address2,");
                        sbSQL.Append(":city,");
                        sbSQL.Append(":stateCode,");
                        sbSQL.Append(":countryCode,");
                        sbSQL.Append(":zip,");
                        sbSQL.Append(":email,");
                        sbSQL.Append(":phone,");
                        sbSQL.Append(":userGroup,");
                        sbSQL.Append(":notifyEmailSentOn,");
                        sbSQL.Append(":notifyAcceptedOn,");
                        sbSQL.Append(":isNotifyAccepted,");
                        sbSQL.Append(":userPassword,");
                        sbSQL.Append(":salt,");
                        sbSQL.Append(":organisationName,");
                        sbSQL.Append(":businessName,");
                        sbSQL.Append(":occupation,");
                        sbSQL.Append(":voterId,");
                        sbSQL.Append(":remarks,");
                        sbSQL.Append(":tenantId)");

                        userId = dataContext.Insert(sbSQL.ToString(), commandType: CommandType.Text, userAccountParams);

                        Employee.UserId = userId;

                        userRoleRefApiModel = new UseRoleRefApiModel();
                        userRoleRefApiModel.UserId = userId;
                        userRoleRefApiModel.RoleType = Constants.LOB_EMP;
                        userRoleRefApiModel.RoleId = 2;
                        userRoleRefApiModel.RefID = lobbyistId;
                        userRoleRefApiModel.RelationshipId = 0;


                        sbSQL = new StringBuilder();
                        sbSQL.Clear();
                        sbSQL.AppendLine("SELECT * FROM save_useroleref(");
                        sbSQL.Append(":userId,");
                        sbSQL.Append(":roleType,");
                        sbSQL.Append(":roleId,");
                        sbSQL.Append(":refId,");
                        sbSQL.Append(":relationshipId)");

                        IDbDataParameter[] useRoleRefParams = new[]
                        {
                    dataContext.CreateParameter(DbType.Int32, "userId", 10,  userRoleRefApiModel.UserId, ParameterDirection.InputOutput),
                    dataContext.CreateParameter(DbType.String, "roleType", 10, userRoleRefApiModel.RoleType, ParameterDirection.InputOutput),
                    dataContext.CreateParameter(DbType.Int32, "roleId", 10, userRoleRefApiModel.RoleId, ParameterDirection.InputOutput),
                    dataContext.CreateParameter(DbType.Int32, "refId", 10, userRoleRefApiModel.RefID, ParameterDirection.InputOutput),
                    dataContext.CreateParameter(DbType.Int32, "relationshipId", 10, userRoleRefApiModel.RelationshipId, ParameterDirection.InputOutput),
                };

                        int userRoleRefId = dataContext.Insert(sbSQL.ToString(), commandType: CommandType.Text, useRoleRefParams);
                    }

                    foreach (LobbyistInfo subCon in lobbyistEmployee.SubContractorInfo)
                    {


                        IDbDataParameter[] userAccountParams = new[]
                    {
                    dataContext.CreateParameter(DbType.String, "userName", 10, subCon.UserName, ParameterDirection.InputOutput),
                    dataContext.CreateParameter(DbType.String, "userTitle", 10, subCon.Title, ParameterDirection.InputOutput),
                    dataContext.CreateParameter(DbType.String, "firstName", 200, subCon.FirstName, ParameterDirection.InputOutput),
                    dataContext.CreateParameter(DbType.String, "lastName", 10, subCon.LastName, ParameterDirection.InputOutput),
                    dataContext.CreateParameter(DbType.String, "address1", 150, subCon.Address1, ParameterDirection.InputOutput),
                    dataContext.CreateParameter(DbType.String, "address2", 100 , subCon.Address2, ParameterDirection.InputOutput),
                    dataContext.CreateParameter(DbType.String, "city", 10, subCon.City, ParameterDirection.InputOutput),
                    dataContext.CreateParameter(DbType.String, "stateCode", 20, subCon.StateCode, ParameterDirection.InputOutput),
                    dataContext.CreateParameter(DbType.String, "countryCode", 50, subCon.CountryCode, ParameterDirection.InputOutput),
                    dataContext.CreateParameter(DbType.String, "zip", 1000, subCon.Zipcode, ParameterDirection.InputOutput),
                    dataContext.CreateParameter(DbType.String, "email", 200, subCon.Email, ParameterDirection.InputOutput),
                    dataContext.CreateParameter(DbType.String, "phone", 150, subCon.Phone, ParameterDirection.InputOutput),
                    dataContext.CreateParameter(DbType.String, "userGroup", 150, "N", ParameterDirection.InputOutput),
                    dataContext.CreateParameter(DbType.Date, "notifyEmailSentOn", 100, subCon.NotifyEmailSentOn, ParameterDirection.InputOutput),
                    dataContext.CreateParameter(DbType.Date, "notifyAcceptedOn", 100, subCon.NotifyAcceptedOn, ParameterDirection.InputOutput),
                    dataContext.CreateParameter(DbType.Boolean, "isNotifyAccepted", 10, subCon.IsNotifyAccepted, ParameterDirection.InputOutput),
                    dataContext.CreateParameter(DbType.String, "userPassword", 200, subCon.UserPassword, ParameterDirection.InputOutput),
                    dataContext.CreateParameter(DbType.String, "salt", 15, subCon.Salt, ParameterDirection.InputOutput),
                    dataContext.CreateParameter(DbType.String, "organisationName", 200, subCon.OrganisationName, ParameterDirection.InputOutput),
                    dataContext.CreateParameter(DbType.String, "businessName", 200, subCon.BusinessName, ParameterDirection.InputOutput),
                    dataContext.CreateParameter(DbType.String, "occupation", 150, subCon.Occupation, ParameterDirection.InputOutput),
                    dataContext.CreateParameter(DbType.String, "voterId", 200, subCon.VoterId, ParameterDirection.InputOutput),
                    dataContext.CreateParameter(DbType.String, "remarks", 150, subCon.Remarks, ParameterDirection.InputOutput),
                    dataContext.CreateParameter(DbType.Int32, "tenantId", 100, subCon.TenantId, ParameterDirection.InputOutput),
                    dataContext.CreateParameter(DbType.String, "typeuser", 100, subCon.TypeOfUser, ParameterDirection.InputOutput)
                };

                        sbSQL = new StringBuilder();
                        sbSQL.Clear();
                        sbSQL.Append("SELECT * FROM save_usersaccountdetails(");
                        sbSQL.Append(":userName,");
                        sbSQL.Append(":userTitle,");
                        sbSQL.Append(":firstName,");
                        sbSQL.Append(":lastName,");
                        sbSQL.Append(":address1,");
                        sbSQL.Append(":address2,");
                        sbSQL.Append(":city,");
                        sbSQL.Append(":stateCode,");
                        sbSQL.Append(":countryCode,");
                        sbSQL.Append(":zip,");
                        sbSQL.Append(":email,");
                        sbSQL.Append(":phone,");
                        sbSQL.Append(":userGroup,");
                        sbSQL.Append(":notifyEmailSentOn,");
                        sbSQL.Append(":notifyAcceptedOn,");
                        sbSQL.Append(":isNotifyAccepted,");
                        sbSQL.Append(":userPassword,");
                        sbSQL.Append(":salt,");
                        sbSQL.Append(":organisationName,");
                        sbSQL.Append(":businessName,");
                        sbSQL.Append(":occupation,");
                        sbSQL.Append(":voterId,");
                        sbSQL.Append(":remarks,");
                        sbSQL.Append(":tenantId,");
                        sbSQL.Append(":typeuser)");

                        userId = dataContext.Insert(sbSQL.ToString(), commandType: CommandType.Text, userAccountParams);

                        subCon.UserId = userId;

                        userRoleRefApiModel = new UseRoleRefApiModel();
                        userRoleRefApiModel.UserId = userId;
                        userRoleRefApiModel.RoleType = Constants.LOB_SUB;
                        userRoleRefApiModel.RoleId = 2;
                        userRoleRefApiModel.RefID = lobbyistId;
                        userRoleRefApiModel.RelationshipId = 0;


                        sbSQL = new StringBuilder();
                        sbSQL.Clear();
                        sbSQL.AppendLine("SELECT * FROM save_useroleref(");
                        sbSQL.Append(":userId,");
                        sbSQL.Append(":roleType,");
                        sbSQL.Append(":roleId,");
                        sbSQL.Append(":refId,");
                        sbSQL.Append(":relationshipId)");

                        IDbDataParameter[] useRoleRefParams = new[]
                        {
                    dataContext.CreateParameter(DbType.Int32, "userId", 10,  userRoleRefApiModel.UserId, ParameterDirection.InputOutput),
                    dataContext.CreateParameter(DbType.String, "roleType", 10, userRoleRefApiModel.RoleType, ParameterDirection.InputOutput),
                    dataContext.CreateParameter(DbType.Int32, "roleId", 10, userRoleRefApiModel.RoleId, ParameterDirection.InputOutput),
                    dataContext.CreateParameter(DbType.Int32, "refId", 10, userRoleRefApiModel.RefID, ParameterDirection.InputOutput),
                    dataContext.CreateParameter(DbType.Int32, "relationshipId", 10, userRoleRefApiModel.RelationshipId, ParameterDirection.InputOutput),
                };

                        int userRoleRefId = dataContext.Insert(sbSQL.ToString(), commandType: CommandType.Text, useRoleRefParams);
                    }
                    foreach (LobbyistInfo cltInfo in lobbyistEmployee.ClientInfo)
                    {
                        IDbDataParameter[] client = new[]
                    {
                    dataContext.CreateParameter(DbType.String, "companyname", 300, cltInfo.OrganisationName, ParameterDirection.InputOutput),
                    dataContext.CreateParameter(DbType.String, "natureofbusiness", 300, cltInfo.BusinessName, ParameterDirection.InputOutput),
                    dataContext.CreateParameter(DbType.String, "legislativematters", 300, cltInfo.Remarks, ParameterDirection.InputOutput),
                    dataContext.CreateParameter(DbType.String, "address1", 300, cltInfo.Address1, ParameterDirection.InputOutput),
                    dataContext.CreateParameter(DbType.String, "address2", 300 , cltInfo.Address2, ParameterDirection.InputOutput),
                    dataContext.CreateParameter(DbType.String, "city", 300, cltInfo.City, ParameterDirection.InputOutput),
                    dataContext.CreateParameter(DbType.String, "statecode", 2, cltInfo.StateCode, ParameterDirection.InputOutput),
                    dataContext.CreateParameter(DbType.String, "zip", 10, cltInfo.Zipcode, ParameterDirection.InputOutput)

                };

                        sbSQL = new StringBuilder();
                        sbSQL.Clear();
                        sbSQL.AppendLine("SELECT * FROM save_clientdetails(");
                        sbSQL.Append(":companyname,");
                        sbSQL.Append(":natureofbusiness,");
                        sbSQL.Append(":legislativematters,");
                        sbSQL.Append(":address1,");
                        sbSQL.Append(":address2,");
                        sbSQL.Append(":city,");
                        sbSQL.Append(":statecode,");
                        sbSQL.Append(":zip)");



                        userId = dataContext.Insert(sbSQL.ToString(), commandType: CommandType.Text, client);

                        IDbDataParameter[] userAccountParams = new[]
                    {
                    dataContext.CreateParameter(DbType.String, "userName", 10, cltInfo.UserName, ParameterDirection.InputOutput),
                    dataContext.CreateParameter(DbType.String, "userTitle", 10, cltInfo.Title, ParameterDirection.InputOutput),
                    dataContext.CreateParameter(DbType.String, "firstName", 200, cltInfo.FirstName, ParameterDirection.InputOutput),
                    dataContext.CreateParameter(DbType.String, "lastName", 10, cltInfo.LastName, ParameterDirection.InputOutput),
                    dataContext.CreateParameter(DbType.String, "address1", 150, cltInfo.Address1, ParameterDirection.InputOutput),
                    dataContext.CreateParameter(DbType.String, "address2", 100 , cltInfo.Address2, ParameterDirection.InputOutput),
                    dataContext.CreateParameter(DbType.String, "city", 10, cltInfo.City, ParameterDirection.InputOutput),
                    dataContext.CreateParameter(DbType.String, "stateCode", 20, cltInfo.StateCode, ParameterDirection.InputOutput),
                    dataContext.CreateParameter(DbType.String, "countryCode", 50, cltInfo.CountryCode, ParameterDirection.InputOutput),
                    dataContext.CreateParameter(DbType.String, "zip", 1000, cltInfo.Zipcode, ParameterDirection.InputOutput),
                    dataContext.CreateParameter(DbType.String, "email", 200, cltInfo.Email, ParameterDirection.InputOutput),
                    dataContext.CreateParameter(DbType.String, "phone", 150, cltInfo.Phone, ParameterDirection.InputOutput),
                    dataContext.CreateParameter(DbType.String, "userGroup", 150, "N", ParameterDirection.InputOutput),
                    dataContext.CreateParameter(DbType.Date, "notifyEmailSentOn", 100, cltInfo.NotifyEmailSentOn, ParameterDirection.InputOutput),
                    dataContext.CreateParameter(DbType.Date, "notifyAcceptedOn", 100, cltInfo.NotifyAcceptedOn, ParameterDirection.InputOutput),
                    dataContext.CreateParameter(DbType.Boolean, "isNotifyAccepted", 10, cltInfo.IsNotifyAccepted, ParameterDirection.InputOutput),
                    dataContext.CreateParameter(DbType.String, "userPassword", 200, cltInfo.UserPassword, ParameterDirection.InputOutput),
                    dataContext.CreateParameter(DbType.String, "salt", 15, cltInfo.Salt, ParameterDirection.InputOutput),
                    dataContext.CreateParameter(DbType.String, "organisationName", 200, cltInfo.OrganisationName, ParameterDirection.InputOutput),
                    dataContext.CreateParameter(DbType.String, "businessName", 200, cltInfo.BusinessName, ParameterDirection.InputOutput),
                    dataContext.CreateParameter(DbType.String, "occupation", 150, cltInfo.Occupation, ParameterDirection.InputOutput),
                    dataContext.CreateParameter(DbType.String, "voterId", 200, cltInfo.VoterId, ParameterDirection.InputOutput),
                    dataContext.CreateParameter(DbType.String, "remarks", 150, cltInfo.Remarks, ParameterDirection.InputOutput),
                    dataContext.CreateParameter(DbType.Int32, "tenantId", 100, cltInfo.TenantId, ParameterDirection.InputOutput),
                    dataContext.CreateParameter(DbType.String, "typeuser", 100, cltInfo.TypeOfUser, ParameterDirection.InputOutput)

                };

                        sbSQL = new StringBuilder();
                        sbSQL.Clear();
                        sbSQL.Append("SELECT * FROM save_usersaccountdetails(");
                        sbSQL.Append(":userName,");
                        sbSQL.Append(":userTitle,");
                        sbSQL.Append(":firstName,");
                        sbSQL.Append(":lastName,");
                        sbSQL.Append(":address1,");
                        sbSQL.Append(":address2,");
                        sbSQL.Append(":city,");
                        sbSQL.Append(":stateCode,");
                        sbSQL.Append(":countryCode,");
                        sbSQL.Append(":zip,");
                        sbSQL.Append(":email,");
                        sbSQL.Append(":phone,");
                        sbSQL.Append(":userGroup,");
                        sbSQL.Append(":notifyEmailSentOn,");
                        sbSQL.Append(":notifyAcceptedOn,");
                        sbSQL.Append(":isNotifyAccepted,");
                        sbSQL.Append(":userPassword,");
                        sbSQL.Append(":salt,");
                        sbSQL.Append(":organisationName,");
                        sbSQL.Append(":businessName,");
                        sbSQL.Append(":occupation,");
                        sbSQL.Append(":voterId,");
                        sbSQL.Append(":remarks,");
                        sbSQL.Append(":tenantId,");
                        sbSQL.Append(":typeuser)");

                        userId = dataContext.Insert(sbSQL.ToString(), commandType: CommandType.Text, userAccountParams);

                        cltInfo.UserId = userId;

                        userRoleRefApiModel = new UseRoleRefApiModel();
                        userRoleRefApiModel.UserId = userId;
                        userRoleRefApiModel.RoleType = Constants.LOB_CLI;
                        userRoleRefApiModel.RoleId = 2;
                        userRoleRefApiModel.RefID = lobbyistId;
                        userRoleRefApiModel.RelationshipId = 0;


                        sbSQL = new StringBuilder();
                        sbSQL.Clear();
                        sbSQL.AppendLine("SELECT * FROM save_useroleref(");
                        sbSQL.Append(":userId,");
                        sbSQL.Append(":roleType,");
                        sbSQL.Append(":roleId,");
                        sbSQL.Append(":refId,");
                        sbSQL.Append(":relationshipId)");

                        IDbDataParameter[] useRoleRefParams = new[]
                        {
                    dataContext.CreateParameter(DbType.Int32, "userId", 10,  userRoleRefApiModel.UserId, ParameterDirection.InputOutput),
                    dataContext.CreateParameter(DbType.String, "roleType", 10, userRoleRefApiModel.RoleType, ParameterDirection.InputOutput),
                    dataContext.CreateParameter(DbType.Int32, "roleId", 10, userRoleRefApiModel.RoleId, ParameterDirection.InputOutput),
                    dataContext.CreateParameter(DbType.Int32, "refId", 10, userRoleRefApiModel.RefID, ParameterDirection.InputOutput),
                    dataContext.CreateParameter(DbType.Int32, "relationshipId", 10, userRoleRefApiModel.RelationshipId, ParameterDirection.InputOutput),
                };

                        int userRoleRefId = dataContext.Insert(sbSQL.ToString(), commandType: CommandType.Text, useRoleRefParams);
                    }
                    foreach (LobbyistInfo relation in lobbyistEmployee.Relationship)
                    {


                        IDbDataParameter[] userAccountParams = new[]
                    {
                    dataContext.CreateParameter(DbType.String, "userName", 10, relation.UserName, ParameterDirection.InputOutput),
                    dataContext.CreateParameter(DbType.String, "userTitle", 10, relation.Title, ParameterDirection.InputOutput),
                    dataContext.CreateParameter(DbType.String, "firstName", 200, relation.FirstName, ParameterDirection.InputOutput),
                    dataContext.CreateParameter(DbType.String, "lastName", 10, relation.LastName, ParameterDirection.InputOutput),
                    dataContext.CreateParameter(DbType.String, "address1", 150, relation.Address1, ParameterDirection.InputOutput),
                    dataContext.CreateParameter(DbType.String, "address2", 100 , relation.Address2, ParameterDirection.InputOutput),
                    dataContext.CreateParameter(DbType.String, "city", 10, relation.City, ParameterDirection.InputOutput),
                    dataContext.CreateParameter(DbType.String, "stateCode", 20, relation.StateCode, ParameterDirection.InputOutput),
                    dataContext.CreateParameter(DbType.String, "countryCode", 50, relation.CountryCode, ParameterDirection.InputOutput),
                    dataContext.CreateParameter(DbType.String, "zip", 1000, relation.Zipcode, ParameterDirection.InputOutput),
                    dataContext.CreateParameter(DbType.String, "email", 200, relation.Email, ParameterDirection.InputOutput),
                    dataContext.CreateParameter(DbType.String, "phone", 150, relation.Phone, ParameterDirection.InputOutput),
                    dataContext.CreateParameter(DbType.String, "userGroup", 150, "N", ParameterDirection.InputOutput),
                    dataContext.CreateParameter(DbType.Date, "notifyEmailSentOn", 100, relation.NotifyEmailSentOn, ParameterDirection.InputOutput),
                    dataContext.CreateParameter(DbType.Date, "notifyAcceptedOn", 100, relation.NotifyAcceptedOn, ParameterDirection.InputOutput),
                    dataContext.CreateParameter(DbType.Boolean, "isNotifyAccepted", 10, relation.IsNotifyAccepted, ParameterDirection.InputOutput),
                    dataContext.CreateParameter(DbType.String, "userPassword", 200, relation.UserPassword, ParameterDirection.InputOutput),
                    dataContext.CreateParameter(DbType.String, "salt", 15, relation.Salt, ParameterDirection.InputOutput),
                    dataContext.CreateParameter(DbType.String, "organisationName", 200, relation.OrganisationName, ParameterDirection.InputOutput),
                    dataContext.CreateParameter(DbType.String, "businessName", 200, relation.BusinessName, ParameterDirection.InputOutput),
                    dataContext.CreateParameter(DbType.String, "occupation", 150, relation.Occupation, ParameterDirection.InputOutput),
                    dataContext.CreateParameter(DbType.String, "voterId", 200, relation.VoterId, ParameterDirection.InputOutput),
                    dataContext.CreateParameter(DbType.String, "remarks", 150, relation.Remarks, ParameterDirection.InputOutput),
                    dataContext.CreateParameter(DbType.Int32, "tenantId", 100, relation.TenantId, ParameterDirection.InputOutput)
                };

                        sbSQL = new StringBuilder();
                        sbSQL.Clear();
                        sbSQL.Append("SELECT * FROM save_usersaccountdetails(");
                        sbSQL.Append(":userName,");
                        sbSQL.Append(":userTitle,");
                        sbSQL.Append(":firstName,");
                        sbSQL.Append(":lastName,");
                        sbSQL.Append(":address1,");
                        sbSQL.Append(":address2,");
                        sbSQL.Append(":city,");
                        sbSQL.Append(":stateCode,");
                        sbSQL.Append(":countryCode,");
                        sbSQL.Append(":zip,");
                        sbSQL.Append(":email,");
                        sbSQL.Append(":phone,");
                        sbSQL.Append(":userGroup,");
                        sbSQL.Append(":notifyEmailSentOn,");
                        sbSQL.Append(":notifyAcceptedOn,");
                        sbSQL.Append(":isNotifyAccepted,");
                        sbSQL.Append(":userPassword,");
                        sbSQL.Append(":salt,");
                        sbSQL.Append(":organisationName,");
                        sbSQL.Append(":businessName,");
                        sbSQL.Append(":occupation,");
                        sbSQL.Append(":voterId,");
                        sbSQL.Append(":remarks,");
                        sbSQL.Append(":tenantId)");

                        userId = dataContext.Insert(sbSQL.ToString(), commandType: CommandType.Text, userAccountParams);

                        relation.UserId = userId;

                        userRoleRefApiModel = new UseRoleRefApiModel();
                        userRoleRefApiModel.UserId = userId;
                        userRoleRefApiModel.RoleType = Constants.LOB_REL;
                        userRoleRefApiModel.RoleId = 2;
                        userRoleRefApiModel.RefID = lobbyistId;
                        userRoleRefApiModel.RelationshipId = userId;


                        sbSQL = new StringBuilder();
                        sbSQL.Clear();
                        sbSQL.AppendLine("SELECT * FROM save_useroleref(");
                        sbSQL.Append(":userId,");
                        sbSQL.Append(":roleType,");
                        sbSQL.Append(":roleId,");
                        sbSQL.Append(":refId,");
                        sbSQL.Append(":relationshipId)");

                        IDbDataParameter[] useRoleRefParams = new[]
                        {
                    dataContext.CreateParameter(DbType.Int32, "userId", 10,  userRoleRefApiModel.UserId, ParameterDirection.InputOutput),
                    dataContext.CreateParameter(DbType.String, "roleType", 10, userRoleRefApiModel.RoleType, ParameterDirection.InputOutput),
                    dataContext.CreateParameter(DbType.Int32, "roleId", 10, userRoleRefApiModel.RoleId, ParameterDirection.InputOutput),
                    dataContext.CreateParameter(DbType.Int32, "refId", 10, userRoleRefApiModel.RefID, ParameterDirection.InputOutput),
                    dataContext.CreateParameter(DbType.Int32, "relationshipId", 10, userRoleRefApiModel.RelationshipId, ParameterDirection.InputOutput),
                };

                        int userRoleRefId = dataContext.Insert(sbSQL.ToString(), commandType: CommandType.Text, useRoleRefParams);
                    }

                    IDbDataParameter[] signatureParam = new[]
                   {
                      dataContext.CreateParameter(DbType.Int32,"lobbyId", 100, lobbyistId, ParameterDirection.InputOutput),
                      dataContext.CreateParameter(DbType.String,"imageDet", 30000, lobbyistEmployee.Signature, ParameterDirection.InputOutput),
                    };
                    int retValue = dataContext.Update(@"select * from update_lobbyistsignature(:lobbyId, :imageDet)", commandType: CommandType.Text, signatureParam);
                    //return res;

                    sbSQL = new StringBuilder();
                    sbSQL.Clear();
                    sbSQL.AppendLine("SELECT * FROM save_useroleref(");
                    sbSQL.Append(":userId,");
                    sbSQL.Append(":roleType,");
                    sbSQL.Append(":roleId,");
                    sbSQL.Append(":refId,");
                    sbSQL.Append(":relationshipId)");

                    IDbDataParameter[] paramRoleRef = new[]
                    {
                        dataContext.CreateParameter(DbType.Int32, "userId", 10,  lobbyistEmployee.UserID, ParameterDirection.InputOutput),
                        dataContext.CreateParameter(DbType.String, "roleType", 10, Constants.USER_LOBBYIST, ParameterDirection.InputOutput),
                        dataContext.CreateParameter(DbType.Int32, "roleId", 10, 1, ParameterDirection.InputOutput),
                        dataContext.CreateParameter(DbType.Int32, "refId", 10, lobbyistId, ParameterDirection.InputOutput),
                        dataContext.CreateParameter(DbType.Int32, "relationshipId", 10, 0, ParameterDirection.InputOutput),
                    };

                    retValue = dataContext.Insert(sbSQL.ToString(), commandType: CommandType.Text, paramRoleRef);

                    transactionScope.Commit();

                    return lobbyistId > 0;
                }
                catch (Exception Ex)
                {
                    transactionScope.Rollback();

                    throw new ValidationException(Ex.Message, Ex);

                }

                finally
                {
                    connection.Close();
                }
            }

        }

        public async Task<int> CreateLobbyistEmployee(LobbyistInfo lobbyistEmployee)
        {
            int userId = 0;
            UseRoleRefApiModel userRoleRefApiModel;
            StringBuilder sbSQL = new StringBuilder();
            IDbDataParameter[] userAccountParams = new[]
                 {
                    dataContext.CreateParameter(DbType.String, "userName", 10, lobbyistEmployee.UserName, ParameterDirection.InputOutput),
                    dataContext.CreateParameter(DbType.String, "userTitle", 10, lobbyistEmployee.Title, ParameterDirection.InputOutput),
                    dataContext.CreateParameter(DbType.String, "firstName", 200, lobbyistEmployee.FirstName, ParameterDirection.InputOutput),
                    dataContext.CreateParameter(DbType.String, "lastName", 10, lobbyistEmployee.LastName, ParameterDirection.InputOutput),
                    dataContext.CreateParameter(DbType.String, "address1", 150, lobbyistEmployee.Address1, ParameterDirection.InputOutput),
                    dataContext.CreateParameter(DbType.String, "address2", 100 , lobbyistEmployee.Address2, ParameterDirection.InputOutput),
                    dataContext.CreateParameter(DbType.String, "city", 10, lobbyistEmployee.City, ParameterDirection.InputOutput),
                    dataContext.CreateParameter(DbType.String, "stateCode", 20, lobbyistEmployee.StateCode, ParameterDirection.InputOutput),
                    dataContext.CreateParameter(DbType.String, "countryCode", 50, lobbyistEmployee.CountryCode, ParameterDirection.InputOutput),
                    dataContext.CreateParameter(DbType.String, "zip", 1000, lobbyistEmployee.Zipcode, ParameterDirection.InputOutput),
                    dataContext.CreateParameter(DbType.String, "email", 200, lobbyistEmployee.Email, ParameterDirection.InputOutput),
                    dataContext.CreateParameter(DbType.String, "phone", 150, lobbyistEmployee.Phone, ParameterDirection.InputOutput),
                    dataContext.CreateParameter(DbType.String, "userGroup", 150, "N", ParameterDirection.InputOutput),
                    dataContext.CreateParameter(DbType.Date, "notifyEmailSentOn", 100, lobbyistEmployee.NotifyEmailSentOn, ParameterDirection.InputOutput),
                    dataContext.CreateParameter(DbType.Date, "notifyAcceptedOn", 100, lobbyistEmployee.NotifyAcceptedOn, ParameterDirection.InputOutput),
                    dataContext.CreateParameter(DbType.Boolean, "isNotifyAccepted", 10, lobbyistEmployee.IsNotifyAccepted, ParameterDirection.InputOutput),
                    dataContext.CreateParameter(DbType.String, "userPassword", 200, lobbyistEmployee.UserPassword, ParameterDirection.InputOutput),
                    dataContext.CreateParameter(DbType.String, "salt", 15, lobbyistEmployee.Salt, ParameterDirection.InputOutput),
                    dataContext.CreateParameter(DbType.String, "organisationName", 200, lobbyistEmployee.OrganisationName, ParameterDirection.InputOutput),
                    dataContext.CreateParameter(DbType.String, "businessName", 200, lobbyistEmployee.BusinessName, ParameterDirection.InputOutput),
                    dataContext.CreateParameter(DbType.String, "occupation", 150, lobbyistEmployee.Occupation, ParameterDirection.InputOutput),
                    dataContext.CreateParameter(DbType.String, "voterId", 200, lobbyistEmployee.VoterId, ParameterDirection.InputOutput),
                    dataContext.CreateParameter(DbType.String, "remarks", 150, lobbyistEmployee.Remarks, ParameterDirection.InputOutput),
                    dataContext.CreateParameter(DbType.Int32, "tenantId", 100, lobbyistEmployee.TenantId, ParameterDirection.InputOutput)
                };

            sbSQL = new StringBuilder();
            sbSQL.Clear();
            sbSQL.Append("SELECT * FROM save_usersaccountdetails(");
            sbSQL.Append(":userName,");
            sbSQL.Append(":userTitle,");
            sbSQL.Append(":firstName,");
            sbSQL.Append(":lastName,");
            sbSQL.Append(":address1,");
            sbSQL.Append(":address2,");
            sbSQL.Append(":city,");
            sbSQL.Append(":stateCode,");
            sbSQL.Append(":countryCode,");
            sbSQL.Append(":zip,");
            sbSQL.Append(":email,");
            sbSQL.Append(":phone,");
            sbSQL.Append(":userGroup,");
            sbSQL.Append(":notifyEmailSentOn,");
            sbSQL.Append(":notifyAcceptedOn,");
            sbSQL.Append(":isNotifyAccepted,");
            sbSQL.Append(":userPassword,");
            sbSQL.Append(":salt,");
            sbSQL.Append(":organisationName,");
            sbSQL.Append(":businessName,");
            sbSQL.Append(":occupation,");
            sbSQL.Append(":voterId,");
            sbSQL.Append(":remarks,");
            sbSQL.Append(":tenantId)");

            userId = dataContext.Insert(sbSQL.ToString(), commandType: CommandType.Text, userAccountParams);

            lobbyistEmployee.UserId = userId;

            userRoleRefApiModel = new UseRoleRefApiModel();
            userRoleRefApiModel.UserId = userId;
            userRoleRefApiModel.RoleType = "L";
            userRoleRefApiModel.RoleId = 1;
            userRoleRefApiModel.RefID = lobbyistEmployee.LobbyistId;
            userRoleRefApiModel.RelationshipId = 0;


            sbSQL = new StringBuilder();
            sbSQL.Clear();
            sbSQL.AppendLine("SELECT * FROM save_useroleref(");
            sbSQL.Append(":userId,");
            sbSQL.Append(":roleType,");
            sbSQL.Append(":roleId,");
            sbSQL.Append(":refId,");
            sbSQL.Append(":relationshipId)");

            IDbDataParameter[] useRoleRefParams = new[]
            {
                    dataContext.CreateParameter(DbType.Int32, "userId", 10,  userRoleRefApiModel.UserId, ParameterDirection.InputOutput),
                    dataContext.CreateParameter(DbType.String, "roleType", 10, userRoleRefApiModel.RoleType, ParameterDirection.InputOutput),
                    dataContext.CreateParameter(DbType.Int32, "roleId", 10, userRoleRefApiModel.RoleId, ParameterDirection.InputOutput),
                    dataContext.CreateParameter(DbType.Int32, "refId", 10, userRoleRefApiModel.RefID, ParameterDirection.InputOutput),
                    dataContext.CreateParameter(DbType.Int32, "relationshipId", 10, userRoleRefApiModel.RelationshipId, ParameterDirection.InputOutput),
                };

            int userRoleRefId = dataContext.Insert(sbSQL.ToString(), commandType: CommandType.Text, useRoleRefParams);


            return userId;
        }

        public async Task<int> UpdateLobbyistEmployee(LobbyistOldApiModel lobbyistEmployee)
        {
            IDbDataParameter[] param = new[]
               {
                  dataContext.CreateParameter(DbType.Int32,"id", 100, lobbyistEmployee.LobbyistID, ParameterDirection.InputOutput),
                  dataContext.CreateParameter(DbType.String,"_firstname", 100, lobbyistEmployee.FirstName, ParameterDirection.InputOutput),
                  dataContext.CreateParameter(DbType.String,"_lastname", 100, lobbyistEmployee.LastName,  ParameterDirection.InputOutput),
                  dataContext.CreateParameter(DbType.String,"_email", 500, lobbyistEmployee.Email, ParameterDirection.Input),
                  dataContext.CreateParameter(DbType.String,"_imageurl", 500, lobbyistEmployee.ImageURL, ParameterDirection.Input),
                };
            int res = dataContext.Update(@"select * from update_lobbyist(:id, :_firstname, :_lastname, :_email, :_imageurl)", commandType: CommandType.Text, param);
            return res;
        }
        public async Task<int> UpdateLobbyistEmployee(LobbyistInfo lobbyistEmployee)
        {
            UseRoleRefApiModel userRoleRefApiModel;
            StringBuilder sbSQL = new StringBuilder();
            IDbDataParameter[] userAccountParams = new[]
                 {
                    dataContext.CreateParameter(DbType.Int32, "userid", 10, lobbyistEmployee.UserId, ParameterDirection.InputOutput),
                    dataContext.CreateParameter(DbType.String, "userName", 10, lobbyistEmployee.UserName, ParameterDirection.InputOutput),
                    dataContext.CreateParameter(DbType.String, "userTitle", 10, lobbyistEmployee.Title, ParameterDirection.InputOutput),
                    dataContext.CreateParameter(DbType.String, "firstName", 200, lobbyistEmployee.FirstName, ParameterDirection.InputOutput),
                    dataContext.CreateParameter(DbType.String, "lastName", 10, lobbyistEmployee.LastName, ParameterDirection.InputOutput),
                    dataContext.CreateParameter(DbType.String, "addressref1", 150, lobbyistEmployee.Address1, ParameterDirection.InputOutput),
                    dataContext.CreateParameter(DbType.String, "addressref2", 100 , lobbyistEmployee.Address2, ParameterDirection.InputOutput),
                    dataContext.CreateParameter(DbType.String, "citys", 10, lobbyistEmployee.City, ParameterDirection.InputOutput),
                    dataContext.CreateParameter(DbType.String, "stateCode", 20, lobbyistEmployee.StateCode, ParameterDirection.InputOutput),
                    dataContext.CreateParameter(DbType.String, "countryCode", 50, lobbyistEmployee.CountryCode, ParameterDirection.InputOutput),
                    dataContext.CreateParameter(DbType.String, "zipCode", 1000, lobbyistEmployee.Zipcode, ParameterDirection.InputOutput),
                    dataContext.CreateParameter(DbType.String, "emailId", 200, lobbyistEmployee.Email, ParameterDirection.InputOutput),
                    dataContext.CreateParameter(DbType.String, "phoneNo", 150, lobbyistEmployee.Phone, ParameterDirection.InputOutput),
                    dataContext.CreateParameter(DbType.String, "userGroup", 150, "N", ParameterDirection.InputOutput),
                    dataContext.CreateParameter(DbType.Date, "notifyEmailSentOn", 100, lobbyistEmployee.NotifyEmailSentOn, ParameterDirection.InputOutput),
                    dataContext.CreateParameter(DbType.Date, "notifyAcceptedOn", 100, lobbyistEmployee.NotifyAcceptedOn, ParameterDirection.InputOutput),
                    dataContext.CreateParameter(DbType.Boolean, "isNotifyAccepted", 10, lobbyistEmployee.IsNotifyAccepted, ParameterDirection.InputOutput),
                    dataContext.CreateParameter(DbType.String, "userPassword", 200, lobbyistEmployee.UserPassword, ParameterDirection.InputOutput),
                    dataContext.CreateParameter(DbType.String, "saltref", 15, lobbyistEmployee.Salt, ParameterDirection.InputOutput),
                    dataContext.CreateParameter(DbType.String, "organisationName", 200, lobbyistEmployee.OrganisationName, ParameterDirection.InputOutput),
                    dataContext.CreateParameter(DbType.String, "businessName", 200, lobbyistEmployee.BusinessName, ParameterDirection.InputOutput),
                    dataContext.CreateParameter(DbType.String, "occupations", 150, lobbyistEmployee.Occupation, ParameterDirection.InputOutput),
                    dataContext.CreateParameter(DbType.String, "voterId", 200, lobbyistEmployee.VoterId, ParameterDirection.InputOutput),
                    dataContext.CreateParameter(DbType.String, "remark", 150, lobbyistEmployee.Remarks, ParameterDirection.InputOutput),
                    dataContext.CreateParameter(DbType.Int32, "tenantId", 100, lobbyistEmployee.TenantId, ParameterDirection.InputOutput)
                };

            sbSQL = new StringBuilder();
            sbSQL.Clear();
            sbSQL.Append("SELECT * FROM update_usersaccountdetails(");
            sbSQL.Append(":userId,");
            sbSQL.Append(":userName,");
            sbSQL.Append(":userTitle,");
            sbSQL.Append(":firstName,");
            sbSQL.Append(":lastName,");
            sbSQL.Append(":addressref1,");
            sbSQL.Append(":addressref2,");
            sbSQL.Append(":citys,");
            sbSQL.Append(":stateCode,");
            sbSQL.Append(":countryCode,");
            sbSQL.Append(":zipCode,");
            sbSQL.Append(":emailId,");
            sbSQL.Append(":phoneNo,");
            sbSQL.Append(":userGroup,");
            sbSQL.Append(":notifyEmailSentOn,");
            sbSQL.Append(":notifyAcceptedOn,");
            sbSQL.Append(":isNotifyAccepted,");
            sbSQL.Append(":userPassword,");
            sbSQL.Append(":saltref,");
            sbSQL.Append(":organisationName,");
            sbSQL.Append(":businessName,");
            sbSQL.Append(":occupations,");
            sbSQL.Append(":voterId,");
            sbSQL.Append(":remark,");
            sbSQL.Append(":tenantId)");
            int res = dataContext.Update(sbSQL.ToString(), commandType: CommandType.Text, userAccountParams);
            return res;
        }
        public async Task<int> DeleteLobbyistUser(int LobbyistEmployeeID)
        {
            IDbDataParameter[] param = new[]
                {
                  dataContext.CreateParameter(DbType.Int32,"userid", 100, LobbyistEmployeeID, ParameterDirection.InputOutput),
                };
            int res = dataContext.Delete(@"select * from delete_useraccount(:userid)", commandType: CommandType.Text, param);
            return res;
        }

        public async Task<int> DeleteLobbyistEmployee(int LobbyistEmployeeID)
        {
            IDbDataParameter[] param = new[]
                {
                  dataContext.CreateParameter(DbType.Int32,"id", 100, LobbyistEmployeeID, ParameterDirection.InputOutput),
                };
            int res = dataContext.Delete(@"select * from delete_lobbyist(:id)", commandType: CommandType.Text, param);
            return res;
        }


        public async Task<List<LobbyistOldApiModel>> GetLobbyistEmployeebyID(int LobbyistEmployeeID)
        {
            IDbDataParameter[] param = new[]
               {
                  dataContext.CreateParameter(DbType.Int32,"id", 100, LobbyistEmployeeID, ParameterDirection.InputOutput),
                };
            DataTable ResultDT = dataContext.GetDataTable(@"select * from get_lobbyistemployeebyid(:id)", commandType: CommandType.Text, param);
            List<LobbyistOldApiModel> Studentlist = tableConverter.ConvertToList<LobbyistOldApiModel>(ResultDT);
            return Studentlist;
        }

        public async Task<List<LobbyistOldApiModel>> GetLobbyistEmployeebyList()
        {
            DataTable ResultDT = dataContext.GetDataTable(@"select * from get_lobbyistemployeedetails()", commandType: CommandType.Text, null);

            List<LobbyistOldApiModel> Studentlist = tableConverter.ConvertToList<LobbyistOldApiModel>(ResultDT);
            return Studentlist;
        }


        public async Task<int> LoginInformation(UserModel contactinfo, string SecretKey)
        {
            int result;
            Cryptograhy crpt = new Cryptograhy();

            EncryptResultModel objEncry = crpt.EncryptText(contactinfo.Password, SecretKey);
            var pass = Convert.ToBase64String(objEncry.Password);
            var salt = Convert.ToBase64String(objEncry.Salt);

            try
            {
                IDbDataParameter[] param = new[]
                    {
                  dataContext.CreateParameter(DbType.Int32,"id", 100, contactinfo.ContactInformationId, ParameterDirection.InputOutput),
                  dataContext.CreateParameter(DbType.String, "emailid", 200, contactinfo.Email, ParameterDirection.InputOutput),
                  dataContext.CreateParameter(DbType.String,"pass", 500, pass, ParameterDirection.Input),
                  dataContext.CreateParameter(DbType.String,"salttest", 100, salt, ParameterDirection.Input),


                };
                result = dataContext.Update(@"select * from create_loginpassword(:id, :emailid , :pass, :salttest)", commandType: CommandType.Text, param);

                return result;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        public async Task<int> ResetPassword(ResetPasswordModel contactinfo, string SecretKey)
        {
            int result = 0;
            if (CheckExpirePWDDate(contactinfo.UserId) >= 0)
            {
                EncryptResultModel objEncryptPWD = GetEncryptText(contactinfo.Password, SecretKey);

                string strPWD = Convert.ToBase64String(objEncryptPWD.Password);
                string strSaltKey = Convert.ToBase64String(objEncryptPWD.Salt);

                try
                {
                    IDbDataParameter[] param = new[]
                    {
                        dataContext.CreateParameter(DbType.Int32, "id", 200, contactinfo.UserId, ParameterDirection.InputOutput),
                        dataContext.CreateParameter(DbType.String,"pass", 500, strPWD, ParameterDirection.Input),
                        dataContext.CreateParameter(DbType.String,"saltKey", 500, strSaltKey, ParameterDirection.Input),
                        dataContext.CreateParameter(DbType.String,"old", 500, contactinfo.OldPassword, ParameterDirection.Input),
                    };
                    result = dataContext.Update(@"select * from create_resetpassword(:id , :pass, :saltKey, :old)", commandType: CommandType.Text, param);
                }
                catch (Exception ex)
                {
                    throw new CustomException(ex.Message, ex);
                }
            }
            else
                result = 2;

            return result;
        }
        public async Task<int> SelectUserType(UserTypeModel contactinfo)
        {
            int result;
            try
            {
                IDbDataParameter[] param = new[]
                    {
                  dataContext.CreateParameter(DbType.Int32,"id", 100, contactinfo.ContactInformationId, ParameterDirection.InputOutput),
                  dataContext.CreateParameter(DbType.String, "usertype", 200, contactinfo.UserTypeId, ParameterDirection.Input),


                };

                result = dataContext.Update(@"select * from select_usertypeid(:id, :usertype)", commandType: CommandType.Text, param);

                return result;
            }
            catch (Exception ex)
            {
                throw new CustomException(ex.Message, ex);
            }

        }
        public async Task<List<UserTypeRefDataModel>> GetAllUserType()
        {


            DataTable ResultDT = dataContext.GetDataTable(@"select * from get_usertypedetails()", commandType: CommandType.Text, null);

            List<UserTypeRefDataModel> Studentlist = tableConverter.ConvertToList<UserTypeRefDataModel>(ResultDT);
            return Studentlist;
        }

        public async Task<int> CreateRolerelationship(RolerelationshipApiModel rolerelationship)
        {
            IDbDataParameter[] param = new[]
               {
                  dataContext.CreateParameter(DbType.Int32,"roleid", 100, rolerelationship.RoleID, ParameterDirection.InputOutput),
                  dataContext.CreateParameter(DbType.String,"roletype", 100, rolerelationship.RoleType, ParameterDirection.InputOutput),
                  dataContext.CreateParameter(DbType.Int32,"refid", 100, rolerelationship.RefID, ParameterDirection.InputOutput),
                  dataContext.CreateParameter(DbType.Int32,"relationshipid", 100, rolerelationship.RelationshipID,  ParameterDirection.InputOutput),
                  dataContext.CreateParameter(DbType.Int32,"userid", 100, rolerelationship.UserID, ParameterDirection.InputOutput),
                  dataContext.CreateParameter(DbType.Int32,"lobbyistid", 100, rolerelationship.LobbyistID, ParameterDirection.InputOutput),
                };
            int res = dataContext.Insert(@"select * from save_rolerelationship(:roleid, :roletype, :refid, :relationshipid, :userid, :lobbyistid)", commandType: CommandType.Text, param);
            return res;
        }
        public async Task<int> UpdateExpireDateTime(EmailReq emailReq)
        {
            try
            {
                int retValue = 0;
                DateTime dateTime = DateTime.Now;
                var expire = dateTime.AddHours(5);
                UserInfoResposeApiModel userInfo = GetUserDetailById(emailReq.ToEmail);
                if (userInfo != null)
                {
                    IDbDataParameter[] param = new[]
                    {
                      dataContext.CreateParameter(DbType.String,"mailid", 100, userInfo.EmailId, ParameterDirection.InputOutput),
                      dataContext.CreateParameter(DbType.DateTime,"expire", 100, expire, ParameterDirection.InputOutput),
                    };
                    retValue = dataContext.Update(@"select * from set_expiretime(:mailid,:expire)", commandType: CommandType.Text, param);
                    if (retValue > 0)
                        retValue = userInfo.UserId;
                }
                else
                    retValue = 0;
                return retValue;
            }
            catch (Exception Ex)
            {
                throw new CustomException(Ex.Message, Ex);
            }
        }


        public async Task<bool> UpdateIEFAdditionalInfo(IEFAddlInfoApiModel IEFDetails)
        {
            IDbDataParameter[] param = new[]
               {
                  dataContext.CreateParameter(DbType.Int32,"userId", 100, IEFDetails.UserID, ParameterDirection.InputOutput),
                  dataContext.CreateParameter(DbType.String,"filerType", 10, IEFDetails.FilerType, ParameterDirection.InputOutput),
                  dataContext.CreateParameter(DbType.String,"occupationDetails", 150, IEFDetails.Occupation, ParameterDirection.InputOutput),
                  dataContext.CreateParameter(DbType.String,"employerDetails", 200, IEFDetails.Employer,  ParameterDirection.InputOutput),
             };
            int res = dataContext.Update(@"select * from save_iefadditionalinfo(:userId, :filerType, :occupationDetails, :employerDetails)", commandType: CommandType.Text, param);
            return res > 0;
        }


        public async Task<bool> UpdateLobbyistAdditionalInfo(LobbyistAddlInfoApiModel lobbyistAddlInfoDetails)
        {
            int retValue = 0;
            foreach (SelectedLobbyist Lobb in lobbyistAddlInfoDetails.Lobbyist)
            {
                IDbDataParameter[] param = new[]
                {
                  dataContext.CreateParameter(DbType.Int32,"userId", 100, lobbyistAddlInfoDetails.UserID, ParameterDirection.InputOutput),
                  dataContext.CreateParameter(DbType.String,"userType", 10, lobbyistAddlInfoDetails.UserType, ParameterDirection.InputOutput),
                  dataContext.CreateParameter(DbType.Int32,"userRoleId", 100, lobbyistAddlInfoDetails.UserRoleId, ParameterDirection.InputOutput),
                  dataContext.CreateParameter(DbType.Int32,"refId", 100, Lobb.RefId,  ParameterDirection.InputOutput),
                  dataContext.CreateParameter(DbType.Int32,"relationshipId", 100, lobbyistAddlInfoDetails.RelationshipId,  ParameterDirection.InputOutput),
                };
                retValue = dataContext.Insert(@"select * from save_additionalinfo(:userId, :userType, :userRoleId, :refId, :relationshipId)", commandType: CommandType.Text, param);

            }
            return retValue > 0;
        }

        public async Task<List<LobbyistOldApiModel>> GetLobbyistList()
        {
            DataTable ResultDT = dataContext.GetDataTable(@"select * from get_lobbyistlist()", commandType: CommandType.Text, null);

            List<LobbyistOldApiModel> Studentlist = tableConverter.ConvertToList<LobbyistOldApiModel>(ResultDT);
            return Studentlist;
        }

        public async Task<IEnumerable<UAConfirmationAndSubmitResponseApiModel>> GetUserAccountConfirmAndSubmit(UAConfirmationAndSubmitRequestApiModel UAConfirmDetails)
        {

            IDbDataParameter[] param = new[]
               {
                  dataContext.CreateParameter(DbType.Int32,"userId", 100, UAConfirmDetails.UserId, ParameterDirection.InputOutput),
            };
            DataTable dtUserConfirmDet = dataContext.GetDataTable(@"SELECT * FROM get_useraccoutconfirmationdetail(:userId)", commandType: CommandType.Text, param);

            IEnumerable<UAConfirmationAndSubmitResponseApiModel> resposeDt = ConvertDataTableToList.DataTableToList<UAConfirmationAndSubmitResponseApiModel>(dtUserConfirmDet);

            return resposeDt;
        }

        public async Task<IEnumerable<UserBaseInfo>> GetOfficerListByName(OfficerListRequestApiModel searchOfficer)
        {
            IDbDataParameter[] param = new[]
            {
                  dataContext.CreateParameter(DbType.String,"officerName", 100, searchOfficer.searchOfficerName, ParameterDirection.InputOutput)
            };
            var dtCommitteeList = dataContext.GetDataTable(@"SELECT * FROM get_officerdetailsbyname(:officerName)", commandType: CommandType.Text, param);

            IEnumerable<UserBaseInfo> resposeDt = ConvertDataTableToList.DataTableToList<UserBaseInfo>(dtCommitteeList);
            return resposeDt;
        }
        public async Task<IEnumerable<ClientsResponseApiModel>> GetClientListByName(ClientListRequestApiModel searchCommitte)
        {
            try
            {
                IDbDataParameter[] param = new[]
                {
                  dataContext.CreateParameter(DbType.String,"comName", 300, searchCommitte.searchClientName, ParameterDirection.InputOutput)
            };
                var dtCommitteeList = dataContext.GetDataTable(@"SELECT * FROM get_clientsbyname(:comName)", commandType: CommandType.Text, param);

                IEnumerable<ClientsResponseApiModel> resposeDt = ConvertDataTableToList.DataTableToList<ClientsResponseApiModel>(dtCommitteeList);
                return resposeDt;
            }
            catch (Exception Ex)
            {
                throw new CustomException(Ex.Message, Ex);
            }
        }
        public async Task<IEnumerable<LobbyistOldApiModel>> GetLobbyListByName(string searchLobbyName)
        {
            try
            {
                IDbDataParameter[] param = new[]
                {
                  dataContext.CreateParameter(DbType.String,"comName", 300, searchLobbyName, ParameterDirection.InputOutput)
            };
                var dtCommitteeList = dataContext.GetDataTable(@"SELECT * FROM get_lobbybyname(:comName)", commandType: CommandType.Text, param);

                IEnumerable<LobbyistOldApiModel> resposeDt = ConvertDataTableToList.DataTableToList<LobbyistOldApiModel>(dtCommitteeList);
                return resposeDt;
            }
            catch (Exception Ex)
            {
                throw new CustomException(Ex.Message, Ex);
            }
        }

        public async Task<LoginUserInfoResposeApiModel> ValidateCredentials(LoginUserInfoRequestApiModel loginUserInfoDetail, string secretKey)
        {
            LoginUserInfoResposeApiModel loginUserInfoResposeApiModel = null;
            List<RolesandTypesApiModel> RolesandTypesss = new List<RolesandTypesApiModel>();
            IDbDataParameter[] param = new[]
            {
                  dataContext.CreateParameter(DbType.String,"userEmailId", 100, loginUserInfoDetail.EmailId, ParameterDirection.InputOutput),
                };

            var resposeDet = dataContext.GetDataTable(@"select * from get_userdetail(:userEmailId)", commandType: CommandType.Text, param);

            IEnumerable<LoginUserInfoResposeApiModel> resposeDt = ConvertDataTableToList.DataTableToList<LoginUserInfoResposeApiModel>(resposeDet);

            if (resposeDt.Count() == 1)
            {

                loginUserInfoResposeApiModel = new LoginUserInfoResposeApiModel()
                {
                    UserId = resposeDt.FirstOrDefault().UserId,
                    ContactId = resposeDt.FirstOrDefault().ContactId,
                    EmailId = resposeDt.FirstOrDefault().EmailId,
                    PWD = resposeDt.FirstOrDefault().PWD,
                    SaltKey = resposeDt.FirstOrDefault().SaltKey
                };


                IDbDataParameter[] paramm = new[]
                {
                  dataContext.CreateParameter(DbType.Int32,"_userid", 100, Convert.ToInt32(loginUserInfoResposeApiModel.UserId), ParameterDirection.InputOutput),
                };
                var resDdt = dataContext.GetDataTable(@"select * from get_rolesandtypes(:_userid)", commandType: CommandType.Text, paramm);

                IEnumerable<RolesandTypesApiModel> resDt = ConvertDataTableToList.DataTableToList<RolesandTypesApiModel>(resDdt);
                foreach (var resres in resDt)
                {
                    RolesandTypesss.Add(new RolesandTypesApiModel
                    {
                        RoleID = resres.RoleID,
                        Role = resres.Role,
                        EntityID = resres.EntityID,
                        EntityType = resres.EntityType,
                        EntityName = resres.EntityName
                    });
                }
                if (resposeDet.Rows.Count != 0)
                {
                    loginUserInfoResposeApiModel.RolesandTypes = RolesandTypesss;
                }
            }
            return loginUserInfoResposeApiModel;
        }

        private UserInfoResposeApiModel GetUserDetailById(string EmailId)
        {
            string retValue = string.Empty;
            UserInfoResposeApiModel userInfo = null;

            IDbDataParameter[] param = new[]
            {
                  dataContext.CreateParameter(DbType.String,"mailId", 200, EmailId, ParameterDirection.InputOutput),
             };

            var resposeDet = dataContext.GetDataTable(@"select * from get_userdetailbyid(:mailId)", commandType: CommandType.Text, param);


            IEnumerable<UserInfoResposeApiModel> resposeDt = ConvertDataTableToList.DataTableToList<UserInfoResposeApiModel>(resposeDet);

            foreach (var res in resposeDt)
            {
                userInfo = new UserInfoResposeApiModel()
                {
                    UserId = res.UserId,
                    FName = res.FName,
                    LName = res.LName,
                    Address1 = res.Address1,
                    Address2 = res.Address2,
                    cityName = res.cityName,
                    StateCode = res.StateCode,
                    Zip = res.Zip,
                    PhoneNo = res.PhoneNo,
                    EmailId = res.EmailId
                };
            }
            return userInfo;
        }

        private EncryptResultModel GetEncryptText(string pPassword, string pSecretKey)
        {
            Cryptograhy cryptograhy = new Cryptograhy();
            EncryptResultModel respose = cryptograhy.EncryptText(pPassword, pSecretKey);

            return respose;
        }


        private int CheckExpirePWDDate(int pUserEmail)
        {
            IDbDataParameter[] param = new[]
            {
                  dataContext.CreateParameter(DbType.Int32,"id", 100, pUserEmail, ParameterDirection.InputOutput)
            };
            var retVal = dataContext.GetScalarValue(@"SELECT * FROM checkpwdexpiredatetime(:id)", commandType: CommandType.Text, param);

            if (retVal != null)
                return 1;
            else
                return 0;
        }

        public async Task<int> SendIndependentSpender(IndependentSpenderAffiliationApiModel independentSpenderAffiliation)
        {
            int retValue = 0;
            int UserID = independentSpenderAffiliation.UserID;
            foreach (IndependentSpenderAffiliation independentSpenderId in independentSpenderAffiliation.IndependentSpenderids)
            {
                IDbDataParameter[] param = new[]
                {
                  dataContext.CreateParameter(DbType.Int32,"_independentSpenderId", 100, independentSpenderId.IndependentSpenderID, ParameterDirection.InputOutput),
                  dataContext.CreateParameter(DbType.Int32,"_userId", 100, UserID, ParameterDirection.InputOutput),
                  dataContext.CreateParameter(DbType.String,"_notes", 100, independentSpenderAffiliation.Notes, ParameterDirection.InputOutput),
                };
                retValue = dataContext.Insert(@"select * from save_userindependentspender(:_independentSpenderId, :_userId, :_notes)", commandType: CommandType.Text, param);

            }
            return retValue;
        }

        public async Task<IEnumerable<IndependentSpenderApiModel>> GetIndependentSpender(SearchIERequestApiModel searchIERequest)
        {
            IDbDataParameter[] param = new[]
            {
                  dataContext.CreateParameter(DbType.String,"_independentspender", 200, searchIERequest.IndependentSpender, ParameterDirection.InputOutput),
             };
            var dtCommitteeList = dataContext.GetDataTable(@"SELECT * FROM get_independentspender(:_independentspender)", commandType: CommandType.Text, param);
            IEnumerable<IndependentSpenderApiModel> resposeDt = ConvertDataTableToList.DataTableToList<IndependentSpenderApiModel>(dtCommitteeList);
            return resposeDt;
        }

        public async Task<LobbyistDetailResponseApiModel> GetLobbyistDetail(int lobbyistId)
        {
            int idx = 0;

            IDbDataParameter[] param = new[]
            {
                  dataContext.CreateParameter(DbType.Int32,"_lobbyistid", 100, lobbyistId, ParameterDirection.InputOutput)
            };
            var dtLobbyist = dataContext.GetDataTable(@"SELECT * FROM public.get_lobbyistdetailbyid(:_lobbyistid)", commandType: CommandType.Text, param);

            LobbyistDetailResponseApiModel lobbyistDetails = ConvertDataTableToList.ToClass<LobbyistDetailResponseApiModel>(dtLobbyist);

            param = new[]
            {
                  dataContext.CreateParameter(DbType.Int32,"_lobbyistid", 100, lobbyistId, ParameterDirection.InputOutput)
            };
            var dtLobbyistEmp = dataContext.GetDataTable(@"SELECT * FROM public.get_lobbyistemployeedetailbyid(:_lobbyistid)", commandType: CommandType.Text, param);

            IEnumerable<LobbyistEmployee> resposeEmpDt = ConvertDataTableToList.DataTableToList<LobbyistEmployee>(dtLobbyistEmp);

            LobbyistEmployee[] lobbyistEmployees = new LobbyistEmployee[dtLobbyistEmp.Rows.Count];

            foreach (LobbyistEmployee emp in resposeEmpDt)
            {
                lobbyistEmployees[idx++] = emp;
            }
            lobbyistDetails.Employees = lobbyistEmployees;

            param = new[]
            {
                  dataContext.CreateParameter(DbType.Int32,"_lobbyistid", 100, lobbyistId, ParameterDirection.InputOutput)
            };
            var dtLobbyistSubcon = dataContext.GetDataTable(@"SELECT * FROM public.get_lobbyistsubcontractordetailbyid(:_lobbyistid)", commandType: CommandType.Text, param);

            IEnumerable<LobbyistSubContractor> resposeSubConDt = ConvertDataTableToList.DataTableToList<LobbyistSubContractor>(dtLobbyistSubcon);

            LobbyistSubContractor[] lobbyistSubCons = new LobbyistSubContractor[dtLobbyistSubcon.Rows.Count];
            idx = 0;
            foreach (LobbyistSubContractor subContractor in resposeSubConDt)
            {
                lobbyistSubCons[idx++] = subContractor;
            }
            lobbyistDetails.SubContractors = lobbyistSubCons;

            param = new[]
            {
                  dataContext.CreateParameter(DbType.Int32,"_lobbyistid", 100, lobbyistId, ParameterDirection.InputOutput)
            };
            var dtLobbyistClients = dataContext.GetDataTable(@"SELECT * FROM public.get_lobbyistclientdetailbyid(:_lobbyistid)", commandType: CommandType.Text, param);

            IEnumerable<LobbyistClient> resposeClientDt = ConvertDataTableToList.DataTableToList<LobbyistClient>(dtLobbyistClients);

            LobbyistClient[] lobbyistClients = new LobbyistClient[dtLobbyistSubcon.Rows.Count];
            idx = 0;
            foreach (LobbyistClient client in resposeClientDt)
            {
                lobbyistClients[idx++] = client;
            }
            lobbyistDetails.Clients = lobbyistClients;

            param = new[]
            {
                  dataContext.CreateParameter(DbType.Int32,"_lobbyistid", 100, lobbyistId, ParameterDirection.InputOutput)
            };
            var dtLobbyistRelationship = dataContext.GetDataTable(@"SELECT * FROM public.get_lobbyistrelationshipdetailbyid(:_lobbyistid)", commandType: CommandType.Text, param);

            IEnumerable<LobbyistRelationship> resposeRelationshipDt = ConvertDataTableToList.DataTableToList<LobbyistRelationship>(dtLobbyistRelationship);

            LobbyistRelationship[] lobbyistRelationships = new LobbyistRelationship[dtLobbyistSubcon.Rows.Count];
            idx = 0;
            foreach (LobbyistRelationship relationship in resposeRelationshipDt)
            {
                lobbyistRelationships[idx++] = relationship;
            }
            lobbyistDetails.Relationships = lobbyistRelationships;

            param = new[]
            {
                  dataContext.CreateParameter(DbType.Int32,"_lobbyistid", 100, lobbyistId, ParameterDirection.InputOutput)
            };
            var dtLobbyistSignature = dataContext.GetDataTable(@"SELECT * FROM public.get_lobbyistsignaturebyid(:_lobbyistid)", commandType: CommandType.Text, param);

            LobbyistSignature resposeSignature = ConvertDataTableToList.ToClass<LobbyistSignature>(dtLobbyistSignature);

            lobbyistDetails.Signature = resposeSignature;

            return lobbyistDetails;
        }


        public async Task<IEnumerable<SwitchCommitteeDetail>> GetSwitchCommitteeDetails(int id)
        {
            IDbDataParameter[] param = new[]
            {
                  dataContext.CreateParameter(DbType.Int32,"_id", 200, id, ParameterDirection.InputOutput),
             };
            var dtCommitteeList = dataContext.GetDataTable(@"SELECT * FROM get_switchcommitteedetail(:_id)", commandType: CommandType.Text, param);
            IEnumerable<SwitchCommitteeDetail> resposeDt = ConvertDataTableToList.DataTableToList<SwitchCommitteeDetail>(dtCommitteeList);
            return resposeDt;
        }


        public async Task<IEnumerable<SwitchLobbyistDetail>> GetSwitchLobbyistDetails(int id)
        {
            IDbDataParameter[] param = new[]
            {
                   dataContext.CreateParameter(DbType.Int32,"_id", 200, id, ParameterDirection.InputOutput),
             };
            var dtCommitteeList = dataContext.GetDataTable(@"SELECT * FROM get_switchlobbyistdetail(:_id)", commandType: CommandType.Text, param);
            IEnumerable<SwitchLobbyistDetail> resposeDt = ConvertDataTableToList.DataTableToList<SwitchLobbyistDetail>(dtCommitteeList);
            return resposeDt;
        }


        public async Task<IEnumerable<SwitchIEDetail>> GetSwitchIEDetails(int id)
        {
            IDbDataParameter[] param = new[]
            {
                   dataContext.CreateParameter(DbType.Int32,"_id", 200, id, ParameterDirection.InputOutput),
             };
            var dtCommitteeList = dataContext.GetDataTable(@"SELECT * FROM get_switchiedetail(:_id)", commandType: CommandType.Text, param);
            IEnumerable<SwitchIEDetail> resposeDt = ConvertDataTableToList.DataTableToList<SwitchIEDetail>(dtCommitteeList);
            return resposeDt;
        }
        public async Task<IEnumerable<ManageFilerResponseApiModel>> GetManageFilerDetail(ManageFilerRequestApiModel manageFilerRequest)
        {
            StringBuilder sbSQL = new StringBuilder();

            if (manageFilerRequest.LastFillingStartDate == null)
            {
                manageFilerRequest.LastFillingStartDate = DateTime.MinValue;
            }
            if (manageFilerRequest.LastFillingEndDate == null)
            {
                manageFilerRequest.LastFillingEndDate = DateTime.MaxValue;
            }

            IDbDataParameter[] param = new[]
             {
                  dataContext.CreateParameter(DbType.String,"fname", 200, manageFilerRequest.FilerName, ParameterDirection.InputOutput),
                  dataContext.CreateParameter(DbType.String,"ftype", 200, manageFilerRequest.FilerType, ParameterDirection.InputOutput),
                  dataContext.CreateParameter(DbType.String,"fstatus", 200, manageFilerRequest.FilerStatus, ParameterDirection.InputOutput),
                  dataContext.CreateParameter(DbType.Date,"lsstartdate", 200, manageFilerRequest.LastFillingStartDate, ParameterDirection.InputOutput),
                  dataContext.CreateParameter(DbType.Date,"lsenddate", 200, manageFilerRequest.LastFillingEndDate, ParameterDirection.InputOutput),
                  dataContext.CreateParameter(DbType.String,"ctype", 200, manageFilerRequest.CommitteType, ParameterDirection.InputOutput),
                  dataContext.CreateParameter(DbType.String,"otype", 200, manageFilerRequest.OfficeType, ParameterDirection.InputOutput),
                  dataContext.CreateParameter(DbType.String,"publicfundstatus", 200, manageFilerRequest.PublicFundStatus, ParameterDirection.InputOutput),
             };

            sbSQL.Clear();
            sbSQL.Append("SELECT * FROM get_managefilter(");
            sbSQL.Append(":fname,");
            sbSQL.Append(":ftype,");
            sbSQL.Append(":fstatus,");
            sbSQL.Append(":lsstartdate,");
            sbSQL.Append(":lsenddate,");
            sbSQL.Append(":ctype,");
            sbSQL.Append(":otype,");
            sbSQL.Append(":publicfundstatus)");

            var dtManageFilerList = dataContext.GetDataTable(sbSQL.ToString(), commandType: CommandType.Text, param);
            IEnumerable<ManageFilerResponseApiModel> resposeDt = ConvertDataTableToList.DataTableToList<ManageFilerResponseApiModel>(dtManageFilerList);
            return resposeDt;
        }


        public async Task<DataTable> DownloadManageFiler(ManageFilerRequestApiModel manageFilerRequest)
        {
            StringBuilder sbSQL = new StringBuilder();

            if (manageFilerRequest.LastFillingStartDate == null)
            {
                manageFilerRequest.LastFillingStartDate = DateTime.MinValue;
            }
            if (manageFilerRequest.LastFillingEndDate == null)
            {
                manageFilerRequest.LastFillingEndDate = DateTime.MaxValue;
            }

            IDbDataParameter[] param = new[]
             {
                  dataContext.CreateParameter(DbType.String,"fname", 200, manageFilerRequest.FilerName, ParameterDirection.InputOutput),
                  dataContext.CreateParameter(DbType.String,"ftype", 200, manageFilerRequest.FilerType, ParameterDirection.InputOutput),
                  dataContext.CreateParameter(DbType.String,"fstatus", 200, manageFilerRequest.FilerStatus, ParameterDirection.InputOutput),
                  dataContext.CreateParameter(DbType.Date,"lsstartdate", 200, manageFilerRequest.LastFillingStartDate, ParameterDirection.InputOutput),
                  dataContext.CreateParameter(DbType.Date,"lsenddate", 200, manageFilerRequest.LastFillingEndDate, ParameterDirection.InputOutput),
                  dataContext.CreateParameter(DbType.String,"ctype", 200, manageFilerRequest.CommitteType, ParameterDirection.InputOutput),
                  dataContext.CreateParameter(DbType.String,"otype", 200, manageFilerRequest.OfficeType, ParameterDirection.InputOutput),
                  dataContext.CreateParameter(DbType.String,"publicfundstatus", 200, manageFilerRequest.PublicFundStatus, ParameterDirection.InputOutput),
             };

            sbSQL.Clear();
            sbSQL.Append("SELECT * FROM get_managefilter(");
            sbSQL.Append(":fname,");
            sbSQL.Append(":ftype,");
            sbSQL.Append(":fstatus,");
            sbSQL.Append(":lsstartdate,");
            sbSQL.Append(":lsenddate,");
            sbSQL.Append(":ctype,");
            sbSQL.Append(":otype,");
            sbSQL.Append(":publicfundstatus)");

            var dtCommitteeList = dataContext.GetDataTable(sbSQL.ToString(), commandType: CommandType.Text, param);
            return dtCommitteeList;
        }

        public async Task<bool> UpdateLobbyistStatus(LobbyistStatusUpdateRequestApiModel lobbyistStatusUpdate)
        {
            int retValue = 0;
            IDbDataParameter[] param = new[]
            {
                  dataContext.CreateParameter(DbType.Int32,"_id", 100, lobbyistStatusUpdate.Id, ParameterDirection.InputOutput),
                  dataContext.CreateParameter(DbType.Boolean,"status", 10, lobbyistStatusUpdate.Status, ParameterDirection.InputOutput),
                  dataContext.CreateParameter(DbType.String,"addnotes", 100, lobbyistStatusUpdate.Notes, ParameterDirection.InputOutput),
            };
            retValue = dataContext.Update(@"select * from update_lobbyiststatus(:_id, :status, :addnotes)", commandType: CommandType.Text, param);
            return retValue > 0;
        }
        public async Task<UserEmailDetailResponseApiModel> GetLobbyistUserEmail(int Id)
        {
            IDbDataParameter[] param = new[]
            {
                   dataContext.CreateParameter(DbType.Int32,"_id", 200, Id, ParameterDirection.InputOutput),
                   dataContext.CreateParameter(DbType.String,"userType", 200, Constants.USER_LOBBYIST, ParameterDirection.InputOutput),
            };
            var dtUserEmail = dataContext.GetDataTable(@"SELECT * FROM get_useremail(:_id, :userType)", commandType: CommandType.Text, param);
            UserEmailDetailResponseApiModel response = ConvertDataTableToList.ToClass<UserEmailDetailResponseApiModel>(dtUserEmail);
            return response;
        }


        public async Task<IEnumerable<UserInfoResposeApiModel>> GetUserDetails(int UserID)
        {
            IDbDataParameter[] param = new[]
            {
                   dataContext.CreateParameter(DbType.Int32,"uid", 200, UserID, ParameterDirection.InputOutput),
            };
            var dtCommitteeList = dataContext.GetDataTable(@"SELECT * FROM get_userdetailbyid(:uid)", commandType: CommandType.Text, param);
            IEnumerable<UserInfoResposeApiModel> resposeDt = ConvertDataTableToList.DataTableToList<UserInfoResposeApiModel>(dtCommitteeList);
            return resposeDt;
        }

        public int SaveRefreshToken(RefreshToken newRefreshToken)
        {
            int retValue = 0;
            IDbDataParameter[] param = new[]
            {
                  dataContext.CreateParameter(DbType.String,"_token", 1000, newRefreshToken.Token, ParameterDirection.InputOutput),
                  dataContext.CreateParameter(DbType.String,"_jwtid", 1000, newRefreshToken.JwtId, ParameterDirection.InputOutput),
                  dataContext.CreateParameter(DbType.Date,"_createddate", 100, newRefreshToken.CreatedDate, ParameterDirection.InputOutput),
                  dataContext.CreateParameter(DbType.Date,"_expireddate", 100, newRefreshToken.ExpiredDate, ParameterDirection.InputOutput),
                  dataContext.CreateParameter(DbType.Boolean,"_isused", 100, newRefreshToken.IsUsed, ParameterDirection.InputOutput),
                  dataContext.CreateParameter(DbType.Boolean,"_invalidated", 100, newRefreshToken.Invalidated, ParameterDirection.InputOutput),
                  dataContext.CreateParameter(DbType.String,"_userid", 100, newRefreshToken.UserId, ParameterDirection.InputOutput),
            };
            retValue = dataContext.Insert(@"select * from save_refreshtoken(:_token, :_jwtid, :_createddate, :_expireddate, :_isused, :_invalidated, :_userid)", commandType: CommandType.Text, param);
            return retValue;
        }

        public RefreshToken GetRefreshTokenByToken(string token)
        {
            IDbDataParameter[] param = new[]
           {
                   dataContext.CreateParameter(DbType.String,"_token", 200, token, ParameterDirection.InputOutput),
             };
            var dtList = dataContext.GetDataTable(@"SELECT * FROM get_userrefreshtokendetailbytoken(:_token)", commandType: CommandType.Text, param);
            RefreshToken rtkn = new RefreshToken();
            rtkn.Token = dtList.Rows[0]["token"].ToString();
            rtkn.JwtId = dtList.Rows[0]["jwtid"].ToString();
            rtkn.CreatedDate = Convert.ToDateTime(dtList.Rows[0]["createddate"]);
            rtkn.ExpiredDate = Convert.ToDateTime(dtList.Rows[0]["expireddate"]);
            rtkn.IsUsed = Convert.ToBoolean(dtList.Rows[0]["isused"]);
            rtkn.Invalidated = Convert.ToBoolean(dtList.Rows[0]["invalidated"]);
            rtkn.UserId = dtList.Rows[0]["userid"].ToString();
            return rtkn;
        }

        public int UpdateRefreshToken(string token, bool IsUsed)
        {
            int retValue = 0;
            IDbDataParameter[] param = new[]
            {
                  dataContext.CreateParameter(DbType.Boolean,"_isused", 1000, IsUsed, ParameterDirection.InputOutput),
                  dataContext.CreateParameter(DbType.String,"_token", 1000, token, ParameterDirection.InputOutput),
            };
            retValue = dataContext.Insert(@"select * from update_refreshtoken(:_isused, :_token)", commandType: CommandType.Text, param);
            return retValue;
        }

        public async Task<int> VaidateEmailCheck(string UserEmailID)
        {
            IDbDataParameter[] param = new[]
                {
                  dataContext.CreateParameter(DbType.String,"useremailid", 200, UserEmailID, ParameterDirection.InputOutput),
                };
            int ResultDT = dataContext.Update(@"select * from validateemail(:useremailid)", commandType: CommandType.Text, param);

            return ResultDT;
        }

        public async Task<int> UpdateIEAdditionalInfo(IEUpdateAddlInfoRequestApiModel iEUpdateAddlInfo)
        {
            int filerID = 0;
            IDbDataParameter[] param = new[]
            {
                dataContext.CreateParameter(DbType.Int32,"contactId", 200, iEUpdateAddlInfo.ContactId, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.String,"filerType", 200, iEUpdateAddlInfo.FilerType, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.String,"occupationDesc", 200, iEUpdateAddlInfo.Occupation, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.String,"employer", 200, iEUpdateAddlInfo.Employer, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.String,"organisationName", 200, iEUpdateAddlInfo.OrganisationName, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.String,"userId", 200, "", ParameterDirection.InputOutput),
            };

            StringBuilder sbQuery = new StringBuilder();
            sbQuery.Clear();

            sbQuery.AppendLine("select * from update_IEAddlInfo(");
            sbQuery.AppendLine(":contactId, ");
            sbQuery.AppendLine(":filerType, ");
            sbQuery.AppendLine(":occupationDesc, ");
            sbQuery.AppendLine(":employer, ");
            sbQuery.AppendLine(":organisationName, ");
            sbQuery.AppendLine(":userId)");

            int response = dataContext.Update(sbQuery.ToString(), commandType: CommandType.Text, param);


            IDbDataParameter[] paramf = new[]
         {
                  dataContext.CreateParameter(DbType.String,"_entitytype", 1000, "IE", ParameterDirection.Input),
                  dataContext.CreateParameter(DbType.Int32,"_entityid", 150, iEUpdateAddlInfo.ContactId,  ParameterDirection.Input),
                  dataContext.CreateParameter(DbType.Int32,"_categoryid", 150, 4,  ParameterDirection.Input),
                  dataContext.CreateParameter(DbType.String,"_filerstatus", 150, "A",  ParameterDirection.Input),
                };
            filerID = dataContext.Insert(@"select * from save_filer(:_entitytype, :_entityid, :_categoryid, :_filerstatus)", commandType: CommandType.Text, paramf);

            IDbDataParameter[] paramcrmm = new[]
{
                  dataContext.CreateParameter(DbType.Int32,"_contactid", 200, iEUpdateAddlInfo.ContactId,  ParameterDirection.Input),
                  dataContext.CreateParameter(DbType.Int32,"_filerid", 150, filerID,  ParameterDirection.Input),
                };
            int contactrolemappingidd = dataContext.Update(@"select * from save_contactrolemappingie( :_contactid, :_filerid)", commandType: CommandType.Text, paramcrmm);

            return response;
        }

        public async Task<UserEntitiesResponseApiModel> GetUserEntites(int userId)
        {
            UserEntitiesResponseApiModel userEntities = new UserEntitiesResponseApiModel();

            IDbDataParameter[] param = new[]
            {
                dataContext.CreateParameter(DbType.Int32,"userId", 200, userId, ParameterDirection.InputOutput),
            };
            var dtUserEntity = dataContext.GetDataTable(@"SELECT * FROM get_userentities(:userId)", commandType: CommandType.Text, param);

            string expression = String.Format("TRIM(entitytype) = '{0}'", "L");
            DataRow[] lobbyists = dtUserEntity.Select(expression);
            DataTable dtLobbyist = lobbyists.Length > 0 ? lobbyists.CopyToDataTable() : new DataTable();
            IEnumerable<UserEntity> resposeLobbyistDt = ConvertDataTableToList.DataTableToList<UserEntity>(dtLobbyist);

            expression = String.Format("TRIM(entitytype) = '{0}'", "C");
            DataRow[] committees = dtUserEntity.Select(expression);
            DataTable dtCommittee = committees.Length > 0 ? committees.CopyToDataTable() : null;
            IEnumerable<UserEntity> resposeCommitteeDt = ConvertDataTableToList.DataTableToList<UserEntity>(dtCommittee);

            expression = String.Format("TRIM(entitytype) = '{0}'", "IE");
            DataRow[] ie = dtUserEntity.Select(expression);
            DataTable dtIE = ie.Length > 0 ? ie.CopyToDataTable() : null;
            IEnumerable<UserEntity> resposeIEDt = ConvertDataTableToList.DataTableToList<UserEntity>(dtIE);

            expression = String.Format("TRIM(entitytype) = '{0}'", "CO");
            DataRow[] coveredOfficials = dtUserEntity.Select(expression);
            DataTable dtCoveredOfficial = coveredOfficials.Length > 0 ? coveredOfficials.CopyToDataTable() : null;
            IEnumerable<UserEntity> resposeCODt = ConvertDataTableToList.DataTableToList<UserEntity>(dtCoveredOfficial);

            userEntities.Lobbyists = resposeLobbyistDt;
            userEntities.Committees = resposeCommitteeDt;
            userEntities.IndependentExp = resposeIEDt;
            userEntities.CoveredOfficials = resposeCODt;

            return userEntities;
        }

        public async Task<List<RolesandTypesApiModel>> GetUserRoles(int userId)
        {
            List<RolesandTypesApiModel> RolesandTypesss = new List<RolesandTypesApiModel>();

            IDbDataParameter[] paramm = new[]
            {
                dataContext.CreateParameter(DbType.Int32,"_userid", 100, userId, ParameterDirection.InputOutput),
            };
            var resDdt = dataContext.GetDataTable(@"select * from get_rolesandtypes(:_userid)", commandType: CommandType.Text, paramm);

            IEnumerable<RolesandTypesApiModel> resDt = ConvertDataTableToList.DataTableToList<RolesandTypesApiModel>(resDdt);
            foreach (var resres in resDt)
            {
                RolesandTypesss.Add(new RolesandTypesApiModel
                {
                    RoleID = resres.RoleID,
                    Role = resres.Role,
                    EntityID = resres.EntityID,
                    EntityType = resres.EntityType,
                    EntityName = resres.EntityName
                });
            }
            return RolesandTypesss;
        }

        public async Task<UserEntityDetailsResponseApiModel> GetUserEntityDetails(int entityId, string entityType)
        {
            IDbDataParameter[] param = new[]
             {
                dataContext.CreateParameter(DbType.Int32,"_entityid", 200, entityId, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.String,"_entitytype", 200, entityType, ParameterDirection.InputOutput),
            };
            var dtUserEntity = dataContext.GetDataTable(@"SELECT * FROM get_userentitydetail(:_entityid, :_entitytype)", commandType: CommandType.Text, param);

            UserEntityDetailsResponseApiModel resposeDt = ConvertDataTableToList.ToClass<UserEntityDetailsResponseApiModel>(dtUserEntity);

            return resposeDt;

        }

        public async Task<IEnumerable<ManageFilersResponseApiModel>> GetManageFilers(ManageFilersRequestApiModel manageFilerRequest)
        {
            IDbDataParameter[] param = new[]
             {
                dataContext.CreateParameter(DbType.String,"fname", 200, manageFilerRequest.FilerName, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.String,"ftype", 200, manageFilerRequest.FilerType, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.String,"fstatus", 200, manageFilerRequest.FilerStatus, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.Date,"lsstartdate", 200, manageFilerRequest.StartDate, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.Date,"lsenddate", 200, manageFilerRequest.EndDate, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.String,"ctype", 200, manageFilerRequest.CommitteeType, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.String,"otype", 200, manageFilerRequest.OfficeType, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.Date,"edate", 200, manageFilerRequest.ElectionDate, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.String,"publicfundstatus", 200, manageFilerRequest.PublicFundStatus, ParameterDirection.InputOutput),
            };
            StringBuilder sbQuery = new StringBuilder();
            sbQuery.Clear();
            sbQuery.AppendLine(@"SELECT * FROM get_managefiler(");
            sbQuery.AppendLine(":fname, ");
            sbQuery.AppendLine(":ftype, ");
            sbQuery.AppendLine(":fstatus, ");
            sbQuery.AppendLine(":lsstartdate, ");
            sbQuery.AppendLine(":lsenddate, ");
            sbQuery.AppendLine(":ctype, ");
            sbQuery.AppendLine(":otype, ");
            sbQuery.AppendLine(":edate, ");
            sbQuery.AppendLine(":publicfundstatus)");

            var dtManageFilers = dataContext.GetDataTable(sbQuery.ToString(), commandType: CommandType.Text, param);

            IEnumerable<ManageFilersResponseApiModel> resposeDt = ConvertDataTableToList.DataTableToList<ManageFilersResponseApiModel>(dtManageFilers);

            return resposeDt;

        }

        public async Task<int> SaveIndependentSpenderAffiliation(IndependentSpendersAffiliationApiModel independentSpenderAffiliation)
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
            foreach (IndependentSpenderAffiliationDetailApiModel ieid in independentSpenderAffiliation.IndependentSpenderIds)
            {
                IDbDataParameter[] paramu = new[]
                {
                  dataContext.CreateParameter(DbType.String,"_requesttype", 100, "R", ParameterDirection.Input),
                  dataContext.CreateParameter(DbType.String,"_useremail", 150, "",  ParameterDirection.Input),
                  dataContext.CreateParameter(DbType.Int32,"_usercontactid", 150, independentSpenderAffiliation.ContactID,  ParameterDirection.Input),
                  dataContext.CreateParameter(DbType.Int32, "_invitercontactid", 100, 0,  ParameterDirection.Input),
                  dataContext.CreateParameter(DbType.Int32, "_emailmessageid", 100, emailMessageId,  ParameterDirection.Input),
                  dataContext.CreateParameter(DbType.String, "_userjoinnote", 1000, independentSpenderAffiliation.Notes,  ParameterDirection.Input),
                  dataContext.CreateParameter(DbType.Int32, "_ieid", 100, ieid.IndependentSpenderID,  ParameterDirection.Input),
                };
                int userJoinRequestId = dataContext.Update(@"select * from save_userjoinrequestie(:_requesttype, :_useremail, :_usercontactid, :_invitercontactid, :_emailmessageid, :_userjoinnote, :_ieid)", commandType: CommandType.Text, paramu);
            }

            return emailMessageId;
        }

        public async Task<List<GetLobbyistEmployee>> GetIndependentSpender(int independentSpenderId)
        {
            IDbDataParameter[] param = new[]
              {
                  dataContext.CreateParameter(DbType.Int32,"_ieid", 100, independentSpenderId, ParameterDirection.InputOutput),
               };
            DataTable ResultDT = dataContext.GetDataTable(@"select * from get_independentspender(:_ieid)", commandType: CommandType.Text, param);

            List<GetLobbyistEmployee> employeelist = tableConverter.ConvertToList<GetLobbyistEmployee>(ResultDT);
            return employeelist;
        }

        public async Task<List<string>> GetFilerNamesByName(string searchName)
        {
            IDbDataParameter[] param = new[]
            {
                dataContext.CreateParameter(DbType.String,"fname", 200, searchName, ParameterDirection.InputOutput),
            };

            var dtfilerName = dataContext.GetDataTable(@"SELECT * FROM get_filerbyname(:fname)", commandType: CommandType.Text, param);

            List<string> response = dtfilerName.Rows.OfType<DataRow>().Select(dr => (string)dr["filerName"]).ToList();

            return response;
        }

        public async Task<int> FilerInviteUser(AddUserPaymentApiModel addUserPayment)
        {
            int Id = 0;
            IDbDataParameter[] param = new[]
            {
                  dataContext.CreateParameter(DbType.String,"_emailId", 100, addUserPayment.EmailId,  ParameterDirection.InputOutput),
                  dataContext.CreateParameter(DbType.Int32,"_Entity_id", 100, addUserPayment.Entity_id,  ParameterDirection.InputOutput),
                  dataContext.CreateParameter(DbType.String,"_Entity_Type", 100, addUserPayment.Entity_Type,  ParameterDirection.InputOutput),
                };
            Id = dataContext.Insert(@"select * from save_adduserdetails(:_emailId,:_Entity_id,:_Entity_Type)", commandType: CommandType.Text, param);
            return Id;
		}
        public async Task<List<GetCurrentUser>> GetFilerUsers(int entityId, string entityType)
        {
            IDbDataParameter[] param = new[]
              {
                  dataContext.CreateParameter(DbType.Int32,"_entityid", 100, entityId, ParameterDirection.InputOutput),
                  dataContext.CreateParameter(DbType.String,"_entitytype", 100, entityType, ParameterDirection.InputOutput),

               };
            DataTable ResultDT = dataContext.GetDataTable(@"select * from get_currentuserfilers(:_entityid, :_entitytype)", commandType: CommandType.Text, param);
            List<GetCurrentUser> currentUserList = tableConverter.ConvertToList<GetCurrentUser>(ResultDT);
            return currentUserList;
        }

        public async Task<int> DeleteFilerContact(int contactId, int filerId)
        {
            IDbDataParameter[] param = new[]
                {
                  dataContext.CreateParameter(DbType.Int32,"_contactid", 100, contactId, ParameterDirection.InputOutput),
                   dataContext.CreateParameter(DbType.Int32,"_filerid", 100, filerId, ParameterDirection.InputOutput),
                };
            int res = dataContext.Delete(@"select * from delete_currentfilercontact(:_contactid, :_filerid)", commandType: CommandType.Text, param);
            return res;
        }

        public async Task<IEnumerable<MakeTreasurerApiModel>> SaveMakeTreasurer(MakeTreasurerApiModel addMakeTreasurer)
        {
            int Id = 0;
            IDbDataParameter[] param = new[]
               {
                  dataContext.CreateParameter(DbType.Int32,"_contactid", 100, addMakeTreasurer.ContactID,  ParameterDirection.InputOutput),
                  dataContext.CreateParameter(DbType.Int32,"_entityid", 100, addMakeTreasurer.EntityId,  ParameterDirection.InputOutput),
                  dataContext.CreateParameter(DbType.String,"_entitytype", 100, addMakeTreasurer.EntityType,  ParameterDirection.InputOutput),
                  dataContext.CreateParameter(DbType.Int32,"_userid", 100, addMakeTreasurer.UserID,  ParameterDirection.InputOutput),
               };
            DataTable ResultDT = dataContext.GetDataTable(@"select * from save_maketreasurer(:_contactid, :_entityid, :_entitytype, :_userid)", commandType: CommandType.Text, param);
            List<MakeTreasurerApiModel> currentUserList = tableConverter.ConvertToList<MakeTreasurerApiModel>(ResultDT);
            return currentUserList;
        }
        public async Task<List<GetAdminUsers>> GetFilerAdminUsers(int filerId, int userId, string filerType, string status, DateTime lastActiveStartDate, DateTime lastActiveEndDate, DateTime createdStartDate, DateTime createdEndDate)
        {

            IDbDataParameter[] param = new[]
              {
                  dataContext.CreateParameter(DbType.Int32,"_filerid", 100, filerId, ParameterDirection.InputOutput),
                  dataContext.CreateParameter(DbType.Int32,"_userid", 100, userId, ParameterDirection.InputOutput),
                  dataContext.CreateParameter(DbType.String,"_filertype", 100, string.IsNullOrEmpty(filerType) ? "" : filerType, ParameterDirection.InputOutput),
                  dataContext.CreateParameter(DbType.String,"_status", 100, string.IsNullOrEmpty(status) ? "" : status, ParameterDirection.InputOutput),
                  dataContext.CreateParameter(DbType.Date,"_lastactivestartdate", 100,  lastActiveStartDate , ParameterDirection.InputOutput),
                  dataContext.CreateParameter(DbType.Date, "_lastactiveenddate", 100,  lastActiveEndDate, ParameterDirection.InputOutput),
                  dataContext.CreateParameter(DbType.Date, "_createdstartdate", 100,  createdStartDate, ParameterDirection.InputOutput),
                  dataContext.CreateParameter(DbType.Date,"_createdenddate", 100,  createdEndDate, ParameterDirection.InputOutput),
               };
            DataTable ResultDT = dataContext.GetDataTable(@"select * from get_currentactiveusers(:_filerid, :_userid, :_filertype,:_status,:_lastactivestartdate,:_lastactiveenddate,:_createdstartdate,:_createdenddate)", commandType: CommandType.Text, param);
            List<GetAdminUsers> currentUserList = tableConverter.ConvertToList<GetAdminUsers>(ResultDT);
            return currentUserList;
        }
        public async Task<List<GetAdminUsers>> GetUserAffiliations(int filerId, int userId, string filerType, string status, DateTime lastActiveStartDate, DateTime lastActiveEndDate, DateTime createdStartDate, DateTime createdEndDate)
        {

            IDbDataParameter[] param = new[]
              {
                  dataContext.CreateParameter(DbType.Int32,"_filerid", 100, filerId, ParameterDirection.InputOutput),
                  dataContext.CreateParameter(DbType.Int32,"_userid", 100, userId, ParameterDirection.InputOutput),
                  dataContext.CreateParameter(DbType.String,"_filertype", 100, string.IsNullOrEmpty(filerType) ? "" : filerType, ParameterDirection.InputOutput),
                  dataContext.CreateParameter(DbType.String,"_status", 100, string.IsNullOrEmpty(status) ? "" : status, ParameterDirection.InputOutput),
                  dataContext.CreateParameter(DbType.Date,"_lastactivestartdate", 100,  lastActiveStartDate , ParameterDirection.InputOutput),
                  dataContext.CreateParameter(DbType.Date, "_lastactiveenddate", 100,  lastActiveEndDate, ParameterDirection.InputOutput),
                  dataContext.CreateParameter(DbType.Date, "_createdstartdate", 100,  createdStartDate, ParameterDirection.InputOutput),
                  dataContext.CreateParameter(DbType.Date,"_createdenddate", 100,  createdEndDate, ParameterDirection.InputOutput),
               };
            DataTable ResultDT = dataContext.GetDataTable(@"select * from get_useraffiliations(:_filerid, :_userid, :_filertype,:_status,:_lastactivestartdate,:_lastactiveenddate,:_createdstartdate,:_createdenddate)", commandType: CommandType.Text, param);
            List<GetAdminUsers> currentUserList = tableConverter.ConvertToList<GetAdminUsers>(ResultDT);
            return currentUserList;
        }

    }
}
