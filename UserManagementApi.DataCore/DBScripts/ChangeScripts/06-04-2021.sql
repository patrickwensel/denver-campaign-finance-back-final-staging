----------------------------------------Functions------------------------------------------

DROP FUNCTION public.save_subcontractors(integer, integer, character varying, character varying, character varying, character varying, character varying, character varying, character varying);

CREATE OR REPLACE FUNCTION public.save_subcontractors(
	lobbyistentityid integer,
	contactid integer,
	typeid character varying,
	fname character varying,
	mname character varying,
	lname character varying,
	phoneno character varying,
	emailid character varying,
	userid character varying)
    RETURNS integer
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
DECLARE newContactId integer = 0;
DECLARE filerId integer = 0;
DECLARE lUserId integer = 0;
DECLARE roleTypeId integer = 0;
begin
	-- Get the filerId from lobbyist table 
	SELECT filer_contact_id, primary_contact_id INTO filerId, lUserId 
	FROM public.lobbyist 
		WHERE lobbysit_id = lobbyistentityid;

	-- Get the roleTypeId from role table
	SELECT id INTO roleTypeId FROM public.role WHERE role = 'Lobbyist Subcontractor';
		
	if contactId = 0 then
	begin
		-- 	Insert into contact table
		INSERT INTO public.contact(
			contact_id, contact_type, first_name, 
			middle_name, last_name, org_name, 
			address1, address2, city, 
			state_code, country_code, zip, 
			email, phone, occupation, 
			voter_id, description, filerid, 
			status_code, created_by, created_at, 
			updated_by, updated_on)
		VALUES (nextval('contact_contact_id_seq'), typeId, fname, 
				mname, lname, null, 
				null, null, null, 
				null, null, null, 
				emailId, phoneNo, null, 
				null, null, null, 
				'ACTIVE', lUserId, localtimestamp, 
				lUserId, localtimestamp);

		-- Get the current value from contact table
		SELECT currval('contact_contact_id_seq') INTO newContactId;
		
		-- Insert into contact_role_mapping table
		INSERT INTO public.contact_role_mapping(
			contact_role_mapping_id, user_id, contact_id, 
			filer_id, role_type_id, created_by, 
			created_at, updated_by, updated_on)
		VALUES (nextval('contact_role_mapping_contact_role_mapping_id_seq'), null, newContactId, 
				filerId, roleTypeId, lUserId, 
				localtimestamp, lUserId, localtimestamp);
	end;
	else
	begin
		UPDATE public.contact
			SET contact_type = typeId,
				first_name = fname,
				middle_name = mname,
				last_name = lname,
				email = emailId,
				phone = phoneNo,
				updated_by = lUserId, 
				updated_on = localtimestamp
		WHERE contact_id = contactId;
	end;
	end if;
	
	if contactId = 0 then
		contactId := newContactId;
	end if;
	
	return contactId;

 end
$BODY$;

ALTER FUNCTION public.save_subcontractors(integer, integer, character varying, character varying, character varying, character varying, character varying, character varying, character varying)
    OWNER TO devadmin;
	
------------------------------------------------

DROP FUNCTION public.save_relationships(integer, integer, integer, integer, character varying, character varying, character varying, character varying, character varying);

