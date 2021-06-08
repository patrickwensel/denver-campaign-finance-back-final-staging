
-- DROP FUNCTION public.get_lobyyistcontactinfo(integer);

CREATE OR REPLACE FUNCTION public.get_lobyyistcontactinfo(
	lobbyistid integer)
    RETURNS TABLE(year character varying, orgtype character varying, orgname character varying, firstname character varying, lastname character varying, address1 character varying, address2 character varying, city character varying, statecode character varying, zipcode character varying, phoneno character varying, email character varying, statuscode text) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
begin
  return query
  SELECT l.year, 
		l.type,
		c.org_name,
		c.first_name,
		c.last_name,
		c.address1,
		c.address2,
		c.city,
		c.state_code,
		c.zip,
		c.phone,
		c.email,
		upper(coalesce(l.status_code, 'NEW')) as status_code
FROM public.lobbyist l
	INNER JOIN public.contact c ON l.filer_contact_id = c.contact_id
WHERE l.lobbysit_id = lobbyistid;
 end
$BODY$;
