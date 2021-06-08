------------------------------------------Functions----------------------------------------

DROP FUNCTION public.get_committeebyid(integer);

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
	ORDER BY 1;
 end
$BODY$;


DROP FUNCTION public.get_filerbyname(character varying);

CREATE OR REPLACE FUNCTION public.get_filerbyname(
	fname character varying DEFAULT NULL::character varying)
    RETURNS TABLE(filername character varying) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
begin
   if CONCAT(fname, 'ZZZ') != 'ZZZ' AND fname = null then
	  return query
	  SELECT T.filerName FROM
		(SELECT  com.name as filerName
			FROM public.committee com
		 UNION	
		 SELECT CASE WHEN l.type = 'LOB-I' THEN 
					CASE WHEN CONCAT(pc.middle_name, 'ZZZ') = 'ZZZ' THEN 
						CONCAT(pc.first_name, ' ', pc.last_name)
					ELSE 
						CONCAT(pc.first_name, ' ', pc.middle_name, ' ', pc.last_name)
					END
				ELSE
					pc.org_name
				END as filerName
			FROM public.lobbyist l
				LEFT JOIN public.contact pc ON l.filer_contact_id = pc.contact_id
		 UNION
			SELECT CASE WHEN CONCAT(c.middle_name, 'ZZZ') = 'ZZZ' THEN 
						CONCAT(c.first_name, ' ', c.last_name)
					ELSE 
						CONCAT(c.first_name, ' ', c.middle_name, ' ', c.last_name)
					END as filerName
			FROM public.contact c
	  ) T
		WHERE LOWER(TRIM(T.filerName)) LIKE '%' || trim(fname) || '%';
  else
	  return query
	  SELECT T.filerName FROM
		(SELECT  com.name as filerName
			FROM public.committee com
		 UNION	
		 SELECT CASE WHEN l.type = 'LOB-I' THEN 
					CASE WHEN CONCAT(pc.middle_name, 'ZZZ') = 'ZZZ' THEN 
						CONCAT(pc.first_name, ' ', pc.last_name)
					ELSE 
						CONCAT(pc.first_name, ' ', pc.middle_name, ' ', pc.last_name)
					END
				ELSE
					pc.org_name
				END as filerName
			FROM public.lobbyist l
				LEFT JOIN public.contact pc ON l.filer_contact_id = pc.contact_id
		 UNION
			SELECT CASE WHEN CONCAT(c.middle_name, 'ZZZ') = 'ZZZ' THEN 
						CONCAT(c.first_name, ' ', c.last_name)
					ELSE 
						CONCAT(c.first_name, ' ', c.middle_name, ' ', c.last_name)
					END as filerName
			FROM public.contact c
	   ) T;
   end if;
 end
$BODY$;


DROP FUNCTION public.get_lobbyistentities(integer, character varying);

CREATE OR REPLACE FUNCTION public.get_lobbyistentities(
	lobbyistentityid integer,
	roletype character varying)
    RETURNS TABLE(contactid integer, firstname text, middlename text, lastname text, fullname text, phoneno text, emailid text, contacttype text, orgname text, lobfullname text, employeeid integer, natureofbusiness text, legislativematters text, address1 text, address2 text, city text, statecode text, zipcode text, officialname text, officialtitle text, relationship text, entityname text) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
