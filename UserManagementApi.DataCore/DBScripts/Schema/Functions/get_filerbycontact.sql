CREATE OR REPLACE FUNCTION public.get_filerbycontact(
	_contactid integer,
	_type character varying)
    RETURNS integer
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
begin


  return (SELECT filer_id FROM public."filer" WHERE entity_id = _contactid and entity_type = _type);
-- inserted fail retuns 0

end
$BODY$;

ALTER FUNCTION public.get_filerbycontact(integer, character varying)
    OWNER TO devadmin;


