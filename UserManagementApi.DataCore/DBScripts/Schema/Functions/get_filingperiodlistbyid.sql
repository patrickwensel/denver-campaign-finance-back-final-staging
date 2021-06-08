-- FUNCTION: public.get_filingperiodlistbyid(integer)

-- DROP FUNCTION public.get_filingperiodlistbyid(integer);

CREATE OR REPLACE FUNCTION public.get_filingperiodlistbyid(
	_filingperiodid integer)
    RETURNS TABLE(filingperiodid integer, filingperiodname character varying, description character varying, startdate date, enddate date, duedate timestamp without time zone, electioncycleid integer, filingperiodfilertypeids text, filertypeid character varying, filingperiodfileryypeid integer, itemthreshold numeric) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
begin
  return query
  	select fp.filing_period_id,
	fp."name",
	fp."desc",
	fp.start_date,
	fp.end_date,
	fp.due_date,
	fp.election_cycle_id,
	CAST (fpftm.filing_period_filer_type_mapping_id AS text),
	fpftm.filer_type_id,
	fpftm.filing_period_filer_type_mapping_id,
	fp.item_threshold
	from
	filing_period fp
	inner join filing_period_filer_type_mapping fpftm on fpftm.filing_period_id = fp.filing_period_id
	where fp.filing_period_id=_filingperiodid and fp.status_code='ACTIVE' and fpftm.status_code='ACTIVE';
	
end
$BODY$;

ALTER FUNCTION public.get_filingperiodlistbyid(integer)
    OWNER TO devadmin;
