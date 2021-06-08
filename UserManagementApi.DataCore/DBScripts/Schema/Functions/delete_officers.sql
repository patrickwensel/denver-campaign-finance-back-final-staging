

CREATE OR REPLACE FUNCTION public.delete_officers(
	_contactid integer)
    RETURNS integer
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
begin
	update public."contact" set 
	status_code='Delete'
 	where "contact_id" = _contactid;
 	if found then --deleted successfully
 	return 1;
 	else
  	return 0;
 	end if;
end
$BODY$;

