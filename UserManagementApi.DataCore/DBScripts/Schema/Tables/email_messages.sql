CREATE TABLE public.email_messages
(
    email_message_id serial,
    email_type_id character varying(15) NULL,
    txn_ref_id character varying(100) NULL,
    receiver_id character varying(1000) NULL,
    subject character varying(250) NULL,
	message character varying(2000) NULL,
	sent_on date NULL,
	is_user_action_required bool NULL,
	expiry_datetime date NULL,
	created_by character varying(100) NULL,
	created_at date NULL,
	updated_by character varying(100) NULL,
	updated_on date NULL,
    CONSTRAINT email_messages_pkey PRIMARY KEY (email_message_id)
)