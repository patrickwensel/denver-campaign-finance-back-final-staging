using Denver.DataAccess;
using Denver.Infra.Constants;
using Microsoft.Extensions.Configuration;
using Npgsql;
using System;
using System.Collections.Generic;
using System.Data;
using System.Text;
using System.Threading.Tasks;
using UserManagementApi.Domain.ApiModels;
using UserManagementApi.Domain.ViewModels;
using UserManagementApi.Domain.ApiModels.Committee;
using UserManagementApi.Domain.Entities;
using UserManagementApi.Domain.Helper;
using UserManagementApi.Domain.Repositories;
using Denver.Infra.Common;
using System.Linq;

namespace UserManagementApi.DataCore.Repositories
{
    public class CommitteeRepository : ICommitteeRepository
    {
        private DBManager dataContext;
        DataTableToList tableConverter;
        public CommitteeRepository(IConfiguration configuration)
        {
            dataContext = new DBManager(configuration.GetConnectionString("AppDB"), DataProvider.PostgreSQL);
            tableConverter = new DataTableToList();
        }
        public async Task<IEnumerable<CommitteeListResponseApiModel>> GetCommitteeList()
        {
            var dtCommitteeList = dataContext.GetDataTable(@"SELECT * FROM get_committeedetails()", commandType: CommandType.Text);

            IEnumerable<CommitteeListResponseApiModel> resposeDt = ConvertDataTableToList.DataTableToList<CommitteeListResponseApiModel>(dtCommitteeList);
            return resposeDt;
        }

        public async Task<IEnumerable<BallotIssueListResponseApiModel>> GetBallotIssueList()
        {
            var dtBallotIssueList = dataContext.GetDataTable(@"SELECT * FROM get_ballotissues()", commandType: CommandType.Text);

            IEnumerable<BallotIssueListResponseApiModel> resposeDt = ConvertDataTableToList.DataTableToList<BallotIssueListResponseApiModel>(dtBallotIssueList);
            return resposeDt;
        }

        public async Task<bool> UpdateCommitteeAdditionalInfo(CommitteeAddlInfoApiModel committeeAddlInfo)
        {
            int retValue = 0;
            foreach (SelectedCommittee committeId in committeeAddlInfo.Committee)
            {
                IDbDataParameter[] param = new[]
                {
                  dataContext.CreateParameter(DbType.Int32,"userId", 100, committeeAddlInfo.UserID, ParameterDirection.InputOutput),
                  dataContext.CreateParameter(DbType.String,"userType", 10, committeeAddlInfo.UserType, ParameterDirection.InputOutput),
                  dataContext.CreateParameter(DbType.Int32,"userRoleId", 100, committeeAddlInfo.UserRoleId, ParameterDirection.InputOutput),
                  dataContext.CreateParameter(DbType.Int32,"refId", 100, committeId.RefId,  ParameterDirection.InputOutput),
                  dataContext.CreateParameter(DbType.Int32,"relationshipId", 100, committeeAddlInfo.RelationshipId,  ParameterDirection.InputOutput),
                };
                retValue = dataContext.Insert(@"select * from save_additionalinfo(:userId, :userType, :userRoleId, :refId, :relationshipId)", commandType: CommandType.Text, param);

            }
            return retValue > 0;
        }
        public async Task<IEnumerable<CommitteeListResponseApiModel>> GetCommitteeListByName(CommitteeListRequestApiModel searchCommitte)
        {
            IDbDataParameter[] param = new[]
            {
                  dataContext.CreateParameter(DbType.String,"comName", 100, searchCommitte.searchCommitteeName, ParameterDirection.InputOutput)
            };
            var dtCommitteeList = dataContext.GetDataTable(@"SELECT * FROM get_committeedetailsbyname(:comName)", commandType: CommandType.Text, param);

            IEnumerable<CommitteeListResponseApiModel> resposeDt = ConvertDataTableToList.DataTableToList<CommitteeListResponseApiModel>(dtCommitteeList);
            return resposeDt;
        }
        public async Task<IEnumerable<SwitchCommitteeDetail>> GetCommitteeorLobbyistbyID(int id, string type)
        {
            IDbDataParameter[] param = new[]
            {
                  dataContext.CreateParameter(DbType.Int32,"_id", 100, id, ParameterDirection.InputOutput),
                  dataContext.CreateParameter(DbType.String,"_type", 100, type, ParameterDirection.InputOutput)
            };
            var dtCommitteeList = dataContext.GetDataTable(@"SELECT * FROM get_committeeorlobbyistbyID(:_id, :_type)", commandType: CommandType.Text, param);

            IEnumerable<SwitchCommitteeDetail> resposeDt = ConvertDataTableToList.DataTableToList<SwitchCommitteeDetail>(dtCommitteeList);
            return resposeDt;
        }
        public async Task<IEnumerable<CommitteeandLobbyistbyUser>> GetCommitteeandLobbyistbyUser(int id)
        {
            var latest = new CommitteeandLobbyistbyUser();
            IDbDataParameter[] param = new[]
         {
                  dataContext.CreateParameter(DbType.Int32,"_id", 100, id, ParameterDirection.InputOutput)
            };
            var dtCommitteeList = dataContext.GetDataTable(@"SELECT * FROM get_committeebyUser(:_id)", commandType: CommandType.Text, param);
            IEnumerable<CommitteeList> resposeDtC = ConvertDataTableToList.DataTableToList<CommitteeList>(dtCommitteeList);
            IDbDataParameter[] paramL = new[]
            {
                  dataContext.CreateParameter(DbType.Int32,"_id", 100, id, ParameterDirection.InputOutput)
            };
            var dtCommitteeListL = dataContext.GetDataTable(@"SELECT * FROM get_lobbyistbyUser(:_id)", commandType: CommandType.Text, paramL);
            IEnumerable<LobbyistList> resposeDtL = ConvertDataTableToList.DataTableToList<LobbyistList>(dtCommitteeListL);
            IDbDataParameter[] paramIE = new[]
            {
                  dataContext.CreateParameter(DbType.Int32,"_id", 100, id, ParameterDirection.InputOutput)
            };
            var dtCommitteeListIE = dataContext.GetDataTable(@"SELECT * FROM get_iebyUser(:_id)", commandType: CommandType.Text, paramIE);
            IEnumerable<IEList> resposeDtIE = ConvertDataTableToList.DataTableToList<IEList>(dtCommitteeListIE);
            IDbDataParameter[] paramU = new[]
            {
                  dataContext.CreateParameter(DbType.Int32,"_id", 100, id, ParameterDirection.InputOutput)
            };
            DataTable dtCommitteeListuser = dataContext.GetDataTable(@"SELECT * FROM get_usertypedetailsbyid(:_id)", commandType: CommandType.Text, paramU);
            latest.committeelist = resposeDtC;
            latest.lobbyistlist = resposeDtL;
            latest.ielist = resposeDtIE;
            latest.userType = dtCommitteeListuser.Rows[0][0].ToString();
            IEnumerable<CommitteeandLobbyistbyUser> data = new[] { latest };
            return data;
        }

        public async Task<bool> UpdateCommitteeStatus(CommitteeStatusUpdateRequestApiModel committeeStatusUpdate)
        {
            int retValue = 0;
            IDbDataParameter[] param = new[]
            {
                  dataContext.CreateParameter(DbType.Int32,"committeId", 100, committeeStatusUpdate.Id, ParameterDirection.InputOutput),
                  dataContext.CreateParameter(DbType.Boolean,"status", 10, committeeStatusUpdate.Status, ParameterDirection.InputOutput),
                  dataContext.CreateParameter(DbType.String,"addnotes", 100, committeeStatusUpdate.Notes, ParameterDirection.InputOutput),
            };
            retValue = dataContext.Update(@"select * from update_committeeStatus(:committeId, :status, :addnotes)", commandType: CommandType.Text, param);
            return retValue > 0;
        }

