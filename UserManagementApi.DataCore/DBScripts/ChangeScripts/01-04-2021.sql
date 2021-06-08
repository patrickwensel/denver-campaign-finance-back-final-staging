----------------------------------------Functions------------------------------------------



CREATE OR REPLACE FUNCTION public.delete_officers(
	_contactid integer)
    RETURNS integer
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
begin
	update public."contact" set 
	status_code='Delete'
 	where "contact_id" = _contactid;
 	if found then --deleted successfully
 	return 1;
 	else
  	return 0;
 	end if;
end
$BODY$;




---------------------------------------------------------------------------------------------


CREATE OR REPLACE FUNCTION public.save_officers(
	_contactid integer,
	_contacttype character varying,
	_firstname character varying,
	_lastname character varying,
	_address1 character varying,
	_address2 character varying,
	_city character varying,
	_state character varying,
	_zip character varying,
	_phone character varying,
	_email character varying,
	_desc character varying)
    RETURNS integer
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
DECLARE id int = 0;
begin

    IF (_contactid)>0 THEN 
	update public."contact" set "contact_type"= _contacttype,
	"first_name"=_firstname,
	"last_name" =_lastname,
	"address1" =_address1,
	"address2" =_address2,
	"city" = _city,
	"state_code" = _state,
	"zip"= _zip,
	"phone"= _phone,
	"email" = _email,
	"description" = _desc,
	 "updated_by" ='Denver', 
	 "updated_on" =localtimestamp
	where "contact_id" = _contactid;
	return _contactid;
    ELSE 
	insert into public."contact" ("contact_type", "first_name", "last_name", "address1", "address2", "city", "state_code", "zip" , "phone", "email", "description", "created_by", "created_at", "updated_by", "updated_on", status_code)
 values(_contacttype, _firstname, _lastname, _address1, _address2, _city, _state, _zip, _phone, _email, _desc, 'Denver', localtimestamp, 'Denver', localtimestamp, 'Active');
  return (SELECT LASTVAL());
  END IF;

  
-- inserted fail retuns 0

end
$BODY$;


-------------------------------------------------------------------------------------------


CREATE OR REPLACE FUNCTION public.get_officerlist(
	committeeid integer)
    RETURNS TABLE(contactid integer, firstname character varying, lastname character varying, description character varying, officertype character varying, filerid integer) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
begin
  return query
  select off.contact_id, 
  off.first_name,
  off.last_name,
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
  where fil.entity_id = committeeid and fil.entity_type= 'COMMITTEE' and off.status_code = 'Active'
   order by off.contact_id;
 end
$BODY$;

ALTER FUNCTION public.get_officerlist(integer)
    OWNER TO devadmin;



----------------------------------------Functions------------------------------------------