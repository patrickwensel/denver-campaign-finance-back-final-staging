
﻿----------------------------------------Functions----------------------------------------------
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
		INSERT INTO public.debugdetails(param1) values('Yes');
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
		INSERT INTO public.debugdetails(param1) values('No');
			return query
			SELECT c.contact_id,
				CASE WHEN CONCAT(c.middle_name, 'ZZZ') = 'ZZZ' THEN c.first_name || ' ' || c.last_name
					ELSE  c.first_name || ' ' || c.middle_name || ' ' || c.last_name
				END as fullName
			 FROM public.contact c 
			 	WHERE c.contact_id = primaryUserId
			 		AND lower(coalesce(c.status_code, 'active')) = 'active';
		end;
		end if;
end
$BODY$;

ALTER FUNCTION public.getlobbyistemployee(integer)
    OWNER TO devadmin;


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
	 INNER JOIN public.contact c ON c.contact_id = crm.contact_id
	WHERE crm.user_id = userId
		AND f.entity_type = 'L'
		AND coalesce(lower(l.status_code), 'active') = 'active'
	UNION
	SELECT com.committee_id, CASE WHEN CONCAT(c.middle_name, 'ZZZ') = 'ZZZ' THEN 
					CONCAT(c.first_name, ' ', c.last_name) 
				  ELSE
				  	CONCAT(c.first_name, ' ', c.middle_name, ' ', c.last_name)
				  END as entity_Name, f.entity_type
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

ALTER FUNCTION public.get_userentities(integer)
    OWNER TO devadmin;


DROP FUNCTION public.get_filerbyname(character varying);

CREATE OR REPLACE FUNCTION public.get_filerbyname(
	fname character varying)
    RETURNS TABLE(filername character varying) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
begin
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
			LEFT JOIN public.contact pc ON l.primary_contact_id = pc.contact_id
	 UNION
		SELECT CASE WHEN CONCAT(c.middle_name, 'ZZZ') = 'ZZZ' THEN 
					CONCAT(c.first_name, ' ', c.last_name)
				ELSE 
					CONCAT(c.first_name, ' ', c.middle_name, ' ', c.last_name)
				END as filerName
		FROM public.contact c
  ) T
	WHERE LOWER(TRIM(T.filerName)) LIKE '%' || trim(fname) || '%';
 end
$BODY$;

ALTER FUNCTION public.get_filerbyname(character varying)
    OWNER TO devadmin;
	
	
DROP FUNCTION public.get_electioncycles();

CREATE OR REPLACE FUNCTION public.get_electioncycles(
	)
    RETURNS TABLE(electioncycleid integer, electioncycle character varying, electioncycletypeid character varying, electioncycletype character varying, startdate date, enddate date, electiondate date, description character varying, district character varying, iestartdate date, ieenddate date, officeids text, offices text) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
begin
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
		string_agg(tlo.name::text,', ') offices
	FROM public.election_cycle ec 
		INNER JOIN public.type_lookups tl ON ec.election_type_id = tl.type_id 
			AND tl.lookup_type_code = 'ELECTION-TYPE'
		INNER JOIN public.election_cycle_offices_mapping ecom ON ec.election_cycle_id = ecom.election_cycle_id
		INNER JOIN type_lookups tlo ON ecom.office_id = tlo.type_id
			AND tlo.lookup_type_code = 'OFF'
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
	   ec.ie_end_date
	ORDER BY 1;
 end
$BODY$;

ALTER FUNCTION public.get_electioncycles()
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
			CASE WHEN c.contact_type = 'I' THEN 'Individual'
				WHEN c.contact_type = 'O' THEN 'Organisation'
				ELSE ''
			END as entity_Type,
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
			LEFT JOIN public.contact c ON l.filer_contact_id = c.contact_id
			INNER JOIN public.contact pc ON l.primary_contact_id = pc.contact_id
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
			INNER JOIN public.election_cycle ec ON com.election_cycle_id = ec.election_cycle_id
			LEFT JOIN public.ballot_issue bi ON com.ballot_issue_id = bi.ballot_issue_id
		WHERE com.committee_id = _entityid;
	else
		return query
		SELECT c.contact_id as entity_Id, 
			   CASE WHEN CONCAT(c.middle_name, 'ZZZ') = 'ZZZ' THEN 
				CONCAT(c.first_name, ' ', c.last_name) 
			   ELSE
				CONCAT(c.first_name, ' ', c.middle_name, ' ', c.last_name)
			   END as entity_Name, 
			   CASE WHEN f.entity_type = 'C' THEN 'Committee'
					WHEN f.entity_type = 'L' THEN 'Lobbyist'
					WHEN f.entity_type = 'IE' THEN 'Independent Expenditure'
					WHEN f.entity_type = 'CO' THEN 'Covered Official or Former City Employee'
			   ELSE
				''
			   END as entity_Type,
			   text(c.org_name),
			   '' as primary_name,
			   '' as candidate_name,
				'' as treasurer_name,
			   '' as election_date,
			   '' as public_fund,
			   '' as ballot_issue,
			   '' as position,
			   '' as purpose,
			   text(c.occupation)
		FROM public.contact_role_mapping crm
			 INNER JOIN public.filer f ON crm.filer_id = f.filer_id
			 INNER JOIN public.contact c ON c.contact_id = crm.contact_id
		WHERE c.contact_id = _entityid;
	end if;
 end
$BODY$;

ALTER FUNCTION public.get_userentitydetail(integer, character varying)
    OWNER TO devadmin;


DROP FUNCTION public.get_lobyyistcontactinfo(integer);

CREATE OR REPLACE FUNCTION public.get_lobyyistcontactinfo(
	lobbyistid integer)
    RETURNS TABLE(year character varying, orgtype character varying, orgname character varying, firstname character varying, lastname character varying, address1 character varying, address2 character varying, city character varying, statecode character varying, zipcode character varying, phoneno character varying, email character varying, statusCode text) 
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
		upper(l.status_code) as status_code
FROM public.lobbyist l
	INNER JOIN public.contact c ON l.primary_contact_id = c.contact_id
WHERE l.lobbysit_id = lobbyistid;
 end
$BODY$;

ALTER FUNCTION public.get_lobyyistcontactinfo(integer)
    OWNER TO devadmin;
	

	
    ----------------------------------------Functions------------------------------------

