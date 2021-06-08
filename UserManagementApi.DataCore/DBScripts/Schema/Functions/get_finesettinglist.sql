-- FUNCTION: public.get_finesettinglist()

-- DROP FUNCTION public.get_finesettinglist();

CREATE OR REPLACE FUNCTION public.get_finesettinglist(
	)
    RETURNS TABLE(fineid integer, finename character varying, amount numeric, graceperiod integer, frequency character varying, finefilertypeids character varying, finefilermapid integer, filertypeid character varying, filertype character varying) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
begin
  return query
  	select fs.fine_id,
	fs."name",
	fs.amount,
	fs.grace_period,
	fs.frequency,
	fs.filertypeids,
	fsft.fine_filer_map_id,
	fsft.filer_type_id,
	tlkups."name"
	
	from
	fine_settings fs
	 inner join fine_filer_type_mapping fsft on fsft.fine_id = fs.fine_id
	 inner join type_lookups  tlkups on tlkups.type_id = fsft.filer_type_id
	where fs.status_code='ACTIVE' and fsft.status_code='ACTIVE';
	
end
$BODY$;

ALTER FUNCTION public.get_finesettinglist()
    OWNER TO devadmin;
