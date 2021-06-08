-- Table: public.offices

-- DROP TABLE public.offices;

CREATE TABLE public.offices
(
    officeid integer NOT NULL DEFAULT nextval('offices_officeid_seq'::regclass),
    office character varying(120) COLLATE pg_catalog."default" NOT NULL,
    createddate date,
    updateddate date,
    CONSTRAINT offices_pkey PRIMARY KEY (officeid)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.offices
    OWNER to devadmin;