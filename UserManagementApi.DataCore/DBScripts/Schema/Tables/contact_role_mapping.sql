-- Table: public.contact_role_mapping

-- DROP TABLE public.contact_role_mapping;

CREATE TABLE public.contact_role_mapping
(
    contact_role_mapping_id integer NOT NULL DEFAULT nextval('contact_role_mapping_contact_role_mapping_id_seq'::regclass),
    user_id integer,
    contact_id integer,
    filer_id integer,
    role_type_id integer,
    created_by character varying(100) COLLATE pg_catalog."default",
    created_at date,
    updated_by character varying(100) COLLATE pg_catalog."default",
    updated_on date,
    status_code character varying(100) COLLATE pg_catalog."default",
    CONSTRAINT contact_role_mapping_pkey PRIMARY KEY (contact_role_mapping_id)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.contact_role_mapping
    OWNER to devadmin;