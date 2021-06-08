------------------------------------------Functions----------------------------------------
-- FUNCTION: public.getlobbyistemployee(integer)

-- DROP FUNCTION public.getlobbyistemployee(integer);

CREATE OR REPLACE FUNCTION public.getlobbyistemployee(
	_lobbyistid integer)
    RETURNS TABLE(contactid integer, employeetype text, employeename text) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
DECLARE roleTypeId int = 0;
DECLARE fillerId int = 0;
begin
SELECT id into roleTypeId FROM public.role WHERE role = 'Lobbyist Employee';
  
SELECT filer_id into fillerId 
FROM public.filer 
WHERE entity_id = _lobbyistid
AND entity_type = 'LOBBYIST';
return query
--  Lobbyist	Employee	
 
SELECT c.contact_id,
'Lobbyist Employee' as entity_type,
concat(c.first_name, ' ', c.last_name)  as name
FROM contact_role_mapping crm
INNER JOIN contact c  ON c.contact_id = crm.contact_id
WHERE crm.role_type_id = roleTypeId
AND crm.filer_id = fillerId
AND c.status_code = 'Active'
		
		UNION
--  Lobbyist	Primay Contact	
select 
c.contact_id,
'Lobbyist Primay' as entity_type,
concat(c.first_name, ' ', c.last_name)  as name
from  public.lobbyist l
inner join public.contact c on c.contact_id = l.primary_contact_id
and l.lobbysit_id=_lobbyistid
AND c.status_code = 'Active';

 end
$BODY$;

ALTER FUNCTION public.getlobbyistemployee(integer)
    OWNER TO devadmin;



----------------------------------------Functions------------------------------------