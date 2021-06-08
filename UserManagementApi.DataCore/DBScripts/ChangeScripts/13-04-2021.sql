----------------------------Tables------------------------------------------------


CREATE TABLE public.type_lookups
(
    lookup_type_code character varying(15)  NOT NULL,
    type_id character varying(100) COLLATE pg_catalog."default" NOT NULL,
    name character varying(100) COLLATE pg_catalog."default" NOT NULL,
    "desc" character varying(150) COLLATE pg_catalog."default",
    "Order" integer DEFAULT 0,
    status_code character varying(20) COLLATE pg_catalog."default" ,
    CONSTRAINT type_lookups_pkey PRIMARY KEY (lookup_type_code, type_id)
)

----------------------------Tables------------------------------------------------

------------------------Functions-----------------------------------------------------
-- FUNCTION: public.get_userdetail(character varying)

-- DROP FUNCTION public.get_userdetail(character varying);

CREATE OR REPLACE FUNCTION public.get_userdetail(
	useremailid character varying)
    RETURNS TABLE(userid integer,contactid integer, emailid character varying, pwd character varying, saltkey character varying) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
begin
  return query
        select      
		ua.user_id,
		ua.contact_id, 
		c.email,
		ua.password,
		ua.salt
		from public.contact c 
		INNER JOIN public.user_account ua ON c.contact_id = ua.contact_id
 		WHERE email = userEmailId;

		IF EXISTS (SELECT email FROM public.contact where email=userEmailId) THEN
  		 insert into public.sessionuser (emailid,userid) values(userEmailId,userEmailId);
 	 	END IF;		
 end
$BODY$;

ALTER FUNCTION public.get_userdetail(character varying)
    OWNER TO devadmin;

-- FUNCTION: public.getlobbyistemployee(integer)

-- DROP FUNCTION public.getlobbyistemployee(integer);

CREATE OR REPLACE FUNCTION public.getlobbyistemployee(
	_lobbyistid integer)
    RETURNS TABLE(contactid integer, employeetype character varying, employeename text) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
DECLARE empRoleTypeId int = 0;
DECLARE primaryRoleTypeId int = 0;
DECLARE fillerId int = 0;
begin
SELECT id into empRoleTypeId FROM public.role WHERE role = 'Lobbyist Employee';
SELECT id into primaryRoleTypeId FROM public.role WHERE role = 'Primary Registering Lobbyist';
SELECT filer_id into fillerId 
FROM public.filer 
WHERE entity_id = _lobbyistid
AND entity_type = 'L';
return query
--  Lobbyist	Employee	& Primary Lpbbyist
 
SELECT c.contact_id,
rl.role as entity_type,
concat(c.first_name, ' ', c.last_name)  as name
FROM contact_role_mapping crm
INNER JOIN contact c  ON c.contact_id = crm.contact_id
INNER JOIN role rl on  rl.id = crm.role_type_id
WHERE crm.role_type_id = empRoleTypeId or  crm.role_type_id = primaryRoleTypeId
AND crm.filer_id = fillerId 
AND c.status_code = 'ACTIVE';
		

end
$BODY$;

ALTER FUNCTION public.getlobbyistemployee(integer)
    OWNER TO devadmin;




-------------------------------------------------------------------------------------

-- FUNCTION: public.delete_committetypename(character varying, character varying)

-- DROP FUNCTION public.delete_committetypename(character varying, character varying);

CREATE OR REPLACE FUNCTION public.delete_committetypename(
	_typeid character varying,
	_typecode character varying)
    RETURNS integer
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
begin
 update  public.type_lookups set status_code='DELETED'
 where type_id = _typeid and _typecode='COM';
return 1;
end
$BODY$;

ALTER FUNCTION public.delete_committetypename(character varying, character varying)
    OWNER TO devadmin;

------------------------Functions-----------------------------------------------------


CREATE OR REPLACE FUNCTION public.save_committetypes(
	_typename character varying,
	_typeid character varying)
    RETURNS integer
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
DECLARE id int = 0;
begin
IF EXISTS (SELECT type_id FROM public.type_lookups where type_id=_typeid) THEN

update public.type_lookups set "name" = _typename
where type_id=_typeid; 

ELSE
 INSERT INTO public.type_lookups(lookup_type_code, type_id, "name", "desc", "Order", status_code)
 values('COM', _typeid, _typename, '', 1, 'ACTIVE');
  --return (SELECT LASTVAL());
  END IF;
 return 1;
end
$BODY$;




------------------------Functions-----------------------------------------------------
-- FUNCTION: public.get_committeetypedetails()

-- DROP FUNCTION public.get_committeetypedetails();

CREATE OR REPLACE FUNCTION public.get_committeetypedetails(
	)
    RETURNS TABLE(lookuptypecode character varying, typeid character varying, typename character varying, typedesc character varying, typeorder integer) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
begin
  return query
 select tlup.lookup_type_code,tlup.type_id, tlup."name", tlup."desc", tlup."Order"
 from public.type_lookups tlup 
 where tlup.lookup_type_code= 'COM' and tlup.status_code='ACTIVE';
 end
$BODY$;

ALTER FUNCTION public.get_committeetypedetails()
    OWNER TO devadmin;


------------------------Functions-----------------------------------------------------

-- FUNCTION: public.save_officesdetails(character varying, character varying)

-- DROP FUNCTION public.save_officesdetails(character varying, character varying);

CREATE OR REPLACE FUNCTION public.save_officesdetails(
	_typename character varying,
	_typeid character varying)
    RETURNS integer
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
DECLARE id int = 0;
begin
IF EXISTS (SELECT type_id FROM public.type_lookups where type_id=_typeid) THEN

update public.type_lookups set "name" = _typename
where type_id=_typeid; 

ELSE

INSERT INTO public.type_lookups(lookup_type_code, type_id, "name", "desc", "Order", status_code)
values('OFF', _typeid, _typename, '', 1, 'ACTIVE');

END IF;
 
  --return (SELECT LASTVAL());
 return 1;
end
$BODY$;

ALTER FUNCTION public.save_officesdetails(character varying, character varying)
    OWNER TO devadmin;

------------------------Functions-----------------------------------------------------

-- FUNCTION: public.get_officelistdetails()

-- DROP FUNCTION public.get_officelistdetails();

CREATE OR REPLACE FUNCTION public.get_officelistdetails(
	)
    RETURNS TABLE(lookuptypecode character varying, typeid character varying, typename character varying, typedesc character varying, typeorder integer) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
begin
  return query
 select tlup.lookup_type_code,tlup.type_id, tlup."name", tlup."desc", tlup."Order"
 from public.type_lookups tlup 
 where tlup.lookup_type_code= 'OFF'and tlup.status_code='ACTIVE';
 end
$BODY$;

ALTER FUNCTION public.get_officelistdetails()
    OWNER TO devadmin;

------------------------Functions-----------------------------------------------------
-- FUNCTION: public.delete_offices(character varying, character varying)

-- DROP FUNCTION public.delete_offices(character varying, character varying);

CREATE OR REPLACE FUNCTION public.delete_offices(
	_typeid character varying,
	_typecode character varying)
    RETURNS integer
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
begin
 update  public.type_lookups set status_code='DELETED'
 where type_id = _typeid and _typecode='OFF';
return 1;
end
$BODY$;
 
ALTER FUNCTION public.delete_offices(character varying, character varying)
    OWNER TO devadmin;

------------------------Functions-----------------------------------------------------

