CREATE OR REPLACE FUNCTION public.get_committeebyid(
	_committeeid integer)
    RETURNS TABLE(committeeid integer, committeename character varying, officesought character varying, district character varying, electiondate date, candidatename text, status text) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
DECLARE contactid integer;
begin
SELECT candidate_contact_id INTO contactid FROM public.committee where committee_id = _committeeid;
return query
SELECT committee.committee_id, committee.name, offi."name", committee.district, 
election.election_date, concat(con.first_name ,' ', con.last_name) as candidate, upper(coalesce(committee.status_code, 'NEW')) as status_code
FROM public.committee committee 
LEFT JOIN public.type_lookups offi on committee.office_sought_id = offi.type_id and offi.lookup_type_code= 'OFF'and offi.status_code='ACTIVE'
LEFT JOIN public.election_cycle election on committee.election_cycle_id = election.election_cycle_id
INNER JOIN public.contact con on committee.candidate_contact_id = con.contact_id
WHERE committee.committee_id = _committeeid
ORDER BY committee.committee_id;
 end
$BODY$;

ALTER FUNCTION public.get_committeebyid(integer)
    OWNER TO devadmin;
