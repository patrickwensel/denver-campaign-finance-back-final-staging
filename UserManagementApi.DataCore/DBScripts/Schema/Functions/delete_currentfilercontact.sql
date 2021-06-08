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
