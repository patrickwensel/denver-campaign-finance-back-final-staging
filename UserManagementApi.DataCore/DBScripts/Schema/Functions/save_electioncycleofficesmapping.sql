-- FUNCTION: public.save_electioncycleofficesmapping(integer, character varying, character varying)

-- DROP FUNCTION public.save_electioncycleofficesmapping(integer, character varying, character varying);

CREATE OR REPLACE FUNCTION public.save_electioncycleofficesmapping(
	electioncycleid integer,
	officeid character varying,
	userid character varying)
    RETURNS integer
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
DECLARE newElectionCycleOfficesMapId integer = 0;
begin
	if NOT EXISTS (SELECT 1 FROM election_cycle_offices_mapping
				  	WHERE election_cycle_id = electionCycleId
				  		AND office_id = officeId) then
		INSERT INTO public.election_cycle_offices_mapping(
				election_office_map_id, election_cycle_id, office_id, 
				status_code, created_by, created_at, 
				updated_by, updated_on)
		VALUES (nextval('election_cycle_offices_mapping_id_seq'), electionCycleId, officeId, 
				'ACTIVE', 'Denver', localtimestamp, 
				'Denver', localtimestamp);

		-- Get the current value from election_cycle_offices_mapping table
		SELECT currval('election_cycle_offices_mapping_id_seq') INTO newElectionCycleOfficesMapId;
	else
		UPDATE public.election_cycle_offices_mapping
			SET status_code = 'ACTIVE'
		WHERE election_cycle_id = electioncycleid
			AND office_id = officeid;
	end if;
	
	if newElectionCycleOfficesMapId = 0 then
		newElectionCycleOfficesMapId = electioncycleid;
	end if;
	
	return newElectionCycleOfficesMapId;
 end
$BODY$;

ALTER FUNCTION public.save_electioncycleofficesmapping(integer, character varying, character varying)
    OWNER TO devadmin;