        public async Task<IEnumerable<CommitteeListResponseApiModel>> SearchCommittee(SearchCommitteeRequestApiModel searchreq)
        {
            IDbDataParameter[] param = new[]
            {
                  dataContext.CreateParameter(DbType.String,"_committeename", 100, searchreq.CommitteeName, ParameterDirection.InputOutput)
            };
            var dtCommitteeList = dataContext.GetDataTable(@"SELECT * FROM searchapprovedcommittee(:_committeename)", commandType: CommandType.Text, param);

            IEnumerable<CommitteeListResponseApiModel> resposeDt = ConvertDataTableToList.DataTableToList<CommitteeListResponseApiModel>(dtCommitteeList);
            return resposeDt;
        }
        public async Task<IEnumerable<ManageCommitteListResponseApiModel>> GetManageCommitteeList(ManageCommitteListRequestApiModel manageCommitteListRequest)
        {
            if (manageCommitteListRequest.LastFillingStartDate == null)
            {
                manageCommitteListRequest.LastFillingStartDate = DateTime.MinValue;
            }
            if (manageCommitteListRequest.LastFillingEndDate == null)
            {
                manageCommitteListRequest.LastFillingEndDate = DateTime.MaxValue;
            }
            IDbDataParameter[] param = new[]
            {
                  dataContext.CreateParameter(DbType.String,"comName", 100, manageCommitteListRequest.Name, ParameterDirection.InputOutput),
                  dataContext.CreateParameter(DbType.String,"comType", 100, manageCommitteListRequest.Type, ParameterDirection.InputOutput),
                  dataContext.CreateParameter(DbType.String,"comStatus", 100, manageCommitteListRequest.Status, ParameterDirection.InputOutput),
                  dataContext.CreateParameter(DbType.Date,"lsStartDate", 100, manageCommitteListRequest.LastFillingStartDate, ParameterDirection.InputOutput),
                  dataContext.CreateParameter(DbType.Date,"lsEndDate", 100, manageCommitteListRequest.LastFillingEndDate, ParameterDirection.InputOutput),
                  dataContext.CreateParameter(DbType.String,"officeType", 100, manageCommitteListRequest.OfficeType, ParameterDirection.InputOutput),
                  dataContext.CreateParameter(DbType.String,"publicFundStatus", 100, manageCommitteListRequest.PublicFundStatus, ParameterDirection.InputOutput)
            };
            string query = "select* from get_managecommittes_dynamic(:comName, :comType, :comStatus, :lsStartDate, :lsEndDate, :officeType, :publicFundStatus)";
            var resposeDet = dataContext.GetDataTable(query, commandType: CommandType.Text, param);

            IEnumerable<ManageCommitteListResponseApiModel> resposeDt = ConvertDataTableToList.DataTableToList<ManageCommitteListResponseApiModel>(resposeDet);

            return resposeDt;
        }

        public async Task<CommitteeDetailsApiModel> GetCommitteeDetail(int committteeId)
        {
            int idx = 0;
            CommitteeDetailsApiModel committeeDet = new CommitteeDetailsApiModel();
            IDbDataParameter[] comParam = new[]
            {
                dataContext.CreateParameter(DbType.Int32,"comid", 100, committteeId, ParameterDirection.InputOutput),
            };
            var responseComDt = dataContext.GetDataTable(@"select * from get_committeedetailbyid(:comid)", commandType: CommandType.Text, comParam);
            IEnumerable<CommitteeDetail> responseCDt = ConvertDataTableToList.DataTableToList<CommitteeDetail>(responseComDt);

            CommitteeDetail comDet = responseComDt.ToClass<CommitteeDetail>();

            IDbDataParameter[] offParam = new[]
            {
                dataContext.CreateParameter(DbType.Int32,"comid", 100, committteeId, ParameterDirection.InputOutput),
            };
            var responseOfficerDt = dataContext.GetDataTable(@"select * from get_committeofficerdetailbyid(:comid)", commandType: CommandType.Text, offParam);

            IEnumerable<Officer> responseODt = ConvertDataTableToList.DataTableToList<Officer>(responseOfficerDt);
            Officer[] officers = new Officer[responseOfficerDt.Rows.Count];

            foreach (Officer officer in responseODt)
            {
                officers[idx++] = officer;
            }
            committeeDet.CommitteeDetail = comDet;
            committeeDet.Officer = officers;

            return committeeDet;
        }
        public async Task<int> TerminateCommittee(int committteeId)
        {
            int retValue = 0;
            IDbDataParameter[] comParam = new[]
            {
                dataContext.CreateParameter(DbType.Int32,"comid", 100, committteeId, ParameterDirection.InputOutput),
            };
            retValue = dataContext.Update(@"select * from update_terminatecommittee(:comid)", commandType: CommandType.Text, comParam);

            return retValue;
        }

        public async Task<UserEmailDetailResponseApiModel> GetCommitteeUserEmail(int Id)
        {
            IDbDataParameter[] param = new[]
            {
                   dataContext.CreateParameter(DbType.Int32,"_id", 200, Id, ParameterDirection.InputOutput),
                   dataContext.CreateParameter(DbType.String,"userType", 200, Constants.USER_CANDIDATE, ParameterDirection.InputOutput),
            };
            var dtUserEmail = dataContext.GetDataTable(@"SELECT * FROM get_useremail(:_id, :userType)", commandType: CommandType.Text, param);
            UserEmailDetailResponseApiModel response = ConvertDataTableToList.ToClass<UserEmailDetailResponseApiModel>(dtUserEmail);
            return response;
        }

        public async Task<bool> SendCommitteeNote(SendCommitteNoteRequestApiModel sendCommitteNote)
        {
            int retValue = 0;
            IDbDataParameter[] param = new[]
            {
                  dataContext.CreateParameter(DbType.Int32,"committeid", 100, sendCommitteNote.Id, ParameterDirection.InputOutput),
                  dataContext.CreateParameter(DbType.String,"_subject", 10, sendCommitteNote.Subject, ParameterDirection.InputOutput),
                  dataContext.CreateParameter(DbType.String,"_message", 100, sendCommitteNote.Message, ParameterDirection.InputOutput),
             };
            retValue = dataContext.Update(@"select * from update_committeemeesage(:committeid, :_subject, :_message)", commandType: CommandType.Text, param);
            return retValue > 0;

        }
        // Method of Get CommitteeByname
        public async Task<IEnumerable<CommitteeListResponseApiModels>> GetCommitteeByName(string searchCommittee, string committeetype)
        {
            IDbDataParameter[] param = new[]
            {
                  dataContext.CreateParameter(DbType.String,"comName", 100, searchCommittee, ParameterDirection.InputOutput),
                  dataContext.CreateParameter(DbType.String,"comType", 100, committeetype, ParameterDirection.InputOutput)
            };
            var dtCommitteeList = dataContext.GetDataTable(@"SELECT * FROM get_committeebyname(:comName, :comType)", commandType: CommandType.Text, param);

            IEnumerable<CommitteeListResponseApiModels> resposeDt = ConvertDataTableToList.DataTableToList<CommitteeListResponseApiModels>(dtCommitteeList);
            return resposeDt;
        }


