-- FUNCTION: public.get_committeetypedetails()

-- DROP FUNCTION public.get_committeetypedetails();

CREATE OR REPLACE FUNCTION public.get_committeetypedetails(
	)
    RETURNS TABLE(lookuptypecode character varying, typeid character varying, typename character varying, typedesc character varying, typeorder integer) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
begin
  return query
 select tlup.lookup_type_code,tlup.type_id, tlup."name", tlup."desc", tlup."Order"
 from public.type_lookups tlup 
 where tlup.lookup_type_code= 'COM' and tlup.status_code='ACTIVE';
 end
$BODY$;

ALTER FUNCTION public.get_committeetypedetails()
    OWNER TO devadmin;
