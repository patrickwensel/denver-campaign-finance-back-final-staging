using Denver.DataAccess;
using Denver.Infra.Common;
using Microsoft.Extensions.Configuration;
using System.Collections.Generic;
using System.Data;
using System.Threading.Tasks;
using UserManagementApi.Domain.ViewModels;
using UserManagementApi.Domain.ApiModels;
using UserManagementApi.Domain.ApiModels.Committee;
using UserManagementApi.Domain.Repositories;

namespace UserManagementApi.DataCore.Repositories
{
    public class SystemManagementRepository : ISystemManagementRepository
    {
        DataTableToList tableConverter;
        private DBManager dataContext;
        public SystemManagementRepository(IConfiguration configuration)
        {
            dataContext = new DBManager(configuration.GetConnectionString("AppDB"), DataProvider.PostgreSQL);
            tableConverter = new DataTableToList();
        }
        public async Task<int> CreateBallotIssues(BallotIssueApiModel ballotIssues)
        {
            IDbDataParameter[] param = new[]
               {
                  dataContext.CreateParameter(DbType.String,"ballotissuecode", 200, ballotIssues.BallotIssueCode, ParameterDirection.InputOutput),
                  dataContext.CreateParameter(DbType.String,"ballotissue", 1000, ballotIssues.BallotIssue,  ParameterDirection.InputOutput),
                  dataContext.CreateParameter(DbType.String,"electioncycle", 500, ballotIssues.ElectionCycle, ParameterDirection.Input),
                  dataContext.CreateParameter(DbType.String,"_description", 500, ballotIssues.Description, ParameterDirection.Input),
                };
            int res = dataContext.Insert(@"select * from save_ballotissuesm(:ballotissuecode, :ballotissue, :electioncycle, :_description)", commandType: CommandType.Text, param);
            return res;
        }

        public async Task<int> UpdateBallotIssues(BallotIssueApiModel ballotIssues)
        {
            IDbDataParameter[] param = new[]
               {
                  dataContext.CreateParameter(DbType.Int32,"_ballot_issue_id", 100, ballotIssues.BallotId, ParameterDirection.InputOutput),
                  dataContext.CreateParameter(DbType.String,"_ballot_issue_code", 200, ballotIssues.BallotIssueCode, ParameterDirection.InputOutput),
                  dataContext.CreateParameter(DbType.String,"_ballot_issue", 1000, ballotIssues.BallotIssue,  ParameterDirection.InputOutput),
                  dataContext.CreateParameter(DbType.String,"_election_cycle", 500, ballotIssues.ElectionCycle, ParameterDirection.Input),
                  dataContext.CreateParameter(DbType.String,"_description", 500, ballotIssues.Description, ParameterDirection.Input),
                };
            int res = dataContext.Update(@"select * from update_ballotissuesm(:_ballot_issue_id, :_ballot_issue_code, :_ballot_issue, :_election_cycle, :_description)", commandType: CommandType.Text, param);
            return res;
        }
        public async Task<int> DeleteBallotIssues(int BallotId)
        {
            IDbDataParameter[] param = new[]
                {
                  dataContext.CreateParameter(DbType.Int32,"ballotissueid", 100, BallotId, ParameterDirection.InputOutput),
                };
            int res = dataContext.Delete(@"select * from delete_ballotissuesm(:ballotissueid)", commandType: CommandType.Text, param);
            return res;
        }

        public async Task<List<BallotIssueApiModel>> GetBallotIssuesList()
        {
            DataTable ResultDT = dataContext.GetDataTable(@"select * from get_ballotissuesm()", commandType: CommandType.Text, null);

            List<BallotIssueApiModel> BallotIssueslist = tableConverter.ConvertToList<BallotIssueApiModel>(ResultDT);
            return BallotIssueslist;
        }


        public async Task<List<ContributionLimitsApiModel>> GetContributionLimitsList()
        {
            DataTable ResultDT = dataContext.GetDataTable(@"select * from get_contributionLimits()", commandType: CommandType.Text, null);

            List<ContributionLimitsApiModel> contributionLimitslist = tableConverter.ConvertToList<ContributionLimitsApiModel>(ResultDT);
            return contributionLimitslist;
        }

