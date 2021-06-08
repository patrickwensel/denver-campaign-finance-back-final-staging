-- FUNCTION: public.save_contributionlimits(character varying, character varying, character varying, integer, integer, character varying, character varying, character varying, character varying, character varying, numeric)

-- DROP FUNCTION public.save_contributionlimits(character varying, character varying, character varying, integer, integer, character varying, character varying, character varying, character varying, character varying, numeric);

CREATE OR REPLACE FUNCTION public.save_contributionlimits(
	commiteetypeid character varying,
	officetypeid character varying,
	donortypeid character varying,
	electioncycleid integer,
	tenantid integer,
	commiteetype character varying,
	officetype character varying,
	donortype character varying,
	electionyear character varying,
	des character varying,
	contlimit numeric)
    RETURNS integer
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
DECLARE Coid int = 0;
begin

	
	
	INSERT INTO public.contribution_limits(commitee_type_id,
	office_type_id,
	donor_type_id,
	election_cycle_id,
	tenant_id,
    commitee_type,
    office_type,
    donor_type,
	cont_limit,
    election_year,
    description)
	VALUES (commiteetypeid,
	officetypeid,
	donortypeid,
	electioncycleid,
	tenantid,
    commiteetype,
    officetype,
    donortype,
	contlimit,
    electionyear,
    des);
			
	
	if found then --inserted successfully
	 	 return 1;
	else 
		return 0; -- inserted fail
	end if;

end
$BODY$;

ALTER FUNCTION public.save_contributionlimits(character varying, character varying, character varying, integer, integer, character varying, character varying, character varying, character varying, character varying, numeric)
    OWNER TO devadmin;
