-- FUNCTION: public.save_clients(integer, integer, integer, character varying, integer, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying)

-- DROP FUNCTION public.save_clients(integer, integer, integer, character varying, integer, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying);

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
