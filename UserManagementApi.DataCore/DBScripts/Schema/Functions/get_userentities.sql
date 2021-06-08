-- FUNCTION: public.get_userentities(integer)

-- DROP FUNCTION public.get_userentities(integer);

CREATE OR REPLACE FUNCTION public.get_userentities(
	userid integer)
    RETURNS TABLE(contactid integer, entityname text, entitytype character varying) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
begin
  return query
  SELECT l.lobbysit_id, CASE WHEN CONCAT(c.middle_name, 'ZZZ') = 'ZZZ' THEN 
					CONCAT(c.first_name, ' ', c.last_name) 
				  ELSE
				  	CONCAT(c.first_name, ' ', c.middle_name, ' ', c.last_name)
				  END as entity_Name, f.entity_type
	FROM public.contact_role_mapping crm
	 INNER JOIN public.filer f ON crm.filer_id = f.filer_id
	 INNER JOIN public.lobbyist l ON l.lobbysit_id = f.entity_id
	 INNER JOIN public.contact c ON c.contact_id = l.filer_contact_id
	WHERE crm.user_id = userId
		AND f.entity_type = 'L'
		AND coalesce(lower(l.status_code), 'active') = 'active'
		 and crm.status_code='ACTIVE'
	UNION
	SELECT com.committee_id, com.name as entity_Name, f.entity_type
	FROM public.contact_role_mapping crm
	 INNER JOIN public.filer f ON crm.filer_id = f.filer_id
	 INNER JOIN public.committee com ON com.committee_id = f.entity_id
	 INNER JOIN public.contact c ON c.contact_id = crm.contact_id
	WHERE crm.user_id = userId
		AND f.entity_type = 'C'
		AND coalesce(lower(com.status_code), 'active') = 'active'
		 and crm.status_code='ACTIVE'
	UNION
	SELECT c.contact_id, CASE WHEN CONCAT(c.middle_name, 'ZZZ') = 'ZZZ' THEN 
					CONCAT(c.first_name, ' ', c.last_name) 
				  ELSE
				  	CONCAT(c.first_name, ' ', c.middle_name, ' ', c.last_name)
				  END as entity_Name, f.entity_type
	FROM public.contact_role_mapping crm
	 INNER JOIN public.filer f ON crm.filer_id = f.filer_id
	 INNER JOIN public.contact c ON c.contact_id = crm.contact_id
	WHERE crm.user_id = userId
		AND f.entity_type = 'IE'
		AND coalesce(lower(c.status_code), 'active') = 'active'
		 and crm.status_code='ACTIVE'
	UNION 
	SELECT c.contact_id, CASE WHEN CONCAT(c.middle_name, 'ZZZ') = 'ZZZ' THEN 
					CONCAT(c.first_name, ' ', c.last_name) 
				  ELSE
				  	CONCAT(c.first_name, ' ', c.middle_name, ' ', c.last_name)
				  END as entity_Name, f.entity_type
	FROM public.contact_role_mapping crm
	 INNER JOIN public.filer f ON crm.filer_id = f.filer_id
	 INNER JOIN public.contact c ON c.contact_id = crm.contact_id
	WHERE crm.user_id = userId
		AND f.entity_type = 'CO'
		AND coalesce(lower(c.status_code), 'active') = 'active'
		 and crm.status_code='ACTIVE';
		
 end
$BODY$;

ALTER FUNCTION public.get_userentities(integer)
    OWNER TO devadmin;
