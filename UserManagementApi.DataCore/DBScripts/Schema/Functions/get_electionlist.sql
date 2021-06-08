-- FUNCTION: public.get_electionlist()

-- DROP FUNCTION public.get_electionlist();

CREATE OR REPLACE FUNCTION public.get_electionlist(
	)
    RETURNS TABLE(id integer, electiondate date, name character varying) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
begin
  return query
  	SELECT election.id, election.election_date,  election.name
	FROM public.election election;
end
$BODY$;

ALTER FUNCTION public.get_electionlist()
    OWNER TO devadmin;
