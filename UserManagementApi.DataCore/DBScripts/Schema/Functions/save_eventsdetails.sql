-- FUNCTION: public.save_eventsdetails(integer, character varying, character varying, timestamp with time zone, boolean, character varying)

-- DROP FUNCTION public.save_eventsdetails(integer, character varying, character varying, timestamp with time zone, boolean, character varying);

CREATE OR REPLACE FUNCTION public.save_eventsdetails(
	_event_ids integer,
	_name character varying,
	_desc character varying,
	_eventdate timestamp with time zone,
	_bump_filing_due boolean,
	_filer_type_id character varying)
    RETURNS integer
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
DECLARE userId int = 0;
declare eventid int = 0;
begin
if NOT EXISTS (SELECT 1 FROM event
				  	WHERE event_id = _event_ids) then
	INSERT INTO public.Event(
		event_id, name, descr, 
		eventdate, bump_filing_due,status_code,created_by,created_at)
	VALUES (nextval('events_id_seq'), _name, _desc, 
			_eventdate, _bump_filing_due,'Active','Denver',now());		
		eventid  = (SELECT LASTVAL());	
		
  INSERT INTO public.event_filer_type_mapping(
		event_filer_map_id,event_id,filer_type_id,status_code,created_by,created_at)
	VALUES (nextval('EventMapping_id_seq'),eventid, _filer_type_id,'Active','Denver',now());
					
	SELECT CURRVAL('events_id_seq') INTO userId;
		if found then --inserted successfully
	  	return userId;
	else 
		return 0; -- inserted fail
	end if;
else
	update event set name = _name,  
 descr = _desc, eventdate = _eventdate,bump_filing_due = _bump_filing_due,updated_by='Denver',updated_on = now()
 where event_id = _event_ids;
 
 update event_filer_type_mapping set filer_type_id = _filer_type_id,updated_by='Denver',updated_on = now()
 where event_id = _event_ids;
 return _event_ids;
end if;

end
$BODY$;

ALTER FUNCTION public.save_eventsdetails(integer, character varying, character varying, timestamp with time zone, boolean, character varying)
    OWNER TO devadmin;
