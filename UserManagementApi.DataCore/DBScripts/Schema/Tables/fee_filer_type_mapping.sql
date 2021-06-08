-- Table: public.fee_filer_type_mapping

-- DROP TABLE public.fee_filer_type_mapping;

CREATE TABLE public.fee_filer_type_mapping
(
    fee_filer_map_id integer NOT NULL DEFAULT nextval('fee_filer_type_mapping_fee_filer_map_id_seq'::regclass),
    fee_id integer,
    filertype_id character varying COLLATE pg_catalog."default",
    status_code character varying(255) COLLATE pg_catalog."default",
    created_by character varying COLLATE pg_catalog."default",
    created_on timestamp without time zone,
    updated_by character varying COLLATE pg_catalog."default",
    updated_on timestamp without time zone,
    CONSTRAINT fee_filer_type_mapping_pkey PRIMARY KEY (fee_filer_map_id)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.fee_filer_type_mapping
    OWNER to devadmin;