------------------------------------------------------------------------------
--tablename:ballot_issue
--date:30-03-2021
--DevelopedBy: API teams Denver
-------------------------------------------------------------------------------

CREATE TABLE public.ballot_issue
(
    ballot_issue_id integer NOT NULL DEFAULT nextval('ballot_issue_ballot_issue_id_seq'::regclass),
    ballot_issue_code character varying(100) COLLATE pg_catalog."default" NOT NULL,
    ballot_issue character varying(1000) COLLATE pg_catalog."default" NOT NULL,
    created_by character varying(10) COLLATE pg_catalog."default",
    created_at date,
    updated_by character varying(10) COLLATE pg_catalog."default",
    updated_on date,
    sequence_no integer,
    isactive boolean,
    election_date date,
    election_cycle character varying(1000) COLLATE pg_catalog."default",
    CONSTRAINT ballot_issue_pkey PRIMARY KEY (ballot_issue_id)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.ballot_issue
    OWNER to devadmin;