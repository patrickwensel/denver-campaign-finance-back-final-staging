using Denver.DataAccess;
using Denver.Infra.Common;
using Microsoft.Extensions.Configuration;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using UserManagementApi.Domain.Helper;
using UserManagementApi.Domain.Repositories;
using UserManagementApi.Domain.ViewModels;

namespace UserManagementApi.DataCore.Repositories
{
    public class CalendarRepository : ICalendarRepository
    {
        private DataTableToList tableConverter;
        private DBManager dataContext;

        public CalendarRepository(IConfiguration configuration)
        {
            dataContext = new DBManager(configuration.GetConnectionString("AppDB"), DataProvider.PostgreSQL);
            tableConverter = new DataTableToList();
        }

        public async Task<int> SaveElectionCycle(ElectionCycleRequestApiModel electionCycleRequest)
        {
            int electionCycleId = 0;

            IDbDataParameter[] param = new[]
            {
                dataContext.CreateParameter(DbType.Int32, "electioncycleid", 100, electionCycleRequest.ElectionCycleId, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.String, "electionname", 300, electionCycleRequest.Name, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.String, "electiontypeid", 100, electionCycleRequest.ElectionTypeId, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.Date, "startdate", 100, electionCycleRequest.StartDate, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.Date, "enddate", 100, electionCycleRequest.EndDate, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.Date, "electiondate", 100, electionCycleRequest.ElectionDate, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.String, "electioncyclestatus", 100, electionCycleRequest.Status, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.String, "description", 1000, electionCycleRequest.Description, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.String, "districtDesc", 100, electionCycleRequest.District, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.Date, "iestartdate", 100, electionCycleRequest.IEStartDate, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.Date, "ieenddate", 100, electionCycleRequest.IEEndDate, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.String, "userid", 100, "", ParameterDirection.InputOutput),
            };

            StringBuilder sbQuery = new StringBuilder();
            sbQuery.Clear();
            sbQuery.AppendLine(@"select * from save_electioncycle(");
            sbQuery.AppendLine(":electioncycleid, ");
            sbQuery.AppendLine(":electionname, ");
            sbQuery.AppendLine(":electiontypeid, ");
            sbQuery.AppendLine(":startdate, ");
            sbQuery.AppendLine(":enddate, ");
            sbQuery.AppendLine(":electiondate, ");
            sbQuery.AppendLine(":electioncyclestatus, ");
            sbQuery.AppendLine(":description, ");
            sbQuery.AppendLine(":districtDesc, ");
            sbQuery.AppendLine(":iestartdate, ");
            sbQuery.AppendLine(":ieenddate, ");
            sbQuery.AppendLine(":userid)");

            electionCycleId = dataContext.Insert(sbQuery.ToString(), commandType: CommandType.Text, param);

            IEnumerable<ElectionCycleResponseApiModel> electionCycle = await GetElectionCycleById(electionCycleId);

            string officeIds = string.Empty;

            if (electionCycle != null)
            {
                foreach (ElectionCycleResponseApiModel ec in electionCycle)
                {
                    officeIds = ec.OfficeIds;
                }
            }

            string[] arrOfficeIds = officeIds.Split(',').Select(x => x.Trim()).ToArray();

            IEnumerable<string> removedOffices = arrOfficeIds.Except(electionCycleRequest.Offices);

            foreach (string office in electionCycleRequest.Offices)
            {
                IDbDataParameter[] offParam = new[]
                {
                    dataContext.CreateParameter(DbType.Int32, "electionCycleId", 100, electionCycleId, ParameterDirection.InputOutput),
                    dataContext.CreateParameter(DbType.String, "officeId", 100, office, ParameterDirection.InputOutput),
                    dataContext.CreateParameter(DbType.String, "userid", 100, "", ParameterDirection.InputOutput)
                };

                sbQuery = new StringBuilder();
                sbQuery.Clear();
                sbQuery.AppendLine(@"select * from save_electioncycleofficesmapping(");
                sbQuery.AppendLine(":electionCycleId, ");
                sbQuery.AppendLine(":officeId, ");
                sbQuery.AppendLine(":userid)");

                var response = dataContext.Insert(sbQuery.ToString(), commandType: CommandType.Text, offParam);
            }

            foreach (string rOff in removedOffices)
            {
                int delRes = await DeleteOfficeFromElectionCycle(electionCycleId, rOff);
            }

            return electionCycleId;
        }

