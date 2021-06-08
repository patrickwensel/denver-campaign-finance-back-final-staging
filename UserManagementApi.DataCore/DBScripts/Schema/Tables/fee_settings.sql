
CREATE TABLE public.fee_settings
(
    feeid integer NOT NULL DEFAULT nextval('fee_settings_feeid_seq'::regclass),
    name character varying(255) COLLATE pg_catalog."default" NOT NULL,
    amount integer,
    duedate timestamp without time zone,
    invoice_date timestamp without time zone,
    status_code character varying(255) COLLATE pg_catalog."default",
    created_by character varying COLLATE pg_catalog."default",
    created_at timestamp without time zone,
    updated_by character varying COLLATE pg_catalog."default",
    updated_on timestamp without time zone,
    CONSTRAINT fee_settings_pkey PRIMARY KEY (feeid)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.fee_settings
    OWNER to devadmin;