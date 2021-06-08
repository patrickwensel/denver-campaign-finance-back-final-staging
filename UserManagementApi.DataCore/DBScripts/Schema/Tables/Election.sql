

CREATE TABLE public.election
(
    id integer NOT NULL,
    election_date date NOT NULL,
    name character varying(300) COLLATE pg_catalog."default",
    "desc" character varying(1000) COLLATE pg_catalog."default",
    tenant_id integer,
    status_code character varying(3) COLLATE pg_catalog."default",
    "created_ by" character varying(10) COLLATE pg_catalog."default",
    created_at date,
    updated_by character varying(10) COLLATE pg_catalog."default",
    updated_on date,
    CONSTRAINT election_pkey PRIMARY KEY (id)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.election
    OWNER to devadmin;