CREATE OR REPLACE FUNCTION public.save_relationships(
	lobbyistentityid integer,
	contactid integer,
	lobbyistrelationshipid integer,
	employeeid integer,
	offname character varying,
	offtitle character varying,
	relationshipdesc character varying,
	entityname character varying,
	userid character varying)
    RETURNS integer
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
DECLARE newContactId integer = 0;
DECLARE filerId integer = 0;
DECLARE lUserId integer = 0;
DECLARE roleTypeId integer = 0;
begin
	-- Get the filerId from lobbyist table 
	SELECT filer_contact_id, primary_contact_id INTO filerId, lUserId 
	FROM public.lobbyist 
		WHERE lobbysit_id = lobbyistentityid;

	-- Get the roleTypeId from role table
	SELECT id INTO roleTypeId FROM public.role WHERE role = 'Lobbyist Relationship';
		
	if contactid = 0 then
	begin
		-- 	Insert into contact table
		INSERT INTO public.contact(
			contact_id, contact_type, first_name, 
			middle_name, last_name, org_name, 
			address1, address2, city, 
			state_code, country_code, zip, 
			email, phone, occupation, 
			voter_id, description, filerid, 
			status_code, created_by, created_at, 
			updated_by, updated_on)
		VALUES (nextval('contact_contact_id_seq'), 'I', null, 
				null, null, null, 
				null, null, null, 
				null, null, null, 
				null, null, null, 
				null, null, null, 
				'ACTIVE', lUserId, localtimestamp, 
				lUserId, localtimestamp);

		-- Get the current value from contact table
		SELECT currval('contact_contact_id_seq') INTO newContactId;
		
		-- Insert  into lobbyist_relationship table		
		INSERT INTO public.lobbyist_relationship(
				lobbyist_relationship_id, contact_id, official_name, 
				official_title, relationship, entity_name, 
				status_code, created_by, created_at, 
				updated_by, updated_on, employee_id)
		VALUES (nextval('lobbyist_relationship_id_seq'), newContactId, offName, 
				offTitle, relationshipDesc, entityName, 
				'ACTIVE', lUserId, localtimestamp, 
				lUserId, localtimestamp, employeeId);
				
		-- Insert into contact_role_mapping table
		INSERT INTO public.contact_role_mapping(
			contact_role_mapping_id, user_id, contact_id, 
			filer_id, role_type_id, created_by, 
			created_at, updated_by, updated_on)
		VALUES (nextval('contact_role_mapping_contact_role_mapping_id_seq'), null, newContactId, 
				filerId, roleTypeId, lUserId, 
				localtimestamp, lUserId, localtimestamp);
	end;
	else
	begin
	
		UPDATE public.lobbyist_relationship
			SET official_name = offName,
				official_title = offTitle,
				relationship = relationshipDesc,
				entity_name = entityName,
				updated_by = lUserId, 
 				updated_on = localtimestamp
		WHERE lobbyist_relationship_id = lobbyistRelationshipId;
		
-- 		UPDATE public.contact
-- 			SET first_name = fname,
-- 				middle_name = mname,
-- 				last_name = lname,
-- 				email = emailId,
-- 				phone = phoneNo,
-- 				updated_by = userId, 
-- 				updated_on = localtimestamp
-- 		WHERE contact_id = contactId;

	end;
	end if;
	
	if contactId = 0 then
		contactId := newContactId;
	end if;
	
	return contactId;

 end
$BODY$;

ALTER FUNCTION public.save_relationships(integer, integer, integer, integer, character varying, character varying, character varying, character varying, character varying)
    OWNER TO devadmin;
	
-------------------------------------------------------

DROP FUNCTION public.save_employees(integer, integer, character varying, character varying, character varying, character varying, character varying, character varying);

CREATE OR REPLACE FUNCTION public.save_employees(
	lobbyistentityid integer,
	contactid integer,
	fname character varying,
	mname character varying,
	lname character varying,
	phoneno character varying,
	emailid character varying,
	userid character varying)
    RETURNS integer
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
DECLARE newContactId integer = 0;
DECLARE filerId integer = 0;
DECLARE lUserId integer = 0;
DECLARE roleTypeId integer = 0;
begin

	-- Get the filerId from lobbyist table 
	SELECT filer_contact_id, primary_contact_id INTO filerId, lUserId 
	FROM public.lobbyist 
		WHERE lobbysit_id = lobbyistentityid;

	-- Get the roleTypeId from role table
	SELECT id INTO roleTypeId FROM public.role WHERE role = 'Lobbyist Employee';
		
	if contactId = 0 then
	begin
		-- 	Insert into contact table
		INSERT INTO public.contact(
			contact_id, contact_type, first_name, 
			middle_name, last_name, org_name, 
			address1, address2, city, 
			state_code, country_code, zip, 
			email, phone, occupation, 
			voter_id, description, filerid, 
			status_code, created_by, created_at, 
			updated_by, updated_on)
		VALUES (nextval('contact_contact_id_seq'), 'I', fname, 
				mname, lname, null, 
				null, null, null, 
				null, null, null, 
				emailId, phoneNo, null, 
				null, null, null, 
				'ACTIVE', lUserId, localtimestamp, 
				lUserId, localtimestamp);

		-- Get the current value from contact table
		SELECT currval('contact_contact_id_seq') INTO newContactId;

		-- Insert into contact_role_mapping table
		INSERT INTO public.contact_role_mapping(
			contact_role_mapping_id, user_id, contact_id, 
			filer_id, role_type_id, created_by, 
			created_at, updated_by, updated_on)
		VALUES (nextval('contact_role_mapping_contact_role_mapping_id_seq'), null, newContactId, 
				filerId, roleTypeId, lUserId, 
				localtimestamp, lUserId, localtimestamp);
	end;
	else
	begin
		UPDATE public.contact
			SET first_name = fname,
				middle_name = mname,
				last_name = lname,
				email = emailId,
				phone = phoneNo,
				updated_by = lUserId, 
				updated_on = localtimestamp
		WHERE contact_id = contactId;
	end;
	end if;

	if contactId = 0 then
		contactId := newContactId;
	end if;
	
	return contactId;
 end
