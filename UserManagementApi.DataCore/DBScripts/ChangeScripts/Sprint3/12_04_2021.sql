------------------------------------------Functions----------------------------------------

DROP FUNCTION public.get_electioncycles();

CREATE OR REPLACE FUNCTION public.get_electioncycles()
    RETURNS TABLE(electioncycleid integer, electioncycle character varying, electioncycletypeid character varying, electioncycletype character varying, startdate date, enddate date, electiondate date, description character varying, district character varying, iestartdate date, ieenddate date) 
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
	   ec.ie_end_date
	FROM public.election_cycle ec 
		INNER JOIN public.type_lookups tl ON ec.election_type_id = tl.type_id 
			AND tl.lookup_type_code = 'ELECTION-TYPE'
	WHERE ec.status_code = 'ACTIVE';
 end
$BODY$;

ALTER FUNCTION public.get_electioncycles()
    OWNER TO devadmin;
	
DROP FUNCTION public.get_electioncyclebytype(character varying);

CREATE OR REPLACE FUNCTION public.get_electioncyclebytype(
	typecode character varying)
    RETURNS TABLE(electioncycleid integer, electioncycle character varying) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
begin
  return query
  SELECT ec.election_cycle_id, 
	   ec.name
  FROM public.election_cycle ec 
  	WHERE ec.status_code = 'ACTIVE'
		AND ec.election_type_id = typeCode;
 end
$BODY$;

ALTER FUNCTION public.get_electioncyclebytype(character varying)
    OWNER TO devadmin;

    --------------------------------------
    CREATE OR REPLACE FUNCTION public.get_electioncycledetailsbyfiler(
	_startdate date,
	_enddate date)
    RETURNS TABLE(title character varying, description character varying, edate date) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
begin
return query
SELECT name,"desc",election_date FROM public.election_cycle
WHERE (election_date, election_date ) OVERLAPS (_startdate::DATE, _enddate::DATE);
 end
$BODY$;

ALTER FUNCTION public.get_electioncycledetailsbyfiler(date, date)
    OWNER TO devadmin;
    -------------------------------
    CREATE OR REPLACE FUNCTION public.get_eventdetailsbyfiler(
	_filertype character varying,
	_startdate date,
	_enddate date)
    RETURNS TABLE(title character varying, description character varying, edate date) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
begin
return query
SELECT ec.name,ec."descr",DATE(ec.eventdate) FROM public.event ec
Left JOIN public.event_filer_type_mapping eftm on ec.event_id = eftm.event_id
WHERE (ec.eventdate, ec.eventdate ) OVERLAPS (_startdate::DATE, _enddate::DATE) 
AND eftm.filer_type_id = _filertype;
 end
$BODY$;

ALTER FUNCTION public.get_eventdetailsbyfiler(character varying, date, date)
    OWNER TO devadmin;
    ---------------------------
    CREATE OR REPLACE FUNCTION public.get_filingperioddetailsbyfiler(
	_filertype character varying,
	_startdate date,
	_enddate date)
    RETURNS TABLE(title character varying, description character varying, edate date) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
begin
return query
SELECT fp.name,fp."desc",DATE(fp.due_date) FROM public.filing_period fp
Left JOIN public.filing_period_filer_type_mapping fpftm on fp.filing_period_id = fpftm.filing_period_id
WHERE (fp.due_date, fp.due_date ) OVERLAPS (_startdate::DATE, _enddate::DATE) 
AND fpftm.filer_type_id = _filertype;
 end
$BODY$;

ALTER FUNCTION public.get_filingperioddetailsbyfiler(character varying, date, date)
    OWNER TO devadmin;
    ----------------------------------------Functions------------------------------------