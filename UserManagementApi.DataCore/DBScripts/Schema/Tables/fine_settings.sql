------------------------------------------------------------------------------

-------------------------------------------------------------------------------
CREATE TABLE public.fine_settings
(
    fine_id  SERIAL  PRIMARY KEY,
    "name" character varying(300) COLLATE pg_catalog."default" NOT NULL,
    amount numeric(15,2) NOT NULL,
    grace_period integer,
    frequency character varying(1) NOT NULL, 
    filertypeids character varying(300),
    status_code character varying(20),
    created_by character varying(10) COLLATE pg_catalog."default",
    created_at date,
    updated_by character varying(10) COLLATE pg_catalog."default",
    updated_on date
)
------------------------------------------------------