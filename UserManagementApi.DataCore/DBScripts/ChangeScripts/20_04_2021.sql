------------------------------------------Functions----------------------------------------
DROP FUNCTION public.get_committeecontactbyid(integer);

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
LEFT JOIN public.committee com on con.contact_id= com.committee_contact_id
LEFT JOIN public.states st on con.state_code= st.code
WHERE com.committee_id = _committeeid;
--ORDER BY con.contact_id;
 end
$BODY$;

DROP FUNCTION public.get_electioncycles();

CREATE OR REPLACE FUNCTION public.get_electioncycles(
	)
    RETURNS TABLE(electioncycleid integer, electioncycle character varying, electioncycletypeid character varying, electioncycletype character varying, startdate date, enddate date, electiondate date, description character varying, district character varying, iestartdate date, ieenddate date, officeids text, offices text, statusdesc character varying) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
begin

	UPDATE public.election_cycle 
		SET status = 'COM'
	WHERE end_date < CURRENT_DATE
		AND status = 'ACT';
	
  return query
	SELECT ec.election_cycle_id, 
	   ec.name, 
	   ec.election_type_id, 
	   tl.name as etName,
	   ec.start_date, 
	   ec.end_date, 
	   ec.election_date,
	   ec."desc", 
	   ec.district, 
	   ec.ie_start_date, 
	   ec.ie_end_date,
	   string_agg(ecom.office_id::text,', ') officeids,
		string_agg(tlo.name::text,', ') offices,
		tks.name as statusDesc
	FROM public.election_cycle ec 
		LEFT JOIN public.type_lookups tl ON ec.election_type_id = tl.type_id 
			AND tl.lookup_type_code = 'ELECTION-TYPE'
		LEFT JOIN public.election_cycle_offices_mapping ecom ON ec.election_cycle_id = ecom.election_cycle_id
		LEFT JOIN type_lookups tlo ON ecom.office_id = tlo.type_id
			AND tlo.lookup_type_code = 'OFF'
		LEFT JOIN public.type_lookups tks ON tks.type_id = ec.status
			AND tks.lookup_type_code ='ELECTION-STATUS'
	WHERE ec.status_code = 'ACTIVE'
		GROUP BY ec.election_cycle_id, 
	   ec.name, 
	   ec.election_type_id, 
	   tl.name,
	   ec.start_date, 
	   ec.end_date, 
	   ec.election_date,
	   ec."desc", 
	   ec.district, 
	   ec.ie_start_date, 
	   ec.ie_end_date,
	   tks.name
	ORDER BY ec.updated_on DESC;
 end
$BODY$;


DROP FUNCTION public.get_managefilers();

CREATE OR REPLACE FUNCTION public.get_managefilers(
	)
    RETURNS TABLE(filerid integer, filertype text, comtype character varying, filername character varying, primaryuser text, status text, lfdate text, createddate date, electiondate text, officetype text) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
begin
  return query
  SELECT com.committee_id as filerID, 
  		 'AC-CAN' as filerType,
		 tl.type_id as comType,
	    com.name as filerName,
	   CASE WHEN CONCAT(tc.middle_name, 'ZZZ') = 'ZZZ' THEN 
			CONCAT(tc.first_name, ' ', tc.last_name)
		ELSE 
			CONCAT(tc.first_name, ' ', tc.middle_name, ' ', tc.last_name)
		END  as primary_user,
		upper(coalesce(com.status_code, 'NEW')) as status,
		CASE WHEN tl.name = 'Candidate Committee' OR tl.name = 'Issue Committee'  THEN 
			--text(fp.due_date)
			TO_CHAR(fp.due_date::DATE, 'YYYY-mm-DD')
		ELSE
		'' END as lfDate,
		com.created_at as cDate,
		text(ec.election_date) as eDate,
		text(com.office_sought_id) as officeId
FROM public.committee com
	INNER JOIN public.contact tc ON com.treasurer_contact_id = tc.contact_id
	LEFT JOIN public.type_lookups tl ON tl.type_id = com.typeid
		and tl.lookup_type_code = 'COM'
	LEFT JOIN public.election_cycle ec ON com.election_cycle_id = ec.election_cycle_id
	LEFT JOIN public.filing_period fp ON ec.election_cycle_id = fp.election_cycle_id
