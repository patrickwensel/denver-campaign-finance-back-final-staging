CREATE OR REPLACE FUNCTION public.get_eventdetailsbyfiler(
	_filertype character varying,
	_startdate date,
	_enddate date)
    RETURNS TABLE(title character varying, description character varying, edate date) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
begin
return query
SELECT ec.name,ec."descr",DATE(ec.eventdate) FROM public.event ec
Left JOIN public.event_filer_type_mapping eftm on ec.event_id = eftm.event_id
WHERE (ec.eventdate, ec.eventdate ) OVERLAPS (_startdate::DATE, _enddate::DATE) 
AND eftm.filer_type_id = _filertype;
 end
$BODY$;

ALTER FUNCTION public.get_eventdetailsbyfiler(character varying, date, date)
    OWNER TO devadmin;