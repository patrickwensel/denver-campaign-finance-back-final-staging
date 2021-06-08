CREATE OR REPLACE FUNCTION public.save_issuecommittee(
	_name character varying,
	_committeetypeid character varying,
	_ballotissueid integer,
	_electioncycleid integer,
	_position character varying,
	_purpose character varying,
	_registrationstatus character varying,
	_committeeid integer)
    RETURNS integer
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
DECLARE id int = 0;
begin
if (_committeeid) > 0 then
 update public."committee" set "name"=_name, typeid=_committeetypeid, ballot_issue_id=_ballotissueid, 
 election_cycle_id=_electioncycleid,
"position"=_position, purpose=_purpose,
created_by='Denver', updated_by='Denver',  updated_on=NOW()
 where "committee_id" = _committeeid;
 return _committeeid;
else
 insert into public."committee" ("name", "typeid", "ballot_issue_id", "election_cycle_id", "position", "purpose", "registration_status", "created_by", "created_at", "updated_by", "updated_on")
 values(_name, _committeetypeid, _ballotissueid, _electioncycleid, _position, _purpose, _registrationstatus, 'Denver', localtimestamp, 'Denver', localtimestamp);
  IF EXISTS (SELECT ballot_issue_id FROM public.ballot_issue_sm where ballot_issue_id=_ballotissueid) THEN
  		 update  public.ballot_issue_sm set cmtflag =1 where ballot_issue_id=_ballotissueid;
 	 	END IF;
  return (SELECT LASTVAL());
end if;

end
$BODY$;

ALTER FUNCTION public.save_issuecommittee(character varying, character varying, integer, integer, character varying, character varying, character varying, integer)
    OWNER TO devadmin;
