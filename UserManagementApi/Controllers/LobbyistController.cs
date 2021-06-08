using Denver.Common;
using Denver.Infra.Constants;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Threading.Tasks;
using UserManagementApi.Configurations;
using UserManagementApi.Domain.ApiModels;
using UserManagementApi.Domain.ViewModels;
using UserManagementApi.Domain.ApiModels.Committee;
using UserManagementApi.Domain.Entities;
using UserManagementApi.Domain.Entities.Committee;
using UserManagementApi.Domain.Service;
using UserManagementApi.Domain.ViewModels;
using Denver.Infra;

namespace UserManagementApi.Controllers
{
    [ApiController]
    public class LobbyistController : BaseController
    {
        private readonly AppSettings _appSettings;

        public LobbyistController(IUserManagementService iUserService, ILogger<LobbyistController> logger, AppSettings appSettings) : base(iUserService, logger)
        {
            _appSettings = appSettings;
        }

        #region New

        /// <summary>
        /// createLobbyist - Save Lobbyist Details
        /// </summary>
        /// <param name="saveLobbyist"></param>
        /// <returns></returns>
        [HttpPost("saveLobbyist")]
        [AllowAnonymous]
        public async Task<List<ApiResponse<bool>>> SaveLobbyist([FromBody] LobbyistApiModel saveLobbyist)
        {
            

            if (saveLobbyist.ContactID == 0)
            {
                LoggedInUser loggedInUser = this.GetLoggedInUser();
                saveLobbyist.ContactID = Convert.ToInt32(loggedInUser.ContactId);
            }
            if (!ModelState.IsValid)
            {
                throw new ValidationException(ValidationMessage.InvalidInput, null, ModelState.Values.SelectMany(x => x.Errors.Select(y => y.ErrorMessage)).ToList());
            }
            int response = await _iService.SaveLobbyist(saveLobbyist);
            return response != 0 ? CreateRespWithreturnCollection(response) : GeneralErrorResponse();
        }

        [HttpPut("UpdateLobbyistSignature")]
        [AllowAnonymous]

        public async Task<List<ApiResponse<bool>>> UpdateLobbyistSignature([FromBody] LobbyistSignatureApiModel lobbyistSignature)
        {
            if (!ModelState.IsValid)
            {
                throw new ValidationException(ValidationMessage.InvalidInput, null, ModelState.Values.SelectMany(x => x.Errors.Select(y => y.ErrorMessage)).ToList());
            }
            int response = await _iService.UpdateLobbyistSignature(lobbyistSignature);
            return response != 0 ? CreateRespWithreturnCollectionForU(response) : GeneralErrorResponse();
        }

        ///// <summary>
        ///// getEmployees - Employee List
        ///// </summary>
        ///// <param name="getEmployees"></param>
        ///// <returns></returns>
        //[HttpGet("getEmployees")]
        //[AllowAnonymous]
        //public async Task<List<EmployeeList>> getEmployees(int lobbyistId)
        //{
        //    List<EmployeeList> employees = await _iService.GetEmployees(lobbyistId);
        //    return employees;
        //}

        /// <summary>
        /// SaveLobbyistAffiliation - Map Contact and Lobbyist
        /// </summary>
        /// <param name="lobbyistAffiliation"></param>
        /// <returns></returns>
        [HttpPost("SaveLobbyistAffiliation")]
        [AllowAnonymous]
        public async Task<List<ApiResponse<bool>>> SaveLobbyistAffiliation([FromBody] LobbyistAffiliationApiModel lobbyistAffiliation)
        {
            

            if (lobbyistAffiliation.ContactID == 0)
            {
                LoggedInUser loggedInUser = this.GetLoggedInUser();
                lobbyistAffiliation.ContactID = Convert.ToInt32(loggedInUser.ContactId);
            }
            if (!ModelState.IsValid)
            {
                throw new ValidationException(ValidationMessage.InvalidInput, null, ModelState.Values.SelectMany(x => x.Errors.Select(y => y.ErrorMessage)).ToList());
            }
            int response = await _iService.SaveLobbyistAffiliation(lobbyistAffiliation);
            return response != 0 ? CreateRespWithreturnCollectionForU(response) : GeneralErrorResponse();
        }

