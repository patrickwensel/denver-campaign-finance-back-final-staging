CREATE OR REPLACE FUNCTION public.save_filer(
	_entitytype character varying,
	_entityid integer,
	_categoryid integer,
	_filerstatus character varying)
    RETURNS integer
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
DECLARE id int = 0;
begin
 insert into public."filer" ("entity_type", "entity_id", "categoryid", "filer_status", "created_by", "created_at", "updated_by", "updated_on")
 values(_entitytype, _entityid, _categoryid, _filerstatus, 'Denver', localtimestamp, 'Denver', localtimestamp);
  return (SELECT LASTVAL());
-- inserted fail retuns 0

end
$BODY$;

ALTER FUNCTION public.save_filer(character varying, integer,  integer, character varying)
    OWNER TO devadmin;