        public async Task<int> DeleteElectionCycle(int electionCycleId)
        {
            IDbDataParameter[] param = new[]
            {
                dataContext.CreateParameter(DbType.Int32, "electioncycleid", 100, electionCycleId, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.String, "userid", 100, "", ParameterDirection.InputOutput),
            };

            StringBuilder sbQuery = new StringBuilder();
            sbQuery.Clear();
            sbQuery.AppendLine(@"select * from delete_electioncycle(");
            sbQuery.AppendLine(":electioncycleid, ");
            sbQuery.AppendLine(":userid)");

            var response = dataContext.Delete(sbQuery.ToString(), commandType: CommandType.Text, param);
            return response;
        }

        private async Task<int> DeleteOfficeFromElectionCycle(int electionCycleId, string officeId)
        {
            IDbDataParameter[] param = new[]
            {
                dataContext.CreateParameter(DbType.Int32, "electioncycleid", 100, electionCycleId, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.String, "officeId", 100, officeId, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.String, "userid", 100, "", ParameterDirection.InputOutput),
            };

            StringBuilder sbQuery = new StringBuilder();
            sbQuery.Clear();
            sbQuery.AppendLine(@"select * from delete_electioncycleofficebyid(");
            sbQuery.AppendLine(":electioncycleid, ");
            sbQuery.AppendLine(":officeId, ");
            sbQuery.AppendLine(":userid)");

            var response = dataContext.Delete(sbQuery.ToString(), commandType: CommandType.Text, param);
            return response;
        }


        public async Task<IEnumerable<ElectionCycleResponseApiModel>> GetElectionCycleById(int electionCycleId)
        {
            IDbDataParameter[] param = new[]
            {
                dataContext.CreateParameter(DbType.Int32, "electioncycleid", 100, electionCycleId, ParameterDirection.InputOutput),
            };
            var dtElectionCycle = dataContext.GetDataTable("select * from get_electioncyclebyid(:electioncycleid)", commandType: CommandType.Text, param);

            IEnumerable<ElectionCycleResponseApiModel> resposeElectionCycle = ConvertDataTableToList.DataTableToList<ElectionCycleResponseApiModel>(dtElectionCycle);

            return resposeElectionCycle;
        }
        //Save the Events From the Calendar Functionality
        public async Task<int> SaveEvents(SaveEventsApiModel saveEvents)
        {
            IDbDataParameter[] param = new[]
               {
                  dataContext.CreateParameter(DbType.Int32,"_event_ids", 200, saveEvents.event_id, ParameterDirection.InputOutput),
                  dataContext.CreateParameter(DbType.String,"_name", 200, saveEvents.Name, ParameterDirection.InputOutput),
                  dataContext.CreateParameter(DbType.String,"_desc", 1000, saveEvents.Desc,  ParameterDirection.InputOutput),
                  dataContext.CreateParameter(DbType.DateTime,"_eventdate", 500, saveEvents.eventdate, ParameterDirection.Input),
                  dataContext.CreateParameter(DbType.Boolean,"_bump_filing_due", 500, saveEvents.bump_filing_due, ParameterDirection.Input),
                  dataContext.CreateParameter(DbType.String,"_filer_type_id", 100, saveEvents.filer_type_id, ParameterDirection.Input),
                };
            int res = dataContext.Insert(@"select * from save_eventsdetails(:_event_ids,:_name,:_desc,:_eventdate,:_bump_filing_due,:_filer_type_id)", commandType: CommandType.Text, param);
            return res;
        }

        //Delete  the Events 
        public async Task<int> DeleteEvents(int eventId)
        {
            IDbDataParameter[] param = new[]
                {
                  dataContext.CreateParameter(DbType.Int32,"_eventId", 100, eventId, ParameterDirection.InputOutput),
                };
            int res = dataContext.Delete(@"select * from delete_Events(:_eventId)", commandType: CommandType.Text, param);
            return res;
        }
        //Get the Events for GridView
        public async Task<List<SaveEventsResponseApiModel>> GetEventList()
        {
            DataTable ResultDT = dataContext.GetDataTable(@"select * from get_Events()", commandType: CommandType.Text, null);

            List<SaveEventsResponseApiModel> Committetlist = tableConverter.ConvertToList<SaveEventsResponseApiModel>(ResultDT);
            return Committetlist;
		}


