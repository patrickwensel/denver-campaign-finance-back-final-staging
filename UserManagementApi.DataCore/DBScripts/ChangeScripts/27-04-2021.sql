----------------------------------------------Functions-----------------------------------
-- FUNCTION: public.save_contactrolemapping(integer, integer, integer)

-- DROP FUNCTION public.save_contactrolemapping(integer, integer, integer);

CREATE OR REPLACE FUNCTION public.save_contactrolemapping(
	_userid integer,
	_contactid integer,
	_filerid integer)
    RETURNS integer
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
DECLARE roleid integer;
begin
SELECT id INTO roleid FROM public.role where role = 'Candidate';
insert into public."contact_role_mapping" ("user_id", "contact_id", "filer_id", "role_type_id", "created_by", "created_at", "updated_by", "updated_on", "status_code")
 values(_userid, _contactid, _filerid, roleid, _userid, localtimestamp, _userid, localtimestamp, 'ACTIVE');
  return (SELECT LASTVAL());
-- inserted fail retuns 0

end
$BODY$;

ALTER FUNCTION public.save_contactrolemapping(integer, integer, integer)
    OWNER TO devadmin;
--------------------------
-- FUNCTION: public.save_contactrolemappingie(integer, integer)

-- DROP FUNCTION public.save_contactrolemappingie(integer, integer);

CREATE OR REPLACE FUNCTION public.save_contactrolemappingie(
	_contactid integer,
	_filerid integer)
    RETURNS integer
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
DECLARE roleid integer;
DECLARE uid integer;
begin
SELECT id INTO roleid FROM public.role where role = 'Other User';
SELECT user_id INTO uid FROM public.user_account where contact_id = _contactid;
insert into public."contact_role_mapping" ("user_id", "contact_id", "filer_id", "role_type_id", "created_by", "created_at", "updated_by", "updated_on", "status_code")
 values(uid, _contactid, _filerid, roleid, 'Denver', localtimestamp, 'Denver', localtimestamp, 'ACTIVE');
  return (SELECT LASTVAL());
-- inserted fail retuns 0

end
$BODY$;

ALTER FUNCTION public.save_contactrolemappingie(integer, integer)
    OWNER TO devadmin;
--------------------------------------
-- FUNCTION: public.save_contactrolemappinglobby(integer, integer)

-- DROP FUNCTION public.save_contactrolemappinglobby(integer, integer);

CREATE OR REPLACE FUNCTION public.save_contactrolemappinglobby(
	_contactid integer,
	_filerid integer)
    RETURNS integer
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
DECLARE roleid integer;
DECLARE uid integer;
begin
SELECT id INTO roleid FROM public.role where role = 'Primary Registering Lobbyist';
SELECT user_id INTO uid FROM public.user_account where contact_id = _contactid;
insert into public."contact_role_mapping" ("user_id", "contact_id", "filer_id", "role_type_id", "created_by", "created_at", "updated_by", "updated_on", "status_code")
 values(uid, _contactid, _filerid, roleid, 'Denver', localtimestamp, 'Denver', localtimestamp, 'ACTIVE');
  return (SELECT LASTVAL());
-- inserted fail retuns 0

end
$BODY$;

ALTER FUNCTION public.save_contactrolemappinglobby(integer, integer)
    OWNER TO devadmin;
---------------------------
-- FUNCTION: public.save_contactrolemappingofficer(integer, integer, integer)

-- DROP FUNCTION public.save_contactrolemappingofficer(integer, integer, integer);

CREATE OR REPLACE FUNCTION public.save_contactrolemappingofficer(
	_userid integer,
	_contactid integer,
	_committeeid integer)
    RETURNS integer
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
DECLARE roleid integer;
DECLARE filid integer;
begin

SELECT id INTO roleid FROM public.role where role = 'Officer';
SELECT filer_id INTO filid FROM public.filer where entity_id = _committeeid and entity_type = 'C';

insert into public."contact_role_mapping" ("user_id", "contact_id", "filer_id", "role_type_id", "created_by", "created_at", "updated_by", "updated_on", "status_code")
 values(_userid, _contactid, filid, roleid, 'Denver', localtimestamp, 'Denver', localtimestamp, 'ACTIVE');
  return (SELECT LASTVAL());
