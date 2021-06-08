-- FUNCTION: public.delete_committetypename(character varying, character varying)

-- DROP FUNCTION public.delete_committetypename(character varying, character varying);

CREATE OR REPLACE FUNCTION public.delete_committetypename(
	_typeid character varying,
	_typecode character varying)
    RETURNS integer
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
begin
 update  public.type_lookups set status_code='DELETED'
 where type_id = _typeid and _typecode='COM';
return 1;
end
$BODY$;

ALTER FUNCTION public.delete_committetypename(character varying, character varying)
    OWNER TO devadmin;
