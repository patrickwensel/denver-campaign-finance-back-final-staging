-- FUNCTION: public.get_contributionlimits()

-- DROP FUNCTION public.get_contributionlimits();

CREATE OR REPLACE FUNCTION public.get_contributionlimits(
	)
    RETURNS TABLE(id integer, commiteetypeid character varying, officetypeid character varying, donortypeid character varying, electioncycleid integer, tenantid integer, commiteetype character varying, officetype character varying, donortype character varying, electionyear character varying, descript character varying, contlimit numeric) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
begin
  return query
  	SELECT 
	contl.id,
	contl.commitee_type_id,
	contl.office_type_id,
	contl.donor_type_id,
	contl.election_cycle_id,
		contl.tenant_id,
    contl.commitee_type,
    contl.office_type,
    contl.donor_type,
	contl.election_year,
    contl.description,
	contl.cont_limit
	FROM public.contribution_limits contl;
end
$BODY$;

ALTER FUNCTION public.get_contributionlimits()
    OWNER TO devadmin;
