CREATE TABLE public.user_account
(
    user_id serial,
    contact_id integer NOT NULL,
    notify_email_sent_on date NULL,
    notify_accepted_on date NULL,
    password character varying(150) NULL,
    status character varying(10) NULL,status_code character varying(10) NULL,
	created_by character varying(100) NULL,
	created_at date NULL,
	updated_by character varying(100) NULL,
	updated_on date NULL,
    CONSTRAINT user_account_pkey PRIMARY KEY (user_id)
)
