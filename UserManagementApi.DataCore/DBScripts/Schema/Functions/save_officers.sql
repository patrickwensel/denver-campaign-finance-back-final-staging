-- FUNCTION: public.save_officers(integer, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying)

-- DROP FUNCTION public.save_officers(integer, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying);

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

ALTER FUNCTION public.save_officers(integer, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying)
    OWNER TO devadmin;
