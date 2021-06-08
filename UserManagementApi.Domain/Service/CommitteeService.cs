using Denver.Infra.Common;
using Denver.Infra.Constants;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Text;
using System.Threading.Tasks;
using UserManagementApi.Domain.ApiModels;
using UserManagementApi.Domain.ViewModels;
using UserManagementApi.Domain.ApiModels.Committee;
using UserManagementApi.Domain.Helper;
using UserManagementApi.Domain.Repositories;
using UserManagementApi.Domain.ViewModels;

namespace UserManagementApi.Domain.Service
{
    public partial class UserManagementService
    {
        public async Task<IEnumerable<BallotIssueListResponseApiModel>> GetBallotIssueList()
        {
            return await _committeeRepository.GetBallotIssueList();
        }

        public async Task<IEnumerable<CommitteeListResponseApiModel>> GetCommitteeList()
        {
            return await _committeeRepository.GetCommitteeList();
        }



        public async Task<bool> UpdateCommitteeAdditionalInfo(CommitteeAddlInfoApiModel committeeAddlInfoDetails, EmailReq emailReq)
        {
            //return await _committeeRepository.UpdateCommitteeAdditionalInfo(committeeAddlInfoDetails);

            var retValue = await _committeeRepository.UpdateCommitteeAdditionalInfo(committeeAddlInfoDetails);

            var response = await _identityRepository.GetUserDetails(committeeAddlInfoDetails.UserID);
            UserInfoResposeApiModel userInfo = null;
            foreach (UserInfoResposeApiModel user in response)
            {
                userInfo = user;
            }
            string name = string.Empty;
            if (userInfo != null)
            {
                name = string.Format("{0} {1}", userInfo.FName, userInfo.LName);
                emailReq.ToEmail = userInfo.EmailId;
                if (retValue)
                {
                    emailReq.Subject = string.Format(Constants.CreateAccountSubject, userInfo.UserType);
                    emailReq.BodyMessage = string.Format(Constants.CreateAccountMessage, name, userInfo.UserType);

                    retValue = await SendEmail.SendMail(emailReq.SMTPServer, emailReq.SMTPPort, emailReq.FromEmail,
                                                      emailReq.ToEmail, emailReq.Password, emailReq.CcEmail,
                                                      emailReq.BccEmail, emailReq.Subject, emailReq.BodyMessage, emailReq.BodyTemplate);

                }
            }
            return retValue;
        }

        public async Task<IEnumerable<CommitteeListResponseApiModel>> GetCommitteeListByName(CommitteeListRequestApiModel searchCommitte)
        {
            return await _committeeRepository.GetCommitteeListByName(searchCommitte);
        }
        public async Task<IEnumerable<SwitchCommitteeDetail>> GetCommitteeorLobbyistbyID(int id, string type)
        {
            return await _committeeRepository.GetCommitteeorLobbyistbyID(id, type);
        }
        public async Task<IEnumerable<CommitteeandLobbyistbyUser>> GetCommitteeandLobbyistbyUser(int id)
        {
            return await _committeeRepository.GetCommitteeandLobbyistbyUser(id);
        }

        public async Task<bool> UpdateCommitteeStatus(CommitteeStatusUpdateRequestApiModel committeeStatusUpdate, EmailReq emailReq)
        {
            bool retValue = await _committeeRepository.UpdateCommitteeStatus(committeeStatusUpdate);
            var userEmailDetail = await _committeeRepository.GetCommitteeUserEmail(committeeStatusUpdate.Id);
            string name = string.Empty;
            if (userEmailDetail != null)
            {
                name = string.Format("{0} {1}", userEmailDetail.FirstName, userEmailDetail.LastName);
                emailReq.ToEmail = userEmailDetail.Email;
                if (retValue)
                {
                    if (committeeStatusUpdate.Status)
                    {
                        emailReq.Subject = string.Format(Constants.CommitteeApprovedOrDeniedEmailSubject, Constants.STATUS_APPROVED);
                        emailReq.BodyMessage = string.Format(Constants.CommitteeApprovedOrDeniedMessage, name, Constants.STATUS_APPROVED.ToLower());
                    }
                    else
                    {
                        emailReq.Subject = string.Format(Constants.CommitteeApprovedOrDeniedEmailSubject, Constants.STATUS_REJECTED);
                        emailReq.BodyMessage = string.Format(Constants.CommitteeApprovedOrDeniedMessage, name, Constants.STATUS_REJECTED.ToLower());
                    }
                    retValue = await SendEmail.SendMail(emailReq.SMTPServer, emailReq.SMTPPort, emailReq.FromEmail,
                                                      emailReq.ToEmail, emailReq.Password, emailReq.CcEmail,
                                                      emailReq.BccEmail, emailReq.Subject, emailReq.BodyMessage, emailReq.BodyTemplate);


                }
            }
            return retValue;
        }

