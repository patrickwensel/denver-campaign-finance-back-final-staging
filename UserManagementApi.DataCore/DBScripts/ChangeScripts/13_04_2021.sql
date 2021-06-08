----------------------------Functions-----------------------------------------------
CREATE OR REPLACE FUNCTION public.save_contactrolemappingtreasuree(
	_contactid integer,
	_filerid integer)
    RETURNS integer
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
DECLARE roleid integer;
DECLARE uid integer;
begin
SELECT id INTO roleid FROM public.role where role = 'Treasurer';
SELECT user_id INTO uid FROM public.user_account where contact_id = _contactid;
insert into public."contact_role_mapping" ("user_id", "contact_id", "filer_id", "role_type_id", "created_by", "created_at", "updated_by", "updated_on")
 values(uid, _contactid, _filerid, roleid, 'Denver', localtimestamp, 'Denver', localtimestamp);
  return (SELECT LASTVAL());
-- inserted fail retuns 0

end
$BODY$;

ALTER FUNCTION public.save_contactrolemappingtreasuree(integer, integer)
    OWNER TO devadmin;
    ------------------------------
    CREATE OR REPLACE FUNCTION public.save_contactrolemappinglobby(
	_contactid integer,
	_filerid integer)
    RETURNS integer
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
DECLARE roleid integer;
DECLARE uid integer;
begin
SELECT id INTO roleid FROM public.role where role = 'Primary Registering Lobbyist';
SELECT user_id INTO uid FROM public.user_account where contact_id = _contactid;
insert into public."contact_role_mapping" ("user_id", "contact_id", "filer_id", "role_type_id", "created_by", "created_at", "updated_by", "updated_on")
 values(uid, _contactid, _filerid, roleid, 'Denver', localtimestamp, 'Denver', localtimestamp);
  return (SELECT LASTVAL());
-- inserted fail retuns 0

end
$BODY$;

ALTER FUNCTION public.save_contactrolemappinglobby(integer, integer)
    OWNER TO devadmin;
-------------------------------
CREATE OR REPLACE FUNCTION public.save_contactrolemappingofficer(
	_userid integer,
	_contactid integer,
	_committeeid integer)
    RETURNS integer
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
DECLARE roleid integer;
DECLARE filid integer;
begin

SELECT id INTO roleid FROM public.role where role = 'Officer';
SELECT filer_id INTO filid FROM public.filer where entity_id = _committeeid and entity_type = 'C';

insert into public."contact_role_mapping" ("user_id", "contact_id", "filer_id", "role_type_id", "created_by", "created_at", "updated_by", "updated_on")
 values(_userid, _contactid, filid, roleid, 'Denver', localtimestamp, 'Denver', localtimestamp);
  return (SELECT LASTVAL());
-- inserted fail retuns 0

end
$BODY$;

ALTER FUNCTION public.save_contactrolemappingofficer(integer, integer, integer)
    OWNER TO devadmin;
----------------------------
CREATE OR REPLACE FUNCTION public.save_contactrolemapping(
	_userid integer,
	_contactid integer,
	_filerid integer)
    RETURNS integer
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
DECLARE roleid integer;
begin
SELECT id INTO roleid FROM public.role where role = 'Candidate';
insert into public."contact_role_mapping" ("user_id", "contact_id", "filer_id", "role_type_id", "created_by", "created_at", "updated_by", "updated_on")
 values(_userid, _contactid, _filerid, roleid, _userid, localtimestamp, _userid, localtimestamp);
  return (SELECT LASTVAL());
-- inserted fail retuns 0

end
$BODY$;

ALTER FUNCTION public.save_contactrolemapping(integer, integer, integer)
    OWNER TO devadmin;
    -----------------------------
    CREATE OR REPLACE FUNCTION public.save_lobbyist(
	_year character varying,
	_type character varying,
	_primarycontactid integer,
	_filercontactid integer,
	_lobbyistid integer)
    RETURNS integer
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
DECLARE id int = 0;
begin
if (_lobbyistid) > 0 then

  update public."lobbyist" set "year"=_year, "type"=_type, primary_contact_id=_primarycontactid,
