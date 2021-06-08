CREATE OR REPLACE FUNCTION public.delete_events(
	_eventid integer)
    RETURNS integer
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
begin

 UPDATE public.event
		SET status_code = 'DELETED',
			updated_on = now()
	WHERE event_id = _eventid;
	
	UPDATE public.event_filer_type_mapping
		SET status_code = 'DELETED',
			updated_on = now()
	WHERE event_id = _eventid;
return _eventid;
end
$BODY$;

ALTER FUNCTION public.delete_events(integer)
    OWNER TO devadmin;