-- 	LEFT JOIN public.type_lookups tlo ON tlo.type_id = com.office_sought_id
-- 		and tl.lookup_type_code = 'OFF'
--WHERE com.election_cycle_id = fp.election_cycle_id
UNION	
SELECT l.lobbysit_id as filerId, 
	   'AC-LOB' as filerType,
	   '' as comType,
	   CASE WHEN CONCAT(pc.middle_name, 'ZZZ') = 'ZZZ' THEN 
			CONCAT(pc.first_name, ' ', pc.last_name)
		ELSE 
			CONCAT(pc.first_name, ' ', pc.middle_name, ' ', pc.last_name)
		END as filerName,
		CASE WHEN l.type = 'LOB-I' THEN 
			CASE WHEN CONCAT(pc.middle_name, 'ZZZ') = 'ZZZ' THEN 
				CONCAT(pc.first_name, ' ', pc.last_name)
			ELSE 
				CONCAT(pc.first_name, ' ', pc.middle_name, ' ', pc.last_name)
			END
		ELSE
			pc.org_name
		END as primary_user,
		upper(coalesce(l.status_code, 'NEW')) as status,
		'' as lfDate,
		l.created_at as cDate,
		'' as eDate,
		'' as officeId
FROM public.lobbyist l
	LEFT JOIN public.contact pc ON l.filer_contact_id = pc.contact_id
	--LEFT JOIN public.contact fc ON l.filer_contact_id = fc.contact_id
UNION
SELECT c.contact_id as filerId,
		CASE WHEN f.entity_type = 'IE' THEN 'AC-IEF' 
		ELSE 'AC-CFE' END as filerType,
		f.entity_type as comType,
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
		upper(coalesce(c.status_code, 'NEW')) as status,
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

DROP FUNCTION public.getlobbyistemployee(integer);

CREATE OR REPLACE FUNCTION public.getlobbyistemployee(
	_lobbyistid integer)
    RETURNS TABLE(contactid integer, employeename text) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
DECLARE roleTypeId int = 0;
DECLARE primaryUserId int = 0;
DECLARE lobbyistType character varying;
DECLARE fillerId int = 0;
begin
	SELECT id INTO roleTypeId
	  FROM public.role 
	WHERE role = 'Lobbyist Employee';
	
	SELECT primary_contact_id, type, filer_contact_id INTO primaryUserId, lobbyistType, fillerId
  		FROM public.lobbyist 
  	WHERE lobbysit_id = _lobbyistid;

	if lobbyistType = 'LOB-O' then
	begin
		return query
			SELECT c.contact_id,
				CASE WHEN CONCAT(c.middle_name, 'ZZZ') = 'ZZZ' THEN c.first_name || ' ' || c.last_name
					ELSE  c.first_name || ' ' || c.middle_name || ' ' || c.last_name
				END as fullName
			FROM public.contact_role_mapping crm
			INNER JOIN public.contact c  ON crm.contact_id = c.contact_id
				WHERE crm.role_type_id = roleTypeId
					AND crm.filer_id = fillerId
					AND lower(coalesce(c.status_code, 'active')) = 'active'
			UNION
			 SELECT c.contact_id,
				CASE WHEN CONCAT(c.middle_name, 'ZZZ') = 'ZZZ' THEN c.first_name || ' ' || c.last_name
					ELSE  c.first_name || ' ' || c.middle_name || ' ' || c.last_name
				END as fullName
			 FROM public.contact c 
			 WHERE c.contact_id = fillerId
			 	AND lower(coalesce(c.status_code, 'active')) = 'active';
		end;
		else
		begin
			return query
			SELECT c.contact_id,
				CASE WHEN CONCAT(c.middle_name, 'ZZZ') = 'ZZZ' THEN c.first_name || ' ' || c.last_name
					ELSE  c.first_name || ' ' || c.middle_name || ' ' || c.last_name
				END as fullName
			 FROM public.contact c 
			 	WHERE c.contact_id = fillerId
			 		AND lower(coalesce(c.status_code, 'active')) = 'active';
		end;
		end if;