filer_contact_id=_filercontactid,
created_by='Denver', updated_by='Denver',  updated_on=NOW()
 where "lobbysit_id" = _lobbyistid;
 return _lobbyistid;
 else
 insert into public."lobbyist" ("year", "type", "primary_contact_id", "filer_contact_id", "created_by", "created_at", "updated_by", "updated_on", "status_code")
 values(_year, _type, _primarycontactid, _filercontactid, 'Denver', localtimestamp, 'Denver', localtimestamp, 'Active');
  return (SELECT LASTVAL());
end if;

end
$BODY$;

ALTER FUNCTION public.save_lobbyist(character varying, character varying, integer, integer, integer)
    OWNER TO devadmin;
----------------------------------------
CREATE OR REPLACE FUNCTION public.save_lobbyistcontact(
	_contacttype character varying,
	_firstname character varying,
	_lastname character varying,
	_address1 character varying,
	_address2 character varying,
	_city character varying,
	_state character varying,
	_zip character varying,
	_phone character varying,
	_email character varying,
	_lobbyistid integer)
    RETURNS integer
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
DECLARE contactid integer;
begin
SELECT filer_contact_id INTO contactid FROM public.lobbyist where lobbysit_id = _lobbyistid;
if (_lobbyistid) > 0 then

  update public."contact" set contact_type=_contacttype, first_name=_firstname, last_name=_lastname,
address1=_address1, address2=_address2,  "city" = _city,
state_code=_state, zip=_zip, phone = _phone, email = _email,
created_by='Denver', updated_by='Denver',  updated_on=NOW()
 where "contact_id" = contactid;
 return contactid;
else
 insert into public."contact" ("contact_type", "first_name", "last_name", "address1", "address2", "city", "state_code", "zip" , "phone", "email", "created_by", "created_at", "updated_by", "updated_on", "status_code")
 values(_contacttype, _firstname, _lastname, _address1, _address2, _city, _state, _zip, _phone, _email, 'Denver', localtimestamp, 'Denver', localtimestamp, 'Active');
  return (SELECT LASTVAL());
end if;

end
$BODY$;

