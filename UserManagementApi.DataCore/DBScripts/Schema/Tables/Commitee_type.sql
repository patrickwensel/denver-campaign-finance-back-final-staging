------------------------------------------------------------------------------
--tablename:committee_type
--date:30-03-2021
--DevelopedBy: API teams Denver
-------------------------------------------------------------------------------

CREATE TABLE public.committee_type
(
    committetypeid integer NOT NULL DEFAULT nextval('committetype_sm_committetypeid_seq'::regclass),
    committetypename character varying(1000) COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT committetype_sm_pkey PRIMARY KEY (committetypeid)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.committee_type
    OWNER to devadmin;