-- inserted fail retuns 0

end
$BODY$;

ALTER FUNCTION public.save_contactrolemappingofficer(integer, integer, integer)
    OWNER TO devadmin;
--------------------------
-- FUNCTION: public.save_contactrolemappingtreasuree(integer, integer)

-- DROP FUNCTION public.save_contactrolemappingtreasuree(integer, integer);

CREATE OR REPLACE FUNCTION public.save_contactrolemappingtreasuree(
	_contactid integer,
	_filerid integer)
    RETURNS integer
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
DECLARE roleid integer;
DECLARE uid integer;
begin
	SELECT id INTO roleid 
		FROM public.role where role = 'Treasurer';
	
	SELECT user_id INTO uid 
	FROM public.user_account where contact_id = _contactid;

	insert into public."contact_role_mapping" ("user_id", "contact_id", 
											   "filer_id", "role_type_id", 
											   "created_by", "created_at", 
											   "updated_by", "updated_on", "status_code")
 	values(uid, _contactid, 
		   _filerid, roleid, 
		   'Denver', localtimestamp, 
		   'Denver', localtimestamp, 'ACTIVE');
  return (SELECT LASTVAL());
-- inserted fail retuns 0

end
$BODY$;

ALTER FUNCTION public.save_contactrolemappingtreasuree(integer, integer)
    OWNER TO devadmin;
    -----------------------------------
    -- FUNCTION: public.get_currentuserfilers(integer, character varying)

-- DROP FUNCTION public.get_currentuserfilers(integer, character varying);

CREATE OR REPLACE FUNCTION public.get_currentuserfilers(
	_entityid integer,
	_entitytype character varying)
    RETURNS TABLE(contactid integer, filerid integer, userid integer, firstname character varying, lastname character varying, email character varying, userrole character varying, permissions text) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
DECLARE filerIdVal int = 0;
DECLARE userIdVal int = 0;
begin

SELECT filer_id INTO filerIdVal FROM public.filer   
WHERE entity_id=_entityid and entity_type = _entitytype;
return query
  	
select c.contact_id,
crm.filer_id,
ua.user_id,
c.first_name,
c.last_name,
c.email,
rl.role ,
'' as permissions
from contact_role_mapping crm
inner join contact c on crm.contact_id=c.contact_id 
inner join role rl on rl.id = crm.role_type_id
inner join user_account ua on ua.user_id = crm.user_id
where   crm.filer_id=filerIdVal  and ua.user_id !=0 
and upper(c.status_code) = 'ACTIVE' and upper(crm.status_code) = 'ACTIVE' 
order by c.contact_id desc;
end
$BODY$;

ALTER FUNCTION public.get_currentuserfilers(integer, character varying)
    OWNER TO devadmin;
    ------------------------------
    -- FUNCTION: public.get_employees(integer)

-- DROP FUNCTION public.get_employees(integer);

CREATE OR REPLACE FUNCTION public.get_employees(
	lobbyistentityid integer)
    RETURNS TABLE(contactid integer, contacttype character varying, firstname character varying, middlename character varying, lastname character varying, fullname text, phoneno character varying, emailid character varying) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
DECLARE roleTypeId int = 0;
DECLARE filerId int = 0;
begin

  SELECT id into roleTypeId FROM public.role WHERE role = 'Lobbyist Employee';
  
  SELECT filer_id into filerId 
  FROM public.filer 
  	WHERE entity_id = lobbyistEntityId
		AND entity_type = 'LOBBYIST';
  
  return query
  SELECT c.contact_id,
		c.contact_type,
		c.first_name,
		c.middle_name,
		c.last_name,
		CASE WHEN CONCAT(c.middle_name, 'ZZZ') = 'ZZZ' THEN c.first_name || ' ' || c.last_name
			ELSE  c.first_name || ' ' || c.middle_name || ' ' || c.last_name
		END as fName,
		c.phone,
		c.email
	FROM contact c
		INNER JOIN contact_role_mapping crm  ON c.contact_id = crm.contact_id
	WHERE crm.role_type_id = roleTypeId
		AND crm.filer_id = filerId
		AND c.status_code = 'ACTIVE'
		AND crm.status_code = 'ACTIVE';
 end
