-- FUNCTION: public.save_subcontractors(integer, integer, character varying, character varying, character varying, character varying, character varying, character varying, character varying)

-- DROP FUNCTION public.save_subcontractors(integer, integer, character varying, character varying, character varying, character varying, character varying, character varying, character varying);

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
