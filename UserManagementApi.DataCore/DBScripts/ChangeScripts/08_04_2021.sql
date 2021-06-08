------------------------Functions-----------------------------------------------------

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
  and fil.entity_type= 'COMMITTEE' and off.status_code = 'Active'
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
    RETURNS TABLE(contactid integer, firstname character varying, lastname character varying, organizationname character varying, address1 character varying, address2 character varying, city character varying, state character varying, zip character varying, email character varying, phone character varying, occupation character varying, description character varying, rolename character varying) 
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

    -----------------------------------------------------

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
		WHEN (f.entity_id = cm.committee_id AND f.entity_type = 'COMMITTEE') THEN cm.name 
		WHEN (f.entity_id = c.contact_id AND f.entity_type = 'LOBBYIST"') THEN c.first_name END AS usertypename
		from public.contact c 
LEFT JOIN public.user_account ua ON c.contact_id = ua.contact_id
LEFT JOIN public.contact_role_mapping crm ON c.contact_id = crm.contact_id
LEFT JOIN public.role r ON crm.role_type_id = r.id 
LEFT JOIN public.filer f ON crm.filer_id = f.filer_id
LEFT JOIN public.committee cm ON cm.committee_id = f.entity_id WHERE c.contact_id = _userid;
	
 end
$BODY$;

ALTER FUNCTION public.get_rolesandtypes(integer)
    OWNER TO devadmin;

    --------------------------------------------------
    -- FUNCTION: public.get_lobbybyname(character varying)

-- DROP FUNCTION public.get_lobbybyname(character varying);

CREATE OR REPLACE FUNCTION public.get_lobbybyname(
	comname character varying)
    RETURNS TABLE(lobbyistid integer, year character varying, type character varying, firstname character varying, lastname character varying, organisationname character varying, address1 character varying, address2 character varying, city character varying, statecode character varying, zipcode character varying, phone character varying, email character varying, imageurl character varying) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
--DECLARE searchCommittee character varying(200);
begin
 
  return query
  SELECT lb.lobbysit_id,lb.year, lb.type,c.first_name, c.last_name, c.org_name ,
  c.address1,c.address2,c.city,c.state_code,c.zip,c.phone,c.email, 
lb.sign_image_url FROM public.lobbyist as lb
LEFT JOIN public.contact as c on lb.filer_contact_id = c.contact_id
		WHERE ((LOWER(c.first_name) LIKE '%' || '' || LOWER('a') || '' || '%'
			OR LOWER(c.last_name) LIKE '%' || '' || LOWER('a') || '' || '%')
			   AND (c.first_name !='' AND c.first_name IS NOT NULL))
		   ORDER BY c.first_name;
 end
$BODY$;

ALTER FUNCTION public.get_lobbybyname(character varying)
    OWNER TO devadmin;

    -------------------------------------------

    CREATE OR REPLACE FUNCTION public.save_contactrolemappingtreasuree(
	_contactid integer,
	_filerid integer,
	_roletypeid integer)
    RETURNS integer
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
DECLARE id integer;
begin
SELECT user_id INTO id FROM public.user_account where contact_id = _contactid;
insert into public."contact_role_mapping" ("user_id", "contact_id", "filer_id", "role_type_id", "created_by", "created_at", "updated_by", "updated_on")
 values(id, _contactid, _filerid, _roletypeid, 'Denver', localtimestamp, 'Denver', localtimestamp);
  return (SELECT LASTVAL());
-- inserted fail retuns 0

end
$BODY$;

ALTER FUNCTION public.save_contactrolemappingtreasuree(integer, integer, integer)
    OWNER TO devadmin;
---------------------------------------

CREATE OR REPLACE FUNCTION public.save_userjoinrequest(
	_requesttype character varying,
	_useremail character varying,
	_usercontactid integer,
	_invitercontactid integer,
	_emailmessageid integer,
	_userjoindate character varying,
	_committeeid integer)
    RETURNS integer
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
DECLARE filid integer;
begin

SELECT filer_id INTO filid FROM public.filer where entity_id = _committeeid and entity_type = 'C';
 insert into public."user_join_request" ("request_type", "filer_id", "user_email", "user_contact_id", "inviter_contact_id", "email_msg_id", "user_join_note", "created_by", "created_at", "updated_by", "updated_on")
 values(_requesttype, filid, _useremail, _usercontactid, _invitercontactid, _emailmessageid, _userjoindate, 'Denver', localtimestamp, 'Denver', localtimestamp);
  return (SELECT LASTVAL());
-- inserted fail retuns 0

end
$BODY$;

ALTER FUNCTION public.save_userjoinrequest(character varying, character varying, integer, integer, integer, character varying, integer)
    OWNER TO devadmin;

    ------------------------------------------

    CREATE OR REPLACE FUNCTION public.save_contactrolemappingofficer(
	_userid integer,
	_contactid integer,
	_roletypeid integer,
	_committeeid integer)
    RETURNS integer
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
DECLARE filid integer;
begin

SELECT filer_id INTO filid FROM public.filer where entity_id = _committeeid and entity_type = 'C';

insert into public."contact_role_mapping" ("user_id", "contact_id", "filer_id", "role_type_id", "created_by", "created_at", "updated_by", "updated_on")
 values(_userid, _contactid, filid, _roletypeid, 'Denver', localtimestamp, 'Denver', localtimestamp);
  return (SELECT LASTVAL());
-- inserted fail retuns 0

end
$BODY$;

ALTER FUNCTION public.save_contactrolemappingofficer(integer, integer, integer, integer)
    OWNER TO devadmin;
    ------------------------------------
    CREATE OR REPLACE FUNCTION public.save_userjoinrequestlob(
	_requesttype character varying,
	_useremail character varying,
	_usercontactid integer,
	_invitercontactid integer,
	_emailmessageid integer,
	_userjoindate character varying,
	_lobbyistid integer)
    RETURNS integer
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
DECLARE filid integer;
begin

SELECT filer_id INTO filid FROM public.filer where entity_id = _lobbyistid and entity_type = 'L';
 insert into public."user_join_request" ("request_type", "filer_id", "user_email", "user_contact_id", "inviter_contact_id", "email_msg_id", "user_join_note", "created_by", "created_at", "updated_by", "updated_on")
 values(_requesttype, filid, _useremail, _usercontactid, _invitercontactid, _emailmessageid, _userjoindate, 'Denver', localtimestamp, 'Denver', localtimestamp);
  return (SELECT LASTVAL());
-- inserted fail retuns 0

end
$BODY$;

ALTER FUNCTION public.save_userjoinrequestlob(character varying, character varying, integer, integer, integer, character varying, integer)
    OWNER TO devadmin;

------------------------Functions-----------------------------------------------------

ALTER TABLE public.committee ALTER COLUMN name DROP NOT NULL;
	ALTER TABLE public.lobbyist ALTER COLUMN type TYPE  character varying(10)
	ALTER TABLE public.contact ALTER COLUMN contact_type TYPE  character varying(10)