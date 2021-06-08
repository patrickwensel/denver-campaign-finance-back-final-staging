-- FUNCTION: public.update_matchingdetails(integer, numeric, numeric, integer, character varying, integer, numeric, character varying, character varying, date, date, character varying)

-- DROP FUNCTION public.update_matchingdetails(integer, numeric, numeric, integer, character varying, integer, numeric, character varying, character varying, date, date, character varying);

CREATE OR REPLACE FUNCTION public.update_matchingdetails(
	_matchingid integer,
	_qualifyingcontributionamount numeric,
	_matchingcontributionamount numeric,
	_numberrequiredqualifyingcontributions integer,
	_matchingratio character varying,
	_contributionlimitsforparticipate integer,
	_totalavailablefunds numeric,
	_officetypeid character varying,
	_qualifyingoffices character varying,
	_startdate date,
	_endate date,
	_electioncycle character varying)
    RETURNS integer
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
begin
 update public.matchinglimits set QualifyingContributionAmount=_qualifyingcontributionamount, 
 MatchingContributionAmount=_matchingcontributionamount,
 NumberRequiredQualifyingContributions=_numberrequiredqualifyingcontributions,
 MatchingRatio=_matchingratio, ContributionLimitsforParticipate=_contributionlimitsforparticipate,
 totalavailablefunds = _totalavailablefunds,office_type_id=_officetypeid,
 QualifyingOffices=_qualifyingoffices, StartDate=_startdate, EnDate=_endate, 
 ElectionCycle=_electioncycle
 where MatchingId = _matchingid;
 return _matchingid;
end
$BODY$;

ALTER FUNCTION public.update_matchingdetails(integer, numeric, numeric, integer, character varying, integer, numeric, character varying, character varying, date, date, character varying)
    OWNER TO devadmin;
