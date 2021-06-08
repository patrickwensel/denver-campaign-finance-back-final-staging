------------------------------------------------------------------------------

-------------------------------------------------------------------------------



CREATE TABLE public.filing_period
(
    filing_period_id  SERIAL  PRIMARY KEY,
    name character varying(300) COLLATE pg_catalog."default" NOT NULL,
    "desc" character varying(1000) COLLATE pg_catalog."default",
    start_date date,
    end_date date,
    due_date timestamp without time zone,
    election_cycle_id integer,
    status_code character varying(20),
 created_by character varying(10) COLLATE pg_catalog."default",
    created_at date,
    updated_by character varying(10) COLLATE pg_catalog."default",
    updated_on date

)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.filing_period
    OWNER to devadmin;
------------------------------------------------------