        public async Task<IEnumerable<ElectionCycleDetailResponseApiModel>> GetElectionCycles()
        {
            var dtStatus = dataContext.GetDataTable(@"SELECT * FROM public.get_electioncycles()", commandType: CommandType.Text, null);

            IEnumerable<ElectionCycleDetailResponseApiModel> resposeDt = ConvertDataTableToList.DataTableToList<ElectionCycleDetailResponseApiModel>(dtStatus);
            return resposeDt;
        }

        public async Task<CalendarEventsApiModel> GetCalendarDetails(string filerType, DateTime sdate, DateTime edate)
        {
            CalendarEventsApiModel resposes = new CalendarEventsApiModel();
            List<CalendarApiModel> ElectionCycle = new List<CalendarApiModel>();
            List<CalendarApiModel> Events = new List<CalendarApiModel>();
            List<CalendarApiModel> FilingPeriod = new List<CalendarApiModel>();
            IDbDataParameter[] paramec = new[]
            {
                dataContext.CreateParameter(DbType.Date, "_startdate", 500, sdate, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.Date, "_enddate", 500, edate, ParameterDirection.InputOutput),
            };
            var dtElectionCycle = dataContext.GetDataTable("select * from get_electioncycledetailsbyfiler(:_startdate, :_enddate)", commandType: CommandType.Text, paramec);

            IEnumerable<CalendarApiModel> respose = ConvertDataTableToList.DataTableToList<CalendarApiModel>(dtElectionCycle);

            IDbDataParameter[] paramev = new[]
           {    dataContext.CreateParameter(DbType.String, "_filertype", 500, filerType, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.Date, "_startdate", 500, sdate, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.Date, "_enddate", 500, edate, ParameterDirection.InputOutput),
            };
            var dtEvents = dataContext.GetDataTable("select * from get_eventdetailsbyfiler(:_filertype, :_startdate, :_enddate)", commandType: CommandType.Text, paramev);

            IEnumerable<CalendarApiModel> resposeev = ConvertDataTableToList.DataTableToList<CalendarApiModel>(dtElectionCycle);

            IDbDataParameter[] paramfp = new[]
           {    dataContext.CreateParameter(DbType.String, "_filertype", 500, filerType, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.Date, "_startdate", 500, sdate, ParameterDirection.InputOutput),
                dataContext.CreateParameter(DbType.Date, "_enddate", 500, edate, ParameterDirection.InputOutput),
            };
            var dtFilingPeriod = dataContext.GetDataTable("select * from get_filingperioddetailsbyfiler(:_filertype, :_startdate, :_enddate)", commandType: CommandType.Text, paramfp);

            IEnumerable<CalendarApiModel> resposepf = ConvertDataTableToList.DataTableToList<CalendarApiModel>(dtElectionCycle);
            if (dtElectionCycle.Rows.Count != 0)
            {
                foreach (var resec in respose)
                {
                    ElectionCycle.Add(new CalendarApiModel
                    {
                        Title = resec.Title,
                        Description = resec.Description,
                        EDate = resec.EDate
                    });
                }
                resposes.ElectionCycleDetails = ElectionCycle;
            }
            if (dtEvents.Rows.Count != 0)
            {
                foreach (var resev in resposeev)
                {
                    Events.Add(new CalendarApiModel
                    {
                        Title = resev.Title,
                        Description = resev.Description,
                        EDate = resev.EDate
                    });
                }
                resposes.EventDetails = Events;
            }
            if (dtFilingPeriod.Rows.Count != 0)
            {
                foreach (var resfp in resposepf)
                {
                    FilingPeriod.Add(new CalendarApiModel
                    {
                        Title = resfp.Title,
                        Description = resfp.Description,
                        EDate = resfp.EDate
                    });
                }
                resposes.FilingPeriodDetails = FilingPeriod;
            }
            return resposes;
        }
        //   Filing Period
        public async Task<int> SaveFilingPeriod(FilingPeriodApiModel filingPeriod)
        {

            int filingPeriodId = 0;
            IDbDataParameter[] param = new[]
               {
                  dataContext.CreateParameter(DbType.Int32,"_filingperiodid", 100, filingPeriod.FilingPeriodId,  ParameterDirection.InputOutput),
                  dataContext.CreateParameter(DbType.String,"_filingperiodname", 200, filingPeriod.FilingPeriodName, ParameterDirection.InputOutput),
                  dataContext.CreateParameter(DbType.String,"_description", 1000, filingPeriod.Description,  ParameterDirection.InputOutput),
                  dataContext.CreateParameter(DbType.Date,"_startdate", 100, filingPeriod.StartDate,  ParameterDirection.InputOutput),
                  dataContext.CreateParameter(DbType.Date,"_endate", 100, filingPeriod.Enddate,  ParameterDirection.InputOutput),
                  dataContext.CreateParameter(DbType.DateTime,"_duedate", 1000, filingPeriod.Duedate,  ParameterDirection.InputOutput),
                  dataContext.CreateParameter(DbType.Int32,"_electioncycleid", 100, filingPeriod.ElectionCycleId,  ParameterDirection.InputOutput),
                  dataContext.CreateParameter(DbType.Decimal,"_itemthreshold", 300, filingPeriod.ItemThreshold,  ParameterDirection.InputOutput),
                  dataContext.CreateParameter(DbType.String,"_filertypeids", 200, filingPeriod.FilingPeriodFilerTypeIds,  ParameterDirection.InputOutput),
                };
            filingPeriodId = dataContext.Insert(@"select * from save_filingperioddetails(:_filingperiodid, :_filingperiodname, :_description, :_startdate, :_endate, :_duedate,:_electioncycleid, :_itemthreshold, :_filertypeids)", commandType: CommandType.Text, param);
            return filingPeriodId;
        }