$BODY$;

ALTER FUNCTION public.save_employees(integer, integer, character varying, character varying, character varying, character varying, character varying, character varying)
    OWNER TO devadmin;
	
--------------------------------------------------

DROP FUNCTION public.save_clients(integer, integer, integer, character varying, integer, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying);

CREATE OR REPLACE FUNCTION public.save_clients(
	lobbyistentityid integer,
	contactid integer,
	lobbyistclientid integer,
	comname character varying,
	employeeid integer,
	nbusiness character varying,
	lmatters character varying,
	addr1 character varying,
	addr2 character varying,
	cityname character varying,
	statecode character varying,
	zipcode character varying,
	userid character varying)
    RETURNS integer
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
DECLARE newContactId integer = 0;
DECLARE filerId integer = 0;
DECLARE lUserId integer = 0;
DECLARE roleTypeId integer = 0;
begin

	-- Get the filerId from lobbyist table 
	SELECT filer_contact_id, primary_contact_id INTO filerId, lUserId 
	FROM public.lobbyist 
		WHERE lobbysit_id = lobbyistentityid;

	-- Get the roleTypeId from role table
	SELECT id INTO roleTypeId FROM public.role WHERE role = 'Lobbyist Client';
		
	if contactid = 0 then
	begin
		-- 	Insert into contact table
		INSERT INTO public.contact(
			contact_id, contact_type, first_name, 
			middle_name, last_name, org_name, 
			address1, address2, city, 
			state_code, country_code, zip, 
			email, phone, occupation, 
			voter_id, description, filerid, 
			status_code, created_by, created_at, 
			updated_by, updated_on)
		VALUES (nextval('contact_contact_id_seq'), 'I', null, 
				null, null, comName, 
				addr1, addr2, cityName, 
				stateCode, null, zipCode, 
				null, null, null, 
				null, null, null, 
				'ACTIVE', lUserId, localtimestamp, 
				lUserId, localtimestamp);

		-- Get the current value from contact table
		SELECT currval('contact_contact_id_seq') INTO newContactId;
		
		-- Insert  into lobbyist_client table		
		INSERT INTO public.lobbyist_client(
			lobbyist_client_id, contact_id, employee_id, 
			client_id, nature_of_business, legislative_matters, 
			status_code, created_by, created_at, 
			updated_by, updated_on)
		VALUES (nextval('lobbyist_client_id_seq'), newContactId, employeeid, 
				null, nBusiness, lMatters, 
				'ACTIVE', lUserId, localtimestamp, 
				lUserId, localtimestamp);
				
		-- Insert into contact_role_mapping table
		INSERT INTO public.contact_role_mapping(
			contact_role_mapping_id, user_id, contact_id, 
			filer_id, role_type_id, created_by, 
			created_at, updated_by, updated_on)
		VALUES (nextval('contact_role_mapping_contact_role_mapping_id_seq'), null, newContactId, 
				filerId, roleTypeId, lUserId, 
				localtimestamp, lUserId, localtimestamp);
	end;
	else
	begin
		UPDATE public.lobbyist_client
			SET nature_of_business = nBusiness,
				legislative_matters = lMatters,
				employee_id = employeeId,
				updated_by = lUserId, 
				updated_on = localtimestamp
		WHERE lobbyist_client_id = lobbyistclientid;
		
		UPDATE public.contact
			SET org_name = comName,
				address1 = addr1, 
				address2 = addr2, 
				city = cityName, 
				state_code = stateCode, 
				zip = zipCode,
				updated_by = lUserId, 
				updated_on = localtimestamp
		WHERE contact_id = contactId;
	end;
	end if;
	
	if contactId = 0 then
		contactId := newContactId;
	end if;
	
	return contactId;

 end
