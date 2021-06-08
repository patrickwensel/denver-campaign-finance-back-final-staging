using Denver.Infra.Constants;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Text;
using System.Threading.Tasks;
using UserManagementApi.Domain.ApiModels;
using UserManagementApi.Domain.Repositories;
using UserManagementApi.Domain.ViewModels;

namespace UserManagementApi.Domain.Service
{
    public partial class UserManagementService
    {
        public async Task<List<EmployeeList>> GetEmployees(int lobbyistId)
        {
            return await _lobbyistRepository.GetEmployees(lobbyistId);
        }
        public async Task<int> SaveLobbyist(LobbyistApiModel saveLobbyist)
        {
            return await _lobbyistRepository.SaveLobbyist(saveLobbyist);
        }
        public async Task<int> SaveLobbyistAffiliation(LobbyistAffiliationApiModel lobbyistAffiliation)
        {
            return await _lobbyistRepository.SaveLobbyistAffiliation(lobbyistAffiliation);
        }
        public async Task<int> UpdateLobbyistSignature(LobbyistSignatureApiModel lobbyistSignature)
        {
            return await _lobbyistRepository.UpdateLobbyistSignature(lobbyistSignature);
        }

        public async Task<List<LobbyistEntitiesResponseApiModel>> GetLobbyistEntities(int lobbyistId, string roleType)
        {
            switch (roleType)
            {
                case Constants.LOB_EMP:
                    roleType = "Lobbyist Employee";
                    break;
                case Constants.LOB_SUB:
                    roleType = "Lobbyist Subcontractor";
                    break;
                case Constants.LOB_CLI:
                    roleType = "Lobbyist Client";
                    break;
                case Constants.LOB_REL:
                    roleType = "Lobbyist Relationship";
                    break;
            }
            return await _lobbyistRepository.GetLobbyistEntities(lobbyistId, roleType);
        }

        public async Task<List<GetLobbyistEmployee>> GetLobbyist(int lobbyistId)
        {
            return await _lobbyistRepository.GetLobbyist(lobbyistId);
        }

        public async Task<List<LobbyistEntitiesResponseApiModel>> GetLobbyistEntitiesbyName(int LobbyistId, string SearchName, string RoleType)
        {
            switch (RoleType)
            {
                case Constants.LOB_EMP:
                    RoleType = "Lobbyist Employee";
                    break;
                case Constants.LOB_SUB:
                    RoleType = "Lobbyist Subcontractor";
                    break;
                case Constants.LOB_CLI:
                    RoleType = "Lobbyist Client";
                    break;
                case Constants.LOB_REL:
                    RoleType = "Lobbyist Relationship";
                    break;
            }
            return await _lobbyistRepository.GetLobbyistEntitiesbyName(LobbyistId, SearchName, RoleType);
        }

        public async Task<int> SaveEmployee(LobbyistEmployeeRequestApiModel lobbyistEmployee)
        {
            return await _lobbyistRepository.SaveEmployee(lobbyistEmployee);
        }

        public async Task<int> DeleteEmployee(int contactId)
        {
            return await _lobbyistRepository.DeleteEmployee(contactId);
        }


        public async Task<int> SaveSubcontractor(LobbyistSubcontractorRequestApiModel lobbyistSubcontractor)
        {
            return await _lobbyistRepository.SaveSubcontractor(lobbyistSubcontractor);
        }

        public async Task<int> DeleteSubcontractor(int contactId)
        {
            return await _lobbyistRepository.DeleteSubcontractor(contactId);
        }

        public async Task<int> SaveClient(LobbyistClientApiModel lobbyistClient)
        {
            return await _lobbyistRepository.SaveClient(lobbyistClient);
        }

        public async Task<int> DeleteClient(int contactId)
        {
            return await _lobbyistRepository.DeleteClient(contactId);
        }

        public async Task<int> SaveRelationship(LobbyistRelationshipRequestApiModel lobbyistRelationship)
        {
            return await _lobbyistRepository.SaveRelationship(lobbyistRelationship);
        }

        public async Task<int> DeleteRelationship(int contactId)
        {
            return await _lobbyistRepository.DeleteRelationship(contactId);
        }
        public async Task<LobbyistSignatureDetailApiModel> GetLobbyistSignature(int lobbyistId)
        {
            return await _lobbyistRepository.GetLobbyistSignature(lobbyistId);
        }
        public async Task<LobbyistContactInfoApiModel> GetLobbyistContactInformation(int lobbyistId)
        {
            return await _lobbyistRepository.GetLobbyistContactInformation(lobbyistId);
        }
    }
}
