-- Table: public.user_role_permission

-- DROP TABLE public.user_role_permission;

CREATE TABLE public.user_role_permission
(
    ind integer NOT NULL,
    modulename character varying(200) COLLATE pg_catalog."default" NOT NULL,
    tenantid integer NOT NULL,
    candidate integer,
    treasusrer integer,
    committeeofficer integer,
    primarylobbylist integer,
    lobbylist integer,
    official integer,
    CONSTRAINT userpermissionsettings_pkey PRIMARY KEY (ind)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.user_role_permission
    OWNER to devadmin;