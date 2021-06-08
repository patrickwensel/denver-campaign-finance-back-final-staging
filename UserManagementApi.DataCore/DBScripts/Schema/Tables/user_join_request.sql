CREATE TABLE public.user_join_request
(
    join_request_id serial,
    request_type character varying(10) NULL,
    filer_id integer NULL,
    user_email character varying(250) NULL,
    user_contact_id integer NULL,
	inviter_contact_id integer NULL,
	email_msg_id integer NULL,
	user_join_note character varying(1000) NULL,
	created_by character varying(100) NULL,
	created_at date NULL,
	updated_by character varying(100) NULL,
	updated_on date NULL,
    CONSTRAINT user_join_request_pkey PRIMARY KEY (join_request_id)
)