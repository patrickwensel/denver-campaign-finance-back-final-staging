------------------------------------------Functions----------------------------------------

DROP FUNCTION public.get_lobbyistentities(integer, character varying);

CREATE OR REPLACE FUNCTION public.get_lobbyistentities(
	lobbyistentityid integer,
	roletype character varying)
    RETURNS TABLE(contactid integer, firstname text, middlename text, lastname text, fullname text, phoneno text, emailid text, contacttype text, orgname text, lobfullName text, employeeid integer, natureofbusiness text, legislativematters text, address1 text, address2 text, city text, statecode text, zipcode text, officialname text, officialtitle text, relationship text, entityname text) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
DECLARE roleTypeId integer;
DECLARE filerId1 integer;
begin

  SELECT id into roleTypeId 
  FROM public.role 
  	WHERE role = roleType;

	SELECT filer_contact_id INTO filerId1 FROM public.lobbyist WHERE lobbysit_id = lobbyistentityid;
	
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
			'' as lobfullName,
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
		FROM contact_role_mapping crm
			INNER JOIN contact c  ON crm.contact_id = c.contact_id
		WHERE crm.role_type_id = roleTypeId
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
			'' as lobfullName,
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
 		FROM contact_role_mapping crm
 			INNER JOIN contact c ON crm.contact_id = c.contact_id
 		WHERE crm.role_type_id = roleTypeId
			AND crm.filer_id = filerId1
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
			CASE WHEN CONCAT(cl.middle_name, 'ZZZ') = 'ZZZ' THEN cl.first_name || ' ' || cl.last_name
				ELSE  cl.first_name || ' ' || cl.middle_name || ' ' || cl.last_name
			END as lobfullName,
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
		FROM public.contact_role_mapping crm
			INNER JOIN  public.contact c ON crm.contact_id = c.contact_id
			INNER JOIN  public.lobbyist_client lc ON c.contact_id = lc.contact_id
			LEFT JOIN  public.contact cl ON lc.employee_id = cl.contact_id
		WHERE crm.role_type_id = roleTypeId
			AND crm.filer_id = filerId1
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
			CASE WHEN CONCAT(cl.middle_name, 'ZZZ') = 'ZZZ' THEN cl.first_name || ' ' || cl.last_name
				ELSE  cl.first_name || ' ' || cl.middle_name || ' ' || cl.last_name
			END as lobfullName,
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
		FROM public.contact_role_mapping crm
				INNER JOIN  public.contact c ON crm.contact_id = c.contact_id
				INNER JOIN  public.lobbyist_relationship lr ON c.contact_id = lr.contact_id
				INNER JOIN  public.contact cl ON lr.employee_id = cl.contact_id
			WHERE crm.role_type_id = roleTypeId
				AND crm.filer_id = filerId1
				AND lr.status_code = 'ACTIVE';
	end if;
 end
$BODY$;

ALTER FUNCTION public.get_lobbyistentities(integer, character varying)
    OWNER TO devadmin;
	
----------------------------------------Functions------------------------------------