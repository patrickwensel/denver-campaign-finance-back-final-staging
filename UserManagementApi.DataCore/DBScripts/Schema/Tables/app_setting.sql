------------------------------------------------------------------------------
--tablename:Appsetting
--date:30-03-2021
--DevelopedBy: API teams Denver
-------------------------------------------------------------------------------
CREATE TABLE public.app_setting
(
    app_id integer NOT NULL DEFAULT nextval('app_tenant_app_id_seq'::regclass),
    app_name character varying(40) COLLATE pg_catalog."default",
    theme_name character varying(100) COLLATE pg_catalog."default",
    logo_url character varying(50000) COLLATE pg_catalog."default",
    fav_icon character varying(50000) COLLATE pg_catalog."default",
    banner_image_url character varying(50000) COLLATE pg_catalog."default",
    seal_image_url character varying(50000) COLLATE pg_catalog."default",
    clerk_seal_image_url character varying(50000) COLLATE pg_catalog."default",
    header_image_url character varying(50000) COLLATE pg_catalog."default",
    footer_image_url character varying(50000) COLLATE pg_catalog."default",
    clerk_sign_image_url character varying(50000) COLLATE pg_catalog."default",
    created_by character varying(10) COLLATE pg_catalog."default",
    created_at date,
    updated_by character varying(10) COLLATE pg_catalog."default",
    updated_on date,
    CONSTRAINT app_setting_pkey PRIMARY KEY (app_id)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.app_setting
    OWNER to devadmin;
------------------------------------------------------