DECLARE roleTypeId integer;
DECLARE filerId1 integer;
begin

  SELECT id into roleTypeId 
  FROM public.role 
  	WHERE role = roleType;

	SELECT filer_contact_id INTO filerId1 FROM public.lobbyist WHERE lobbysit_id = lobbyistentityid;
	
	if roleType = 'Lobbyist Employee' then
		return query	
		SELECT c.contact_id as contactId,
			text(c.first_name) as firstName,
			text(c.middle_name) as middleName,
			text(c.last_name) as lastName,
			CASE WHEN CONCAT(c.middle_name, 'ZZZ') = 'ZZZ' THEN c.first_name || ' ' || c.last_name
				ELSE  c.first_name || ' ' || c.middle_name || ' ' || c.last_name
			END as fullName,
			text(c.phone) as phoneNo,
			text(c.email) as emailId,
			CASE WHEN c.contact_type = 'I' OR  c.contact_type = 'LOB-I' THEN 'Individual'
				WHEN c.contact_type = 'O' OR  c.contact_type = 'LOB-O' THEN 'Organization'
			  ELSE ''
			END as contactType,
			'' as orgName,
			'' as lobfullName,
			0 employeeId,
			'' as natureOfBusiness,
			'' as legislativeMatters,
			'' as address1,
			'' as address2,
			'' as city,
			'' as stateCode,
			'' as zipCode,
			'' as officialName,
			'' as officialTitle,
			'' as relationship,
			'' as entityName
		FROM contact_role_mapping crm
			INNER JOIN contact c  ON crm.contact_id = c.contact_id
		WHERE crm.role_type_id = roleTypeId
			AND crm.filer_id = filerId1;
			--AND lower(coalesce(c.status_code, 'active')) = 'active';
	elsif roleType = 'Lobbyist Subcontractor' then
		return query
 		SELECT c.contact_id as contactId,
 			text(c.first_name) as firstName,
 			text(c.middle_name) as middleName,
 			text(c.last_name) as lastName,
 			CASE WHEN CONCAT(c.middle_name, 'ZZZ') = 'ZZZ' THEN c.first_name || ' ' || c.last_name
 				ELSE  c.first_name || ' ' || c.middle_name || ' ' || c.last_name
 			END as fullName,
 			text(c.phone) as phoneNo,
 			text(c.email) as emailId,
 			CASE WHEN c.contact_type = 'I' OR  c.contact_type = 'LOB-I' THEN 'Individual'
				WHEN c.contact_type = 'O' OR  c.contact_type = 'LOB-O' THEN 'Organization'
			  ELSE ''
			END as contactType,
 			'' as orgName,
			'' as lobfullName,
 			0 employeeId,
 			'' as natureOfBusiness,
 			'' as legislativeMatters,
 			'' as address1,
 			'' as address2,
 			'' as city,
 			'' as stateCode,
 			'' as zipCode,
			'' as officialName,
 			'' as officialTitle,
 			'' as relationship,
 			'' as entityName
 		FROM contact_role_mapping crm
 			INNER JOIN contact c ON crm.contact_id = c.contact_id
 		WHERE crm.role_type_id = roleTypeId
			AND crm.filer_id = filerId1;
			--AND lower(coalesce(c.status_code, 'active')) = 'active';
	elsif  roleType = 'Lobbyist Client' then
		return query
		SELECT c.contact_id as contactId,
			text(c.first_name) as firstName,
			text(c.middle_name) as middleName,
			text(c.last_name) as lastName,
			CASE WHEN CONCAT(c.middle_name, 'ZZZ') = 'ZZZ' THEN c.first_name || ' ' || c.last_name
				ELSE  c.first_name || ' ' || c.middle_name || ' ' || c.last_name
			END as fullName,
			text(c.phone) as phoneNo,
			text(c.email) as emailId,
			CASE WHEN c.contact_type = 'I' OR  c.contact_type = 'LOB-I' THEN 'Individual'
				WHEN c.contact_type = 'O' OR  c.contact_type = 'LOB-O' THEN 'Organization'
			  ELSE ''
			END as contactType,
			text(c.org_name) as orgName,
			CASE WHEN CONCAT(cl.middle_name, 'ZZZ') = 'ZZZ' THEN cl.first_name || ' ' || cl.last_name
				ELSE  cl.first_name || ' ' || cl.middle_name || ' ' || cl.last_name
			END as lobfullName,
			lc.employee_id as employeeId,
			text(lc.nature_of_business) as natureOfBusiness,
			text(lc.legislative_matters) as legislativeMatters,
			text(c.address1) as address1,
			text(c.address2) as address2,
			text(c.city) as city,
			text(c.state_code) as stateCode,
			text(c.zip) as zipCode,
			'' as officialName,
			'' as officialTitle,
			'' as relationship,
			'' as entityName
		FROM public.contact_role_mapping crm
			INNER JOIN  public.contact c ON crm.contact_id = c.contact_id
			INNER JOIN  public.lobbyist_client lc ON c.contact_id = lc.contact_id
			LEFT JOIN  public.contact cl ON lc.employee_id = cl.contact_id
		WHERE crm.role_type_id = roleTypeId
			AND crm.filer_id = filerId1;
			--AND lower(coalesce(lc.status_code, 'active')) = 'active';
	elsif roleType = 'Lobbyist Relationship' then
		return query
		SELECT c.contact_id as contactId,
			text(c.first_name) as firstName,
			text(c.middle_name) as middleName,
			text(c.last_name) as lastName,
			CASE WHEN CONCAT(c.middle_name, 'ZZZ') = 'ZZZ' THEN c.first_name || ' ' || c.last_name
				ELSE  c.first_name || ' ' || c.middle_name || ' ' || c.last_name
			END as fullName,
			'' as phoneNo,
			'' as emailId,
			'' as contactType,
			'' orgName,
			CASE WHEN CONCAT(cl.middle_name, 'ZZZ') = 'ZZZ' THEN cl.first_name || ' ' || cl.last_name
				ELSE  cl.first_name || ' ' || cl.middle_name || ' ' || cl.last_name
			END as lobfullName,
			lr.employee_id as employeeId,
			'' as natureOfBusiness,
			'' as legislativeMatters,
			'' as address1,
			'' as address2,
			'' as city,
			'' as stateCode,
			'' as zipCode,
			text(lr.official_name) as officialName,
			text(lr.official_title) as officialTitle,
			text(lr.relationship) as relationship,
			text(lr.entity_name) as entityName
		FROM public.contact_role_mapping crm
				INNER JOIN  public.contact c ON crm.contact_id = c.contact_id
				INNER JOIN  public.lobbyist_relationship lr ON c.contact_id = lr.contact_id
				INNER JOIN  public.contact cl ON lr.employee_id = cl.contact_id
			WHERE crm.role_type_id = roleTypeId
				AND crm.filer_id = filerId1;
				--AND lower(coalesce(lr.status_code, 'active')) = 'active';
	end if;
 end