$BODY$;

ALTER FUNCTION public.get_employees(integer)
    OWNER TO devadmin;
-----------------------------------------

-- FUNCTION: public.get_independentspender(integer)

-- DROP FUNCTION public.get_independentspender(integer);

CREATE OR REPLACE FUNCTION public.get_independentspender(
	_ieid integer)
    RETURNS TABLE(contactid integer, employeetype character varying, employeename text) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
begin
return query
SELECT DISTINCT c.contact_id,
rl.role as entity_type,
concat(c.first_name, ' ', c.last_name)  as name
FROM contact_role_mapping crm
INNER JOIN contact c  ON c.contact_id = crm.contact_id
INNER JOIN role rl on  rl.id = crm.role_type_id and role = 'Other User'
INNER JOIN filer fil on  fil.entity_id = c.contact_id AND entity_type = 'IE'
WHERE crm.status_code = 'ACTIVE';
		

end
$BODY$;

ALTER FUNCTION public.get_independentspender(integer)
    OWNER TO devadmin;
-----------------------------
-- FUNCTION: public.get_lobbyistentities(integer, character varying)

-- DROP FUNCTION public.get_lobbyistentities(integer, character varying);

CREATE OR REPLACE FUNCTION public.get_lobbyistentities(
	lobbyistentityid integer,
	roletype character varying)
    RETURNS TABLE(contactid integer, firstname text, middlename text, lastname text, fullname text, phoneno text, emailid text, contacttype text, orgname text, lobfullname text, employeeid integer, natureofbusiness text, legislativematters text, address1 text, address2 text, city text, statecode text, zipcode text, officialname text, officialtitle text, relationship text, entityname text) 
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
			CASE WHEN c.contact_type = 'I' OR  c.contact_type = 'LOB-I' THEN 'Individual'
				WHEN c.contact_type = 'O' OR  c.contact_type = 'LOB-O' THEN 'Organization'
			  ELSE ''
			END as contactType,
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
			AND lower(coalesce(c.status_code, 'deleted')) != 'deleted'
			AND crm.status_code = 'ACTIVE';
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
 			CASE WHEN c.contact_type = 'I' OR  c.contact_type = 'LOB-I' THEN 'Individual'
				WHEN c.contact_type = 'O' OR  c.contact_type = 'LOB-O' THEN 'Organization'
			  ELSE ''
			END as contactType,
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
			AND lower(coalesce(c.status_code, 'deleted')) != 'deleted'
			AND crm.status_code = 'ACTIVE';
			--AND lower(coalesce(c.status_code, 'active')) = 'active';
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
			CASE WHEN c.contact_type = 'I' OR  c.contact_type = 'LOB-I' THEN 'Individual'
				WHEN c.contact_type = 'O' OR  c.contact_type = 'LOB-O' THEN 'Organization'
			  ELSE ''
			END as contactType,
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
			AND lower(coalesce(lc.status_code, 'deleted')) != 'deleted'
			AND crm.status_code = 'ACTIVE';
			--AND lower(coalesce(lc.status_code, 'active')) = 'active';
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
				AND lower(coalesce(lr.status_code, 'deleted')) != 'deleted'
				AND crm.status_code = 'ACTIVE';
				--AND lower(coalesce(lr.status_code, 'active')) = 'active';
	end if;
 end
$BODY$;

ALTER FUNCTION public.get_lobbyistentities(integer, character varying)
    OWNER TO devadmin;
------------------------------------------
-- FUNCTION: public.get_lobbyistentitiesbyname(integer, character varying, character varying)

-- DROP FUNCTION public.get_lobbyistentitiesbyname(integer, character varying, character varying);

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
			AND c.status_code = 'ACTIVE'
			AND crm.status_code = 'ACTIVE';
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
			AND c.status_code = 'ACTIVE'
			AND crm.status_code = 'ACTIVE';
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
			AND lc.status_code = 'ACTIVE'
			AND crm.status_code = 'ACTIVE';
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
				AND lr.status_code = 'ACTIVE'
				AND crm.status_code = 'ACTIVE';
	end if;
 end
$BODY$;

ALTER FUNCTION public.get_lobbyistentitiesbyname(integer, character varying, character varying)
    OWNER TO devadmin;
