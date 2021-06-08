-- FUNCTION: public.delete_contributionlimits(integer)

-- DROP FUNCTION public.delete_contributionlimits(integer);

CREATE OR REPLACE FUNCTION public.delete_contributionlimits(
	_id integer)
    RETURNS integer
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
begin
 delete from public."contribution_limits"
 where "id" = _id;
 if found then --deleted successfully
  return 1;
 else
  return 0;
 end if;
end
$BODY$;

ALTER FUNCTION public.delete_contributionlimits(integer)
    OWNER TO devadmin;
