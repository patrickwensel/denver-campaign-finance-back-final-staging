CREATE OR REPLACE FUNCTION public.save_userjoinrequestlob(
	_requesttype character varying,
	_useremail character varying,
	_usercontactid integer,
	_invitercontactid integer,
	_emailmessageid integer,
	_userjoinnote character varying,
	_lobbyistid integer)
    RETURNS integer
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
DECLARE filid integer;
begin

SELECT filer_id INTO filid FROM public.filer where entity_id = _lobbyistid and entity_type = 'L';
 insert into public."user_join_request" ("request_type", "filer_id", "user_email", "user_contact_id", 
										 "inviter_contact_id", "email_msg_id", "user_join_note", 
										 "created_by", "created_at", "updated_by", "updated_on")
 values(_requesttype, filid, _useremail, _usercontactid, _invitercontactid, _emailmessageid, _userjoinnote, 'Denver', localtimestamp, 'Denver', localtimestamp);
  return (SELECT LASTVAL());
-- inserted fail retuns 0

end
$BODY$;

ALTER FUNCTION public.save_userjoinrequestlob(character varying, character varying, integer, integer, integer, character varying, integer)
    OWNER TO devadmin;
