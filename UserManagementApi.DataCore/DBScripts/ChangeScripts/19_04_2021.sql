
﻿----------------------Functions----------------------------------
CREATE OR REPLACE FUNCTION public.get_committeebyid(
	_committeeid integer)
    RETURNS TABLE(committeeid integer, committeename character varying, officesought character varying, district character varying, electiondate date, candidatename text, status text) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
DECLARE contactid integer;
begin
SELECT candidate_contact_id INTO contactid FROM public.committee where committee_id = _committeeid;
return query
SELECT committee.committee_id, committee.name, offi."name", committee.district, 
election.election_date, concat(con.first_name ,' ', con.last_name) as candidate, upper(coalesce(committee.status_code, 'NEW')) as status_code
FROM public.committee committee 
LEFT JOIN public.type_lookups offi on committee.office_sought_id = offi.type_id and offi.lookup_type_code= 'OFF'and offi.status_code='ACTIVE'
LEFT JOIN public.election_cycle election on committee.election_cycle_id = election.election_cycle_id
INNER JOIN public.contact con on committee.candidate_contact_id = con.contact_id
WHERE committee.committee_id = _committeeid
ORDER BY committee.committee_id;
 end
$BODY$;

ALTER FUNCTION public.get_committeebyid(integer)
    OWNER TO devadmin;

---------------------

CREATE OR REPLACE FUNCTION public.get_electioncycledates()
    RETURNS TABLE(electioncycleid integer, electioncycletypeid character varying,electiondate date) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
begin
  return query
  SELECT ec.election_cycle_id,
  ec.election_type_id, 
  ec.election_date
  FROM public.election_cycle ec 
  	WHERE ec.status_code = 'ACTIVE';
 end
$BODY$;



    -------------------------

    CREATE OR REPLACE FUNCTION public.save_lobbyistcontact(
	_contacttype character varying,
	_orgname character varying,
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

  update public."contact" set contact_type=_contacttype, org_name=_orgname, first_name=_firstname, last_name=_lastname,
address1=_address1, address2=_address2,  "city" = _city,
state_code=_state, zip=_zip, phone = _phone, email = _email,
created_by='Denver', updated_by='Denver',  updated_on=NOW()
 where "contact_id" = contactid;
 return contactid;
else
 insert into public."contact" ("contact_type", "org_name", "first_name", "last_name", "address1", "address2", "city", "state_code", "zip" , "phone", "email", "created_by", "created_at", "updated_by", "updated_on", "status_code")
 values(_contacttype, _orgname, _firstname, _lastname, _address1, _address2, _city, _state, _zip, _phone, _email, 'Denver', localtimestamp, 'Denver', localtimestamp, 'Active');
  return (SELECT LASTVAL());
end if;

end
$BODY$;

ALTER FUNCTION public.save_lobbyistcontact(character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, integer)
    OWNER TO stgadmin;

    ----------------------------
    CREATE OR REPLACE FUNCTION public.get_committeecontactbyid(
	_committeeid integer)
    RETURNS TABLE(contactid integer, address1 character varying, address2 character varying, city character varying, 
				  state character varying, zip character varying, email character varying, phone character varying, 
				  altemail character varying, altphone character varying, campaignwebsite character varying) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
DECLARE contactid integer;
begin
SELECT committee_contact_id INTO contactid FROM public.committee where committee_id = _committeeid;
return query
SELECT con.contact_id, con.address1, con.address2, con.city, st."desc",
con.zip, con.email, con.phone, con.altemail, con.altphone, com.campaign_website
FROM public.contact con 
LEFT JOIN public.committee com on con.contact_id= com.committee_contact_id
LEFT JOIN public.states st on con.state_code= st.code
WHERE con.contact_id = contactid
ORDER BY con.contact_id;
 end
$BODY$;

ALTER FUNCTION public.get_committeecontactbyid(integer)
    OWNER TO devadmin;
    --------------------------------
    CREATE OR REPLACE FUNCTION public.save_committeeothercontact(
	_contacttype character varying,
	_phone character varying,
	_email character varying,
	_altphone character varying,
	_altemail character varying,
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
 update public."contact" set "contact_type"=_contacttype, phone=_phone, email=_email, altphone=_altphone, altemail=_altemail,
filerid=_filerid,
created_by='Denver', updated_by='Denver',  updated_on=NOW()
 where "contact_id" = contactid;
 return contactid;
else
 insert into public."contact" ("contact_type", "phone", "email", "altphone", "altemail", "filerid", "status_code", "created_by", "created_at", "updated_by", "updated_on")
 values(_contacttype, _phone, _email, _altphone, _altemail, _filerid, _statuscode, 'Denver', localtimestamp, 'Denver', localtimestamp);
  return (SELECT LASTVAL());
end if;
end
$BODY$;

ALTER FUNCTION public.save_committeeothercontact(character varying, character varying, character varying, integer, character varying, integer)
    OWNER TO devadmin;

    --------------------------
    CREATE OR REPLACE FUNCTION public.get_committeecontactbyid(
	_committeeid integer)
    RETURNS TABLE(contactid integer, address1 character varying, address2 character varying, city character varying, state character varying, zip character varying, email character varying, phone character varying, altemail character varying, altphone character varying, campaignwebsite character varying) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
DECLARE contactid integer;
begin
--SELECT committee_contact_id INTO contactid FROM public.committee where committee_id = _committeeid;
return query
SELECT con.contact_id, con.address1, con.address2, con.city, st."desc",
con.zip, con.email, con.phone, con.altemail, con.altphone, com.campaign_website
FROM public.contact con 
LEFT JOIN public.committee com on con.contact_id= com.other_contact_id
LEFT JOIN public.states st on con.state_code= st.code
WHERE com.committee_id = _committeeid;
--ORDER BY con.contact_id;
 end
$BODY$;

ALTER FUNCTION public.get_committeecontactbyid(integer)
    OWNER TO devadmin;
    --------------------------Functions-----------------------

    ALTER TABLE public.contact ADD altphone  character varying(500)
ALTER TABLE public.contact ADD altemail  character varying(500)
