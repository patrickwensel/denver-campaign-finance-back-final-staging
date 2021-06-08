-- Table: public.loan_sub_transaction

-- DROP TABLE public.loan_sub_transaction;
----------------------------------------------------------
CREATE TABLE public.loan_sub_transaction
(
    loan_sub_id integer NOT NULL DEFAULT nextval('loan_sub_transaction_loan_sub_id_seq'::regclass),
    loan_id integer,
    amount integer,
    subloan_date timestamp without time zone,
    type character varying(10) COLLATE pg_catalog."default",
    CONSTRAINT loan_sub_transaction_pkey PRIMARY KEY (loan_sub_id),
    CONSTRAINT loan_sub_transaction_loan_id_fkey FOREIGN KEY (loan_id)
        REFERENCES public.loan (loan_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.loan_sub_transaction
    OWNER to devadmin;