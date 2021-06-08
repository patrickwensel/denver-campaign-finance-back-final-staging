-- FUNCTION: public.get_ballotissuesm()

-- DROP FUNCTION public.get_ballotissuesm();

CREATE OR REPLACE FUNCTION public.get_ballotissuesm(
	)
    RETURNS TABLE(ballotid integer, ballotissuecode character varying, ballotissue character varying, createdby character varying, createdat date, updatedby character varying, updatedon date, electioncycle character varying, description character varying) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
begin
  return query
  	SELECT bism.ballot_issue_id, 
	bism.ballot_issue_code, 
	bism.ballot_issue, 
	bism.created_by, 
	bism.created_at, 
	bism.updated_by, 
	bism.updated_on,
	bism.election_cycle,
	bism.description FROM public.ballot_issue_sm bism;
end
$BODY$;

ALTER FUNCTION public.get_ballotissuesm()
    OWNER TO devadmin;
