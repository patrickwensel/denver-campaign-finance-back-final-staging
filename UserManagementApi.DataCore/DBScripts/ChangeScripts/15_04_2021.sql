------------------------------------------Functions----------------------------------------

DROP FUNCTION public.get_signaturedetail(integer);

CREATE OR REPLACE FUNCTION public.get_signaturedetail(
	lobbyistid integer)
    RETURNS TABLE(firstName character varying, lastName character varying, email character varying, signature character varying) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
begin
  return query
  SELECT sign_first_name,
	   sign_last_name, 
	   sign_email, 
	   sign_image_url
	FROM public.lobbyist
		WHERE lobbysit_id = lobbyistid;
 end
$BODY$;

ALTER FUNCTION public.get_signaturedetail(integer)
    OWNER TO devadmin;
    -------------------------
    CREATE OR REPLACE FUNCTION public.get_committeecontactbyid(
	_committeeid integer)
    RETURNS TABLE(contactid integer, address1 character varying, address2 character varying, city character varying, state character varying, zip character varying, email character varying, phone character varying, campaignwebsite character varying) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
DECLARE contactid integer;
begin
SELECT committee_contact_id INTO contactid FROM public.committee where committee_id = _committeeid;
return query
SELECT con.contact_id, con.address1, con.address2, con.city, st."desc",
con.zip, con.email, con.phone, com.campaign_website
FROM public.contact con 
LEFT JOIN public.committee com on con.contact_id= com.committee_contact_id
LEFT JOIN public.states st on con.state_code= st.code
WHERE con.contact_id = contactid
ORDER BY con.contact_id;
 end
$BODY$;

ALTER FUNCTION public.get_committeecontactbyid(integer)
    OWNER TO devadmin;
-----------------------
CREATE OR REPLACE FUNCTION public.get_committeebyid(
	_committeeid integer)
    RETURNS TABLE(committeeid integer, committeename character varying, officesought character varying, district character varying, electiondate date, candidatename text) 
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
election.election_date, concat(con.first_name ,' ', con.last_name) as candidate
FROM public.committee committee 
LEFT JOIN public.type_lookups offi on committee.office_sought_id = offi.type_id
INNER JOIN public.election_cycle election on committee.election_cycle_id = election.election_cycle_id
INNER JOIN public.contact con on committee.candidate_contact_id = con.contact_id
WHERE committee.committee_id = _committeeid
ORDER BY committee.committee_id;
 end
$BODY$;

ALTER FUNCTION public.get_committeebyid(integer)
    OWNER TO devadmin;
----------------------
    CREATE OR REPLACE FUNCTION public.get_bankinfo(
	_committeeid integer)
    RETURNS TABLE(committeeid integer, bankname character varying, address1 character varying, address2 character varying, city character varying, statecode character varying, zip character varying) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
begin
  return query
  select 
  com.committee_id, 
  com.bank_name,
  com.bank_address1,
  com.bank_address2,
  com.bank_city,
  s.desc,
  com.bank_zip
  from public.committee com
  LEFT JOIN public.states s on com.bank_state_code = s.code
  where com.committee_id = _committeeid
   order by com.committee_id;
 end
$BODY$;

ALTER FUNCTION public.get_bankinfo(integer)
    OWNER TO devadmin;


    ----------------------------------------Functions------------------------------------