-- FUNCTION: public.get_electioncyclebytype(character varying)

-- DROP FUNCTION public.get_electioncyclebytype(character varying);

CREATE OR REPLACE FUNCTION public.get_electioncyclebytype(
	typecode character varying)
    RETURNS TABLE(electioncycleid integer, electioncycle character varying) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
begin
  return query
  SELECT ec.election_cycle_id, 
	   ec.name
  FROM public.election_cycle ec 
  	WHERE ec.status_code = 'ACTIVE'
		AND ec.election_type_id = typeCode;
 end
$BODY$;

ALTER FUNCTION public.get_electioncyclebytype(character varying)
    OWNER TO devadmin;
