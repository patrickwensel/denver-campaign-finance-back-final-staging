CREATE OR REPLACE FUNCTION public.get_bankinfo(
	_committeeid integer)
    RETURNS TABLE(committeeid integer, bankname character varying, address1 character varying, address2 character varying, city character varying, statecode character varying, zip character varying) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
begin
  return query
  select 
  com.committee_id, 
  com.bank_name,
  com.bank_address1,
  com.bank_address2,
  com.bank_city,
  s.desc,
  com.bank_zip
  from public.committee com
  LEFT JOIN public.states s on com.bank_state_code = s.code
  where com.committee_id = _committeeid
   order by com.committee_id;
 end
$BODY$;

ALTER FUNCTION public.get_bankinfo(integer)
    OWNER TO devadmin;
