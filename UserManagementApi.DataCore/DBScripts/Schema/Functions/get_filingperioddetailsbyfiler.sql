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