$BODY$;

DROP FUNCTION public.get_lobyyistcontactinfo(integer);

CREATE OR REPLACE FUNCTION public.get_lobyyistcontactinfo(
	lobbyistid integer)
    RETURNS TABLE(year character varying, orgtype character varying, orgname character varying, firstname character varying, lastname character varying, address1 character varying, address2 character varying, city character varying, statecode character varying, zipcode character varying, phoneno character varying, email character varying, statuscode text) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
begin
  return query
  SELECT l.year, 
		l.type,
		c.org_name,
		c.first_name,
		c.last_name,
		c.address1,
		c.address2,
		c.city,
		c.state_code,
		c.zip,
		c.phone,
		c.email,
		upper(coalesce(l.status_code, 'NEW')) as status_code
FROM public.lobbyist l
	INNER JOIN public.contact c ON l.filer_contact_id = c.contact_id
WHERE l.lobbysit_id = lobbyistid;
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


DROP FUNCTION public.get_rolesandtypes(integer);

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
WHERE c.contact_id = _userid
	AND upper(coalesce(c.status_code,'ACTIVE')) = 'ACTIVE';
 end
$BODY$;

DROP FUNCTION public.get_userentities(integer);

CREATE OR REPLACE FUNCTION public.get_userentities(
	userid integer)
    RETURNS TABLE(contactid integer, entityname text, entitytype character varying) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
begin
  return query
  SELECT l.lobbysit_id, CASE WHEN CONCAT(c.middle_name, 'ZZZ') = 'ZZZ' THEN 
					CONCAT(c.first_name, ' ', c.last_name) 
				  ELSE
				  	CONCAT(c.first_name, ' ', c.middle_name, ' ', c.last_name)
				  END as entity_Name, f.entity_type
	FROM public.contact_role_mapping crm
	 INNER JOIN public.filer f ON crm.filer_id = f.filer_id
	 INNER JOIN public.lobbyist l ON l.lobbysit_id = f.entity_id
	 INNER JOIN public.contact c ON c.contact_id = l.filer_contact_id
	WHERE crm.user_id = userId
		AND f.entity_type = 'L'
		AND coalesce(lower(l.status_code), 'active') = 'active'
	UNION
	SELECT com.committee_id, com.name as entity_Name, f.entity_type
	FROM public.contact_role_mapping crm
	 INNER JOIN public.filer f ON crm.filer_id = f.filer_id
	 INNER JOIN public.committee com ON com.committee_id = f.entity_id
	 INNER JOIN public.contact c ON c.contact_id = crm.contact_id
	WHERE crm.user_id = userId
		AND f.entity_type = 'C'
		AND coalesce(lower(com.status_code), 'active') = 'active'
	UNION
	SELECT c.contact_id, CASE WHEN CONCAT(c.middle_name, 'ZZZ') = 'ZZZ' THEN 
					CONCAT(c.first_name, ' ', c.last_name) 
				  ELSE
				  	CONCAT(c.first_name, ' ', c.middle_name, ' ', c.last_name)
				  END as entity_Name, f.entity_type
	FROM public.contact_role_mapping crm
	 INNER JOIN public.filer f ON crm.filer_id = f.filer_id
	 INNER JOIN public.contact c ON c.contact_id = crm.contact_id
	WHERE crm.user_id = userId
		AND f.entity_type = 'IE'
		AND coalesce(lower(c.status_code), 'active') = 'active'
	UNION 
	SELECT c.contact_id, CASE WHEN CONCAT(c.middle_name, 'ZZZ') = 'ZZZ' THEN 
					CONCAT(c.first_name, ' ', c.last_name) 
				  ELSE
				  	CONCAT(c.first_name, ' ', c.middle_name, ' ', c.last_name)
				  END as entity_Name, f.entity_type
	FROM public.contact_role_mapping crm
	 INNER JOIN public.filer f ON crm.filer_id = f.filer_id
	 INNER JOIN public.contact c ON c.contact_id = crm.contact_id
	WHERE crm.user_id = userId
		AND f.entity_type = 'CO'
		AND coalesce(lower(c.status_code), 'active') = 'active';
 end
