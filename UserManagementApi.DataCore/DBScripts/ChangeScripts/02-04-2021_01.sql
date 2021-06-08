----------------------------------------Functions------------------------------------------

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
  
  SELECT filer_id into filerId1 
  FROM public.filer 
  	WHERE entity_id = lobbyistEntityId
	 	AND entity_type = 'LOBBYIST';
		
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

----------------------------------------Functions------------------------------------------

---------------------------------------Tables----------------------------------------------

----------------------------------------Tables------------------------------------------
CREATE TABLE public.lobbyist_client
(
    lobbyist_client_id integer NOT NULL,
    contact_id integer,
    employee_id integer,
    client_id integer,
    nature_of_business character varying(150) COLLATE pg_catalog."default" NOT NULL,
    legislative_matters character varying(150) COLLATE pg_catalog."default" NOT NULL,
    status_code character varying(10) COLLATE pg_catalog."default",
    created_by integer,
    created_at date,
    updated_by integer,
    updated_on date,
    CONSTRAINT lobbyist_client_pkey PRIMARY KEY (lobbyist_client_id),
    CONSTRAINT client_id FOREIGN KEY (lobbyist_client_id)
        REFERENCES public.contact (contact_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT employee_id FOREIGN KEY (lobbyist_client_id)
        REFERENCES public.contact (contact_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT lobbyist_id FOREIGN KEY (lobbyist_client_id)
        REFERENCES public.lobbyist (lobbysit_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.lobbyist_client
    OWNER to devadmin;

COMMENT ON CONSTRAINT client_id ON public.lobbyist_client
    IS 'Reference Table - Contact';
COMMENT ON CONSTRAINT employee_id ON public.lobbyist_client
    IS 'Reference Table - Contact';
COMMENT ON CONSTRAINT lobbyist_id ON public.lobbyist_client
    IS 'Reference Table - Lobbyist';
	
	CREATE TABLE public.lobbyist_relationship
(
    lobbyist_relationship_id integer NOT NULL,
    contact_id integer,
    official_name character varying(150) COLLATE pg_catalog."default" NOT NULL,
    official_title character varying(100) COLLATE pg_catalog."default" NOT NULL,
    relationship character varying(100) COLLATE pg_catalog."default" NOT NULL,
    entity_name character varying(150) COLLATE pg_catalog."default" NOT NULL,
    status_code character varying(10) COLLATE pg_catalog."default",
    created_by integer,
    created_at date,
    updated_by integer,
    updated_on date,
    employee_id integer,
    CONSTRAINT lobbyist_relationship_pkey PRIMARY KEY (lobbyist_relationship_id),
    CONSTRAINT contact_id FOREIGN KEY (lobbyist_relationship_id)
        REFERENCES public.contact (contact_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.lobbyist_relationship
    OWNER to devadmin;

COMMENT ON CONSTRAINT contact_id ON public.lobbyist_relationship
    IS 'Reference Table';

----------------------------------------Tables------------------------------------------