end
$BODY$;

DROP FUNCTION public.save_committeeothercontact(character varying, character varying, character varying, character varying, character varying, integer, character varying, integer);

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



DROP FUNCTION public.save_contactrolemappingtreasuree(integer, integer);

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
	SELECT id INTO roleid 
		FROM public.role where role = 'Treasurer';
	
	SELECT user_id INTO uid 
	FROM public.user_account where contact_id = _contactid;

	insert into public."contact_role_mapping" ("user_id", "contact_id", 
											   "filer_id", "role_type_id", 
											   "created_by", "created_at", 
											   "updated_by", "updated_on")
 	values(uid, _contactid, 
		   _filerid, roleid, 
		   'Denver', localtimestamp, 
		   'Denver', localtimestamp);
  return (SELECT LASTVAL());
-- inserted fail retuns 0

end
$BODY$;

DROP FUNCTION public.save_electioncycle(integer, character varying, character varying, date, date, date, character varying, character varying, character varying, date, date, character varying);

CREATE OR REPLACE FUNCTION public.save_electioncycle(
	electioncycleid integer,
	electionname character varying,
	electiontypeid character varying,
	startdate date,
	enddate date,
	electiondate date,
	electioncyclestatus character varying,
	description character varying,
	districtdesc character varying,
	iestartdate date,
	ieenddate date,
	userid character varying)
    RETURNS integer
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
DECLARE newElectionCycleId integer = 0;
DECLARE sDate date;
DECLARE eDate date;
DECLARE sIEDate date;
DECLARE eIEDate date;
DECLARE nYear double precision;
begin
	SELECT EXTRACT(YEAR FROM startdate) INTO nYear; 
	if nYear = 1 OR nYear = 9999 then
		sDate := null;
	else
		sDate := startdate;
	end if;
	
	SELECT EXTRACT(YEAR FROM enddate) INTO nYear;
	if nYear = 1 OR nYear = 9999 then
		eDate := null;
	else
		eDate := enddate;
	end if;
	
	SELECT EXTRACT(YEAR FROM iestartdate) INTO nYear;
	if nYear = 1 OR nYear = 9999 then
		sIEDate := null;
	else
		sIEDate := iestartdate;
	end if;
	
	SELECT EXTRACT(YEAR FROM ieenddate) INTO nYear; 
	if nYear = 1 OR nYear = 9999 then
		eIEDate := null;
	else
		eIEDate := ieenddate;
	end if;
	
	if electionCycleId = 0 then
	begin
		-- 	Insert into contact table
		INSERT INTO public.election_cycle(
			election_cycle_id, name, election_type_id, 
			start_date, end_date, election_date, 
			status, "desc", district, 
			ie_start_date, ie_end_date, status_code, 
			created_by, created_at, updated_by, 
			updated_on)
		VALUES (nextval('election_cycle_id_seq'), electionName, electionTypeId, 
				sDate, eDate, electionDate, 
				electionCycleStatus, description, districtDesc, 
				sIEDate, eIEDate, 'ACTIVE', 
				'Denver', localtimestamp, 'Denver', 
				localtimestamp);

		-- Get the current value from election_cycle table
		SELECT currval('election_cycle_id_seq') INTO newElectionCycleId;
	end;
	else
	begin
		UPDATE public.election_cycle
		SET name=electionName, 
			election_type_id=electionTypeId, 
			start_date=sDate, end_date=eDate, 
			election_date=electionDate, status=electionCycleStatus, 
			"desc"=description, district=districtDesc, 
			ie_start_date=sIEDate, 
			ie_end_date=eIEDate, 
			updated_by='Denver', 
			updated_on=localtimestamp
		WHERE election_cycle_id = electionCycleId;
	end;
	end if;

	if electionCycleId = 0 then
		electionCycleId := newElectionCycleId;
	end if;
	
	return electionCycleId;
 end
$BODY$;

----------------------------------------Functions------------------------------------