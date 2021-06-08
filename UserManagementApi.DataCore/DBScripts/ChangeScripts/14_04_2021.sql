---------------------------------------Functions-------------------------------------------
CREATE OR REPLACE FUNCTION public.save_userjoinrequest(
	_requesttype character varying,
	_useremail character varying,
	_usercontactid integer,
	_invitercontactid integer,
	_emailmessageid integer,
	_userjoinnote character varying,
	_committeeid integer)
    RETURNS integer
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
DECLARE filid integer;
begin

SELECT filer_id INTO filid FROM public.filer where entity_id = _committeeid and entity_type = 'C';
 insert into public."user_join_request" ("request_type", "filer_id", "user_email", "user_contact_id", "inviter_contact_id", "email_msg_id", "user_join_note", "created_by", "created_at", "updated_by", "updated_on")
 values(_requesttype, filid, _useremail, _usercontactid, _invitercontactid, _emailmessageid, _userjoinnote, 'Denver', localtimestamp, 'Denver', localtimestamp);
  return (SELECT LASTVAL());
-- inserted fail retuns 0

end
$BODY$;

ALTER FUNCTION public.save_userjoinrequest(character varying, character varying, integer, integer, integer, character varying, integer)
    OWNER TO devadmin;

    ----------------------------------
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
--------------------------------
CREATE OR REPLACE FUNCTION public.save_committee(
	_name character varying,
	_committeetypeid character varying,
	_officesoughtid character varying,
	_district character varying,
	_electioncycleid integer,
	_committeewebsite character varying,
	_bankname character varying,
	_address1 character varying,
	_address2 character varying,
	_city character varying,
	_statecode character varying,
	_zip character varying,
	_registrationstatus character varying,
	_committeeid integer)
    RETURNS integer
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
DECLARE id int = 0;
begin
if (_committeeid) > 0 then
 update public."committee" set "name"=_name, typeid=_committeetypeid, office_sought_id=_officesoughtid,
district=_district, election_cycle_id=_electioncycleid,  "campaign_website" = _committeewebsite,
bank_name=_bankname, bank_address1=_address1, bank_address2=_address2, bank_city = _city, bank_state_code = _statecode,bank_zip =_zip,
created_by='Denver', updated_by='Denver',  updated_on=NOW()
 where "committee_id" = _committeeid;
 return _committeeid;
else
 insert into public."committee" ("name", "typeid", "office_sought_id", "district", "election_cycle_id", 
								 "campaign_website", "bank_name", "bank_address1" , "bank_address2", "bank_city", 
								 "bank_state_code", "bank_zip", "registration_status", "created_by", "created_at", 
								 "updated_by", "updated_on")
 values(_name, _committeetypeid, _officesoughtid, _district, _electioncycleid, _committeewebsite, _bankname, _address1, _address2, _city, _statecode, _zip, _registrationstatus, 'Denver', localtimestamp, 'Denver', localtimestamp);
  return (SELECT LASTVAL());
end if;

end
$BODY$;

ALTER FUNCTION public.save_committee(character varying, character varying, character varying, character varying, integer, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, integer)
    OWNER TO devadmin;
-------------------------------
CREATE OR REPLACE FUNCTION public.save_issuecommittee(
	_name character varying,
	_committeetypeid character varying,
	_ballotissueid integer,
	_electioncycleid integer,
	_position character varying,
	_purpose character varying,
	_registrationstatus character varying,
	_committeeid integer)
    RETURNS integer
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
DECLARE id int = 0;
begin
if (_committeeid) > 0 then
 update public."committee" set "name"=_name, typeid=_committeetypeid, ballot_issue_id=_ballotissueid, 
 election_cycle_id=_electioncycleid,
"position"=_position, purpose=_purpose,
created_by='Denver', updated_by='Denver',  updated_on=NOW()
 where "committee_id" = _committeeid;
 return _committeeid;
else
 insert into public."committee" ("name", "typeid", "ballot_issue_id", "election_cycle_id", "position", "purpose", "registration_status", "created_by", "created_at", "updated_by", "updated_on")
 values(_name, _committeetypeid, _ballotissueid, _electioncycleid, _position, _purpose, _registrationstatus, 'Denver', localtimestamp, 'Denver', localtimestamp);
  IF EXISTS (SELECT ballot_issue_id FROM public.ballot_issue_sm where ballot_issue_id=_ballotissueid) THEN
  		 update  public.ballot_issue_sm set cmtflag =1 where ballot_issue_id=_ballotissueid;
 	 	END IF;
  return (SELECT LASTVAL());
end if;

end
$BODY$;

ALTER FUNCTION public.save_issuecommittee(character varying, character varying, integer, integer, character varying, character varying, character varying, integer)
    OWNER TO devadmin;
-----------------------
CREATE OR REPLACE FUNCTION public.save_pacorsmalldonorcommittee(
	_committeetypeid character varying,
	_purpose character varying,
	_registrationstatus character varying,
	_committeeid integer)
    RETURNS integer
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
DECLARE id int = 0;
begin
if (_committeeid) > 0 then
 update public."committee" set  typeid=_committeetypeid, purpose=_purpose,
created_by='Denver', updated_by='Denver',  updated_on=NOW()
 where "committee_id" = _committeeid;
 return _committeeid;
else
 insert into public."committee" ("typeid", "purpose", "registration_status", "created_by", "created_at", "updated_by", "updated_on")
 values(_committeetypeid, _purpose, _registrationstatus, 'Denver', localtimestamp, 'Denver', localtimestamp);
  return (SELECT LASTVAL());
end if;
end
$BODY$;

ALTER FUNCTION public.save_pacorsmalldonorcommittee(character varying, character varying, character varying, integer)
    OWNER TO devadmin;

---------------------------------------Functions-------------------------------------------