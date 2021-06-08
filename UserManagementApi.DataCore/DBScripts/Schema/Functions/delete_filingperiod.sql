-- FUNCTION: public.delete_filingperiod(integer)

-- DROP FUNCTION public.delete_filingperiod(integer);

CREATE OR REPLACE FUNCTION public.delete_filingperiod(
	_filingperiodid integer)
    RETURNS integer
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
begin
 update  public.filing_period set status_code='DELETED'
 where filing_period_id = _filingperiodid;
  update  public.filing_period_filer_type_mapping set status_code='DELETED'
 where filing_period_id = _filingperiodid;
 if found then --deleted successfully
  return 1;
 else
  return 0;
 end if;
end
$BODY$;

ALTER FUNCTION public.delete_filingperiod(integer)
    OWNER TO devadmin;
