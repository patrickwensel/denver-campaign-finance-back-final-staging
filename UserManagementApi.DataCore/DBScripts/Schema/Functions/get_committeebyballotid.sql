-- FUNCTION: public.get_committeebyballotid(character varying)

-- DROP FUNCTION public.get_committeebyballotid(character varying);

CREATE OR REPLACE FUNCTION public.get_committeebyballotid(
	ballotissueid integer)
    RETURNS TABLE(committeeid integer, committeename character varying, committeeposition character varying) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
begin
  return query
	SELECT com.committee_id, com.name, com.position
		FROM public.committee com
	WHERE com.ballot_issue_id = ballotissueid;
end
$BODY$;


