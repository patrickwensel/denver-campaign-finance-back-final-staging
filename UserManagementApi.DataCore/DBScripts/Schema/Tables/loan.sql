-- Table: public.loan

-- DROP TABLE public.loan;
---------------------------------------------------------------------------------tables---------------------------------
CREATE TABLE public.loan
(
    loan_id integer NOT NULL DEFAULT nextval('loan_loan_id_seq'::regclass),
    filer_id integer,
    loan_type integer,
    tenderid integer,
    loan_amount integer,
    loan_date timestamp without time zone,
    guarantor_name character varying(200) COLLATE pg_catalog."default",
    guaranteed_amount integer,
    interest_rate character varying(50) COLLATE pg_catalog."default",
    due_date timestamp without time zone,
    admin_notes character varying(250) COLLATE pg_catalog."default",
    created_by character varying COLLATE pg_catalog."default",
    created_at timestamp without time zone,
    updated_by character varying COLLATE pg_catalog."default",
    updated_on timestamp without time zone,
    CONSTRAINT loan_pkey PRIMARY KEY (loan_id)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.loan
    OWNER to devadmin;