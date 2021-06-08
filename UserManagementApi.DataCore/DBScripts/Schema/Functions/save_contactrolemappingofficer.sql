-- FUNCTION: public.save_contactrolemappingofficer(integer, integer, integer)

-- DROP FUNCTION public.save_contactrolemappingofficer(integer, integer, integer);

CREATE OR REPLACE FUNCTION public.save_contactrolemappingofficer(
	_userid integer,
	_contactid integer,
	_committeeid integer)
    RETURNS integer
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
DECLARE roleid integer;
DECLARE filid integer;
begin

SELECT id INTO roleid FROM public.role where role = 'Officer';
SELECT filer_id INTO filid FROM public.filer where entity_id = _committeeid and entity_type = 'C';

insert into public."contact_role_mapping" ("user_id", "contact_id", "filer_id", "role_type_id", "created_by", "created_at", "updated_by", "updated_on", "status_code")
 values(_userid, _contactid, filid, roleid, 'Denver', localtimestamp, 'Denver', localtimestamp, 'ACTIVE');
  return (SELECT LASTVAL());
-- inserted fail retuns 0

end
$BODY$;

ALTER FUNCTION public.save_contactrolemappingofficer(integer, integer, integer)
    OWNER TO devadmin;
