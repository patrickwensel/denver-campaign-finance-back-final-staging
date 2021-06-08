-- FUNCTION: public.get_officerlist(integer)

-- DROP FUNCTION public.get_officerlist(integer);

CREATE OR REPLACE FUNCTION public.get_officerlist(
	committeeid integer)
    RETURNS TABLE(contactid integer, firstname character varying, lastname character varying, organizationname character varying, address1 character varying, address2 character varying, city character varying, statecode character varying, state character varying, zip character varying, email character varying, phone character varying, occupation character varying, description character varying, rolename character varying) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
DECLARE filid integer;
begin

SELECT filer_id INTO filid FROM public.filer where entity_id = committeeid and entity_type = 'C';
  return query
  select off.contact_id, 
  off.first_name,
  off.last_name,
  off.org_name,
  off.address1,
  off.address2,
  off.city,
  off.state_code,
  s.desc,
  off.zip,
  off.email,
  off.phone,
  off.occupation,
  off.description,
  rle.role
  from public.contact_role_mapping crm
  inner join public.contact off  on off.contact_id = crm.contact_id
  inner join public.role rle 
  on rle.id = crm.role_type_id
  LEFT JOIN public.states s on off.state_code = s.code
  where crm.filer_id = filid and LOWER(off.status_code) = 'active'  and crm.status_code='ACTIVE'
   order by off.contact_id;
 end
$BODY$;

ALTER FUNCTION public.get_officerlist(integer)
    OWNER TO devadmin;
