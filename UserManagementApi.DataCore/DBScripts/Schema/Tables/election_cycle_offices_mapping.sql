-- Table: public.election_cycle_offices_mapping

-- DROP TABLE public.election_cycle_offices_mapping;

CREATE TABLE public.election_cycle_offices_mapping
(
    election_office_map_id integer NOT NULL,
    election_cycle_id integer,
    office_id character varying(10) COLLATE pg_catalog."default",
    status_code character varying(10) COLLATE pg_catalog."default",
    created_by character varying(100) COLLATE pg_catalog."default",
    created_at date,
    updated_by character varying(100) COLLATE pg_catalog."default",
    updated_on date,
    CONSTRAINT election_cycle_offices_mapping_pkey PRIMARY KEY (election_office_map_id)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.election_cycle_offices_mapping
    OWNER to devadmin;