        public async Task<List<GetOfficerApiModel>> GetOfficersList(int committeeid)
        {
            IDbDataParameter[] param = new[]
           {
                  dataContext.CreateParameter(DbType.Int32,"committeeid", 100, committeeid, ParameterDirection.InputOutput)
           };
            DataTable ResultDT = dataContext.GetDataTable(@"select * from get_officerlist(:committeeid)", commandType: CommandType.Text, param);

            List<GetOfficerApiModel> officerlist = tableConverter.ConvertToList<GetOfficerApiModel>(ResultDT);
            return officerlist;
        }
        public async Task<int> CreateCommittee(CommitteApiModel createCommittee)
        {
            int committeeid = 0;
            int filerID = 0;
            int CandidateContactID = 0;
            int CommitteeContacID = 0;
            int CommitteeOtherContactID = 0;
            if (createCommittee.CommitteeDetail != null)
            {
                IDbDataParameter[] param = new[]
               {
                  dataContext.CreateParameter(DbType.String,"_name", 500, createCommittee.CommitteeDetail.CommitteeName, ParameterDirection.Input),
                  dataContext.CreateParameter(DbType.String,"_committeetypeid", 300, createCommittee.CommitteeDetail.CommitteeTypeID,  ParameterDirection.Input),
                  dataContext.CreateParameter(DbType.String,"_officesoughtid", 150, createCommittee.CommitteeDetail.OfficeSoughtID, ParameterDirection.Input),
                  dataContext.CreateParameter(DbType.String,"_district", 150, createCommittee.CommitteeDetail.District, ParameterDirection.Input),
                  dataContext.CreateParameter(DbType.Int32,"_electioncycleid", 200, createCommittee.CommitteeDetail.ElectionCycleID, ParameterDirection.Input),
                  dataContext.CreateParameter(DbType.String,"_committeewebsite", 200, createCommittee.CommitteeDetail.CommitteeWebsite, ParameterDirection.Input),
                  dataContext.CreateParameter(DbType.String,"_bankname", 200, createCommittee.CommitteeDetail.BankName, ParameterDirection.Input),
                  dataContext.CreateParameter(DbType.String,"_address1", 200, createCommittee.CommitteeDetail.Address1, ParameterDirection.Input),
                  dataContext.CreateParameter(DbType.String,"_address2", 200, createCommittee.CommitteeDetail.Address2, ParameterDirection.Input),
                  dataContext.CreateParameter(DbType.String,"_city", 200, createCommittee.CommitteeDetail.City, ParameterDirection.Input),
                  dataContext.CreateParameter(DbType.String,"_statecode", 200, createCommittee.CommitteeDetail.StateCode, ParameterDirection.Input),
                  dataContext.CreateParameter(DbType.String,"_zip", 200, createCommittee.CommitteeDetail.Zip, ParameterDirection.Input),
                  dataContext.CreateParameter(DbType.String,"_registrationstatus", 200, "N"),
                  dataContext.CreateParameter(DbType.Int32,"_committeeid", 200, createCommittee.CommitteeDetail.CommitteeID),
                };
                committeeid = dataContext.Insert(@"select * from save_committee(:_name, :_committeetypeid, :_officesoughtid, :_district, :_electioncycleid, :_committeewebsite, :_bankname, :_address1, :_address2, :_city, :_statecode, :_zip, :_registrationstatus, :_committeeid)", commandType: CommandType.Text, param);
                if (createCommittee.CommitteeDetail.CommitteeID == 0)
                {
                    IDbDataParameter[] paramf = new[]
             {
                  dataContext.CreateParameter(DbType.String,"_entitytype", 1000, "C", ParameterDirection.Input),
                  dataContext.CreateParameter(DbType.Int32,"_entityid", 150, committeeid,  ParameterDirection.Input),
                  dataContext.CreateParameter(DbType.Int32,"_categoryid", 150, 1,  ParameterDirection.Input),
                  dataContext.CreateParameter(DbType.String,"_filerstatus", 150, "A",  ParameterDirection.Input),
                };
                    filerID = dataContext.Insert(@"select * from save_filer(:_entitytype, :_entityid, :_categoryid, :_filerstatus)", commandType: CommandType.Text, paramf);

                }
            }
            if (createCommittee.CandidateContactDetail != null)
            {
                IDbDataParameter[] paramcc = new[]
               {
                  dataContext.CreateParameter(DbType.String,"_contacttype", 100, "I", ParameterDirection.Input),
                  dataContext.CreateParameter(DbType.String,"_firstname", 150, createCommittee.CandidateContactDetail.FirstName,  ParameterDirection.Input),
                  dataContext.CreateParameter(DbType.String,"_lastname", 1500, createCommittee.CandidateContactDetail.LastName,  ParameterDirection.Input),
                  dataContext.CreateParameter(DbType.Int32,"_filerid", 150, filerID,  ParameterDirection.Input),
                  dataContext.CreateParameter(DbType.String,"_statuscode", 200, "ACTIVE", ParameterDirection.Input),
                  dataContext.CreateParameter(DbType.Int32,"_committeeid", 200, createCommittee.CommitteeDetail.CommitteeID),
                };
                CandidateContactID = dataContext.Insert(@"select * from save_candidatecontact(:_contacttype, :_firstname, :_lastname, :_filerid, :_statuscode, :_committeeid)", commandType: CommandType.Text, paramcc);
            }
            if (createCommittee.CommitteeContactDetail != null)
            {
                IDbDataParameter[] paramcoc = new[]
               {
                  dataContext.CreateParameter(DbType.String,"_contacttype", 100, "O", ParameterDirection.Input),
                  dataContext.CreateParameter(DbType.String,"_orgname", 1500, createCommittee.CommitteeContactDetail.OrganizationName,  ParameterDirection.Input),
                  dataContext.CreateParameter(DbType.String,"_address1", 1500, createCommittee.CommitteeContactDetail.Address1,  ParameterDirection.Input),
                  dataContext.CreateParameter(DbType.String,"_address2", 1500, createCommittee.CommitteeContactDetail.Address2,  ParameterDirection.Input),
                  dataContext.CreateParameter(DbType.String,"_city", 200, createCommittee.CommitteeContactDetail.City, ParameterDirection.Input),
                  dataContext.CreateParameter(DbType.String,"_statecode", 200, createCommittee.CommitteeContactDetail.StateCode, ParameterDirection.Input),
                  dataContext.CreateParameter(DbType.String,"_zip", 200, createCommittee.CommitteeContactDetail.Zip, ParameterDirection.Input),
                  dataContext.CreateParameter(DbType.Int32,"_filerid", 150, filerID,  ParameterDirection.Input),
                  dataContext.CreateParameter(DbType.String,"_statuscode", 200, "ACTIVE", ParameterDirection.Input),
                  dataContext.CreateParameter(DbType.Int32,"_committeeid", 200, createCommittee.CommitteeDetail.CommitteeID),
                };
                CommitteeContacID = dataContext.Insert(@"select * from save_committeecontact(:_contacttype, :_orgname, :_address1, :_address2, :_city, :_statecode, :_zip, :_filerid, :_statuscode, :_committeeid)", commandType: CommandType.Text, paramcoc);
            }
            if (createCommittee.CommitteeOtherContactDetail != null)
            {
                IDbDataParameter[] paramcotc = new[]
               {
                  dataContext.CreateParameter(DbType.String,"_contacttype", 100, "O", ParameterDirection.Input),
                  dataContext.CreateParameter(DbType.String,"_phone", 150, createCommittee.CommitteeOtherContactDetail.Phone,  ParameterDirection.Input),
                  dataContext.CreateParameter(DbType.String,"_email", 200, createCommittee.CommitteeOtherContactDetail.Email,  ParameterDirection.Input),
                  dataContext.CreateParameter(DbType.String,"_altphone", 150, createCommittee.CommitteeOtherContactDetail.AltPhone,  ParameterDirection.Input),
                  dataContext.CreateParameter(DbType.String,"_altemail", 200, createCommittee.CommitteeOtherContactDetail.AltEmail,  ParameterDirection.Input),
                  dataContext.CreateParameter(DbType.Int32,"_filerid", 150, filerID,  ParameterDirection.Input),
                  dataContext.CreateParameter(DbType.String,"_statuscode", 200, "ACTIVE", ParameterDirection.Input),
                  dataContext.CreateParameter(DbType.Int32,"_committeeid", 200, createCommittee.CommitteeDetail.CommitteeID),
                };
                CommitteeOtherContactID = dataContext.Insert(@"select * from save_committeeothercontact(:_contacttype, :_phone, :_email, :_altphone, :_altemail, :_filerid, :_statuscode, :_committeeid)", commandType: CommandType.Text, paramcotc);
            }
            if (createCommittee.CommitteeDetail.CommitteeID == 0)
            {

                IDbDataParameter[] paramuc = new[]
                 {
                  dataContext.CreateParameter(DbType.Int32,"_committeecontactid", 100, CommitteeContacID, ParameterDirection.Input),
                  dataContext.CreateParameter(DbType.Int32,"_candidatecontactid", 150, CandidateContactID,  ParameterDirection.Input),
                  dataContext.CreateParameter(DbType.Int32,"_contactid", 200, createCommittee.ContactID,  ParameterDirection.Input),
                  dataContext.CreateParameter(DbType.Int32,"_committeeothercontactid", 150, CommitteeOtherContactID,  ParameterDirection.Input),
                  dataContext.CreateParameter(DbType.Int32,"_committeeid", 150, committeeid,  ParameterDirection.Input),
                  dataContext.CreateParameter(DbType.Int32,"_filerid", 150, filerID,  ParameterDirection.Input),
                };
                committeeid = dataContext.Update(@"select * from update_committecontact(:_committeecontactid, :_candidatecontactid, :_contactid, :_committeeothercontactid, :_committeeid, :_filerid)", commandType: CommandType.Text, paramuc);

                IDbDataParameter[] paramcrm = new[]
        {
                  dataContext.CreateParameter(DbType.Int32,"_contactid", 200, createCommittee.ContactID,  ParameterDirection.Input),
                  dataContext.CreateParameter(DbType.Int32,"_filerid", 150, filerID,  ParameterDirection.Input),
                };
                int contactrolemappingid = dataContext.Update(@"select * from save_contactrolemappingtreasuree( :_contactid, :_filerid)", commandType: CommandType.Text, paramcrm);


                IDbDataParameter[] paramcrmm = new[]
    {
                  dataContext.CreateParameter(DbType.Int32,"_userid", 100, 0, ParameterDirection.Input),
                  dataContext.CreateParameter(DbType.Int32,"_contactid", 200, CandidateContactID,  ParameterDirection.Input),
                  dataContext.CreateParameter(DbType.Int32,"_filerid", 150, filerID,  ParameterDirection.Input),
                };
                int contactrolemappingidd = dataContext.Update(@"select * from save_contactrolemapping(:_userid, :_contactid, :_filerid)", commandType: CommandType.Text, paramcrmm);

            }

            return committeeid;
        }