        #region getLobbyistEntities
        /// <summary>
        /// getEmployees - Employee List
        /// </summary>
        /// <param name="getEmployees"></param>
        /// <returns></returns>
        [HttpGet("getLobbyistEntities")]
        [AllowAnonymous]
        public async Task<List<LobbyistEntitiesResponseApiModel>> getLobbyistEntities(int lobbyistId, string roleType)
        {
            List<LobbyistEntitiesResponseApiModel> response = await _iService.GetLobbyistEntities(lobbyistId, roleType);
            return response;
        }



        #endregion getLobbyistEntities


        [HttpGet("GetLobbyist")]
        [AllowAnonymous]
        public async Task<List<GetLobbyistEmployee>> GetLobbyist(int lobbyistId)
        {
            List<GetLobbyistEmployee> employees = await _iService.GetLobbyist(lobbyistId);
            return employees;
        }

        /// <summary>
        /// Getclient - Retrieve Lobbyistclientdetail based on the Name
        /// </summary>
        /// <param name="searchLobby"></param>
        /// <returns></returns>
        [HttpGet("GetLobbyistByName")]
        [AllowAnonymous]
        public async Task<ActionResult> GetLobbyistByName(string searchLobbyName)
        {
            return Ok(await _iService.GetLobbyListByName(searchLobbyName));
        }

        /// <summary>
        /// getLobbysitByName - Employee List
        /// </summary>
        /// <param name="lobbyistId"></param>
        /// <param name="searchName"></param>
        /// <param name="roleType"></param>
        /// <returns></returns>
        [HttpGet("getLobbyistEntitiesbyName")]
        [AllowAnonymous]
        public async Task<List<LobbyistEntitiesResponseApiModel>> getLobbyistEntitiesbyName(int lobbyistId, string searchName, string roleType)
        {
            List<LobbyistEntitiesResponseApiModel> response = await _iService.GetLobbyistEntitiesbyName(lobbyistId, searchName, roleType);
            return response;
        }

        #region saveEmployee
        /// <summary>
        /// saveEmployee - Save Employee details
        /// </summary>
        /// <param name="lobbyistEmployee"></param>
        /// <returns></returns>
        [HttpPost("saveEmployee")]
        [AllowAnonymous]
        public async Task<List<ApiResponse<bool>>> SaveEmployee([FromBody] LobbyistEmployeeRequestApiModel lobbyistEmployee)
        {
            if (!ModelState.IsValid)
            {
                throw new ValidationException(ValidationMessage.InvalidInput, null, ModelState.Values.SelectMany(x => x.Errors.Select(y => y.ErrorMessage)).ToList());
            }
            int response = await _iService.SaveEmployee(lobbyistEmployee);
            return response != 0 ? CreateRespWithreturnCollection(response) : GeneralErrorResponse();
        }
        #endregion saveEmployee

        #region deleteEmployee
        /// <summary>
        /// DeleteEmployee - Delete Employee details
        /// </summary>
        /// <param name="contactId"></param>
        /// <returns></returns>
        [HttpPost("deleteEmployee")]
        [AllowAnonymous]
        public async Task<List<ApiResponse<bool>>> DeleteEmployee(int contactId)
        {
            int response = await _iService.DeleteEmployee(contactId);
            return response != 0 ? CreateRespWithreturnCollectionForD(response) : GeneralErrorResponse();
        }
        #endregion deleteEmployee

        #region saveSubcontractor
        /// <summary>
        /// saveEmployee - Save Employee details
        /// </summary>
        /// <param name="lobbyistEmployee"></param>
        /// <returns></returns>
        [HttpPost("saveSubcontractor")]
        [AllowAnonymous]
        public async Task<List<ApiResponse<bool>>> SaveSubcontractor([FromBody] LobbyistSubcontractorRequestApiModel lobbyistSubcontractor)
        {
            if (!ModelState.IsValid)
            {
                throw new ValidationException(ValidationMessage.InvalidInput, null, ModelState.Values.SelectMany(x => x.Errors.Select(y => y.ErrorMessage)).ToList());
            }
            int response = await _iService.SaveSubcontractor(lobbyistSubcontractor);
            return response != 0 ? CreateRespWithreturnCollection(response) : GeneralErrorResponse();
        }
        #endregion saveSubcontractor

        #region deleteSubcontractor
        /// <summary>
        /// DeleteSubcontractor - Delete Subcontractor details
        /// </summary>
        /// <param name="contactId"></param>
        /// <returns></returns>
        [HttpPost("deleteSubcontractor")]
        [AllowAnonymous]
        public async Task<List<ApiResponse<bool>>> DeleteSubcontractor(int contactId)
        {
            int response = await _iService.DeleteSubcontractor(contactId);
            return response != 0 ? CreateRespWithreturnCollectionForD(response) : GeneralErrorResponse();
        }
        #endregion deleteSubcontractor

