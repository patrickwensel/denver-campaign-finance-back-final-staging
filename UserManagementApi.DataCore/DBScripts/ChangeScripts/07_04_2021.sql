
﻿------------------------------------------Functions----------------------------------------


-- FUNCTION: public.get_committeebyname(character varying, character varying)

-- DROP FUNCTION public.get_committeebyname(character varying, character varying);

CREATE OR REPLACE FUNCTION public.get_committeebyname(
	comname character varying,
	comtype character varying)
    RETURNS TABLE(committeeid integer, committeename character varying) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
DECLARE ComTypeId integer;

begin

SELECT committetypeid INTO ComTypeId FROM public.committee_type WHERE committetypename = comtype;
 IF  (comtype='All') THEN
 -- All Committee Type
 
return query
SELECT committee.committee_id, committee.name 
FROM public.committee
WHERE LOWER(committee.name) LIKE '%' || '' || LOWER(comName) || '' || '%'  
ORDER BY committee.committee_id;

ELSE
-- Selected Committee Type
return query
SELECT committee.committee_id, committee.name
FROM public.committee  
WHERE LOWER(committee.name) LIKE '%' || '' || LOWER(comName) || '' || '%' 
AND committee.typeid = ComTypeId
ORDER BY committee.committee_id;
END IF;
 end
$BODY$;

ALTER FUNCTION public.get_committeebyname(character varying, character varying)
    OWNER TO devadmin;




---------------------------------------Functions-----------------------------------------------

CREATE OR REPLACE FUNCTION public.get_lobbyistentitiesbyname(
	lobbyistentityid integer,
	lobbyistsearchname character varying,
	roletype character varying)
    RETURNS TABLE(contactid integer, firstname text, middlename text, lastname text, fullname text, phoneno text, emailid text, contacttype text, orgname text, lobbysitid integer, employeeid integer, natureofbusiness text, legislativematters text, address1 text, address2 text, city text, statecode text, zipcode text, officialname text, officialtitle text, relationship text, entityname text) 

    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$

begin
 IF  (comtype='All') THEN
 -- All Committee Type
 
return query
SELECT committee.committee_id, committee.name ,committee_type.committetypename
FROM public.committee  inner join committee_type  on committee.typeid = committee_type.committetypeid
WHERE LOWER(committee.name) LIKE '%' || '' || LOWER(comName) || '' || '%'  
ORDER BY committee.committee_id;

ELSE
-- Selected Committee Type
return query
SELECT committee.committee_id, committee.name ,committee_type.committetypename
FROM public.committee  inner join committee_type  on committee.typeid = committee_type.committetypeid
WHERE LOWER(committee.name) LIKE '%' || '' || LOWER(comName) || '' || '%' 
AND LOWER(committee_type.committetypename) LIKE '%' || '' || LOWER(comtype) || '' || '%'
ORDER BY committee.committee_id;
END IF;
 end
$BODY$;

ALTER FUNCTION public.get_committeebyname(character varying, character varying)
    OWNER TO devadmin;



----------------------------------------Functions------------------------------------

DECLARE roleTypeId integer;
DECLARE filerId1 integer;
DECLARE filerId2 integer;
DECLARE filerId3 integer;
DECLARE filerId4 integer;
begin

  SELECT id into roleTypeId 
  FROM public.role 
  	WHERE role = roleType;
  
