using System;
using System.Collections.Generic;
using System.Text;
using System.Threading.Tasks;
using UserManagementApi.Domain.ApiModels;
using UserManagementApi.Domain.ViewModels;

namespace UserManagementApi.Domain.Repositories
{
    public interface ILobbyistRepository
    {
        Task<int> CreateLobbyistEmployee(LobbyistOldApiModel contactinfo);
        Task<int> UpdateLobbyistEmployee(LobbyistOldApiModel contactinfo);
        Task<int> DeleteLobbyistEmployee(int LobbyistEmployeeID);
        Task<List<EmployeeList>> GetEmployees(int lobbyistId);
        Task<int> SaveLobbyist(LobbyistApiModel saveLobbyist);
        Task<int> SaveLobbyistAffiliation(LobbyistAffiliationApiModel lobbyistAffiliation);
        Task<int> UpdateLobbyistSignature(LobbyistSignatureApiModel lobbyistSignature);
        Task<List<LobbyistEntitiesResponseApiModel>> GetLobbyistEntities(int lobbyistId, string roleType);
        Task<List<GetLobbyistEmployee>> GetLobbyist(int lobbyistId);
        Task<List<LobbyistEntitiesResponseApiModel>> GetLobbyistEntitiesbyName(int lobbyistId, string searchName, string roleType);
        Task<int> SaveEmployee(LobbyistEmployeeRequestApiModel lobbyistEmployee);
        Task<int> DeleteEmployee(int contactId);
        Task<int> SaveSubcontractor(LobbyistSubcontractorRequestApiModel lobbyistSubcontractor);
        Task<int> DeleteSubcontractor(int contactId);
        Task<int> SaveClient(LobbyistClientApiModel lobbyistClient);
        Task<int> DeleteClient(int contactId);
        Task<int> SaveRelationship(LobbyistRelationshipRequestApiModel lobbyistRelationship);
        Task<int> DeleteRelationship(int contactId);
        Task<LobbyistSignatureDetailApiModel> GetLobbyistSignature(int lobbyistId);
        Task<LobbyistContactInfoApiModel> GetLobbyistContactInformation(int lobbyistId);
    }
}
