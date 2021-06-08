-- FUNCTION: public.get_independentspender(integer)

-- DROP FUNCTION public.get_independentspender(integer);

CREATE OR REPLACE FUNCTION public.get_independentspender(
	_ieid integer)
    RETURNS TABLE(contactid integer, employeetype character varying, employeename text) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
begin
return query
SELECT DISTINCT c.contact_id,
rl.role as entity_type,
concat(c.first_name, ' ', c.last_name)  as name
FROM contact_role_mapping crm
INNER JOIN contact c  ON c.contact_id = crm.contact_id
INNER JOIN role rl on  rl.id = crm.role_type_id and role = 'Other User'
INNER JOIN filer fil on  fil.entity_id = c.contact_id AND entity_type = 'IE'
WHERE crm.status_code = 'ACTIVE';
		

end
$BODY$;

ALTER FUNCTION public.get_independentspender(integer)
    OWNER TO devadmin;