--   SELECT filer_id into filerId1 
--   FROM public.filer 
--   	WHERE entity_id = lobbyistEntityId
-- 	 	AND entity_type = 'LOBBYIST';

	SELECT filer_contact_id INTO filerId1 FROM public.lobbyist WHERE lobbysit_id = lobbyistentityid;

	filerId2 = filerId1;
	filerId3 = filerId1;
	filerId4 = filerId1;
	
	if roleType = 'Lobbyist Employee' then
		return query	
		SELECT c.contact_id as contactId,
			text(c.first_name) as firstName,
			text(c.middle_name) as middleName,
			text(c.last_name) as lastName,
			CASE WHEN CONCAT(c.middle_name, 'ZZZ') = 'ZZZ' THEN c.first_name || ' ' || c.last_name
				ELSE  c.first_name || ' ' || c.middle_name || ' ' || c.last_name
			END as fullName,
			text(c.phone) as phoneNo,
			text(c.email) as emailId,
			text(c.contact_type) as contactType,
			'' as orgName,
			0 lobbysitId,
			0 employeeId,
			'' as natureOfBusiness,
			'' as legislativeMatters,
			'' as address1,
			'' as address2,
			'' as city,
			'' as stateCode,
			'' as zipCode,
			'' as officialName,
			'' as officialTitle,
			'' as relationship,
			'' as entityName
		FROM contact c
			INNER JOIN contact_role_mapping crm  ON c.contact_id = crm.contact_id
		WHERE crm.role_type_id = roleTypeId
		AND (LOWER(c.first_name) LIKE '%' || '' || LOWER(lobbyistsearchname) || '' || '%' OR 
LOWER(c.org_name) LIKE '%' || '' || LOWER(lobbyistsearchname) || '' || '%' OR 
LOWER(c.last_name) LIKE '%' || '' || LOWER(lobbyistsearchname) || '' || '%')
			AND crm.filer_id = filerId1
			AND c.status_code = 'ACTIVE';
	elsif roleType = 'Lobbyist Subcontractor' then
		return query
 		SELECT c.contact_id as contactId,
 			text(c.first_name) as firstName,
 			text(c.middle_name) as middleName,
 			text(c.last_name) as lastName,
 			CASE WHEN CONCAT(c.middle_name, 'ZZZ') = 'ZZZ' THEN c.first_name || ' ' || c.last_name
 				ELSE  c.first_name || ' ' || c.middle_name || ' ' || c.last_name
 			END as fullName,
 			text(c.phone) as phoneNo,
 			text(c.email) as emailId,
 			text(c.contact_type) as contactType,
 			'' as orgName,
 			0 lobbysitId,
 			0 employeeId,
 			'' as natureOfBusiness,
 			'' as legislativeMatters,
 			'' as address1,
 			'' as address2,
 			'' as city,
 			'' as stateCode,
 			'' as zipCode,
			'' as officialName,
 			'' as officialTitle,
 			'' as relationship,
 			'' as entityName
 		FROM contact c
 			INNER JOIN contact_role_mapping crm  ON c.contact_id = crm.contact_id
 		WHERE crm.role_type_id = roleTypeId
	AND (LOWER(c.first_name) LIKE '%' || '' || LOWER(lobbyistsearchname) || '' || '%' OR 
LOWER(c.org_name) LIKE '%' || '' || LOWER(lobbyistsearchname) || '' || '%' OR 
LOWER(c.last_name) LIKE '%' || '' || LOWER(lobbyistsearchname) || '' || '%')
			AND crm.filer_id = filerId2
			AND c.status_code = 'ACTIVE';
	elsif  roleType = 'Lobbyist Client' then
		return query
		SELECT c.contact_id as contactId,
			text(c.first_name) as firstName,
			text(c.middle_name) as middleName,
			text(c.last_name) as lastName,
			CASE WHEN CONCAT(c.middle_name, 'ZZZ') = 'ZZZ' THEN c.first_name || ' ' || c.last_name
				ELSE  c.first_name || ' ' || c.middle_name || ' ' || c.last_name
			END as fullName,
			text(c.phone) as phoneNo,
			text(c.email) as emailId,
			text(c.contact_type) as contactType,
			text(c.org_name) as orgName,
			l.lobbysit_id as lobbysitId,
			lc.employee_id as employeeId,
			text(lc.nature_of_business) as natureOfBusiness,
			text(lc.legislative_matters) as legislativeMatters,
			text(c.address1) as address1,
			text(c.address2) as address2,
			text(c.city) as city,
			text(c.state_code) as stateCode,
			text(c.zip) as zipCode,
			'' as officialName,
			'' as officialTitle,
			'' as relationship,
			'' as entityName
		FROM public.lobbyist l
			INNER JOIN  public.lobbyist_client lc ON l.lobbysit_id = lc.employee_id
			INNER JOIN  public.contact c ON c.contact_id = lc.contact_id
			INNER JOIN  public.contact_role_mapping crm ON c.contact_id = crm.contact_id
		WHERE l.lobbysit_id = lobbyistEntityId
		AND (LOWER(c.first_name) LIKE '%' || '' || LOWER(lobbyistsearchname) || '' || '%' OR 
LOWER(c.org_name) LIKE '%' || '' || LOWER(lobbyistsearchname) || '' || '%' OR 
LOWER(c.last_name) LIKE '%' || '' || LOWER(lobbyistsearchname) || '' || '%')
			AND crm.role_type_id = roleTypeId
			AND crm.filer_id = filerId3
			AND lc.status_code = 'ACTIVE';
	elsif roleType = 'Lobbyist Relationship' then
		return query
		SELECT c.contact_id as contactId,
			text(c.first_name) as firstName,
			text(c.middle_name) as middleName,
			text(c.last_name) as lastName,
			CASE WHEN CONCAT(c.middle_name, 'ZZZ') = 'ZZZ' THEN c.first_name || ' ' || c.last_name
				ELSE  c.first_name || ' ' || c.middle_name || ' ' || c.last_name
			END as fullName,
			'' as phoneNo,
			'' as emailId,
			'' as contactType,
			'' orgName,
			l.lobbysit_id as lobbysitId,
			lr.employee_id as employeeId,
			'' as natureOfBusiness,
			'' as legislativeMatters,
			'' as address1,
			'' as address2,
			'' as city,
			'' as stateCode,
			'' as zipCode,
			text(lr.official_name) as officialName,
			text(lr.official_title) as officialTitle,
			text(lr.relationship) as relationship,
			text(lr.entity_name) as entityName
		FROM public.lobbyist l
				INNER JOIN  public.lobbyist_relationship lr ON l.lobbysit_id = lr.employee_id
				INNER JOIN  public.contact c ON c.contact_id = lr.contact_id
				INNER JOIN  public.contact_role_mapping crm ON c.contact_id = crm.contact_id
			WHERE l.lobbysit_id = lobbyistEntityId
			AND (LOWER(c.first_name) LIKE '%' || '' || LOWER(lobbyistsearchname) || '' || '%' OR 
LOWER(c.org_name) LIKE '%' || '' || LOWER(lobbyistsearchname) || '' || '%' OR 
LOWER(c.last_name) LIKE '%' || '' || LOWER(lobbyistsearchname) || '' || '%')
				AND crm.role_type_id = roleTypeId
				AND crm.filer_id = filerId4
				AND lr.status_code = 'ACTIVE';
	end if;
 end
$BODY$;

ALTER FUNCTION public.get_lobbyistentitiesbyname(integer, character varying, character varying)
    OWNER TO devadmin;


	---------------------------------------Functions-----------------------------------------------