-- FUNCTION: public.get_feelistbyid(integer)

-- DROP FUNCTION public.get_feelistbyid(integer);

CREATE OR REPLACE FUNCTION public.get_feelistbyid(
	_feeid integer)
    RETURNS TABLE(feeid integer, name character varying, amount integer, duedate timestamp without time zone, invoice_date timestamp without time zone, type_id character varying, filername character varying) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
begin
  return query
  	select fee_settings.feeid,
	fee_settings."name",
	fee_settings.amount,
	fee_settings.duedate,
	fee_settings.invoice_date,
	fee_filer_type_mapping.filertype_id,
	type_lookups.name as filername
	from
	fee_settings 
	inner join fee_filer_type_mapping  on fee_filer_type_mapping.fee_id = fee_settings.feeid
	inner join type_lookups on type_lookups.type_id = fee_filer_type_mapping.filertype_id
	where fee_settings.feeid= _feeid and fee_settings.status_code='Active';
	
end
$BODY$;

ALTER FUNCTION public.get_feelistbyid(integer)
    OWNER TO devadmin;
