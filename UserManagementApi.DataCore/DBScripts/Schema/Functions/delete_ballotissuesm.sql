-- FUNCTION: public.delete_ballotissuesm(integer)

-- DROP FUNCTION public.delete_ballotissuesm(integer);

CREATE OR REPLACE FUNCTION public.delete_ballotissuesm(
	ballotissueid integer)
    RETURNS integer
begin
 delete from public."ballot_issue_sm"
 where "ballot_issue_id" = ballotissueid;
 if found then --deleted successfully
  return 1;
 else
  return 0;
 end if;
end
$BODY$;

ALTER FUNCTION public.delete_ballotissuesm(integer)
    OWNER TO devadmin;
