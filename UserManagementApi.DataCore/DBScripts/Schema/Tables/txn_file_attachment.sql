-- Table: public.txn_file_attachment

-- DROP TABLE public.txn_file_attachment;

CREATE TABLE public.txn_file_attachment
(
    attachment_id integer NOT NULL DEFAULT nextval('txn_file_attachment_attachment_id_seq'::regclass),
    attachment_type_id character varying(100) COLLATE pg_catalog."default" NOT NULL,
    record_id integer NOT NULL,
    file_url character varying(1000) COLLATE pg_catalog."default" NOT NULL,
    file_mime_type character varying(10) COLLATE pg_catalog."default"
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.txn_file_attachment
    OWNER to devadmin;