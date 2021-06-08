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