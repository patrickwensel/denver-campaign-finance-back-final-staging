----------------------------------------Functions------------------------------------

-- FUNCTION: public.delete_currentfilercontact(integer, integer)

-- DROP FUNCTION public.delete_currentfilercontact(integer, integer);

CREATE OR REPLACE FUNCTION public.delete_currentfilercontact(
	_contactid integer,
	_filerid integer)
    RETURNS integer
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
begin

 update  public.contact_role_mapping set status_code='DELETED'
 where contact_id = _contactid and filer_id=_filerid;
 
 if found then --deleted successfully
  return 1;
 else
  return 0;
 end if;
end
$BODY$;

ALTER FUNCTION public.delete_currentfilercontact(integer, integer)
    OWNER TO devadmin;

----------------------------------------Functions------------------------------------
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
where   crm.filer_id=filerIdVal  and ua.user_id !=null
and upper(c.status_code) = 'ACTIVE' and (crm.status_code) = 'ACTIVE'
order by c.contact_id desc;
end
$BODY$;

ALTER FUNCTION public.get_currentuserfilers(integer, character varying)
    OWNER TO devadmin;


----------------------------------------Functions------------------------------------

-- FUNCTION: public.delete_currentusercontact(integer)

-- DROP FUNCTION public.delete_currentusercontact(integer);

CREATE OR REPLACE FUNCTION public.delete_currentfilercontact(
	_contactid integer,
	_filerid integer)
    RETURNS integer
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
begin

 update  public.contact set status_code='DELETED'
 where contact_id = _contactid;
 update  public.contact_role_mapping set status_code='DELETED'
 where contact_id = _contactid and filer_id=_filerid;
 
 if found then --deleted successfully
  return 1;
 else
  return 0;
 end if;
end
$BODY$;




 ----------------------------------------Functions------------------------------------