$BODY$;

ALTER FUNCTION public.save_clients(integer, integer, integer, character varying, integer, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying)
    OWNER TO devadmin;
	
-----------------------------------------


DROP FUNCTION public.delete_subcontractor(integer, character varying);

CREATE OR REPLACE FUNCTION public.delete_subcontractor(
	contactid integer,
	userid character varying)
    RETURNS integer
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
begin
	UPDATE public.contact
		SET status_code = 'DELETED',
			--updated_by = userId, 
			updated_on = localtimestamp
	WHERE contact_id = contactId;
	
	return contactId;
	
 end
$BODY$;

ALTER FUNCTION public.delete_subcontractor(integer, character varying)
    OWNER TO devadmin;
	
----------------------------------------------

DROP FUNCTION public.delete_relationship(integer, character varying);

CREATE OR REPLACE FUNCTION public.delete_relationship(
	contactid integer,
	userid character varying)
    RETURNS integer
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
begin
	UPDATE public.contact
		SET status_code = 'DELETED',
			updated_by = userId, 
			updated_on = localtimestamp
	WHERE contact_id = contactId;
	
	UPDATE public.lobbyist_relationship
		SET status_code = 'DELETED',
			updated_by = userId, 
			updated_on = localtimestamp
	WHERE contact_id = contactId;
	
	return contactId;
 end
$BODY$;

ALTER FUNCTION public.delete_relationship(integer, character varying)
    OWNER TO devadmin;
	
----------------------------------------------------

DROP FUNCTION public.delete_employee(integer, character varying);

CREATE OR REPLACE FUNCTION public.delete_employee(
	contactid integer,
	userid character varying)
    RETURNS integer
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
begin
	
	UPDATE public.contact
		SET status_code = 'DELETED',
			--updated_by = userId, 
			updated_on = localtimestamp
	WHERE contact_id = contactId;
	
	return contactId;
 end
$BODY$;

ALTER FUNCTION public.delete_employee(integer, character varying)
    OWNER TO devadmin;
	
---------------------------

DROP FUNCTION public.delete_client(integer, character varying);

CREATE OR REPLACE FUNCTION public.delete_client(
	contactid integer,
	userid character varying)
    RETURNS integer
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
begin
	UPDATE public.contact
		SET status_code = 'DELETED',
			updated_by = userId, 
			updated_on = localtimestamp
	WHERE contact_id = contactId;
	
	UPDATE public.lobbyist_client
		SET status_code = 'DELETED',
			updated_by = userId, 
			updated_on = localtimestamp
	WHERE contact_id = contactId;
	
	return contactId;

 end
$BODY$;

ALTER FUNCTION public.delete_client(integer, character varying)
    OWNER TO devadmin;
	
DROP FUNCTION public.get_lobbyistentities(integer, character varying);

CREATE OR REPLACE FUNCTION public.get_lobbyistentities(
	lobbyistentityid integer,
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
				AND crm.role_type_id = roleTypeId
				AND crm.filer_id = filerId4
				AND lr.status_code = 'ACTIVE';
	end if;
 end
$BODY$;

ALTER FUNCTION public.get_lobbyistentities(integer, character varying)
    OWNER TO devadmin;

----------------------------------------Tables------------------------------------------

DROP TABLE public.lobbyist_client;

CREATE TABLE public.lobbyist_client
(
    lobbyist_client_id integer NOT NULL,
    contact_id integer,
    employee_id integer,
    client_id integer,
    nature_of_business character varying(150) COLLATE pg_catalog."default" NOT NULL,
    legislative_matters character varying(150) COLLATE pg_catalog."default" NOT NULL,
    status_code character varying(10) COLLATE pg_catalog."default",
    created_by character varying(20) COLLATE pg_catalog."default",
    created_at date,
    updated_by character varying(20) COLLATE pg_catalog."default",
    updated_on date,
    CONSTRAINT lobbyist_client_pkey PRIMARY KEY (lobbyist_client_id)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.lobbyist_client
    OWNER to devadmin;
	
ALTER TABLE lobbyist_relationship 
ALTER COLUMN created_by TYPE character varying(20),
ALTER COLUMN updated_by TYPE character varying(20);

----------------------------------------Tables------------------------------------------