        #region saveClient
        /// <summary>
        /// saveEmployee - Save Client details
        /// </summary>
        /// <param name="lobbyistClient"></param>
        /// <returns></returns>
        [HttpPost("saveClient")]
        [AllowAnonymous]
        public async Task<List<ApiResponse<bool>>> SaveClient([FromBody] LobbyistClientApiModel lobbyistClient)
        {
            if (!ModelState.IsValid)
            {
                throw new ValidationException(ValidationMessage.InvalidInput, null, ModelState.Values.SelectMany(x => x.Errors.Select(y => y.ErrorMessage)).ToList());
            }
            int response = await _iService.SaveClient(lobbyistClient);
            return response != 0 ? CreateRespWithreturnCollection(response) : GeneralErrorResponse();
        }
        #endregion saveClient

        #region deleteClient
        /// <summary>
        /// DeleteSubcontractor - Delete Subcontractor details
        /// </summary>
        /// <param name="contactId"></param>
        /// <param name="userId"></param>
        /// <returns></returns>
        [HttpPost("deleteClient")]
        [AllowAnonymous]
        public async Task<List<ApiResponse<bool>>> DeleteClient(int contactId)
        {
            int response = await _iService.DeleteClient(contactId);
            return response != 0 ? CreateRespWithreturnCollectionForD(response) : GeneralErrorResponse();
        }
        #endregion deleteEmployee

        #region saveRelationship
        /// <summary>
        /// saveEmployee - Save Relationship details
        /// </summary>
        /// <param name="lobbyistRelationship"></param>
        /// <returns></returns>
        [HttpPost("saveRelationship")]
        [AllowAnonymous]
        public async Task<List<ApiResponse<bool>>> SaveRelationship([FromBody] LobbyistRelationshipRequestApiModel lobbyistRelationship)
        {
            if (!ModelState.IsValid)
            {
                throw new ValidationException(ValidationMessage.InvalidInput, null, ModelState.Values.SelectMany(x => x.Errors.Select(y => y.ErrorMessage)).ToList());
            }
            int response = await _iService.SaveRelationship(lobbyistRelationship);
            return response != 0 ? CreateRespWithreturnCollection(response) : GeneralErrorResponse();
        }
        #endregion saveSubcontractor

        #region deleteRelationship
        /// <summary>
        /// DeleteSubcontractor - Delete Subcontractor details
        /// </summary>
        /// <param name="contactId"></param>
        /// <param name="userId"></param>
        /// <returns></returns>
        [HttpPost("deleteRelationship")]
        [AllowAnonymous]
        public async Task<List<ApiResponse<bool>>> DeleteRelationship(int contactId)
        {
            int response = await _iService.DeleteRelationship(contactId);
            return response != 0 ? CreateRespWithreturnCollectionForD(response) : GeneralErrorResponse();
        }
        #endregion deleteRelationship
        #region getLobbyistSignature
        /// <summary>
        /// getLobbyistSignature - Get Lobbyist Signature detail
        /// </summary>
        /// <param name="lobbyistId"></param>
        /// <returns>LobbyistSignatureDetailApiModel</returns>
        [HttpGet("getLobbyistSignature")]
        [AllowAnonymous]
        public async Task<LobbyistSignatureDetailApiModel> GetLobbyistSignature(int lobbyistId)
        {
            var response = await _iService.GetLobbyistSignature(lobbyistId);
            return response;
        }
        #endregion getLobbyistSignature

        #region getLobbyistContactInformation
        /// <summary>
        /// getLobbyistContactInformation - Get Lobbyist ContactInformation detail
        /// </summary>
        /// <param name="lobbyistId"></param>
        /// <returns>LobbyistContactInfoApiModel</returns>
        [HttpGet("getLobbyistContactInformation")]
        [AllowAnonymous]
        public async Task<LobbyistContactInfoApiModel> GetLobbyistContactInformation(int lobbyistId)
        {
            var response = await _iService.GetLobbyistContactInformation(lobbyistId);
            return response;
        }

        #endregion getLobbyistContactInformation

        #endregion New

        #region Old