        public async Task<int> SaveOfficer(OfficersApiModel createOfficer)
        {
            IDbDataParameter[] param = new[]
         {
                   dataContext.CreateParameter(DbType.Int32,"_contactid", 200, createOfficer.ContactID, ParameterDirection.Input),
                  dataContext.CreateParameter(DbType.String,"_contacttype", 100, "I", ParameterDirection.Input),
                  dataContext.CreateParameter(DbType.String,"_firstname", 150, createOfficer.FirstName,  ParameterDirection.Input),
                  dataContext.CreateParameter(DbType.String,"_lastname", 150, createOfficer.LastName, ParameterDirection.Input),
                  dataContext.CreateParameter(DbType.String,"_address1", 200, createOfficer.Address1, ParameterDirection.Input),
                  dataContext.CreateParameter(DbType.String,"_address2", 200, createOfficer.Address2, ParameterDirection.Input),
                  dataContext.CreateParameter(DbType.String,"_city", 200, createOfficer.City, ParameterDirection.Input),
                  dataContext.CreateParameter(DbType.String,"_state", 200, createOfficer.StateCode, ParameterDirection.Input),
                  dataContext.CreateParameter(DbType.String,"_zip", 200, createOfficer.Zip, ParameterDirection.Input),
                  dataContext.CreateParameter(DbType.String,"_phone", 200, createOfficer.Phone, ParameterDirection.Input),
                  dataContext.CreateParameter(DbType.String,"_email", 200, createOfficer.Email, ParameterDirection.Input),
                  dataContext.CreateParameter(DbType.String,"_desc", 200, createOfficer.Description, ParameterDirection.Input),
                };
            var contactId = dataContext.Insert(@"select * from save_officers(:_contactid, :_contacttype, :_firstname, :_lastname, :_address1, :_address2, :_city, :_state, :_zip, :_phone, :_email, :_desc)", commandType: CommandType.Text, param);
            if (createOfficer.ContactID == 0)
            {
                IDbDataParameter[] paramcrm = new[]
                {
                  dataContext.CreateParameter(DbType.Int32,"_userid", 100, 0, ParameterDirection.Input),
                  dataContext.CreateParameter(DbType.Int32,"_contactid", 200, contactId,  ParameterDirection.Input),
                  dataContext.CreateParameter(DbType.Int32,"_committeeid", 100, createOfficer.CommitteeID,  ParameterDirection.Input),
                };
                int contactRoleMappingId = dataContext.Update(@"select * from save_contactrolemappingofficer(:_userid, :_contactid, :_committeeid)", commandType: CommandType.Text, paramcrm);
            }
            return contactId;
        }

        public async Task<int> UpdateBankInfo(BankInfoApiModel updateBankInfo)
        {
            IDbDataParameter[] param = new[]
           {
                  dataContext.CreateParameter(DbType.Int32,"_committeeid", 500, updateBankInfo.CommitteeID, ParameterDirection.Input),
                  dataContext.CreateParameter(DbType.String,"_bankname", 200, updateBankInfo.BankName, ParameterDirection.Input),
                  dataContext.CreateParameter(DbType.String,"_address1", 200, updateBankInfo.Address1, ParameterDirection.Input),
                  dataContext.CreateParameter(DbType.String,"_address2", 200, updateBankInfo.Address2, ParameterDirection.Input),
                  dataContext.CreateParameter(DbType.String,"_city", 200, updateBankInfo.City, ParameterDirection.Input),
                  dataContext.CreateParameter(DbType.String,"_statecode", 200, updateBankInfo.StateCode, ParameterDirection.Input),
                  dataContext.CreateParameter(DbType.String,"_zip", 200, updateBankInfo.Zip, ParameterDirection.Input),
                };
            int committeeid = dataContext.Insert(@"select * from update_bankinfo(:_committeeid, :_bankname, :_address1, :_address2, :_city, :_statecode, :_zip)", commandType: CommandType.Text, param);
            return committeeid;

        }
        public async Task<int> SaveCommitteeAffiliation(CommitteeAffiliationApiModel committeeAffiliation)
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
            foreach (CommitteeAffiliationDetailApiModel commiitteeid in committeeAffiliation.CommitteeIds)
            {
                IDbDataParameter[] paramu = new[]
                {
                  dataContext.CreateParameter(DbType.String,"_requesttype", 100, "R", ParameterDirection.Input),
                  dataContext.CreateParameter(DbType.String,"_useremail", 150, "",  ParameterDirection.Input),
                  dataContext.CreateParameter(DbType.Int32,"_usercontactid", 150, committeeAffiliation.ContactID,  ParameterDirection.Input),
                  dataContext.CreateParameter(DbType.Int32, "_invitercontactid", 100, 0,  ParameterDirection.Input),
                  dataContext.CreateParameter(DbType.Int32, "_emailmessageid", 100, emailMessageId,  ParameterDirection.Input),
                  dataContext.CreateParameter(DbType.String, "_userjoinnote", 1000, committeeAffiliation.Notes,  ParameterDirection.Input),
                  dataContext.CreateParameter(DbType.Int32, "_committeeid", 100, commiitteeid.CommitteeID,  ParameterDirection.Input),
                };
                int userJoinRequestId = dataContext.Update(@"select * from save_userjoinrequest(:_requesttype, :_useremail, :_usercontactid, :_invitercontactid, :_emailmessageid, :_userjoinnote, :_committeeid)", commandType: CommandType.Text, paramu);
            }

            return emailMessageId;
        }

        public async Task<int> DeleteOfficer(int contactid)
        {
            IDbDataParameter[] param = new[]
                {
                  dataContext.CreateParameter(DbType.Int32,"_contactid", 200, contactid, ParameterDirection.InputOutput),
                };
            int res = dataContext.Delete(@"select * from delete_officers(:_contactid)", commandType: CommandType.Text, param);
            return res;
        }

