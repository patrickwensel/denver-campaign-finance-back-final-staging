-- Table: public.election_cycle

-- DROP TABLE public.election_cycle;

CREATE TABLE public.election_cycle
(
    election_cycle_id integer NOT NULL,
    name character varying(200) COLLATE pg_catalog."default" NOT NULL,
    election_type_id character varying(10) COLLATE pg_catalog."default" NOT NULL,
    start_date date,
    end_date date,
    election_date date NOT NULL,
    status character varying(10) COLLATE pg_catalog."default" NOT NULL,
    "desc" character varying(1000) COLLATE pg_catalog."default",
    district character varying(100) COLLATE pg_catalog."default",
    ie_start_date date,
    ie_end_date date,
    status_code character varying(10) COLLATE pg_catalog."default",
    created_by character varying(100) COLLATE pg_catalog."default",
    created_at date,
    updated_by character varying(100) COLLATE pg_catalog."default",
    updated_on date,
    CONSTRAINT election_cycle_pkey PRIMARY KEY (election_cycle_id)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.election_cycle
    OWNER to devadmin;