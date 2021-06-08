DROP FUNCTION public.get_electioncycles();

CREATE OR REPLACE FUNCTION public.get_electioncycles(
	)
    RETURNS TABLE(electioncycleid integer, electioncycle character varying, electioncycletypeid character varying, electioncycletype character varying, startdate date, enddate date, electiondate date, description character varying, district character varying, iestartdate date, ieenddate date, officeids text, offices text, statusdesc character varying) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
begin

	UPDATE public.election_cycle 
		SET status = 'COM'
	WHERE end_date < CURRENT_DATE
		AND status = 'ACT';
	
  return query
	SELECT ec.election_cycle_id, 
	   ec.name, 
	   ec.election_type_id, 
	   tl.name as etName,
	   ec.start_date, 
	   ec.end_date, 
	   ec.election_date,
	   ec."desc", 
	   ec.district, 
	   ec.ie_start_date, 
	   ec.ie_end_date,
	   string_agg(ecom.office_id::text,', ') officeids,
		string_agg(tlo.name::text,', ') offices,
		tks.name as statusDesc
	FROM public.election_cycle ec 
		LEFT JOIN public.type_lookups tl ON ec.election_type_id = tl.type_id 
			AND tl.lookup_type_code = 'ELECTION-TYPE'
		LEFT JOIN public.election_cycle_offices_mapping ecom ON ec.election_cycle_id = ecom.election_cycle_id
		LEFT JOIN type_lookups tlo ON ecom.office_id = tlo.type_id
			AND tlo.lookup_type_code = 'OFF'
		LEFT JOIN public.type_lookups tks ON tks.type_id = ec.status
			AND tks.lookup_type_code ='ELECTION-STATUS'
	WHERE ec.status_code = 'ACTIVE'
		GROUP BY ec.election_cycle_id, 
	   ec.name, 
	   ec.election_type_id, 
	   tl.name,
	   ec.start_date, 
	   ec.end_date, 
	   ec.election_date,
	   ec."desc", 
	   ec.district, 
	   ec.ie_start_date, 
	   ec.ie_end_date,
	   tks.name
	ORDER BY ec.updated_on DESC;
 end
$BODY$;