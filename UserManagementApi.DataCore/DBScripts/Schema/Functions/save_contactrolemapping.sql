-- FUNCTION: public.save_contactrolemapping(integer, integer, integer)

-- DROP FUNCTION public.save_contactrolemapping(integer, integer, integer);

CREATE OR REPLACE FUNCTION public.save_contactrolemapping(
	_userid integer,
	_contactid integer,
	_filerid integer)
    RETURNS integer
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
DECLARE roleid integer;
begin
SELECT id INTO roleid FROM public.role where role = 'Candidate';
insert into public."contact_role_mapping" ("user_id", "contact_id", "filer_id", "role_type_id", "created_by", "created_at", "updated_by", "updated_on", "status_code")
 values(_userid, _contactid, _filerid, roleid, _userid, localtimestamp, _userid, localtimestamp, 'ACTIVE');
  return (SELECT LASTVAL());
-- inserted fail retuns 0

end
$BODY$;

ALTER FUNCTION public.save_contactrolemapping(integer, integer, integer)
    OWNER TO devadmin;
