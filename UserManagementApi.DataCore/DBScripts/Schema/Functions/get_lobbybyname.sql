-- FUNCTION: public.get_lobbybyname(character varying)

-- DROP FUNCTION public.get_lobbybyname(character varying);

CREATE OR REPLACE FUNCTION public.get_lobbybyname(
	comname character varying)
    RETURNS TABLE(lobbyistid integer, year character varying, type character varying, firstname character varying, lastname character varying, organisationname character varying, address1 character varying, address2 character varying, city character varying, statecode character varying, zipcode character varying, phone character varying, email character varying, imageurl character varying) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
--DECLARE searchCommittee character varying(200);
begin
 
  return query
  SELECT lb.lobbysit_id,lb.year, lb.type,c.first_name, c.last_name, c.org_name ,
  c.address1,c.address2,c.city,c.state_code,c.zip,c.phone,c.email, 
lb.sign_image_url FROM public.lobbyist as lb
LEFT JOIN public.contact as c on lb.filer_contact_id = c.contact_id
		WHERE ((LOWER(c.first_name) LIKE '%' || '' || LOWER('a') || '' || '%'
			OR LOWER(c.last_name) LIKE '%' || '' || LOWER('a') || '' || '%')
			   AND (c.first_name !='' AND c.first_name IS NOT NULL))
		   ORDER BY c.first_name;
 end
$BODY$;

ALTER FUNCTION public.get_lobbybyname(character varying)
    OWNER TO devadmin;
