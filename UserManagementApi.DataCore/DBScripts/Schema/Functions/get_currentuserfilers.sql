-- FUNCTION: public.get_currentuserfilers(integer, character varying)

-- DROP FUNCTION public.get_currentuserfilers(integer, character varying);

CREATE OR REPLACE FUNCTION public.get_currentuserfilers(
	_entityid integer,
	_entitytype character varying)
    RETURNS TABLE(contactid integer, filerid integer, userid integer, firstname character varying, lastname character varying, email character varying, userrole character varying, permissions text) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
DECLARE filerIdVal int = 0;
DECLARE userIdVal int = 0;
begin

SELECT filer_id INTO filerIdVal FROM public.filer   
WHERE entity_id=_entityid and entity_type = _entitytype;
return query
  	
select c.contact_id,
crm.filer_id,
ua.user_id,
c.first_name,
c.last_name,
c.email,
rl.role ,
'' as permissions
from contact_role_mapping crm
inner join contact c on crm.contact_id=c.contact_id 
inner join role rl on rl.id = crm.role_type_id
inner join user_account ua on ua.user_id = crm.user_id
where   crm.filer_id=filerIdVal  and ua.user_id !=0 
and upper(c.status_code) = 'ACTIVE' and upper(crm.status_code) = 'ACTIVE' 
order by c.contact_id desc;
end
$BODY$;

ALTER FUNCTION public.get_currentuserfilers(integer, character varying)
    OWNER TO devadmin;
