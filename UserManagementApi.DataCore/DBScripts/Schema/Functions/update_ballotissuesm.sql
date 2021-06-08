-- FUNCTION: public.update_ballotissuesm(integer, character varying, character varying, character varying, character varying)

-- DROP FUNCTION public.update_ballotissuesm(integer, character varying, character varying, character varying, character varying);

CREATE OR REPLACE FUNCTION public.update_ballotissuesm(
	_ballot_issue_id integer,
	_ballot_issue_code character varying,
	_ballot_issue character varying,
	_election_cycle character varying,
	_description character varying)
    RETURNS integer
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
begin
 update public."ballot_issue_sm" set ballot_issue_code=_ballot_issue_code,  
 ballot_issue=_ballot_issue, election_cycle=_election_cycle, description=_description, 
 created_by='Denver', updated_by='Denver',  updated_on=NOW()
 where "ballot_issue_id" = _ballot_issue_id;
 return _ballot_issue_id;
end
$BODY$;

ALTER FUNCTION public.update_ballotissuesm(integer, character varying, character varying, character varying, character varying)
    OWNER TO devadmin;
