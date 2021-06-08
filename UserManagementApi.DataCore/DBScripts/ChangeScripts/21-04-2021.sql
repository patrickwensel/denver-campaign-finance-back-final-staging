---------------------------------------Functions-------------------------------------------
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
			AND lower(coalesce(c.status_code, 'deleted')) != 'deleted';
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
			AND lower(coalesce(c.status_code, 'deleted')) != 'deleted';
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
			AND lower(coalesce(lc.status_code, 'deleted')) != 'deleted';
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
				AND lower(coalesce(lr.status_code, 'deleted')) != 'deleted';
				--AND lower(coalesce(lr.status_code, 'active')) = 'active';
	end if;
 end
$BODY$;

ALTER FUNCTION public.get_lobbyistentities(integer, character varying)
    OWNER TO devadmin;

	----------------------------------------
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
		WHERE c.contact_id = _entityid;
	end if;
 end
$BODY$;

ALTER FUNCTION public.get_userentitydetail(integer, character varying)
    OWNER TO devadmin;

	----------------------------------------
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
  where crm.filer_id = filid and LOWER(off.status_code) = 'active'
   order by off.contact_id;
 end
$BODY$;

ALTER FUNCTION public.get_officerlist(integer)
    OWNER TO devadmin;

	---------------------------------------
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

	------------------------------------------
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
  where crm.filer_id = filid and LOWER(off.status_code) = 'active'
   order by off.contact_id;
 end
$BODY$;

ALTER FUNCTION public.get_officerlist(integer)
    OWNER TO devadmin;

	----------------------------Functions------------------------------

INSERT INTO 
    public.type_lookups (lookup_type_code, type_id, "name", "desc", "Order", status_code)
VALUES
('POSITION','POS-OPP', 'Oppose', 'Oppose', 2, 'ACTIVE')

UPDATE public.type_lookups SET type_id = 'POS-SUP', "name" = 'Support', "desc" = 'Support' where type_id = 'POS'