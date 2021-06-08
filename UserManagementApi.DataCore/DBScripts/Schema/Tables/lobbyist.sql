CREATE TABLE public.lobbyist
(
    lobbysit_id serial,
	year character varying(10),
    type character varying(1),
    primary_contact_id integer NOT NULL,
    filer_contact_id integer,
    sign_first_name character varying(150) NULL,
    sign_last_name character varying(150) NULL,
    sign_email character varying(250) NULL,
    sign_image_url character varying(1000),
    admin_notes character varying(500),
	status_code character varying(10) NULL,
	created_by character varying(100) NULL,
	created_at date NULL,
	updated_by character varying(100) NULL,
	updated_on date NULL,
    CONSTRAINT lobbyist_pkey PRIMARY KEY (lobbysit_id)
)