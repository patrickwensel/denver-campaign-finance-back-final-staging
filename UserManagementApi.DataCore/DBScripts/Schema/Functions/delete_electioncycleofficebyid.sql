-- FUNCTION: public.delete_electioncycleofficebyid(integer, character varying, character varying)

-- DROP FUNCTION public.delete_electioncycleofficebyid(integer, character varying, character varying);

CREATE OR REPLACE FUNCTION public.delete_electioncycleofficebyid(
	electioncycleid integer,
	officeid character varying,
	userid character varying)
    RETURNS integer
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
begin
	UPDATE public.election_cycle_offices_mapping
		SET status_code = 'DELETED',
			--updated_by = userId, 
			updated_on = localtimestamp
	WHERE election_cycle_id = electioncycleid
		AND office_id = officeId;
	
	return electioncycleid;
	
 end
$BODY$;

ALTER FUNCTION public.delete_electioncycleofficebyid(integer, character varying, character varying)
    OWNER TO devadmin;