        public async Task<List<GetFilingPeriodApiModel>> GetFilingPeriods()
        {
            DataTable ResultDT = dataContext.GetDataTable(@"select * from get_filingperiodlist()", commandType: CommandType.Text, null);

            List<GetFilingPeriodApiModel> filingPeriodlist = tableConverter.ConvertToList<GetFilingPeriodApiModel>(ResultDT);
            return filingPeriodlist;
        }

        public async Task<int> DeleteFilingPeriod(int filingperiodid)
        {
            IDbDataParameter[] param = new[]
                {
                  dataContext.CreateParameter(DbType.Int32,"_filingperiodid", 100, filingperiodid, ParameterDirection.InputOutput),
                };
            int res = dataContext.Delete(@"select * from delete_filingperiod(:_filingperiodid)", commandType: CommandType.Text, param);
            return res;
        }


        public async Task<IEnumerable<GetFilingPeriodApiModel>> GetFilingPeriodById(int filingPeriodId)
        {
            IDbDataParameter[] param = new[]
            {
                dataContext.CreateParameter(DbType.Int32, "_filingperiodid", 100, filingPeriodId, ParameterDirection.InputOutput),
            };
            var dtFilingPeriod = dataContext.GetDataTable("select * from get_filingperiodlistbyid(:_filingperiodid)", commandType: CommandType.Text, param);

            IEnumerable<GetFilingPeriodApiModel> responseFilingPeriod = ConvertDataTableToList.DataTableToList<GetFilingPeriodApiModel>(dtFilingPeriod);

            return responseFilingPeriod;
        }
        public async Task<IEnumerable<GetEventsResponseApiModel>> GetEventsById(int eventId)
        {
            IDbDataParameter[] param = new[]
            {
                dataContext.CreateParameter(DbType.Int32, "_eventId", 100, eventId, ParameterDirection.InputOutput),
            };
            var dtFilingPeriod = dataContext.GetDataTable("select * from get_eventslistbyId(:_eventId)", commandType: CommandType.Text, param);

            IEnumerable<GetEventsResponseApiModel> responseevents = ConvertDataTableToList.DataTableToList<GetEventsResponseApiModel>(dtFilingPeriod);

            return responseevents;
        }
    }
}