        //#region Lobbyist_Employee
        ///// <summary>
        ///// CreateEmployee - Create LobbyistEmployee
        ///// </summary>
        ///// <param name="createLobbyistEmployee"></param>
        ///// <returns></returns>
        //[HttpPost("CreateEmployee")]
        //[AllowAnonymous]
        //public async Task<List<ApiResponse<bool>>> CreateLobbyistEmployee([FromBody] LobbyistInfo createLobbyistEmployee)
        //{
        //    if (!ModelState.IsValid)
        //    {
        //        throw new ValidationException(ValidationMessage.InvalidInput, null, ModelState.Values.SelectMany(x => x.Errors.Select(y => y.ErrorMessage)).ToList());
        //    }
        //    int response = await _iService.CreateLobbyistEmployee(createLobbyistEmployee);
        //    return response != 0 ? CreateRespWithreturnCollection(response) : GeneralErrorResponse();
        //}

        ///// <summary>
        ///// UpdateEmployee - Update LobbyistEmployee
        ///// </summary>
        ///// <param name="updateLobbyistEmployee"></param>
        ///// <returns></returns>
        //[HttpPut("UpdateEmployee")]
        //[AllowAnonymous]
        //public async Task<List<ApiResponse<bool>>> UpdateLobbyistEmployee([FromBody] LobbyistInfo updateLobbyistEmployee)
        //{
        //    if (!ModelState.IsValid)
        //    {
        //        throw new ValidationException(ValidationMessage.InvalidInput, null, ModelState.Values.SelectMany(x => x.Errors.Select(y => y.ErrorMessage)).ToList());
        //    }
        //    int response = await _iService.UpdateLobbyistEmployee(updateLobbyistEmployee);
        //    return response != 0 ? CreateRespWithreturnCollectionForU(response) : GeneralErrorResponse();
        //}


        ///// <summary>
        ///// DeleteEmployee - Delete LobbyistEmployee
        ///// </summary>
        ///// <param name="LobbyistEmployeeID"></param>
        ///// <returns></returns>
        //[HttpDelete("DeleteEmployee")]
        //[AllowAnonymous]
        //public async Task<List<ApiResponse<bool>>> DeleteLobbyistEmployee(int LobbyistEmployeeID)

        //{
        //    int response = await _iService.DeleteLobbyistUser(LobbyistEmployeeID);
        //    return response != 0 ? CreateRespWithreturnCollectionForD(response) : GeneralErrorResponse();
        //}

        /////// <summary>
        /////// GetEmployeebyID - Retrieve LobbyistEmployeedetail based on the LobbyistEmployeebyID
        /////// </summary>
        /////// <param name="LobbyistEmployeeID"></param>
        /////// <returns></returns>
        ////[HttpGet("GetEmployeebyID")]
        ////[AllowAnonymous]
        ////public async Task<List<LobbyistApiModel>> GetLobbyistEmployeebyID(int LobbyistEmployeeID)
        ////{
        ////    if (!ModelState.IsValid)
        ////    {
        ////        throw new ValidationException(ValidationMessage.InvalidInput, ModelState.Values.SelectMany(x => x.Errors.Select(y => y.ErrorMessage)).ToList());
        ////    }
        ////    List<LobbyistApiModel> responsedt = await _iService.GetLobbyistEmployeebyID(LobbyistEmployeeID);
        ////    return responsedt;
        ////}

        /////// <summary>
        /////// GetEmployeeList - Retrieve LobbyistEmployeedetail 
        /////// </summary>
        /////// <returns></returns>
        ////[HttpGet("GetEmployeeList")]
        ////[AllowAnonymous]
        ////public async Task<List<LobbyistApiModel>> GetLobbyistEmployeebyList()
        ////{
        ////    if (!ModelState.IsValid)
        ////    {
        ////        throw new ValidationException(ValidationMessage.InvalidInput, ModelState.Values.SelectMany(x => x.Errors.Select(y => y.ErrorMessage)).ToList());
        ////    }
        ////    List<LobbyistApiModel> responsedt = await _iService.GetLobbyistEmployeebyList();
        ////    return responsedt;
        ////}
        //#endregion

