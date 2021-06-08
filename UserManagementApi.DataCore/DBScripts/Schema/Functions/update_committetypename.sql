-- FUNCTION: public.update_committetypename(character varying, character varying, character varying, character varying, integer)

-- DROP FUNCTION public.update_committetypename(character varying, character varying, character varying, character varying, integer);

CREATE OR REPLACE FUNCTION public.update_committetypename(
	_lookuptypecode character varying,
	_typeid character varying,
	_typename character varying,
	_typedesc character varying,
	_typeorder integer)
    RETURNS integer
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
begin
 update public.type_lookups  set lookup_type_code = _lookuptypecode,
 "name" = _typename,
 "desc" = _typedesc, 
 "Order" = _typeorder
 where type_id = _typeid;
 return 1;
end
$BODY$;

ALTER FUNCTION public.update_committetypename(character varying, character varying, character varying, character varying, integer)
    OWNER TO devadmin;