        public async Task<int> CreateIssueCommittee(IssueCommitteeApiModel createIssueCommittee)
        {
            int committeeid = 0;
            int filerID = 0;
            int CommitteeContacID = 0;
            int CommitteeOtherContactID = 0;
            if (createIssueCommittee.IssueCommitteeDetail != null)
            {
                IDbDataParameter[] param = new[]
               {
                  dataContext.CreateParameter(DbType.String,"_name", 500, createIssueCommittee.IssueCommitteeDetail.CommitteeName, ParameterDirection.Input),
                  dataContext.CreateParameter(DbType.String,"_committeetypeid", 300, createIssueCommittee.IssueCommitteeDetail.CommitteeTypeID,  ParameterDirection.Input),
                  dataContext.CreateParameter(DbType.Int32,"_ballotissueid", 150, createIssueCommittee.IssueCommitteeDetail.BallotIssueID, ParameterDirection.Input),
                  dataContext.CreateParameter(DbType.Int32,"_electioncycleid", 150, createIssueCommittee.IssueCommitteeDetail.ElectionCycleID, ParameterDirection.Input),
                  dataContext.CreateParameter(DbType.String,"_position", 2000, createIssueCommittee.IssueCommitteeDetail.Position, ParameterDirection.Input),
                  dataContext.CreateParameter(DbType.String,"_purpose", 2000, createIssueCommittee.IssueCommitteeDetail.Purpose, ParameterDirection.Input),
                  dataContext.CreateParameter(DbType.String,"_registrationstatus", 200, "N"),
                  dataContext.CreateParameter(DbType.Int32,"_committeeid", 200, createIssueCommittee.IssueCommitteeDetail.CommitteeID),
                };
                committeeid = dataContext.Insert(@"select * from save_issuecommittee(:_name, :_committeetypeid, :_ballotissueid, :_electioncycleid, :_position, :_purpose, :_registrationstatus, :_committeeid)", commandType: CommandType.Text, param);
                if (createIssueCommittee.IssueCommitteeDetail.CommitteeID == 0)
                {
                    IDbDataParameter[] paramf = new[]
                 {
                  dataContext.CreateParameter(DbType.String,"_entitytype", 1000, "C", ParameterDirection.Input),
                  dataContext.CreateParameter(DbType.Int32,"_entityid", 150, committeeid,  ParameterDirection.Input),
                  dataContext.CreateParameter(DbType.Int32,"_categoryid", 150, 1,  ParameterDirection.Input),
                  dataContext.CreateParameter(DbType.String,"_filerstatus", 150, "A",  ParameterDirection.Input),
                };
                    filerID = dataContext.Insert(@"select * from save_filer(:_entitytype, :_entityid, :_categoryid, :_filerstatus)", commandType: CommandType.Text, paramf);

                }
            }
            if (createIssueCommittee.CommitteeContactDetail != null)
            {
                IDbDataParameter[] paramcoc = new[]
               {
                  dataContext.CreateParameter(DbType.String,"_contacttype", 100, "O", ParameterDirection.Input),
                  dataContext.CreateParameter(DbType.String,"_orgname", 1500, createIssueCommittee.CommitteeContactDetail.OrganizationName,  ParameterDirection.Input),
                  dataContext.CreateParameter(DbType.String,"_address1", 1500, createIssueCommittee.CommitteeContactDetail.Address1,  ParameterDirection.Input),
                  dataContext.CreateParameter(DbType.String,"_address2", 1500, createIssueCommittee.CommitteeContactDetail.Address2,  ParameterDirection.Input),
                  dataContext.CreateParameter(DbType.String,"_city", 200, createIssueCommittee.CommitteeContactDetail.City, ParameterDirection.Input),
                  dataContext.CreateParameter(DbType.String,"_statecode", 200, createIssueCommittee.CommitteeContactDetail.StateCode, ParameterDirection.Input),
                  dataContext.CreateParameter(DbType.String,"_zip", 200, createIssueCommittee.CommitteeContactDetail.Zip, ParameterDirection.Input),
                  dataContext.CreateParameter(DbType.Int32,"_filerid", 150, filerID,  ParameterDirection.Input),
                  dataContext.CreateParameter(DbType.String,"_statuscode", 200, "ACTIVE", ParameterDirection.Input),
                  dataContext.CreateParameter(DbType.Int32,"_committeeid", 200, createIssueCommittee.IssueCommitteeDetail.CommitteeID),
                };
                CommitteeContacID = dataContext.Insert(@"select * from save_committeecontact(:_contacttype, :_orgname, :_address1, :_address2, :_city, :_statecode, :_zip, :_filerid, :_statuscode, :_committeeid)", commandType: CommandType.Text, paramcoc);
            }
            if (createIssueCommittee.CommitteeOtherContactDetail != null)
            {
                IDbDataParameter[] paramcotc = new[]
               {
                  dataContext.CreateParameter(DbType.String,"_contacttype", 100, "O", ParameterDirection.Input),
                  dataContext.CreateParameter(DbType.String,"_phone", 150, createIssueCommittee.CommitteeOtherContactDetail.Phone,  ParameterDirection.Input),
                  dataContext.CreateParameter(DbType.String,"_email", 200, createIssueCommittee.CommitteeOtherContactDetail.Email,  ParameterDirection.Input),
                  dataContext.CreateParameter(DbType.String,"_altphone", 150, createIssueCommittee.CommitteeOtherContactDetail.AltPhone,  ParameterDirection.Input),
                  dataContext.CreateParameter(DbType.String,"_altemail", 200, createIssueCommittee.CommitteeOtherContactDetail.AltEmail,  ParameterDirection.Input),
                  dataContext.CreateParameter(DbType.Int32,"_filerid", 150, filerID,  ParameterDirection.Input),
                  dataContext.CreateParameter(DbType.String,"_statuscode", 200, "ACTIVE", ParameterDirection.Input),
                  dataContext.CreateParameter(DbType.Int32,"_committeeid", 200, createIssueCommittee.IssueCommitteeDetail.CommitteeID),
                };
                CommitteeOtherContactID = dataContext.Insert(@"select * from save_committeeothercontact(:_contacttype, :_phone, :_email, :_altphone, :_altemail, :_filerid, :_statuscode, :_committeeid)", commandType: CommandType.Text, paramcotc);
            }
            if (createIssueCommittee.IssueCommitteeDetail.CommitteeID == 0)
            {
                IDbDataParameter[] paramuc = new[]
             {
                  dataContext.CreateParameter(DbType.Int32,"_committeecontactid", 100, CommitteeContacID, ParameterDirection.Input),
                  dataContext.CreateParameter(DbType.Int32,"_candidatecontactid", 150, 0,  ParameterDirection.Input),
                  dataContext.CreateParameter(DbType.Int32,"_contactid", 200, createIssueCommittee.ContactID,  ParameterDirection.Input),
                  dataContext.CreateParameter(DbType.Int32,"_committeeothercontactid", 150, CommitteeOtherContactID,  ParameterDirection.Input),
                  dataContext.CreateParameter(DbType.Int32,"_committeeid", 150, committeeid,  ParameterDirection.Input),
                  dataContext.CreateParameter(DbType.Int32,"_filerid", 150, filerID,  ParameterDirection.Input),
                };
                committeeid = dataContext.Update(@"select * from update_committecontact(:_committeecontactid, :_candidatecontactid, :_contactid, :_committeeothercontactid, :_committeeid, :_filerid)", commandType: CommandType.Text, paramuc);

                IDbDataParameter[] paramcrm = new[]
         {
                  dataContext.CreateParameter(DbType.Int32,"_contactid", 200, createIssueCommittee.ContactID,  ParameterDirection.Input),
                  dataContext.CreateParameter(DbType.Int32,"_filerid", 150, filerID,  ParameterDirection.Input),
                };
                int contactrolemappingid = dataContext.Update(@"select * from save_contactrolemappingtreasuree( :_contactid, :_filerid)", commandType: CommandType.Text, paramcrm);

            }
            return committeeid;
        }