        //#region lobbyist_relationships
        ///// <summary>
        ///// CreateRelationship - Create LobbyistRelationship
        ///// </summary>
        ///// <param name="createLobbyistRelationship"></param>
        ///// <returns></returns>
        //[HttpPost("CreateRelationship")]
        //[AllowAnonymous]
        //public async Task<List<ApiResponse<bool>>> CreateLobbyistRelationship([FromBody] LobbyistInfo createLobbyistRelationship)
        //{
        //    if (!ModelState.IsValid)
        //    {
        //        throw new ValidationException(ValidationMessage.InvalidInput, null, ModelState.Values.SelectMany(x => x.Errors.Select(y => y.ErrorMessage)).ToList());
        //    }
        //    int response = await _iService.CreateLobbyistEmployee(createLobbyistRelationship);
        //    return response != 0 ? CreateRespWithreturnCollection(response) : GeneralErrorResponse();
        //}

        ///// <summary>
        ///// UpdateLobbyistRelationship - Update LobbyistRelationship
        ///// </summary>
        ///// <param name="updateLobbyistRelationship"></param>
        ///// <returns></returns>
        //[HttpPut("UpdateRelationship")]
        //[AllowAnonymous]
        //public async Task<List<ApiResponse<bool>>> UpdateLobbyistRelationship([FromBody] LobbyistInfo updateLobbyistRelationship)
        //{
        //    if (!ModelState.IsValid)
        //    {
        //        throw new ValidationException(ValidationMessage.InvalidInput, null, ModelState.Values.SelectMany(x => x.Errors.Select(y => y.ErrorMessage)).ToList());
        //    }
        //    int response = await _iService.UpdateLobbyistEmployee(updateLobbyistRelationship);
        //    return response != 0 ? CreateRespWithreturnCollectionForU(response) : GeneralErrorResponse();
        //}


        ///// <summary>
        ///// DeleteLobbyistRelationship - Delete LobbyistRelationship
        ///// </summary>
        ///// <param name="LobbyistRelationshipID"></param>
        ///// <returns></returns>
        //[HttpDelete("DeleteRelationship")]
        //[AllowAnonymous]
        //public async Task<List<ApiResponse<bool>>> DeleteLobbyistRelationship(int LobbyistRelationshipID)

        //{
        //    int response = await _iService.DeleteLobbyistEmployee(LobbyistRelationshipID);
        //    return response != 0 ? CreateRespWithreturnCollectionForD(response) : GeneralErrorResponse();
        //}

        /////// <summary>
        /////// GetLobbyistRelationshipID - Retrieve LobbyistRelationshipdetail based on the LobbyistRelationshipbyID
        /////// </summary>
        /////// <param name="LobbyistRelationshipID"></param>
        /////// <returns></returns>
        ////[HttpGet("GetRelationshipbyID")]
        ////[AllowAnonymous]
        ////public async Task<List<LobbyistApiModel>> GetLobbyistRelationshipID(int LobbyistRelationshipID)
        ////{
        ////    if (!ModelState.IsValid)
        ////    {
        ////        throw new ValidationException(ValidationMessage.InvalidInput, ModelState.Values.SelectMany(x => x.Errors.Select(y => y.ErrorMessage)).ToList());
        ////    }
        ////    List<LobbyistApiModel> responsedt = await _iService.GetLobbyistEmployeebyID(LobbyistRelationshipID);
        ////    return responsedt;
        ////}

        /////// <summary>
        /////// GetLobbyistRelationshipList - Retrieve LobbyistEmployeedetail 
        /////// </summary>
        /////// <returns></returns>
        ////[HttpGet("GetRelationshipList")]
        ////[AllowAnonymous]
        ////public async Task<List<LobbyistApiModel>> GetLobbyistRelationshipList()
        ////{
        ////    if (!ModelState.IsValid)
        ////    {
        ////        throw new ValidationException(ValidationMessage.InvalidInput, ModelState.Values.SelectMany(x => x.Errors.Select(y => y.ErrorMessage)).ToList());
        ////    }
        ////    List<LobbyistApiModel> responsedt = await _iService.GetLobbyistEmployeebyList();
        ////    return responsedt;
        ////}
        //#endregion

        //#region lobbyist_subcontractor
        ///// <summary>
        ///// CreateSubcontractor - Create LobbyistSubcontractor
        ///// </summary>
        ///// <param name="createLobbyistSubcontractor"></param>
        ///// <returns></returns>
        //[HttpPost("CreateSubcontractor")]
        //[AllowAnonymous]
        //public async Task<List<ApiResponse<bool>>> CreateLobbyistSubcontractor([FromBody] LobbyistInfo createLobbyistSubcontractor)
        //{
        //    if (!ModelState.IsValid)
        //    {
        //        throw new ValidationException(ValidationMessage.InvalidInput, null, ModelState.Values.SelectMany(x => x.Errors.Select(y => y.ErrorMessage)).ToList());
        //    }
        //    int response = await _iService.CreateLobbyistEmployee(createLobbyistSubcontractor);
        //    return response != 0 ? CreateRespWithreturnCollection(response) : GeneralErrorResponse();
        //}