ALTER FUNCTION public.save_lobbyistcontact(character varying, character varying, character varying, 
								   character varying, character varying, character varying, 
								   character varying, character varying, character varying, 
								   character varying, integer)
    OWNER TO devadmin;

    ------------------------------------------------
    CREATE OR REPLACE FUNCTION public.save_committee(
	_name character varying,
	_committeetypeid integer,
	_officesoughtid integer,
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

ALTER FUNCTION public.save_committee(character varying, integer, integer, character varying, integer, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, integer)
    OWNER TO devadmin;
-------------------------------------------
CREATE OR REPLACE FUNCTION public.save_candidatecontact(
	_contacttype character varying,
	_firstname character varying,
	_lastname character varying,
	_filerid integer,
	_statuscode character varying,
	_committeeid integer)
    RETURNS integer
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
DECLARE contactid integer;
begin
SELECT candidate_contact_id INTO contactid FROM public.committee where committee_id = _committeeid;
if (_committeeid) > 0 then
 update public."contact" set "contact_type"=_contacttype, first_name=_firstname, last_name=_lastname,
filerid=_filerid,
created_by='Denver', updated_by='Denver',  updated_on=NOW()
 where "contact_id" = contactid;
 return contactid;
else
 insert into public."contact" ("contact_type", "first_name", "last_name", "filerid", "status_code", "created_by", "created_at", "updated_by", "updated_on")
 values(_contacttype, _firstname, _lastname, _filerid, _statuscode, 'Denver', localtimestamp, 'Denver', localtimestamp);
  return (SELECT LASTVAL());
end if;

end
$BODY$;

ALTER FUNCTION public.save_candidatecontact(character varying, character varying, character varying, integer, character varying, integer)
    OWNER TO devadmin;
------------------------------
CREATE OR REPLACE FUNCTION public.save_committeecontact(
	_contacttype character varying,
	_orgname character varying,
	_address1 character varying,
	_address2 character varying,
	_city character varying,
	_statecode character varying,
	_zip character varying,
	_filerid integer,
	_statuscode character varying,
	_committeeid integer)
    RETURNS integer
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
DECLARE contactid integer;
begin
SELECT committee_contact_id INTO contactid FROM public.committee where committee_id = _committeeid;
if (_committeeid) > 0 then
 update public."contact" set "contact_type"=_contacttype, org_name=_orgname, address1=_address1,
address2=_address2, city=_city, state_code=_statecode, zip=_zip, filerid=_filerid,
created_by='Denver', updated_by='Denver',  updated_on=NOW()
 where "contact_id" = contactid;
 return contactid;
else
 insert into public."contact" ("contact_type", "org_name", "address1", "address2", "city", "state_code", "zip", "filerid", "status_code", "created_by", "created_at", "updated_by", "updated_on")
 values(_contacttype, _orgname, _address1, _address2, _city, _statecode, _zip, _filerid, _statuscode, 'Denver', localtimestamp, 'Denver', localtimestamp);
  return (SELECT LASTVAL());
end if;

end
$BODY$;

ALTER FUNCTION public.save_committeecontact(character varying, character varying, character varying, character varying, character varying, character varying, character varying, integer, character varying, integer)
    OWNER TO devadmin;
------------------------------
CREATE OR REPLACE FUNCTION public.save_committeeothercontact(
	_contacttype character varying,
	_phone character varying,
	_email character varying,
	_filerid integer,
	_statuscode character varying,
	_committeeid integer)
    RETURNS integer
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
DECLARE contactid integer;
begin
SELECT other_contact_id INTO contactid FROM public.committee where committee_id = _committeeid;
if (_committeeid) > 0 then
 update public."contact" set "contact_type"=_contacttype, phone=_phone, email=_email,
filerid=_filerid,
created_by='Denver', updated_by='Denver',  updated_on=NOW()
 where "contact_id" = contactid;
 return contactid;
else
 insert into public."contact" ("contact_type", "phone", "email", "filerid", "status_code", "created_by", "created_at", "updated_by", "updated_on")
 values(_contacttype, _phone, _email, _filerid, _statuscode, 'Denver', localtimestamp, 'Denver', localtimestamp);
  return (SELECT LASTVAL());
end if;
end
$BODY$;

ALTER FUNCTION public.save_committeeothercontact(character varying, character varying, character varying, integer, character varying, integer)
    OWNER TO devadmin;
---------------------------------
CREATE OR REPLACE FUNCTION public.save_issuecommittee(
	_name character varying,
	_committeetypeid integer,
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

ALTER FUNCTION public.save_issuecommittee(character varying, integer, integer, integer, character varying, character varying, character varying, integer)
    OWNER TO devadmin;
--------------------------
CREATE OR REPLACE FUNCTION public.save_pacorsmalldonorcommittee(
	_committeetypeid integer,
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

ALTER FUNCTION public.save_pacorsmalldonorcommittee(integer, character varying, character varying, integer)
    OWNER TO devadmin;
---------------------------
CREATE OR REPLACE FUNCTION public.save_committee(
	_name character varying,
	_committeetypeid integer,
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

ALTER FUNCTION public.save_committee(character varying, integer, character varying, character varying, integer, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, integer)
    OWNER TO devadmin;
    -----------------------


    ----------------------------Functions-----------------------------------------------
    
	ALTER TABLE public.committee ALTER COLUMN office_sought_id TYPE  character varying(50)
    ALTER TABLE public.user_join_request ALTER COLUMN user_join_note TYPE  character varying(1000)
ALTER TABLE public.committee ALTER COLUMN typeid TYPE  character varying(500)