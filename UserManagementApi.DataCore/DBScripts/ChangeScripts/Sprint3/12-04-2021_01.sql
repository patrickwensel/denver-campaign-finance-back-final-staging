------------------------------------------tables---------------------------------------------------------

-- Table: public.event

-- DROP TABLE public.event;
CREATE TABLE public.event
(
    event_id integer NOT NULL DEFAULT nextval('event_event_id_seq'::regclass),
    name character varying(300) COLLATE pg_catalog."default" NOT NULL,
    descr character varying(1000) COLLATE pg_catalog."default",
    eventdate timestamp with time zone,
    bump_filing_due boolean,
    status_code character varying COLLATE pg_catalog."default",
    created_by character varying COLLATE pg_catalog."default",
    created_at timestamp with time zone,
    updated_by character varying COLLATE pg_catalog."default",
    updated_on timestamp with time zone,
    CONSTRAINT event_pkey PRIMARY KEY (event_id)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.event
    OWNER to devadmin;



CREATE TABLE public.event_filer_type_mapping
(
    event_filer_map_id integer NOT NULL,
    event_id integer,
    filer_type_id character varying COLLATE pg_catalog."default",
    status_code character varying(255) COLLATE pg_catalog."default",
    created_by character varying(255) COLLATE pg_catalog."default",
    created_at timestamp with time zone,
    updated_on timestamp with time zone,
    updated_by character varying COLLATE pg_catalog."default",
    CONSTRAINT event_filer_mapping_pkey PRIMARY KEY (event_filer_map_id)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.event_filer_type_mapping
    OWNER to devadmin;
----------------------------------------------------functions-----------------------------------------

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
------------------------------------------------------------------------------------------------------
-- FUNCTION: public.delete_events(integer)

-- DROP FUNCTION public.delete_events(integer);

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
----------------------------------------------------------------------------------
-- FUNCTION: public.get_events()

-- DROP FUNCTION public.get_events();

CREATE OR REPLACE FUNCTION public.get_events(
	)
    RETURNS TABLE(event_id integer, name character varying, descr character varying, eventdate timestamp with time zone, filertype character varying, filerid character varying) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
begin
  return query
  select event.event_id,event.name,event.descr,event.eventdate,type_lookups.name,type_lookups.type_id
  from event inner join event_filer_type_mapping on  event.event_id = event_filer_type_mapping.event_id 
  inner join type_lookups on type_lookups.type_id = event_filer_type_mapping.filer_type_id;
 
 end
$BODY$;

ALTER FUNCTION public.get_events()
    OWNER TO devadmin;
-----------------------------------------------------------------------------------------