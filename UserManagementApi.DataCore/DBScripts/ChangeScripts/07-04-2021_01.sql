
----------------------------------------Functions-------------------------------------------


-- DROP FUNCTION public.update_IEAddlInfo(integer, character varying, character varying, character varying, character varying, character varying);

CREATE OR REPLACE FUNCTION public.update_IEAddlInfo(
	contactId integer,
	filerType character varying,
	occupationDesc character varying,
	employer character varying,
	organisationName character varying,
	userId character varying)
    RETURNS integer
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
begin
	if filerType = 'I' then
		UPDATE public.contact
			SET contact_type = filerType,
				org_name = employer,
				occupation = occupationDesc
		WHERE contact_id = contactId;
	else
		UPDATE public.contact
			SET contact_type = filerType,
				org_name = organisationName,
				occupation = null
		WHERE contact_id = contactId;
	end if;
 
  return contactId;

end
$BODY$;

ALTER FUNCTION public.update_IEAddlInfo(integer, character varying, character varying, character varying, character varying, character varying)
    OWNER TO devadmin;

	--------------------------------------------------
-- FUNCTION: public.get_rolesandtypes(character varying)

-- DROP FUNCTION public.get_rolesandtypes(character varying);

CREATE OR REPLACE FUNCTION public.get_rolesandtypes(
	useremailid character varying)
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
		WHEN (f.entity_id = cm.committee_id AND f.entity_type = 'COMMITTEE') THEN cm.name 
		WHEN (f.entity_id = c.contact_id AND f.entity_type = 'LOBBYIST"') THEN c.first_name END AS usertypename
		from public.contact c 
LEFT JOIN public.user_account ua ON c.contact_id = ua.contact_id
LEFT JOIN public.contact_role_mapping crm ON c.contact_id = crm.contact_id
LEFT JOIN public.role r ON crm.role_type_id = r.id 
LEFT JOIN public.filer f ON crm.filer_id = f.filer_id
LEFT JOIN public.committee cm ON cm.committee_id = f.entity_id WHERE c.email = userEmailId;
		IF EXISTS (SELECT email FROM public.contact where email=userEmailId) THEN
  		 insert into public.sessionuser (emailid,userid) values(userEmailId,userEmailId);
 	 	END IF;
		
 end
$BODY$;

ALTER FUNCTION public.get_rolesandtypes(character varying)
    OWNER TO devadmin;

----------------------------------------
-- FUNCTION: public.get_userdetail(character varying)

-- DROP FUNCTION public.get_userdetail(character varying);

CREATE OR REPLACE FUNCTION public.get_userdetail(
	useremailid character varying)
    RETURNS TABLE(userid integer, emailid character varying, usertype character varying, typeid integer, pwd character varying, saltkey character varying) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
begin
  return query
  select c.contact_id, 
		c.email, 
		r.role,
		r.id,
		ua.password,
		ua.salt
		from public.contact c 
LEFT JOIN public.user_account ua ON c.contact_id = ua.contact_id
LEFT JOIN public.contact_role_mapping crm ON c.contact_id = crm.contact_id
LEFT JOIN public.role r ON crm.role_type_id = r.id WHERE email = userEmailId;
		IF EXISTS (SELECT email FROM public.contact where email=userEmailId) THEN
  		 insert into public.sessionuser (emailid,userid) values(userEmailId,userEmailId);
 	 	END IF;
		
 end
$BODY$;

ALTER FUNCTION public.get_userdetail(character varying)
    OWNER TO devadmin;


	---------------------------------------

	-- FUNCTION: public.save_useraccount(character varying, integer, character varying, character varying)

-- DROP FUNCTION public.save_useraccount(character varying, integer, character varying, character varying);

CREATE OR REPLACE FUNCTION public.save_useraccount(
	_password character varying,
	_contactid integer,
	_status character varying,
	_salt character varying)
    RETURNS integer
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
DECLARE id int = 0;
begin
 insert into public."user_account" ("contact_id", "password", "status", "salt", "created_by", "created_at", "updated_by", "updated_on")
 values(_contactid, _password, _status, _salt, 'Denver', localtimestamp, 'Denver', localtimestamp);
  return (SELECT LASTVAL());
-- inserted fail retuns 0

end
$BODY$;

ALTER FUNCTION public.save_useraccount(character varying, integer, character varying, character varying)
    OWNER TO devadmin;

----------------------------------------Functions-------------------------------------------
ALTER TABLE public.user_account ADD Salt character varying(10000) NULL
