using Denver.Infra.Constants;
using Microsoft.Azure.Amqp.Framing;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Globalization;
using System.Text;
using System.Threading.Tasks;
using UserManagementApi.Domain.ViewModels;

namespace UserManagementApi.Domain.Service
{
    public partial class UserManagementService
    {
        public async Task<int> SaveElectionCycle(ElectionCycleRequestApiModel electionCycleRequest)
        {
            if (electionCycleRequest.StartDate == null)
            {
                electionCycleRequest.StartDate = DateTime.MinValue;
            }

            if (electionCycleRequest.EndDate == null)
            {
                electionCycleRequest.EndDate = DateTime.MaxValue;
            }

            if (electionCycleRequest.IEStartDate == null)
            {
                electionCycleRequest.IEStartDate = DateTime.MinValue;
            }

            if (electionCycleRequest.IEEndDate == null)
            {
                electionCycleRequest.IEEndDate = DateTime.MaxValue;
            }

            return await _calendarRepository.SaveElectionCycle(electionCycleRequest);
        }

        public async Task<int> DeleteElectionCycle(int electionCycleId)
        {
            return await _calendarRepository.DeleteElectionCycle(electionCycleId);
        }
        public async Task<IEnumerable<ElectionCycleResponseApiModel>> GetElectionCycleById(int electionCycleId)
        {
            return await _calendarRepository.GetElectionCycleById(electionCycleId);
        }
       

        //Save the Event
        public async Task<int> SaveEvents(SaveEventsApiModel saveEvents)
        {
            return await _calendarRepository.SaveEvents(saveEvents);
        }
        //Delete the Event
        public async Task<int> DeleteEvents(int eventId)
        {
            return await _calendarRepository.DeleteEvents(eventId);
        }
        //Get GetEventList
        public async Task<List<SaveEventsResponseApiModel>> GetEventList()
        {
            return await _calendarRepository.GetEventList();
		}

        public async Task<IEnumerable<ElectionCycleDetailResponseApiModel>> GetElectionCycles()
        {
            return await _calendarRepository.GetElectionCycles();
        }
        public async Task<CalendarEventsApiModel> GetCalendarDetails(string filerType, string month, string year)
        {
            int monthnum = DateTime.ParseExact(month, "MMMM", CultureInfo.CurrentCulture).Month;
            DateTime startDate = new DateTime(Convert.ToInt32(year), monthnum, 1).Date;
            var endDate = startDate.AddMonths(1).AddDays(-1).Date;
            return await _calendarRepository.GetCalendarDetails(filerType, startDate, endDate);

        }

        //Filing Period
        public async Task<int> SaveFilingPeriod(FilingPeriodApiModel filingPeriod)
        {
            return await _calendarRepository.SaveFilingPeriod(filingPeriod);
        }

        public async Task<List<GetFilingPeriodApiModel>> GetFilingPeriods()
        {
            return await _calendarRepository.GetFilingPeriods();

        }

        public async Task<int> DeleteFilingPeriod(int filingperiodid)
        {
            return await _calendarRepository.DeleteFilingPeriod(filingperiodid);
        }

        public async Task<IEnumerable<GetFilingPeriodApiModel>> GetFilingPeriodById(int filingperiodid)
        {
            return await _calendarRepository.GetFilingPeriodById(filingperiodid);
        }

        //Filing Period
        public async Task<IEnumerable<GetEventsResponseApiModel>> GetEventsById(int eventId)
        {
            return await _calendarRepository.GetEventsById(eventId);
        }
    }
}
