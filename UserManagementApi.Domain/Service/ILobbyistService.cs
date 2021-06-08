using System;
using System.Collections.Generic;
using System.Text;
using System.Threading.Tasks;
using UserManagementApi.Domain.ApiModels;
using UserManagementApi.Domain.ViewModels;

namespace UserManagementApi.Domain.Service
{
    public interface ILobbyistService
    {
        Task<int> CreateLobbyistEmployee(LobbyistOldApiModel lobbyinfo);
        Task<int> UpdateLobbyistEmployee(LobbyistOldApiModel lobbyinfo);
        //Task<int> DeleteLobbyistEmployee(int LobbyistEmployeeID);
        //Task<List<LobbyistApiModel>> GetLobbyistEmployeebyID(int LobbyistEmployeeID);
        //Task<List<LobbyistApiModel>> GetLobbyistEmployeebyList();
        Task<List<EmployeeList>> GetEmployees(int lobbyistId);
        Task<int> UpdateLobbyistSignature(LobbyistSignatureApiModel lobbyistSignature);
        Task<List<GetLobbyistEmployee>> GetLobbyist(int lobbyistId);

        Task<int> SaveEmployee(LobbyistEmployeeRequestApiModel lobbyistEmployee);
        Task<int> DeleteEmployee(int contactId, string userId);
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
