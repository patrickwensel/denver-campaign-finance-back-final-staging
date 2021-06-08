-- FUNCTION: public.get_lookups(character varying)

-- DROP FUNCTION public.get_lookups(character varying);

CREATE OR REPLACE FUNCTION public.get_lookups(
	lookuptype character varying)
    RETURNS TABLE(lookuptypecode character varying, lookuptypeid character varying, lookupname character varying, lookupdesc character varying, lookuporder integer) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
begin
  return query
  	SELECT 
		lookup.lookup_type_code, 
		lookup.type_id, 
		lookup.name, 
		lookup.desc,
		lookup."Order"
	FROM public.type_lookups lookup
	WHERE lookup_type_code = lookuptype
	order by lookup."Order";
end
$BODY$;

ALTER FUNCTION public.get_lookups(character varying)
    OWNER TO devadmin;
