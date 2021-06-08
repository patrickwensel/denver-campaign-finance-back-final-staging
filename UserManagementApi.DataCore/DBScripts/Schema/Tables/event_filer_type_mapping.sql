-- Table: public.event_filer_type_mapping

-- DROP TABLE public.event_filer_type_mapping;

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