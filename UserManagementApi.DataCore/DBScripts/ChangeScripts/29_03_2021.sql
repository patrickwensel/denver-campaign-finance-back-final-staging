---------------------------------------Tables------------------------------------------------
CREATE TABLE public.filer
(
    filer_id serial,
    entity_type character varying(150) NULL,
	entity_id integer,
    categoryid integer NULL,
    filer_status character varying(10) NULL,
	status_code character varying(10) NULL,
	created_by character varying(100) NULL,
	created_at date NULL,
	updated_by character varying(100) NULL,
	updated_on date NULL,
    CONSTRAINT filer_pkey PRIMARY KEY (filer_id)
)
----------------------------------------------------------
CREATE TABLE public.committee
(
    Committee_id serial,
    name character varying(500) NOT NULL,
    typeid integer NULL,
	committee_contact_id integer NULL,
	other_contact_id integer NULL,
	treasurer_contact_id integer NULL,
	candidate_contact_id integer NULL,
	office_sought_id integer NULL,
    district character varying(150) NULL,
	election_cycle_id integer NULL,
	ballot_issue_id integer NULL,
	ballot_issue_notes character varying(150) NULL,
    position character varying(50) NULL,
    purpose character varying(1000) NULL,
    campaign_website character varying(200) NULL,
	bank_name character varying(150) NULL,
	bank_address1 character varying(200) NULL,
	bank_address2 character varying(200) NULL,
	bank_city character varying(150) NULL,
	bank_state_code character varying(2) NULL,
    bank_zip character varying(10) NULL,
	registration_status character varying(10) NULL,
    admin_notes character varying(500) NULL,
	status_code character varying(10) NULL,
	created_by character varying(100) NULL,
	created_at date NULL,
	updated_by character varying(100) NULL,
	updated_on date NULL,
    CONSTRAINT committee_pkey PRIMARY KEY (committee_id)
)
---------------------------------------Tables------------------------------------------------

---------------------------------------Functions---------------------------------------------
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
	_registrationstatus character varying)
    RETURNS integer
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
DECLARE id int = 0;
begin
 insert into public."committee" ("name", "typeid", "office_sought_id", "district", "election_cycle_id", "campaign_website", "bank_name", "bank_address1" , "bank_address2", "bank_city", "bank_state_code", "bank_zip", "registration_status", "created_by", "created_at", "updated_by", "updated_on")
 values(_name, _committeetypeid, _officesoughtid, _district, _electioncycleid, _committeewebsite, _bankname, _address1, _address2, _city, _statecode, _zip, _registrationstatus, 'Denver', localtimestamp, 'Denver', localtimestamp);
  return (SELECT LASTVAL());
-- inserted fail retuns 0

end
$BODY$;

ALTER FUNCTION public.save_committee(character varying, integer,  integer, character varying, integer, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying)
    OWNER TO devadmin;
-----------------------------------
CREATE OR REPLACE FUNCTION public.save_filer(
	_entitytype character varying,
	_entityid integer,
	_categoryid integer,
	_filerstatus character varying)
    RETURNS integer
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
DECLARE id int = 0;
begin
 insert into public."filer" ("entity_type", "entity_id", "categoryid", "filer_status", "created_by", "created_at", "updated_by", "updated_on")
 values(_entitytype, _entityid, _categoryid, _filerstatus, 'Denver', localtimestamp, 'Denver', localtimestamp);
  return (SELECT LASTVAL());
-- inserted fail retuns 0

end
$BODY$;

ALTER FUNCTION public.save_filer(character varying, integer,  integer, character varying)
    OWNER TO devadmin;
