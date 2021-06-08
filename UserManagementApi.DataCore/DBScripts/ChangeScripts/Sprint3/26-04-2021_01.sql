----------------------------------------------------------Functions-----------------------------------------------------
DROP FUNCTION public.get_contactdetailsbyid(integer);

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

DROP FUNCTION public.get_contactbyname(integer, character varying, character varying);

CREATE OR REPLACE FUNCTION public.get_contactbyname(
	entityid integer,
	entitytype character varying,
	searchname character varying)
    RETURNS TABLE(contactid integer, fullname text, filerid integer) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
DECLARE _filerId int = 0;
begin
	
   SELECT filer_id INTO _filerId 
   FROM public.filer 
   	WHERE entity_id = entityId 
		AND entity_type = entityType;
   
  return query
  SELECT c.contact_id, 
		CASE WHEN c.contact_type = 'CON-I' THEN
			CASE WHEN CONCAT(c.middle_name, 'ZZZ') = 'ZZZ' THEN c.first_name || ' ' || c.last_name
				ELSE  c.first_name || ' ' || c.middle_name || ' ' || c.last_name
			END 
		ELSE
			text(c.org_name)
		END AS fName,
		crm.filer_id
	FROM public.contact_role_mapping crm
		INNER JOIN public.contact c ON crm.contact_id = c.contact_id
		INNER JOIN (SELECT "id" AS roleId FROM public.role 
					   WHERE role IN ('Payee', 
									  'Lender', 
									  'Contributor')) tr ON tr.roleId = crm.role_type_id
	WHERE crm.filer_id = _filerId
	 AND lower(crm.status_code) = 'active'
	 AND CONCAT(c.version_id, 'ZZZ') = 'ZZZ'
	 AND (lower(c.first_name) LIKE '%' || lower(searchName) || '%' OR
		  lower(c.last_name) LIKE '%' || lower(searchName) || '%' OR 
		  lower(c.org_name) LIKE '%' || lower(searchName) || '%')
	ORDER BY 1 DESC
	LIMIT 5;

 end
$BODY$;

ALTER FUNCTION public.get_contactbyname(integer, character varying, character varying)
    OWNER TO devadmin;


----------------------------------------------------------Functions-----------------------------------------------------
----------------------------------------------------------Alter Table Scripts-----------------------------------------------------
	
ALTER TABLE public.contact 
ADD COLUMN version_id integer;
	
----------------------------------------------------------Alter Table Scripts-----------------------------------------------------
