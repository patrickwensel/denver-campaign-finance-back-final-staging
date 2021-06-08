using System;
using System.Collections.Generic;
using System.Text;
using System.Threading.Tasks;
using UserManagementApi.Domain.ViewModels;

namespace UserManagementApi.Domain.Repositories
{
    public interface ICalendarRepository
    {
        Task<int> SaveElectionCycle(ElectionCycleRequestApiModel electionCycleRequest);
        Task<int> DeleteElectionCycle(int electionCycleId);
        Task<IEnumerable<ElectionCycleResponseApiModel>> GetElectionCycleById(int electionCycleId);

       
       //Save Events 
        Task<int> SaveEvents(SaveEventsApiModel saveEvents);
        //Delete the Event
        Task<int> DeleteEvents(int eventId);
        //Get the EventList
        Task<List<SaveEventsResponseApiModel>> GetEventList();

        Task<IEnumerable<ElectionCycleDetailResponseApiModel>> GetElectionCycles();

        Task<CalendarEventsApiModel> GetCalendarDetails(string filerType, DateTime sdate, DateTime edate);


        /// Filing Period
        /// 
        Task<int> SaveFilingPeriod(FilingPeriodApiModel filingPeriod);
        Task<List<GetFilingPeriodApiModel>> GetFilingPeriods();
        Task<int> DeleteFilingPeriod(int filingperiodid);
        Task<IEnumerable<GetFilingPeriodApiModel>> GetFilingPeriodById(int filingperiodid);
        // Filing Period
        Task<IEnumerable<GetEventsResponseApiModel>> GetEventsById(int eventId);
    
    }
}
