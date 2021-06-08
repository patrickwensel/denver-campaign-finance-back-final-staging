-- FUNCTION: public.get_donortypes()

-- DROP FUNCTION public.get_donortypes();

CREATE OR REPLACE FUNCTION public.get_donortypes(
	)
    RETURNS TABLE(donortypeid character varying, donortype character varying, name character varying) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
begin
  return query
	SELECT Donor.lookup_type_code, Donor.type_id,  Donor.name
	FROM public.type_lookups Donor where Donor.lookup_type_code='FILER-TYPE';
end
$BODY$;

ALTER FUNCTION public.get_donortypes()
    OWNER TO devadmin;
