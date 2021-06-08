-- Table: public.payment

-- DROP TABLE public.payment;

CREATE TABLE public.payment
(
    payment_id integer NOT NULL DEFAULT nextval('payment_payment_id_seq'::regclass),
    invoice_id integer NOT NULL,
    amount numeric(15,2) NOT NULL,
    date date,
    "user" character varying(100) COLLATE pg_catalog."default" NOT NULL,
    payment_method character varying(100) COLLATE pg_catalog."default" NOT NULL,
    filer_id integer NOT NULL,
    CONSTRAINT payment_invoice_pkey PRIMARY KEY (payment_id)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.payment
    OWNER to devadmin;