        public async Task<int> CreatePACCommittee(PACCommitteeApiModel createPACCommittee)
        {
            int committeeid = 0;
            int filerID = 0;
            int CommitteeContacID = 0;
            int CommitteeOtherContactID = 0;
            if (createPACCommittee.PACCommitteeDetail != null)
            {
                IDbDataParameter[] param = new[]
               {
                  dataContext.CreateParameter(DbType.String,"_committeename", 300, createPACCommittee.PACCommitteeDetail.CommitteeName,  ParameterDirection.Input),
                  dataContext.CreateParameter(DbType.String,"_committeetypeid", 300, createPACCommittee.PACCommitteeDetail.CommitteeTypeID,  ParameterDirection.Input),
                  dataContext.CreateParameter(DbType.String,"_purpose", 2000, createPACCommittee.PACCommitteeDetail.Purpose, ParameterDirection.Input),
                  dataContext.CreateParameter(DbType.String,"_registrationstatus", 200, "N"),
                  dataContext.CreateParameter(DbType.Int32,"_committeeid", 200, createPACCommittee.PACCommitteeDetail.CommitteeID),
                };
                committeeid = dataContext.Insert(@"select * from save_pacorsmalldonorcommittee(:_committeename, :_committeetypeid, :_purpose, :_registrationstatus, :_committeeid)", commandType: CommandType.Text, param);
                if (createPACCommittee.PACCommitteeDetail.CommitteeID == 0)
                {
                    IDbDataParameter[] paramf = new[]
                 {
                  dataContext.CreateParameter(DbType.String,"_entitytype", 1000, "C", ParameterDirection.Input),
                  dataContext.CreateParameter(DbType.Int32,"_entityid", 150, committeeid,  ParameterDirection.Input),
                  dataContext.CreateParameter(DbType.Int32,"_categoryid", 150, 1,  ParameterDirection.Input),
                  dataContext.CreateParameter(DbType.String,"_filerstatus", 150, "A",  ParameterDirection.Input),
                };
                    filerID = dataContext.Insert(@"select * from save_filer(:_entitytype, :_entityid, :_categoryid, :_filerstatus)", commandType: CommandType.Text, paramf);
                }

            }
            if (createPACCommittee.CommitteeContactDetail != null)
            {
                IDbDataParameter[] paramcoc = new[]
               {
                  dataContext.CreateParameter(DbType.String,"_contacttype", 100, "O", ParameterDirection.Input),
                  dataContext.CreateParameter(DbType.String,"_orgname", 1500, createPACCommittee.CommitteeContactDetail.OrganizationName,  ParameterDirection.Input),
                  dataContext.CreateParameter(DbType.String,"_address1", 1500, createPACCommittee.CommitteeContactDetail.Address1,  ParameterDirection.Input),
                  dataContext.CreateParameter(DbType.String,"_address2", 1500, createPACCommittee.CommitteeContactDetail.Address2,  ParameterDirection.Input),
                  dataContext.CreateParameter(DbType.String,"_city", 200, createPACCommittee.CommitteeContactDetail.City, ParameterDirection.Input),
                  dataContext.CreateParameter(DbType.String,"_statecode", 200, createPACCommittee.CommitteeContactDetail.StateCode, ParameterDirection.Input),
                  dataContext.CreateParameter(DbType.String,"_zip", 200, createPACCommittee.CommitteeContactDetail.Zip, ParameterDirection.Input),
                  dataContext.CreateParameter(DbType.Int32,"_filerid", 150, filerID,  ParameterDirection.Input),
                  dataContext.CreateParameter(DbType.String,"_statuscode", 200, "ACTIVE", ParameterDirection.Input),
                  dataContext.CreateParameter(DbType.Int32,"_committeeid", 200, createPACCommittee.PACCommitteeDetail.CommitteeID),
                };
                CommitteeContacID = dataContext.Insert(@"select * from save_committeecontact(:_contacttype, :_orgname, :_address1, :_address2, :_city, :_statecode, :_zip, :_filerid, :_statuscode, :_committeeid)", commandType: CommandType.Text, paramcoc);
            }
            if (createPACCommittee.CommitteeOtherContactDetail != null)
            {
                IDbDataParameter[] paramcotc = new[]
               {
                  dataContext.CreateParameter(DbType.String,"_contacttype", 100, "O", ParameterDirection.Input),
                  dataContext.CreateParameter(DbType.String,"_phone", 150, createPACCommittee.CommitteeOtherContactDetail.Phone,  ParameterDirection.Input),
                  dataContext.CreateParameter(DbType.String,"_email", 200, createPACCommittee.CommitteeOtherContactDetail.Email,  ParameterDirection.Input),
                  dataContext.CreateParameter(DbType.String,"_altphone", 150, createPACCommittee.CommitteeOtherContactDetail.AltPhone,  ParameterDirection.Input),
                  dataContext.CreateParameter(DbType.String,"_altemail", 200, createPACCommittee.CommitteeOtherContactDetail.AltEmail,  ParameterDirection.Input),
                  dataContext.CreateParameter(DbType.Int32,"_filerid", 150, filerID,  ParameterDirection.Input),
                  dataContext.CreateParameter(DbType.String,"_statuscode", 200, "ACTIVE", ParameterDirection.Input),
                  dataContext.CreateParameter(DbType.Int32,"_committeeid", 200, createPACCommittee.PACCommitteeDetail.CommitteeID),
                };
                CommitteeOtherContactID = dataContext.Insert(@"select * from save_committeeothercontact(:_contacttype, :_phone, :_email, :_altphone, :_altemail, :_filerid, :_statuscode, :_committeeid)", commandType: CommandType.Text, paramcotc);
            }
            if (createPACCommittee.PACCommitteeDetail.CommitteeID == 0)
            {
                IDbDataParameter[] paramuc = new[]
             {
                  dataContext.CreateParameter(DbType.Int32,"_committeecontactid", 100, CommitteeContacID, ParameterDirection.Input),
                  dataContext.CreateParameter(DbType.Int32,"_candidatecontactid", 150, 0,  ParameterDirection.Input),
                  dataContext.CreateParameter(DbType.Int32,"_contactid", 200, createPACCommittee.ContactID,  ParameterDirection.Input),
                  dataContext.CreateParameter(DbType.Int32,"_committeeothercontactid", 150, CommitteeOtherContactID,  ParameterDirection.Input),
                  dataContext.CreateParameter(DbType.Int32,"_committeeid", 150, committeeid,  ParameterDirection.Input),
                  dataContext.CreateParameter(DbType.Int32,"_filerid", 150, filerID,  ParameterDirection.Input),
                };
                committeeid = dataContext.Update(@"select * from update_committecontact(:_committeecontactid, :_candidatecontactid, :_contactid, :_committeeothercontactid, :_committeeid, :_filerid)", commandType: CommandType.Text, paramuc);

                IDbDataParameter[] paramcrm = new[]
              {
                  dataContext.CreateParameter(DbType.Int32,"_contactid", 200, createPACCommittee.ContactID,  ParameterDirection.Input),
                  dataContext.CreateParameter(DbType.Int32,"_filerid", 150, filerID,  ParameterDirection.Input),
                };
                int contactrolemappingid = dataContext.Update(@"select * from save_contactrolemappingtreasuree( :_contactid, :_filerid)", commandType: CommandType.Text, paramcrm);

            }

            return committeeid;
        }


