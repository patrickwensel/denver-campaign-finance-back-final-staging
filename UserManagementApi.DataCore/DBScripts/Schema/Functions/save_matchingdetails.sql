-- FUNCTION: public.save_matchingdetails(numeric, numeric, integer, character varying, integer, numeric, character varying, character varying, date, date, character varying)

-- DROP FUNCTION public.save_matchingdetails(numeric, numeric, integer, character varying, integer, numeric, character varying, character varying, date, date, character varying);

CREATE OR REPLACE FUNCTION public.save_matchingdetails(
	qualifyingcontributionamount numeric,
	matchingcontributionamount numeric,
	numberrequiredqualifyingcontributions integer,
	matchingratio character varying,
	contributionlimitsforparticipate integer,
	_totalavailablefunds numeric,
	officetypeid character varying,
	qualifyingoffices character varying,
	startdate date,
	endate date,
	electioncycle character varying)
    RETURNS integer
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
begin

	--SELECT id = nextval('user_account_id_seq');
	
	INSERT INTO public.MatchingLimits(
		 QualifyingContributionAmount,MatchingContributionAmount, NumberRequiredQualifyingContributions, 
		MatchingRatio, ContributionLimitsforParticipate, totalavailablefunds,office_type_id, QualifyingOffices, 
		StartDate, Endate, ElectionCycle)
	VALUES (qualifyingcontributionamount,matchingcontributionamount, numberrequiredqualifyingcontributions, 
			matchingratio, contributionlimitsforparticipate, _totalavailablefunds, officetypeid, qualifyingoffices,
			startdate, endate, electioncycle);
			

	if found then --inserted successfully
	  	return 1;
	else 
		return 0; -- inserted fail
	end if;

end
$BODY$;

ALTER FUNCTION public.save_matchingdetails(numeric, numeric, integer, character varying, integer, numeric, character varying, character varying, date, date, character varying)
    OWNER TO devadmin;
