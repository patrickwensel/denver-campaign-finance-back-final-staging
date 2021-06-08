-- Table: public.lobbyist_relationship

-- DROP TABLE public.lobbyist_relationship;

CREATE TABLE public.lobbyist_relationship
(
    lobbyist_relationship_id integer NOT NULL,
    contact_id integer,
    official_name character varying(150) COLLATE pg_catalog."default" NOT NULL,
    official_title character varying(100) COLLATE pg_catalog."default" NOT NULL,
    relationship character varying(100) COLLATE pg_catalog."default" NOT NULL,
    entity_name character varying(150) COLLATE pg_catalog."default" NOT NULL,
    status_code character varying(10) COLLATE pg_catalog."default",
    created_by integer,
    created_at date,
    updated_by integer,
    updated_on date,
    employee_id integer,
    CONSTRAINT lobbyist_relationship_pkey PRIMARY KEY (lobbyist_relationship_id),
    CONSTRAINT contact_id FOREIGN KEY (lobbyist_relationship_id)
        REFERENCES public.contact (contact_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.lobbyist_relationship
    OWNER to devadmin;

COMMENT ON CONSTRAINT contact_id ON public.lobbyist_relationship
    IS 'Reference Table';