        public async Task<int> CreateSmallDonorCommittee(SmallDonorApiModel createSmallDonorCommittee)
        {
            int committeeid = 0;
            int filerID = 0;
            int CommitteeContacID = 0;
            int CommitteeOtherContactID = 0;
            if (createSmallDonorCommittee.SmallDonorCommitteeDetail != null)
            {
                IDbDataParameter[] param = new[]
               {
                  dataContext.CreateParameter(DbType.String,"_committeename", 300, createSmallDonorCommittee.SmallDonorCommitteeDetail.CommitteeName,  ParameterDirection.Input),
                  dataContext.CreateParameter(DbType.String,"_committeetypeid", 300, createSmallDonorCommittee.SmallDonorCommitteeDetail.CommitteeTypeID,  ParameterDirection.Input),
                  dataContext.CreateParameter(DbType.String,"_purpose", 2000, createSmallDonorCommittee.SmallDonorCommitteeDetail.Purpose, ParameterDirection.Input),
                  dataContext.CreateParameter(DbType.String,"_registrationstatus", 200, "N"),
                  dataContext.CreateParameter(DbType.Int32,"_committeeid", 200, createSmallDonorCommittee.SmallDonorCommitteeDetail.CommitteeID),
                };
                committeeid = dataContext.Insert(@"select * from save_pacorsmalldonorcommittee(:_committeename, :_committeetypeid, :_purpose, :_registrationstatus, :_committeeid)", commandType: CommandType.Text, param);
                if (createSmallDonorCommittee.SmallDonorCommitteeDetail.CommitteeID == 0)
                {
                    IDbDataParameter[] paramf = new[]
                 {
                  dataContext.CreateParameter(DbType.String,"_entitytype", 1000, "C", ParameterDirection.Input),
                  dataContext.CreateParameter(DbType.Int32,"_entityid", 150, committeeid,  ParameterDirection.Input),
                  dataContext.CreateParameter(DbType.Int32,"_categoryid", 150, 1,  ParameterDirection.Input),
                  dataContext.CreateParameter(DbType.String,"_filerstatus", 150, "A",  ParameterDirection.Input),
                };
                    filerID = dataContext.Insert(@"select * from save_filer(:_entitytype, :_entityid, :_categoryid, :_filerstatus)", commandType: CommandType.Text, paramf);
                }
            }
            if (createSmallDonorCommittee.CommitteeContactDetail != null)
            {
                IDbDataParameter[] paramcoc = new[]
               {
                  dataContext.CreateParameter(DbType.String,"_contacttype", 100, "O", ParameterDirection.Input),
                  dataContext.CreateParameter(DbType.String,"_orgname", 1500, createSmallDonorCommittee.CommitteeContactDetail.OrganizationName,  ParameterDirection.Input),
                  dataContext.CreateParameter(DbType.String,"_address1", 1500, createSmallDonorCommittee.CommitteeContactDetail.Address1,  ParameterDirection.Input),
                  dataContext.CreateParameter(DbType.String,"_address2", 1500, createSmallDonorCommittee.CommitteeContactDetail.Address2,  ParameterDirection.Input),
                  dataContext.CreateParameter(DbType.String,"_city", 200, createSmallDonorCommittee.CommitteeContactDetail.City, ParameterDirection.Input),
                  dataContext.CreateParameter(DbType.String,"_statecode", 200, createSmallDonorCommittee.CommitteeContactDetail.StateCode, ParameterDirection.Input),
                  dataContext.CreateParameter(DbType.String,"_zip", 200, createSmallDonorCommittee.CommitteeContactDetail.Zip, ParameterDirection.Input),
                  dataContext.CreateParameter(DbType.Int32,"_filerid", 150, filerID,  ParameterDirection.Input),
                  dataContext.CreateParameter(DbType.String,"_statuscode", 200, "Active", ParameterDirection.Input),
                  dataContext.CreateParameter(DbType.Int32,"_committeeid", 200, createSmallDonorCommittee.SmallDonorCommitteeDetail.CommitteeID),
                };
                CommitteeContacID = dataContext.Insert(@"select * from save_committeecontact(:_contacttype, :_orgname, :_address1, :_address2, :_city, :_statecode, :_zip, :_filerid, :_statuscode, :_committeeid)", commandType: CommandType.Text, paramcoc);
            }
            if (createSmallDonorCommittee.CommitteeOtherContactDetail != null)
            {
                IDbDataParameter[] paramcotc = new[]
               {
                  dataContext.CreateParameter(DbType.String,"_contacttype", 100, "O", ParameterDirection.Input),
                  dataContext.CreateParameter(DbType.String,"_phone", 150, createSmallDonorCommittee.CommitteeOtherContactDetail.Phone,  ParameterDirection.Input),
                  dataContext.CreateParameter(DbType.String,"_email", 200, createSmallDonorCommittee.CommitteeOtherContactDetail.Email,  ParameterDirection.Input),
                  dataContext.CreateParameter(DbType.String,"_altphone", 150, createSmallDonorCommittee.CommitteeOtherContactDetail.AltPhone,  ParameterDirection.Input),
                  dataContext.CreateParameter(DbType.String,"_altemail", 200, createSmallDonorCommittee.CommitteeOtherContactDetail.AltEmail,  ParameterDirection.Input),
                  dataContext.CreateParameter(DbType.Int32,"_filerid", 150, filerID,  ParameterDirection.Input),
                  dataContext.CreateParameter(DbType.String,"_statuscode", 200, "Active", ParameterDirection.Input),
                  dataContext.CreateParameter(DbType.Int32,"_committeeid", 200, createSmallDonorCommittee.SmallDonorCommitteeDetail.CommitteeID),
                };
                CommitteeOtherContactID = dataContext.Insert(@"select * from save_committeeothercontact(:_contacttype, :_phone, :_email, :_altphone, :_altemail, :_filerid, :_statuscode, :_committeeid)", commandType: CommandType.Text, paramcotc);
            }
            if (createSmallDonorCommittee.SmallDonorCommitteeDetail.CommitteeID == 0)
            {
                IDbDataParameter[] paramuc = new[]
             {
                  dataContext.CreateParameter(DbType.Int32,"_committeecontactid", 100, CommitteeContacID, ParameterDirection.Input),
                  dataContext.CreateParameter(DbType.Int32,"_candidatecontactid", 150, 0,  ParameterDirection.Input),
                  dataContext.CreateParameter(DbType.Int32,"_contactid", 200, createSmallDonorCommittee.ContactID,  ParameterDirection.Input),
                  dataContext.CreateParameter(DbType.Int32,"_committeeothercontactid", 150, CommitteeOtherContactID,  ParameterDirection.Input),
                  dataContext.CreateParameter(DbType.Int32,"_committeeid", 150, committeeid,  ParameterDirection.Input),
                  dataContext.CreateParameter(DbType.Int32,"_filerid", 150, filerID,  ParameterDirection.Input),
                };
                committeeid = dataContext.Update(@"select * from update_committecontact(:_committeecontactid, :_candidatecontactid, :_contactid, :_committeeothercontactid, :_committeeid, :_filerid)", commandType: CommandType.Text, paramuc);

                IDbDataParameter[] paramcrm = new[]
            {
                  dataContext.CreateParameter(DbType.Int32,"_contactid", 200, createSmallDonorCommittee.ContactID,  ParameterDirection.Input),
                  dataContext.CreateParameter(DbType.Int32,"_filerid", 150, filerID,  ParameterDirection.Input),
                };
                int contactrolemappingid = dataContext.Update(@"select * from save_contactrolemappingtreasuree( :_contactid, :_filerid)", commandType: CommandType.Text, paramcrm);

            }

            return committeeid;
        }

        public async Task<List<GetOfficerApiModel>> GetOfficersListByName(string officerName, int committeeId)
        {
            IDbDataParameter[] param = new[]
            {
                  dataContext.CreateParameter(DbType.String,"_officername", 100, officerName, ParameterDirection.InputOutput),
                  dataContext.CreateParameter(DbType.Int32,"_committeeid", 100, committeeId, ParameterDirection.InputOutput),
            };
            var dtCommitteeList = dataContext.GetDataTable(@"SELECT * FROM get_officerbyname(:_officername, :_committeeid)", commandType: CommandType.Text, param);

            List<GetOfficerApiModel> officerlist = tableConverter.ConvertToList<GetOfficerApiModel>(dtCommitteeList);
            return officerlist;
        }

