-- FUNCTION: public.get_status(character varying)

-- DROP FUNCTION public.get_status(character varying);

CREATE OR REPLACE FUNCTION public.get_status(
	stype character varying)
    RETURNS TABLE(statustype character varying, statuscode character varying, statusdesc character varying, statusorder numeric, isactive boolean) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
begin
  return query
  	SELECT 
			status.type, 
		status.code,
		status."desc", 
		status."order",
		status.isactive
	FROM public.status_code status
	where status.type= sType
	ORDER BY status."order";
end
$BODY$;

ALTER FUNCTION public.get_status(character varying)
    OWNER TO devadmin;