        public async Task<int> CreateContributionLimits(ContributionLimitsApiModel contributionLimits)
        {
            IDbDataParameter[] param = new[]
               {
                dataContext.CreateParameter(DbType.String,"commiteetypeid", 1000, contributionLimits.CommiteeTypeId, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.String,"officetypeid", 1000, contributionLimits.OfficeTypeId,  ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.String,"donortypeid", 1000, contributionLimits.DonorTypeId, ParameterDirection.Input),
                dataContext.CreateParameter(DbType.Int32,"electioncycleid", 100, contributionLimits.ElectionCycleId, ParameterDirection.Input),
                dataContext.CreateParameter(DbType.Int32,"tenantid", 100, contributionLimits.TenantId, ParameterDirection.Input),
                dataContext.CreateParameter(DbType.String,"commiteetype", 1000, contributionLimits.CommiteeType, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.String,"officetype", 1000, contributionLimits.OfficeType,  ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.String,"donortype", 1000, contributionLimits.DonorType, ParameterDirection.Input),
                dataContext.CreateParameter(DbType.String,"electionyear", 100, contributionLimits.ElectionYear, ParameterDirection.Input),
                dataContext.CreateParameter(DbType.String,"des", 500, contributionLimits.Descript, ParameterDirection.Input),
                dataContext.CreateParameter(DbType.Decimal,"contlimit", 100, contributionLimits.ContLimit, ParameterDirection.Input),
            };
            int res = dataContext.Insert(@"select * from save_contributionLimits(:commiteetypeid,:officetypeid,:donortypeid,:electioncycleid,:tenantid,:commiteetype,:officetype,:donortype,:electionyear,:des,:contlimit)", commandType: CommandType.Text, param);
            return res;
        }

        public async Task<int> UpdateContributionLimits(ContributionLimitsApiModel contributionLimits)
        {
            IDbDataParameter[] param = new[]
               {
                dataContext.CreateParameter(DbType.Int32,"cntlimitid", 100, contributionLimits.Id, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.String,"commiteetypeid", 1000, contributionLimits.CommiteeTypeId, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.String,"officetypeid", 1000, contributionLimits.OfficeTypeId,  ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.String,"donortypeid", 1000, contributionLimits.DonorTypeId, ParameterDirection.Input),
                dataContext.CreateParameter(DbType.Int32,"electioncycleid", 100, contributionLimits.ElectionCycleId, ParameterDirection.Input),
                dataContext.CreateParameter(DbType.Int32,"tenantid", 100, contributionLimits.TenantId, ParameterDirection.Input),
                dataContext.CreateParameter(DbType.String,"commiteetype", 1000, contributionLimits.CommiteeType, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.String,"officetype", 1000, contributionLimits.OfficeType,  ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.String,"donortype", 500, contributionLimits.DonorType, ParameterDirection.Input),
                dataContext.CreateParameter(DbType.String,"electionyear", 100, contributionLimits.ElectionYear, ParameterDirection.Input),
                dataContext.CreateParameter(DbType.String,"des", 500, contributionLimits.Descript, ParameterDirection.Input),
                dataContext.CreateParameter(DbType.Decimal,"contlimit", 100, contributionLimits.ContLimit, ParameterDirection.Input),
                };
            int res = dataContext.Update(@"select * from update_contributionLimits(:cntlimitid,:commiteetypeid,:officetypeid,:donortypeid,:electioncycleid,:tenantid,:commiteetype,:officetype,:donortype,:electionyear,:des,:contlimit)", commandType: CommandType.Text, param);
            return res;
        }


        public async Task<int> DeleteContributionLimits(int id)
        {
            IDbDataParameter[] param = new[]
                {
                  dataContext.CreateParameter(DbType.Int32,"_id", 100, id, ParameterDirection.InputOutput),
                };
            int res = dataContext.Delete(@"select * from delete_contributionLimits(:_id)", commandType: CommandType.Text, param);
            return res;
        }

