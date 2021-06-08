-- FUNCTION: public.get_events()

-- DROP FUNCTION public.get_events();

CREATE OR REPLACE FUNCTION public.get_events(
	)
    RETURNS TABLE(event_id integer, name character varying, descr character varying, eventdate timestamp with time zone, filertype character varying) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
begin
  return query
  select event.event_id,event.name,event.descr,event.eventdate,type_lookups.name
  from event inner join event_filer_type_mapping on  event.event_id = event_filer_type_mapping.event_id 
  inner join type_lookups on type_lookups.type_id = event_filer_type_mapping.filer_type_id;
 
 end
$BODY$;
