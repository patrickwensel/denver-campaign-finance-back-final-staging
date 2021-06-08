-- FUNCTION: public.delete_feesettings(integer)

-- DROP FUNCTION public.delete_feesettings(integer);

CREATE OR REPLACE FUNCTION public.delete_feesettings(
	_fee_id integer)
    RETURNS integer
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
begin
 update public.fee_settings set status_code= 'DELETED' where feeid =_fee_id;
 update  public.fee_filer_type_mapping set status_code='DELETED'
 	where fee_id = _fee_id ;
 if found then --deleted successfully
  return 1;
 else
  return 0;
 end if;
end
$BODY$;

ALTER FUNCTION public.delete_feesettings(integer)
    OWNER TO devadmin;
