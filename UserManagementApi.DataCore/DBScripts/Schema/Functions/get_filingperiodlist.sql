-- FUNCTION: public.get_filingperiodlist()

-- DROP FUNCTION public.get_filingperiodlist();

CREATE OR REPLACE FUNCTION public.get_filingperiodlist(
	)
    RETURNS TABLE(filingperiodid integer, filingperiodname character varying, description character varying, startdate date, enddate date, duedate timestamp without time zone, electioncycleid integer, electionstartdate date, electionenddate date, electionname character varying, itemthreshold numeric) 
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
	ec.start_date,
	ec.end_date,
	ec."name",
	fp.item_threshold
	from
	filing_period fp
	inner join election_cycle ec on ec.election_cycle_id = fp.election_cycle_id
	where fp.status_code='ACTIVE';
	
end
$BODY$;

ALTER FUNCTION public.get_filingperiodlist()
    OWNER TO devadmin;
