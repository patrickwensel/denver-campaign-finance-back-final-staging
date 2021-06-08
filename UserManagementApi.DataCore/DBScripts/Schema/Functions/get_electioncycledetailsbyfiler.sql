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