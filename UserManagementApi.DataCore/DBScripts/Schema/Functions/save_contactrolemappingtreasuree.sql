-- FUNCTION: public.save_contactrolemappingtreasuree(integer, integer)

-- DROP FUNCTION public.save_contactrolemappingtreasuree(integer, integer);

CREATE OR REPLACE FUNCTION public.save_contactrolemappingtreasuree(
	_contactid integer,
	_filerid integer)
    RETURNS integer
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
DECLARE roleid integer;
DECLARE uid integer;
begin
	SELECT id INTO roleid 
		FROM public.role where role = 'Treasurer';
	
	SELECT user_id INTO uid 
	FROM public.user_account where contact_id = _contactid;

	insert into public."contact_role_mapping" ("user_id", "contact_id", 
											   "filer_id", "role_type_id", 
											   "created_by", "created_at", 
											   "updated_by", "updated_on", "status_code")
 	values(uid, _contactid, 
		   _filerid, roleid, 
		   'Denver', localtimestamp, 
		   'Denver', localtimestamp, 'ACTIVE');
  return (SELECT LASTVAL());
-- inserted fail retuns 0

end
$BODY$;

ALTER FUNCTION public.save_contactrolemappingtreasuree(integer, integer)
    OWNER TO devadmin;