        ///// <summary>
        ///// UpdateSubcontractor - Update LobbyistSubcontractor
        ///// </summary>
        ///// <param name="updateLobbyistEmployee"></param>
        ///// <returns></returns>
        //[HttpPut("UpdateSubcontractor")]
        //[AllowAnonymous]
        //public async Task<List<ApiResponse<bool>>> UpdateLobbyistSubcontractor([FromBody] LobbyistInfo updateLobbyistSubcontractor)
        //{
        //    if (!ModelState.IsValid)
        //    {
        //        throw new ValidationException(ValidationMessage.InvalidInput, null, ModelState.Values.SelectMany(x => x.Errors.Select(y => y.ErrorMessage)).ToList());
        //    }
        //    int response = await _iService.UpdateLobbyistEmployee(updateLobbyistSubcontractor);
        //    return response != 0 ? CreateRespWithreturnCollectionForU(response) : GeneralErrorResponse();
        //}


        ///// <summary>
        ///// DeleteSubcontractor - Delete LobbyistSubcontractor
        ///// </summary>
        ///// <param name="LobbyistSubcontractorID"></param>
        ///// <returns></returns>
        //[HttpDelete("DeleteSubcontractor")]
        //[AllowAnonymous]
        //public async Task<List<ApiResponse<bool>>> DeleteLobbyistSubcontractor(int LobbyistSubcontractorID)

        //{
        //    int response = await _iService.DeleteLobbyistUser(LobbyistSubcontractorID);
        //    return response != 0 ? CreateRespWithreturnCollectionForD(response) : GeneralErrorResponse();
        //}

        /////// <summary>
        /////// GetSubcontractorbyID - Retrieve LobbyistSubcontractordetail based on the LobbyistSubcontractorbyID
        /////// </summary>
        /////// <param name="LobbyistSubcontractorID"></param>
        /////// <returns></returns>
        ////[HttpGet("GetSubcontractorbyID")]
        ////[AllowAnonymous]
        ////public async Task<List<LobbyistApiModel>> GetLobbyistSubcontractorbyID(int LobbyistEmployeeID)
        ////{
        ////    if (!ModelState.IsValid)
        ////    {
        ////        throw new ValidationException(ValidationMessage.InvalidInput, ModelState.Values.SelectMany(x => x.Errors.Select(y => y.ErrorMessage)).ToList());
        ////    }
        ////    List<LobbyistApiModel> responsedt = await _iService.GetLobbyistEmployeebyID(LobbyistEmployeeID);
        ////    return responsedt;
        ////}

        /////// <summary>
        /////// GetSubcontractorList - Retrieve LobbyistSubcontractordetail 
        /////// </summary>
        /////// <returns></returns>
        ////[HttpGet("GetSubcontractorList")]
        ////[AllowAnonymous]
        ////public async Task<List<LobbyistApiModel>> GetLobbyistSubcontractorList()
        ////{
        ////    if (!ModelState.IsValid)
        ////    {
        ////        throw new ValidationException(ValidationMessage.InvalidInput, ModelState.Values.SelectMany(x => x.Errors.Select(y => y.ErrorMessage)).ToList());
        ////    }
        ////    List<LobbyistApiModel> responsedt = await _iService.GetLobbyistEmployeebyList();
        ////    return responsedt;
        ////}
        //#endregion

        //#region lobbyist_client
        ///// <summary>
        ///// Createclient - Create Lobbyistclient
        ///// </summary>
        ///// <param name="createLobbyistclient"></param>
        ///// <returns></returns>
        //[HttpPost("Createclient")]
        //[AllowAnonymous]
        //public async Task<List<ApiResponse<bool>>> CreateLobbyistclient([FromBody] LobbyistInfo createLobbyistclient)
        //{
        //    if (!ModelState.IsValid)
        //    {
        //        throw new ValidationException(ValidationMessage.InvalidInput, null, ModelState.Values.SelectMany(x => x.Errors.Select(y => y.ErrorMessage)).ToList());
        //    }
        //    int response = await _iService.CreateLobbyistEmployee(createLobbyistclient);
        //    return response != 0 ? CreateRespWithreturnCollection(response) : GeneralErrorResponse();
        //}

