-- FUNCTION: public.save_ballotissuesm(character varying, character varying, character varying, character varying)

-- DROP FUNCTION public.save_ballotissuesm(character varying, character varying, character varying, character varying);

CREATE OR REPLACE FUNCTION public.save_ballotissuesm(
	ballotissuecode character varying,
	ballotissue character varying,
	electioncycle character varying,
	_description character varying)
    RETURNS integer
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
DECLARE ballotissueid int = 0;
begin

	-- SELECT id = nextval(' ballot_issue_id');
	
	INSERT INTO public.ballot_issue_sm(ballot_issue_code, ballot_issue,
    created_by,
    created_at,
    updated_by,
    updated_on,
    election_cycle,description, cmtflag)
	VALUES (ballotissuecode, ballotissue,
			'Denver', NOW(), 'Denver',
			NOW(),
			electioncycle,_description,0);
			
	INSERT INTO public.ballot_issue(ballot_issue_code, ballot_issue,
    created_by,
    created_at,
    updated_by,
    updated_on,
	sequence_no,
	isactive,
    election_date,
	election_cycle)
	VALUES (ballotissuecode, ballotissue,
			'Denver', NOW(), 'Denver',
			NOW(),
			1,'true',NOW(),electioncycle);
			
			
		
			
	-- SELECT CURRVAL('ballot_issue_id') INTO ballotissueid;
	-- if found then --inserted successfully
	 -- 	return ballotissueid;
	-- else 
		return 1; -- inserted fail
	--end if;

end
$BODY$;

ALTER FUNCTION public.save_ballotissuesm(character varying, character varying, character varying, character varying)
    OWNER TO devadmin;
