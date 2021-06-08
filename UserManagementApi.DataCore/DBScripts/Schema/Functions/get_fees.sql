-- FUNCTION: public.get_fees()

-- DROP FUNCTION public.get_fees();

CREATE OR REPLACE FUNCTION public.get_fees(
	)
    RETURNS TABLE(feeid integer, name character varying, amount integer, duedate timestamp without time zone, invoice_date timestamp without time zone, filername character varying, type_id character varying) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
begin
  return query
   select fee_settings.feeid,fee_settings.name,fee_settings.amount,fee_settings.duedate,fee_settings.invoice_date,type_lookups.name as filername ,type_lookups.type_id
  from fee_settings inner join fee_filer_type_mapping on  fee_settings.feeid = fee_filer_type_mapping.fee_id 
  inner join type_lookups on type_lookups.type_id = fee_filer_type_mapping.filertype_id
  where fee_settings.status_code='Active' order by fee_settings.feeid;
 end
$BODY$;

ALTER FUNCTION public.get_fees()
    OWNER TO devadmin;
