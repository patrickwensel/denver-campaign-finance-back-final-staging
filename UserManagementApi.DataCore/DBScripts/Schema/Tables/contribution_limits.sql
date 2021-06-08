------------------------------------------------------------------------------
--tablename:contribution_limits
--date:30-03-2021
--DevelopedBy: API teams Denver
-------------------------------------------------------------------------------

CREATE TABLE public.contribution_limits
(
    id integer NOT NULL DEFAULT nextval('contribution_limits_id_seq'::regclass),
    commitee_type_id character varying(1000) COLLATE pg_catalog."default",
    office_type_id character varying(1000) COLLATE pg_catalog."default",
    donor_type_id character varying(1000) COLLATE pg_catalog."default",
    election_cycle_id integer NOT NULL,
    tenant_id integer NOT NULL,
    commitee_type character varying(1000) COLLATE pg_catalog."default",
    office_type character varying(1000) COLLATE pg_catalog."default",
    donor_type character varying(1000) COLLATE pg_catalog."default",
    cont_limit numeric(15,2),
    election_year character varying(1000) COLLATE pg_catalog."default",
    description character varying(1000) COLLATE pg_catalog."default",
    CONSTRAINT contribution_limits_pkey PRIMARY KEY (id)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.contribution_limits
    OWNER to devadmin;