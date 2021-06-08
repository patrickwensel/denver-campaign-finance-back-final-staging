-- Table: public.contact

-- DROP TABLE public.contact;

CREATE TABLE public.contact
(
    contact_id integer NOT NULL DEFAULT nextval('contact_contact_id_seq'::regclass),
    contact_type character varying(10) COLLATE pg_catalog."default" NOT NULL,
    first_name character varying(150) COLLATE pg_catalog."default",
    middle_name character varying(100) COLLATE pg_catalog."default",
    last_name character varying(150) COLLATE pg_catalog."default",
    org_name character varying(200) COLLATE pg_catalog."default",
    address1 character varying(200) COLLATE pg_catalog."default",
    address2 character varying(200) COLLATE pg_catalog."default",
    city character varying(150) COLLATE pg_catalog."default",
    state_code character varying(2) COLLATE pg_catalog."default",
    country_code character varying(2) COLLATE pg_catalog."default",
    zip character varying(10) COLLATE pg_catalog."default",
    email character varying(200) COLLATE pg_catalog."default",
    phone character varying(15) COLLATE pg_catalog."default",
    occupation character varying(150) COLLATE pg_catalog."default",
    voter_id character varying(50) COLLATE pg_catalog."default",
    description character varying(150) COLLATE pg_catalog."default",
    filerid integer,
    status_code character varying(10) COLLATE pg_catalog."default",
    created_by character varying(100) COLLATE pg_catalog."default",
    created_at date,
    updated_by character varying(100) COLLATE pg_catalog."default",
    updated_on date,
    altphone character varying(500) COLLATE pg_catalog."default",
    altemail character varying(500) COLLATE pg_catalog."default",
    version_id integer,
    CONSTRAINT contact_pkey PRIMARY KEY (contact_id)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.contact
    OWNER to devadmin;