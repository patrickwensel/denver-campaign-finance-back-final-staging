--------------------------------------Functions-------------------------------------------

-- FUNCTION: public.save_pacorsmalldonorcommittee(character varying, character varying, character varying, integer)

-- DROP FUNCTION public.save_pacorsmalldonorcommittee(character varying, character varying, character varying, integer);

CREATE OR REPLACE FUNCTION public.save_pacorsmalldonorcommittee(
	_committeename character varying,
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
 update public."committee" set "name"=_committeename, typeid=_committeetypeid, purpose=_purpose,
created_by='Denver', updated_by='Denver',  updated_on=NOW()
 where "committee_id" = _committeeid;
 return _committeeid;
else
 insert into public."committee" ("name", "typeid", "purpose", "registration_status", "created_by", "created_at", "updated_by", "updated_on")
 values(_committeename, _committeetypeid, _purpose, _registrationstatus, 'Denver', localtimestamp, 'Denver', localtimestamp);
  return (SELECT LASTVAL());
end if;
end
$BODY$;

ALTER FUNCTION public.save_pacorsmalldonorcommittee(character varying, character varying, character varying, integer)
    OWNER TO devadmin;
    ----------------------------
    CREATE OR REPLACE FUNCTION public.get_committeebyid(
	_committeeid integer)
    RETURNS TABLE(committeeid integer, committeename character varying, officesought character varying, district character varying, electiondate date, candidatename text, status character varying) 
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
election.election_date, concat(con.first_name ,' ', con.last_name) as candidate, committee.status_code
FROM public.committee committee 
LEFT JOIN public.type_lookups offi on committee.office_sought_id = offi.type_id
LEFT JOIN public.election_cycle election on committee.election_cycle_id = election.election_cycle_id
INNER JOIN public.contact con on committee.candidate_contact_id = con.contact_id
WHERE committee.committee_id = _committeeid
ORDER BY committee.committee_id;
 end
$BODY$;

ALTER FUNCTION public.get_committeebyid(integer)
    OWNER TO qaadmin;
------------------------
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
								 "updated_by", "updated_on", "status_code")
 values(_name, _committeetypeid, _officesoughtid, _district, _electioncycleid, _committeewebsite, _bankname, _address1, _address2, _city, _statecode, _zip, _registrationstatus, 'Denver', localtimestamp, 'Denver', localtimestamp, 'NEW');
  return (SELECT LASTVAL());
end if;

end
$BODY$;

ALTER FUNCTION public.save_committee(character varying, character varying, character varying, character varying, integer, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, integer)
    OWNER TO qaadmin;
-------------------------
CREATE OR REPLACE FUNCTION public.get_rolesandtypes(
	_userid integer)
    RETURNS TABLE(roleid integer, role character varying, entityid integer, entitytype character varying, entityname character varying) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
begin
  return query
  select  
		r.id,
		r.role,
		f.entity_id,
		f.entity_type,
		CASE 
		WHEN (f.entity_id = cm.committee_id AND f.entity_type = 'C') THEN cm.name 
		WHEN (f.entity_id = lb.lobbysit_id AND f.entity_type = 'L') THEN concat(c.first_name,' ',c.last_name) END AS usertypename
		from public.contact c 
LEFT JOIN public.user_account ua ON c.contact_id = ua.contact_id
LEFT JOIN public.contact_role_mapping crm ON c.contact_id = crm.contact_id
LEFT JOIN public.role r ON crm.role_type_id = r.id 
LEFT JOIN public.filer f ON crm.filer_id = f.filer_id
LEFT JOIN public.committee cm ON cm.committee_id = f.entity_id 
LEFT JOIN public.lobbyist lb ON lb.lobbysit_id = f.entity_id 
WHERE c.contact_id = _userid;
	
 end
$BODY$;

ALTER FUNCTION public.get_rolesandtypes(integer)
    OWNER TO devadmin;
-----------------------
CREATE OR REPLACE FUNCTION public.save_pacorsmalldonorcommittee(
	_committeename character varying,
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
 update public."committee" set "name"=_committeename, typeid=_committeetypeid, purpose=_purpose,
created_by='Denver', updated_by='Denver',  updated_on=NOW()
 where "committee_id" = _committeeid;
 return _committeeid;
else
 insert into public."committee" ("name", "typeid", "purpose", "registration_status", "created_by", "created_at", "updated_by", "updated_on")
 values(_committeename, _committeetypeid, _purpose, _registrationstatus, 'Denver', localtimestamp, 'Denver', localtimestamp);
  return (SELECT LASTVAL());
end if;
end
$BODY$;

ALTER FUNCTION public.save_pacorsmalldonorcommittee(character varying, character varying, character varying, integer)
    OWNER TO qaadmin;


    ----------------------------------Functions--------------------------------------