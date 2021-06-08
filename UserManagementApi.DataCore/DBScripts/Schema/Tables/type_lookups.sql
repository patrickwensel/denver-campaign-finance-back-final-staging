

CREATE TABLE public.type_lookups
(
    lookup_type_code character varying(15) COLLATE pg_catalog."default" NOT NULL,
    type_id character varying(100) COLLATE pg_catalog."default" NOT NULL,
    name character varying(100) COLLATE pg_catalog."default" NOT NULL,
    "desc" character varying(150) COLLATE pg_catalog."default",
    "Order" integer DEFAULT 0,
    CONSTRAINT type_lookups_pkey PRIMARY KEY (lookup_type_code, type_id)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;