$BODY$;


DROP FUNCTION public.get_userentitydetail(integer, character varying);

CREATE OR REPLACE FUNCTION public.get_userentitydetail(
	_entityid integer,
	_entitytype character varying)
    RETURNS TABLE(contactid integer, entityname text, entitytype text, orgname text, primaryname text, candidatename text, treasurername text, electiondate text, publicfund text, ballotissue text, positiondesc text, purposedesc text, occupationdesc text) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
begin
	if _entitytype = 'AC-LOB' then
	  return query
		SELECT  l.lobbysit_id AS entity_Id,
			CASE WHEN CONCAT(c.middle_name, 'ZZZ') = 'ZZZ' THEN 
				CONCAT(c.first_name, ' ', c.last_name) 
			ELSE
				CONCAT(c.first_name, ' ', c.middle_name, ' ', c.last_name)
			END as entity_Name,
			text(c.contact_type) as entity_Type,
			text(c.org_name),
			CASE WHEN CONCAT(pc.middle_name, 'ZZZ') = 'ZZZ' THEN 
				CONCAT(pc.first_name, ' ', pc.last_name) 
			ELSE
				CONCAT(pc.first_name, ' ', pc.middle_name, ' ', pc.last_name)
			END as primary_name,
			'' as candidate_name,
			'' as treasurer_name,
			'' as election_date,
			'' as public_fund,
			'' as ballot_issue,
			'' as position,
			'' as purpose,
			'' as occupation
		FROM public.lobbyist l 
			LEFT JOIN public.contact c ON l.primary_contact_id = c.contact_id
			INNER JOIN public.contact pc ON l.filer_contact_id = pc.contact_id
		WHERE l.lobbysit_id = _entityid;
	elsif _entitytype = 'AC-CAN' OR  _entitytype = 'AC-TST' then
		return query
		SELECT com.committee_id as entity_Id, 
				text(com.name) as entity_Name, 
				text(com.typeid) as entity_Type, 
				'' as org_name,
				'' as primary_name,
				CASE WHEN CONCAT(cc.middle_name, 'ZZZ') = 'ZZZ' THEN 
					CONCAT(cc.first_name, ' ', cc.last_name) 
				ELSE
					CONCAT(cc.first_name, ' ', cc.middle_name, ' ', cc.last_name)
				END as candidate_name,
				CASE WHEN CONCAT(tc.middle_name, 'ZZZ') = 'ZZZ' THEN 
					CONCAT(tc.first_name, ' ', tc.last_name) 
				ELSE
					CONCAT(tc.first_name, ' ', tc.middle_name, ' ', tc.last_name)
				END as treasurer_name,
				text(ec.election_date),
				'Active' as public_fund,
				text(bi.ballot_issue),
				text(com.position),
				text(com.purpose),
				'' as occupation
		FROM public.committee com
			INNER JOIN public.contact c ON c.contact_id = com.committee_contact_id
			LEFT JOIN public.contact cc ON com.candidate_contact_id = cc.contact_id
			LEFT JOIN public.contact tc ON com.treasurer_contact_id = tc.contact_id
			LEFT JOIN public.election_cycle ec ON com.election_cycle_id = ec.election_cycle_id
			LEFT JOIN public.ballot_issue bi ON com.ballot_issue_id = bi.ballot_issue_id
		WHERE com.committee_id = _entityid;
	else
		return query
		SELECT c.contact_id as entity_Id, 
		      '' as entity_Name, 
			   text(c.contact_type) as entity_Type,
			   text(c.org_name),
			   '' as primary_name,
			   '' as candidate_name,
				'' as treasurer_name,
			   '' as election_date,
			   '' as public_fund,
			   '' as ballot_issue,
			   '' as position,
			   '' as purpose,
			   text(c.occupation) as occupation
		FROM public.contact_role_mapping crm
			 INNER JOIN public.filer f ON crm.filer_id = f.filer_id
			 INNER JOIN public.contact c ON c.contact_id = crm.contact_id
		WHERE c.contact_id = _entityid;
	end if;
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
			 WHERE c.contact_id = primaryUserId
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

----------------------------------------Functions------------------------------------