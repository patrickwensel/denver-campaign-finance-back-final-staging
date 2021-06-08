------------------------------------------Functions----------------------------------------

DROP FUNCTION public.get_electioncyclebyid(integer);

CREATE OR REPLACE FUNCTION public.get_electioncyclebyid(
	ecycleid integer)
    RETURNS TABLE(electioncycleid integer, electionname character varying, electiontypeid character varying, electiontypedesc character varying, startdate date, enddate date, electiondate date, status character varying, statusdesc character varying, description character varying, district character varying, iestartdate date, ieenddate date, electioncyclestatus character varying, officeids character varying, offices character varying) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
DECLARE tOfficeIds character varying;
DECLARE tOffices character varying;
begin

  	SELECT string_agg(ecom.office_id::text,', ') officeids,
		string_agg(tl.name::text,', ') offices INTO tOfficeIds, tOffices
	FROM public.election_cycle_offices_mapping ecom
		INNER JOIN type_lookups tl ON ecom.office_id = tl.type_id 
			AND tl.lookup_type_code = 'ELECTION-TYPE'
	WHERE ecom.election_cycle_id = eCycleId
		AND ecom.status_code = 'ACTIVE'
	GROUP BY ecom.election_cycle_id;
 
  return query
  SELECT ec.election_cycle_id, ec.name, 
  		ec.election_type_id, electiontype.name as electionType, ec.start_date, 
		ec.end_date, ec.election_date, 
		ec.status, electionstatus.name as statusDesc, ec."desc", 
		ec.district, ec.ie_start_date, 
		ec.ie_end_date, ec.status_code,
		tOfficeIds, tOffices
	FROM public.election_cycle ec 
		LEFT JOIN public.type_lookups electionstatus ON ec.status = electionstatus.type_id 
			AND electionstatus.lookup_type_code = 'ELECTION-STATUS'
		LEFT JOIN public.type_lookups electiontype ON ec.election_type_id = electiontype.type_id 
			AND electiontype.lookup_type_code = 'ELECTION-TYPE'
	WHERE ec.election_cycle_id = eCycleId;
 end
$BODY$;

ALTER FUNCTION public.get_electioncyclebyid(integer)
    OWNER TO devadmin;
	
DROP FUNCTION public.get_lobyyistcontactinfo(integer);

CREATE OR REPLACE FUNCTION public.get_lobyyistcontactinfo(
	lobbyistid integer)
    RETURNS TABLE(year character varying, 
				  orgType character varying, 
				  orgName character varying,
				  firstName character varying,
				  lastName character varying,
				  address1 character varying,
				  address2 character varying,
				  city character varying,
				  stateCode character varying,
				  zipCode character varying,
				  phoneNo character varying,
				  email character varying) 
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
		c.email
FROM public.lobbyist l
	INNER JOIN public.contact c ON l.primary_contact_id = c.contact_id
WHERE l.lobbysit_id = lobbyistid;
 end
$BODY$;

ALTER FUNCTION public.get_lobyyistcontactinfo(integer)
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
    RETURNS TABLE(filerId integer, filerName text, 
				  primaryUser text, status text, 
				  lastfillingdate text, createdDate text,
				  electiondate text, filerType text) 
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
DECLARE electionDate date;
DECLARE nYear double precision;
begin
	
	SELECT EXTRACT(YEAR FROM lsstartdate) INTO nYear; 
	if nYear = 1 OR nYear = 9999 then
		fsDate := null;
	else
		fsDate := startdate;
	end if;
	
	SELECT EXTRACT(YEAR FROM lsenddate) INTO nYear; 
	if nYear = 1 OR nYear = 9999 then
		feDate := null;
	else
		feDate := lsenddate;
	end if;
	
	SELECT EXTRACT(YEAR FROM edate) INTO nYear; 
	if nYear = 1 OR nYear = 9999 then
		electionDate := null;
	else
		electionDate := lsenddate;
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

		
		INSERT INTO public.debugdetails(param1, param2) values(sqlQuery, 'step1');
		-- Filer Name
		if CONCAT(fname, 'ZZZ') != 'ZZZ' then
			whereClause := ' WHERE LOWER(mf.filername) LIKE ' || '''%' || LOWER(trim(fname)) || '%''';
		end if;
		
		INSERT INTO public.debugdetails(param1, param2) values(whereClause, 'step2');
		
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
		
		INSERT INTO public.debugdetails(param1, param2) values(whereClause, 'step3');
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
		
		INSERT INTO public.debugdetails(param1) values(whereClause);
		sqlQuery := sqlQuery || whereClause;
		
		INSERT INTO public.debugdetails(param1, param2) values(sqlQuery, 'Final');
		return query execute sqlQuery;
 end
$BODY$;

ALTER FUNCTION public.get_managefiler(character varying, character varying, character varying, date, date, character varying, character varying, date, character varying)
    OWNER TO devadmin;
	
	
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
	
	



----------------------------------------Functions------------------------------------
	
----------------------------------------Tables------------------------------------
ALTER TABLE public.election_cycle_offices_mapping
ALTER COLUMN office_id  TYPE character varying(50);
----------------------------------------Tables------------------------------------
	
	