---------------------------------------

-- FUNCTION: public.get_managefilers()

-- DROP FUNCTION public.get_managefilers();

CREATE OR REPLACE FUNCTION public.get_managefilers(
	)
    RETURNS TABLE(filerid integer, filertype text, comtype character varying, filername character varying, primaryuser text, status text, lfdate text, createddate date, electiondate text, officetype text) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
begin
  return query
  SELECT com.committee_id as filerID, 
  		 'AC-CAN' as filerType,
		 tl.type_id as comType,
	    com.name as filerName,
	   CASE WHEN CONCAT(tc.middle_name, 'ZZZ') = 'ZZZ' THEN 
			CONCAT(tc.first_name, ' ', tc.last_name)
		ELSE 
			CONCAT(tc.first_name, ' ', tc.middle_name, ' ', tc.last_name)
		END  as primary_user,
		upper(coalesce(com.status_code, 'NEW')) as status,
		CASE WHEN tl.name = 'Candidate Committee' OR tl.name = 'Issue Committee'  THEN 
			--text(fp.due_date)
			TO_CHAR(fp.due_date::DATE, 'YYYY-mm-DD')
		ELSE
		'' END as lfDate,
		com.created_at as cDate,
		text(ec.election_date) as eDate,
		text(com.office_sought_id) as officeId
FROM public.committee com
	INNER JOIN public.contact tc ON com.treasurer_contact_id = tc.contact_id
	LEFT JOIN public.type_lookups tl ON tl.type_id = com.typeid
		and tl.lookup_type_code = 'COM'
	LEFT JOIN public.election_cycle ec ON com.election_cycle_id = ec.election_cycle_id
	LEFT JOIN public.filing_period fp ON ec.election_cycle_id = fp.election_cycle_id
-- 	LEFT JOIN public.type_lookups tlo ON tlo.type_id = com.office_sought_id
-- 		and tl.lookup_type_code = 'OFF'
--WHERE com.election_cycle_id = fp.election_cycle_id
UNION	
SELECT l.lobbysit_id as filerId, 
	   'AC-LOB' as filerType,
	   '' as comType,
	   CASE WHEN CONCAT(pc.middle_name, 'ZZZ') = 'ZZZ' THEN 
			CONCAT(pc.first_name, ' ', pc.last_name)
		ELSE 
			CONCAT(pc.first_name, ' ', pc.middle_name, ' ', pc.last_name)
		END as filerName,
		CASE WHEN l.type = 'LOB-I' THEN 
			CASE WHEN CONCAT(pc.middle_name, 'ZZZ') = 'ZZZ' THEN 
				CONCAT(pc.first_name, ' ', pc.last_name)
			ELSE 
				CONCAT(pc.first_name, ' ', pc.middle_name, ' ', pc.last_name)
			END
		ELSE
			pc.org_name
		END as primary_user,
		upper(coalesce(l.status_code, 'NEW')) as status,
		'' as lfDate,
		l.created_at as cDate,
		'' as eDate,
		'' as officeId
FROM public.lobbyist l
	LEFT JOIN public.contact pc ON l.filer_contact_id = pc.contact_id
	--LEFT JOIN public.contact fc ON l.filer_contact_id = fc.contact_id
UNION
SELECT c.contact_id as filerId,
		CASE WHEN f.entity_type = 'IE' THEN 'AC-IEF' 
		ELSE 'AC-CFE' END as filerType,
		f.entity_type as comType,
		CASE WHEN CONCAT(c.middle_name, 'ZZZ') = 'ZZZ' THEN 
			CONCAT(c.first_name, ' ', c.last_name)
		ELSE 
			CONCAT(c.first_name, ' ', c.middle_name, ' ', c.last_name)
		END as filerName,
		CASE WHEN CONCAT(pc.middle_name, 'ZZZ') = 'ZZZ' THEN 
			CONCAT(pc.first_name, ' ', pc.last_name)
		ELSE 
			CONCAT(pc.first_name, ' ', pc.middle_name, ' ', pc.last_name)
		END as primary_user,
		upper(coalesce(c.status_code, 'NEW')) as status,
		'' as lfDate,
		c.created_at as cDate,
		'' as eDate,
		'' as officeId
