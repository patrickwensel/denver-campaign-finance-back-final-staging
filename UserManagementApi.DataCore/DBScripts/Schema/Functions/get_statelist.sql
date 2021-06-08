-- FUNCTION: public.get_statelist()

-- DROP FUNCTION public.get_statelist();

CREATE OR REPLACE FUNCTION public.get_statelist(
	)
    RETURNS TABLE(stateid character varying, statecode character varying, statedesc character varying, "order" integer) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
begin
  return query
  	SELECT 
		state.type, 
		state.code,
		state."desc", 
		state."order"
	FROM public.states state
	ORDER BY state."order";
end
$BODY$;

ALTER FUNCTION public.get_statelist()
    OWNER TO devadmin;
