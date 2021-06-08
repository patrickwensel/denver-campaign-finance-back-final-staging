
-- DROP FUNCTION public.get_filerbyname(character varying);

CREATE OR REPLACE FUNCTION public.get_filerbyname(
	fname character varying DEFAULT NULL::character varying)
    RETURNS TABLE(filername character varying) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
begin
   if CONCAT(fname, 'ZZZ') != 'ZZZ' AND fname = null then
	  return query
	  SELECT T.filerName FROM
		(SELECT  com.name as filerName
			FROM public.committee com
		 UNION	
		 SELECT CASE WHEN l.type = 'LOB-I' THEN 
					CASE WHEN CONCAT(pc.middle_name, 'ZZZ') = 'ZZZ' THEN 
						CONCAT(pc.first_name, ' ', pc.last_name)
					ELSE 
						CONCAT(pc.first_name, ' ', pc.middle_name, ' ', pc.last_name)
					END
				ELSE
					pc.org_name
				END as filerName
			FROM public.lobbyist l
				LEFT JOIN public.contact pc ON l.filer_contact_id = pc.contact_id
		 UNION
			SELECT CASE WHEN CONCAT(c.middle_name, 'ZZZ') = 'ZZZ' THEN 
						CONCAT(c.first_name, ' ', c.last_name)
					ELSE 
						CONCAT(c.first_name, ' ', c.middle_name, ' ', c.last_name)
					END as filerName
			FROM public.contact c
	  ) T
		WHERE LOWER(TRIM(T.filerName)) LIKE '%' || trim(fname) || '%';
  else
	  return query
	  SELECT T.filerName FROM
		(SELECT  com.name as filerName
			FROM public.committee com
		 UNION	
		 SELECT CASE WHEN l.type = 'LOB-I' THEN 
					CASE WHEN CONCAT(pc.middle_name, 'ZZZ') = 'ZZZ' THEN 
						CONCAT(pc.first_name, ' ', pc.last_name)
					ELSE 
						CONCAT(pc.first_name, ' ', pc.middle_name, ' ', pc.last_name)
					END
				ELSE
					pc.org_name
				END as filerName
			FROM public.lobbyist l
				LEFT JOIN public.contact pc ON l.filer_contact_id = pc.contact_id
		 UNION
			SELECT CASE WHEN CONCAT(c.middle_name, 'ZZZ') = 'ZZZ' THEN 
						CONCAT(c.first_name, ' ', c.last_name)
					ELSE 
						CONCAT(c.first_name, ' ', c.middle_name, ' ', c.last_name)
					END as filerName
			FROM public.contact c
	   ) T;
   end if;
 end
$BODY$;