FROM public.contact c
	INNER JOIN public.contact_role_mapping crm ON c.contact_id = crm.contact_id  and crm.status_code='ACTIVE'
	INNER JOIN public.filer f ON crm.filer_id = f.filer_id
		AND f.entity_type IN ('IE', 'CO')
	LEFT JOIN public.user_account ua ON crm.user_id = ua.user_id
	INNER JOIN public.contact pc ON ua.contact_id = pc.contact_id;
	
 end
$BODY$;

ALTER FUNCTION public.get_managefilers()
    OWNER TO devadmin;
	----------------------------------------
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
--------------------------------------
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
-------------------------------
-- FUNCTION: public.get_rolesandtypes(integer)

-- DROP FUNCTION public.get_rolesandtypes(integer);

CREATE OR REPLACE FUNCTION public.get_rolesandtypes(
	_userid integer)
    RETURNS TABLE(roleid integer, role character varying, entityid integer, entitytype character varying, entityname character varying) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
begin
  return query
  select  
		r.id,
		r.role,
		f.entity_id,
		f.entity_type,
		CASE 
		WHEN (f.entity_id = cm.committee_id AND f.entity_type = 'C') THEN cm.name 
		WHEN (f.entity_id = lb.lobbysit_id AND f.entity_type = 'L') THEN concat(c.first_name,' ',c.last_name) END AS usertypename
		from public.contact c 
LEFT JOIN public.user_account ua ON c.contact_id = ua.contact_id
LEFT JOIN public.contact_role_mapping crm ON c.contact_id = crm.contact_id
LEFT JOIN public.role r ON crm.role_type_id = r.id 
LEFT JOIN public.filer f ON crm.filer_id = f.filer_id
LEFT JOIN public.committee cm ON cm.committee_id = f.entity_id 
LEFT JOIN public.lobbyist lb ON lb.lobbysit_id = f.entity_id 
WHERE c.contact_id = _userid
	AND upper(coalesce(c.status_code,'ACTIVE')) = 'ACTIVE'
	 and crm.status_code='ACTIVE';
 end
$BODY$;

ALTER FUNCTION public.get_rolesandtypes(integer)
    OWNER TO devadmin;
-------------------------------------------
-- FUNCTION: public.get_userentities(integer)

-- DROP FUNCTION public.get_userentities(integer);

CREATE OR REPLACE FUNCTION public.get_userentities(
	userid integer)
    RETURNS TABLE(contactid integer, entityname text, entitytype character varying) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
begin
  return query
  SELECT l.lobbysit_id, CASE WHEN CONCAT(c.middle_name, 'ZZZ') = 'ZZZ' THEN 
					CONCAT(c.first_name, ' ', c.last_name) 
				  ELSE
				  	CONCAT(c.first_name, ' ', c.middle_name, ' ', c.last_name)
				  END as entity_Name, f.entity_type
	FROM public.contact_role_mapping crm
	 INNER JOIN public.filer f ON crm.filer_id = f.filer_id
	 INNER JOIN public.lobbyist l ON l.lobbysit_id = f.entity_id
	 INNER JOIN public.contact c ON c.contact_id = l.filer_contact_id
	WHERE crm.user_id = userId
		AND f.entity_type = 'L'
		AND coalesce(lower(l.status_code), 'active') = 'active'
		 and crm.status_code='ACTIVE'
	UNION
	SELECT com.committee_id, com.name as entity_Name, f.entity_type
	FROM public.contact_role_mapping crm
	 INNER JOIN public.filer f ON crm.filer_id = f.filer_id
	 INNER JOIN public.committee com ON com.committee_id = f.entity_id
	 INNER JOIN public.contact c ON c.contact_id = crm.contact_id
	WHERE crm.user_id = userId
		AND f.entity_type = 'C'
		AND coalesce(lower(com.status_code), 'active') = 'active'
		 and crm.status_code='ACTIVE'
	UNION
	SELECT c.contact_id, CASE WHEN CONCAT(c.middle_name, 'ZZZ') = 'ZZZ' THEN 
					CONCAT(c.first_name, ' ', c.last_name) 
				  ELSE
				  	CONCAT(c.first_name, ' ', c.middle_name, ' ', c.last_name)
				  END as entity_Name, f.entity_type
	FROM public.contact_role_mapping crm
	 INNER JOIN public.filer f ON crm.filer_id = f.filer_id
	 INNER JOIN public.contact c ON c.contact_id = crm.contact_id
	WHERE crm.user_id = userId
		AND f.entity_type = 'IE'
		AND coalesce(lower(c.status_code), 'active') = 'active'
		 and crm.status_code='ACTIVE'
	UNION 
	SELECT c.contact_id, CASE WHEN CONCAT(c.middle_name, 'ZZZ') = 'ZZZ' THEN 
					CONCAT(c.first_name, ' ', c.last_name) 
				  ELSE
				  	CONCAT(c.first_name, ' ', c.middle_name, ' ', c.last_name)
				  END as entity_Name, f.entity_type
	FROM public.contact_role_mapping crm
	 INNER JOIN public.filer f ON crm.filer_id = f.filer_id
	 INNER JOIN public.contact c ON c.contact_id = crm.contact_id
	WHERE crm.user_id = userId
		AND f.entity_type = 'CO'
		AND coalesce(lower(c.status_code), 'active') = 'active'
		 and crm.status_code='ACTIVE';
		
 end
