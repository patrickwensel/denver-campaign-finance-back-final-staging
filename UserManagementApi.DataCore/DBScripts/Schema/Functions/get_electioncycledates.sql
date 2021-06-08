
CREATE OR REPLACE FUNCTION public.get_electioncycledates()
    RETURNS TABLE(electioncycleid integer, electioncycletypeid character varying,electiondate date) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
begin
  return query
  SELECT ec.election_cycle_id,
  ec.election_type_id, 
  ec.election_date
  FROM public.election_cycle ec 
  	WHERE ec.status_code = 'ACTIVE';
 end
$BODY$;


