----------------------------------------Functions------------------------------------------
DROP FUNCTION public.get_employees(integer);

CREATE OR REPLACE FUNCTION public.get_employees(
	entityid integer)
    RETURNS TABLE(contactid integer, contacttype character varying, firstname character varying, middlename character varying, lastname character varying, fullname text, phoneno character varying, emailid character varying) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
begin
  return query
  SELECT c.contact_id,
		c.contact_type,
		c.first_name,
		c.middle_name,
		c.last_name,
		CASE WHEN CONCAT(c.middle_name, 'ZZZ') = 'ZZZ' THEN c.first_name || ' ' || c.last_name
			ELSE  c.first_name || ' ' || c.middle_name || ' ' || c.last_name
		END as fName,
		c.phone,
		c.email
	FROM public.filer f
		INNER JOIN contact_role_mapping crm ON f.filer_id = crm.filer_id
		INNER JOIN contact c ON c.contact_id = crm.contact_id
		INNER JOIN public.role r ON r.id = crm.role_type_id
	WHERE f.entity_id = entityId
		AND f.entity_type = 'LOBBYIST'
		AND r.role = 'Lobbyist Employee';
 end
$BODY$;

ALTER FUNCTION public.get_employees(integer)
    OWNER TO devadmin;

----------------------------------------Functions------------------------------------------