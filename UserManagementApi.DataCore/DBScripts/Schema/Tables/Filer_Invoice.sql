-- Table: public.filer_invoice

-- DROP TABLE public.filer_invoice;

CREATE TABLE public.filer_invoice
(
    invoice_id integer NOT NULL DEFAULT nextval('filer_invoice_invoice_id_seq'::regclass),
    invoice_type_id character varying(100) COLLATE pg_catalog."default" NOT NULL,
    "desc" character varying(1000) COLLATE pg_catalog."default" NOT NULL,
    filer_id integer NOT NULL,
    status character varying(100) COLLATE pg_catalog."default" NOT NULL,
    amount numeric(15,2),
    created_date date,
    CONSTRAINT filer_invoice_pkey PRIMARY KEY (invoice_id)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.filer_invoice
    OWNER to devadmin;