$BODY$;

ALTER FUNCTION public.get_userentities(integer)
    OWNER TO devadmin;
---------------------

-- FUNCTION: public.get_userentitydetail(integer, character varying)

-- DROP FUNCTION public.get_userentitydetail(integer, character varying);

CREATE OR REPLACE FUNCTION public.get_userentitydetail(
	_entityid integer,
	_entitytype character varying)
    RETURNS TABLE(contactid integer, entityname text, entitytype text, orgname text, primaryname text, candidatename text, treasurername text, electiondate text, publicfund text, ballotissue text, positiondesc text, purposedesc text, occupationdesc text) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
begin
	if _entitytype = 'AC-LOB' then
	  return query
		SELECT  l.lobbysit_id AS entity_Id,
			CASE WHEN CONCAT(c.middle_name, 'ZZZ') = 'ZZZ' THEN 
				CONCAT(c.first_name, ' ', c.last_name) 
			ELSE
				CONCAT(c.first_name, ' ', c.middle_name, ' ', c.last_name)
			END as entity_Name,
			text(pc.contact_type) as entity_Type,
			text(pc.org_name),
			CASE WHEN CONCAT(pc.middle_name, 'ZZZ') = 'ZZZ' THEN 
				CONCAT(pc.first_name, ' ', pc.last_name) 
			ELSE
				CONCAT(pc.first_name, ' ', pc.middle_name, ' ', pc.last_name)
			END as primary_name,
			'' as candidate_name,
			'' as treasurer_name,
			'' as election_date,
			'' as public_fund,
			'' as ballot_issue,
			'' as position,
			'' as purpose,
			'' as occupation
		FROM public.lobbyist l 
			LEFT JOIN public.contact c ON l.primary_contact_id = c.contact_id
			INNER JOIN public.contact pc ON l.filer_contact_id = pc.contact_id
		WHERE l.lobbysit_id = _entityid;
	elsif _entitytype = 'AC-CAN' OR  _entitytype = 'AC-TST' then
		return query
		SELECT com.committee_id as entity_Id, 
				text(com.name) as entity_Name, 
				text(com.typeid) as entity_Type, 
				'' as org_name,
				'' as primary_name,
				CASE WHEN CONCAT(cc.middle_name, 'ZZZ') = 'ZZZ' THEN 
					CONCAT(cc.first_name, ' ', cc.last_name) 
				ELSE
					CONCAT(cc.first_name, ' ', cc.middle_name, ' ', cc.last_name)
				END as candidate_name,
				CASE WHEN CONCAT(tc.middle_name, 'ZZZ') = 'ZZZ' THEN 
					CONCAT(tc.first_name, ' ', tc.last_name) 
				ELSE
					CONCAT(tc.first_name, ' ', tc.middle_name, ' ', tc.last_name)
				END as treasurer_name,
				text(ec.election_date),
				'Active' as public_fund,
				text(bi.ballot_issue),
				text(com.position),
				text(com.purpose),
				'' as occupation
		FROM public.committee com
			INNER JOIN public.contact c ON c.contact_id = com.committee_contact_id
			LEFT JOIN public.contact cc ON com.candidate_contact_id = cc.contact_id
			LEFT JOIN public.contact tc ON com.treasurer_contact_id = tc.contact_id
			LEFT JOIN public.election_cycle ec ON com.election_cycle_id = ec.election_cycle_id
			LEFT JOIN public.ballot_issue bi ON com.ballot_issue_id = bi.ballot_issue_id
		WHERE com.committee_id = _entityid;
	else
		return query
		SELECT c.contact_id as entity_Id, 
		      '' as entity_Name, 
			   text(c.contact_type) as entity_Type,
			   text(c.org_name),
			   '' as primary_name,
			   '' as candidate_name,
				'' as treasurer_name,
			   '' as election_date,
			   '' as public_fund,
			   '' as ballot_issue,
			   '' as position,
			   '' as purpose,
			   text(c.occupation) as occupation
		FROM public.contact_role_mapping crm
			 INNER JOIN public.filer f ON crm.filer_id = f.filer_id
			 INNER JOIN public.contact c ON c.contact_id = crm.contact_id
		WHERE c.contact_id = _entityid  and crm.status_code='ACTIVE';
	end if;
 end
