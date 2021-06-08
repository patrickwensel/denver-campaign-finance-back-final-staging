-- FUNCTION: public.delete_electioncycle(integer, character varying)

-- DROP FUNCTION public.delete_electioncycle(integer, character varying);

CREATE OR REPLACE FUNCTION public.delete_electioncycle(
	electioncycleid integer,
	userid character varying)
    RETURNS integer
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
begin
	UPDATE public.election_cycle
		SET status_code = 'DELETED',
			--updated_by = userId, 
			updated_on = localtimestamp
	WHERE election_cycle_id = electioncycleid;
	
	UPDATE public.election_cycle_offices_mapping
		SET status_code = 'DELETED',
			--updated_by = userId, 
			updated_on = localtimestamp
	WHERE election_cycle_id = electioncycleid;
	
	return electioncycleid;
	
 end
$BODY$;

ALTER FUNCTION public.delete_electioncycle(integer, character varying)
    OWNER TO devadmin;