        public async Task<int> CreateCoveredOfficial(int contactId)
        {
            int filerID = 0;

            IDbDataParameter[] paramf = new[]
         {
                  dataContext.CreateParameter(DbType.String,"_entitytype", 1000, "CO", ParameterDirection.Input),
                  dataContext.CreateParameter(DbType.Int32,"_entityid", 150, contactId,  ParameterDirection.Input),
                  dataContext.CreateParameter(DbType.Int32,"_categoryid", 150, 6,  ParameterDirection.Input),
                  dataContext.CreateParameter(DbType.String,"_filerstatus", 150, "A",  ParameterDirection.Input),
                };
            filerID = dataContext.Insert(@"select * from save_filer(:_entitytype, :_entityid, :_categoryid, :_filerstatus)", commandType: CommandType.Text, paramf);

            IDbDataParameter[] paramcrmm = new[]
{
                  dataContext.CreateParameter(DbType.Int32,"_contactid", 200, contactId,  ParameterDirection.Input),
                  dataContext.CreateParameter(DbType.Int32,"_filerid", 150, filerID,  ParameterDirection.Input),
                  dataContext.CreateParameter(DbType.Int32,"_roletypeid", 150, 3,  ParameterDirection.Input),
                };
            int contactrolemappingidd = dataContext.Update(@"select * from save_contactrolemappingtreasuree( :_contactid, :_filerid, :_roletypeid)", commandType: CommandType.Text, paramcrmm);


            return contactId;
        }
        public async Task<CommitteeDetailsResponseApiModel> GetCommitteeDetails(int committeeid)
        {
            List<CommitteeResponseApiModel> committeeResponseApiModels = new List<CommitteeResponseApiModel>();
            List<CommitteeContactResponseApiModel> committeeContactResponseApiModels = new List<CommitteeContactResponseApiModel>();
            List<GetOfficerApiModel> getOfficerApiModels = new List<GetOfficerApiModel>();
            List<BankInfoApiModel> bankInfoApiModels = new List<BankInfoApiModel>();
            CommitteeDetailsResponseApiModel committeeDetailsResponse = new CommitteeDetailsResponseApiModel();
            IDbDataParameter[] param = new[]
            {
                  dataContext.CreateParameter(DbType.Int32,"_committeeid", 100, committeeid, ParameterDirection.InputOutput),
            };
            var dtCommitteeList = dataContext.GetDataTable(@"SELECT * FROM get_committeebyid(:_committeeid)", commandType: CommandType.Text, param);

            List<CommitteeResponseApiModel> committeedetail = tableConverter.ConvertToList<CommitteeResponseApiModel>(dtCommitteeList);
            IDbDataParameter[] paramcc = new[]
           {
                  dataContext.CreateParameter(DbType.Int32,"_committeeid", 100, committeeid, ParameterDirection.InputOutput),
            };
            var dtCommitteecontactList = dataContext.GetDataTable(@"SELECT * FROM get_committeecontactbyid(:_committeeid)", commandType: CommandType.Text, paramcc);

            List<CommitteeContactResponseApiModel> committeecontactdetail = tableConverter.ConvertToList<CommitteeContactResponseApiModel>(dtCommitteecontactList);

            IDbDataParameter[] paramo = new[]
          {
                  dataContext.CreateParameter(DbType.Int32,"committeeid", 100, committeeid, ParameterDirection.InputOutput)
           };
            var ResultDT = dataContext.GetDataTable(@"select * from get_officerlist(:committeeid)", commandType: CommandType.Text, paramo);

            List<GetOfficerApiModel> officerlist = tableConverter.ConvertToList<GetOfficerApiModel>(ResultDT);

            IDbDataParameter[] paramb = new[]
         {
                  dataContext.CreateParameter(DbType.Int32,"committeeid", 100, committeeid, ParameterDirection.InputOutput)
           };
            var dtBankinfo = dataContext.GetDataTable(@"select * from get_bankinfo(:committeeid)", commandType: CommandType.Text, paramb);

            List<BankInfoApiModel> Bankinfo = tableConverter.ConvertToList<BankInfoApiModel>(dtBankinfo);

            if (dtCommitteeList.Rows.Count != 0)
            {
                foreach (var resec in committeedetail)
                {
                    committeeResponseApiModels.Add(new CommitteeResponseApiModel
                    {
                        CommitteeID = resec.CommitteeID,
                        CommitteeName = resec.CommitteeName,
                        OfficeSought = resec.OfficeSought,
                        District = resec.District,
                        ElectionDate = resec.ElectionDate,
                        CandidateName = resec.CandidateName,
                        Status = resec.Status
                    });
                }
                committeeDetailsResponse.CommitteeDetail = committeeResponseApiModels;
            }

            if (dtCommitteecontactList.Rows.Count != 0)
            {
                foreach (var resec in committeecontactdetail)
                {
                    committeeContactResponseApiModels.Add(new CommitteeContactResponseApiModel
                    {
                        ContactID = resec.ContactID,
                        Address1 = resec.Address1,
                        Address2 = resec.Address2,
                        City = resec.City,
                        State = resec.State,
                        Zip = resec.Zip,
                        Email = resec.Email,
                        Phone = resec.Phone,
                        AltEmail = resec.AltEmail,
                        AltPhone = resec.AltPhone,
                        CampaignWebsite = resec.CampaignWebsite
                    });
                }
                committeeDetailsResponse.CommitteeContactDetail = committeeContactResponseApiModels;
            }

            if (ResultDT.Rows.Count != 0)
            {
                foreach (var resec in officerlist)
                {
                    getOfficerApiModels.Add(new GetOfficerApiModel
                    {
                        ContactID = resec.ContactID,
                        FirstName = resec.FirstName,
                        LastName = resec.LastName,
                        OrganizationName = resec.OrganizationName,
                        Address1 = resec.Address1,
                        Address2 = resec.Address2,
                        City = resec.City,
                        State = resec.State,
                        Zip = resec.Zip,
                        Email = resec.Email,
                        Phone = resec.Phone,
                        Occupation = resec.Occupation,
                        Description = resec.Description,
                        RoleName = resec.RoleName
                    });
                }
                committeeDetailsResponse.OfficerDetail = getOfficerApiModels;
            }

            if (dtBankinfo.Rows.Count != 0)
            {
                foreach (var resec in Bankinfo)
                {
                    bankInfoApiModels.Add(new BankInfoApiModel
                    {
                        CommitteeID = resec.CommitteeID,
                        BankName = resec.BankName,
                        Address1 = resec.Address1,
                        Address2 = resec.Address2,
                        City = resec.City,
                        StateCode = resec.StateCode,
                        Zip = resec.Zip
                    });
                }
                committeeDetailsResponse.BankInfoDetail = bankInfoApiModels;
            }
            return committeeDetailsResponse;
        }

        public async Task<int> UpdateCommitteeorLobbyistStatus(StatusUpdateRequestApiModel statusUpdate)
        {
            int retValue = 0;
            IDbDataParameter[] param = new[]
            {
                  dataContext.CreateParameter(DbType.Int32,"_id", 100, statusUpdate.Id, ParameterDirection.InputOutput),
                  dataContext.CreateParameter(DbType.Boolean,"_status", 10, statusUpdate.Status, ParameterDirection.InputOutput),
                  dataContext.CreateParameter(DbType.String,"_notes", 1000, statusUpdate.Notes, ParameterDirection.InputOutput),
                  dataContext.CreateParameter(DbType.String,"_entitytype", 1000, statusUpdate.EntityType, ParameterDirection.InputOutput),
            };
            retValue = dataContext.Update(@"select * from update_committeeorlobbyistStatus(:_id, :_status, :_notes, :_entitytype)", commandType: CommandType.Text, param);
            return retValue;
        }
    }
}
