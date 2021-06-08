CREATE OR REPLACE FUNCTION public.get_committeecontactbyid(
	_committeeid integer)
    RETURNS TABLE(contactid integer, address1 character varying, address2 character varying, city character varying, state character varying, zip character varying, email character varying, phone character varying, altemail character varying, altphone character varying, campaignwebsite character varying) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
DECLARE contactid integer;
begin
--SELECT committee_contact_id INTO contactid FROM public.committee where committee_id = _committeeid;
return query
SELECT con.contact_id, con.address1, con.address2, con.city, st."desc",
con.zip, con.email, con.phone, con.altemail, con.altphone, com.campaign_website
FROM public.contact con 
LEFT JOIN public.committee com on con.contact_id= com.other_contact_id
LEFT JOIN public.states st on con.state_code= st.code
WHERE com.committee_id = _committeeid;
--ORDER BY con.contact_id;
 end
$BODY$;

ALTER FUNCTION public.get_committeecontactbyid(integer)
    OWNER TO devadmin;