-- FUNCTION: public.get_officerbyname(character varying, integer)

-- DROP FUNCTION public.get_officerbyname(character varying, integer);

CREATE OR REPLACE FUNCTION public.get_officerbyname(
	_officername character varying,
	_committeeid integer)
    RETURNS TABLE(contactid integer, firstname character varying, lastname character varying, organizationname character varying, address1 character varying, address2 character varying, city character varying, state character varying, zip character varying, email character varying, phone character varying, occupation character varying, description character varying, role character varying, filerid integer) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
DECLARE ComTypeId integer;

begin
  return query
  select off.contact_id, 
  off.first_name,
  off.last_name,
  off.org_name,
  off.address1,
  off.address2,
  off.city,
  s.desc,
  off.zip,
  off.email,
  off.phone,
  off.occupation,
  off.description,
  rle.role,
  crm.filer_id
  
  from public.contact off 
  inner join public.contact_role_mapping crm
   on off.contact_id = crm.contact_id
  inner join public.filer fil 
  on crm.filer_id =fil.entity_id
  inner join public.role rle 
  on rle.id = crm.role_type_id
  LEFT JOIN public.states s on off.state_code = s.code
  LEFT JOIN public.committee cm on cm.treasurer_contact_id = off.contact_id
  WHERE (LOWER(off.first_name) LIKE '%' || '' || LOWER(_officername) || '' || '%' OR
LOWER(off.last_name) LIKE '%' || '' || LOWER(_officername) || '' || '%') 
and cm.committee_id =  _committeeid
  and fil.entity_type= 'COMMITTEE' and off.status_code = 'Active'  and crm.status_code='ACTIVE'
   order by off.contact_id;  

 end
$BODY$;

ALTER FUNCTION public.get_officerbyname(character varying, integer)
    OWNER TO devadmin;
