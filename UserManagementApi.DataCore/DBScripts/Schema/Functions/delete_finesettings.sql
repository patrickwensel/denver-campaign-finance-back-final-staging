-- FUNCTION: public.delete_finesettings(integer)

-- DROP FUNCTION public.delete_finesettings(integer);

CREATE OR REPLACE FUNCTION public.delete_finesettings(
	_fineid integer)
    RETURNS integer
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
begin
 update public.fine_settings set status_code= 'DELETED' where fine_id =_fineid;
 update  public.fine_filer_type_mapping set status_code='DELETED'
 	where fine_id = _fineid ;
 if found then --deleted successfully
  return 1;
 else
  return 0;
 end if;
end
$BODY$;

ALTER FUNCTION public.delete_finesettings(integer)
    OWNER TO devadmin;
