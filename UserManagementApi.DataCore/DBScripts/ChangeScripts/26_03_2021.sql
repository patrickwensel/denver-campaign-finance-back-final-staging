---------------------------------------Tables------------------------------------------------
CREATE TABLE public.contact
(
    contact_id serial,
    contact_type character varying(1) NOT NULL,
    first_name character varying(150) NULL,
    middle_name character varying(100) NULL,
    last_name character varying(150) NULL,
    org_name character varying(200) NULL,
    address1 character varying(200) NULL,
	address2 character varying(200) NULL,
	city character varying(150) NULL,
	state_code character varying(2) NULL,
	country_code character varying(2) NULL,
    zip character varying(10) NULL,
	email character varying(200) NULL,
    phone character varying(15) NULL,
    occupation character varying(150) NULL,
    voter_id character varying(50) NULL,
    description character varying(150) NULL,
    filerid integer NULL,
	status_code character varying(10) NULL,
	created_by character varying(100) NULL,
	created_at date NULL,
	updated_by character varying(100) NULL,
	updated_on date NULL,
    CONSTRAINT contact_pkey PRIMARY KEY (contact_id)
)
-------------------------------------------------------------

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
---------------------------------------Tables------------------------------------------------

---------------------------------------Functions---------------------------------------------
CREATE OR REPLACE FUNCTION public.save_contact(
	_contacttype character varying,
	_firstname character varying,
	_lastname character varying,
	_address1 character varying,
	_address2 character varying,
	_city character varying,
	_state character varying,
	_zip character varying,
	_phone character varying,
	_email character varying)
    RETURNS integer
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
DECLARE id int = 0;
begin
 insert into public."contact" ("contact_type", "first_name", "last_name", "address1", "address2", "city", "state_code", "zip" , "phone", "email", "created_by", "created_at", "updated_by", "updated_on")
 values(_contacttype, _firstname, _lastname, _address1, _address2, _city, _state, _zip, _phone, _email, 'Denver', localtimestamp, 'Denver', localtimestamp);
  return (SELECT LASTVAL());
-- inserted fail retuns 0

end
$BODY$;

ALTER FUNCTION public.save_contact(character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying)
    OWNER TO devadmin;

    ---------------------------------------------------------

    CREATE OR REPLACE FUNCTION public.save_useraccount(
	_password character varying,
	_contactid integer,
	_status character varying)
    RETURNS integer
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
DECLARE id int = 0;
begin
 insert into public."user_account" ("contact_id", "password", "status", "created_by", "created_at", "updated_by", "updated_on")
 values(_contactid, _password, _status, 'Denver', localtimestamp, 'Denver', localtimestamp);
  return (SELECT LASTVAL());
-- inserted fail retuns 0

end
$BODY$;

ALTER FUNCTION public.save_useraccount(character varying, integer, character varying)
    OWNER TO devadmin;
---------------------------------------Functions---------------------------------------------


---------------------------------------Triggers---------------------------------------------

---------------------------------------Triggers---------------------------------------------