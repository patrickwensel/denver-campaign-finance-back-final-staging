
CREATE TABLE public.states
(
    type character varying(10) COLLATE pg_catalog."default" NOT NULL,
    code character varying(3) COLLATE pg_catalog."default" NOT NULL,
    "desc" character varying(25) COLLATE pg_catalog."default" NOT NULL,
    "order" integer NOT NULL,
    isactive boolean DEFAULT true,
    CONSTRAINT status_code_pkey PRIMARY KEY (type, code)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;