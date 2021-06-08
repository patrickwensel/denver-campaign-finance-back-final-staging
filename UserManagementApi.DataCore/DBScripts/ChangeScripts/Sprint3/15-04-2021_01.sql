-- FUNCTION: public.get_eventslistbyid(integer)

-----------------------------------------------------------functions-----------------------------------------------------

CREATE OR REPLACE FUNCTION public.get_eventslistbyid(
	_eventid integer)
    RETURNS TABLE(event_id integer, name character varying, descr character varying, eventdate timestamp with time zone, filername character varying, filer_type_id character varying, event_filer_map_id integer) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
begin
  return query
  	select fp.event_id,
	fp."name",
	fp."descr",
	fp.eventdate,
	type_lookups.name as filername,
	fpftm.filer_type_id,
	fpftm.event_filer_map_id
	from
	event fp
	inner join event_filer_type_mapping fpftm on fpftm.event_id = fp.event_id
	inner join type_lookups on type_lookups.type_id = fpftm.filer_type_id
	where fp.event_id = _eventid and fp.status_code='Active';
	
end
$BODY$;

ALTER FUNCTION public.get_eventslistbyid(integer)
    OWNER TO devadmin;
