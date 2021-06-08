CREATE OR REPLACE FUNCTION public.update_bankinfo(
	_committeeid integer,
	_bankname character varying,
	_address1 character varying,
	_address2 character varying,
	_city character varying,
	_statecode character varying,
	_zip character varying)
    RETURNS integer
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
begin
update public."committee" set bank_name=_bankname, bank_address1=_address1, 
bank_address2=_address2, bank_city=_city,  
bank_state_code=_statecode, bank_zip=_zip,created_by='Denver', updated_by='Denver',  updated_on=NOW()
 where "committee_id" = _committeeid;
 
  return _committeeid;
-- inserted fail retuns 0

end
$BODY$;

ALTER FUNCTION public.update_bankinfo(integer, character varying, character varying, character varying, character varying, character varying, character varying)
    OWNER TO devadmin;
