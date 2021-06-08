DROP FUNCTION public.get_electioncyclebyid(integer);

CREATE OR REPLACE FUNCTION public.get_electioncyclebyid(
	ecycleid integer)
    RETURNS TABLE(electioncycleid integer, electionname character varying, electiontypeid character varying, electiontypedesc character varying, startdate date, enddate date, electiondate date, status character varying, statusdesc character varying, description character varying, district character varying, iestartdate date, ieenddate date, electioncyclestatus character varying, officeids character varying, offices character varying) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
DECLARE tOfficeIds character varying;
DECLARE tOffices character varying;
begin

  	SELECT string_agg(ecom.office_id::text,', ') officeids,
		string_agg(tl.name::text,', ') offices INTO tOfficeIds, tOffices
	FROM public.election_cycle_offices_mapping ecom
		INNER JOIN type_lookups tl ON ecom.office_id = tl.type_id 
			AND tl.lookup_type_code = 'ELECTION-TYPE'
	WHERE ecom.election_cycle_id = eCycleId
		AND ecom.status_code = 'ACTIVE'
	GROUP BY ecom.election_cycle_id;
 
  return query
  SELECT ec.election_cycle_id, ec.name, 
  		ec.election_type_id, electiontype.name as electionType, ec.start_date, 
		ec.end_date, ec.election_date, 
		ec.status, electionstatus.name as statusDesc, ec."desc", 
		ec.district, ec.ie_start_date, 
		ec.ie_end_date, ec.status_code,
		tOfficeIds, tOffices
	FROM public.election_cycle ec 
		LEFT JOIN public.type_lookups electionstatus ON ec.status = electionstatus.type_id 
			AND electionstatus.lookup_type_code = 'ELECTION-STATUS'
		LEFT JOIN public.type_lookups electiontype ON ec.election_type_id = electiontype.type_id 
			AND electiontype.lookup_type_code = 'ELECTION-TYPE'
	WHERE ec.election_cycle_id = eCycleId;
 end
$BODY$;

ALTER FUNCTION public.get_electioncyclebyid(integer)
    OWNER TO devadmin;