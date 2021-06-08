----------------------------------------------------functions-----------------------------------------

-- FUNCTION: public.get_committeebyname(character varying)

-- DROP FUNCTION public.get_committeebyname(character varying);

CREATE OR REPLACE FUNCTION public.get_committeebyname(
	comname character varying)
    RETURNS TABLE(committeeid integer, committeename character varying, committeetype character varying) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
begin
 
  return query

 SELECT committee.committee_id, committee.name ,committee_type.committetypename
	FROM public.committee   join committee_type  on committee.committee_id = committee_type.committetypeid
	WHERE LOWER(committee.name) LIKE '%' || '' || LOWER(comName) || '' || '%'  
		   ORDER BY committee.committee_id;
 end
$BODY$;

ALTER FUNCTION public.get_committeebyname(character varying)
    OWNER TO devadmin;