        public async Task<IEnumerable<CommitteeListResponseApiModel>> SearchCommittee(SearchCommitteeRequestApiModel searchreq)
        {
            return await _committeeRepository.SearchCommittee(searchreq);
        }

        public async Task<IEnumerable<ManageCommitteListResponseApiModel>> GetManageCommitteeList(ManageCommitteListRequestApiModel manageCommitteListRequest)
        {
            return await _committeeRepository.GetManageCommitteeList(manageCommitteListRequest);
        }
        public async Task<ApiModels.CommitteeDetailsApiModel> GetCommitteeDetail(int committteeId)
        {
            return await _committeeRepository.GetCommitteeDetail(committteeId);
        }
        public async Task<int> TerminateCommittee(int committteeId)
        {
            return await _committeeRepository.TerminateCommittee(committteeId);
        }

        public async Task<bool> SendCommitteeNote(SendCommitteNoteRequestApiModel sendCommitteNote, EmailReq emailReq)
        {
            bool retValue = await _committeeRepository.SendCommitteeNote(sendCommitteNote);

            var userEmailDetail = await _committeeRepository.GetCommitteeUserEmail(sendCommitteNote.Id);
            string name = string.Empty;
            if (userEmailDetail != null)
            {
                name = string.Format("{0} {1}", userEmailDetail.FirstName, userEmailDetail.LastName);
                emailReq.ToEmail = userEmailDetail.Email;
                emailReq.BodyMessage = string.Format("Hi {0}, {1}", name, emailReq.BodyMessage);
                if (retValue)
                {
                    retValue = await SendEmail.SendMail(emailReq.SMTPServer, emailReq.SMTPPort, emailReq.FromEmail,
                                                      emailReq.ToEmail, emailReq.Password, emailReq.CcEmail,
                                                      emailReq.BccEmail, emailReq.Subject, emailReq.BodyMessage, emailReq.BodyTemplate);


                }
            }
            return retValue;
        }
        //Method of GetCommitteeByName
        public async Task<IEnumerable<CommitteeListResponseApiModels>> GetCommitteeByName(string searchCommittee, string committeetype)
        {
            return await _committeeRepository.GetCommitteeByName(searchCommittee, committeetype); 
        }

        public async Task<List<GetOfficerApiModel>> GetOfficersList(int committeeid)
        {
            return await _committeeRepository.GetOfficersList(committeeid);
        }

        public async Task<int> CreateCommittee(CommitteApiModel createCommittee)
        {
            return await _committeeRepository.CreateCommittee(createCommittee);
        }

        public async Task<int> SaveOfficer(OfficersApiModel createOfficer)
        {
            return await _committeeRepository.SaveOfficer(createOfficer);
        }
        public async Task<int> UpdateBankInfo(BankInfoApiModel updateBankInfo)
        {
            return await _committeeRepository.UpdateBankInfo(updateBankInfo);

        }
        public async Task<int> SaveCommitteeAffiliation(CommitteeAffiliationApiModel committeeAffiliation)
        {
            return await _committeeRepository.SaveCommitteeAffiliation(committeeAffiliation);
        }
        public async Task<int> DeleteOfficer(int contactid)
        {
            return await _committeeRepository.DeleteOfficer(contactid);
        }

        public async Task<int> CreateIssueCommittee(IssueCommitteeApiModel createIssueCommittee)
        {
            return await _committeeRepository.CreateIssueCommittee(createIssueCommittee);
        }
        public async Task<int> CreatePACCommittee(PACCommitteeApiModel createPACCommittee)
        {
            return await _committeeRepository.CreatePACCommittee(createPACCommittee);
        }
        public async Task<int> CreateSmallDonorCommittee(SmallDonorApiModel createSmallDonorCommittee)
        {
            return await _committeeRepository.CreateSmallDonorCommittee(createSmallDonorCommittee);
        }

        public async Task<List<GetOfficerApiModel>> GetOfficersListByName(string officerName, int committeeId)
        {
            return await _committeeRepository.GetOfficersListByName(officerName, committeeId);
        }
        public async Task<int> CreateCoveredOfficial(int contactId)
        {
            return await _committeeRepository.CreateCoveredOfficial(contactId);
        }
        public async Task<CommitteeDetailsResponseApiModel> GetCommitteeDetails(int committeeid)
        {
            return await _committeeRepository.GetCommitteeDetails(committeeid);
        }
        public async Task<int> UpdateCommitteeorLobbyistStatus(StatusUpdateRequestApiModel statusUpdate)
        {
            return await _committeeRepository.UpdateCommitteeorLobbyistStatus(statusUpdate);
        }
    }
}