        public async Task<List<FillerTypeApiModel>> GetFillerTypeList()
        {
            DataTable ResultDT = dataContext.GetDataTable(@"select * from get_fillertypes()", commandType: CommandType.Text, null);

            List<FillerTypeApiModel> fillerTypelist = tableConverter.ConvertToList<FillerTypeApiModel>(ResultDT);
            return fillerTypelist;
        }
        public async Task<List<DonorTypeApiModel>> GetDonorTypeList()
        {
            DataTable ResultDT = dataContext.GetDataTable(@"select * from get_donortypes()", commandType: CommandType.Text, null);

            List<DonorTypeApiModel> donorTypelist = tableConverter.ConvertToList<DonorTypeApiModel>(ResultDT);
            return donorTypelist;
        }
        public async Task<List<OfficeTypeApiModel>> GetOfficeTypeList()
        {
            DataTable ResultDT = dataContext.GetDataTable(@"select * from get_officetypes()", commandType: CommandType.Text, null);

            List<OfficeTypeApiModel> officeTypelist = tableConverter.ConvertToList<OfficeTypeApiModel>(ResultDT);
            return officeTypelist;
        }

        public async Task<List<ElectionApiModel>> GetElectionList()
        {
            DataTable ResultDT = dataContext.GetDataTable(@"select * from get_electionlist()", commandType: CommandType.Text, null);

            List<ElectionApiModel> electionlist = tableConverter.ConvertToList<ElectionApiModel>(ResultDT);
            return electionlist;
        }
        public async Task<int> SaveCommitteType(GetCommitteListTypeApiModel addCommitteTypes)
        {
            int result;
            if (addCommitteTypes.TypeId == "")
            {
                string typeId = System.Guid.NewGuid().ToString();
                IDbDataParameter[] param = new[]
                   {
                        dataContext.CreateParameter(DbType.String,"_typename", 100, addCommitteTypes.TypeName, ParameterDirection.InputOutput),
                        dataContext.CreateParameter(DbType.String,"_typeid", 100, typeId, ParameterDirection.InputOutput),
               };
                result = dataContext.Insert(@"select * from save_committetypes(:_typename, :_typeid)", commandType: CommandType.Text, param);

            }
            else
            {
                IDbDataParameter[] param = new[]
                   {
                        dataContext.CreateParameter(DbType.String,"_typename", 100, addCommitteTypes.TypeName, ParameterDirection.InputOutput),
                        dataContext.CreateParameter(DbType.String,"_typeid", 100, addCommitteTypes.TypeId, ParameterDirection.InputOutput),
               };
                result = dataContext.Insert(@"select * from save_committetypes(:_typename, :_typeid)", commandType: CommandType.Text, param);

            }
            return result;
        }      
        public async Task<int> DeleteCommitteeType(string typeId, string typeCode)
        {
            IDbDataParameter[] param = new[]
                {
                  dataContext.CreateParameter(DbType.String,"_typeid", 100, typeId, ParameterDirection.InputOutput),
                  dataContext.CreateParameter(DbType.String,"_typeCode", 100, typeCode, ParameterDirection.InputOutput),
                };
            int res = dataContext.Delete(@"select * from delete_committetypename(:_typeid, :_typeCode)", commandType: CommandType.Text, param);
            return res;
        }
        public async Task<List<GetCommitteListTypeApiModel>> GetCommitteTypeList()
        {
            DataTable ResultDT = dataContext.GetDataTable(@"select * from get_CommitteeTypedetails()", commandType: CommandType.Text, null);

            List<GetCommitteListTypeApiModel> Committetlist = tableConverter.ConvertToList<GetCommitteListTypeApiModel>(ResultDT);
            return Committetlist;
        }
        public async Task<int> SaveOffice(AddOfficeApiModel addOffice)
        {
            int result;
            if (addOffice.TypeId == "")
            {
                string typeId = System.Guid.NewGuid().ToString();
                IDbDataParameter[] param = new[]
                   {
                        dataContext.CreateParameter(DbType.String,"_typename", 100, addOffice.TypeName, ParameterDirection.InputOutput),
                        dataContext.CreateParameter(DbType.String,"_typeid", 100, typeId, ParameterDirection.InputOutput),
               };
                result = dataContext.Insert(@"select * from save_officesdetails(:_typename, :_typeid)", commandType: CommandType.Text, param);
                
            }
            else
            {
                IDbDataParameter[] param = new[]
                   {
                        dataContext.CreateParameter(DbType.String,"_typename", 100, addOffice.TypeName, ParameterDirection.InputOutput),
                        dataContext.CreateParameter(DbType.String,"_typeid", 100, addOffice.TypeId, ParameterDirection.InputOutput),
               };
                result = dataContext.Insert(@"select * from save_officesdetails(:_typename, :_typeid)", commandType: CommandType.Text, param);

            }
            return result;
        }     
        public async Task<int> DeleteOffices(string typeId, string typeCode)
        {
            IDbDataParameter[] param = new[]
                {
                  dataContext.CreateParameter(DbType.String,"_typeid", 100, typeId, ParameterDirection.InputOutput),
                  dataContext.CreateParameter(DbType.String,"_typeCode", 100, typeCode, ParameterDirection.InputOutput),
                };
            int res = dataContext.Delete(@"select * from delete_offices(:_typeid, :_typeCode)", commandType: CommandType.Text, param);
            return res;
        }
        public async Task<List<AddOfficeApiModel>> GetallOfficeList()
        {
            DataTable ResultDT = dataContext.GetDataTable(@"select * from get_officelistdetails()", commandType: CommandType.Text, null);
            List<AddOfficeApiModel> Studentlist = tableConverter.ConvertToList<AddOfficeApiModel>(ResultDT);
            return Studentlist;
        }
        public async Task<int> AddMatchingLimits(AddMatchingLimitApiModel addMatchingLimit)
        {
            IDbDataParameter[] param = new[]
               {
                  dataContext.CreateParameter(DbType.Decimal,"qualifyingcontributionamount", 100, addMatchingLimit.QualifyingContributionAmount, ParameterDirection.InputOutput), 
                  dataContext.CreateParameter(DbType.Decimal,"matchingcontributionamount", 100, addMatchingLimit.MatchingContributionAmount, ParameterDirection.InputOutput), 
                  dataContext.CreateParameter(DbType.Int32,"numberrequiredqualifyingcontributions", 100, addMatchingLimit.NumberRequiredQualifyingContributions, ParameterDirection.InputOutput), 
                  dataContext.CreateParameter(DbType.String,"matchingratio", 100, addMatchingLimit.MatchingRatio,  ParameterDirection.InputOutput), 
                  dataContext.CreateParameter(DbType.Int32,"contributionlimitsforparticipate", 100, addMatchingLimit.ContributionLimitsforParticipate,  ParameterDirection.InputOutput), 
                  dataContext.CreateParameter(DbType.Decimal,"_totalavailablefunds", 100, addMatchingLimit.TotalAvailableFunds,  ParameterDirection.InputOutput), 
                  dataContext.CreateParameter(DbType.String,"officetypeid", 1000, addMatchingLimit.OfficeTypeId,  ParameterDirection.InputOutput), 
                  dataContext.CreateParameter(DbType.String,"qualifyingoffices", 1000, addMatchingLimit.QualifyingOffices,  ParameterDirection.InputOutput), 
                  dataContext.CreateParameter(DbType.Date,"startdate", 100, addMatchingLimit.StartDate,  ParameterDirection.InputOutput), 
                  dataContext.CreateParameter(DbType.Date,"endate", 100, addMatchingLimit.Enddate,  ParameterDirection.InputOutput),
                  dataContext.CreateParameter(DbType.String,"electionCycle", 1000, addMatchingLimit.ElectionCycle,  ParameterDirection.InputOutput),
                };
            int res = dataContext.Insert(@"select * from save_matchingdetails(:qualifyingcontributionamount, :matchingcontributionamount, :numberrequiredqualifyingcontributions, :matchingratio, :contributionlimitsforparticipate, :_totalavailablefunds,:officetypeid, :qualifyingoffices, :startdate, :endate,:electioncycle)", commandType: CommandType.Text, param);
            return res;
        }
        public async Task<int> UpdateMatchingLimits(AddMatchingLimitApiModel UpdateMatchingLimit)
        {
            IDbDataParameter[] param = new[]
               {
                  dataContext.CreateParameter(DbType.Int32,"_matchingid", 100, UpdateMatchingLimit.MatchingId, ParameterDirection.InputOutput),
                  dataContext.CreateParameter(DbType.Decimal,"_qualifyingcontributionamount", 100, UpdateMatchingLimit.QualifyingContributionAmount, ParameterDirection.InputOutput),
                  dataContext.CreateParameter(DbType.Decimal,"_matchingcontributionamount", 10, UpdateMatchingLimit.MatchingContributionAmount, ParameterDirection.InputOutput),
                  dataContext.CreateParameter(DbType.Int32,"_numberrequiredqualifyingcontributions", 100, UpdateMatchingLimit.NumberRequiredQualifyingContributions, ParameterDirection.InputOutput),
                  dataContext.CreateParameter(DbType.String,"_matchingratio", 100, UpdateMatchingLimit.MatchingRatio,  ParameterDirection.InputOutput),
                  dataContext.CreateParameter(DbType.Int32,"_contributionlimitsforparticipate", 100, UpdateMatchingLimit.ContributionLimitsforParticipate,  ParameterDirection.InputOutput),
                  dataContext.CreateParameter(DbType.Decimal,"_totalavailablefunds", 100, UpdateMatchingLimit.TotalAvailableFunds,  ParameterDirection.InputOutput),
                  dataContext.CreateParameter(DbType.String,"_officetypeid", 1000, UpdateMatchingLimit.OfficeTypeId,  ParameterDirection.InputOutput),
                  dataContext.CreateParameter(DbType.String,"_qualifyingoffices", 1000, UpdateMatchingLimit.QualifyingOffices,  ParameterDirection.InputOutput),
                  dataContext.CreateParameter(DbType.Date,"_startdate", 100, UpdateMatchingLimit.StartDate,  ParameterDirection.InputOutput),
                  dataContext.CreateParameter(DbType.Date,"_endate", 100, UpdateMatchingLimit.Enddate,  ParameterDirection.InputOutput),
                  dataContext.CreateParameter(DbType.String,"_electioncycle", 1000, UpdateMatchingLimit.ElectionCycle,  ParameterDirection.InputOutput),
                };
            int res = dataContext.Update(@"select * from update_matchingdetails(:_matchingid, :_qualifyingcontributionamount, :_matchingcontributionamount, :_numberrequiredqualifyingcontributions, :_matchingratio, :_contributionlimitsforparticipate, :_totalavailablefunds, :_officetypeid, :_qualifyingoffices, :_startdate, :_endate,:_electioncycle)", commandType: CommandType.Text, param);
            return res;

        }
        public async Task<int> DeleteMatchingLimits(int Id)
        {
            IDbDataParameter[] param = new[]
                {
                  dataContext.CreateParameter(DbType.Int32,"_matchingid", 100, Id, ParameterDirection.InputOutput),
                };
            int res = dataContext.Delete(@"select * from delete_matchingdetails(:_matchingid)", commandType: CommandType.Text, param);
            return res;
        }

