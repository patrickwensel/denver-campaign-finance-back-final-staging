-- FUNCTION: public.delete_matchingdetails(integer)

-- DROP FUNCTION public.delete_matchingdetails(integer);

CREATE OR REPLACE FUNCTION public.delete_matchingdetails(
	_matchingid integer)
    RETURNS integer
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
begin
 delete from public.matchinglimits
 where MatchingId = _matchingid;
 if found then --deleted successfully
  return 1;
 else
  return 0;
 end if;
end
$BODY$;

ALTER FUNCTION public.delete_matchingdetails(integer)
    OWNER TO devadmin;
