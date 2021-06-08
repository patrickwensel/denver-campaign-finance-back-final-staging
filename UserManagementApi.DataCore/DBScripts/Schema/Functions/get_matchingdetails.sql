-- FUNCTION: public.get_matchingdetails()

-- DROP FUNCTION public.get_matchingdetails();

CREATE OR REPLACE FUNCTION public.get_matchingdetails(
	)
    RETURNS TABLE(matchingid integer, qualifyingcontributionamount numeric, matchingcontributionamount numeric, numberrequiredqualifyingcontributions integer, matchingratio character varying, contributionlimitsforparticipate integer, totalavailablefunds numeric, officetypeid character varying, qualifyingoffices character varying, startdate date, enddate date, electioncycle character varying) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
begin
return query
SELECT matchlimit.MatchingId,
matchlimit.QualifyingContributionAmount,
matchlimit.MatchingContributionAmount,
matchlimit.NumberRequiredQualifyingContributions,
matchlimit.MatchingRatio,
matchlimit.ContributionLimitsforParticipate,
matchlimit.totalavailablefunds,
matchlimit.office_type_id,
matchlimit.QualifyingOffices,
matchlimit.StartDate,
matchlimit.Endate, 
matchlimit.ElectionCycle from public.matchinglimits matchlimit;
  
  	
end
$BODY$;

ALTER FUNCTION public.get_matchingdetails()
    OWNER TO devadmin;