        ///// <summary>
        ///// Updateclient - Update Lobbyistclient
        ///// </summary>
        ///// <param name="updateLobbyistclient"></param>
        ///// <returns></returns>
        //[HttpPut("Updateclient")]
        //[AllowAnonymous]
        //public async Task<List<ApiResponse<bool>>> UpdateLobbyistclient([FromBody] LobbyistInfo updateLobbyistclient)
        //{
        //    if (!ModelState.IsValid)
        //    {
        //        throw new ValidationException(ValidationMessage.InvalidInput, null, ModelState.Values.SelectMany(x => x.Errors.Select(y => y.ErrorMessage)).ToList());
        //    }
        //    int response = await _iService.UpdateLobbyistEmployee(updateLobbyistclient);
        //    return response != 0 ? CreateRespWithreturnCollectionForU(response) : GeneralErrorResponse();
        //}


        ///// <summary>
        ///// Deleteclient - Delete Lobbyistclient
        ///// </summary>
        ///// <param name="LobbyistclientID"></param>
        ///// <returns></returns>
        //[HttpDelete("Deleteclient")]
        //[AllowAnonymous]
        //public async Task<List<ApiResponse<bool>>> DeleteLobbyistclient(int LobbyistclientID)

        //{
        //    int response = await _iService.DeleteLobbyistUser(LobbyistclientID);
        //    return response != 0 ? CreateRespWithreturnCollectionForD(response) : GeneralErrorResponse();
        //}

        ///// <summary>
        ///// Getclient - Retrieve Lobbyistclientdetail based on the Name
        ///// </summary>
        ///// <param name="searchClient"></param>
        ///// <returns></returns>
        //[HttpPost("Getclient")]
        //[AllowAnonymous]
        //public async Task<ActionResult> GetClientListByName(ClientListRequestApiModel searchClient)
        //{
        //    return Ok(await _iService.GetClientListByName(searchClient));
        //}


        /////// <summary>
        /////// GetclientList - Retrieve Lobbyistclientdetail 
        /////// </summary>
        /////// <returns></returns>
        ////[HttpGet("GetclientList")]
        ////[AllowAnonymous]
        ////public async Task<List<LobbyistApiModel>> GetLobbyistclientList()
        ////{
        ////    if (!ModelState.IsValid)
        ////    {
        ////        throw new ValidationException(ValidationMessage.InvalidInput, ModelState.Values.SelectMany(x => x.Errors.Select(y => y.ErrorMessage)).ToList());
        ////    }
        ////    List<LobbyistApiModel> responsedt = await _iService.GetLobbyistEmployeebyList();
        ////    return responsedt;
        ////}
        //#endregion

        ///// <summary>
        ///// CreateLobbyist - Create Lobbyist
        ///// </summary>
        ///// <param name="createLobbyist"></param>
        ///// <returns></returns>
        //[HttpPost("createLobbyist")]
        //[AllowAnonymous]
        //public async Task<ApiResponse<string>> CreateLobbyist([FromBody] LobbyistOldApiModel createLobbyist)
        //{
        //    if (!ModelState.IsValid)
        //    {
        //        throw new ValidationException(ValidationMessage.InvalidInput, null, ModelState.Values.SelectMany(x => x.Errors.Select(y => y.ErrorMessage)).ToList());
        //    }
        //    EmailReq emailReq = new EmailReq();
        //    emailReq.FromEmail = this._appSettings.EmailSettings.SmtpUserName;
        //    emailReq.CcEmail = this._appSettings.EmailSettings.CCEmails;
        //    emailReq.BccEmail = this._appSettings.EmailSettings.BccEmails;
        //    emailReq.Password = this._appSettings.EmailSettings.SmtpPassword;
        //    emailReq.SMTPServer = this._appSettings.EmailSettings.SmtpServer;
        //    emailReq.UILink = this._appSettings.EmailSettings.UILink;
        //    emailReq.SMTPPort = Convert.ToInt32(this._appSettings.EmailSettings.SmtpPort);

        //    bool response = await _iService.CreateLobbyist(createLobbyist, emailReq);
        //    if (response)
        //        return SuccessResponseWithCustomMessage("Email Sent Successfully", 1);
        //    else
        //        return ErrorResponseWithCustomMessage("Error Occured while sending Mail");

        //}

