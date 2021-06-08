
CREATE TABLE public.status_code
(
    type character varying(10) COLLATE pg_catalog."default" NOT NULL,
    code character varying(3) COLLATE pg_catalog."default" NOT NULL,
    "desc" character varying(25) COLLATE pg_catalog."default",
    "order" numeric(2,0),
    isactive boolean DEFAULT true,
    CONSTRAINT "status_code_PK's" PRIMARY KEY (type, code)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;