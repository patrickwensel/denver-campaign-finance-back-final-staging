

CREATE OR REPLACE FUNCTION public.get_committeebyname(
	comname character varying,
	comtype character varying)
    RETURNS TABLE(committeeid integer, committeename character varying) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
DECLARE ComTypeId integer;

begin

SELECT committetypeid INTO ComTypeId FROM public.committee_type WHERE committetypename = comtype;
 IF  (comtype='All') THEN
 -- All Committee Type
 
return query
SELECT committee.committee_id, committee.name 
FROM public.committee
WHERE LOWER(committee.name) LIKE '%' || '' || LOWER(comName) || '' || '%'  
ORDER BY committee.committee_id;

ELSE
-- Selected Committee Type
return query
SELECT committee.committee_id, committee.name
FROM public.committee  
WHERE LOWER(committee.name) LIKE '%' || '' || LOWER(comName) || '' || '%' 
AND committee.typeid = ComTypeId
ORDER BY committee.committee_id;
END IF;
 end
$BODY$;


