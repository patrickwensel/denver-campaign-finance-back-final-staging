-- FUNCTION: public.get_paymenthistory(character varying, character varying, date, date, integer)

-- DROP FUNCTION public.get_paymenthistory(character varying, character varying, date, date, integer);

CREATE OR REPLACE FUNCTION public.get_paymenthistory(
	_searchval character varying,
	_filertype character varying,
	_mindate date,
	_maxdate date,
	_electioncycleid integer)
    RETURNS TABLE(invoicenumber integer, filername text, date text, amount text, description text, "user" text, paymentmethod text, type text) 
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

if _mindate != null then
	SELECT EXTRACT(YEAR FROM _mindate) INTO nYear; 
	if nYear = 1 OR nYear = 9999 then
		fsDate := null;
	else
		fsDate := _mindate;
	end if;
	end if;
	if _maxdate != null then
	SELECT EXTRACT(YEAR FROM _maxdate) INTO nYear; 
	if nYear = 1 OR nYear = 9999 then
		feDate := null;
	else
		feDate := _maxdate;
	end if;
	end if;
	  whereClause := '';
	  sqlQuery := 'SELECT ph.invoicenumber,
					text(ph.filername) as fname,
					text(ph.type) as type,
					text(ph.description) as description,
					text(ph.date) as fsDate,
					text(ph.amount) as amount,
					text(ph.user) as user,
					text(ph.paymentmethod) as paymentmethod
			FROM public.get_paymenthistory() ph ';

		if CONCAT(_searchval, 'ZZZ') != 'ZZZ' then
			whereClause := ' WHERE LOWER(ph.filername) LIKE ' || '''%' || LOWER(trim(_searchval)) || '%''';
		end if;
		

		if CONCAT(_filertype, 'ZZZ') != 'ZZZ' then
			whereClauseValue := '';
			SELECT INTO arrValue regexp_split_to_array(_filertype,',');
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
				whereClause := whereClause || ' ph.filerType IN (' || whereClauseValue || ')';
			end if;
		end if;
		
if _mindate != null then
		if CONCAT(fsDate, 'ZZZ') != 'ZZZ' AND CONCAT(feDate, 'ZZZ') != 'ZZZ' then
			if CONCAT(whereClause, 'ZZZ') != 'ZZZ' then
				whereClause := whereClause || ' AND ';
			else
				whereClause := ' WHERE ';
			end if;
			whereClause := whereClause || ' CAST(ph.date as TEXT) >= ' || '''' || _mindate || '''' || ' AND CAST(ph.date as TEXT) <= ' || '''' || _maxdate || ''''; 
		end if;
		end if ;

		-- Election Date
		if _electioncycleid != 0 then
		if CONCAT(_electioncycleid, 'ZZZ') != 'ZZZ' then
			if CONCAT(whereClause, 'ZZZ') != 'ZZZ' then
					whereClause := whereClause || ' AND ';
			else
				whereClause := ' WHERE ';
			end if;
			whereClause := whereClause || ' ph.electioncycleid = '''  || _electioncycleid || '''';
		end if;
		end if;
		
		--INSERT INTO public.debugdetails(param1) values(whereClause);
		sqlQuery := sqlQuery || whereClause;
		
		--INSERT INTO public.debugdetails(param1, param2) values(sqlQuery, 'Final');
		return query execute sqlQuery;
 end
$BODY$;

ALTER FUNCTION public.get_paymenthistory(character varying, character varying, date, date, integer)
    OWNER TO devadmin;
