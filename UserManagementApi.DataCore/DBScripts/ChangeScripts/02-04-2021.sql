----------------------------------------Functions------------------------------------------


CREATE OR REPLACE FUNCTION public.update_lobbyistsignature(
	_lobbyistid integer,
	_signfirstname character varying,
	_signlastname character varying,
	_signemail character varying,
	_signimageurl character varying)
    RETURNS integer
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
begin
 update public."lobbyist" set "sign_first_name"=_signfirstname, 
 "sign_last_name" = _signlastname,
 "sign_email" = _signemail,
 "sign_image_url" = _signimageurl

 where "lobbysit_id" = _lobbyistid;
 return _lobbyistid;
end
$BODY$;



---------------------------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION public.get_filerbycontact(
	_contactid integer,
	_type character varying)
    RETURNS integer
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
begin


  return (SELECT filer_id FROM public."filer" WHERE entity_id = _contactid and entity_type = _type);
-- inserted fail retuns 0

end
$BODY$;

ALTER FUNCTION public.get_filerbycontact(integer, character varying)
    OWNER TO devadmin;





-------------------------------------------------------------------------------------------



-- FUNCTION: public.save_emailmessages(integer, character varying, character varying, character varying, character varying, date, boolean, date)

-- DROP FUNCTION public.save_emailmessages(integer, character varying, character varying, character varying, character varying, date, boolean, date);

CREATE OR REPLACE FUNCTION public.save_emailmessages(
	_emailtypeid integer,
	_txnrefid character varying,
	_receiverid character varying,
	_subject character varying,
	_message character varying,
	_sendon date,
	_isuseractionrequired boolean,
	_expirydatetime date)
    RETURNS integer
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
DECLARE id int = 0;
begin
 insert into public."email_messages" ("email_type_id", "txn_ref_id", "receiver_id", "subject", "message", "sent_on", "is_user_action_required", "expiry_datetime", "created_by", "created_at", "updated_by", "updated_on")
 values(_emailtypeid, _txnrefid, _receiverid, _subject, _message, _sendon, _isuseractionrequired, _expirydatetime, 'Denver', localtimestamp, 'Denver', localtimestamp);
  return (SELECT LASTVAL());
-- inserted fail retuns 0

end
$BODY$;

ALTER FUNCTION public.save_emailmessages(integer, character varying, character varying, character varying, character varying, date, boolean, date)
    OWNER TO devadmin;

    ------------------------------------------------------

    CREATE OR REPLACE FUNCTION public.save_userjoinrequest(
	_requesttype character varying,
	_filerid integer,
	_useremail character varying,
	_usercontactid integer,
	_invitercontactid integer,
	_emailmessageid integer,
	_userjoindate character varying)
    RETURNS integer
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
DECLARE id int = 0;
begin
 insert into public."user_join_request" ("request_type", "filer_id", "user_email", "user_contact_id", "inviter_contact_id", "email_msg_id", "user_join_note", "created_by", "created_at", "updated_by", "updated_on")
 values(_requesttype, _filerid, _useremail, _usercontactid, _invitercontactid, _emailmessageid, _userjoindate, 'Denver', localtimestamp, 'Denver', localtimestamp);
  return (SELECT LASTVAL());
-- inserted fail retuns 0

end
$BODY$;

ALTER FUNCTION public.save_userjoinrequest(character varying, integer, character varying, integer, integer, integer, character varying)
    OWNER TO devadmin;


    ------------------------------------------

    CREATE OR REPLACE FUNCTION public.save_pacorsmalldonorcommittee(
	_committeetypeid integer,
	_purpose character varying,
	_registrationstatus character varying)
    RETURNS integer
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
DECLARE id int = 0;
begin
 insert into public."committee" ("typeid", "purpose", "registration_status", "created_by", "created_at", "updated_by", "updated_on")
 values(_committeetypeid, _purpose, _registrationstatus, 'Denver', localtimestamp, 'Denver', localtimestamp);
  return (SELECT LASTVAL());
-- inserted fail retuns 0

end
$BODY$;

ALTER FUNCTION public.save_pacorsmalldonorcommittee(integer, character varying, character varying)
    OWNER TO devadmin;
-----------------------------------------

CREATE OR REPLACE FUNCTION public.save_issuecommittee(
	_name character varying,
	_committeetypeid integer,
	_ballotissueid integer,
	_electioncycleid integer,
	_position character varying,
	_purpose character varying,
	_registrationstatus character varying)
    RETURNS integer
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
DECLARE id int = 0;
begin
 insert into public."committee" ("name", "typeid", "ballot_issue_id", "election_cycle_id", "position", "purpose", "registration_status", "created_by", "created_at", "updated_by", "updated_on")
 values(_name, _committeetypeid, _ballotissueid, _electioncycleid, _position, _purpose, _registrationstatus, 'Denver', localtimestamp, 'Denver', localtimestamp);
  return (SELECT LASTVAL());
-- inserted fail retuns 0

end
$BODY$;

ALTER FUNCTION public.save_issuecommittee(character varying, integer, integer, integer, character varying, character varying, character varying)
    OWNER TO devadmin;
----------------------------------------Functions------------------------------------------

---------------------------------------Tables----------------------------------------------

CREATE TABLE public.email_messages
(
    email_message_id serial,
    email_type_id integer NULL,
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

-------------------------------------------
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
---------------------------------------Tables----------------------------------------------