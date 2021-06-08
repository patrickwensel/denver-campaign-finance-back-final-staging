-- FUNCTION: public.get_contactdetailsbyid(integer)

-- DROP FUNCTION public.get_contactdetailsbyid(integer);

CREATE OR REPLACE FUNCTION public.get_contactdetailsbyid(
	_contactid integer)
    RETURNS TABLE(contacttype character varying, firstname character varying, middlename character varying, lastname character varying, orgname character varying, occupation character varying, voterid character varying, address1 character varying, address2 character varying, city character varying, statecode character varying, zipcode character varying) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
begin
  return query
  SELECT c.contact_type,
  			c.first_name,
			c.middle_name,
			c.last_name,
			c.org_name,
			c.occupation,
			c.voter_id,
			c.address1,
			c.address2,
			c.city,
			c.state_code,
			c.zip
	FROM public.contact c
	WHERE c.contact_id = _contactId;
 end
$BODY$;

ALTER FUNCTION public.get_contactdetailsbyid(integer)
    OWNER TO devadmin;
