-- Table: public.lobbyist_client

-- DROP TABLE public.lobbyist_client;

CREATE TABLE public.lobbyist_client
(
    lobbyist_client_id integer NOT NULL,
    contact_id integer,
    employee_id integer,
    client_id integer,
    nature_of_business character varying(150) COLLATE pg_catalog."default" NOT NULL,
    legislative_matters character varying(150) COLLATE pg_catalog."default" NOT NULL,
    status_code character varying(10) COLLATE pg_catalog."default",
    created_by character varying(20) COLLATE pg_catalog."default",
    created_at date,
    updated_by character varying(20) COLLATE pg_catalog."default",
    updated_on date,
    CONSTRAINT lobbyist_client_pkey PRIMARY KEY (lobbyist_client_id)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.lobbyist_client
    OWNER to devadmin;