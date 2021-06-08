
﻿----------------------------------------Functions----------------------------------------------
CREATE OR REPLACE FUNCTION public.update_committeeorlobbyiststatus(
	_id integer,
	_status boolean,
	_notes character varying,
	_entitytype character varying)
    RETURNS integer
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
begin
if (_entitytype) = 'C' then

update public.committee set status_code = CASE
           WHEN _status THEN 'ACTIVE' ELSE 'DENIED' END, admin_notes = _notes where committee_id = _id;
return _id;
elseif (_entitytype) = 'L' then
update public.lobbyist set status_code = CASE
           WHEN _status THEN 'ACTIVE' ELSE 'DENIED' END, admin_notes = _notes where lobbysit_id = _id;
return _id;
end if;
end
$BODY$;

ALTER FUNCTION public.update_committeeorlobbyiststatus(integer, boolean, character varying, character varying)
    OWNER TO devadmin;


	--------------------------------------------
	CREATE OR REPLACE FUNCTION public.save_contactrolemappingie(
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
SELECT id INTO roleid FROM public.role where role = 'Other User';
SELECT user_id INTO uid FROM public.user_account where contact_id = _contactid;
insert into public."contact_role_mapping" ("user_id", "contact_id", "filer_id", "role_type_id", "created_by", "created_at", "updated_by", "updated_on")
 values(uid, _contactid, _filerid, roleid, 'Denver', localtimestamp, 'Denver', localtimestamp);
  return (SELECT LASTVAL());
-- inserted fail retuns 0

end
$BODY$;

ALTER FUNCTION public.save_contactrolemappingie(integer, integer)
    OWNER TO devadmin;
	----------------------------
	CREATE OR REPLACE FUNCTION public.save_userjoinrequestie(
	_requesttype character varying,
	_useremail character varying,
	_usercontactid integer,
	_invitercontactid integer,
	_emailmessageid integer,
	_userjoinnote character varying,
	_ieid integer)
    RETURNS integer
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
DECLARE filid integer;
begin

SELECT filer_id INTO filid FROM public.filer where entity_id = _ieid and entity_type = 'IE';
 insert into public."user_join_request" ("request_type", "filer_id", "user_email", "user_contact_id", 
										 "inviter_contact_id", "email_msg_id", "user_join_note", 
										 "created_by", "created_at", "updated_by", "updated_on")
 values(_requesttype, filid, _useremail, _usercontactid, _invitercontactid, _emailmessageid, _userjoinnote, 'Denver', localtimestamp, 'Denver', localtimestamp);
  return (SELECT LASTVAL());
-- inserted fail retuns 0

end
$BODY$;

ALTER FUNCTION public.save_userjoinrequestie(character varying, character varying, integer, integer, integer, character varying, integer)
    OWNER TO devadmin;
--------------------------------
CREATE OR REPLACE FUNCTION public.get_independentspender(
	_ieid integer)
    RETURNS TABLE(contactid integer, employeetype character varying, employeename text) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
DECLARE roleid int = 0;
DECLARE fillerId int = 0;
begin
SELECT id into roleid FROM public.role WHERE role = 'Other User';
SELECT filer_id into fillerId 
FROM public.filer 
WHERE entity_id = _ieid
AND entity_type = 'IE';
return query
 
SELECT c.contact_id,
rl.role as entity_type,
concat(c.first_name, ' ', c.last_name)  as name
FROM contact_role_mapping crm
INNER JOIN contact c  ON c.contact_id = crm.contact_id
INNER JOIN role rl on  rl.id = crm.role_type_id
WHERE crm.role_type_id = roleid
AND crm.filer_id = fillerId 
AND c.status_code = 'ACTIVE';
		

end
$BODY$;

ALTER FUNCTION public.get_independentspender(integer)
    OWNER TO devadmin;

	----------------------------------
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
 values(_name, _committeetypeid, _officesoughtid, _district, _electioncycleid, _committeewebsite, _bankname, _address1, _address2, _city, _statecode, _zip, _registrationstatus, 'Denver', localtimestamp, 'Denver', localtimestamp, 'ACTIVE');
  return (SELECT LASTVAL());
end if;

end
$BODY$;

-------------------------
CREATE OR REPLACE FUNCTION public.get_committeebyid(
	_committeeid integer)
    RETURNS TABLE(committeeid integer, committeename character varying, officesought character varying, 
				  district character varying, electiondate date, candidatename text, status character varying) 
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
INNER JOIN public.election_cycle election on committee.election_cycle_id = election.election_cycle_id
INNER JOIN public.contact con on committee.candidate_contact_id = con.contact_id
WHERE committee.committee_id = _committeeid
ORDER BY committee.committee_id;
 end
$BODY$;

ALTER FUNCTION public.get_committeebyid(integer)
    OWNER TO devadmin;


    ----------------------------------Functions-------------------------

﻿------------------------------------------Functions----------------------------------------
DROP FUNCTION public.get_managefilers();

CREATE OR REPLACE FUNCTION public.get_managefilers(
	)
    RETURNS TABLE(filerid integer, filertype text, comtype character varying, filername character varying, primaryuser text, status character varying, lfdate text, createddate date, electiondate text, officetype text) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
begin
  return query
  SELECT com.committee_id as filerID, 
  		'C' as filerType,
		tl.type_id as comType,
	   com.name as filerName,
	   CASE WHEN CONCAT(tc.middle_name, 'ZZZ') = 'ZZZ' THEN 
			CONCAT(tc.first_name, ' ', tc.last_name)
		ELSE 
			CONCAT(tc.first_name, ' ', tc.middle_name, ' ', tc.last_name)
		END  as primary_user,
		com.status_code as status,
		CASE WHEN tl.name = 'Candidate Committee' OR tl.name = 'Issue Committee'  THEN 
			text(fp.due_date)
		ELSE
		'' END as lfDate,
		com.created_at as cDate,
		text(ec.election_date) as eDate,
		text(tlo.type_id) as officeId
FROM public.committee com
	INNER JOIN public.contact tc ON com.treasurer_contact_id = tc.contact_id
	LEFT JOIN public.type_lookups tl ON tl.type_id = com.typeid
		and tl.lookup_type_code = 'COM'
	LEFT JOIN public.election_cycle ec ON com.election_cycle_id = ec.election_cycle_id
	LEFT JOIN public.filing_period fp ON ec.election_cycle_id = fp.election_cycle_id
	LEFT JOIN public.type_lookups tlo ON tlo.type_id = com.office_sought_id
		and tl.lookup_type_code = 'OFF'
WHERE com.election_cycle_id = fp.election_cycle_id
UNION	
SELECT l.lobbysit_id as filerId, 
	   'L' as filerType,
	   '' as comType,
		CASE WHEN l.type = 'LOB-I' THEN 
			CASE WHEN CONCAT(pc.middle_name, 'ZZZ') = 'ZZZ' THEN 
				CONCAT(pc.first_name, ' ', pc.last_name)
			ELSE 
				CONCAT(pc.first_name, ' ', pc.middle_name, ' ', pc.last_name)
			END
		ELSE
			pc.org_name
		END as filerName,
		CASE WHEN CONCAT(pc.middle_name, 'ZZZ') = 'ZZZ' THEN 
			CONCAT(pc.first_name, ' ', pc.last_name)
		ELSE 
			CONCAT(pc.first_name, ' ', pc.middle_name, ' ', pc.last_name)
		END as primary_user,
		l.status_code as status,
		'' as lfDate,
		l.created_at as cDate,
		'' as eDate,
		'' as officeId
FROM public.lobbyist l
	LEFT JOIN public.contact pc ON l.primary_contact_id = pc.contact_id
	--LEFT JOIN public.contact fc ON l.filer_contact_id = fc.contact_id
UNION
SELECT c.contact_id as filerId,
		f.entity_type as filerType,
		'' as comType,
		CASE WHEN CONCAT(c.middle_name, 'ZZZ') = 'ZZZ' THEN 
			CONCAT(c.first_name, ' ', c.last_name)
		ELSE 
			CONCAT(c.first_name, ' ', c.middle_name, ' ', c.last_name)
		END as filerName,
		CASE WHEN CONCAT(pc.middle_name, 'ZZZ') = 'ZZZ' THEN 
			CONCAT(pc.first_name, ' ', pc.last_name)
		ELSE 
			CONCAT(pc.first_name, ' ', pc.middle_name, ' ', pc.last_name)
		END as primary_user,
		c.status_code as status,
		'' as lfDate,
		c.created_at as cDate,
		'' as eDate,
		'' as officeId
FROM public.contact c
	INNER JOIN public.contact_role_mapping crm ON c.contact_id = crm.contact_id
	INNER JOIN public.filer f ON crm.filer_id = f.filer_id
		AND f.entity_type IN ('IE', 'CO')
	LEFT JOIN public.user_account ua ON crm.user_id = ua.user_id
	INNER JOIN public.contact pc ON ua.contact_id = pc.contact_id;
	
 end
$BODY$;

ALTER FUNCTION public.get_managefilers()
    OWNER TO devadmin;


DROP FUNCTION public.get_managefiler(character varying, character varying, character varying, date, date, character varying, character varying, date, character varying);

CREATE OR REPLACE FUNCTION public.get_managefiler(
	fname character varying,
	ftype character varying,
	fstatus character varying,
	lsstartdate date,
	lsenddate date,
	ctype character varying,
	otype character varying,
	edate date,
	publicfundstatus character varying)
    RETURNS TABLE(filerid integer, filername text, primaryuser text, status text, lastfillingdate text, createddate text, electiondate text, filertype text) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
DECLARE sqlQuery character varying;
DECLARE whereClause character varying;
DECLARE arrValue text[];
DECLARE whereClauseValue character varying;
DECLARE val character varying;
DECLARE isCommaPresent boolean;
DECLARE conditionText character varying;
DECLARE fsDate date;
DECLARE feDate date;
DECLARE eleDate date;
DECLARE nYear double precision;
begin
	
	SELECT EXTRACT(YEAR FROM lsstartdate) INTO nYear; 
	if nYear = 1 OR nYear = 9999 then
		fsDate := null;
	else
		fsDate := lsstartdate;
	end if;
	
	SELECT EXTRACT(YEAR FROM lsenddate) INTO nYear; 
	if nYear = 1 OR nYear = 9999 then
		feDate := null;
	else
		feDate := lsenddate;
	end if;
	
	SELECT EXTRACT(YEAR FROM edate) INTO nYear; 
	if nYear = 1 OR nYear = 9999 then
		eleDate := null;
	else
		eleDate := edate;
	end if;
	
	  whereClause := '';
	  sqlQuery := 'SELECT mf.filerid,
					text(mf.filername) as fname,
					text(mf.primaryuser) as puser,
					text(mf.status) as status,
					text(mf.lfdate) as lfdate,
					text(mf.createddate) as cdate,
					text(mf.electiondate) as edate,
					text(mf.filerType) as ftype
			FROM public.get_managefilers() mf ';

		
		--INSERT INTO public.debugdetails(param1, param2) values(sqlQuery, 'step1');
		-- Filer Name
		if CONCAT(fname, 'ZZZ') != 'ZZZ' then
			whereClause := ' WHERE LOWER(mf.filername) LIKE ' || '''%' || LOWER(trim(fname)) || '%''';
		end if;
		
		--INSERT INTO public.debugdetails(param1, param2) values(whereClause, 'step2');
		
		-- Filter Type
		if CONCAT(ftype, 'ZZZ') != 'ZZZ' then
			whereClauseValue := '';
			SELECT INTO arrValue regexp_split_to_array(ftype,',');
			FOREACH val IN array arrValue LOOP
				if CONCAT(whereClauseValue, 'ZZZ') = 'ZZZ' then
					whereClauseValue := '''' || trim(val) || '';
				else
					whereClauseValue := whereClauseValue || ''',''' || trim(val) || '';
				end if;
			END LOOP;
		
			if CONCAT(whereClauseValue, 'ZZZ') != 'ZZZ' then
				whereClauseValue = whereClauseValue || '''';
				if CONCAT(whereClause, 'ZZZ') != 'ZZZ' then
					whereClause := whereClause || ' AND ';
				else
					whereClause := ' WHERE ';
				end if;
				whereClause := whereClause || ' mf.filerType IN (' || whereClauseValue || ')';
			end if;
		end if;
		
		--INSERT INTO public.debugdetails(param1, param2) values(whereClause, 'step3');
		-- Last Filling Date
		if CONCAT(fsDate, 'ZZZ') != 'ZZZ' AND CONCAT(feDate, 'ZZZ') != 'ZZZ' then
			if CONCAT(whereClause, 'ZZZ') != 'ZZZ' then
				whereClause := whereClause || ' AND ';
			else
				whereClause := ' WHERE ';
			end if;
			whereClause := whereClause || ' CAST(mf.lfdate as TEXT) >= ' || '''' || lsStartDate || '''' || ' AND mf.lfdate <= ' || '''' || lsEndDate || ''''; 
		end if;
		
		-- Filer Status
		if CONCAT(fstatus, 'ZZZ') != 'ZZZ' then
			whereClauseValue := '';
			SELECT INTO arrValue regexp_split_to_array(fstatus,',');
			FOREACH val IN array arrValue LOOP
				if CONCAT(whereClauseValue, 'ZZZ') = 'ZZZ' then
					whereClauseValue := '''' || trim(val) || '';
				else
					whereClauseValue := whereClauseValue || ''',''' || trim(val) || '';
				end if;
			END LOOP;
		
			if CONCAT(whereClauseValue, 'ZZZ') != 'ZZZ' then
				whereClauseValue = whereClauseValue || '''';
				if CONCAT(whereClause, 'ZZZ') != 'ZZZ' then
					whereClause := whereClause || ' AND ';
				else
					whereClause := ' WHERE ';
				end if;
				whereClause := whereClause || ' mf.status IN (' || whereClauseValue || ')';
			end if;
		end if;
		
		-- Committee Type
		if CONCAT(ctype, 'ZZZ') != 'ZZZ' then
			whereClauseValue := '';
			SELECT INTO arrValue regexp_split_to_array(ctype,',');
			FOREACH val IN array arrValue LOOP
				if CONCAT(whereClauseValue, 'ZZZ') = 'ZZZ' then
					whereClauseValue := '''' || trim(val) || '';
				else
					whereClauseValue := whereClauseValue || ''',''' || trim(val) || '';
				end if;
			END LOOP;
		
			if CONCAT(whereClauseValue, 'ZZZ') != 'ZZZ' then
				whereClauseValue = whereClauseValue || '''';
				if CONCAT(whereClause, 'ZZZ') != 'ZZZ' then
					whereClause := whereClause || ' AND ';
				else
					whereClause := ' WHERE ';
				end if;
				whereClause := whereClause || ' mf.comtype IN (' || whereClauseValue || ')';
			end if;
		end if;
		
		-- Officer Type
		if CONCAT(otype, 'ZZZ') != 'ZZZ' then
			whereClauseValue := '';
			SELECT INTO arrValue regexp_split_to_array(otype,',');
			FOREACH val IN array arrValue LOOP
				if CONCAT(whereClauseValue, 'ZZZ') = 'ZZZ' then
					whereClauseValue := '''' || trim(val) || '';
				else
					whereClauseValue := whereClauseValue || ''',''' || trim(val) || '';
				end if;
			END LOOP;
		
			if CONCAT(whereClauseValue, 'ZZZ') != 'ZZZ' then
				whereClauseValue = whereClauseValue || '''';
				if CONCAT(whereClause, 'ZZZ') != 'ZZZ' then
					whereClause := whereClause || ' AND ';
				else
					whereClause := ' WHERE ';
				end if;
				whereClause := whereClause || ' mf.officetype IN (' || whereClauseValue || ')';
			end if;
		end if;
		
		-- Election Date
		if CONCAT(eleDate, 'ZZZ') != 'ZZZ' then
			whereClause := ' WHERE mf.electiondate = '''  || eleDate || '''';
		end if;
		
		--INSERT INTO public.debugdetails(param1) values(whereClause);
		sqlQuery := sqlQuery || whereClause;
		
		--INSERT INTO public.debugdetails(param1, param2) values(sqlQuery, 'Final');
		return query execute sqlQuery;
 end
$BODY$;

ALTER FUNCTION public.get_managefiler(character varying, character varying, character varying, date, date, character varying, character varying, date, character varying)
    OWNER TO devadmin;

    ----------------------------------------Functions------------------------------------

