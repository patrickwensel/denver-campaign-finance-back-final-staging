-- FUNCTION: public.get_employees(integer)

-- DROP FUNCTION public.get_employees(integer);

CREATE OR REPLACE FUNCTION public.get_employees(
	lobbyistentityid integer)
    RETURNS TABLE(contactid integer, contacttype character varying, firstname character varying, middlename character varying, lastname character varying, fullname text, phoneno character varying, emailid character varying) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
DECLARE roleTypeId int = 0;
DECLARE filerId int = 0;
begin

  SELECT id into roleTypeId FROM public.role WHERE role = 'Lobbyist Employee';
  
  SELECT filer_id into filerId 
  FROM public.filer 
  	WHERE entity_id = lobbyistEntityId
		AND entity_type = 'LOBBYIST';
  
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
	FROM contact c
		INNER JOIN contact_role_mapping crm  ON c.contact_id = crm.contact_id
	WHERE crm.role_type_id = roleTypeId
		AND crm.filer_id = filerId
		AND c.status_code = 'ACTIVE'
		AND crm.status_code = 'ACTIVE';
 end
$BODY$;

ALTER FUNCTION public.get_employees(integer)
    OWNER TO devadmin;