--------------------------------------------------
CREATE OR REPLACE FUNCTION public.save_candidatecontact(
	_contacttype character varying,
	_firstname character varying,
	_lastname character varying,
	_filerid integer)
    RETURNS integer
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
DECLARE id int = 0;
begin
 insert into public."contact" ("contact_type", "first_name", "last_name", "filerid", "created_by", "created_at", "updated_by", "updated_on")
 values(_contacttype, _firstname, _lastname, _filerid, 'Denver', localtimestamp, 'Denver', localtimestamp);
  return (SELECT LASTVAL());
-- inserted fail retuns 0

end
$BODY$;

ALTER FUNCTION public.save_candidatecontact(character varying, character varying, character varying, integer)
    OWNER TO devadmin;
---------------------------------------
CREATE OR REPLACE FUNCTION public.save_committeecontact(
	_contacttype character varying,
	_orgname character varying,
	_address1 character varying,
	_address2 character varying,
	_city character varying,
	_statecode character varying,
	_zip character varying,
	_filerid integer)
    RETURNS integer
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
DECLARE id int = 0;
begin
 insert into public."contact" ("contact_type", "org_name", "address1", "address2", "city", "state_code", "zip", "filerid", "created_by", "created_at", "updated_by", "updated_on")
 values(_contacttype, _orgname, _address1, _address2, _city, _statecode, _zip, _filerid, 'Denver', localtimestamp, 'Denver', localtimestamp);
  return (SELECT LASTVAL());
-- inserted fail retuns 0

end
$BODY$;

ALTER FUNCTION public.save_committeecontact(character varying, character varying, character varying, character varying, character varying, character varying, character varying, integer)
    OWNER TO devadmin;
--------------------------------------------
CREATE OR REPLACE FUNCTION public.save_committeeothercontact(
	_contacttype character varying,
	_phone character varying,
	_email character varying,
	_filerid integer)
    RETURNS integer
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
DECLARE id int = 0;
begin
 insert into public."contact" ("contact_type", "phone", "email", "filerid", "created_by", "created_at", "updated_by", "updated_on")
 values(_contacttype, _phone, _email, _filerid, 'Denver', localtimestamp, 'Denver', localtimestamp);
  return (SELECT LASTVAL());
-- inserted fail retuns 0

end
$BODY$;

ALTER FUNCTION public.save_committeeothercontact(character varying, character varying, character varying, integer)
    OWNER TO devadmin;
-------------------------------------------
CREATE OR REPLACE FUNCTION public.update_committecontact(
	_committeecontactid integer,
	_candidatecontactid integer,
	_contactid integer,
	_committeeothercontactid integer,
	_committeeid integer,
	_filerid integer)
    RETURNS integer
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
begin
update public."committee" set committee_contact_id=_committeecontactid, other_contact_id=_committeeothercontactid, 
treasurer_contact_id=_contactid, candidate_contact_id=_candidatecontactid,  created_by='Denver', updated_by='Denver',  updated_on=NOW()
 where "committee_id" = _committeeid;
 
 update public."contact" set filerid = _filerid where "contact_id" = _contactid;
 
  return _committeeid;
-- inserted fail retuns 0

end
$BODY$;

ALTER FUNCTION public.update_committecontact(integer, integer, integer, integer, integer, integer)
    OWNER TO devadmin;

    -------------------------------------------------

CREATE OR REPLACE FUNCTION public.save_officers(
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
	_desc character varying,
	_filerid integer)
    RETURNS integer
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
DECLARE id int = 0;
begin
 insert into public."contact" ("contact_type", "first_name", "last_name", "address1", "address2", "city", "state_code", "zip" , "phone", "email", "description", "filerid", "created_by", "created_at", "updated_by", "updated_on")
 values(_contacttype, _firstname, _lastname, _address1, _address2, _city, _state, _zip, _phone, _email, _desc, _filerid, 'Denver', localtimestamp, 'Denver', localtimestamp);
  return (SELECT LASTVAL());
-- inserted fail retuns 0

end
$BODY$;

ALTER FUNCTION public.save_officers(character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, integer)
    OWNER TO devadmin;

---------------------------------------Functions---------------------------------------------