        public async Task<List<AddMatchingLimitApiModel>> GetMatchingLimitsList()
        {
            DataTable ResultDT = dataContext.GetDataTable(@"select * from get_matchingdetails()", commandType: CommandType.Text, null);

            List<AddMatchingLimitApiModel> matchinglimitslist = tableConverter.ConvertToList<AddMatchingLimitApiModel>(ResultDT);
            return matchinglimitslist;
        }
        public async Task<int> CreateModifyFormImageUpload(AppTenantRequestApiModel appTenantRequestAPI)
        {
            IDbDataParameter[] param = new[]
               {
                  dataContext.CreateParameter(DbType.String,"appname", 100, appTenantRequestAPI.AppName, ParameterDirection.InputOutput),
                  dataContext.CreateParameter(DbType.String,"themename", 100, appTenantRequestAPI.ThemeName,  ParameterDirection.InputOutput),
                  dataContext.CreateParameter(DbType.String,"logourl", 50000, appTenantRequestAPI.LogoUrl, ParameterDirection.Input),
                  dataContext.CreateParameter(DbType.String,"favicon", 50000, appTenantRequestAPI.FavIcon, ParameterDirection.Input),
                  dataContext.CreateParameter(DbType.String,"bannerimageurl", 50000, appTenantRequestAPI.BannerImageUrl, ParameterDirection.InputOutput),
                  dataContext.CreateParameter(DbType.String,"sealimageurl", 50000, appTenantRequestAPI.SealImageUrl,  ParameterDirection.InputOutput),
                  dataContext.CreateParameter(DbType.String,"clerksealimageurl", 50000, appTenantRequestAPI.ClerkSealImageUrl, ParameterDirection.Input),
                  dataContext.CreateParameter(DbType.String,"headerimageurl", 50000, appTenantRequestAPI.HeaderImageUrl, ParameterDirection.Input),
                  dataContext.CreateParameter(DbType.String,"footerimageurl", 50000, appTenantRequestAPI.FooterImageUrl, ParameterDirection.Input),
                  dataContext.CreateParameter(DbType.String,"clerksignimageurl", 50000, appTenantRequestAPI.ClerkSignImageUrl, ParameterDirection.Input),
            };
            int res = dataContext.Insert(@"select * from save_apptenant(:appname, :themename, :logourl, :favicon,:bannerimageurl, :sealimageurl, :clerksealimageurl, :headerimageurl, :footerimageurl, :clerksignimageurl)", commandType: CommandType.Text, param);
            return res;
        }
        public async Task<int> UpdateModifyFormImageUpload(AppTenantRequestApiModel appTenantRequestAPI)
        {
            IDbDataParameter[] param = new[]
               {
                  dataContext.CreateParameter(DbType.Int32,"appid", 100, appTenantRequestAPI.AppId, ParameterDirection.InputOutput),
                  dataContext.CreateParameter(DbType.String,"appname", 100, appTenantRequestAPI.AppName, ParameterDirection.InputOutput),
                  dataContext.CreateParameter(DbType.String,"themename", 100, appTenantRequestAPI.ThemeName,  ParameterDirection.InputOutput),
                  dataContext.CreateParameter(DbType.String,"logourl", 50000, appTenantRequestAPI.LogoUrl, ParameterDirection.Input),
                  dataContext.CreateParameter(DbType.String,"favicon", 50000, appTenantRequestAPI.FavIcon, ParameterDirection.Input),
                  dataContext.CreateParameter(DbType.String,"bannerimageurl", 50000, appTenantRequestAPI.BannerImageUrl, ParameterDirection.InputOutput),
                  dataContext.CreateParameter(DbType.String,"sealimageurl", 50000, appTenantRequestAPI.SealImageUrl,  ParameterDirection.InputOutput),
                  dataContext.CreateParameter(DbType.String,"clerksealimageurl", 50000, appTenantRequestAPI.ClerkSealImageUrl, ParameterDirection.Input),
                  dataContext.CreateParameter(DbType.String,"headerimageurl", 50000, appTenantRequestAPI.HeaderImageUrl, ParameterDirection.Input),
                  dataContext.CreateParameter(DbType.String,"footerimageurl", 50000, appTenantRequestAPI.FooterImageUrl, ParameterDirection.Input),
                  dataContext.CreateParameter(DbType.String,"clerksignimageurl", 50000, appTenantRequestAPI.ClerkSignImageUrl, ParameterDirection.Input),
                };
            int res = dataContext.Update(@"select * from update_apptenant(:appid, :appname, :themename, :logourl, :favicon,:bannerimageurl, :sealimageurl, :clerksealimageurl, :headerimageurl, :footerimageurl, :clerksignimageurl)", commandType: CommandType.Text, param);
            return res;
        }
        public async Task<List<UserPermissionSettingApiModel>> GetUserPermissionList()
        {
            DataTable ResultDT = dataContext.GetDataTable(@"select * from get_userpermission()", commandType: CommandType.Text, null);
            List<UserPermissionSettingApiModel> getuserpermissionsettings = tableConverter.ConvertToList<UserPermissionSettingApiModel>(ResultDT);
            return getuserpermissionsettings;
        }

        public async Task<List<CommitteeList>> GetCommiteeListMatchingBallotCode(int ballotIssueID)
        {
            IDbDataParameter[] param = new[]
               {
                  dataContext.CreateParameter(DbType.Int32,"ballotissueid", 100, ballotIssueID, ParameterDirection.InputOutput),
               };
            DataTable ResultDT = dataContext.GetDataTable(@"select * from get_committeebyballotid(:ballotissueid)", commandType: CommandType.Text, param);

            List<CommitteeList> committeeList = tableConverter.ConvertToList<CommitteeList>(ResultDT);
            return committeeList;
        }

        public async Task<List<AppTenantRequestApiModel>> GetModifyFormImage(int appid)
        {
            IDbDataParameter[] param = new[]
              {
                  dataContext.CreateParameter(DbType.Int32,"_appid", 100, appid, ParameterDirection.InputOutput),
               };
            DataTable ResultDT = dataContext.GetDataTable(@"select * from get_apptenant(:_appid)", commandType: CommandType.Text, param);

            List<AppTenantRequestApiModel> imglist = tableConverter.ConvertToList<AppTenantRequestApiModel>(ResultDT);
            return imglist;
        }
    }
}
