-- FUNCTION: public.get_managefiler(character varying, character varying, character varying, date, date, character varying, character varying, date, character varying)

-- DROP FUNCTION public.get_managefiler(character varying, character varying, character varying, date, date, character varying, character varying, date, character varying);

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
