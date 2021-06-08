-- Table: public.matchinglimits

-- DROP TABLE public.matchinglimits;

CREATE TABLE public.matchinglimits
(
    matchingid integer NOT NULL DEFAULT nextval('matchinglimits_matchingid_seq'::regclass),
    qualifyingcontributionamount numeric(15,2),
    matchingcontributionamount numeric(15,2),
    numberrequiredqualifyingcontributions integer,
    matchingratio character varying COLLATE pg_catalog."default",
    contributionlimitsforparticipate integer,
    totalavailablefunds numeric(15,2),
    office_type_id character varying COLLATE pg_catalog."default",
    qualifyingoffices character varying COLLATE pg_catalog."default",
    startdate date NOT NULL,
    endate date NOT NULL,
    electioncycle character varying COLLATE pg_catalog."default",
    CONSTRAINT matchinglimits_pkey PRIMARY KEY (matchingid)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.matchinglimits
    OWNER to devadmin;