        ///// <summary>
        ///// UpdateLobbyistAdditionalInfo - Update Lobbyist Additional Info
        ///// </summary>
        ///// <param name="LobbyistRelationshipID"></param>
        ///// <returns></returns>
        //[HttpPost("UpdateLobbyistAdditionalInfo")]
        //[AllowAnonymous]
        //public async Task<ApiResponse<string>> UpdateLobbyistAdditionalInfo([FromBody] LobbyistAddlInfoApiModel lobbyistAddlInfoDetails)
        //{
        //    if (!ModelState.IsValid)
        //    {
        //        throw new ValidationException(ValidationMessage.InvalidInput, null, ModelState.Values.SelectMany(x => x.Errors.Select(y => y.ErrorMessage)).ToList());
        //    }
        //    EmailReq emailReq = new EmailReq();
        //    emailReq.FromEmail = this._appSettings.EmailSettings.SmtpUserName;
        //    emailReq.CcEmail = this._appSettings.EmailSettings.CCEmails;
        //    emailReq.BccEmail = this._appSettings.EmailSettings.BccEmails;
        //    emailReq.Password = this._appSettings.EmailSettings.SmtpPassword;
        //    emailReq.SMTPServer = this._appSettings.EmailSettings.SmtpServer;
        //    emailReq.UILink = this._appSettings.EmailSettings.UILink;
        //    emailReq.SMTPPort = Convert.ToInt32(this._appSettings.EmailSettings.SmtpPort);
        //    bool response = await _iService.UpdateLobbyistAdditionalInfo(lobbyistAddlInfoDetails, emailReq);

        //    if (response)
        //        return SuccessResponseWithCustomMessage("Email Sent Successfully", 1);
        //    else
        //        return ErrorResponseWithCustomMessage("Error Occured while sending Mail");
        //}


        ///// <summary>
        ///// GetLobbyistList - Retrieve Lobbyist detail list
        ///// </summary>
        ///// <returns>CommitteeResponse<returns>
        ///// <summary>
        //[HttpGet("GetLobbyistList")]
        //[AllowAnonymous]
        //public async Task<List<LobbyistOldApiModel>> GetLobbyistList()
        //{
        //    if (!ModelState.IsValid)
        //    {
        //        throw new ValidationException(ValidationMessage.InvalidInput, null, ModelState.Values.SelectMany(x => x.Errors.Select(y => y.ErrorMessage)).ToList());
        //    }
        //    List<LobbyistOldApiModel> responsedt = await _iService.GetLobbyistList();
        //    return responsedt;
        //}


        ///// <summary>
        ///// GetLobbyist - Retrieve Lobbyist detail 
        ///// </summary>
        ///// <returns>LobbyistDetailResponse<returns>
        ///// <summary>
        //[HttpPost("GetLobbyistDetail")]
        //[AllowAnonymous]
        //public async Task<LobbyistDetailResponseApiModel> GetLobbyistDetail(int lobbyistId)
        //{
        //    var responsedt = await _iService.GetLobbyistDetail(lobbyistId);
        //    return responsedt;
        //}

        ///// <summary>
        ///// Update Lobbyist Status
        ///// </summary>
        ///// <param>committeeStatusUpdate</param>
        ///// <returns></returns>
        //[HttpPost("UpdateLobbyistStatus")]
        //[AllowAnonymous]
        //public async Task<ApiResponse<string>> UpdateLobbyistStatus(LobbyistStatusUpdateRequestApiModel lobbyistStatusUpdate)
        //{
        //    EmailReq emailReq = new EmailReq();
        //    emailReq.FromEmail = this._appSettings.EmailSettings.SmtpUserName;
        //    emailReq.CcEmail = this._appSettings.EmailSettings.CCEmails;
        //    emailReq.BccEmail = this._appSettings.EmailSettings.BccEmails;
        //    emailReq.Password = this._appSettings.EmailSettings.SmtpPassword;
        //    emailReq.SMTPServer = this._appSettings.EmailSettings.SmtpServer;
        //    emailReq.UILink = this._appSettings.EmailSettings.UILink;
        //    emailReq.SMTPPort = Convert.ToInt32(this._appSettings.EmailSettings.SmtpPort);

        //    bool retValue = await _iService.UpdateLobbyistStatus(lobbyistStatusUpdate, emailReq);
        //    if (retValue)
        //        return SuccessResponseWithCustomMessage("Email Sent Successfully", 1);
        //    else
        //        return ErrorResponseWithCustomMessage("Error Occured while sending Mail");


        //}

        #endregion Old
    }
}