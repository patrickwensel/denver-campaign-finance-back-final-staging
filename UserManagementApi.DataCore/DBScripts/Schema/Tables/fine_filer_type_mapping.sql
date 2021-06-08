------------------------------------------------------------------------------

-------------------------------------------------------------------------------
CREATE TABLE public.fine_filer_type_mapping
(
    fine_filer_map_id  SERIAL  PRIMARY KEY,
    fine_id integer NOT NULL,
    filer_type_id character varying COLLATE pg_catalog."default" ,
    status_code character varying(20),
    created_by character varying(10) COLLATE pg_catalog."default",
    created_at date,
    updated_by character varying(10) COLLATE pg_catalog."default",
    updated_on date
)
------------------------------------------------------