$BODY$;

ALTER FUNCTION public.get_userentitydetail(integer, character varying)
    OWNER TO devadmin;
--------------------------------------
-- FUNCTION: public.getlobbyistemployee(integer)

-- DROP FUNCTION public.getlobbyistemployee(integer);

CREATE OR REPLACE FUNCTION public.getlobbyistemployee(
	_lobbyistid integer)
    RETURNS TABLE(contactid integer, employeename text) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
DECLARE roleTypeId int = 0;
DECLARE primaryUserId int = 0;
DECLARE lobbyistType character varying;
DECLARE fillerId int = 0;
begin
	SELECT id INTO roleTypeId
	  FROM public.role 
	WHERE role = 'Lobbyist Employee';
	
	SELECT primary_contact_id, type, filer_contact_id INTO primaryUserId, lobbyistType, fillerId
  		FROM public.lobbyist 
  	WHERE lobbysit_id = _lobbyistid;

	if lobbyistType = 'LOB-O' then
	begin
		return query
			SELECT c.contact_id,
				CASE WHEN CONCAT(c.middle_name, 'ZZZ') = 'ZZZ' THEN c.first_name || ' ' || c.last_name
					ELSE  c.first_name || ' ' || c.middle_name || ' ' || c.last_name
				END as fullName
			FROM public.contact_role_mapping crm
			INNER JOIN public.contact c  ON crm.contact_id = c.contact_id
			INNER JOIN public.lobbyist l ON c.contact_id = l.filer_contact_id
				WHERE crm.role_type_id = roleTypeId
					AND crm.filer_id = fillerId
					AND lower(coalesce(c.status_code, 'active')) = 'active'
					 and crm.status_code='ACTIVE'
			UNION
			 SELECT c.contact_id,
				CASE WHEN CONCAT(c.middle_name, 'ZZZ') = 'ZZZ' THEN c.first_name || ' ' || c.last_name
					ELSE  c.first_name || ' ' || c.middle_name || ' ' || c.last_name
				END as fullName
			 FROM public.contact c 
			INNER JOIN public.lobbyist l ON c.contact_id = l.filer_contact_id
			 WHERE c.contact_id = fillerId
			 	AND lower(coalesce(c.status_code, 'active')) = 'active';
		end;
		else
		begin
			return query
			SELECT c.contact_id,
				CASE WHEN CONCAT(c.middle_name, 'ZZZ') = 'ZZZ' THEN c.first_name || ' ' || c.last_name
					ELSE  c.first_name || ' ' || c.middle_name || ' ' || c.last_name
				END as fullName
			 FROM public.contact c 
			 INNER JOIN public.lobbyist l ON c.contact_id = l.filer_contact_id
			 	WHERE c.contact_id = fillerId
			 		AND lower(coalesce(c.status_code, 'active')) = 'active';
		end;
		end if;
end
$BODY$;

ALTER FUNCTION public.getlobbyistemployee(integer)
    OWNER TO devadmin;
